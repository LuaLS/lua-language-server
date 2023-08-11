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

# codeLens.enable

启用代码度量。

## type

```ts
boolean
```

## default

```jsonc
false
```

# completion.autoRequire

输入内容看起来是个文件名时，自动 `require` 此文件。

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"Disable"
```

# completion.displayContext

预览建议的相关代码片段，可能可以帮助你了解这项建议的用法。设置的数字表示代码片段的截取行数，设置为`0`可以禁用此功能。

## type

```ts
integer
```

## default

```jsonc
0
```

# completion.enable

启用自动完成。

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"Replace"
```

# completion.postfix

用于触发后缀建议的符号。

## type

```ts
string
```

## default

```jsonc
"@"
```

# completion.requireSeparator

`require` 时使用的分隔符。

## type

```ts
string
```

## default

```jsonc
"."
```

# completion.showParams

在建议列表中显示函数的参数信息，函数拥有多个定义时会分开显示。

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"Fallback"
```

# completion.workspaceWord

显示的上下文单词是否包含工作区中其他文件的内容。

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.disable

禁用的诊断（使用浮框括号内的代码）。

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

不诊断使用以下 scheme 的lua文件。

## type

```ts
Array<string>
```

## default

```jsonc
["git"]
```

# diagnostics.enable

启用诊断。

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.globals

已定义的全局变量。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.groupFileStatus

批量修改一个组中的文件状态。

* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* None:    禁用此诊断

设置为 `Fallback` 意味着组中的诊断由 `diagnostics.neededFileStatus` 单独设置。
其他设置将覆盖单独设置，但是不会覆盖以 `!` 结尾的设置。


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

批量修改一个组中的诊断等级。
设置为 `Fallback` 意味着组中的诊断由 `diagnostics.severity` 单独设置。
其他设置将覆盖单独设置，但是不会覆盖以 `!` 结尾的设置。


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

```jsonc
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

