from collections.abc import Generator

import pytest
from flask.testing import FlaskClient

from app import app


@pytest.fixture
def client() -> Generator[FlaskClient, None, None]:
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_hello_returns_200(client: FlaskClient) -> None:
    response = client.get("/")
    assert response.status_code == 200


def test_hello_contains_text(client: FlaskClient) -> None:
    response = client.get("/")
    assert b"Hello" in response.data


def test_health_endpoint(client: FlaskClient) -> None:
    response = client.get("/health")
    assert response.status_code == 200
    data = response.get_json()
    assert data["status"] == "ok"
