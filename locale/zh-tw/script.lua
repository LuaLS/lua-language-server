DIAG_LINE_ONLY_SPACE    =
'只有空格的空行。'
DIAG_LINE_POST_SPACE    =
'後置空格。'
DIAG_UNUSED_LOCAL       =
'未使用的區域變數 `{}`。'
DIAG_UNDEF_GLOBAL       =
'未定義的全域變數 `{}`。'
DIAG_UNDEF_FIELD        =
'未定義的屬性/欄位 `{}`。'
DIAG_UNDEF_ENV_CHILD    =
'未定義的變數 `{}`（多載了 `_ENV` ）。'
DIAG_UNDEF_FENV_CHILD   =
'未定義的變數 `{}`（處於模組中）。'
DIAG_GLOBAL_IN_NIL_ENV  =
'不能使用全域變數（ `_ENV` 被設為了 `nil` ）。'
DIAG_GLOBAL_IN_NIL_FENV =
'不能使用全域變數（模組被設為了 `nil` ）。'
DIAG_UNUSED_LABEL       =
'未使用的標籤 `{}`。'
DIAG_UNUSED_FUNCTION    =
'未使用的函式。'
DIAG_UNUSED_VARARG      =
'未使用的不定引數。'
DIAG_REDEFINED_LOCAL    =
'重複定義區域變數 `{}`。'
DIAG_DUPLICATE_INDEX    =
'重複的索引 `{}`。'
DIAG_DUPLICATE_METHOD   =
'重複的方法 `{}`。'
DIAG_PREVIOUS_CALL      =
'會被直譯為 `{}{}` 。你可能需要加一個 `;`。'
DIAG_PREFIELD_CALL      =
'會被直譯為 `{}{}` 。你可能需要加一個 `,` 或 `;` 。'
DIAG_OVER_MAX_ARGS      =
'函式最多接收 {:d} 個引數，但獲得了 {:d} 個。'
DIAG_MISS_ARGS          =
'函式最少接收 {:d} 個引數，但獲得了 {:d} 個。'
DIAG_UNNECESSARY_ASSERT =
'不必要的斷言：此陳述式始終為真。'
DIAG_OVER_MAX_VALUES    =
'只有 {} 個變數，但你設定了 {} 個值。'
DIAG_AMBIGUITY_1        =
'會優先運算 `{}` ，你可能需要加個括號。'
DIAG_LOWERCASE_GLOBAL   =
'首字母小寫的全域變數，你是否漏了 `local` 或是有拼寫錯誤？'
DIAG_EMPTY_BLOCK        =
'空程式碼區塊'
DIAG_DIAGNOSTICS        =
'Lua 診斷'
DIAG_SYNTAX_CHECK       =
'Lua 語法檢查'
DIAG_NEED_VERSION       =
'在 {} 中是合法的，目前為 {}'
DIAG_DEFINED_VERSION    =
'在 {} 中有定義，目前為 {}'
DIAG_DEFINED_CUSTOM     =
'在 {} 中有定義'
DIAG_DUPLICATE_CLASS    =
'重複定義的 Class `{}`。'
DIAG_UNDEFINED_CLASS    =
'未定義的 Class `{}`。'
DIAG_CYCLIC_EXTENDS     =
'循環繼承。'
DIAG_INEXISTENT_PARAM   =
'不存在的參數。'
DIAG_DUPLICATE_PARAM    =
'重複的參數。'
DIAG_NEED_CLASS         =
'需要先定義 Class 。'
DIAG_DUPLICATE_SET_FIELD=
'重複定義的欄位 `{}`。'
DIAG_SET_CONST          =
'不能對常數賦值。'
DIAG_SET_FOR_STATE      =
'修改了迴圈變數。'
DIAG_CODE_AFTER_BREAK   =
'無法執行到 `break` 後的程式碼。'
DIAG_UNBALANCED_ASSIGNMENTS =
'由於值的數量不夠而賦值了 `nil` 。在Lua中, `x, y = 1` 等價於 `x, y = 1, nil` 。'
DIAG_REQUIRE_LIKE       =
'你可以在設定中將 `{}` 視為 `require`。'
DIAG_COSE_NON_OBJECT    =
'無法 close 此類型的值。（除非給此類型設定 `__close` 元方法）'
DIAG_COUNT_DOWN_LOOP    =
'你的意思是 `{}` 嗎？'
DIAG_UNKNOWN            =
'無法推測出類型。'
DIAG_DEPRECATED         =
'已棄用。'
DIAG_DIFFERENT_REQUIRES =
'使用了不同的名字 `require` 了同一個檔案。'
DIAG_REDUNDANT_RETURN   =
'冗餘回傳。'
DIAG_AWAIT_IN_SYNC      =
'只能在標記為非同步的函式中呼叫非同步函式。'
DIAG_NOT_YIELDABLE      =
'此函式的第 {} 個參數沒有被標記為可讓出，但是傳入了非同步函式。（使用 `---@param name async fun()` 來標記為可讓出）'
DIAG_DISCARD_RETURNS    =
'不能丟棄此函式的回傳值。'
DIAG_NEED_CHECK_NIL     =
'需要判空'
DIAG_CIRCLE_DOC_CLASS                 =
'循環繼承的類別。'
DIAG_DOC_FIELD_NO_CLASS               =
'欄位必須定義在類別之後。'
DIAG_DUPLICATE_DOC_ALIAS              =
'重複定義的別名 `{}`.'
DIAG_DUPLICATE_DOC_FIELD              =
'重複定義的欄位 `{}`。'
DIAG_DUPLICATE_DOC_PARAM              =
'重複指向的參數 `{}`。'
DIAG_UNDEFINED_DOC_CLASS              =
'未定義的類別 `{}`。'
DIAG_UNDEFINED_DOC_NAME               =
'未定義的類型或別名 `{}`。'
DIAG_UNDEFINED_DOC_PARAM              =
'指向了未定義的參數 `{}`。'
DIAG_MISSING_GLOBAL_DOC_COMMENT       =
'全域函式 `{}` 缺少註解。'
DIAG_MISSING_GLOBAL_DOC_PARAM         =
'全域函式 `{2}` 的參數 `{1}` 缺少 @param 標註。'
DIAG_MISSING_GLOBAL_DOC_RETURN        =
'全域函式 `{2}` 的第 `{1}` 個回傳值缺少 @return 標註。'
DIAG_MISSING_LOCAL_EXPORT_DOC_COMMENT =
'輸出的區域函式 `{}` 缺少註解。'
DIAG_MISSING_LOCAL_EXPORT_DOC_PARAM   =
'輸出的區域函式 `{2}` 的參數 `{1}` 缺少 @param 標註。'
DIAG_MISSING_LOCAL_EXPORT_DOC_RETURN  =
'輸出的區域函式 `{2}` 的第 {1} 個回傳值缺少 @return 標註。'
DIAG_INCOMPLETE_SIGNATURE_DOC_PARAM   =
'簽名不完整。參數 `{1}` 缺少 @param 標註。'
DIAG_INCOMPLETE_SIGNATURE_DOC_RETURN  =
'簽名不完整。第 {1} 個回傳值缺少 @return 標註。'
DIAG_UNKNOWN_DIAG_CODE                =
'未知的診斷代碼 `{}`。'
DIAG_CAST_LOCAL_TYPE                  =
'已顯式定義變數的類型為 `{def}`，不能再將其類型轉換為 `{ref}`。'
DIAG_CAST_FIELD_TYPE                  =
'已顯式定義欄位的類型為 `{def}`，不能再將其類型轉換為 `{ref}`。'
DIAG_ASSIGN_TYPE_MISMATCH             =
'不能將 `{ref}` 賦值給 `{def}`。'
DIAG_PARAM_TYPE_MISMATCH              =
'不能將 `{ref}` 賦值給參數 `{def}`.'
DIAG_UNKNOWN_CAST_VARIABLE            =
'未知的類型轉換變數 `{}`.'
DIAG_CAST_TYPE_MISMATCH               =
'不能將 `{ref}` 轉換為 `{def}`。'
DIAG_MISSING_RETURN_VALUE             =
'至少需要 {min} 個回傳值，但此處只回傳 {rmax} 個值。'
DIAG_MISSING_RETURN_VALUE_RANGE       =
'至少需要 {min} 個回傳值，但此處只回傳 {rmin} 到 {rmax} 個值。'
DIAG_REDUNDANT_RETURN_VALUE           =
'最多只有 {max} 個回傳值，但此處回傳了第 {rmax} 個值。'
DIAG_REDUNDANT_RETURN_VALUE_RANGE     =
'最多只有 {max} 個回傳值，但此處回傳了第 {rmin} 到第 {rmax} 個值。'
DIAG_MISSING_RETURN                   =
'此處需要回傳值。'
DIAG_RETURN_TYPE_MISMATCH             =
'第 {index} 個回傳值的類型為 `{def}` ，但實際回傳的是 `{ref}`。\n{err}'
DIAG_UNKNOWN_OPERATOR                 =
'未知的運算子 `{}`。'
DIAG_UNREACHABLE_CODE                 =
'無法到達的程式碼。'
DIAG_INVISIBLE_PRIVATE                =
'欄位 `{field}` 是私有層級，只能在 `{class}` 類別中才能存取。'
DIAG_INVISIBLE_PROTECTED              =
'欄位 `{field}` 是保護層級，只能在 `{class}` 類別及其子類別中才能存取。'
DIAG_INVISIBLE_PACKAGE                =
'欄位 `{field}` 只能在同樣的檔案 `{uri}` 中存取。'
DIAG_GLOBAL_ELEMENT                   =
'全域元素。'
DIAG_MISSING_FIELDS                   =
'缺少類型 `{1}` 的必要欄位： {2}'
DIAG_INJECT_FIELD                     =
'不能在 `{class}` 的引用中注入欄位 `{field}` 。{fix}'
DIAG_INJECT_FIELD_FIX_CLASS           =
'如果要允許注入，請對 `{node}` 使用 `{fix}` 。'
DIAG_INJECT_FIELD_FIX_TABLE           =
'如果要允許注入，請在定義中添加 `{fix}` 。'

