#!/usr/bin/env bash

set -euo pipefail

source .env

aws s3 sync --size-only --exclude "*" --include "*.bundle" ../graveyard/ s3://$AWS_BUCKET/graveyard/
aws s3 sync --size-only s3://$AWS_BUCKET/graveyard/ ../graveyard/
