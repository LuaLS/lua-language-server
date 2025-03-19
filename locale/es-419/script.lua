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
'¡El lector se cayó! Las últimas palabras fueron:{}'
PARSER_UNKNOWN          =
'Error desconocido de sintaxis...'
PARSER_MISS_NAME        =
'Se esperaba <name>.'
PARSER_UNKNOWN_SYMBOL   =
'Símbolo inesperado `{symbol}`.'
PARSER_MISS_SYMBOL      =
'Símbolo faltante `{symbol}`.'
PARSER_MISS_ESC_X       =
'Deberían ser 2 dígitos hexadecimales.'
PARSER_UTF8_SMALL       =
'Al menos 1 dígito hexadecimal.'
PARSER_UTF8_MAX         =
'Deberían ser entre {min} y {max}.'
PARSER_ERR_ESC          =
'Secuencia inválida de escape.'
PARSER_MUST_X16         =
'Deberían ser dígitos hexadecimales.'
PARSER_MISS_EXPONENT    =
'Faltan los dígitos para el exponente.'
PARSER_MISS_EXP         =
'Se esperaba <exp>.'
PARSER_MISS_FIELD       =
'Se esperaba <field>.'
PARSER_MISS_METHOD      =
'Se esperaba <method>.'
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
'Se esperaba <eof> después de `return`.'
PARSER_ACTION_AFTER_BREAK =
'Se esperaba <eof> después de `break`.'
PARSER_NO_VISIBLE_LABEL =
'No se ve la etiqueta `{label}` .'
PARSER_REDEFINE_LABEL   =
'La etiqueta `{label}` ya fue definida.'
PARSER_UNSUPPORT_SYMBOL =
'{version} no soporta esta gramática.'
PARSER_UNEXPECT_DOTS    =
'No se puede usar `...` fuera de una función de vararg.'
PARSER_UNEXPECT_SYMBOL  =
'Símbolo inesperado `{symbol}`.'
PARSER_UNKNOWN_TAG      =
'Atributo desconocido.'
PARSER_MULTI_TAG        =
'Los multi-atributos no están soportados.'
PARSER_UNEXPECT_LFUNC_NAME =
'La función local solo puede ser usar identificadores como nombre.'
PARSER_UNEXPECT_EFUNC_NAME =
'La función como expresión no puede ser nombrada.'
PARSER_ERR_LCOMMENT_END =
'Las anotaciones multi-línea deben ser cerradas por `{symbol}` .'
PARSER_ERR_C_LONG_COMMENT =
'En Lua debe usarse `--[[ ]]` para anotaciones multi-línea.'
PARSER_ERR_LSTRING_END  =
'Los strings largos se deben cerrar con `{symbol}` .'
PARSER_ERR_ASSIGN_AS_EQ =
'Se debe usar `=` para la asignación.'
PARSER_ERR_EQ_AS_ASSIGN =
'Se debe usar `==` para la igualdad.'
PARSER_ERR_UEQ          =
'Se debe usar `~=` para la no igualdad.'
PARSER_ERR_THEN_AS_DO   =
'Debería usar `then` .'
PARSER_ERR_DO_AS_THEN   =
'Debería usar `do` .'
PARSER_MISS_END         =
'Falta el `end` correspondiente.'
PARSER_ERR_COMMENT_PREFIX =
'En Lua se debe usar `--` para las anotaciones.'
PARSER_MISS_SEP_IN_TABLE =
'Falta el símbolo `,` ó `;` .'
PARSER_SET_CONST         =
'Asignación de valor a una variable constante.'
PARSER_UNICODE_NAME      =
'Contiene caracteres Unicode.'
PARSER_ERR_NONSTANDARD_SYMBOL =
'En Lua se debe usar `{symbol}` .'
PARSER_MISS_SPACE_BETWEEN =
'Se deben dejar espacios entre símbolos.'
PARSER_INDEX_IN_FUNC_NAME =
'La forma `[name]` no puede ser usada en el nombre de una función nombrada.'
PARSER_UNKNOWN_ATTRIBUTE  =
'El atributo local debe ser `const` ó `close`'
PARSER_AMBIGUOUS_SYNTAX   =
'En Lua 5.1, los corchetes izquierdos llamados por la función deben estar en la misma línea que la función.'
PARSER_NEED_PAREN         =
'Se necesita agregar un par de paréntesis.'
PARSER_NESTING_LONG_MARK  =
'La anidación de `[[...]]` no está permitida en Lua 5.1 .'
PARSER_LOCAL_LIMIT        =
'Solo 200 variables locales activas y valores anteriores pueden existir al mismo tiempo.'
PARSER_LUADOC_MISS_CLASS_NAME          =
'Se esperaba <class name>.'
PARSER_LUADOC_MISS_EXTENDS_SYMBOL      =
'Se esperaba `:`.'
PARSER_LUADOC_MISS_CLASS_EXTENDS_NAME  =
'Se esperaba <class extends name>.'
PARSER_LUADOC_MISS_SYMBOL              =
'Se esperaba `{symbol}`.'
PARSER_LUADOC_MISS_ARG_NAME            =
'Se esperaba <arg name>.'
PARSER_LUADOC_MISS_TYPE_NAME           =
'Se esperaba <type name>.'
PARSER_LUADOC_MISS_ALIAS_NAME          =
'Se esperaba <alias name>.'
PARSER_LUADOC_MISS_ALIAS_EXTENDS       =
'Se esperaba <alias extends>.'
PARSER_LUADOC_MISS_PARAM_NAME          =
'Se esperaba <param name>.'
PARSER_LUADOC_MISS_PARAM_EXTENDS       =
'Se esperaba <param extends>.'
PARSER_LUADOC_MISS_FIELD_NAME          =
'Se esperaba <field name>.'
PARSER_LUADOC_MISS_FIELD_EXTENDS       =
'Se esperaba <field extends>.'
PARSER_LUADOC_MISS_GENERIC_NAME        =
'Se esperaba <generic name>.'
PARSER_LUADOC_MISS_GENERIC_EXTENDS_NAME=
'Se esperaba <generic extends name>.'
PARSER_LUADOC_MISS_VARARG_TYPE         =
'Se esperaba <vararg type>.'
PARSER_LUADOC_MISS_FUN_AFTER_OVERLOAD  =
'Se esperaba `fun`.'
PARSER_LUADOC_MISS_CATE_NAME           =
'Se esperaba <doc name>.'
PARSER_LUADOC_MISS_DIAG_MODE           =
'Se esperaba <diagnostic mode>.'
PARSER_LUADOC_ERROR_DIAG_MODE          =
'<diagnostic mode> incorrect.'
PARSER_LUADOC_MISS_LOCAL_NAME          =
'Se esperaba <local name>.'

