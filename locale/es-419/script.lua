DIAG_LINE_ONLY_SPACE    =
'Línea con solo espacios.'
DIAG_LINE_POST_SPACE    =
'Línea con espacio al final.'
DIAG_UNUSED_LOCAL       =
'Variable sin usar `{}`.'
DIAG_UNDEF_GLOBAL       =
'Variable global no definida `{}`.'
DIAG_UNDEF_FIELD        =
'Campo no definido `{}`.'
DIAG_UNDEF_ENV_CHILD    =
'Variable no definida `{}` (`_ENV` sobrecargado).'
DIAG_UNDEF_FENV_CHILD   =
'Variable no definida `{}` (dentro del módulo).'
DIAG_GLOBAL_IN_NIL_ENV  =
'Variable global inválida `{}` (`_ENV` es `nil`).'
DIAG_GLOBAL_IN_NIL_FENV =
'Variable global (módulo de ambiente es `nil`).'
DIAG_UNUSED_LABEL       =
'Etiqueta sin uso `{}`.'
DIAG_UNUSED_FUNCTION    =
'Funciones sin uso.'
DIAG_UNUSED_VARARG      =
'vararg sin uso.'
DIAG_REDEFINED_LOCAL    =
'Variable re-definida `{}`.'
DIAG_DUPLICATE_INDEX    =
'Índice duplicado `{}`.'
DIAG_DUPLICATE_METHOD   =
'Método duplicado `{}`.'
DIAG_PREVIOUS_CALL      =
'Se intrepretará como `{}{}`. Podría ser necesario agregar una `.`.'
DIAG_PREFIELD_CALL      =
'Se intrepretará como `{}{}`. Podría ser necesario agregar una `.` ó `;`.'
DIAG_OVER_MAX_ARGS      =
'Esta función espera un máximo de {:d} argumento(s), pero está recibiendo {:d}.'
DIAG_MISS_ARGS          =
'Esta función requiere {:d} argumento(s), pero está recibiendo {:d}.'
DIAG_OVER_MAX_VALUES    =
'Solo tiene {} variables, pero se están asignando {} valores.'
DIAG_AMBIGUITY_1        =
'Se calcula `{}` primero. Agregar corchetes podría ser necesario.'
DIAG_LOWERCASE_GLOBAL   =
'Variable global con inicial minúscula, ¿olvidó agregar `local` o está mal escrita?'
DIAG_EMPTY_BLOCK        =
'Bloque vacío.'
DIAG_DIAGNOSTICS        =
'Diagnósticos de Lua.'
DIAG_SYNTAX_CHECK       =
'Chequeo sintáctico de Lua.'
DIAG_NEED_VERSION       =
'Soportado en {}, actualmente usando {}.'
DIAG_DEFINED_VERSION    =
'Definido en {}, actualmente usando {}.'
DIAG_DEFINED_CUSTOM     =
'Definido en {}.'
DIAG_DUPLICATE_CLASS    =
'La Clase `{}` está duplicada.'
DIAG_UNDEFINED_CLASS    =
'La Clase `{}` no está definida.'
DIAG_CYCLIC_EXTENDS     =
'Extensiones cíclicas'
DIAG_INEXISTENT_PARAM   =
'Parametro inexistente.'
DIAG_DUPLICATE_PARAM    =
'Parametro duplicado.'
DIAG_NEED_CLASS         =
'La clase debe ser definida primero.'
DIAG_DUPLICATE_SET_FIELD=
'Campo duplicado `{}`.'
DIAG_SET_CONST          =
'Asignación de valor a una variable constante.'
DIAG_SET_FOR_STATE      =
'Asignación de valor a una variable de bucle.'
DIAG_CODE_AFTER_BREAK   =
'Código después de `break` nunca se ejecuta.'
DIAG_UNBALANCED_ASSIGNMENTS =
'El valor que se asigna es `nil` debido a que el número de valores no es suficiente. En Lua, `x, y = 1 ` es equivalente a `x, y = 1, nil` .'
DIAG_REQUIRE_LIKE       =
'Puede tratar `{}` como `require` por configuración.'
DIAG_COSE_NON_OBJECT    =
'No se puede cerrar un valor de este tipo. (A menos que se asigne el método meta `__close`)'
DIAG_COUNT_DOWN_LOOP    =
'Quizo decir `{}` ?'
DIAG_UNKNOWN            =
'No se puede inferir el tipo.'
DIAG_DEPRECATED         =
'Obsoleto.'
DIAG_DIFFERENT_REQUIRES =
'Al mismo archivo se le requiere con `require` con distintos nombres.'
DIAG_REDUNDANT_RETURN   =
'Retorno redundante.'
DIAG_AWAIT_IN_SYNC      =
'Una función asíncrona solo puede ser llamada en una función asíncrona.'
DIAG_NOT_YIELDABLE      =
'El parámetro {}-ésimo de esta función no fue marcado como suspendible para ceder el control (`yield`), en vez, una función asíncrona fue provista. (Use `---@param nombre async fun()` para marcarlo como suspendible)'
DIAG_DISCARD_RETURNS    =
'No se pueden descartar los valores retornados por esta función.'
DIAG_NEED_CHECK_NIL     =
'Un chequeo de nil es necesario.'
DIAG_CIRCLE_DOC_CLASS                 =
'Clases con herencia circular.'
DIAG_DOC_FIELD_NO_CLASS               =
'El campo debe estar definido después que la clase.'
DIAG_DUPLICATE_DOC_ALIAS              =
'Alias `{}` fue definido múltiples veces.'
DIAG_DUPLICATE_DOC_FIELD              =
'Campos definidos múltiples veces `{}`.'
DIAG_DUPLICATE_DOC_PARAM              =
'Parámetros duplicados `{}`.'
DIAG_UNDEFINED_DOC_CLASS              =
'Clase no definida `{}`.'
DIAG_UNDEFINED_DOC_NAME               =
'Tipo o alias no definido `{}`.'
DIAG_UNDEFINED_DOC_PARAM              =
'Parámetro no definido `{}`.'
DIAG_MISSING_GLOBAL_DOC_COMMENT       =
'Falta un comentario para la función global `{}`.'
DIAG_MISSING_GLOBAL_DOC_PARAM         =
'Falta una anotación @param para el parámetro `{}` en la función global `{}`.'
DIAG_MISSING_GLOBAL_DOC_RETURN        =
'Falta una anotación @return para el índice `{}` en la función global `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_COMMENT  =
'Falta un un comentario para la función local exportada `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_PARAM    =
'Falta una anotación @param para el parámetro `{}` en la función local `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_RETURN   =
'Falta una anotación @return para el índice `{}` en la función local `{}`.'
DIAG_INCOMPLETE_SIGNATURE_DOC_PARAM   =
'Firma incompleta. Falta una anotación @param para el parámetro `{}`.'
DIAG_INCOMPLETE_SIGNATURE_DOC_RETURN  =
'Firma incompleta. Falta una anotación @return para el índice `{}`.'
DIAG_UNKNOWN_DIAG_CODE                =
'Código de diagnóstico desconocido `{}`.'
DIAG_CAST_LOCAL_TYPE                  =
'Esta variable fue definida como tipo `{def}`. No se puede convertir su tipo a `{ref}`.'
DIAG_CAST_FIELD_TYPE                  =
'Este campo fue definido como tipo `{def}`. No se puede convertir su tipo a `{ref}`.'
DIAG_ASSIGN_TYPE_MISMATCH             =
'No se puede asignar `{ref}` a `{def}`'
DIAG_PARAM_TYPE_MISMATCH              =
'Cannot assign `{ref}` to parameter `{def}`.'
DIAG_UNKNOWN_CAST_VARIABLE            =
'Variable de conversión de tipo desconocida `{}`.'
DIAG_CAST_TYPE_MISMATCH               =
'No se puede convertir `{ref}` a `{def}`。'
DIAG_MISSING_RETURN_VALUE             =
'Las anotaciones especifican que se requieren al menos {min} valor(es) de retorno, en cambio, se encontró que se retornaron {rmax}.'
DIAG_MISSING_RETURN_VALUE_RANGE       =
'Las anotaciones especifican que se requieren al menos {min} valor(es), en cambio, se encontró que se retornaron entre {rmin} y {rmax}.'
DIAG_REDUNDANT_RETURN_VALUE           =
'Las anotaciones especifican que se retornan a lo más {max} valor(es), en cambio, se encontró que se retornaron {rmax}.'
DIAG_REDUNDANT_RETURN_VALUE_RANGE     =
'Las anotaciones especifican que se retornan a lo más {max} valor(es), en cambio, se encontró que se retornaron entre {rmin} y {rmax}.'
DIAG_MISSING_RETURN                   =
'Las anotaciones especifican que se requiere un valor de retorno aquí.'
DIAG_RETURN_TYPE_MISMATCH             =
'Las anotaciones especifican que el valor de retorno #{index} tiene `{def}` como tipo, en cambio, se está retornando un valor de tipo `{ref}`.'
DIAG_UNKNOWN_OPERATOR                 =
'Operación desconocida `{}`.'
DIAG_UNREACHABLE_CODE                 =
'Este código nunca es ejecutado.'
DIAG_INVISIBLE_PRIVATE                =
'El campo `{field}` es privado, solo puede ser accedido desde la clase `{class}`.'
DIAG_INVISIBLE_PROTECTED              =
'El campo `{field}` es protegido, solo puede ser accedido desde la clase `{class}` y sus sub-clases.'
DIAG_INVISIBLE_PACKAGE                =
'Al campo `{field}` solo se le puede acceder dentro del mismo archivo `{uri}`.'
DIAG_GLOBAL_ELEMENT                   =
'El elemento es global.'
DIAG_MISSING_FIELDS                   =
'Faltan los campos requeridos en el tipo `{1}`: {2}'
DIAG_INJECT_FIELD                     =
'Los campos no pueden ser inyectados a la referencia de `{class}` para `{field}`. {fix}'
DIAG_INJECT_FIELD_FIX_CLASS           =
'Para que sea así, use `---@class` para `{node}`.'
DIAG_INJECT_FIELD_FIX_TABLE           =
'Para permitir la inyección, agregue `{fix}` a la definición.'

