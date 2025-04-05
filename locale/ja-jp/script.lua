DIAG_LINE_ONLY_SPACE    =
'行に空白文字のみが含まれています。'
DIAG_LINE_POST_SPACE    =
'行末に余分な空白文字があります。'
DIAG_UNUSED_LOCAL       =
'使用されていないローカル変数 `{}`'
DIAG_UNDEF_GLOBAL       =
'グローバル変数 `{}` は未定義です。'
DIAG_UNDEF_FIELD        =
'プロパティ/フィールド `{}` は未定義です。'
DIAG_UNDEF_ENV_CHILD    =
'変数 `{}` は未定義です（`_ENV` オーバーロード）。'
DIAG_UNDEF_FENV_CHILD   =
'変数 `{}` は未定義です（モジュール内）。'
DIAG_GLOBAL_IN_NIL_ENV  =
'グローバル変数は使用できません（`_ENV` が `nil` に設定されています）。'
DIAG_GLOBAL_IN_NIL_FENV =
'グローバル変数は使用できません（モジュール内の環境が `nil` に設定されています）。'
DIAG_UNUSED_LABEL       =
'ラベル `{}` は使用されていません。'
DIAG_UNUSED_FUNCTION    =
'使用されていない関数です。'
DIAG_UNUSED_VARARG      =
'使用されていない可変引数です。'
DIAG_REDEFINED_LOCAL    =
'ローカル変数 `{}` が再定義されています。'
DIAG_DUPLICATE_INDEX    =
'重複したインデックス `{}` があります。'
DIAG_DUPLICATE_METHOD   =
'重複したメソッド `{}` があります。'
DIAG_PREVIOUS_CALL      =
'これは `{}{}` と解釈されます。`,` を追加する必要があるかもしれません。'
DIAG_PREFIELD_CALL      =
'これは `{}{}` と解釈されます。`,` か `;` を追加する必要があるかもしれません。'
DIAG_OVER_MAX_ARGS      =
'この関数は最大で {:d} 個の引数を受け取りますが、{:d} 個の引数が渡されています。'
DIAG_MISS_ARGS          =
'この関数は少なくとも {:d} 個の引数を必要としますが、{:d} 個しか渡されていません。'
DIAG_UNNECESSARY_ASSERT =
'不要なアサーション: この式は常に真です。'
DIAG_OVER_MAX_VALUES    =
'変数は {} 個しかありませんが、{} 個の値が設定されています。'
DIAG_AMBIGUITY_1        =
'`{}` は優先的に評価されます。括弧を追加する必要があるかもしれません。'
DIAG_LOWERCASE_GLOBAL   =
'小文字で始まるグローバル変数です。`local` を忘れているか、スペルミスがある可能性があります。'
DIAG_EMPTY_BLOCK        =
'空のコードブロックです。'
DIAG_DIAGNOSTICS        =
'Lua診断'
DIAG_SYNTAX_CHECK       =
'Lua構文チェック'
DIAG_NEED_VERSION       =
'この機能は {} から有効です。現在のバージョンは {} です。'
DIAG_DEFINED_VERSION    =
'これは {} で定義されていますが、現在のバージョンは {} です。'
DIAG_DEFINED_CUSTOM     =
'これは {} で定義されています。'
DIAG_DUPLICATE_CLASS    =
'クラス `{}` が重複して定義されています。'
DIAG_UNDEFINED_CLASS    =
'クラス `{}` は未定義です。。'
DIAG_CYCLIC_EXTENDS     =
'循環的な継承が発生しています。'
DIAG_INEXISTENT_PARAM   =
'存在しないパラメータです。'
DIAG_DUPLICATE_PARAM    =
'パラメータが重複しています。'
DIAG_NEED_CLASS         =
'クラスを先に定義する必要があります。'
DIAG_DUPLICATE_SET_FIELD=
'フィールド `{}` が重複して定義されています。'
DIAG_SET_CONST          =
'定数に値を設定することはできません。'
DIAG_SET_FOR_STATE      =
'ループ変数を設定しています。'
DIAG_CODE_AFTER_BREAK   =
'`break` の後のコードは実行されません。'
DIAG_UNBALANCED_ASSIGNMENTS =
'値の数が足りないため、`nil` が代入されました。Luaでは `x, y = 1` は `x, y = 1, nil` と同等です。'
DIAG_REQUIRE_LIKE       =
'`{}` を `require` として取り扱うように設定できます。'
DIAG_COSE_NON_OBJECT    =
'このタイプの値はクローズできません。（`__close` メタメソッドを設定しない限り）'
DIAG_COUNT_DOWN_LOOP    =
'もしかして `{}` ？'
DIAG_UNKNOWN            =
'タイプを推測できません。'
DIAG_DEPRECATED         =
'非推薦。'
DIAG_DIFFERENT_REQUIRES =
'同じファイルが異なる名前で require されています。'
DIAG_REDUNDANT_RETURN   =
'冗長な return ステートメントです。'
DIAG_AWAIT_IN_SYNC      =
'非同期関数は、非同期としてマークされた関数内でのみ呼び出すことができます。'
DIAG_NOT_YIELDABLE      =
'この関数の第{}パラメータは譲渡可能としてマークされていませんが、非同期関数が渡されました。（`---@param name async fun()` を使用して譲渡可能としてマークしてください）'
DIAG_DISCARD_RETURNS    =
'この関数の戻り値は破棄できません。'
DIAG_NEED_CHECK_NIL     =
'nil チェックが必要です。'
DIAG_CIRCLE_DOC_CLASS                 =
'循環継承されたクラスです。'
DIAG_DOC_FIELD_NO_CLASS               =
'フィールドはクラスの後に定義しなければなりません。'
DIAG_DUPLICATE_DOC_ALIAS              =
'エイリアス `{}` が重複して定義されています。'
DIAG_DUPLICATE_DOC_FIELD              =
'フィールド `{}` が重複して定義されています。'
DIAG_DUPLICATE_DOC_PARAM              =
'パラメータ `{}` が重複して指されています。'
DIAG_UNDEFINED_DOC_CLASS              =
'クラス `{}` は未定義です。'
DIAG_UNDEFINED_DOC_NAME               =
'タイプまたはエイリアス `{}` は未定義です。'
DIAG_UNDEFINED_DOC_PARAM              =
'パラメータ `{}` は未定義です。'
DIAG_MISSING_GLOBAL_DOC_COMMENT       =
'グローバル関数 `{}` に注釈がありません。'
DIAG_MISSING_GLOBAL_DOC_PARAM         =
'グローバル関数 `{2}` のパラメータ `{1}` に @param 注釈がありません。'
DIAG_MISSING_GLOBAL_DOC_RETURN        =
'グローバル関数 `{2}` の第 `{1}` の戻り値に @return 注釈がありません。'
DIAG_MISSING_LOCAL_EXPORT_DOC_COMMENT  =
'エクスポートされたローカル関数 `{}` に注釈がありません。'
DIAG_MISSING_LOCAL_EXPORT_DOC_PARAM    =
'エクスポートされたローカル関数 `{2}` のパラメータ `{1}` に @param 注釈がありません。'
DIAG_MISSING_LOCAL_EXPORT_DOC_RETURN   =
'エクスポートされたローカル関数 `{2}` の第 {1} の戻り値に @return 注釈がありません。'
DIAG_INCOMPLETE_SIGNATURE_DOC_PARAM   =
'シグネチャが不完全です。パラメータ `{}` に @param 注釈がありません。'
DIAG_INCOMPLETE_SIGNATURE_DOC_RETURN  =
'シグネチャが不完全です。第 {} の戻り値に @return 注釈がありません。'
DIAG_UNKNOWN_DIAG_CODE                =
'診断コード `{}` は不明です。'
DIAG_CAST_LOCAL_TYPE                  =
'変数が `{def}` 型として定義されているため、`{ref}` 型に変換できません。'
DIAG_CAST_FIELD_TYPE                  =
'フィールドが `{def}` 型として定義されているため、`{ref}` 型に変換できません。'
DIAG_ASSIGN_TYPE_MISMATCH             =
'`{ref}` を `{def}` に代入できません。'
DIAG_PARAM_TYPE_MISMATCH              =
'`{ref}` をパラメータ `{def}` に代入できません。'
DIAG_UNKNOWN_CAST_VARIABLE            =
'型変換変数 `{}` は不明です。'
DIAG_CAST_TYPE_MISMATCH               =
'`{def}` を `{ref}` に変換できません。'
DIAG_MISSING_RETURN_VALUE             =
'注釈によると少なくとも {min} 個の戻り値が必要ですが、ここでは {rmax} 個しか返されていません。'
DIAG_MISSING_RETURN_VALUE_RANGE       =
'注釈によると少なくとも {min} 個の戻り値が必要ですが、ここでは {rmin} から {rmax} 個しか返されていません。'
DIAG_REDUNDANT_RETURN_VALUE           =
'注釈によると最大 {max} 個の戻り値しか返せませんが、ここでは {rmax} 個の戻り値が返されています。'
DIAG_REDUNDANT_RETURN_VALUE_RANGE     =
'注釈によると最大 {max} 個の戻り値しか返せませんが、ここでは {rmin} から {rmax} 個の戻り値が返されています。'
DIAG_MISSING_RETURN                   =
'注釈によると戻り値は必要ですが、`return` 文が見つかりません。'
DIAG_RETURN_TYPE_MISMATCH             =
'注釈によると第 {index} の戻り値の型が `{def}` ですが、実際には `{ref}` が返されています。'
DIAG_UNKNOWN_OPERATOR                 =
'演算子 `{}` は不明です。'
DIAG_UNREACHABLE_CODE                 =
'到達不可能なコードです。'
DIAG_INVISIBLE_PRIVATE                =
'フィールド `{field}` は private であり、クラス `{class}` 内でのみアクセスできます。'
DIAG_INVISIBLE_PROTECTED              =
'フィールド `{field}` は private であり、クラス `{class}` およびそのサブクラス内でのみアクセスできます。'
DIAG_INVISIBLE_PACKAGE                =
'フィールド `{field}` は同じファイル `{uri}` 内でのみアクセスできます。'
DIAG_GLOBAL_ELEMENT                   =
'グローバル変数。'
DIAG_MISSING_FIELDS                   =
'タイプ `{1}` に必要なフィールド {2} が不足しています。'
DIAG_INJECT_FIELD                     =
'クラス `{class}` の参照にフィールド `{field}` を注入することはできません。{fix}'
DIAG_INJECT_FIELD_FIX_CLASS           =
'注入を許可するには、`{node}` に `{fix}` を使用してください。'
DIAG_INJECT_FIELD_FIX_TABLE           =
'注入を許可するには、定義に `{fix}` を追加してください。'

