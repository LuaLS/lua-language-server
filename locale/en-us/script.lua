DIAG_LINE_ONLY_SPACE    =
'Line with spaces only.'
DIAG_LINE_POST_SPACE    =
'Line with trailing space.'
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
'This function expects a maximum of {:d} argument(s) but instead it is receiving {:d}.'
DIAG_MISS_ARGS          =
'This function requires {:d} argument(s) but instead it is receiving {:d}.'
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
DIAG_DUPLICATE_DOC_ALIAS              =
'Duplicate defined alias `{}`.'
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
DIAG_MISSING_GLOBAL_DOC_COMMENT       =
'Missing comment for global function `{}`.'
DIAG_MISSING_GLOBAL_DOC_PARAM         =
'Missing @param annotation for parameter `{}` in global function `{}`.'
DIAG_MISSING_GLOBAL_DOC_RETURN        =
'Missing @return annotation at index `{}` in global function `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_COMMENT  =
'Missing comment for exported local function `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_PARAM    =
'Missing @param annotation for parameter `{}` in exported local function `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_RETURN   =
'Missing @return annotation at index `{}` in exported local function `{}`.'
DIAG_INCOMPLETE_SIGNATURE_DOC_PARAM   =
'Incomplete signature. Missing @param annotation for parameter `{}`.'
DIAG_INCOMPLETE_SIGNATURE_DOC_RETURN  =
'Incomplete signature. Missing @return annotation at index `{}`.'
DIAG_UNKNOWN_DIAG_CODE                =
'Unknown diagnostic code `{}`.'
DIAG_CAST_LOCAL_TYPE                  =
'This variable is defined as type `{def}`. Cannot convert its type to `{ref}`.'
DIAG_CAST_FIELD_TYPE                  =
'This field is defined as type `{def}`. Cannot convert its type to `{ref}`.'
DIAG_ASSIGN_TYPE_MISMATCH             =
'Cannot assign `{ref}` to `{def}`.'
DIAG_PARAM_TYPE_MISMATCH              =
'Cannot assign `{ref}` to parameter `{def}`.'
DIAG_UNKNOWN_CAST_VARIABLE            =
'Unknown type conversion variable `{}`.'
DIAG_CAST_TYPE_MISMATCH               =
'Cannot convert `{def}` to `{ref}`。'
DIAG_MISSING_RETURN_VALUE             =
'Annotations specify that at least {min} return value(s) are required, found {rmax} returned here instead.'
DIAG_MISSING_RETURN_VALUE_RANGE       =
'Annotations specify that at least {min} return value(s) are required, found {rmin} to {rmax} returned here instead.'
DIAG_REDUNDANT_RETURN_VALUE           =
'Annotations specify that at most {max} return value(s) are required, found {rmax} returned here instead.'
DIAG_REDUNDANT_RETURN_VALUE_RANGE     =
'Annotations specify that at most {max} return value(s) are required, found {rmin} to {rmax} returned here instead.'
DIAG_MISSING_RETURN                   =
'Annotations specify that a return value is required here.'
DIAG_RETURN_TYPE_MISMATCH             =
'Annotations specify that return value #{index} has a type of `{def}`, returning value of type `{ref}` here instead.'
DIAG_UNKNOWN_OPERATOR                 =
'Unknown operator `{}`.'
DIAG_UNREACHABLE_CODE                 =
'Unreachable code.'
DIAG_INVISIBLE_PRIVATE                =
'Field `{field}` is private, it can only be accessed in class `{class}`.'
DIAG_INVISIBLE_PROTECTED              =
'Field `{field}` is protected, it can only be accessed in class `{class}` and its subclasses.'
DIAG_INVISIBLE_PACKAGE                =
'Field `{field}` can only be accessed in same file `{uri}`.'
DIAG_GLOBAL_ELEMENT                   =
'Element is global.'
DIAG_MISSING_FIELDS                   =
'Missing required fields in type `{1}`: {2}'
DIAG_INJECT_FIELD                     =
'Fields cannot be injected into the reference of `{class}` for `{field}`. {fix}'
DIAG_INJECT_FIELD_FIX_CLASS           =
'To do so, use `---@class` for `{node}`.'
DIAG_INJECT_FIELD_FIX_TABLE           =
'To allow injection, add `{fix}` to the definition.'

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
WORKSPACE_NOT_ALLOWED     =
'Your workspace is set to `{}`. Lua language server refused to load this directory. Please check your configuration.[learn more here](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)'
WORKSPACE_SCAN_TOO_MUCH   =
'More than {} files have been scanned. The current scanned directory is `{}`. Please see the [FAQ](https://luals.github.io/wiki/faq/#how-can-i-improve-startup-speeds) to see how you can include fewer files. It is also possible that your [configuration is incorrect](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder).'

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
PARSER_AMBIGUOUS_SYNTAX   =
'In Lua 5.1, the left brackets called by the function must be in the same line as the function.'
PARSER_NEED_PAREN         =
'Need to add a pair of parentheses.'
PARSER_NESTING_LONG_MARK  =
'Nesting of `[[...]]` is not allowed in Lua 5.1 .'
PARSER_LOCAL_LIMIT        =
'Only 200 active local variables and upvalues can be existed at the same time.'
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
ACTION_ADD_DICT         =
'Add \'{}\' to workspace dict'
ACTION_FIX_ADD_PAREN    =
'Add parentheses.'
ACTION_AUTOREQUIRE      =
"Import '{}' as {}"

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
COMMAND_ADD_DICT           =
'Add Word to dictionary'
COMMAND_REFERENCE_COUNT    =
'{} references'

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
WINDOW_PROCESSING_BUILD_META     =
'Processing build meta...'
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
'Please allow sending anonymous usage data and error reports to help us further improve this extension. Read our privacy policy [here](https://luals.github.io/privacy#language-server) .'
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
WINDOW_CONFIG_LUA_DEPRECATED     =
'`config.lua` is deprecated, please use `config.json` instead.'
WINDOW_CONVERT_CONFIG_LUA        =
'Convert to `config.json`'
WINDOW_MODIFY_REQUIRE_PATH       =
'Do you want to modify the require path?'
WINDOW_MODIFY_REQUIRE_OK         =
'Modify'

