# addonManager.enable

是否啟用延伸模組的附加插件管理器（Addon Manager）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# addonManager.repositoryBranch

指定插件管理器（Addon Manager）使用的git branch。

## type

```ts
string
```

## default

```jsonc
""
```

# addonManager.repositoryPath

指定插件管理器（Addon Manager）使用的git path。

## type

```ts
string
```

## default

```jsonc
""
```

# addonRepositoryPath

指定獨立的插件倉庫路徑（與插件管理器無關）。

## type

```ts
string
```

## default

```jsonc
""
```

# codeLens.enable

啟用CodeLens。

## type

```ts
boolean
```

## default

```jsonc
false
```

# completion.autoRequire

輸入內容看起來像檔名時，自動 `require` 此檔案。

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

# completion.maxSuggestCount

自動完成時最多分析的欄位數量。若物件欄位超過此上限，必須提供更精確的輸入才會顯示建議。

## type

```ts
integer
```

## default

```jsonc
100
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
* ``"assign-const-global"``
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
* ``"declare-const"``
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
* ``"env-is-global"``
* ``"err-assign-as-eq"``
* ``"err-c-long-comment"``
* ``"err-comment-prefix"``
* ``"err-do-as-then"``
* ``"err-eq-as-assign"``
* ``"err-esc"``
* ``"err-nonstandard-symbol"``
* ``"err-then-as-do"``
* ``"exp-in-action"``
* ``"global-close-attribute"``
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
* ``"multi-close"``
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
* ``"unexpect-gfunc-name"``
* ``"unexpect-lfunc-name"``
* ``"unexpect-symbol"``
* ``"unicode-name"``
* ``"unknown-attribute"``
* ``"unknown-cast-variable"``
* ``"unknown-diag-code"``
* ``"unknown-operator"``
* ``"unknown-symbol"``
* ``"unreachable-code"``
* ``"unsupport-named-vararg"``
* ``"unsupport-symbol"``
* ``"unused-function"``
* ``"unused-label"``
* ``"unused-local"``
* ``"unused-vararg"``
* ``"variable-not-declared"``

## default

```jsonc
[]
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

# diagnostics.enableScheme

**Missing description!!**

## type

```ts
Array<string>
```

## default

