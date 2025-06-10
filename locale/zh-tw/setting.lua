---@diagnostic disable: undefined-global

config.addonManager.enable        =
"是否啟用延伸模組的附加插件管理器（Addon Manager）。"
config.addonManager.repositoryBranch =
"指定插件管理器（Addon Manager）使用的git branch。"
config.addonManager.repositoryPath =
"指定插件管理器（Addon Manager）使用的git path。"
config.addonRepositoryPath        = -- TODO: need translate!
"Specifies the addon repository path (not related to the addon manager)."
config.runtime.version            =
"Lua執行版本。"
config.runtime.path               =
[[
當使用 `require` 時，如何根據輸入的名字來尋找檔案。
此選項設定為 `?/init.lua` 時，代表當你輸入 `require 'myfile'` 時，會從已載入的檔案中搜尋 `{workspace}/myfile/init.lua`。
當 `runtime.pathStrict` 設定為 `false` 時，還會嘗試搜尋 `${workspace}/**/myfile/init.lua`。
如果你想要載入工作區以外的檔案，你需要先設定 `Lua.workspace.library`。
]]
config.runtime.pathStrict         =
'啟用後 `runtime.path` 將只搜尋第一層目錄，見 `runtime.path` 的說明。'
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
config.runtime.pluginArgs         =
"延伸模組的額外引數。"
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
config.diagnostics.globalsRegex   =
"使用正規表示式尋找全域變數。"
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
批次修改一個組中的診斷等級。
設定為 `Fallback` 意味著組中的診斷由 `diagnostics.severity` 單獨設定。
其他設定將覆蓋單獨設定，但是不會覆蓋以 `!` 結尾的設定。
]]
config.diagnostics.groupFileStatus =
[[
批次修改一個組中的檔案狀態。

* Opened:  只診斷打開的檔案
* Any:     診斷所有檔案
* None:    停用此診斷

設定為 `Fallback` 意味著組中的診斷由 `diagnostics.neededFileStatus` 單獨設定。
其他設定將覆蓋單獨設定，但是不會覆蓋以 `!` 結尾的設定。
]]
config.diagnostics.workspaceEvent =
"設定觸發工作區診斷的時機。"
config.diagnostics.workspaceEvent.OnChange =
"當檔案發生變化時觸發工作區診斷。"
config.diagnostics.workspaceEvent.OnSave =
"當儲存檔案時觸發工作區診斷。"
config.diagnostics.workspaceEvent.None =
"停用工作區診斷。"
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
config.diagnostics.unusedLocalExclude =
'如果變數名符合以下規則，則不對其進行 `unused-local` 診斷。'
config.workspace.ignoreDir        =
"忽略的檔案與目錄（使用 `.gitignore` 語法）。"
config.workspace.ignoreSubmodules =
"忽略子模組。"
config.workspace.useGitIgnore     =
"忽略 `.gitignore` 中列舉的檔案。"
config.workspace.maxPreload       =
"最大預先載入檔案數。"
config.workspace.preloadFileSize  =
"預先載入時跳過大小大於該值（KB）的檔案。"
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
"輸入內容看起來像檔名時，自動 `require` 此檔案。"
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
"增強的語義顏色。類似於 `Semantic` ，但會進行額外的分析（也會帶來額外的開銷）。"
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
是否展開別名。例如 `---@alias myType boolean|number` 展開後顯示為 `boolean|number`，否則顯示為 `myType`'。
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
'如果呼叫的函式被標記為了 `---@async`，則在呼叫處提示 `await`。'
config.hint.awaitPropagate               =
'啟用 `await` 的傳播，當一個函式呼叫了一個 `---@async` 標記的函式時，會自動標記為 `---@async`。'
config.hint.semicolon                    =
'若陳述式尾部沒有分號，則顯示虛擬分號。'
config.hint.semicolon.All                =
'所有陳述式都顯示虛擬分號。'
config.hint.semicolon.SameLine            =
'兩個陳述式在同一行時，在它們之間顯示分號。'
config.hint.semicolon.Disable            =
'停用虛擬分號。'
config.codeLens.enable                   =
'啟用CodeLens。'
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
[[
設定檢查命名風格的組態。
Read [formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) to learn usage.
]]
config.telemetry.enable                  =
[[
啟用遙測，透過網路發送你的編輯器資訊與錯誤日誌。在[此處](https://luals.github.io/privacy/#language-server)閱讀我們的隱私聲明。
]]
config.misc.parameters                   =
'VSCode內啟動語言伺服時的[命令列參數](https://luals.github.io/wiki/usage#arguments)。'
config.misc.executablePath               =
'指定VSCode內的可執行文件'
config.language.fixIndent                =
'（僅限VSCode）修復自動縮排錯誤，例如在有包含 "function" 的字串中換行時出現的錯誤縮排。'
config.language.completeAnnotation       =
'（僅限VSCode）在註解後換行時自動插入 "---@ "。'
config.type.castNumberToInteger          =
'允許將 `number` 類型賦值給 `integer` 類型。'
config.type.weakUnionCheck               =
[[
同位類型中只要有一個子類型滿足條件，則同位類型也滿足條件。

此設定為 `false` 時，`number|boolean` 類型無法賦值給 `number` 類型；為 `true` 時則可以。
]]
config.type.weakNilCheck                 =
[[
對同位類型進行類型檢查時，忽略其中的 `nil`。

此設定為 `false` 時，`number|boolean` 類型無法賦值給 `number` 類型；為 `true` 時則可以。
]]
config.type.inferParamType               =
[[
未註解參數類型時，參數類型由函式傳入參數推斷。

如果設定為 "false"，則在未註解時，參數類型為 "any"。
]]
config.type.checkTableShape              =
[[
對表的形狀進行嚴格檢查。
]]
config.type.inferTableSize               = -- TODO: need translate!
'Maximum number of table fields analyzed during type inference.'
config.doc.privateName                   =
'將特定名稱的欄位視為private，例如 `m_*` 代表 `XXX.m_id` 和 `XXX.m_type` 會是私有層級，只能在定義所在的類別內存取'
config.doc.protectedName                 =
'將特定名稱的欄位視為protected，例如 `m_*` 代表 `XXX.m_id` 和 `XXX.m_type` 會是保護層級，只能在定義所在的類別和其子類別內存取'
config.doc.packageName                   =
'將特定名稱的欄位視為package，例如 `m_*` 代表 `XXX.m_id` 和 `XXX.m_type` 只能在定義所在的檔案內存取'
config.doc.regengine                     = -- TODO: need translate!
'The regular expression engine used for matching documentation scope names.'
config.doc.regengine.glob                = -- TODO: need translate!
'The default lightweight pattern syntax.'
config.doc.regengine.lua                 = -- TODO: need translate!
'Full Lua-style regular expressions.'
config.docScriptPath                     = -- TODO: need translate!
'The regular expression engine used for matching documentation scope names.'
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
config.diagnostics['assign-type-mismatch']  =
'賦值類型與變數類型不符合'
config.diagnostics['await-in-sync']         =
'同步函式中呼叫非同步函式'
config.diagnostics['cast-local-type']    =
'已顯式定義變數類型不符合要定義的值的類型'
config.diagnostics['cast-type-mismatch']    =
'變數被轉換為不符合其初始類型的類型'
config.diagnostics['circular-doc-class']    =
'兩個類別互相繼承、循環'
config.diagnostics['close-non-object']      =
'嘗試關閉非物件變數'
config.diagnostics['code-after-break']      =
'迴圈內break陳述式後的程式碼'
config.diagnostics['codestyle-check']       =
'行的格式不正確'
config.diagnostics['count-down-loop']       =
'因為 `for` 迴圈是遞增而不是遞減，所以不會到達上限/極限'
config.diagnostics['deprecated']            =
'API已標記deprecated（棄用）但仍在使用'
config.diagnostics['different-requires']    =
'required的同一個檔案使用了兩個不同的名字'
config.diagnostics['discard-returns']       =
'忽略了標註為 `@nodiscard` 的函式的回傳值'
config.diagnostics['doc-field-no-class']    =
'向沒有標註 `@class` 的類別標註 `@field` 欄位'
config.diagnostics['duplicate-doc-alias']   =
'`@alias` 標註名字衝突'
config.diagnostics['duplicate-doc-field']   =
'`@field` 標註名字衝突'
config.diagnostics['duplicate-doc-param']   =
'`@param` 標註名字衝突'
config.diagnostics['duplicate-set-field']   =
'在類別中多次定義相同的欄位'
config.diagnostics['incomplete-signature-doc'] =
'`@param` 或 `@return` 不完整'
config.diagnostics['invisible']             =
'嘗試存取不可見的欄位'
config.diagnostics['missing-global-doc']    =
'全域變數缺少標註（全域函式必須為所有參數和回傳值提供標註）'
config.diagnostics['missing-local-export-doc'] =
'匯出的區域函式缺少標註（匯出的區域函式、所有的參數和回傳值都必須有標註）'
config.diagnostics['missing-parameter']     =
'函式呼叫的引數數量比函式標註的參數數量少'
config.diagnostics['missing-return']        =
'函式有 `@return` 標註卻沒有 `return` 陳述式'
config.diagnostics['missing-return-value']  =
'函式沒有回傳值，但使用了 `@return` 標註了回傳值'
config.diagnostics['need-check-nil']        =
'變數曾被賦值為 `nil` 或可選值（可能是 `nil` ）'
config.diagnostics['unnecessary-assert']    =
'對始終為true的陳述式的冗餘斷言'
config.diagnostics['no-unknown']            =
'無法推斷變數的未知類型'
config.diagnostics['not-yieldable']         =
'不允許呼叫 `coroutine.yield()`'
config.diagnostics['param-type-mismatch']   =
'給定參數的類型不符合函式定義所要求的類型（ `@param` ）'
config.diagnostics['redundant-return']      =
'放了一個不需要的 `return` 陳述式，因為函式會自行退出'
config.diagnostics['redundant-return-value']=
'回傳了 `@return` 標註未指定的額外值'
config.diagnostics['return-type-mismatch']  =
'回傳值的類型不符合 `@return` 中宣告的類型'
config.diagnostics['spell-check']           =
'字串拼寫檢查'
config.diagnostics['name-style-check']      =
'變數命名風格檢查'
config.diagnostics['unbalanced-assignments']=
'多重賦值時沒有賦值所有變數（如 `local x,y = 1` ）'
config.diagnostics['undefined-doc-class']   =
'在 `@class` 標註中引用未定義的類別。'
config.diagnostics['undefined-doc-name']    =
'在 `@type` 標註中引用未定義的類型或 `@alias`'
config.diagnostics['undefined-doc-param']   =
'在 `@param` 標註中引用函式定義未宣告的參數'
config.diagnostics['undefined-field']       =
'讀取變數中為定義的欄位'
config.diagnostics['unknown-cast-variable'] =
'使用 `@cast` 對未定義的變數進行強制轉換'
config.diagnostics['unknown-diag-code']     =
'輸入了未知的診斷'
config.diagnostics['unknown-operator']      =
'未知的運算子'
config.diagnostics['unreachable-code']      =
'無法到達的程式碼'
config.diagnostics['global-element']       =
'對全域元素的警告'
config.typeFormat.config                    =
'寫Lua程式碼時的格式化組態'
config.typeFormat.config.auto_complete_end  =
'是否在合適的位置自動完成 `end`'
config.typeFormat.config.auto_complete_table_sep =
'是否在宣告表的結尾自動添加分隔符號'
config.typeFormat.config.format_line        =
'是否格式化某一行'

command.exportDocument =
'Lua：輸出文件…'
command.addon_manager.open =
'Lua：打開插件管理器（Addon Manager）…'
command.reloadFFIMeta =
'Lua：重新生成luajit的FFI模組C語言中繼資料'
command.startServer =
'Lua：（除錯）重新啟動語言伺服'
command.stopServer =
'Lua：（除錯）停止語言伺服'