CONFIG_LOAD_FAILED               =
'Unable to read the settings file: {}'
CONFIG_LOAD_ERROR                =
'Setting file loading error: {}'
CONFIG_TYPE_ERROR                =
'The setting file must be in lua or json format: {}'
CONFIG_MODIFY_FAIL_SYNTAX_ERROR  =
'Failed to modify settings, there are syntax errors in the settings file: {}'
CONFIG_MODIFY_FAIL_NO_WORKSPACE  =
[[
Failed to modify settings:
* The current mode is single-file mode, server cannot create `.luarc.json` without workspace.
* The language client dose not support modifying settings from the server side.

Please modify following settings manually:
{}
]]
CONFIG_MODIFY_FAIL               =
[[
Failed to modify settings

Please modify following settings manually:
{}
]]

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
CLI_DOC_INITING   =
'Loading documents ...'
CLI_DOC_DONE      =
[[
Document exporting completed!
Raw data: {}
Markdown(example): {}
]]

TYPE_ERROR_ENUM_GLOBAL_DISMATCH =
'Type `{child}` cannot match enumeration type of `{parent}`'
TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED =
'Cannot use generic `{child}` in enumeration'
TYPE_ERROR_ENUM_LITERAL_DISMATCH =
'Literal `{child}` cannot match the enumeration value of `{parent}`'
TYPE_ERROR_ENUM_OBJECT_DISMATCH =
'The object `{child}` cannot match the enumeration value of `{parent}`. They must be the same object'
TYPE_ERROR_ENUM_NO_OBJECT =
'The passed in enumeration value `{child}` is not recognized'
TYPE_ERROR_INTEGER_DISMATCH =
'Literal `{child}` cannot match integer `{parent}`'
TYPE_ERROR_STRING_DISMATCH =
'Literal `{child}` cannot match string `{parent}`'
TYPE_ERROR_BOOLEAN_DISMATCH =
'Literal `{child}` cannot match boolean `{parent}`'
TYPE_ERROR_TABLE_NO_FIELD =
'Field `{key}` does not exist in the table'
TYPE_ERROR_TABLE_FIELD_DISMATCH =
'The type of field `{key}` is `{child}`, which cannot match `{parent}`'
TYPE_ERROR_CHILD_ALL_DISMATCH =
'All subtypes in `{child}` cannot match `{parent}`'
TYPE_ERROR_PARENT_ALL_DISMATCH =
'`{child}` cannot match any subtypes in `{parent}`'
TYPE_ERROR_UNION_DISMATCH =
'`{child}` cannot match `{parent}`'
TYPE_ERROR_OPTIONAL_DISMATCH =
'Optional type cannot match `{parent}`'
TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER =
'The number `{child}` cannot be converted to an integer'
TYPE_ERROR_NUMBER_TYPE_TO_INTEGER =
'Cannot convert number type to integer type'
TYPE_ERROR_DISMATCH =
'Type `{child}` cannot match `{parent}`'

