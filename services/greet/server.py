from flask import Flask, request, jsonify


app = Flask(__name__)

@app.route('/')
def hello_world():
    user = request.args.get('name', 'Mr. Nobody')

    print(f'Got request for {user}')

    return jsonify({
        'name': 'greeter service',
        'greeting': f'Hello, {user}',
    })

app.run(port=9002, host='0.0.0.0')