SYMBOL_ANONYMOUS       =
'<Anonymous>'

HOVER_VIEW_DOCUMENTS   =
'Ver documentos'
HOVER_DOCUMENT_LUA51   =
'http://www.lua.org/manual/5.1/manual.html#{}'
HOVER_DOCUMENT_LUA52   =
'http://www.lua.org/manual/5.2/manual.html#{}'
HOVER_DOCUMENT_LUA53   =
'http://www.lua.org/manual/5.3/manual.html#{}'
HOVER_DOCUMENT_LUA54   =
'http://www.lua.org/manual/5.4/manual.html#{}'
HOVER_DOCUMENT_LUAJIT  =
'http://www.lua.org/manual/5.1/manual.html#{}'
HOVER_NATIVE_DOCUMENT_LUA51    =
'command:extension.lua.doc?["en-us/51/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA52    =
'command:extension.lua.doc?["en-us/52/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA53    =
'command:extension.lua.doc?["en-us/53/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA54    =
'command:extension.lua.doc?["en-us/54/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUAJIT   =
'command:extension.lua.doc?["en-us/51/manual.html/{}"]'
HOVER_MULTI_PROTOTYPE     =
'({} prototipos)'
HOVER_STRING_BYTES        =
'{} bytes'
HOVER_STRING_CHARACTERS   =
'{} bytes, {} characters'
HOVER_MULTI_DEF_PROTO     =
'({} definiciones, {} prototipos)'
HOVER_MULTI_PROTO_NOT_FUNC=
'({} definiciones no-funcionales)'
HOVER_USE_LUA_PATH     =
'(Ruta de búsqueda: `{}`)'
HOVER_EXTENDS          =
'Se expande a {}'
HOVER_TABLE_TIME_UP    =
'Por temas de rendimiento se deshabilito la inferencia parcial de tipo.'
HOVER_WS_LOADING       =
'Cargando espacio de trabajo: {} / {}'
HOVER_AWAIT_TOOLTIP    =
'Llamando a la función asíncrona, la hebra actual podría ser suspendida.'

