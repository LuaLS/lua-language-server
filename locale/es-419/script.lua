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
ACTION_FIX_C_LONG_COMMENT=
'Modifica al formato de anotaciones multi-línea de Lua.'
ACTION_FIX_LSTRING_END =
'Modifica al símbolo correcto de cierre de string largo.'
ACTION_ADD_LSTRING_END =
'Cierra string largo.'
ACTION_FIX_ASSIGN_AS_EQ=
'Modifica a `=` .'
ACTION_FIX_EQ_AS_ASSIGN=
'Modifica a `==` .'
ACTION_FIX_UEQ         =
'Modifica a `~=` .'
ACTION_FIX_THEN_AS_DO  =
'Modifica a `then` .'
ACTION_FIX_DO_AS_THEN  =
'Modifica a `do` .'
ACTION_ADD_END         =
'Agrega `end` (infiere la marca en base ala indentación).'
ACTION_FIX_COMMENT_PREFIX=
'Modifica a `--` .'
ACTION_FIX_NONSTANDARD_SYMBOL=
'Modifica a `{symbol}` .'
ACTION_RUNTIME_UNICODE_NAME=
'Permite el uso de caracteres Unicode.'
ACTION_SWAP_PARAMS     =
'Cambia al parámetro {index} de `{node}`'
ACTION_FIX_INSERT_SPACE=
'Inserte espacio.'
ACTION_JSON_TO_LUA     =
'Convierte JSON a Lua'
ACTION_DISABLE_DIAG_LINE=
'Deshabilita diagnósticos en esta línea ({}).'
ACTION_DISABLE_DIAG_FILE=
'Deshabilita diagnósticos en este archivo ({}).'
ACTION_MARK_ASYNC      =
'Marca la función actual como asíncrona.'
ACTION_ADD_DICT        =
'Agrega \'{}\' al diccionario de espacio de trabajo'
ACTION_FIX_ADD_PAREN   =
'Agrega paréntesis.'
ACTION_AUTOREQUIRE     =
"Importa '{}' como {}"

COMMAND_DISABLE_DIAG      =
'Deshabilita los diagnósticos'
COMMAND_MARK_GLOBAL       =
'Marca la variable como global definida'
COMMAND_REMOVE_SPACE      =
'Quita todos los espacios al final de línea.'
COMMAND_ADD_BRACKETS      =
'Agrega corchetes'
COMMAND_RUNTIME_VERSION   =
'Cambia la versión a ejecutar'
COMMAND_OPEN_LIBRARY      =
'Carga variables globales de una biblioteca externa'
COMMAND_UNICODE_NAME      =
'Permite el uso de caracteres Unicode.'
COMMAND_JSON_TO_LUA       =
'Convierte JSON a Lua'
COMMAND_JSON_TO_LUA_FAILED=
'Falló la conversión JSON a Lua: {}'
COMMAND_ADD_DICT          =
'Agrega la palabra al diccionario'
COMMAND_REFERENCE_COUNT   =
'{} referencias'

COMPLETION_IMPORT_FROM          =
'Importa de {}'
COMPLETION_DISABLE_AUTO_REQUIRE =
'Deshabilita auto require'
COMPLETION_ASK_AUTO_REQUIRE     =
'¿Desea agregar el código al inicio del archivo para hacer require a este archivo?'

DEBUG_MEMORY_LEAK      =
"{} Lamento la fuga de memoria. Pronto se reiniciará el servicio de lenguage."
DEBUG_RESTART_NOW      =
'Reinicia ahora'

