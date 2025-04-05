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
DIAG_UNNECESSARY_ASSERT =
'不必要的断言：此表达式始终为真值。'
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
DIAG_DUPLICATE_DOC_ALIAS              =
'重复定义的别名 `{}`。'
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
DIAG_MISSING_GLOBAL_DOC_COMMENT       =
'全局函数 `{}` 缺少注释。'
DIAG_MISSING_GLOBAL_DOC_PARAM         =
'全局函数 `{2}` 的参数 `{1}` 缺少 @param 注解。'
DIAG_MISSING_GLOBAL_DOC_RETURN        =
'全局函数 `{2}` 的第 `{1}` 个返回值缺少 @return 注解。'
DIAG_MISSING_LOCAL_EXPORT_DOC_COMMENT =
'导出的局部函数 `{}` 缺少注释。'
DIAG_MISSING_LOCAL_EXPORT_DOC_PARAM   =
'导出的局部函数 `{2}` 的参数 `{1}` 缺少 @param 注解。'
DIAG_MISSING_LOCAL_EXPORT_DOC_RETURN  =
'导出的局部函数 `{2}` 的第 {1} 个返回值缺少 @return 注解。'
DIAG_INCOMPLETE_SIGNATURE_DOC_PARAM   =
'签名不完整。参数 `{1}` 缺少 @param 注解。'
DIAG_INCOMPLETE_SIGNATURE_DOC_RETURN  =
'签名不完整。第 {1} 个返回值缺少 @return 注解。'
DIAG_UNKNOWN_DIAG_CODE                =
'未知的诊断代号 `{}`。'
DIAG_CAST_LOCAL_TYPE                  =
'已显式定义变量的类型为 `{def}` ，不能再将其类型转换为 `{ref}`。'
DIAG_CAST_FIELD_TYPE                  =
'已显式定义字段的类型为 `{def}` ，不能再将其类型转换为 `{ref}`。'
DIAG_ASSIGN_TYPE_MISMATCH             =
'不能将 `{ref}` 赋值给 `{def}`。'
DIAG_PARAM_TYPE_MISMATCH              =
'不能将 `{ref}` 赋给参数 `{def}`。'
DIAG_UNKNOWN_CAST_VARIABLE            =
'未知的类型转换变量 `{}`。'
DIAG_CAST_TYPE_MISMATCH               =
'不能将 `{def}` 转换为 `{ref}`。'
DIAG_MISSING_RETURN_VALUE             =
'至少需要 {min} 个返回值，但此处只返回 {rmax} 个值。'
DIAG_MISSING_RETURN_VALUE_RANGE       =
'至少需要 {min} 个返回值，但此处只返回 {rmin} 到 {rmax} 个值。'
DIAG_REDUNDANT_RETURN_VALUE           =
'最多只有 {max} 个返回值，但此处返回了第 {rmax} 个值。'
DIAG_REDUNDANT_RETURN_VALUE_RANGE     =
'最多只有 {max} 个返回值，但此处返回了第 {rmin} 到第 {rmax} 个值。'
DIAG_MISSING_RETURN                   =
'此处需要返回值。'
DIAG_RETURN_TYPE_MISMATCH             =
'第 {index} 个返回值的类型为 `{def}` ，但实际返回的是 `{ref}`。'
DIAG_UNKNOWN_OPERATOR                 =
'未知的运算符 `{}`。'
DIAG_UNREACHABLE_CODE                 =
'不可达的代码。'
DIAG_INVISIBLE_PRIVATE                =
'字段 `{field}` 是私有的，只能在 `{class}` 类中才能访问。'
DIAG_INVISIBLE_PROTECTED              =
'字段 `{field}` 受到保护，只能在 `{class}` 类极其子类中才能访问。'
DIAG_INVISIBLE_PACKAGE                =
'字段 `{field}` 只能在相同的文件 `{uri}` 中才能访问。'
DIAG_GLOBAL_ELEMENT                   =
'全局变量。'
DIAG_MISSING_FIELDS                   =
'缺少类型 `{1}` 的必要字段： {2}'
DIAG_INJECT_FIELD                     =
'不能在 `{class}` 的引用中注入字段 `{field}` 。{fix}'
DIAG_INJECT_FIELD_FIX_CLASS           =
'如要允许注入，请对 `{node}` 使用 `{fix}` 。'
DIAG_INJECT_FIELD_FIX_TABLE           =
'如要允许注入，请在定义中添加 `{fix}` 。'

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
WORKSPACE_NOT_ALLOWED     =
'你的工作目录被设置为了 `{}`，Lua语言服务拒绝加载此目录，请检查你的配置。[了解更多](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)'
WORKSPACE_SCAN_TOO_MUCH   =
'已扫描了超过 {} 个文件，当前扫描的目录为 `{}`. 请参阅 [FAQ](https://luals.github.io/wiki/faq#how-can-i-improve-startup-speeds) 了解如何排除多余的文件。也可能是你的 [设置有错误](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder).'

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
PARSER_AMBIGUOUS_SYNTAX   =
'在 Lua 5.1 中，函数调用的左括号必须与函数在同一行。'
PARSER_NEED_PAREN         =
'需要添加一对括号。'
PARSER_NESTING_LONG_MARK  =
'Lua 5.1 中不允许使用嵌套的 `[[...]]` 。'
PARSER_LOCAL_LIMIT        =
'只能同时存在200个活跃的局部变量与上值。'
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
ACTION_ADD_DICT         =
'将 \'{}\' 添加到工作区的词典中。'
ACTION_FIX_ADD_PAREN    =
'添加括号。'
ACTION_AUTOREQUIRE      =
"导入 '{}' 作为 `{}`"

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
COMMAND_ADD_DICT           =
'将单词添加到字典'
COMMAND_REFERENCE_COUNT    =
'{} 个引用'

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
WINDOW_PROCESSING_BUILD_META     =
'正在处理编译器元数据...'
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
'请允许发送匿名的使用数据与错误报告，帮助我们进一步完善此插件。在[此处](https://luals.github.io/privacy/#language-server)阅读我们的隐私声明。'
WINDOW_TELEMETRY_ENABLE          =
'允许'
WINDOW_TELEMETRY_DISABLE         =
'禁止'
WINDOW_CLIENT_NOT_SUPPORT_CONFIG =
'你的客户端不支持从服务侧修改设置，请手动修改如下设置：'
WINDOW_LCONFIG_NOT_SUPPORT_CONFIG=
'暂不支持自动修改本地设置，请手动修改如下设置：'
WINDOW_MANUAL_CONFIG_ADD         =
'为 `{key}` 添加元素 `{value:q}`;'
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
WINDOW_CONFIG_LUA_DEPRECATED     =
'`config.lua` 已废弃，请改用 `config.json` 。'
WINDOW_CONVERT_CONFIG_LUA        =
'转换为 `config.json`'
WINDOW_MODIFY_REQUIRE_PATH      =
'你想要修改 `require` 的路径吗？'
WINDOW_MODIFY_REQUIRE_OK        =
'修改'

