#!/usr/bin/env bash
set -eo pipefail

if ! hash ghi 2>/dev/null; then
    echo "Failed to find ghi, please install that first!"
    exit 1
fi

repos=(
    homebrew-kleister
    kleister-api
    kleister-cli
    kleister-go
)

for repo in "${repos[@]}"; do
    echo "> listing ${repo} milestones"
    ghi milestone -l -- kleister/${repo}
done
