#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

err()
{
  echo "$1" 1>&2
  exit 1
}

# Parse args
BUNDLE_PATH=${1:-}
[ -z "$BUNDLE_PATH" ] && err "Usage: $0 bundle-path"
[ -f "$BUNDLE_PATH" ] || err "Bundle $BUNDLE_PATH not found"

git bundle verify $BUNDLE_PATH

TARGET_PATH="$( dirname "$SCRIPT_DIR" )/$( basename $BUNDLE_PATH .bundle )"
[ -e "$TARGET_PATH" ] && err "Target $TARGET_PATH already exists"

git clone "$BUNDLE_PATH" "$TARGET_PATH"
