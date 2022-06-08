# completion.autoRequire

輸入內容看起來是個檔名時，自動 `require` 此檔案。

## type
`boolean`

## default

`true`

# completion.callSnippet

顯示函式呼叫片段。

## type
`string`

## default

`"Disable"`

## enum

* `"Disable"`: 只顯示 `函式名`。
* `"Both"`: 顯示 `函式名` 與 `呼叫片段`。
* `"Replace"`: 只顯示 `呼叫片段`。

# completion.displayContext

預覽建議的相關程式碼片段，可能可以幫助你瞭解這項建議的用法。設定的數字表示程式碼片段的擷取行數，設定為 `0` 可以停用此功能。

## type
`integer`

## default

`0`

# completion.enable

啟用自動完成。

## type
`boolean`

## default

`true`

# completion.keywordSnippet

顯示關鍵字語法片段。

## type
`string`

## default

`"Replace"`

## enum

* `"Disable"`: 只顯示 `關鍵字`。
* `"Both"`: 顯示 `關鍵字` 與 `語法片段`。
* `"Replace"`: 只顯示 `語法片段`。

# completion.postfix

用於觸發後綴建議的符號。

## type
`string`

## default

`"@"`

# completion.requireSeparator

`require` 時使用的分隔符。

## type
`string`

## default

`"."`

# completion.showParams

在建議列表中顯示函式的參數資訊，函式擁有多個定義時會分開顯示。

## type
`boolean`

## default

`true`

# completion.showWord

在建議中顯示上下文單詞。

## type
`string`

## default

`"Fallback"`

## enum

* `"Enable"`: 總是在建議中顯示上下文單詞。
* `"Fallback"`: 無法根據語義提供建議時才顯示上下文單詞。
* `"Disable"`: 不顯示上下文單詞。

# completion.workspaceWord

顯示的上下文單詞是否包含工作區中其他檔案的內容。

## type
`boolean`

## default

`true`

# diagnostics.disable

停用的診斷（使用浮框括號內的程式碼）。

## type
`array<string>`

## default

`[]`

# diagnostics.disableScheme

不診斷使用以下 scheme 的lua檔案。

## type
`array<string>`

## default

`[ "git" ]`

# diagnostics.enable

啟用診斷。

## type
`boolean`

## default

`true`

# diagnostics.globals

已定義的全域變數。

## type
`array<string>`

## default

`[]`

# diagnostics.ignoredFiles

如何診斷被忽略的檔案。

## type
`string`

## default

`"Opened"`

## enum

* `"Enable"`: 總是診斷這些檔案。
* `"Opened"`: 只有打開這些檔案時才會診斷。
* `"Disable"`: 不診斷這些檔案。

# diagnostics.libraryFiles

如何診斷透過 `Lua.workspace.library` 載入的檔案。

## type
`string`

## default

`"Opened"`

## enum

* `"Enable"`: 總是診斷這些檔案。
* `"Opened"`: 只有打開這些檔案時才會診斷。
* `"Disable"`: 不診斷這些檔案。

# diagnostics.neededFileStatus

* Opened:  只診斷打開的檔案
* Any:     診斷任何檔案
* Disable: 停用此診斷


## type
`object`

# diagnostics.severity

修改診斷等級。

## type
`object`

# diagnostics.workspaceDelay

進行工作區診斷的延遲（毫秒）。當你啟動工作區，或編輯了任意檔案後，將會在背景對整個工作區進行重新診斷。設定為負數可以停用工作區診斷。

## type
`integer`

## default

`3000`

# diagnostics.workspaceRate

工作區診斷的執行速率（百分比）。降低該值會減少CPU佔用，但是也會降低工作區診斷的速度。你目前正在編輯的檔案的診斷總是全速完成，不受該選項影響。

## type
`integer`

## default

`100`

# format.defaultConfig

**Missing description!!**

## type
`object`

## default

`{}`

# format.enable

啟用程式碼格式化程式。

## type
`boolean`

## default

`true`

# hint.arrayIndex

在建構表時提示陣列索引。

## type
`string`

## default

`"Auto"`

## enum

* `"Enable"`: 所有的表中都提示陣列索引。
* `"Auto"`: 只有表大於3項，或者表是混合型別時才進行提示。
* `"Disable"`: 停用陣列索引提示。

# hint.await

**Missing description!!**

## type
`boolean`

## default

`true`

# hint.enable

啟用內嵌提示。

## type
`boolean`

# hint.paramName

在函式呼叫處提示參數名。

## type
`string`

## default

`"All"`

## enum

* `"All"`: 所有型別的參數均進行提示。
* `"Literal"`: 只有字面常數型別的參數進行提示。
* `"Disable"`: 停用參數提示。

# hint.paramType

在函式的參數位置提示型別。

## type
`boolean`

## default

`true`

# hint.setType

在賦值操作位置提示型別。

## type
`boolean`

# hover.enable

啟用懸浮提示。

## type
`boolean`

## default

`true`

# hover.enumsLimit

當值對應多個型別時，限制型別的顯示數量。

## type
`integer`

## default

`5`

# hover.expandAlias

**Missing description!!**

## type
`boolean`

## default

`true`

# hover.previewFields

懸浮提示檢視表時，限制表內欄位的最大預覽數量。

## type
`integer`

## default

`20`

# hover.viewNumber

懸浮提示檢視數字內容（僅當字面常數不是十進制時）。

## type
`boolean`

## default

`true`

