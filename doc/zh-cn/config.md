# completion.autoRequire

输入内容看起来是个文件名时，自动 `require` 此文件。

## type

```ts
boolean
```

## default

```json
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

```json
"Disable"
```

# completion.displayContext

预览建议的相关代码片段，可能可以帮助你了解这项建议的用法。设置的数字表示代码片段的截取行数，设置为`0`可以禁用此功能。

## type

```ts
integer
```

## default

```json
0
```

# completion.enable

启用自动完成。

## type

```ts
boolean
```

## default

```json
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

```json
"Replace"
```

# completion.postfix

用于触发后缀建议的符号。

## type

```ts
string
```

## default

```json
"@"
```

# completion.requireSeparator

`require` 时使用的分隔符。

## type

```ts
string
```

## default

```json
"."
```

# completion.showParams

在建议列表中显示函数的参数信息，函数拥有多个定义时会分开显示。

## type

```ts
boolean
```

## default

```json
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

```json
"Fallback"
```

# completion.workspaceWord

显示的上下文单词是否包含工作区中其他文件的内容。

## type

```ts
boolean
```

## default

```json
true
```

# diagnostics.disable

禁用的诊断（使用浮框括号内的代码）。

## type

```ts
Array<string>
```

## default

```json
[]
```

# diagnostics.disableScheme

不诊断使用以下 scheme 的lua文件。

## type

```ts
Array<string>
```

## default

```json
["git"]
```

# diagnostics.enable

启用诊断。

## type

```ts
boolean
```

## default

```json
true
```

# diagnostics.globals

已定义的全局变量。

## type

```ts
Array<string>
```

## default

```json
[]
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

```json
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

```json
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* Disable: 禁用此诊断


## type

```ts
object<string, string>
```

## enum

* ``"Any"``
* ``"Opened"``
* ``"None"``

## default

```json
{
    "ambiguity-1": "Any",
    "await-in-sync": "None",
    "circle-doc-class": "Any",
    "close-non-object": "Any",
    "code-after-break": "Opened",
    "codestyle-check": "None",
    "count-down-loop": "Any",
    "deprecated": "Opened",
    "different-requires": "Any",
    "discard-returns": "Opened",
    "doc-field-no-class": "Any",
    "duplicate-doc-alias": "Any",
    "duplicate-doc-field": "Any",
    "duplicate-doc-param": "Any",
    "duplicate-index": "Any",
    "duplicate-set-field": "Any",
    "empty-block": "Opened",
    "global-in-nil-env": "Any",
    "lowercase-global": "Any",
    "missing-parameter": "Opened",
    "need-check-nil": "Opened",
    "newfield-call": "Any",
    "newline-call": "Any",
    "no-unknown": "None",
    "not-yieldable": "None",
    "redefined-local": "Opened",
    "redundant-parameter": "Opened",
    "redundant-return": "Opened",
    "redundant-value": "Opened",
    "spell-check": "None",
    "trailing-space": "Opened",
    "type-check": "None",
    "unbalanced-assignments": "Any",
    "undefined-doc-class": "Any",
    "undefined-doc-name": "Any",
    "undefined-doc-param": "Any",
    "undefined-env-child": "Any",
    "undefined-field": "Opened",
    "undefined-global": "Any",
    "unknown-diag-code": "Any",
    "unused-function": "Opened",
    "unused-label": "Opened",
    "unused-local": "Opened",
    "unused-vararg": "Opened"
}
```

# diagnostics.severity

修改诊断等级。

## type

```ts
object<string, string>
```

## enum

* ``"Error"``
* ``"Warning"``
* ``"Information"``
* ``"Hint"``

## default

```json
{
    "ambiguity-1": "Warning",
    "await-in-sync": "Warning",
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
    "duplicate-index": "Warning",
    "duplicate-set-field": "Warning",
    "empty-block": "Hint",
    "global-in-nil-env": "Warning",
    "lowercase-global": "Information",
    "missing-parameter": "Warning",
    "need-check-nil": "Warning",
    "newfield-call": "Warning",
    "newline-call": "Information",
    "no-unknown": "Information",
    "not-yieldable": "Warning",
    "redefined-local": "Hint",
    "redundant-parameter": "Warning",
    "redundant-return": "Warning",
    "redundant-value": "Warning",
    "spell-check": "Information",
    "trailing-space": "Hint",
    "type-check": "Warning",
    "unbalanced-assignments": "Warning",
    "undefined-doc-class": "Warning",
    "undefined-doc-name": "Warning",
    "undefined-doc-param": "Warning",
    "undefined-env-child": "Information",
    "undefined-field": "Warning",
    "undefined-global": "Warning",
    "unknown-diag-code": "Warning",
    "unused-function": "Hint",
    "unused-label": "Hint",
    "unused-local": "Hint",
    "unused-vararg": "Hint"
}
```

# diagnostics.workspaceDelay

进行工作区诊断的延迟（毫秒）。当你启动工作区，或编辑了任意文件后，将会在后台对整个工作区进行重新诊断。设置为负数可以禁用工作区诊断。

## type

```ts
integer
```

## default

```json
3000
```

# diagnostics.workspaceRate

工作区诊断的运行速率（百分比）。降低该值会减少CPU占用，但是也会降低工作区诊断的速度。你当前正在编辑的文件的诊断总是全速完成，不受该选项影响。

## type

```ts
integer
```

