#!/bin/bash

set -e

MY_DIR=$(cd "$(dirname $0)";pwd)
cd $MY_DIR

echo "updating submodule ..."
git submodule -q update --recursive --init

echo "build luamake ..."
cd 3rd/luamake
ninja -f ninja/macos.ninja
cd -

./3rd/luamake/luamake

cd server

# avoid too many file opened error
ulimit -n 4000

./bin/lua-language-server publish.lua
cd -

cp server/bin/*.so "${INSTALL_PATH}/server/bin"

echo "Try to install lua-language-server for you:"
INSTALL_PATH=`find ~/.vscode/extensions -name "sumneko.lua-*" | sort -r | head -1`

if [ -d "$INSTALL_PATH" ]; then
    cp server/bin/lua-language-server "${INSTALL_PATH}/server/bin"

    cp server/*.so "${INSTALL_PATH}/server"

    echo "installed."
    echo "please restart VScode and enjoy."
    echo "Done."
else
    echo "please install sumneko Lua in VScode Marketplace first."
fi

#cd publish/lua-language-server
#vsce package
