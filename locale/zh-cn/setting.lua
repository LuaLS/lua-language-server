---@diagnostic disable: undefined-global

config.addonManager.enable        =
"是否启用扩展的附加插件管理器(Addon Manager)"
config.addonManager.repositoryBranch =
"指定插件管理器(Addon Manager)使用的git仓库分支"
config.addonManager.repositoryPath =
"指定插件管理器(Addon Manager)使用的git仓库路径"
config.runtime.version            =
"Lua运行版本。"
config.runtime.path               =
[[
当使用 `require` 时，如何根据输入的名字来查找文件。
此选项设置为 `?/init.lua` 意味着当你输入 `require 'myfile'` 时，会从已加载的文件中搜索 `{workspace}/myfile/init.lua`。
当 `runtime.pathStrict` 设置为 `false` 时，还会尝试搜索 `${workspace}/**/myfile/init.lua`。
如果你想要加载工作区以外的文件，你需要先设置 `Lua.workspace.library`。
]]
config.runtime.pathStrict         =
'启用后 `runtime.path` 将只搜索第一层目录，见 `runtime.path` 的说明。'
config.runtime.special            =
[[将自定义全局变量视为一些特殊的内置变量，语言服务将提供特殊的支持。
下面这个例子表示将 `include` 视为 `require` 。
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```
]]
config.runtime.unicodeName        =
"允许在名字中使用 Unicode 字符。"
config.runtime.nonstandardSymbol  =
"支持非标准的符号。请务必确认你的运行环境支持这些符号。"
config.runtime.plugin             =
"插件路径，请查阅[文档](https://luals.github.io/wiki/plugins)了解用法。"
config.runtime.pluginArgs         =
"插件的额外参数。"
config.runtime.fileEncoding       =
"文件编码，`ansi` 选项只在 `Windows` 平台下有效。"
config.runtime.builtin            =
[[
调整内置库的启用状态，你可以根据实际运行环境禁用掉不存在的库（或重新定义）。

* `default`: 表示库会根据运行版本启用或禁用
* `enable`: 总是启用
* `disable`: 总是禁用
]]
config.runtime.meta               =
'meta文件的目录名称格式。'
config.diagnostics.enable         =
"启用诊断。"
config.diagnostics.disable        =
"禁用的诊断（使用浮框括号内的代码）。"
config.diagnostics.globals        =
"已定义的全局变量。"
config.diagnostics.globalsRegex   =
"启用诊断以检测尝试关闭非对象的变量。"
config.diagnostics.severity       =
[[
修改诊断等级。
以 `!` 结尾的设置优先级高于组设置 `diagnostics.groupSeverity`。
]]
config.diagnostics.neededFileStatus =
[[
* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* None:    禁用此诊断

以 `!` 结尾的设置优先级高于组设置 `diagnostics.groupFileStatus`。
]]
config.diagnostics.groupSeverity  =
[[
批量修改一个组中的诊断等级。
设置为 `Fallback` 意味着组中的诊断由 `diagnostics.severity` 单独设置。
其他设置将覆盖单独设置，但是不会覆盖以 `!` 结尾的设置。
]]
config.diagnostics.groupFileStatus =
[[
批量修改一个组中的文件状态。

* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* None:    禁用此诊断

设置为 `Fallback` 意味着组中的诊断由 `diagnostics.neededFileStatus` 单独设置。
其他设置将覆盖单独设置，但是不会覆盖以 `!` 结尾的设置。
]]
config.diagnostics.workspaceEvent =
"设置触发工作区诊断的时机。"
config.diagnostics.workspaceEvent.OnChange =
"当文件发生变化时触发工作区诊断。"
config.diagnostics.workspaceEvent.OnSave =
"当文件保存时触发工作区诊断。"
config.diagnostics.workspaceEvent.None =
"关闭工作区诊断。"
config.diagnostics.workspaceDelay =
"进行工作区诊断的延迟（毫秒）。"
config.diagnostics.workspaceRate  =
"工作区诊断的运行速率（百分比）。降低该值会减少CPU占用，但是也会降低工作区诊断的速度。你当前正在编辑的文件的诊断总是全速完成，不受该选项影响。"
config.diagnostics.libraryFiles   =
"如何诊断通过 `Lua.workspace.library` 加载的文件。"
config.diagnostics.libraryFiles.Enable   =
"总是诊断这些文件。"
config.diagnostics.libraryFiles.Opened   =
"只有打开这些文件时才会诊断。"
config.diagnostics.libraryFiles.Disable  =
"不诊断这些文件。"
config.diagnostics.ignoredFiles   =
"如何诊断被忽略的文件。"
config.diagnostics.ignoredFiles.Enable   =
"总是诊断这些文件。"
config.diagnostics.ignoredFiles.Opened   =
"只有打开这些文件时才会诊断。"
config.diagnostics.ignoredFiles.Disable  =
"不诊断这些文件。"
config.diagnostics.disableScheme  =
'不诊断使用以下 scheme 的lua文件。'
config.diagnostics.unusedLocalExclude =
'如果变量名匹配以下规则，则不对其进行 `unused-local` 诊断。'
config.workspace.ignoreDir        =
"忽略的文件与目录（使用 `.gitignore` 语法）。"
config.workspace.ignoreSubmodules =
"忽略子模块。"
config.workspace.useGitIgnore     =
"忽略 `.gitignore` 中列举的文件。"
config.workspace.maxPreload       =
"最大预加载文件数。"
config.workspace.preloadFileSize  =
"预加载时跳过大小大于该值（KB）的文件。"
config.workspace.library          =
"除了当前工作区以外，还会从哪些目录中加载文件。这些目录中的文件将被视作外部提供的代码库，部分操作（如重命名字段）不会修改这些文件。"
config.workspace.checkThirdParty  =
[[
自动检测与适配第三方库，目前支持的库为：

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]]
config.workspace.userThirdParty          =
'在这里添加私有的第三方库适配文件路径，请参考内置的[配置文件路径](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)'
config.workspace.supportScheme           =
'为以下 scheme 的lua文件提供语言服务。'
config.completion.enable                 =
'启用自动完成。'
config.completion.callSnippet            =
'显示函数调用片段。'
config.completion.callSnippet.Disable    =
"只显示 `函数名`。"
config.completion.callSnippet.Both       =
"显示 `函数名` 与 `调用片段`。"
config.completion.callSnippet.Replace    =
"只显示 `调用片段`。"
config.completion.keywordSnippet         =
'显示关键字语法片段'
config.completion.keywordSnippet.Disable =
"只显示 `关键字`。"
config.completion.keywordSnippet.Both    =
"显示 `关键字` 与 `语法片段`。"
config.completion.keywordSnippet.Replace =
"只显示 `语法片段`。"
config.completion.displayContext         =
"预览建议的相关代码片段，可能可以帮助你了解这项建议的用法。设置的数字表示代码片段的截取行数，设置为`0`可以禁用此功能。"
config.completion.workspaceWord          =
"显示的上下文单词是否包含工作区中其他文件的内容。"
config.completion.showWord               =
"在建议中显示上下文单词。"
config.completion.showWord.Enable        =
"总是在建议中显示上下文单词。"
config.completion.showWord.Fallback      =
"无法根据语义提供建议时才显示上下文单词。"
config.completion.showWord.Disable       =
"不显示上下文单词。"
config.completion.autoRequire            =
"输入内容看起来是个文件名时，自动 `require` 此文件。"
config.completion.showParams             =
"在建议列表中显示函数的参数信息，函数拥有多个定义时会分开显示。"
config.completion.requireSeparator       =
"`require` 时使用的分隔符。"
config.completion.postfix                =
"用于触发后缀建议的符号。"
config.color.mode                        =
"着色模式。"
config.color.mode.Semantic               =
"语义着色。你可能需要同时将 `editor.semanticHighlighting.enabled` 设置为 `true` 才能生效。"
config.color.mode.SemanticEnhanced       =
"增强的语义颜色。 类似于`Semantic`，但会进行额外的分析（也会带来额外的开销）。"
config.color.mode.Grammar                =
"语法着色。"
config.semantic.enable                   =
"启用语义着色。你可能需要同时将 `editor.semanticHighlighting.enabled` 设置为 `true` 才能生效。"
config.semantic.variable                 =
"对变量/字段/参数进行语义着色。"
config.semantic.annotation               =
"对类型注解进行语义着色。"
config.semantic.keyword                  =
"对关键字/字面量/运算符进行语义着色。只有当你的编辑器无法进行语法着色时才需要启用此功能。"
config.signatureHelp.enable              =
"启用参数提示。"
config.hover.enable                      =
"启用悬停提示。"
config.hover.viewString                  =
"悬停提示查看字符串内容（仅当字面量包含转义符时）。"
config.hover.viewStringMax               =
"悬停提示查看字符串内容时的最大长度。"
config.hover.viewNumber                  =
"悬停提示查看数字内容（仅当字面量不是十进制时）。"
config.hover.fieldInfer                  =
"悬停提示查看表时，会对表的每个字段进行类型推测，当类型推测的用时累计达到该设定值（毫秒）时，将跳过后续字段的类型推测。"
config.hover.previewFields               =
"悬停提示查看表时，限制表内字段的最大预览数量。"
config.hover.enumsLimit                  =
"当值对应多个类型时，限制类型的显示数量。"
config.hover.expandAlias                 =
[[
是否展开别名。例如 `---@alias myType boolean|number` 展开后显示为 `boolean|number`，否则显示为 `myType`。
]]
config.develop.enable                    =
'开发者模式。请勿开启，会影响性能。'
config.develop.debuggerPort              =
'调试器监听端口。'
config.develop.debuggerWait              =
'调试器连接之前挂起。'
config.intelliSense.searchDepth          =
'设置智能感知的搜索深度。增大该值可以增加准确度，但会降低性能。不同的项目对该设置的容忍度差异较大，请自己调整为合适的值。'
config.intelliSense.fastGlobal           =
'在对全局变量进行补全，及查看 `_G` 的悬浮提示时进行优化。这会略微降低类型推测的准确度，但是对于大量使用全局变量的项目会有大幅的性能提升。'
config.window.statusBar                  =
'在状态栏显示插件状态。'
config.window.progressBar                =
'在状态栏显示进度条。'
config.hint.enable                       =
'启用内联提示。'
config.hint.paramType                    =
'在函数的参数位置提示类型。'
config.hint.setType                      =
'在赋值操作位置提示类型。'
config.hint.paramName                    =
'在函数调用处提示参数名。'
config.hint.paramName.All                =
'所有类型的参数均进行提示。'
config.hint.paramName.Literal            =
'只有字面量类型的参数进行提示。'
config.hint.paramName.Disable            =
'禁用参数提示。'
config.hint.arrayIndex                   =
'在构造表时提示数组索引。'
config.hint.arrayIndex.Enable            =
'所有的表中都提示数组索引。'
config.hint.arrayIndex.Auto              =
'只有表大于3项，或者表是混合类型时才进行提示。'
config.hint.arrayIndex.Disable           =
'禁用数组索引提示。'
config.hint.await                        =
'如果调用的函数被标记为了 `---@async` ，则在调用处提示 `await` 。'
config.hint.awaitPropagate               =
'启用 `await` 的传播, 当一个函数调用了一个`---@async`标记的函数时，会自动标记为`---@async`。'
config.hint.semicolon                    =
'若语句尾部没有分号，则显示虚拟分号。'
config.hint.semicolon.All                =
'所有语句都显示虚拟分号。'
config.hint.semicolon.SameLine           =
'2个语句在同一行时，在它们之间显示分号。'
config.hint.semicolon.Disable            =
'禁用虚拟分号。'
config.codeLens.enable                   =
'启用代码度量。'
config.format.enable                     =
'启用代码格式化程序。'
config.format.defaultConfig              =
[[
默认的格式化配置，优先级低于工作区内的 `.editorconfig` 文件。
请查阅[格式化文档](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)了解用法。
]]
config.spell.dict                        =
'拼写检查的自定义单词。'
config.nameStyle.config                  =
'设定命名风格检查的配置'
config.telemetry.enable                  =
[[
启用遥测，通过网络发送你的编辑器信息与错误日志。在[此处](https://luals.github.io/privacy/#language-server)阅读我们的隐私声明。
]]
config.misc.parameters                   =
'VSCode中启动语言服务时的[命令行参数](https://luals.github.io/wiki/usage#arguments)。'
config.misc.executablePath               =
'VSCode中指定可执行文件路径。'
config.language.fixIndent                =
'(仅VSCode) 修复错误的自动缩进，例如在包含单词 "function" 的字符串中换行时出现的错误缩进。'
config.language.completeAnnotation       =
'(仅VSCode) 在注解后换行时自动插入 "---@ "。'
config.type.castNumberToInteger          =
'允许将 `number` 类型赋给 `integer` 类型。'
config.type.weakUnionCheck               =
[[
联合类型中只要有一个子类型满足条件，则联合类型也满足条件。

此设置为 `false` 时，`number|boolean` 类型无法赋给 `number` 类型；为 `true` 时则可以。
]]
config.type.weakNilCheck                 =
[[
对联合类型进行类型检查时，忽略其中的 `nil`。

此设置为 `false` 时，`numer|nil` 类型无法赋给 `number` 类型；为 `true` 是则可以。
]]
config.type.inferParamType               =
[[
未注释参数类型时，参数类型由函数传入参数推断。

如果设置为 "false"，则在未注释时，参数类型为 "any"。
]]
config.type.checkTableShape              =
[[
对表的形状进行严格检查。
]]
config.doc.privateName                   =
'将特定名称的字段视为私有，例如 `m_*` 意味着 `XXX.m_id` 与 `XXX.m_type` 是私有字段，只能在定义所在的类中访问。'
config.doc.protectedName                 =
'将特定名称的字段视为受保护，例如 `m_*` 意味着 `XXX.m_id` 与 `XXX.m_type` 是受保护的字段，只能在定义所在的类极其子类中访问。'
config.doc.packageName                   =
'将特定名称的字段视为package，例如 `m_*` 意味着 `XXX.m_id` 与 `XXX.m_type` 只能在定义所在的文件中访问。'
config.diagnostics['unused-local']          =
'未使用的局部变量'
config.diagnostics['unused-function']       =
'未使用的函数'
config.diagnostics['undefined-global']      =
'未定义的全局变量'
config.diagnostics['global-in-nil-env']     =
'不能使用全局变量（ `_ENV` 被设置为了 `nil`）'
config.diagnostics['unused-label']          =
'未使用的标签'
config.diagnostics['unused-vararg']         =
'未使用的不定参数'
config.diagnostics['trailing-space']        =
'后置空格'
config.diagnostics['redefined-local']       =
'重复定义的局部变量'
config.diagnostics['newline-call']          =
'以 `(` 开始的新行，在语法上被解析为了上一行的函数调用'
config.diagnostics['newfield-call']         =
'在字面量表中，2行代码之间缺少分隔符，在语法上被解析为了一次索引操作'
config.diagnostics['redundant-parameter']   =
'函数调用时，传入了多余的参数'
config.diagnostics['ambiguity-1']           =
'优先级歧义，如：`num or 0 + 1`，推测用户的实际期望为 `(num or 0) + 1` '
config.diagnostics['lowercase-global']      =
'首字母小写的全局变量定义'
config.diagnostics['undefined-env-child']   =
'`_ENV` 被设置为了新的字面量表，但是试图获取的全局变量不再这张表中'
config.diagnostics['duplicate-index']       =
'在字面量表中重复定义了索引'
config.diagnostics['empty-block']           =
'空代码块'
config.diagnostics['redundant-value']       =
'赋值操作时，值的数量比被赋值的对象多'
config.diagnostics['assign-type-mismatch']  =
'值类型与赋值变量类型不匹配'
config.diagnostics['await-in-sync']         =
'同步函数中异步函数调用'
config.diagnostics['cast-local-type']    =
'已显式定义变量类型与要定义的值的类型不匹配'
config.diagnostics['cast-type-mismatch']    =
'变量被转换为与其初始类型不匹配的类型'
config.diagnostics['circular-doc-class']    =
'两个类相互继承并互相循环'
config.diagnostics['close-non-object']      =
'尝试关闭非对象变量的诊断'
config.diagnostics['code-after-break']      =
'放在循环中break语句后面的代码'
config.diagnostics['codestyle-check']       =
'启用对不正确样式行的诊断'
config.diagnostics['count-down-loop']       =
'for循环永远无法达到最大/极限值(在递减时递增)'
config.diagnostics['deprecated']            =
'变量已被标记为deprecated(过时)但仍在使用'
config.diagnostics['different-requires']    =
'required的同一个文件使用了两个不同的名字'
config.diagnostics['discard-returns']       =
'函数的返回值被忽略(函数被`@nodiscard`标记时)'
config.diagnostics['doc-field-no-class']    =
'为不存在的类`@class`标记`@field`字段'
config.diagnostics['duplicate-doc-alias']   =
'`@alias`字段的名字冲突'
config.diagnostics['duplicate-doc-field']   =
'`@field`字段的名字冲突'
config.diagnostics['duplicate-doc-param']   =
'`@param`字段的名字冲突'
config.diagnostics['duplicate-set-field']   =
'在一个类中多次定义同一字段'
config.diagnostics['incomplete-signature-doc'] =
'`@param`或`@return`的注释不完整'
config.diagnostics['invisible']             =
'使用不可见的值'
config.diagnostics['missing-global-doc']    =
'全局变量的注释缺失(全局函数必须为所有参数和返回值提供注释和注释)'
config.diagnostics['missing-local-export-doc'] =
'导出的本地函数缺少注释(导出的本地函数必须有包括本身以及所有参数和返回值的注释)'
config.diagnostics['missing-parameter']     =
'函数参数数少于注释函数参数数'
config.diagnostics['missing-return']        =
'函数带有返回注释而无返回语句'
config.diagnostics['missing-return-value']  =
'函数无值返回但函数使用`@return`标记了返回值'
config.diagnostics['need-check-nil']        =
'变量之前被赋值为`nil`或可选值(可能为 `nil`)'
config.diagnostics['unnecessary-assert']    =
'启用对冗余断言(针对始终为真值的表达式)的诊断'
config.diagnostics['no-unknown']            =
'变量的未知类型无法推断'
config.diagnostics['not-yieldable']         =
'不允许调用 `coroutine.yield()` '
config.diagnostics['param-type-mismatch']   =
'给定参数的类型与函数定义所要求的类型(`@param`)不匹配'
config.diagnostics['redundant-return']      =
'当放置一个不需要的返回值时触发(函数会自行退出)'
config.diagnostics['redundant-return-value']=
'返回`@return`注释未指定的额外值'
config.diagnostics['return-type-mismatch']  =
'返回值的类型与`@return`中声明的类型不匹配'
config.diagnostics['spell-check']           =
'启用字符串拼写检查的诊断。'
config.diagnostics['name-style-check']      =
'变量的名称样式检查'
config.diagnostics['unbalanced-assignments']=
'多重赋值时没有赋值所有变量(如`local x,y = 1`)'
config.diagnostics['undefined-doc-class']   =
'在`@class`注解中引用未定义的类。'
config.diagnostics['undefined-doc-name']    =
'在`@type`注解中引用未定义的类型或`@alias`'
config.diagnostics['undefined-doc-param']   =
'函数声明中`@param`引用了未定义的参数'
config.diagnostics['undefined-field']       =
'引用变量的未定义字段'
config.diagnostics['unknown-cast-variable'] =
'使用`@cast`对未定义变量的强制转换'
config.diagnostics['unknown-diag-code']     =
'未知的诊断代码'
config.diagnostics['unknown-operator']      =
'未知的运算符'
config.diagnostics['unreachable-code']      =
'不可达的代码'
config.diagnostics['global-element']       =
'启用诊断以警告全局元素。'
config.typeFormat.config                    =
'配置输入Lua代码时的格式化行为'
config.typeFormat.config.auto_complete_end  =
'是否在合适的位置自动完成 `end`'
config.typeFormat.config.auto_complete_table_sep =
'是否在table末尾自动添加分隔符'
config.typeFormat.config.format_line        =
'是否对某一行进行格式化'

command.exportDocument =
'Lua: 导出文档...'
command.addon_manager.open =
'Lua: 打开插件管理器...'
command.reloadFFIMeta =
'Lua: 重新生成luajit的FFI模块C语言元数据'
command.startServer =
'Lua: 重启语言服务器'
command.stopServer =
'Lua: 停止语言服务器'
