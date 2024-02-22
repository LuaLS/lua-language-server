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

輸入內容看起來是個檔名時，自動 `require` 此檔案。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.callSnippet

顯示函式呼叫片段。

## type

```ts
string
```

## enum

* ``"Disable"``: 只顯示 `函式名`。
* ``"Both"``: 顯示 `函式名` 與 `呼叫片段`。
* ``"Replace"``: 只顯示 `呼叫片段`。

## default

```jsonc
"Disable"
```

# completion.displayContext

預覽建議的相關程式碼片段，可能可以幫助你瞭解這項建議的用法。設定的數字表示程式碼片段的擷取行數，設定為 `0` 可以停用此功能。

## type

```ts
integer
```

## default

```jsonc
0
```

# completion.enable

啟用自動完成。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.keywordSnippet

顯示關鍵字語法片段。

## type

```ts
string
```

## enum

* ``"Disable"``: 只顯示 `關鍵字`。
* ``"Both"``: 顯示 `關鍵字` 與 `語法片段`。
* ``"Replace"``: 只顯示 `語法片段`。

## default

```jsonc
"Replace"
```

# completion.postfix

用於觸發後綴建議的符號。

## type

```ts
string
```

## default

```jsonc
"@"
```

# completion.requireSeparator

`require` 時使用的分隔符。

## type

```ts
string
```

## default

```jsonc
"."
```

# completion.showParams

在建議列表中顯示函式的參數資訊，函式擁有多個定義時會分開顯示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.showWord

在建議中顯示上下文單詞。

## type

```ts
string
```

## enum

* ``"Enable"``: 總是在建議中顯示上下文單詞。
* ``"Fallback"``: 無法根據語義提供建議時才顯示上下文單詞。
* ``"Disable"``: 不顯示上下文單詞。

## default

```jsonc
"Fallback"
```

# completion.workspaceWord

顯示的上下文單詞是否包含工作區中其他檔案的內容。

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.disable

停用的診斷（使用浮框括號內的程式碼）。

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

不診斷使用以下 scheme 的lua檔案。

## type

```ts
Array<string>
```

## default

```jsonc
["git"]
```

# diagnostics.enable

啟用診斷。

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.globals

已定義的全域變數。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.groupFileStatus

批量修改一個組中的檔案狀態。

* Opened:  只診斷打開的檔案
* Any:     診斷所有檔案
* None:    停用此診斷

設定為 `Fallback` 意味著組中的診斷由 `diagnostics.neededFileStatus` 單獨設定。
其他設定將覆蓋單獨設定，但是不會覆蓋以 `!` 結尾的設定。


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

批量修改一個組中的診斷等級。
設定為 `Fallback` 意味著組中的診斷由 `diagnostics.severity` 單獨設定。
其他設定將覆蓋單獨設定，但是不會覆蓋以 `!` 結尾的設定。


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

如何診斷被忽略的檔案。

## type

```ts
string
```

## enum

* ``"Enable"``: 總是診斷這些檔案。
* ``"Opened"``: 只有打開這些檔案時才會診斷。
* ``"Disable"``: 不診斷這些檔案。

## default

```jsonc
"Opened"
```

# diagnostics.libraryFiles

如何診斷透過 `Lua.workspace.library` 載入的檔案。

## type

```ts
string
```

## enum

* ``"Enable"``: 總是診斷這些檔案。
* ``"Opened"``: 只有打開這些檔案時才會診斷。
* ``"Disable"``: 不診斷這些檔案。

## default

