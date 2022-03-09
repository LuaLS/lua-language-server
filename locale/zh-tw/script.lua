DIAG_LINE_ONLY_SPACE =
'只有空格的空行。 '
DIAG_LINE_POST_SPACE =
'後置空格。 '
DIAG_UNUSED_LOCAL =
'未使用的區域變數`{}`。 '
DIAG_UNDEF_GLOBAL =
'未定義的全域變數`{}`。 '
DIAG_UNDEF_FIELD =
'未定義的屬性/欄位`{}`。 '
DIAG_UNDEF_ENV_CHILD =
'未定義的變數`{}`（重載了`_ENV` ）。 '
DIAG_UNDEF_FENV_CHILD =
'未定義的變數`{}`（處於模組中）。 '
DIAG_GLOBAL_IN_NIL_ENV =
'不能使用全域變數（`_ENV`被置為了`nil`）。 '
DIAG_GLOBAL_IN_NIL_FENV =
'不能使用全域變數（模組被置為了`nil`）。 '
DIAG_UNUSED_LABEL =
'未使用的標籤`{}`。 '
DIAG_UNUSED_FUNCTION =
'未使用的函式。 '
DIAG_UNUSED_VARARG =
'未使用的不定參數。 '
DIAG_REDEFINED_LOCAL =
'重定義區域變數`{}`。 '
DIAG_DUPLICATE_INDEX =
'重複的索引`{}`。 '
DIAG_DUPLICATE_METHOD =
'重複的方法`{}`。 '
DIAG_PREVIOUS_CALL =
'會被解釋為`{}{}`。你可能需要加一個`;`。 '
DIAG_PREFIELD_CALL =
'會被解釋為`{}{}`。你可能需要加一個`,`或`;`。 '
DIAG_OVER_MAX_ARGS =
'函式只接收{:d} 個參數，但你傳了{:d} 個。 '
DIAG_OVER_MAX_VALUES =
'只有{} 個變數，但你設定了{} 個值。 '
DIAG_AMBIGUITY_1 =
'會優先運算`{}`，你可能需要加個括號。 '
DIAG_LOWERCASE_GLOBAL =
'首字母小寫的全域變數，你是否漏了`local` 或是有拼寫錯誤？ '
DIAG_EMPTY_BLOCK =
'空程式碼區塊'
DIAG_DIAGNOSTICS =
'Lua 診斷'
DIAG_SYNTAX_CHECK =
'Lua 語法檢查'
DIAG_NEED_VERSION =
'在{} 中是合法的，目前為{}'
DIAG_DEFINED_VERSION =
'在{} 中有定義，目前為{}'
DIAG_DEFINED_CUSTOM =
'在{} 中有定義'
DIAG_DUPLICATE_CLASS =
'重複定義的Class `{}`。 '
DIAG_UNDEFINED_CLASS =
'未定義的Class `{}`。 '
DIAG_CYCLIC_EXTENDS =
'循環繼承。 '
DIAG_INEXISTENT_PARAM =
'不存在的參數。 '
DIAG_DUPLICATE_PARAM =
'重複的參數。 '
DIAG_NEED_CLASS =
'需要先定義Class 。 '
DIAG_DUPLICATE_SET_FIELD=
'重複定義的欄位`{}`。 '
DIAG_SET_CONST =
'不能對常數賦值。 '
DIAG_SET_FOR_STATE =
'修改了循環變數。 '
DIAG_CODE_AFTER_BREAK =
'無法執行到`break` 後的程式碼。 '
DIAG_UNBALANCED_ASSIGNMENTS =
'由於值的數量不夠而被賦值為了`nil` 。在Lua中, `x, y = 1` 等價於`x, y = 1, nil` 。 '
DIAG_REQUIRE_LIKE =
'你可以在設定中將`{}` 視為`require`。 '
DIAG_COSE_NON_OBJECT =
'無法close 此類型的值。 （除非給此類型設定`__close` 元方法）'
DIAG_COUNT_DOWN_LOOP =
'你的意思是`{}` 嗎？ '
DIAG_IMPLICIT_ANY =
'無法推測出類型。 '
DIAG_DEPRECATED =
'已廢棄。 '
DIAG_DIFFERENT_REQUIRES =
'使用了不同的名字require 了同一個檔案。 '
DIAG_REDUNDANT_RETURN =
'冗餘回傳。 '
DIAG_AWAIT_IN_SYNC =
'只能在標記為異步的函式中呼叫異步函式。 '
DIAG_NOT_YIELDABLE =
'此函式的第{} 個參數沒有被標記為可讓出，但是傳入了異步函式。 （使用`---@param name async fun()` 來標記為可讓出）'
DIAG_DISCARD_RETURNS =
'不能丟棄此函式的回傳值。 '

