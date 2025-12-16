# addonManager.enable

Whether the addon manager is enabled or not.

## type

```ts
boolean
```

## default

```jsonc
true
```

# addonRepositoryPath

Specifies the addon repository path (not related to the addon manager).

## type

```ts
string
```

# codeLens.enable

Enable code lens.

## type

```ts
boolean
```

## default

```jsonc
false
```

# completion.autoRequire

When the input looks like a file name, automatically `require` this file.

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"Disable"
```

# completion.displayContext

Previewing the relevant code snippet of the suggestion may help you understand the usage of the suggestion. The number set indicates the number of intercepted lines in the code fragment. If it is set to `0`, this feature can be disabled.

## type

```ts
integer
```

## default

```jsonc
0
```

# completion.enable

Enable completion.

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"Replace"
```

# completion.postfix

The symbol used to trigger the postfix suggestion.

## type

```ts
string
```

## default

```jsonc
"@"
```

# completion.requireSeparator

The separator used when `require`.

## type

```ts
string
```

## default

```jsonc
"."
```

# completion.showParams

Display parameters in completion list. When the function has multiple definitions, they will be displayed separately.

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"Fallback"
```

# completion.workspaceWord

Whether the displayed context word contains the content of other files in the workspace.

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.disable

Disabled diagnostic (Use code in hover brackets).

## type

```ts
Array<string>
```

## enum

* ``"action-after-return"``
* ``"ambiguity-1"``
* ``"ambiguous-syntax"``
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
* ``"global-element"``
* ``"global-in-nil-env"``
* ``"incomplete-signature-doc"``
* ``"index-in-func-name"``
* ``"inject-field"``
* ``"invisible"``
* ``"jump-local-scope"``
* ``"keyword"``
* ``"local-limit"``
* ``"lowercase-global"``
* ``"lua-doc-miss-sign"``
* ``"luadoc-error-diag-mode"``
* ``"luadoc-miss-alias-extends"``
* ``"luadoc-miss-alias-name"``
* ``"luadoc-miss-arg-name"``
* ``"luadoc-miss-cate-name"``
* ``"luadoc-miss-class-extends-name"``
* ``"luadoc-miss-class-name"``
* ``"luadoc-miss-diag-mode"``
* ``"luadoc-miss-diag-name"``
* ``"luadoc-miss-field-extends"``
* ``"luadoc-miss-field-name"``
* ``"luadoc-miss-fun-after-overload"``
* ``"luadoc-miss-generic-name"``
* ``"luadoc-miss-local-name"``
* ``"luadoc-miss-module-name"``
* ``"luadoc-miss-operator-name"``
* ``"luadoc-miss-param-extends"``
* ``"luadoc-miss-param-name"``
* ``"luadoc-miss-see-name"``
* ``"luadoc-miss-sign-name"``
* ``"luadoc-miss-symbol"``
* ``"luadoc-miss-type-name"``
* ``"luadoc-miss-vararg-type"``
* ``"luadoc-miss-version"``
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
* ``"missing-fields"``
* ``"missing-global-doc"``
* ``"missing-local-doc"``
* ``"missing-local-export-doc"``
* ``"missing-parameter"``
* ``"missing-return"``
* ``"missing-return-value"``
* ``"name-style-check"``
* ``"need-check-nil"``
* ``"need-paren"``
* ``"nesting-long-mark"``
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

Do not diagnose Lua files that use the following scheme.

## type

```ts
Array<string>
```

## default

```jsonc
["git"]
```

# diagnostics.enable

Enable diagnostics.

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.globals

Defined global variables.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.globalsRegex

Find defined global variables using regex.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.groupFileStatus

Modify the diagnostic needed file status in a group.

* Opened:  only diagnose opened files
* Any:     diagnose all files
* None:    disable this diagnostic

`Fallback` means that diagnostics in this group are controlled by `diagnostics.neededFileStatus` separately.
Other settings will override individual settings without end of `!`.


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
    * name-style-check
    * spell-check
    */
    "codestyle": "Fallback",
    /*
    * global-element
    */
    "conventions": "Fallback",
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
    * circle-doc-class
    * doc-field-no-class
    * duplicate-doc-alias
    * duplicate-doc-field
    * duplicate-doc-param
    * incomplete-signature-doc
    * missing-global-doc
    * missing-local-doc
    * missing-local-export-doc
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
    * invisible
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
    * inject-field
    * need-check-nil
    * param-type-mismatch
    * return-type-mismatch
    * undefined-field
    */
    "type-check": "Fallback",
    /*
    * missing-fields
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

Modify the diagnostic severity in a group.
`Fallback` means that diagnostics in this group are controlled by `diagnostics.severity` separately.
Other settings will override individual settings without end of `!`.


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
    * name-style-check
    * spell-check
    */
    "codestyle": "Fallback",
    /*
    * global-element
    */
    "conventions": "Fallback",
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
    * circle-doc-class
    * doc-field-no-class
    * duplicate-doc-alias
    * duplicate-doc-field
    * duplicate-doc-param
    * incomplete-signature-doc
    * missing-global-doc
    * missing-local-doc
    * missing-local-export-doc
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
    * invisible
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
    * inject-field
    * need-check-nil
    * param-type-mismatch
    * return-type-mismatch
    * undefined-field
    */
    "type-check": "Fallback",
    /*
    * missing-fields
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

```jsonc
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