CONFIG_LOAD_FAILED               =
'无法读取设置文件：{}'
CONFIG_LOAD_ERROR                =
'设置文件加载错误：{}'
CONFIG_TYPE_ERROR                =
'设置文件必须是lua或json格式：{}'
CONFIG_MODIFY_FAIL_SYNTAX_ERROR  =
'修改设置失败，设置文件中有语法错误：{}'
CONFIG_MODIFY_FAIL_NO_WORKSPACE  =
[[
修改设置失败：
* 当前模式为单文件模式，服务器只能在工作区中创建 `.luarc.json` 文件。
* 语言客户端不支持从服务器侧修改设置。

请手动修改以下设置：
{}
]]
CONFIG_MODIFY_FAIL               =
[[
修改设置失败

请手动修改以下设置：
{}
]]

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
CLI_CHECK_PROGRESS =
'检测到问题 {} 在文件 {} 中'
CLI_CHECK_RESULTS_OUTPATH =
'诊断完成，共有 {} 个问题，请查看 {}'
CLI_CHECK_RESULTS_PRETTY =
'诊断完成，共有 {} 个问题'
CLI_CHECK_MULTIPLE_WORKERS =
'开启 {} 个工作任务，进度输出将会被禁用。这可能会花费几分钟。'
CLI_DOC_INITING   =
'加载文档 ...'
CLI_DOC_DONE      =
'文档导出完成！'
CLI_DOC_WORKING   =
'正在生成文档...'