MWS_NOT_SUPPORT         =
'現在 {} はマルチワークスペースをサポートしていません。新しいワークスペースを反映するためには再起動が必要になる場合があります。'
MWS_RESTART             =
'再起動'
MWS_NOT_COMPLETE        =
'ワークスペースの準備がまだ完了していません。暫くしてからもう一度お試しください。'
MWS_COMPLETE            =
'ワークスペースの準備が完了しました。再度お試しいただけます。'
MWS_MAX_PRELOAD         =
'プリロードファイルの数が上限（{}）に達しました。読み込む必要のあるファイルを手動で開く必要があります。'
MWS_UCONFIG_FAILED      =
'ユーザー設定の保存に失敗しました。'
MWS_UCONFIG_UPDATED     =
'ユーザー設定が更新されました。'
MWS_WCONFIG_UPDATED     =
'ワークスペース設定が更新されました。'

WORKSPACE_SKIP_LARGE_FILE =
'ファイル {} のサイズが {} KB を超えているため、解析をスキップしました。現在のサイズは {} KB です。'
WORKSPACE_LOADING         =
'ワークスペースを読み込んでいます。'
WORKSPACE_DIAGNOSTIC      =
'ワークスペースの診断を実行しています。'
WORKSPACE_SKIP_HUGE_FILE  =
'パフォーマンスのため、ファイル {} の解析を停止しました。'
WORKSPACE_NOT_ALLOWED     =
'ワークスペースが `{}` に設定されているため、Lua言語サービスがこのディレクトリの読み込みを拒否しました。設定を確認してください。[詳細はこちら](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)'
WORKSPACE_SCAN_TOO_MUCH   =
'{} 個以上のファイルをスキャンしました。現在スキャンしているディレクトリは `{}` です。不要なファイルを除外する方法については、[FAQ](https://luals.github.io/wiki/faq#how-can-i-improve-startup-speeds) を参照してください。また、[設定に誤りがある可能性があります](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)。'