## default

```json
100
```

# format.defaultConfig

**Missing description!!**

## type

```ts
Object<string, string>
```

## default

```json
{}
```

# format.enable

启用代码格式化程序。

## type

```ts
boolean
```

## default

```json
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

```json
"Auto"
```

# hint.await

**Missing description!!**

## type

```ts
boolean
```

## default

```json
true
```

# hint.enable

启用内联提示。

## type

```ts
boolean
```

## default

```json
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

```json
"All"
```

# hint.paramType

在函数的参数位置提示类型。

## type

```ts
boolean
```

## default

```json
true
```

# hint.setType

在赋值操作位置提示类型。

## type

```ts
boolean
```

## default

```json
false
```

# hover.enable

启用悬停提示。

## type

```ts
boolean
```

## default

```json
true
```

# hover.enumsLimit

当值对应多个类型时，限制类型的显示数量。

## type

```ts
integer
```

## default

```json
5
```

# hover.expandAlias

**Missing description!!**

## type

```ts
boolean
```

## default

```json
true
```

# hover.previewFields

悬停提示查看表时，限制表内字段的最大预览数量。

## type

```ts
integer
```

## default

```json
20
```

# hover.viewNumber

悬停提示查看数字内容（仅当字面量不是十进制时）。

## type

```ts
boolean
```

## default

```json
true
```

# hover.viewString

悬停提示查看字符串内容（仅当字面量包含转义符时）。

## type

```ts
boolean
```

## default

```json
true
```

# hover.viewStringMax

悬停提示查看字符串内容时的最大长度。

## type

```ts
integer
```

## default

```json
1000
```

# misc.parameters

VSCode中启动语言服务时的[命令行参数](https://github.com/sumneko/lua-language-server/wiki/Command-line)。

## type

```ts
Array<string>
```

## default

```json
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

```json
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

```json
"utf8"
```

# runtime.meta

**Missing description!!**

## type

```ts
string
```

## default

```json
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
* ``"||"``
* ``"&&"``
* ``"!"``
* ``"!="``
* ``"continue"``

## default

```json
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

```json
["?.lua","?/init.lua"]
```

# runtime.pathStrict

启用后 `runtime.path` 将只搜索第一层目录，见 `runtime.path` 的说明。

## type

```ts
boolean
```

## default

```json
false
```

# runtime.plugin

插件路径，请查阅[文档](https://github.com/sumneko/lua-language-server/wiki/Plugin)了解用法。

## type

```ts
string
```

## default

```json
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

```json
{}
```

# runtime.unicodeName

允许在名字中使用 Unicode 字符。

## type

```ts
boolean
```

## default

```json
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

```json
"Lua 5.4"
```

# semantic.annotation

对类型注解进行语义着色。

## type

```ts
boolean
```

## default

```json
true
```

# semantic.enable

启用语义着色。你可能需要同时将 `editor.semanticHighlighting.enabled` 设置为 `true` 才能生效。

## type

```ts
boolean
```

## default

```json
true
```

# semantic.keyword

对关键字/字面量/运算符进行语义着色。只有当你的编辑器无法进行语法着色时才需要启用此功能。

## type

```ts
boolean
```

## default

```json
false
```

# semantic.variable

对变量/字段/参数进行语义着色。

## type

```ts
boolean
```

## default

```json
true
```

# signatureHelp.enable

启用参数提示。

## type

```ts
boolean
```

## default

```json
true
```

# spell.dict

**Missing description!!**

## type

```ts
Array<string>
```

## default

```json
[]
```

# telemetry.enable

启用遥测，通过网络发送你的编辑器信息与错误日志。在[此处](https://github.com/sumneko/lua-language-server/wiki/%E9%9A%90%E7%A7%81%E5%A3%B0%E6%98%8E)阅读我们的隐私声明。


## type

```ts
boolean | null
```

## default

```json
null
```

# window.progressBar

在状态栏显示进度条。

## type

```ts
boolean
```

## default

```json
true
```

# window.statusBar

在状态栏显示插件状态。

## type

```ts
boolean
```

## default

```json
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

```json
true
```

# workspace.ignoreDir

忽略的文件与目录（使用 `.gitignore` 语法）。

## type

```ts
Array<string>
```

## default

```json
[".vscode"]
```

# workspace.ignoreSubmodules

忽略子模块。

## type

```ts
boolean
```

## default

```json
true
```

# workspace.library

除了当前工作区以外，还会从哪些目录中加载文件。这些目录中的文件将被视作外部提供的代码库，部分操作（如重命名字段）不会修改这些文件。

## type

```ts
Array<string>
```

## default

```json
[]
```

# workspace.maxPreload

最大预加载文件数。

## type

```ts
integer
```

## default

```json
5000
```

# workspace.preloadFileSize

预加载时跳过大小大于该值（KB）的文件。

## type

```ts
integer
```

## default

```json
500
```

# workspace.supportScheme

为以下 scheme 的lua文件提供语言服务。

## type

```ts
Array<string>
```

## default

```json
["file","untitled","git"]
```

# workspace.useGitIgnore

忽略 `.gitignore` 中列举的文件。

## type

```ts
boolean
```

## default

```json
true
```

# workspace.userThirdParty

在这里添加私有的第三方库适配文件路径，请参考内置的[配置文件路径](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)

## type

```ts
Array<string>
```

## default

```json
[]
```