```jsonc
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  only diagnose opened files
* Any:     diagnose all files
* None:    disable this diagnostic

End with `!` means override the group setting `diagnostics.groupFileStatus`.


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
    Enable ambiguous operator precedence diagnostics. For example, the `num or 0 + 1` expression will be suggested `(num or 0) + 1` instead.
    */
    "ambiguity-1": "Any",
    /*
    Enable diagnostics for assignments in which the value's type does not match the type of the assigned variable.
    */
    "assign-type-mismatch": "Opened",
    /*
    Enable diagnostics for calls of asynchronous functions within a synchronous function.
    */
    "await-in-sync": "None",
    /*
    Enable diagnostics for casts of local variables where the target type does not match the defined type.
    */
    "cast-local-type": "Opened",
    /*
    Enable diagnostics for casts where the target type does not match the initial type.
    */
    "cast-type-mismatch": "Opened",
    "circle-doc-class": "Any",
    /*
    Enable diagnostics for attempts to close a variable with a non-object.
    */
    "close-non-object": "Any",
    /*
    Enable diagnostics for code placed after a break statement in a loop.
    */
    "code-after-break": "Opened",
    /*
    Enable diagnostics for incorrectly styled lines.
    */
    "codestyle-check": "None",
    /*
    Enable diagnostics for `for` loops which will never reach their max/limit because the loop is incrementing instead of decrementing.
    */
    "count-down-loop": "Any",
    /*
    Enable diagnostics to highlight deprecated API.
    */
    "deprecated": "Any",
    /*
    Enable diagnostics for files which are required by two different paths.
    */
    "different-requires": "Any",
    /*
    Enable diagnostics for calls of functions annotated with `---@nodiscard` where the return values are ignored.
    */
    "discard-returns": "Any",
    /*
    Enable diagnostics to highlight a field annotation without a defining class annotation.
    */
    "doc-field-no-class": "Any",
    /*
    Enable diagnostics for a duplicated alias annotation name.
    */
    "duplicate-doc-alias": "Any",
    /*
    Enable diagnostics for a duplicated field annotation name.
    */
    "duplicate-doc-field": "Any",
    /*
    Enable diagnostics for a duplicated param annotation name.
    */
    "duplicate-doc-param": "Any",
    /*
    Enable duplicate table index diagnostics.
    */
    "duplicate-index": "Any",
    /*
    Enable diagnostics for setting the same field in a class more than once.
    */
    "duplicate-set-field": "Opened",
    /*
    Enable empty code block diagnostics.
    */
    "empty-block": "Opened",
    /*
    Enable diagnostics to warn about global elements.
    */
    "global-element": "None",
    /*
    Enable cannot use global variables （ `_ENV` is set to `nil`） diagnostics.
    */
    "global-in-nil-env": "Any",
    /*
    Incomplete @param or @return annotations for functions.
    */
    "incomplete-signature-doc": "None",
    "inject-field": "Opened",
    /*
    Enable diagnostics for accesses to fields which are invisible.
    */
    "invisible": "Any",
    /*
    Enable lowercase global variable definition diagnostics.
    */
    "lowercase-global": "Any",
    "missing-fields": "Any",
    /*
    Missing annotations for globals! Global functions must have a comment and annotations for all parameters and return values.
    */
    "missing-global-doc": "None",
    /*
    Missing annotations for locals! Local functions must have a comment and annotations for all parameters and return values.
    */
    "missing-local-export-doc": "None",
    /*
    Missing annotations for exported locals! Exported local functions must have a comment and annotations for all parameters and return values.
    */
    "missing-local-export-doc": "None",
    /*
    Enable diagnostics for function calls where the number of arguments is less than the number of annotated function parameters.
    */
    "missing-parameter": "Any",
    /*
    Enable diagnostics for functions with return annotations which have no return statement.
    */
    "missing-return": "Any",
    /*
    Enable diagnostics for return statements without values although the containing function declares returns.
    */
    "missing-return-value": "Any",
    /*
    Enable diagnostics for name style.
    */
    "name-style-check": "None",
    /*
    Enable diagnostics for variable usages if `nil` or an optional (potentially `nil`) value was assigned to the variable before.
    */
    "need-check-nil": "Opened",
    /*
    Enable newfield call diagnostics. It is raised when the parenthesis of a function call appear on the following line when defining a field in a table.
    */
    "newfield-call": "Any",
    /*
    Enable newline call diagnostics. Is's raised when a line starting with `(` is encountered, which is syntactically parsed as a function call on the previous line.
    */
    "newline-call": "Any",
    /*
    Enable diagnostics for cases in which the type cannot be inferred.
    */
    "no-unknown": "None",
    /*
    Enable diagnostics for calls to `coroutine.yield()` when it is not permitted.
    */
    "not-yieldable": "None",
    /*
    Enable diagnostics for function calls where the type of a provided parameter does not match the type of the annotated function definition.
    */
    "param-type-mismatch": "Opened",
    /*
    Enable redefined local variable diagnostics.
    */
    "redefined-local": "Opened",
    /*
    Enable redundant function parameter diagnostics.
    */
    "redundant-parameter": "Any",
    /*
    Enable diagnostics for return statements which are not needed because the function would exit on its own.
    */
    "redundant-return": "Opened",
    /*
    Enable diagnostics for return statements which return an extra value which is not specified by a return annotation.
    */
    "redundant-return-value": "Any",
    /*
    Enable the redundant values assigned diagnostics. It's raised during assignment operation, when the number of values is higher than the number of objects being assigned.
    */
    "redundant-value": "Any",
    /*
    Enable diagnostics for return values whose type does not match the type declared in the corresponding return annotation.
    */
    "return-type-mismatch": "Opened",
    /*
    Enable diagnostics for typos in strings.
    */
    "spell-check": "None",
    /*
    Enable trailing space diagnostics.
    */
    "trailing-space": "Opened",
    /*
    Enable diagnostics on multiple assignments if not all variables obtain a value (e.g., `local x,y = 1`).
    */
    "unbalanced-assignments": "Any",
    /*
    Enable diagnostics for class annotations in which an undefined class is referenced.
    */
    "undefined-doc-class": "Any",
    /*
    Enable diagnostics for type annotations referencing an undefined type or alias.
    */
    "undefined-doc-name": "Any",
    /*
    Enable diagnostics for cases in which a parameter annotation is given without declaring the parameter in the function definition.
    */
    "undefined-doc-param": "Any",
    /*
    Enable undefined environment variable diagnostics. It's raised when `_ENV` table is set to a new literal table, but the used global variable is no longer present in the global environment.
    */
    "undefined-env-child": "Any",
    /*
    Enable diagnostics for cases in which an undefined field of a variable is read.
    */
    "undefined-field": "Opened",
    /*
    Enable undefined global variable diagnostics.
    */
    "undefined-global": "Any",
    /*
    Enable diagnostics for casts of undefined variables.
    */
    "unknown-cast-variable": "Any",
    /*
    Enable diagnostics in cases in which an unknown diagnostics code is entered.
    */
    "unknown-diag-code": "Any",
    /*
    Enable diagnostics for unknown operators.
    */
    "unknown-operator": "Any",
    /*
    Enable diagnostics for unreachable code.
    */
    "unreachable-code": "Opened",
    /*
    Enable unused function diagnostics.
    */
    "unused-function": "Opened",
    /*
    Enable unused label diagnostics.
    */
    "unused-label": "Opened",
    /*
    Enable unused local variable diagnostics.
    */
    "unused-local": "Opened",
    /*
    Enable unused vararg diagnostics.
    */
    "unused-vararg": "Opened"
}
```

# diagnostics.severity

Modify the diagnostic severity.

End with `!` means override the group setting `diagnostics.groupSeverity`.


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
    Enable ambiguous operator precedence diagnostics. For example, the `num or 0 + 1` expression will be suggested `(num or 0) + 1` instead.
    */
    "ambiguity-1": "Warning",
    /*
    Enable diagnostics for assignments in which the value's type does not match the type of the assigned variable.
    */
    "assign-type-mismatch": "Warning",
    /*
    Enable diagnostics for calls of asynchronous functions within a synchronous function.
    */
    "await-in-sync": "Warning",
    /*
    Enable diagnostics for casts of local variables where the target type does not match the defined type.
    */
    "cast-local-type": "Warning",
    /*
    Enable diagnostics for casts where the target type does not match the initial type.
    */
    "cast-type-mismatch": "Warning",
    "circle-doc-class": "Warning",
    /*
    Enable diagnostics for attempts to close a variable with a non-object.
    */
    "close-non-object": "Warning",
    /*
    Enable diagnostics for code placed after a break statement in a loop.
    */
    "code-after-break": "Hint",
    /*
    Enable diagnostics for incorrectly styled lines.
    */
    "codestyle-check": "Warning",
    /*
    Enable diagnostics for `for` loops which will never reach their max/limit because the loop is incrementing instead of decrementing.
    */
    "count-down-loop": "Warning",
    /*
    Enable diagnostics to highlight deprecated API.
    */
    "deprecated": "Warning",
    /*
    Enable diagnostics for files which are required by two different paths.
    */
    "different-requires": "Warning",
    /*
    Enable diagnostics for calls of functions annotated with `---@nodiscard` where the return values are ignored.
    */
    "discard-returns": "Warning",
    /*
    Enable diagnostics to highlight a field annotation without a defining class annotation.
    */
    "doc-field-no-class": "Warning",
    /*
    Enable diagnostics for a duplicated alias annotation name.
    */
    "duplicate-doc-alias": "Warning",
    /*
    Enable diagnostics for a duplicated field annotation name.
    */
    "duplicate-doc-field": "Warning",
    /*
    Enable diagnostics for a duplicated param annotation name.
    */
    "duplicate-doc-param": "Warning",
    /*
    Enable duplicate table index diagnostics.
    */
    "duplicate-index": "Warning",
    /*
    Enable diagnostics for setting the same field in a class more than once.
    */
    "duplicate-set-field": "Warning",
    /*
    Enable empty code block diagnostics.
    */
    "empty-block": "Hint",
    /*
    Enable diagnostics to warn about global elements.
    */
    "global-element": "Warning",
    /*
    Enable cannot use global variables （ `_ENV` is set to `nil`） diagnostics.
    */
    "global-in-nil-env": "Warning",
    /*
    Incomplete @param or @return annotations for functions.
    */
    "incomplete-signature-doc": "Warning",
    "inject-field": "Warning",
    /*
    Enable diagnostics for accesses to fields which are invisible.
    */
    "invisible": "Warning",
    /*
    Enable lowercase global variable definition diagnostics.
    */
    "lowercase-global": "Information",
    "missing-fields": "Warning",
    /*
    Missing annotations for globals! Global functions must have a comment and annotations for all parameters and return values.
    */
    "missing-global-doc": "Warning",
    /*
    Missing annotations for exported locals! Exported local functions must have a comment and annotations for all parameters and return values.
    */
    "missing-local-export-doc": "Warning",
    /*
    Enable diagnostics for function calls where the number of arguments is less than the number of annotated function parameters.
    */
    "missing-parameter": "Warning",
    /*
    Enable diagnostics for functions with return annotations which have no return statement.
    */
    "missing-return": "Warning",
    /*
    Enable diagnostics for return statements without values although the containing function declares returns.
    */
    "missing-return-value": "Warning",
    /*
    Enable diagnostics for name style.
    */
    "name-style-check": "Warning",
    /*
    Enable diagnostics for variable usages if `nil` or an optional (potentially `nil`) value was assigned to the variable before.
    */
    "need-check-nil": "Warning",
    /*
    Enable newfield call diagnostics. It is raised when the parenthesis of a function call appear on the following line when defining a field in a table.
    */
    "newfield-call": "Warning",
    /*
    Enable newline call diagnostics. Is's raised when a line starting with `(` is encountered, which is syntactically parsed as a function call on the previous line.
    */
    "newline-call": "Warning",
    /*
    Enable diagnostics for cases in which the type cannot be inferred.
    */
    "no-unknown": "Warning",
    /*
    Enable diagnostics for calls to `coroutine.yield()` when it is not permitted.
    */
    "not-yieldable": "Warning",
    /*
    Enable diagnostics for function calls where the type of a provided parameter does not match the type of the annotated function definition.
    */
    "param-type-mismatch": "Warning",
    /*
    Enable redefined local variable diagnostics.
    */
    "redefined-local": "Hint",
    /*
    Enable redundant function parameter diagnostics.
    */
    "redundant-parameter": "Warning",
    /*
    Enable diagnostics for return statements which are not needed because the function would exit on its own.
    */
    "redundant-return": "Hint",
    /*
    Enable diagnostics for return statements which return an extra value which is not specified by a return annotation.
    */
    "redundant-return-value": "Warning",
    /*
    Enable the redundant values assigned diagnostics. It's raised during assignment operation, when the number of values is higher than the number of objects being assigned.
    */
    "redundant-value": "Warning",
    /*
    Enable diagnostics for return values whose type does not match the type declared in the corresponding return annotation.
    */
    "return-type-mismatch": "Warning",
    /*
    Enable diagnostics for typos in strings.
    */
    "spell-check": "Information",
    /*
    Enable trailing space diagnostics.
    */
    "trailing-space": "Hint",
    /*
    Enable diagnostics on multiple assignments if not all variables obtain a value (e.g., `local x,y = 1`).
    */
    "unbalanced-assignments": "Warning",
    /*
    Enable diagnostics for class annotations in which an undefined class is referenced.
    */
    "undefined-doc-class": "Warning",
    /*
    Enable diagnostics for type annotations referencing an undefined type or alias.
    */
    "undefined-doc-name": "Warning",
    /*
    Enable diagnostics for cases in which a parameter annotation is given without declaring the parameter in the function definition.
    */
    "undefined-doc-param": "Warning",
    /*
    Enable undefined environment variable diagnostics. It's raised when `_ENV` table is set to a new literal table, but the used global variable is no longer present in the global environment.
    */
    "undefined-env-child": "Information",
    /*
    Enable diagnostics for cases in which an undefined field of a variable is read.
    */
    "undefined-field": "Warning",
    /*
    Enable undefined global variable diagnostics.
    */
    "undefined-global": "Warning",
    /*
    Enable diagnostics for casts of undefined variables.
    */
    "unknown-cast-variable": "Warning",
    /*
    Enable diagnostics in cases in which an unknown diagnostics code is entered.
    */
    "unknown-diag-code": "Warning",
    /*
    Enable diagnostics for unknown operators.
    */
    "unknown-operator": "Warning",
    /*
    Enable diagnostics for unreachable code.
    */
    "unreachable-code": "Hint",
    /*
    Enable unused function diagnostics.
    */
    "unused-function": "Hint",
    /*
    Enable unused label diagnostics.
    */
    "unused-label": "Hint",
    /*
    Enable unused local variable diagnostics.
    */
    "unused-local": "Hint",
    /*
    Enable unused vararg diagnostics.
    */
    "unused-vararg": "Hint"
}
```

# diagnostics.unusedLocalExclude

Do not diagnose `unused-local` when the variable name matches the following pattern.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.workspaceDelay

Latency (milliseconds) for workspace diagnostics.

## type

```ts
integer
```

## default

```jsonc
3000
```

# diagnostics.workspaceEvent

Set the time to trigger workspace diagnostics.

## type

```ts
string
```

## enum

* ``"OnChange"``: Trigger workspace diagnostics when the file is changed.
* ``"OnSave"``: Trigger workspace diagnostics when the file is saved.
* ``"None"``: Disable workspace diagnostics.

## default

```jsonc
"OnSave"
```

# diagnostics.workspaceRate

Workspace diagnostics run rate (%). Decreasing this value reduces CPU usage, but also reduces the speed of workspace diagnostics. The diagnosis of the file you are currently editing is always done at full speed and is not affected by this setting.

## type

```ts
integer
```

## default

```jsonc
100
```

# doc.packageName

Treat specific field names as package, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are package, witch can only be accessed in the file where the definition is located.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.privateName

Treat specific field names as private, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are private, witch can only be accessed in the class where the definition is located.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.protectedName

Treat specific field names as protected, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are protected, witch can only be accessed in the class where the definition is located and its subclasses.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# format.defaultConfig

The default format configuration. Has a lower priority than `.editorconfig` file in the workspace.
Read [formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) to learn usage.


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# format.enable

Enable code formatter.

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"Auto"
```