MWS_NOT_SUPPORT         =
'{} 目前還不支援多工作目錄，我可能需要重新啟動才能支援新的工作目錄…'
MWS_RESTART             =
'重新啟動'
MWS_NOT_COMPLETE        =
'工作目錄還沒有準備好，你可以稍後再試一下…'
MWS_COMPLETE            =
'工作目錄準備好了，你可以再試一下了'
MWS_MAX_PRELOAD         =
'預載入檔案數已達上限（{}），你需要手動打開需要載入的檔案。'
MWS_UCONFIG_FAILED      =
'使用者設定檔儲存失敗。'
MWS_UCONFIG_UPDATED     =
'使用者設定檔已更新。'
MWS_WCONFIG_UPDATED     =
'工作區設定檔已更新。'

WORKSPACE_SKIP_LARGE_FILE =
'已跳過過大的檔案：{}。目前設定的大小限制為：{} KB，該檔案大小為：{} KB'
WORKSPACE_LOADING         =
'正在載入工作目錄'
WORKSPACE_DIAGNOSTIC      =
'正在對工作目錄進行診斷'
WORKSPACE_SKIP_HUGE_FILE  =
'出於效能考慮，已停止對此檔案解析：{}'
WORKSPACE_NOT_ALLOWED     =
'你的工作目錄被設定為了 `{}` ，Lua語言伺服拒絕載入此目錄，請檢查你的設定檔。[了解更多](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)'
WORKSPACE_SCAN_TOO_MUCH   =
'已掃描了超過 {} 個檔案，目前掃描的目錄為 `{}`。請檢視[FAQ](https://luals.github.io/wiki/faq#how-can-i-improve-startup-speeds)以便了解你要如何引入更少檔案。也有可能你的[組態是錯的](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)。'