```jsonc
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* None:    禁用此诊断

以 `!` 结尾的设置优先级高于组设置 `diagnostics.groupFileStatus`。


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
    优先级歧义，如：`num or 0 + 1`，推测用户的实际期望为 `(num or 0) + 1`
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
    在字面量表中重复定义了索引
    */
    "duplicate-index": "Any",
    /*
    Enable diagnostics for setting the same field in a class more than once.
    */
    "duplicate-set-field": "Opened",
    /*
    空代码块
    */
    "empty-block": "Opened",
    /*
    Enable diagnostics to warn about global elements.
    */
    "global-element": "None",
    /*
    不能使用全局变量（ `_ENV` 被设置为了 `nil`）
    */
    "global-in-nil-env": "Any",
    /*
    Incomplete @param or @return annotations for functions.
    */
    "incomplete-signature-doc": "None",
    /*
    Enable diagnostics for accesses to fields which are invisible.
    */
    "invisible": "Any",
    /*
    首字母小写的全局变量定义
    */
    "lowercase-global": "Any",
    "missing-fields": "Any",
    /*
    Missing annotations for globals! Global functions must have a comment and annotations for all parameters and return values.
    */
    "missing-global-doc": "None",
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
    在字面量表中，2行代码之间缺少分隔符，在语法上被解析为了一次索引操作
    */
    "newfield-call": "Any",
    /*
    以 `(` 开始的新行，在语法上被解析为了上一行的函数调用
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
    重复定义的局部变量
    */
    "redefined-local": "Opened",
    /*
    函数调用时，传入了多余的参数
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
    赋值操作时，值的数量比被赋值的对象多
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
    后置空格
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
    `_ENV` 被设置为了新的字面量表，但是试图获取的全局变量不再这张表中
    */
    "undefined-env-child": "Any",
    /*
    Enable diagnostics for cases in which an undefined field of a variable is read.
    */
    "undefined-field": "Opened",
    /*
    未定义的全局变量
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
    未使用的函数
    */
    "unused-function": "Opened",
    /*
    未使用的标签
    */
    "unused-label": "Opened",
    /*
    未使用的局部变量
    */
    "unused-local": "Opened",
    /*
    未使用的不定参数
    */
    "unused-vararg": "Opened"
}
```

# diagnostics.severity

修改诊断等级。
以 `!` 结尾的设置优先级高于组设置 `diagnostics.groupSeverity`。


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
    优先级歧义，如：`num or 0 + 1`，推测用户的实际期望为 `(num or 0) + 1`
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
    在字面量表中重复定义了索引
    */
    "duplicate-index": "Warning",
    /*
    Enable diagnostics for setting the same field in a class more than once.
    */
    "duplicate-set-field": "Warning",
    /*
    空代码块
    */
    "empty-block": "Hint",
    /*
    Enable diagnostics to warn about global elements.
    */
    "global-element": "Warning",
    /*
    不能使用全局变量（ `_ENV` 被设置为了 `nil`）
    */
    "global-in-nil-env": "Warning",
    /*
    Incomplete @param or @return annotations for functions.
    */
    "incomplete-signature-doc": "Warning",
    /*
    Enable diagnostics for accesses to fields which are invisible.
    */
    "invisible": "Warning",
    /*
    首字母小写的全局变量定义
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
    在字面量表中，2行代码之间缺少分隔符，在语法上被解析为了一次索引操作
    */
    "newfield-call": "Warning",
    /*
    以 `(` 开始的新行，在语法上被解析为了上一行的函数调用
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
    重复定义的局部变量
    */
    "redefined-local": "Hint",
    /*
    函数调用时，传入了多余的参数
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
    赋值操作时，值的数量比被赋值的对象多
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
    后置空格
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
    `_ENV` 被设置为了新的字面量表，但是试图获取的全局变量不再这张表中
    */
    "undefined-env-child": "Information",
    /*
    Enable diagnostics for cases in which an undefined field of a variable is read.
    */
    "undefined-field": "Warning",
    /*
    未定义的全局变量
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
    未使用的函数
    */
    "unused-function": "Hint",
    /*
    未使用的标签
    */
    "unused-label": "Hint",
    /*
    未使用的局部变量
    */
    "unused-local": "Hint",
    /*
    未使用的不定参数
    */
    "unused-vararg": "Hint"
}
```

# diagnostics.unusedLocalExclude

如果变量名匹配以下规则，则不对其进行 `unused-local` 诊断。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.workspaceDelay

进行工作区诊断的延迟（毫秒）。

## type

```ts
integer
```

## default

```jsonc
3000
```

# diagnostics.workspaceEvent

设置触发工作区诊断的时机。

## type

```ts
string
```

## enum

* ``"OnChange"``: 当文件发生变化时触发工作区诊断。
* ``"OnSave"``: 当文件保存时触发工作区诊断。
* ``"None"``: 关闭工作区诊断。

## default

```jsonc
"OnSave"
```

# diagnostics.workspaceRate

工作区诊断的运行速率（百分比）。降低该值会减少CPU占用，但是也会降低工作区诊断的速度。你当前正在编辑的文件的诊断总是全速完成，不受该选项影响。

## type

```ts
integer
```

## default

```jsonc
100
```

# doc.packageName

将特定名称的字段视为package，例如 `m_*` 意味着 `XXX.m_id` 与 `XXX.m_type` 只能在定义所在的文件中访问。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.privateName

将特定名称的字段视为私有，例如 `m_*` 意味着 `XXX.m_id` 与 `XXX.m_type` 是私有字段，只能在定义所在的类中访问。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.protectedName

将特定名称的字段视为受保护，例如 `m_*` 意味着 `XXX.m_id` 与 `XXX.m_type` 是受保护的字段，只能在定义所在的类极其子类中访问。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# format.defaultConfig

默认的格式化配置，优先级低于工作区内的 `.editorconfig` 文件。
请查阅[格式化文档](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)了解用法。


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# format.enable

启用代码格式化程序。

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"Auto"
```

# hint.await

如果调用的函数被标记为了 `---@async` ，则在调用处提示 `await` 。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.enable

