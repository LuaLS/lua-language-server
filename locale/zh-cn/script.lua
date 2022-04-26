DIAG_LINE_ONLY_SPACE    =
'只有空格的空行。'
DIAG_LINE_POST_SPACE    =
'后置空格。'
DIAG_UNUSED_LOCAL       =
'未使用的局部变量 `{}`。'
DIAG_UNDEF_GLOBAL       =
'未定义的全局变量 `{}`。'
DIAG_UNDEF_FIELD        =
'未定义的属性/字段 `{}`。'
DIAG_UNDEF_ENV_CHILD    =
'未定义的变量 `{}`（重载了 `_ENV` ）。'
DIAG_UNDEF_FENV_CHILD   =
'未定义的变量 `{}`（处于模块中）。'
DIAG_GLOBAL_IN_NIL_ENV  =
'不能使用全局变量（`_ENV`被置为了`nil`）。'
DIAG_GLOBAL_IN_NIL_FENV =
'不能使用全局变量（模块被置为了`nil`）。'
DIAG_UNUSED_LABEL       =
'未使用的标签 `{}`。'
DIAG_UNUSED_FUNCTION    =
'未使用的函数。'
DIAG_UNUSED_VARARG      =
'未使用的不定参数。'
DIAG_REDEFINED_LOCAL    =
'重定义局部变量 `{}`。'
DIAG_DUPLICATE_INDEX    =
'重复的索引 `{}`。'
DIAG_DUPLICATE_METHOD   =
'重复的方法 `{}`。'
DIAG_PREVIOUS_CALL      =
'会被解释为 `{}{}`。你可能需要加一个 `;`。'
DIAG_PREFIELD_CALL      =
'会被解释为 `{}{}`。你可能需要加一个`,`或`;`。'
DIAG_OVER_MAX_ARGS      =
'函数最多接收 {:d} 个参数，但获得了 {:d} 个。'
DIAG_MISS_ARGS          =
'函数最少接收 {:d} 个参数，但获得了 {:d} 个。'
DIAG_OVER_MAX_VALUES    =
'只有 {} 个变量，但你设置了 {} 个值。'
DIAG_AMBIGUITY_1        =
'会优先运算 `{}`，你可能需要加个括号。'
DIAG_LOWERCASE_GLOBAL   =
'首字母小写的全局变量，你是否漏了 `local` 或是有拼写错误？'
DIAG_EMPTY_BLOCK        =
'空代码块'
DIAG_DIAGNOSTICS        =
'Lua 诊断'
DIAG_SYNTAX_CHECK       =
'Lua 语法检查'
DIAG_NEED_VERSION       =
'在 {} 中是合法的，当前为 {}'
DIAG_DEFINED_VERSION    =
'在 {} 中有定义，当前为 {}'
DIAG_DEFINED_CUSTOM     =
'在 {} 中有定义'
DIAG_DUPLICATE_CLASS    =
'重复定义的 Class `{}`。'
DIAG_UNDEFINED_CLASS    =
'未定义的 Class `{}`。'
DIAG_CYCLIC_EXTENDS     =
'循环继承。'
DIAG_INEXISTENT_PARAM   =
'不存在的参数。'
DIAG_DUPLICATE_PARAM    =
'重复的参数。'
DIAG_NEED_CLASS         =
'需要先定义 Class 。'
DIAG_DUPLICATE_SET_FIELD=
'重复定义的字段 `{}`。'
DIAG_SET_CONST          =
'不能对常量赋值。'
DIAG_SET_FOR_STATE      =
'修改了循环变量。'
DIAG_CODE_AFTER_BREAK   =
'无法执行到 `break` 后的代码。'
DIAG_UNBALANCED_ASSIGNMENTS =
'由于值的数量不够而被赋值为了 `nil` 。在Lua中, `x, y = 1` 等价于 `x, y = 1, nil` 。'
DIAG_REQUIRE_LIKE       =
'你可以在设置中将 `{}` 视为 `require`。'
DIAG_COSE_NON_OBJECT    =
'无法 close 此类型的值。（除非给此类型设置 `__close` 元方法）'
DIAG_COUNT_DOWN_LOOP    =
'你的意思是 `{}` 吗？'
DIAG_UNKNOWN            =
'无法推测出类型。'
DIAG_DEPRECATED         =
'已废弃。'
DIAG_DIFFERENT_REQUIRES =
'使用了不同的名字 require 了同一个文件。'
DIAG_REDUNDANT_RETURN   =
'冗余返回。'
DIAG_AWAIT_IN_SYNC      =
'只能在标记为异步的函数中调用异步函数。'
DIAG_NOT_YIELDABLE      =
'此函数的第 {} 个参数没有被标记为可让出，但是传入了异步函数。（使用 `---@param name async fun()` 来标记为可让出）'
DIAG_DISCARD_RETURNS    =
'不能丢弃此函数的返回值。'
DIAG_NEED_CHECK_NIL     =
'需要判空。'
DIAG_CIRCLE_DOC_CLASS                 =
'循环继承的类。'
DIAG_DOC_FIELD_NO_CLASS               =
'字段必须定义在类之后。'
DIAG_DUPLICATE_DOC_CLASS              =
'重复定义的类 `{}`。'
DIAG_DUPLICATE_DOC_FIELD              =
'重复定义的字段 `{}`。'
DIAG_DUPLICATE_DOC_PARAM              =
'重复指向的参数 `{}`。'
DIAG_UNDEFINED_DOC_CLASS              =
'未定义的类 `{}`。'
DIAG_UNDEFINED_DOC_NAME               =
'未定义的类型或别名 `{}`。'
DIAG_UNDEFINED_DOC_PARAM              =
'指向了未定义的参数 `{}`。'
DIAG_UNKNOWN_DIAG_CODE                =
'未知的诊断代号 `{}`。'

