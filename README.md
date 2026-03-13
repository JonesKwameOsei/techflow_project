# TechFlow CI/CD Project 🚀

[![CI/CD Pipeline](https://github.com/Dcoder21/Techflow-Project/actions/workflows/pipeline.yml/badge.svg)](https://github.com/Dcoder21/Techflow-Project/actions/workflows/pipeline.yml)
[![Pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![Code style: Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)

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

Finally, the project is now set up with a robust CI/CD pipeline that ensures code quality, security, and reliability at every step of the development process. The next phase will be to implement the Dockerization and deployment automation to complete the end-to-end CI/CD workflow.

However, there is a need to validate the files to be pushed since there has been a lot of updates:

```shell
pre-commit run --all-files
```

![alt text](images/final-commit.png)
![alt text](images/image-1.png)

All checks have passed successfully. The code is now ready to be pushed to the remote repository, where the GitHub Actions workflows will take over and run all the automated checks and processes as configured.

![alt text](images/final-commit-2.png)

---

<!-- ## 🚀 Next Steps: Docker & Deployment

The foundation is now set for the next phase of full automation: ### Creation of Dockerfile

Next, we need to create a `Dockerfile` to containerize the Flask app. This will allow us to run the app in any environment without worrying about dependencies or configuration issues.

You must create the following files from scratch:

### 1. `Dockerfile`
Containerize the Flask app. Your image must:
- Be based on an official Python image
- Install all dependencies from `requirements.txt`
- Expose port `5000`
- Start the app when the container runs

Test it locally before moving on:
```bash
docker build -t techflow-app .
docker run -p 5000:5000 techflow-app
# Visit http://localhost:5000 — does it work?
```

---

### 2. `.github/workflows/pipeline.yml`
This is the heart of the project. Your pipeline must have **three jobs** that run in sequence:

**Job 1 — Test**
- Triggers on every push to `main`
- Spins up a Python environment
- Installs dependencies
- Runs `pytest test_app.py -v`
- The next job must NOT run if tests fail

**Job 2 — Build & Push**
- Only runs if Job 1 passes
- Logs into DockerHub using secrets (see Secrets section below)
- Builds the Docker image
- Pushes it to DockerHub tagged as both `latest` and the commit SHA

**Job 3 — Deploy**
- Only runs if Job 2 passes
- SSHs into your EC2 server using a stored private key
- Pulls the latest image
- Stops the old container and starts the new one
- Sends a success or failure email notification

> 💡 **Hint:** Look into `appleboy/ssh-action` for SSH deployment and `dawidd6/action-send-mail` for email — these are community GitHub Actions that do the heavy lifting for you.

---

### 3. `scripts/health_check.sh`
A bash script that runs on the EC2 server after deployment to verify the app is alive.

It should:
- Make an HTTP request to the app's `/health` endpoint
- Retry up to 5 times if it fails (the container needs a moment to start)
- Exit with code `0` if the app is healthy
- Exit with code `1` if all retries fail

> 💡 **Hint:** Look into the `curl` command with the `-o` and `-w` flags to get just the HTTP status code.

---

### 4. `scripts/rollback.sh`
A bash script that runs on EC2 **only if the health check fails**.

It should:
- Stop and remove the broken container
- Pull the previous stable image from DockerHub (tagged `previous_stable`)
- Start that image instead
- Verify the rollback worked

---

### 5. `scripts/tag_stable.sh` *(Stretch Goal)*
A bash script that runs on EC2 **before** each new deployment.

It should:
- Find the currently running container's image
- Tag it as `previous_stable` on DockerHub

This is what makes rollback possible. Without it, there's nothing to roll back to.

---

## 🔐 GitHub Secrets

Your pipeline must never contain passwords or keys in plain text. Store all sensitive values in **GitHub Secrets** (`Settings → Secrets and variables → Actions`).

You will need to configure these secrets in your repo:

| Secret Name | What It Is |
|-------------|-----------|
| `DOCKERHUB_USERNAME` | Your DockerHub username |
| `DOCKERHUB_TOKEN` | A DockerHub access token (not your password) |
| `EC2_HOST` | The public IP address of your EC2 instance |
| `EC2_SSH_KEY` | The full contents of your `.pem` private key file |
| `EMAIL_USERNAME` | Your Gmail address |
| `EMAIL_APP_PASSWORD` | A Gmail App Password (not your Gmail password) |
| `NOTIFY_EMAIL` | The email address to receive notifications |

Reference them in your YAML like this: `${{ secrets.SECRET_NAME }}`

---

## ☁️ EC2 Setup Checklist

Before your pipeline can deploy, your EC2 server needs to be ready. Complete these steps manually once:

- [ ] Launch a `t2.micro` Ubuntu 24.04 instance (free tier)
- [ ] Create and download a `.pem` key pair
- [ ] Open inbound ports: **22** (SSH) and **80** (HTTP) in the security group
- [ ] SSH into the server and install Docker:
  ```bash
  sudo apt-get update && sudo apt-get install -y docker.io
  sudo systemctl enable docker && sudo systemctl start docker
  sudo usermod -aG docker ubuntu
  ```
- [ ] Upload your scripts to `/home/ubuntu/` and make them executable:
  ```bash
  chmod +x /home/ubuntu/*.sh
  ```

---

## ✅ How You Will Know It Works

1. Push a commit to `main`
2. Go to the **Actions** tab in your GitHub repo and watch all 3 jobs turn green ✅
3. Visit `http://YOUR_EC2_IP` in a browser — you should see the Hello World message
4. Check your email — you should have received a success notification
5. **Bonus test:** Deliberately break something (e.g. make `app.py` crash on startup), push it, and verify that the pipeline catches the failure and rolls back automatically

---

## 🏆 Stretch Goals

Completed everything above? Try these:

- **Tagging** — also tag your Docker image with `previous_stable` before each deploy so rollback always has a target (implement `tag_stable.sh`)
- **Pull Request checks** — modify the pipeline to also run tests on pull requests, not just pushes to `main`
- **Separate environments** — create a `staging` branch that deploys to a second EC2 instance before anything reaches `main`
- **Secrets scanning** — add a step that checks for accidentally committed secrets using `trufflesecurity/trufflehog`

---

## 🚫 Rules

- Do **not** modify `app.py` or `test_app.py`
- Do **not** hardcode credentials anywhere in your files — use GitHub Secrets
- Do **not** copy a working solution from the internet — the goal is that you understand every line you write

---

## 💬 Getting Stuck?

That's part of the process. Before asking for help, try:

1. Reading the error message carefully — GitHub Actions logs are very detailed
2. Googling the exact error
3. Checking the official docs linked in the Tools table above
4. Asking a teammate

Good luck — you've got this. 🛠️
 -->
