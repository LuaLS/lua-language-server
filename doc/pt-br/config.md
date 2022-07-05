# completion.autoRequire

When the input looks like a file name, automatically `require` this file.

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.callSnippet

Shows function call snippets.

## type

```ts
string
```

## enum

* ``"Disable"``: Only shows `function name`.
* ``"Both"``: Shows `function name` and `call snippet`.
* ``"Replace"``: Only shows `call snippet.`

## default

```jsonc
"Disable"
```

# completion.displayContext

Previewing the relevant code snippet of the suggestion may help you understand the usage of the suggestion. The number set indicates the number of intercepted lines in the code fragment. If it is set to `0`, this feature can be disabled.

## type

```ts
integer
```

## default

```jsonc
0
```

# completion.enable

Enable completion.

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.keywordSnippet

Shows keyword syntax snippets.

## type

```ts
string
```

## enum

* ``"Disable"``: Only shows `keyword`.
* ``"Both"``: Shows `keyword` and `syntax snippet`.
* ``"Replace"``: Only shows `syntax snippet`.

## default

```jsonc
"Replace"
```

# completion.postfix

The symbol used to trigger the postfix suggestion.

## type

```ts
string
```

## default

```jsonc
"@"
```

# completion.requireSeparator

The separator used when `require`.

## type

```ts
string
```

## default

```jsonc
"."
```

# completion.showParams

Display parameters in completion list. When the function has multiple definitions, they will be displayed separately.

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.showWord

Show contextual words in suggestions.

## type

```ts
string
```

## enum

* ``"Enable"``: Always show context words in suggestions.
* ``"Fallback"``: Contextual words are only displayed when suggestions based on semantics cannot be provided.
* ``"Disable"``: Do not display context words.

## default

```jsonc
"Fallback"
```

# completion.workspaceWord

Whether the displayed context word contains the content of other files in the workspace.

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.disable

Disabled diagnostic (Use code in hover brackets).

## type

```ts
Array<string>
```

## enum

* ``"not-yieldable"``
* ``"redundant-parameter"``
* ``"break-outside"``
* ``"undefined-doc-class"``
* ``"unknown-symbol"``
* ``"miss-method"``
* ``"err-nonstandard-symbol"``
* ``"unknown-attribute"``
* ``"unexpect-efunc-name"``
* ``"different-requires"``
* ``"miss-end"``
* ``"await-in-sync"``
* ``"args-after-dots"``
* ``"err-eq-as-assign"``
* ``"newfield-call"``
* ``"err-assign-as-eq"``
* ``"undefined-doc-param"``
* ``"param-type-mismatch"``
* ``"global-in-nil-env"``
* ``"missing-parameter"``
* ``"miss-sep-in-table"``
* ``"unknown-cast-variable"``
* ``"miss-loop-min"``
* ``"malformed-number"``
* ``"err-do-as-then"``
* ``"spell-check"``
* ``"undefined-env-child"``
* ``"missing-return-value"``
* ``"discard-returns"``
* ``"redundant-return"``
* ``"miss-esc-x"``
* ``"redundant-value"``
* ``"duplicate-doc-alias"``
* ``"doc-field-no-class"``
* ``"no-visible-label"``
* ``"miss-exp"``
* ``"miss-loop-max"``
* ``"miss-name"``
* ``"empty-block"``
* ``"unused-local"``
* ``"err-then-as-do"``
* ``"duplicate-doc-field"``
* ``"redefined-label"``
* ``"exp-in-action"``
* ``"set-const"``
* ``"circle-doc-class"``
* ``"unexpect-lfunc-name"``
* ``"unsupport-symbol"``
* ``"unused-label"``
* ``"action-after-return"``
* ``"unexpect-dots"``
* ``"newline-call"``
* ``"jump-local-scope"``
* ``"close-non-object"``
* ``"miss-field"``
* ``"count-down-loop"``
* ``"cast-type-mismatch"``
* ``"duplicate-index"``
* ``"unexpect-symbol"``
* ``"block-after-else"``
* ``"unicode-name"``
* ``"miss-exponent"``
* ``"err-esc"``
* ``"redundant-return-value"``
* ``"unbalanced-assignments"``
* ``"err-c-long-comment"``
* ``"undefined-doc-name"``
* ``"ambiguity-1"``
* ``"trailing-space"``
* ``"deprecated"``
* ``"codestyle-check"``
* ``"missing-return"``
* ``"undefined-global"``
* ``"unused-function"``
* ``"code-after-break"``
* ``"assign-type-mismatch"``
* ``"local-limit"``
* ``"cast-local-type"``
* ``"need-check-nil"``
* ``"keyword"``
* ``"unknown-diag-code"``
* ``"unused-vararg"``
* ``"err-comment-prefix"``
* ``"lowercase-global"``
* ``"return-type-mismatch"``
* ``"duplicate-set-field"``
* ``"redefined-local"``
* ``"no-unknown"``
* ``"duplicate-doc-param"``
* ``"index-in-func-name"``
* ``"miss-symbol"``
* ``"undefined-field"``
* ``"miss-space-between"``