ACTION_DISABLE_DIAG    =
'Deshabilita los diagnósticos en el espacio de trabajo ({}).'
ACTION_MARK_GLOBAL     =
'Marca `{}` como global definida.'
ACTION_REMOVE_SPACE    =
'Quita todos los espacios al final de línea.'
ACTION_ADD_SEMICOLON   =
'Agrega `;` .'
ACTION_ADD_BRACKETS    =
'Agrega corchetes.'
ACTION_RUNTIME_VERSION =
'Cambia la versión a ejecutar a {} .'
ACTION_OPEN_LIBRARY    =
'Carga globales de {} .'
ACTION_ADD_DO_END      =
'Agrega `do ... end` .'
ACTION_FIX_LCOMMENT_END=
'Modifica al símbolo de cierre correcto para la anotación multi-línea.'
ACTION_ADD_LCOMMENT_END=
'Cierra las anotaciones multi-línea.'
ACTION_FIX_C_LONG_COMMENT= -- TODO: needs localisation
'Modify to Lua multi-line annotations format.'
ACTION_FIX_LSTRING_END = -- TODO: needs localisation
'Modify to the correct long string closing symbol.'
ACTION_ADD_LSTRING_END = -- TODO: needs localisation
'Close long string.'
ACTION_FIX_ASSIGN_AS_EQ= -- TODO: needs localisation
'Modify to `=` .'
ACTION_FIX_EQ_AS_ASSIGN= -- TODO: needs localisation
'Modify to `==` .'
ACTION_FIX_UEQ         = -- TODO: needs localisation
'Modify to `~=` .'
ACTION_FIX_THEN_AS_DO  = -- TODO: needs localisation
'Modify to `then` .'
ACTION_FIX_DO_AS_THEN  = -- TODO: needs localisation
'Modify to `do` .'
ACTION_ADD_END         = -- TODO: needs localisation
'Add `end` (infer the addition location ny indentations).'
ACTION_FIX_COMMENT_PREFIX= -- TODO: needs localisation
'Modify to `--` .'
ACTION_FIX_NONSTANDARD_SYMBOL= -- TODO: needs localisation
'Modify to `{symbol}` .'
ACTION_RUNTIME_UNICODE_NAME= -- TODO: needs localisation
'Allow Unicode characters.'
ACTION_SWAP_PARAMS     = -- TODO: needs localisation
'Change to parameter {index} of `{node}`'
ACTION_FIX_INSERT_SPACE= -- TODO: needs localisation
'Insert space.'
ACTION_JSON_TO_LUA     = -- TODO: needs localisation
'Convert JSON to Lua'
ACTION_DISABLE_DIAG_LINE=
'Disable diagnostics on this line ({}).'
ACTION_DISABLE_DIAG_FILE=
'Disable diagnostics in this file ({}).'
ACTION_MARK_ASYNC      = -- TODO: needs localisation
'Mark current function as async.'
ACTION_ADD_DICT        = -- TODO: needs localisation
'Add \'{}\' to workspace dict'
ACTION_FIX_ADD_PAREN   = -- TODO: needs localisation
'Add parentheses.'
ACTION_AUTOREQUIRE     = -- TODO: needs localisation
"Import '{}' as {}"

