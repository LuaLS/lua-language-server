---@diagnostic disable: undefined-global

config.addonManager.enable        =
"Si el manejador de extensiones está habilitado."
config.addonManager.repositoryBranch =
"Especifica la rama de git usada por el manejador de extensiones."
config.addonManager.repositoryPath =
"Especifica la ruta git usada por el manejador de extensiones."

config.runtime.version            =
"Versión de Lua que se ejecuta."
config.runtime.path               =
[[
Cuando se ocupa un `require`, cómo se encuentra el archivo basado en el nombre de entrada.

Asignar esta configuración a `?/init.lua` significa que cuando se ingresa `require 'myfile'` se busca en `${workspace}/myfile/init.lua` desde los archivos cargados.
Si `runtime.pathStrict` es `false`, también se busca en `${workspace}/**/myfile/init.lua`.
Si se desea cargar archivos fuera del espacio de trabajo, se debe asignar `Lua.workspace.library` primero.
]]
config.runtime.pathStrict         =
'Cuando está habilitado, `runtime.path` sólo buscará en el primer nivel de directorios, vea la descripción de `runtime.path`.'
config.runtime.special            =
[[Las variables globales personalizadas son consideradas variables intrínsecas, y el servidor de lenguage proveerá un soporte especial.
El siguiente ejemplo muestra que 'include' es tratado como 'require'.
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```
]]
config.runtime.unicodeName        =
"Se permiten los caracteres unicode en los nombres."
config.runtime.nonstandardSymbol  =
"Soporte de símbolos no estándar. Asegúrese que la versión de Lua que se ejecuta soporte estos símbolos."
config.runtime.plugin             =
"Ruta de plugin. Revise [la wiki](https://luals.github.io/wiki/plugins) para más información."
config.runtime.pluginArgs         =
"Argumentos adicionals al plugin."
config.runtime.fileEncoding       =
"Codificación de archivo. La opción `ansi` solo está disponible en la plataforma `Windows`."
config.runtime.builtin            =
[[
Ajuste de la habilitación de biblioteca interna provista. Puede deshabilitar (o redefinir) las bibliotecas inexistentes de acuerdo al ambiente de ejecución.

* `default`: Indica que la biblioteca será habilitada o deshabilitada de acuerdo a la versión que se ejecuta.
* `enable`: Habilitada
* `disable`: Deshabilitada
]]
config.runtime.meta               =
'Formato del nombre del directoria de los archivos meta.'
config.diagnostics.enable         =
"Habilita los diagnósticos."
config.diagnostics.disable        =
"Deshabilita los diagnósticos (Usa código en corchetes bajo el cursor)."
config.diagnostics.globals        =
"Variables globales definidas."
config.diagnostics.globalsRegex   =
"Encuentra variables globales definidas usando esta expresión regular."
config.diagnostics.severity       =
[[
Modifica el la severirad de los diagnósticos.

Agregue `!` al final para descartar la configuración `diagnostics.groupSeverity`.
]]
config.diagnostics.neededFileStatus =
[[
* Opened:  Solo diagnostica los archivos abiertos
* Any:     diagnostica todos los archivos
* None:    deshabilita este diagnóstico

Agregue `!` al final para descartar la configuración `diagnostics.groupFileStatus`.
]]
config.diagnostics.groupSeverity  =
[[
Modifica el la severirad de los diagnósticos en un grupo.
`Fallback` significa que los diagnósticos en este grupo son controlados con una severida separada de `diagnostics.severity`.
Otras configuraciones descartan las configuraciones individuales que no terminen en `!`.
]]
config.diagnostics.groupFileStatus =
[[
Modifica los diagnósticos de archivos requeridos en un grupo.

* Opened:  solo diagnostica los archivos abiertos
* Any:     diagnostica todos los archivos
* None:    deshabilita este diagnóstico

`Fallback` significa que los diagnósticos en este grupo son controlados con una severida separada de `diagnostics.neededFileStatus`.
Otras configuraciones descartan las configuraciones individuales que no terminen en `!`.
]]
config.diagnostics.workspaceEvent =
"Fija el tiempo para lanzar los diagnósticos del espacio de trabajo."
config.diagnostics.workspaceEvent.OnChange =
"Lanza los diagnósticos del espacio de trabajo cuando se cambie el archivo."
config.diagnostics.workspaceEvent.OnSave =
"Lanza los diagnósticos del espacio de trabajo cuando se guarde el archivo."
config.diagnostics.workspaceEvent.None =
"Deshabilita los diagnósticos del espacio de trabajo."
config.diagnostics.workspaceDelay =
"Latencia en milisegundos para diagnósticos del espacio de trabajo."
config.diagnostics.workspaceRate  =
"Tasa porcentual de diagnósticos del espacio de trabajo. Decremente este valor para reducir el uso de CPU, también reduciendo la velocidad de los diagnósticos del espacio de trabajo. El diagnóstico del archivo que esté editando siempre se hace a toda velocidad y no es afectado por esta configuración."
config.diagnostics.libraryFiles   =
"Cómo diagnosticar los archivos cargados via `Lua.workspace.library`."
config.diagnostics.libraryFiles.Enable   =
"Estos archivos siempre se diagnostican."
config.diagnostics.libraryFiles.Opened   =
"Estos archivos se diagnostican solo cuando se abren."
config.diagnostics.libraryFiles.Disable  =
"Estos archivos no se diagnostican."
config.diagnostics.ignoredFiles   =
"Cómo diagnosticar los archivos ignorados."
config.diagnostics.ignoredFiles.Enable   =
"Estos archivos siempre se diagnostican."
config.diagnostics.ignoredFiles.Opened   =
"Estos archivos se diagnostican solo cuando se abren."
config.diagnostics.ignoredFiles.Disable  =
"Estos archivos no se diagnostican."
config.diagnostics.disableScheme  =
'Los archivos de Lua que siguen el siguiente esquema no se diagnostican.'
config.diagnostics.unusedLocalExclude =
'Las variables que calcen con el siguiente patrón no se diagnostican con `unused-local`.'
config.workspace.ignoreDir        =
"Directorios y archivos ignorados (se usa la misma gramática que en `.gitignore`)"
config.workspace.ignoreSubmodules =
"Ignora submódulos."
config.workspace.useGitIgnore     =
"Ignora los archivos enlistados en `gitignore` ."
config.workspace.maxPreload       =
"Máxima pre-carga de archivos."
config.workspace.preloadFileSize  =
"Cuando se pre-carga, se omiten los archivos más grandes que este valor (en KB)."
config.workspace.library          =
"Además de los del espacio de trabajo actual, se cargan archivos de estos directorios. Los archivos en estos directorios serán tratados como bibliotecas con código externo y algunas características (como renombrar campos) no modificarán estos archivos."
config.workspace.checkThirdParty  =
[[
Detección y adaptación automática de bibliotecas externas. Actualmente soportadas:

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]]
config.workspace.userThirdParty          =
'Rutas archivos de configuración para bibliotecas externas privadas. Revise [el archivo de configuración](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd) provisto.'
config.workspace.supportScheme           =
'El servidor de lenguage será provisto para los archivos de Lua del siguiente esquema.'
config.completion.enable                 =
'Habilita la completación.'
config.completion.callSnippet            =
'Muestra snippets para llamadas de funciones.'
config.completion.callSnippet.Disable    =
"Solo muestra `función nombre`."
config.completion.callSnippet.Both       =
"Muestra `función nombre` y `llamar al snippet`."
config.completion.callSnippet.Replace    =
"Solo muestra `llamar al snippet`."
config.completion.keywordSnippet         =
'Muestra snippets con sintaxis de palabras clave.'
config.completion.keywordSnippet.Disable =
"Solo muestra `palabra clave`."
config.completion.keywordSnippet.Both    =
"Muestra `palabra clave` y `snippet de sintaxis`."
config.completion.keywordSnippet.Replace =
"Solo muestra `snippet de sintaxis`."
config.completion.displayContext         =
"La prevista de la sugerencia del snippet de código relevante ayuda a entender el uso de la sugerenecia. El número fijado indica el número de líneas interceptadas en el fragmento de código. Fijando en `0` se deshabilita esta característica."
config.completion.workspaceWord          =
"Si es que el la palabra contextual presentada contiene contenido de otros archivos en el espacio de trabajo."
config.completion.showWord               =
"Muestra palabras contextuales en las sugerencias."
config.completion.showWord.Enable        =
"Siempre muestra palabras contextuales en las sugerencias."
config.completion.showWord.Fallback      =
"Las palabras contextuales solo se muestran si las sugerencias basadas en la semántica no están provistas."
config.completion.showWord.Disable       =
"Sin presentar las palabras contextuales."
config.completion.autoRequire            =
"Agrega automáticamente el `require` correspondiente cuando la entrada se parece a un nombre de archivo."
config.completion.showParams             =
"Muestra los parámetros en la lista de completado. Cuando la función tiene múltiples definiciones, se mostrarán por separado."
config.completion.requireSeparator       =
"Separador usado en `require`."
config.completion.postfix                =
"El símbolo usado para lanzar la sugerencia posfija."
config.color.mode                        =
"Modo de coloración."
config.color.mode.Semantic               =
"Coloración semántica. Puede ser necesario asignar `editor.semanticHighlighting.enabled` a `true` para que tenga efecto."
config.color.mode.SemanticEnhanced       =
"Coloración de semántica avanzada. Igual que `Semántica`, pero con análisis adicional que hace que se requira computación más cara."
config.color.mode.Grammar                =
"Coloración de la gramática."
config.semantic.enable                   =
"Habilita la coloración semántica. Puede ser necesario asignar `editor.semanticHighlighting.enabled`  a `true` para que tenga efecto."
config.semantic.variable                 =
"Coloración semántica de variables, campos y parámetros."
config.semantic.annotation               =
"Coloración de las anotaciones de tipo."
config.semantic.keyword                  =
"Coloración semántica de palabras clave, literales y operadores. Se necesita habilitar esta característica si su editor no puede hacer coloración sintáctica."
config.signatureHelp.enable              =
"Habilita la ayuda de firma."
config.hover.enable                      =
"Habilita la información bajo el cursor."
config.hover.viewString                  =
"Ubica el cursor bajo un string para ver su contenido (solo si el literal contiene un caracter de escape)."
config.hover.viewStringMax               =
"Largo máximo de la información bajo el cursor para ver el contenido de un string."
config.hover.viewNumber                  =
"Ubica el cursor para ver el contenido numérico (solo si el literal no es decimal)."
config.hover.fieldInfer                  =
"Cuando se ubica el cursor para ver una tabla, la inferencia de tipo se realizará para cada campo. Cuando el tiempo acumulado de la inferencia de tipo alcanza el valor fijado (en MS), la inferencia de tipo para los campos subsecuentes será omitida."
config.hover.previewFields               =
"Cuando se ubica el cursor para ver una tabla, fija el máximo numero de previstas para los campos."
config.hover.enumsLimit                  =
"Cuando el valor corresponde a múltiples tipos, fija el límite de tipos en despliegue."
config.hover.expandAlias                 =
[[
Expandir o no los alias. Por ejemplo, la expansión de `---@alias miTipo boolean|number` aparece como `boolean|number`, caso contrarior, aparece como `miTipo`.
]]
config.develop.enable                    =
'Modo de desarrollador. No debe habilitarlo, el rendimiento se verá afectado.'
config.develop.debuggerPort              =
'Puerto en que el depurador escucha.'
config.develop.debuggerWait              =
'Suspender después de que el depurador se conecte.'
config.intelliSense.searchDepth          =
'Fija la profundidad de búsqueda para IntelliSense. El incrementar este valor aumenta la precisión, pero empeora el rendimiento. Diferentes espacios de trabajo tienen diferente tolerancia para esta configuración. Ajústese al valor apropiado.'
config.intelliSense.fastGlobal           =
'En la completación de variable global, y entrada de suspensión de vista `_G`. Esto reduce levemente la precisión de la especulación de tipo, pero tiene una mejora de rendimiento notable para proyectos que ocupan harto las variables globales.'
config.window.statusBar                  =
'Muestra el estado de la extensión en la barra de estado.'
config.window.progressBar                =
'Muestra la barra de progreso en la barra de estado.'
config.hint.enable                       =
'Habilita pistas en línea.'
config.hint.paramType                    =
'Muestra las pistas de tipo al parámetro de las funciones.'
config.hint.setType                      =
'Muestra las pistas de tipo en las asignación.'
config.hint.paramName                    =
'Muestra las pistas de tipo en las llamadas a funciones.'
config.hint.paramName.All                =
'Se muestran odos los tipos de los parámetros.'
config.hint.paramName.Literal            =
'Se muestran solo los parámetros de tipos literales.'
config.hint.paramName.Disable            =
'Deshabilita las pistas de los parámetros.'
config.hint.arrayIndex                   =
'Muestra las pistas de los índices de arreglos cuando se construye una tabla.'
config.hint.arrayIndex.Enable            =
'Muestra las pistas en todas las tablas.'
config.hint.arrayIndex.Auto              =
'Muestra las pistas solo cuando la tabla tiene más de 3 ítemes, o cuando la tabla es mixta.'
config.hint.arrayIndex.Disable           =
'Deshabilita las pistas en de los índices de arreglos.'
config.hint.await                        =
'Si la función que se llama está marcada con `---@async`, pregunta por un `await` en la llamada.'
config.hint.semicolon                    = -- TODO: needs localisation
'Si no hay punto y coma al final de la sentencia, despliega un punto y coma virtual.'
config.hint.semicolon.All                = -- TODO: needs localisation
'Todas las sentencias con un punto y coma virtual desplegado.'
config.hint.semicolon.SameLine            = -- TODO: needs localisation
'Cuando dos sentencias están en la misma línea, despliega un punto y coma entre ellas.'
config.hint.semicolon.Disable            = -- TODO: needs localisation
'Deshabilita punto y coma virtuales.'
config.codeLens.enable                   = -- TODO: needs localisation
'Habilita el lente para código.'
config.format.enable                     = -- TODO: needs localisation
'Habilita el formateador de código.'
config.format.defaultConfig              = -- TODO: needs localisation
[[
La configuración de formateo predeterminada. Tiene menor prioridad que el archivo `.editorconfig`
en el espacio de trabajo.
Revise [la documentación del formateador](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)
para aprender más sobre su uso.
]]
config.spell.dict                        = -- TODO: needs localisation
'Palabras extra para el corrector ortográfico.'
config.nameStyle.config                  = -- TODO: needs localisation
'Configuración de estilo para nombres.'
config.telemetry.enable                  = -- TODO: needs localisation
[[
Habilita la telemetría para enviar información del editor y registros de errores por la red. Lea nuestra política de privacidad [aquí (en inglés)](https://luals.github.io/privacy#language-server).
]]
config.misc.parameters                   = -- TODO: needs localisation
'[Parámetros de la línea de comando](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) para iniciar el servidor de lenguage en VSCode.'
config.misc.executablePath               = -- TODO: needs localisation
'Especifica la ruta del ejecutable en VSCode.'
config.language.fixIndent                = -- TODO: needs localisation
'(Solo en VSCode) Arregla la auto-indentación incorrecta, como aquella cuando los quiebres de línea ocurren dentro de un string que contengan la palabra "function".'
config.language.completeAnnotation       = -- TODO: needs localisation
'(Solo en VSCode) Inserta automáticamente un "---@ " después de un quiebre de línea que sucede a una anotación.'
config.type.castNumberToInteger          = -- TODO: needs localisation
'Se permite asignar el tipo "número" al tipo "entero".'
config.type.weakUnionCheck               = -- TODO: needs localisation
[[
Una vez que un sub-tipo de un tipo de unión satisface la condición, el tipo de unión también satisface la condición.

Cuando esta configuración es `false`, el tipo `number|boolean` no puede ser asignado al tipo `number`. Solo se puede con `true`.
]]
config.type.weakNilCheck                 = -- TODO: needs localisation
[[
Cuando se revisa el tipo de un tipo de unión, los `nil` dentro son ignorados.

Cuando esta configuración es `false`, el tipo `number|nil` no puede ser asignado al tipo `number`. Solo se puede con `true`.
]]
config.type.inferParamType               = -- TODO: needs localisation
[[
Cuando un tipo de parámetro no está anotado, se infiere su tipo de los lugares donde la función es llamada.

Cuando esta configuración es `false`, el tipo del parámetro `any` cuando no puede ser anotado.
]]
config.type.checkTableShape              = -- TODO: needs localisation
[[
Chequea estrictamente la forma de la tabla.
]]
config.doc.privateName                   = -- TODO: needs localisation
'Trata los nombres específicos de campo como privados. Por ejemplo `m_*` significa `XXX.m_id` y `XXX.m_tipo` son privados, por lo que solo pueden ser accedidos donde se define la clase.'
config.doc.protectedName                 = -- TODO: needs localisation
'Trata los nombres específicos de campo como protegidos. Por ejemplo `m_*` significa `XXX.m_id` y `XXX.m_tipo` son privados, por lo que solo pueden ser accedidos donde se define la clase y sus subclases.'
config.doc.packageName                   = -- TODO: needs localisation
'Trata los nombres específicos de campo como del paquete. Por ejemplo `m_*` significa `XXX.m_id` y `XXX.m_tipo` son de paquete, por lo que solo pueden ser accedidos en el archivo donde son definidos.'
config.diagnostics['unused-local']          = -- TODO: needs localisation
'Habilita el diagnóstico de variables local sin uso.'
config.diagnostics['unused-function']       = -- TODO: needs localisation
'Habilita el diagnóstico funcines sin uso.'
config.diagnostics['undefined-global']      = -- TODO: needs localisation
'Habilita el diagnóstico de variables globales sin definir.'
config.diagnostics['global-in-nil-env']     = -- TODO: needs localisation
'Habilita el diagnóstico para la prohibición de uso de variables globales (`_ENV` se fija a `nil`).'
config.diagnostics['unused-label']          = -- TODO: needs localisation
'Habilita el diagnóstico de etiquetas sin uso.'
config.diagnostics['unused-vararg']         = -- TODO: needs localisation
'Habilita el diagnóstico de expresión de número variable de argumentos (vararg) sin uso.'
config.diagnostics['trailing-space']        = -- TODO: needs localisation
'Habilita el diagnóstico de espacios al final de línea.'
config.diagnostics['redefined-local']       = -- TODO: needs localisation
'Habilita el diagnóstico de variables locals redefinidas.'
config.diagnostics['newline-call']          = -- TODO: needs localisation
'Habilita el diagnóstico de llamadas en línea nueva. Se alza un error en las líneas que comienzan con `(`, lo que se lee sintácticamente como una llamada a la línea anterior.'
config.diagnostics['newfield-call']         = -- TODO: needs localisation
'Habilita el diagnóstico de campo nuevo en una llamada. Se alza un error cuando los paréntesis de una llamada a una función aparecen en la siguiente línea cuando se define un campo en una tabla.'
config.diagnostics['redundant-parameter']   = -- TODO: needs localisation
'Habilita el diagnóstico de parámetros redundantes de una función.'
config.diagnostics['ambiguity-1']           = -- TODO: needs localisation
'Habilita el diagnóstico de precedencia de operadores ambiguos. Por ejemplo, ante la expresión `num or 0 + 1` se sugerirrá `(num or 0) + 1`.'
config.diagnostics['lowercase-global']      = -- TODO: needs localisation
'Habilita el diagnóstico de definiciones de variables globacels con minúsculas.'
config.diagnostics['undefined-env-child']   = -- TODO: needs localisation
'Habilita el diagnóstico de variables de ambientes sin definir. Se alza un error cuando a la tabla `_ENV` se le asigna una tabla literal nueva, pero la variable global usada no está presente en el ambiente global.'
config.diagnostics['duplicate-index']       = -- TODO: needs localisation
'Habilita el diagnóstico de índices de tabla duplicados.'
config.diagnostics['empty-block']           = -- TODO: needs localisation
'Habilita el diagnóstico de bloques de código vacíos.'
config.diagnostics['redundant-value']       = -- TODO: needs localisation
'Habilita el diagnóstico de valores asignados redundantemente. Se alza un error en una asignación, cuando el número de valores es mayor que el número de objetos a los cuales se les asigna.'
config.diagnostics['assign-type-mismatch']  = -- TODO: needs localisation
'Enable diagnostics for assignments in which the value\'s type does not match the type of the assigned variable.'
'Habilita el diagnóstico .'
config.diagnostics['await-in-sync']         = -- TODO: needs localisation
'Enable diagnostics for calls of asynchronous functions within a synchronous function.'
'Habilita el diagnóstico .'
config.diagnostics['cast-local-type']    = -- TODO: needs localisation
'Enable diagnostics for casts of local variables where the target type does not match the defined type.'
'Habilita el diagnóstico .'
config.diagnostics['cast-type-mismatch']    = -- TODO: needs localisation
'Enable diagnostics for casts where the target type does not match the initial type.'
'Habilita el diagnóstico .'
config.diagnostics['circular-doc-class']    = -- TODO: needs localisation
'Enable diagnostics for two classes inheriting from each other introducing a circular relation.'
'Habilita el diagnóstico .'
config.diagnostics['close-non-object']      = -- TODO: needs localisation
'Enable diagnostics for attempts to close a variable with a non-object.'
'Habilita el diagnóstico .'
config.diagnostics['code-after-break']      = -- TODO: needs localisation
'Enable diagnostics for code placed after a break statement in a loop.'
'Habilita el diagnóstico .'
config.diagnostics['codestyle-check']       = -- TODO: needs localisation
'Enable diagnostics for incorrectly styled lines.'
'Habilita el diagnóstico .'
config.diagnostics['count-down-loop']       = -- TODO: needs localisation
'Enable diagnostics for `for` loops which will never reach their max/limit because the loop is incrementing instead of decrementing.'
'Habilita el diagnóstico .'
config.diagnostics['deprecated']            = -- TODO: needs localisation
'Enable diagnostics to highlight deprecated API.'
'Habilita el diagnóstico .'
config.diagnostics['different-requires']    = -- TODO: needs localisation
'Enable diagnostics for files which are required by two different paths.'
'Habilita el diagnóstico .'
config.diagnostics['discard-returns']       = -- TODO: needs localisation
'Enable diagnostics for calls of functions annotated with `---@nodiscard` where the return values are ignored.'
'Habilita el diagnóstico .'
config.diagnostics['doc-field-no-class']    = -- TODO: needs localisation
'Enable diagnostics to highlight a field annotation without a defining class annotation.'
'Habilita el diagnóstico .'
config.diagnostics['duplicate-doc-alias']   = -- TODO: needs localisation
'Enable diagnostics for a duplicated alias annotation name.'
'Habilita el diagnóstico .'
config.diagnostics['duplicate-doc-field']   = -- TODO: needs localisation
'Enable diagnostics for a duplicated field annotation name.'
'Habilita el diagnóstico .'
config.diagnostics['duplicate-doc-param']   = -- TODO: needs localisation
'Enable diagnostics for a duplicated param annotation name.'
'Habilita el diagnóstico .'
config.diagnostics['duplicate-set-field']   = -- TODO: needs localisation
'Enable diagnostics for setting the same field in a class more than once.'
'Habilita el diagnóstico .'
config.diagnostics['incomplete-signature-doc']    = -- TODO: needs localisation
'Incomplete @param or @return annotations for functions.'
'Habilita el diagnóstico .'
config.diagnostics['invisible']             = -- TODO: needs localisation
'Enable diagnostics for accesses to fields which are invisible.'
'Habilita el diagnóstico .'
config.diagnostics['missing-global-doc']    = -- TODO: needs localisation
'Missing annotations for globals! Global functions must have a comment and annotations for all parameters and return values.'
'Habilita el diagnóstico .'
config.diagnostics['missing-local-export-doc'] = -- TODO: needs localisation
'Missing annotations for exported locals! Exported local functions must have a comment and annotations for all parameters and return values.'
'Habilita el diagnóstico .'
config.diagnostics['missing-parameter']     = -- TODO: needs localisation
'Enable diagnostics for function calls where the number of arguments is less than the number of annotated function parameters.'
'Habilita el diagnóstico .'
config.diagnostics['missing-return']        = -- TODO: needs localisation
'Enable diagnostics for functions with return annotations which have no return statement.'
'Habilita el diagnóstico .'
config.diagnostics['missing-return-value']  = -- TODO: needs localisation
'Enable diagnostics for return statements without values although the containing function declares returns.'
'Habilita el diagnóstico .'
config.diagnostics['need-check-nil']        = -- TODO: needs localisation
'Enable diagnostics for variable usages if `nil` or an optional (potentially `nil`) value was assigned to the variable before.'
'Habilita el diagnóstico .'
config.diagnostics['no-unknown']            = -- TODO: needs localisation
'Enable diagnostics for cases in which the type cannot be inferred.'
'Habilita el diagnóstico .'
config.diagnostics['not-yieldable']         = -- TODO: needs localisation
'Enable diagnostics for calls to `coroutine.yield()` when it is not permitted.'
'Habilita el diagnóstico .'
config.diagnostics['param-type-mismatch']   = -- TODO: needs localisation
'Enable diagnostics for function calls where the type of a provided parameter does not match the type of the annotated function definition.'
config.diagnostics['redundant-return']      = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for return statements which are not needed because the function would exit on its own.'
config.diagnostics['redundant-return-value']= -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for return statements which return an extra value which is not specified by a return annotation.'
config.diagnostics['return-type-mismatch']  = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for return values whose type does not match the type declared in the corresponding return annotation.'
config.diagnostics['spell-check']           = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for typos in strings.'
config.diagnostics['name-style-check']      = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for name style.'
config.diagnostics['unbalanced-assignments']= -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics on multiple assignments if not all variables obtain a value (e.g., `local x,y = 1`).'
config.diagnostics['undefined-doc-class']   = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for class annotations in which an undefined class is referenced.'
config.diagnostics['undefined-doc-name']    = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for type annotations referencing an undefined type or alias.'
config.diagnostics['undefined-doc-param']   = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for cases in which a parameter annotation is given without declaring the parameter in the function definition.'
config.diagnostics['undefined-field']       = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for cases in which an undefined field of a variable is read.'
config.diagnostics['unknown-cast-variable'] = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for casts of undefined variables.'
config.diagnostics['unknown-diag-code']     = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics in cases in which an unknown diagnostics code is entered.'
config.diagnostics['unknown-operator']      = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for unknown operators.'
config.diagnostics['unreachable-code']      = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics for unreachable code.'
config.diagnostics['global-element']       = -- TODO: needs localisation
'Habilita el diagnóstico .'
'Enable diagnostics to warn about global elements.'
config.typeFormat.config                    = -- TODO: needs localisation
'Configures the formatting behavior while typing Lua code.'
config.typeFormat.config.auto_complete_end  = -- TODO: needs localisation
'Controls if `end` is automatically completed at suitable positions.'
config.typeFormat.config.auto_complete_table_sep = -- TODO: needs localisation
'Controls if a separator is automatically appended at the end of a table declaration.'
config.typeFormat.config.format_line        = -- TODO: needs localisation
'Controls if a line is formatted at all.'

command.exportDocument = -- TODO: needs localisation
'Lua: Export Document ...'
command.addon_manager.open = -- TODO: needs localisation
'Lua: Open Addon Manager ...'
command.reloadFFIMeta = -- TODO: needs localisation
'Lua: Reload luajit ffi meta'
command.startServer = -- TODO: needs localisation
'Lua: (debug) Start Language Server'
command.stopServer = -- TODO: needs localisation
'Lua: (debug) Stop Language Server'
