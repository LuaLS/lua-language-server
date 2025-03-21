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
'If the called function is marked `---@async`, prompt `await` at the call.'
config.hint.semicolon                    = -- TODO: needs localisation
'If there is no semicolon at the end of the statement, display a virtual semicolon.'
config.hint.semicolon.All                = -- TODO: needs localisation
'All statements display virtual semicolons.'
config.hint.semicolon.SameLine            = -- TODO: needs localisation
'When two statements are on the same line, display a semicolon between them.'
config.hint.semicolon.Disable            = -- TODO: needs localisation
'Disable virtual semicolons.'
config.codeLens.enable                   = -- TODO: needs localisation
'Enable code lens.'
config.format.enable                     = -- TODO: needs localisation
'Enable code formatter.'
config.format.defaultConfig              = -- TODO: needs localisation
[[
The default format configuration. Has a lower priority than `.editorconfig` file in the workspace.
Read [formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) to learn usage.
]]
config.spell.dict                        = -- TODO: needs localisation
'Custom words for spell checking.'
config.nameStyle.config                  = -- TODO: needs localisation
'Set name style config'
config.telemetry.enable                  = -- TODO: needs localisation
[[
Enable telemetry to send your editor information and error logs over the network. Read our privacy policy [here](https://luals.github.io/privacy/#language-server).
]]
config.misc.parameters                   = -- TODO: needs localisation
'[Command line parameters](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) when starting the language server in VSCode.'
config.misc.executablePath               = -- TODO: needs localisation
'Specify the executable path in VSCode.'
config.language.fixIndent                = -- TODO: needs localisation
'(VSCode only) Fix incorrect auto-indentation, such as incorrect indentation when line breaks occur within a string containing the word "function."'
config.language.completeAnnotation       = -- TODO: needs localisation
'(VSCode only) Automatically insert "---@ " after a line break following a annotation.'
config.type.castNumberToInteger          = -- TODO: needs localisation
'Allowed to assign the `number` type to the `integer` type.'
config.type.weakUnionCheck               = -- TODO: needs localisation
[[
Once one subtype of a union type meets the condition, the union type also meets the condition.

When this setting is `false`, the `number|boolean` type cannot be assigned to the `number` type. It can be with `true`.
]]
config.type.weakNilCheck                 = -- TODO: needs localisation
[[
When checking the type of union type, ignore the `nil` in it.

When this setting is `false`, the `number|nil` type cannot be assigned to the `number` type. It can be with `true`.
]]
config.type.inferParamType               = -- TODO: needs localisation
[[
When a parameter type is not annotated, it is inferred from the function's call sites.

When this setting is `false`, the type of the parameter is `any` when it is not annotated.
]]
config.type.checkTableShape              = -- TODO: needs localisation
[[
Strictly check the shape of the table.
]]
config.doc.privateName                   = -- TODO: needs localisation
'Treat specific field names as private, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are private, witch can only be accessed in the class where the definition is located.'
config.doc.protectedName                 = -- TODO: needs localisation
'Treat specific field names as protected, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are protected, witch can only be accessed in the class where the definition is located and its subclasses.'
config.doc.packageName                   = -- TODO: needs localisation
'Treat specific field names as package, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are package, witch can only be accessed in the file where the definition is located.'
config.diagnostics['unused-local']          = -- TODO: needs localisation
'Enable unused local variable diagnostics.'
config.diagnostics['unused-function']       = -- TODO: needs localisation
'Enable unused function diagnostics.'
config.diagnostics['undefined-global']      = -- TODO: needs localisation
'Enable undefined global variable diagnostics.'
config.diagnostics['global-in-nil-env']     = -- TODO: needs localisation
'Enable cannot use global variables （ `_ENV` is set to `nil`） diagnostics.'
config.diagnostics['unused-label']          = -- TODO: needs localisation
'Enable unused label diagnostics.'
config.diagnostics['unused-vararg']         = -- TODO: needs localisation
'Enable unused vararg diagnostics.'
config.diagnostics['trailing-space']        = -- TODO: needs localisation
'Enable trailing space diagnostics.'
config.diagnostics['redefined-local']       = -- TODO: needs localisation
'Enable redefined local variable diagnostics.'
config.diagnostics['newline-call']          = -- TODO: needs localisation
'Enable newline call diagnostics. Is\'s raised when a line starting with `(` is encountered, which is syntactically parsed as a function call on the previous line.'
config.diagnostics['newfield-call']         = -- TODO: needs localisation
'Enable newfield call diagnostics. It is raised when the parenthesis of a function call appear on the following line when defining a field in a table.'
config.diagnostics['redundant-parameter']   = -- TODO: needs localisation
'Enable redundant function parameter diagnostics.'
config.diagnostics['ambiguity-1']           = -- TODO: needs localisation
'Enable ambiguous operator precedence diagnostics. For example, the `num or 0 + 1` expression will be suggested `(num or 0) + 1` instead.'
config.diagnostics['lowercase-global']      = -- TODO: needs localisation
'Enable lowercase global variable definition diagnostics.'
config.diagnostics['undefined-env-child']   = -- TODO: needs localisation
'Enable undefined environment variable diagnostics. It\'s raised when `_ENV` table is set to a new literal table, but the used global variable is no longer present in the global environment.'
config.diagnostics['duplicate-index']       = -- TODO: needs localisation
'Enable duplicate table index diagnostics.'
config.diagnostics['empty-block']           = -- TODO: needs localisation
'Enable empty code block diagnostics.'
config.diagnostics['redundant-value']       = -- TODO: needs localisation
'Enable the redundant values assigned diagnostics. It\'s raised during assignment operation, when the number of values is higher than the number of objects being assigned.'
config.diagnostics['assign-type-mismatch']  = -- TODO: needs localisation
'Enable diagnostics for assignments in which the value\'s type does not match the type of the assigned variable.'
config.diagnostics['await-in-sync']         = -- TODO: needs localisation
'Enable diagnostics for calls of asynchronous functions within a synchronous function.'
config.diagnostics['cast-local-type']    = -- TODO: needs localisation
'Enable diagnostics for casts of local variables where the target type does not match the defined type.'
config.diagnostics['cast-type-mismatch']    = -- TODO: needs localisation
'Enable diagnostics for casts where the target type does not match the initial type.'
config.diagnostics['circular-doc-class']    = -- TODO: needs localisation
'Enable diagnostics for two classes inheriting from each other introducing a circular relation.'
config.diagnostics['close-non-object']      = -- TODO: needs localisation
'Enable diagnostics for attempts to close a variable with a non-object.'
config.diagnostics['code-after-break']      = -- TODO: needs localisation
'Enable diagnostics for code placed after a break statement in a loop.'
config.diagnostics['codestyle-check']       = -- TODO: needs localisation
'Enable diagnostics for incorrectly styled lines.'
config.diagnostics['count-down-loop']       = -- TODO: needs localisation
'Enable diagnostics for `for` loops which will never reach their max/limit because the loop is incrementing instead of decrementing.'
config.diagnostics['deprecated']            = -- TODO: needs localisation
'Enable diagnostics to highlight deprecated API.'
config.diagnostics['different-requires']    = -- TODO: needs localisation
'Enable diagnostics for files which are required by two different paths.'
config.diagnostics['discard-returns']       = -- TODO: needs localisation
'Enable diagnostics for calls of functions annotated with `---@nodiscard` where the return values are ignored.'
config.diagnostics['doc-field-no-class']    = -- TODO: needs localisation
'Enable diagnostics to highlight a field annotation without a defining class annotation.'
config.diagnostics['duplicate-doc-alias']   = -- TODO: needs localisation
'Enable diagnostics for a duplicated alias annotation name.'
config.diagnostics['duplicate-doc-field']   = -- TODO: needs localisation
'Enable diagnostics for a duplicated field annotation name.'
config.diagnostics['duplicate-doc-param']   = -- TODO: needs localisation
'Enable diagnostics for a duplicated param annotation name.'
config.diagnostics['duplicate-set-field']   = -- TODO: needs localisation
'Enable diagnostics for setting the same field in a class more than once.'
config.diagnostics['incomplete-signature-doc']    = -- TODO: needs localisation
'Incomplete @param or @return annotations for functions.'
config.diagnostics['invisible']             = -- TODO: needs localisation
'Enable diagnostics for accesses to fields which are invisible.'
config.diagnostics['missing-global-doc']    = -- TODO: needs localisation
'Missing annotations for globals! Global functions must have a comment and annotations for all parameters and return values.'
config.diagnostics['missing-local-export-doc'] = -- TODO: needs localisation
'Missing annotations for exported locals! Exported local functions must have a comment and annotations for all parameters and return values.'
config.diagnostics['missing-parameter']     = -- TODO: needs localisation
'Enable diagnostics for function calls where the number of arguments is less than the number of annotated function parameters.'
config.diagnostics['missing-return']        = -- TODO: needs localisation
'Enable diagnostics for functions with return annotations which have no return statement.'
config.diagnostics['missing-return-value']  = -- TODO: needs localisation
'Enable diagnostics for return statements without values although the containing function declares returns.'
config.diagnostics['need-check-nil']        = -- TODO: needs localisation
'Enable diagnostics for variable usages if `nil` or an optional (potentially `nil`) value was assigned to the variable before.'
config.diagnostics['no-unknown']            = -- TODO: needs localisation
'Enable diagnostics for cases in which the type cannot be inferred.'
config.diagnostics['not-yieldable']         = -- TODO: needs localisation
'Enable diagnostics for calls to `coroutine.yield()` when it is not permitted.'
config.diagnostics['param-type-mismatch']   = -- TODO: needs localisation
'Enable diagnostics for function calls where the type of a provided parameter does not match the type of the annotated function definition.'
config.diagnostics['redundant-return']      = -- TODO: needs localisation
'Enable diagnostics for return statements which are not needed because the function would exit on its own.'
config.diagnostics['redundant-return-value']= -- TODO: needs localisation
'Enable diagnostics for return statements which return an extra value which is not specified by a return annotation.'
config.diagnostics['return-type-mismatch']  = -- TODO: needs localisation
'Enable diagnostics for return values whose type does not match the type declared in the corresponding return annotation.'
config.diagnostics['spell-check']           = -- TODO: needs localisation
'Enable diagnostics for typos in strings.'
config.diagnostics['name-style-check']      = -- TODO: needs localisation
'Enable diagnostics for name style.'
config.diagnostics['unbalanced-assignments']= -- TODO: needs localisation
'Enable diagnostics on multiple assignments if not all variables obtain a value (e.g., `local x,y = 1`).'
config.diagnostics['undefined-doc-class']   = -- TODO: needs localisation
'Enable diagnostics for class annotations in which an undefined class is referenced.'
config.diagnostics['undefined-doc-name']    = -- TODO: needs localisation
'Enable diagnostics for type annotations referencing an undefined type or alias.'
config.diagnostics['undefined-doc-param']   = -- TODO: needs localisation
'Enable diagnostics for cases in which a parameter annotation is given without declaring the parameter in the function definition.'
config.diagnostics['undefined-field']       = -- TODO: needs localisation
'Enable diagnostics for cases in which an undefined field of a variable is read.'
config.diagnostics['unknown-cast-variable'] = -- TODO: needs localisation
'Enable diagnostics for casts of undefined variables.'
config.diagnostics['unknown-diag-code']     = -- TODO: needs localisation
'Enable diagnostics in cases in which an unknown diagnostics code is entered.'
config.diagnostics['unknown-operator']      = -- TODO: needs localisation
'Enable diagnostics for unknown operators.'
config.diagnostics['unreachable-code']      = -- TODO: needs localisation
'Enable diagnostics for unreachable code.'
config.diagnostics['global-element']       = -- TODO: needs localisation
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