COMMAND_DISABLE_DIAG      = -- TODO: needs localisation
'Disable diagnostics'
COMMAND_MARK_GLOBAL       = -- TODO: needs localisation
'Mark defined global'
COMMAND_REMOVE_SPACE      = -- TODO: needs localisation
'Clear all postemptive spaces'
COMMAND_ADD_BRACKETS      = -- TODO: needs localisation
'Add brackets'
COMMAND_RUNTIME_VERSION   = -- TODO: needs localisation
'Change runtime version'
COMMAND_OPEN_LIBRARY      = -- TODO: needs localisation
'Load globals from 3rd library'
COMMAND_UNICODE_NAME      = -- TODO: needs localisation
'Allow Unicode characters.'
COMMAND_JSON_TO_LUA       = -- TODO: needs localisation
'Convert JSON to Lua'
COMMAND_JSON_TO_LUA_FAILED= -- TODO: needs localisation
'Convert JSON to Lua failed: {}'
COMMAND_ADD_DICT          = -- TODO: needs localisation
'Add Word to dictionary'
COMMAND_REFERENCE_COUNT   = -- TODO: needs localisation
'{} references'

COMPLETION_IMPORT_FROM          = -- TODO: needs localisation
'Import from {}'
COMPLETION_DISABLE_AUTO_REQUIRE = -- TODO: needs localisation
'Disable auto require'
COMPLETION_ASK_AUTO_REQUIRE     = -- TODO: needs localisation
'Add the code at the top of the file to require this file?'

DEBUG_MEMORY_LEAK      = -- TODO: needs localisation
"{} I'm sorry for the serious memory leak. The language service will be restarted soon."
DEBUG_RESTART_NOW      = -- TODO: needs localisation
'Restart now'