TYPE_ERROR_ENUM_GLOBAL_DISMATCH =
'类型 `{child}` 无法匹配 `{parent}` 的枚举类型'
TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED =
'无法在枚举中使用泛型 `{child}`'
TYPE_ERROR_ENUM_LITERAL_DISMATCH =
'字面量 `{child}` 无法匹配 `{parent}` 的枚举值'
TYPE_ERROR_ENUM_OBJECT_DISMATCH =
'对象 `{child}` 无法匹配 `{parent}` 的枚举值，它们必须是同一个对象'
TYPE_ERROR_ENUM_NO_OBJECT =
'无法识别传入的枚举值 `{child}`'
TYPE_ERROR_INTEGER_DISMATCH =
'字面量 `{child}` 无法匹配整数 `{parent}`'
TYPE_ERROR_STRING_DISMATCH =
'字面量 `{child}` 无法匹配字符串 `{parent}`'
TYPE_ERROR_BOOLEAN_DISMATCH =
'字面量 `{child}` 无法匹配布尔值 `{parent}`'
TYPE_ERROR_TABLE_NO_FIELD =
'表中不存在字段 `{key}`'
TYPE_ERROR_TABLE_FIELD_DISMATCH =
'字段 `{key}` 的类型为 `{child}`，无法匹配 `{parent}`'
TYPE_ERROR_CHILD_ALL_DISMATCH =
'`{child}` 中的所有子类型均无法匹配 `{parent}`'
TYPE_ERROR_PARENT_ALL_DISMATCH =
'`{child}` 无法匹配 `{parent}` 中的任何子类'
TYPE_ERROR_UNION_DISMATCH =
'`{child}` 无法匹配 `{parent}`'
TYPE_ERROR_OPTIONAL_DISMATCH =
'可选类型无法匹配 `{parent}`'
TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER =
'无法将数字 `{child}` 转换为整数'
TYPE_ERROR_NUMBER_TYPE_TO_INTEGER =
'无法将数字类型转换为整数类型'
TYPE_ERROR_DISMATCH =
'类型 `{child}` 无法匹配 `{parent}`'

