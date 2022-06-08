# completion.autoRequire

输入内容看起来是个文件名时，自动 `require` 此文件。

## type
`boolean`

## default

`true`

# completion.callSnippet

显示函数调用片段。

## type
`string`

## default

`"Disable"`

## enum

* `"Disable"`: 只显示 `函数名`。
* `"Both"`: 显示 `函数名` 与 `调用片段`。
* `"Replace"`: 只显示 `调用片段`。

# completion.displayContext

预览建议的相关代码片段，可能可以帮助你了解这项建议的用法。设置的数字表示代码片段的截取行数，设置为`0`可以禁用此功能。

## type
`integer`

## default

`0`

# completion.enable

启用自动完成。

## type
`boolean`

## default

`true`

# completion.keywordSnippet

显示关键字语法片段

## type
`string`

## default

`"Replace"`

## enum

* `"Disable"`: 只显示 `关键字`。
* `"Both"`: 显示 `关键字` 与 `语法片段`。
* `"Replace"`: 只显示 `语法片段`。

# completion.postfix

用于触发后缀建议的符号。

## type
`string`

## default

`"@"`

# completion.requireSeparator

`require` 时使用的分隔符。

## type
`string`

## default

`"."`

# completion.showParams

在建议列表中显示函数的参数信息，函数拥有多个定义时会分开显示。

## type
`boolean`

## default

`true`

# completion.showWord

在建议中显示上下文单词。

## type
`string`

## default

`"Fallback"`

## enum

* `"Enable"`: 总是在建议中显示上下文单词。
* `"Fallback"`: 无法根据语义提供建议时才显示上下文单词。
* `"Disable"`: 不显示上下文单词。

# completion.workspaceWord

显示的上下文单词是否包含工作区中其他文件的内容。

## type
`boolean`

## default

`true`

# diagnostics.disable

禁用的诊断（使用浮框括号内的代码）。

## type
`array<string>`

## default

`[]`

# diagnostics.disableScheme

不诊断使用以下 scheme 的lua文件。

## type
`array<string>`

## default

`[ "git" ]`

# diagnostics.enable

启用诊断。

## type
`boolean`

## default

`true`

# diagnostics.globals

已定义的全局变量。

## type
`array<string>`

## default

`[]`

# diagnostics.ignoredFiles

如何诊断被忽略的文件。

## type
`string`

## default

`"Opened"`

## enum

* `"Enable"`: 总是诊断这些文件。
* `"Opened"`: 只有打开这些文件时才会诊断。
* `"Disable"`: 不诊断这些文件。

# diagnostics.libraryFiles

如何诊断通过 `Lua.workspace.library` 加载的文件。

## type
`string`

## default

`"Opened"`

## enum

* `"Enable"`: 总是诊断这些文件。
* `"Opened"`: 只有打开这些文件时才会诊断。
* `"Disable"`: 不诊断这些文件。

# diagnostics.neededFileStatus

* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* Disable: 禁用此诊断


## type
`object`

# diagnostics.severity

修改诊断等级。

## type
`object`

# diagnostics.workspaceDelay

进行工作区诊断的延迟（毫秒）。当你启动工作区，或编辑了任意文件后，将会在后台对整个工作区进行重新诊断。设置为负数可以禁用工作区诊断。

## type
`integer`

## default

`3000`

# diagnostics.workspaceRate

工作区诊断的运行速率（百分比）。降低该值会减少CPU占用，但是也会降低工作区诊断的速度。你当前正在编辑的文件的诊断总是全速完成，不受该选项影响。

## type
`integer`

## default

`100`

# format.defaultConfig

**Missing description!!**

## type
`object`

## default

`{}`

# format.enable

启用代码格式化程序。

## type
`boolean`

## default

`true`

# hint.arrayIndex

在构造表时提示数组索引。

## type
`string`

## default

`"Auto"`

## enum

* `"Enable"`: 所有的表中都提示数组索引。
* `"Auto"`: 只有表大于3项，或者表是混合类型时才进行提示。
* `"Disable"`: 禁用数组索引提示。

# hint.await

**Missing description!!**

## type
`boolean`

## default

`true`

# hint.enable

启用内联提示。

## type
`boolean`

# hint.paramName

在函数调用处提示参数名。

## type
`string`

## default

`"All"`

## enum

* `"All"`: 所有类型的参数均进行提示。
* `"Literal"`: 只有字面量类型的参数进行提示。
* `"Disable"`: 禁用参数提示。

# hint.paramType

在函数的参数位置提示类型。

## type
`boolean`

## default

`true`

# hint.setType

在赋值操作位置提示类型。

## type
`boolean`

# hover.enable

启用悬停提示。

## type
`boolean`

## default

`true`

# hover.enumsLimit

当值对应多个类型时，限制类型的显示数量。

## type
`integer`

## default

`5`

# hover.expandAlias

**Missing description!!**

## type
`boolean`

## default

`true`

# hover.previewFields

悬停提示查看表时，限制表内字段的最大预览数量。

## type
`integer`

## default

`20`

# hover.viewNumber

悬停提示查看数字内容（仅当字面量不是十进制时）。

## type
`boolean`

## default

`true`

