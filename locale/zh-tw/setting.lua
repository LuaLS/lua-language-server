---@diagnostic disable: undefined-global

config.runtime.version            =
"Lua執行版本。"
config.runtime.path               =
[[
當使用 `require` 時，如何根據輸入的名字來查找檔案。
此選項設定為 `?/init.lua` 意味著當你輸入 `require 'myfile'` 時，會從已載入的檔案中搜尋 `{workspace}/myfile/init.lua`。
當 `runtime.pathStrict` 設定為 `false` 時，還會嘗試搜尋 `${workspace}/**/myfile/init.lua`。
如果你想要載入工作區以外的檔案，你需要先設定 `Lua.workspace.library`。
]]
config.runtime.pathStrict         =
'啟用後 `runtime.path` 將只搜尋第一層目錄，見 `runtime.path` 的説明。'
config.runtime.special            =
[[將自定義全域變數視為一些特殊的內建變數，語言服務將提供特殊的支援。
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
"延伸模組路徑，請查閲[文件](https://github.com/sumneko/lua-language-server/wiki/Plugin)瞭解用法。"
config.runtime.fileEncoding       =
"檔案編碼，`ansi` 選項只在 `Windows` 平台下有效。"
config.runtime.builtin            =
[[
調整內建庫的啟用狀態，你可以根據實際執行環境禁用掉不存在的庫（或重新定義）。

* `default`: 表示庫會根據執行版本啟用或禁用
* `enable`: 總是啟用
* `disable`: 總是禁用
]]
config.diagnostics.enable         =
"啟用診斷。"
config.diagnostics.disable        =
"禁用的診斷（使用浮框括號內的程式碼）。"
config.diagnostics.globals        =
"已定義的全域變數。"
config.diagnostics.severity       =
"修改診斷等級。"
config.diagnostics.neededFileStatus =
[[
* Opened:  只診斷打開的檔案
* Any:     診斷任何檔案
* Disable: 禁用此診斷
]]
config.diagnostics.workspaceDelay =
"進行工作區診斷的延遲（毫秒）。當你啟動工作區，或編輯了任意檔案後，將會在後台對整個工作區進行重新診斷。設定為負數可以禁用工作區診斷。"
config.diagnostics.workspaceRate  =
"工作區診斷的執行速率（百分比）。降低該值會減少CPU佔用，但是也會降低工作區診斷的速度。你目前正在編輯的檔案的診斷總是全速完成，不受該選項影響。"
config.diagnostics.libraryFiles   =
"如何診斷通過 `Lua.workspace.library` 載入的檔案。"
config.diagnostics.ignoredFiles   =
"如何診斷被忽略的檔案。"
config.diagnostics.files.Enable   =
"總是診斷這些檔案。"
config.diagnostics.files.Opened   =
"只有打開這些檔案時才會診斷。"
config.diagnostics.files.Disable  =
"不診斷這些檔案。"
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
"除了目前工作區以外，還會從哪些目錄中載入檔案。這些目錄中的檔案將被視作外部提供的程式碼庫，部分操作（如重命名欄位）不會修改這些檔案。"
config.workspace.checkThirdParty  =
[[
自動檢測與適應第三方庫，目前支援的庫為：

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]]
config.workspace.userThirdParty          =
'在這裡添加私有的第三方庫適應檔案路徑，請參考內建的[組態檔案路徑](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)'
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
'顯示關鍵字語法片段'
config.completion.keywordSnippet.Disable =
"只顯示 `關鍵字`。"
config.completion.keywordSnippet.Both    =
"顯示 `關鍵字` 與 `語法片段`。"
config.completion.keywordSnippet.Replace =
"只顯示 `語法片段`。"
config.completion.displayContext         =
"預覽建議的相關程式碼片段，可能可以幫助你瞭解這項建議的用法。設定的數字表示程式碼片段的截取行數，設定為`0`可以禁用此功能。"
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
"在建議列表中顯示函式的參數訊息，函式擁有多個定義時會分開顯示。"
config.completion.requireSeparator       =
"`require` 時使用的分隔符。"
config.completion.postfix                =
"用於觸發後綴建議的符號。"
config.color.mode                        =
"著色模式。"
config.color.mode.Semantic               =
"語義著色。你可能需要同時將 `editor.semanticHighlighting.enabled` 設定為 `true` 才能生效。"
config.color.mode.SemanticEnhanced       =
"增強的語義顏色。 類似於`Semantic`，但會進行額外的分析（也會帶來額外的開銷）。"
config.color.mode.Grammar                =
"語法著色。"
config.semantic.enable                   =
"啟用語義著色。你可能需要同時將 `editor.semanticHighlighting.enabled` 設定為 `true` 才能生效。"
config.semantic.variable                 =
"對變數/欄位/參數進行語義著色。"
config.semantic.annotation               =
"對類型註解進行語義著色。"
config.semantic.keyword                  =
"對關鍵字/字面常數/運算符進行語義著色。只有當你的編輯器無法進行語法著色時才需要啟用此功能。"
config.signatureHelp.enable              =
"啟用參數提示。"
config.hover.enable                      =
"啟用懸浮提示。"
config.hover.viewString                  =
"懸浮提示查看字串內容（僅當字面常數包含跳脫字元時）。"
config.hover.viewStringMax               =
"懸浮提示查看字串內容時的最大長度。"
config.hover.viewNumber                  =
"懸浮提示查看數字內容（僅當字面常數不是十進制時）。"
config.hover.fieldInfer                  =
"懸浮提示查看表時，會對表的每個欄位進行類型推測，當類型推測的用時累計達到該設定值（毫秒）時，將跳過後續欄位的類型推測。"
config.hover.previewFields               =
"懸浮提示查看表時，限制表內欄位的最大預覽數量。"
config.hover.enumsLimit                  =
"當值對應多個類型時，限制類型的顯示數量。"
config.develop.enable                    =
'開發者模式。請勿開啟，會影響效能。'
config.develop.debuggerPort              =
'除錯器監聽埠。'
config.develop.debuggerWait              =
'除錯器連接之前懸置。'
config.intelliSense.searchDepth          =
'設定智能感知的搜尋深度。增大該值可以增加準確度，但會降低效能。不同的項目對該設定的容忍度差異較大，請自己調整為合適的值。'
config.intelliSense.fastGlobal           =
'在對全域變數進行補全，及查看 `_G` 的懸浮提示時進行最佳化。這會略微降低類型推測的準確度，但是對於大量使用全域變數的項目會有大幅的效能提升。'
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
'禁用參數提示。'
config.hint.arrayIndex                   =
'在構造表時提示陣列索引。'
config.hint.arrayIndex.Enable            =
'所有的表中都提示陣列索引。'
config.hint.arrayIndex.Auto              =
'只有表大於3項，或者表是混合類型時才進行提示。'
config.hint.arrayIndex.Disable           =
'禁用陣列索引提示。'
config.format.enable                     =
'啟用程式碼格式化程式。'
config.telemetry.enable                  =
[[
啟用遙測，通過網路發送你的編輯器訊息與錯誤日誌。在[此處](https://github.com/sumneko/lua-language-server/wiki/%E9%9A%90%E7%A7%81%E5%A3%B0%E6%98%8E)閲讀我們的隱私聲明。
]]
config.misc.parameters                   =
'VSCode中啟動語言服務時的[命令列參數](https://github.com/sumneko/lua-language-server/wiki/Command-line)。'
config.IntelliSense.traceLocalSet        =
'請查閲[文件](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features)瞭解用法。'
config.IntelliSense.traceReturn          =
'請查閲[文件](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features)瞭解用法。'
config.IntelliSense.traceBeSetted        =
'請查閲[文件](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features)瞭解用法。'
config.IntelliSense.traceFieldInject     =
'請查閲[文件](https://github.com/sumneko/lua-language-server/wiki/IntelliSense-optional-features)瞭解用法。'
config.diagnostics['unused-local']          =
'未使用的局部變數'
config.diagnostics['unused-function']       =
'未使用的函式'
config.diagnostics['undefined-global']      =
'未定義的全域變數'
config.diagnostics['global-in-nil-env']     =
'不能使用全域變數（ `_ENV` 被設定為了 `nil`）'
config.diagnostics['unused-label']          =
'未使用的標籤'
config.diagnostics['unused-vararg']         =
'未使用的不定參數'
config.diagnostics['trailing-space']        =
'後置空格'
config.diagnostics['redefined-local']       =
'重複定義的局部變數'
config.diagnostics['newline-call']          =
'以 `(` 開始的新行，在語法上被解析為了上一行的函式呼叫'
config.diagnostics['newfield-call']         =
'在字面常數表中，2行程式碼之間缺少分隔符，在語法上被解析為了一次索引操作'
config.diagnostics['redundant-parameter']   =
'函式呼叫時，傳入了多餘的參數'
config.diagnostics['ambiguity-1']           =
'優先級歧義，如：`num or 0 + 1`，推測使用者的實際期望為 `(num or 0) + 1` '
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
