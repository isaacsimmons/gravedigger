#!/usr/bin/env bash

set -euo pipefail

source .env

aws s3 sync --size-only --exclude "*" --include "*.bundle" ../graveyard/ $AWS_BUCKET_PATH
aws s3 sync --size-only $AWS_BUCKET_PATH ../graveyard/
