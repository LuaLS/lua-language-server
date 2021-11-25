# changelog

## 2.5.0
* `NEW` settings:
  + `Lua.runtime.pathStrict`: not check subdirectories when using `runtime.path`
  + `Lua.hint.await`: display `await` when calling a function marked as async
  + `Lua.completion.postfix`: the symbol that triggers postfix, default is `@`
* `NEW` add supports for `lovr`
* `NEW` file encoding supports `utf16le` and `utf16be`
* `NEW` full IntelliSense supports for literal tables, see [#720](https://github.com/sumneko/lua-language-server/issues/720) and [#727](https://github.com/sumneko/lua-language-server/issues/727)
* `NEW` `LuaDoc` annotations:
  + `---@async`: mark a function as async
  + `---@nodiscard`: the return value of the marking function cannot be discarded
* `NEW` diagnostics:
  + `await-in-sync`: check whether calls async function in sync function. disabled by default.
  + `not-yieldable`: check whether the function supports async functions as parameters. disabled by default.
  + `discard-returns`: check whether the return value is discarded.
* `NEW` locale `pt-br`, thanks [Jeferson Ferreira](https://github.com/jefersonf)
* `NEW` supports [utf-8-offsets](https://clangd.llvm.org/extensions#utf-8-offsets)
* `NEW` supports quickfix for `.luarc.json`
* `NEW` completion postifx: `@function`, `@method`, `@pcall`, `@xpcall`, `@insert`, `@remove`, `@concat`, `++`, `++?`
* `CHG` `LuaDoc`:
  + `---@class` can be re-declared
  + supports unicode
  + supports `---@param ... number`, equivalent to `---@vararg number`
  + supports `fun(...: string)`
  + supports `fun(x, y, ...)`, equivalent to `fun(x: any, y: any, ...: any)`
* `CHG` settings from `--configpath`, `.luarc.json`, `client` no longer prevent subsequent settings, instead they are merged in order
* `CHG` no longer asks to trust plugin in VSCode, because VSCode already provides the workspace trust feature
* `CHG` skip huge files (>= 10 MB)
* `CHG` after using `Lua.runtime.nonstandardSymbol` to treat `//` as a comment, `//` is no longer parsed as an operator

## 2.4.11
`2021-11-25`
* `FIX` [#816](https://github.com/sumneko/lua-language-server/issues/816)
* `FIX` [#817](https://github.com/sumneko/lua-language-server/issues/817)
* `FIX` [#818](https://github.com/sumneko/lua-language-server/issues/818)
* `FIX` [#820](https://github.com/sumneko/lua-language-server/issues/820)

## 2.4.10
`2021-11-23`
* `FIX` [#790](https://github.com/sumneko/lua-language-server/issues/790)
* `FIX` [#798](https://github.com/sumneko/lua-language-server/issues/798)
* `FIX` [#804](https://github.com/sumneko/lua-language-server/issues/804)
* `FIX` [#805](https://github.com/sumneko/lua-language-server/issues/805)
* `FIX` [#806](https://github.com/sumneko/lua-language-server/issues/806)
* `FIX` [#807](https://github.com/sumneko/lua-language-server/issues/807)
* `FIX` [#809](https://github.com/sumneko/lua-language-server/issues/809)

## 2.4.9
`2021-11-18`
* `CHG` for performance reasons, some of the features that are not cost-effective in IntelliSense have been disabled by default, and you can re-enable them through the following settings:
  + `Lua.IntelliSense.traceLocalSet`
  + `Lua.IntelliSense.traceReturn`
  + `Lua.IntelliSense.traceBeSetted`
  + `Lua.IntelliSense.traceFieldInject`

  [read more](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features)

## 2.4.8
`2021-11-15`
* `FIX` incorrect IntelliSense in specific situations
* `FIX` [#777](https://github.com/sumneko/lua-language-server/issues/777)
* `FIX` [#778](https://github.com/sumneko/lua-language-server/issues/778)
* `FIX` [#779](https://github.com/sumneko/lua-language-server/issues/779)
* `FIX` [#780](https://github.com/sumneko/lua-language-server/issues/780)

## 2.4.7
`2021-10-27`
* `FIX` [#762](https://github.com/sumneko/lua-language-server/issues/762)

## 2.4.6
`2021-10-26`
* `NEW` diagnostic: `redundant-return`
* `FIX` [#744](https://github.com/sumneko/lua-language-server/issues/744)
* `FIX` [#748](https://github.com/sumneko/lua-language-server/issues/748)
* `FIX` [#749](https://github.com/sumneko/lua-language-server/issues/749)
* `FIX` [#752](https://github.com/sumneko/lua-language-server/issues/752)
* `FIX` [#753](https://github.com/sumneko/lua-language-server/issues/753)
* `FIX` [#756](https://github.com/sumneko/lua-language-server/issues/756)
* `FIX` [#758](https://github.com/sumneko/lua-language-server/issues/758)
* `FIX` [#760](https://github.com/sumneko/lua-language-server/issues/760)

## 2.4.5
`2021-10-18`
* `FIX` accidentally load lua files from user workspace

## 2.4.4
`2021-10-15`
* `CHG` improve `.luarc.json`
* `FIX` [#722](https://github.com/sumneko/lua-language-server/issues/722)

## 2.4.3
`2021-10-13`
* `FIX` [#713](https://github.com/sumneko/lua-language-server/issues/713)
* `FIX` [#718](https://github.com/sumneko/lua-language-server/issues/718)
* `FIX` [#719](https://github.com/sumneko/lua-language-server/issues/719)
* `FIX` [#725](https://github.com/sumneko/lua-language-server/issues/725)
* `FIX` [#729](https://github.com/sumneko/lua-language-server/issues/729)
* `FIX` [#730](https://github.com/sumneko/lua-language-server/issues/730)
* `FIX` runtime errors

## 2.4.2
`2021-10-8`
* `FIX` [#702](https://github.com/sumneko/lua-language-server/issues/702)
* `FIX` [#706](https://github.com/sumneko/lua-language-server/issues/706)
* `FIX` [#707](https://github.com/sumneko/lua-language-server/issues/707)
* `FIX` [#709](https://github.com/sumneko/lua-language-server/issues/709)
* `FIX` [#712](https://github.com/sumneko/lua-language-server/issues/712)

## 2.4.1
`2021-10-2`
* `FIX` broken with single file
* `FIX` [#698](https://github.com/sumneko/lua-language-server/issues/698)
* `FIX` [#699](https://github.com/sumneko/lua-language-server/issues/699)

## 2.4.0
`2021-10-1`
* `NEW` loading settings from `.luarc.json`
* `NEW` settings:
  + `Lua.diagnostics.libraryFiles`
  + `Lua.diagnostics.ignoredFiles`
  + `Lua.completion.showWord`
  + `Lua.completion.requireSeparator`
* `NEW` diagnostics:
  + `different-requires`
* `NEW` `---@CustomClass<string, number>`
* `NEW` supports `$/cancelRequest`
* `NEW` `EventEmitter`
    ```lua
    --- @class Emit
    --- @field on fun(eventName: string, cb: function)
    --- @field on fun(eventName: '"died"', cb: fun(i: integer))
    --- @field on fun(eventName: '"won"', cb: fun(s: string))
    local emit = {}

    emit:on(--[[support autocomplete fr "died" and "won"]])

    emit:on("died", function (i)
        -- should be i: integer
    end)

    emit:on('won', function (s)
        -- should be s: string
    end)
    ```
* `NEW` `---@module 'moduleName'`
    ```lua
    ---@module 'mylib'
    local lib -- the same as `local lib = require 'mylib'`
    ```
* `NEW` add supports of `skynet`
* `CHG` hover: improve showing multi defines
* `CHG` hover: improve showing multi comments at enums
* `CHG` hover: shows method
* `CHG` hint: `Lua.hint.paramName` now supports `Disable`, `Literal` and `All`
* `CHG` only search first file by `require`
* `CHG` no longer infer by usage
* `CHG` no longer ignore file names case in Windows
* `CHG` watching library changes
* `CHG` completion: improve misspelling results
* `CHG` completion: `Lua.completion.displayContext` default to `0`
* `CHG` completion: `autoRequire` has better inserting position
* `CHG` diagnostics:
  + `redundant-parameter` default severity to `Warning`
  + `redundant-value` default severity to `Warning`
* `CHG` infer: more strict of calculation results
* `CHG` [#663](https://github.com/sumneko/lua-language-server/issues/663)
* `FIX` runtime errors
* `FIX` hint: may show param-2 as `self`
* `FIX` semantic: may fail when scrolling
* `FIX` [#647](https://github.com/sumneko/lua-language-server/issues/647)
* `FIX` [#660](https://github.com/sumneko/lua-language-server/issues/660)
* `FIX` [#673](https://github.com/sumneko/lua-language-server/issues/673)

## 2.3.7
`2021-8-17`
* `CHG` improve performance
* `FIX` [#244](https://github.com/sumneko/lua-language-server/issues/244)

## 2.3.6
`2021-8-9`
* `FIX` completion: can not find global fields
* `FIX` globals and class may lost

## 2.3.5
`2021-8-9`
* `CHG` improve memory usage
* `CHG` completion: call snip triggers signature (VSCode only)
* `FIX` completion: may not find results

## 2.3.4
`2021-8-6`
* `CHG` improve performance
* `FIX` [#625](https://github.com/sumneko/lua-language-server/issues/625)

## 2.3.3
`2021-7-26`
* `NEW` config supports prop
* `FIX` [#612](https://github.com/sumneko/lua-language-server/issues/612)
* `FIX` [#613](https://github.com/sumneko/lua-language-server/issues/613)
* `FIX` [#618](https://github.com/sumneko/lua-language-server/issues/618)
* `FIX` [#620](https://github.com/sumneko/lua-language-server/issues/620)

## 2.3.2
`2021-7-21`
* `NEW` `LuaDoc`: supports `['string']` as field:
    ```lua
    ---@class keyboard
    ---@field ['!'] number
    ---@field ['?'] number
    ---@field ['#'] number
    ```
* `NEW` add supports of `love2d`
* `FIX` gitignore pattern `\` broken initialization
* `FIX` runtime errors

## 2.3.1
`2021-7-19`
* `NEW` setting `Lua.workspace.userThirdParty`, add private user [third-parth](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd) by this setting
* `CHG` path in config supports `~/xxxx`
* `FIX` `autoRequire` inserted incorrect code
* `FIX` `autoRequire` may provide dumplicated options
* `FIX` [#606](https://github.com/sumneko/lua-language-server/issues/606)
* `FIX` [#607](https://github.com/sumneko/lua-language-server/issues/607)

## 2.3.0
`2021-7-16`
* `NEW` `VSCode`: click the status bar icon to operate:
    * run workspace diagnostics
* `NEW` `LuaDoc`: supports `[1]` as field:
    ```lua
    ---@class position
    ---@field [1] number
    ---@field [2] number
    ---@field [3] number
    ```
* `NEW` hover: view array `local array = {'a', 'b', 'c'}`:
    ```lua
    local array: {
        [1]: string = "a",
        [2]: string = "b",
        [3]: string = "c",
    }
    ```
* `NEW` completion: supports enums in `fun()`
    ```lua
    ---@type fun(x: "'aaa'"|"'bbb'")
    local f

    f(--[[show `'aaa'` and `'bbb'` here]])
    ```
* `FIX` loading workspace may hang
* `FIX` `debug.getuservalue` and `debug.setuservalue` should not exist in `Lua 5.1`
* `FIX` infer of `---@type class[][]`
* `FIX` infer of `---@type {}[]`
* `FIX` completion: displaying `@fenv` in `Lua 5.1`
* `FIX` completion: incorrect at end of line
* `FIX` when a file is renamed, the file will still be loaded even if the new file name has been set to ignore
* `FIX` [#596](https://github.com/sumneko/lua-language-server/issues/596)
* `FIX` [#597](https://github.com/sumneko/lua-language-server/issues/597)
* `FIX` [#598](https://github.com/sumneko/lua-language-server/issues/598)
* `FIX` [#601](https://github.com/sumneko/lua-language-server/issues/601)

## 2.2.3
`2021-7-9`
* `CHG` improve `auto require`
* `CHG` will not sleep anymore
* `FIX` incorrect doc: `debug.getlocal`
* `FIX` completion: incorrect callback
* `FIX` [#592](https://github.com/sumneko/lua-language-server/issues/592)

## 2.2.2
`2021-7-9`
* `FIX` incorrect syntax color
* `FIX` incorrect type infer

## 2.2.1
`2021-7-8`
* `FIX` change setting may failed

## 2.2.0
`2021-7-8`
* `NEW` detect and apply third-party libraries, including:
  * OpenResty
  * Cocos4.0
  * Jass
* `NEW` `LuaDoc`: supports literal table:
    ```lua
    ---@generic T
    ---@param x T
    ---@return { x: number, y: T, z?: boolean}
    local function f(x) end

    local t = f('str')
    -- hovering "t" shows:
    local t: {
        x: number,
        y: string,
        z?: boolean,
    }
    ```
* `CHG` improve changing config from server side
* `CHG` improve hover color
* `CHG` improve performance
* `CHG` telemetry: sends version of this extension
* `FIX` supports for file with LF
* `FIX` may infer a custom class as a string

## 2.1.0
`2021-7-2`
* `NEW` supports local config file, using `--configpath="config.json"`, [learn more here](https://github.com/sumneko/lua-language-server/wiki/Setting-without-VSCode)
* `NEW` goto `type definition`
* `NEW` infer type by callback param:
    ```lua
    ---@param callback fun(value: string)
    local function work(callback)
    end

    work(function (value)
        -- value is string here
    end)
    ```
* `NEW` optional field `---@field name? type`
* `CHG` [#549](https://github.com/sumneko/lua-language-server/issues/549)
* `CHG` diagnostics: always ignore the ignored files even if they are opened
* `FIX` completion: `type() ==` may does not work

## 2.0.5
`2021-7-1`
* `NEW` `hover` and `completion` reports initialization progress
* `CHG` `class field` consider implicit definition
    ```lua
    ---@class Class
    local mt = {}

    function mt:init()
        self.xxx = 1
    end

    function mt:func()
        print(self.xxx) -- self.xxx is defined
    end
    ```
* `CHG` improve performance
* `FIX` [#580](https://github.com/sumneko/lua-language-server/issues/580)

## 2.0.4
`2021-6-25`
* `FIX` [#550](https://github.com/sumneko/lua-language-server/issues/550)
* `FIX` [#555](https://github.com/sumneko/lua-language-server/issues/555)
* `FIX` [#574](https://github.com/sumneko/lua-language-server/issues/574)

## 2.0.3
`2021-6-24`
* `CHG` improve memory usage
* `FIX` some dialog boxes block the initialization process
* `FIX` diagnostics `undefined-field`: blocks main thread
* `FIX` [#565](https://github.com/sumneko/lua-language-server/issues/565)

## 2.0.2
`2021-6-23`
* `NEW` supports literal table in `pairs`
    ```lua
    local t = { a = 1, b = 2, c = 3 }
    for k, v in pairs(t) do
        -- `k` is string and `v` is integer here
    end
    ```
* `CHG` view `local f ---@type fun(x:number):boolean`
    ```lua
    ---before
    function f(x: number)
      -> boolean
    ---after
    local f: fun(x: number): boolean
    ```
* `FIX` [#558](https://github.com/sumneko/lua-language-server/issues/558)
* `FIX` [#567](https://github.com/sumneko/lua-language-server/issues/567)
* `FIX` [#568](https://github.com/sumneko/lua-language-server/issues/568)
* `FIX` [#570](https://github.com/sumneko/lua-language-server/issues/570)
* `FIX` [#571](https://github.com/sumneko/lua-language-server/issues/571)

## 2.0.1
`2021-6-21`
* `FIX` [#566](https://github.com/sumneko/lua-language-server/issues/566)

## 2.0.0
`2021-6-21`
* `NEW` implement
* `CHG` diagnostics `undefined-field`, `deprecated`: default by `Opened` instead of `None`
* `CHG` setting `Lua.runtime.plugin`: default by `""` instead of `".vscode/lua/plugin.lua"` (for security)
* `CHG` setting `Lua.intelliSense.searchDepth`: removed
* `CHG` setting `Lua.misc.parameters`: `string array` instead of `string`
* `CHG` setting `Lua.develop.enable`, `Lua.develop.debuggerPort`, `Lua.develop.debuggerWait`: removed, use `Lua.misc.parameters` instead
* `FIX` [#441](https://github.com/sumneko/lua-language-server/issues/441)
* `FIX` [#493](https://github.com/sumneko/lua-language-server/issues/493)
* `FIX` [#531](https://github.com/sumneko/lua-language-server/issues/531)
* `FIX` [#542](https://github.com/sumneko/lua-language-server/issues/542)
* `FIX` [#543](https://github.com/sumneko/lua-language-server/issues/543)
* `FIX` [#553](https://github.com/sumneko/lua-language-server/issues/553)
* `FIX` [#562](https://github.com/sumneko/lua-language-server/issues/562)
* `FIX` [#563](https://github.com/sumneko/lua-language-server/issues/563)

## 1.21.3
`2021-6-17`
* `NEW` supports `untrusted workspaces`
* `FIX` performance issues, thanks to [folke](https://github.com/folke)

## 1.21.2
`2021-5-18`
* `FIX` loaded new file with ignored filename
* `FIX` [#536](https://github.com/sumneko/lua-language-server/issues/536)
* `FIX` [#537](https://github.com/sumneko/lua-language-server/issues/537)
* `FIX` [#538](https://github.com/sumneko/lua-language-server/issues/538)
* `FIX` [#539](https://github.com/sumneko/lua-language-server/issues/539)

## 1.21.1
`2021-5-8`
* `FIX` [#529](https://github.com/sumneko/lua-language-server/issues/529)

## 1.21.0
`2021-5-7`
* `NEW` setting: `completion.showParams`
* `NEW` `LuaDoc`: supports multiline comments
* `NEW` `LuaDoc`: tail comments support lua string

## 1.20.5
`2021-4-30`
* `NEW` setting: `completion.autoRequire`
* `NEW` setting: `hover.enumsLimit`
* `CHG` folding: supports `-- #region`
* `FIX` completion: details may be suspended
* `FIX` [#522](https://github.com/sumneko/lua-language-server/issues/522)
* `FIX` [#523](https://github.com/sumneko/lua-language-server/issues/523)

## 1.20.4
`2021-4-13`
* `NEW` diagnostic: `deprecated`
* `FIX` [#464](https://github.com/sumneko/lua-language-server/issues/464)
* `FIX` [#497](https://github.com/sumneko/lua-language-server/issues/497)
* `FIX` [#502](https://github.com/sumneko/lua-language-server/issues/502)

## 1.20.3
`2021-4-6`
* `FIX` [#479](https://github.com/sumneko/lua-language-server/issues/479)
* `FIX` [#483](https://github.com/sumneko/lua-language-server/issues/483)
* `FIX` [#485](https://github.com/sumneko/lua-language-server/issues/485)
* `FIX` [#487](https://github.com/sumneko/lua-language-server/issues/487)
* `FIX` [#488](https://github.com/sumneko/lua-language-server/issues/488)
* `FIX` [#490](https://github.com/sumneko/lua-language-server/issues/490)
* `FIX` [#495](https://github.com/sumneko/lua-language-server/issues/495)

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
