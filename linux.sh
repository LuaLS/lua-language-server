#!/bin/bash

set -e

MY_DIR=$(cd "$(dirname $0)";pwd)
cd $MY_DIR

git submodule -q update --recursive --init

## apt install ninja-build
## apt install clang

echo "build luamake ..."
cd 3rd/luamake
ninja -f ninja/linux.ninja
cd $MY_DIR

./3rd/luamake/luamake

cd server
mv bin/*.so .

# avoid too many file opened error
ulimit -n 4000

./bin/lua-language-server publish.lua
cd $MY_DIR

# cp server/*.so publish/lua-language-server/server/

## nvm install stable
## nvm use stable
## npm install -g vsce

# cd publish/lua-language-server
# vsce package


## example of development environment
## cp ~/lua-language-server/server/*.so ~/.vscode/extensions/sumneko.lua-0.9.4/server/
## killall -9 lua-language-server; cp ~/lua-language-server/server/bin/lua-language-server ~/.vscode/extensions/sumneko.lua-0.9.4/server/bin/
