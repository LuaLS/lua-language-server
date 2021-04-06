# changelog

## 1.20.3
`2021-4-6`
`FIX` [#479](https://github.com/sumneko/lua-language-server/issues/479)
`FIX` [#483](https://github.com/sumneko/lua-language-server/issues/483)
`FIX` [#485](https://github.com/sumneko/lua-language-server/issues/485)
`FIX` [#487](https://github.com/sumneko/lua-language-server/issues/487)
`FIX` [#488](https://github.com/sumneko/lua-language-server/issues/488)
`FIX` [#490](https://github.com/sumneko/lua-language-server/issues/490)
`FIX` [#495](https://github.com/sumneko/lua-language-server/issues/495)

## 1.20.2
`2021-4-2`
* `CHG` `LuaDoc`: supports `---@param self TYPE`
* `CHG` completion: does not show suggests after `\n`, `{` and `,`, unless your setting `editor.acceptSuggestionOnEnter` is `off`
* `FIX` [#482](https://github.com/sumneko/lua-language-server/issues/482)

## 1.20.1
`2021-3-27`
* `FIX` telemetry window blocks initializing
* `FIX` [#468](https://github.com/sumneko/lua-language-server/issues/468)

## 1.20.0
`2021-3-27`
* `CHG` telemetry: change to opt-in, see [#462](https://github.com/sumneko/lua-language-server/issues/462) and [Privacy-Policy](https://github.com/sumneko/lua-language-server/wiki/Privacy-Policy)
* `FIX` [#467](https://github.com/sumneko/lua-language-server/issues/467)

## 1.19.1
`2021-3-22`
* `CHG` improve performance
* `FIX` [#457](https://github.com/sumneko/lua-language-server/issues/457)
* `FIX` [#458](https://github.com/sumneko/lua-language-server/issues/458)

## 1.19.0
`2021-3-18`
* `NEW` VSCode: new setting `Lua.misc.parameters`
* `NEW` new setting `Lua.runtime.builtin`, used to disable some built-in libraries
* `NEW` quick fix: disable diagnostic in line/file
* `NEW` setting: `Lua.runtime.path` supports absolute path
* `NEW` completion: field in table
```lua
---@class A
---@field x number
---@field y number
---@field z number

---@type A
local t = {
    -- provide `x`, `y` and `z` here
}
```
* `NEW` `LuaDoc`: supports multi-line comment before resume
```lua
---this is
---a multi line
---comment
---@alias XXXX
---comment 1
---comment 1
---| '1'
---comment 2
---comment 2
---| '2'

---@param x XXXX
local function f(x)
end

f( -- view comments of `1` and `2` in completion
```
* `CHG` intelli-scense: search from generic param to return
* `CHG` intelli-scense: search across vararg
* `CHG` text-document-synchronization: refactored
* `CHG` diagnostic: improve `newline-call`
* `CHG` completion: improve `then .. end`
* `CHG` improve initialization speed
* `CHG` improve performance
* `FIX` missed syntax error `function m['x']() end`
* `FIX` [#452](https://github.com/sumneko/lua-language-server/issues/452)

## 1.18.1
`2021-3-10`
* `CHG` semantic-tokens: improve colors of `const` and `close`
* `CHG` type-formating: improve execution conditions
* `FIX` [#444](https://github.com/sumneko/lua-language-server/issues/444)

## 1.18.0
`2021-3-9`
* `NEW` `LuaDoc`: supports `---@diagnostic disable`
* `NEW` code-action: convert JSON to Lua
* `NEW` completion: provide `then .. end` snippet
* `NEW` type-formating:
    ```lua
    -- press `enter` at $
    local function f() $ end
    -- formating result:
    local function f()
        $
    end

    -- as well as
    do $ end
    -- formating result
    do
        $
    end
    ```
* `CHG` `Windows`: dose not provide `ucrt` any more
* `CHG` `Lua.workspace.library`: use `path[]` instead of `<path, true>`
* `FIX` missed syntax error `local a <const>= 1`
* `FIX` workspace: preload blocked when hitting `Lua.workspace.maxPreload`
* `FIX` [#443](https://github.com/sumneko/lua-language-server/issues/443)
* `FIX` [#445](https://github.com/sumneko/lua-language-server/issues/445)

## 1.17.4
`2021-3-4`
* `FIX` [#437](https://github.com/sumneko/lua-language-server/issues/437) again
* `FIX` [#438](https://github.com/sumneko/lua-language-server/issues/438)

## 1.17.3
`2021-3-3`
* `CHG` intelli-scense: treat `V[]` as `table<integer, V>` in `pairs`
* `FIX` completion: `detail` disappears during continuous input
* `FIX` [#435](https://github.com/sumneko/lua-language-server/issues/435)
* `FIX` [#436](https://github.com/sumneko/lua-language-server/issues/436)
* `FIX` [#437](https://github.com/sumneko/lua-language-server/issues/437)

## 1.17.2
`2021-3-2`
* `FIX` running in Windows

## 1.17.1
`2021-3-1`
* `CHG` intelli-scense: improve infer across `table<K, V>` and `V[]`.
* `CHG` intelli-scense: improve infer across `pairs` and `ipairs`
* `FIX` hover: shows nothing when hovering unknown function
* `FIX` [#398](https://github.com/sumneko/lua-language-server/issues/398)
* `FIX` [#421](https://github.com/sumneko/lua-language-server/issues/421)
* `FIX` [#422](https://github.com/sumneko/lua-language-server/issues/422)

## 1.17.0
`2021-2-24`
* `NEW` diagnostic: `duplicate-set-field`
* `NEW` diagnostic: `no-implicit-any`, disabled by default
* `CHG` completion: improve field and table
* `CHG` improve infer cross `ipairs`
* `CHG` cache globals when loading
* `CHG` completion: remove trigger character `\n` for now, see [#401](https://github.com/sumneko/lua-language-server/issues/401)
* `FIX` diagnositc: may open file with wrong uri case
* `FIX` [#406](https://github.com/sumneko/lua-language-server/issues/406)

## 1.16.1
`2021-2-22`
* `FIX` signature: parameters may be misplaced
* `FIX` completion: interface in nested table
* `FIX` completion: interface not show after `,`
* `FIX` [#400](https://github.com/sumneko/lua-language-server/issues/400)
* `FIX` [#402](https://github.com/sumneko/lua-language-server/issues/402)
* `FIX` [#403](https://github.com/sumneko/lua-language-server/issues/403)
* `FIX` [#404](https://github.com/sumneko/lua-language-server/issues/404)
* `FIX` runtime errors

## 1.16.0
`2021-2-20`
* `NEW` file encoding supports `ansi`
* `NEW` completion: supports interface, see [#384](https://github.com/sumneko/lua-language-server/issues/384)
* `NEW` `LuaDoc`: supports multiple class inheritance: `---@class Food: Burger, Pizza, Pie, Pasta`
* `CHG` rename `table*` to `tablelib`
* `CHG` `LuaDoc`: revert compatible with `--@`, see [#392](https://github.com/sumneko/lua-language-server/issues/392)
* `CHG` improve performance
* `FIX` missed syntax error `f() = 1`
* `FIX` missed global `bit` in `LuaJIT`
* `FIX` completion: may insert error text when continuous inputing
* `FIX` completion: may insert error text after resolve
* `FIX` [#349](https://github.com/sumneko/lua-language-server/issues/349)
* `FIX` [#396](https://github.com/sumneko/lua-language-server/issues/396)

## 1.15.1
`2021-2-18`
* `CHG` diagnostic: `unused-local` excludes `doc.param`
* `CHG` definition: excludes values, see [#391](https://github.com/sumneko/lua-language-server/issues/391)
* `FIX` not works on Linux and macOS

## 1.15.0
`2021-2-9`
* `NEW` LUNAR YEAR, BE HAPPY!
* `CHG` diagnostic: when there are too many errors, the main errors will be displayed first
* `CHG` main thread no longer loop sleeps, see [#329](https://github.com/sumneko/lua-language-server/issues/329) [#386](https://github.com/sumneko/lua-language-server/issues/386)
* `CHG` improve performance

## 1.14.3
`2021-2-8`
* `CHG` hint: disabled by default, see [#380](https://github.com/sumneko/lua-language-server/issues/380)
* `FIX` [#381](https://github.com/sumneko/lua-language-server/issues/381)
* `FIX` [#382](https://github.com/sumneko/lua-language-server/issues/382)
* `FIX` [#388](https://github.com/sumneko/lua-language-server/issues/388)

## 1.14.2
`2021-2-4`
* `FIX` [#356](https://github.com/sumneko/lua-language-server/issues/356)
* `FIX` [#375](https://github.com/sumneko/lua-language-server/issues/375)
* `FIX` [#376](https://github.com/sumneko/lua-language-server/issues/376)
* `FIX` [#377](https://github.com/sumneko/lua-language-server/issues/377)
* `FIX` [#378](https://github.com/sumneko/lua-language-server/issues/378)
* `FIX` [#379](https://github.com/sumneko/lua-language-server/issues/379)
* `FIX` a lot of runtime errors

## 1.14.1
`2021-2-2`
* `FIX` [#372](https://github.com/sumneko/lua-language-server/issues/372)

## 1.14.0
`2021-2-2`
* `NEW` `VSCode` hint
* `NEW` flush cache after 5 min
* `NEW` `VSCode` help semantic color with market theme
* `CHG` create/delete/rename files no longer reload workspace
* `CHG` `LuaDoc`: compatible with `--@`
* `FIX` `VSCode` settings
* `FIX` [#368](https://github.com/sumneko/lua-language-server/issues/368)
* `FIX` [#371](https://github.com/sumneko/lua-language-server/issues/371)

## 1.13.0
`2021-1-28`
* `NEW` `VSCode` status bar
* `NEW` `VSCode` options in some window
* `CHG` performance optimization
* `FIX` endless loop

## 1.12.2
`2021-1-27`
* `CHG` performance optimization
* `FIX` modifying the code before loading finish makes confusion
* `FIX` signature: not works

## 1.12.1
`2021-1-27`
* `FIX` endless loop

## 1.12.0
`2021-1-26`
* `NEW` progress
* `NEW` [#340](https://github.com/sumneko/lua-language-server/pull/340): supports `---@type table<string, number>`
* `FIX` [#355](https://github.com/sumneko/lua-language-server/pull/355)
* `FIX` [#359](https://github.com/sumneko/lua-language-server/issues/359)
* `FIX` [#361](https://github.com/sumneko/lua-language-server/issues/361)

## 1.11.2
`2021-1-7`
* `FIX` [#345](https://github.com/sumneko/lua-language-server/issues/345): not works with unexpect args
* `FIX` [#346](https://github.com/sumneko/lua-language-server/issues/346): dont modify the cache

## 1.11.1
`2021-1-5`
* `CHG` performance optimization

## 1.11.0
`2021-1-5`
* `NEW` `Lua.runtime.plugin`
* `NEW` intelli-scense: improved `m.f = function (self) end` from `self` to `m`
* `CHG` performance optimization
* `CHG` completion: improve performance of workspace words
* `FIX` hover: tail comments may be cutted
* `FIX` runtime errors

## 1.10.0
`2021-1-4`
* `NEW` workspace: supports `.dll`(`.so`) in `require`
* `NEW` folding: `---@class`, `--#region` and docs of function
* `NEW` diagnostic: `count-down-loop`
* `CHG` supports `~` in command line
* `CHG` completion: improve workspace words
* `CHG` completion: show words in string
* `CHG` completion: split `for .. in` to `for .. ipairs` and `for ..pairs`
* `CHG` diagnostic: `unused-function` checks recursive
* `FIX` [#339](https://github.com/sumneko/lua-language-server/issues/339)

## 1.9.0
`2020-12-31`
* `NEW` YEAR! Peace and love!
* `NEW` specify path of `log` and `meta` by `--logpath=xxx` and `--metapath=XXX` in command line
* `NEW` completion: worksapce word
* `NEW` completion: show words in comment
* `NEW` completion: generate function documentation
* `CHG` got arg after script name: `lua-language-server.exe main.lua --logpath=D:\log --metapath=D:\meta --develop=false`
* `FIX` runtime errors

## 1.8.2
`2020-12-29`
* `CHG` performance optimization

## 1.8.1
`2020-12-24`
* `FIX` telemetry: connect failed caused not working

## 1.8.0
`2020-12-23`
* `NEW` runtime: support nonstandard symbol
* `NEW` diagnostic: `close-non-object`
* `FIX` [#318](https://github.com/sumneko/lua-language-server/issues/318)

## 1.7.4
`2020-12-20`
* `FIX` workspace: preload may failed

## 1.7.3
`2020-12-20`
* `FIX` luadoc: typo of `package.config`
* `FIX` [#310](https://github.com/sumneko/lua-language-server/issues/310)

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
