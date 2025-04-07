# changelog

## Unreleased
<!-- Add all new changes here. They will be moved under a version at release -->

## 3.14.0
`2025-4-7`
* `NEW` locale `es-419`, thanks [Felipe Lema](https://codeberg.org/FelipeLema)
* `FIX` prevent unnecessary edits by LSP formatting when content did not change
* `FIX` return no completions if completion is disabled
* `FIX` optimized the performance of large literal tables (e.g., configuration tables)

## 3.13.9
`2025-3-13`
* `CHG` remove the limit for analyzing the literal table

## 3.13.8
`2025-3-12`
* `CHG` when analyzing the literal table, only the first 100 items are analyzed at most
* `CHG` when checking type matching for union types, only the first 100 items are checked at most
* `FIX` Update `--help` message.
* `FIX` --check now respects ignoreDir setting
* `FIX` incorrect argument skip pattern for `--check_out_path=`, which incorrectly skips the next argument

## 3.13.7
`2025-3-10`
* `NEW` CLI: added `--help`.
* `CHG` default path for `--doc_out_path` is the current directory
* `FIX` incorrect argument skip pattern for `--check_out_path=`, which incorrectly skips the next argument
* `FIX` incorrect error message for `--doc_update`.
* `FIX` reimplement section `luals.config` in file doc.json
* `FIX` incorrect file names in file doc.json
* `FIX` remove extra `./` path prefix in the check report when using `--check=.`
* `FIX` Narrowing of types with literal fields: [#3056](https://github.com/LuaLS/lua-language-server/issues/3056), [#3089](https://github.com/LuaLS/lua-language-server/issues/3089)
* `FIX` correct lua version of `math.ult` and `math.type`
* `FIX` incorrect links for `pattern` in `string` methods
* `FIX` fix type annotations for bit module
* `FIX` Another regression related to type narrow and generic param introduced since `v3.10.1` [#3087](https://github.com/LuaLS/lua-language-server/issues/3087)

## 3.13.6
`2025-2-6`
* `NEW` `---@class` supports attribute `partial`, which will not check missing inherited fields [#3023](https://github.com/LuaLS/lua-language-server/issues/3023)
  ```lua
  ---@class Config
  ---@field a number

  ---@class (partial) Config.P: Config
  ---@field b number

  ---@type Config.P[]
  local cfgs = {}
  cfgs[1] = { b = 1 } -- no warning
  cfgs[2] = {}        -- only warns missing `b`
  ```
  This enables the previous missing field check behavior before [#2970](https://github.com/LuaLS/lua-language-server/issues/2970)
* `NEW` Added variable substitution support for vscode's `${workspaceFolder:x}` when resolving path placeholders [#2987](https://github.com/LuaLS/lua-language-server/issues/2987)
* `NEW` Added `--check_format=json|pretty` for use with `--check` to output diagnostics in a human readable format.
* `NEW` Test CLI: `--name=<testname>` `-n=<testname>`: run specify unit test
* `CHG` Generic pattern now supports definition after capture and optional, union, array [#3014](https://github.com/LuaLS/lua-language-server/issues/3014) [#3031](https://github.com/LuaLS/lua-language-server/pull/3031)
  ```lua
  ---@generic T
  ---@param t `T`.Cat?
  ---@return T?
  local function f(t) end

  local t = f('Smile') --> t is `(Smile.Cat)?`
  ```
* `FIX` Fixed the error that the configuration file pointed to by the `--configpath` option was not read and loaded.
* `FIX` Don't truncate any output when running in `--doc` mode [#3049](https://github.com/LuaLS/lua-language-server/issues/3049)
* `FIX` Generic return can be optional.
* `FIX` Fixed the comment calculating in docs `---@param a string?Comment` - now its `Comment` instead of `omment` [#3028](https://github.com/LuaLS/lua-language-server/pull/3028)
* `FIX` Fixed cannot bind variables using tail comment `@class` [#2673](https://github.com/LuaLS/lua-language-server/issues/2673)
* `FIX` Fixed missing field completion for generic class object [#2196](https://github.com/LuaLS/lua-language-server/issues/2196) [#2945](https://github.com/LuaLS/lua-language-server/issues/2945) [#3041](https://github.com/LuaLS/lua-language-server/issues/3041)

## 3.13.5
`2024-12-20`
* `NEW` Setting: `Lua.hint.awaitPropagate`: When enabled, `--@async` propagates to the caller.
* `CHG` Add server version information to `initialize` response [#2996](https://github.com/LuaLS/lua-language-server/pull/2996)
* `CHG` If the `---@field` of the same name has a type of `fun`, the `duplicate-doc-field` check will not be performed.
* `FIX` Incorrect infer for function array annotation on tables [#2367](https://github.com/LuaLS/lua-language-server/issues/2367)

## 3.13.4
`2024-12-13`
* `CHG` Can adjust the level of detail of Hover (VSCode)

## 3.13.3
`2024-12-6`
* `CHG` Update Love2d version
* `CHG` Improve type infer of `table.unpack` and `unpack`
* `FIX` `missing-fields` diagnostic now warns about missing inherited fields
* `FIX` Incorrect `param-type-mismatch` diagnostic for optional fields

## 3.13.2
`2024-11-21`
* `CHG` fulfill zh-cn translations
* `FIX` Add missing `errs ~= nil` checks to script/vm/type checkTableShape

## 3.13.1
`2024-11-13`
* `FIX` Incorrect type check in some case

## 3.13.0
`2024-11-13`
* `NEW` Setting: `Lua.type.inferTableSize`: A Small Table array can be infered
* `NEW` Add custom repository support for addonManager. New configuration setting: `Lua.addonManager.repositoryBranch` and `Lua.addonManager.repositoryPath`
* `NEW` Infer function parameter types when the function is used as an callback argument and that argument has a `fun()` annotation. Enable with `Lua.type.inferParamType` setting. [#2695](https://github.com/LuaLS/lua-language-server/pull/2695)
  ```lua
  ---@param callback fun(a: integer)
  function register(callback) end

  local function callback(a) end  --> a: integer
  register(callback)
  ```
* `CHG` Basic types allow contravariance
  ```lua
  ---@class int32: integer

  ---@type integer
  local n

  ---@type int32
  local a = n
  ```
* `FIX` Improve type narrow with **literal alias type** during completion and signature help

## 3.12.0
`2024-10-30`
* `NEW` Support importing `enum` through class name suffix matching in quick fixes, allowing the import of `enum` from `table.table.enum; return table`.
* `NEW` Support limited multiline annotations
  ```lua
  ---@type {
  --- x: number,
  --- y: number,
  --- z: number,
  ---}
  local point --> local point: { x: number, y: number, z: number }
  ```
* `FIX` A regression related to type narrow and generic param introduced since `v3.10.1`
* `FIX` Parse storagePath to improve reliability of resolving ${addons} placeholder
* `FIX` Reference should also look in tablefield
* `FIX` Determine that the index of `{...}` is an integer when iterating

## 3.11.1
`2024-10-9`
* `FIX` Fixed an issue preventing to set the locale to Japanese
* `FIX` Preserve newlines between function comment and @see
* `FIX` Accept storagePath option from client to resolve addon directory not found

## 3.11.0
`2024-9-30`
* `NEW` Added support for Japanese locale
* `NEW` Infer function parameter types when overriding the same-named class function in an instance of that class [#2158](https://github.com/LuaLS/lua-language-server/issues/2158)
* `NEW` Types with literal fields can be narrowed.
* `NEW` Reference addons installed via the addon manager with `${addons}` [#2866](https://github.com/LuaLS/lua-language-server/pull/2866).
* `NEW` Support using `---@class` on `rawset(_G, ...)` to annotate the created global variable [#2862](https://github.com/LuaLS/lua-language-server/issues/2862)
* `NEW` Settings:
  + `Lua.language.fixIndent`
  + `Lua.language.completeAnnotation`
* `FIX` Eliminate floating point error in test benchmark output
* `FIX` Remove luamake install from make scripts
* `FIX` Incorrect `table` type injected to the global variable created by `rawset(_G, ...)` [#2863](https://github.com/LuaLS/lua-language-server/issues/2863)

## 3.10.6
`2024-9-10`
* `NEW` Custom documentation exporter
* `NEW` Setting: `Lua.docScriptPath`: Path to a script that overrides `cli.doc.export`, allowing user-specified documentation exporting.
* `NEW` Infer the parameter types of a same-named function in the subclass based on the parameter types in the superclass function.
* `FIX` Fix `VM.OnCompileFunctionParam` function in plugins
* `FIX` Lua 5.1: fix incorrect warning when using setfenv with an int as first parameter
* `FIX` Improve type narrow by checking exact match on literal type params
* `FIX` Correctly list enums for function overload arguments [#2840](https://github.com/LuaLS/lua-language-server/pull/2840)
* `FIX` Incorrect function params' type infer when there is only `@overload` [#2509](https://github.com/LuaLS/lua-language-server/issues/2509) [#2708](https://github.com/LuaLS/lua-language-server/issues/2708) [#2709](https://github.com/LuaLS/lua-language-server/issues/2709)
* `FIX` Only call workspace/configuration when available [#981](https://github.com/LuaLS/lua-language-server/issues/981), [#2318](https://github.com/LuaLS/lua-language-server/issues/2318), [2336](https://github.com/LuaLS/lua-language-server/issues/2336) [#2843](https://github.com/LuaLS/lua-language-server/pull/2843)

## 3.10.5
`2024-8-19`
* `NEW` using `enum (partial)`, it suggests all fields with the same `enum` type rather than just the fields from the current table.
* `NEW` When using `enum["<key>" or <index>]`, undefined fields will raise an 'undefined' error.
* `FIX` Renaming files in the directory leads to the auto-correction in "require" adding extra characters.
* `FIX` Performance issue
* `FIX` Fix incorrect indent fixing for `for`

## 3.10.4
`2024-8-16`
* `NEW` Setting: `Lua.type.checkTableShape`: Add matching checks between the shape of tables and classes, during type checking. [#2768](https://github.com/LuaLS/lua-language-server/pull/2768)
* `NEW` `undefined-field` supports `enum`
* `CHG` Show enumed table as `enum X` instead of `table`
* `FIX` Error `attempt to index a nil value` when `Lua.hint.semicolon == 'All'` [#2788](https://github.com/LuaLS/lua-language-server/issues/2788)
* `FIX` Incorrect LuaCats parsing for `"'"`
* `FIX` Incorrect indent fixings

## 3.10.3
`2024-8-8`
* `FIX` Memory leak with `---@enum(partical)`

## 3.10.2
`2024-8-7`
* `NEW` Add support for binary metamethod on right operand [#2777](https://github.com/LuaLS/lua-language-server/pull/2777)
* `FIX` Incorrect indentation fixing in some case

## 3.10.1
`2024-8-2`
* `FIX` Runtime error
* `FIX` Disable indentation fixing for Non-VSCode

## 3.10.0
`2024-8-1`
* `NEW` Add postfix snippet for `unpack`
* `NEW` Add support for lambda style functions, `|paramList| expr` is syntactic sugar for `function(paramList) return expr end`
* `NEW` Added lua regular expression support for `Lua.doc.<scope>Name` [#2753](https://github.com/LuaLS/lua-language-server/pull/2753)
* `NEW` You can now click on "References" in CodeLen to display the reference list（VSCode）
* `NEW` Improved behavior for inserting new lines:
  + When inside an annotation, an annotation tag will be added at the beginning of the line (VSCode).
  + When between `function () end` or similar constructs, the format will be adjusted to a more reasonable one (VSCode) and leading/trailing spaces will be removed (generic).
  + Attempts to semantically fix improper indentation (generic).
* `CHG` Improve performance of multithreaded `--check` and `undefined-field` diagnostic
* `CHG` Change spacing of parameter inlay hints to match other LSPs, like `rust-analyzer`
* `FIX` `diagnostics.severity` defaulting to "Warning" when run using `--check` [#2730](https://github.com/LuaLS/lua-language-server/issues/2730)
* `FIX` Respect `completion.showParams` config for local function completion
* `FIX` Addons can now self-recommend as expected. Fixed by correcting the `wholeMatch` function
* `FIX` Now correctly evaluates the visibility of fields in a class when they are defined directly in the object. use for completion and invisible dianostic. [#2752](https://github.com/LuaLS/lua-language-server/issues/2752)
* `FIX` Bad triggering of the `inject-field` diagnostic, when the fields are declared at the creation of the object [#2746](https://github.com/LuaLS/lua-language-server/issues/2746)
* `FIX` Inconsistent type narrow behavior of function call args [#2758](https://github.com/LuaLS/lua-language-server/issues/2758)
* `FIX` Improve the `missing-fields` logic to be able to correctly handle classes defined several times [#22770](https://github.com/LuaLS/lua-language-server/pull/2770)
* `FIX` Typos in annotation descriptions
* `FIX` incorrect `CompletionItemKind` for postfix snippets [#2773](https://github.com/LuaLS/lua-language-server/pull/2773)

## 3.9.3
`2024-6-11`
* `FIX` Sometimes providing incorrect autocompletion when chaining calls

## 3.9.2
`2024-6-6`
* `NEW` Reference workspace symbols in comments using `[some text](lua://symbolName)` syntax
* `FIX` Don't do diagnostics when the workspace is not ready
* `FIX` Autocompletion for enum values ​​is not available in some cases

## 3.9.1
`2024-5-14`
* revert extension runtime

## 3.9.0
`2024-5-11`
* `NEW` goto implementation
* `NEW` narrow the function prototype based on the parameter type
  ```lua
  ---@overload fun(a: boolean): A
  ---@overload fun(a: number): B
  local function f(...) end

  local r1 = f(true) --> r1 is `A`
  local r2 = f(10) --> r2 is `B`
  ```

## 3.8.3
`2024-4-23`
* `FIX` server may crash when the workspace is using a non-English path.

## 3.8.2
`2024-4-23`
* This is a fake version only for the new version of VSCode, with a core of 3.8.0.

## 3.8.1
`2024-4-23`
* This is a fake version only for the old version of VSCode, with a core of `3.7.4`. Starting from the next minor version, the version requirement for VSCode will be raised to prevent users still using the old version of VSCode from updating to the new version and experiencing compatibility issues.

## 3.8.0
`2024-4-22`
* `NEW` supports tuple type (@[lizho])
  ```lua
  ---@type [string, number, boolean]
  local t

  local x = t[1] --> x is `string`
  local y = t[2] --> y is `number`
  local z = t[3] --> z is `boolean`
  ```
* `NEW` generic pattern (@[fesily])
  ```lua
  ---@generic T
  ---@param t Cat.`T`
  ---@return T
  local function f(t) end

  local t = f('Smile') --> t is `Cat.Smile`
  ```
* `NEW` alias and enums supports attribute `partial`
  ```lua
  ---@alias Animal Cat

  ---@alias(partial) Animal Dog

  ---@type Animal
  local animal --> animal is `Cat|Dog` here
  ```

  ```lua
  ---@enum(key) ErrorCodes
  local codes1 = {
      OK = 0,
      ERROR = 1,
      FATAL = 2,
  }

  ---@enum(key, partial) ErrorCodes
  local codes2 = {
      WARN = 3,
      INFO = 4,
  }

  ---@type ErrorCodes
  local code

  code = 'ERROR' --> OK
  code = 'WARN'  --> OK

  ```
* `NEW` plugin: add `OnTransFormAst` interface (@[fesily])
* `NEW` plugin: add `OnNodeCompileFunctionParam` interface (@[fesily])
* `NEW` plugin: add `ResolveRequire` interface (@[Artem Dzhemesiuk])
* `NEW` plugin: support multi plugins (@[fesily])
  + setting: `Lua.runtime.plugin` can be `string|string[]`
  + setting: `Lua.runtime.pluginArgs` can be `string[]|table<string, string>`
* `NEW` CLI: `--doc` add option `--doc_out_path <PATH>` (@[Andreas Matthias])
* `NEW` CLI: `--doc_update`, update an existing `doc.json` without using `--doc` again (@[Andreas Matthias])
* `NEW` CLI: `--trust_all_plugins`, this is potentially unsafe for normal use and meant for usage in CI environments only (@[Paul Emmerich])
* `CHG` CLI: `--check` will run plugins (@[Daniel Farrell])
* `FIX` diagnostic: `discard-returns` not works in some blocks (@clay-golem)
* `FIX` rename in library files

## 3.7.4
`2024-1-5`
* `FIX` rename to unicode with `Lua.runtime.unicodeName = true`

## 3.7.3
`2023-11-14`
* `FIX` can not infer arg type in some cases.

## 3.7.2
`2023-11-9`
* `FIX` [#2407]

[#2407]: https://github.com/LuaLS/lua-language-server/issues/2407

## 3.7.1
`2023-11-7`
* `FIX` [#2299]
* `FIX` [#2335]

[#2299]: https://github.com/LuaLS/lua-language-server/issues/2299
[#2335]: https://github.com/LuaLS/lua-language-server/issues/2335

## 3.7.0
`2023-8-24`
* `NEW` support `---@type` and `--[[@as]]` for return statement
* `NEW` commandline parameter `--force-accept-workspace`: allowing the use of the root directory or home directory as the workspace
* `NEW` diagnostic: `inject-field`
* `NEW` `---@enum` supports attribute `key`
  ```lua
  ---@enum (key) AnimalType
  local enum = {
    Cat = 1,
    Dog = 2,
  }

  ---@param animal userdata
  ---@param atp AnimalType
  ---@return boolean
  local function isAnimalType(animal, atp)
    return API.isAnimalType(animal, enum[atp])
  end

  assert(isAnimalType(animal, 'Cat'))
  ```
* `NEW` `---@class` supports attribute `exact`
  ```lua
  ---@class (exact) Point
  ---@field x number
  ---@field y number
  local m = {}
  m.x = 1 -- OK
  m.y = 2 -- OK
  m.z = 3 -- Warning
  ```

* `FIX` wrong hover and signature for method with varargs and overloads
* `FIX` [#2155]
* `FIX` [#2224]
* `FIX` [#2252]
* `FIX` [#2267]

[#2155]: https://github.com/LuaLS/lua-language-server/issues/2155
[#2224]: https://github.com/LuaLS/lua-language-server/issues/2224
[#2252]: https://github.com/LuaLS/lua-language-server/issues/2252
[#2267]: https://github.com/LuaLS/lua-language-server/issues/2267

## 3.6.25
`2023-7-26`
* `FIX` [#2214]

[#2214]: https://github.com/LuaLS/lua-language-server/issues/2214

## 3.6.24
`2023-7-21`
* `NEW` diagnostic: `missing-fields`
* `FIX` shake of `codeLens`
* `FIX` [#2145]

[#2145]: https://github.com/LuaLS/lua-language-server/issues/2145

## 3.6.23
`2023-7-7`
* `CHG` signature: narrow by inputed literal

## 3.6.22
`2023-6-14`
* `FIX` [#2038]
* `FIX` [#2042]
* `FIX` [#2062]
* `FIX` [#2083]
* `FIX` [#2088]
* `FIX` [#2110]
* `FIX` [#2129]

[#2038]: https://github.com/LuaLS/lua-language-server/issues/2038
[#2042]: https://github.com/LuaLS/lua-language-server/issues/2042
[#2062]: https://github.com/LuaLS/lua-language-server/issues/2062
[#2083]: https://github.com/LuaLS/lua-language-server/issues/2083
[#2088]: https://github.com/LuaLS/lua-language-server/issues/2088
[#2110]: https://github.com/LuaLS/lua-language-server/issues/2110
[#2129]: https://github.com/LuaLS/lua-language-server/issues/2129

## 3.6.21
`2023-5-24`
* `FIX` disable ffi plugin

## 3.6.20
`2023-5-23`
* `NEW` support connecting by socket with `--socket=PORT`
* `FIX` [#2113]

[#2113]: https://github.com/LuaLS/lua-language-server/issues/2113

## 3.6.19
`2023-4-26`
* `FIX` commandline parameter `checklevel` may not work
* `FIX` [#2036]
* `FIX` [#2037]
* `FIX` [#2056]
* `FIX` [#2077]
* `FIX` [#2081]

[#2036]: https://github.com/LuaLS/lua-language-server/issues/2036
[#2037]: https://github.com/LuaLS/lua-language-server/issues/2037
[#2056]: https://github.com/LuaLS/lua-language-server/issues/2056
[#2077]: https://github.com/LuaLS/lua-language-server/issues/2077
[#2081]: https://github.com/LuaLS/lua-language-server/issues/2081

## 3.6.18
`2023-3-23`
* `FIX` [#1943]
* `FIX` [#1996]
* `FIX` [#2004]
* `FIX` [#2013]

[#1943]: https://github.com/LuaLS/lua-language-server/issues/1943
[#1996]: https://github.com/LuaLS/lua-language-server/issues/1996
[#2004]: https://github.com/LuaLS/lua-language-server/issues/2004
[#2013]: https://github.com/LuaLS/lua-language-server/issues/2013

## 3.6.17
`2023-3-9`
* `CHG` export documents: export global variables
* `FIX` [#1715]
* `FIX` [#1753]
* `FIX` [#1914]
* `FIX` [#1922]
* `FIX` [#1924]
* `FIX` [#1928]
* `FIX` [#1945]
* `FIX` [#1955]
* `FIX` [#1978]

[#1715]: https://github.com/LuaLS/lua-language-server/issues/1715
[#1753]: https://github.com/LuaLS/lua-language-server/issues/1753
[#1914]: https://github.com/LuaLS/lua-language-server/issues/1914
[#1922]: https://github.com/LuaLS/lua-language-server/issues/1922
[#1924]: https://github.com/LuaLS/lua-language-server/issues/1924
[#1928]: https://github.com/LuaLS/lua-language-server/issues/1928
[#1945]: https://github.com/LuaLS/lua-language-server/issues/1945
[#1955]: https://github.com/LuaLS/lua-language-server/issues/1955
[#1978]: https://github.com/LuaLS/lua-language-server/issues/1978

## 3.6.13
`2023-3-2`
* `FIX` setting: `Lua.addonManager.enable` should be `true` by default
* `FIX` failed to publish to Windows

## 3.6.12
`2023-3-2`
* `NEW` [Addon Manager](https://github.com/LuaLS/lua-language-server/discussions/1607), try it with command `lua.addon_manager.open`. Thanks to [carsakiller](https://github.com/carsakiller)!

## 3.6.11
`2023-2-13`
* `CHG` completion: don't show loading process
* `FIX` [#1886]
* `FIX` [#1887]
* `FIX` [#1889]
* `FIX` [#1895]
* `FIX` [#1902]

[#1886]: https://github.com/LuaLS/lua-language-server/issues/1886
[#1887]: https://github.com/LuaLS/lua-language-server/issues/1887
[#1889]: https://github.com/LuaLS/lua-language-server/issues/1889
[#1895]: https://github.com/LuaLS/lua-language-server/issues/1895
[#1902]: https://github.com/LuaLS/lua-language-server/issues/1902

## 3.6.10
`2023-2-7`
* `FIX` [#1869]
* `FIX` [#1872]

[#1869]: https://github.com/LuaLS/lua-language-server/issues/1869
[#1872]: https://github.com/LuaLS/lua-language-server/issues/1872

## 3.6.9
`2023-2-2`
* `FIX` [#1864]
* `FIX` [#1868]
* `FIX` [#1869]
* `FIX` [#1871]

[#1864]: https://github.com/LuaLS/lua-language-server/issues/1864
[#1868]: https://github.com/LuaLS/lua-language-server/issues/1868
[#1869]: https://github.com/LuaLS/lua-language-server/issues/1869
[#1871]: https://github.com/LuaLS/lua-language-server/issues/1871

## 3.6.8
`2023-1-31`
* `NEW` command `lua.exportDocument` . VSCode will display this command in the right-click menu
* `CHG` setting `Lua.workspace.supportScheme` has been removed. All schemes are supported if the language id is `lua`
* `FIX` [#1831]
* `FIX` [#1838]
* `FIX` [#1841]
* `FIX` [#1851]
* `FIX` [#1855]
* `FIX` [#1857]

[#1831]: https://github.com/LuaLS/lua-language-server/issues/1831
[#1838]: https://github.com/LuaLS/lua-language-server/issues/1838
[#1841]: https://github.com/LuaLS/lua-language-server/issues/1841
[#1851]: https://github.com/LuaLS/lua-language-server/issues/1851
[#1855]: https://github.com/LuaLS/lua-language-server/issues/1855
[#1857]: https://github.com/LuaLS/lua-language-server/issues/1857

## 3.6.7
`2023-1-20`
* `FIX` [#1810]
* `FIX` [#1829]

[#1810]: https://github.com/LuaLS/lua-language-server/issues/1810
[#1829]: https://github.com/LuaLS/lua-language-server/issues/1829

## 3.6.6
`2023-1-17`
* `FIX` [#1825]
* `FIX` [#1826]

[#1825]: https://github.com/LuaLS/lua-language-server/issues/1825
[#1826]: https://github.com/LuaLS/lua-language-server/issues/1826

## 3.6.5
`2023-1-16`
* `NEW` support casting global variables
* `NEW` code lens: this feature is disabled by default.
* `NEW` settings:
  * `Lua.codeLens.enable`: Enable code lens.
* `CHG` improve memory usage for large libraries
* `CHG` definition: supports finding definitions for `@class` and `@alias`, since they may be defined multi times
* `CHG` rename: supports `@field`
* `CHG` improve patch for `.luarc.json`
* `CHG` `---@meta [name]`: once declared `name`, user can only require this file by declared name. meta file can not be required with name `_`
* `CHG` remove telemetry
* `FIX` [#831]
* `FIX` [#1729]
* `FIX` [#1737]
* `FIX` [#1751]
* `FIX` [#1767]
* `FIX` [#1796]
* `FIX` [#1805]
* `FIX` [#1808]
* `FIX` [#1811]
* `FIX` [#1824]

[#831]:  https://github.com/LuaLS/lua-language-server/issues/831
[#1729]: https://github.com/LuaLS/lua-language-server/issues/1729
[#1737]: https://github.com/LuaLS/lua-language-server/issues/1737
[#1751]: https://github.com/LuaLS/lua-language-server/issues/1751
[#1767]: https://github.com/LuaLS/lua-language-server/issues/1767
[#1796]: https://github.com/LuaLS/lua-language-server/issues/1796
[#1805]: https://github.com/LuaLS/lua-language-server/issues/1805
[#1808]: https://github.com/LuaLS/lua-language-server/issues/1808
[#1811]: https://github.com/LuaLS/lua-language-server/issues/1811
[#1824]: https://github.com/LuaLS/lua-language-server/issues/1824

## 3.6.4
`2022-11-29`
* `NEW` modify `require` after renaming files
* `FIX` circulation reference in process analysis
  ```lua
  ---@type number
  local x

  ---@type number
  local y

  x = y

  y = x --> Can not infer `y` before
  ```
* `FIX` [#1698]
* `FIX` [#1704]
* `FIX` [#1717]

[#1698]: https://github.com/LuaLS/lua-language-server/issues/1698
[#1704]: https://github.com/LuaLS/lua-language-server/issues/1704
[#1717]: https://github.com/LuaLS/lua-language-server/issues/1717

## 3.6.3
`2022-11-14`
* `FIX` [#1684]
* `FIX` [#1692]

[#1684]: https://github.com/LuaLS/lua-language-server/issues/1684
[#1692]: https://github.com/LuaLS/lua-language-server/issues/1692

## 3.6.2
`2022-11-10`
* `FIX` incorrect type check for generic with nil
* `FIX` [#1676]
* `FIX` [#1677]
* `FIX` [#1679]
* `FIX` [#1680]

[#1676]: https://github.com/LuaLS/lua-language-server/issues/1676
[#1677]: https://github.com/LuaLS/lua-language-server/issues/1677
[#1679]: https://github.com/LuaLS/lua-language-server/issues/1679
[#1680]: https://github.com/LuaLS/lua-language-server/issues/1680

## 3.6.1
`2022-11-8`
* `FIX` wrong diagnostics for `pcall` and `xpcall`
* `FIX` duplicate fields in table hover
* `FIX` description disapeared for overloaded function
* `FIX` [#1675]

[#1675]: https://github.com/LuaLS/lua-language-server/issues/1675

## 3.6.0
`2022-11-8`
* `NEW` supports `private`/`protected`/`public`/`package`
  * mark in `doc.field`
    ```lua
    ---@class unit
    ---@field private uuid integer
    ```
  * mark with `---@private`, `---@protected`, `---@public` and `---@package`
    ```lua
    ---@class unit
    local mt = {}

    ---@private
    function mt:init()
    end

    ---@protected
    function mt:update()
    end
    ```
  * mark by settings `Lua.doc.privateName`, `Lua.doc.protectedName` and `Lua.doc.packageName`
    ```lua
    ---@class unit
    ---@field _uuid integer --> treat as private when `Lua.doc.privateName` has `"_*"`
    ```
* `NEW` settings:
  * `Lua.misc.executablePath`: [#1557] specify the executable path in VSCode
  * `Lua.diagnostics.workspaceEvent`: [#1626] set the time to trigger workspace diagnostics.
  * `Lua.doc.privateName`: treat matched fields as private
  * `Lua.doc.protectedName`: treat matched fields as protected
  * `Lua.doc.packageName`: treat matched fields as package
* `NEW` CLI `--doc [path]` to make docs.
server will generate `doc.json` and `doc.md` in `LOGPATH`.
`doc.md` is generated by `doc.json` by example code `script/cli/doc2md.lua`.
* `CHG` [#1558] detect multi libraries
* `CHG` [#1458] `semantic-tokens`: global variable is setted to `variable.global`
  ```jsonc
  // color global variables to red
  "editor.semanticTokenColorCustomizations": {
      "rules": {
          "variable.global": "#ff0000"
      }
  }
  ```
* `CHG` [#1177] re-support for symlinks, users need to maintain the correctness of symlinks themselves
* `CHG` [#1561] infer definitions and types across chain expression
  ```lua
  ---@class myClass
  local myClass = {}

  myClass.a.b.c.e.f.g = 1

  ---@type myClass
  local class

  print(class.a.b.c.e.f.g) --> inferred as integer
  ```
* `CHG` [#1582] the following diagnostics consider `overload`
  * `missing-return`
  * `missing-return-value`
  * `redundant-return-value`
  * `return-type-mismatch`
* `CHG` workspace-symbol: supports chain fields based on global variables and types. try `io.open` or `iolib.open`
* `CHG` [#1641] if a function only has varargs and has `---@overload`, the varargs will be ignored
* `CHG` [#1575] search definitions by first argument of `setmetatable`
  ```lua
  ---@class Object
  local obj = setmetatable({
    initValue = 1,
  }, mt)

  print(obj.initValue) --> `obj.initValue` is integer
  ```
* `CHG` [#1153] infer type by generic parameters or returns of function
  ```lua
  ---@generic T
  ---@param f fun(x: T)
  ---@return T[]
  local function x(f) end

  ---@type fun(x: integer)
  local cb

  local arr = x(cb) --> `arr` is inferred as `integer[]`
  ```
* `CHG` [#1201] infer parameter type by expected returned function of parent function
  ```lua
  ---@return fun(x: integer)
  local function f()
      return function (x) --> `x` is inferred as `integer`
      end
  end
  ```
* `CHG` [#1332] infer parameter type when function in table
  ```lua
  ---@class A
  ---@field f fun(x: string)

  ---@type A
  local t = {
      f = function (x) end --> `x` is inferred as `string`
  }
  ```
* `CHG` find reference: respect `includeDeclaration` (although I don't know how to turn off this option in VSCode)
* `CHG` [#1344] improve `---@see`
* `CHG` [#1484] setting `runtime.special` supports fields
  ```jsonc
  {
    "runtime.special": {
      "sandbox.require": "require"
    }
  }
  ```
* `CHG` [#1533] supports completion with table field of function
* `CHG` [#1457] infer parameter type by function type
  ```lua
  ---@type fun(x: number)
  local function f(x) --> `x` is inferred as `number`
  end
  ```
* `CHG` [#1663] check parameter types of generic extends
  ```lua
  ---@generic T: string | boolean
  ---@param x T
  ---@return T
  local function f(x)
      return x
  end

  local x = f(1) --> Warning: Cannot assign `integer` to parameter `<T:boolean|string>`.
  ```
* `CHG` [#1434] type check: check the fields in table:
  ```lua
  ---@type table<string, string>
  local x

  ---@type table<string, number>
  local y

  x = y --> Warning: Cannot assign `<string, number>` to `<string, string>`
  ```
* `CHG` [#1374] type check: supports array part in literal table
  ```lua
  ---@type boolean[]
  local t = { 1, 2, 3 } --> Warning: Cannot assign `integer` to `boolean`
  ```
* `CHG` `---@enum` supports runtime values
* `FIX` [#1479]
* `FIX` [#1480]
* `FIX` [#1567]
* `FIX` [#1593]
* `FIX` [#1595]
* `FIX` [#1599]
* `FIX` [#1606]
* `FIX` [#1608]
* `FIX` [#1637]
* `FIX` [#1640]
* `FIX` [#1642]
* `FIX` [#1662]
* `FIX` [#1672]

[#1153]: https://github.com/LuaLS/lua-language-server/issues/1153
[#1177]: https://github.com/LuaLS/lua-language-server/issues/1177
[#1201]: https://github.com/LuaLS/lua-language-server/issues/1201
[#1202]: https://github.com/LuaLS/lua-language-server/issues/1202
[#1332]: https://github.com/LuaLS/lua-language-server/issues/1332
[#1344]: https://github.com/LuaLS/lua-language-server/issues/1344
[#1374]: https://github.com/LuaLS/lua-language-server/issues/1374
[#1434]: https://github.com/LuaLS/lua-language-server/issues/1434
[#1457]: https://github.com/LuaLS/lua-language-server/issues/1457
[#1458]: https://github.com/LuaLS/lua-language-server/issues/1458
[#1479]: https://github.com/LuaLS/lua-language-server/issues/1479
[#1480]: https://github.com/LuaLS/lua-language-server/issues/1480
[#1484]: https://github.com/LuaLS/lua-language-server/issues/1484
[#1533]: https://github.com/LuaLS/lua-language-server/issues/1533
[#1557]: https://github.com/LuaLS/lua-language-server/issues/1557
[#1558]: https://github.com/LuaLS/lua-language-server/issues/1558
[#1561]: https://github.com/LuaLS/lua-language-server/issues/1561
[#1567]: https://github.com/LuaLS/lua-language-server/issues/1567
[#1575]: https://github.com/LuaLS/lua-language-server/issues/1575
[#1582]: https://github.com/LuaLS/lua-language-server/issues/1582
[#1593]: https://github.com/LuaLS/lua-language-server/issues/1593
[#1595]: https://github.com/LuaLS/lua-language-server/issues/1595
[#1599]: https://github.com/LuaLS/lua-language-server/issues/1599
[#1606]: https://github.com/LuaLS/lua-language-server/issues/1606
[#1608]: https://github.com/LuaLS/lua-language-server/issues/1608
[#1626]: https://github.com/LuaLS/lua-language-server/issues/1626
[#1637]: https://github.com/LuaLS/lua-language-server/issues/1637
[#1640]: https://github.com/LuaLS/lua-language-server/issues/1640
[#1641]: https://github.com/LuaLS/lua-language-server/issues/1641
[#1642]: https://github.com/LuaLS/lua-language-server/issues/1642
[#1662]: https://github.com/LuaLS/lua-language-server/issues/1662
[#1663]: https://github.com/LuaLS/lua-language-server/issues/1663
[#1670]: https://github.com/LuaLS/lua-language-server/issues/1670
[#1672]: https://github.com/LuaLS/lua-language-server/issues/1672

## 3.5.6
`2022-9-16`
* `FIX` [#1439](https://github.com/LuaLS/lua-language-server/issues/1439)
* `FIX` [#1467](https://github.com/LuaLS/lua-language-server/issues/1467)
* `FIX` [#1506](https://github.com/LuaLS/lua-language-server/issues/1506)
* `FIX` [#1537](https://github.com/LuaLS/lua-language-server/issues/1537)

## 3.5.5
`2022-9-7`
* `FIX` [#1529](https://github.com/LuaLS/lua-language-server/issues/1529)
* `FIX` [#1530](https://github.com/LuaLS/lua-language-server/issues/1530)

## 3.5.4
`2022-9-6`
* `NEW` `type-formatting`: fix wrong indentation of VSCode
* `CHG` `document-symbol`: redesigned to better support for `Sticky Scroll` feature of VSCode
* `FIX` `diagnostics.workspaceDelay` can not prevent first workspace diagnostic
* `FIX` [#1476](https://github.com/LuaLS/lua-language-server/issues/1476)
* `FIX` [#1490](https://github.com/LuaLS/lua-language-server/issues/1490)
* `FIX` [#1493](https://github.com/LuaLS/lua-language-server/issues/1493)
* `FIX` [#1499](https://github.com/LuaLS/lua-language-server/issues/1499)
* `FIX` [#1526](https://github.com/LuaLS/lua-language-server/issues/1526)

## 3.5.3
`2022-8-13`
* `FIX` [#1409](https://github.com/LuaLS/lua-language-server/issues/1409)
* `FIX` [#1422](https://github.com/LuaLS/lua-language-server/issues/1422)
* `FIX` [#1425](https://github.com/LuaLS/lua-language-server/issues/1425)
* `FIX` [#1428](https://github.com/LuaLS/lua-language-server/issues/1428)
* `FIX` [#1430](https://github.com/LuaLS/lua-language-server/issues/1430)
* `FIX` [#1431](https://github.com/LuaLS/lua-language-server/issues/1431)
* `FIX` [#1446](https://github.com/LuaLS/lua-language-server/issues/1446)
* `FIX` [#1451](https://github.com/LuaLS/lua-language-server/issues/1451)
* `FIX` [#1461](https://github.com/LuaLS/lua-language-server/issues/1461)
* `FIX` [#1463](https://github.com/LuaLS/lua-language-server/issues/1463)

## 3.5.2
`2022-8-1`
* `FIX` [#1395](https://github.com/LuaLS/lua-language-server/issues/1395)
* `FIX` [#1403](https://github.com/LuaLS/lua-language-server/issues/1403)
* `FIX` [#1405](https://github.com/LuaLS/lua-language-server/issues/1405)
* `FIX` [#1406](https://github.com/LuaLS/lua-language-server/issues/1406)
* `FIX` [#1418](https://github.com/LuaLS/lua-language-server/issues/1418)

## 3.5.1
`2022-7-26`
* `NEW` supports [color](https://github.com/LuaLS/lua-language-server/pull/1379)
* `NEW` setting `Lua.runtime.pluginArgs`
* `CHG` setting `type.castNumberToInteger` default by `true`
* `CHG` improve supports for multi-workspace
* `FIX` [#1354](https://github.com/LuaLS/lua-language-server/issues/1354)
* `FIX` [#1355](https://github.com/LuaLS/lua-language-server/issues/1355)
* `FIX` [#1363](https://github.com/LuaLS/lua-language-server/issues/1363)
* `FIX` [#1365](https://github.com/LuaLS/lua-language-server/issues/1365)
* `FIX` [#1367](https://github.com/LuaLS/lua-language-server/issues/1367)
* `FIX` [#1368](https://github.com/LuaLS/lua-language-server/issues/1368)
* `FIX` [#1370](https://github.com/LuaLS/lua-language-server/issues/1370)
* `FIX` [#1375](https://github.com/LuaLS/lua-language-server/issues/1375)
* `FIX` [#1391](https://github.com/LuaLS/lua-language-server/issues/1391)

## 3.5.0
`2022-7-19`
* `NEW` `LuaDoc`: `---@operator`:
  ```lua
  ---@class fspath
  ---@operator div(string|fspath): fspath

  ---@type fspath
  local root

  local fileName = root / 'script' / 'main.lua' -- `fileName` is `fspath` here
  ```
* `NEW` `LuaDoc`: `---@source`:
  ```lua
  -- Also supports absolute path or relative path (based on current file path)
  ---@source file:///xxx.c:50:20
  XXX = 1 -- when finding definitions of `XXX`, returns `file:///xxx.c:50:20` instead here.
  ```
* `NEW` `LuaDoc`: `---@enum`:
  ```lua
  ---@enum animal
  Animal = {
    Cat = 1,
    Dog = 2,
  }

  ---@param x animal
  local function f(x) end

  f() -- suggests `Animal.Cat`, `Animal.Dog`, `1`, `2` as the first parameter
  ```
* `NEW` diagnostics:
  * `unknown-operator`
  * `unreachable-code`
* `NEW` settings:
  * `diagnostics.unusedLocalExclude`
* `NEW` VSCode: add support for [EmmyLuaUnity](https://marketplace.visualstudio.com/items?itemName=CppCXY.emmylua-unity)
* `CHG` support multi-type:
  ```lua
  ---@type number, _, boolean
  local a, b, c -- `a` is `number`, `b` is `unknown`, `c` is `boolean`
  ```
* `CHG` treat `_ENV = XXX` as `local _ENV = XXX`
  * `_ENV = nil`: disable all globals
  * `_ENV = {}`: allow all globals
  * `_ENV = {} ---@type mathlib`: only allow globals in `mathlib`
* `CHG` hover: dose not show unknown `---@XXX` as description
* `CHG` contravariance is allowed at the class declaration
  ```lua
  ---@class BaseClass
  local BaseClass

  ---@class MyClass: BaseClass
  local MyClass = BaseClass -- OK!
  ```
* `CHG` hover: supports path in link
  ```lua
  --![](image.png) --> will convert to `--![](file:///xxxx/image.png)`
  local x
  ```
* `CHG` signature: only show signatures matching the entered parameters
* `FIX` [#880](https://github.com/LuaLS/lua-language-server/issues/880)
* `FIX` [#1284](https://github.com/LuaLS/lua-language-server/issues/1284)
* `FIX` [#1292](https://github.com/LuaLS/lua-language-server/issues/1292)
* `FIX` [#1294](https://github.com/LuaLS/lua-language-server/issues/1294)
* `FIX` [#1306](https://github.com/LuaLS/lua-language-server/issues/1306)
* `FIX` [#1311](https://github.com/LuaLS/lua-language-server/issues/1311)
* `FIX` [#1317](https://github.com/LuaLS/lua-language-server/issues/1317)
* `FIX` [#1320](https://github.com/LuaLS/lua-language-server/issues/1320)
* `FIX` [#1330](https://github.com/LuaLS/lua-language-server/issues/1330)
* `FIX` [#1345](https://github.com/LuaLS/lua-language-server/issues/1345)
* `FIX` [#1346](https://github.com/LuaLS/lua-language-server/issues/1346)
* `FIX` [#1348](https://github.com/LuaLS/lua-language-server/issues/1348)

## 3.4.2
`2022-7-6`
* `CHG` diagnostic: `type-check` ignores `nil` in `getfield`
* `CHG` diagnostic: `---@diagnostic disable: <ERR_NAME>` can suppress syntax errors
* `CHG` completion: `completion.callSnippet` no longer generate parameter types
* `CHG` hover: show `---@type {x: number, y: number}` as detail instead of `table`
* `CHG` dose not infer as `nil` by `t.field = nil`
* `FIX` [#1278](https://github.com/LuaLS/lua-language-server/issues/1278)
* `FIX` [#1288](https://github.com/LuaLS/lua-language-server/issues/1288)

## 3.4.1
`2022-7-5`
* `NEW` settings:
  * `type.weakNilCheck`
* `CHG` allow type contravariance for `setmetatable` when initializing a class
  ```lua
  ---@class A
  local a = {}

  ---@class B: A
  local b = setmetatable({}, { __index = a }) -- OK!
  ```
* `FIX` [#1256](https://github.com/LuaLS/lua-language-server/issues/1256)
* `FIX` [#1257](https://github.com/LuaLS/lua-language-server/issues/1257)
* `FIX` [#1267](https://github.com/LuaLS/lua-language-server/issues/1267)
* `FIX` [#1269](https://github.com/LuaLS/lua-language-server/issues/1269)
* `FIX` [#1273](https://github.com/LuaLS/lua-language-server/issues/1273)
* `FIX` [#1275](https://github.com/LuaLS/lua-language-server/issues/1275)
* `FIX` [#1279](https://github.com/LuaLS/lua-language-server/issues/1279)

## 3.4.0
`2022-6-29`
* `NEW` diagnostics:
  * `cast-local-type`
  * `assign-type-mismatch`
  * `param-type-mismatch`
  * `unknown-cast-variable`
  * `cast-type-mismatch`
  * `missing-return-value`
  * `redundant-return-value`
  * `missing-return`
  * `return-type-mismatch`
* `NEW` settings:
  * `diagnostics.groupSeverity`
  * `diagnostics.groupFileStatus`
  * `type.castNumberToInteger`
  * `type.weakUnionCheck`
  * `hint.semicolon`
* `CHG` infer `nil` as redundant return value
  ```lua
  local function f() end
  local x = f() -- `x` is `nil` instead of `unknown`
  ```
* `CHG` infer called function by params num
  ```lua
  ---@overload fun(x: number, y: number):string
  ---@overload fun(x: number):number
  ---@return boolean
  local function f() end

  local n1 = f()     -- `n1` is `boolean`
  local n2 = f(0)    -- `n2` is `number`
  local n3 = f(0, 0) -- `n3` is `string`
  ```
* `CHG` semicolons and parentheses can be used in `DocTable`
  ```lua
  ---@type { (x: number); (y: boolean) }
  ```
* `CHG` return names and parentheses can be used in `DocFunction`
  ```lua
  ---@type fun():(x: number, y: number, ...: number)
  ```
* `CHG` supports `---@return boolean ...`
* `CHG` improve experience for diagnostics and semantic-tokens
* `FIX` diagnostics flash when opening a file
* `FIX` sometimes workspace diagnostics are not triggered
* `FIX` [#1228](https://github.com/LuaLS/lua-language-server/issues/1228)
* `FIX` [#1229](https://github.com/LuaLS/lua-language-server/issues/1229)
* `FIX` [#1242](https://github.com/LuaLS/lua-language-server/issues/1242)
* `FIX` [#1243](https://github.com/LuaLS/lua-language-server/issues/1243)
* `FIX` [#1249](https://github.com/LuaLS/lua-language-server/issues/1249)

## 3.3.1
`2022-6-17`
* `FIX` [#1213](https://github.com/LuaLS/lua-language-server/issues/1213)
* `FIX` [#1215](https://github.com/LuaLS/lua-language-server/issues/1215)
* `FIX` [#1217](https://github.com/LuaLS/lua-language-server/issues/1217)
* `FIX` [#1218](https://github.com/LuaLS/lua-language-server/issues/1218)
* `FIX` [#1220](https://github.com/LuaLS/lua-language-server/issues/1220)
* `FIX` [#1223](https://github.com/LuaLS/lua-language-server/issues/1223)

## 3.3.0
`2022-6-15`
* `NEW` `LuaDoc` supports `` `CODE` ``
  ```lua
  ---@type `CONST.X` | `CONST.Y`
  local x

  if x == -- suggest `CONST.X` and `CONST.Y` here
  ```
* `CHG` infer type by `error`
  ```lua
  ---@type integer|nil
  local n

  if not n then
      error('n is nil')
  end

  print(n) -- `n` is `integer` here
  ```
* `CHG` infer type by `t and t.x`
  ```lua
  ---@type table|nil
  local t

  local s = t and t.x or 1 -- `t` in `t.x` is `table`
  ```
* `CHG` infer type by `type(x)`
  ```lua
  local x

  if type(x) == 'string' then
      print(x) -- `x` is `string` here
  end

  local tp = type(x)

  if tp == 'boolean' then
      print(x) -- `x` is `boolean` here
  end
  ```
* `CHG` infer type by `>`/`<`/`>=`/`<=`
* `FIX` with clients that support LSP 3.17 (VSCode), workspace diagnostics are triggered every time when opening a file.
* `FIX` [#1204](https://github.com/LuaLS/lua-language-server/issues/1204)
* `FIX` [#1208](https://github.com/LuaLS/lua-language-server/issues/1208)

## 3.2.5
`2022-6-9`
* `NEW` provide config docs in `LUA_LANGUAGE_SERVER/doc/`
* `FIX` [#1148](https://github.com/LuaLS/lua-language-server/issues/1148)
* `FIX` [#1149](https://github.com/LuaLS/lua-language-server/issues/1149)
* `FIX` [#1192](https://github.com/LuaLS/lua-language-server/issues/1192)

## 3.2.4
`2022-5-25`
* `NEW` settings:
  + `workspace.supportScheme`: `["file", "untitled", "git"]`
  + `diagnostics.disableScheme`: `["git"]`
* `NEW` folding: support folding `---@alias`
* `CHG` if `rootUri` or `workspaceFolder` is set to `ROOT` or `HOME`, this extension will refuse to load these directories and show an error message.
* `CHG` show warning message when scanning more than 100,000 files.
* `CHG` upgrade [LSP](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/) to `3.17`
* `FIX` hover: can not union `table` with other basic types
* `FIX` [#1125](https://github.com/LuaLS/lua-language-server/issues/1125)
* `FIX` [#1131](https://github.com/LuaLS/lua-language-server/issues/1131)
* `FIX` [#1134](https://github.com/LuaLS/lua-language-server/issues/1134)
* `FIX` [#1141](https://github.com/LuaLS/lua-language-server/issues/1141)
* `FIX` [#1144](https://github.com/LuaLS/lua-language-server/issues/1144)
* `FIX` [#1150](https://github.com/LuaLS/lua-language-server/issues/1150)
* `FIX` [#1155](https://github.com/LuaLS/lua-language-server/issues/1155)

## 3.2.3
`2022-5-16`
* `CHG` parse `.luarc.json` as jsonc. In order to please the editor, it also supports `.luarc.jsonc` as the file name.
* `CHG` dose not load files in symbol links
* `FIX` memory leak with symbol links
* `FIX` diagnostic: send empty results to every file after startup
* `FIX` [#1103](https://github.com/LuaLS/lua-language-server/issues/1103)
* `FIX` [#1107](https://github.com/LuaLS/lua-language-server/issues/1107)

## 3.2.2
`2022-4-26`
* `FIX` diagnostic: `unused-function` cannot handle recursion correctly
* `FIX` [#1092](https://github.com/LuaLS/lua-language-server/issues/1092)
* `FIX` [#1093](https://github.com/LuaLS/lua-language-server/issues/1093)
* `FIX` runtime errors reported by telemetry, see [#1091](https://github.com/LuaLS/lua-language-server/issues/1091)

## 3.2.1
`2022-4-25`
* `FIX` broken in VSCode

## 3.2.0
`2022-4-25`
* `NEW` supports infer of callback parameter
  ```lua
  ---@type string[]
  local t

  table.sort(t, function (a, b)
      -- `a` and `b` is `string` here
  end)
  ```
* `NEW` using `---@overload` as class constructor
  ```lua
  ---@class Class
  ---@overload fun():Class
  local mt

  local x = mt() --> x is `Class` here
  ```
* `NEW` add `--[[@as type]]`
  ```lua
  local x = true
  local y = x--[[@as integer]] -- y is `integer` here
  ```
* `NEW` add `---@cast`
  * `---@cast localname type`
  * `---@cast localname +type`
  * `---@cast localname -type`
  * `---@cast localname +?`
  * `---@cast localname -?`
* `NEW` generic: resolve `T[]` by `table<integer, type>` or `---@field [integer] type`
* `NEW` resolve `class[1]` by `---@field [integer] type`
* `NEW` diagnostic: `missing-parameter`
* `NEW` diagnostic: `need-check-nil`
* `CHG` diagnostic: no longer mark `redundant-parameter` as `Unnecessary`
* `FIX` diagnostic: `unused-function` does not recognize recursion
* `FIX` [#1051](https://github.com/LuaLS/lua-language-server/issues/1051)
* `FIX` [#1072](https://github.com/LuaLS/lua-language-server/issues/1072)
* `FIX` [#1077](https://github.com/LuaLS/lua-language-server/issues/1077)
* `FIX` [#1088](https://github.com/LuaLS/lua-language-server/issues/1088)
* `FIX` runtime errors

## 3.1.0
`2022-4-17`
* `NEW` support find definition in method
* `CHG` hint: move to LSP. Its font is now controlled by the client.
* `CHG` hover: split `local` into `local` / `parameter` / `upvalue` / `self`.
* `CHG` hover: added parentheses to some words, such as `global` / `field` / `class`.
* `FIX` definition of `table<k, v>`
* `FIX` [#994](https://github.com/LuaLS/lua-language-server/issues/994)
* `FIX` [#1057](https://github.com/LuaLS/lua-language-server/issues/1057)
* `FIX` runtime errors reported by telemetry, see [#1058](https://github.com/LuaLS/lua-language-server/issues/1058)

## 3.0.2
`2022-4-15`
* `FIX` `table<string, boolean>[string] -> boolean`
* `FIX` goto `type definition`
* `FIX` [#1050](https://github.com/LuaLS/lua-language-server/issues/1050)

## 3.0.1
`2022-4-11`
* `FIX` [#1033](https://github.com/LuaLS/lua-language-server/issues/1033)
* `FIX` [#1034](https://github.com/LuaLS/lua-language-server/issues/1034)
* `FIX` [#1035](https://github.com/LuaLS/lua-language-server/issues/1035)
* `FIX` [#1036](https://github.com/LuaLS/lua-language-server/issues/1036)
* `FIX` runtime errors reported by telemetry, see [#1037](https://github.com/LuaLS/lua-language-server/issues/1037)

## 3.0.0
`2022-4-10`
* `CHG` [break changes](https://github.com/LuaLS/lua-language-server/issues/980)
* `CHG` diagnostic:
  + `type-check`: removed for now
  + `no-implicit-any`: renamed to `no-unknown`
* `CHG` formatter: no longer need` --preview`
* `CHG` `LuaDoc`: supports `---@type (string|integer)[]`
* `FIX` semantic: color of `function`
* `FIX` [#1027](https://github.com/LuaLS/lua-language-server/issues/1027)
* `FIX` [#1028](https://github.com/LuaLS/lua-language-server/issues/1028)

## 2.6.8
`2022-4-9`
* `CHG` completion: call snippet shown as `Function` instead of `Snippet` when `Lua.completion.callSnippet` is `Replace`
* `FIX` [#976](https://github.com/LuaLS/lua-language-server/issues/976)
* `FIX` [#995](https://github.com/LuaLS/lua-language-server/issues/995)
* `FIX` [#1004](https://github.com/LuaLS/lua-language-server/issues/1004)
* `FIX` [#1008](https://github.com/LuaLS/lua-language-server/issues/1008)
* `FIX` [#1009](https://github.com/LuaLS/lua-language-server/issues/1009)
* `FIX` [#1011](https://github.com/LuaLS/lua-language-server/issues/1011)
* `FIX` [#1014](https://github.com/LuaLS/lua-language-server/issues/1014)
* `FIX` [#1016](https://github.com/LuaLS/lua-language-server/issues/1016)
* `FIX` [#1017](https://github.com/LuaLS/lua-language-server/issues/1017)
* `FIX` runtime errors reported by telemetry

## 2.6.7
`2022-3-9`
* `NEW` diagnosis report, [read more](https://luals.github.io/wiki/diagnosis-report/)
* `CHG` `VSCode`: 1.65 has built in new `Lua` syntax files, so this extension no longer provides syntax files, which means you can install other syntax extensions in the marketplace. If you have any suggestions or issues, please [open issues here](https://github.com/LuaLS/lua.tmbundle).
* `CHG` telemetry: the prompt will only appear in VSCode to avoid repeated prompts in other platforms due to the inability to automatically modify the settings.
* `FIX` [#965](https://github.com/LuaLS/lua-language-server/issues/965)
* `FIX` [#975](https://github.com/LuaLS/lua-language-server/issues/975)

## 2.6.6
`2022-2-21`
* `NEW` formatter preview, use `--preview` to enable this feature, [read more](https://github.com/LuaLS/lua-language-server/issues/960)
* `FIX` [#958](https://github.com/LuaLS/lua-language-server/issues/958)
* `FIX` runtime errors

## 2.6.5
`2022-2-17`
* `FIX` telemetry is not disabled by default (since 2.6.0)
* `FIX` [#934](https://github.com/LuaLS/lua-language-server/issues/934)
* `FIX` [#952](https://github.com/LuaLS/lua-language-server/issues/952)

## 2.6.4
`2022-2-9`
* `CHG` completion: reduced sorting priority for postfix completion
* `FIX` [#936](https://github.com/LuaLS/lua-language-server/issues/936)
* `FIX` [#937](https://github.com/LuaLS/lua-language-server/issues/937)
* `FIX` [#940](https://github.com/LuaLS/lua-language-server/issues/940)
* `FIX` [#941](https://github.com/LuaLS/lua-language-server/issues/941)
* `FIX` [#941](https://github.com/LuaLS/lua-language-server/issues/942)
* `FIX` [#943](https://github.com/LuaLS/lua-language-server/issues/943)
* `FIX` [#946](https://github.com/LuaLS/lua-language-server/issues/946)

## 2.6.3
`2022-1-25`
* `FIX` new files are not loaded correctly
* `FIX` [#923](https://github.com/LuaLS/lua-language-server/issues/923)
* `FIX` [#926](https://github.com/LuaLS/lua-language-server/issues/926)

## 2.6.2
`2022-1-25`
* `FIX` [#925](https://github.com/LuaLS/lua-language-server/issues/925)

## 2.6.1
`2022-1-24`
* `CHG` default values of settings:
  + `Lua.diagnostics.workspaceDelay`: `0` sec -> `3` sec
  + `Lua.workspace.maxPreload`: `1000` -> `5000`
  + `Lua.workspace.preloadFileSize`: `100` KB -> `500` KB
* `CHG` improve performance
* `FIX` modify luarc failed
* `FIX` library files not recognized correctly
* `FIX` [#903](https://github.com/LuaLS/lua-language-server/issues/903)
* `FIX` [#906](https://github.com/LuaLS/lua-language-server/issues/906)
* `FIX` [#920](https://github.com/LuaLS/lua-language-server/issues/920)

## 2.6.0
`2022-1-13`
* `NEW` supports multi-workspace in server side, for developers of language clients, please [read here](https://luals.github.io/wiki/developing/#multiple-workspace-support) to learn more.
* `NEW` setting:
  + `Lua.hint.arrayIndex`
  + `Lua.semantic.enable`
  + `Lua.semantic.variable`
  + `Lua.semantic.annotation`
  + `Lua.semantic.keyword`
* `CHG` completion: improve response speed
* `CHG` completion: can be triggered in `LuaDoc` and strings
* `CHG` diagnostic: smoother
* `CHG` settings `Lua.color.mode` removed
* `FIX` [#876](https://github.com/LuaLS/lua-language-server/issues/876)
* `FIX` [#879](https://github.com/LuaLS/lua-language-server/issues/879)
* `FIX` [#884](https://github.com/LuaLS/lua-language-server/issues/884)
* `FIX` [#885](https://github.com/LuaLS/lua-language-server/issues/885)
* `FIX` [#886](https://github.com/LuaLS/lua-language-server/issues/886)
* `FIX` [#902](https://github.com/LuaLS/lua-language-server/issues/902)

## 2.5.6
`2021-12-27`
* `CHG` diagnostic: now syntax errors in `LuaDoc` are shown as `Warning`
* `FIX` [#863](https://github.com/LuaLS/lua-language-server/issues/863)
* `FIX` return type of `math.floor`
* `FIX` runtime errors

## 2.5.5
`2021-12-16`
* `FIX` dose not work in VSCode

## 2.5.4
`2021-12-16`
* `FIX` [#847](https://github.com/LuaLS/lua-language-server/issues/847)
* `FIX` [#848](https://github.com/LuaLS/lua-language-server/issues/848)
* `FIX` completion: incorrect cache
* `FIX` hover: always view string

## 2.5.3
`2021-12-6`
* `FIX` [#842](https://github.com/LuaLS/lua-language-server/issues/844)
* `FIX` [#844](https://github.com/LuaLS/lua-language-server/issues/844)

## 2.5.2
`2021-12-2`
* `FIX` [#815](https://github.com/LuaLS/lua-language-server/issues/815)
* `FIX` [#825](https://github.com/LuaLS/lua-language-server/issues/825)
* `FIX` [#826](https://github.com/LuaLS/lua-language-server/issues/826)
* `FIX` [#827](https://github.com/LuaLS/lua-language-server/issues/827)
* `FIX` [#831](https://github.com/LuaLS/lua-language-server/issues/831)
* `FIX` [#837](https://github.com/LuaLS/lua-language-server/issues/837)
* `FIX` [#838](https://github.com/LuaLS/lua-language-server/issues/838)
* `FIX` postfix
* `FIX` runtime errors

## 2.5.1
`2021-11-29`
* `FIX` incorrect syntax error

## 2.5.0
`2021-11-29`
* `NEW` settings:
  + `Lua.runtime.pathStrict`: not check subdirectories when using `runtime.path`
  + `Lua.hint.await`: display `await` when calling a function marked as async
  + `Lua.completion.postfix`: the symbol that triggers postfix, default is `@`
* `NEW` add supports for `lovr`
* `NEW` file encoding supports `utf16le` and `utf16be`
* `NEW` full IntelliSense supports for literal tables, see [#720](https://github.com/LuaLS/lua-language-server/issues/720) and [#727](https://github.com/LuaLS/lua-language-server/issues/727)
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
* `FIX` [#816](https://github.com/LuaLS/lua-language-server/issues/816)
* `FIX` [#817](https://github.com/LuaLS/lua-language-server/issues/817)
* `FIX` [#818](https://github.com/LuaLS/lua-language-server/issues/818)
* `FIX` [#820](https://github.com/LuaLS/lua-language-server/issues/820)

## 2.4.10
`2021-11-23`
* `FIX` [#790](https://github.com/LuaLS/lua-language-server/issues/790)
* `FIX` [#798](https://github.com/LuaLS/lua-language-server/issues/798)
* `FIX` [#804](https://github.com/LuaLS/lua-language-server/issues/804)
* `FIX` [#805](https://github.com/LuaLS/lua-language-server/issues/805)
* `FIX` [#806](https://github.com/LuaLS/lua-language-server/issues/806)
* `FIX` [#807](https://github.com/LuaLS/lua-language-server/issues/807)
* `FIX` [#809](https://github.com/LuaLS/lua-language-server/issues/809)

## 2.4.9
`2021-11-18`
* `CHG` for performance reasons, some of the features that are not cost-effective in IntelliSense have been disabled by default, and you can re-enable them through the following settings:
  + `Lua.IntelliSense.traceLocalSet`
  + `Lua.IntelliSense.traceReturn`
  + `Lua.IntelliSense.traceBeSetted`
  + `Lua.IntelliSense.traceFieldInject`

  [read more](https://github.com/LuaLS/lua-language-server/wiki/IntelliSense-optional-features)

## 2.4.8
`2021-11-15`
* `FIX` incorrect IntelliSense in specific situations
* `FIX` [#777](https://github.com/LuaLS/lua-language-server/issues/777)
* `FIX` [#778](https://github.com/LuaLS/lua-language-server/issues/778)
* `FIX` [#779](https://github.com/LuaLS/lua-language-server/issues/779)
* `FIX` [#780](https://github.com/LuaLS/lua-language-server/issues/780)

## 2.4.7
`2021-10-27`
* `FIX` [#762](https://github.com/LuaLS/lua-language-server/issues/762)

## 2.4.6
`2021-10-26`
* `NEW` diagnostic: `redundant-return`
* `FIX` [#744](https://github.com/LuaLS/lua-language-server/issues/744)
* `FIX` [#748](https://github.com/LuaLS/lua-language-server/issues/748)
* `FIX` [#749](https://github.com/LuaLS/lua-language-server/issues/749)
* `FIX` [#752](https://github.com/LuaLS/lua-language-server/issues/752)
* `FIX` [#753](https://github.com/LuaLS/lua-language-server/issues/753)
* `FIX` [#756](https://github.com/LuaLS/lua-language-server/issues/756)
* `FIX` [#758](https://github.com/LuaLS/lua-language-server/issues/758)
* `FIX` [#760](https://github.com/LuaLS/lua-language-server/issues/760)

## 2.4.5
`2021-10-18`
* `FIX` accidentally load lua files from user workspace

## 2.4.4
`2021-10-15`
* `CHG` improve `.luarc.json`
* `FIX` [#722](https://github.com/LuaLS/lua-language-server/issues/722)

## 2.4.3
`2021-10-13`
* `FIX` [#713](https://github.com/LuaLS/lua-language-server/issues/713)
* `FIX` [#718](https://github.com/LuaLS/lua-language-server/issues/718)
* `FIX` [#719](https://github.com/LuaLS/lua-language-server/issues/719)
* `FIX` [#725](https://github.com/LuaLS/lua-language-server/issues/725)
* `FIX` [#729](https://github.com/LuaLS/lua-language-server/issues/729)
* `FIX` [#730](https://github.com/LuaLS/lua-language-server/issues/730)
* `FIX` runtime errors

## 2.4.2
`2021-10-8`
* `FIX` [#702](https://github.com/LuaLS/lua-language-server/issues/702)
* `FIX` [#706](https://github.com/LuaLS/lua-language-server/issues/706)
* `FIX` [#707](https://github.com/LuaLS/lua-language-server/issues/707)
* `FIX` [#709](https://github.com/LuaLS/lua-language-server/issues/709)
* `FIX` [#712](https://github.com/LuaLS/lua-language-server/issues/712)

## 2.4.1
`2021-10-2`
* `FIX` broken with single file
* `FIX` [#698](https://github.com/LuaLS/lua-language-server/issues/698)
* `FIX` [#699](https://github.com/LuaLS/lua-language-server/issues/699)

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
* `CHG` [#663](https://github.com/LuaLS/lua-language-server/issues/663)
* `FIX` runtime errors
* `FIX` hint: may show param-2 as `self`
* `FIX` semantic: may fail when scrolling
* `FIX` [#647](https://github.com/LuaLS/lua-language-server/issues/647)
* `FIX` [#660](https://github.com/LuaLS/lua-language-server/issues/660)
* `FIX` [#673](https://github.com/LuaLS/lua-language-server/issues/673)

## 2.3.7
`2021-8-17`
* `CHG` improve performance
* `FIX` [#244](https://github.com/LuaLS/lua-language-server/issues/244)

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
* `FIX` [#625](https://github.com/LuaLS/lua-language-server/issues/625)

## 2.3.3
`2021-7-26`
* `NEW` config supports prop
* `FIX` [#612](https://github.com/LuaLS/lua-language-server/issues/612)
* `FIX` [#613](https://github.com/LuaLS/lua-language-server/issues/613)
* `FIX` [#618](https://github.com/LuaLS/lua-language-server/issues/618)
* `FIX` [#620](https://github.com/LuaLS/lua-language-server/issues/620)

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
* `NEW` setting `Lua.workspace.userThirdParty`, add private user [third-parth](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd) by this setting
* `CHG` path in config supports `~/xxxx`
* `FIX` `autoRequire` inserted incorrect code
* `FIX` `autoRequire` may provide dumplicated options
* `FIX` [#606](https://github.com/LuaLS/lua-language-server/issues/606)
* `FIX` [#607](https://github.com/LuaLS/lua-language-server/issues/607)

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
* `FIX` [#596](https://github.com/LuaLS/lua-language-server/issues/596)
* `FIX` [#597](https://github.com/LuaLS/lua-language-server/issues/597)
* `FIX` [#598](https://github.com/LuaLS/lua-language-server/issues/598)
* `FIX` [#601](https://github.com/LuaLS/lua-language-server/issues/601)

## 2.2.3
`2021-7-9`
* `CHG` improve `auto require`
* `CHG` will not sleep anymore
* `FIX` incorrect doc: `debug.getlocal`
* `FIX` completion: incorrect callback
* `FIX` [#592](https://github.com/LuaLS/lua-language-server/issues/592)

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
* `NEW` supports local config file, using `--configpath="config.json"`, [learn more here](https://luals.github.io/wiki/usage/#--configpath)
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
* `CHG` [#549](https://github.com/LuaLS/lua-language-server/issues/549)
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
* `FIX` [#580](https://github.com/LuaLS/lua-language-server/issues/580)

## 2.0.4
`2021-6-25`
* `FIX` [#550](https://github.com/LuaLS/lua-language-server/issues/550)
* `FIX` [#555](https://github.com/LuaLS/lua-language-server/issues/555)
* `FIX` [#574](https://github.com/LuaLS/lua-language-server/issues/574)

## 2.0.3
`2021-6-24`
* `CHG` improve memory usage
* `FIX` some dialog boxes block the initialization process
* `FIX` diagnostics `undefined-field`: blocks main thread
* `FIX` [#565](https://github.com/LuaLS/lua-language-server/issues/565)

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
* `FIX` [#558](https://github.com/LuaLS/lua-language-server/issues/558)
* `FIX` [#567](https://github.com/LuaLS/lua-language-server/issues/567)
* `FIX` [#568](https://github.com/LuaLS/lua-language-server/issues/568)
* `FIX` [#570](https://github.com/LuaLS/lua-language-server/issues/570)
* `FIX` [#571](https://github.com/LuaLS/lua-language-server/issues/571)

## 2.0.1
`2021-6-21`
* `FIX` [#566](https://github.com/LuaLS/lua-language-server/issues/566)

## 2.0.0
`2021-6-21`
* `NEW` implement
* `CHG` diagnostics `undefined-field`, `deprecated`: default by `Opened` instead of `None`
* `CHG` setting `Lua.runtime.plugin`: default by `""` instead of `".vscode/lua/plugin.lua"` (for security)
* `CHG` setting `Lua.intelliSense.searchDepth`: removed
* `CHG` setting `Lua.misc.parameters`: `string array` instead of `string`
* `CHG` setting `Lua.develop.enable`, `Lua.develop.debuggerPort`, `Lua.develop.debuggerWait`: removed, use `Lua.misc.parameters` instead
* `FIX` [#441](https://github.com/LuaLS/lua-language-server/issues/441)
* `FIX` [#493](https://github.com/LuaLS/lua-language-server/issues/493)
* `FIX` [#531](https://github.com/LuaLS/lua-language-server/issues/531)
* `FIX` [#542](https://github.com/LuaLS/lua-language-server/issues/542)
* `FIX` [#543](https://github.com/LuaLS/lua-language-server/issues/543)
* `FIX` [#553](https://github.com/LuaLS/lua-language-server/issues/553)
* `FIX` [#562](https://github.com/LuaLS/lua-language-server/issues/562)
* `FIX` [#563](https://github.com/LuaLS/lua-language-server/issues/563)

## 1.21.3
`2021-6-17`
* `NEW` supports `untrusted workspaces`
* `FIX` performance issues, thanks to [folke](https://github.com/folke)

## 1.21.2
`2021-5-18`
* `FIX` loaded new file with ignored filename
* `FIX` [#536](https://github.com/LuaLS/lua-language-server/issues/536)
* `FIX` [#537](https://github.com/LuaLS/lua-language-server/issues/537)
* `FIX` [#538](https://github.com/LuaLS/lua-language-server/issues/538)
* `FIX` [#539](https://github.com/LuaLS/lua-language-server/issues/539)

## 1.21.1
`2021-5-8`
* `FIX` [#529](https://github.com/LuaLS/lua-language-server/issues/529)

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
* `FIX` [#522](https://github.com/LuaLS/lua-language-server/issues/522)
* `FIX` [#523](https://github.com/LuaLS/lua-language-server/issues/523)

## 1.20.4
`2021-4-13`
* `NEW` diagnostic: `deprecated`
* `FIX` [#464](https://github.com/LuaLS/lua-language-server/issues/464)
* `FIX` [#497](https://github.com/LuaLS/lua-language-server/issues/497)
* `FIX` [#502](https://github.com/LuaLS/lua-language-server/issues/502)

## 1.20.3
`2021-4-6`
* `FIX` [#479](https://github.com/LuaLS/lua-language-server/issues/479)
* `FIX` [#483](https://github.com/LuaLS/lua-language-server/issues/483)
* `FIX` [#485](https://github.com/LuaLS/lua-language-server/issues/485)
* `FIX` [#487](https://github.com/LuaLS/lua-language-server/issues/487)
* `FIX` [#488](https://github.com/LuaLS/lua-language-server/issues/488)
* `FIX` [#490](https://github.com/LuaLS/lua-language-server/issues/490)
* `FIX` [#495](https://github.com/LuaLS/lua-language-server/issues/495)

## 1.20.2
`2021-4-2`
* `CHG` `LuaDoc`: supports `---@param self TYPE`
* `CHG` completion: does not show suggests after `\n`, `{` and `,`, unless your setting `editor.acceptSuggestionOnEnter` is `off`
* `FIX` [#482](https://github.com/LuaLS/lua-language-server/issues/482)

## 1.20.1
`2021-3-27`
* `FIX` telemetry window blocks initializing
* `FIX` [#468](https://github.com/LuaLS/lua-language-server/issues/468)

## 1.20.0
`2021-3-27`
* `CHG` telemetry: change to opt-in, see [#462](https://github.com/LuaLS/lua-language-server/issues/462) and [Privacy-Policy](https://luals.github.io/privacy/#language-server)
* `FIX` [#467](https://github.com/LuaLS/lua-language-server/issues/467)

## 1.19.1
`2021-3-22`
* `CHG` improve performance
* `FIX` [#457](https://github.com/LuaLS/lua-language-server/issues/457)
* `FIX` [#458](https://github.com/LuaLS/lua-language-server/issues/458)

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
* `FIX` [#452](https://github.com/LuaLS/lua-language-server/issues/452)

## 1.18.1
`2021-3-10`
* `CHG` semantic-tokens: improve colors of `const` and `close`
* `CHG` type-formating: improve execution conditions
* `FIX` [#444](https://github.com/LuaLS/lua-language-server/issues/444)

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
* `FIX` [#443](https://github.com/LuaLS/lua-language-server/issues/443)
* `FIX` [#445](https://github.com/LuaLS/lua-language-server/issues/445)

## 1.17.4
`2021-3-4`
* `FIX` [#437](https://github.com/LuaLS/lua-language-server/issues/437) again
* `FIX` [#438](https://github.com/LuaLS/lua-language-server/issues/438)

## 1.17.3
`2021-3-3`
* `CHG` intelli-scense: treat `V[]` as `table<integer, V>` in `pairs`
* `FIX` completion: `detail` disappears during continuous input
* `FIX` [#435](https://github.com/LuaLS/lua-language-server/issues/435)
* `FIX` [#436](https://github.com/LuaLS/lua-language-server/issues/436)
* `FIX` [#437](https://github.com/LuaLS/lua-language-server/issues/437)

## 1.17.2
`2021-3-2`
* `FIX` running in Windows

## 1.17.1
`2021-3-1`
* `CHG` intelli-scense: improve infer across `table<K, V>` and `V[]`.
* `CHG` intelli-scense: improve infer across `pairs` and `ipairs`
* `FIX` hover: shows nothing when hovering unknown function
* `FIX` [#398](https://github.com/LuaLS/lua-language-server/issues/398)
* `FIX` [#421](https://github.com/LuaLS/lua-language-server/issues/421)
* `FIX` [#422](https://github.com/LuaLS/lua-language-server/issues/422)

## 1.17.0
`2021-2-24`
* `NEW` diagnostic: `duplicate-set-field`
* `NEW` diagnostic: `no-implicit-any`, disabled by default
* `CHG` completion: improve field and table
* `CHG` improve infer cross `ipairs`
* `CHG` cache globals when loading
* `CHG` completion: remove trigger character `\n` for now, see [#401](https://github.com/LuaLS/lua-language-server/issues/401)
* `FIX` diagnositc: may open file with wrong uri case
* `FIX` [#406](https://github.com/LuaLS/lua-language-server/issues/406)

## 1.16.1
`2021-2-22`
* `FIX` signature: parameters may be misplaced
* `FIX` completion: interface in nested table
* `FIX` completion: interface not show after `,`
* `FIX` [#400](https://github.com/LuaLS/lua-language-server/issues/400)
* `FIX` [#402](https://github.com/LuaLS/lua-language-server/issues/402)
* `FIX` [#403](https://github.com/LuaLS/lua-language-server/issues/403)
* `FIX` [#404](https://github.com/LuaLS/lua-language-server/issues/404)
* `FIX` runtime errors

## 1.16.0
`2021-2-20`
* `NEW` file encoding supports `ansi`
* `NEW` completion: supports interface, see [#384](https://github.com/LuaLS/lua-language-server/issues/384)
* `NEW` `LuaDoc`: supports multiple class inheritance: `---@class Food: Burger, Pizza, Pie, Pasta`
* `CHG` rename `table*` to `tablelib`
* `CHG` `LuaDoc`: revert compatible with `--@`, see [#392](https://github.com/LuaLS/lua-language-server/issues/392)
* `CHG` improve performance
* `FIX` missed syntax error `f() = 1`
* `FIX` missed global `bit` in `LuaJIT`
* `FIX` completion: may insert error text when continuous inputing
* `FIX` completion: may insert error text after resolve
* `FIX` [#349](https://github.com/LuaLS/lua-language-server/issues/349)
* `FIX` [#396](https://github.com/LuaLS/lua-language-server/issues/396)

## 1.15.1
`2021-2-18`
* `CHG` diagnostic: `unused-local` excludes `doc.param`
* `CHG` definition: excludes values, see [#391](https://github.com/LuaLS/lua-language-server/issues/391)
* `FIX` not works on Linux and macOS

## 1.15.0
`2021-2-9`
* `NEW` LUNAR YEAR, BE HAPPY!
* `CHG` diagnostic: when there are too many errors, the main errors will be displayed first
* `CHG` main thread no longer loop sleeps, see [#329](https://github.com/LuaLS/lua-language-server/issues/329) [#386](https://github.com/LuaLS/lua-language-server/issues/386)
* `CHG` improve performance

## 1.14.3
`2021-2-8`
* `CHG` hint: disabled by default, see [#380](https://github.com/LuaLS/lua-language-server/issues/380)
* `FIX` [#381](https://github.com/LuaLS/lua-language-server/issues/381)
* `FIX` [#382](https://github.com/LuaLS/lua-language-server/issues/382)
* `FIX` [#388](https://github.com/LuaLS/lua-language-server/issues/388)

## 1.14.2
`2021-2-4`
* `FIX` [#356](https://github.com/LuaLS/lua-language-server/issues/356)
* `FIX` [#375](https://github.com/LuaLS/lua-language-server/issues/375)
* `FIX` [#376](https://github.com/LuaLS/lua-language-server/issues/376)
* `FIX` [#377](https://github.com/LuaLS/lua-language-server/issues/377)
* `FIX` [#378](https://github.com/LuaLS/lua-language-server/issues/378)
* `FIX` [#379](https://github.com/LuaLS/lua-language-server/issues/379)
* `FIX` a lot of runtime errors

## 1.14.1
`2021-2-2`
* `FIX` [#372](https://github.com/LuaLS/lua-language-server/issues/372)

## 1.14.0
`2021-2-2`
* `NEW` `VSCode` hint
* `NEW` flush cache after 5 min
* `NEW` `VSCode` help semantic color with market theme
* `CHG` create/delete/rename files no longer reload workspace
* `CHG` `LuaDoc`: compatible with `--@`
* `FIX` `VSCode` settings
* `FIX` [#368](https://github.com/LuaLS/lua-language-server/issues/368)
* `FIX` [#371](https://github.com/LuaLS/lua-language-server/issues/371)

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
* `NEW` [#340](https://github.com/LuaLS/lua-language-server/pull/340): supports `---@type table<string, number>`
* `FIX` [#355](https://github.com/LuaLS/lua-language-server/pull/355)
* `FIX` [#359](https://github.com/LuaLS/lua-language-server/issues/359)
* `FIX` [#361](https://github.com/LuaLS/lua-language-server/issues/361)

## 1.11.2
`2021-1-7`
* `FIX` [#345](https://github.com/LuaLS/lua-language-server/issues/345): not works with unexpect args
* `FIX` [#346](https://github.com/LuaLS/lua-language-server/issues/346): dont modify the cache

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
* `FIX` [#339](https://github.com/LuaLS/lua-language-server/issues/339)

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
* `FIX` [#318](https://github.com/LuaLS/lua-language-server/issues/318)

## 1.7.4
`2020-12-20`
* `FIX` workspace: preload may failed

## 1.7.3
`2020-12-20`
* `FIX` luadoc: typo of `package.config`
* `FIX` [#310](https://github.com/LuaLS/lua-language-server/issues/310)

## 1.7.2
`2020-12-17`
* `CHG` completion: use custom tabsize
* `FIX` [#307](https://github.com/LuaLS/lua-language-server/issues/307)
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
    + [What data will be sent](https://github.com/LuaLS/lua-language-server/blob/master/script/service/telemetry.lua)
    + [How to use this data](https://github.com/LuaLS/lua-telemetry-server/tree/master/method)
* `CHG` diagnostic: `unused-function` ignores function with `<close>`
* `CHG` semantic: not cover local call
* `CHG` language client: update to [7.0.0](https://github.com/microsoft/vscode-languageserver-node/commit/20681d7632bb129def0c751be73cf76bd01f2f3a)
* `FIX` semantic: tokens may not be updated correctly
* `FIX` completion: require path broken
* `FIX` hover: document uri
* `FIX` [#291](https://github.com/LuaLS/lua-language-server/issues/291)
* `FIX` [#294](https://github.com/LuaLS/lua-language-server/issues/294)

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
* `FIX` [#297](https://github.com/LuaLS/lua-language-server/issues/297)

## 1.5.0
`2020-12-5`
* `NEW` setting `runtime.unicodeName`
* `NEW` fully supports `---@generic T`
* `FIX` [#274](https://github.com/LuaLS/lua-language-server/issues/274)
* `FIX` [#276](https://github.com/LuaLS/lua-language-server/issues/276)
* `FIX` [#279](https://github.com/LuaLS/lua-language-server/issues/279)
* `FIX` [#280](https://github.com/LuaLS/lua-language-server/issues/280)

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

* `FIX` syntaxes tokens: [#272](https://github.com/LuaLS/lua-language-server/issues/272)

## 1.2.0
`2020-11-27`

* `NEW` hover shows comments from `---@param` and `---@return`: [#135](https://github.com/LuaLS/lua-language-server/issues/135)
* `NEW` support `LuaDoc` as tail comment
* `FIX` `---@class` inheritance
* `FIX` missed syntaxes token: `punctuation.definition.parameters.finish.lua`

## 1.1.4
`2020-11-25`

* `FIX` wiered completion suggests for require paths in `Linux` and `macOS`: [#269](https://github.com/LuaLS/lua-language-server/issues/269)

## 1.1.3
`2020-11-25`

* `FIX` extension not works in `Ubuntu`: [#268](https://github.com/LuaLS/lua-language-server/issues/268)

## 1.1.2
`2020-11-24`

* `NEW` auto completion finds globals from `Lua.diagnostics.globals`
* `NEW` support tail `LuaDoc`
* `CHG` no more `Lua.intelliScense.fastGlobal`, now globals always fast and accurate
* `CHG` `LuaDoc` supports `--- @`
* `CHG` `find reference` uses extra `Lua.intelliSense.searchDepth`
* `CHG` diagnostics are limited by `100` in each file
* `FIX` library files are under limit of `Lua.workspace.maxPreload`: [#266](https://github.com/LuaLS/lua-language-server/issues/266)

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
* `CHG` checks if client supports `Lua.completion.enable`: [#259](https://github.com/LuaLS/lua-language-server/issues/259)
* `FIX` support for single Lua file
* `FIX` [#257](https://github.com/LuaLS/lua-language-server/issues/257)

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
* `FIX` `Lua.diagnostics.enable` not works: [#251](https://github.com/LuaLS/lua-language-server/issues/251)

## 1.0.2
`2020-11-11`

* `NEW` supports `---|` after `doc.type`
* `CHG` `lowcase-global` ignores globals with `---@class`
* `FIX` endless loop
* `FIX` [#244](https://github.com/LuaLS/lua-language-server/issues/244)

## 1.0.1
`2020-11-10`

* `FIX` autocompletion not works.

## 1.0.0
`2020-11-9`

* `NEW` implementation, NEW start!

<!-- contributors -->
[lizho]: (https://github.com/lizho)
[fesily]: (https://github.com/fesily)
[Andreas Matthias]: (https://github.com/AndreasMatthias)
[Daniel Farrell]: (https://github.com/danpf)
[Paul Emmerich]: (https://github.com/emmericp)
[Artem Dzhemesiuk]: (https://github.com/zziger)
[clay-golem]: (https://github.com/clay-golem)
