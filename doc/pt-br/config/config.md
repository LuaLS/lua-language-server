# completion.autoRequire

When the input looks like a file name, automatically `require` this file.

## default
`true`

# completion.callSnippet

Shows function call snippets.

## default
`"Disable"`
## enum
* `"Disable"`: Only shows `function name`.
* `"Both"`: Shows `function name` and `call snippet`.
* `"Replace"`: Only shows `call snippet.`

# completion.displayContext

Previewing the relevant code snippet of the suggestion may help you understand the usage of the suggestion. The number set indicates the number of intercepted lines in the code fragment. If it is set to `0`, this feature can be disabled.

## default
`0`

# completion.enable

Enable completion.

## default
`true`

# completion.keywordSnippet

Shows keyword syntax snippets.

## default
`"Replace"`
## enum
* `"Disable"`: Only shows `keyword`.
* `"Both"`: Shows `keyword` and `syntax snippet`.
* `"Replace"`: Only shows `syntax snippet`.

# completion.postfix

The symbol used to trigger the postfix suggestion.

## default
`"@"`

# completion.requireSeparator

The separator used when `require`.

## default
`"."`

# completion.showParams

Display parameters in completion list. When the function has multiple definitions, they will be displayed separately.

## default
`true`

# completion.showWord

Show contextual words in suggestions.

## default
`"Fallback"`
## enum
* `"Enable"`: Always show context words in suggestions.
* `"Fallback"`: Contextual words are only displayed when suggestions based on semantics cannot be provided.
* `"Disable"`: Do not display context words.

# completion.workspaceWord

Whether the displayed context word contains the content of other files in the workspace.

## default
`true`

# diagnostics.disable

Disabled diagnostic (Use code in hover brackets).

## default
`{}`

# diagnostics.disableScheme

Do not diagnose Lua files that use the following scheme.

## default
`{ "git" }`

# diagnostics.enable

Enable diagnostics.

## default
`true`

# diagnostics.globals

Defined global variables.

## default
`{}`

# diagnostics.ignoredFiles

How to diagnose ignored files.

## default
`"Opened"`
## enum
* `"Enable"`: Always diagnose these files.
* `"Opened"`: Only when these files are opened will it be diagnosed.
* `"Disable"`: These files are not diagnosed.

# diagnostics.libraryFiles

How to diagnose files loaded via `Lua.workspace.library`.

## default
`"Opened"`
## enum
* `"Enable"`: Always diagnose these files.
* `"Opened"`: Only when these files are opened will it be diagnosed.
* `"Disable"`: These files are not diagnosed.

# diagnostics.neededFileStatus

* Opened:  only diagnose opened files
* Any:     diagnose all files
* Disable: disable this diagnostic



# diagnostics.severity

Modified diagnostic severity.


# diagnostics.workspaceDelay

Latency (milliseconds) for workspace diagnostics. When you start the workspace, or edit any file, the entire workspace will be re-diagnosed in the background. Set to negative to disable workspace diagnostics.

## default
`3000`

# diagnostics.workspaceRate

Workspace diagnostics run rate (%). Decreasing this value reduces CPU usage, but also reduces the speed of workspace diagnostics. The diagnosis of the file you are currently editing is always done at full speed and is not affected by this setting.

## default
`100`

# format.defaultConfig

**Missing description!!**
## default
`{}`

# format.enable

Enable code formatter.

## default
`true`

# hint.arrayIndex

Show hints of array index when constructing a table.

## default
`"Auto"`
## enum
* `"Enable"`: Show hints in all tables.
* `"Auto"`: Show hints only when the table is greater than 3 items, or the table is a mixed table.
* `"Disable"`: Disable hints of array index.

# hint.await

**Missing description!!**
## default
`true`

# hint.enable

Enable inlay hint.


# hint.paramName

Show hints of parameter name at the function call.

## default
`"All"`
## enum
* `"All"`: All types of parameters are shown.
* `"Literal"`: Only literal type parameters are shown.
* `"Disable"`: Disable parameter hints.

# hint.paramType

Show type hints at the parameter of the function.

## default
`true`

# hint.setType

Show hints of type at assignment operation.


# hover.enable

Enable hover.

## default
`true`

# hover.enumsLimit

When the value corresponds to multiple types, limit the number of types displaying.

## default
`5`

# hover.expandAlias

**Missing description!!**
## default
`true`

# hover.previewFields

