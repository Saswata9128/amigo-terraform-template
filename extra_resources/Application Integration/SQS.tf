##SQS DLQ resource
resource "aws_sqs_queue" "MAP3_DeadLetterQueue" { ##Resource reference names should be fixed for a paricular terraform project
  name                       = var.Sqs_DeadLetterQueue
  delay_seconds              = 0
  visibility_timeout_seconds = var.Sqs_Visibility_Timeout_Seconds
  max_message_size           = var.Sqs_Message_Size
  message_retention_seconds  = var.Sqs_MessageRetension_Seconds
  receive_wait_time_seconds  = var.Sqs_ReceiveWait_Seconds
}

#Main SQS resource
resource "aws_sqs_queue" "MAP3_TF_QUEUE" { ##Resource reference names should be fixed for a paricular terraform project
  name                       = var.Sqs_Name
  delay_seconds              = var.Sqs_Delay_Seconds
  visibility_timeout_seconds = var.Sqs_Visibility_Timeout_Seconds
  max_message_size           = var.Sqs_Message_Size
  message_retention_seconds  = var.Sqs_MessageRetension_Seconds
  receive_wait_time_seconds  = var.Sqs_ReceiveWait_Seconds
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.MAP3_DeadLetterQueue.arn ##associating deadletter Queue with main queue
    maxReceiveCount     = 10
  })
}