PARSER_CRASH            =
'語法解析崩潰了！遺言：{}'
PARSER_UNKNOWN          =
'未知語法錯誤…'
PARSER_MISS_NAME        =
'缺少名稱。'
PARSER_UNKNOWN_SYMBOL   =
'未知符號`{symbol}`。'
PARSER_MISS_SYMBOL      =
'缺少符號`{symbol}`。'
PARSER_MISS_ESC_X       =
'必須是2個16進制字元。'
PARSER_UTF8_SMALL       =
'至少有1個字元。'
PARSER_UTF8_MAX         =
'必須在 {min} 與 {max} 之間。'
PARSER_ERR_ESC          =
'錯誤的跳脫字元。'
PARSER_MUST_X16         =
'必須是16進制字元。'
PARSER_MISS_EXPONENT    =
'缺少指數部分。'
PARSER_MISS_EXP         =
'缺少表達式。'
PARSER_MISS_FIELD       =
'缺少欄位/屬性名。'
PARSER_MISS_METHOD      =
'缺少方法名。'
PARSER_ARGS_AFTER_DOTS  =
'`...` 必須是最後一個引數。'
PARSER_KEYWORD          =
'關鍵字無法作為名稱。'
PARSER_EXP_IN_ACTION    =
'該表達式不能作為敘述。'
PARSER_BREAK_OUTSIDE    =
'`break`必須在迴圈內部。'
PARSER_MALFORMED_NUMBER =
'無法構成有效數字。'
PARSER_ACTION_AFTER_RETURN =
'`return`之後不能再執行程式碼。'
PARSER_ACTION_AFTER_BREAK =
'`break`之後不能再執行程式碼。'
PARSER_NO_VISIBLE_LABEL =
'標籤`{label}`不可見。'
PARSER_REDEFINE_LABEL   =
'標籤`{label}`重定義。'
PARSER_UNSUPPORT_SYMBOL =
'{version} 不支援該符號。'
PARSER_UNEXPECT_DOTS    =
'`...` 只能在不定參函式中使用。'
PARSER_UNEXPECT_SYMBOL  =
'未知的符號 `{symbol}` 。'
PARSER_UNKNOWN_TAG      =
'不支援的屬性。'
PARSER_MULTI_TAG        =
'只能設定一個屬性。'
PARSER_UNEXPECT_LFUNC_NAME =
'區域函式只能使用識別字作為名稱。'
PARSER_UNEXPECT_EFUNC_NAME =
'函式作為表達式時不能命名。'
PARSER_ERR_LCOMMENT_END =
'應使用 `{symbol}` 來關閉多行註解。'
PARSER_ERR_C_LONG_COMMENT =
'Lua應使用 `--[[ ]]` 來進行多行註解。'
PARSER_ERR_LSTRING_END  =
'應使用 `{symbol}` 來關閉長字串。'
PARSER_ERR_ASSIGN_AS_EQ =
'應使用 `=` 來進行賦值操作。'
PARSER_ERR_EQ_AS_ASSIGN =
'應使用 `==` 來進行等於判斷。'
PARSER_ERR_UEQ          =
'應使用 `~=` 來進行不等於判斷。'
PARSER_ERR_THEN_AS_DO   =
'應使用 `then` 。'
PARSER_ERR_DO_AS_THEN   =
'應使用 `do` 。'
PARSER_MISS_END         =
'缺少對應的 `end` 。'
PARSER_ERR_COMMENT_PREFIX =
'Lua應使用 `--` 來進行註解。'
PARSER_MISS_SEP_IN_TABLE =
'需要用 `,` 或 `;` 進行分割。'
PARSER_SET_CONST         =
'不能對常數賦值。'
PARSER_UNICODE_NAME      =
'包含了 Unicode 字元。'
PARSER_ERR_NONSTANDARD_SYMBOL =
'Lua中應使用符號 `{symbol}` 。'
PARSER_MISS_SPACE_BETWEEN =
'符號之間必須保留空格。'
PARSER_INDEX_IN_FUNC_NAME =
'命名函式的名稱中不能使用 `[name]` 形式。'
PARSER_UNKNOWN_ATTRIBUTE  =
'區域變數屬性應該是 `const` 或 `close` 。'
PARSER_AMBIGUOUS_SYNTAX   =
'在 Lua 5.1 中，呼叫函式的左括號和函式必須在同一行。'
PARSER_NEED_PAREN         =
'需要添加一對括號。'
PARSER_NESTING_LONG_MARK  =
'Lua 5.1 不允許使用巢狀的 `[[...]]` 。'
PARSER_LOCAL_LIMIT        =
'只能同時存在200個活躍的區域變數與上值。'
PARSER_LUADOC_MISS_CLASS_NAME           =
'缺少類別名稱。'
PARSER_LUADOC_MISS_EXTENDS_SYMBOL       =
'缺少符號 `:` 。'
PARSER_LUADOC_MISS_CLASS_EXTENDS_NAME   =
'缺少要繼承的類別名稱。'
PARSER_LUADOC_MISS_SYMBOL               =
'缺少符號 `{symbol}`。'
PARSER_LUADOC_MISS_ARG_NAME             =
'缺少參數名稱。'
PARSER_LUADOC_MISS_TYPE_NAME            =
'缺少類型名。'
PARSER_LUADOC_MISS_ALIAS_NAME           =
'缺少別名。'
PARSER_LUADOC_MISS_ALIAS_EXTENDS        =
'缺少別名定義。'
PARSER_LUADOC_MISS_PARAM_NAME           =
'缺少要指向的參數名稱。'
PARSER_LUADOC_MISS_PARAM_EXTENDS        =
'缺少參數的類型定義。'
PARSER_LUADOC_MISS_FIELD_NAME           =
'缺少欄位名稱。'
PARSER_LUADOC_MISS_FIELD_EXTENDS        =
'缺少欄位的類型定義。'
PARSER_LUADOC_MISS_GENERIC_NAME         =
'缺少泛型名稱。'
PARSER_LUADOC_MISS_GENERIC_EXTENDS_NAME =
'缺少泛型要繼承的類別名稱。'
PARSER_LUADOC_MISS_VARARG_TYPE          =
'缺少可變引數的類型定義。'
PARSER_LUADOC_MISS_FUN_AFTER_OVERLOAD   =
'缺少關鍵字 `fun` 。'
PARSER_LUADOC_MISS_CATE_NAME            =
'缺少文件類型名稱。'
PARSER_LUADOC_MISS_DIAG_MODE            =
'缺少診斷模式。'
PARSER_LUADOC_ERROR_DIAG_MODE           =
'診斷模式不正確。'
PARSER_LUADOC_MISS_LOCAL_NAME           =
'缺少變數名。'