MWS_NOT_SUPPORT         =
'{} 目前还不支持多工作目录，我可能需要重启才能支持新的工作目录...'
MWS_RESTART             =
'重启'
MWS_NOT_COMPLETE        =
'工作目录还没有准备好，你可以稍后再试一下...'
MWS_COMPLETE            =
'工作目录准备好了，你可以再试一下了...'
MWS_MAX_PRELOAD         =
'预加载文件数已达上限（{}），你需要手动打开需要加载的文件。'
MWS_UCONFIG_FAILED      =
'用户配置保存失败。'
MWS_UCONFIG_UPDATED     =
'用户配置已更新。'
MWS_WCONFIG_UPDATED     =
'工作区配置已更新。'

WORKSPACE_SKIP_LARGE_FILE =
'已跳过过大的文件：{}。当前设置的大小限制为：{} KB，该文件大小为：{} KB'
WORKSPACE_LOADING         =
'正在加载工作目录'
WORKSPACE_DIAGNOSTIC      =
'正在对工作目录进行诊断'
WORKSPACE_SKIP_HUGE_FILE  =
'出于性能考虑，已停止对此文件解析：{}'

PARSER_CRASH            =
'语法解析崩溃了！遗言：{}'
PARSER_UNKNOWN          =
'未知语法错误...'
PARSER_MISS_NAME        =
'缺少名称。'
PARSER_UNKNOWN_SYMBOL   =
'未知符号`{symbol}`。'
PARSER_MISS_SYMBOL      =
'缺少符号`{symbol}`。'
PARSER_MISS_ESC_X       =
'必须是2个16进制字符。'
PARSER_UTF8_SMALL       =
'至少有1个字符。'
PARSER_UTF8_MAX         =
'必须在 {min} 与 {max} 之间。'
PARSER_ERR_ESC          =
'错误的转义符。'
PARSER_MUST_X16         =
'必须是16进制字符。'
PARSER_MISS_EXPONENT    =
'缺少指数部分。'
PARSER_MISS_EXP         =
'缺少表达式。'
PARSER_MISS_FIELD       =
'缺少字段/属性名。'
PARSER_MISS_METHOD      =
'缺少方法名。'
PARSER_ARGS_AFTER_DOTS  =
'`...`必须是最后一个参数。'
PARSER_KEYWORD          =
'关键字无法作为名称。'
PARSER_EXP_IN_ACTION    =
'该表达式不能作为语句。'
PARSER_BREAK_OUTSIDE    =
'`break`必须在循环内部。'
PARSER_MALFORMED_NUMBER =
'无法构成有效数字。'
PARSER_ACTION_AFTER_RETURN =
'`return`之后不能再执行代码。'
PARSER_ACTION_AFTER_BREAK =
'`break`之后不能再执行代码。'
PARSER_NO_VISIBLE_LABEL =
'标签`{label}`不可见。'
PARSER_REDEFINE_LABEL   =
'标签`{label}`重复定义。'
PARSER_UNSUPPORT_SYMBOL =
'{version} 不支持该符号。'
PARSER_UNEXPECT_DOTS    =
'`...`只能在不定参函数中使用。'
PARSER_UNEXPECT_SYMBOL  =
'未知的符号 `{symbol}` 。'
PARSER_UNKNOWN_TAG      =
'不支持的属性。'
PARSER_MULTI_TAG        =
'只能设置一个属性。'
PARSER_UNEXPECT_LFUNC_NAME =
'局部函数只能使用标识符作为名称。'
PARSER_UNEXPECT_EFUNC_NAME =
'函数作为表达式时不能命名。'
PARSER_ERR_LCOMMENT_END =
'应使用`{symbol}`来关闭多行注释。'
PARSER_ERR_C_LONG_COMMENT =
'Lua应使用`--[[ ]]`来进行多行注释。'
PARSER_ERR_LSTRING_END  =
'应使用`{symbol}`来关闭长字符串。'
PARSER_ERR_ASSIGN_AS_EQ =
'应使用`=`来进行赋值操作。'
PARSER_ERR_EQ_AS_ASSIGN =
'应使用`==`来进行等于判断。'
PARSER_ERR_UEQ          =
'应使用`~=`来进行不等于判断。'
PARSER_ERR_THEN_AS_DO   =
'应使用`then`。'
PARSER_ERR_DO_AS_THEN   =
'应使用`do`。'
PARSER_MISS_END         =
'缺少对应的`end`。'
PARSER_ERR_COMMENT_PREFIX =
'Lua应使用`--`来进行注释。'
PARSER_MISS_SEP_IN_TABLE =
'需要用`,`或`;`进行分割。'
PARSER_SET_CONST         =
'不能对常量赋值。'
PARSER_UNICODE_NAME      =
'包含了 Unicode 字符。'
PARSER_ERR_NONSTANDARD_SYMBOL =
'Lua中应使用符号 `{symbol}`。'
PARSER_MISS_SPACE_BETWEEN =
'符号之间必须保留空格'
PARSER_INDEX_IN_FUNC_NAME =
'命名函数的名称中不能使用 `[name]` 形式。'
PARSER_UNKNOWN_ATTRIBUTE  =
'局部变量属性应该是 `const` 或 `close`'
PARSER_LUADOC_MISS_CLASS_NAME           =
'缺少类名称。'
PARSER_LUADOC_MISS_EXTENDS_SYMBOL       =
'缺少符号 `:`。'
PARSER_LUADOC_MISS_CLASS_EXTENDS_NAME   =
'缺少要继承的类名称。'
PARSER_LUADOC_MISS_SYMBOL               =
'缺少符号 `{symbol}`。'
PARSER_LUADOC_MISS_ARG_NAME             =
'缺少参数名称。'
PARSER_LUADOC_MISS_TYPE_NAME            =
'缺少类型名。'
PARSER_LUADOC_MISS_ALIAS_NAME           =
'缺少别名。'
PARSER_LUADOC_MISS_ALIAS_EXTENDS        =
'缺少别名定义。'
PARSER_LUADOC_MISS_PARAM_NAME           =
'缺少要指向的参数名称。'
PARSER_LUADOC_MISS_PARAM_EXTENDS        =
'缺少参数的类型定义。'
PARSER_LUADOC_MISS_FIELD_NAME           =
'缺少字段名称。'
PARSER_LUADOC_MISS_FIELD_EXTENDS        =
'缺少字段的类型定义。'
PARSER_LUADOC_MISS_GENERIC_NAME         =
'缺少泛型名称。'
PARSER_LUADOC_MISS_GENERIC_EXTENDS_NAME =
'缺少泛型要继承的类名称。'
PARSER_LUADOC_MISS_VARARG_TYPE          =
'缺少不定参的类型定义。'
PARSER_LUADOC_MISS_FUN_AFTER_OVERLOAD   =
'缺少关键字 `fun`。'
PARSER_LUADOC_MISS_CATE_NAME            =
'缺少文档类型名称。'
PARSER_LUADOC_MISS_DIAG_MODE            =
'缺少诊断模式。'
PARSER_LUADOC_ERROR_DIAG_MODE           =
'诊断模式不正确。'
PARSER_LUADOC_MISS_LOCAL_NAME           =
'缺少变量名。'

