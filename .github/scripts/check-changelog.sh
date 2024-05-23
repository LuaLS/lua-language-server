#!/bin/bash

set -e

CHANGELOG_FILE="changelog.md"

git fetch

# Check if the changelog file was modified in the PR
if git diff --name-only origin/$GITHUB_BASE_REF..$GITHUB_HEAD_REF | grep -q $CHANGELOG_FILE; then
  echo "Thank you for updating the changelog!"
  exit 0
else
  echo "Changelog has not been updated. Please update $CHANGELOG_FILE!"
  exit 1
fi
