"""
    AWS Lambda entry point.

    :param event: The input data to the Lambda function (dict).
                  Expected to contain a key 'inputNumber'.
    :param context: The runtime information provided by AWS Lambda.
    :return: A dictionary containing the status code and
             JSON-encoded result.
    """
import json
import random

def lambda_handler(event, context):
    """
    AWS Lambda entry point.

    :param event: The input data to the Lambda function (dict).
                  Expected to contain a key 'inputNumber'.
    :param context: The runtime information provided by AWS Lambda.
    :return: A dictionary containing the status code and
             JSON-encoded result.
    """
    print(event)
    print(context)

    # Generate a random number between 1 and 100
    random_number1 = random.randint(1, 100000000000000000000)
    random_number2 = random.randint(1, 1000000000000000000000)
    random_number3 = random.randint(1, 1000000000000000000000)

    # Calculate the result
    result = random_number2 * random_number1 * random_number3
    print(result)
    # Return the result in a format expected by API Gateway
    return {
        "statusCode": 200,
        "body": json.dumps({"result": result})
    }

if __name__ == '__main__':
    lambda_handler({"inputNumber": 1},2)
