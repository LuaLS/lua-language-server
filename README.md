# lua-language-server

[![Build status](https://ci.appveyor.com/api/projects/status/0tng1g72fssvu9rr/branch/master?svg=true)](https://ci.appveyor.com/project/sumneko/vscode-lua-language-server/branch/master)

### Feature

- [x] Goto Definition
- [x] Goto Implementation
- [x] Find All References
- [x] Type Inference
- [x] Hover
- [x] Diagnostics
- [x] Rename
- [x] Auto Completion
- [x] IntelliSense
- [x] Signature Help
- [x] Document Symbols
- [x] Support Dirty Script
- [x] Syntax Check
- [x] Search Globals
- [x] Highlight
- [ ] Multi Workspace
- [ ] Type Format
- [ ] Code Action

### Locale

- [x] en-US
- [x] zh-CN

Please [help me][en-US] improve the quality of `en-US`.

API描述的中文翻译来自[云风](https://cloudwu.github.io/lua53doc/manual.html)。

[en-US]: https://github.com/sumneko/vscode-lua-language-server/tree/master/server/locale/en-US

### library

You can add your library at [here][libs] by `Pull Requests`.

你可以通过`Pull Requests`在[这里][libs]添加自己的函数库。

[libs]: https://github.com/sumneko/vscode-lua-language-server/tree/master/server/libs

### Notice
I'm fighting against memory leaks in the current version. If the memory footprint is too high, please end the process of language service manually. VSCode will automatically restart the language service. Sorry for the inconvenience.

我正在与目前版本的内存泄漏做斗争，如果内存占用过高，请手动结束语言服务的进程，VSCode会自动重启语言服务。给您带来的不便敬请谅解。
