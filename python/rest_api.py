from crypt import methods
from unittest import result
from flask import Flask, request
import boto3
import json

#you need to add your aws cardential with aws cli first.
#this simple flask app will listen on port 8080 to POST requests and send it to aws simple que service.
app = Flask(__name__)


@app.route("/api", methods=["POST"])
def deliver_post_request():
  result = request.get_json(force=True)
  sqs_client = boto3.client("sqs", region_name="us-east-1")
  sqs_client.send_message(
    QueueUrl="https://sqs.us-east-1.amazonaws.com/758085967712/data_pipeline",
    MessageBody=json.dumps(result)
    
)
  return result
  

if __name__ == ("__main__"):
  app.run()