```jsonc
["file"]
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

# diagnostics.globalsRegex

使用正規表示式尋找全域變數。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.groupFileStatus

批次修改一個組中的檔案狀態。

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

批次修改一個組中的診斷等級。
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
    賦值類型與變數類型不符合
    */
    "assign-type-mismatch": "Opened",
    /*
    同步函式中呼叫非同步函式
    */
    "await-in-sync": "None",
    /*
    已顯式定義變數類型不符合要定義的值的類型
    */
    "cast-local-type": "Opened",
    /*
    變數被轉換為不符合其初始類型的類型
    */
    "cast-type-mismatch": "Opened",
    "circle-doc-class": "Any",
    /*
    嘗試關閉非物件變數
    */
    "close-non-object": "Any",
    /*
    迴圈內break陳述式後的程式碼
    */
    "code-after-break": "Opened",
    /*
    行的格式不正確
    */
    "codestyle-check": "None",
    /*
    因為 `for` 迴圈是遞增而不是遞減，所以不會到達上限/極限
    */
    "count-down-loop": "Any",
    /*
    API已標記deprecated（棄用）但仍在使用
    */
    "deprecated": "Any",
    /*
    required的同一個檔案使用了兩個不同的名字
    */
    "different-requires": "Any",
    /*
    忽略了標註為 `@nodiscard` 的函式的回傳值
    */
    "discard-returns": "Any",
    /*
    向沒有標註 `@class` 的類別標註 `@field` 欄位
    */
    "doc-field-no-class": "Any",
    /*
    `@alias` 標註名字衝突
    */
    "duplicate-doc-alias": "Any",
    /*
    `@field` 標註名字衝突
    */
    "duplicate-doc-field": "Any",
    /*
    `@param` 標註名字衝突
    */
    "duplicate-doc-param": "Any",
    /*
    在字面常數表中重複定義了索引
    */
    "duplicate-index": "Any",
    /*
    在類別中多次定義相同的欄位
    */
    "duplicate-set-field": "Opened",
    /*
    空程式碼區塊
    */
    "empty-block": "Opened",
    /*
    對全域元素的警告
    */
    "global-element": "None",
    /*
    不能使用全域變數（ `_ENV` 被設定為 `nil`）
    */
    "global-in-nil-env": "Any",
    /*
    `@param` 或 `@return` 不完整
    */
    "incomplete-signature-doc": "None",
    "inject-field": "Opened",
    /*
    嘗試存取不可見的欄位
    */
    "invisible": "Any",
    /*
    首字母小寫的全域變數定義
    */
    "lowercase-global": "Any",
    "missing-fields": "Any",
    /*
    全域變數缺少標註（全域函式必須為所有參數和回傳值提供標註）
    */
    "missing-global-doc": "None",
    /*
    匯出的區域函式缺少標註（匯出的區域函式、所有的參數和回傳值都必須有標註）
    */
    "missing-local-export-doc": "None",
    /*
    函式呼叫的引數數量比函式標註的參數數量少
    */
    "missing-parameter": "Any",
    /*
    函式有 `@return` 標註卻沒有 `return` 陳述式
    */
    "missing-return": "Any",
    /*
    函式沒有回傳值，但使用了 `@return` 標註了回傳值
    */
    "missing-return-value": "Any",
    /*
    變數命名風格檢查
    */
    "name-style-check": "None",
    /*
    變數曾被賦值為 `nil` 或可選值（可能是 `nil` ）
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
    無法推斷變數的未知類型
    */
    "no-unknown": "None",
    /*
    不允許呼叫 `coroutine.yield()`
    */
    "not-yieldable": "None",
    /*
    給定參數的類型不符合函式定義所要求的類型（ `@param` ）
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
    放了一個不需要的 `return` 陳述式，因為函式會自行退出
    */
    "redundant-return": "Opened",
    /*
    回傳了 `@return` 標註未指定的額外值
    */
    "redundant-return-value": "Any",
    /*
    賦值操作時，值的數量比被賦值的對象多
    */
    "redundant-value": "Any",
    /*
    回傳值的類型不符合 `@return` 中宣告的類型
    */
    "return-type-mismatch": "Opened",
    /*
    字串拼寫檢查
    */
    "spell-check": "None",
    /*
    後置空格
    */
    "trailing-space": "Opened",
    /*
    多重賦值時沒有賦值所有變數（如 `local x,y = 1` ）
    */
    "unbalanced-assignments": "Any",
    /*
    在 `@class` 標註中引用未定義的類別。
    */
    "undefined-doc-class": "Any",
    /*
    在 `@type` 標註中引用未定義的類型或 `@alias`
    */
    "undefined-doc-name": "Any",
    /*
    在 `@param` 標註中引用函式定義未宣告的參數
    */
    "undefined-doc-param": "Any",
    /*
    `_ENV` 被設定為了新的字面常數表，但是試圖獲取的全域變數不在這張表中
    */
    "undefined-env-child": "Any",
    /*
    讀取變數中為定義的欄位
    */
    "undefined-field": "Opened",
    /*
    未定義的全域變數
    */
    "undefined-global": "Any",
    /*
    使用 `@cast` 對未定義的變數進行強制轉換
    */
    "unknown-cast-variable": "Any",
    /*
    輸入了未知的診斷
    */
    "unknown-diag-code": "Any",
    /*
    未知的運算子
    */
    "unknown-operator": "Any",
    /*
    無法到達的程式碼
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
    賦值類型與變數類型不符合
    */
    "assign-type-mismatch": "Warning",
    /*
    同步函式中呼叫非同步函式
    */
    "await-in-sync": "Warning",
    /*
    已顯式定義變數類型不符合要定義的值的類型
    */
    "cast-local-type": "Warning",
    /*
    變數被轉換為不符合其初始類型的類型
    */
    "cast-type-mismatch": "Warning",
    "circle-doc-class": "Warning",
    /*
    嘗試關閉非物件變數
    */
    "close-non-object": "Warning",
    /*
    迴圈內break陳述式後的程式碼
    */
    "code-after-break": "Hint",
    /*
    行的格式不正確
    */
    "codestyle-check": "Warning",
    /*
    因為 `for` 迴圈是遞增而不是遞減，所以不會到達上限/極限
    */
    "count-down-loop": "Warning",
    /*
    API已標記deprecated（棄用）但仍在使用
    */
    "deprecated": "Warning",
    /*
    required的同一個檔案使用了兩個不同的名字
    */
    "different-requires": "Warning",
    /*
    忽略了標註為 `@nodiscard` 的函式的回傳值
    */
    "discard-returns": "Warning",
    /*
    向沒有標註 `@class` 的類別標註 `@field` 欄位
    */
    "doc-field-no-class": "Warning",
    /*
    `@alias` 標註名字衝突
    */
    "duplicate-doc-alias": "Warning",
    /*
    `@field` 標註名字衝突
    */
    "duplicate-doc-field": "Warning",
    /*
    `@param` 標註名字衝突
    */
    "duplicate-doc-param": "Warning",
    /*
    在字面常數表中重複定義了索引
    */
    "duplicate-index": "Warning",
    /*
    在類別中多次定義相同的欄位
    */
    "duplicate-set-field": "Warning",
    /*
    空程式碼區塊
    */
    "empty-block": "Hint",
    /*
    對全域元素的警告
    */
    "global-element": "Warning",
    /*
    不能使用全域變數（ `_ENV` 被設定為 `nil`）
    */
    "global-in-nil-env": "Warning",
    /*
    `@param` 或 `@return` 不完整
    */
    "incomplete-signature-doc": "Warning",
    "inject-field": "Warning",
    /*
    嘗試存取不可見的欄位
    */
    "invisible": "Warning",
    /*
    首字母小寫的全域變數定義
    */
    "lowercase-global": "Information",
    "missing-fields": "Warning",
    /*
    全域變數缺少標註（全域函式必須為所有參數和回傳值提供標註）
    */
    "missing-global-doc": "Warning",
    /*
    匯出的區域函式缺少標註（匯出的區域函式、所有的參數和回傳值都必須有標註）
    */
    "missing-local-export-doc": "Warning",
    /*
    函式呼叫的引數數量比函式標註的參數數量少
    */
    "missing-parameter": "Warning",
    /*
    函式有 `@return` 標註卻沒有 `return` 陳述式
    */
    "missing-return": "Warning",
    /*
    函式沒有回傳值，但使用了 `@return` 標註了回傳值
    */
    "missing-return-value": "Warning",
    /*
    變數命名風格檢查
    */
    "name-style-check": "Warning",
    /*
    變數曾被賦值為 `nil` 或可選值（可能是 `nil` ）
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
    無法推斷變數的未知類型
    */
    "no-unknown": "Warning",
    /*
    不允許呼叫 `coroutine.yield()`
    */
    "not-yieldable": "Warning",
    /*
    給定參數的類型不符合函式定義所要求的類型（ `@param` ）
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
    放了一個不需要的 `return` 陳述式，因為函式會自行退出
    */
    "redundant-return": "Hint",
    /*
    回傳了 `@return` 標註未指定的額外值
    */
    "redundant-return-value": "Warning",
    /*
    賦值操作時，值的數量比被賦值的對象多
    */
    "redundant-value": "Warning",
    /*
    回傳值的類型不符合 `@return` 中宣告的類型
    */
    "return-type-mismatch": "Warning",
    /*
    字串拼寫檢查
    */
    "spell-check": "Information",
    /*
    後置空格
    */
    "trailing-space": "Hint",
    /*
    多重賦值時沒有賦值所有變數（如 `local x,y = 1` ）
    */
    "unbalanced-assignments": "Warning",
    /*
    在 `@class` 標註中引用未定義的類別。
    */
    "undefined-doc-class": "Warning",
    /*
    在 `@type` 標註中引用未定義的類型或 `@alias`
    */
    "undefined-doc-name": "Warning",
    /*
    在 `@param` 標註中引用函式定義未宣告的參數
    */
    "undefined-doc-param": "Warning",
    /*
    `_ENV` 被設定為了新的字面常數表，但是試圖獲取的全域變數不在這張表中
    */
    "undefined-env-child": "Information",
    /*
    讀取變數中為定義的欄位
    */
    "undefined-field": "Warning",
    /*
    未定義的全域變數
    */
    "undefined-global": "Warning",
    /*
    使用 `@cast` 對未定義的變數進行強制轉換
    */
    "unknown-cast-variable": "Warning",
    /*
    輸入了未知的診斷
    */
    "unknown-diag-code": "Warning",
    /*
    未知的運算子
    */
    "unknown-operator": "Warning",
    /*
    無法到達的程式碼
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

如果變數名符合以下規則，則不對其進行 `unused-local` 診斷。

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

設定觸發工作區診斷的時機。

## type

```ts
string
```

## enum

* ``"OnChange"``: 當檔案發生變化時觸發工作區診斷。
* ``"OnSave"``: 當儲存檔案時觸發工作區診斷。
* ``"None"``: 停用工作區診斷。

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

將特定名稱的欄位視為package，例如 `m_*` 代表 `XXX.m_id` 和 `XXX.m_type` 只能在定義所在的檔案內存取

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.privateName

將特定名稱的欄位視為private，例如 `m_*` 代表 `XXX.m_id` 和 `XXX.m_type` 會是私有層級，只能在定義所在的類別內存取

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.protectedName

將特定名稱的欄位視為protected，例如 `m_*` 代表 `XXX.m_id` 和 `XXX.m_type` 會是保護層級，只能在定義所在的類別和其子類別內存取

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.regengine

用於匹配文件作用域名稱的正則表達式引擎。

## type

```ts
string
```

## enum

* ``"glob"``: 預設的輕量模式語法。
* ``"lua"``: 完整的 Lua 風格正則表達式。

## default

```jsonc
"glob"
```

# docScriptPath

用於匹配文件作用域名稱的正則表達式引擎。

## type

```ts
string
```

## default

```jsonc
""
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