WINDOW_COMPILING                = -- TODO: needs localisation
'Compiling'
WINDOW_DIAGNOSING               = -- TODO: needs localisation
'Diagnosing'
WINDOW_INITIALIZING             = -- TODO: needs localisation
'Initializing...'
WINDOW_PROCESSING_HOVER         = -- TODO: needs localisation
'Processing hover...'
WINDOW_PROCESSING_DEFINITION    = -- TODO: needs localisation
'Processing definition...'
WINDOW_PROCESSING_REFERENCE     = -- TODO: needs localisation
'Processing reference...'
WINDOW_PROCESSING_RENAME        = -- TODO: needs localisation
'Processing rename...'
WINDOW_PROCESSING_COMPLETION    = -- TODO: needs localisation
'Processing completion...'
WINDOW_PROCESSING_SIGNATURE     = -- TODO: needs localisation
'Processing signature help...'
WINDOW_PROCESSING_SYMBOL        = -- TODO: needs localisation
'Processing file symbols...'
WINDOW_PROCESSING_WS_SYMBOL     = -- TODO: needs localisation
'Processing workspace symbols...'
WINDOW_PROCESSING_SEMANTIC_FULL = -- TODO: needs localisation
'Processing full semantic tokens...'
WINDOW_PROCESSING_SEMANTIC_RANGE= -- TODO: needs localisation
'Processing incremental semantic tokens...'
WINDOW_PROCESSING_HINT          = -- TODO: needs localisation
'Processing inline hint...'
WINDOW_PROCESSING_BUILD_META    = -- TODO: needs localisation
'Processing build meta...'
WINDOW_INCREASE_UPPER_LIMIT     = -- TODO: needs localisation
'Increase upper limit'
WINDOW_CLOSE                    = -- TODO: needs localisation
'Close'
WINDOW_SETTING_WS_DIAGNOSTIC    = -- TODO: needs localisation
'You can delay or disable workspace diagnostics in settings'
WINDOW_DONT_SHOW_AGAIN          = -- TODO: needs localisation
"Don't show again"
WINDOW_DELAY_WS_DIAGNOSTIC      = -- TODO: needs localisation
'Idle time diagnosis (delay {} seconds)'
WINDOW_DISABLE_DIAGNOSTIC       = -- TODO: needs localisation
'Disable workspace diagnostics'
WINDOW_LUA_STATUS_WORKSPACE     = -- TODO: needs localisation
'Workspace   : {}'
WINDOW_LUA_STATUS_CACHED_FILES  = -- TODO: needs localisation
'Cached files: {ast}/{max}'
WINDOW_LUA_STATUS_MEMORY_COUNT  = -- TODO: needs localisation
'Memory usage: {mem:.f}M'
WINDOW_LUA_STATUS_TIP           = -- TODO: needs localisation
[[

This icon is a cat,
Not a dog nor a fox!
             ↓↓↓
]]
WINDOW_LUA_STATUS_DIAGNOSIS_TITLE=
'Perform workspace diagnosis'
WINDOW_LUA_STATUS_DIAGNOSIS_MSG = -- TODO: needs localisation
'Do you want to perform workspace diagnosis?'
WINDOW_APPLY_SETTING            = -- TODO: needs localisation
'Apply setting'
WINDOW_CHECK_SEMANTIC           = -- TODO: needs localisation
'If you are using the color theme in the market, you may need to modify `editor.semanticHighlighting.enabled` to `true` to make semantic tokens take effect.'
WINDOW_TELEMETRY_HINT           = -- TODO: needs localisation
'Please allow sending anonymous usage data and error reports to help us further improve this extension. Read our privacy policy [here](https://luals.github.io/privacy#language-server) .'
WINDOW_TELEMETRY_ENABLE         = -- TODO: needs localisation
'Allow'
WINDOW_TELEMETRY_DISABLE        = -- TODO: needs localisation
'Prohibit'
WINDOW_CLIENT_NOT_SUPPORT_CONFIG= -- TODO: needs localisation
'Your client does not support modifying settings from the server side, please manually modify the following settings:'
WINDOW_LCONFIG_NOT_SUPPORT_CONFIG=
'Automatic modification of local settings is not currently supported, please manually modify the following settings:'
WINDOW_MANUAL_CONFIG_ADD        = -- TODO: needs localisation
'`{key}`: add element `{value:q}` ;'
WINDOW_MANUAL_CONFIG_SET        = -- TODO: needs localisation
'`{key}`: set to `{value:q}` ;'
WINDOW_MANUAL_CONFIG_PROP       = -- TODO: needs localisation
'`{key}`: set the property `{prop}` to `{value:q}`;'
WINDOW_APPLY_WHIT_SETTING       = -- TODO: needs localisation
'Apply and modify settings'
WINDOW_APPLY_WHITOUT_SETTING    = -- TODO: needs localisation
'Apply but do not modify settings'
WINDOW_ASK_APPLY_LIBRARY        = -- TODO: needs localisation
'Do you need to configure your work environment as `{}`?'
WINDOW_SEARCHING_IN_FILES       = -- TODO: needs localisation
'Searching in files...'
WINDOW_CONFIG_LUA_DEPRECATED    = -- TODO: needs localisation
'`config.lua` is deprecated, please use `config.json` instead.'
WINDOW_CONVERT_CONFIG_LUA       = -- TODO: needs localisation
'Convert to `config.json`'
WINDOW_MODIFY_REQUIRE_PATH      = -- TODO: needs localisation
'Do you want to modify the require path?'
WINDOW_MODIFY_REQUIRE_OK        = -- TODO: needs localisation
'Modify'

