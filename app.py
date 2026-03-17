import os

from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello() -> tuple[str, int]:
    return "Hello, World! 🚀 TechFlow CI/CD Pipeline is live.", 200


@app.route("/health")
def health() -> tuple[dict[str, str], int]:
    return {"status": "ok"}, 200


if __name__ == "__main__":
    app.run(host=os.environ.get("FLASK_HOST", "127.0.0.1"), port=5000)
