#!/usr/bin/env sh
set -ex
echo $NODE_NAME
echo $PIPELINE_NODE
echo $RESERVE
echo "$BRANCH_NAME"

make build

NAME=authlib
VERSION=$(awk '$1 == "version" {print $NF}' ./authlib/consts.py | sed "s/'//g")
OS=none
CPU_ARCH=any

WHEEL_FILENAME="$NAME-$VERSION-py3-$OS-$CPU_ARCH.whl"
CODE=$(curl -sS -w '%{http_code}' -F package="@dist/$WHEEL_FILENAME" -o output.txt "https://$GEMFURY_AUTH_TOKEN@push.fury.io/quartic-ai/")
cat output.txt && rm -rf output.txt
if [[ "$CODE" =~ ^2 ]]; then
    echo "$WHEEL_FILENAME Package published successfully"
else
    echo "ERROR: server returned HTTP code $CODE"
    exit 1
fi
