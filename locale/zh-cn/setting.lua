---@diagnostic disable: undefined-global

config.runtime.version            = "Lua运行版本。"
config.runtime.path               = [[
当使用 `require` 时，如何根据输入的名字来查找文件。
此选项设置为 `?/init.lua` 意味着当你输入 `require 'myfile'` 时，会从已加载的文件中搜索 `{workspace}/myfile/init.lua`。
当 `runtime.pathStrict` 设置为 `false` 时，还会尝试搜索 `${workspace}/**/myfile/init.lua`。
如果你想要加载工作区以外的文件，你需要先设置 `Lua.workspace.library`。
]]
config.runtime.pathStrict         = '启用后 `runtime.path` 将只搜索第一层目录，见 `runtime.path` 的说明。'
config.runtime.special            = [[将自定义全局变量视为一些特殊的内置变量，语言服务将提供特殊的支持。
下面这个例子表示将 `include` 视为 `require` 。
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```
]]
config.runtime.unicodeName        = "允许在名字中使用 Unicode 字符。"
config.runtime.nonstandardSymbol  = "支持非标准的符号。请务必确认你的运行环境支持这些符号。"
config.runtime.plugin             = "插件路径，请查阅[文档](https://github.com/sumneko/lua-language-server/wiki/Plugin)了解用法。"
config.runtime.fileEncoding       = "文件编码，`ansi` 选项只在 `Windows` 平台下有效。"
config.runtime.builtin            = [[
调整内置库的启用状态，你可以根据实际运行环境禁用掉不存在的库（或重新定义）。

* `default`: 表示库会根据运行版本启用或禁用
* `enable`: 总是启用
* `disable`: 总是禁用
]]
config.diagnostics.enable         = "启用诊断。"
config.diagnostics.disable        = "禁用的诊断（使用浮框括号内的代码）。"
config.diagnostics.globals        = "已定义的全局变量。"
config.diagnostics.severity       = "修改诊断等级。"
config.diagnostics.neededFileStatus = [[
* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* Disable: 禁用此诊断
]]
config.diagnostics.workspaceDelay = "进行工作区诊断的延迟（毫秒）。当你启动工作区，或编辑了任意文件后，将会在后台对整个工作区进行重新诊断。设置为负数可以禁用工作区诊断。"
config.diagnostics.workspaceRate  = "工作区诊断的运行速率（百分比）。降低该值会减少CPU占用，但是也会降低工作区诊断的速度。你当前正在编辑的文件的诊断总是全速完成，不受该选项影响。"
config.diagnostics.libraryFiles   = "如何诊断通过 `Lua.workspace.library` 加载的文件。"
config.diagnostics.ignoredFiles   = "如何诊断被忽略的文件。"
config.diagnostics.files.Enable   = "总是诊断这些文件。"
config.diagnostics.files.Opened   = "只有打开这些文件时才会诊断。"
config.diagnostics.files.Disable  = "不诊断这些文件。"
config.workspace.ignoreDir        = "忽略的文件与目录（使用 `.gitignore` 语法）。"
config.workspace.ignoreSubmodules = "忽略子模块。"
config.workspace.useGitIgnore     = "忽略 `.gitignore` 中列举的文件。"
config.workspace.maxPreload       = "最大预加载文件数。"
config.workspace.preloadFileSize  = "预加载时跳过大小大于该值（KB）的文件。"
config.workspace.library          = "除了当前工作区以外，还会从哪些目录中加载文件。这些目录中的文件将被视作外部提供的代码库，部分操作（如重命名字段）不会修改这些文件。"
config.workspace.checkThirdParty  = [[
自动检测与适配第三方库，目前支持的库为：

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]]
config.workspace.userThirdParty          = '在这里添加私有的第三方库适配文件路径，请参考内置的[配置文件路径](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)'
config.completion.enable                 = '启用自动完成。'
config.completion.callSnippet            = '显示函数调用片段。'
config.completion.callSnippet.Disable    = "只显示 `函数名`。"
config.completion.callSnippet.Both       = "显示 `函数名` 与 `调用片段`。"
config.completion.callSnippet.Replace    = "只显示 `调用片段`。"
config.completion.keywordSnippet         = '显示关键字语法片段'
config.completion.keywordSnippet.Disable = "只显示 `关键字`。"
config.completion.keywordSnippet.Both    = "显示 `关键字` 与 `语法片段`。"
config.completion.keywordSnippet.Replace = "只显示 `语法片段`。"
config.completion.displayContext         = "预览建议的相关代码片段，可能可以帮助你了解这项建议的用法。设置的数字表示代码片段的截取行数，设置为`0`可以禁用此功能。"
config.completion.workspaceWord          = "显示的上下文单词是否包含工作区中其他文件的内容。"
config.completion.showWord               = "在建议中显示上下文单词。"
config.completion.showWord.Enable        = "总是在建议中显示上下文单词。"
config.completion.showWord.Fallback      = "无法根据语义提供建议时才显示上下文单词。"
config.completion.showWord.Disable       = "不显示上下文单词。"
config.completion.autoRequire            = "输入内容看起来是个文件名时，自动 `require` 此文件。"
config.completion.showParams             = "在建议列表中显示函数的参数信息，函数拥有多个定义时会分开显示。"
config.completion.requireSeparator       = "`require` 时使用的分隔符。"
config.completion.postfix                = "用于触发后缀建议的符号。"
config.color.mode                        = "着色模式。"
config.color.mode.Semantic               = "语义着色。你可能需要同时将 `editor.semanticHighlighting.enabled` 设置为 `true` 才能生效。"
config.color.mode.SemanticEnhanced       = "增强的语义颜色。 类似于`Semantic`，但会进行额外的分析（也会带来额外的开销）。"
config.color.mode.Grammar                = "语法着色。"
config.semantic.enable                   = "启用语义着色。你可能需要同时将 `editor.semanticHighlighting.enabled` 设置为 `true` 才能生效。"
config.semantic.variable                 = "对变量/字段/参数进行语义着色。"
config.semantic.annotation               = "对类型注解进行语义着色。"
config.semantic.keyword                  = "对关键字/字面量/运算符进行语义着色。只有当你的编辑器无法进行语法着色时才需要启用此功能。"
config.signatureHelp.enable              = "启用参数提示。"
config.hover.enable                      = "启用悬停提示。"
config.hover.viewString                  = "悬停提示查看字符串内容（仅当字面量包含转义符时）。"
config.hover.viewStringMax               = "悬停提示查看字符串内容时的最大长度。"
config.hover.viewNumber                  = "悬停提示查看数字内容（仅当字面量不是十进制时）。"
config.hover.fieldInfer                  = "悬停提示查看表时，会对表的每个字段进行类型推测，当类型推测的用时累计达到该设定值（毫秒）时，将跳过后续字段的类型推测。"
config.hover.previewFields               = "悬停提示查看表时，限制表内字段的最大预览数量。"
config.hover.enumsLimit                  = "当值对应多个类型时，限制类型的显示数量。"
config.develop.enable                    = '开发者模式。请勿开启，会影响性能。'
config.develop.debuggerPort              = '调试器监听端口。'
config.develop.debuggerWait              = '调试器连接之前挂起。'
config.intelliSense.searchDepth          = '设置智能感知的搜索深度。增大该值可以增加准确度，但会降低性能。不同的项目对该设置的容忍度差异较大，请自己调整为合适的值。'
config.intelliSense.fastGlobal           = '在对全局变量进行补全，及查看 `_G` 的悬浮提示时进行优化。这会略微降低类型推测的准确度，但是对于大量使用全局变量的项目会有大幅的性能提升。'
config.window.statusBar                  = '在状态栏显示插件状态。'
config.window.progressBar                = '在状态栏显示进度条。'
config.hint.enable                       = '启用内联提示。'
config.hint.paramType                    = '在函数的参数位置提示类型。'
config.hint.setType                      = '在赋值操作位置提示类型。'
config.hint.paramName                    = '在函数调用处提示参数名。'
config.hint.paramName.All                = '所有类型的参数均进行提示。'
config.hint.paramName.Literal            = '只有字面量类型的参数进行提示。'
config.hint.paramName.Disable            = '禁用参数提示。'
config.hint.arrayIndex                   = '在构造表时提示数组索引。'
config.hint.arrayIndex.Enable            = '所有的表中都提示数组索引。'
config.hint.arrayIndex.Auto              = '只有表大于3项，或者表是混合类型时才进行提示。'
config.hint.arrayIndex.Disable           = '禁用数组索引提示。'
config.telemetry.enable                  = [[
启用遥测，通过网络发送你的编辑器信息与错误日志。在[此处](https://github.com/sumneko/lua-language-server/wiki/%E9%9A%90%E7%A7%81%E5%A3%B0%E6%98%8E)阅读我们的隐私声明。
]]
config.misc.parameters                   = 'VSCode中启动语言服务时的[命令行参数](https://github.com/sumneko/lua-language-server/wiki/Command-line)。'
config.IntelliSense.traceLocalSet        = '请查阅[文档](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features)了解用法。'
config.IntelliSense.traceReturn          = '请查阅[文档](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features)了解用法。'
config.IntelliSense.traceBeSetted        = '请查阅[文档](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features)了解用法。'
config.IntelliSense.traceFieldInject     = '请查阅[文档](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features)了解用法。'


config.diagnostics['unused-local']          = '未使用的局部变量'
config.diagnostics['unused-function']       = '未使用的函数'
config.diagnostics['undefined-global']      = '未定义的全局变量'
config.diagnostics['global-in-nil-env']     = '不能使用全局变量（ `_ENV` 被设置为了 `nil`）'
config.diagnostics['unused-label']          = '未使用的标签'
config.diagnostics['unused-vararg']         = '未使用的不定参数'
config.diagnostics['trailing-space']        = '后置空格'
config.diagnostics['redefined-local']       = '重复定义的局部变量'
config.diagnostics['newline-call']          = '以 `(` 开始的新行，在语法上被解析为了上一行的函数调用'
config.diagnostics['newfield-call']         = '在字面量表中，2行代码之间缺少分隔符，在语法上被解析为了一次索引操作'
config.diagnostics['redundant-parameter']   = '函数调用时，传入了多余的参数'
config.diagnostics['ambiguity-1']           = '优先级歧义，如：`num or 0 + 1`，推测用户的实际期望为 `(num or 0) + 1` '
config.diagnostics['lowercase-global']      = '首字母小写的全局变量定义'
config.diagnostics['undefined-env-child']   = '`_ENV` 被设置为了新的字面量表，但是试图获取的全局变量不再这张表中'
config.diagnostics['duplicate-index']       = '在字面量表中重复定义了索引'
config.diagnostics['empty-block']           = '空代码块'
config.diagnostics['redundant-value']       = '赋值操作时，值的数量比被赋值的对象多'
