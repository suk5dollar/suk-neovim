#!/bin/sh -e

cmd="command uname -n"
if [ "$($cmd)" = "archlinux" ]; then
    echo "Running Arch"
else
    echo "Not running Arch"
fi


cmd="command git -v > /dev/null 2>&1"
if [ ! "$($cmd)" ]; then
    echo "Git not installed on this system"
else
    echo "Git installed on this system"
fi


options="pacman apt" 
pkgr="nothing"
for opt in $options; do
    cmd="command -v $opt > /dev/null 2>&1"
    if [ "$($cmd)" ]; then
        pkgr=$opt
        break
    fi
done

echo "Using $pkgr"
 

