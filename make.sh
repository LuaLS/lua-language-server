#!/usr/bin/env bash

git submodule update --init --recursive
pushd 3rd/luamake
./compile/build.sh
popd
if [ -z "$1" ]; then
    3rd/luamake/luamake rebuild
else
    3rd/luamake/luamake rebuild --platform "$1"
fi