CONFIG_LOAD_FAILED              = -- TODO: needs localisation
'Unable to read the settings file: {}'
CONFIG_LOAD_ERROR               = -- TODO: needs localisation
'Setting file loading error: {}'
CONFIG_TYPE_ERROR               = -- TODO: needs localisation
'The setting file must be in lua or json format: {}'
CONFIG_MODIFY_FAIL_SYNTAX_ERROR = -- TODO: needs localisation
'Failed to modify settings, there are syntax errors in the settings file: {}'
CONFIG_MODIFY_FAIL_NO_WORKSPACE = -- TODO: needs localisation
[[
Failed to modify settings:
* The current mode is single-file mode, server cannot create `.luarc.json` without workspace.
* The language client dose not support modifying settings from the server side.

Please modify following settings manually:
{}
]]
CONFIG_MODIFY_FAIL              = -- TODO: needs localisation
[[
Failed to modify settings

Please modify following settings manually:
{}
]]

PLUGIN_RUNTIME_ERROR            = -- TODO: needs localisation
[[
An error occurred in the plugin, please report it to the plugin author.
Please check the details in the output or log.
Plugin path: {}
]]
PLUGIN_TRUST_LOAD               = -- TODO: needs localisation
[[
The current settings try to load the plugin at this location:{}

Note that malicious plugin may harm your computer
]]
PLUGIN_TRUST_YES                = -- TODO: needs localisation
[[
Trust and load this plugin
]]
PLUGIN_TRUST_NO                 = -- TODO: needs localisation
[[
Don't load this plugin
]]

CLI_CHECK_ERROR_TYPE= -- TODO: needs localisation
'The argument of CHECK must be a string, but got {}'
CLI_CHECK_ERROR_URI= -- TODO: needs localisation
'The argument of CHECK must be a valid uri, but got {}'
CLI_CHECK_ERROR_LEVEL= -- TODO: needs localisation
'Checklevel must be one of: {}'
CLI_CHECK_INITING= -- TODO: needs localisation
'Initializing ...'
CLI_CHECK_SUCCESS= -- TODO: needs localisation
'Diagnosis completed, no problems found'
CLI_CHECK_PROGRESS= -- TODO: needs localisation
'Found {} problems in {} files'
CLI_CHECK_RESULTS= -- TODO: needs localisation
'Diagnosis complete, {} problems found, see {}'
CLI_CHECK_MULTIPLE_WORKERS= -- TODO: needs localisation
'Starting {} worker tasks, progress output will be disabled. This may take a few minutes.'
CLI_DOC_INITING  = -- TODO: needs localisation
'Loading documents ...'
CLI_DOC_DONE     = -- TODO: needs localisation
[[
Documentation exported:
]]
CLI_DOC_WORKING  = -- TODO: needs localisation
'Building docs...'

