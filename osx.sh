#!/bin/bash

set -e

MY_DIR=$(cd "$(dirname $0)";pwd)
cd $MY_DIR

git submodule -q update --recursive --init

echo "build luamake ..."
cd 3rd/luamake
ninja -f ninja/macos.ninja
cd -

./3rd/luamake/luamake

cd server
cp bin/*.so .
./bin/lua-language-server publish.lua
cd -

cp server/*.so publish/lua-language-server/server/

#cd publish/lua-language-server
#vsce package