如果呼叫的函式被標記為了 `---@async`，則在呼叫處提示 `await`。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.awaitPropagate

啟用 `await` 的傳播，當一個函式呼叫了一個 `---@async` 標記的函式時，會自動標記為 `---@async`。

## type

```ts
boolean
```

## default

```jsonc
false
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

是否展開別名。例如 `---@alias myType boolean|number` 展開後顯示為 `boolean|number`，否則顯示為 `myType`'。


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
10
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

# language.completeAnnotation

（僅限VSCode）在註解後換行時自動插入 "---@ "。

## type

```ts
boolean
```

## default

```jsonc
true
```

# language.fixIndent

（僅限VSCode）修復自動縮排錯誤，例如在有包含 "function" 的字串中換行時出現的錯誤縮排。

## type

```ts
boolean
```

## default

```jsonc
true
```

# misc.executablePath

指定VSCode內的可執行文件

## type

```ts
string
```

## default

```jsonc
""
```

# misc.parameters

VSCode內啟動語言伺服時的[命令列參數](https://luals.github.io/wiki/usage#arguments)。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# nameStyle.config

設定檢查命名風格的組態。
閱讀 [formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) 了解用法。


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

# runtime.enableLuaJITExtensions

啟用 LuaJIT 擴充語法（需將 `Lua.runtime.version` 設定為 `LuaJIT`）。
各項擴充語法也可以單獨透過 `Lua.runtime.nonstandardSymbol` 啟用。


## type

```ts
boolean
```

## default

```jsonc
false
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

