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
    kleister-docs
    kleister-go
    kleister-scripts
)

labels=(
    bug:fc2929
    duplicate:cccccc
    enhancement:84b6eb
    hacktoberfest:d4c5f9
    help\ wanted:159818
    in\ progress:ededed
    infra:006b75
    invalid:e6e6e6
    lint:fbca04
    poc:c2e0c6
    question:cc317c
    ready:ededed
    third-party:e99695
    translation:b60205
    wontfix:5319e7
)

for repo in "${repos[@]}"; do
    echo "> updating ${repo} labels"

    for label in "${labels[@]}"; do
        title="${label%%:*}"
        color="${label##*:}"

        ghi label -a -c "${color}" "${title}" -- kleister/${repo}
    done
done