WINDOW_COMPILING                =
'Compilando'
WINDOW_DIAGNOSING               =
'Diagnosticando'
WINDOW_INITIALIZING             =
'Inicializando...'
WINDOW_PROCESSING_HOVER         =
'Procesando ratón rondando...'
WINDOW_PROCESSING_DEFINITION    =
'Procesando definición...'
WINDOW_PROCESSING_REFERENCE     =
'Procesando referencia...'
WINDOW_PROCESSING_RENAME        =
'Procesando renombre...'
WINDOW_PROCESSING_COMPLETION    =
'Procesando completado...'
WINDOW_PROCESSING_SIGNATURE     =
'Procesando ayuda de firma...'
WINDOW_PROCESSING_SYMBOL        =
'Procesando símbolos de archivo...'
WINDOW_PROCESSING_WS_SYMBOL     =
'Procesando símbolos de espacio de trabajo...'
WINDOW_PROCESSING_SEMANTIC_FULL =
'Procesando tóquenes semánticos completos...'
WINDOW_PROCESSING_SEMANTIC_RANGE=
'Procesando tóquenes semánticos incrementales...'
WINDOW_PROCESSING_HINT          =
'Procesando pista en línea...'
WINDOW_PROCESSING_BUILD_META    =
'Procesando meta de construcción...'
WINDOW_INCREASE_UPPER_LIMIT     =
'Incrementa límite superior'
WINDOW_CLOSE                    =
'Cierra'
WINDOW_SETTING_WS_DIAGNOSTIC    =
'Puede desahibilitar los diagnósticos del espacio de trabajo o dejarlos para después en la configuración'
WINDOW_DONT_SHOW_AGAIN          =
'No lo muestres de nuevo'
WINDOW_DELAY_WS_DIAGNOSTIC      =
'Diagnósticos de tiempo ocioso (retardo de {} segundos)'
WINDOW_DISABLE_DIAGNOSTIC       =
'Deshabilita los diagnósticos del espacio de trabajo'
WINDOW_LUA_STATUS_WORKSPACE     =
'Espacio de trabajo  : {}'
WINDOW_LUA_STATUS_CACHED_FILES  =
'Archivos en caché: {ast}/{max}'
WINDOW_LUA_STATUS_MEMORY_COUNT  =
'Memoria en uso: {mem:.f}M'
WINDOW_LUA_STATUS_TIP           =
[[

Este ícono es un gato,
¡no es un perro o un zorro!
             ↓↓↓
]]
WINDOW_LUA_STATUS_DIAGNOSIS_TITLE=
'Realiza los diagnósticos del espacio de trabajo'
WINDOW_LUA_STATUS_DIAGNOSIS_MSG =
'¿Quiere realizar los diagnósticos del espacio de trabajo?'
WINDOW_APPLY_SETTING            =
'Aplica la configuración'
WINDOW_CHECK_SEMANTIC           =
'Puede ser que necesite modificar `editor.semanticHighlighting.enabled` a `true` si está usando el tema de colores del mercado para hacer que los tóquenes semánticos tengan efecto, '
WINDOW_TELEMETRY_HINT           =
'Por favor, permita el envío de datos de uso anónimos y de reportes de errores para ayudarnos a mejorar esta extensión. Lea nuestra política de privacidad [aquí (en inglés)](https://luals.github.io/privacy#language-server) .'
WINDOW_TELEMETRY_ENABLE         =
'Permitida'
WINDOW_TELEMETRY_DISABLE        =
'Prohibida'
WINDOW_CLIENT_NOT_SUPPORT_CONFIG=
'Su cliente no soporta la modificación de la configuación desde el servidor, por favor, modifique manualmente las siguientes configuraciones:'
WINDOW_LCONFIG_NOT_SUPPORT_CONFIG=
'La modificación automática de la configuración local no está soportada actualmente, por favor, modifique manualmente las siguientes configuraciones:'
WINDOW_MANUAL_CONFIG_ADD        =
'`{key}`: agregue el elemento `{value:q}` ;'
WINDOW_MANUAL_CONFIG_SET        =
'`{key}`: asignado a `{value:q}` ;'
WINDOW_MANUAL_CONFIG_PROP       =
'`{key}`: la propiedad `{prop}` asignada a `{value:q}`;'
WINDOW_APPLY_WHIT_SETTING       =
'Aplica y modifica la configuración'
WINDOW_APPLY_WHITOUT_SETTING    =
'Aplica pero sin modificar la configuración'
WINDOW_ASK_APPLY_LIBRARY        =
'¿Necesita configurar su ambiente de trabajo como `{}`?'
WINDOW_SEARCHING_IN_FILES       =
'Buscando en los archivos...'
WINDOW_CONFIG_LUA_DEPRECATED    =
'`config.lua` está obsoleto, por favor, use `config.json`.'
WINDOW_CONVERT_CONFIG_LUA       =
'Convierte a `config.json`'
WINDOW_MODIFY_REQUIRE_PATH      =
'¿Desea modificar la ruta para requerir módulos?'
WINDOW_MODIFY_REQUIRE_OK        =
'Modifica'