LuaJIT 3.0 擴充語法（`?.` `??` `?:` `~>>` `~>>=` `..=` `~=` `const` `->` `number_underscore`）也可在此單獨啟用，不要求 `Lua.runtime.version` 為 `LuaJIT`。注意：`~=` 僅在陳述式上下文（如 `a ~= b` 單獨成行）時作為互斥或複合指定，表達式中仍是不等於比較。


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
* ``"?."``: 安全導覽（`a?.b` / `a?.[k]` / `f?.()` / `obj?.:method()` / `obj:method?.()`）。
* ``"??"``: 空值合併（`a ?? b`，僅當左側為 nil 時取右側）。
* ``"?:"``: 三元條件（`a ? b : c`，右結合；b 部分禁止方法呼叫）。
* ``"~>>"``: 算術右移（`a ~>> b`，LuaJIT 特有；普通 `>>` 為邏輯右移）。
* ``"~>>="``: 算術右移複合指定（`a ~>>= b`）。
* ``"..="``: 字串連接複合指定（`a ..= b`）。
* ``"~="``: 互斥或複合指定：僅陳述式上下文（如 `a ~= b` 單獨成行）生效；表達式中仍是不等於比較。
* ``"const"``: `const` 宣告（區塊級區域常數，不可重新賦值/重複宣告）。
* ``"->"``: 短函式箭頭（`x -> expr` / `|x| -> expr` / `|| -> expr` / `-> do ... end`）。
* ``"number_underscore"``: 數字字面量底線（如 `1_000`、`0x1_2`、`0b1_0`）。