SYMBOL_ANONYMOUS        =
'<匿名函式>'

HOVER_VIEW_DOCUMENTS    =
'檢視文件'
HOVER_DOCUMENT_LUA51    =
'https://www.lua.org/manual/5.1/manual.html#{}'
HOVER_DOCUMENT_LUA52    =
'https://www.lua.org/manual/5.2/manual.html#{}'
HOVER_DOCUMENT_LUA53    =
'http://cloudwu.github.io/lua53doc/manual.html#{}'
HOVER_DOCUMENT_LUA54    =
'https://www.lua.org/manual/5.4/manual.html#{}'
HOVER_DOCUMENT_LUAJIT   =
'https://www.lua.org/manual/5.1/manual.html#{}'
HOVER_NATIVE_DOCUMENT_LUA51     =
'command:extension.lua.doc?["en-us/51/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA52     =
'command:extension.lua.doc?["en-us/52/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA53     =
'command:extension.lua.doc?["zh-cn/53/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA54     =
'command:extension.lua.doc?["en-us/54/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUAJIT    =
'command:extension.lua.doc?["en-us/51/manual.html/{}"]'
HOVER_MULTI_PROTOTYPE      =
'（{} 個原型）'
HOVER_STRING_BYTES         =
'{} 個位元組'
HOVER_STRING_CHARACTERS    =
'{} 個位元組，{} 個字元'
HOVER_MULTI_DEF_PROTO      =
'（{} 個定義，{} 個原型）'
HOVER_MULTI_PROTO_NOT_FUNC =
'（{} 個非函式定義）'
HOVER_USE_LUA_PATH      =
'（搜尋路徑： `{}` ）'
HOVER_EXTENDS           =
'展開為 {}'
HOVER_TABLE_TIME_UP     =
'出於效能考慮，已停用了部分類型推斷。'
HOVER_WS_LOADING        =
'正在載入工作目錄：{} / {}'
HOVER_AWAIT_TOOLTIP     =
'正在呼叫非同步函式，可能會讓出目前共常式'

ACTION_DISABLE_DIAG     =
'在工作區停用診斷 ({})。'
ACTION_MARK_GLOBAL      =
'標記 `{}` 為已定義的全域變數。'
ACTION_REMOVE_SPACE     =
'清除所有後置空格。'
ACTION_ADD_SEMICOLON    =
'添加 `;` 。'
ACTION_ADD_BRACKETS     =
'添加括號。'
ACTION_RUNTIME_VERSION  =
'修改執行版本為 {} 。'
ACTION_OPEN_LIBRARY     =
'載入 {} 中的全域變數。'
ACTION_ADD_DO_END       =
'添加 `do ... end` 。'
ACTION_FIX_LCOMMENT_END =
'改用正確的多行註解關閉符號。'
ACTION_ADD_LCOMMENT_END =
'關閉多行註解。'
ACTION_FIX_C_LONG_COMMENT =
'修改為 Lua 的多行註解格式。'
ACTION_FIX_LSTRING_END  =
'改用正確的長字串關閉符號。'
ACTION_ADD_LSTRING_END  =
'關閉長字串。'
ACTION_FIX_ASSIGN_AS_EQ =
'改為 `=` 。'
ACTION_FIX_EQ_AS_ASSIGN =
'改為 `==` 。'
ACTION_FIX_UEQ          =
'改為 `~=` 。'
ACTION_FIX_THEN_AS_DO   =
'改為 `then` 。'
ACTION_FIX_DO_AS_THEN   =
'改為 `do` 。'
ACTION_ADD_END          =
'添加 `end` （根據縮排推測添加位置）。'
ACTION_FIX_COMMENT_PREFIX =
'改為 `--` 。'
ACTION_FIX_NONSTANDARD_SYMBOL =
'改為 `{symbol}`。'
ACTION_RUNTIME_UNICODE_NAME =
'允許使用 Unicode 字元。'
ACTION_SWAP_PARAMS      =
'將其改為 `{node}` 的第 {index} 個參數'
ACTION_FIX_INSERT_SPACE =
'插入空格'
ACTION_JSON_TO_LUA      =
'把 JSON 轉成 Lua'
ACTION_DISABLE_DIAG_LINE=
'在此行停用診斷 ({})。'
ACTION_DISABLE_DIAG_FILE=
'在此檔案停用診斷 ({})。'
ACTION_MARK_ASYNC       =
'將目前函式標記為非同步。'
ACTION_ADD_DICT         =
'添加 \'{}\' 到工作區字典'
ACTION_FIX_ADD_PAREN    =
'添加括號。'
ACTION_AUTOREQUIRE      =
"引入 '{}' 作為 {}"