When hovering to view a table, limits the maximum number of previews for fields.

## default
`20`

# hover.viewNumber

Hover to view numeric content (only if literal is not decimal).

## default
`true`

# hover.viewString

Hover to view the contents of a string (only if the literal contains an escape character).

## default
`true`

# hover.viewStringMax

The maximum length of a hover to view the contents of a string.

## default
`1000`

# misc.parameters

[Command line parameters](https://github.com/sumneko/lua-telemetry-server/tree/master/method) when starting the language service in VSCode.

## default
`{}`

# runtime.builtin

Adjust the enabled state of the built-in library. You can disable (or redefine) the non-existent library according to the actual runtime environment.

* `default`: Indicates that the library will be enabled or disabled according to the runtime version
* `enable`: always enable
* `disable`: always disable



# runtime.fileEncoding

File encoding. The `ansi` option is only available under the `Windows` platform.

## default
`"utf8"`
## enum
* `"utf8"`
* `"ansi"`
* `"utf16le"`
* `"utf16be"`

# runtime.meta

**Missing description!!**
## default
`"${version} ${language} ${encoding}"`

# runtime.nonstandardSymbol

Supports non-standard symbols. Make sure that your runtime environment supports these symbols.

## default
`{}`

# runtime.path

When using `require`, how to find the file based on the input name.
Setting this config to `?/init.lua` means that when you enter `require 'myfile'`, `${workspace}/myfile/init.lua` will be searched from the loaded files.
if `runtime.pathStrict` is `false`, `${workspace}/**/myfile/init.lua` will also be searched.
If you want to load files outside the workspace, you need to set `Lua.workspace.library` first.


## default
`{ "?.lua", "?/init.lua" }`

# runtime.pathStrict

When enabled, `runtime.path` will only search the first level of directories, see the description of `runtime.path`.


# runtime.plugin

Plugin path. Please read [wiki](https://github.com/sumneko/lua-language-server/wiki/Plugin) to learn more.

## default
`""`

# runtime.special

The custom global variables are regarded as some special built-in variables, and the language server will provide special support
The following example shows that 'include' is treated as' require '.
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```


## default
`{}`

# runtime.unicodeName

Allows Unicode characters in name.


# runtime.version

Lua runtime version.

## default
`"Lua 5.4"`
## enum
* `"Lua 5.1"`
* `"Lua 5.2"`
* `"Lua 5.3"`
* `"Lua 5.4"`
* `"LuaJIT"`

# semantic.annotation

Semantic coloring of type annotations.

## default
`true`

# semantic.enable

Enable semantic color. You may need to set `editor.semanticHighlighting.enabled` to `true` to take effect.

## default
`true`

# semantic.keyword

Semantic coloring of keywords/literals/operators. You only need to enable this feature if your editor cannot do syntax coloring.


# semantic.variable

Semantic coloring of variables/fields/parameters.

## default
`true`

# signatureHelp.enable

Enable signature help.

## default
`true`

# spell.dict

**Missing description!!**
## default
`{}`

# telemetry.enable

Enable telemetry to send your editor information and error logs over the network. Read our privacy policy [here](https://github.com/sumneko/lua-language-server/wiki/Privacy-Policy).


## default
`nil`

# window.progressBar

Show progress bar in status bar.

## default
`true`

# window.statusBar

Show extension status in status bar.

## default
`true`

# workspace.checkThirdParty

Automatic detection and adaptation of third-party libraries, currently supported libraries are:

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass


## default
`true`

# workspace.ignoreDir

Ignored files and directories (Use `.gitignore` grammar).

## default
`{ ".vscode" }`

# workspace.ignoreSubmodules

Ignore submodules.

## default
`true`

# workspace.library

In addition to the current workspace, which directories will load files from. The files in these directories will be treated as externally provided code libraries, and some features (such as renaming fields) will not modify these files.

## default
`{}`

# workspace.maxPreload

Max preloaded files.

## default
`5000`

# workspace.preloadFileSize

Skip files larger than this value (KB) when preloading.

## default
`500`

# workspace.supportScheme

Provide language server for the Lua files of the following scheme.

## default
`{ "file", "untitled", "git" }`

# workspace.useGitIgnore

Ignore files list in `.gitignore` .

## default
`true`

# workspace.userThirdParty

Add private third-party library configuration file paths here, please refer to the built-in [configuration file path](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)

## default
`{}`