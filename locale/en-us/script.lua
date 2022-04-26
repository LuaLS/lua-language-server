DIAG_LINE_ONLY_SPACE    =
'Line with spaces only.'
DIAG_LINE_POST_SPACE    =
'Line with postspace.'
DIAG_UNUSED_LOCAL       =
'Unused local `{}`.'
DIAG_UNDEF_GLOBAL       =
'Undefined global `{}`.'
DIAG_UNDEF_FIELD        =
'Undefined field `{}`.'
DIAG_UNDEF_ENV_CHILD    =
'Undefined variable `{}` (overloaded `_ENV` ).'
DIAG_UNDEF_FENV_CHILD   =
'Undefined variable `{}` (inside module).'
DIAG_GLOBAL_IN_NIL_ENV  =
'Invalid global (`_ENV` is `nil`).'
DIAG_GLOBAL_IN_NIL_FENV =
'Invalid global (module environment is `nil`).'
DIAG_UNUSED_LABEL       =
'Unused label `{}`.'
DIAG_UNUSED_FUNCTION    =
'Unused functions.'
DIAG_UNUSED_VARARG      =
'Unused vararg.'
DIAG_REDEFINED_LOCAL    =
'Redefined local `{}`.'
DIAG_DUPLICATE_INDEX    =
'Duplicate index `{}`.'
DIAG_DUPLICATE_METHOD   =
'Duplicate method `{}`.'
DIAG_PREVIOUS_CALL      =
'Will be interpreted as `{}{}`. It may be necessary to add a `,`.'
DIAG_PREFIELD_CALL      =
'Will be interpreted as `{}{}`. It may be necessary to add a `,` or `;`.'
DIAG_OVER_MAX_ARGS      =
'The function received a maximum of {:d} arguments, but got {:d}.'
DIAG_MISS_ARGS          =
'the function received at least {:d} arguments, but got {:d}.'
DIAG_OVER_MAX_VALUES    =
'Only has {} variables, but you set {} values.'
DIAG_AMBIGUITY_1        =
'Compute `{}` first. You may need to add brackets.'
DIAG_LOWERCASE_GLOBAL   =
'Global variable in lowercase initial, Did you miss `local` or misspell it?'
DIAG_EMPTY_BLOCK        =
'Empty block.'
DIAG_DIAGNOSTICS        =
'Lua Diagnostics.'
DIAG_SYNTAX_CHECK       =
'Lua Syntax Check.'
DIAG_NEED_VERSION       =
'Supported in {}, current is {}.'
DIAG_DEFINED_VERSION    =
'Defined in {}, current is {}.'
DIAG_DEFINED_CUSTOM     =
'Defined in {}.'
DIAG_DUPLICATE_CLASS    =
'Duplicate Class `{}`.'
DIAG_UNDEFINED_CLASS    =
'Undefined Class `{}`.'
DIAG_CYCLIC_EXTENDS     =
'Cyclic extends.'
DIAG_INEXISTENT_PARAM   =
'Inexistent param.'
DIAG_DUPLICATE_PARAM    =
'Duplicate param.'
DIAG_NEED_CLASS         =
'Class needs to be defined first.'
DIAG_DUPLICATE_SET_FIELD=
'Duplicate field `{}`.'
DIAG_SET_CONST          =
'Assignment to const variable.'
DIAG_SET_FOR_STATE      =
'Assignment to for-state variable.'
DIAG_CODE_AFTER_BREAK   =
'Unable to execute code after `break`.'
DIAG_UNBALANCED_ASSIGNMENTS =
'The value is assigned as `nil` because the number of values is not enough. In Lua, `x, y = 1 ` is equivalent to `x, y = 1, nil` .'
DIAG_REQUIRE_LIKE       =
'You can treat `{}` as `require` by setting.'
DIAG_COSE_NON_OBJECT    =
'Cannot close a value of this type. (Unless set `__close` meta method)'
DIAG_COUNT_DOWN_LOOP    =
'Do you mean `{}` ?'
DIAG_UNKNOWN            =
'Can not infer type.'
DIAG_DEPRECATED         =
'Deprecated.'
DIAG_DIFFERENT_REQUIRES =
'The same file is required with different names.'
DIAG_REDUNDANT_RETURN   =
'Redundant return.'
DIAG_AWAIT_IN_SYNC      =
'Async function can only be called in async function.'
DIAG_NOT_YIELDABLE      =
'The {}th parameter of this function was not marked as yieldable, but an async function was passed in. (Use `---@param name async fun()` to mark as yieldable)'
DIAG_DISCARD_RETURNS    =
'The return values of this function cannot be discarded.'
DIAG_NEED_CHECK_NIL     =
'Need check nil.'
DIAG_CIRCLE_DOC_CLASS                 =
'Circularly inherited classes.'
DIAG_DOC_FIELD_NO_CLASS               =
'The field must be defined after the class.'
DIAG_DUPLICATE_DOC_CLASS              =
'Duplicate defined class `{}`.'
DIAG_DUPLICATE_DOC_FIELD              =
'Duplicate defined fields `{}`.'
DIAG_DUPLICATE_DOC_PARAM              =
'Duplicate params `{}`.'
DIAG_UNDEFINED_DOC_CLASS              =
'Undefined class `{}`.'
DIAG_UNDEFINED_DOC_NAME               =
'Undefined type or alias `{}`.'
DIAG_UNDEFINED_DOC_PARAM              =
'Undefined param `{}`.'
DIAG_UNKNOWN_DIAG_CODE                =
'Unknown diagnostic code `{}`.'