LUADOC_DESC_CLASS =
[=[
定义一个类或表的结构
## 语法
`---@class <name> [: <parent>[, <parent>]...]`
## 用法
```
---@class Manager: Person, Human
Manager = {}
```
---
[文档](https://luals.github.io/wiki/annotations#class)
]=]
LUADOC_DESC_TYPE =
[=[
指定某个变量的类型

默认类型: `nil`, `any`, `boolean`, `string`, `number`, `integer`,
`function`, `table`, `thread`, `userdata`, `lightuserdata`

(可以通过 `@alias` 来创建自定义类型)

## 语法
`---@type <type>[| [type]...`

## 用法
### 常规
```
---@type nil|table|myClass
local Example = nil
```

### 数组
```
---@type number[]
local phoneNumbers = {}
```

### 枚举
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

### 函数
```
---@type fun(mode?: "r"|"w"): string
local myFunction
```
---
[文档](https://luals.github.io/wiki/annotations#type)
]=]
LUADOC_DESC_ALIAS =
[=[
可以使用 `@param`, `@type` 等类型注解创建你的自定义类型。

## 语法
`---@alias <name> <type> [description]`\
or
```
---@alias <name>
---| 'value' [# comment]
---| 'value2' [# comment]
...
```

## 用法
### 扩展为其它类型
```
---@alias filepath string Path to a file

---@param path filepath Path to the file to search in
function find(path, pattern) end
```

### 枚举
```
---@alias font-style
---| '"underlined"' # Underline the text
---| '"bold"' # Bolden the text
---| '"italic"' # Make the text italicized

---@param style font-style Style to apply
function setFontStyle(style) end
```

### 字面量枚举
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
[文档](https://luals.github.io/wiki/annotations#alias)
]=]
LUADOC_DESC_PARAM =
[=[
声明一个函数的参数

## 语法
`@param <name>[?] <type> [comment]`

## 用法
### 常规
```
---@param url string The url to request
---@param headers? table<string, string> HTTP headers to send
---@param timeout? number Timeout in seconds
function get(url, headers, timeout) end
```

### 可变参数
```
---@param base string The base to concat to
---@param ... string The values to concat
function concat(base, ...) end
```
---
[文档](https://luals.github.io/wiki/annotations#param)
]=]
LUADOC_DESC_RETURN =
[=[
声明返回值

## 语法
`@return <type> [name] [description]`\
or\
`@return <type> [# description]`

## 用法
### 常规
```
---@return number
---@return number # The green component
---@return number b The blue component
function hexToRGB(hex) end
```

### 只有类型和名称
```
---@return number x, number y
function getCoords() end
```

### 只有类型
```
---@return string, string
function getFirstLast() end
```

### 返回可变值
```
---@return string ... The tags of the item
function getTags(item) end
```
---
[文档](https://luals.github.io/wiki/annotations#return)
]=]
LUADOC_DESC_FIELD =
[=[
声明一个类或表的字段。这将允许你为表提供更详细的类型。
在 `v3.6.0` 后， 你可以标记一个字段为 `private`，
`protected`， `public` 或 `package`。

## 语法
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
[文档](https://luals.github.io/wiki/annotations#field)
]=]
LUADOC_DESC_GENERIC =
[=[
仿照泛型。泛型可以允许类型被复用，
因为它们有助于定义一种可以与不同类型一起使用的 “通用形状”。

## 语法
`---@generic <name> [:parent_type] [, <name> [:parent_type]]`

## 用法
### 常规
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

### 捕获泛型类型的名称
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

### 在表中使用泛型
```
---@class table<K, V>: { [K]: V }

-- This is what allows us to create a table
-- and intellisense keeps track of any type
-- we give for key (K) or value (V)
```
---
[文档](https://luals.github.io/wiki/annotations/#generic)
]=]
LUADOC_DESC_VARARG =
[=[
主要用于对 EmmyLua 传统注解支持。`@vararg` 并不提供输入或允许描述。

**在描述参数时（无论是不是变量），你应该使用 `@param`。**

## 语法
`@vararg <type>`

## 用法
```
---Concat strings together
---@vararg string
function concat(...) end
```
---
[文档](https://luals.github.io/wiki/annotations#vararg)
]=]
LUADOC_DESC_OVERLOAD =
[=[
允许定义多个函数签名。

## 语法
`---@overload fun(<name>[: <type>] [, <name>[: <type>]]...)[: <type>[, <type>]...]`

## 用法
```
---@overload fun(t: table, value: any): number
function table.insert(t, position, value) end
```
---
[文档](https://luals.github.io/wiki/annotations#overload)
]=]
LUADOC_DESC_DEPRECATED =
[=[
将函数标记为已弃用。这会使任何已弃用函数被调用时出现删除线。

## 语法
`---@deprecated`

---
[文档](https://luals.github.io/wiki/annotations#deprecated)
]=]
LUADOC_DESC_META =
[=[
标识这个文件是元文件，并且仅用于定义和语法提示。

元文件中主要有三个需要注意的地方：
1. 在元文件中不会有任何基于上下文的语法提示
2. 悬停在使用元文件的 `require` 上时，会显示 `[meta]` 而不是绝对路径
3. `Find Reference` 功能会忽略元文件

## 语法
`---@meta`

---
[文档](https://luals.github.io/wiki/annotations#meta)
]=]
LUADOC_DESC_VERSION =
[=[
指定此函数专用的 Lua 版本。

Lua 版本: `5.1`, `5.2`, `5.3`, `5.4`, `JIT`。

需要配置 `Diagnostics: Needed File Status`。

## 语法
`---@version <version>[, <version>]...`

## 用法
### 常规
```
---@version JIT
function onlyWorksInJIT() end
```
### Specify multiple versions
```
---@version <5.2,JIT
function oldLuaOnly() end
```
---
[文档](https://luals.github.io/wiki/annotations#version)
]=]
LUADOC_DESC_SEE =
[=[
Define something that can be viewed for more information
定义可以查看更多信息的内容

## 语法
`---@see <text>`

---
[文档](https://luals.github.io/wiki/annotations#see)
]=]
LUADOC_DESC_DIAGNOSTIC =
[=[
开启或关闭对错误，警告或其他的诊断检查。

操作: `disable`, `enable`, `disable-line`, `disable-next-line`

[名称](https://github.com/LuaLS/lua-language-server/blob/cbb6e6224094c4eb874ea192c5f85a6cba099588/script/proto/define.lua#L54)

## 语法
`---@diagnostic <action>[: <name>]`

## 用法
### 关闭下一行
```
---@diagnostic disable-next-line: undefined-global
```

### 手动切换
```
---@diagnostic disable: unused-local
local unused = "hello world"
---@diagnostic enable: unused-local
```
---
[文档](https://luals.github.io/wiki/annotations#diagnostic)
]=]
LUADOC_DESC_MODULE =
[=[
提供 `require` 的语义。

## 语法
`---@module <'module_name'>`

## 用法
```
---@module 'string.utils'
local stringUtils
-- This is functionally the same as:
local module = require('string.utils')
```
---
[文档](https://luals.github.io/wiki/annotations#module)
]=]
LUADOC_DESC_ASYNC =
[=[
标记一个函数为异步

## 语法
`---@async`

---
[文档](https://luals.github.io/wiki/annotations#async)
]=]
LUADOC_DESC_NODISCARD =
[=[
阻止这个函数的返回值被丢弃或忽略。
如果忽略返回值，将会引起 `discard-returns` 警告。

## 语法
`---@nodiscard`

---
[文档](https://luals.github.io/wiki/annotations#nodiscard)
]=]
LUADOC_DESC_CAST =
[=[
允许类型转换。

## 语法
`@cast <variable> <[+|-]type>[, <[+|-]type>]...`

## 用法
### 改写类型
```
---@type integer
local x --> integer

---@cast x string
print(x) --> string
```
### 添加类型
```
---@type string
local x --> string

---@cast x +boolean, +number
print(x) --> string|boolean|number
```
### 移除类型
```
---@type string|table
local x --> string|table

---@cast x -string
print(x) --> table
```
---
[文档](https://luals.github.io/wiki/annotations#cast)
]=]
LUADOC_DESC_OPERATOR =
[=[
为[算子元方法](http://lua-users.org/wiki/MetatableEvents) 提供类型声明。

## 语法
`@operator <operation>[(input_type)]:<resulting_type>`

## 用法
### Vector 加方法
```
---@class Vector
---@operator add(Vector):Vector

vA = Vector.new(1, 2, 3)
vB = Vector.new(10, 20, 30)

vC = vA + vB
--> Vector
```
### 一元减法
```
---@class Passcode
---@operator unm:integer

pA = Passcode.new(1234)
pB = -pA
--> integer
```
[查看请求](https://github.com/LuaLS/lua-language-server/issues/599)
]=]
LUADOC_DESC_ENUM =
[=[
将表标记为枚举。如果你想要一个枚举但是无法将其定义为 Lua 表，看一眼 [`@alias`](https://luals.github.io/wiki/annotations#alias)
标签。

## 语法
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
提供一个其它文件中源代码的引用。当查找某一项的定义时，将会使用它的 `@source`。

## 语法
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
标记一个函数为其所处文件的私有成员。一个打包的函数不可以被其它文件访问。

## 语法
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
标记一个字段为类的私有成员。私有字段仅可在其所属的类中访问，并且不能被子类访问。

## 语法
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
标记一个字段为类的受保护成员。受保护字段仅可在其所属的类或子类中访问。

## 语法
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