SYMBOL_ANONYMOUS        =
'<匿名函数>'

HOVER_VIEW_DOCUMENTS    =
'查看文档'
HOVER_DOCUMENT_LUA51    =
'http://www.lua.org/manual/5.1/manual.html#{}'
HOVER_DOCUMENT_LUA52    =
'http://www.lua.org/manual/5.2/manual.html#{}'
HOVER_DOCUMENT_LUA53    =
'http://cloudwu.github.io/lua53doc/manual.html#{}'
HOVER_DOCUMENT_LUA54    =
'http://www.lua.org/manual/5.4/manual.html#{}'
HOVER_DOCUMENT_LUAJIT   =
'http://www.lua.org/manual/5.1/manual.html#{}'
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
'({} 个原型)'
HOVER_STRING_BYTES         =
'{} 个字节'
HOVER_STRING_CHARACTERS    =
'{} 个字节，{} 个字符'
HOVER_MULTI_DEF_PROTO      =
'({} 个定义，{} 个原型)'
HOVER_MULTI_PROTO_NOT_FUNC =
'({} 个非函数定义)'
HOVER_USE_LUA_PATH      =
'（搜索路径： `{}`）'
HOVER_EXTENDS           =
'展开为 {}'
HOVER_TABLE_TIME_UP     =
'出于性能考虑，已禁用了部分类型推断。'
HOVER_WS_LOADING        =
'正在加载工作目录：{} / {}'
HOVER_AWAIT_TOOLTIP     =
'正在调用异步函数，可能会让出当前协程'