# hint.await

If the called function is marked `---@async`, prompt `await` at the call.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.enable

Enable inlay hint.

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"All"
```

# hint.paramType

Show type hints at the parameter of the function.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.semicolon

If there is no semicolon at the end of the statement, display a virtual semicolon.

## type

```ts
string
```

## enum

* ``"All"``: All statements display virtual semicolons.
* ``"SameLine"``: When two statements are on the same line, display a semicolon between them.
* ``"Disable"``: Disable virtual semicolons.

## default

```jsonc
"SameLine"
```

# hint.setType

Show hints of type at assignment operation.

## type

```ts
boolean
```

## default

```jsonc
false
```

# hover.enable

Enable hover.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.enumsLimit

When the value corresponds to multiple types, limit the number of types displaying.

## type

```ts
integer
```

## default

```jsonc
5
```

# hover.expandAlias

Whether to expand the alias. For example, expands `---@alias myType boolean|number` appears as `boolean|number`, otherwise it appears as `myType'.


## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.previewFields

When hovering to view a table, limits the maximum number of previews for fields.

## type

```ts
integer
```

## default

```jsonc
50
```

# hover.viewNumber

Hover to view numeric content (only if literal is not decimal).

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewString

Hover to view the contents of a string (only if the literal contains an escape character).

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewStringMax

The maximum length of a hover to view the contents of a string.

## type

```ts
integer
```

## default

```jsonc
1000
```

# misc.executablePath

Specify the executable path in VSCode.

## type

```ts
string
```

## default

```jsonc
""
```

# misc.parameters

[Command line parameters](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) when starting the language server in VSCode.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# nameStyle.config

Set name style config

## type

```ts
Object<string, string | array>
```

## default

```jsonc
{}
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
    "jit.profile": "default",
    "jit.util": "default",
    "math": "default",
    "os": "default",
    "package": "default",
    "string": "default",
    "string.buffer": "default",
    "table": "default",
    "table.clear": "default",
    "table.new": "default",
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

```jsonc
"utf8"
```

# runtime.meta

Format of the directory name of the meta files.

## type

```ts
string
```

## default

```jsonc
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
* ``"|lambda|"``

## default

```jsonc
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

```jsonc
["?.lua","?/init.lua"]
```

# runtime.pathStrict

When enabled, `runtime.path` will only search the first level of directories, see the description of `runtime.path`.

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.plugin

Plugin path. Please read [wiki](https://luals.github.io/wiki/plugins) to learn more.

## type

```ts
string
```

## default

```jsonc
""
```

# runtime.pluginArgs

Additional arguments for the plugin.

## type

```ts
Array<string>
```

## default

```jsonc
[]
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