COMMAND_DISABLE_DIAG       =
'停用診斷'
COMMAND_MARK_GLOBAL        =
'標記全域變數'
COMMAND_REMOVE_SPACE       =
'清除所有後置空格'
COMMAND_ADD_BRACKETS       =
'添加括號'
COMMAND_RUNTIME_VERSION    =
'修改執行版本'
COMMAND_OPEN_LIBRARY       =
'載入第三方庫中的全域變數'
COMMAND_UNICODE_NAME       =
'允許使用 Unicode 字元'
COMMAND_JSON_TO_LUA        =
'JSON 轉 Lua'
COMMAND_JSON_TO_LUA_FAILED =
'JSON 轉 Lua 失敗：{}'
COMMAND_ADD_DICT           =
'添加單字到字典裡'
COMMAND_REFERENCE_COUNT    =
'{} 個參考'

COMPLETION_IMPORT_FROM           =
'從 {} 中匯入'
COMPLETION_DISABLE_AUTO_REQUIRE  =
'停用自動require'
COMPLETION_ASK_AUTO_REQUIRE      =
'在檔案頂部添加程式碼 require 此檔案？'

DEBUG_MEMORY_LEAK       =
'{} 很抱歉發生了嚴重的記憶體漏失，語言伺服即將重新啟動。'
DEBUG_RESTART_NOW       =
'立即重新啟動'

WINDOW_COMPILING                 =
'正在編譯'
WINDOW_DIAGNOSING                =
'正在診斷'
WINDOW_INITIALIZING              =
'正在初始化…'
WINDOW_PROCESSING_HOVER          =
'正在處理懸浮提示…'
WINDOW_PROCESSING_DEFINITION     =
'正在處理轉到定義…'
WINDOW_PROCESSING_REFERENCE      =
'正在處理轉到引用…'
WINDOW_PROCESSING_RENAME         =
'正在處理重新命名…'
WINDOW_PROCESSING_COMPLETION     =
'正在處理自動完成…'
WINDOW_PROCESSING_SIGNATURE      =
'正在處理參數提示…'
WINDOW_PROCESSING_SYMBOL         =
'正在處理檔案符號…'
WINDOW_PROCESSING_WS_SYMBOL      =
'正在處理工作區符號…'
WINDOW_PROCESSING_SEMANTIC_FULL  =
'正在處理全量語義著色…'
WINDOW_PROCESSING_SEMANTIC_RANGE =
'正在處理差量語義著色…'
WINDOW_PROCESSING_HINT           =
'正在處理內嵌提示…'
WINDOW_PROCESSING_BUILD_META     =
'正在處理編譯器中繼資料…'
WINDOW_INCREASE_UPPER_LIMIT      =
'增加上限'
WINDOW_CLOSE                     =
'關閉'
WINDOW_SETTING_WS_DIAGNOSTIC     =
'你可以在設定中延遲或停用工作目錄診斷'
WINDOW_DONT_SHOW_AGAIN           =
'不再提示'
WINDOW_DELAY_WS_DIAGNOSTIC       =
'空閒時診斷（延遲{}秒）'
WINDOW_DISABLE_DIAGNOSTIC        =
'停用工作區診斷'
WINDOW_LUA_STATUS_WORKSPACE      =
'工作區：{}'
WINDOW_LUA_STATUS_CACHED_FILES   =
'已快取檔案：{ast}/{max}'
WINDOW_LUA_STATUS_MEMORY_COUNT   =
'記憶體佔用：{mem:.f}M'
WINDOW_LUA_STATUS_TIP            =
[[

這個圖標是貓，
不是狗也不是狐狸！
             ↓↓↓
]]
WINDOW_LUA_STATUS_DIAGNOSIS_TITLE=
'進行工作區診斷'
WINDOW_LUA_STATUS_DIAGNOSIS_MSG  =
'是否進行工作區診斷？'
WINDOW_APPLY_SETTING             =
'套用設定'
WINDOW_CHECK_SEMANTIC            =
'如果你正在使用市場中的顏色主題，你可能需要同時修改 `editor.semanticHighlighting.enabled` 選項為 `true` 才會使語義著色生效。'
WINDOW_TELEMETRY_HINT            =
'請允許發送匿名的使用資料與錯誤報告，幫助我們進一步完善此延伸模組。在[此處](https://luals.github.io/privacy/#language-server)閱讀我們的隱私聲明。'
WINDOW_TELEMETRY_ENABLE          =
'允許'
WINDOW_TELEMETRY_DISABLE         =
'禁止'
WINDOW_CLIENT_NOT_SUPPORT_CONFIG =
'你的用戶端不支援從伺服端修改設定，請手動修改以下設定：'
WINDOW_LCONFIG_NOT_SUPPORT_CONFIG=
'暫時不支援自動修改本地設定，請手動修改以下設定：'
WINDOW_MANUAL_CONFIG_ADD         =
'為 `{key}` 添加值 `{value:q}`;'
WINDOW_MANUAL_CONFIG_SET         =
'將 `{key}` 的值設定為 `{value:q}`;'
WINDOW_MANUAL_CONFIG_PROP        =
'將 `{key}` 的屬性 `{prop}` 設定為 `{value:q}`;'
WINDOW_APPLY_WHIT_SETTING        =
'套用並修改設定'
WINDOW_APPLY_WHITOUT_SETTING     =
'套用但不修改設定'
WINDOW_ASK_APPLY_LIBRARY         =
'是否需要將你的工作環境配置為 `{}` ？'
WINDOW_SEARCHING_IN_FILES        =
'正在檔案中搜尋…'
WINDOW_CONFIG_LUA_DEPRECATED     =
'`config.lua` 已棄用，請改用 `config.json` 。'
WINDOW_CONVERT_CONFIG_LUA        =
'轉換為 `config.json`'
WINDOW_MODIFY_REQUIRE_PATH       =
'你想要修改 `require` 的路徑嗎？'
WINDOW_MODIFY_REQUIRE_OK         =
'修改'