ACTION_DISABLE_DIAG     =
'在工作区禁用诊断 ({})。'
ACTION_MARK_GLOBAL      =
'标记 `{}` 为已定义的全局变量。'
ACTION_REMOVE_SPACE     =
'清除所有后置空格。'
ACTION_ADD_SEMICOLON    =
'添加 `;` 。'
ACTION_ADD_BRACKETS     =
'添加括号。'
ACTION_RUNTIME_VERSION  =
'修改运行版本为 {} 。'
ACTION_OPEN_LIBRARY     =
'加载 {} 中的全局变量。'
ACTION_ADD_DO_END       =
'添加 `do ... end` 。'
ACTION_FIX_LCOMMENT_END =
'改用正确的多行注释关闭符号。'
ACTION_ADD_LCOMMENT_END =
'关闭多行注释。'
ACTION_FIX_C_LONG_COMMENT =
'修改为 Lua 的多行注释格式。'
ACTION_FIX_LSTRING_END  =
'改用正确的长字符串关闭符号。'
ACTION_ADD_LSTRING_END  =
'关闭长字符串。'
ACTION_FIX_ASSIGN_AS_EQ =
'改为 `=` 。'
ACTION_FIX_EQ_AS_ASSIGN =
'改为 `==` 。'
ACTION_FIX_UEQ          =
'改为 `~=` 。'
ACTION_FIX_THEN_AS_DO   =
'改为 `then` 。'
ACTION_FIX_DO_AS_THEN   =
'改为 `do` 。'
ACTION_ADD_END          =
'添加 `end` （根据缩进推测添加位置）。'
ACTION_FIX_COMMENT_PREFIX =
'改为 `--` 。'
ACTION_FIX_NONSTANDARD_SYMBOL =
'改为 `{symbol}`'
ACTION_RUNTIME_UNICODE_NAME =
'允许使用 Unicode 字符。'
ACTION_SWAP_PARAMS      =
'将其改为 `{node}` 的第 {index} 个参数'
ACTION_FIX_INSERT_SPACE =
'插入空格'
ACTION_JSON_TO_LUA      =
'把 JSON 转成 Lua'
ACTION_DISABLE_DIAG_LINE=
'在此行禁用诊断 ({})。'
ACTION_DISABLE_DIAG_FILE=
'在此文件禁用诊断 ({})。'
ACTION_MARK_ASYNC       =
'将当前函数标记为异步。'