DIAG_CIRCLE_DOC_CLASS =
'循環繼承的類別。 '
DIAG_DOC_FIELD_NO_CLASS =
'欄位必須定義在類別之後。 '
DIAG_DUPLICATE_DOC_CLASS =
'重複定義的類別`{}`。 '
DIAG_DUPLICATE_DOC_FIELD =
'重複定義的欄位`{}`。 '
DIAG_DUPLICATE_DOC_PARAM =
'重複指向的參數`{}`。 '
DIAG_UNDEFINED_DOC_CLASS =
'未定義的類別`{}`。 '
DIAG_UNDEFINED_DOC_NAME =
'未定義的類型或別名`{}`。 '
DIAG_UNDEFINED_DOC_PARAM =
'指向了未定義的參數`{}`。 '
DIAG_UNKNOWN_DIAG_CODE =
'未知的診斷代碼`{}`。 '

MWS_NOT_SUPPORT =
'{} 目前還不支援多工作目錄，我可能需要重啟才能支援新的工作目錄...'
MWS_RESTART =
'重啟'
MWS_NOT_COMPLETE =
'工作目錄還沒有準備好，你可以稍後再試一下...'
MWS_COMPLETE =
'工作目錄準備好了，你可以再試一下了...'
MWS_MAX_PRELOAD =
'預載入檔案數已達上限（{}），你需要手動打開需要載入的檔案。 '
MWS_UCONFIG_FAILED =
'使用者設定儲存失敗。 '
MWS_UCONFIG_UPDATED =
'使用者設定已更新。 '
MWS_WCONFIG_UPDATED =
'工作區設定已更新。 '

WORKSPACE_SKIP_LARGE_FILE =
'已跳過過大的檔案：{}。目前設定的大小限制為：{} KB，該檔案大小為：{} KB'
WORKSPACE_LOADING =
'正在載入工作目錄'
WORKSPACE_DIAGNOSTIC =
'正在對工作目錄進行診斷'
WORKSPACE_SKIP_HUGE_FILE =
'出於效能考慮，已停止對此檔案解析：{}'

