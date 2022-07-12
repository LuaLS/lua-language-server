# completion.autoRequire

输入内容看起来是个文件名时，自动 `require` 此文件。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.callSnippet

显示函数调用片段。

## type

```ts
string
```

## enum

* ``"Disable"``: 只显示 `函数名`。
* ``"Both"``: 显示 `函数名` 与 `调用片段`。
* ``"Replace"``: 只显示 `调用片段`。

## default

```jsonc
"Disable"
```

# completion.displayContext

预览建议的相关代码片段，可能可以帮助你了解这项建议的用法。设置的数字表示代码片段的截取行数，设置为`0`可以禁用此功能。

## type

```ts
integer
```

## default

```jsonc
0
```

# completion.enable

启用自动完成。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.keywordSnippet

显示关键字语法片段

## type

```ts
string
```

## enum

* ``"Disable"``: 只显示 `关键字`。
* ``"Both"``: 显示 `关键字` 与 `语法片段`。
* ``"Replace"``: 只显示 `语法片段`。

## default

```jsonc
"Replace"
```

# completion.postfix

用于触发后缀建议的符号。

## type

```ts
string
```

## default

```jsonc
"@"
```

# completion.requireSeparator

`require` 时使用的分隔符。

## type

```ts
string
```

## default

```jsonc
"."
```

# completion.showParams

在建议列表中显示函数的参数信息，函数拥有多个定义时会分开显示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.showWord

在建议中显示上下文单词。

## type

```ts
string
```

## enum

* ``"Enable"``: 总是在建议中显示上下文单词。
* ``"Fallback"``: 无法根据语义提供建议时才显示上下文单词。
* ``"Disable"``: 不显示上下文单词。

## default

```jsonc
"Fallback"
```

# completion.workspaceWord

显示的上下文单词是否包含工作区中其他文件的内容。

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.disable

禁用的诊断（使用浮框括号内的代码）。

## type

```ts
Array<string>
```

## enum

* ``"action-after-return"``
* ``"ambiguity-1"``
* ``"args-after-dots"``
* ``"assign-type-mismatch"``
* ``"await-in-sync"``
* ``"block-after-else"``
* ``"break-outside"``
* ``"cast-local-type"``
* ``"cast-type-mismatch"``
* ``"circle-doc-class"``
* ``"close-non-object"``
* ``"code-after-break"``
* ``"codestyle-check"``
* ``"count-down-loop"``
* ``"deprecated"``
* ``"different-requires"``
* ``"discard-returns"``
* ``"doc-field-no-class"``
* ``"duplicate-doc-alias"``
* ``"duplicate-doc-field"``
* ``"duplicate-doc-param"``
* ``"duplicate-index"``
* ``"duplicate-set-field"``
* ``"empty-block"``
* ``"err-assign-as-eq"``
* ``"err-c-long-comment"``
* ``"err-comment-prefix"``
* ``"err-do-as-then"``
* ``"err-eq-as-assign"``
* ``"err-esc"``
* ``"err-nonstandard-symbol"``
* ``"err-then-as-do"``
* ``"exp-in-action"``
* ``"global-in-nil-env"``
* ``"index-in-func-name"``
* ``"jump-local-scope"``
* ``"keyword"``
* ``"local-limit"``
* ``"lowercase-global"``
* ``"malformed-number"``
* ``"miss-end"``
* ``"miss-esc-x"``
* ``"miss-exp"``
* ``"miss-exponent"``
* ``"miss-field"``
* ``"miss-loop-max"``
* ``"miss-loop-min"``
* ``"miss-method"``
* ``"miss-name"``
* ``"miss-sep-in-table"``
* ``"miss-space-between"``
* ``"miss-symbol"``
* ``"missing-parameter"``
* ``"missing-return"``
* ``"missing-return-value"``
* ``"need-check-nil"``
* ``"newfield-call"``
* ``"newline-call"``
* ``"no-unknown"``
* ``"no-visible-label"``
* ``"not-yieldable"``
* ``"param-type-mismatch"``
* ``"redefined-label"``
* ``"redefined-local"``
* ``"redundant-parameter"``
* ``"redundant-return"``
* ``"redundant-return-value"``
* ``"redundant-value"``
* ``"return-type-mismatch"``
* ``"set-const"``
* ``"spell-check"``
* ``"trailing-space"``
* ``"unbalanced-assignments"``
* ``"undefined-doc-class"``
* ``"undefined-doc-name"``
* ``"undefined-doc-param"``
* ``"undefined-env-child"``
* ``"undefined-field"``
* ``"undefined-global"``
* ``"unexpect-dots"``
* ``"unexpect-efunc-name"``
* ``"unexpect-lfunc-name"``
* ``"unexpect-symbol"``
* ``"unicode-name"``
* ``"unknown-attribute"``
* ``"unknown-cast-variable"``
* ``"unknown-diag-code"``
* ``"unknown-operator"``
* ``"unknown-symbol"``
* ``"unreachable-code"``
* ``"unsupport-symbol"``
* ``"unused-function"``
* ``"unused-label"``
* ``"unused-local"``
* ``"unused-vararg"``

