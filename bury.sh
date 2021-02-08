#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PARENT_DIR="$( dirname "$SCRIPT_DIR" )"
GRAVEYARD_DIR="$PARENT_DIR/graveyard"
TMP_DIR="$SCRIPT_DIR/tmp"

err()
{
  echo "$1" 1>&2
  exit 1
}

# Parse args
CLONE_URL=${1:-}
NAME_OVERRIDE=${2:-}
[ -z "$CLONE_URL" ] && err "Usage: $0 git-url [local-filename]"

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
cd "$TMP_DIR"
echo "Ready to clone $CLONE_URL"
git clone --bare --mirror $CLONE_URL $NAME_OVERRIDE

REPO_FULL_NAME=`ls | head -n 1`
REPO_NAME=`echo $REPO_FULL_NAME | sed "s/.git$//"`


cd $REPO_FULL_NAME

LAST_COMMIT_DATE=`git log -1 --date=format:%Y-%m-%d --format="%cd"`
BUNDLE_PATH="$GRAVEYARD_DIR/$REPO_NAME-$LAST_COMMIT_DATE.bundle"

[ -e "$BUNDLE_PATH" ] && err "ERROR: File already exists at $BUNDLE_PATH"
echo "Ready to create bundle $BUNDLE_PATH"
git bundle create "$BUNDLE_PATH" --all

cd "$SCRIPT_DIR"
rm -rf "$TMP_DIR"

echo
echo "Backup created at $BUNDLE_PATH. You may now delete the repository at $CLONE_URL"