CONFIG_LOAD_FAILED              =
'No se pudo leer el archivo de configuración: {}'
CONFIG_LOAD_ERROR               =
'Error al cargar el archivo de configuración: {}'
CONFIG_TYPE_ERROR               =
'El el archivo de configuración debe estar o en formato lua o en formato json: {}'
CONFIG_MODIFY_FAIL_SYNTAX_ERROR =
'Falló la modificación de la configuración, hay errores de sintaxis en el archivo de configuración: {}'
CONFIG_MODIFY_FAIL_NO_WORKSPACE =
[[
Falló la modificación de la configuración:
* El modo actual es "solo un archivo", el servidor no puede crear `.luarc.json` sin un espacio de trabajo.
* El cliente de lenguage no soporta la modificación de la configuración desde el servidor.

Por favor, modifique manualmente las siguientes configuraciones:
{}
]]
CONFIG_MODIFY_FAIL              =
[[
Falló la modificación de la configuración:

Por favor, modifique manualmente las siguientes configuraciones:
{}
]]

PLUGIN_RUNTIME_ERROR            =
[[
Hubo un error en el plugin, por favor, repórtelo con la persona autora del plugin.
Por favor, revise los detalles en la salida o registros.
Ruta del plugin: {}
]]
PLUGIN_TRUST_LOAD               =
[[
La configuración actual intenta cargar el plugin ubicado aquí:{}

Tenga precaución con algún plugin malicioso que pueda dañar su computador
]]
PLUGIN_TRUST_YES                =
[[
Confía y carga este plugin
]]
PLUGIN_TRUST_NO                 =
[[
No cargues este plugin
]]

CLI_CHECK_ERROR_TYPE=
'El argumento de CHECK debe ser un string, pero se tiene {}'
CLI_CHECK_ERROR_URI=
'El argumento de CHECK debe ser una uri válida, pero se tiene {}'
CLI_CHECK_ERROR_LEVEL=
'El nivel de chequeo debe ser uno de: {}'
CLI_CHECK_INITING=
'Inicializando...'
CLI_CHECK_SUCCESS=
'Se completó el diagnóstico, no se encontraron problemas'
CLI_CHECK_PROGRESS=
'Se encontraron {} problema(s) en {} archivo(s)'
CLI_CHECK_RESULTS=
'Se completó el diagnóstico, se encontraron {} problema(s), vea {}'
CLI_CHECK_MULTIPLE_WORKERS=
'Iniciando {} tarea(s) de trabajo, se ha deshabitado la salida de progreso. Esto podría tomar unos minutos.'
CLI_DOC_INITING  =
'Cargando documentos ...'
CLI_DOC_DONE     =
[[
Documentación exportada:
]]
CLI_DOC_WORKING  =
'Construyendo la documentación...'