MWS_NOT_SUPPORT         =
'{} does not support multi workspace for now, I may need to restart to support the new workspace ...'
MWS_RESTART             =
'Restart'
MWS_NOT_COMPLETE        =
'Workspace is not complete yet. You may try again later...'
MWS_COMPLETE            =
'Workspace is complete now. You may try again...'
MWS_MAX_PRELOAD         =
'Preloaded files has reached the upper limit ({}), you need to manually open the files that need to be loaded.'
MWS_UCONFIG_FAILED      =
'Saving user setting failed.'
MWS_UCONFIG_UPDATED     =
'User setting updated.'
MWS_WCONFIG_UPDATED     =
'Workspace setting updated.'

WORKSPACE_SKIP_LARGE_FILE =
'Too large file: {} skipped. The currently set size limit is: {} KB, and the file size is: {} KB.'
WORKSPACE_LOADING         =
'Loading workspace'
WORKSPACE_DIAGNOSTIC      =
'Diagnosing workspace'
WORKSPACE_SKIP_HUGE_FILE  =
'For performance reasons, the parsing of this file has been stopped: {}'

PARSER_CRASH            =
'Parser crashed! Last words:{}'
PARSER_UNKNOWN          =
'Unknown syntax error...'
PARSER_MISS_NAME        =
'<name> expected.'
PARSER_UNKNOWN_SYMBOL   =
'Unexpected symbol `{symbol}`.'
PARSER_MISS_SYMBOL      =
'Missed symbol `{symbol}`.'
PARSER_MISS_ESC_X       =
'Should be 2 hexadecimal digits.'
PARSER_UTF8_SMALL       =
'At least 1 hexadecimal digit.'
PARSER_UTF8_MAX         =
'Should be between {min} and {max} .'
PARSER_ERR_ESC          =
'Invalid escape sequence.'
PARSER_MUST_X16         =
'Should be hexadecimal digits.'
PARSER_MISS_EXPONENT    =
'Missed digits for the exponent.'
PARSER_MISS_EXP         =
'<exp> expected.'
PARSER_MISS_FIELD       =
'<field> expected.'
PARSER_MISS_METHOD      =
'<method> expected.'
PARSER_ARGS_AFTER_DOTS  =
'`...` should be the last arg.'
PARSER_KEYWORD          =
'<keyword> cannot be used as name.'
PARSER_EXP_IN_ACTION    =
'Unexpected <exp> .'
PARSER_BREAK_OUTSIDE    =
'<break> not inside a loop.'
PARSER_MALFORMED_NUMBER =
'Malformed number.'
PARSER_ACTION_AFTER_RETURN =
'<eof> expected after `return`.'
PARSER_ACTION_AFTER_BREAK =
'<eof> expected after `break`.'
PARSER_NO_VISIBLE_LABEL =
'No visible label `{label}` .'
PARSER_REDEFINE_LABEL   =
'Label `{label}` already defined.'
PARSER_UNSUPPORT_SYMBOL =
'{version} does not support this grammar.'
PARSER_UNEXPECT_DOTS    =
'Cannot use `...` outside a vararg function.'
PARSER_UNEXPECT_SYMBOL  =
'Unexpected symbol `{symbol}` .'
PARSER_UNKNOWN_TAG      =
'Unknown attribute.'
PARSER_MULTI_TAG        =
'Does not support multi attributes.'
PARSER_UNEXPECT_LFUNC_NAME =
'Local function can only use identifiers as name.'
PARSER_UNEXPECT_EFUNC_NAME =
'Function as expression cannot be named.'
PARSER_ERR_LCOMMENT_END =
'Multi-line annotations should be closed by `{symbol}` .'
PARSER_ERR_C_LONG_COMMENT =
'Lua should use `--[[ ]]` for multi-line annotations.'
PARSER_ERR_LSTRING_END  =
'Long string should be closed by `{symbol}` .'
PARSER_ERR_ASSIGN_AS_EQ =
'Should use `=` for assignment.'
PARSER_ERR_EQ_AS_ASSIGN =
'Should use `==` for equal.'
PARSER_ERR_UEQ          =
'Should use `~=` for not equal.'
PARSER_ERR_THEN_AS_DO   =
'Should use `then` .'
PARSER_ERR_DO_AS_THEN   =
'Should use `do` .'
PARSER_MISS_END         =
'Miss corresponding `end` .'
PARSER_ERR_COMMENT_PREFIX =
'Lua should use `--` for annotations.'
PARSER_MISS_SEP_IN_TABLE =
'Miss symbol `,` or `;` .'
PARSER_SET_CONST         =
'Assignment to const variable.'
PARSER_UNICODE_NAME      =
'Contains Unicode characters.'
PARSER_ERR_NONSTANDARD_SYMBOL =
'Lua should use `{symbol}` .'
PARSER_MISS_SPACE_BETWEEN =
'Spaces must be left between symbols.'
PARSER_INDEX_IN_FUNC_NAME =
'The `[name]` form cannot be used in the name of a named function.'
PARSER_UNKNOWN_ATTRIBUTE  =
'Local attribute should be `const` or `close`'
PARSER_LUADOC_MISS_CLASS_NAME           =
'<class name> expected.'
PARSER_LUADOC_MISS_EXTENDS_SYMBOL       =
'`:` expected.'
PARSER_LUADOC_MISS_CLASS_EXTENDS_NAME   =
'<class extends name> expected.'
PARSER_LUADOC_MISS_SYMBOL               =
'`{symbol}` expected.'
PARSER_LUADOC_MISS_ARG_NAME             =
'<arg name> expected.'
PARSER_LUADOC_MISS_TYPE_NAME            =
'<type name> expected.'
PARSER_LUADOC_MISS_ALIAS_NAME           =
'<alias name> expected.'
PARSER_LUADOC_MISS_ALIAS_EXTENDS        =
'<alias extends> expected.'
PARSER_LUADOC_MISS_PARAM_NAME           =
'<param name> expected.'
PARSER_LUADOC_MISS_PARAM_EXTENDS        =
'<param extends> expected.'
PARSER_LUADOC_MISS_FIELD_NAME           =
'<field name> expected.'
PARSER_LUADOC_MISS_FIELD_EXTENDS        =
'<field extends> expected.'
PARSER_LUADOC_MISS_GENERIC_NAME         =
'<generic name> expected.'
PARSER_LUADOC_MISS_GENERIC_EXTENDS_NAME =
'<generic extends name> expected.'
PARSER_LUADOC_MISS_VARARG_TYPE          =
'<vararg type> expected.'
PARSER_LUADOC_MISS_FUN_AFTER_OVERLOAD   =
'`fun` expected.'
PARSER_LUADOC_MISS_CATE_NAME            =
'<doc name> expected.'
PARSER_LUADOC_MISS_DIAG_MODE            =
'<diagnostic mode> expected.'
PARSER_LUADOC_ERROR_DIAG_MODE           =
'<diagnostic mode> incorrect.'
PARSER_LUADOC_MISS_LOCAL_NAME           =
'<local name> expected.'

