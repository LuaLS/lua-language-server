---@diagnostic disable: undefined-global

config.runtime.version            = -- TODO: need translate!
"Lua runtime version."
config.runtime.path               = -- TODO: need translate!
[[
When using `require`, how to find the file based on the input name.
Setting this config to `?/init.lua` means that when you enter `require 'myfile'`, `${workspace}/myfile/init.lua` will be searched from the loaded files.
if `runtime.pathStrict` is `false`, `${workspace}/**/myfile/init.lua` will also be searched.
If you want to load files outside the workspace, you need to set `Lua.workspace.library` first.
]]
config.runtime.pathStrict         = -- TODO: need translate!
'When enabled, `runtime.path` will only search the first level of directories, see the description of `runtime.path`.'
config.runtime.special            = -- TODO: need translate!
[[The custom global variables are regarded as some special built-in variables, and the language server will provide special support
The following example shows that 'include' is treated as' require '.
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```
]]
config.runtime.unicodeName        = -- TODO: need translate!
"Allows Unicode characters in name."
config.runtime.nonstandardSymbol  = -- TODO: need translate!
"Supports non-standard symbols. Make sure that your runtime environment supports these symbols."
config.runtime.plugin             = -- TODO: need translate!
"Plugin path. Please read [wiki](https://github.com/sumneko/lua-language-server/wiki/Plugin) to learn more."
config.runtime.fileEncoding       = -- TODO: need translate!
"File encoding. The `ansi` option is only available under the `Windows` platform."
config.runtime.builtin            = -- TODO: need translate!
[[
Adjust the enabled state of the built-in library. You can disable (or redefine) the non-existent library according to the actual runtime environment.

* `default`: Indicates that the library will be enabled or disabled according to the runtime version
* `enable`: always enable
* `disable`: always disable
]]
config.diagnostics.enable         = -- TODO: need translate!
"Enable diagnostics."
config.diagnostics.disable        = -- TODO: need translate!
"Disabled diagnostic (Use code in hover brackets)."
config.diagnostics.globals        = -- TODO: need translate!
"Defined global variables."
config.diagnostics.severity       = -- TODO: need translate!
"Modified diagnostic severity."
config.diagnostics.neededFileStatus = -- TODO: need translate!
[[
* Opened:  only diagnose opened files
* Any:     diagnose all files
* Disable: disable this diagnostic
]]
config.diagnostics.workspaceDelay = -- TODO: need translate!
"Latency (milliseconds) for workspace diagnostics. When you start the workspace, or edit any file, the entire workspace will be re-diagnosed in the background. Set to negative to disable workspace diagnostics."
config.diagnostics.workspaceRate  = -- TODO: need translate!
"Workspace diagnostics run rate (%). Decreasing this value reduces CPU usage, but also reduces the speed of workspace diagnostics. The diagnosis of the file you are currently editing is always done at full speed and is not affected by this setting."
config.diagnostics.libraryFiles   = -- TODO: need translate!
"How to diagnose files loaded via `Lua.workspace.library`."
config.diagnostics.ignoredFiles   = -- TODO: need translate!
"How to diagnose ignored files."
config.diagnostics.files.Enable   = -- TODO: need translate!
"Always diagnose these files."
config.diagnostics.files.Opened   = -- TODO: need translate!
"Only when these files are opened will it be diagnosed."
config.diagnostics.files.Disable  = -- TODO: need translate!
"These files are not diagnosed."
config.workspace.ignoreDir        = -- TODO: need translate!
"Ignored files and directories (Use `.gitignore` grammar)."-- .. example.ignoreDir,
config.workspace.ignoreSubmodules = -- TODO: need translate!
"Ignore submodules."
config.workspace.useGitIgnore     = -- TODO: need translate!
"Ignore files list in `.gitignore` ."
config.workspace.maxPreload       = -- TODO: need translate!
"Max preloaded files."
config.workspace.preloadFileSize  = -- TODO: need translate!
"Skip files larger than this value (KB) when preloading."
config.workspace.library          = -- TODO: need translate!
"In addition to the current workspace, which directories will load files from. The files in these directories will be treated as externally provided code libraries, and some features (such as renaming fields) will not modify these files."
config.workspace.checkThirdParty  = -- TODO: need translate!
[[
Automatic detection and adaptation of third-party libraries, currently supported libraries are:

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]]
config.workspace.userThirdParty          = -- TODO: need translate!
'Add private third-party library configuration file paths here, please refer to the built-in [configuration file path](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)'
config.completion.enable                 = -- TODO: need translate!
'Enable completion.'
config.completion.callSnippet            = -- TODO: need translate!
'Shows function call snippets.'
config.completion.callSnippet.Disable    = -- TODO: need translate!
"Only shows `function name`."
config.completion.callSnippet.Both       = -- TODO: need translate!
"Shows `function name` and `call snippet`."
config.completion.callSnippet.Replace    = -- TODO: need translate!
"Only shows `call snippet.`"
config.completion.keywordSnippet         = -- TODO: need translate!
'Shows keyword syntax snippets.'
config.completion.keywordSnippet.Disable = -- TODO: need translate!
"Only shows `keyword`."
config.completion.keywordSnippet.Both    = -- TODO: need translate!
"Shows `keyword` and `syntax snippet`."
config.completion.keywordSnippet.Replace = -- TODO: need translate!
"Only shows `syntax snippet`."
config.completion.displayContext         = -- TODO: need translate!
"Previewing the relevant code snippet of the suggestion may help you understand the usage of the suggestion. The number set indicates the number of intercepted lines in the code fragment. If it is set to `0`, this feature can be disabled."
config.completion.workspaceWord          = -- TODO: need translate!
"Whether the displayed context word contains the content of other files in the workspace."
config.completion.showWord               = -- TODO: need translate!
"Show contextual words in suggestions."
config.completion.showWord.Enable        = -- TODO: need translate!
"Always show context words in suggestions."
config.completion.showWord.Fallback      = -- TODO: need translate!
"Contextual words are only displayed when suggestions based on semantics cannot be provided."
config.completion.showWord.Disable       = -- TODO: need translate!
"Do not display context words."
config.completion.autoRequire            = -- TODO: need translate!
"When the input looks like a file name, automatically `require` this file."
config.completion.showParams             = -- TODO: need translate!
"Display parameters in completion list. When the function has multiple definitions, they will be displayed separately."
config.completion.requireSeparator       = -- TODO: need translate!
"The separator used when `require`."
config.completion.postfix                = -- TODO: need translate!
"The symbol used to trigger the postfix suggestion."
config.color.mode                        = -- TODO: need translate!
"Color mode."
config.color.mode.Semantic               = -- TODO: need translate!
"Semantic color. You may need to set `editor.semanticHighlighting.enabled` to `true` to take effect."
config.color.mode.SemanticEnhanced       = -- TODO: need translate!
"Enhanced semantic color. Like `Semantic`, but with additional analysis which might be more computationally expensive."
config.color.mode.Grammar                = -- TODO: need translate!
"Grammar color."
config.semantic.enable                   = -- TODO: need translate!
"Enable semantic color. You may need to set `editor.semanticHighlighting.enabled` to `true` to take effect."
config.semantic.variable                 = -- TODO: need translate!
"Semantic coloring of variables/fields/parameters."
config.semantic.annotation               = -- TODO: need translate!
"Semantic coloring of type annotations."
config.semantic.keyword                  = -- TODO: need translate!
"Semantic coloring of keywords/literals/operators. You only need to enable this feature if your editor cannot do syntax coloring."
config.signatureHelp.enable              = -- TODO: need translate!
"Enable signature help."
config.hover.enable                      = -- TODO: need translate!
"Enable hover."
config.hover.viewString                  = -- TODO: need translate!
"Hover to view the contents of a string (only if the literal contains an escape character)."
config.hover.viewStringMax               = -- TODO: need translate!
"The maximum length of a hover to view the contents of a string."
config.hover.viewNumber                  = -- TODO: need translate!
"Hover to view numeric content (only if literal is not decimal)."
config.hover.fieldInfer                  = -- TODO: need translate!
"When hovering to view a table, type infer will be performed for each field. When the accumulated time of type infer reaches the set value (MS), the type infer of subsequent fields will be skipped."
config.hover.previewFields               = -- TODO: need translate!
"When hovering to view a table, limits the maximum number of previews for fields."
config.hover.enumsLimit                  = -- TODO: need translate!
"When the value corresponds to multiple types, limit the number of types displaying."
config.develop.enable                    = -- TODO: need translate!
'Developer mode. Do not enable, performance will be affected.'
config.develop.debuggerPort              = -- TODO: need translate!
'Listen port of debugger.'
config.develop.debuggerWait              = -- TODO: need translate!
'Suspend before debugger connects.'
config.intelliSense.searchDepth          = -- TODO: need translate!
'Set the search depth for IntelliSense. Increasing this value increases accuracy, but decreases performance. Different workspace have different tolerance for this setting. Please adjust it to the appropriate value.'
config.intelliSense.fastGlobal           = -- TODO: need translate!
'In the global variable completion, and view `_G` suspension prompt. This will slightly reduce the accuracy of type speculation, but it will have a significant performance improvement for projects that use a lot of global variables.'
config.window.statusBar                  = -- TODO: need translate!
'Show extension status in status bar.'
config.window.progressBar                = -- TODO: need translate!
'Show progress bar in status bar.'
config.hint.enable                       = -- TODO: need translate!
'Enable inlay hint.'
config.hint.paramType                    = -- TODO: need translate!
'Show type hints at the parameter of the function.'
config.hint.setType                      = -- TODO: need translate!
'Show hints of type at assignment operation.'
config.hint.paramName                    = -- TODO: need translate!
'Show hints of parameter name at the function call.'
config.hint.paramName.All                = -- TODO: need translate!
'All types of parameters are shown.'
config.hint.paramName.Literal            = -- TODO: need translate!
'Only literal type parameters are shown.'
config.hint.paramName.Disable            = -- TODO: need translate!
'Disable parameter hints.'
config.hint.arrayIndex                   = -- TODO: need translate!
'Show hints of array index when constructing a table.'
config.hint.arrayIndex.Enable            = -- TODO: need translate!
'Show hints in all tables.'
config.hint.arrayIndex.Auto              = -- TODO: need translate!
'Show hints only when the table is greater than 3 items, or the table is a mixed table.'
config.hint.arrayIndex.Disable           = -- TODO: need translate!
'Disable hints of array index.'
config.format.enable                     = -- TODO: need translate!
'Enable code formatter.'
config.telemetry.enable                  = -- TODO: need translate!
[[
Enable telemetry to send your editor information and error logs over the network. Read our privacy policy [here](https://github.com/sumneko/lua-language-server/wiki/Privacy-Policy).
]]
config.misc.parameters                   = -- TODO: need translate!
'[Command line parameters](https://github.com/sumneko/lua-telemetry-server/tree/master/method) when starting the language service in VSCode.'
config.IntelliSense.traceLocalSet        = -- TODO: need translate!
'Please read [wiki](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features) to learn more.'
config.IntelliSense.traceReturn          = -- TODO: need translate!
'Please read [wiki](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features) to learn more.'
config.IntelliSense.traceBeSetted        = -- TODO: need translate!
'Please read [wiki](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features) to learn more.'
config.IntelliSense.traceFieldInject     = -- TODO: need translate!
'Please read [wiki](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features) to learn more.'
config.diagnostics['unused-local']          = -- TODO: need translate!
'未使用的局部变量'
config.diagnostics['unused-function']       = -- TODO: need translate!
'未使用的函数'
config.diagnostics['undefined-global']      = -- TODO: need translate!
'未定义的全局变量'
config.diagnostics['global-in-nil-env']     = -- TODO: need translate!
'不能使用全局变量（ `_ENV` 被设置为了 `nil`）'
config.diagnostics['unused-label']          = -- TODO: need translate!
'未使用的标签'
config.diagnostics['unused-vararg']         = -- TODO: need translate!
'未使用的不定参数'
config.diagnostics['trailing-space']        = -- TODO: need translate!
'后置空格'
config.diagnostics['redefined-local']       = -- TODO: need translate!
'重复定义的局部变量'
config.diagnostics['newline-call']          = -- TODO: need translate!
'以 `(` 开始的新行，在语法上被解析为了上一行的函数调用'
config.diagnostics['newfield-call']         = -- TODO: need translate!
'在字面量表中，2行代码之间缺少分隔符，在语法上被解析为了一次索引操作'
config.diagnostics['redundant-parameter']   = -- TODO: need translate!
'函数调用时，传入了多余的参数'
config.diagnostics['ambiguity-1']           = -- TODO: need translate!
'优先级歧义，如：`num or 0 + 1`，推测用户的实际期望为 `(num or 0) + 1` '
config.diagnostics['lowercase-global']      = -- TODO: need translate!
'首字母小写的全局变量定义'
config.diagnostics['undefined-env-child']   = -- TODO: need translate!
'`_ENV` 被设置为了新的字面量表，但是试图获取的全局变量不再这张表中'
config.diagnostics['duplicate-index']       = -- TODO: need translate!
'在字面量表中重复定义了索引'
config.diagnostics['empty-block']           = -- TODO: need translate!
'空代码块'
config.diagnostics['redundant-value']       = -- TODO: need translate!
'赋值操作时，值的数量比被赋值的对象多'
