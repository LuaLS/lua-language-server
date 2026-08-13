---@diagnostic disable: undefined-global

config.addonManager.enable        =
"アドオンマネージャーを有効にするかどうか。"
config.addonManager.repositoryBranch =
"アドオンマネージャーが使用するgitブランチを指定します。"
config.addonManager.repositoryPath =
"アドオンマネージャーが使用するgitパスを指定します。"
config.addonRepositoryPath        =
"アドオンのリポジトリパスを指定します（アドオンマネージャーとは無関係です）。"
config.runtime.version            =
"Lua のランタイムバージョン。"
config.runtime.path               =
[[
`require` を使用する際、入力名に基づいてファイルを探す方法。
この設定を `?/init.lua` にすると、`require 'myfile'` と入力したとき、読み込まれたファイルから `${workspace}/myfile/init.lua` が検索されます。
`runtime.pathStrict` が `false` の場合、`${workspace}/**/myfile/init.lua` も検索対象になります。
ワークスペース外のファイルを読み込みたい場合は、先に `Lua.workspace.library` を設定する必要があります。
]]
config.runtime.pathStrict         =
'有効にすると、`runtime.path` は最上位のディレクトリ階層のみを検索します。詳細は `runtime.path` の説明を参照してください。'
config.runtime.special            =
[[カスタムのグローバル変数を一部の特別な組み込み変数として扱い、言語サーバーが特別なサポートを提供します。
以下の例では、`include` を `require` として扱います。
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```
]]
config.runtime.unicodeName        =
"名前に Unicode 文字を使用できるようにします。"
config.runtime.nonstandardSymbol  =
"非標準の記号をサポートします。ランタイム環境がこれらの記号をサポートしていることを確認してください。"
config.runtime.nonstandardSymbol['?.'] =
"安全ナビゲーション（フィールド/メソッド：`a?.b` / `obj?.:method()` / `obj:method?.()`）。"
config.runtime.nonstandardSymbol['?.('] =
"安全ナビゲーション呼び出し（`f?.()` / `f?.\"str\"` / `f?.{...}` / `f?.[[...]]`）。"
config.runtime.nonstandardSymbol['?.['] =
"安全ナビゲーションインデックス（`t?.[key]`）。"
config.runtime.nonstandardSymbol['?('] =
"ドットなしオプショナル呼び出し（`f?()` は `f?.()` と同等。三項（`ternary`）の解析と競合するため併用非推奨）。"
config.runtime.nonstandardSymbol['?['] =
"ドットなしオプショナルインデックス（`t?[1]` は `t?.[1]` と同等。三項（`ternary`）の解析と競合するため併用非推奨）。"
config.runtime.nonstandardSymbol['??'] =
"nil 合体（`a ?? b`。左辺が nil の場合のみ右辺を返す）。"
config.runtime.nonstandardSymbol['ternary'] =
"三項演算子（`cond ? x : y`、右結合。`x` 部分ではメソッド呼び出し禁止）。"
config.runtime.nonstandardSymbol['?:'] =
"ドットなし安全メソッド（`obj?:get()` は `obj?.:get()` と同等）。"
config.runtime.nonstandardSymbol['~>>'] =
"算術右シフト（`a ~>> b`。LuaJIT 固有。通常の `>>` は論理右シフト）。"
config.runtime.nonstandardSymbol['~>>='] =
"算術右シフト複合代入（`a ~>>= b`）。"
config.runtime.nonstandardSymbol['..='] =
"文字列連結複合代入（`a ..= b`）。"
config.runtime.nonstandardSymbol['~='] =
"XOR 複合代入：文コンテキスト（例：`a ~= b` が単独の行）でのみ有効。式の中では「等しくない」のまま。"
config.runtime.nonstandardSymbol['const'] =
"`const` 宣言（ブロックスコープのローカル定数。再代入・再宣言不可）。"
config.runtime.nonstandardSymbol['->'] =
"短い関数の矢印（`x -> expr` / `|x| -> expr` / `|| -> expr` / `-> do ... end`）。"
config.runtime.nonstandardSymbol['number_underscore'] =
"数値リテラルのアンダースコア（例：`1_000`、`0x1_2`、`0b1_0`）。"
config.runtime.nonstandardSymbol['//'] =
"行コメント（C スタイル）。"
config.runtime.nonstandardSymbol['/**/'] =
"ブロックコメント（C スタイル）。"
config.runtime.nonstandardSymbol['`'] =
"バッククォート文字列リテラル。"
config.runtime.nonstandardSymbol['+='] =
"加算複合代入。"
config.runtime.nonstandardSymbol['-='] =
"減算複合代入。"
config.runtime.nonstandardSymbol['*='] =
"乗算複合代入。"
config.runtime.nonstandardSymbol['/='] =
"除算複合代入。"
config.runtime.nonstandardSymbol['%='] =
"剰余複合代入。"
config.runtime.nonstandardSymbol['^='] =
"べき乗複合代入。"
config.runtime.nonstandardSymbol['//='] =
"床除算複合代入。"
config.runtime.nonstandardSymbol['|='] =
"ビット単位 OR 複合代入。"
config.runtime.nonstandardSymbol['&='] =
"ビット単位 AND 複合代入。"
config.runtime.nonstandardSymbol['<<='] =
"左シフト複合代入。"
config.runtime.nonstandardSymbol['>>='] =
"右シフト複合代入。"
config.runtime.nonstandardSymbol['||'] =
"論理 OR（`or` と同等）。"
config.runtime.nonstandardSymbol['&&'] =
"論理 AND（`and` と同等）。"
config.runtime.nonstandardSymbol['!'] =
"論理 NOT（`not` と同等）。"
config.runtime.nonstandardSymbol['!='] =
"等しくない（`~=` と同等）。"
config.runtime.nonstandardSymbol['continue'] =
"`continue` 文。"
config.runtime.nonstandardSymbol['|lambda|'] =
"パイプ引数の短い関数（`|x| expr`）。"
config.runtime.enableLuaJITExtensions =
[[
LuaJIT 拡張構文を有効にします（`Lua.runtime.version` を `LuaJIT` に設定する必要があります）。
各拡張構文は `Lua.runtime.nonstandardSymbol` で個別に有効化することもできます。
]]
config.runtime.plugin             =
"プラグインのパス。詳細は [wiki](https://luals.github.io/wiki/plugins) を参照してください。"
config.runtime.pluginArgs         =
"プラグインに渡す追加引数。"
config.runtime.fileEncoding       =
"ファイルのエンコーディング。`ansi` オプションは `Windows` プラットフォームでのみ利用可能です。"
config.runtime.builtin            =
[[
組み込みライブラリの有効状態を調整します。実際のランタイム環境に応じて、存在しないライブラリを無効化（または再定義）できます。

* `default`: ランタイムバージョンに応じてライブラリを有効／無効にします
* `enable`: 常に有効
* `disable`: 常に無効
]]
config.runtime.meta               =
'メタファイルのディレクトリ名の形式。'
config.diagnostics.enable         =
"診断を有効にします。"
config.diagnostics.disable        =
"無効化する診断（ホバーの括弧内に表示されるコードを使用）。"
config.diagnostics.globals        =
"定義済みのグローバル変数。"
config.diagnostics.globalsRegex   =
"正規表現で定義済みのグローバル変数を検索します。"
config.diagnostics.severity       =
[[
診断の重大度を変更します。

末尾に `!` を付けると、グループ設定 `diagnostics.groupSeverity` を上書きします。
]]
config.diagnostics.neededFileStatus =
[[
* Opened: 開いているファイルのみを診断
* Any:    すべてのファイルを診断
* None:   この診断を無効化

末尾に `!` を付けると、グループ設定 `diagnostics.groupFileStatus` を上書きします。
]]
config.diagnostics.groupSeverity  =
[[
グループ内の診断の重大度を変更します。
`Fallback` は、このグループ内の診断が個別に `diagnostics.severity` によって制御されることを意味します。
その他の設定は、末尾に `!` が付いていない個別の設定を上書きします。
]]
config.diagnostics.groupFileStatus =
[[
グループ内の診断対象ファイル状態を変更します。

* Opened: 開いているファイルのみを診断
* Any:    すべてのファイルを診断
* None:   この診断を無効化

`Fallback` は、このグループ内の診断が個別に `diagnostics.neededFileStatus` によって制御されることを意味します。
その他の設定は、末尾に `!` が付いていない個別の設定を上書きします。
]]
config.diagnostics.workspaceEvent =
"ワークスペース診断をトリガーするタイミングを設定します。"
config.diagnostics.workspaceEvent.OnChange =
"ファイルが変更されたときにワークスペース診断をトリガーします。"
config.diagnostics.workspaceEvent.OnSave =
"ファイルが保存されたときにワークスペース診断をトリガーします。"
config.diagnostics.workspaceEvent.None =
"ワークスペース診断を無効にします。"
config.diagnostics.workspaceDelay =
"ワークスペース診断の待ち時間（ミリ秒）。"
config.diagnostics.workspaceRate  =
"ワークスペース診断の実行レート（％）。この値を下げると CPU 使用率は低下しますが、ワークスペース診断の速度も低下します。現在編集中のファイルの診断は常に全速で行われ、この設定の影響を受けません。"
config.diagnostics.libraryFiles   =
"`Lua.workspace.library` 経由で読み込まれたファイルをどのように診断するか。"
config.diagnostics.libraryFiles.Enable   =
"常にこれらのファイルを診断します。"
config.diagnostics.libraryFiles.Opened   =
"これらのファイルが開かれているときのみ診断します。"
config.diagnostics.libraryFiles.Disable  =
"これらのファイルは診断しません。"
config.diagnostics.ignoredFiles   =
"無視されているファイルをどのように診断するか。"
config.diagnostics.ignoredFiles.Enable   =
"常にこれらのファイルを診断します。"
config.diagnostics.ignoredFiles.Opened   =
"これらのファイルが開かれているときのみ診断します。"
config.diagnostics.ignoredFiles.Disable  =
"これらのファイルは診断しません。"
config.diagnostics.disableScheme  =
'次のスキームを使用する Lua ファイルは診断しません。'
config.diagnostics.validScheme  =
'次のスキームを使用する Lua ファイルの診断を有効にします。'
config.diagnostics.unusedLocalExclude =
'変数名が次のパターンに一致する場合、`unused-local` を診断しません。'
config.workspace.ignoreDir        =
"無視するファイルとディレクトリ（`.gitignore` の構文を使用）。"-- .. example.ignoreDir,
config.workspace.ignoreSubmodules =
"サブモジュールを無視します。"
config.workspace.useGitIgnore     =
"`.gitignore` に記載されたファイルを無視します。"
config.workspace.maxPreload       =
"プリロードする最大ファイル数。"
config.workspace.preloadFileSize  =
"プリロード時にこの値（KB）より大きいファイルをスキップします。"
config.workspace.library          =
"現在のワークスペースに加えて、どのディレクトリからファイルをロードするか。これらのディレクトリ内のファイルは外部提供のコードライブラリとして扱われ、一部の機能（フィールド名の変更など）はこれらのファイルを変更しません。"
config.workspace.dofileRoots      =
"現在のワークスペースに加えて、`dofile` がルートとして扱う可能性のあるディレクトリ。これらのディレクトリ内のファイルは即座にロードされます。"
config.workspace.checkThirdParty  =
[[
サードパーティライブラリの自動検出と適応。現在サポートされているライブラリ：

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]]
config.workspace.userThirdParty          =
'プライベートサードパーティライブラリの設定ファイルパスをここに追加してください。組み込みの[設定ファイルパス](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)を参照してください。'
config.workspace.supportScheme           =
'次のスキームのLuaファイルに言語サーバーを提供します。'
config.completion.enable                 =
'補完を有効にします。'
config.completion.callSnippet            =
'関数呼び出しスニペットを表示します。'
config.completion.callSnippet.Disable    =
"関数名のみを表示します。"
config.completion.callSnippet.Both       =
"関数名と呼び出しスニペットを表示します。"
config.completion.callSnippet.Replace    =
"呼び出しスニペットのみを表示します。"
config.completion.keywordSnippet         =
'キーワード構文スニペットを表示します。'
config.completion.keywordSnippet.Disable =
"キーワードのみを表示します。"
config.completion.keywordSnippet.Both    =
"キーワードと構文スニペットを表示します。"
config.completion.keywordSnippet.Replace =
"構文スニペットのみを表示します。"
config.completion.displayContext         =
"提案の関連コードスニペットをプレビューすることで、提案の使用法を理解しやすくなります。設定された数値は、コードフラグメント内で切り取られる行数を示します。`0`に設定すると、この機能を無効にできます。"
config.completion.workspaceWord          =
"表示されるコンテキストワードにワークスペース内の他のファイルの内容を含めるかどうか。"
config.completion.showWord               =
"提案内にコンテキストワードを表示します。"
config.completion.showWord.Enable        =
"常に提案内にコンテキストワードを表示します。"
config.completion.showWord.Fallback      =
"セマンティックスに基づく提案を提供できない場合のみ、コンテキストワードを表示します。"
config.completion.showWord.Disable       =
"コンテキストワードを表示しません。"
config.completion.autoRequire            =
"入力がファイル名のように見える場合、自動的にこのファイルを`require`します。"
config.completion.maxSuggestCount        =
"補完用に分析するフィールドの最大数。オブジェクトがこの制限より多くのフィールドを持つ場合、補完が表示されるにはより具体的な入力が必要になります。"
config.completion.showParams             =
"補完リストにパラメータを表示します。関数に複数の定義がある場合、個別に表示されます。"
config.completion.requireSeparator       =
"`require`時に使用される区切り文字。"
config.completion.postfix                =
"後置提案をトリガーするために使用されるシンボル。"
config.color.mode                        =
"カラーモード。"
config.color.mode.Semantic               =
"セマンティックカラー。効果を発揮するために`editor.semanticHighlighting.enabled`を`true`に設定する必要があるかもしれません。"
config.color.mode.SemanticEnhanced       =
"強化されたセマンティックカラー。`Semantic`に似ていますが、追加の分析が行われるため、計算コストが高くなる可能性があります。"
config.color.mode.Grammar                =
"文法カラー。"
config.semantic.enable                   =
"セマンティックカラーを有効にします。効果を発揮するために`editor.semanticHighlighting.enabled`を`true`に設定する必要があるかもしれません。"
config.semantic.variable                 =
"変数/フィールド/パラメータのセマンティックカラーリング。"
config.semantic.annotation               =
"型注釈のセマンティックカラーリング。"
config.semantic.keyword                  =
"キーワード/リテラル/演算子のセマンティックカラーリング。エディタが構文カラーリングをできない場合のみ、この機能を有効にする必要があります。"
config.signatureHelp.enable              =
"シグネチャヘルプを有効にします。"
config.hover.enable                      =
"ホバーを有効にします。"
config.hover.viewString                  =
"ホバーで文字列の内容を表示します（リテラルにエスケープ文字が含まれている場合のみ）。"
config.hover.viewStringMax               =
"ホバーで表示する文字列内容の最大長。"
config.hover.viewNumber                  =
"ホバーで数値内容を表示します（リテラルが10進数でない場合のみ）。"
config.hover.fieldInfer                  =
"テーブルをホバーで表示する際、各フィールドに対して型推論が実行されます。型推論の累積時間が設定値（ミリ秒）に達すると、後続のフィールドの型推論はスキップされます。"
config.hover.previewFields               =
"テーブルをホバーで表示する際、フィールドのプレビューの最大数を制限します。"
config.hover.enumsLimit                  =
"値が複数の型に対応する場合、表示される型の数を制限します。"
config.hover.expandAlias                 =
[[
エイリアスを展開するかどうか。たとえば、`---@alias myType boolean|number`を展開すると`boolean|number`として表示され、そうでない場合は`myType`として表示されます。
]]
config.develop.enable                    =
'開発者モード。パフォーマンスに影響するため有効にしないでください。'
config.develop.debuggerPort              =
'デバッガーの待ち受けポート。'
config.develop.debuggerWait              =
'デバッガー接続前に停止します。'
config.intelliSense.searchDepth          =
'IntelliSenseの検索深度を設定します。この値を上げると精度が上がりますが、パフォーマンスが低下します。ワークスペースごとに適切な値を調整してください。'
config.intelliSense.fastGlobal           =
'グローバル変数補完および `_G` ホバー表示を高速化します。型推論の精度がわずかに低下しますが、多数のグローバルを使うプロジェクトでは大きく改善します。'
config.window.statusBar                  =
'ステータスバーに拡張機能のステータスを表示します。'
config.window.progressBar                =
'ステータスバーに進行状況バーを表示します。'
config.hint.enable                       =
'インレイヒントを有効にします。'
config.hint.paramType                    =
'関数のパラメータに型ヒントを表示します。'
config.hint.setType                      =
'代入操作で型ヒントを表示します。'
config.hint.paramName                    =
'関数呼び出し時にパラメータ名のヒントを表示します。'
config.hint.paramName.All                =
'すべての型のパラメータを表示します。'
config.hint.paramName.Literal            =
'リテラル型のパラメータのみを表示します。'
config.hint.paramName.Disable            =
'パラメータヒントを無効にします。'
config.hint.arrayIndex                   =
'テーブル構築時に配列インデックスのヒントを表示します。'
config.hint.arrayIndex.Enable            =
'すべてのテーブルでヒントを表示します。'
config.hint.arrayIndex.Auto              =
'テーブルが3要素を超える、または混在テーブルの場合のみヒントを表示します。'
config.hint.arrayIndex.Disable           =
'配列インデックスのヒントを無効にします。'
config.hint.await                        =
'呼び出す関数に `---@async` が付いている場合、呼び出し箇所で `await` を提案します。'
config.hint.awaitPropagate               =
'`await` の伝播を有効にします。`---@async` が付いた関数を呼び出す関数は、自動的に `---@async` とマークされます。'
config.hint.semicolon                    =
'文末にセミコロンがない場合に仮想セミコロンを表示します。'
config.hint.semicolon.All                =
'すべての文で仮想セミコロンを表示します。'
config.hint.semicolon.SameLine           =
'同じ行に2つの文がある場合、その間にセミコロンを表示します。'
config.hint.semicolon.Disable            =
'仮想セミコロンを無効にします。'
config.codeLens.enable                   =
'コードレンズを有効にします。'
config.format.enable                     =
'コードフォーマッタを有効にします。'
config.format.defaultConfig              =
[[
デフォルトのフォーマット設定。ワークスペース内の`.editorconfig`ファイルより優先度が低くなります。
[formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) を参照してください。
]]
config.spell.dict                        =
'スペルチェック用のカスタム単語。'
config.nameStyle.config                  =
[[
命名スタイル設定。
[formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) を参照してください。
]]
config.telemetry.enable                  =
[[
テレメトリを有効にし、エディタ情報とエラーログをネットワーク経由で送信します。プライバシーポリシーは[こちら](https://luals.github.io/privacy/#language-server)。
]]
config.misc.parameters                   =
'VSCode で言語サーバーを起動するときの[コマンドライン引数](https://github.com/LuaLS/lua-telemetry-server/tree/master/method)。'
config.misc.executablePath               =
'VSCodeでの実行可能ファイルのパスを指定します。'
config.language.fixIndent                =
'(VSCodeのみ) 誤った自動インデントを修正します。例えば、"function" を含む文字列内で改行したときの不正なインデントなど。'
config.language.completeAnnotation       =
'(VSCodeのみ) 注釈行の改行後に自動で "---@ " を挿入します。'
config.type.castNumberToInteger          =
'`number` 型を `integer` 型に代入することを許可します。'
config.type.weakUnionCheck               =
[[
共用体型のどれか1つのサブタイプが条件を満たせば、共用体全体も条件を満たします。

この設定が`false`の場合、`number|boolean`型は`number`型に代入できません。`true`の場合は可能です。
]]
config.type.weakNilCheck                 =
[[
共用体型のチェック時に、その中の`nil`を無視します。

この設定が`false`の場合、`number|nil`型は`number`型に代入できません。`true`の場合は可能です。
]]
config.type.inferParamType               =
[[
パラメータ型が注釈されていない場合、関数の呼び出し箇所から推論します。

この設定が`false`の場合、注釈がないパラメータの型は`any`になります。
]]
config.type.checkTableShape              =
[[
テーブルの形状を厳密にチェックします。
]]
config.type.inferTableSize               =
'型推論時に解析するテーブルフィールドの最大数。'
config.doc.privateName                   =
'特定のフィールド名をプライベートとして扱います。例: `m_*` は `XXX.m_id` や `XXX.m_type` がプライベートであり、定義されているクラス内でのみアクセス可能です。'
config.doc.protectedName                 =
'特定のフィールド名をプロテクトとして扱います。例: `m_*` は `XXX.m_id` や `XXX.m_type` がプロテクトであり、定義クラスおよびそのサブクラスでのみアクセス可能です。'
config.doc.packageName                   =
'特定のフィールド名をパッケージとして扱います。例: `m_*` は `XXX.m_id` や `XXX.m_type` がパッケージであり、定義されているファイル内でのみアクセス可能です。'
config.doc.regengine                     =
'ドキュメントスコープ名のマッチに使用する正規表現エンジン。'
config.doc.regengine.glob                =
'デフォルトの軽量パターン構文。'
config.doc.regengine.lua                 =
'Luaスタイルの正規表現（フル機能）。'
config.docScriptPath                     =
'ドキュメントスコープ名のマッチに使用する正規表現エンジン。'
config.diagnostics['unused-local']          =
'未使用のローカル変数の診断を有効にします。'
config.diagnostics['unused-function']       =
'未使用の関数の診断を有効にします。'
config.diagnostics['undefined-global']      =
'未定義のグローバル変数の診断を有効にします。'
config.diagnostics['global-in-nil-env']     =
'グローバル変数を使用できない（`_ENV` が `nil`）場合の診断を有効にします。'
config.diagnostics['unused-label']          =
'未使用ラベルの診断を有効にします。'
config.diagnostics['unused-vararg']         =
'未使用の可変引数の診断を有効にします。'
config.diagnostics['trailing-space']        =
'行末の余分な空白の診断を有効にします。'
config.diagnostics['redefined-local']       =
'ローカル変数の再定義診断を有効にします。'
config.diagnostics['newline-call']          =
'改行呼び出しの診断を有効にします。`(` で始まる行が前の行への関数呼び出しとして構文解析される場合に発生します。'
config.diagnostics['newfield-call']         =
'newfield 呼び出しの診断を有効にします。テーブル定義中に関数呼び出しの括弧が次の行に現れる場合に発生します。'
config.diagnostics['redundant-parameter']   =
'冗長な関数パラメータの診断を有効にします。'
config.diagnostics['ambiguity-1']           =
'演算子優先順位のあいまいさ診断を有効にします。例: `num or 0 + 1` には `(num or 0) + 1` を推奨します。'
config.diagnostics['lowercase-global']      =
'先頭小文字のグローバル変数定義の診断を有効にします。'
config.diagnostics['undefined-env-child']   =
'未定義環境変数の診断を有効にします。`_ENV` を新しいリテラルテーブルに設定した結果、使用中のグローバルが存在しない場合に発生します。'
config.diagnostics['duplicate-index']       =
'重複したテーブルインデックスの診断を有効にします。'
config.diagnostics['empty-block']           =
'空のコードブロック診断を有効にします。'
config.diagnostics['redundant-value']       =
'代入時の余分な値の診断を有効にします。値の数が変数の数を超える場合に発生します。'
config.diagnostics['assign-type-mismatch']  =
'値の型が代入先の型と一致しない代入の診断を有効にします。'
config.diagnostics['await-in-sync']         =
'同期関数内で非同期関数を呼び出す場合の診断を有効にします。'
config.diagnostics['cast-local-type']    =
'ローカル変数のキャスト先の型が定義と一致しない場合の診断を有効にします。'
config.diagnostics['cast-type-mismatch']    =
'キャスト先の型が元の型と一致しない場合の診断を有効にします。'
config.diagnostics['circular-doc-class']    =
'クラス同士が継承し合う循環関係の診断を有効にします。'
config.diagnostics['close-non-object']      =
'オブジェクト以外を閉じようとする場合の診断を有効にします。'
config.diagnostics['code-after-break']      =
'ループ内で`break`の後に配置されたコードの診断を有効にします。'
config.diagnostics['codestyle-check']       =
'スタイルに合わない行の診断を有効にします。'
config.diagnostics['count-down-loop']       =
'減少しないため上限に到達しない `for` ループの診断を有効にします。'
config.diagnostics['deprecated']            =
'非推奨APIを強調する診断を有効にします。'
config.diagnostics['different-requires']    =
'異なるパスで同じファイルをrequireする場合の診断を有効にします。'
config.diagnostics['discard-returns']       =
'`---@nodiscard` が付いた関数の戻り値を無視した呼び出しの診断を有効にします。'
config.diagnostics['doc-field-no-class']    =
'クラス注釈なしでフィールド注釈がある場合の診断を有効にします。'
config.diagnostics['duplicate-doc-alias']   =
'エイリアス注釈名の重複診断を有効にします。'
config.diagnostics['duplicate-doc-field']   =
'フィールド注釈名の重複診断を有効にします。'
config.diagnostics['duplicate-doc-param']   =
'パラメータ注釈名の重複診断を有効にします。'
config.diagnostics['duplicate-set-field']   =
'クラス内で同じフィールドを複数回設定する診断を有効にします。'
config.diagnostics['incomplete-signature-doc']    =
'関数の @param または @return 注釈が不完全な場合の診断。'
config.diagnostics['invisible']             =
'不可視フィールドへのアクセス診断を有効にします。'
config.diagnostics['missing-global-doc']    =
'グローバル関数の注釈不足の診断。コメントと全パラメータ・戻り値の注釈が必要です。'
config.diagnostics['missing-local-export-doc'] =
'エクスポートされたローカル関数の注釈不足の診断。'
config.diagnostics['missing-parameter']     =
'注釈パラメータ数より少ない引数で関数を呼び出した場合の診断を有効にします。'
config.diagnostics['missing-return']        =
'戻り注釈があるのにreturn文がない場合の診断を有効にします。'
config.diagnostics['missing-return-value']  =
'戻り値を宣言しているのに値を返さないreturn文の診断を有効にします。'
config.diagnostics['need-check-nil']        =
'以前に`nil`または任意型が代入された変数を使用する際のnilチェック診断を有効にします。'
config.diagnostics['unnecessary-assert']    =
'真値に対する冗長なassertの診断を有効にします。'
config.diagnostics['no-unknown']            =
'型を推論できない場合の診断を有効にします。'
config.diagnostics['not-yieldable']         =
'許可されない場所での`coroutine.yield()`呼び出しの診断を有効にします。'
config.diagnostics['param-type-mismatch']   =
'注釈の型と一致しない引数を渡した場合の診断を有効にします。'
config.diagnostics['redundant-return']      =
'不要なreturn文の診断を有効にします。'
config.diagnostics['redundant-return-value']=
'注釈にない追加の戻り値を返すreturn文の診断を有効にします。'
config.diagnostics['return-type-mismatch']  =
'戻り値の型が注釈と一致しない場合の診断を有効にします。'
config.diagnostics['spell-check']           =
'文字列内のタイポ診断を有効にします。'
config.diagnostics['name-style-check']      =
'名前スタイルの診断を有効にします。'
config.diagnostics['unbalanced-assignments']=
'多重代入で一部の変数が値を得られない場合の診断を有効にします（例: `local x,y = 1`）。'
config.diagnostics['undefined-doc-class']   =
'未定義クラスを参照するクラス注釈の診断を有効にします。'
config.diagnostics['undefined-doc-name']    =
'未定義の型またはエイリアスを参照する注釈の診断を有効にします。'
config.diagnostics['undefined-doc-param']   =
'関数定義に存在しないパラメータへの注釈の診断を有効にします。'
config.diagnostics['undefined-field']       =
'未定義フィールドを参照する場合の診断を有効にします。'
config.diagnostics['unknown-cast-variable'] =
'未定義変数へのキャスト診断を有効にします。'
config.diagnostics['unknown-diag-code']     =
'不明な診断コードが入力された場合の診断を有効にします。'
config.diagnostics['unknown-operator']      =
'不明な演算子の診断を有効にします。'
config.diagnostics['unreachable-code']      =
'到達不能コードの診断を有効にします。'
config.diagnostics['global-element']       =
'グローバル要素に関する警告診断を有効にします。'
config.diagnostics['action-after-return'] =
'`return` 文の後のコード'
config.diagnostics['ambiguous-syntax'] =
'曖昧な構文'
config.diagnostics['args-after-dots'] =
'`...` の後の引数'
config.diagnostics['assign-const-global'] =
'const グローバル変数への代入'
config.diagnostics['block-after-else'] =
'`else` の後のブロック'
config.diagnostics['break-outside'] =
'ループの外で `break` を使用'
config.diagnostics['circle-doc-class'] =
'`@class` 継承の循環'
config.diagnostics['declare-const'] =
'const 定数の再宣言'
config.diagnostics['env-is-global'] =
'`_ENV` をグローバル変数として使用'
config.diagnostics['exp-in-action'] =
'文の位置に式が出現'
config.diagnostics['global-close-attribute'] =
'グローバル変数への close 属性'
config.diagnostics['index-in-func-name'] =
'関数名にインデックスが含まれる'
config.diagnostics['inject-field'] =
'オブジェクトへのフィールド注入'
config.diagnostics['jump-local-scope'] =
'ローカル変数のスコープにジャンプ'
config.diagnostics['keyword'] =
'キーワードの不適切な使用'
config.diagnostics['local-limit'] =
'ローカル変数の数が上限を超える'
config.diagnostics['lua-doc-miss-sign'] =
'LuaDoc コメントに記号が不足'
config.diagnostics['malformed-number'] =
'不正な数値リテラル'
config.diagnostics['missing-fields'] =
'フィールドが不足'
config.diagnostics['multi-close'] =
'多重 close 操作'
config.diagnostics['need-paren'] =
'括弧が必要'
config.diagnostics['nesting-long-mark'] =
'ネストした長いコメントマーカー'
config.diagnostics['no-visible-label'] =
'見えないラベル'
config.diagnostics['redefined-label'] =
'再定義されたラベル'
config.diagnostics['set-const'] =
'const 定数への代入'
config.diagnostics['unicode-name'] =
'Unicode 名'
config.diagnostics['unknown-attribute'] =
'不明な属性'
config.diagnostics['unknown-symbol'] =
'不明な記号'
config.diagnostics['unsupport-named-vararg'] =
'サポートされない名前付き可変引数'
config.diagnostics['variable-not-declared'] =
'未宣言の変数の使用'
config.typeFormat.config                    =
'Luaコード入力中のフォーマット動作を設定します。'
config.typeFormat.config.auto_complete_end  =
'適切な位置で`end`を自動補完するかを制御します。'
config.typeFormat.config.auto_complete_table_sep =
'テーブル宣言末尾にセパレータを自動付与するかを制御します。'
config.typeFormat.config.format_line        =
'行を自動整形するかどうかを制御します。'

command.exportDocument =
'Lua: ドキュメントをエクスポート...'
command.addon_manager.open =
'Lua: アドオンマネージャーを開く...'
command.reloadFFIMeta =
'Lua: luajit ffi メタを再読み込み'
command.startServer =
'Lua: 言語サーバーを再起動'
command.stopServer =
'Lua: 言語サーバーを停止'