PARSER_CRASH            =
'構文解析がクラッシュしました！ 最後のメッセージ：{}'
PARSER_UNKNOWN          =
'不明な構文エラー'
PARSER_MISS_NAME        =
'名前が不足しています。'
PARSER_UNKNOWN_SYMBOL   =
'シンボル `{symbol}` は不明です。'
PARSER_MISS_SYMBOL      =
'シンボル `{symbol}` が不足しています。'
PARSER_MISS_ESC_X       =
'バイト指定(`\\x`)には16進数の文字が2つ必要です。'
PARSER_UTF8_SMALL       =
'Unicode 指定(`\\u`)には16進数の文字が1つ以上必要です。'
PARSER_UTF8_MAX         =
'Unicode 指定(`\\u`)は {min} から {max} 文字である必要があります。'
PARSER_ERR_ESC          =
'無効なエスケープシーケンス。'
PARSER_MUST_X16         =
'16進数の文字である必要があります。'
PARSER_MISS_EXPONENT    =
'指数部が不足しています。'
PARSER_MISS_EXP         =
'式が不足しています。'
PARSER_MISS_FIELD       =
'フィールド/プロパティ名が不足しています。'
PARSER_MISS_METHOD      =
'メソッド名が不足しています。'
PARSER_ARGS_AFTER_DOTS  =
'`...` は最後の引数でなければなりません。'
PARSER_KEYWORD          =
'キーワードは名前として使用できません。'
PARSER_EXP_IN_ACTION    =
'この式は文として使用できません。'
PARSER_BREAK_OUTSIDE    =
'`break` はループの外で利用できません。'
PARSER_MALFORMED_NUMBER =
'無効な数字です。'
PARSER_ACTION_AFTER_RETURN =
'`return` の後にコードを実行することはできません。'
PARSER_ACTION_AFTER_BREAK =
'`break` の後にコードを実行することはできません。'
PARSER_NO_VISIBLE_LABEL =
'ラベル `{label}` が見つかりません。'
PARSER_REDEFINE_LABEL   =
'ラベル `{label}` は定義済みです。'
PARSER_UNSUPPORT_SYMBOL =
'{version} ではこのシンボルはサポートされていません。'
PARSER_UNEXPECT_DOTS    =
'`...` は可変引数関数内でのみ使用できます。'
PARSER_UNEXPECT_SYMBOL  =
'シンボル `{symbol}` は不明です。'
PARSER_UNKNOWN_TAG      =
'不明なタグです。'
PARSER_MULTI_TAG        =
'タグは1つのみ設定できます。'
PARSER_UNEXPECT_LFUNC_NAME =
'ローカル関数の名前には識別子のみ使用できます。'
PARSER_UNEXPECT_EFUNC_NAME =
'式として関数を利用する場合、名前を付けることはできません。'
PARSER_ERR_LCOMMENT_END =
'複数行のアノテーションは `{symbol}` で終わる必要があります。'
PARSER_ERR_C_LONG_COMMENT =
'Lua では複数行のコメントを `--[[ ]]` で囲む必要があります。'
PARSER_ERR_LSTRING_END  =
'長い文字列は `{symbol}` で終わる必要があります。'
PARSER_ERR_ASSIGN_AS_EQ =
'代入には `=` を使用します。'
PARSER_ERR_EQ_AS_ASSIGN =
'等号判定には `==` を使用します。'
PARSER_ERR_UEQ          =
'不等号判定には `~=` を使用します。'
PARSER_ERR_THEN_AS_DO   =
'`then` を使用する必要があります。'
PARSER_ERR_DO_AS_THEN   =
'`do` を使用する必要があります。'
PARSER_MISS_END         =
'対応する `end` が不足しています。'
PARSER_ERR_COMMENT_PREFIX =
'Lua ではコメントに `--` を使用する必要があります。'
PARSER_MISS_SEP_IN_TABLE =
'区切りには `,` または `;` が必要です。'
PARSER_SET_CONST         =
'定数に値を代入できません。'
PARSER_UNICODE_NAME      =
'Unicode 文字が含まれています。'
PARSER_ERR_NONSTANDARD_SYMBOL =
'Lua では `{symbol}` 記号を使用する必要があります。'
PARSER_MISS_SPACE_BETWEEN =
'記号の間にはスペースを入れる必要があります。'
PARSER_INDEX_IN_FUNC_NAME =
'関数名には `[name]` 形式を使用できません。'
PARSER_UNKNOWN_ATTRIBUTE  =
'ローカル変数の属性は `const` または `close` である必要があります。'
PARSER_AMBIGUOUS_SYNTAX   =
'Lua 5.1 では、関数呼び出しの左括弧は関数と同じ行になければなりません。'
PARSER_NEED_PAREN         =
'括弧を追加する必要があります。'
PARSER_NESTING_LONG_MARK  =
'Lua 5.1 ではネストされた `[[...]]` は使用できません。'
PARSER_LOCAL_LIMIT        =
'同時に存在できるローカル変数とアップバリューの数は200個までです。'
PARSER_LUADOC_MISS_CLASS_NAME           =
'クラス名が不足しています。'
PARSER_LUADOC_MISS_EXTENDS_SYMBOL       =
'`:` が不足しています。'
PARSER_LUADOC_MISS_CLASS_EXTENDS_NAME   =
'継承するクラス名が不足しています。'
PARSER_LUADOC_MISS_SYMBOL               =
'`{symbol}` が不足しています。'
PARSER_LUADOC_MISS_ARG_NAME             =
'引数名が不足しています。'
PARSER_LUADOC_MISS_TYPE_NAME            =
'型名が不足しています。'
PARSER_LUADOC_MISS_ALIAS_NAME           =
'エイリアス名が不足しています。'
PARSER_LUADOC_MISS_ALIAS_EXTENDS        =
'エイリアスの定義が不足しています。'
PARSER_LUADOC_MISS_PARAM_NAME           =
'引数名が不足しています。'
PARSER_LUADOC_MISS_PARAM_EXTENDS        =
'引数の型が不足しています。'
PARSER_LUADOC_MISS_FIELD_NAME           =
'フィールド名が不足しています。'
PARSER_LUADOC_MISS_FIELD_EXTENDS        =
'フィールドの型が不足しています。'
PARSER_LUADOC_MISS_GENERIC_NAME         =
'ジェネリック名が不足しています。'
PARSER_LUADOC_MISS_GENERIC_EXTENDS_NAME =
'ジェネリックが継承するクラス名が不足しています。'
PARSER_LUADOC_MISS_VARARG_TYPE          =
'可変長引数の型が不足しています。'
PARSER_LUADOC_MISS_FUN_AFTER_OVERLOAD   =
'キーワード `fun` が不足しています。'
PARSER_LUADOC_MISS_CATE_NAME            =
'アノテーションの種類が不足しています。'
PARSER_LUADOC_MISS_DIAG_MODE            =
'診断モードが不足しています。'
PARSER_LUADOC_ERROR_DIAG_MODE           =
'診断モードが正しくありません。'
PARSER_LUADOC_MISS_LOCAL_NAME           =
'変数名が不足しています。'

