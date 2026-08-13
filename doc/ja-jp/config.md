# addonManager.enable

アドオンマネージャーを有効にするかどうか。

## type

```ts
boolean
```

## default

```jsonc
true
```

# addonManager.repositoryBranch

アドオンマネージャーが使用するgitブランチを指定します。

## type

```ts
string
```

## default

```jsonc
""
```

# addonManager.repositoryPath

アドオンマネージャーが使用するgitパスを指定します。

## type

```ts
string
```

## default

```jsonc
""
```

# addonRepositoryPath

アドオンのリポジトリパスを指定します（アドオンマネージャーとは無関係です）。

## type

```ts
string
```

## default

```jsonc
""
```

# codeLens.enable

コードレンズを有効にします。

## type

```ts
boolean
```

## default

```jsonc
false
```

# completion.autoRequire

入力がファイル名のように見える場合、自動的にこのファイルを`require`します。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.callSnippet

関数呼び出しスニペットを表示します。

## type

```ts
string
```

## enum

* ``"Disable"``: 関数名のみを表示します。
* ``"Both"``: 関数名と呼び出しスニペットを表示します。
* ``"Replace"``: 呼び出しスニペットのみを表示します。

## default

```jsonc
"Disable"
```

# completion.displayContext

提案の関連コードスニペットをプレビューすることで、提案の使用法を理解しやすくなります。設定された数値は、コードフラグメント内で切り取られる行数を示します。`0`に設定すると、この機能を無効にできます。

## type

```ts
integer
```

## default

```jsonc
0
```

# completion.enable

補完を有効にします。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.keywordSnippet

キーワード構文スニペットを表示します。

## type

```ts
string
```

## enum

* ``"Disable"``: キーワードのみを表示します。
* ``"Both"``: キーワードと構文スニペットを表示します。
* ``"Replace"``: 構文スニペットのみを表示します。

## default

```jsonc
"Replace"
```

# completion.maxSuggestCount

補完用に分析するフィールドの最大数。オブジェクトがこの制限より多くのフィールドを持つ場合、補完が表示されるにはより具体的な入力が必要になります。

## type

```ts
integer
```

## default

```jsonc
100
```

# completion.postfix

後置提案をトリガーするために使用されるシンボル。

## type

```ts
string
```

## default

```jsonc
"@"
```

# completion.requireSeparator

`require`時に使用される区切り文字。

## type

```ts
string
```

## default

```jsonc
"."
```

# completion.showParams

補完リストにパラメータを表示します。関数に複数の定義がある場合、個別に表示されます。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.showWord

提案内にコンテキストワードを表示します。

## type

```ts
string
```

## enum

* ``"Enable"``: 常に提案内にコンテキストワードを表示します。
* ``"Fallback"``: セマンティックスに基づく提案を提供できない場合のみ、コンテキストワードを表示します。
* ``"Disable"``: コンテキストワードを表示しません。

## default

```jsonc
"Fallback"
```

# completion.workspaceWord

表示されるコンテキストワードにワークスペース内の他のファイルの内容を含めるかどうか。

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.disable

無効化する診断（ホバーの括弧内に表示されるコードを使用）。

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

診断を有効にします。

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

定義済みのグローバル変数。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.globalsRegex

正規表現で定義済みのグローバル変数を検索します。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.groupFileStatus

グループ内の診断対象ファイル状態を変更します。

* Opened: 開いているファイルのみを診断
* Any:    すべてのファイルを診断
* None:   この診断を無効化

`Fallback` は、このグループ内の診断が個別に `diagnostics.neededFileStatus` によって制御されることを意味します。
その他の設定は、末尾に `!` が付いていない個別の設定を上書きします。


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

グループ内の診断の重大度を変更します。
`Fallback` は、このグループ内の診断が個別に `diagnostics.severity` によって制御されることを意味します。
その他の設定は、末尾に `!` が付いていない個別の設定を上書きします。


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

無視されているファイルをどのように診断するか。

## type

```ts
string
```

## enum

* ``"Enable"``: 常にこれらのファイルを診断します。
* ``"Opened"``: これらのファイルが開かれているときのみ診断します。
* ``"Disable"``: これらのファイルは診断しません。

