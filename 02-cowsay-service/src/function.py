import os
import json
import cowsay

GREETING = os.environ.get('GREETING', None)
CHARACTER = os.environ.get('CHARACTER', 'cow')

def lambda_handler(event, context):
    if 'body' in event:
        event = json.loads(event['body'])
    
    print(event, type(event))

    character = event.get('character', CHARACTER)
    message = event.get('message', '')
    if GREETING:
        message = f"{GREETING} {message}"
        
    return {
        'notice': cowsay.get_output_string(character, message)
    }


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("-m", "--message", type=str, required=True)
    parser.add_argument("-c", "--character", type=str, default="cow")
    args = parser.parse_args()
    print(lambda_handler(vars(args), None)['notice'])