## default

```jsonc
[]
```

# diagnostics.disableScheme

Do not diagnose Lua files that use the following scheme.

## type

```ts
Array<string>
```

## default

```jsonc
["git"]
```

# diagnostics.enable

Enable diagnostics.

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.globals

Defined global variables.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.groupFileStatus

Modify the diagnostic needed file status in a group.

* Opened:  only diagnose opened files
* Any:     diagnose all files
* None:    disable this diagnostic

`Fallback` means that diagnostics in this group are controlled by `diagnostics.neededFileStatus` separately.
Other settings will override individual settings without end of `!`.


## type

```ts
object<string, string>
```

## enum

* ``"Any"``
* ``"Opened"``
* ``"None"``
* ``"Fallback"``

## default

```jsonc
{
    /*
    * ambiguity-1
    * count-down-loop
    * different-requires
    * newfield-call
    * newline-call
    */
    "ambiguity": "Fallback",
    /*
    * await-in-sync
    * not-yieldable
    */
    "await": "Fallback",
    /*
    * codestyle-check
    * spell-check
    */
    "codestyle": "Fallback",
    /*
    * duplicate-index
    * duplicate-set-field
    */
    "duplicate": "Fallback",
    /*
    * global-in-nil-env
    * lowercase-global
    * undefined-env-child
    * undefined-global
    */
    "global": "Fallback",
    /*
    * cast-type-mismatch
    * circle-doc-class
    * doc-field-no-class
    * duplicate-doc-alias
    * duplicate-doc-field
    * duplicate-doc-param
    * undefined-doc-class
    * undefined-doc-name
    * undefined-doc-param
    * unknown-cast-variable
    * unknown-diag-code
    */
    "luadoc": "Fallback",
    /*
    * redefined-local
    */
    "redefined": "Fallback",
    /*
    * close-non-object
    * deprecated
    * discard-returns
    */
    "strict": "Fallback",
    /*
    * no-unknown
    */
    "strong": "Fallback",
    /*
    * assign-type-mismatch
    * cast-local-type
    * cast-type-mismatch
    * need-check-nil
    * param-type-mismatch
    * return-type-mismatch
    * undefined-field
    */
    "type-check": "Fallback",
    /*
    * missing-parameter
    * missing-return
    * missing-return-value
    * redundant-parameter
    * redundant-return-value
    * redundant-value
    * unbalanced-assignments
    */
    "unbalanced": "Fallback",
    /*
    * code-after-break
    * empty-block
    * redundant-return
    * trailing-space
    * unused-function
    * unused-label
    * unused-local
    * unused-vararg
    */
    "unused": "Fallback"
}
```

# diagnostics.groupSeverity

Modify the diagnostic severity in a group.
`Fallback` means that diagnostics in this group are controlled by `diagnostics.severity` separately.
Other settings will override individual settings without end of `!`.


## type

```ts
object<string, string>
```

## enum

* ``"Error"``
* ``"Warning"``
* ``"Information"``
* ``"Hint"``
* ``"Fallback"``

## default

