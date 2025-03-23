#API Gateway
resource "aws_api_gateway_rest_api" "rest_api_gateway" {
  name = var.project_name
  description = var.api_description
}

resource "aws_api_gateway_integration" "rest_api_integration" {
  for_each = aws_api_gateway_resource.rest_api_gtw_resource
  rest_api_id = aws_api_gateway_rest_api.rest_api_gateway.id
  resource_id = aws_api_gateway_resource.rest_api_gtw_resource[each.key].id
  http_method = aws_api_gateway_method.any[each.key].http_method
  integration_http_method = "POST"
  # # For Lambda Integration
  # type = "AWS_PROXY"
  # uri = aws_lambda_function.lambda_function[each.key].invoke_arn
  # content_handling        = "CONVERT_TO_TEXT"
  # cache_key_parameters    = []
  # request_templates       =  {
  #   "application/json" = <<EOF
  #     {
  #       "method": "$context.httpMethod",
  #       "body" : $input.json('$'),
  #       "headers": {
  #         #foreach($param in $input.params().header.keySet())
  #         "$param": "$util.escapeJavaScript($input.params().header.get($param))" #if($foreach.hasNext),#end
  #         #end
  #       },
  #       "queryParams": {
  #         #foreach($param in $input.params().querystring.keySet())
  #         "$param": "$util.escapeJavaScript($input.params().querystring.get($param))" #if($foreach.hasNext),#end
  #         #end
  #       },
  #       "pathParams": {
  #         #foreach($param in $input.params().path.keySet())
  #         "$param": "$util.escapeJavaScript($input.params().path.get($param))" #if($foreach.hasNext),#end
  #         #end
  #       }  
  #     "stateMachineArn": "arn:aws:states:us-east-1:892083583785:stateMachine:hold_in_place"
  #     }
  #   EOF
  # }

  # # For AWS Service (State Machines) Integration
  type = "AWS"
  uri = "arn:aws:apigateway:${var.region}:states:action/StartExecution"
  content_handling        = "CONVERT_TO_TEXT"
  cache_key_parameters    = []
  request_templates       =  {
    "application/json" = <<EOF
      #set($input = $input.json('$'))
      {"input": "{\"queryStringParameters\" : $util.escapeJavaScript($input)}",
      "stateMachineArn": "arn:aws:states:${var.region}:${var.account}:stateMachine:${each.key}"
      }
    EOF
  }
  credentials = "arn:aws:iam::${var.account}:role/hold_in_place_api_${var.account}"
}

module "cors" {
  for_each = aws_api_gateway_resource.rest_api_gtw_resource
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"
  api_id = aws_api_gateway_rest_api.rest_api_gateway.id
  api_resource_id = aws_api_gateway_resource.rest_api_gtw_resource[each.key].id
}

resource "aws_api_gateway_resource" "rest_api_gtw_resource" {
  # Lambda Resources
  # for_each = aws_lambda_function.lambda_function
  # path_part = split("/", "${each.key}")[1]
  
  # StepFunction Resources
  for_each = aws_sfn_state_machine.sfn_state_machine
  path_part = split("/", "${each.key}")[0]
  rest_api_id = aws_api_gateway_rest_api.rest_api_gateway.id
  parent_id = aws_api_gateway_rest_api.rest_api_gateway.root_resource_id
  
}

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_gateway.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.rest_api_gtw_resource,
      aws_api_gateway_method.any,
      aws_api_gateway_integration.rest_api_integration
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "rest_api_gtw_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id

  rest_api_id  = aws_api_gateway_rest_api.rest_api_gateway.id
  stage_name = "beta"
}

resource "aws_api_gateway_method" "any" {
  for_each = aws_api_gateway_resource.rest_api_gtw_resource
  rest_api_id = aws_api_gateway_rest_api.rest_api_gateway.id
  resource_id = aws_api_gateway_resource.rest_api_gtw_resource[each.key].id
  http_method = "ANY"
  authorization = "NONE"
  api_key_required = true
  # request_parameters = {
  #   for param in var.tables[each.key]:
  #     "method.request.querystring.${param}"=> false
  # }

}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_gateway.id
  stage_name  = aws_api_gateway_stage.rest_api_gtw_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
  }
}

resource "aws_api_gateway_rest_api_policy" "rest_api_policy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_gateway.id
  policy = data.aws_iam_policy_document.rest_api.json

}

data "aws_iam_policy_document" "rest_api" {
  statement {
    principals {
      type = "*"
      identifiers = ["*"]
    }
    actions = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.rest_api_gateway.execution_arn}/*"]
    effect = "Allow"
 }
}

resource "aws_api_gateway_method_response" "response_200" {
  for_each = aws_api_gateway_resource.rest_api_gtw_resource
  rest_api_id = aws_api_gateway_rest_api.rest_api_gateway.id
  resource_id = aws_api_gateway_resource.rest_api_gtw_resource[each.key].id
  http_method = aws_api_gateway_method.any[each.key].http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  name = var.project_name
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name         = "${var.project_name}_plan"
  description  = var.api_description
  product_code = "MYCODE"

  api_stages {
    api_id = aws_api_gateway_rest_api.rest_api_gateway.id
    stage  = aws_api_gateway_stage.rest_api_gtw_stage.stage_name
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}

resource "aws_api_gateway_usage_plan_key" "plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}
