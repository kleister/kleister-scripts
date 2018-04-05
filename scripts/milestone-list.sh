#!/usr/bin/env bash

#
# Copyright 2016 Thomas Boerger <thomas@webhippie.de>
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

set -eo pipefail

if ! hash ghi 2>/dev/null; then
    echo "failed to find ghi, please install that first!"
    exit 1
fi

repos=(
    homebrew-kleister
    kleister-api
    kleister-cli
    kleister-ui
    kleister-go
    kleister-js
    kleister-php
    kleister-python
    kleister-ruby
)

for repo in "${repos[@]}"; do
    echo "> listing ${repo} milestones"
    ghi milestone -l -- kleister/${repo}
done