PARSER_CRASH =
'語法解析崩潰了！遺言：{}'
PARSER_UNKNOWN =
'未知語法錯誤...'
PARSER_MISS_NAME =
'缺少名稱。 '
PARSER_UNKNOWN_SYMBOL =
'未知符號`{symbol}`。 '
PARSER_MISS_SYMBOL =
'缺少符號`{symbol}`。 '
PARSER_MISS_ESC_X =
'必須是2個16進制字元。 '
PARSER_UTF8_SMALL =
'至少有1個字元。 '
PARSER_UTF8_MAX =
'必須在{min} 與{max} 之間。 '
PARSER_ERR_ESC =
'錯誤的轉義符。 '
PARSER_MUST_X16 =
'必須是16進制字元。 '
PARSER_MISS_EXPONENT =
'缺少指數部分。 '
PARSER_MISS_EXP =
'缺少表達式。 '
PARSER_MISS_FIELD =
'缺少欄位/屬性名。 '
PARSER_MISS_METHOD =
'缺少方法名。 '
PARSER_ARGS_AFTER_DOTS =
'`...`必須是最後一個參數。 '
PARSER_KEYWORD =
'關鍵字無法作為名稱。 '
PARSER_EXP_IN_ACTION =
'該表達式不能作為語句。 '
PARSER_BREAK_OUTSIDE =
'`break`必須在循環內部。 '
PARSER_MALFORMED_NUMBER =
'無法構成有效數字。 '
PARSER_ACTION_AFTER_RETURN =
'`return`之後不能再執行程式碼。 '
PARSER_ACTION_AFTER_BREAK =
'`break`之後不能再執行程式碼。 '
PARSER_NO_VISIBLE_LABEL =
'標籤`{label}`不可見。 '
PARSER_REDEFINE_LABEL =
'標籤`{label}`重複定義。 '
PARSER_UNSUPPORT_SYMBOL =
'{version} 不支援該符號。 '
PARSER_UNEXPECT_DOTS =
'`...`只能在不定參函式中使用。 '
PARSER_UNEXPECT_SYMBOL =
'未知的符號`{symbol}` 。 '
PARSER_UNKNOWN_TAG =
'不支援的屬性。 '
PARSER_MULTI_TAG =
'只能設定一個屬性。 '
PARSER_UNEXPECT_LFUNC_NAME =
'區域函式只能使用識別符作為名稱。 '
PARSER_UNEXPECT_EFUNC_NAME =
'函式作為表達式時不能命名。 '
PARSER_ERR_LCOMMENT_END =
'應使用`{symbol}`來關閉多行註解。 '
PARSER_ERR_C_LONG_COMMENT =
'Lua應使用`--[[ ]]`來進行多行註解。 '
PARSER_ERR_LSTRING_END =
'應使用`{symbol}`來關閉長字串。 '
PARSER_ERR_ASSIGN_AS_EQ =
'應使用`=`來進行賦值操作。 '
PARSER_ERR_EQ_AS_ASSIGN =
'應使用`==`來進行等於判斷。 '
PARSER_ERR_UEQ =
'應使用`~=`來進行不等於判斷。 '
PARSER_ERR_THEN_AS_DO =
'應使用`then`。 '
PARSER_ERR_DO_AS_THEN =
'應使用`do`。 '
PARSER_MISS_END =
'缺少對應的`end`。 '
PARSER_ERR_COMMENT_PREFIX =
'Lua應使用`--`來進行註解。 '
PARSER_MISS_SEP_IN_TABLE =
'需要用`,`或`;`進行分割。 '
PARSER_SET_CONST =
'不能對常數賦值。 '
PARSER_UNICODE_NAME =
'包含了Unicode 字元。 '
PARSER_ERR_NONSTANDARD_SYMBOL =
'Lua中應使用符號`{symbol}`。 '
PARSER_MISS_SPACE_BETWEEN =
'符號之間必須保留空格'
PARSER_INDEX_IN_FUNC_NAME =
'命名函式的名稱中不能使用`[name]` 形式。 '
PARSER_UNKNOWN_ATTRIBUTE =
'區域變數屬性應該是`const` 或`close`'

