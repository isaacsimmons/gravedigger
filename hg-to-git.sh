#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
HG_TMP_DIR="$SCRIPT_DIR/tmp-hg"
GIT_TMP_DIR="$SCRIPT_DIR/tmp-git"
FAST_EXPORT_DIR="$SCRIPT_DIR/fast-export"
AUTHORS_FILE="$SCRIPT_DIR/hg-authors"

[ -d "$FAST_EXPORT_DIR" ] || git clone https://github.com/frej/fast-export.git "$FAST_EXPORT_DIR"
touch "$AUTHORS_FILE"

err()
{
  echo "$1" 1>&2
  exit 1
}

# Parse args
CLONE_URL=${1:-}
NAME_OVERRIDE=${2:-}
[ -z "$CLONE_URL" ] && err "Usage: $0 git-url [local-filename]"

rm -rf "$HG_TMP_DIR"
mkdir -p "$HG_TMP_DIR" "$GIT_TMP_DIR"

cd "$HG_TMP_DIR"
echo "Ready to clone $CLONE_URL"
hg clone $CLONE_URL $NAME_OVERRIDE

REPO_NAME=`ls | head -n 1`

cd $REPO_NAME

NEW_AUTHORS=""
hg log | grep user: | sort | uniq | sed 's/user: *//' | while read author
do
  if ! grep -q "^\"$author\"=" "$AUTHORS_FILE"; then
    echo "\"$author\"=\"\"" >> "$AUTHORS_FILE"
    NEW_AUTHORS=1
  fi
done
# If any new authors were discovered and added to the hg-authors file, print a message and bail out
[ -z "$NEW_AUTHORS" ] || err "New authors added in $AUTHORS_FILE. Update mappings now."


cd "$GIT_TMP_DIR"
mkdir $REPO_NAME
cd $REPO_NAME

echo "Ready to convert repo $REPO_NAME"
git init
$FAST_EXPORT_DIR/hg-fast-export.sh -r "$HG_TMP_DIR/$REPO_NAME" -A "$AUTHORS_FILE"

rm -rf "$HG_TMP_DIR"
