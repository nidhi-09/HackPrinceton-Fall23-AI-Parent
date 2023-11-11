from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/get_text', methods=['POST'])
def get_text():
    # Handle Character.ai API request here
    # Return the obtained text as JSON
    pass

@app.route('/generate_video', methods=['POST'])
def generate_video():
    # Handle d-id API request here
    # Return the video or a link to the generated video
    pass
if __name__ == '__main__':
    # Run the Flask app using Gunicorn from the command line
    # Example command: gunicorn -w 4 -b 0.0.0.0:5000 your_app_module:app
    import os
    os.system('gunicorn -w 4 -b 0.0.0.0:5000 app:app')