SYMBOL_ANONYMOUS        =
'<Anonymous>'

HOVER_VIEW_DOCUMENTS    =
'View documents'
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
'({} prototypes)'
HOVER_STRING_BYTES         =
'{} bytes'
HOVER_STRING_CHARACTERS    =
'{} bytes, {} characters'
HOVER_MULTI_DEF_PROTO      =
'({} definitions, {} prototypes)'
HOVER_MULTI_PROTO_NOT_FUNC =
'({} non functional definition)'
HOVER_USE_LUA_PATH      =
'(Search path: `{}`)'
HOVER_EXTENDS           =
'Expand to {}'
HOVER_TABLE_TIME_UP     =
'Partial type inference has been disabled for performance reasons.'
HOVER_WS_LOADING        =
'Workspace loading: {} / {}'
HOVER_AWAIT_TOOLTIP     =
'Calling async function, current thread may be yielded.'

ACTION_DISABLE_DIAG     =
'Disable diagnostics in the workspace ({}).'
ACTION_MARK_GLOBAL      =
'Mark `{}` as defined global.'
ACTION_REMOVE_SPACE     =
'Clear all postemptive spaces.'
ACTION_ADD_SEMICOLON    =
'Add `;` .'
ACTION_ADD_BRACKETS     =
'Add brackets.'
ACTION_RUNTIME_VERSION  =
'Change runtime version to {} .'
ACTION_OPEN_LIBRARY     =
'Load globals from {} .'
ACTION_ADD_DO_END       =
'Add `do ... end` .'
ACTION_FIX_LCOMMENT_END =
'Modify to the correct multi-line annotations closing symbol.'
ACTION_ADD_LCOMMENT_END =
'Close multi-line annotations.'
ACTION_FIX_C_LONG_COMMENT =
'Modify to Lua multi-line annotations format.'
ACTION_FIX_LSTRING_END  =
'Modify to the correct long string closing symbol.'
ACTION_ADD_LSTRING_END  =
'Close long string.'
ACTION_FIX_ASSIGN_AS_EQ =
'Modify to `=` .'
ACTION_FIX_EQ_AS_ASSIGN =
'Modify to `==` .'
ACTION_FIX_UEQ          =
'Modify to `~=` .'
ACTION_FIX_THEN_AS_DO   =
'Modify to `then` .'
ACTION_FIX_DO_AS_THEN   =
'Modify to `do` .'
ACTION_ADD_END          =
'Add `end` (infer the addition location ny indentations).'
ACTION_FIX_COMMENT_PREFIX =
'Modify to `--` .'
ACTION_FIX_NONSTANDARD_SYMBOL =
'Modify to `{symbol}` .'
ACTION_RUNTIME_UNICODE_NAME =
'Allow Unicode characters.'
ACTION_SWAP_PARAMS      =
'Change to parameter {index} of `{node}`'
ACTION_FIX_INSERT_SPACE =
'Insert space.'
ACTION_JSON_TO_LUA      =
'Convert JSON to Lua'
ACTION_DISABLE_DIAG_LINE=
'Disable diagnostics on this line ({}).'
ACTION_DISABLE_DIAG_FILE=
'Disable diagnostics in this file ({}).'
ACTION_MARK_ASYNC       =
'Mark current function as async.'

