# lua-language-server

![build](https://github.com/sumneko/lua-language-server/workflows/build/badge.svg)
[![version](https://vsmarketplacebadge.apphb.com/version-short/sumneko.lua.svg)](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
![installs](https://vsmarketplacebadge.apphb.com/installs-short/sumneko.lua.svg)
![downloads](https://vsmarketplacebadge.apphb.com/downloads-short/sumneko.lua.svg)
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/sumneko/lua-language-server.svg)](https://github.com/sumneko/lua-language-server/issues "Average time to resolve an issue")


***Lua development just got a whole lot better*** 🧠

The Lua language server provides various language features for Lua to make development easier and faster. With around half a million installs on Visual Studio Code, it is the most popular extension for Lua language support.

## Features

- 📄 Over 20 supported [annotations](https://github.com/sumneko/lua-language-server/wiki/Annotations) for documenting your code
- ↪ Go to definition
- 🦺 Dynamic [type checking](https://github.com/sumneko/lua-language-server/wiki/Type-Checking)
- 🔍 Find references
- ⚠️ [Diagnostics/Warnings](https://github.com/sumneko/lua-language-server/wiki/Diagnostics)
- 🕵️ [Syntax checking](https://github.com/sumneko/lua-language-server/wiki/Syntax-Errors)
- 📝 Element renaming
- 🗨️ Hover to view details on variables, functions, and more
- 🖊️ Autocompletion
- 📚 Support for [libraries](https://github.com/sumneko/lua-language-server/wiki/Libraries)
- 💅 [Code formatting](https://github.com/sumneko/lua-language-server/wiki/Formatter)
- 💬 [Spell checking](https://github.com/sumneko/lua-language-server/wiki/Formatter)
- 🛠️ Custom [plugins](https://github.com/sumneko/lua-language-server/wiki/Plugins)

## Install

The language server can easily be installed for use in VS Code, but it can also be used by other clients using the command line.

### Visual Studio Code
[![Install in VS Code](https://img.shields.io/badge/Install-VS%20Code-blue "Install in VS Code")](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
The language server and Visual Studio Code client can be installed from [the VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=sumneko.lua).

![](https://github.com/sumneko/vscode-lua/raw/master/images//Install%20In%20VSCode.gif)

### Command Line
[![Install for command line](https://img.shields.io/badge/Install-Command%20Line-blue "Install for command line")](https://github.com/sumneko/lua-language-server/wiki/Getting-Started#command-line)
Check the [wiki for a guide](https://github.com/sumneko/lua-language-server/wiki/Getting-Started#command-line) to install the language server for use on the command line. This allows the language server to be used for NeoVim and other clients that follow the language server protocol.

## Supported Lua Versions
| Version | Supported |
| :-----: | :-------: |
| Lua 5.1 |     ✅    |
| Lua 5.2 |     ✅    |
| Lua 5.3 |     ✅    |
| Lua 5.4 |     ✅    |
| LuaJIT  |     ✅    |

## Links
- [Changelog](https://github.com/sumneko/lua-language-server/blob/master/changelog.md)
- [Wiki](https://github.com/sumneko/lua-language-server/wiki)
- [FAQ](https://github.com/sumneko/lua-language-server/wiki/FAQ)
- [Report an issue][issues]
- [Suggest a feature][issues]
- [Discuss](https://github.com/sumneko/lua-language-server/discussions)

> If you find any mistakes, please [report it][issues] or open a [pull request][pulls] if you have a fix of your own ❤️
>
> 如果你发现了任何错误，请[告诉我][issues]或使用[Pull Requests][pulls]来直接修复。❤️

[issues]: https://github.com/sumneko/lua-language-server/issues
[pulls]: https://github.com/sumneko/lua-language-server/pulls

## Available Languages

✅ `en-us`
✅ `zh-cn`
✅ `zh-tw`
✅ `pt-br`


> ℹ Note: All translations are provided and collaborated on by the community. If you find an inappropriate or harmful translation, [please report it immediately](https://github.com/sumneko/lua-language-server/issues).

Are you able to [provide a translation](https://github.com/sumneko/lua-language-server/wiki/Translations)? It would be greatly appreciated!

Thank you to [all contributors of translations](https://github.com/sumneko/lua-language-server/commits/master/locale)!

[en-US]: https://github.com/sumneko/lua-language-server/tree/master/locale/en-us

## Configuration
Configuration of the server can be done in a number of ways, which are explained more in-depth in the [wiki](https://github.com/sumneko/lua-language-server/wiki/Configuration-File).

### Visual Studio Code
You can use the [settings editor](https://code.visualstudio.com/docs/getstarted/settings#_settings-editor) or edit the [raw JSON file](https://code.visualstudio.com/docs/getstarted/settings#_settingsjson).

### Other
See the [configuration file wiki page](https://github.com/sumneko/lua-language-server/wiki/Configuration-File).


## Privacy
This language server has **opt-in** telemetry that collects usage data and sends it to the development team to help improve the extension. Read our [privacy policy](https://github.com/sumneko/lua-language-server/wiki/Home#privacy) to learn more.


## Contributors
![GitHub Contributors Image](https://contrib.rocks/image?repo=sumneko/lua-language-server)

## Credit
Software that the language server (or the development of it) uses:

* [bee.lua](https://github.com/actboy168/bee.lua)
* [luamake](https://github.com/actboy168/luamake)
* [LPegLabel](https://github.com/sqmedeiros/lpeglabel)
* [LuaParser](https://github.com/sumneko/LuaParser)
* [ScreenToGif](https://github.com/NickeManarin/ScreenToGif)
* [vscode-languageclient](https://github.com/microsoft/vscode-languageserver-node)
* [lua.tmbundle](https://github.com/textmate/lua.tmbundle)
* [EmmyLua](https://emmylua.github.io)
* [lua-glob](https://github.com/sumneko/lua-glob)
* [utility](https://github.com/sumneko/utility)
* [vscode-lua-doc](https://github.com/actboy168/vscode-lua-doc)
* [json.lua](https://github.com/actboy168/json.lua)
* [EmmyLuaCodeStyle](https://github.com/CppCXY/EmmyLuaCodeStyle)
* [inspect.lua](https://github.com/kikito/inspect.lua)
