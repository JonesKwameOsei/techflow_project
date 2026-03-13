#!/usr/bin/env python3
"""
Script to create GitHub repository labels for the TechFlow project.
This script sets up all required labels for the CI/CD pipeline.

Requirements:
    pip install PyGithub

Usage:
    python setup_labels.py --token YOUR_GITHUB_TOKEN --repo owner/repo-name

Example:
    python setup_labels.py --token ghp_xxxx --repo Dcoder21/Techflow-Project
"""

import argparse
import sys
from typing import List, Tuple

try:
    from github import Github
    from github.GithubException import GithubException
except ImportError:
    print("❌ PyGithub not installed. Run: pip install PyGithub")
    sys.exit(1)

# Define labels: (name, color, description)
LABELS: List[Tuple[str, str, str]] = [
    # Type labels
    ("type:bug", "d73a4a", "Something isn't working"),
    ("type:feature", "a2eeef", "New feature or request"),
    ("type:docs", "0075ca", "Improvements or additions to documentation"),
    ("type:chore", "fef2c0", "Maintenance and housekeeping"),
    ("type:refactor", "fbca04", "Code refactoring"),
    ("type:test", "c2e0c6", "Adding or updating tests"),
    # Priority labels
    ("priority:low", "d4edda", "Low priority issue"),
    ("priority:medium", "fff3cd", "Medium priority issue"),
    ("priority:high", "f8d7da", "High priority issue"),
    ("priority:critical", "721c24", "Critical priority issue"),
    # Status labels
    ("status:triage", "e1e4e8", "Needs triage"),
    ("status:in-progress", "0052cc", "Work in progress"),
    ("status:ready-for-review", "28a745", "Ready for review"),
    ("status:blocked", "b60205", "Blocked by dependencies"),
    ("status:on-hold", "fbca04", "On hold"),
    # Size labels
    ("size:xs", "c2e0c6", "Extra small PR"),
    ("size:s", "7ce4a7", "Small PR"),
    ("size:m", "ffeb3b", "Medium PR"),
    ("size:l", "ff9800", "Large PR"),
    ("size:xl", "f44336", "Extra large PR"),
    # Area labels
    ("area:backend", "1f77b4", "Backend related"),
    ("area:frontend", "ff7f0e", "Frontend related"),
    ("area:api", "2ca02c", "API related"),
    ("area:ci-cd", "9467bd", "CI/CD pipeline related"),
    ("area:security", "d62728", "Security related"),
    ("area:performance", "17becf", "Performance related"),
]


def create_labels(token: str, repo_name: str) -> None:
    """Create labels in the GitHub repository."""
    try:
        g = Github(token)
        repo = g.get_repo(repo_name)

        print(f"🔧 Setting up labels for {repo_name}...")

        created_count = 0
        updated_count = 0

        for label_name, color, description in LABELS:
            try:
                # Try to get existing label
                existing_label = repo.get_label(label_name)

                # Update if different
                if (
                    existing_label.color.lower() != color.lower()
                    or existing_label.description != description
                ):
                    existing_label.edit(label_name, color, description)
                    print(f"✏️  Updated: {label_name}")
                    updated_count += 1
                else:
                    print(f"✅ Exists: {label_name}")

            except GithubException as e:
                if e.status == 404:  # Label doesn't exist
                    repo.create_label(label_name, color, description)
                    print(f"➕ Created: {label_name}")
                    created_count += 1
                else:
                    print(f"❌ Error with {label_name}: {e.data['message']}")

        print("\n🎉 Label setup complete!")
        print(f"   Created: {created_count}")
        print(f"   Updated: {updated_count}")
        print(f"   Total labels: {len(LABELS)}")

    except GithubException as e:
        print(f"❌ GitHub API error: {e.data['message']}")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Unexpected error: {str(e)}")
        sys.exit(1)


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Create GitHub repository labels for TechFlow project"
    )
    parser.add_argument("--token", required=True, help="GitHub personal access token")
    parser.add_argument(
        "--repo", required=True, help="Repository name in format: owner/repo-name"
    )

    args = parser.parse_args()

    if "/" not in args.repo:
        print("❌ Repository must be in format: owner/repo-name")
        sys.exit(1)

    create_labels(args.token, args.repo)


if __name__ == "__main__":
    main()
