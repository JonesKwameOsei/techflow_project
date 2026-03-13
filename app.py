import os
from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello, World! 🚀 TechFlow CI/CD Pipeline is live.", 200


@app.route("/health")
def health():
    return {"status": "ok"}, 200


if __name__ == "__main__":
    # Use environment variables for configuration with safe defaults
    host = os.environ.get(
        "FLASK_HOST", "127.0.0.1"
    )  # Default to localhost for security
    port = int(os.environ.get("FLASK_PORT", "5000"))
    debug = os.environ.get("FLASK_ENV") == "development"

    app.run(host=host, port=port, debug=debug)
