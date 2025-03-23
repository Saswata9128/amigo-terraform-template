//region SQS Queue
  Sqs_Name = "MAP3_TF_QUEUE"

  Sqs_Delay_Seconds = 5

  Sqs_Visibility_Timeout_Seconds = 30

  Sqs_Message_Size = 2048

  Sqs_MessageRetension_Seconds = 86400

  Sqs_ReceiveWait_Seconds = 1

  Sqs_DeadLetterQueue = "MAP3_DeadLetterQueue"
//endregion


//region API
  api_description = "API Gateway for {proj}"

  api_path = "hello"

  request_params = ["name"]
//endregion
