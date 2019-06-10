# lua-language-server

| Windows | Linux | macOS |
| ------- | ----- | ----- |
| [![Build Status](https://dev.azure.com/sumneko/lua-language-server/_apis/build/status/sumneko.lua-language-server?branchName=master&jobName=windows_msvc)](https://dev.azure.com/sumneko/lua-language-server/_build/latest?definitionId=1&branchName=master) | [![Build status](https://ci.appveyor.com/api/projects/status/0tng1g72fssvu9rr/branch/master?svg=true)](https://ci.appveyor.com/project/sumneko/vscode-lua-language-server/branch/master) | [![Build Status](https://dev.azure.com/sumneko/lua-language-server/_apis/build/status/sumneko.lua-language-server?branchName=master&jobName=macos)](https://dev.azure.com/sumneko/lua-language-server/_build/latest?definitionId=1&branchName=master) |
## Feature

- [x] Goto Definition
- [x] Find All References
- [x] Hover
- [x] Diagnostics
- [x] Rename
- [x] Auto Completion
- [x] IntelliSense
- [x] Signature Help
- [x] Document Symbols
- [x] Syntax Check
- [x] Highlight
- [x] Code Action
- [x] EmmyLua Annotation
- [ ] Multi Workspace
- [ ] Type Format

## Preview

### Goto Definition

![avatar](https://github.com/sumneko/lua-language-server/raw/master/images//Goto%20Definition.gif)

### Find All References

![avatar](https://github.com/sumneko/lua-language-server/raw/master/images//Find%20All%20References.gif)

### Hover

![avatar](https://github.com/sumneko/lua-language-server/raw/master/images/Hover.gif)

### Diagnostics

![avatar](https://github.com/sumneko/lua-language-server/raw/master/images/Diagnostics.gif)

### Rename

![avatar](https://github.com/sumneko/lua-language-server/raw/master/images/Rename.gif)

### Auto Completion

![avatar](https://github.com/sumneko/lua-language-server/raw/master/images/Auto%20Completion.gif)

### Signature Help

![avatar](https://github.com/sumneko/lua-language-server/raw/master/images/Signature%20Help.gif)

### Emmy Annotation

![avatar](https://github.com/sumneko/lua-language-server/raw/master/images/Emmy%20Annotation.gif)

## How to use on macOS/Linux

You need to build `lua-language-server` yourself on macOS/Linux.

* Install [sumneko.lua] in VSCode
* Install [extension-path] in VSCode
* Install [ninja]
* Clone source code
```
git clone https://github.com/sumneko/lua-language-server
git submodule update --init --recursive
```
* Open repo and execute tasks in VSCode
    1. PreCompile
    2. Compile
    3. Install
* Restart VSCode and open your lua project
* Enjoy

[ninja]: https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages
[sumneko.lua]: https://marketplace.visualstudio.com/items?itemName=sumneko.lua
[extension-path]: https://marketplace.visualstudio.com/items?itemName=actboy168.extension-path

## Version

- [x] Lua 5.1
- [x] Lua 5.2
- [x] Lua 5.3
- [x] Lua 5.4
- [x] LuaJIT

If you find any mistakes, please [tell me][issues] or use [Pull Requests][@lua] to fix them directly.

如果你发现了任何错误，请[告诉我][issues]或使用[Pull Requests][@lua]来直接修复。

[issues]: https://github.com/sumneko/lua-language-server/issues
[@lua]: https://github.com/sumneko/lua-language-server/tree/master/server/libs/%40lua

## Locale

- [x] en-US
- [x] zh-CN

Please [help me][en-US] improve the quality of `en-US`.

[en-US]: https://github.com/sumneko/vscode-lua-language-server/tree/master/server/locale/en-US

## Credit

* [bee.lua](https://github.com/actboy168/bee.lua)
* [luamake](https://github.com/actboy168/luamake)
* [lni](https://github.com/actboy168/lni)
* [LPegLabel](https://github.com/sqmedeiros/lpeglabel)
* [LuaParser](https://github.com/sumneko/LuaParser)
* [rcedit](https://github.com/electron/rcedit)
* [ScreenToGif](https://github.com/NickeManarin/ScreenToGif)
* [vscode-languageclient](https://github.com/microsoft/vscode-languageserver-node)
* [lua.tmbundle](https://github.com/textmate/lua.tmbundle)
* [Lua 5.3 中文翻译](https://cloudwu.github.io/lua53doc/manual.html)
* [EmmyLua](https://emmylua.github.io)
* [lua-glob](https://github.com/sumneko/lua-glob)
* [lua-uri](https://github.com/sumneko/lua-uri)

## Acknowledgement

* [actboy168](https://github.com/actboy168)
* [Dmitry Sannikov](https://github.com/dasannikov)
* [Jayden Charbonneau](https://github.com/Reshiram110)
* [Stjepan Bakrac](https://github.com/z16)
* [Peter Young](https://github.com/young40)
* [Li Xiaobin](https://github.com/Xiaobin0860)
* [Fedora7](https://github.com/Fedora7)
* [Allen Shaw](https://github.com/shuxiao9058)
* [Bartel](https://github.com/Letrab)
