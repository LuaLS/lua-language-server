# vscode-lua-language-server

[![Build status](https://ci.appveyor.com/api/projects/status/0tng1g72fssvu9rr/branch/master?svg=true)](https://ci.appveyor.com/project/sumneko/vscode-lua-language-server/branch/master)

### Feature

- [x] Goto Definition
- [x] Goto Implementation
- [x] Find References
- [x] Rough Type Inference
- [x] Hover
- [x] Diagnostics
- [x] Rename
- [x] Auto Completion
- [x] IntelliSense
- [x] Signature Help
- [x] Document Symbols
- [x] Support Dirty Script
- [x] Syntax Check
- [ ] Multi Workspace
- [ ] Type Format
- [ ] Accurate Type Inference
- [ ] Search Globals
- [ ] Find All References
- [ ] Code Action

### Locale

- [x] en-US
- [x] zh-CN

Please [help me][en-US] improve the quality of `en-US`.

API描述的中文翻译来自[云风](https://cloudwu.github.io/lua53doc/manual.html)。

[en-US]: https://github.com/sumneko/vscode-lua-language-server/tree/master/server/locale/en-US

### library

You can add your library at [here][libs] by `Pull Requests`. Attention, `source.type` should be `library`, this will not increase the burden of language services.

你可以通过`Pull Requests`在[这里][libs]添加自己的函数库。注意，`source.type`必须设置为`library`，这样不会增加语言服务的负担。

[libs]: https://github.com/sumneko/vscode-lua-language-server/tree/master/server/libs
