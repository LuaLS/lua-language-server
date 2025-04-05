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
config.hint.semicolon                    =
'Si no hay punto y coma al final de la sentencia, despliega un punto y coma virtual.'
config.hint.semicolon.All                =
'Todas las sentencias con un punto y coma virtual desplegado.'
config.hint.semicolon.SameLine            =
'Cuando dos sentencias están en la misma línea, despliega un punto y coma entre ellas.'
config.hint.semicolon.Disable            =
'Deshabilita punto y coma virtuales.'
config.codeLens.enable                   =
'Habilita el lente para código.'
config.format.enable                     =
'Habilita el formateador de código.'
config.format.defaultConfig              =
[[
La configuración de formateo predeterminada. Tiene menor prioridad que el archivo `.editorconfig`
en el espacio de trabajo.
Revise [la documentación del formateador](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)
para aprender más sobre su uso.
]]
config.spell.dict                        =
'Palabras extra para el corrector ortográfico.'
config.nameStyle.config                  =
'Configuración de estilo para nombres.'
config.telemetry.enable                  =
[[
Habilita la telemetría para enviar información del editor y registros de errores por la red. Lea nuestra política de privacidad [aquí (en inglés)](https://luals.github.io/privacy#language-server).
]]
config.misc.parameters                   =
'[Parámetros de la línea de comando](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) para iniciar el servidor de lenguage en VSCode.'
config.misc.executablePath               =
'Especifica la ruta del ejecutable en VSCode.'
config.language.fixIndent                =
'(Solo en VSCode) Arregla la auto-indentación incorrecta, como aquella cuando los quiebres de línea ocurren dentro de un string que contengan la palabra "function".'
config.language.completeAnnotation       =
'(Solo en VSCode) Inserta automáticamente un "---@ " después de un quiebre de línea que sucede a una anotación.'
config.type.castNumberToInteger          =
'Se permite asignar el tipo "número" al tipo "entero".'
config.type.weakUnionCheck               =
[[
Una vez que un sub-tipo de un tipo de unión satisface la condición, el tipo de unión también satisface la condición.

Cuando esta configuración es `false`, el tipo `number|boolean` no puede ser asignado al tipo `number`. Solo se puede con `true`.
]]
config.type.weakNilCheck                 =
[[
Cuando se revisa el tipo de un tipo de unión, los `nil` dentro son ignorados.

Cuando esta configuración es `false`, el tipo `number|nil` no puede ser asignado al tipo `number`. Solo se puede con `true`.
]]
config.type.inferParamType               =
[[
Cuando un tipo de parámetro no está anotado, se infiere su tipo de los lugares donde la función es llamada.

Cuando esta configuración es `false`, el tipo del parámetro `any` cuando no puede ser anotado.
]]
config.type.checkTableShape              =
[[
Chequea estrictamente la forma de la tabla.
]]
config.doc.privateName                   =
'Trata los nombres específicos de campo como privados. Por ejemplo `m_*` significa `XXX.m_id` y `XXX.m_tipo` son privados, por lo que solo pueden ser accedidos donde se define la clase.'
config.doc.protectedName                 =
'Trata los nombres específicos de campo como protegidos. Por ejemplo `m_*` significa `XXX.m_id` y `XXX.m_tipo` son privados, por lo que solo pueden ser accedidos donde se define la clase y sus subclases.'
config.doc.packageName                   =
'Trata los nombres específicos de campo como del paquete. Por ejemplo `m_*` significa `XXX.m_id` y `XXX.m_tipo` son de paquete, por lo que solo pueden ser accedidos en el archivo donde son definidos.'
config.diagnostics['unused-local']          =
'Habilita el diagnóstico de variables local sin uso.'
config.diagnostics['unused-function']       =
'Habilita el diagnóstico funcines sin uso.'
config.diagnostics['undefined-global']      =
'Habilita el diagnóstico de variables globales sin definir.'
config.diagnostics['global-in-nil-env']     =
'Habilita el diagnóstico para la prohibición de uso de variables globales (`_ENV` se fija a `nil`).'
config.diagnostics['unused-label']          =
'Habilita el diagnóstico de etiquetas sin uso.'
config.diagnostics['unused-vararg']         =
'Habilita el diagnóstico de expresión de número variable de argumentos (vararg) sin uso.'
config.diagnostics['trailing-space']        =
'Habilita el diagnóstico de espacios al final de línea.'
config.diagnostics['redefined-local']       =
'Habilita el diagnóstico de variables locals redefinidas.'
config.diagnostics['newline-call']          =
'Habilita el diagnóstico de llamadas en línea nueva. Se alza un error en las líneas que comienzan con `(`, lo que se lee sintácticamente como una llamada a la línea anterior.'
config.diagnostics['newfield-call']         =
'Habilita el diagnóstico de campo nuevo en una llamada. Se alza un error cuando los paréntesis de una llamada a una función aparecen en la siguiente línea cuando se define un campo en una tabla.'
config.diagnostics['redundant-parameter']   =
'Habilita el diagnóstico de parámetros redundantes de una función.'
config.diagnostics['ambiguity-1']           =
'Habilita el diagnóstico de precedencia de operadores ambiguos. Por ejemplo, ante la expresión `num or 0 + 1` se sugerirrá `(num or 0) + 1`.'
config.diagnostics['lowercase-global']      =
'Habilita el diagnóstico de definiciones de variables globacels con minúsculas.'
config.diagnostics['undefined-env-child']   =
'Habilita el diagnóstico de variables de ambientes sin definir. Se alza un error cuando a la tabla `_ENV` se le asigna una tabla literal nueva, pero la variable global usada no está presente en el ambiente global.'
config.diagnostics['duplicate-index']       =
'Habilita el diagnóstico de índices de tabla duplicados.'
config.diagnostics['empty-block']           =
'Habilita el diagnóstico de bloques de código vacíos.'
config.diagnostics['redundant-value']       =
'Habilita el diagnóstico de valores asignados redundantemente. Se alza un error en una asignación, cuando el número de valores es mayor que el número de objetos a los cuales se les asigna.'
config.diagnostics['assign-type-mismatch']  =
'Habilita el diagnóstico para asignaciones en las cuales el valor del tipo no calza con el tipo de la variable siendo asignada.'
config.diagnostics['await-in-sync']         =
'Habilita el diagnóstico para llamadas a funciones asíncronas dentro de una función síncrona.'
config.diagnostics['cast-local-type']    =
'Habilita el diagnóstico para conversión de tipos de variables locales donde el tipo objetivo no calza con el tipo definido.'
config.diagnostics['cast-type-mismatch']    =
'Habilita el diagnóstico para conversiones de tipos donde el tipo objetivo no calza con el tipo inicial.'
config.diagnostics['circular-doc-class']    =
'Habilita el diagnóstico para pares de clases que heredan una de la otra, introduciendo una relación circular.'
config.diagnostics['close-non-object']      =
'Habilita el diagnóstico para intentos de cerra una variable con un no-objeto.'
config.diagnostics['code-after-break']      =
'Habilita el diagnóstico para el código que viene después de un `break` en un bucle.'
config.diagnostics['codestyle-check']       =
'Habilita el diagnóstico para líneas formateadas incorrectamente.'
config.diagnostics['count-down-loop']       =
'Habilita el diagnóstico para bucles `for` en los cuales nunca se alcanza su máximo o límite por que el bucle es incremental en vez de decremental.'
config.diagnostics['deprecated']            =
'Habilita el diagnóstico para resaltar APIs obsoletas.'
config.diagnostics['different-requires']    =
'Habilita el diagnóstico para archivos que son requeridos con dos rutas distintas.'
config.diagnostics['discard-returns']       =
'Habilita el diagnóstico para llamadas de funciones anotadas con `---@nodiscard` en las cuales se ignore los valores retornados.'
config.diagnostics['doc-field-no-class']    =
'Habilita el diagnóstico para resaltar una anotación de campo sin una anotación de clase que lo defina.'
config.diagnostics['duplicate-doc-alias']   =
'Habilita el diagnóstico para nombres de alias duplicados en una anotación.'
config.diagnostics['duplicate-doc-field']   =
'Habilita el diagnóstico para nombres de campo duplicados en una anotación.'
config.diagnostics['duplicate-doc-param']   =
'Habilita el diagnóstico para nombres de parámetros duplicados en una anotación.'
config.diagnostics['duplicate-set-field']   =
'Habilita el diagnóstico para cuando se asigna el mismo campo en una clase más de una vez.'
config.diagnostics['incomplete-signature-doc']    =
'Habilita el diagnóstico para anotaciones @param o @return incompletas para funciones.'
config.diagnostics['invisible']             =
'Habilita el diagnóstico para accesos a campos que son invisibles.'
config.diagnostics['missing-global-doc']    =
'Habilita el diagnóstico para globales faltantes. Las funciones globales deben tener un comentario y anotaciones para todos sus parámetros y valores retornados.'
config.diagnostics['missing-local-export-doc'] =
'Habilita el diagnóstico para locales exportadas. Las funciones locales deben tener un comentario y anotaciones para todos sus parámetros y valores retornados.'
config.diagnostics['missing-parameter']     =
'Habilita el diagnóstico para llamados de funciones donde el número de argumentos es menore que el número de parámetros anotados de la función.'
config.diagnostics['missing-return']        =
'Habilita el diagnóstico para para funciones con anotaciones de retorno que no tienen la expresión `return …`.'
config.diagnostics['missing-return-value']  =
'Habilita el diagnóstico para expresiones `return …` sin valores aunque la función que la contiene declare retornos.'
config.diagnostics['need-check-nil']        =
'Habilita el diagnóstico para usos de variables si `nil` o un valor opcional (potencialmente `nil`) haya sido asignado a la variable anteriormente.'
config.diagnostics['no-unknown']            =
'Habilita el diagnóstico para los casos en que el tipo no puede ser inferido.'
config.diagnostics['not-yieldable']         =
'Habilita el diagnóstico para llamadas a `coroutine.yield()` cuando no esté permitido.'
config.diagnostics['param-type-mismatch']   =
'Habilita el diagnóstico para llamadas a funciones donde el tipo de un parámetro provisto no calza con el tipo de la definición anotado de la función.'
config.diagnostics['redundant-return']      =
'Habilita el diagnóstico para sentencias de retorno que no son necesarias porque la función terminaría de igual manera.'
config.diagnostics['redundant-return-value']=
'Habilita el diagnóstico para sentencias de retorno que retornan un valor extra que no fue especificado por una anotación de retorno.'
config.diagnostics['return-type-mismatch']  =
'Habilita el diagnóstico para valores retornados cuyo tipo no calza con el tipo declarado en la anotación correspondiente de la función.'
config.diagnostics['spell-check']           =
'Habilita el diagnóstico para errores tipográficos en strings.'
config.diagnostics['name-style-check']      =
'Habilita el diagnóstico para el estilo de nombres.'
config.diagnostics['unbalanced-assignments']=
'Habilita el diagnóstico para asignaciones múltiplies si no todas las variables obtienen un valor (por ejemplo, `local x,y = 1`).'
config.diagnostics['undefined-doc-class']   =
'Habilita el diagnóstico para las anotaciones de clase en las cuales una clase sin definir es referenciada.'
config.diagnostics['undefined-doc-name']    =
'Habilita el diagnóstico para anotaciones de tipo que referencian a un tipo o alias sin definir.'
config.diagnostics['undefined-doc-param']   =
'Habilita el diagnóstico para casos en que una anotación de parámetro es dado sin declarar el parámetro en la definición de la función.'
config.diagnostics['undefined-field']       =
'Habilita el diagnóstico para los casos en que se lee un campo sin definir de una variable.'
config.diagnostics['unknown-cast-variable'] =
'Habilita el diagnóstico para conversiones de tipo de variables sin definir.'
config.diagnostics['unknown-diag-code']     =
'Habilita el diagnóstico para los casos en que un código desconocido de diagnóstico es ingresado.'
config.diagnostics['unknown-operator']      =
'Habilita el diagnóstico para operadores desconocidos.'
config.diagnostics['unreachable-code']      =
'Habilita el diagnóstico para código inalcanzable.'
config.diagnostics['global-element']       =
'Habilita el diagnóstico que alerta sobre elementos globales.'
config.typeFormat.config                    =
'Configura el comportamiento del formateo mientras se tipea código Lua.'
config.typeFormat.config.auto_complete_end  =
'Controla si se completa automáticamente con `end` en las posiciones correspondientes.'
config.typeFormat.config.auto_complete_table_sep =
'Controla si se agrega automáticamente un separador al final de la declaración de una tabla.'
config.typeFormat.config.format_line        =
'Controla si una línea se formatea'

command.exportDocument =
'Lua: Exporta Documento ...'
command.addon_manager.open =
'Lua: Abre el Manejador de Extensiones ...'
command.reloadFFIMeta =
'Lua: Recarga meta de ffi para luajit'
command.startServer =
'Lua: (debug) Carga el Servidor de Lenguaje'
command.stopServer =
'Lua: (debug) Detén el Servidor de Lenguaje'