SYMBOL_ANONYMOUS        =
'<匿名関数>'

HOVER_VIEW_DOCUMENTS    =
'ドキュメントを見る'
HOVER_DOCUMENT_LUA51    =
'http://www.lua.org/manual/5.1/manual.html#{}'
HOVER_DOCUMENT_LUA52    =
'http://www.lua.org/manual/5.2/manual.html#{}'
HOVER_DOCUMENT_LUA53    =
'http://www.lua.org/manual/5.3/manual.html#{}'
HOVER_DOCUMENT_LUA54    =
'http://www.lua.org/manual/5.4/manual.html#{}'
HOVER_DOCUMENT_LUAJIT   =
'http://www.lua.org/manual/5.1/manual.html#{}'
HOVER_NATIVE_DOCUMENT_LUA51     =
'command:extension.lua.doc?["en-us/51/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA52     =
'command:extension.lua.doc?["en-us/52/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA53     =
'command:extension.lua.doc?["en-us/53/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA54     =
'command:extension.lua.doc?["en-us/54/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUAJIT    =
'command:extension.lua.doc?["en-us/51/manual.html/{}"]'
HOVER_MULTI_PROTOTYPE      =
'（{} 個のプロトタイプ）'
HOVER_STRING_BYTES         =
'{} バイト'
HOVER_STRING_CHARACTERS    =
'{} バイト、{} 文字'
HOVER_MULTI_DEF_PROTO      =
'（{} 個の定義、{} 個のプロトタイプ）'
HOVER_MULTI_PROTO_NOT_FUNC =
'（{} 個の非関数定義）'
HOVER_USE_LUA_PATH      =
'（検索パス： `{}`）'
HOVER_EXTENDS           =
'{} に展開'
HOVER_TABLE_TIME_UP     =
'パフォーマンスのため、一部の型推論が無効になっています。'
HOVER_WS_LOADING        =
'ワークスペースをロード中：{} / {}'
HOVER_AWAIT_TOOLTIP     =
'非同期関数を呼び出しています。現在のスレッドは譲る可能性があります。'

ACTION_DISABLE_DIAG     =
'ワークスペース ({}) の診断を無効にします。'
ACTION_MARK_GLOBAL      =
'`{}` を定義済みのグローバル変数としてマークする。'
ACTION_REMOVE_SPACE     =
'すべての行末スペースを削除します'
ACTION_ADD_SEMICOLON    =
'`;` を追加します。'
ACTION_ADD_BRACKETS     =
'括弧を追加します。'
ACTION_RUNTIME_VERSION  =
'ランタイムバージョンを {} に変更します。'
ACTION_OPEN_LIBRARY     =
'{} からグローバル変数をロードします。'
ACTION_ADD_DO_END       =
'`do ... end` を追加します。'
ACTION_FIX_LCOMMENT_END =
'複数行コメントの終了記号を修正します。'
ACTION_ADD_LCOMMENT_END =
'複数行コメントの終了記号を追加します。'
ACTION_FIX_C_LONG_COMMENT =
'Lua の複数行コメント形式に変更します。'
ACTION_FIX_LSTRING_END  =
'長い文字列の終了記号を修正します。'
ACTION_ADD_LSTRING_END  =
'長い文字列の終了記号を追加します。'
ACTION_FIX_ASSIGN_AS_EQ =
'`=` に変更します。'
ACTION_FIX_EQ_AS_ASSIGN =
'`==` に変更します。'
ACTION_FIX_UEQ          =
'`~=` に変更します。'
ACTION_FIX_THEN_AS_DO   =
'`then` に変更します。'
ACTION_FIX_DO_AS_THEN   =
'`do` に変更します。'
ACTION_ADD_END          =
'`end` を追加します（インデントに基づいて位置を推測します）。'
ACTION_FIX_COMMENT_PREFIX =
'`--` に変更します。'
ACTION_FIX_NONSTANDARD_SYMBOL =
'`{symbol}` に変更します。'
ACTION_RUNTIME_UNICODE_NAME =
'Unicode 文字の使用を許可します。'
ACTION_SWAP_PARAMS      =
'`{node}` の第 {index} 引数に変更します。'
ACTION_FIX_INSERT_SPACE =
'スペースを追加します。'
ACTION_JSON_TO_LUA      =
'JSON を Lua に変換します。'
ACTION_DISABLE_DIAG_LINE=
'この行で診断 ({}) を無効にします。'
ACTION_DISABLE_DIAG_FILE=
'このファイルで診断 ({}) を無効にします。'
ACTION_MARK_ASYNC       =
'現在の関数を非同期として指定します。'
ACTION_ADD_DICT         =
'\'{}\' をワークスペースの辞書に追加します。'
ACTION_FIX_ADD_PAREN    =
'括弧を追加します。'
ACTION_AUTOREQUIRE      =
'\'{}\' を `{}` としてインポートします。'