LUADOC_DESC_CLASS =
[=[
Defines a class/table structure
## Syntax
`---@class <name> [: <parent>[, <parent>]...]`
## Usage
```
---@class Manager: Person, Human
Manager = {}
```
---
[View Wiki](https://luals.github.io/wiki/annotations#class)
]=]
LUADOC_DESC_TYPE =
[=[
Specify the type of a certain variable

Default types: `nil`, `any`, `boolean`, `string`, `number`, `integer`,
`function`, `table`, `thread`, `userdata`, `lightuserdata`

(Custom types can be provided using `@alias`)

## Syntax
`---@type <type>[| [type]...`

## Usage
### General
```
---@type nil|table|myClass
local Example = nil
```

### Arrays
```
---@type number[]
local phoneNumbers = {}
```

### Enums
```
---@type "red"|"green"|"blue"
local color = ""
```

### Tables
```
---@type table<string, boolean>
local settings = {
    disableLogging = true,
    preventShutdown = false,
}

---@type { [string]: true }
local x --x[""] is true
```

### Functions
```
---@type fun(mode?: "r"|"w"): string
local myFunction
```
---
[View Wiki](https://luals.github.io/wiki/annotations#type)
]=]
LUADOC_DESC_ALIAS =
[=[
Create your own custom type that can be used with `@param`, `@type`, etc.

## Syntax
`---@alias <name> <type> [description]`\
or
```
---@alias <name>
---| 'value' [# comment]
---| 'value2' [# comment]
...
```

## Usage
### Expand to other type
```
---@alias filepath string Path to a file

---@param path filepath Path to the file to search in
function find(path, pattern) end
```

### Enums
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
[View Wiki](https://luals.github.io/wiki/annotations#alias)
]=]
LUADOC_DESC_PARAM =
[=[
Declare a function parameter

## Syntax
`@param <name>[?] <type> [comment]`

## Usage
### General
```
---@param url string The url to request
---@param headers? table<string, string> HTTP headers to send
---@param timeout? number Timeout in seconds
function get(url, headers, timeout) end
```

### Variable Arguments
```
---@param base string The base to concat to
---@param ... string The values to concat
function concat(base, ...) end
```
---
[View Wiki](https://luals.github.io/wiki/annotations#param)
]=]
LUADOC_DESC_RETURN =
[=[
Declare a return value

## Syntax
`@return <type> [name] [description]`\
or\
`@return <type> [# description]`

## Usage
### General
```
---@return number
---@return number # The green component
---@return number b The blue component
function hexToRGB(hex) end
```

### Type & name only
```
---@return number x, number y
function getCoords() end
```

### Type only
```
---@return string, string
function getFirstLast() end
```

### Return variable values
```
---@return string ... The tags of the item
function getTags(item) end
```
---
[View Wiki](https://luals.github.io/wiki/annotations#return)
]=]
LUADOC_DESC_FIELD =
[=[
Declare a field in a class/table. This allows you to provide more in-depth
documentation for a table. As of `v3.6.0`, you can mark a field as `private`,
`protected`, `public`, or `package`.

## Syntax
`---@field [scope] <name> <type> [description]`

## Usage
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
[View Wiki](https://luals.github.io/wiki/annotations#field)
]=]
LUADOC_DESC_GENERIC =
[=[
Simulates generics. Generics can allow types to be re-used as they help define
a "generic shape" that can be used with different types.

## Syntax
`---@generic <name> [:parent_type] [, <name> [:parent_type]]`

## Usage
### General
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

### Capture name of generic type
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

### How Lua tables use generics
```
---@class table<K, V>: { [K]: V }

-- This is what allows us to create a table
-- and intellisense keeps track of any type
-- we give for key (K) or value (V)
```
---
[View Wiki](https://luals.github.io/wiki/annotations/#generic)
]=]
LUADOC_DESC_VARARG =
[=[
Primarily for legacy support for EmmyLua annotations. `@vararg` does not
provide typing or allow descriptions.

**You should instead use `@param` when documenting parameters (variable or not).**

## Syntax
`@vararg <type>`

## Usage
```
---Concat strings together
---@vararg string
function concat(...) end
```
---
[View Wiki](https://luals.github.io/wiki/annotations/#vararg)
]=]
LUADOC_DESC_OVERLOAD =
[=[
Allows defining of multiple function signatures.

## Syntax
`---@overload fun(<name>[: <type>] [, <name>[: <type>]]...)[: <type>[, <type>]...]`

## Usage
```
---@overload fun(t: table, value: any): number
function table.insert(t, position, value) end
```
---
[View Wiki](https://luals.github.io/wiki/annotations#overload)
]=]
LUADOC_DESC_DEPRECATED =
[=[
Marks a function as deprecated. This results in any deprecated function calls
being ~~struck through~~.

## Syntax
`---@deprecated`

---
[View Wiki](https://luals.github.io/wiki/annotations#deprecated)
]=]
LUADOC_DESC_META =
[=[
Indicates that this is a meta file and should be used for definitions and intellisense only.

There are 3 main distinctions to note with meta files:
1. There won't be any context-based intellisense in a meta file
2. Hovering a `require` filepath in a meta file shows `[meta]` instead of an absolute path
3. The `Find Reference` function will ignore meta files

## Syntax
`---@meta`

---
[View Wiki](https://luals.github.io/wiki/annotations#meta)
]=]
LUADOC_DESC_VERSION =
[=[
Specifies Lua versions that this function is exclusive to.

Lua versions: `5.1`, `5.2`, `5.3`, `5.4`, `JIT`.

Requires configuring the `Diagnostics: Needed File Status` setting.

## Syntax
`---@version <version>[, <version>]...`

## Usage
### General
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
[View Wiki](https://luals.github.io/wiki/annotations#version)
]=]
LUADOC_DESC_SEE =
[=[
Define something that can be viewed for more information

## Syntax
`---@see <text>`

---
[View Wiki](https://luals.github.io/wiki/annotations#see)
]=]
LUADOC_DESC_DIAGNOSTIC =
[=[
Enable/disable diagnostics for error/warnings/etc.

Actions: `disable`, `enable`, `disable-line`, `disable-next-line`

[Names](https://github.com/LuaLS/lua-language-server/blob/cbb6e6224094c4eb874ea192c5f85a6cba099588/script/proto/define.lua#L54)

## Syntax
`---@diagnostic <action>[: <name>]`

## Usage
### Disable next line
```
---@diagnostic disable-next-line: undefined-global
```

### Manually toggle
```
---@diagnostic disable: unused-local
local unused = "hello world"
---@diagnostic enable: unused-local
```
---
[View Wiki](https://luals.github.io/wiki/annotations#diagnostic)
]=]
LUADOC_DESC_MODULE =
[=[
Provides the semantics of `require`.

## Syntax
`---@module <'module_name'>`

## Usage
```
---@module 'string.utils'
local stringUtils
-- This is functionally the same as:
local module = require('string.utils')
```
---
[View Wiki](https://luals.github.io/wiki/annotations#module)
]=]
LUADOC_DESC_ASYNC =
[=[
Marks a function as asynchronous.

## Syntax
`---@async`

---
[View Wiki](https://luals.github.io/wiki/annotations#async)
]=]
LUADOC_DESC_NODISCARD =
[=[
Prevents this function's return values from being discarded/ignored.
This will raise the `discard-returns` warning should the return values
be ignored.

## Syntax
`---@nodiscard`

---
[View Wiki](https://luals.github.io/wiki/annotations#nodiscard)
]=]
LUADOC_DESC_CAST =
[=[
Allows type casting (type conversion).

## Syntax
`@cast <variable> <[+|-]type>[, <[+|-]type>]...`

## Usage
### Overwrite type
```
---@type integer
local x --> integer

---@cast x string
print(x) --> string
```
### Add Type
```
---@type string
local x --> string

---@cast x +boolean, +number
print(x) --> string|boolean|number
```
### Remove Type
```
---@type string|table
local x --> string|table

---@cast x -string
print(x) --> table
```
---
[View Wiki](https://luals.github.io/wiki/annotations#cast)
]=]
LUADOC_DESC_OPERATOR =
[=[
Provide type declaration for [operator metamethods](http://lua-users.org/wiki/MetatableEvents).

## Syntax
`@operator <operation>[(input_type)]:<resulting_type>`

## Usage
### Vector Add Metamethod
```
---@class Vector
---@operation add(Vector):Vector

vA = Vector.new(1, 2, 3)
vB = Vector.new(10, 20, 30)

vC = vA + vB
--> Vector
```
### Unary Minus
```
---@class Passcode
---@operation unm:integer

pA = Passcode.new(1234)
pB = -pA
--> integer
```
[View Request](https://github.com/LuaLS/lua-language-server/issues/599)
]=]
LUADOC_DESC_ENUM =
[=[
Mark a table as an enum. If you want an enum but can't define it as a Lua
table, take a look at the [`@alias`](https://luals.github.io/wiki/annotations#alias)
tag.

## Syntax
`@enum <name>`

## Usage
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
Provide a reference to some source code which lives in another file. When
searching for the definition of an item, its `@source` will be used.

## Syntax
`@source <path>`

## Usage
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
Mark a function as private to the file it is defined in. A packaged function
cannot be accessed from another file.

## Syntax
`@package`

## Usage
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
Mark a function as private to a @class. Private functions can be accessed only
from within their class and are not accessible from child classes.

## Syntax
`@private`

## Usage
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
Mark a function as protected within a @class. Protected functions can be
accessed only from within their class or from child classes.

## Syntax
`@protected`

## Usage
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