COMMAND_DISABLE_DIAG       =
'Disable diagnostics'
COMMAND_MARK_GLOBAL        =
'Mark defined global'
COMMAND_REMOVE_SPACE       =
'Clear all postemptive spaces'
COMMAND_ADD_BRACKETS       =
'Add brackets'
COMMAND_RUNTIME_VERSION    =
'Change runtime version'
COMMAND_OPEN_LIBRARY       =
'Load globals from 3rd library'
COMMAND_UNICODE_NAME       =
'Allow Unicode characters.'
COMMAND_JSON_TO_LUA        =
'Convert JSON to Lua'
COMMAND_JSON_TO_LUA_FAILED =
'Convert JSON to Lua failed: {}'

COMPLETION_IMPORT_FROM           =
'Import from {}'
COMPLETION_DISABLE_AUTO_REQUIRE  =
'Disable auto require'
COMPLETION_ASK_AUTO_REQUIRE      =
'Add the code at the top of the file to require this file?'

DEBUG_MEMORY_LEAK       =
"{} I'm sorry for the serious memory leak. The language service will be restarted soon."
DEBUG_RESTART_NOW       =
'Restart now'

WINDOW_COMPILING                 =
'Compiling'
WINDOW_DIAGNOSING                =
'Diagnosing'
WINDOW_INITIALIZING              =
'Initializing...'
WINDOW_PROCESSING_HOVER          =
'Processing hover...'
WINDOW_PROCESSING_DEFINITION     =
'Processing definition...'
WINDOW_PROCESSING_REFERENCE      =
'Processing reference...'
WINDOW_PROCESSING_RENAME         =
'Processing rename...'
WINDOW_PROCESSING_COMPLETION     =
'Processing completion...'
WINDOW_PROCESSING_SIGNATURE      =
'Processing signature help...'
WINDOW_PROCESSING_SYMBOL         =
'Processing file symbols...'
WINDOW_PROCESSING_WS_SYMBOL      =
'Processing workspace symbols...'
WINDOW_PROCESSING_SEMANTIC_FULL  =
'Processing full semantic tokens...'
WINDOW_PROCESSING_SEMANTIC_RANGE =
'Processing incremental semantic tokens...'
WINDOW_PROCESSING_HINT           =
'Processing inline hint...'
WINDOW_INCREASE_UPPER_LIMIT      =
'Increase upper limit'
WINDOW_CLOSE                     =
'Close'
WINDOW_SETTING_WS_DIAGNOSTIC     =
'You can delay or disable workspace diagnostics in settings'
WINDOW_DONT_SHOW_AGAIN           =
"Don't show again"
WINDOW_DELAY_WS_DIAGNOSTIC       =
'Idle time diagnosis (delay {} seconds)'
WINDOW_DISABLE_DIAGNOSTIC        =
'Disable workspace diagnostics'
WINDOW_LUA_STATUS_WORKSPACE      =
'Workspace   : {}'
WINDOW_LUA_STATUS_CACHED_FILES   =
'Cached files: {ast}/{max}'
WINDOW_LUA_STATUS_MEMORY_COUNT   =
'Memory usage: {mem:.f}M'
WINDOW_LUA_STATUS_TIP            =
[[

This icon is a cat,
Not a dog nor a fox!
             ↓↓↓
]]
WINDOW_LUA_STATUS_DIAGNOSIS_TITLE=
'Perform workspace diagnosis'
WINDOW_LUA_STATUS_DIAGNOSIS_MSG  =
'Do you want to perform workspace diagnosis?'
WINDOW_APPLY_SETTING             =
'Apply setting'
WINDOW_CHECK_SEMANTIC            =
'If you are using the color theme in the market, you may need to modify `editor.semanticHighlighting.enabled` to `true` to make semantic tokens take effect.'
WINDOW_TELEMETRY_HINT            =
'Please allow sending anonymous usage data and error reports to help us further improve this extension. Read our privacy policy [here](https://github.com/sumneko/lua-language-server/wiki/Privacy-Policy) .'
WINDOW_TELEMETRY_ENABLE          =
'Allow'
WINDOW_TELEMETRY_DISABLE         =
'Prohibit'
WINDOW_CLIENT_NOT_SUPPORT_CONFIG =
'Your client does not support modifying settings from the server side, please manually modify the following settings:'
WINDOW_LCONFIG_NOT_SUPPORT_CONFIG=
'Automatic modification of local settings is not currently supported, please manually modify the following settings:'
WINDOW_MANUAL_CONFIG_ADD         =
'`{key}`: add element `{value:q}` ;'
WINDOW_MANUAL_CONFIG_SET         =
'`{key}`: set to `{value:q}` ;'
WINDOW_MANUAL_CONFIG_PROP        =
'`{key}`: set the property `{prop}` to `{value:q}`;'
WINDOW_APPLY_WHIT_SETTING        =
'Apply and modify settings'
WINDOW_APPLY_WHITOUT_SETTING     =
'Apply but do not modify settings'
WINDOW_ASK_APPLY_LIBRARY         =
'Do you need to configure your work environment as `{}`?'
WINDOW_SEARCHING_IN_FILES        =
'Searching in files...'

CONFIG_LOAD_FAILED               =
'Unable to read the settings file: {}'
CONFIG_LOAD_ERROR                =
'Setting file loading error: {}'
CONFIG_TYPE_ERROR                =
'The setting file must be in lua or json format: {}'

PLUGIN_RUNTIME_ERROR             =
[[
An error occurred in the plugin, please report it to the plugin author.
Please check the details in the output or log.
Plugin path: {}
]]
PLUGIN_TRUST_LOAD                =
[[
The current settings try to load the plugin at this location:{}

Note that malicious plugin may harm your computer
]]
PLUGIN_TRUST_YES                 =
[[
Trust and load this plugin
]]
PLUGIN_TRUST_NO                  =
[[
Don't load this plugin
]]

CLI_CHECK_ERROR_TYPE =
'The argument of CHECK must be a string, but got {}'
CLI_CHECK_ERROR_URI =
'The argument of CHECK must be a valid uri, but got {}'
CLI_CHECK_ERROR_LEVEL =
'Checklevel must be one of: {}'
CLI_CHECK_INITING =
'Initializing ...'
CLI_CHECK_SUCCESS =
'Diagnosis completed, no problems found'
CLI_CHECK_RESULTS =
'Diagnosis complete, {} problems found, see {}'
