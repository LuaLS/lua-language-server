---@diagnostic disable: undefined-global

config.addonManager.enable        = -- TODO: need translate!
"Whether the addon manager is enabled or not."
config.runtime.version            =
"Lua執行版本。"
config.runtime.path               =
[[
當使用 `require` 時，如何根據輸入的名字來尋找檔案。
此選項設定為 `?/init.lua` 意味著當你輸入 `require 'myfile'` 時，會從已載入的檔案中搜尋 `{workspace}/myfile/init.lua`。
當 `runtime.pathStrict` 設定為 `false` 時，還會嘗試搜尋 `${workspace}/**/myfile/init.lua`。
如果你想要載入工作區以外的檔案，你需要先設定 `Lua.workspace.library`。
]]
config.runtime.pathStrict         =
'啟用後 `runtime.path` 將只搜尋第一層目錄，見 `runtime.path` 的説明。'
config.runtime.special            =
[[將自訂全域變數視為一些特殊的內建變數，語言伺服將提供特殊的支援。
下面這個例子表示將 `include` 視為 `require` 。
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```
]]
config.runtime.unicodeName        =
"允許在名字中使用 Unicode 字元。"
config.runtime.nonstandardSymbol  =
"支援非標準的符號。請務必確認你的執行環境支援這些符號。"
config.runtime.plugin             =
"延伸模組路徑，請查閱[文件](https://luals.github.io/wiki/plugins)瞭解用法。"
config.runtime.pluginArgs         = -- TODO: need translate!
"Additional arguments for the plugin."
config.runtime.fileEncoding       =
"檔案編碼，選項 `ansi` 只在 `Windows` 平台下有效。"
config.runtime.builtin            =
[[
調整內建庫的啟用狀態，你可以根據實際執行環境停用（或重新定義）不存在的庫。

* `default`: 表示庫會根據執行版本啟用或停用
* `enable`: 總是啟用
* `disable`: 總是停用
]]
config.runtime.meta               =
'meta檔案的目錄名稱格式'
config.diagnostics.enable         =
"啟用診斷。"
config.diagnostics.disable        =
"停用的診斷（使用浮框括號內的程式碼）。"
config.diagnostics.globals        =
"已定義的全域變數。"
config.diagnostics.severity       =
[[
修改診斷等級。
以 `!` 結尾的設定優先順序高於組設定 `diagnostics.groupSeverity`。
]]
config.diagnostics.neededFileStatus =
[[
* Opened:  只診斷打開的檔案
* Any:     診斷所有檔案
* None:    停用此診斷

以 `!` 結尾的設定優先順序高於組設定 `diagnostics.groupFileStatus`。
]]
config.diagnostics.groupSeverity  =
[[
批量修改一個組中的診斷等級。
設定為 `Fallback` 意味著組中的診斷由 `diagnostics.severity` 單獨設定。
其他設定將覆蓋單獨設定，但是不會覆蓋以 `!` 結尾的設定。
]]
config.diagnostics.groupFileStatus =
[[
批量修改一個組中的檔案狀態。

* Opened:  只診斷打開的檔案
* Any:     診斷所有檔案
* None:    停用此診斷

設定為 `Fallback` 意味著組中的診斷由 `diagnostics.neededFileStatus` 單獨設定。
其他設定將覆蓋單獨設定，但是不會覆蓋以 `!` 結尾的設定。
]]
config.diagnostics.workspaceEvent = -- TODO: need translate!
"Set the time to trigger workspace diagnostics."
config.diagnostics.workspaceEvent.OnChange = -- TODO: need translate!
"Trigger workspace diagnostics when the file is changed."
config.diagnostics.workspaceEvent.OnSave = -- TODO: need translate!
"Trigger workspace diagnostics when the file is saved."
config.diagnostics.workspaceEvent.None = -- TODO: need translate!
"Disable workspace diagnostics."
config.diagnostics.workspaceDelay =
"進行工作區診斷的延遲（毫秒）。"
config.diagnostics.workspaceRate  =
"工作區診斷的執行速率（百分比）。降低該值會減少CPU使用率，但是也會降低工作區診斷的速度。你目前正在編輯的檔案的診斷總是全速完成，不受該選項影響。"
config.diagnostics.libraryFiles   =
"如何診斷透過 `Lua.workspace.library` 載入的檔案。"
config.diagnostics.libraryFiles.Enable   =
"總是診斷這些檔案。"
config.diagnostics.libraryFiles.Opened   =
"只有打開這些檔案時才會診斷。"
config.diagnostics.libraryFiles.Disable  =
"不診斷這些檔案。"
config.diagnostics.ignoredFiles   =
"如何診斷被忽略的檔案。"
config.diagnostics.ignoredFiles.Enable   =
"總是診斷這些檔案。"
config.diagnostics.ignoredFiles.Opened   =
"只有打開這些檔案時才會診斷。"
config.diagnostics.ignoredFiles.Disable  =
"不診斷這些檔案。"
config.diagnostics.disableScheme  =
'不診斷使用以下 scheme 的lua檔案。'
config.diagnostics.unusedLocalExclude = -- TODO: need translate!
'Do not diagnose `unused-local` when the variable name matches the following pattern.'
config.workspace.ignoreDir        =
"忽略的檔案與目錄（使用 `.gitignore` 語法）。"
config.workspace.ignoreSubmodules =
"忽略子模組。"
config.workspace.useGitIgnore     =
"忽略 `.gitignore` 中列舉的檔案。"
config.workspace.maxPreload       =
"最大預載入檔案數。"
config.workspace.preloadFileSize  =
"預載入時跳過大小大於該值（KB）的檔案。"
config.workspace.library          =
"除了目前工作區以外，還會從哪些目錄中載入檔案。這些目錄中的檔案將被視作外部提供的程式碼庫，部分操作（如重新命名欄位）不會修改這些檔案。"
config.workspace.checkThirdParty  =
[[
自動偵測與適應第三方庫，目前支援的庫為：

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]]
config.workspace.userThirdParty          =
'在這裡添加私有的第三方庫適應檔案路徑，請參考內建的[組態檔案路徑](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)'
config.workspace.supportScheme           =
'為以下 `scheme` 的lua檔案提供語言伺服。'
config.completion.enable                 =
'啟用自動完成。'
config.completion.callSnippet            =
'顯示函式呼叫片段。'
config.completion.callSnippet.Disable    =
"只顯示 `函式名`。"
config.completion.callSnippet.Both       =
"顯示 `函式名` 與 `呼叫片段`。"
config.completion.callSnippet.Replace    =
"只顯示 `呼叫片段`。"
config.completion.keywordSnippet         =
'顯示關鍵字語法片段。'
config.completion.keywordSnippet.Disable =
"只顯示 `關鍵字`。"
config.completion.keywordSnippet.Both    =
"顯示 `關鍵字` 與 `語法片段`。"
config.completion.keywordSnippet.Replace =
"只顯示 `語法片段`。"
config.completion.displayContext         =
"預覽建議的相關程式碼片段，可能可以幫助你瞭解這項建議的用法。設定的數字表示程式碼片段的擷取行數，設定為 `0` 可以停用此功能。"
config.completion.workspaceWord          =
"顯示的上下文單詞是否包含工作區中其他檔案的內容。"
config.completion.showWord               =
"在建議中顯示上下文單詞。"
config.completion.showWord.Enable        =
"總是在建議中顯示上下文單詞。"
config.completion.showWord.Fallback      =
"無法根據語義提供建議時才顯示上下文單詞。"
config.completion.showWord.Disable       =
"不顯示上下文單詞。"
config.completion.autoRequire            =
"輸入內容看起來是個檔名時，自動 `require` 此檔案。"
config.completion.showParams             =
"在建議列表中顯示函式的參數資訊，函式擁有多個定義時會分開顯示。"
config.completion.requireSeparator       =
"`require` 時使用的分隔符。"
config.completion.postfix                =
"用於觸發後綴建議的符號。"
config.color.mode                        =
"著色模式。"
config.color.mode.Semantic               =
"語義著色。你可能需要同時將 `editor.semanticHighlighting.enabled` 設定為 `true` 才能生效。"
config.color.mode.SemanticEnhanced       =
"增強的語義顏色。類似於`Semantic`，但會進行額外的分析（也會帶來額外的開銷）。"
config.color.mode.Grammar                =
"語法著色。"
config.semantic.enable                   =
"啟用語義著色。你可能需要同時將 `editor.semanticHighlighting.enabled` 設定為 `true` 才能生效。"
config.semantic.variable                 =
"對變數/欄位/參數進行語義著色。"
config.semantic.annotation               =
"對類型註解進行語義著色。"
config.semantic.keyword                  =
"對關鍵字/字面常數/運算子進行語義著色。只有當你的編輯器無法進行語法著色時才需要啟用此功能。"
config.signatureHelp.enable              =
"啟用參數提示。"
config.hover.enable                      =
"啟用懸浮提示。"
config.hover.viewString                  =
"懸浮提示檢視字串內容（僅當字面常數包含跳脫字元時）。"
config.hover.viewStringMax               =
"懸浮提示檢視字串內容時的最大長度。"
config.hover.viewNumber                  =
"懸浮提示檢視數字內容（僅當字面常數不是十進制時）。"
config.hover.fieldInfer                  =
"懸浮提示檢視表時，會對表的每個欄位進行類型推測，當類型推測的用時累計達到該設定值（毫秒）時，將跳過後續欄位的類型推測。"
config.hover.previewFields               =
"懸浮提示檢視表時，限制表內欄位的最大預覽數量。"
config.hover.enumsLimit                  =
"當值對應多個類型時，限制類型的顯示數量。"
config.hover.expandAlias                 =
[[
是否展開別名。例如 `---@alias myType boolean|number` 展開後顯示為 `boolean|number`，否則顯示為 `myType'。
]]
config.develop.enable                    =
'開發者模式。請勿開啟，會影響效能。'
config.develop.debuggerPort              =
'除錯器監聽埠。'
config.develop.debuggerWait              =
'除錯器連接之前懸置。'
config.intelliSense.searchDepth          =
'設定智慧感知的搜尋深度。增大該值可以增加準確度，但會降低效能。不同的工作區對該設定的容忍度差異較大，請自己調整為合適的值。'
config.intelliSense.fastGlobal           =
'在對全域變數進行補全，及檢視 `_G` 的懸浮提示時進行最佳化。這會略微降低類型推測的準確度，但是對於大量使用全域變數的專案會有大幅的效能提升。'
config.window.statusBar                  =
'在狀態欄顯示延伸模組狀態。'
config.window.progressBar                =
'在狀態欄顯示進度條。'
config.hint.enable                       =
'啟用內嵌提示。'
config.hint.paramType                    =
'在函式的參數位置提示類型。'
config.hint.setType                      =
'在賦值操作位置提示類型。'
config.hint.paramName                    =
'在函式呼叫處提示參數名。'
config.hint.paramName.All                =
'所有類型的參數均進行提示。'
config.hint.paramName.Literal            =
'只有字面常數類型的參數進行提示。'
config.hint.paramName.Disable            =
'停用參數提示。'
config.hint.arrayIndex                   =
'在建構表時提示陣列索引。'
config.hint.arrayIndex.Enable            =
'所有的表中都提示陣列索引。'
config.hint.arrayIndex.Auto              =
'只有表大於3項，或者表是混合類型時才進行提示。'
config.hint.arrayIndex.Disable           =
'停用陣列索引提示。'
config.hint.await                        =
'如果呼叫的函數被標記為了 `---@async`，則在呼叫處提示 `await`。'
config.hint.semicolon                    =
'若陳述式尾部沒有分號，則顯示虛擬分號。'
config.hint.semicolon.All                =
'所有陳述式都顯示虛擬分號。'
config.hint.semicolon.SameLine            =
'兩個陳述式在同一行時，在它們之間顯示分號。'
config.hint.semicolon.Disable            =
'停用虛擬分號。'
config.codeLens.enable                   = -- TODO: need translate!
'Enable code lens.'
config.format.enable                     =
'啟用程式碼格式化程式。'
config.format.defaultConfig              =
[[
預設的格式化組態，優先順序低於工作區內的 `.editorconfig` 檔案。
請查閱[格式化文件](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)了解用法。
]]
config.spell.dict                        =
'拼寫檢查的自訂單詞。'
config.nameStyle.config                  = -- TODO: need translate!
'Set name style config'
config.telemetry.enable                  =
[[
啟用遙測，透過網路發送你的編輯器資訊與錯誤日誌。在[此處](https://luals.github.io/privacy/#language-server)閱讀我們的隱私聲明。
]]
config.misc.parameters                   =
'VSCode中啟動語言伺服時的[命令列參數](https://luals.github.io/wiki/usage#arguments)。'
config.misc.executablePath               = -- TODO: need translate!
'Specify the executable path in VSCode.'
config.type.castNumberToInteger          =
'允許將 `number` 類型賦值給 `integer` 類型。'
config.type.weakUnionCheck               =
[[
同位類型中只要有一個子類型滿足條件，則同位類型也滿足條件。

此設定為 `false` 時，`number|boolean` 類型無法賦給 `number` 類型；為 `true` 時則可以。
]]
config.type.weakNilCheck                 = -- TODO: need translate!
[[
When checking the type of union type, ignore the `nil` in it.

When this setting is `false`, the `number|nil` type cannot be assigned to the `number` type. It can be with `true`.
]]
config.doc.privateName                   = -- TODO: need translate!
'Treat specific field names as private, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are private, witch can only be accessed in the class where the definition is located.'
config.doc.protectedName                 = -- TODO: need translate!
'Treat specific field names as protected, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are protected, witch can only be accessed in the class where the definition is located and its subclasses.'
config.doc.packageName                   = -- TODO: need translate!
'Treat specific field names as package, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are package, witch can only be accessed in the file where the definition is located.'
config.diagnostics['unused-local']          =
'未使用的區域變數'
config.diagnostics['unused-function']       =
'未使用的函式'
config.diagnostics['undefined-global']      =
'未定義的全域變數'
config.diagnostics['global-in-nil-env']     =
'不能使用全域變數（ `_ENV` 被設定為 `nil`）'
config.diagnostics['unused-label']          =
'未使用的標籤'
config.diagnostics['unused-vararg']         =
'未使用的不定引數'
config.diagnostics['trailing-space']        =
'後置空格'
config.diagnostics['redefined-local']       =
'重複定義的區域變數'
config.diagnostics['newline-call']          =
'以 `(` 開始的新行，在語法上被解析為了上一行的函式呼叫'
config.diagnostics['newfield-call']         =
'在字面常數表中，2行程式碼之間缺少分隔符，在語法上被解析為了一次索引操作'
config.diagnostics['redundant-parameter']   =
'函式呼叫時，傳入了多餘的引數'
config.diagnostics['ambiguity-1']           =
'優先順序歧義，如： `num or 0 + 1` ，推測使用者的實際期望為 `(num or 0) + 1`'
config.diagnostics['lowercase-global']      =
'首字母小寫的全域變數定義'
config.diagnostics['undefined-env-child']   =
'`_ENV` 被設定為了新的字面常數表，但是試圖獲取的全域變數不在這張表中'
config.diagnostics['duplicate-index']       =
'在字面常數表中重複定義了索引'
config.diagnostics['empty-block']           =
'空程式碼區塊'
config.diagnostics['redundant-value']       =
'賦值操作時，值的數量比被賦值的對象多'
config.diagnostics['assign-type-mismatch']  = -- TODO: need translate!
'Enable diagnostics for assignments in which the value\'s type does not match the type of the assigned variable.'
config.diagnostics['await-in-sync']         = -- TODO: need translate!
'Enable diagnostics for calls of asynchronous functions within a synchronous function.'
config.diagnostics['cast-local-type']    = -- TODO: need translate!
'Enable diagnostics for casts of local variables where the target type does not match the defined type.'
config.diagnostics['cast-type-mismatch']    = -- TODO: need translate!
'Enable diagnostics for casts where the target type does not match the initial type.'
config.diagnostics['circular-doc-class']    = -- TODO: need translate!
'Enable diagnostics for two classes inheriting from each other introducing a circular relation.'
config.diagnostics['close-non-object']      = -- TODO: need translate!
'Enable diagnostics for attempts to close a variable with a non-object.'
config.diagnostics['code-after-break']      = -- TODO: need translate!
'Enable diagnostics for code placed after a break statement in a loop.'
config.diagnostics['codestyle-check']       = -- TODO: need translate!
'Enable diagnostics for incorrectly styled lines.'
config.diagnostics['count-down-loop']       = -- TODO: need translate!
'Enable diagnostics for `for` loops which will never reach their max/limit because the loop is incrementing instead of decrementing.'
config.diagnostics['deprecated']            = -- TODO: need translate!
'Enable diagnostics to highlight deprecated API.'
config.diagnostics['different-requires']    = -- TODO: need translate!
'Enable diagnostics for files which are required by two different paths.'
config.diagnostics['discard-returns']       = -- TODO: need translate!
'Enable diagnostics for calls of functions annotated with `---@nodiscard` where the return values are ignored.'
config.diagnostics['doc-field-no-class']    = -- TODO: need translate!
'Enable diagnostics to highlight a field annotation without a defining class annotation.'
config.diagnostics['duplicate-doc-alias']   = -- TODO: need translate!
'Enable diagnostics for a duplicated alias annotation name.'
config.diagnostics['duplicate-doc-field']   = -- TODO: need translate!
'Enable diagnostics for a duplicated field annotation name.'
config.diagnostics['duplicate-doc-param']   = -- TODO: need translate!
'Enable diagnostics for a duplicated param annotation name.'
config.diagnostics['duplicate-set-field']   = -- TODO: need translate!
'Enable diagnostics for setting the same field in a class more than once.'
config.diagnostics['incomplete-signature-doc'] = -- TODO: need translate!
'Incomplete @param or @return annotations for functions.'
config.diagnostics['invisible']             = -- TODO: need translate!
'Enable diagnostics for accesses to fields which are invisible.'
config.diagnostics['missing-global-doc']    = -- TODO: need translate!
'Missing annotations for globals! Global functions must have a comment and annotations for all parameters and return values.'
config.diagnostics['missing-local-export-doc'] = -- TODO: need translate!
'Missing annotations for exported locals! Exported local functions must have a comment and annotations for all parameters and return values.'
config.diagnostics['missing-parameter']     = -- TODO: need translate!
'Enable diagnostics for function calls where the number of arguments is less than the number of annotated function parameters.'
config.diagnostics['missing-return']        = -- TODO: need translate!
'Enable diagnostics for functions with return annotations which have no return statement.'
config.diagnostics['missing-return-value']  = -- TODO: need translate!
'Enable diagnostics for return statements without values although the containing function declares returns.'
config.diagnostics['need-check-nil']        = -- TODO: need translate!
'Enable diagnostics for variable usages if `nil` or an optional (potentially `nil`) value was assigned to the variable before.'
config.diagnostics['no-unknown']            = -- TODO: need translate!
'Enable diagnostics for cases in which the type cannot be inferred.'
config.diagnostics['not-yieldable']         = -- TODO: need translate!
'Enable diagnostics for calls to `coroutine.yield()` when it is not permitted.'
config.diagnostics['param-type-mismatch']   = -- TODO: need translate!
'Enable diagnostics for function calls where the type of a provided parameter does not match the type of the annotated function definition.'
config.diagnostics['redundant-return']      = -- TODO: need translate!
'Enable diagnostics for return statements which are not needed because the function would exit on its own.'
config.diagnostics['redundant-return-value']= -- TODO: need translate!
'Enable diagnostics for return statements which return an extra value which is not specified by a return annotation.'
config.diagnostics['return-type-mismatch']  = -- TODO: need translate!
'Enable diagnostics for return values whose type does not match the type declared in the corresponding return annotation.'
config.diagnostics['spell-check']           = -- TODO: need translate!
'Enable diagnostics for typos in strings.'
config.diagnostics['name-style-check']      = -- TODO: need translate!
'Enable diagnostics for name style.'
config.diagnostics['unbalanced-assignments']= -- TODO: need translate!
'Enable diagnostics on multiple assignments if not all variables obtain a value (e.g., `local x,y = 1`).'
config.diagnostics['undefined-doc-class']   = -- TODO: need translate!
'Enable diagnostics for class annotations in which an undefined class is referenced.'
config.diagnostics['undefined-doc-name']    = -- TODO: need translate!
'Enable diagnostics for type annotations referencing an undefined type or alias.'
config.diagnostics['undefined-doc-param']   = -- TODO: need translate!
'Enable diagnostics for cases in which a parameter annotation is given without declaring the parameter in the function definition.'
config.diagnostics['undefined-field']       = -- TODO: need translate!
'Enable diagnostics for cases in which an undefined field of a variable is read.'
config.diagnostics['unknown-cast-variable'] = -- TODO: need translate!
'Enable diagnostics for casts of undefined variables.'
config.diagnostics['unknown-diag-code']     = -- TODO: need translate!
'Enable diagnostics in cases in which an unknown diagnostics code is entered.'
config.diagnostics['unknown-operator']      = -- TODO: need translate!
'Enable diagnostics for unknown operators.'
config.diagnostics['unreachable-code']      = -- TODO: need translate!
'Enable diagnostics for unreachable code.'
config.diagnostics['global-element']       = -- TODO: need translate!
'Enable diagnostics to warn about global elements.'
config.typeFormat.config                    = -- TODO: need translate!
'Configures the formatting behavior while typing Lua code.'
config.typeFormat.config.auto_complete_end  = -- TODO: need translate!
'Controls if `end` is automatically completed at suitable positions.'
config.typeFormat.config.auto_complete_table_sep = -- TODO: need translate!
'Controls if a separator is automatically appended at the end of a table declaration.'
config.typeFormat.config.format_line        = -- TODO: need translate!
'Controls if a line is formatted at all.'

command.exportDocument = -- TODO: need translate!
'Lua: Export Document ...'
command.addon_manager.open = -- TODO: need translate!
'Lua: Open Addon Manager ...'
command.reloadFFIMeta = -- TODO: need translate!
'Lua: Reload luajit ffi meta'
