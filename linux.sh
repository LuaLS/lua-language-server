#!/bin/bash

set -e

MY_DIR=$(cd "$(dirname $0)";pwd)
INSTALL_PATH=`find ~/.vscode/extensions -name "sumneko.lua-*" | sort -r | head -1`
if [ -d "$INSTALL_PATH" ]; then
else
    echo "please install sumneko Lua in VScode Marketplace first."
fi

cd $MY_DIR

echo "updating submodule ..."
git submodule -q update --recursive --init

echo "build luamake ..."
cd 3rd/luamake
ninja -f ninja/linux.ninja
cd -

echo "build binary ..."
./3rd/luamake/luamake

echo "Try to install lua-language-server for you:"
cp server/bin/lua-language-server "${INSTALL_PATH}/server/bin"
cp server/bin/*.so "${INSTALL_PATH}/server/bin"

echo "Test ..."
${INSTALL_PATH}/server/bin/lua-language-server ${INSTALL_PATH}/server/test.lua

echo "installed."
echo "please restart VScode and enjoy."
echo "Done."