COMMAND_DISABLE_DIAG       =
'診断を無効にします'
COMMAND_MARK_GLOBAL        =
'グローバル変数として指定します'
COMMAND_REMOVE_SPACE       =
'すべての行末スペースを削除します'
COMMAND_ADD_BRACKETS       =
'括弧を追加します。'
COMMAND_RUNTIME_VERSION    =
'実行バージョンを変更します'
COMMAND_OPEN_LIBRARY       =
'サードパーティライブラリのグローバル変数をロードします'
COMMAND_UNICODE_NAME       =
'Unicode 文字の使用を許可します'
COMMAND_JSON_TO_LUA        =
'JSON を Lua に変換します'
COMMAND_JSON_TO_LUA_FAILED =
'JSON を Lua に変換できませんでした：{}'
COMMAND_ADD_DICT           =
'単語を辞書に追加します'
COMMAND_REFERENCE_COUNT    =
'{} 件の参照'

COMPLETION_IMPORT_FROM           =
'{} からインポート'
COMPLETION_DISABLE_AUTO_REQUIRE  =
'自動 require を無効にします'
COMPLETION_ASK_AUTO_REQUIRE      =
'ファイル先頭にこのファイルを require するコードを追加しますか？'

DEBUG_MEMORY_LEAK       =
'{} 重大なメモリリークが発生したため、言語サービスを再起動します。'
DEBUG_RESTART_NOW       =
'今すぐ再起動します'

WINDOW_COMPILING                 =
'コンパイル中です'
WINDOW_DIAGNOSING                =
'診断中です'
WINDOW_INITIALIZING              =
'初期化中です...'
WINDOW_PROCESSING_HOVER          =
'ホバーヒントを処理中しています...'
WINDOW_PROCESSING_DEFINITION     =
'定義ジャンプを処理しています...'
WINDOW_PROCESSING_REFERENCE      =
'参照ジャンプを処理しています...'
WINDOW_PROCESSING_RENAME         =
'名前変更を処理しています...'
WINDOW_PROCESSING_COMPLETION     =
'オートコンプリートを処理しています...'
WINDOW_PROCESSING_SIGNATURE      =
'パラメータヒントを処理していますです...'
WINDOW_PROCESSING_SYMBOL         =
'ファイルシンボルを処理しています...'
WINDOW_PROCESSING_WS_SYMBOL      =
'ワークスペースシンボルを処理しています...'
WINDOW_PROCESSING_SEMANTIC_FULL  =
'セマンティックカラーリング（フール）を処理しています...'
WINDOW_PROCESSING_SEMANTIC_RANGE =
'セマンティックカラーリング（インクリメンタル）を処理しています...'
WINDOW_PROCESSING_HINT           =
'インラインヒントを処理しています...'
WINDOW_PROCESSING_BUILD_META     =
'コンパイラのメタデータを処理しています...'
WINDOW_INCREASE_UPPER_LIMIT      =
'上限を増やします'
WINDOW_CLOSE                     =
'クローズ'
WINDOW_SETTING_WS_DIAGNOSTIC     =
'ワークスペース設定で診断を遅延または無効化できます'
WINDOW_DONT_SHOW_AGAIN           =
'再度表示しない'
WINDOW_DELAY_WS_DIAGNOSTIC       =
'アイドル時に診断（{}秒遅延）'
WINDOW_DISABLE_DIAGNOSTIC        =
'ワークスペース診断を無効にします'
WINDOW_LUA_STATUS_WORKSPACE      =
'ワークスペース：{}'
WINDOW_LUA_STATUS_CACHED_FILES   =
'キャッシュされたファイル：{ast}/{max}'
WINDOW_LUA_STATUS_MEMORY_COUNT   =
'メモリ使用量：{mem:.f}M'
WINDOW_LUA_STATUS_TIP            =
[[

このアイコンは猫です。
犬でも狐でもありません！
             ↓↓↓
]]
WINDOW_LUA_STATUS_DIAGNOSIS_TITLE=
'ワークスペースの診断を行います'
WINDOW_LUA_STATUS_DIAGNOSIS_MSG  =
'ワークスペースの診断を行いますか。'
WINDOW_APPLY_SETTING             =
'設定を適用します'
WINDOW_CHECK_SEMANTIC            =
'マーケットプレイスのカラーテーマを使用している場合、セマンティックハイライトを有効にするには `editor.semanticHighlighting.enabled` オプションを `true` に設定する必要があるかもしれまん。'
WINDOW_TELEMETRY_HINT            =
'匿名の使用データとエラーレポートの送信を許可し、このプラグインの改善にご協力ください。プライバシーポリシーについては[こちら](https://luals.github.io/privacy/#language-server)をご覧ください。'
WINDOW_TELEMETRY_ENABLE          =
'許可します'
WINDOW_TELEMETRY_DISABLE         =
'許可しません'
WINDOW_CLIENT_NOT_SUPPORT_CONFIG =
'お使いのクライアントはサーバー側からの設定変更をサポートしていません。以下の設定を手動で変更してください：'
WINDOW_LCONFIG_NOT_SUPPORT_CONFIG=
'ローカル設定の自動変更は現在サポートされていません。以下の設定を手動で変更してください：'
WINDOW_MANUAL_CONFIG_ADD         =
'`{key}` に要素 `{value:q}` を追加します;'
WINDOW_MANUAL_CONFIG_SET         =
'`{key}` の値を `{value:q}` に設定します;'
WINDOW_MANUAL_CONFIG_PROP        =
'`{key}` のプロパティ `{prop}` を `{value:q}` に設定します;'
WINDOW_APPLY_WHIT_SETTING        =
'設定を変更して適用します'
WINDOW_APPLY_WHITOUT_SETTING     =
'設定を変更せずに適用します'
WINDOW_ASK_APPLY_LIBRARY         =
'作業環境を `{}` に設定しますか？'
WINDOW_SEARCHING_IN_FILES        =
'ファイルを検索しています...'
WINDOW_CONFIG_LUA_DEPRECATED     =
'`config.lua` は廃止されました。代わりに `config.json` を使用してください。'
WINDOW_CONVERT_CONFIG_LUA        =
'`config.json` に変換します'
WINDOW_MODIFY_REQUIRE_PATH       =
'`require` のパスを変更しますか。'
WINDOW_MODIFY_REQUIRE_OK         =
'変更します'

