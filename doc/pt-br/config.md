# completion.autoRequire

When the input looks like a file name, automatically `require` this file.

## type

```ts
boolean
```

## default

```json
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

```json
"Disable"
```

# completion.displayContext

Previewing the relevant code snippet of the suggestion may help you understand the usage of the suggestion. The number set indicates the number of intercepted lines in the code fragment. If it is set to `0`, this feature can be disabled.

## type

```ts
integer
```

## default

```json
0
```

# completion.enable

Enable completion.

## type

```ts
boolean
```

## default

```json
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

```json
"Replace"
```

# completion.postfix

The symbol used to trigger the postfix suggestion.

## type

```ts
string
```

## default

```json
"@"
```

# completion.requireSeparator

The separator used when `require`.

## type

```ts
string
```

## default

```json
"."
```

# completion.showParams

Display parameters in completion list. When the function has multiple definitions, they will be displayed separately.

## type

```ts
boolean
```

## default

```json
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

```json
"Fallback"
```

# completion.workspaceWord

Whether the displayed context word contains the content of other files in the workspace.

## type

```ts
boolean
```

## default

```json
true
```

# diagnostics.disable

Disabled diagnostic (Use code in hover brackets).

## type

```ts
Array<string>
```

## default

```json
[]
```

# diagnostics.disableScheme

Do not diagnose Lua files that use the following scheme.

## type

```ts
Array<string>
```

## default

```json
["git"]
```

# diagnostics.enable

Enable diagnostics.

## type

```ts
boolean
```

## default

```json
true
```

# diagnostics.globals

Defined global variables.

## type

```ts
Array<string>
```

## default

```json
[]
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

```json
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

```json
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  only diagnose opened files
* Any:     diagnose all files
* Disable: disable this diagnostic


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

Modified diagnostic severity.

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

Latency (milliseconds) for workspace diagnostics. When you start the workspace, or edit any file, the entire workspace will be re-diagnosed in the background. Set to negative to disable workspace diagnostics.

## type

```ts
integer
```

## default

```json
3000
```

# diagnostics.workspaceRate

Workspace diagnostics run rate (%). Decreasing this value reduces CPU usage, but also reduces the speed of workspace diagnostics. The diagnosis of the file you are currently editing is always done at full speed and is not affected by this setting.

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

Enable code formatter.

## type

```ts
boolean
```

## default

```json
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

Enable inlay hint.

## type

```ts
boolean
```

## default

```json
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

```json
"All"
```

# hint.paramType

Show type hints at the parameter of the function.

## type

```ts
boolean
```

## default

```json
true
```

# hint.setType

Show hints of type at assignment operation.

## type

```ts
boolean
```

## default

```json
false
```

# hover.enable

Enable hover.

## type

```ts
boolean
```

## default

```json
true
```

# hover.enumsLimit

When the value corresponds to multiple types, limit the number of types displaying.

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

When hovering to view a table, limits the maximum number of previews for fields.

## type

```ts
integer
```

## default

```json
20
```

# hover.viewNumber

Hover to view numeric content (only if literal is not decimal).

## type

```ts
boolean
```

## default

```json
true
```

# hover.viewString

Hover to view the contents of a string (only if the literal contains an escape character).

## type

```ts
boolean
```

## default

```json
true
```

# hover.viewStringMax

The maximum length of a hover to view the contents of a string.

## type

```ts
integer
```

## default

```json
1000
```

# misc.parameters

[Command line parameters](https://github.com/sumneko/lua-telemetry-server/tree/master/method) when starting the language service in VSCode.

## type

```ts
Array<string>
```

## default

```json
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

When using `require`, how to find the file based on the input name.
Setting this config to `?/init.lua` means that when you enter `require 'myfile'`, `${workspace}/myfile/init.lua` will be searched from the loaded files.
if `runtime.pathStrict` is `false`, `${workspace}/**/myfile/init.lua` will also be searched.
If you want to load files outside the workspace, you need to set `Lua.workspace.library` first.


## type

```ts
Array<string>
```

## default

```json
["?.lua","?/init.lua"]
```

# runtime.pathStrict

When enabled, `runtime.path` will only search the first level of directories, see the description of `runtime.path`.

## type

```ts
boolean
```

## default

```json
false
```

# runtime.plugin

Plugin path. Please read [wiki](https://github.com/sumneko/lua-language-server/wiki/Plugin) to learn more.

## type

```ts
string
```

## default

```json
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

```json
{}
```

# runtime.unicodeName

Allows Unicode characters in name.

## type

```ts
boolean
```

## default

```json
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

```json
"Lua 5.4"
```

# semantic.annotation

Semantic coloring of type annotations.

## type

```ts
boolean
```

## default

```json
true
```

# semantic.enable

Enable semantic color. You may need to set `editor.semanticHighlighting.enabled` to `true` to take effect.

## type

```ts
boolean
```

## default

```json
true
```

# semantic.keyword

Semantic coloring of keywords/literals/operators. You only need to enable this feature if your editor cannot do syntax coloring.

## type

```ts
boolean
```

## default

```json
false
```

# semantic.variable

Semantic coloring of variables/fields/parameters.

## type

```ts
boolean
```

## default

```json
true
```

# signatureHelp.enable

Enable signature help.

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

Enable telemetry to send your editor information and error logs over the network. Read our privacy policy [here](https://github.com/sumneko/lua-language-server/wiki/Privacy-Policy).


## type

```ts
boolean | null
```

## default

```json
null
```

# window.progressBar

Show progress bar in status bar.

## type

```ts
boolean
```

## default

```json
true
```

# window.statusBar

Show extension status in status bar.

## type

```ts
boolean
```

## default

```json
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

```json
true
```

# workspace.ignoreDir

Ignored files and directories (Use `.gitignore` grammar).

## type

```ts
Array<string>
```

## default

```json
[".vscode"]
```

# workspace.ignoreSubmodules

Ignore submodules.

## type

```ts
boolean
```

## default

```json
true
```

# workspace.library

In addition to the current workspace, which directories will load files from. The files in these directories will be treated as externally provided code libraries, and some features (such as renaming fields) will not modify these files.

## type

```ts
Array<string>
```

## default

```json
[]
```

# workspace.maxPreload

Max preloaded files.

## type

```ts
integer
```

## default

```json
5000
```

# workspace.preloadFileSize

Skip files larger than this value (KB) when preloading.

## type

```ts
integer
```

## default

```json
500
```

# workspace.supportScheme

Provide language server for the Lua files of the following scheme.

## type

```ts
Array<string>
```

## default

```json
["file","untitled","git"]
```

# workspace.useGitIgnore

Ignore files list in `.gitignore` .

## type

```ts
boolean
```

## default

```json
true
```

# workspace.userThirdParty

Add private third-party library configuration file paths here, please refer to the built-in [configuration file path](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)

## type

```ts
Array<string>
```

## default

```json
[]
```