#!/bin/sh -e

options="pacman apt" 
pkgr="nothing"
for opt in $options; do
    cmd="command -v $opt > /dev/null 2>&1"
    if [ "$($cmd)" ]; then
        pkgr=$opt
        break
    fi
done