PARSER_LUADOC_MISS_CLASS_NAME =
'缺少類別名稱。 '
PARSER_LUADOC_MISS_EXTENDS_SYMBOL =
'缺少符號`:`。 '
PARSER_LUADOC_MISS_CLASS_EXTENDS_NAME =
'缺少要繼承的類別名稱。 '
PARSER_LUADOC_MISS_SYMBOL =
'缺少符號`{symbol}`。 '
PARSER_LUADOC_MISS_ARG_NAME =
'缺少參數名稱。 '
PARSER_LUADOC_MISS_TYPE_NAME =
'缺少類型名。 '
PARSER_LUADOC_MISS_ALIAS_NAME =
'缺少別名。 '
PARSER_LUADOC_MISS_ALIAS_EXTENDS =
'缺少別名定義。 '
PARSER_LUADOC_MISS_PARAM_NAME =
'缺少要指向的參數名稱。 '
PARSER_LUADOC_MISS_PARAM_EXTENDS =
'缺少參數的類型定義。 '
PARSER_LUADOC_MISS_FIELD_NAME =
'缺少欄位名稱。 '
PARSER_LUADOC_MISS_FIELD_EXTENDS =
'缺少欄位的類型定義。 '
PARSER_LUADOC_MISS_GENERIC_NAME =
'缺少泛型名稱。 '
PARSER_LUADOC_MISS_GENERIC_EXTENDS_NAME =
'缺少泛型要繼承的類名稱。 '
PARSER_LUADOC_MISS_VARARG_TYPE =
'缺少不定參的類型定義。 '
PARSER_LUADOC_MISS_FUN_AFTER_OVERLOAD =
'缺少關鍵字`fun`。 '
PARSER_LUADOC_MISS_CATE_NAME =
'缺少文件類型名稱。 '
PARSER_LUADOC_MISS_DIAG_MODE =
'缺少診斷模式'
PARSER_LUADOC_ERROR_DIAG_MODE =
'診斷模式不正確'

SYMBOL_ANONYMOUS =
'<匿名函式>'

HOVER_VIEW_DOCUMENTS =
'查看文件'

HOVER_DOCUMENT_LUA51 =
'http://www.lua.org/manual/5.1/manual.html#{}'
HOVER_DOCUMENT_LUA52 =
'http://www.lua.org/manual/5.2/manual.html#{}'
HOVER_DOCUMENT_LUA53 =
'http://cloudwu.github.io/lua53doc/manual.html#{}'
HOVER_DOCUMENT_LUA54 =
'http://www.lua.org/manual/5.4/manual.html#{}'
HOVER_DOCUMENT_LUAJIT =
'http://www.lua.org/manual/5.1/manual.html#{}'

HOVER_NATIVE_DOCUMENT_LUA51 =
'command:extension.lua.doc?["en-us/51/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA52 =
'command:extension.lua.doc?["en-us/52/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA53 =
'command:extension.lua.doc?["zh-cn/53/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA54 =
'command:extension.lua.doc?["en-us/54/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUAJIT =
'command:extension.lua.doc?["en-us/51/manual.html/{}"]'

HOVER_MULTI_PROTOTYPE =
'({} 個原型)'
HOVER_STRING_BYTES =
'{} 個位元組'
HOVER_S TRING_CHARACTERS =
'{} 個位元組，{} 個字元'
HOVER_MULTI_DEF_PROTO =
'({} 個定義，{} 個原型)'
HOVER_MULTI_PROTO_NOT_FUNC =
'({} 個非函式定義)'

HOVER_USE_LUA_PATH =
'（搜索路徑： `{}`）'
HOVER_EXTENDS =
'展開為{}'
HOVER_TABLE_TIME_UP =
'出於效能考慮，已禁用了部分類型推斷。 '
HOVER_WS_LOADING =
'正在載入工作目錄：{} / {}'