CONFIG_LOAD_FAILED               =
'無法讀取設定檔案：{}'
CONFIG_LOAD_ERROR                =
'設定檔案載入錯誤：{}'
CONFIG_TYPE_ERROR                =
'設定檔案必須是lua或json格式：{}'
CONFIG_MODIFY_FAIL_SYNTAX_ERROR  =
'修改設定失敗，設定檔中有語法錯誤：{}'
CONFIG_MODIFY_FAIL_NO_WORKSPACE  =
[[
修改設定失敗：
* 目前模式為單一檔案模式，伺服器只能在工作區中新增 `.luarc.json` 檔案。
* 語言用戶端不支援從伺服端修改設定。

請手動修改以下設定：
{}
]]
CONFIG_MODIFY_FAIL               =
[[
修改設定失敗

請手動修改以下設定：
{}
]]

PLUGIN_RUNTIME_ERROR             =
[[
延伸模組發生錯誤，請彙報給延伸模組作者。
請在輸出或日誌中查看詳細資訊。
延伸模組路徑：{}
]]
PLUGIN_TRUST_LOAD                =
[[
目前設定試圖載入位於此位置的延伸模組：{}

注意，惡意的延伸模組可能會危害您的電腦
]]
PLUGIN_TRUST_YES                 =
[[
信任並載入延伸模組
]]
PLUGIN_TRUST_NO                  =
[[
不要載入此延伸模組
]]

CLI_CHECK_ERROR_TYPE =
'check 必須是一個字串，但是是一個 {}'
CLI_CHECK_ERROR_URI =
'check 必須是一個有效的 URI，但是是 {}'
CLI_CHECK_ERROR_LEVEL =
'checklevel 必須是這些值之一：{}'
CLI_CHECK_INITING =
'正在初始化…'
CLI_CHECK_SUCCESS =
'診斷完成，沒有發現問題'
CLI_CHECK_PROGRESS =
'在檔案 {2} 中檢測到問題 {1}'
CLI_CHECK_RESULTS_OUTPATH =
'診斷完成，共有 {} 個問題，請查看 {}'
CLI_CHECK_RESULTS_PRETTY =
'診斷完成，共有 {} 個問題'
CLI_CHECK_MULTIPLE_WORKERS =
'開始 {} 個工作任務，將會停用進度輸出。這可能會花費幾分鐘。'
CLI_DOC_INITING   =
'文件載入中…'
CLI_DOC_DONE      =
'文件輸出完成！'
CLI_DOC_WORKING   =
'正在產生文件…'

TYPE_ERROR_ENUM_GLOBAL_DISMATCH =
'類型 `{child}` 不符合 `{parent}` 的列舉類型'
TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED =
'無法在列舉中使用泛型 `{child}`'
TYPE_ERROR_ENUM_LITERAL_DISMATCH =
'字面常數 `{child}` 不符合 `{parent}` 的列舉值'
TYPE_ERROR_ENUM_OBJECT_DISMATCH =
'物件 `{child}` 不符合 `{parent}` 的列舉值，它們必須是同一個物件'
TYPE_ERROR_ENUM_NO_OBJECT =
'無法識別傳入的列舉值 `{child}`'
TYPE_ERROR_INTEGER_DISMATCH =
'字面常數 `{child}` 不符合整數 `{parent}`'
TYPE_ERROR_STRING_DISMATCH =
'字面常數 `{child}` 不符合字串 `{parent}`'
TYPE_ERROR_BOOLEAN_DISMATCH =
'字面常數 `{child}` 不符合布林值 `{parent}`'
TYPE_ERROR_TABLE_NO_FIELD =
'表中不存在欄位 `{key}`'
TYPE_ERROR_TABLE_FIELD_DISMATCH =
'欄位 `{key}` 的類型是 `{child}`，無法匹配 `{parent}`'
TYPE_ERROR_CHILD_ALL_DISMATCH =
'`{child}` 的所有子類型皆無法匹配 `{parent}`'
TYPE_ERROR_PARENT_ALL_DISMATCH =
'`{child}` 無法匹配 `{parent}` 中的任何子類型'
TYPE_ERROR_UNION_DISMATCH =
'`{child}` 無法匹配 `{parent}`'
TYPE_ERROR_OPTIONAL_DISMATCH =
'可選類型不符合 `{parent}`'
TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER =
'無法將數字 `{child}` 轉換成整數'
TYPE_ERROR_NUMBER_TYPE_TO_INTEGER =
'無法將數字類型轉換為整數類型'
TYPE_ERROR_DISMATCH =
'類型 `{child}` 無法匹配 `{parent}`'