## default

```jsonc
[]
```

# runtime.path

當使用 `require` 時，如何根據輸入的名字來尋找檔案。
此選項設定為 `?/init.lua` 時，代表當你輸入 `require 'myfile'` 時，會從已載入的檔案中搜尋 `{workspace}/myfile/init.lua`。
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

啟用後 `runtime.path` 將只搜尋第一層目錄，見 `runtime.path` 的說明。

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
string | array
```

## default

```jsonc
null
```

# runtime.pluginArgs

延伸模組的額外引數。

## type

```ts
array | object
```

## default

```jsonc
null
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
* ``"Lua 5.5"``
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

# type.checkTableShape

對表的形狀進行嚴格檢查。


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.inferParamType

未註解參數類型時，參數類型由函式傳入參數推斷。

如果設定為 "false"，則在未註解時，參數類型為 "any"。


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.inferTableSize

在類型推斷時最多分析的表欄位數。

## type

```ts
integer
```

## default

```jsonc
10
```

# type.maxUnionVariants

**Missing description!!**

## type

```ts
integer
```

## default

```jsonc
0
```

# type.weakNilCheck

對同位類型進行類型檢查時，忽略其中的 `nil`。

此設定為 `false` 時，`number|boolean` 類型無法賦值給 `number` 類型；為 `true` 時則可以。


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

此設定為 `false` 時，`number|boolean` 類型無法賦值給 `number` 類型；為 `true` 時則可以。


## type

```ts
boolean
```

## default

```jsonc
false
```

# typeFormat.config

寫Lua程式碼時的格式化組態

## type

```ts
object<string, string>
```

## default

```jsonc
{
    /*
    是否在合適的位置自動完成 `end`
    */
    "auto_complete_end": "true",
    /*
    是否在宣告表的結尾自動添加分隔符號
    */
    "auto_complete_table_sep": "true",
    /*
    是否格式化某一行
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
string | boolean
```

## default

```jsonc
null
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

最大預先載入檔案數。

## type

```ts
integer
```

## default

```jsonc
5000
```

# workspace.preloadFileSize

預先載入時跳過大小大於該值（KB）的檔案。

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