```jsonc
{
    /*
    * ambiguity-1
    * count-down-loop
    * different-requires
    * newfield-call
    * newline-call
    */
    "ambiguity": "Fallback",
    /*
    * await-in-sync
    * not-yieldable
    */
    "await": "Fallback",
    /*
    * codestyle-check
    * spell-check
    */
    "codestyle": "Fallback",
    /*
    * duplicate-index
    * duplicate-set-field
    */
    "duplicate": "Fallback",
    /*
    * global-in-nil-env
    * lowercase-global
    * undefined-env-child
    * undefined-global
    */
    "global": "Fallback",
    /*
    * cast-type-mismatch
    * circle-doc-class
    * doc-field-no-class
    * duplicate-doc-alias
    * duplicate-doc-field
    * duplicate-doc-param
    * undefined-doc-class
    * undefined-doc-name
    * undefined-doc-param
    * unknown-cast-variable
    * unknown-diag-code
    */
    "luadoc": "Fallback",
    /*
    * redefined-local
    */
    "redefined": "Fallback",
    /*
    * close-non-object
    * deprecated
    * discard-returns
    */
    "strict": "Fallback",
    /*
    * no-unknown
    */
    "strong": "Fallback",
    /*
    * assign-type-mismatch
    * cast-local-type
    * cast-type-mismatch
    * need-check-nil
    * param-type-mismatch
    * return-type-mismatch
    * undefined-field
    */
    "type-check": "Fallback",
    /*
    * missing-parameter
    * missing-return
    * missing-return-value
    * redundant-parameter
    * redundant-return-value
    * redundant-value
    * unbalanced-assignments
    */
    "unbalanced": "Fallback",
    /*
    * code-after-break
    * empty-block
    * redundant-return
    * trailing-space
    * unused-function
    * unused-label
    * unused-local
    * unused-vararg
    */
    "unused": "Fallback"
}
```

# diagnostics.ignoredFiles

How to diagnose ignored files.

## type

```ts
string
```

## enum

* ``"Enable"``: Always diagnose these files.
* ``"Opened"``: Only when these files are opened will it be diagnosed.
* ``"Disable"``: These files are not diagnosed.

## default

```jsonc
"Opened"
```

# diagnostics.libraryFiles

How to diagnose files loaded via `Lua.workspace.library`.

## type

```ts
string
```

## enum

* ``"Enable"``: Always diagnose these files.
* ``"Opened"``: Only when these files are opened will it be diagnosed.
* ``"Disable"``: These files are not diagnosed.

## default

