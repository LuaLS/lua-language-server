---@diagnostic disable: undefined-global

config.addonManager.enable        = -- TODO: need translate!
"Whether the addon manager is enabled or not."
config.addonManager.repositoryBranch = -- TODO: need translate!
"Specifies the git branch used by the addon manager."
config.addonManager.repositoryPath = -- TODO: need translate!
"Specifies the git path used by the addon manager."
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
"Plugin path. Please read [wiki](https://luals.github.io/wiki/plugins) to learn more."
config.runtime.pluginArgs         = -- TODO: need translate!
"Additional arguments for the plugin."
config.runtime.fileEncoding       = -- TODO: need translate!
"File encoding. The `ansi` option is only available under the `Windows` platform."
config.runtime.builtin            = -- TODO: need translate!
[[
Adjust the enabled state of the built-in library. You can disable (or redefine) the non-existent library according to the actual runtime environment.

* `default`: Indicates that the library will be enabled or disabled according to the runtime version
* `enable`: always enable
* `disable`: always disable
]]
config.runtime.meta               = -- TODO: need translate!
'Format of the directory name of the meta files.'
config.diagnostics.enable         = -- TODO: need translate!
"Enable diagnostics."
config.diagnostics.disable        = -- TODO: need translate!
"Disabled diagnostic (Use code in hover brackets)."
config.diagnostics.globals        = -- TODO: need translate!
"Defined global variables."
config.diagnostics.globalsRegex   = -- TODO: need translate!
"Find defined global variables using regex."
config.diagnostics.severity       = -- TODO: need translate!
[[
Modify the diagnostic severity.

End with `!` means override the group setting `diagnostics.groupSeverity`.
]]
config.diagnostics.neededFileStatus = -- TODO: need translate!
[[
* Opened:  only diagnose opened files
* Any:     diagnose all files
* None:    disable this diagnostic

End with `!` means override the group setting `diagnostics.groupFileStatus`.
]]
config.diagnostics.groupSeverity  = -- TODO: need translate!
[[
Modify the diagnostic severity in a group.
`Fallback` means that diagnostics in this group are controlled by `diagnostics.severity` separately.
Other settings will override individual settings without end of `!`.
]]
config.diagnostics.groupFileStatus = -- TODO: need translate!
[[
Modify the diagnostic needed file status in a group.

* Opened:  only diagnose opened files
* Any:     diagnose all files
* None:    disable this diagnostic

`Fallback` means that diagnostics in this group are controlled by `diagnostics.neededFileStatus` separately.
Other settings will override individual settings without end of `!`.
]]
config.diagnostics.workspaceEvent = -- TODO: need translate!
"Set the time to trigger workspace diagnostics."
config.diagnostics.workspaceEvent.OnChange = -- TODO: need translate!
"Trigger workspace diagnostics when the file is changed."
config.diagnostics.workspaceEvent.OnSave = -- TODO: need translate!
"Trigger workspace diagnostics when the file is saved."
config.diagnostics.workspaceEvent.None = -- TODO: need translate!
"Disable workspace diagnostics."
config.diagnostics.workspaceDelay = -- TODO: need translate!
"Latency (milliseconds) for workspace diagnostics."
config.diagnostics.workspaceRate  = -- TODO: need translate!
"Workspace diagnostics run rate (%). Decreasing this value reduces CPU usage, but also reduces the speed of workspace diagnostics. The diagnosis of the file you are currently editing is always done at full speed and is not affected by this setting."
config.diagnostics.libraryFiles   = -- TODO: need translate!
"How to diagnose files loaded via `Lua.workspace.library`."
config.diagnostics.libraryFiles.Enable   = -- TODO: need translate!
"Always diagnose these files."
config.diagnostics.libraryFiles.Opened   = -- TODO: need translate!
"Only when these files are opened will it be diagnosed."
config.diagnostics.libraryFiles.Disable  = -- TODO: need translate!
"These files are not diagnosed."
config.diagnostics.ignoredFiles   = -- TODO: need translate!
"How to diagnose ignored files."
config.diagnostics.ignoredFiles.Enable   = -- TODO: need translate!
"Always diagnose these files."
config.diagnostics.ignoredFiles.Opened   = -- TODO: need translate!
"Only when these files are opened will it be diagnosed."
config.diagnostics.ignoredFiles.Disable  = -- TODO: need translate!
"These files are not diagnosed."
config.diagnostics.disableScheme  = -- TODO: need translate!
'Do not diagnose Lua files that use the following scheme.'
config.diagnostics.unusedLocalExclude = -- TODO: need translate!
'Do not diagnose `unused-local` when the variable name matches the following pattern.'
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
'Add private third-party library configuration file paths here, please refer to the built-in [configuration file path](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)'
config.workspace.supportScheme           = -- TODO: need translate!
'Provide language server for the Lua files of the following scheme.'
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
config.hover.expandAlias                 = -- TODO: need translate!
[[
Whether to expand the alias. For example, expands `---@alias myType boolean|number` appears as `boolean|number`, otherwise it appears as `myType'.
]]
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
config.hint.await                        = -- TODO: need translate!
'If the called function is marked `---@async`, prompt `await` at the call.'
config.hint.awaitPropagate               = -- TODO: need translate!
'Enable the propagation of `await`. When a function calls a function marked `---@async`,\z
it will be automatically marked as `---@async`.'
config.hint.semicolon                    = -- TODO: need translate!
'If there is no semicolon at the end of the statement, display a virtual semicolon.'
config.hint.semicolon.All                = -- TODO: need translate!
'All statements display virtual semicolons.'
config.hint.semicolon.SameLine            = -- TODO: need translate!
'When two statements are on the same line, display a semicolon between them.'
config.hint.semicolon.Disable            = -- TODO: need translate!
'Disable virtual semicolons.'
config.codeLens.enable                   = -- TODO: need translate!
'Enable code lens.'
config.format.enable                     = -- TODO: need translate!
'Enable code formatter.'
config.format.defaultConfig              = -- TODO: need translate!
[[
The default format configuration. Has a lower priority than `.editorconfig` file in the workspace.
Read [formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) to learn usage.
]]
config.spell.dict                        = -- TODO: need translate!
'Custom words for spell checking.'
config.nameStyle.config                  = -- TODO: need translate!
'Set name style config'
config.telemetry.enable                  = -- TODO: need translate!
[[
Enable telemetry to send your editor information and error logs over the network. Read our privacy policy [here](https://luals.github.io/privacy/#language-server).
]]
config.misc.parameters                   = -- TODO: need translate!
'[Command line parameters](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) when starting the language service in VSCode.'
config.misc.executablePath               = -- TODO: need translate!
'Specify the executable path in VSCode.'
config.language.fixIndent                = -- TODO: need translate!
'(VSCode only) Fix incorrect auto-indentation, such as incorrect indentation when line breaks occur within a string containing the word "function."'
config.language.completeAnnotation       = -- TODO: need translate!
'(VSCode only) Automatically insert "---@ " after a line break following a annotation.'
config.type.castNumberToInteger          = -- TODO: need translate!
'Allowed to assign the `number` type to the `integer` type.'
config.type.weakUnionCheck               = -- TODO: need translate!
[[
Once one subtype of a union type meets the condition, the union type also meets the condition.

When this setting is `false`, the `number|boolean` type cannot be assigned to the `number` type. It can be with `true`.
]]
config.type.weakNilCheck                 = -- TODO: need translate!
[[
When checking the type of union type, ignore the `nil` in it.

When this setting is `false`, the `number|nil` type cannot be assigned to the `number` type. It can be with `true`.
]]
config.type.inferParamType               = -- TODO: need translate!
[[
When the parameter type is not annotated, the parameter type is inferred from the function's incoming parameters.

When this setting is `false`, the type of the parameter is `any` when it is not annotated.
]]
config.type.checkTableShape              = -- TODO: need translate!
[[
对表的形状进行严格检查。
]]
config.doc.privateName                   = -- TODO: need translate!
'Treat specific field names as private, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are private, witch can only be accessed in the class where the definition is located.'
config.doc.protectedName                 = -- TODO: need translate!
'Treat specific field names as protected, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are protected, witch can only be accessed in the class where the definition is located and its subclasses.'
config.doc.packageName                   = -- TODO: need translate!
'Treat specific field names as package, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are package, witch can only be accessed in the file where the definition is located.'
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
config.diagnostics['assign-type-mismatch']  = -- TODO: need translate!
'Enable diagnostics for assignments in which the value\'s type does not match the type of the assigned variable.'
config.diagnostics['await-in-sync']         = -- TODO: need translate!
'Enable diagnostics for calls of asynchronous functions within a synchronous function.'
config.diagnostics['cast-local-type']    = -- TODO: need translate!
'Enable diagnostics for casts of local variables where the target type does not match the defined type.'
config.diagnostics['cast-type-mismatch']    = -- TODO: need translate!
'Enable diagnostics for casts where the target type does not match the initial type.'
config.diagnostics['circular-doc-class']    = -- TODO: need translate!
'Enable diagnostics for two classes inheriting from each other introducing a circular relation.'
config.diagnostics['close-non-object']      = -- TODO: need translate!
'Enable diagnostics for attempts to close a variable with a non-object.'
config.diagnostics['code-after-break']      = -- TODO: need translate!
'Enable diagnostics for code placed after a break statement in a loop.'
config.diagnostics['codestyle-check']       = -- TODO: need translate!
'Enable diagnostics for incorrectly styled lines.'
config.diagnostics['count-down-loop']       = -- TODO: need translate!
'Enable diagnostics for `for` loops which will never reach their max/limit because the loop is incrementing instead of decrementing.'
config.diagnostics['deprecated']            = -- TODO: need translate!
'Enable diagnostics to highlight deprecated API.'
config.diagnostics['different-requires']    = -- TODO: need translate!
'Enable diagnostics for files which are required by two different paths.'
config.diagnostics['discard-returns']       = -- TODO: need translate!
'Enable diagnostics for calls of functions annotated with `---@nodiscard` where the return values are ignored.'
config.diagnostics['doc-field-no-class']    = -- TODO: need translate!
'Enable diagnostics to highlight a field annotation without a defining class annotation.'
config.diagnostics['duplicate-doc-alias']   = -- TODO: need translate!
'Enable diagnostics for a duplicated alias annotation name.'
config.diagnostics['duplicate-doc-field']   = -- TODO: need translate!
'Enable diagnostics for a duplicated field annotation name.'
config.diagnostics['duplicate-doc-param']   = -- TODO: need translate!
'Enable diagnostics for a duplicated param annotation name.'
config.diagnostics['duplicate-set-field']   = -- TODO: need translate!
'Enable diagnostics for setting the same field in a class more than once.'
config.diagnostics['incomplete-signature-doc'] = -- TODO: need translate!
'Incomplete @param or @return annotations for functions.'
config.diagnostics['invisible']             = -- TODO: need translate!
'Enable diagnostics for accesses to fields which are invisible.'
config.diagnostics['missing-global-doc']    = -- TODO: need translate!
'Missing annotations for globals! Global functions must have a comment and annotations for all parameters and return values.'
config.diagnostics['missing-local-export-doc'] = -- TODO: need translate!
'Missing annotations for exported locals! Exported local functions must have a comment and annotations for all parameters and return values.'
config.diagnostics['missing-parameter']     = -- TODO: need translate!
'Enable diagnostics for function calls where the number of arguments is less than the number of annotated function parameters.'
config.diagnostics['missing-return']        = -- TODO: need translate!
'Enable diagnostics for functions with return annotations which have no return statement.'
config.diagnostics['missing-return-value']  = -- TODO: need translate!
'Enable diagnostics for return statements without values although the containing function declares returns.'
config.diagnostics['need-check-nil']        = -- TODO: need translate!
'Enable diagnostics for variable usages if `nil` or an optional (potentially `nil`) value was assigned to the variable before.'
config.diagnostics['unnecessary-assert']    = -- TODO: need translate!
'Enable diagnostics for redundant assertions on truthy values.'
config.diagnostics['no-unknown']            = -- TODO: need translate!
'Enable diagnostics for cases in which the type cannot be inferred.'
config.diagnostics['not-yieldable']         = -- TODO: need translate!
'Enable diagnostics for calls to `coroutine.yield()` when it is not permitted.'
config.diagnostics['param-type-mismatch']   = -- TODO: need translate!
'Enable diagnostics for function calls where the type of a provided parameter does not match the type of the annotated function definition.'
config.diagnostics['redundant-return']      = -- TODO: need translate!
'Enable diagnostics for return statements which are not needed because the function would exit on its own.'
config.diagnostics['redundant-return-value']= -- TODO: need translate!
'Enable diagnostics for return statements which return an extra value which is not specified by a return annotation.'
config.diagnostics['return-type-mismatch']  = -- TODO: need translate!
'Enable diagnostics for return values whose type does not match the type declared in the corresponding return annotation.'
config.diagnostics['spell-check']           = -- TODO: need translate!
'Enable diagnostics for typos in strings.'
config.diagnostics['name-style-check']      = -- TODO: need translate!
'Enable diagnostics for name style.'
config.diagnostics['unbalanced-assignments']= -- TODO: need translate!
'Enable diagnostics on multiple assignments if not all variables obtain a value (e.g., `local x,y = 1`).'
config.diagnostics['undefined-doc-class']   = -- TODO: need translate!
'Enable diagnostics for class annotations in which an undefined class is referenced.'
config.diagnostics['undefined-doc-name']    = -- TODO: need translate!
'Enable diagnostics for type annotations referencing an undefined type or alias.'
config.diagnostics['undefined-doc-param']   = -- TODO: need translate!
'Enable diagnostics for cases in which a parameter annotation is given without declaring the parameter in the function definition.'
config.diagnostics['undefined-field']       = -- TODO: need translate!
'Enable diagnostics for cases in which an undefined field of a variable is read.'
config.diagnostics['unknown-cast-variable'] = -- TODO: need translate!
'Enable diagnostics for casts of undefined variables.'
config.diagnostics['unknown-diag-code']     = -- TODO: need translate!
'Enable diagnostics in cases in which an unknown diagnostics code is entered.'
config.diagnostics['unknown-operator']      = -- TODO: need translate!
'Enable diagnostics for unknown operators.'
config.diagnostics['unreachable-code']      = -- TODO: need translate!
'Enable diagnostics for unreachable code.'
config.diagnostics['global-element']       = -- TODO: need translate!
'Enable diagnostics to warn about global elements.'
config.typeFormat.config                    = -- TODO: need translate!
'Configures the formatting behavior while typing Lua code.'
config.typeFormat.config.auto_complete_end  = -- TODO: need translate!
'Controls if `end` is automatically completed at suitable positions.'
config.typeFormat.config.auto_complete_table_sep = -- TODO: need translate!
'Controls if a separator is automatically appended at the end of a table declaration.'
config.typeFormat.config.format_line        = -- TODO: need translate!
'Controls if a line is formatted at all.'

command.exportDocument = -- TODO: need translate!
'Lua: Export Document ...'
command.addon_manager.open = -- TODO: need translate!
'Lua: Open Addon Manager ...'
command.reloadFFIMeta = -- TODO: need translate!
'Lua: Reload luajit ffi meta'
command.startServer = -- TODO: need translate!
'Lua: Restart Language Server'
command.stopServer = -- TODO: need translate!
'Lua: Stop Language Server'