# hover.viewString

懸浮提示檢視字串內容（僅當字面常數包含跳脫字元時）。

## type
`boolean`

## default

`true`

# hover.viewStringMax

懸浮提示檢視字串內容時的最大長度。

## type
`integer`

## default

`1000`

# misc.parameters

VSCode中啟動語言服務時的[命令列參數](https://github.com/sumneko/lua-language-server/wiki/Command-line)。

## type
`array<string>`

## default

`[]`

# runtime.builtin

調整內建庫的啟用狀態，你可以根據實際執行環境停用不存在的庫（或重新定義）。

* `default`: 表示庫會根據執行版本啟用或停用
* `enable`: 總是啟用
* `disable`: 總是停用


## type
`object`

# runtime.fileEncoding

檔案編碼，`ansi` 選項只在 `Windows` 平台下有效。

## type
`string`

## default

`"utf8"`

## enum

* `"utf8"`
* `"ansi"`
* `"utf16le"`
* `"utf16be"`

# runtime.meta

**Missing description!!**

## type
`string`

## default

`"${version} ${language} ${encoding}"`

# runtime.nonstandardSymbol

支援非標準的符號。請務必確認你的執行環境支援這些符號。

## type
`array<string>`

## default

`[]`

# runtime.path

當使用 `require` 時，如何根據輸入的名字來尋找檔案。
此選項設定為 `?/init.lua` 意味著當你輸入 `require 'myfile'` 時，會從已載入的檔案中搜尋 `{workspace}/myfile/init.lua`。
當 `runtime.pathStrict` 設定為 `false` 時，還會嘗試搜尋 `${workspace}/**/myfile/init.lua`。
如果你想要載入工作區以外的檔案，你需要先設定 `Lua.workspace.library`。


## type
`array<string>`

## default

`[ "?.lua", "?/init.lua" ]`

# runtime.pathStrict

啟用後 `runtime.path` 將只搜尋第一層目錄，見 `runtime.path` 的説明。

## type
`boolean`

# runtime.plugin

延伸模組路徑，請查閲[文件](https://github.com/sumneko/lua-language-server/wiki/Plugin)瞭解用法。

## type
`string`

## default

`""`

# runtime.special

將自訂全域變數視為一些特殊的內建變數，語言服務將提供特殊的支援。
下面這個例子表示將 `include` 視為 `require` 。
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```


## type
`object`

## default

`{}`

# runtime.unicodeName

允許在名字中使用 Unicode 字元。

## type
`boolean`

# runtime.version

Lua執行版本。

## type
`string`

## default

`"Lua 5.4"`

## enum

* `"Lua 5.1"`
* `"Lua 5.2"`
* `"Lua 5.3"`
* `"Lua 5.4"`
* `"LuaJIT"`

# semantic.annotation

對型別註解進行語義著色。

## type
`boolean`

## default

`true`

# semantic.enable

啟用語義著色。你可能需要同時將 `editor.semanticHighlighting.enabled` 設定為 `true` 才能生效。

## type
`boolean`

## default

`true`

# semantic.keyword

對關鍵字/字面常數/運算子進行語義著色。只有當你的編輯器無法進行語法著色時才需要啟用此功能。

## type
`boolean`

# semantic.variable

對變數/欄位/參數進行語義著色。

## type
`boolean`

## default

`true`

# signatureHelp.enable

啟用參數提示。

## type
`boolean`

## default

`true`

# spell.dict

**Missing description!!**

## type
`array<string>`

## default

`[]`

# telemetry.enable

啟用遙測，透過網路發送你的編輯器資訊與錯誤日誌。在[此處](https://github.com/sumneko/lua-language-server/wiki/%E9%9A%B1%E7%A7%81%E8%81%B2%E6%98%8E)閲讀我們的隱私聲明。


## type
`boolean | null`

## default

`nil`

# window.progressBar

在狀態欄顯示進度條。

## type
`boolean`

## default

`true`

# window.statusBar

在狀態欄顯示延伸模組狀態。

## type
`boolean`

## default

`true`

# workspace.checkThirdParty

自動偵測與適應第三方庫，目前支援的庫為：

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass


## type
`boolean`

## default

`true`

# workspace.ignoreDir

忽略的檔案與目錄（使用 `.gitignore` 語法）。

## type
`array<string>`

## default

`[ ".vscode" ]`

# workspace.ignoreSubmodules

忽略子模組。

## type
`boolean`

## default

`true`

# workspace.library

除了目前工作區以外，還會從哪些目錄中載入檔案。這些目錄中的檔案將被視作外部提供的程式碼庫，部分操作（如重新命名欄位）不會修改這些檔案。

## type
`array<string>`

## default

`[]`

# workspace.maxPreload

最大預載入檔案數。

## type
`integer`

## default

`5000`

# workspace.preloadFileSize

預載入時跳過大小大於該值（KB）的檔案。

## type
`integer`

## default

`500`

# workspace.supportScheme

為以下 `scheme` 的lua檔案提供語言服務。

## type
`array<string>`

## default

`[ "file", "untitled", "git" ]`

# workspace.useGitIgnore

忽略 `.gitignore` 中列舉的檔案。

## type
`boolean`

## default

`true`

# workspace.userThirdParty

在這裡添加私有的第三方庫適應檔案路徑，請參考內建的[組態檔案路徑](https://github.com/sumneko/lua-language-server/tree/master/meta/3rd)

## type
`array<string>`

## default

`[]`