CONFIG_LOAD_FAILED               =
'設定ファイルを読み込めませんでした：{}'
CONFIG_LOAD_ERROR                =
'設定ファイルの読み込み中にエラーが発生しました：{}'
CONFIG_TYPE_ERROR                =
'設定ファイルは lua または json フォーマットでなければなりません：{}'
CONFIG_MODIFY_FAIL_SYNTAX_ERROR  =
'設定ファイル中に構文エラーがあったため、設定を変更できませんでした：{}'
CONFIG_MODIFY_FAIL_NO_WORKSPACE  =
[[
設定の変更に失敗しました：
* `.luarc.json` ファイルの作成にはワークスペースが必要ですが、現在は単一ファイルモードになっています。
* クライアントはサーバー側からの設定変更をサポートしていません。

以下の設定を手動で変更してください：
{}
]]
CONFIG_MODIFY_FAIL               =
[[
設定の変更に失敗しました。

以下の設定を手動で変更してください：
{}
]]

PLUGIN_RUNTIME_ERROR             =
[[
プラグインの実行中にエラーが発生しました。プラグイン作成者に報告してください。
詳細は出力またはログ画面でご確認ください。
プラグインのパス：{}
]]
PLUGIN_TRUST_LOAD                =
[[
現在の設定では、次の場所にあるプラグインを読み込もうとしています：
{}

悪意のあるプラグインはコンピュータに害を与える可能性があることにご注意ください。
]]
PLUGIN_TRUST_YES                 =
[[
このプラグインを信頼して読み込む
]]
PLUGIN_TRUST_NO                  =
[[
このプラグインを読み込まない
]]

CLI_CHECK_ERROR_TYPE =
'check は文字列でなければなりませんが、{} が指定されました'
CLI_CHECK_ERROR_URI =
'check は有効な URI でなければなりませんが、{} が指定されました'
CLI_CHECK_ERROR_LEVEL =
'checklevel は次のいずれかである必要があります：{}'
CLI_CHECK_INITING =
'初期化中...'
CLI_CHECK_SUCCESS =
'診断が完了しました。問題は見つかりませんでした'
CLI_CHECK_PROGRESS =
'{} ファイルに渡り、{} 個の問題が発見されました'
CLI_CHECK_RESULTS_OUTPATH =
'診断が完了しました。{} 個の問題が発見されました。詳しくは {} をご確認ください'
CLI_CHECK_RESULTS_PRETTY =
'診断が完了しました。{} 個の問題が発見されました'
CLI_CHECK_MULTIPLE_WORKERS =
'{} 個のワーカータスクを開始しているため、進行状況の出力が無効になります。完了まで数分かかることがあります。'
CLI_DOC_INITING   =
'ドキュメントを読み込んでいます...'
CLI_DOC_DONE      =
[[
ドキュメントのエクスポートが完了しました！
元データ: {}
Markdown(例): {}
]]
CLI_DOC_WORKING   = -- TODO: need translate!
'Building docs...'

TYPE_ERROR_ENUM_GLOBAL_DISMATCH =
'タイプ `{child}` は `{parent}` の列挙型に一致しません'
TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED =
'列挙型においてジェネリック型 `{child}` を使用できません'
TYPE_ERROR_ENUM_LITERAL_DISMATCH =
'リテラル `{child}` は `{parent}` の列挙値に一致しません'
TYPE_ERROR_ENUM_OBJECT_DISMATCH =
'オブジェクト `{child}` は `{parent}` の列挙値に一致しません。同じオブジェクトである必要があります'
TYPE_ERROR_ENUM_NO_OBJECT =
'渡された列挙値 `{child}` を認識できません'
TYPE_ERROR_INTEGER_DISMATCH =
'リテラル `{child}` は整数 `{parent}` に一致しません'
TYPE_ERROR_STRING_DISMATCH =
'リテラル `{child}` は文字列 `{parent}` に一致しません'
TYPE_ERROR_BOOLEAN_DISMATCH =
'リテラル `{child}` はブール値 `{parent}` に一致しません'
TYPE_ERROR_TABLE_NO_FIELD =
'テーブルにフィールド `{key}` が存在しません'
TYPE_ERROR_TABLE_FIELD_DISMATCH =
'フィールド `{key}` の型 `{child}` は `{parent}` に一致しません'
TYPE_ERROR_CHILD_ALL_DISMATCH =
'`{child}` のすべてのサブタイプは `{parent}` に一致しません'
TYPE_ERROR_PARENT_ALL_DISMATCH =
'`{child}` は `{parent}` のどのサブタイプにも一致しません'
TYPE_ERROR_UNION_DISMATCH =
'`{child}` は `{parent}` に一致しません'
TYPE_ERROR_OPTIONAL_DISMATCH =
'オプション型は `{parent}` に一致しません'
TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER =
'数字 `{child}` を整数に変換できません'
TYPE_ERROR_NUMBER_TYPE_TO_INTEGER =
'数値型を整数型に変換できません'
TYPE_ERROR_DISMATCH =
'型 `{child}` は `{parent}` に一致しません'

