#!/usr/bin/env bash

git submodule update --init --recursive
pushd 3rd/luamake
./compile/install.sh
popd
./3rd/luamake/luamake rebuild