TYPE_ERROR_ENUM_GLOBAL_DISMATCH=
'El tipo `{child}` no calza con el tipo de enumeración `{parent}`'
TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED=
'No se puede usar el genérico `{child}` en enumeraciones'
TYPE_ERROR_ENUM_LITERAL_DISMATCH=
'El literal `{child}` no calza con el valor de enumeración `{parent}`'
TYPE_ERROR_ENUM_OBJECT_DISMATCH=
'El literal `{child}` no calza con el valor de enumeración `{parent}`. Deben ser el mismo objeto'
TYPE_ERROR_ENUM_NO_OBJECT=
'No se reconoce el valor de enumeración entregado `{child}`'
TYPE_ERROR_INTEGER_DISMATCH=
'El literal `{child}` no calza con el entero `{parent}`'
TYPE_ERROR_STRING_DISMATCH=
'El literal `{child}` no calza con el string `{parent}`'
TYPE_ERROR_BOOLEAN_DISMATCH=
'El literal `{child}` no calza con el booleano `{parent}`'
TYPE_ERROR_TABLE_NO_FIELD=
'El campo `{key}` no existe en la tabla'
TYPE_ERROR_TABLE_FIELD_DISMATCH=
'El tipo del campo `{key}` es `{child}`, que no calza con `{parent}`'
TYPE_ERROR_CHILD_ALL_DISMATCH=
'Todos los sub-tipos en `{child}` no calzan con  `{parent}`'
TYPE_ERROR_PARENT_ALL_DISMATCH=
'`{child}` no calza con ningún sub-tipo en `{parent}`'
TYPE_ERROR_UNION_DISMATCH=
'`{child}` no calza con `{parent}`'
TYPE_ERROR_OPTIONAL_DISMATCH=
'El tipo opcional no calza con `{parent}`'
TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER=
'El número `{child}` no puede ser convertido a un entero'
TYPE_ERROR_NUMBER_TYPE_TO_INTEGER=
"No se puede convertir un tipo 'número' a un tipo 'entero'"
TYPE_ERROR_DISMATCH=
'El tipo `{child}` no calza con `{parent}`'