```jsonc
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  只診斷打開的檔案
* Any:     診斷所有檔案
* None:    停用此診斷

以 `!` 結尾的設定優先順序高於組設定 `diagnostics.groupFileStatus`。


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
    優先順序歧義，如： `num or 0 + 1` ，推測使用者的實際期望為 `(num or 0) + 1`
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
    在字面常數表中重複定義了索引
    */
    "duplicate-index": "Any",
    /*
    Enable diagnostics for setting the same field in a class more than once.
    */
    "duplicate-set-field": "Opened",
    /*
    空程式碼區塊
    */
    "empty-block": "Opened",
    /*
    Enable diagnostics to warn about global elements.
    */
    "global-element": "None",
    /*
    不能使用全域變數（ `_ENV` 被設定為 `nil`）
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
    首字母小寫的全域變數定義
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
    在字面常數表中，2行程式碼之間缺少分隔符，在語法上被解析為了一次索引操作
    */
    "newfield-call": "Any",
    /*
    以 `(` 開始的新行，在語法上被解析為了上一行的函式呼叫
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
    重複定義的區域變數
    */
    "redefined-local": "Opened",
    /*
    函式呼叫時，傳入了多餘的引數
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
    賦值操作時，值的數量比被賦值的對象多
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
    後置空格
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
    `_ENV` 被設定為了新的字面常數表，但是試圖獲取的全域變數不在這張表中
    */
    "undefined-env-child": "Any",
    /*
    Enable diagnostics for cases in which an undefined field of a variable is read.
    */
    "undefined-field": "Opened",
    /*
    未定義的全域變數
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
    未使用的函式
    */
    "unused-function": "Opened",
    /*
    未使用的標籤
    */
    "unused-label": "Opened",
    /*
    未使用的區域變數
    */
    "unused-local": "Opened",
    /*
    未使用的不定引數
    */
    "unused-vararg": "Opened"
}
```

# diagnostics.severity

修改診斷等級。
以 `!` 結尾的設定優先順序高於組設定 `diagnostics.groupSeverity`。


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
    優先順序歧義，如： `num or 0 + 1` ，推測使用者的實際期望為 `(num or 0) + 1`
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
    在字面常數表中重複定義了索引
    */
    "duplicate-index": "Warning",
    /*
    Enable diagnostics for setting the same field in a class more than once.
    */
    "duplicate-set-field": "Warning",
    /*
    空程式碼區塊
    */
    "empty-block": "Hint",
    /*
    Enable diagnostics to warn about global elements.
    */
    "global-element": "Warning",
    /*
    不能使用全域變數（ `_ENV` 被設定為 `nil`）
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
    首字母小寫的全域變數定義
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
    在字面常數表中，2行程式碼之間缺少分隔符，在語法上被解析為了一次索引操作
    */
    "newfield-call": "Warning",
    /*
    以 `(` 開始的新行，在語法上被解析為了上一行的函式呼叫
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
    重複定義的區域變數
    */
    "redefined-local": "Hint",
    /*
    函式呼叫時，傳入了多餘的引數
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
    賦值操作時，值的數量比被賦值的對象多
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
    後置空格
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
    `_ENV` 被設定為了新的字面常數表，但是試圖獲取的全域變數不在這張表中
    */
    "undefined-env-child": "Information",
    /*
    Enable diagnostics for cases in which an undefined field of a variable is read.
    */
    "undefined-field": "Warning",
    /*
    未定義的全域變數
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
    未使用的函式
    */
    "unused-function": "Hint",
    /*
    未使用的標籤
    */
    "unused-label": "Hint",
    /*
    未使用的區域變數
    */
    "unused-local": "Hint",
    /*
    未使用的不定引數
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

進行工作區診斷的延遲（毫秒）。

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

工作區診斷的執行速率（百分比）。降低該值會減少CPU使用率，但是也會降低工作區診斷的速度。你目前正在編輯的檔案的診斷總是全速完成，不受該選項影響。

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

預設的格式化組態，優先順序低於工作區內的 `.editorconfig` 檔案。
請查閱[格式化文件](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)了解用法。


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# format.enable

啟用程式碼格式化程式。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.arrayIndex

在建構表時提示陣列索引。

## type

```ts
string
```

## enum

* ``"Enable"``: 所有的表中都提示陣列索引。
* ``"Auto"``: 只有表大於3項，或者表是混合類型時才進行提示。
* ``"Disable"``: 停用陣列索引提示。

## default

```jsonc
"Auto"
```

# hint.await

如果呼叫的函數被標記為了 `---@async`，則在呼叫處提示 `await`。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.enable

啟用內嵌提示。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.paramName

在函式呼叫處提示參數名。

## type

```ts
string
```

## enum

* ``"All"``: 所有類型的參數均進行提示。
* ``"Literal"``: 只有字面常數類型的參數進行提示。
* ``"Disable"``: 停用參數提示。

## default

```jsonc
"All"
```

# hint.paramType

在函式的參數位置提示類型。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.semicolon

若陳述式尾部沒有分號，則顯示虛擬分號。

## type

```ts
string
```

## enum

* ``"All"``: 所有陳述式都顯示虛擬分號。
* ``"SameLine"``: 兩個陳述式在同一行時，在它們之間顯示分號。
* ``"Disable"``: 停用虛擬分號。

## default

```jsonc
"SameLine"
```

# hint.setType

在賦值操作位置提示類型。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hover.enable

啟用懸浮提示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.enumsLimit

當值對應多個類型時，限制類型的顯示數量。

## type

```ts
integer
```

## default

```jsonc
5
```

# hover.expandAlias

是否展開別名。例如 `---@alias myType boolean|number` 展開後顯示為 `boolean|number`，否則顯示為 `myType'。


## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.previewFields

懸浮提示檢視表時，限制表內欄位的最大預覽數量。

## type

```ts
integer
```

## default

```jsonc
50
```

# hover.viewNumber

懸浮提示檢視數字內容（僅當字面常數不是十進制時）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewString

懸浮提示檢視字串內容（僅當字面常數包含跳脫字元時）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewStringMax

懸浮提示檢視字串內容時的最大長度。

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

VSCode中啟動語言伺服時的[命令列參數](https://luals.github.io/wiki/usage#arguments)。

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

調整內建庫的啟用狀態，你可以根據實際執行環境停用（或重新定義）不存在的庫。

* `default`: 表示庫會根據執行版本啟用或停用
* `enable`: 總是啟用
* `disable`: 總是停用


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

檔案編碼，選項 `ansi` 只在 `Windows` 平台下有效。

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

meta檔案的目錄名稱格式

## type

```ts
string
```

## default

```jsonc
"${version} ${language} ${encoding}"
```

# runtime.nonstandardSymbol

支援非標準的符號。請務必確認你的執行環境支援這些符號。

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

當使用 `require` 時，如何根據輸入的名字來尋找檔案。
此選項設定為 `?/init.lua` 意味著當你輸入 `require 'myfile'` 時，會從已載入的檔案中搜尋 `{workspace}/myfile/init.lua`。
當 `runtime.pathStrict` 設定為 `false` 時，還會嘗試搜尋 `${workspace}/**/myfile/init.lua`。
如果你想要載入工作區以外的檔案，你需要先設定 `Lua.workspace.library`。


## type

```ts
Array<string>
```

## default

```jsonc
["?.lua","?/init.lua"]
```

# runtime.pathStrict

啟用後 `runtime.path` 將只搜尋第一層目錄，見 `runtime.path` 的説明。

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.plugin

延伸模組路徑，請查閱[文件](https://luals.github.io/wiki/plugins)瞭解用法。

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

將自訂全域變數視為一些特殊的內建變數，語言伺服將提供特殊的支援。
下面這個例子表示將 `include` 視為 `require` 。
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

允許在名字中使用 Unicode 字元。

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.version

Lua執行版本。

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

對類型註解進行語義著色。

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.enable

啟用語義著色。你可能需要同時將 `editor.semanticHighlighting.enabled` 設定為 `true` 才能生效。

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.keyword

對關鍵字/字面常數/運算子進行語義著色。只有當你的編輯器無法進行語法著色時才需要啟用此功能。

## type

```ts
boolean
```

## default

```jsonc
false
```

# semantic.variable

對變數/欄位/參數進行語義著色。

## type

```ts
boolean
```

## default

```jsonc
true
```

# signatureHelp.enable

啟用參數提示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# spell.dict

拼寫檢查的自訂單詞。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# type.castNumberToInteger

允許將 `number` 類型賦值給 `integer` 類型。

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

同位類型中只要有一個子類型滿足條件，則同位類型也滿足條件。

此設定為 `false` 時，`number|boolean` 類型無法賦給 `number` 類型；為 `true` 時則可以。


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

在狀態欄顯示進度條。

## type

```ts
boolean
```

## default

```jsonc
true
```

# window.statusBar

在狀態欄顯示延伸模組狀態。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.checkThirdParty

自動偵測與適應第三方庫，目前支援的庫為：

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

忽略的檔案與目錄（使用 `.gitignore` 語法）。

## type

```ts
Array<string>
```

## default

```jsonc
[".vscode"]
```

# workspace.ignoreSubmodules

忽略子模組。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.library

除了目前工作區以外，還會從哪些目錄中載入檔案。這些目錄中的檔案將被視作外部提供的程式碼庫，部分操作（如重新命名欄位）不會修改這些檔案。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# workspace.maxPreload

最大預載入檔案數。

## type

```ts
integer
```

## default

```jsonc
5000
```

# workspace.preloadFileSize

預載入時跳過大小大於該值（KB）的檔案。

## type

```ts
integer
```

## default

```jsonc
500
```

# workspace.useGitIgnore

忽略 `.gitignore` 中列舉的檔案。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.userThirdParty

在這裡添加私有的第三方庫適應檔案路徑，請參考內建的[組態檔案路徑](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)

## type

```ts
Array<string>
```

## default

```jsonc
[]
```