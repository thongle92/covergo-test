from flask import Flask
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def show_current_time():
    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    return f"Current time is: {current_time}"

if __name__ == '__main__':
    app.run(port=8282, debug=True)