## default

```jsonc
[]
```

# diagnostics.disableScheme

不诊断使用以下 scheme 的lua文件。

## type

```ts
Array<string>
```

## default

```jsonc
["git"]
```

# diagnostics.enable

启用诊断。

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.globals

已定义的全局变量。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.groupFileStatus

批量修改一个组中的文件状态。

* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* None:    禁用此诊断

设置为 `Fallback` 意味着组中的诊断由 `diagnostics.neededFileStatus` 单独设置。
其他设置将覆盖单独设置，但是不会覆盖以 `!` 结尾的设置。


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
    * unknown-operator
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
    * unreachable-code
    * unused-function
    * unused-label
    * unused-local
    * unused-vararg
    */
    "unused": "Fallback"
}
```

# diagnostics.groupSeverity

批量修改一个组中的诊断等级。
设置为 `Fallback` 意味着组中的诊断由 `diagnostics.severity` 单独设置。
其他设置将覆盖单独设置，但是不会覆盖以 `!` 结尾的设置。


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
    * unknown-operator
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
    * unreachable-code
    * unused-function
    * unused-label
    * unused-local
    * unused-vararg
    */
    "unused": "Fallback"
}
```

# diagnostics.ignoredFiles

如何诊断被忽略的文件。

## type

```ts
string
```

## enum

* ``"Enable"``: 总是诊断这些文件。
* ``"Opened"``: 只有打开这些文件时才会诊断。
* ``"Disable"``: 不诊断这些文件。

## default

```jsonc
"Opened"
```

# diagnostics.libraryFiles

如何诊断通过 `Lua.workspace.library` 加载的文件。

## type

```ts
string
```

## enum

* ``"Enable"``: 总是诊断这些文件。
* ``"Opened"``: 只有打开这些文件时才会诊断。
* ``"Disable"``: 不诊断这些文件。

## default

```jsonc
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* None:    禁用此诊断

以 `!` 结尾的设置优先级高于组设置 `diagnostics.groupFileStatus`。


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
    "unknown-operator": "Any",
    "unreachable-code": "Opened",
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

修改诊断等级。
以 `!` 结尾的设置优先级高于组设置 `diagnostics.groupSeverity`。


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
    "unknown-operator": "Warning",
    "unreachable-code": "Hint",
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

# diagnostics.unusedLocalExclude

如果变量名匹配以下规则，则不对其进行 `unused-local` 诊断。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.workspaceDelay

进行工作区诊断的延迟（毫秒）。当你启动工作区，或编辑了任意文件后，将会在后台对整个工作区进行重新诊断。设置为负数可以禁用工作区诊断。

## type

```ts
integer
```

## default

```jsonc
3000
```

# diagnostics.workspaceRate

工作区诊断的运行速率（百分比）。降低该值会减少CPU占用，但是也会降低工作区诊断的速度。你当前正在编辑的文件的诊断总是全速完成，不受该选项影响。

## type

```ts
integer
```

## default

```jsonc
100
```

# format.defaultConfig

默认的格式化配置，优先级低于工作区内的 `.editorconfig` 文件。
请查阅[格式化文档](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)了解用法。


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# format.enable

启用代码格式化程序。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.arrayIndex

在构造表时提示数组索引。

## type

```ts
string
```

## enum

* ``"Enable"``: 所有的表中都提示数组索引。
* ``"Auto"``: 只有表大于3项，或者表是混合类型时才进行提示。
* ``"Disable"``: 禁用数组索引提示。

## default

```jsonc
"Auto"
```

# hint.await

如果调用的函数被标记为了 `---@async` ，则在调用处提示 `await` 。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.enable

启用内联提示。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.paramName

在函数调用处提示参数名。

## type

```ts
string
```

## enum

* ``"All"``: 所有类型的参数均进行提示。
* ``"Literal"``: 只有字面量类型的参数进行提示。
* ``"Disable"``: 禁用参数提示。

## default

```jsonc
"All"
```

# hint.paramType

在函数的参数位置提示类型。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.semicolon

若语句尾部没有分号，则显示虚拟分号。

## type

```ts
string
```

## enum

* ``"All"``: 所有语句都显示虚拟分号。
* ``"SameLine"``: 2个语句在同一行时，在它们之间显示分号。
* ``"Disable"``: 禁用虚拟分号。

## default

```jsonc
"SameLine"
```

# hint.setType

在赋值操作位置提示类型。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hover.enable

启用悬停提示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.enumsLimit

当值对应多个类型时，限制类型的显示数量。

## type

```ts
integer
```

## default

```jsonc
5
```

# hover.expandAlias

是否展开别名。例如 `---@alias myType boolean|number` 展开后显示为 `boolean|number`，否则显示为 `myType`。


## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.previewFields

悬停提示查看表时，限制表内字段的最大预览数量。

## type

```ts
integer
```

## default

```jsonc
50
```

# hover.viewNumber

悬停提示查看数字内容（仅当字面量不是十进制时）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewString

悬停提示查看字符串内容（仅当字面量包含转义符时）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewStringMax

悬停提示查看字符串内容时的最大长度。

## type

```ts
integer
```

## default

```jsonc
1000
```

# misc.parameters

VSCode中启动语言服务时的[命令行参数](https://github.com/sumneko/lua-language-server/wiki/Command-line)。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# runtime.builtin

调整内置库的启用状态，你可以根据实际运行环境禁用掉不存在的库（或重新定义）。

* `default`: 表示库会根据运行版本启用或禁用
* `enable`: 总是启用
* `disable`: 总是禁用


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
    "table.clear": "default",
    "table.new": "default",
    "utf8": "default"
}
```