ACTION_DISABLE_DIAG =
'在工作區禁用診斷({})。 '
ACTION_MARK_GLOBAL =
'標記`{}` 為已定義的全域變數。 '
ACTION_REMOVE_SPACE =
'清除所有後置空格。 '
ACTION_ADD_SEMICOLON =
'添加`;` 。 '
ACTION_ADD_BRACKETS =
'添加括號。 '
ACTION_RUNTIME_VERSION =
'修改執行版本為{} 。 '
ACTION_OPEN_LIBRARY =
'載入{} 中的全域變數。 '
ACTION_ADD_DO_END =
'添加`do ... end` 。 '
ACTION_FIX_LCOMMENT_END =
'改用正確的多行註解關閉符號。 '
ACTION_ADD_LCOMMENT_END =
'關閉多行註解。 '
ACTION_FIX_C_LONG_COMMENT =
'修改為Lua 的多行註解格式。 '
ACTION_FIX_LSTRING_END =
'改用正確的長字串關閉符號。 '
ACTION_ADD_LSTRING_END =
'關閉長字串。 '
ACTION_FIX_ASSIGN_AS_EQ =
'改為`=` 。 '
ACTION_FIX_EQ_AS_ASSIGN =
'改為`==` 。 '
ACTION_FIX_UEQ =
'改為`~=` 。 '
ACTION_FIX_THEN_AS_DO =
'改為`then` 。 '
ACTION_FIX_DO_AS_THEN =
'改為`do` 。 '
ACTION_ADD_END =
'添加`end` （根據縮排推測添加位置）。 '
ACTION_FIX_COMMENT_PREFIX =
'改為`--` 。 '
ACTION_FIX_NONSTANDARD_SYMBOL =
'改為`{symbol}`'
ACTION_RUNTIME_UNICODE_NAME =
'允許使用Unicode 字元。 '
ACTION_SWAP_PARAMS =
'將其改為`{node}` 的第{index} 個參數'
ACTION_FIX_INSERT_SPACE =
'插入空格'
ACTION_JSON_TO_LUA =
'把JSON 轉成Lua'
ACTION_DISABLE_DIAG_LINE=
'在此行禁用診斷({})。 '
ACTION_DISABLE_DIAG_FILE=
'在此檔案禁用診斷({})。 '
ACTION_MARK_ASYNC =
'將目前函式標記為異步。 '

COMMAND_DISABLE_DIAG =
'禁用診斷'
COMMAND_MARK_GLOBAL =
'標記全域變數'
COMMAND_REMOVE_SPACE =
'清除所有後置空格'
COMMAND_ADD_BRACKETS =
'添加括號'
COMMAND_RUNTIME_VERSION =
'修改執行版本'
COMMAND_OPEN_LIBRARY =
'載入第三方庫中的全域變數'
COMMAND_UNICODE_NAME =
'允許使用Unicode 字元'
COMMAND_JSON_TO_LUA =
'JSON 轉Lua'
COMMAND_JSON_TO_LUA_FAILED =
'JSON 轉Lua 失敗：{}'

COMPLETION_IMPORT_FROM =
'從{} 中導入'
COMPLETION_DISABLE_AUTO_REQUIRE =
'禁用自動require'
COMPLETION_ASK_AUTO_REQUIRE =
'在檔案頂部添加程式碼require 此檔案？ '

DEBUG_MEMORY_LEAK =
'{} 很抱歉發生了嚴重的記憶體流失，語言服務即將重啟。 '
DEBUG_RESTART_NOW =
'立即重啟'

