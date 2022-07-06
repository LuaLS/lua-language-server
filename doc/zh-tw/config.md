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

* ``"not-yieldable"``
* ``"redundant-parameter"``
* ``"break-outside"``
* ``"undefined-doc-class"``
* ``"unknown-symbol"``
* ``"miss-method"``
* ``"err-nonstandard-symbol"``
* ``"unknown-attribute"``
* ``"unexpect-efunc-name"``
* ``"different-requires"``
* ``"miss-end"``
* ``"await-in-sync"``
* ``"args-after-dots"``
* ``"err-eq-as-assign"``
* ``"newfield-call"``
* ``"err-assign-as-eq"``
* ``"undefined-doc-param"``
* ``"param-type-mismatch"``
* ``"global-in-nil-env"``
* ``"unused-vararg"``
* ``"miss-sep-in-table"``
* ``"unknown-cast-variable"``
* ``"unknown-operator"``
* ``"malformed-number"``
* ``"err-do-as-then"``
* ``"spell-check"``
* ``"undefined-env-child"``
* ``"missing-return-value"``
* ``"discard-returns"``
* ``"redundant-return"``
* ``"miss-esc-x"``
* ``"redundant-value"``
* ``"duplicate-doc-alias"``
* ``"doc-field-no-class"``
* ``"no-visible-label"``
* ``"miss-loop-min"``
* ``"miss-exp"``
* ``"miss-loop-max"``
* ``"miss-name"``
* ``"empty-block"``
* ``"unused-local"``
* ``"err-then-as-do"``
* ``"duplicate-doc-field"``
* ``"redefined-label"``
* ``"exp-in-action"``
* ``"set-const"``
* ``"circle-doc-class"``
* ``"unexpect-lfunc-name"``
* ``"unsupport-symbol"``
* ``"unused-label"``
* ``"action-after-return"``
* ``"unexpect-dots"``
* ``"redundant-return-value"``
* ``"jump-local-scope"``
* ``"close-non-object"``
* ``"miss-field"``
* ``"count-down-loop"``
* ``"cast-type-mismatch"``
* ``"newline-call"``
* ``"unexpect-symbol"``
* ``"block-after-else"``
* ``"unicode-name"``
* ``"miss-exponent"``
* ``"err-esc"``
* ``"local-limit"``
* ``"trailing-space"``
* ``"err-c-long-comment"``
* ``"undefined-global"``
* ``"undefined-doc-name"``
* ``"ambiguity-1"``
* ``"deprecated"``
* ``"codestyle-check"``
* ``"missing-return"``
* ``"missing-parameter"``
* ``"unused-function"``
* ``"cast-local-type"``
* ``"assign-type-mismatch"``
* ``"duplicate-set-field"``
* ``"no-unknown"``
* ``"need-check-nil"``
* ``"keyword"``
* ``"unknown-diag-code"``
* ``"return-type-mismatch"``
* ``"err-comment-prefix"``
* ``"lowercase-global"``
* ``"unbalanced-assignments"``
* ``"redefined-local"``
* ``"code-after-break"``
* ``"duplicate-index"``
* ``"duplicate-doc-param"``
* ``"index-in-func-name"``
* ``"miss-symbol"``
* ``"undefined-field"``
* ``"miss-space-between"``

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
    * spell-check
    */
    "codestyle": "Fallback",
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
    * cast-type-mismatch
    * circle-doc-class
    * doc-field-no-class
    * duplicate-doc-alias
    * duplicate-doc-field
    * duplicate-doc-param
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
    * spell-check
    */
    "codestyle": "Fallback",
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
    * cast-type-mismatch
    * circle-doc-class
    * doc-field-no-class
    * duplicate-doc-alias
    * duplicate-doc-field
    * duplicate-doc-param
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
    "assign-type-mismatch": "Opened",
    "await-in-sync": "None",
    "cast-local-type": "Opened",
    "cast-type-mismatch": "Any",
    "circle-doc-class": "Any",
    "close-non-object": "Any",
    "code-after-break": "Opened",
    "codestyle-check": "None",
    "count-down-loop": "Any",
    "deprecated": "Any",
    "different-requires": "Any",
    "discard-returns": "Any",
    "doc-field-no-class": "Any",
    "duplicate-doc-alias": "Any",
    "duplicate-doc-field": "Any",
    "duplicate-doc-param": "Any",
    /*
    在字面常數表中重複定義了索引
    */
    "duplicate-index": "Any",
    "duplicate-set-field": "Any",
    /*
    空程式碼區塊
    */
    "empty-block": "Opened",
    /*
    不能使用全域變數（ `_ENV` 被設定為 `nil`）
    */
    "global-in-nil-env": "Any",
    /*
    首字母小寫的全域變數定義
    */
    "lowercase-global": "Any",
    "missing-parameter": "Any",
    "missing-return": "Any",
    "missing-return-value": "Any",
    "need-check-nil": "Opened",
    /*
    在字面常數表中，2行程式碼之間缺少分隔符，在語法上被解析為了一次索引操作
    */
    "newfield-call": "Any",
    /*
    以 `(` 開始的新行，在語法上被解析為了上一行的函式呼叫
    */
    "newline-call": "Any",
    "no-unknown": "None",
    "not-yieldable": "None",
    "param-type-mismatch": "Opened",
    /*
    重複定義的區域變數
    */
    "redefined-local": "Opened",
    /*
    函式呼叫時，傳入了多餘的引數
    */
    "redundant-parameter": "Any",
    "redundant-return": "Opened",
    "redundant-return-value": "Any",
    /*
    賦值操作時，值的數量比被賦值的對象多
    */
    "redundant-value": "Any",
    "return-type-mismatch": "Opened",
    "spell-check": "None",
    /*
    後置空格
    */
    "trailing-space": "Opened",
    "unbalanced-assignments": "Any",
    "undefined-doc-class": "Any",
    "undefined-doc-name": "Any",
    "undefined-doc-param": "Any",
    /*
    `_ENV` 被設定為了新的字面常數表，但是試圖獲取的全域變數不在這張表中
    */
    "undefined-env-child": "Any",
    "undefined-field": "Opened",
    /*
    未定義的全域變數
    */
    "undefined-global": "Any",
    "unknown-cast-variable": "Any",
    "unknown-diag-code": "Any",
    "unknown-operator": "Any",
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
    "assign-type-mismatch": "Warning",
    "await-in-sync": "Warning",
    "cast-local-type": "Warning",
    "cast-type-mismatch": "Warning",
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
    /*
    在字面常數表中重複定義了索引
    */
    "duplicate-index": "Warning",
    "duplicate-set-field": "Warning",
    /*
    空程式碼區塊
    */
    "empty-block": "Hint",
    /*
    不能使用全域變數（ `_ENV` 被設定為 `nil`）
    */
    "global-in-nil-env": "Warning",
    /*
    首字母小寫的全域變數定義
    */
    "lowercase-global": "Information",
    "missing-parameter": "Warning",
    "missing-return": "Warning",
    "missing-return-value": "Warning",
    "need-check-nil": "Warning",
    /*
    在字面常數表中，2行程式碼之間缺少分隔符，在語法上被解析為了一次索引操作
    */
    "newfield-call": "Warning",
    /*
    以 `(` 開始的新行，在語法上被解析為了上一行的函式呼叫
    */
    "newline-call": "Warning",
    "no-unknown": "Warning",
    "not-yieldable": "Warning",
    "param-type-mismatch": "Warning",
    /*
    重複定義的區域變數
    */
    "redefined-local": "Hint",
    /*
    函式呼叫時，傳入了多餘的引數
    */
    "redundant-parameter": "Warning",
    "redundant-return": "Hint",
    "redundant-return-value": "Warning",
    /*
    賦值操作時，值的數量比被賦值的對象多
    */
    "redundant-value": "Warning",
    "return-type-mismatch": "Warning",
    "spell-check": "Information",
    /*
    後置空格
    */
    "trailing-space": "Hint",
    "unbalanced-assignments": "Warning",
    "undefined-doc-class": "Warning",
    "undefined-doc-name": "Warning",
    "undefined-doc-param": "Warning",
    /*
    `_ENV` 被設定為了新的字面常數表，但是試圖獲取的全域變數不在這張表中
    */
    "undefined-env-child": "Information",
    "undefined-field": "Warning",
    /*
    未定義的全域變數
    */
    "undefined-global": "Warning",
    "unknown-cast-variable": "Warning",
    "unknown-diag-code": "Warning",
    "unknown-operator": "Warning",
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

