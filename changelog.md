# changelog

## 1.7.2
`2020-12-17`
* `CHG` completion: use custom tabsize
* `FIX` [#307](https://github.com/sumneko/lua-language-server/issues/307)
* `FIX` a lot of runtime errors

## 1.7.1
`2020-12-16`
* `NEW` setting: `diagnostics.neededFileStatus`
* `FIX` scan workspace may fails
* `FIX` quickfix: `newline-call` failed
* `FIX` a lot of other runtime errors

## 1.7.0
`2020-12-16`
* `NEW` diagnostic: `undefined-field`
* `NEW` telemetry:
    + [What data will be sent](https://github.com/sumneko/lua-language-server/blob/master/script/service/telemetry.lua)
    + [How to use this data](https://github.com/sumneko/lua-telemetry-server/tree/master/method)
* `CHG` diagnostic: `unused-function` ignores function with `<close>`
* `CHG` semantic: not cover local call
* `CHG` language client: update to [7.0.0](https://github.com/microsoft/vscode-languageserver-node/commit/20681d7632bb129def0c751be73cf76bd01f2f3a)
* `FIX` semantic: tokens may not be updated correctly
* `FIX` completion: require path broken
* `FIX` hover: document uri
* `FIX` [#291](https://github.com/sumneko/lua-language-server/issues/291)
* `FIX` [#294](https://github.com/sumneko/lua-language-server/issues/294)

## 1.6.0
`2020-12-14`
* `NEW` completion: auto require local modules
* `NEW` completion: support delegate
* `NEW` hover: show function by keyword `function`
* `NEW` code action: swap params
* `CHG` standalone: unbind the relative path between binaries and scripts
* `CHG` hover: `LuaDoc` also catchs `--` (no need `---`)
* `CHG` rename: support doc
* `CHG` completion: keyword considers expression
* `FIX` [#297](https://github.com/sumneko/lua-language-server/issues/297)

## 1.5.0
`2020-12-5`
* `NEW` setting `runtime.unicodeName`
* `NEW` fully supports `---@generic T`
* `FIX` [#274](https://github.com/sumneko/lua-language-server/issues/274)
* `FIX` [#276](https://github.com/sumneko/lua-language-server/issues/276)
* `FIX` [#279](https://github.com/sumneko/lua-language-server/issues/279)
* `FIX` [#280](https://github.com/sumneko/lua-language-server/issues/280)

## 1.4.0
`2020-12-3`
* `NEW` setting `hover.previewFields`: limit how many fields are shown in table hover
* `NEW` fully supports `---@type Object[]`
* `NEW` supports `---@see`
* `NEW` diagnostic `unbalanced-assignments`
* `CHG` resolves infer of `string|table`
* `CHG` `unused-local` ignores local with `---@class`
* `CHG` locale file format changes to `lua`

## 1.3.0
`2020-12-1`

* `NEW` provides change logs, I think it's good idea for people knowing what's new ~~(bugs)~~
* `NEW` meta files of LuaJIT
* `NEW` support completion of `type(o) == ?`
* `CHG` now I think it's a bad idea as it took me nearly an hour to complete the logs started from version `1.0.0`
* `FIX` closing ignored or library file dose not clean diagnostics
* `FIX` searching of `t.f1` when `t.f1 = t.f2`
* `FIX` missing signature help of global function

## 1.2.1
`2020-11-27`

* `FIX` syntaxes tokens: [#272](https://github.com/sumneko/lua-language-server/issues/272)

## 1.2.0
`2020-11-27`

* `NEW` hover shows comments from `---@param` and `---@return`: [#135](https://github.com/sumneko/lua-language-server/issues/135)
* `NEW` support `LuaDoc` as tail comment
* `FIX` `---@class` inheritance
* `FIX` missed syntaxes token: `punctuation.definition.parameters.finish.lua`

## 1.1.4
`2020-11-25`

* `FIX` wiered completion suggests for require paths in `Linux` and `macOS`: [#269](https://github.com/sumneko/lua-language-server/issues/269)

## 1.1.3
`2020-11-25`

* `FIX` extension not works in `Ubuntu`: [#268](https://github.com/sumneko/lua-language-server/issues/268)

## 1.1.2
`2020-11-24`

* `NEW` auto completion finds globals from `Lua.diagnostics.globals`
* `NEW` support tail `LuaDoc`
* `CHG` no more `Lua.intelliScense.fastGlobal`, now globals always fast and accurate
* `CHG` `LuaDoc` supports `--- @`
* `CHG` `find reference` uses extra `Lua.intelliSense.searchDepth`
* `CHG` diagnostics are limited by `100` in each file
* `FIX` library files are under limit of `Lua.workspace.maxPreload`: [#266](https://github.com/sumneko/lua-language-server/issues/266)

## 1.1.1
`2020-11-23`

* `NEW` auto completion special marks deprecated items
* `FIX` diagnostics may push wrong uri in `Linux` and `macOS`
* `FIX` diagnostics not cleaned up when closing ignored lua file
* `FIX` reload workspace remains old caches
* `FIX` incorrect hover of local attribute

## 1.1.0
`2020-11-20`

* `NEW` no longer `BETA`
* `NEW` use `meta.lua` instead of `meta.lni`, now you can find the definition of builtin function
* `CHG` Lua files outside of workspace no longer launch a new server

## 1.0.6
`2020-11-20`

* `NEW` diagnostic `code-after-break`
* `CHG` optimize performance
* `CHG` updated language client
* `CHG` `unused-function` ignores global functions (may used out of Lua)
* `CHG` checks if client supports `Lua.completion.enable`: [#259](https://github.com/sumneko/lua-language-server/issues/259)
* `FIX` support for single Lua file
* `FIX` [#257](https://github.com/sumneko/lua-language-server/issues/257)

## 1.0.5
`2020-11-14`

* `NEW` `LuaDoc` supports more `EmmyLua`

## 1.0.4
`2020-11-12`

* `FIX` extension not works

## 1.0.3
`2020-11-12`

* `NEW` server kills itself when disconnecting
* `NEW` `LuaDoc` supports more `EmmyLua`
* `FIX` `Lua.diagnostics.enable` not works: [#251](https://github.com/sumneko/lua-language-server/issues/251)

## 1.0.2
`2020-11-11`

* `NEW` supports `---|` after `doc.type`
* `CHG` `lowcase-global` ignores globals with `---@class`
* `FIX` endless loop
* `FIX` [#244](https://github.com/sumneko/lua-language-server/issues/244)

## 1.0.1
`2020-11-10`

* `FIX` autocompletion not works.

## 1.0.0
`2020-11-9`

* `NEW` implementation, NEW start!