启用内联提示。

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"All"
```

# hint.paramType

在函数的参数位置提示类型。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.semicolon

若语句尾部没有分号，则显示虚拟分号。

## type

```ts
string
```

## enum

* ``"All"``: 所有语句都显示虚拟分号。
* ``"SameLine"``: 2个语句在同一行时，在它们之间显示分号。
* ``"Disable"``: 禁用虚拟分号。

## default

```jsonc
"SameLine"
```

# hint.setType

在赋值操作位置提示类型。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hover.enable

启用悬停提示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.enumsLimit

当值对应多个类型时，限制类型的显示数量。

## type

```ts
integer
```

## default

```jsonc
5
```

# hover.expandAlias

是否展开别名。例如 `---@alias myType boolean|number` 展开后显示为 `boolean|number`，否则显示为 `myType`。


## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.previewFields

悬停提示查看表时，限制表内字段的最大预览数量。

## type

```ts
integer
```

## default

```jsonc
50
```

# hover.viewNumber

悬停提示查看数字内容（仅当字面量不是十进制时）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewString

悬停提示查看字符串内容（仅当字面量包含转义符时）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewStringMax

悬停提示查看字符串内容时的最大长度。

## type

```ts
integer
```

## default

```jsonc
1000
```

# misc.executablePath

VSCode中指定可执行文件路径。

## type

```ts
string
```

## default

```jsonc
""
```

# misc.parameters

VSCode中启动语言服务时的[命令行参数](https://luals.github.io/wiki/usage/#arguments)。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# nameStyle.config

设定命名风格检查的配置

## type

```ts
Object<string, string | array>
```

## default

```jsonc
{}
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

```jsonc
"utf8"
```

# runtime.meta

meta文件的目录名称格式。

## type

```ts
string
```

## default

```jsonc
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

## default

```jsonc
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

```jsonc
["?.lua","?/init.lua"]
```

# runtime.pathStrict

启用后 `runtime.path` 将只搜索第一层目录，见 `runtime.path` 的说明。

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.plugin

插件路径，请查阅[文档](https://luals.github.io/wiki/plugins)了解用法。

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

```jsonc
{}
```

# runtime.unicodeName

允许在名字中使用 Unicode 字符。

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
"Lua 5.4"
```

# semantic.annotation

对类型注解进行语义着色。

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.enable

启用语义着色。你可能需要同时将 `editor.semanticHighlighting.enabled` 设置为 `true` 才能生效。

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.keyword

对关键字/字面量/运算符进行语义着色。只有当你的编辑器无法进行语法着色时才需要启用此功能。

## type

```ts
boolean
```

## default

```jsonc
false
```

# semantic.variable

对变量/字段/参数进行语义着色。

## type

```ts
boolean
```

## default

```jsonc
true
```

# signatureHelp.enable

启用参数提示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# spell.dict

拼写检查的自定义单词。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# type.castNumberToInteger

允许将 `number` 类型赋给 `integer` 类型。

## type

```ts
boolean
```

## default

```jsonc
true
```

# type.weakNilCheck

对联合类型进行类型检查时，忽略其中的 `nil`。

此设置为 `false` 时，`numer|nil` 类型无法赋给 `number` 类型；为 `true` 是则可以。


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.weakUnionCheck

联合类型中只要有一个子类型满足条件，则联合类型也满足条件。

此设置为 `false` 时，`number|boolean` 类型无法赋给 `number` 类型；为 `true` 时则可以。


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

在状态栏显示进度条。

## type

```ts
boolean
```

## default

```jsonc
true
```

# window.statusBar

在状态栏显示插件状态。

## type

```ts
boolean
```

## default

```jsonc
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

```jsonc
true
```

# workspace.ignoreDir

忽略的文件与目录（使用 `.gitignore` 语法）。

## type

```ts
Array<string>
```

## default

```jsonc
[".vscode"]
```

# workspace.ignoreSubmodules

忽略子模块。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.library

除了当前工作区以外，还会从哪些目录中加载文件。这些目录中的文件将被视作外部提供的代码库，部分操作（如重命名字段）不会修改这些文件。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# workspace.maxPreload

最大预加载文件数。

## type

```ts
integer
```

## default

```jsonc
5000
```

# workspace.preloadFileSize

预加载时跳过大小大于该值（KB）的文件。

## type

```ts
integer
```

## default

```jsonc
500
```

# workspace.useGitIgnore

忽略 `.gitignore` 中列举的文件。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.userThirdParty

在这里添加私有的第三方库适配文件路径，请参考内置的[配置文件路径](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)

## type

```ts
Array<string>
```

## default

```jsonc
[]
```