LUADOC_DESC_CLASS=
[=[
Define una estructura de clase o tabla
## Sintaxis
`---@class <nombre> [: <madre>[, <madre>]...]`
## Uso
```
---@class Gerente: Persona, Humano
Gerente = {}
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#class)
]=]
LUADOC_DESC_TYPE=
[=[
Especifica el tipo de una cierta variable

Tipos predefinidos: `nil`, `any`, `boolean`, `string`, `number`, `integer`,
`function`, `table`, `thread`, `userdata`, `lightuserdata`

(Otros tipos pueden ser provistos usando `@alias`)

## Sintaxis
`---@type <tipo>[| [tipo]...`

## Uso
### En general
```
---@type nil|table|miClase
local Ejemplo = nil
```

### Arreglos
```
---@type number[]
local numsTelefonicos = {}
```

### Enumeraciones
```
---@type "red"|"green"|"blue"
local color = ""
```

### Tablas
```
---@type table<string, boolean>
local config = {
    desahibilitaRegistra = true,
    previeneElApagado = false,
}

---@type { [string]: true }
local x --x[""] es `true`
```

### Funciones
```
---@type fun(mode?: "r"|"w"): string
local miFun
```
---
[Revisar la Wiki](https://luals.github.io/wiki/annotations#type)
]=]
LUADOC_DESC_ALIAS=
[=[
Se pueden crear tipos propios que pueden ser usados con `@param`, `@type`, etc.

## Sintaxis
`---@alias <nombre> <tipo> [descripción]`\
or
```
---@alias <nombre>
---| 'valor' [# comentario]
---| 'valor2' [# comentario]
...
```

## Uso
### Expansión a otro tipo
```
---@alias rutaArchivo string ruta a un archivo

---@param ruta rutaArchivo Ruta al archivo para buscar
function encuentra(ruta, patron) end
```

### Enumeraciones
```
---@alias estilo-de-fuente
---| '"subrayado"' # Subraya el texto
---| '"negrita"' # Pon el texto en negrita
---| '"italica"' # Italiza el texto

---@param estilo estilo-de-fuente Estilo a aplicar
function asignaEstiloDeFuente(estilo) end
```

### Enumeraciones literales
```
local enumeraciones = {
    LECTURA = 0,
    ESCRITURA = 1,
    CERRADO = 2
}

---@alias EstadosDeArchivo
---| `enumeraciones.LECTURA`
---| `enumeraciones.ESCRITURA`
---| `enumeraciones.CERRADO`
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#alias)
]=]
LUADOC_DESC_PARAM=
[=[
Declaración de un parámetro de una función

## Sintaxis
`@param <nombre>[?] <tipo> [comentario]`

## Uso
### En general
```
---@param url string La url a requerir
---@param cabeceras? table<string, string> Cabeceras HTTP a enviar
---@param expiracion? number Tiempo de expiración en segundos
function get(url, cabeceras, expiracion) end
```

### Argumentos variables
```
---@param base string La base de la concatenación
---@param ... string Los valores a concatenar
function concat(base, ...) end
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#param)
]=]
LUADOC_DESC_RETURN=
[=[
Declaración de un valor de retorno

## Sintaxis
`@return <tipo> [nombre] [descripción]`\
or\
`@return <tipo> [# descripción]`

## Uso
### En general
```
---@return number
---@return number # Componente verde
---@return number b Componente azul
function hexToRGB(hex) end
```

### Solo tipos y nombres
```
---@return number x, number y
function getCoords() end
```

### Solo tipos
```
---@return string, string
function obtenPrimeroYUltimo() end
```

### Retorno de valores variables
```
---@return string ... Las etiquetas del ítem
function obtenEtiquetas(item) end
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#return)
]=]
LUADOC_DESC_FIELD=
[=[
Declaración de un campo en una clase o tabla. Esto permite proveer una
documentación con más detalles para una tabla. Desde `v3.6.0`, se puede
marcar un campo como privado (`private`), protegido (`protected`), público
(`public`) o en-paquete (`package`).

## Sintaxis
`---@field [alcance] <nombre> <tipo> [descripción]`

## Uso
```
---@class HTTP_RESPONSE
---@field status HTTP_STATUS
---@field headers table<string, string> Las cabeceras de la respuesta

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
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#field)
]=]
LUADOC_DESC_GENERIC=
[=[
Simulación de genéricos. Los genéricos permiten que los tipos puedan ser
reusados dado que ayudan a definir una "figura genérica" que puede ser
usada con otros tipos.

## Sintaxis
`---@generic <nombre> [:tipo_padre] [, <nombre> [:tipo_padre]]`

## Uso
### En general
```
---@generic T
---@param valor T El valor a retornar
---@return T valor Exactamente el mismo valor
function eco(valor)
    return valor
end

-- El tipo es string
s = eco("e")

-- El tipo es número (`number`)
n = eco(10)

-- El tipo es booleano (`boolean`)
b = eco(true)

-- Tenemos toda esta información con solo
-- usar @generic sin tener que especificar
-- manualmente cada tipo permitido
```

### Captura del nombre de un tipo genérico
### Capture name of generic type
```
---@class Foo
local Foo = {}
function Foo:Bar() end

---@generic T
---@param nombre `T` # aquí se captura el tipo de nombre genérico
---@return T       # se retorna el tipo genérico
function Generico(nombre) end

local v = Generico("Foo") -- v es un objeto de Foo
```

### Uso de genéricos en Lua
```
---@class table<K, V>: { [K]: V }

-- Esto es lo que nos permite crear una
-- tabla e intellisense hace seguimiento a
-- cualquier tipo al que le proveamos para la
-- clave (k) ó el valor
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations/#generic)
]=]
LUADOC_DESC_VARARG=
[=[
Usado principalmente para el soporte obsoleto de annotaciones de EmmyLua.
Proveer tipos o permitir descripciones no están soportados con `@vararg`

**Se debe usar `@param` cuando se documentan parámetros (sean variables o no).**

## Sintaxis
`@vararg <tipo>`

## Uso
```
---Concatena strings
---@vararg string
function concat(...) end
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations/#vararg)
]=]
LUADOC_DESC_OVERLOAD=
[=[
Permite definir firmas múltiples para una función.

## Sintaxis
`---@overload fun(<nombre>[: <tipo>] [, <nombre>[: <tipo>]]...)[: <tipo>[, <tipo>]...]`

## Uso
```
---@overload fun(t: table, value: any): number
function table.insert(t, position, value) end
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#overload)
]=]
LUADOC_DESC_DEPRECATED=
[=[
Marca una función como obsoleta. Como consecuencia, cualquier llamado a una
función obsoleta se ~~tarja~~

## Sintaxis
`---@deprecated`

---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#deprecated)
]=]
LUADOC_DESC_META=
[=[
Indica que este es un archivo meta y debe ser usado solo para definiciones e intellisense.

Hay tres distinciones principales que hay que notar con los archivos meta:
1. No hay intellisense basado en el contexto en un archivo meta
2. El colocar el cursor sobre una ruta de un `require` en un archivo meta muestra `[meta]` en vez de una ruta absolta
3. La función `Busca referencias` ignora los archivos meta

## Sintaxis
`---@meta`

---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#meta)
]=]
LUADOC_DESC_VERSION=
[=[
Especifica versiones de Lua en las que esta función se encuentra.

Versiones de Lua: `5.1`, `5.2`, `5.3`, `5.4`, `JIT`.

Se requiere la configuración `Diagnostics: Needed File Status`.

## Sintaxis
`---@version <version>[, <version>]...`

## Uso
### En general
```
---@version JIT
function onlyWorksInJIT() end
```
### Especificando múltiples versiones
```
---@version <5.2,JIT
function oldLuaOnly() end
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#version)
]=]
LUADOC_DESC_SEE=
[=[
Define algo que puede ser revisado para más información

## Sintaxis
`---@see <text>`

---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#see)
]=]
LUADOC_DESC_DIAGNOSTIC=
[=[
Habilita o deshabilita el diagnóstico para errores, advertencias, etc.

Acciones: deshabilita (`disable`), habilita (`enable`), deshabilita para esta línea (`disable-line`), deshabilita para la siguiente línea (`disable-next-line`)

[Nombres](https://github.com/LuaLS/lua-language-server/blob/cbb6e6224094c4eb874ea192c5f85a6cba099588/script/proto/define.lua#L54)

## Sintaxis
`---@diagnostic <acción>[: <nombre>]`

## Uso
### Deshabilita para la siguiente línea
```
---@diagnostic disable-next-line: undefined-global
```

### Cambio manual
```
---@diagnostic disable: unused-local
local sinUso = "hola mundo"
---@diagnostic enable: unused-local
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#diagnostic)
]=]
LUADOC_DESC_MODULE=
[=[
Provee la semántica para `require`.

## Sintaxis
`---@module <'nombre_módulo'>`

## Uso
```
---@module 'string.utils'
local stringUtils
-- Esto es funcionalmente equivalente a:
local mod = require('string.utils')
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#module)
]=]
LUADOC_DESC_ASYNC=
[=[
Marca una función como "asíncrona".

## Sintaxis
`---@async`

---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#async)
]=]
LUADOC_DESC_NODISCARD=
[=[
Previene que los valores retornados por esta función sean ignorados o descartados.
Esto alza la advertencia `discard-returns` si se ignoran los valores retornados.

## Sintaxis
`---@nodiscard`

---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#nodiscard)
]=]
LUADOC_DESC_CAST=
[=[
Se permite la conversión de tipo.

## Sintaxis
`@cast <variable> <[+|-]tipo>[, <[+|-]tipo>]...`

## Uso
### Sobreescritura del tipo
```
---@type integer
local x --> integer

---@cast x string
print(x) --> string
```
### Agregar un tipo
```
---@type string
local x --> string

---@cast x +boolean, +number
print(x) --> string|boolean|number
```
### Remover un tipo
```
---@type string|table
local x --> string|table

---@cast x -string
print(x) --> table
```
---
[Revisar en la Wiki](https://luals.github.io/wiki/annotations#cast)
]=]
LUADOC_DESC_OPERATOR=
[=[
Provee la declaración de tipo para [metamétodos de operador](http://lua-users.org/wiki/MetatableEvents).

## Sintaxis
`@operator <operación>[(tipo_de_entrada)]:<tipo_resultante>`

## Uso
### Metamétodo para suma de Vector
```
---@class Vector
---@operator add(Vector):Vector

vA = Vector.new(1, 2, 3)
vB = Vector.new(10, 20, 30)

vC = vA + vB
--> Vector
```
### Resta unaria
```
---@class Passcode
---@operator unm:integer

pA = Passcode.new(1234)
pB = -pA
--> integer
```
[View Request](https://github.com/LuaLS/lua-language-server/issues/599)
]=]
LUADOC_DESC_ENUM=
[=[
Marca una tabla como una enumeración. Revise [`@alias`](https://luals.github.io/wiki/annotations#alias)
si se desea una enumeración, pero no se puede definir como una tabla de Lua.
Mark a table as an enum. If you want an enum but can't define it as a Lua

## Sintaxis
`@enum <nombre>`

## Uso
```
---@enum colores
local colores = {
	blanco = 0,
	naranjo = 2,
	amarillo = 4,
	verde = 8,
	negro = 16,
}

---@param color colores
local function asignaColor(color) end

-- El completado y la información-bajo-el-cursor se provee para el siguiente parámetro
asignaColor(colores.verde)
```
]=]
LUADOC_DESC_SOURCE=
[=[
Provee una referencia a algún código fuente que vive en otro archivo.
Cuando se busque por la definición de un ítem, se ocupa su `@source`.

## Sintaxis
`@source <ruta>`

## Uso
```
---Se pueden ocupar rutas absolutas
---@source C:/Users/me/Documents/program/myFile.c
local a

---También URIs
---@source file:///C:/Users/me/Documents/program/myFile.c:10
local b

---También rutas relativas
---@source local/file.c
local c

---Se puede incluir los números de línea y caracter
---@source local/file.c:10:8
local d
```
]=]
LUADOC_DESC_PACKAGE=
[=[
Marca una función como privada del archivo en la que fue definida. Una función
empacada (en un cierto paquete) no puede ser accedida desde otro archivo

## Sintaxis
`@package`

## Uso
```
---@class Animal
---@field private ojos integer
local Animal = {}

---@package
---No se puede acceder desde otro archivo
function Animal:conteoDeOjos()
    return self.ojos
end
```
]=]
LUADOC_DESC_PRIVATE=
[=[
Marca una función como privada de una clase. Las funciones privadas pueden
ser accedidas solo dentro de su clase y no por clases hijas.

## Sintaxis
`@private`

## Uso
```
---@class Animal
---@field private ojos integer
local Animal = {}

---@private
function Animal:conteoDeOjos()
    return self.ojos
end

---@class Perro:Animal
local miPerro = {}

---esto no está permitido
myDog:conteoDeOjos();
```
]=]
LUADOC_DESC_PROTECTED=
[=[
Marca una función como protegida de una clase. Las funciones protegidas pueden
ser accedidas solo dentro de su clase o sus clases hijas.

## Sintaxis
`@protected`

## Uso
```
---@class Animal
---@field private ojos integer
local Animal = {}

---@protected
function Animal:conteoDeOjos()
    return self.ojos
end

---@class Perro:Animal
local miPerro = {}

---Permitido dado que la función es protegida y no privada.
myDog:conteoDeOjos();
```
]=]
