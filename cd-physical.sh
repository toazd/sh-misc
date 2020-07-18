#!/bin/sh
cdp() {
    sNEW_PATH=${1:-$(pwd -L)}

    # If the requested path is already canonicalized, nothing to do
    [ "$sNEW_PATH" = "$(pwd -P)" ] && return 0

    # If the requested path is not a directory
    if [ ! -d "$sNEW_PATH" ]; then
        echo "\"$sNEW_PATH\" is not a directory"
        return 1
    fi

    # If the requested path is not a symlink then skip the rest
    [ ! -L "$sNEW_PATH" ] && { cd "$sNEW_PATH" || return 1; return 0; }

    # Change to the resolved, absolute path of the symlink
    if ! cd "$(realpath -eqP "$sNEW_PATH")"; then
        return 1
    fi

    return 0
}
