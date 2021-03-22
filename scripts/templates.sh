#!/usr/bin/env bash

#
# Copyright 2021 Thomas Boerger <thomas@webhippie.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# This script is used to copy a pre-defined set of templates into all
# repositories part of the Kleister GitHub organization. The template files
# include CONTRIBUTING.md, DCO and LICENSE files so far.
#

set -eo pipefail

if [ -L "${0}" ]; then
    ROOT=$(cd "$(dirname "$(readlink -e "${0}")")/.."; pwd)
else
    ROOT=$(cd "$(dirname "${0}")/.."; pwd)
fi

for REPO in $(curl --silent https://api.github.com/users/kleister/repos | jq -r '.[].clone_url'); do
    WORKDIR=$(mktemp -d -t kleister-templates)
    NAME=$(basename "${REPO%.git}")

    echo "> Cloning ${REPO} into ${WORKDIR}"
    git clone -b master "${REPO}" "${WORKDIR}"

    pushd "${WORKDIR}" >/dev/null
        echo " -> Writing license file"
        if [[ "${NAME}" == "kleister-docs" ]]; then
            curl --silent -o LICENSE https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt
        else
            curl --silent -o LICENSE https://www.apache.org/licenses/LICENSE-2.0.txt
        fi

        echo " -> Writing dco file"
        sed "s/REPO_NAME/${NAME}/" < "${ROOT}/templates/dco.tmpl" >| DCO

        echo " -> Writing contributing file"
        sed "s/REPO_NAME/${NAME}/" < "${ROOT}/templates/contributing.tmpl" >| CONTRIBUTING.md

        echo " -> Writing editorconfig file"
        sed "s/REPO_NAME/${NAME}/" < "${ROOT}/templates/editorconfig.tmpl" >| .editorconfig

        echo " -> Creating github dir"
        mkdir -p .github

        echo " -> Writing lock settings"
        sed "s/REPO_NAME/${NAME}/" < "${ROOT}/templates/lock.tmpl" >| .github/lock.yml

        echo " -> Writing reaction settings"
        sed "s/REPO_NAME/${NAME}/" < "${ROOT}/templates/reaction.tmpl" >| .github/reaction.yml

        echo " -> Writing pr template"
        sed "s/REPO_NAME/${NAME}/" < "${ROOT}/templates/pr_template.tmpl" >| .github/pull_request_template.md

        echo " -> Writing issue template"
        sed "s/REPO_NAME/${NAME}/" < "${ROOT}/templates/issue_template.tmpl" >| .github/issue_template.md

        if [[ ! -f .github/settings.yml ]]; then
            echo " -> Writing repo settings"
            sed "s/REPO_NAME/${NAME}/" < "${ROOT}/templates/settings.tmpl" >| .github/settings.yml
        fi

        git add --all
        git commit -m 'Updated standard templates'
    popd >/dev/null

    rm -rf "${WORKDIR}"
done