LUADOC_DESC_CLASS =
[=[
定義一個類別/表結構
## 語法
`---@class <name> [: <parent>[, <parent>]...]`
## 用法
```
---@class Manager: Person, Human
Manager = {}
```
---
[檢視文件](https://luals.github.io/wiki/annotations#class)
]=]
LUADOC_DESC_TYPE =
[=[
指定一個變數的類型

預設類型： `nil` 、 `any` 、 `boolean` 、 `string` 、 `number` 、 `integer`、
`function` 、 `table` 、 `thread` 、 `userdata` 、 `lightuserdata`

（可以使用 `@alias` 提供自訂類型）

## 語法
`---@type <type>[| [type]...`

## 用法
### 一般
```
---@type nil|table|myClass
local Example = nil
```

### 陣列
```
---@type number[]
local phoneNumbers = {}
```

### 列舉
```
---@type "red"|"green"|"blue"
local color = ""
```

### 表
```
---@type table<string, boolean>
local settings = {
    disableLogging = true,
    preventShutdown = false,
}

---@type { [string]: true }
local x --x[""] is true
```

### 函式
```
---@type fun(mode?: "r"|"w"): string
local myFunction
```
---
[檢視文件](https://luals.github.io/wiki/annotations#type)
]=]
LUADOC_DESC_ALIAS =
[=[
新增你的自訂類型，可以與 `@param`、`@type` 等一起使用。

## 語法
`---@alias <name> <type> [description]`\
或
```
---@alias <name>
---| 'value' [# comment]
---| 'value2' [# comment]
...
```

## 用法
### Expand to other type
```
---@alias filepath string Path to a file

---@param path filepath Path to the file to search in
function find(path, pattern) end
```

### 列舉
```
---@alias font-style
---| '"underlined"' # Underline the text
---| '"bold"' # Bolden the text
---| '"italic"' # Make the text italicized

---@param style font-style Style to apply
function setFontStyle(style) end
```

### Literal Enum
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
[檢視文件](https://luals.github.io/wiki/annotations#alias)
]=]
LUADOC_DESC_PARAM =
[=[
宣告一個函式參數

## 語法
`@param <name>[?] <type> [comment]`

## 用法
### 一般
```
---@param url string The url to request
---@param headers? table<string, string> HTTP headers to send
---@param timeout? number Timeout in seconds
function get(url, headers, timeout) end
```

### 可變引數
```
---@param base string The base to concat to
---@param ... string The values to concat
function concat(base, ...) end
```
---
[檢視文件](https://luals.github.io/wiki/annotations#param)
]=]
LUADOC_DESC_RETURN =
[=[
宣告一個回傳值

## 語法
`@return <type> [name] [description]`\
或\
`@return <type> [# description]`

## 用法
### 一般
```
---@return number
---@return number # The green component
---@return number b The blue component
function hexToRGB(hex) end
```

### 僅限類型和名稱
```
---@return number x, number y
function getCoords() end
```

### 僅限類型
```
---@return string, string
function getFirstLast() end
```

### 回傳變數值
```
---@return string ... The tags of the item
function getTags(item) end
```
---
[檢視文件](https://luals.github.io/wiki/annotations#return)
]=]
LUADOC_DESC_FIELD =
[=[
在類別/表中宣告一個欄位。 這使你可以為表提供更深入詳細的文件。

## 語法
`---@field <name> <type> [description]`

## 用法
```
---@class HTTP_RESPONSE
---@field status HTTP_STATUS
---@field headers table<string, string> The headers of the response

---@class HTTP_STATUS
---@field code number The status code of the response
---@field message string A message reporting the status

---@return HTTP_RESPONSE response The response from the server
function get(url) end

--This response variable has all of the fields defined above
response = get("localhost")

--Extension provided intellisense for the below assignment
statusCode = response.status.code
```
---
[檢視文件](https://luals.github.io/wiki/annotations#field)
]=]
LUADOC_DESC_GENERIC =
[=[
模擬泛型。 泛型可以允許類型被重用，因為它們有助於定義可用於不同類型的"通用形狀"。

## 語法
`---@generic <name> [:parent_type] [, <name> [:parent_type]]`

## 用法
### 一般
```
---@generic T
---@param value T The value to return
---@return T value The exact same value
function echo(value)
    return value
end

-- Type is string
s = echo("e")

-- Type is number
n = echo(10)

-- Type is boolean
b = echo(true)

-- We got all of this info from just using
-- @generic rather than manually specifying
-- each allowed type
```

### 捕獲泛型類型的名稱
```
---@class Foo
local Foo = {}
function Foo:Bar() end

---@generic T
---@param name `T` # the name generic type is captured here
---@return T       # generic type is returned
function Generic(name) end

local v = Generic("Foo") -- v is an object of Foo
```

### Lua 表如何使用泛型
```
---@class table<K, V>: { [K]: V }

-- This is what allows us to create a table
-- and intellisense keeps track of any type
-- we give for key (K) or value (V)
```
---
[檢視文件](https://luals.github.io/wiki/annotations#generic)
]=]
LUADOC_DESC_VARARG =
[=[
主要用於對 EmmyLua 註解的向下支援。 `@vararg` 不提供輸入或允許描述。

**在記錄參數（變數或非變數）時，您應該改用 `@param`。**

## 語法
`@vararg <type>`

## 用法
```
---Concat strings together
---@vararg string
function concat(...) end
```
---
[檢視文件](https://luals.github.io/wiki/annotations#vararg)
]=]
LUADOC_DESC_OVERLOAD =
[=[
允許定義多個函式簽章。

## 語法
`---@overload fun(<name>[: <type>] [, <name>[: <type>]]...)[: <type>[, <type>]...]`

## 用法
```
---@overload fun(t: table, value: any): number
function table.insert(t, position, value) end
```
---
[檢視文件](https://luals.github.io/wiki/annotations#overload)
]=]
LUADOC_DESC_DEPRECATED =
[=[
將函式標記為已棄用。 這會導致任何不推薦使用的函式呼叫被 ~~擊穿~~。

## 語法
`---@deprecated`

---
[檢視文件](https://luals.github.io/wiki/annotations#deprecated)
]=]
LUADOC_DESC_META =
[=[
表示這是一個中繼檔案，應僅用於定義和智慧感知。

中繼檔案有 3 個主要區別需要注意：
1. 中繼檔案中不會有任何基於上下文的智慧感知
2. 將 `require` 檔案路徑懸停在中繼檔案中會顯示 `[meta]` 而不是絕對路徑
3. `Find Reference` 功能會忽略中繼檔案

## 語法
`---@meta`

---
[檢視文件](https://luals.github.io/wiki/annotations#meta)
]=]
LUADOC_DESC_VERSION =
[=[
指定此函式獨有的 Lua 版本。

Lua 版本：`5.1` 、 `5.2` 、 `5.3` 、 `5.4` 、 `JIT`。

需要 `Diagnostics: Needed File Status` 設定。

## 語法
`---@version <version>[, <version>]...`

## 用法
### 一般
```
---@version JIT
function onlyWorksInJIT() end
```
### 指定多個版本
```
---@version <5.2,JIT
function oldLuaOnly() end
```
---
[檢視文件](https://luals.github.io/wiki/annotations#version)
]=]
LUADOC_DESC_SEE =
[=[
定義可以檢視以獲取更多資訊的內容

## Syntax
`---@see <text>`

---
[檢視文件](https://luals.github.io/wiki/annotations#see)
]=]
LUADOC_DESC_DIAGNOSTIC =
[=[
啟用/停用診斷錯誤與警告等。

操作：`disable` 、 `enable` 、 `disable-line` 、 `disable-next-line`

[名稱](https://github.com/LuaLS/lua-language-server/blob/cbb6e6224094c4eb874ea192c5f85a6cba099588/script/proto/define.lua#L54)

## 語法
`---@diagnostic <action>[: <name>]`

## 用法
### 停用下一行
```
---@diagnostic disable-next-line: undefined-global
```

### 手動切換
```
---@diagnostic disable: unused-local
local unused = "hello world"
---@diagnostic enable: unused-local
```
---
[檢視文件](https://luals.github.io/wiki/annotations#diagnostic)
]=]
LUADOC_DESC_MODULE =
[=[
提供 `require` 的語義。

## 語法
`---@module <'module_name'>`

## 用法
```
---@module 'string.utils'
local stringUtils
-- This is functionally the same as:
local module = require('string.utils')
```
---
[檢視文件](https://luals.github.io/wiki/annotations#module)
]=]
LUADOC_DESC_ASYNC =
[=[
將函式標記為非同步。

## 語法
`---@async`

---
[檢視文件](https://luals.github.io/wiki/annotations#async)
]=]
LUADOC_DESC_NODISCARD =
[=[
防止此函式的回傳值被丟棄/忽略。
如果忽略回傳值，這將引發 `discard-returns` 警告。

## 語法
`---@nodiscard`

---
[檢視文件](https://luals.github.io/wiki/annotations#nodiscard)
]=]
LUADOC_DESC_CAST =
[=[
允許轉型（類型轉換）。

## 語法
`@cast <variable> <[+|-]type>[, <[+|-]type>]...`

## 用法
### 覆蓋類型
```
---@type integer
local x --> integer

---@cast x string
print(x) --> string
```
### 增加類型
```
---@type string
local x --> string

---@cast x +boolean, +number
print(x) --> string|boolean|number
```
### 移除類型
```
---@type string|table
local x --> string|table

---@cast x -string
print(x) --> table
```
---
[檢視文件](https://luals.github.io/wiki/annotations#cast)
]=]
LUADOC_DESC_OPERATOR =
[=[
為 [運算子元方法](http://lua-users.org/wiki/MetatableEvents) 提供類型聲明

## 語法
`@operator <operation>[(input_type)]:<resulting_type>`

## 用法
### 向量加法元方法
```
---@class Vector
---@operator add(Vector):Vector

vA = Vector.new(1, 2, 3)
vB = Vector.new(10, 20, 30)

vC = vA + vB
--> Vector
```
### 一元減法
```
---@class Passcode
---@operator unm:integer

pA = Passcode.new(1234)
pB = -pA
--> integer
```
[檢視請求](https://github.com/LuaLS/lua-language-server/issues/599)
]=]
LUADOC_DESC_ENUM =
[=[
將表標記為列舉。如果你想要一個列舉但是無法將其定義為 Lua 表，看一眼 [`@alias`](https://luals.github.io/wiki/annotations#alias)
標籤。

## 語法
`@enum <name>`

## 用法
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

-- Completion and hover is provided for the below param
setColor(colors.green)
```
]=]
LUADOC_DESC_SOURCE =
[=[
提供一個其他檔案中原始碼的引用。當查找某一項的定義時，將會使用它的 `@source`。

## 語法
`@source <path>`

## 用法
```
---You can use absolute paths
---@source C:/Users/me/Documents/program/myFile.c
local a

---Or URIs
---@source file:///C:/Users/me/Documents/program/myFile.c:10
local b

---Or relative paths
---@source local/file.c
local c

---You can also include line and char numbers
---@source local/file.c:10:8
local d
```
]=]
LUADOC_DESC_PACKAGE =
[=[
將函式標註為其所處檔案的私有成員。一個打包的函式不可以被其他檔案存取。

## 語法
`@package`

## 用法
```
---@class Animal
---@field private eyes integer
local Animal = {}

---@package
---This cannot be accessed in another file
function Animal:eyesCount()
    return self.eyes
end
```
]=]
LUADOC_DESC_PRIVATE =
[=[
將欄位標註為類別的私有成員。私有欄位僅可在其所屬的類別中存取，並且不能被子類別存取。

## 語法
`@private`

## 用法
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

---NOT PERMITTED!
myDog:eyesCount();
```
]=]
LUADOC_DESC_PROTECTED =
[=[
將欄位標註為類別的保護成員。保護欄位僅可在其所屬的類別或子類別中存取。

## 語法
`@protected`

## 用法
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

---Permitted because function is protected, not private.
myDog:eyesCount();
```
]=]