TYPE_ERROR_ENUM_GLOBAL_DISMATCH= -- TODO: needs localisation
'Type `{child}` cannot match enumeration type of `{parent}`'
TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED= -- TODO: needs localisation
'Cannot use generic `{child}` in enumeration'
TYPE_ERROR_ENUM_LITERAL_DISMATCH= -- TODO: needs localisation
'Literal `{child}` cannot match the enumeration value of `{parent}`'
TYPE_ERROR_ENUM_OBJECT_DISMATCH= -- TODO: needs localisation
'The object `{child}` cannot match the enumeration value of `{parent}`. They must be the same object'
TYPE_ERROR_ENUM_NO_OBJECT= -- TODO: needs localisation
'The passed in enumeration value `{child}` is not recognized'
TYPE_ERROR_INTEGER_DISMATCH= -- TODO: needs localisation
'Literal `{child}` cannot match integer `{parent}`'
TYPE_ERROR_STRING_DISMATCH= -- TODO: needs localisation
'Literal `{child}` cannot match string `{parent}`'
TYPE_ERROR_BOOLEAN_DISMATCH= -- TODO: needs localisation
'Literal `{child}` cannot match boolean `{parent}`'
TYPE_ERROR_TABLE_NO_FIELD= -- TODO: needs localisation
'Field `{key}` does not exist in the table'
TYPE_ERROR_TABLE_FIELD_DISMATCH= -- TODO: needs localisation
'The type of field `{key}` is `{child}`, which cannot match `{parent}`'
TYPE_ERROR_CHILD_ALL_DISMATCH= -- TODO: needs localisation
'All subtypes in `{child}` cannot match `{parent}`'
TYPE_ERROR_PARENT_ALL_DISMATCH= -- TODO: needs localisation
'`{child}` cannot match any subtypes in `{parent}`'
TYPE_ERROR_UNION_DISMATCH= -- TODO: needs localisation
'`{child}` cannot match `{parent}`'
TYPE_ERROR_OPTIONAL_DISMATCH= -- TODO: needs localisation
'Optional type cannot match `{parent}`'
TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER= -- TODO: needs localisation
'The number `{child}` cannot be converted to an integer'
TYPE_ERROR_NUMBER_TYPE_TO_INTEGER= -- TODO: needs localisation
'Cannot convert number type to integer type'
TYPE_ERROR_DISMATCH= -- TODO: needs localisation
'Type `{child}` cannot match `{parent}`'

LUADOC_DESC_CLASS= -- TODO: needs localisation
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
LUADOC_DESC_TYPE= -- TODO: needs localisation
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
LUADOC_DESC_ALIAS= -- TODO: needs localisation
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
LUADOC_DESC_PARAM= -- TODO: needs localisation
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
LUADOC_DESC_RETURN= -- TODO: needs localisation
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
LUADOC_DESC_FIELD= -- TODO: needs localisation
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
LUADOC_DESC_GENERIC= -- TODO: needs localisation
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
LUADOC_DESC_VARARG= -- TODO: needs localisation
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
LUADOC_DESC_OVERLOAD= -- TODO: needs localisation
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
LUADOC_DESC_DEPRECATED= -- TODO: needs localisation
[=[
Marks a function as deprecated. This results in any deprecated function calls
being ~~struck through~~.

## Syntax
`---@deprecated`

---
[View Wiki](https://luals.github.io/wiki/annotations#deprecated)
]=]
LUADOC_DESC_META= -- TODO: needs localisation
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
LUADOC_DESC_VERSION= -- TODO: needs localisation
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
LUADOC_DESC_SEE= -- TODO: needs localisation
[=[
Define something that can be viewed for more information

## Syntax
`---@see <text>`

---
[View Wiki](https://luals.github.io/wiki/annotations#see)
]=]
LUADOC_DESC_DIAGNOSTIC= -- TODO: needs localisation
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
LUADOC_DESC_MODULE= -- TODO: needs localisation
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
LUADOC_DESC_ASYNC= -- TODO: needs localisation
[=[
Marks a function as asynchronous.

## Syntax
`---@async`

---
[View Wiki](https://luals.github.io/wiki/annotations#async)
]=]
LUADOC_DESC_NODISCARD= -- TODO: needs localisation
[=[
Prevents this function's return values from being discarded/ignored.
This will raise the `discard-returns` warning should the return values
be ignored.

## Syntax
`---@nodiscard`

---
[View Wiki](https://luals.github.io/wiki/annotations#nodiscard)
]=]
LUADOC_DESC_CAST= -- TODO: needs localisation
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
LUADOC_DESC_OPERATOR= -- TODO: needs localisation
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
LUADOC_DESC_ENUM= -- TODO: needs localisation
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
LUADOC_DESC_SOURCE= -- TODO: needs localisation
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
LUADOC_DESC_PACKAGE= -- TODO: needs localisation
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
LUADOC_DESC_PRIVATE= -- TODO: needs localisation
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
LUADOC_DESC_PROTECTED= -- TODO: needs localisation
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