## default

```jsonc
"Opened"
```

# diagnostics.libraryFiles

`Lua.workspace.library` 経由で読み込まれたファイルをどのように診断するか。

## type

```ts
string
```

## enum

* ``"Enable"``: 常にこれらのファイルを診断します。
* ``"Opened"``: これらのファイルが開かれているときのみ診断します。
* ``"Disable"``: これらのファイルは診断しません。

## default

```jsonc
"Opened"
```

# diagnostics.neededFileStatus

* Opened: 開いているファイルのみを診断
* Any:    すべてのファイルを診断
* None:   この診断を無効化

末尾に `!` を付けると、グループ設定 `diagnostics.groupFileStatus` を上書きします。


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
    演算子優先順位のあいまいさ診断を有効にします。例: `num or 0 + 1` には `(num or 0) + 1` を推奨します。
    */
    "ambiguity-1": "Any",
    /*
    値の型が代入先の型と一致しない代入の診断を有効にします。
    */
    "assign-type-mismatch": "Opened",
    /*
    同期関数内で非同期関数を呼び出す場合の診断を有効にします。
    */
    "await-in-sync": "None",
    /*
    ローカル変数のキャスト先の型が定義と一致しない場合の診断を有効にします。
    */
    "cast-local-type": "Opened",
    /*
    キャスト先の型が元の型と一致しない場合の診断を有効にします。
    */
    "cast-type-mismatch": "Opened",
    "circle-doc-class": "Any",
    /*
    オブジェクト以外を閉じようとする場合の診断を有効にします。
    */
    "close-non-object": "Any",
    /*
    ループ内で`break`の後に配置されたコードの診断を有効にします。
    */
    "code-after-break": "Opened",
    /*
    スタイルに合わない行の診断を有効にします。
    */
    "codestyle-check": "None",
    /*
    減少しないため上限に到達しない `for` ループの診断を有効にします。
    */
    "count-down-loop": "Any",
    /*
    非推奨APIを強調する診断を有効にします。
    */
    "deprecated": "Any",
    /*
    異なるパスで同じファイルをrequireする場合の診断を有効にします。
    */
    "different-requires": "Any",
    /*
    `---@nodiscard` が付いた関数の戻り値を無視した呼び出しの診断を有効にします。
    */
    "discard-returns": "Any",
    /*
    クラス注釈なしでフィールド注釈がある場合の診断を有効にします。
    */
    "doc-field-no-class": "Any",
    /*
    エイリアス注釈名の重複診断を有効にします。
    */
    "duplicate-doc-alias": "Any",
    /*
    フィールド注釈名の重複診断を有効にします。
    */
    "duplicate-doc-field": "Any",
    /*
    パラメータ注釈名の重複診断を有効にします。
    */
    "duplicate-doc-param": "Any",
    /*
    重複したテーブルインデックスの診断を有効にします。
    */
    "duplicate-index": "Any",
    /*
    クラス内で同じフィールドを複数回設定する診断を有効にします。
    */
    "duplicate-set-field": "Opened",
    /*
    空のコードブロック診断を有効にします。
    */
    "empty-block": "Opened",
    /*
    グローバル要素に関する警告診断を有効にします。
    */
    "global-element": "None",
    /*
    グローバル変数を使用できない（`_ENV` が `nil`）場合の診断を有効にします。
    */
    "global-in-nil-env": "Any",
    /*
    関数の @param または @return 注釈が不完全な場合の診断。
    */
    "incomplete-signature-doc": "None",
    "inject-field": "Opened",
    /*
    不可視フィールドへのアクセス診断を有効にします。
    */
    "invisible": "Any",
    /*
    先頭小文字のグローバル変数定義の診断を有効にします。
    */
    "lowercase-global": "Any",
    "missing-fields": "Any",
    /*
    グローバル関数の注釈不足の診断。コメントと全パラメータ・戻り値の注釈が必要です。
    */
    "missing-global-doc": "None",
    /*
    エクスポートされたローカル関数の注釈不足の診断。
    */
    "missing-local-export-doc": "None",
    /*
    注釈パラメータ数より少ない引数で関数を呼び出した場合の診断を有効にします。
    */
    "missing-parameter": "Any",
    /*
    戻り注釈があるのにreturn文がない場合の診断を有効にします。
    */
    "missing-return": "Any",
    /*
    戻り値を宣言しているのに値を返さないreturn文の診断を有効にします。
    */
    "missing-return-value": "Any",
    /*
    名前スタイルの診断を有効にします。
    */
    "name-style-check": "None",
    /*
    以前に`nil`または任意型が代入された変数を使用する際のnilチェック診断を有効にします。
    */
    "need-check-nil": "Opened",
    /*
    newfield 呼び出しの診断を有効にします。テーブル定義中に関数呼び出しの括弧が次の行に現れる場合に発生します。
    */
    "newfield-call": "Any",
    /*
    改行呼び出しの診断を有効にします。`(` で始まる行が前の行への関数呼び出しとして構文解析される場合に発生します。
    */
    "newline-call": "Any",
    /*
    型を推論できない場合の診断を有効にします。
    */
    "no-unknown": "None",
    /*
    許可されない場所での`coroutine.yield()`呼び出しの診断を有効にします。
    */
    "not-yieldable": "None",
    /*
    注釈の型と一致しない引数を渡した場合の診断を有効にします。
    */
    "param-type-mismatch": "Opened",
    /*
    ローカル変数の再定義診断を有効にします。
    */
    "redefined-local": "Opened",
    /*
    冗長な関数パラメータの診断を有効にします。
    */
    "redundant-parameter": "Any",
    /*
    不要なreturn文の診断を有効にします。
    */
    "redundant-return": "Opened",
    /*
    注釈にない追加の戻り値を返すreturn文の診断を有効にします。
    */
    "redundant-return-value": "Any",
    /*
    代入時の余分な値の診断を有効にします。値の数が変数の数を超える場合に発生します。
    */
    "redundant-value": "Any",
    /*
    戻り値の型が注釈と一致しない場合の診断を有効にします。
    */
    "return-type-mismatch": "Opened",
    /*
    文字列内のタイポ診断を有効にします。
    */
    "spell-check": "None",
    /*
    行末の余分な空白の診断を有効にします。
    */
    "trailing-space": "Opened",
    /*
    多重代入で一部の変数が値を得られない場合の診断を有効にします（例: `local x,y = 1`）。
    */
    "unbalanced-assignments": "Any",
    /*
    未定義クラスを参照するクラス注釈の診断を有効にします。
    */
    "undefined-doc-class": "Any",
    /*
    未定義の型またはエイリアスを参照する注釈の診断を有効にします。
    */
    "undefined-doc-name": "Any",
    /*
    関数定義に存在しないパラメータへの注釈の診断を有効にします。
    */
    "undefined-doc-param": "Any",
    /*
    未定義環境変数の診断を有効にします。`_ENV` を新しいリテラルテーブルに設定した結果、使用中のグローバルが存在しない場合に発生します。
    */
    "undefined-env-child": "Any",
    /*
    未定義フィールドを参照する場合の診断を有効にします。
    */
    "undefined-field": "Opened",
    /*
    未定義のグローバル変数の診断を有効にします。
    */
    "undefined-global": "Any",
    /*
    未定義変数へのキャスト診断を有効にします。
    */
    "unknown-cast-variable": "Any",
    /*
    不明な診断コードが入力された場合の診断を有効にします。
    */
    "unknown-diag-code": "Any",
    /*
    不明な演算子の診断を有効にします。
    */
    "unknown-operator": "Any",
    /*
    到達不能コードの診断を有効にします。
    */
    "unreachable-code": "Opened",
    /*
    未使用の関数の診断を有効にします。
    */
    "unused-function": "Opened",
    /*
    未使用ラベルの診断を有効にします。
    */
    "unused-label": "Opened",
    /*
    未使用のローカル変数の診断を有効にします。
    */
    "unused-local": "Opened",
    /*
    未使用の可変引数の診断を有効にします。
    */
    "unused-vararg": "Opened"
}
```

# diagnostics.severity

診断の重大度を変更します。

末尾に `!` を付けると、グループ設定 `diagnostics.groupSeverity` を上書きします。


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
    演算子優先順位のあいまいさ診断を有効にします。例: `num or 0 + 1` には `(num or 0) + 1` を推奨します。
    */
    "ambiguity-1": "Warning",
    /*
    値の型が代入先の型と一致しない代入の診断を有効にします。
    */
    "assign-type-mismatch": "Warning",
    /*
    同期関数内で非同期関数を呼び出す場合の診断を有効にします。
    */
    "await-in-sync": "Warning",
    /*
    ローカル変数のキャスト先の型が定義と一致しない場合の診断を有効にします。
    */
    "cast-local-type": "Warning",
    /*
    キャスト先の型が元の型と一致しない場合の診断を有効にします。
    */
    "cast-type-mismatch": "Warning",
    "circle-doc-class": "Warning",
    /*
    オブジェクト以外を閉じようとする場合の診断を有効にします。
    */
    "close-non-object": "Warning",
    /*
    ループ内で`break`の後に配置されたコードの診断を有効にします。
    */
    "code-after-break": "Hint",
    /*
    スタイルに合わない行の診断を有効にします。
    */
    "codestyle-check": "Warning",
    /*
    減少しないため上限に到達しない `for` ループの診断を有効にします。
    */
    "count-down-loop": "Warning",
    /*
    非推奨APIを強調する診断を有効にします。
    */
    "deprecated": "Warning",
    /*
    異なるパスで同じファイルをrequireする場合の診断を有効にします。
    */
    "different-requires": "Warning",
    /*
    `---@nodiscard` が付いた関数の戻り値を無視した呼び出しの診断を有効にします。
    */
    "discard-returns": "Warning",
    /*
    クラス注釈なしでフィールド注釈がある場合の診断を有効にします。
    */
    "doc-field-no-class": "Warning",
    /*
    エイリアス注釈名の重複診断を有効にします。
    */
    "duplicate-doc-alias": "Warning",
    /*
    フィールド注釈名の重複診断を有効にします。
    */
    "duplicate-doc-field": "Warning",
    /*
    パラメータ注釈名の重複診断を有効にします。
    */
    "duplicate-doc-param": "Warning",
    /*
    重複したテーブルインデックスの診断を有効にします。
    */
    "duplicate-index": "Warning",
    /*
    クラス内で同じフィールドを複数回設定する診断を有効にします。
    */
    "duplicate-set-field": "Warning",
    /*
    空のコードブロック診断を有効にします。
    */
    "empty-block": "Hint",
    /*
    グローバル要素に関する警告診断を有効にします。
    */
    "global-element": "Warning",
    /*
    グローバル変数を使用できない（`_ENV` が `nil`）場合の診断を有効にします。
    */
    "global-in-nil-env": "Warning",
    /*
    関数の @param または @return 注釈が不完全な場合の診断。
    */
    "incomplete-signature-doc": "Warning",
    "inject-field": "Warning",
    /*
    不可視フィールドへのアクセス診断を有効にします。
    */
    "invisible": "Warning",
    /*
    先頭小文字のグローバル変数定義の診断を有効にします。
    */
    "lowercase-global": "Information",
    "missing-fields": "Warning",
    /*
    グローバル関数の注釈不足の診断。コメントと全パラメータ・戻り値の注釈が必要です。
    */
    "missing-global-doc": "Warning",
    /*
    エクスポートされたローカル関数の注釈不足の診断。
    */
    "missing-local-export-doc": "Warning",
    /*
    注釈パラメータ数より少ない引数で関数を呼び出した場合の診断を有効にします。
    */
    "missing-parameter": "Warning",
    /*
    戻り注釈があるのにreturn文がない場合の診断を有効にします。
    */
    "missing-return": "Warning",
    /*
    戻り値を宣言しているのに値を返さないreturn文の診断を有効にします。
    */
    "missing-return-value": "Warning",
    /*
    名前スタイルの診断を有効にします。
    */
    "name-style-check": "Warning",
    /*
    以前に`nil`または任意型が代入された変数を使用する際のnilチェック診断を有効にします。
    */
    "need-check-nil": "Warning",
    /*
    newfield 呼び出しの診断を有効にします。テーブル定義中に関数呼び出しの括弧が次の行に現れる場合に発生します。
    */
    "newfield-call": "Warning",
    /*
    改行呼び出しの診断を有効にします。`(` で始まる行が前の行への関数呼び出しとして構文解析される場合に発生します。
    */
    "newline-call": "Warning",
    /*
    型を推論できない場合の診断を有効にします。
    */
    "no-unknown": "Warning",
    /*
    許可されない場所での`coroutine.yield()`呼び出しの診断を有効にします。
    */
    "not-yieldable": "Warning",
    /*
    注釈の型と一致しない引数を渡した場合の診断を有効にします。
    */
    "param-type-mismatch": "Warning",
    /*
    ローカル変数の再定義診断を有効にします。
    */
    "redefined-local": "Hint",
    /*
    冗長な関数パラメータの診断を有効にします。
    */
    "redundant-parameter": "Warning",
    /*
    不要なreturn文の診断を有効にします。
    */
    "redundant-return": "Hint",
    /*
    注釈にない追加の戻り値を返すreturn文の診断を有効にします。
    */
    "redundant-return-value": "Warning",
    /*
    代入時の余分な値の診断を有効にします。値の数が変数の数を超える場合に発生します。
    */
    "redundant-value": "Warning",
    /*
    戻り値の型が注釈と一致しない場合の診断を有効にします。
    */
    "return-type-mismatch": "Warning",
    /*
    文字列内のタイポ診断を有効にします。
    */
    "spell-check": "Information",
    /*
    行末の余分な空白の診断を有効にします。
    */
    "trailing-space": "Hint",
    /*
    多重代入で一部の変数が値を得られない場合の診断を有効にします（例: `local x,y = 1`）。
    */
    "unbalanced-assignments": "Warning",
    /*
    未定義クラスを参照するクラス注釈の診断を有効にします。
    */
    "undefined-doc-class": "Warning",
    /*
    未定義の型またはエイリアスを参照する注釈の診断を有効にします。
    */
    "undefined-doc-name": "Warning",
    /*
    関数定義に存在しないパラメータへの注釈の診断を有効にします。
    */
    "undefined-doc-param": "Warning",
    /*
    未定義環境変数の診断を有効にします。`_ENV` を新しいリテラルテーブルに設定した結果、使用中のグローバルが存在しない場合に発生します。
    */
    "undefined-env-child": "Information",
    /*
    未定義フィールドを参照する場合の診断を有効にします。
    */
    "undefined-field": "Warning",
    /*
    未定義のグローバル変数の診断を有効にします。
    */
    "undefined-global": "Warning",
    /*
    未定義変数へのキャスト診断を有効にします。
    */
    "unknown-cast-variable": "Warning",
    /*
    不明な診断コードが入力された場合の診断を有効にします。
    */
    "unknown-diag-code": "Warning",
    /*
    不明な演算子の診断を有効にします。
    */
    "unknown-operator": "Warning",
    /*
    到達不能コードの診断を有効にします。
    */
    "unreachable-code": "Hint",
    /*
    未使用の関数の診断を有効にします。
    */
    "unused-function": "Hint",
    /*
    未使用ラベルの診断を有効にします。
    */
    "unused-label": "Hint",
    /*
    未使用のローカル変数の診断を有効にします。
    */
    "unused-local": "Hint",
    /*
    未使用の可変引数の診断を有効にします。
    */
    "unused-vararg": "Hint"
}
```

# diagnostics.unusedLocalExclude

変数名が次のパターンに一致する場合、`unused-local` を診断しません。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.workspaceDelay

ワークスペース診断の待ち時間（ミリ秒）。

## type

```ts
integer
```

## default

```jsonc
3000
```

# diagnostics.workspaceEvent

ワークスペース診断をトリガーするタイミングを設定します。

## type

```ts
string
```

## enum

* ``"OnChange"``: ファイルが変更されたときにワークスペース診断をトリガーします。
* ``"OnSave"``: ファイルが保存されたときにワークスペース診断をトリガーします。
* ``"None"``: ワークスペース診断を無効にします。

## default

```jsonc
"OnSave"
```

# diagnostics.workspaceRate

ワークスペース診断の実行レート（％）。この値を下げると CPU 使用率は低下しますが、ワークスペース診断の速度も低下します。現在編集中のファイルの診断は常に全速で行われ、この設定の影響を受けません。

## type

```ts
integer
```

## default

```jsonc
100
```

# doc.packageName

特定のフィールド名をパッケージとして扱います。例: `m_*` は `XXX.m_id` や `XXX.m_type` がパッケージであり、定義されているファイル内でのみアクセス可能です。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.privateName

特定のフィールド名をプライベートとして扱います。例: `m_*` は `XXX.m_id` や `XXX.m_type` がプライベートであり、定義されているクラス内でのみアクセス可能です。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.protectedName

特定のフィールド名をプロテクトとして扱います。例: `m_*` は `XXX.m_id` や `XXX.m_type` がプロテクトであり、定義クラスおよびそのサブクラスでのみアクセス可能です。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.regengine

ドキュメントスコープ名のマッチに使用する正規表現エンジン。

## type

```ts
string
```

## enum

* ``"glob"``: デフォルトの軽量パターン構文。
* ``"lua"``: Luaスタイルの正規表現（フル機能）。

## default

```jsonc
"glob"
```

# docScriptPath

ドキュメントスコープ名のマッチに使用する正規表現エンジン。

## type

```ts
string
```

## default

```jsonc
""
```

# format.defaultConfig

デフォルトのフォーマット設定。ワークスペース内の`.editorconfig`ファイルより優先度が低くなります。
[formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) を参照してください。


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# format.enable

コードフォーマッタを有効にします。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.arrayIndex

テーブル構築時に配列インデックスのヒントを表示します。

## type

```ts
string
```

## enum

* ``"Enable"``: すべてのテーブルでヒントを表示します。
* ``"Auto"``: テーブルが3要素を超える、または混在テーブルの場合のみヒントを表示します。
* ``"Disable"``: 配列インデックスのヒントを無効にします。

## default

```jsonc
"Auto"
```

# hint.await

呼び出す関数に `---@async` が付いている場合、呼び出し箇所で `await` を提案します。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.awaitPropagate

`await` の伝播を有効にします。`---@async` が付いた関数を呼び出す関数は、自動的に `---@async` とマークされます。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.enable

インレイヒントを有効にします。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.paramName

関数呼び出し時にパラメータ名のヒントを表示します。

## type

```ts
string
```

## enum

* ``"All"``: すべての型のパラメータを表示します。
* ``"Literal"``: リテラル型のパラメータのみを表示します。
* ``"Disable"``: パラメータヒントを無効にします。

## default

```jsonc
"All"
```

# hint.paramType

関数のパラメータに型ヒントを表示します。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.semicolon

文末にセミコロンがない場合に仮想セミコロンを表示します。

## type

```ts
string
```

## enum

* ``"All"``: すべての文で仮想セミコロンを表示します。
* ``"SameLine"``: 同じ行に2つの文がある場合、その間にセミコロンを表示します。
* ``"Disable"``: 仮想セミコロンを無効にします。

## default

```jsonc
"SameLine"
```

# hint.setType

代入操作で型ヒントを表示します。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hover.enable

ホバーを有効にします。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.enumsLimit

値が複数の型に対応する場合、表示される型の数を制限します。

## type

```ts
integer
```

## default

```jsonc
5
```

# hover.expandAlias

エイリアスを展開するかどうか。たとえば、`---@alias myType boolean|number`を展開すると`boolean|number`として表示され、そうでない場合は`myType`として表示されます。


## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.previewFields

テーブルをホバーで表示する際、フィールドのプレビューの最大数を制限します。

## type

```ts
integer
```

## default

```jsonc
10
```

# hover.viewNumber

ホバーで数値内容を表示します（リテラルが10進数でない場合のみ）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewString

ホバーで文字列の内容を表示します（リテラルにエスケープ文字が含まれている場合のみ）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewStringMax

ホバーで表示する文字列内容の最大長。

## type

```ts
integer
```

## default

```jsonc
1000
```

# language.completeAnnotation

(VSCodeのみ) 注釈行の改行後に自動で "---@ " を挿入します。

## type

```ts
boolean
```

## default

```jsonc
true
```

# language.fixIndent

(VSCodeのみ) 誤った自動インデントを修正します。例えば、"function" を含む文字列内で改行したときの不正なインデントなど。

## type

```ts
boolean
```

## default

```jsonc
true
```

# misc.executablePath

VSCodeでの実行可能ファイルのパスを指定します。

## type

```ts
string
```

## default

```jsonc
""
```

# misc.parameters

VSCode で言語サーバーを起動するときの[コマンドライン引数](https://github.com/LuaLS/lua-telemetry-server/tree/master/method)。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# nameStyle.config

命名スタイル設定。
[formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) を参照してください。


## type

```ts
Object<string, string | array>
```

## default

```jsonc
{}
```

# runtime.builtin

組み込みライブラリの有効状態を調整します。実際のランタイム環境に応じて、存在しないライブラリを無効化（または再定義）できます。

* `default`: ランタイムバージョンに応じてライブラリを有効／無効にします
* `enable`: 常に有効
* `disable`: 常に無効


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

LuaJIT 拡張構文を有効にします（`Lua.runtime.version` を `LuaJIT` に設定する必要があります）。
各拡張構文は `Lua.runtime.nonstandardSymbol` で個別に有効化することもできます。


## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.fileEncoding

ファイルのエンコーディング。`ansi` オプションは `Windows` プラットフォームでのみ利用可能です。

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

メタファイルのディレクトリ名の形式。

## type

```ts
string
```

## default

```jsonc
"${version} ${language} ${encoding}"
```

# runtime.nonstandardSymbol

非標準の記号をサポートします。ランタイム環境がこれらの記号をサポートしていることを確認してください。

LuaJIT 3.0 拡張構文（`?.` `??` `?:` `~>>` `~>>=` `..=` `~=` `const` `->` `number_underscore`）も個別に有効化できます。`Lua.runtime.version` を `LuaJIT` にする必要はありません。注意：`~=` は文コンテキスト（例：`a ~= b` が単独の行）でのみビット排他的論理和の複合代入として機能し、式の中では「等しくない」演算子のままです。


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
* ``"?."``: 安全ナビゲーション（`a?.b` / `a?.[k]` / `f?.()` / `obj?.:method()` / `obj:method?.()`）。
* ``"??"``: nil 合体（`a ?? b`。左辺が nil の場合のみ右辺を返す）。
* ``"?:"``: 三項演算子（`a ? b : c`、右結合）。
* ``"~>>"``: 算術右シフト（`a ~>> b`。LuaJIT 固有。通常の `>>` は論理右シフト）。
* ``"~>>="``: 算術右シフト複合代入（`a ~>>= b`）。
* ``"..="``: 文字列連結複合代入（`a ..= b`）。
* ``"~="``: XOR 複合代入：文コンテキスト（例：`a ~= b` が単独の行）でのみ有効。式の中では「等しくない」のまま。
* ``"const"``: `const` 宣言（ブロックスコープのローカル定数。再代入・再宣言不可）。
* ``"->"``: 短い関数の矢印（`x -> expr` / `|x| -> expr` / `|| -> expr` / `-> do ... end`）。
* ``"number_underscore"``: 数値リテラルのアンダースコア（例：`1_000`、`0x1_2`、`0b1_0`）。
* ``"?("``: ドットなしオプショナル呼び出し（`f?()` は `f?.()` と同等。三項 `?:` の解析と競合するため併用非推奨）。
* ``"?["``: ドットなしオプショナルインデックス（`t?[1]` は `t?.[1]` と同等。三項 `?:` の解析と競合するため併用非推奨）。

## default

```jsonc
[]
```

# runtime.path

`require` を使用する際、入力名に基づいてファイルを探す方法。
この設定を `?/init.lua` にすると、`require 'myfile'` と入力したとき、読み込まれたファイルから `${workspace}/myfile/init.lua` が検索されます。
`runtime.pathStrict` が `false` の場合、`${workspace}/**/myfile/init.lua` も検索対象になります。
ワークスペース外のファイルを読み込みたい場合は、先に `Lua.workspace.library` を設定する必要があります。


## type

```ts
Array<string>
```

## default

```jsonc
["?.lua","?/init.lua"]
```

# runtime.pathStrict

有効にすると、`runtime.path` は最上位のディレクトリ階層のみを検索します。詳細は `runtime.path` の説明を参照してください。

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.plugin

プラグインのパス。詳細は [wiki](https://luals.github.io/wiki/plugins) を参照してください。

## type

```ts
string | array
```

## default

```jsonc
null
```

# runtime.pluginArgs

プラグインに渡す追加引数。

## type

```ts
array | object
```

## default

```jsonc
null
```

# runtime.special

カスタムのグローバル変数を一部の特別な組み込み変数として扱い、言語サーバーが特別なサポートを提供します。
以下の例では、`include` を `require` として扱います。
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

名前に Unicode 文字を使用できるようにします。

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.version

Lua のランタイムバージョン。

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

型注釈のセマンティックカラーリング。

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.enable

セマンティックカラーを有効にします。効果を発揮するために`editor.semanticHighlighting.enabled`を`true`に設定する必要があるかもしれません。

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.keyword

キーワード/リテラル/演算子のセマンティックカラーリング。エディタが構文カラーリングをできない場合のみ、この機能を有効にする必要があります。

## type

```ts
boolean
```

## default

```jsonc
false
```

# semantic.variable

変数/フィールド/パラメータのセマンティックカラーリング。

## type

```ts
boolean
```

## default

```jsonc
true
```

# signatureHelp.enable

シグネチャヘルプを有効にします。

## type

```ts
boolean
```

## default

```jsonc
true
```

# spell.dict

スペルチェック用のカスタム単語。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# type.castNumberToInteger

`number` 型を `integer` 型に代入することを許可します。

## type

```ts
boolean
```

## default

```jsonc
true
```

# type.checkTableShape

テーブルの形状を厳密にチェックします。


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.inferParamType

パラメータ型が注釈されていない場合、関数の呼び出し箇所から推論します。

この設定が`false`の場合、注釈がないパラメータの型は`any`になります。


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.inferTableSize

型推論時に解析するテーブルフィールドの最大数。

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

共用体型のチェック時に、その中の`nil`を無視します。

この設定が`false`の場合、`number|nil`型は`number`型に代入できません。`true`の場合は可能です。


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.weakUnionCheck

共用体型のどれか1つのサブタイプが条件を満たせば、共用体全体も条件を満たします。

この設定が`false`の場合、`number|boolean`型は`number`型に代入できません。`true`の場合は可能です。


## type

```ts
boolean
```

## default

```jsonc
false
```

# typeFormat.config

Luaコード入力中のフォーマット動作を設定します。

## type

```ts
object<string, string>
```

## default

```jsonc
{
    /*
    適切な位置で`end`を自動補完するかを制御します。
    */
    "auto_complete_end": "true",
    /*
    テーブル宣言末尾にセパレータを自動付与するかを制御します。
    */
    "auto_complete_table_sep": "true",
    /*
    行を自動整形するかどうかを制御します。
    */
    "format_line": "true"
}
```

# window.progressBar

ステータスバーに進行状況バーを表示します。

## type

```ts
boolean
```

## default

```jsonc
true
```

# window.statusBar

ステータスバーに拡張機能のステータスを表示します。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.checkThirdParty

サードパーティライブラリの自動検出と適応。現在サポートされているライブラリ：

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

無視するファイルとディレクトリ（`.gitignore` の構文を使用）。

## type

```ts
Array<string>
```

## default

```jsonc
[".vscode"]
```

# workspace.ignoreSubmodules

サブモジュールを無視します。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.library

現在のワークスペースに加えて、どのディレクトリからファイルをロードするか。これらのディレクトリ内のファイルは外部提供のコードライブラリとして扱われ、一部の機能（フィールド名の変更など）はこれらのファイルを変更しません。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# workspace.maxPreload

プリロードする最大ファイル数。

## type

```ts
integer
```

## default

```jsonc
5000
```

# workspace.preloadFileSize

プリロード時にこの値（KB）より大きいファイルをスキップします。

## type

```ts
integer
```

## default

```jsonc
500
```

# workspace.useGitIgnore

`.gitignore` に記載されたファイルを無視します。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.userThirdParty

プライベートサードパーティライブラリの設定ファイルパスをここに追加してください。組み込みの[設定ファイルパス](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)を参照してください。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```