# runtime.fileEncoding

文件编码，`ansi` 选项只在 `Windows` 平台下有效。

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

meta文件的目录名称格式。

## type

```ts
string
```

## default

```jsonc
"${version} ${language} ${encoding}"
```

# runtime.nonstandardSymbol

支持非标准的符号。请务必确认你的运行环境支持这些符号。

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

当使用 `require` 时，如何根据输入的名字来查找文件。
此选项设置为 `?/init.lua` 意味着当你输入 `require 'myfile'` 时，会从已加载的文件中搜索 `{workspace}/myfile/init.lua`。
当 `runtime.pathStrict` 设置为 `false` 时，还会尝试搜索 `${workspace}/**/myfile/init.lua`。
如果你想要加载工作区以外的文件，你需要先设置 `Lua.workspace.library`。


## type

```ts
Array<string>
```

## default

```jsonc
["?.lua","?/init.lua"]
```

# runtime.pathStrict

启用后 `runtime.path` 将只搜索第一层目录，见 `runtime.path` 的说明。

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.plugin

插件路径，请查阅[文档](https://github.com/sumneko/lua-language-server/wiki/Plugin)了解用法。

## type

```ts
string
```

## default

```jsonc
""
```

# runtime.special

将自定义全局变量视为一些特殊的内置变量，语言服务将提供特殊的支持。
下面这个例子表示将 `include` 视为 `require` 。
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

允许在名字中使用 Unicode 字符。

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.version

Lua运行版本。

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

对类型注解进行语义着色。

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.enable

启用语义着色。你可能需要同时将 `editor.semanticHighlighting.enabled` 设置为 `true` 才能生效。

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.keyword

对关键字/字面量/运算符进行语义着色。只有当你的编辑器无法进行语法着色时才需要启用此功能。

## type

```ts
boolean
```

## default

```jsonc
false
```

# semantic.variable

对变量/字段/参数进行语义着色。

## type

```ts
boolean
```

## default

```jsonc
true
```

# signatureHelp.enable

启用参数提示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# spell.dict

拼写检查的自定义单词。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# telemetry.enable

启用遥测，通过网络发送你的编辑器信息与错误日志。在[此处](https://github.com/sumneko/lua-language-server/wiki/%E9%9A%90%E7%A7%81%E5%A3%B0%E6%98%8E)阅读我们的隐私声明。


## type

```ts
boolean | null
```

## default

```jsonc
null
```

# type.castNumberToInteger

允许将 `number` 类型赋给 `integer` 类型。

## type

```ts
boolean
```

## default

```jsonc
false
```

# type.weakNilCheck

对联合类型进行类型检查时，忽略其中的 `nil`。

此设置为 `false` 时，`numer|nil` 类型无法赋给 `number` 类型；为 `true` 是则可以。


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.weakUnionCheck

联合类型中只要有一个子类型满足条件，则联合类型也满足条件。

此设置为 `false` 时，`number|boolean` 类型无法赋给 `number` 类型；为 `true` 时则可以。


## type

```ts
boolean
```

## default

```jsonc
false
```

# window.progressBar

在状态栏显示进度条。

## type

```ts
boolean
```

## default

```jsonc
true
```

# window.statusBar

在状态栏显示插件状态。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.checkThirdParty

自动检测与适配第三方库，目前支持的库为：

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

忽略的文件与目录（使用 `.gitignore` 语法）。

## type

```ts
Array<string>
```

## default

```jsonc
[".vscode"]
```

# workspace.ignoreSubmodules

忽略子模块。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.library

除了当前工作区以外，还会从哪些目录中加载文件。这些目录中的文件将被视作外部提供的代码库，部分操作（如重命名字段）不会修改这些文件。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# workspace.maxPreload

最大预加载文件数。

## type

```ts
integer
```

## default

```jsonc
5000
```

# workspace.preloadFileSize

预加载时跳过大小大于该值（KB）的文件。

## type

```ts
integer
```

## default

```jsonc
500
```

# workspace.supportScheme

为以下 scheme 的lua文件提供语言服务。

## type

```ts
Array<string>
```

## default

```jsonc
["file","untitled","git"]
```

# workspace.useGitIgnore

忽略 `.gitignore` 中列举的文件。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.userThirdParty

在这里添加私有的第三方库适配文件路径，请参考内置的[配置文件路径](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)

## type

```ts
Array<string>
```

## default

```jsonc
[]
```