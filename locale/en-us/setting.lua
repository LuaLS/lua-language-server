---@diagnostic disable: undefined-global

config.addonManager.enable        =
"Whether the addon manager is enabled or not."
config.runtime.version            =
"Lua runtime version."
config.runtime.path               =
[[
When using `require`, how to find the file based on the input name.
Setting this config to `?/init.lua` means that when you enter `require 'myfile'`, `${workspace}/myfile/init.lua` will be searched from the loaded files.
if `runtime.pathStrict` is `false`, `${workspace}/**/myfile/init.lua` will also be searched.
If you want to load files outside the workspace, you need to set `Lua.workspace.library` first.
]]
config.runtime.pathStrict         =
'When enabled, `runtime.path` will only search the first level of directories, see the description of `runtime.path`.'
config.runtime.special            =
[[The custom global variables are regarded as some special built-in variables, and the language server will provide special support
The following example shows that 'include' is treated as' require '.
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```
]]
config.runtime.unicodeName        =
"Allows Unicode characters in name."
config.runtime.nonstandardSymbol  =
"Supports non-standard symbols. Make sure that your runtime environment supports these symbols."
config.runtime.plugin             =
"Plugin path. Please read [wiki](https://luals.github.io/wiki/plugins) to learn more."
config.runtime.pluginArgs         =
"Additional arguments for the plugin."
config.runtime.fileEncoding       =
"File encoding. The `ansi` option is only available under the `Windows` platform."
config.runtime.builtin            =
[[
Adjust the enabled state of the built-in library. You can disable (or redefine) the non-existent library according to the actual runtime environment.

* `default`: Indicates that the library will be enabled or disabled according to the runtime version
* `enable`: always enable
* `disable`: always disable
]]
config.runtime.meta               =
'Format of the directory name of the meta files.'
config.diagnostics.enable         =
"Enable diagnostics."
config.diagnostics.disable        =
"Disabled diagnostic (Use code in hover brackets)."
config.diagnostics.globals        =
"Defined global variables."
config.diagnostics.severity       =
[[
Modify the diagnostic severity.

End with `!` means override the group setting `diagnostics.groupSeverity`.
]]
config.diagnostics.neededFileStatus =
[[
* Opened:  only diagnose opened files
* Any:     diagnose all files
* None:    disable this diagnostic

End with `!` means override the group setting `diagnostics.groupFileStatus`.
]]
config.diagnostics.groupSeverity  =
[[
Modify the diagnostic severity in a group.
`Fallback` means that diagnostics in this group are controlled by `diagnostics.severity` separately.
Other settings will override individual settings without end of `!`.
]]
config.diagnostics.groupFileStatus =
[[
Modify the diagnostic needed file status in a group.

* Opened:  only diagnose opened files
* Any:     diagnose all files
* None:    disable this diagnostic

`Fallback` means that diagnostics in this group are controlled by `diagnostics.neededFileStatus` separately.
Other settings will override individual settings without end of `!`.
]]
config.diagnostics.workspaceEvent =
"Set the time to trigger workspace diagnostics."
config.diagnostics.workspaceEvent.OnChange =
"Trigger workspace diagnostics when the file is changed."
config.diagnostics.workspaceEvent.OnSave =
"Trigger workspace diagnostics when the file is saved."
config.diagnostics.workspaceEvent.None =
"Disable workspace diagnostics."
config.diagnostics.workspaceDelay =
"Latency (milliseconds) for workspace diagnostics."
config.diagnostics.workspaceRate  =
"Workspace diagnostics run rate (%). Decreasing this value reduces CPU usage, but also reduces the speed of workspace diagnostics. The diagnosis of the file you are currently editing is always done at full speed and is not affected by this setting."
config.diagnostics.libraryFiles   =
"How to diagnose files loaded via `Lua.workspace.library`."
config.diagnostics.libraryFiles.Enable   =
"Always diagnose these files."
config.diagnostics.libraryFiles.Opened   =
"Only when these files are opened will it be diagnosed."
config.diagnostics.libraryFiles.Disable  =
"These files are not diagnosed."
config.diagnostics.ignoredFiles   =
"How to diagnose ignored files."
config.diagnostics.ignoredFiles.Enable   =
"Always diagnose these files."
config.diagnostics.ignoredFiles.Opened   =
"Only when these files are opened will it be diagnosed."
config.diagnostics.ignoredFiles.Disable  =
"These files are not diagnosed."
config.diagnostics.disableScheme  =
'Do not diagnose Lua files that use the following scheme.'
config.diagnostics.unusedLocalExclude =
'Do not diagnose `unused-local` when the variable name matches the following pattern.'
config.workspace.ignoreDir        =
"Ignored files and directories (Use `.gitignore` grammar)."-- .. example.ignoreDir,
config.workspace.ignoreSubmodules =
"Ignore submodules."
config.workspace.useGitIgnore     =
"Ignore files list in `.gitignore` ."
config.workspace.maxPreload       =
"Max preloaded files."
config.workspace.preloadFileSize  =
"Skip files larger than this value (KB) when preloading."
config.workspace.library          =
"In addition to the current workspace, which directories will load files from. The files in these directories will be treated as externally provided code libraries, and some features (such as renaming fields) will not modify these files."
config.workspace.checkThirdParty  =
[[
Automatic detection and adaptation of third-party libraries, currently supported libraries are:

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]]
config.workspace.userThirdParty          =
'Add private third-party library configuration file paths here, please refer to the built-in [configuration file path](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)'
config.workspace.supportScheme           =
'Provide language server for the Lua files of the following scheme.'
config.completion.enable                 =
'Enable completion.'
config.completion.callSnippet            =
'Shows function call snippets.'
config.completion.callSnippet.Disable    =
"Only shows `function name`."
config.completion.callSnippet.Both       =
"Shows `function name` and `call snippet`."
config.completion.callSnippet.Replace    =
"Only shows `call snippet.`"
config.completion.keywordSnippet         =
'Shows keyword syntax snippets.'
config.completion.keywordSnippet.Disable =
"Only shows `keyword`."
config.completion.keywordSnippet.Both    =
"Shows `keyword` and `syntax snippet`."
config.completion.keywordSnippet.Replace =
"Only shows `syntax snippet`."
config.completion.displayContext         =
"Previewing the relevant code snippet of the suggestion may help you understand the usage of the suggestion. The number set indicates the number of intercepted lines in the code fragment. If it is set to `0`, this feature can be disabled."
config.completion.workspaceWord          =
"Whether the displayed context word contains the content of other files in the workspace."
config.completion.showWord               =
"Show contextual words in suggestions."
config.completion.showWord.Enable        =
"Always show context words in suggestions."
config.completion.showWord.Fallback      =
"Contextual words are only displayed when suggestions based on semantics cannot be provided."
config.completion.showWord.Disable       =
"Do not display context words."
config.completion.autoRequire            =
"When the input looks like a file name, automatically `require` this file."
config.completion.showParams             =
"Display parameters in completion list. When the function has multiple definitions, they will be displayed separately."
config.completion.requireSeparator       =
"The separator used when `require`."
config.completion.postfix                =
"The symbol used to trigger the postfix suggestion."
config.color.mode                        =
"Color mode."
config.color.mode.Semantic               =
"Semantic color. You may need to set `editor.semanticHighlighting.enabled` to `true` to take effect."
config.color.mode.SemanticEnhanced       =
"Enhanced semantic color. Like `Semantic`, but with additional analysis which might be more computationally expensive."
config.color.mode.Grammar                =
"Grammar color."
config.semantic.enable                   =
"Enable semantic color. You may need to set `editor.semanticHighlighting.enabled` to `true` to take effect."
config.semantic.variable                 =
"Semantic coloring of variables/fields/parameters."
config.semantic.annotation               =
"Semantic coloring of type annotations."
config.semantic.keyword                  =
"Semantic coloring of keywords/literals/operators. You only need to enable this feature if your editor cannot do syntax coloring."
config.signatureHelp.enable              =
"Enable signature help."
config.hover.enable                      =
"Enable hover."
config.hover.viewString                  =
"Hover to view the contents of a string (only if the literal contains an escape character)."
config.hover.viewStringMax               =
"The maximum length of a hover to view the contents of a string."
config.hover.viewNumber                  =
"Hover to view numeric content (only if literal is not decimal)."
config.hover.fieldInfer                  =
"When hovering to view a table, type infer will be performed for each field. When the accumulated time of type infer reaches the set value (MS), the type infer of subsequent fields will be skipped."
config.hover.previewFields               =
"When hovering to view a table, limits the maximum number of previews for fields."
config.hover.enumsLimit                  =
"When the value corresponds to multiple types, limit the number of types displaying."
config.hover.expandAlias                 =
[[
Whether to expand the alias. For example, expands `---@alias myType boolean|number` appears as `boolean|number`, otherwise it appears as `myType'.
]]
config.develop.enable                    =
'Developer mode. Do not enable, performance will be affected.'
config.develop.debuggerPort              =
'Listen port of debugger.'
config.develop.debuggerWait              =
'Suspend before debugger connects.'
config.intelliSense.searchDepth          =
'Set the search depth for IntelliSense. Increasing this value increases accuracy, but decreases performance. Different workspace have different tolerance for this setting. Please adjust it to the appropriate value.'
config.intelliSense.fastGlobal           =
'In the global variable completion, and view `_G` suspension prompt. This will slightly reduce the accuracy of type speculation, but it will have a significant performance improvement for projects that use a lot of global variables.'
config.window.statusBar                  =
'Show extension status in status bar.'
config.window.progressBar                =
'Show progress bar in status bar.'
config.hint.enable                       =
'Enable inlay hint.'
config.hint.paramType                    =
'Show type hints at the parameter of the function.'
config.hint.setType                      =
'Show hints of type at assignment operation.'
config.hint.paramName                    =
'Show hints of parameter name at the function call.'
config.hint.paramName.All                =
'All types of parameters are shown.'
config.hint.paramName.Literal            =
'Only literal type parameters are shown.'
config.hint.paramName.Disable            =
'Disable parameter hints.'
config.hint.arrayIndex                   =
'Show hints of array index when constructing a table.'
config.hint.arrayIndex.Enable            =
'Show hints in all tables.'
config.hint.arrayIndex.Auto              =
'Show hints only when the table is greater than 3 items, or the table is a mixed table.'
config.hint.arrayIndex.Disable           =
'Disable hints of array index.'
config.hint.await                        =
'If the called function is marked `---@async`, prompt `await` at the call.'
config.hint.semicolon                    =
'If there is no semicolon at the end of the statement, display a virtual semicolon.'
config.hint.semicolon.All                =
'All statements display virtual semicolons.'
config.hint.semicolon.SameLine            =
'When two statements are on the same line, display a semicolon between them.'
config.hint.semicolon.Disable            =
'Disable virtual semicolons.'
config.codeLens.enable                   =
'Enable code lens.'
config.format.enable                     =
'Enable code formatter.'
config.format.defaultConfig              =
[[
The default format configuration. Has a lower priority than `.editorconfig` file in the workspace.
Read [formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) to learn usage.
]]
config.spell.dict                        =
'Custom words for spell checking.'
config.nameStyle.config                  =
'Set name style config'
config.telemetry.enable                  =
[[
Enable telemetry to send your editor information and error logs over the network. Read our privacy policy [here](https://luals.github.io/privacy/#language-server).
]]
config.misc.parameters                   =
'[Command line parameters](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) when starting the language server in VSCode.'
config.misc.executablePath               =
'Specify the executable path in VSCode.'
config.type.castNumberToInteger          =
'Allowed to assign the `number` type to the `integer` type.'
config.type.weakUnionCheck               =
[[
Once one subtype of a union type meets the condition, the union type also meets the condition.

When this setting is `false`, the `number|boolean` type cannot be assigned to the `number` type. It can be with `true`.
]]
config.type.weakNilCheck                 =
[[
When checking the type of union type, ignore the `nil` in it.

When this setting is `false`, the `number|nil` type cannot be assigned to the `number` type. It can be with `true`.
]]
config.doc.privateName                   =
'Treat specific field names as private, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are private, witch can only be accessed in the class where the definition is located.'
config.doc.protectedName                 =
'Treat specific field names as protected, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are protected, witch can only be accessed in the class where the definition is located and its subclasses.'
config.doc.packageName                   =
'Treat specific field names as package, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are package, witch can only be accessed in the file where the definition is located.'
config.diagnostics['unused-local']          =
'Enable unused local variable diagnostics.'
config.diagnostics['unused-function']       =
'Enable unused function diagnostics.'
config.diagnostics['undefined-global']      =
'Enable undefined global variable diagnostics.'
config.diagnostics['global-in-nil-env']     =
'Enable cannot use global variables （ `_ENV` is set to `nil`） diagnostics.'
config.diagnostics['unused-label']          =
'Enable unused label diagnostics.'
config.diagnostics['unused-vararg']         =
'Enable unused vararg diagnostics.'
config.diagnostics['trailing-space']        =
'Enable trailing space diagnostics.'
config.diagnostics['redefined-local']       =
'Enable redefined local variable diagnostics.'
config.diagnostics['newline-call']          =
'Enable newline call diagnostics. Is\'s raised when a line starting with `(` is encountered, which is syntactically parsed as a function call on the previous line.'
config.diagnostics['newfield-call']         =
'Enable newfield call diagnostics. It is raised when the parenthesis of a function call appear on the following line when defining a field in a table.'
config.diagnostics['redundant-parameter']   =
'Enable redundant function parameter diagnostics.'
config.diagnostics['ambiguity-1']           =
'Enable ambiguous operator precedence diagnostics. For example, the `num or 0 + 1` expression will be suggested `(num or 0) + 1` instead.'
config.diagnostics['lowercase-global']      =
'Enable lowercase global variable definition diagnostics.'
config.diagnostics['undefined-env-child']   =
'Enable undefined environment variable diagnostics. It\'s raised when `_ENV` table is set to a new literal table, but the used global variable is no longer present in the global environment.'
config.diagnostics['duplicate-index']       =
'Enable duplicate table index diagnostics.'
config.diagnostics['empty-block']           =
'Enable empty code block diagnostics.'
config.diagnostics['redundant-value']       =
'Enable the redundant values assigned diagnostics. It\'s raised during assignment operation, when the number of values is higher than the number of objects being assigned.'
config.diagnostics['assign-type-mismatch']  =
'Enable diagnostics for assignments in which the value\'s type does not match the type of the assigned variable.'
config.diagnostics['await-in-sync']         =
'Enable diagnostics for calls of asynchronous functions within a synchronous function.'
config.diagnostics['cast-local-type']    =
'Enable diagnostics for casts of local variables where the target type does not match the defined type.'
config.diagnostics['cast-type-mismatch']    =
'Enable diagnostics for casts where the target type does not match the initial type.'
config.diagnostics['circular-doc-class']    =
'Enable diagnostics for two classes inheriting from each other introducing a circular relation.'
config.diagnostics['close-non-object']      =
'Enable diagnostics for attempts to close a variable with a non-object.'
config.diagnostics['code-after-break']      =
'Enable diagnostics for code placed after a break statement in a loop.'
config.diagnostics['codestyle-check']       =
'Enable diagnostics for incorrectly styled lines.'
config.diagnostics['count-down-loop']       =
'Enable diagnostics for `for` loops which will never reach their max/limit because the loop is incrementing instead of decrementing.'
config.diagnostics['deprecated']            =
'Enable diagnostics to highlight deprecated API.'
config.diagnostics['different-requires']    =
'Enable diagnostics for files which are required by two different paths.'
config.diagnostics['discard-returns']       =
'Enable diagnostics for calls of functions annotated with `---@nodiscard` where the return values are ignored.'
config.diagnostics['doc-field-no-class']    =
'Enable diagnostics to highlight a field annotation without a defining class annotation.'
config.diagnostics['duplicate-doc-alias']   =
'Enable diagnostics for a duplicated alias annotation name.'
config.diagnostics['duplicate-doc-field']   =
'Enable diagnostics for a duplicated field annotation name.'
config.diagnostics['duplicate-doc-param']   =
'Enable diagnostics for a duplicated param annotation name.'
config.diagnostics['duplicate-set-field']   =
'Enable diagnostics for setting the same field in a class more than once.'
config.diagnostics['incomplete-signature-doc']    =
'Incomplete @param or @return annotations for functions.'
config.diagnostics['invisible']             =
'Enable diagnostics for accesses to fields which are invisible.'
config.diagnostics['missing-global-doc']    =
'Missing annotations for globals! Global functions must have a comment and annotations for all parameters and return values.'
config.diagnostics['missing-local-export-doc'] =
'Missing annotations for exported locals! Exported local functions must have a comment and annotations for all parameters and return values.'
config.diagnostics['missing-parameter']     =
'Enable diagnostics for function calls where the number of arguments is less than the number of annotated function parameters.'
config.diagnostics['missing-return']        =
'Enable diagnostics for functions with return annotations which have no return statement.'
config.diagnostics['missing-return-value']  =
'Enable diagnostics for return statements without values although the containing function declares returns.'
config.diagnostics['need-check-nil']        =
'Enable diagnostics for variable usages if `nil` or an optional (potentially `nil`) value was assigned to the variable before.'
config.diagnostics['no-unknown']            =
'Enable diagnostics for cases in which the type cannot be inferred.'
config.diagnostics['not-yieldable']         =
'Enable diagnostics for calls to `coroutine.yield()` when it is not permitted.'
config.diagnostics['param-type-mismatch']   =
'Enable diagnostics for function calls where the type of a provided parameter does not match the type of the annotated function definition.'
config.diagnostics['redundant-return']      =
'Enable diagnostics for return statements which are not needed because the function would exit on its own.'
config.diagnostics['redundant-return-value']=
'Enable diagnostics for return statements which return an extra value which is not specified by a return annotation.'
config.diagnostics['return-type-mismatch']  =
'Enable diagnostics for return values whose type does not match the type declared in the corresponding return annotation.'
config.diagnostics['spell-check']           =
'Enable diagnostics for typos in strings.'
config.diagnostics['name-style-check']      =
'Enable diagnostics for name style.'
config.diagnostics['unbalanced-assignments']=
'Enable diagnostics on multiple assignments if not all variables obtain a value (e.g., `local x,y = 1`).'
config.diagnostics['undefined-doc-class']   =
'Enable diagnostics for class annotations in which an undefined class is referenced.'
config.diagnostics['undefined-doc-name']    =
'Enable diagnostics for type annotations referencing an undefined type or alias.'
config.diagnostics['undefined-doc-param']   =
'Enable diagnostics for cases in which a parameter annotation is given without declaring the parameter in the function definition.'
config.diagnostics['undefined-field']       =
'Enable diagnostics for cases in which an undefined field of a variable is read.'
config.diagnostics['unknown-cast-variable'] =
'Enable diagnostics for casts of undefined variables.'
config.diagnostics['unknown-diag-code']     =
'Enable diagnostics in cases in which an unknown diagnostics code is entered.'
config.diagnostics['unknown-operator']      =
'Enable diagnostics for unknown operators.'
config.diagnostics['unreachable-code']      =
'Enable diagnostics for unreachable code.'
config.diagnostics['global-element']       =
'Enable diagnostics to warn about global elements.'
config.typeFormat.config                    =
'Configures the formatting behavior while typing Lua code.'
config.typeFormat.config.auto_complete_end  =
'Controls if `end` is automatically completed at suitable positions.'
config.typeFormat.config.auto_complete_table_sep =
'Controls if a separator is automatically appended at the end of a table declaration.'
config.typeFormat.config.format_line        =
'Controls if a line is formatted at all.'

command.exportDocument =
'Lua: Export Document ...'
command.addon_manager.open =
'Lua: Open Addon Manager ...'
command.reloadFFIMeta =
'Lua: Reload luajit ffi meta'