LUADOC_DESC_CLASS =
[=[
クラス/テーブル構造を定義します。
## 書き方
`---@class <name> [: <parent>[, <parent>]...]`
## 例
```
---@class Manager: Person, Human
Manager = {}
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#class)
]=]
LUADOC_DESC_TYPE =
[=[
変数の型を指定します。

デフォルトの型は `nil`、`any`、`boolean`、`string`、`number`、`integer`、
`function`、`table`、`thread`、`userdata`、`lightuserdata`

（カスタム型は `@alias`を用いて定義できま）

## 書き方
`---@type <type>[| [type]...`

## 例
### 一般
```
---@type nil|table|myClass
local Example = nil
```

### 配列
```
---@type number[]
local phoneNumbers = {}
```

### 列挙
```
---@type "red"|"green"|"blue"
local color = ""
```

### テーブル
```
---@type table<string, boolean>
local settings = {
    disableLogging = true,
    preventShutdown = false,
}

---@type { [string]: true }
local x --x[""] is true
```

### 関数
```
---@type fun(mode?: "r"|"w"): string
local myFunction
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#type)
]=]
LUADOC_DESC_ALIAS =
[=[
`@param` や `@type` に利用できるカスタム型を定義します。

## 書き方
`---@alias <name> <type> [description]`\
or
```
---@alias <name>
---| 'value' [# comment]
---| 'value2' [# comment]
...
```

## 例
### 他の型に展開
```
---@alias filepath string ファイルへのパス

---@param path filepath 探索を行うファイルへのパス
function find(path, pattern) end
```

### 列挙
```
---@alias font-style
---| '"underlined"' # テキストに下線を付ける
---| '"bold"' # テキストを太字にする
---| '"italic"' # テキストをイタリック体にする

---@param style font-style 適用するフォントスタイル
function setFontStyle(style) end
```

### リテラル列挙
```
local enums = {
    READ = 0,
    WRITE = 1,
    CLOSED = 2
}

---@alias FileStates
---| `enums.READ`
---| `enums.WRITE`
---| `enums.CLOSE`
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#alias)
]=]
LUADOC_DESC_PARAM =
[=[
関数のパラメータを宣言します。

## 書き方
`@param <name>[?] <type> [comment]`

## 例
### 一般
```
---@param url string リクエストするURL
---@param headers? table<string, string> 送信するHTTPヘッダー
---@param timeout? number タイムアウト（秒）
function get(url, headers, timeout) end
```

### 可変長引数
```
---@param base string 基底文字列
---@param ... string 基底文字列に連結する値
function concat(base, ...) end
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#param)
]=]
LUADOC_DESC_RETURN =
[=[
戻り値を宣言します。

## 書き方
`@return <type> [name] [description]`\
or\
`@return <type> [# description]`

## 例
### 一般
```
---@return number
---@return number # 緑の値
---@return number b 青の値
function hexToRGB(hex) end
```

### 型と名前のみを指定する場合
```
---@return number x, number y
function getCoords() end
```

### 型のみを指定する場合
```
---@return string, string
function getFirstLast() end
```

### 可変長の値を返す場合
```
---@return string ... アイテムのタグ
function getTags(item) end
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#return)
]=]
LUADOC_DESC_FIELD =
[=[
クラス/テーブル内のフィールドを宣言します。`v3.6.0`以降では、フィールドを`private`、`protected`、`public`、または`package`として指定することができます。

## 書き方
`---@field [scope] <name> <type> [description]`

## 例
```
---@class HTTP_RESPONSE
---@field status HTTP_STATUS
---@field headers table<string, string> レスポンスのヘッダー

---@class HTTP_STATUS
---@field code number ステータスコード
---@field message string ステータスメッセージ

---@return HTTP_RESPONSE response サーバーからのレスポンス
function get(url) end

-- 下記変数には上記で定義されたすべてのフィールドが含まれています
response = get("localhost")

-- コード補完や詳細表示などのインテリセンス機能も提供できるようになります
statusCode = response.status.code
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#field)
]=]
LUADOC_DESC_GENERIC =
[=[
ジェネリク型を宣言します。ジェネリック型は利用される度に異なる型と一致することができ、汎用的な関数の記述に役立ちます。

## 書き方
`---@generic <name> [:parent_type] [, <name> [:parent_type]]`

## 例
### General
```
---@generic T
---@param value T 戻り値と同じ型の値
---@return T value 指定された値と同じ
function echo(value)
    return value
end

-- 型は string
s = echo("e")

-- 型は number
n = echo(10)

-- 型は boolean
b = echo(true)

-- 許可される型を一つずつ指定する変わりに、
-- @generic を用いてすべての型に対応できます
```

### 型名からジェネリック型を設定する
```
---@class Foo
local Foo = {}
function Foo:Bar() end

---@generic T
---@param name `T` # 型名を指定
---@return T       # ジェネリック型の値を返す
function Generic(name) end

local v = Generic("Foo") -- v は Foo 型のオブジェクト
```

### Luaテーブルがジェネリクスを使う方法
```
---@class table<K, V>: { [K]: V }

-- 上記を用いることで、テーブルの作成と
-- インテリセンスによる型の追跡が可能になる
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations/#generic)
]=]
LUADOC_DESC_VARARG =
[=[
主にEmmyLua注釈との互換性のため。`@vararg`で定義された型情報はインテリセンスなどに提供されません。

**パラメーターに注釈を付ける際には、可変長であっても`@param`を使用してください。**

## 書き方
`@vararg <type>`

## 例
```
---文字列を連結します
---@vararg string
function concat(...) end
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations/#vararg)
]=]
LUADOC_DESC_OVERLOAD =
[=[
複数の関数シグネチャを一括で定義するために利用します。

## 書き方
`---@overload fun(<name>[: <type>] [, <name>[: <type>]]...)[: <type>[, <type>]...]`

## 例
```
---@overload fun(t: table, value: any): number
function table.insert(t, position, value) end
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#overload)
]=]
LUADOC_DESC_DEPRECATED =
[=[
関数を非推奨として指定します。非推奨関数の呼び出し箇所には取り消し線が引かれます。

## 書き方
`---@deprecated`

---
[Wikiを表示](https://luals.github.io/wiki/annotations#deprecated)
]=]
LUADOC_DESC_META =
[=[
このファイルがメタファイルであることを示します。

メタファイルはインテリセンス用の定義と注釈のみを含むファイルで、通常のファイルと比べて以下の三つの特徴があります。
1. メタファイル内にはコンテキストに基づくインテリセンスが提供されません。
2. メタファイル内の `require` ファイルパスにカーソルを合わせると、絶対パスの代わりに `[meta]` が表示されます。
3. メタファイル内の定義は `Find Reference` 機能に無視されます。

## 書き方
`---@meta`

---
[Wikiを表示](https://luals.github.io/wiki/annotations#meta)
]=]
LUADOC_DESC_VERSION =
[=[
この関数が特定のLuaバージョンに限定されることを指定します。

指定可能なLuaのバージョンは: `5.1`, `5.2`, `5.3`, `5.4`, `JIT`。

事前に `Diagnostics: Needed File Status` を設定する必要があります。

## 書き方
`---@version <version>[, <version>]...`

## 例
### General
```
---@version JIT
function onlyWorksInJIT() end
```
### 複数バージョンの指定
```
---@version <5.2,JIT
function oldLuaOnly() end
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#version)
]=]
LUADOC_DESC_SEE =
[=[
ワークスペース内のシンボルへの参照を指定します。

## 書き方
`---@see <symbol>`

## 例
```
---下記関数にマウスを合わせると、http.get関数へのリンクが表示されます
---@see http.get
function request(url) end
```

---
[Wikiを表示](https://luals.github.io/wiki/annotations#see)
]=]
LUADOC_DESC_DIAGNOSTIC =
[=[
エラーや警告などの診断を有効化/無効化します。

指定可能なアクション: `disable`, `enable`, `disable-line`, `disable-next-line`

[Names](https://github.com/LuaLS/lua-language-server/blob/cbb6e6224094c4eb874ea192c5f85a6cba099588/script/proto/define.lua#L54)

## 書き方
`---@diagnostic <action>[: <name>]`

## 例
### 次の行において警告を無効化
```
---@diagnostic disable-next-line: undefined-global
```

### 領域を囲んで手動で警告をトグル
```
---@diagnostic disable: unused-local
local unused = "hello world"
---@diagnostic enable: unused-local
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#diagnostic)
]=]
LUADOC_DESC_MODULE =
[=[
`require`と同様な意味で、指定されたファイルの注釈情報を提供します。

## 書き方
`---@module <'module_name'>`

## 例
```
---@module 'string.utils'
local stringUtils
-- 上記は下記と機能的に同じです
local module = require('string.utils')
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#module)
]=]
LUADOC_DESC_ASYNC =
[=[
関数を非同期として指定します。

## 書き方
`---@async`

---
[Wikiを表示](https://luals.github.io/wiki/annotations#async)
]=]
LUADOC_DESC_NODISCARD =
[=[
この関数の戻り値は破棄/無視できないものとして指定します。
戻り値が無視された場合、`discard-returns` の警告が発生します。

## 書き方
`---@nodiscard`

---
[Wikiを表示](https://luals.github.io/wiki/annotations#nodiscard)
]=]
LUADOC_DESC_CAST =
[=[
型変換 (キャスト）を指定します。

## 書き方
`@cast <variable> <[+|-]type>[, <[+|-]type>]...`

## 例
### 型を上書き
```
---@type integer
local x --> 整数

---@cast x string
print(x) --> 文字列
```
### 型を追加
```
---@type string
local x --> 文字列

---@cast x +boolean, +number
print(x) --> 文字列|ブール|数値
```
### 型を削除
```
---@type string|table
local x --> 文字列|テーブル
---@cast x -string
print(x) --> テーブル
```
---
[Wikiを表示](https://luals.github.io/wiki/annotations#cast)
]=]
LUADOC_DESC_OPERATOR =
[=[
[演算子メタメソッド](http://lua-users.org/wiki/MetatableEvents)の型を宣言します。

## 書き方
`@operator <operation>[(input_type)]:<resulting_type>`

## 例
### 加算演算
```
---@class Vector
---@operation add(Vector):Vector

vA = Vector.new(1, 2, 3)
vB = Vector.new(10, 20, 30)

vC = vA + vB
--> Vector
```
### 負の単項演算（unary minus）
```
---@class Passcode
---@operation unm:integer

pA = Passcode.new(1234)
pB = -pA
--> 整数
```
[View Request](https://github.com/LuaLS/lua-language-server/issues/599)
]=]
LUADOC_DESC_ENUM =
[=[
テーブルを列挙型として指定します。Luaテーブルとして定義できない場合は、[`@alias`](https://luals.github.io/wiki/annotations#alias)を参照してください。

## 書き方
`@enum <name>`

## 例
```
---@enum colors
local colors = {
	white = 0,
	orange = 2,
	yellow = 4,
	green = 8,
	black = 16,
}

---@param color colors
local function setColor(color) end

-- 以下のパラメータに対して補完とホバーが提供されます
setColor(colors.green)
```
]=]
LUADOC_DESC_SOURCE =
[=[
他のファイルをシンボルの定義元として指定します。そのシンボルに対して定義ジャンプを行う際、 `@source` で指定されたファイルに飛びます。

## 書き方
`@source <path>`

## 例
```
---絶対パスを使用する場合
---@source C:/Users/me/Documents/program/myFile.c
local a

---URIを使用する場合
---@source file:///C:/Users/me/Documents/program/myFile.c:10
local b

---相対パスを使用する場合
---@source local/file.c
local c

---行番号と文字番号の指定も可能です
---@source local/file.c:10:8
local d
```
]=]
LUADOC_DESC_PACKAGE =
[=[
他のファイルからアクセスできない関数として指定します。

## 書き方
`@package`

## 例
```
---@class Animal
---@field private eyes integer
local Animal = {}

---@package
---この関数は他のファイルからアクセスできません
function Animal:eyesCount()
    return self.eyes
end
```
]=]
LUADOC_DESC_PRIVATE =
[=[
特定のクラス以外からアクセスできない関数として指定します。プライベートとして指定された関数は子クラスからもアクセスすることができません。

## 書き方
`@private`

## 例
```
---@class Animal
---@field private eyes integer
local Animal = {}

---@private
function Animal:eyesCount()
    return self.eyes
end

---@class Dog:Animal
local myDog = {}

---許可されていません！
myDog:eyesCount();
```
]=]
LUADOC_DESC_PROTECTED =
[=[
特定のクラスとその子クラス以外からアクセスできない関数として指定します。プロテクトとして指定された関数は子クラスからアクセスできます。

## 書き方
`@protected`

## 例
```
---@class Animal
---@field private eyes integer
local Animal = {}

---@protected
function Animal:eyesCount()
    return self.eyes
end

---@class Dog:Animal
local myDog = {}

---プロテクト関数のため子クラスからの使用が許可されています
myDog:eyesCount();
```
]=]