```jsonc
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  only diagnose opened files
* Any:     diagnose all files
* None:    disable this diagnostic

End with `!` means override the group setting `diagnostics.groupFileStatus`.


## type

```ts
object<string, string>
```

## enum

* ``"Any"``
* ``"Opened"``
* ``"None"``
* ``"Any!"``
* ``"Opened!"``
* ``"None!"``

## default

```jsonc
{
    /*
    优先级歧义，如：`num or 0 + 1`，推测用户的实际期望为 `(num or 0) + 1` 
    */
    "ambiguity-1": "Any",
    "assign-type-mismatch": "Opened",
    "await-in-sync": "None",
    "cast-local-type": "Opened",
    "cast-type-mismatch": "Any",
    "circle-doc-class": "Any",
    "close-non-object": "Any",
    "code-after-break": "Opened",
    "codestyle-check": "None",
    "count-down-loop": "Any",
    "deprecated": "Any",
    "different-requires": "Any",
    "discard-returns": "Any",
    "doc-field-no-class": "Any",
    "duplicate-doc-alias": "Any",
    "duplicate-doc-field": "Any",
    "duplicate-doc-param": "Any",
    /*
    在字面量表中重复定义了索引
    */
    "duplicate-index": "Any",
    "duplicate-set-field": "Any",
    /*
    空代码块
    */
    "empty-block": "Opened",
    /*
    不能使用全局变量（ `_ENV` 被设置为了 `nil`）
    */
    "global-in-nil-env": "Any",
    /*
    首字母小写的全局变量定义
    */
    "lowercase-global": "Any",
    "missing-parameter": "Any",
    "missing-return": "Any",
    "missing-return-value": "Any",
    "need-check-nil": "Opened",
    /*
    在字面量表中，2行代码之间缺少分隔符，在语法上被解析为了一次索引操作
    */
    "newfield-call": "Any",
    /*
    以 `(` 开始的新行，在语法上被解析为了上一行的函数调用
    */
    "newline-call": "Any",
    "no-unknown": "None",
    "not-yieldable": "None",
    "param-type-mismatch": "Opened",
    /*
    重复定义的局部变量
    */
    "redefined-local": "Opened",
    /*
    函数调用时，传入了多余的参数
    */
    "redundant-parameter": "Any",
    "redundant-return": "Opened",
    "redundant-return-value": "Any",
    /*
    赋值操作时，值的数量比被赋值的对象多
    */
    "redundant-value": "Any",
    "return-type-mismatch": "Opened",
    "spell-check": "None",
    /*
    后置空格
    */
    "trailing-space": "Opened",
    "unbalanced-assignments": "Any",
    "undefined-doc-class": "Any",
    "undefined-doc-name": "Any",
    "undefined-doc-param": "Any",
    /*
    `_ENV` 被设置为了新的字面量表，但是试图获取的全局变量不再这张表中
    */
    "undefined-env-child": "Any",
    "undefined-field": "Opened",
    /*
    未定义的全局变量
    */
    "undefined-global": "Any",
    "unknown-cast-variable": "Any",
    "unknown-diag-code": "Any",
    /*
    未使用的函数
    */
    "unused-function": "Opened",
    /*
    未使用的标签
    */
    "unused-label": "Opened",
    /*
    未使用的局部变量
    */
    "unused-local": "Opened",
    /*
    未使用的不定参数
    */
    "unused-vararg": "Opened"
}
```

# diagnostics.severity

Modify the diagnostic severity.

End with `!` means override the group setting `diagnostics.groupSeverity`.


## type

```ts
object<string, string>
```

## enum

* ``"Error"``
* ``"Warning"``
* ``"Information"``
* ``"Hint"``
* ``"Error!"``
* ``"Warning!"``
* ``"Information!"``
* ``"Hint!"``

## default

```jsonc
{
    /*
    优先级歧义，如：`num or 0 + 1`，推测用户的实际期望为 `(num or 0) + 1` 
    */
    "ambiguity-1": "Warning",
    "assign-type-mismatch": "Warning",
    "await-in-sync": "Warning",
    "cast-local-type": "Warning",
    "cast-type-mismatch": "Warning",
    "circle-doc-class": "Warning",
    "close-non-object": "Warning",
    "code-after-break": "Hint",
    "codestyle-check": "Warning",
    "count-down-loop": "Warning",
    "deprecated": "Warning",
    "different-requires": "Warning",
    "discard-returns": "Warning",
    "doc-field-no-class": "Warning",
    "duplicate-doc-alias": "Warning",
    "duplicate-doc-field": "Warning",
    "duplicate-doc-param": "Warning",
    /*
    在字面量表中重复定义了索引
    */
    "duplicate-index": "Warning",
    "duplicate-set-field": "Warning",
    /*
    空代码块
    */
    "empty-block": "Hint",
    /*
    不能使用全局变量（ `_ENV` 被设置为了 `nil`）
    */
    "global-in-nil-env": "Warning",
    /*
    首字母小写的全局变量定义
    */
    "lowercase-global": "Information",
    "missing-parameter": "Warning",
    "missing-return": "Warning",
    "missing-return-value": "Warning",
    "need-check-nil": "Warning",
    /*
    在字面量表中，2行代码之间缺少分隔符，在语法上被解析为了一次索引操作
    */
    "newfield-call": "Warning",
    /*
    以 `(` 开始的新行，在语法上被解析为了上一行的函数调用
    */
    "newline-call": "Warning",
    "no-unknown": "Warning",
    "not-yieldable": "Warning",
    "param-type-mismatch": "Warning",
    /*
    重复定义的局部变量
    */
    "redefined-local": "Hint",
    /*
    函数调用时，传入了多余的参数
    */
    "redundant-parameter": "Warning",
    "redundant-return": "Hint",
    "redundant-return-value": "Warning",
    /*
    赋值操作时，值的数量比被赋值的对象多
    */
    "redundant-value": "Warning",
    "return-type-mismatch": "Warning",
    "spell-check": "Information",
    /*
    后置空格
    */
    "trailing-space": "Hint",
    "unbalanced-assignments": "Warning",
    "undefined-doc-class": "Warning",
    "undefined-doc-name": "Warning",
    "undefined-doc-param": "Warning",
    /*
    `_ENV` 被设置为了新的字面量表，但是试图获取的全局变量不再这张表中
    */
    "undefined-env-child": "Information",
    "undefined-field": "Warning",
    /*
    未定义的全局变量
    */
    "undefined-global": "Warning",
    "unknown-cast-variable": "Warning",
    "unknown-diag-code": "Warning",
    /*
    未使用的函数
    */
    "unused-function": "Hint",
    /*
    未使用的标签
    */
    "unused-label": "Hint",
    /*
    未使用的局部变量
    */
    "unused-local": "Hint",
    /*
    未使用的不定参数
    */
    "unused-vararg": "Hint"
}
```

# diagnostics.workspaceDelay

Latency (milliseconds) for workspace diagnostics. When you start the workspace, or edit any file, the entire workspace will be re-diagnosed in the background. Set to negative to disable workspace diagnostics.

## type

```ts
integer
```

## default

```jsonc
3000
```

# diagnostics.workspaceRate

Workspace diagnostics run rate (%). Decreasing this value reduces CPU usage, but also reduces the speed of workspace diagnostics. The diagnosis of the file you are currently editing is always done at full speed and is not affected by this setting.

## type

```ts
integer
```

## default

```jsonc
100
```

# format.defaultConfig

The default format configuration. Has a lower priority than `.editorconfig` file in the workspace.
Read [formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) to learn usage.


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# format.enable

Enable code formatter.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.arrayIndex

Show hints of array index when constructing a table.

## type

```ts
string
```

## enum

* ``"Enable"``: Show hints in all tables.
* ``"Auto"``: Show hints only when the table is greater than 3 items, or the table is a mixed table.
* ``"Disable"``: Disable hints of array index.

## default

```jsonc
"Auto"
```

# hint.await

If the called function is marked `---@async`, prompt `await` at the call.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.enable

Enable inlay hint.

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.paramName

Show hints of parameter name at the function call.

## type

```ts
string
```

## enum

* ``"All"``: All types of parameters are shown.
* ``"Literal"``: Only literal type parameters are shown.
* ``"Disable"``: Disable parameter hints.

## default

```jsonc
"All"
```

# hint.paramType

Show type hints at the parameter of the function.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.semicolon

If there is no semicolon at the end of the statement, display a virtual semicolon.

## type

```ts
string
```

## enum

* ``"All"``: All statements display virtual semicolons.
* ``"SameLine"``: When two statements are on the same line, display a semicolon between them.
* ``"Disable"``: Disable virtual semicolons.

## default

```jsonc
"SameLine"
```

# hint.setType

Show hints of type at assignment operation.

## type

```ts
boolean
```

## default

```jsonc
false
```

# hover.enable

Enable hover.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.enumsLimit

When the value corresponds to multiple types, limit the number of types displaying.

## type

```ts
integer
```

## default

```jsonc
5
```

# hover.expandAlias

Whether to expand the alias. For example, expands `---@alias myType boolean|number` appears as `boolean|number`, otherwise it appears as `myType'.


## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.previewFields

When hovering to view a table, limits the maximum number of previews for fields.

## type

```ts
integer
```

## default

```jsonc
50
```

# hover.viewNumber

Hover to view numeric content (only if literal is not decimal).

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewString

Hover to view the contents of a string (only if the literal contains an escape character).

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewStringMax

The maximum length of a hover to view the contents of a string.

## type

```ts
integer
```

## default

```jsonc
1000
```

# misc.parameters

[Command line parameters](https://github.com/sumneko/lua-telemetry-server/tree/master/method) when starting the language service in VSCode.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# runtime.builtin

Adjust the enabled state of the built-in library. You can disable (or redefine) the non-existent library according to the actual runtime environment.

* `default`: Indicates that the library will be enabled or disabled according to the runtime version
* `enable`: always enable
* `disable`: always disable


## type

```ts
object<string, string>
```

## enum

* ``"default"``
* ``"enable"``
* ``"disable"``

## default

```jsonc
{
    "basic": "default",
    "bit": "default",
    "bit32": "default",
    "builtin": "default",
    "coroutine": "default",
    "debug": "default",
    "ffi": "default",
    "io": "default",
    "jit": "default",
    "math": "default",
    "os": "default",
    "package": "default",
    "string": "default",
    "table": "default",
    "utf8": "default"
}
```

# runtime.fileEncoding

File encoding. The `ansi` option is only available under the `Windows` platform.

## type

```ts
string
```

## enum

* ``"utf8"``
* ``"ansi"``
* ``"utf16le"``
* ``"utf16be"``

## default

```jsonc
"utf8"
```

# runtime.meta

Format of the directory name of the meta files.

## type

```ts
string
```

## default

```jsonc
"${version} ${language} ${encoding}"
```

# runtime.nonstandardSymbol

Supports non-standard symbols. Make sure that your runtime environment supports these symbols.

## type

```ts
Array<string>
```

## enum

* ``"//"``
* ``"/**/"``
* ``"`"``
* ``"+="``
* ``"-="``
* ``"*="``
* ``"/="``
* ``"%="``
* ``"^="``
* ``"//="``
* ``"|="``
* ``"&="``
* ``"<<="``
* ``">>="``
* ``"||"``
* ``"&&"``
* ``"!"``
* ``"!="``
* ``"continue"``

## default

```jsonc
[]
```

# runtime.path

When using `require`, how to find the file based on the input name.
Setting this config to `?/init.lua` means that when you enter `require 'myfile'`, `${workspace}/myfile/init.lua` will be searched from the loaded files.
if `runtime.pathStrict` is `false`, `${workspace}/**/myfile/init.lua` will also be searched.
If you want to load files outside the workspace, you need to set `Lua.workspace.library` first.


## type

```ts
Array<string>
```

## default

```jsonc
["?.lua","?/init.lua"]
```

# runtime.pathStrict

When enabled, `runtime.path` will only search the first level of directories, see the description of `runtime.path`.

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.plugin

Plugin path. Please read [wiki](https://github.com/sumneko/lua-language-server/wiki/Plugin) to learn more.

## type

```ts
string
```

## default

```jsonc
""
```

# runtime.special

The custom global variables are regarded as some special built-in variables, and the language server will provide special support
The following example shows that 'include' is treated as' require '.
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# runtime.unicodeName

Allows Unicode characters in name.

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.version

Lua runtime version.

## type

```ts
string
```

## enum

* ``"Lua 5.1"``
* ``"Lua 5.2"``
* ``"Lua 5.3"``
* ``"Lua 5.4"``
* ``"LuaJIT"``

## default

```jsonc
"Lua 5.4"
```

# semantic.annotation

Semantic coloring of type annotations.

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.enable

Enable semantic color. You may need to set `editor.semanticHighlighting.enabled` to `true` to take effect.

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.keyword

Semantic coloring of keywords/literals/operators. You only need to enable this feature if your editor cannot do syntax coloring.

## type

```ts
boolean
```

## default

```jsonc
false
```

# semantic.variable

Semantic coloring of variables/fields/parameters.

## type

```ts
boolean
```

## default

```jsonc
true
```

# signatureHelp.enable

Enable signature help.

## type

```ts
boolean
```

## default

```jsonc
true
```

# spell.dict

Custom words for spell checking.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# telemetry.enable

Enable telemetry to send your editor information and error logs over the network. Read our privacy policy [here](https://github.com/sumneko/lua-language-server/wiki/Privacy-Policy).


## type

```ts
boolean | null
```

## default

```jsonc
null
```

# type.castNumberToInteger

Allowed to assign the `number` type to the `integer` type.

## type

```ts
boolean
```

## default

```jsonc
false
```

# type.weakNilCheck

When checking the type of union type, ignore the `nil` in it.

When this setting is `false`, the `number|nil` type cannot be assigned to the `number` type. It can be with `true`.


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.weakUnionCheck

Once one subtype of a union type meets the condition, the union type also meets the condition.

When this setting is `false`, the `number|boolean` type cannot be assigned to the `number` type. It can be with `true`.


## type

```ts
boolean
```

## default

```jsonc
false
```

# window.progressBar

Show progress bar in status bar.

## type

```ts
boolean
```

## default

```jsonc
true
```

# window.statusBar

Show extension status in status bar.

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.checkThirdParty

Automatic detection and adaptation of third-party libraries, currently supported libraries are:

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass


## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.ignoreDir

Ignored files and directories (Use `.gitignore` grammar).

## type

```ts
Array<string>
```

## default

```jsonc
[".vscode"]
```

# workspace.ignoreSubmodules

Ignore submodules.

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.library

In addition to the current workspace, which directories will load files from. The files in these directories will be treated as externally provided code libraries, and some features (such as renaming fields) will not modify these files.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# workspace.maxPreload

Max preloaded files.

## type

```ts
integer
```

## default

```jsonc
5000
```

# workspace.preloadFileSize

Skip files larger than this value (KB) when preloading.

## type

```ts
integer
```

## default

```jsonc
500
```

# workspace.supportScheme

Provide language server for the Lua files of the following scheme.

## type

```ts
Array<string>
```

## default

```jsonc
["file","untitled","git"]
```

# workspace.useGitIgnore

Ignore files list in `.gitignore` .

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.userThirdParty

Add private third-party library configuration file paths here, please refer to the built-in [configuration file path](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)

## type

```ts
Array<string>
```

## default

```jsonc
[]
```