# diagnostics.workspaceDelay

進行工作區診斷的延遲（毫秒）。當你啟動工作區，或編輯了任何檔案後，將會在背景對整個工作區進行重新診斷。設定為負數可以停用工作區診斷。

## type

```ts
integer
```

## default

```jsonc
3000
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

# misc.parameters

VSCode中啟動語言伺服時的[命令列參數](https://github.com/sumneko/lua-language-server/wiki/Command-line)。

## type

```ts
Array<string>
```

## default

```jsonc
[]
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
    "math": "default",
    "os": "default",
    "package": "default",
    "string": "default",
    "table": "default",
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

延伸模組路徑，請查閱[文件](https://github.com/sumneko/lua-language-server/wiki/Plugin)瞭解用法。

## type

```ts
string
```

## default

```jsonc
""
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

# telemetry.enable

啟用遙測，透過網路發送你的編輯器資訊與錯誤日誌。在[此處](https://github.com/sumneko/lua-language-server/wiki/%E9%9A%B1%E7%A7%81%E8%81%B2%E6%98%8E)閱讀我們的隱私聲明。


## type

```ts
boolean | null
```

## default

```jsonc
null
```

# type.castNumberToInteger

允許將 `number` 類型賦值給 `integer` 類型。

## type

```ts
boolean
```

## default

```jsonc
false
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
boolean
```

## default

```jsonc
true
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

# workspace.supportScheme

為以下 `scheme` 的lua檔案提供語言伺服。

## type

```ts
Array<string>
```

## default

```jsonc
["file","untitled","git"]
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

在這裡添加私有的第三方庫適應檔案路徑，請參考內建的[組態檔案路徑](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)

## type

```ts
Array<string>
```

## default

```jsonc
[]
```