MWS_NOT_SUPPORT         =
'{} no soporta múltiples espacios de trabajo por ahora, podría ser necesario que me reinicie para soportar el nuevo espacio de trabajo ...'
MWS_RESTART             =
'Reiniciar'
MWS_NOT_COMPLETE        =
'El espacio de trabajo aún no está completo. Puede intentarlo más tarde...'
MWS_COMPLETE            =
'El espacio de trabajo está completado. Puede intentarlo de nuevo...'
MWS_MAX_PRELOAD         =
'El número de archivos pre-cargados ha llegado al límite ({}), es necesario abrir manualmente los archivos que necesiten ser cargados.'
MWS_UCONFIG_FAILED      =
'El guardado de la configuración de usuario falló.'
MWS_UCONFIG_UPDATED     =
'La configuración de usuario fue actualizada.'
MWS_WCONFIG_UPDATED     =
'El espacio de trabajo fue actualizado.'

WORKSPACE_SKIP_LARGE_FILE =
'Archivo es muy grande: {} fue omitido. El límite de tamaño actual es: {} KB, y el tamaño de archivo es: {} KB.'
WORKSPACE_LOADING         =
'Cargando el espacio de trabajo.'
WORKSPACE_DIAGNOSTIC      =
'Diagnosticando el espacio de trabajo'
WORKSPACE_SKIP_HUGE_FILE  =
'Por temas de rendimiento se detuvo la lectura de este archivo: {}'
WORKSPACE_NOT_ALLOWED     =
'Su espacio de trabajo está asignado a `{}`. El servidor de lenguage de Lua se rehusó a cargar este directorio. Por favor, revise se configuración. [más info acá (en inglés)](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)'
WORKSPACE_SCAN_TOO_MUCH   =
'Se revisaron más de {} archivos. El directorio actual de revisión es `{}`. Por favor, revise [estas preguntas y respuestas frecuentes (en inglés)](https://luals.github.io/wiki/faq/#how-can-i-improve-startup-speeds) para ver cómo se podrían incluir menos archivos. También es posible que su [configuración esté incorrecta (en inglés)](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder).'

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
CLI_CHECK_PROGRESS =
'Found {} problems in {} files'
CLI_CHECK_RESULTS =
'Diagnosis complete, {} problems found, see {}'
CLI_CHECK_MULTIPLE_WORKERS =
'Starting {} worker tasks, progress output will be disabled. This may take a few minutes.'
CLI_DOC_INITING   =
'Loading documents ...'
CLI_DOC_DONE      =
[[
Documentation exported:
]]
CLI_DOC_WORKING   =
'Building docs...'

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
---@operator add(Vector):Vector

vA = Vector.new(1, 2, 3)
vB = Vector.new(10, 20, 30)

vC = vA + vB
--> Vector
```
### Unary Minus
```
---@class Passcode
---@operator unm:integer

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