```jsonc
{}
```

# runtime.unicodeName

Allows Unicode characters in name.

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"Lua 5.4"
```

# semantic.annotation

Semantic coloring of type annotations.

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.enable

Enable semantic color. You may need to set `editor.semanticHighlighting.enabled` to `true` to take effect.

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.keyword

Semantic coloring of keywords/literals/operators. You only need to enable this feature if your editor cannot do syntax coloring.

## type

```ts
boolean
```

## default

```jsonc
false
```

# semantic.variable

Semantic coloring of variables/fields/parameters.

## type

```ts
boolean
```

## default

```jsonc
true
```

# signatureHelp.enable

Enable signature help.

## type

```ts
boolean
```

## default

```jsonc
true
```

# spell.dict

Custom words for spell checking.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# type.castNumberToInteger

Allowed to assign the `number` type to the `integer` type.

## type

```ts
boolean
```

## default

```jsonc
true
```

# type.weakNilCheck

When checking the type of union type, ignore the `nil` in it.

When this setting is `false`, the `number|nil` type cannot be assigned to the `number` type. It can be with `true`.


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.weakUnionCheck

Once one subtype of a union type meets the condition, the union type also meets the condition.

When this setting is `false`, the `number|boolean` type cannot be assigned to the `number` type. It can be with `true`.


## type

```ts
boolean
```

## default

```jsonc
false
```

# typeFormat.config

Configures the formatting behavior while typing Lua code.

## type

```ts
object<string, string>
```

## default

```jsonc
{
    /*
    Controls if `end` is automatically completed at suitable positions.
    */
    "auto_complete_end": "true",
    /*
    Controls if a separator is automatically appended at the end of a table declaration.
    */
    "auto_complete_table_sep": "true",
    /*
    Controls if a line is formatted at all.
    */
    "format_line": "true"
}
```

# window.progressBar

Show progress bar in status bar.

## type

```ts
boolean
```

## default

```jsonc
true
```

# window.statusBar

Show extension status in status bar.

## type

```ts
boolean
```

## default

```jsonc
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
string
```

## enum

* ``"Ask"``
* ``"Apply"``
* ``"ApplyInMemory"``
* ``"Disable"``

## default

```jsonc
"Ask"
```

# workspace.ignoreDir

Ignored files and directories (Use `.gitignore` grammar).

## type

```ts
Array<string>
```

## default

```jsonc
[".vscode"]
```

# workspace.ignoreSubmodules

Ignore submodules.

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.library

In addition to the current workspace, which directories will load files from. The files in these directories will be treated as externally provided code libraries, and some features (such as renaming fields) will not modify these files.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# workspace.maxPreload

Max preloaded files.

## type

```ts
integer
```

## default

```jsonc
5000
```

# workspace.preloadFileSize

Skip files larger than this value (KB) when preloading.

## type

```ts
integer
```

## default

```jsonc
500
```

# workspace.useGitIgnore

Ignore files list in `.gitignore` .

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.userThirdParty

Add private third-party library configuration file paths here, please refer to the built-in [configuration file path](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)

## type

```ts
Array<string>
```

## default

```jsonc
[]
```
