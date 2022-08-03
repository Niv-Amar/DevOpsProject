import boto3
import json
import csv
import time
import os
from subprocess import call

def lambda_handler(event, context):
    call('rm -rf /tmp/*', shell=True)
    record = event['Records']
    last_message_in_q = record[-1]
    messg_body = last_message_in_q["body"]
    json_str = (str(messg_body))
    #json validation check
    try:
        json_object = json.loads(json_str)
    except ValueError as err:
        return False
    s3 = boto3.resource('s3')
#replace 'ChangeMe!!' with your s3 bucket name.
    bucket = s3.Bucket('ChangeMe!!')
    
#converting json to csv and upload it to s3 bucket
    with open('/tmp/message.csv', 'w') as f:
        for key in json_object.keys():
            f.write("%s, %s\n" % (key, json_object[key]))

    bucket.upload_file('/tmp/message.csv','"'  + (time.strftime("%Y.%m.%d-%H:%M:%S")) + '-products-list.csv')