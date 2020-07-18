#!/bin/sh
set -e

trap 'echo "return: $?, $LINENO"' EXIT

SomeFunc() {
    echo "inside: $?"
    return 1
}

SomeFunc
echo "after: $?"