COMMAND_DISABLE_DIAG       =
'禁用诊断'
COMMAND_MARK_GLOBAL        =
'标记全局变量'
COMMAND_REMOVE_SPACE       =
'清除所有后置空格'
COMMAND_ADD_BRACKETS       =
'添加括号'
COMMAND_RUNTIME_VERSION    =
'修改运行版本'
COMMAND_OPEN_LIBRARY       =
'加载第三方库中的全局变量'
COMMAND_UNICODE_NAME       =
'允许使用 Unicode 字符'
COMMAND_JSON_TO_LUA        =
'JSON 转 Lua'
COMMAND_JSON_TO_LUA_FAILED =
'JSON 转 Lua 失败：{}'

COMPLETION_IMPORT_FROM           =
'从 {} 中导入'
COMPLETION_DISABLE_AUTO_REQUIRE  =
'禁用自动require'
COMPLETION_ASK_AUTO_REQUIRE      =
'在文件顶部添加代码 require 此文件？'

DEBUG_MEMORY_LEAK       =
'{} 很抱歉发生了严重的内存泄漏，语言服务即将重启。'
DEBUG_RESTART_NOW       =
'立即重启'

WINDOW_COMPILING                 =
'正在编译'
WINDOW_DIAGNOSING                =
'正在诊断'
WINDOW_INITIALIZING              =
'正在初始化...'
WINDOW_PROCESSING_HOVER          =
'正在处理悬浮提示...'
WINDOW_PROCESSING_DEFINITION     =
'正在处理转到定义...'
WINDOW_PROCESSING_REFERENCE      =
'正在处理转到引用...'
WINDOW_PROCESSING_RENAME         =
'正在处理重命名...'
WINDOW_PROCESSING_COMPLETION     =
'正在处理自动完成...'
WINDOW_PROCESSING_SIGNATURE      =
'正在处理参数提示...'
WINDOW_PROCESSING_SYMBOL         =
'正在处理文件符号...'
WINDOW_PROCESSING_WS_SYMBOL      =
'正在处理工作区符号...'
WINDOW_PROCESSING_SEMANTIC_FULL  =
'正在处理全量语义着色...'
WINDOW_PROCESSING_SEMANTIC_RANGE =
'正在处理差量语义着色...'
WINDOW_PROCESSING_HINT           =
'正在处理内联提示...'
WINDOW_INCREASE_UPPER_LIMIT      =
'增加上限'
WINDOW_CLOSE                     =
'关闭'
WINDOW_SETTING_WS_DIAGNOSTIC     =
'你可以在设置中延迟或禁用工作目录诊断'
WINDOW_DONT_SHOW_AGAIN           =
'不再提示'
WINDOW_DELAY_WS_DIAGNOSTIC       =
'空闲时诊断（延迟{}秒）'
WINDOW_DISABLE_DIAGNOSTIC        =
'禁用工作区诊断'
WINDOW_LUA_STATUS_WORKSPACE      =
'工作区：{}'
WINDOW_LUA_STATUS_CACHED_FILES   =
'已缓存文件：{ast}/{max}'
WINDOW_LUA_STATUS_MEMORY_COUNT   =
'内存占用：{mem:.f}M'
WINDOW_LUA_STATUS_TIP            =
[[

这个图标是猫，
不是狗也不是狐狸！
             ↓↓↓
]]
WINDOW_LUA_STATUS_DIAGNOSIS_TITLE=
'进行工作区诊断'
WINDOW_LUA_STATUS_DIAGNOSIS_MSG  =
'是否进行工作区诊断？'
WINDOW_APPLY_SETTING             =
'应用设置'
WINDOW_CHECK_SEMANTIC            =
'如果你正在使用市场中的颜色主题，你可能需要同时修改 `editor.semanticHighlighting.enabled` 选项为 `true` 才会使语义着色生效。'
WINDOW_TELEMETRY_HINT            =
'请允许发送匿名的使用数据与错误报告，帮助我们进一步完善此插件。在[此处](https://github.com/sumneko/lua-language-server/wiki/%E9%9A%90%E7%A7%81%E5%A3%B0%E6%98%8E)阅读我们的隐私声明。'
WINDOW_TELEMETRY_ENABLE          =
'允许'
WINDOW_TELEMETRY_DISABLE         =
'禁止'
WINDOW_CLIENT_NOT_SUPPORT_CONFIG =
'你的客户端不支持从服务侧修改设置，请手动修改如下设置：'
WINDOW_LCONFIG_NOT_SUPPORT_CONFIG=
'暂不支持自动修改本地设置，请手动修改如下设置：'
WINDOW_MANUAL_CONFIG_ADD         =
'为 `{key}` 添加值 `{value:q}`;'
WINDOW_MANUAL_CONFIG_SET         =
'将 `{key}` 的值设置为 `{value:q}`;'
WINDOW_MANUAL_CONFIG_PROP        =
'将 `{key}` 的属性 `{prop}` 设置为 `{value:q}`;'
WINDOW_APPLY_WHIT_SETTING        =
'应用并修改设置'
WINDOW_APPLY_WHITOUT_SETTING     =
'应用但不修改设置'
WINDOW_ASK_APPLY_LIBRARY         =
'是否需要将你的工作环境配置为 `{}` ？'
WINDOW_SEARCHING_IN_FILES        =
'正在文件中搜索...'

