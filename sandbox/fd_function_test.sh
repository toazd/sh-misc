#!/bin/sh

#shellcheck disable=SC2039,SC2128
if [ -n "$BASH_VERSINFO" ]; then
    shopt -o posix >/dev/null
fi

fRecDev() {
    while read -r; do
        :
    done
} </dev/stdin


fRecAmp() {
    while read -r; do
        :
    done
} <&0

fSendDev() {
    echo "test" | fRecDev
}

fSendAmp() {
    echo "test" | fRecAmp
}

echo "Using \"/dev/stdin\":"
time for i in {1..100000}; do fSendDev; done
echo -e "\nUsing \"&0\":"
time for i in {1..100000}; do fSendAmp; done
