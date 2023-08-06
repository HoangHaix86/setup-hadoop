#! /usr/bin/env python3
from flask import Flask

app = Flask(__name__)

@app.route('/')
def main():
    with open('/root/.ssh/authorized_keys', 'r') as f:
        return f.read()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9091)