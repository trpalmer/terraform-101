#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" 2> /dev/null && pwd )
cd $SCRIPT_DIR/..

find -name ".terraform" -type d -exec rm -rf {} +
find -name ".terraform.lock.hcl" -type f -exec rm -f {} +
find -name "terraform.tfstate*" -type f -exec rm -f {} +
find -name "*.zip" -type f -exec rm -f {} +
find -name "*venv*" -type d -exec rm -rf {} +