# TechFlow CI/CD Project 🚀

[![CI/CD Pipeline](https://github.com/JonesKwameOsei/Techflow-Project/actions/workflows/pipeline.yml/badge.svg)](https://github.com/JonesKwameOsei/Techflow-Project/actions/workflows/pipeline.yml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen)](https://github.com/pre-commit/pre-commit)
[![Ruff](https://img.shields.io/badge/code%20style-ruff-000000)](https://github.com/astral-sh/ruff)
[![Python](https://img.shields.io/badge/python-3.11+-blue)](https://python.org)
[![Flask](https://img.shields.io/badge/flask-3.0+-green)](https://flask.palletsprojects.com/)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Security](https://img.shields.io/badge/security-bandit-yellow)](https://github.com/PyCQA/bandit)

---

## Overview

This project demonstrates a robust fully automated CI/CD pipeline that takes code from development all the way to a live server with zero manual intervention. It showcases modern DevOps practices with comprehensive testing, security scanning, and automated deployments.

### 🎯 Current Implementation

- **Flask Web Application** with health endpoints
- **Comprehensive CI/CD Pipeline** with GitHub Actions
- **Pre-commit Hooks** for code quality enforcement
- **Multi-Python Testing** across Python 3.9-3.12
- **Security Scanning** with Safety and Bandit
- **Branch Protection Rules** and automated PR checks
- **Code Coverage** reporting and analysis

---

## 🚨 The Problem This Solves

### The Problem Statement

In a traditional software development process, developers write code and then manually deploy it to servers. This can lead to several issues:

- **Human Error**: Manual steps can be forgotten or done incorrectly, leading to failed deployments.
- **Slow Feedback Loop**: Developers may not find out about bugs or issues until after deployment, which can be hours or days later.
- **Deployment Anxiety**: Running tests locally is not the same as running them in a production-like environment. This can lead to "it works on my machine" scenarios where code breaks after deployment. Also, tests become inconsistent across development teams and environments, leading to confusion and mistrust in the testing process, which can result in developers skipping tests altogether. This makes testing less effective and increases the likelihood of bugs reaching production.
- **Operational Friction**: Manual deployment leaves room for developers to manually `SSH` into production servers to pull the latest code and restart servers, which can lead to security risks and inconsistent environments.
- **Lack of Rollback**: If something goes wrong during deployment, there may be no easy way to revert to the last known good state, leading to prolonged downtime.
- **Customer Impact**: Failed deployments mostly lead to downtime, which negatively impacts user experience and can damage the company's reputation.

---

### The Solution: A fully automated CI/CD pipeline that runs tests, builds Docker images, deploys to a live server, and recovers from failures automatically

The primary obstacle to manual deployment is that it relies manly on lack of environment parity due to human error. By automating the entire process, we can ensure that every step is executed consistently and correctly, reducing the chances of failure and improving the overall reliability of the deployment process.

This project builds an infrastructure so that every time a developer pushes code to `main`, the following happens automatically:

```sh
Developer pushes code
        ↓
 Tests run automatically
        ↓
 Docker image is built & stored
        ↓
 App is deployed to a live server
        ↓
 Team receives an email: Success or Failure
        ↓
 Iterative feedback loop
```

> If anything goes wrong during deployment, the system should **automatically recover** without human intervention.

---

## Project Setup

### Run the app and tests locally

Every automation begins with understanding the manual process. After cloning the repo, it is ideal to run it locally to understand what it does and how it works before you start building the pipeline. The project structure is as follows:

```plaintext
Techflow-Project
|-- Project-README.md
|-- README.md
|-- app.py                 # A Flask web app
|-- gitignore.txt
|-- requirements.txt       # Python dependencies
`-- test_app.py            # Tests for the app
```

- Step 1: cd into repo and Install dependencies and run the app:

```python
cd Techflow-Project
pip install -r requirements.txt
python app.py
# Visit http://localhost:5000
```

![alt text](images/image.png)

---

- Step 2: Run the tests to see what "passing" looks like:

```bash
pytest test_app.py -v
```

**Tests passed**:

![alt text](images/image-1.png)

> All 3 tests should pass. The pipeline must make these same tests pass in an automated environment.
---

## Implementation of CI/CD Automation

Having understood how the app works and what the tests do, we can start building the automation. The tools to be use are:

- **GitHub Actions** for CI/CD orchestration
- **Docker** for containerization
- **DockerHub** for image registry
- **Bash** for scripting health checks and rollbacks
- **Terraform** for infrastructure as code
- **Gmail SMTP** for email notifications
- **AWS EC2** for hosting the live server

### Security Implementation

- **Precommit Hooks**: Implement precommit hooks to run tests locally before allowing a commit. This ensures that broken code never even reaches the pipeline.
- **Linting and Formatting**: `Ruff` would be used for linting and formatting to ensure code quality and consistency across the codebase. Set up is found in `pyproject.toml` and enforced via `pre-commit hooks`.
- **Type Checking**: `Pyright` will be used for static type checking to catch type errors before runtime.
- **Secrets Management**: All sensitive information (e.g., DockerHub credentials, EC2 SSH keys, email credentials) will be stored securely using GitHub Secrets. No secrets should be hardcoded in any files.
- **Disable root login**: Ensure that root login is disabled on the EC2 instance to prevent unauthorized access.
- **No Root access for user in Docker Container**: The Dockerfile will be configured to run the application as a non-root user to minimize security risks.
- **Configure SSH Access**: Ensure that SSH access is properly configured with key-based authentication and that only authorized users can access the EC2 instance and there are no manual user access to the server.
- **Use of App Passwords**: For email notifications, Gmail App Passwords will be used instead of regular passwords to enhance security.

---

### One Important Setup Step: Pre-commit Hooks

It it relevant  `pre-commit` installed and run it either locally and/or set up pre-commit hooks to automatically run tests before every commit. This ensures that broken codes or issues are caught before they land in `Git history`.

#### Local setup (recommended path: pre-commit framework)

- Install `pre-commit`:

   ```python
   pip install pre-commit
   ```

- Create a `.pre-commit-config.yaml` file in the root of repo.

- Install the pre-commit hooks:

   ```bash
   pre-commit install
   ```

- Run the hooks on all files to ensure everything is working:

   ```bash
   pre-commit run --all-files
   ```

![alt text](images/pre-commit-1.png)

![alt text](images/pre-commit-2.png)

The pre-commit hooks were successfully installed and run on all files.But some of the files were not formatted correctly and the tests failed. This is the need for pre-commit hooks - to catch these issues before they even get committed.

These files that failed were well formatted after and subsequently passed.

![alt text](images/pre-commit-3.png)

- Add a pre-push hook to run tests before every push. Then enforce that all developers must have this hook installed before they can push to `main`.

```sh
pre-commit install --hook-type pre-push
```

---

### Using Ruff for Linting and Formatting

```python
# Install Ruff
pip install ruff

# Check for errors
ruff check .

# Automatically fix fixable errors
ruff check --fix .

# Format code
ruff format .
```

## mypy for Type Checking

```python
# Install mypy
pip install mypy

# Run mypy
mypy .
```

**OutPUT**:

```sh
Success: no issues found in 3 source files
```

---

## ✅ Current CI/CD Implementation

The project now includes a comprehensive CI/CD pipeline with the following features:

### 🔧 GitHub Actions Workflows

**Main Pipeline ([pipeline.yml](.github/workflows/pipeline.yml))**

- ✅ **Pre-commit Enforcement**: Runs all configured hooks to ensure code quality
- ✅ **Multi-Python Testing**: Tests on Python 3.9, 3.10, 3.11, 3.12
- ✅ **Security Scanning**: Safety (for vulnerabilities) and Bandit (for security)
- ✅ **Build Validation**: Application startup and health check tests
- ✅ **Code Coverage**: Pytest-cov with coverage reporting

**PR Checks ([pr-checks.yml](.github/workflows/pr-checks.yml))**

- ✅ **PR Title Validation**: Enforces conventional commit format
- ✅ **PR Size Limits**: Prevents overly large pull requests
- ✅ **Merge Conflict Detection**: Automatic conflict checking
- ✅ **Label Requirements**: Ensures proper PR categorization
- ✅ **Branch Freshness**: Warns when PRs are behind main

### 📋 Repository Standards

- ✅ **CODEOWNERS**: Automatic reviewer assignment
- ✅ **Issue Templates**: Standardized bug reports and feature requests
- ✅ **PR Templates**: Comprehensive pull request checklist
- ✅ **GitHub Labels**: Complete labeling system for issues and PRs

### 🛠️ Developer Tools

```bash
# Install development dependencies
pip install -r requirements-dev.txt

# Set up pre-commit hooks
pre-commit install
pre-commit install --hook-type commit-msg

# Run all checks locally
pre-commit run --all-files

# Set up GitHub labels (optional)
python setup_labels.py --token YOUR_GITHUB_TOKEN --repo owner/repo
```

### 🔒 Branch Protection Setup

See [CI-CD-SETUP.md](CI-CD-SETUP.md) for detailed instructions on:

- Configuring GitHub branch protection rules
- Setting up required status checks
- Enabling required reviews and signed commits
- Configuring automatic security scanning

---

### Validate Setup before push to remote

Finally, the project is now set up with a robust CI/CD pipeline that ensures code quality, security, and reliability at every step of the development process. The next phase will be to implement the Dockerisation and deployment automation to complete the end-to-end CI/CD workflow.

However, there is a need to validate the files to be pushed since there has been a lot of updates:

```shell
pre-commit run --all-files
```

![alt text](images/final-commit.png)
![alt text](images/image-1.png)

All checks have passed successfully. The code is now ready to be pushed to the remote repository, where the GitHub Actions workflows will take over and run all the automated checks and processes as configured.

![alt text](images/final-commit-2.png)

`Git commit` is subsequently successful. All **security** checks passed. Now code can be pushed to the repo.

![alt text](images/pre-commit-pass.png)

**Branch protection** is working as expected. Now:

![alt text](images/branch-protection.png)

- Changes must be made through a `pull request` - Direct pushes to `main` are blocked.
- `4 of 4 checks` must pass before merging - All GitHub Actions checks must succeed.
- `1 approving review` is required - At least one code owner must approve the PR.
- `Commits must have verified signatures` - Needs signed commits to ensure authenticity.

### Pull Request Code QualityChecks

- All pre-commit hooks run automatically on the PR branch.
- For any hook that failed, the PR showed the failed checks and cannot be merged until all issues

![alt text](images/pr.png)

---

## 🐋 Phase 2: Docker & Deployment

The foundation is now set for the next phase of full automation:

### 1. Creation of Dockerfile

Next, we need to create a `Dockerfile` to containerize the Flask app. This will allow us to run the app in any environment without worrying about dependencies or configuration issues.

Creating the `Dockerfile` from scratch, it should`:

**Containerize** the Flask app. The `Docker image` must:

- Be based on an official Python image
- Install all dependencies from `requirements.txt`
- Create a `non-root user` to run the app for security
- Expose port `5000`
- Start the app when the container runs

Test it locally before moving on:

```bash
docker build -t techflow-app .
docker run --name techflow-app -p 5000:5000 techflow-app
# Visit http://localhost:5000 — does it work?
```

Docker image built and container runs successfully. The app is accessible at `http://localhost:5000` and all endpoints work as expected.

Access it via the CLI to see the running container:

```sh
❯ docker ps
CONTAINER ID   IMAGE                 COMMAND           CREATED         STATUS         PORTS                                         NAMES
2f4428f0e610   techflow-app:latest   "python app.py"   3 minutes ago   Up 3 minutes   0.0.0.0:5000->5000/tcp, [::]:5000->5000/tcp   techflow-app
```

Access it via the browser to see the app running: `http://localhost:5000`

![alt text](images/docker-run-local.png)

![alt text](images/docker-container.png)

---

#### Manually pushing the Docker image to DockerHub

It is essential to push the Docker image to a registry (DockerHub) so it can be accessed and deployed from anywhere or even test the image locally. To do this, we need to:

```bash
docker login
docker tag techflow-app:latest MY_DOCKERHUB_USERNAME/techflow-app:v1.0.0
docker push MY_DOCKERHUB_USERNAME/techflow-app:v1.0.0
```

Verify that the image is successfully pushed to DockerHub by visiting your DockerHub repository.

![alt text](images/dockerhub-image.png)

Now the Docker image is available in DockerHub and can be pulled from anywhere for deployment.

```sh
docker pull MY_DOCKERHUB_USERNAME/techflow-app:v1.0.0
```

```sh
➜ docker images

IMAGE                                    ID             DISK USAGE   CONTENT SIZE   EXTRA
kwameds/techflow-app:v1.0.0              d9ab821e3283        641MB          157MB    U
techflow-app:latest                      d9ab821e3283        641MB          157MB    U
```

Again, the image is successfully pulled from DockerHub and is available locally. This confirms that the DockerHub integration is working correctly and the image can be accessed for deployment. Let's test the pulled image locally to ensure it runs as expected:

```bash
docker run --name techflow-app -p 5000:5000 kwameds/techflow-app:v1.0.0
```

Confirm container is running via CLI:

```sh
docker ps
```

Confirm that the app is running by visiting `http://localhost:5000` in the browser. The app should be accessible and functioning correctly, confirming that the Docker image works as intended.

![alt text](images/dockerhub-container-running.png)

### 2. `.github/workflows/pipeline.yml`

Next, we need to update our GitHub Actions workflow to include steps for building the Docker image and pushing it to DockerHub. This will automate the process of creating and distributing our Docker image every time code is pushed to `main`.

The workflow should include:

#### **Job 1 — Test**

- Triggers on every push to `main`
- Spins up a Python environment
- Installs dependencies
- Runs `pytest test_app.py -v`
- The next job must NOT run if tests fail

#### **Job 2 — Build & Push**

- Only runs if Job 1 passes
- Logs into DockerHub using secrets (see Secrets section below)
- Builds the Docker image
- Pushes it to DockerHub tagged as both `latest` and the commit SHA

#### **Job 3 — Deploy**

- Only runs if Job 2 passes
- SSHs into your EC2 server using a stored private key
- Pulls the latest image
- Stops the old container and starts the new one
- Sends a success or failure email notification
