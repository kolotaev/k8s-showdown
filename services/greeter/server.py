import json

from flask import Flask


app = Flask(__name__)

@app.route('/')
def hello_world():
    print('Got request')

    return json.dumps({
        'name': 'greeter service',
        'greeting': 'Hello World',
    })
