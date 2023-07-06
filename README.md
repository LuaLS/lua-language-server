# lua-language-server

![build](https://img.shields.io/github/actions/workflow/status/LuaLS/lua-language-server/.github%2Fworkflows%2Fbuild.yml)
![Version (including pre-releases)](https://img.shields.io/visual-studio-marketplace/v/sumneko.lua)
![Installs](https://img.shields.io/visual-studio-marketplace/i/sumneko.lua)
![Downloads](https://img.shields.io/visual-studio-marketplace/d/sumneko.lua)


***Lua development just got a whole lot better*** 🧠

The Lua language server provides various language features for Lua to make development easier and faster. With around half a million installs on Visual Studio Code, it is the most popular extension for Lua language support.

## Features

- ⚙️ Supports `Lua 5.4`, `Lua 5.3`, `Lua 5.2`, `Lua 5.1`, and `LuaJIT`
- 📄 Over 20 supported [annotations](https://github.com/LuaLS/lua-language-server/wiki/Annotations) for documenting your code
- ↪ Go to definition
- 🦺 Dynamic [type checking](https://github.com/LuaLS/lua-language-server/wiki/Type-Checking)
- 🔍 Find references
- ⚠️ [Diagnostics/Warnings](https://github.com/LuaLS/lua-language-server/wiki/Diagnostics)
- 🕵️ [Syntax checking](https://github.com/LuaLS/lua-language-server/wiki/Syntax-Errors)
- 📝 Element renaming
- 🗨️ Hover to view details on variables, functions, and more
- 🖊️ Autocompletion
- 📚 Support for [libraries](https://github.com/LuaLS/lua-language-server/wiki/Libraries)
- 💅 [Code formatting](https://github.com/LuaLS/lua-language-server/wiki/Formatter)
- 💬 [Spell checking](https://github.com/LuaLS/lua-language-server/wiki/Formatter)
- 🛠️ Custom [plugins](https://github.com/LuaLS/lua-language-server/wiki/Plugins)
- 📖 [Documentation Generation](https://github.com/LuaLS/lua-language-server/wiki/Export-Documentation)

## Install
The language server can be installed for use in Visual Studio Code, NeoVim, and any [other clients](https://microsoft.github.io/language-server-protocol/implementors/tools/) that support the [Language Server Protocol](https://microsoft.github.io/language-server-protocol/). The language server can be configured using a [configuration file](https://github.com/LuaLS/lua-language-server/wiki/Configuration-File). For a more detailed intro, check out the [getting started page in the wiki](https://github.com/LuaLS/lua-language-server/wiki/Getting-Started).

### Visual Studio Code
[![Install in VS Code](https://img.shields.io/badge/VS%20Code-Install-blue?style=for-the-badge&logo=visualstudiocode "Install in VS Code")](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)

The language server and Visual Studio Code client can be installed from [the VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=sumneko.lua).

### NeoVim
[![Install for NeoVim](https://img.shields.io/badge/NeoVim-Install-blue?style=for-the-badge&logo=neovim "Install for NeoVim")](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls)

View the installation instructions for NeoVim in the [nvim-lspconfig repo](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls).

For a guide to getting started from scratch using Mason, read [Heiker's guide](https://dev.to/vonheikemen/getting-started-with-neovims-native-lsp-client-in-the-year-of-2022-the-easy-way-bp3).

### Command Line
[![Install for command line](https://img.shields.io/badge/Command%20Line-Install-blue?style=for-the-badge&logo=windowsterminal "Install for command line")](https://github.com/LuaLS/lua-language-server/wiki/Getting-Started#command-line)

Check the [wiki for a guide](https://github.com/LuaLS/lua-language-server/wiki/Getting-Started#command-line) to install the language server for use on the command line. This allows the language server to be used with [other clients](https://microsoft.github.io/language-server-protocol/implementors/tools/) that follow the [language server protocol](https://microsoft.github.io/language-server-protocol/overviews/lsp/overview/).

### Community Install Methods
The install methods below are maintained by community members.

[asdf plugin](https://github.com/bellini666/asdf-lua-language-server)

## Links
- [Changelog](https://github.com/LuaLS/lua-language-server/blob/master/changelog.md)
- [Wiki](https://github.com/LuaLS/lua-language-server/wiki)
- [FAQ](https://github.com/LuaLS/lua-language-server/wiki/FAQ)
- [Report an issue][issues]
- [Suggest a feature][issues]
- [Discuss](https://github.com/LuaLS/lua-language-server/discussions)

> If you find any mistakes, please [report it][issues] or open a [pull request][pulls] if you have a fix of your own ❤️
>
> 如果你发现了任何错误，请[告诉我][issues]或使用[Pull Requests][pulls]来直接修复。❤️

[issues]: https://github.com/LuaLS/lua-language-server/issues
[pulls]: https://github.com/LuaLS/lua-language-server/pulls

## Available Languages

- `en-us` 🇺🇸
- `zh-cn` 🇨🇳
- `zh-tw` 🇹🇼
- `pt-br` 🇧🇷


> **Note**
> All translations are provided and collaborated on by the community. If you find an inappropriate or harmful translation, [please report it immediately](https://github.com/LuaLS/lua-language-server/issues).

Are you able to [provide a translation](https://github.com/LuaLS/lua-language-server/wiki/Translations)? It would be greatly appreciated!

Thank you to [all contributors of translations](https://github.com/LuaLS/lua-language-server/commits/master/locale)!


## Privacy
The language server had **opt-in** telemetry that collected usage data and sent it to the development team to help improve the extension. Read our [privacy policy](https://github.com/LuaLS/lua-language-server/wiki/Home#privacy) to learn more. Telemetry was removed in `v3.6.5` and is no longer part of the language server.


## Contributors
![GitHub Contributors Image](https://contrib.rocks/image?repo=sumneko/lua-language-server)

## Credit
Software that the language server (or the development of it) uses:

* [bee.lua](https://github.com/actboy168/bee.lua)
* [luamake](https://github.com/actboy168/luamake)
* [LPegLabel](https://github.com/sqmedeiros/lpeglabel)
* [LuaParser](https://github.com/LuaLS/LuaParser)
* [ScreenToGif](https://github.com/NickeManarin/ScreenToGif)
* [vscode-languageclient](https://github.com/microsoft/vscode-languageserver-node)
* [lua.tmbundle](https://github.com/textmate/lua.tmbundle)
* [EmmyLua](https://emmylua.github.io)
* [lua-glob](https://github.com/LuaLS/lua-glob)
* [utility](https://github.com/LuaLS/utility)
* [vscode-lua-doc](https://github.com/actboy168/vscode-lua-doc)
* [json.lua](https://github.com/actboy168/json.lua)
* [EmmyLuaCodeStyle](https://github.com/CppCXY/EmmyLuaCodeStyle)
* [inspect.lua](https://github.com/kikito/inspect.lua)