# hover.viewString

悬停提示查看字符串内容（仅当字面量包含转义符时）。

## type
`boolean`

## default

`true`

# hover.viewStringMax

悬停提示查看字符串内容时的最大长度。

## type
`integer`

## default

`1000`

# misc.parameters

VSCode中启动语言服务时的[命令行参数](https://github.com/sumneko/lua-language-server/wiki/Command-line)。

## type
`array<string>`

## default

`[]`

# runtime.builtin

调整内置库的启用状态，你可以根据实际运行环境禁用掉不存在的库（或重新定义）。

* `default`: 表示库会根据运行版本启用或禁用
* `enable`: 总是启用
* `disable`: 总是禁用


## type
`object`

# runtime.fileEncoding

文件编码，`ansi` 选项只在 `Windows` 平台下有效。

## type
`string`

## default

`"utf8"`

## enum

* `"utf8"`
* `"ansi"`
* `"utf16le"`
* `"utf16be"`

# runtime.meta

**Missing description!!**

## type
`string`

## default

`"${version} ${language} ${encoding}"`

# runtime.nonstandardSymbol

支持非标准的符号。请务必确认你的运行环境支持这些符号。

## type
`array<string>`

## default

`[]`

# runtime.path

当使用 `require` 时，如何根据输入的名字来查找文件。
此选项设置为 `?/init.lua` 意味着当你输入 `require 'myfile'` 时，会从已加载的文件中搜索 `{workspace}/myfile/init.lua`。
当 `runtime.pathStrict` 设置为 `false` 时，还会尝试搜索 `${workspace}/**/myfile/init.lua`。
如果你想要加载工作区以外的文件，你需要先设置 `Lua.workspace.library`。


## type
`array<string>`

## default

`[ "?.lua", "?/init.lua" ]`

# runtime.pathStrict

启用后 `runtime.path` 将只搜索第一层目录，见 `runtime.path` 的说明。

## type
`boolean`

# runtime.plugin

插件路径，请查阅[文档](https://github.com/sumneko/lua-language-server/wiki/Plugin)了解用法。

## type
`string`

## default

`""`

# runtime.special

将自定义全局变量视为一些特殊的内置变量，语言服务将提供特殊的支持。
下面这个例子表示将 `include` 视为 `require` 。
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```


## type
`object`

## default

`{}`

# runtime.unicodeName

允许在名字中使用 Unicode 字符。

## type
`boolean`

# runtime.version

Lua运行版本。

## type
`string`

## default

`"Lua 5.4"`

## enum

* `"Lua 5.1"`
* `"Lua 5.2"`
* `"Lua 5.3"`
* `"Lua 5.4"`
* `"LuaJIT"`

# semantic.annotation

对类型注解进行语义着色。

## type
`boolean`

## default

`true`

# semantic.enable

启用语义着色。你可能需要同时将 `editor.semanticHighlighting.enabled` 设置为 `true` 才能生效。

## type
`boolean`

## default

`true`

# semantic.keyword

对关键字/字面量/运算符进行语义着色。只有当你的编辑器无法进行语法着色时才需要启用此功能。

## type
`boolean`

# semantic.variable

对变量/字段/参数进行语义着色。

## type
`boolean`

## default

`true`

# signatureHelp.enable

启用参数提示。

## type
`boolean`

## default

`true`

# spell.dict

**Missing description!!**

## type
`array<string>`

## default

`[]`

# telemetry.enable

启用遥测，通过网络发送你的编辑器信息与错误日志。在[此处](https://github.com/sumneko/lua-language-server/wiki/%E9%9A%90%E7%A7%81%E5%A3%B0%E6%98%8E)阅读我们的隐私声明。


## type
`boolean | null`

## default

`nil`

# window.progressBar

在状态栏显示进度条。

## type
`boolean`

## default

`true`

# window.statusBar

在状态栏显示插件状态。

## type
`boolean`

## default

`true`

# workspace.checkThirdParty

自动检测与适配第三方库，目前支持的库为：

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass


## type
`boolean`

## default

`true`

# workspace.ignoreDir

忽略的文件与目录（使用 `.gitignore` 语法）。

## type
`array<string>`

## default

`[ ".vscode" ]`

# workspace.ignoreSubmodules

忽略子模块。

## type
`boolean`

## default

`true`

# workspace.library

除了当前工作区以外，还会从哪些目录中加载文件。这些目录中的文件将被视作外部提供的代码库，部分操作（如重命名字段）不会修改这些文件。

## type
`array<string>`

## default

`[]`

# workspace.maxPreload

最大预加载文件数。

## type
`integer`

## default

`5000`

# workspace.preloadFileSize

预加载时跳过大小大于该值（KB）的文件。

## type
`integer`

## default

`500`

# workspace.supportScheme

为以下 scheme 的lua文件提供语言服务。

## type
`array<string>`

## default

`[ "file", "untitled", "git" ]`

# workspace.useGitIgnore

忽略 `.gitignore` 中列举的文件。

## type
`boolean`

## default

`true`

# workspace.userThirdParty

在这里添加私有的第三方库适配文件路径，请参考内置的[配置文件路径](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)

## type
`array<string>`

## default

`[]`