WINDOW_COMPILING =
'正在編譯'
WINDOW_DIAGNOSING =
'正在診斷'
WINDOW_INITIALIZING =
'正在初始化...'
WINDOW_PROCESSING_HOVER =
'正在處理懸浮提示...'
WINDOW_PROCESSING_DEFINITION =
'正在處理轉到定義...'
WINDOW_PROCESSING_REFERENCE =
'正在處理轉到引用...'
WINDOW_PROCESSING_RENAME =
'正在處理重命名...'
WINDOW_PROCESSING_COMPLETION =
'正在處理自動完成...'
WINDOW_PROCESSING_SIGNATURE =
'正在處理參數提示...'
WINDOW_PROCESSING_SYMBOL =
'正在處理檔案符號...'
WINDOW_PROCESSING_WS_SYMBOL =
'正在處理工作區符號...'
WINDOW_PROCESSING_SEMANTIC_FULL =
'正在處理全量語義著色...'
WINDOW_PROCESSING_SEMANTIC_RANGE =
'正在處理差量語義著色...'
WINDOW_PROCESSING_HINT =
'正在處理內嵌提示...'
WINDOW_INCREASE_UPPER_LIMIT =
'增加上限'
WINDOW_CLOSE =
'關閉'
WINDOW_SETTING_WS_DIAGNOSTIC =
'你可以在設定中延遲或禁用工作目錄診斷'
WINDOW_DONT_SHOW_AGAIN =
'不再提示'
WINDOW_DELAY_WS_DIAGNOSTIC =
'空閒時診斷（延遲{}秒）'
WINDOW_DISABLE_DIAGNOSTIC =
'禁用工作區診斷'
WINDOW_LUA_STATUS_WORKSPACE =
'工作區：{}'
WINDOW_LUA_STATUS_CACHED_FILES =
'已快取檔案：{ast}/{max}'
WINDOW_LUA_STATUS_MEMORY_COUNT =
'記憶體佔用：{mem:.f}M'
WINDOW_LUA_STATUS_TIP =
[[

這個圖標是貓，
不是狗也不是狐狸！
             ↓↓↓
]]
WINDOW_APPLY_SETTING =
'套用設定'
WINDOW_CHECK_SEMANTIC =
'如果你正在使用商城中的顏色主題，你可能需要同時修改`editor.semanticHighlighting.enabled` 選項為`true` 才會使語義著色生效。 '
WINDOW_TELEMETRY_HINT =
'請允許發送匿名的使用資料與錯誤報告，幫助我們進一步完善此延伸模組。在[此處](https://github.com/sumneko/lua-language-server/wiki/%E9%9A%90%E7%A7%81%E5%A3%B0%E6%98%8E)閱讀我們的隱私聲明。 '
WINDOW_TELEMETRY_ENABLE =
'允許'
WINDOW_TELEMETRY_DISABLE =
'禁止'
WINDOW_CLIENT_NOT_SUPPORT_CONFIG =
'你的使用者端不支援從伺服端修改設定，請手動修改以下設定：'
WINDOW_LCONFIG_NOT_SUPPORT_CONFIG=
'暫不支援自動修改本地設定，請手動修改以下設定：'
WINDOW_MANUAL_CONFIG_ADD =
'為`{key}` 添加值`{value:q}`;'
WINDOW_MANUAL_CONFIG_SET =
'將`{key}` 的值設定為`{value:q}`;'
WINDOW_MANUAL_CONFIG_PROP =
'將`{key}` 的屬性`{prop}` 設定為`{value:q}`;'
WINDOW_APPLY_WHIT_SETTING =
'套用並修改設定'
WINDOW_APPLY_WHITOUT_SETTING =
'套用但不修改設定'
WINDOW_ASK_APPLY_LIBRARY =
'是否需要將你的工作環境設定為`{}` ？ '

CONFIG_LOAD_FAILED =
'無法讀取設定檔：{}'
CONFIG_LOAD_ERROR =
'設定檔載入錯誤：{}'
CONFIG_TYPE_ERROR =
'設定檔必須是lua或json格式：{}'

PLUGIN_RUNTIME_ERROR =
[[
延伸模組發生錯誤，請匯報給延伸模組作者。
請在輸出或日誌中查看詳細訊息。
延伸模組路徑：{}
]]
PLUGIN_TRUST_LOAD =
[[
目前設定試圖載入位於此位置的延伸模組：{}

注意，惡意的延伸模組可能會危害您的電腦
]]
PLUGIN_TRUST_YES =
[[
信任並載入延伸模組
]]
PLUGIN_TRUST_NO =
[[
不要載入此延伸模組
]]

CLI_CHECK_ERROR_TYPE =
'check 必須是一個字串，但是是一個{}'
CLI_CHECK_ERROR_URI =
'check 必須是一個有效的URI，但是是{}'
CLI_CHECK_ERROR_LEVEL =
'checklevel 必須是這些值之一：{}'
CLI_CHECK_INITING =
'正在初始化...'
CLI_CHECK_SUCCESS =
'診斷完成，沒有發現問題'
CLI_CHECK_RESULTS =
'診斷完成，共有{} 個問題，請查看{}'