CONFIG_LOAD_FAILED               =
'无法读取设置文件：{}'
CONFIG_LOAD_ERROR                =
'设置文件加载错误：{}'
CONFIG_TYPE_ERROR                =
'设置文件必须是lua或json格式：{}'

PLUGIN_RUNTIME_ERROR             =
[[
插件发生错误，请汇报给插件作者。
请在输出或日志中查看详细信息。
插件路径：{}
]]
PLUGIN_TRUST_LOAD                =
[[
当前设置试图加载位于此位置的插件：{}

注意，恶意的插件可能会危害您的电脑
]]
PLUGIN_TRUST_YES                 =
[[
信任并加载插件
]]
PLUGIN_TRUST_NO                  =
[[
不要加载此插件
]]

CLI_CHECK_ERROR_TYPE =
'check 必须是一个字符串，但是是一个 {}'
CLI_CHECK_ERROR_URI =
'check 必须是一个有效的 URI，但是是 {}'
CLI_CHECK_ERROR_LEVEL =
'checklevel 必须是这些值之一：{}'
CLI_CHECK_INITING =
'正在初始化...'
CLI_CHECK_SUCCESS =
'诊断完成，没有发现问题'
CLI_CHECK_RESULTS =
'诊断完成，共有 {} 个问题，请查看 {}'
