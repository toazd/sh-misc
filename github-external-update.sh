#!/bin/sh

git_root=${1:-'/home/toazd/github/external'}

[ -z "$1" ] && echo "Using default git_root of $git_root"

if [ ! -d "$git_root" ] || [ ! -r "$git_root" ]
then
    echo "$git_root is not a valid directory"
    exit 1
fi

while IFS= read -r line
do
    [ -d "$line/.git" ] && {
        if cd "$line"
        then
            printf '\033[0;32m%s\033[0m\n' "$(basename "$(pwd -P)")"
            git config pull.ff only
            ! git pull && echo "git pull failed for $line"
        fi
    }
done <<EOC
$(find "$git_root" -maxdepth 1 -type d ! -path "$git_root" 2>/dev/null)
EOC

