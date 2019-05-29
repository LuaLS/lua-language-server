#!/bin/bash

set -e

MY_DIR=$(cd "$(dirname $0)";pwd)
INSTALL_PATH=`find ~/.vscode/extensions -name "sumneko.lua-*" | sort -r | head -1`

cd $MY_DIR

echo "updating submodule ..."
git submodule -q update --recursive --init

echo "build luamake ..."
cd 3rd/luamake
ninja -f ninja/macos.ninja
cd -

echo "build binary ..."
./3rd/luamake/luamake

if [ -d "$INSTALL_PATH" ]; then
    echo "Try to install lua-language-server for you:"
    cp -R server/bin "${INSTALL_PATH}/server"

    echo "Test ..."
    ${INSTALL_PATH}/server/bin/lua-language-server ${INSTALL_PATH}/server/test.lua

    echo "installed."
    echo "please restart VScode and enjoy."
else
    echo "Test ..."
    ./server/bin/lua-language-server ./server/test.lua

    echo "please install sumneko Lua in VScode Marketplace first."
fi
echo "Done."
