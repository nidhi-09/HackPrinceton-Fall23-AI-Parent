from flask import Flask, request, jsonify
from characterai_api import call_character_ai

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, Dynamite!'

@app.route('/chat', methods=['POST'])
def chat():
    body = request.get_json()
    
    prompt = body["prompt"]
    return call_character_ai(prompt)

@app.route('/generate_video', methods=['POST'])
def generate_video():
    # Handle d-id API request here
    # Return the video or a link to the generated video
    pass

if __name__ == '__main__':
    # Run the Flask app using Gunicorn from the command line
    # Example command: gunicorn -w 4 -b 0.0.0.0:5000 your_app_module:app
    app.run(debug=True, port=9988)