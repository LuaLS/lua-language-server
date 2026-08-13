# addonManager.enable

Si el manejador de extensiones está habilitado.

## type

```ts
boolean
```

## default

```jsonc
true
```

# addonManager.repositoryBranch

Especifica la rama de git usada por el manejador de extensiones.

## type

```ts
string
```

## default

```jsonc
""
```

# addonManager.repositoryPath

Especifica la ruta git usada por el manejador de extensiones.

## type

```ts
string
```

## default

```jsonc
""
```

# addonRepositoryPath

Especifica la ruta del repositorio de complementos (no relacionada con el gestor de complementos).

## type

```ts
string
```

## default

```jsonc
""
```

# codeLens.enable

Habilita el lente para código.

## type

```ts
boolean
```

## default

```jsonc
false
```

# completion.autoRequire

Agrega automáticamente el `require` correspondiente cuando la entrada se parece a un nombre de archivo.

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.callSnippet

Muestra snippets para llamadas de funciones.

## type

```ts
string
```

## enum

* ``"Disable"``: Solo muestra `función nombre`.
* ``"Both"``: Muestra `función nombre` y `llamar al snippet`.
* ``"Replace"``: Solo muestra `llamar al snippet`.

## default

```jsonc
"Disable"
```

# completion.displayContext

La prevista de la sugerencia del snippet de código relevante ayuda a entender el uso de la sugerenecia. El número fijado indica el número de líneas interceptadas en el fragmento de código. Fijando en `0` se deshabilita esta característica.

## type

```ts
integer
```

## default

```jsonc
0
```

# completion.enable

Habilita la completación.

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.keywordSnippet

Muestra snippets con sintaxis de palabras clave.

## type

```ts
string
```

## enum

* ``"Disable"``: Solo muestra `palabra clave`.
* ``"Both"``: Muestra `palabra clave` y `snippet de sintaxis`.
* ``"Replace"``: Solo muestra `snippet de sintaxis`.

## default

```jsonc
"Replace"
```

# completion.maxSuggestCount

Número máximo de campos a analizar para autocompletar. Cuando un objeto tiene más campos que este límite, las sugerencias requerirán una entrada más específica para aparecer.

## type

```ts
integer
```

## default

```jsonc
100
```

# completion.postfix

El símbolo usado para lanzar la sugerencia posfija.

## type

```ts
string
```

## default

```jsonc
"@"
```

# completion.requireSeparator

Separador usado en `require`.

## type

```ts
string
```

## default

```jsonc
"."
```

# completion.showParams

Muestra los parámetros en la lista de completado. Cuando la función tiene múltiples definiciones, se mostrarán por separado.

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.showWord

Muestra palabras contextuales en las sugerencias.

## type

```ts
string
```

## enum

* ``"Enable"``: Siempre muestra palabras contextuales en las sugerencias.
* ``"Fallback"``: Las palabras contextuales solo se muestran si las sugerencias basadas en la semántica no están provistas.
* ``"Disable"``: Sin presentar las palabras contextuales.

## default

```jsonc
"Fallback"
```

# completion.workspaceWord

Si es que el la palabra contextual presentada contiene contenido de otros archivos en el espacio de trabajo.

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.disable

Deshabilita los diagnósticos (Usa código en corchetes bajo el cursor).

## type

```ts
Array<string>
```

## enum

* ``"action-after-return"``
* ``"ambiguity-1"``
* ``"ambiguous-syntax"``
* ``"args-after-dots"``
* ``"assign-const-global"``
* ``"assign-type-mismatch"``
* ``"await-in-sync"``
* ``"block-after-else"``
* ``"break-outside"``
* ``"cast-local-type"``
* ``"cast-type-mismatch"``
* ``"circle-doc-class"``
* ``"close-non-object"``
* ``"code-after-break"``
* ``"codestyle-check"``
* ``"count-down-loop"``
* ``"declare-const"``
* ``"deprecated"``
* ``"different-requires"``
* ``"discard-returns"``
* ``"doc-field-no-class"``
* ``"duplicate-doc-alias"``
* ``"duplicate-doc-field"``
* ``"duplicate-doc-param"``
* ``"duplicate-index"``
* ``"duplicate-set-field"``
* ``"empty-block"``
* ``"env-is-global"``
* ``"err-assign-as-eq"``
* ``"err-c-long-comment"``
* ``"err-comment-prefix"``
* ``"err-do-as-then"``
* ``"err-eq-as-assign"``
* ``"err-esc"``
* ``"err-nonstandard-symbol"``
* ``"err-then-as-do"``
* ``"exp-in-action"``
* ``"global-close-attribute"``
* ``"global-element"``
* ``"global-in-nil-env"``
* ``"incomplete-signature-doc"``
* ``"index-in-func-name"``
* ``"inject-field"``
* ``"invisible"``
* ``"jump-local-scope"``
* ``"keyword"``
* ``"local-limit"``
* ``"lowercase-global"``
* ``"lua-doc-miss-sign"``
* ``"luadoc-error-diag-mode"``
* ``"luadoc-miss-alias-extends"``
* ``"luadoc-miss-alias-name"``
* ``"luadoc-miss-arg-name"``
* ``"luadoc-miss-cate-name"``
* ``"luadoc-miss-class-extends-name"``
* ``"luadoc-miss-class-name"``
* ``"luadoc-miss-diag-mode"``
* ``"luadoc-miss-diag-name"``
* ``"luadoc-miss-field-extends"``
* ``"luadoc-miss-field-name"``
* ``"luadoc-miss-fun-after-overload"``
* ``"luadoc-miss-generic-name"``
* ``"luadoc-miss-local-name"``
* ``"luadoc-miss-module-name"``
* ``"luadoc-miss-operator-name"``
* ``"luadoc-miss-param-extends"``
* ``"luadoc-miss-param-name"``
* ``"luadoc-miss-see-name"``
* ``"luadoc-miss-sign-name"``
* ``"luadoc-miss-symbol"``
* ``"luadoc-miss-type-name"``
* ``"luadoc-miss-vararg-type"``
* ``"luadoc-miss-version"``
* ``"malformed-number"``
* ``"miss-end"``
* ``"miss-esc-x"``
* ``"miss-exp"``
* ``"miss-exponent"``
* ``"miss-field"``
* ``"miss-loop-max"``
* ``"miss-loop-min"``
* ``"miss-method"``
* ``"miss-name"``
* ``"miss-sep-in-table"``
* ``"miss-space-between"``
* ``"miss-symbol"``
* ``"missing-fields"``
* ``"missing-global-doc"``
* ``"missing-local-export-doc"``
* ``"missing-parameter"``
* ``"missing-return"``
* ``"missing-return-value"``
* ``"multi-close"``
* ``"name-style-check"``
* ``"need-check-nil"``
* ``"need-paren"``
* ``"nesting-long-mark"``
* ``"newfield-call"``
* ``"newline-call"``
* ``"no-unknown"``
* ``"no-visible-label"``
* ``"not-yieldable"``
* ``"param-type-mismatch"``
* ``"redefined-label"``
* ``"redefined-local"``
* ``"redundant-parameter"``
* ``"redundant-return"``
* ``"redundant-return-value"``
* ``"redundant-value"``
* ``"return-type-mismatch"``
* ``"set-const"``
* ``"spell-check"``
* ``"trailing-space"``
* ``"unbalanced-assignments"``
* ``"undefined-doc-class"``
* ``"undefined-doc-name"``
* ``"undefined-doc-param"``
* ``"undefined-env-child"``
* ``"undefined-field"``
* ``"undefined-global"``
* ``"unexpect-dots"``
* ``"unexpect-efunc-name"``
* ``"unexpect-gfunc-name"``
* ``"unexpect-lfunc-name"``
* ``"unexpect-symbol"``
* ``"unicode-name"``
* ``"unknown-attribute"``
* ``"unknown-cast-variable"``
* ``"unknown-diag-code"``
* ``"unknown-operator"``
* ``"unknown-symbol"``
* ``"unreachable-code"``
* ``"unsupport-named-vararg"``
* ``"unsupport-symbol"``
* ``"unused-function"``
* ``"unused-label"``
* ``"unused-local"``
* ``"unused-vararg"``
* ``"variable-not-declared"``

## default

```jsonc
[]
```

# diagnostics.enable

Habilita los diagnósticos.

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.enableScheme

**Missing description!!**

## type

```ts
Array<string>
```

## default

```jsonc
["file"]
```

# diagnostics.globals

Variables globales definidas.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.globalsRegex

Encuentra variables globales definidas usando esta expresión regular.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.groupFileStatus

Modifica los diagnósticos de archivos requeridos en un grupo.

* Opened:  solo diagnostica los archivos abiertos
* Any:     diagnostica todos los archivos
* None:    deshabilita este diagnóstico

`Fallback` significa que los diagnósticos en este grupo son controlados con una severida separada de `diagnostics.neededFileStatus`.
Otras configuraciones descartan las configuraciones individuales que no terminen en `!`.


## type

```ts
object<string, string>
```

## enum

* ``"Any"``
* ``"Opened"``
* ``"None"``
* ``"Fallback"``

## default

```jsonc
{
    /*
    * ambiguity-1
    * count-down-loop
    * different-requires
    * newfield-call
    * newline-call
    */
    "ambiguity": "Fallback",
    /*
    * await-in-sync
    * not-yieldable
    */
    "await": "Fallback",
    /*
    * codestyle-check
    * name-style-check
    * spell-check
    */
    "codestyle": "Fallback",
    /*
    * global-element
    */
    "conventions": "Fallback",
    /*
    * duplicate-index
    * duplicate-set-field
    */
    "duplicate": "Fallback",
    /*
    * global-in-nil-env
    * lowercase-global
    * undefined-env-child
    * undefined-global
    */
    "global": "Fallback",
    /*
    * circle-doc-class
    * doc-field-no-class
    * duplicate-doc-alias
    * duplicate-doc-field
    * duplicate-doc-param
    * incomplete-signature-doc
    * missing-global-doc
    * missing-local-export-doc
    * undefined-doc-class
    * undefined-doc-name
    * undefined-doc-param
    * unknown-cast-variable
    * unknown-diag-code
    * unknown-operator
    */
    "luadoc": "Fallback",
    /*
    * redefined-local
    */
    "redefined": "Fallback",
    /*
    * close-non-object
    * deprecated
    * discard-returns
    * invisible
    */
    "strict": "Fallback",
    /*
    * no-unknown
    */
    "strong": "Fallback",
    /*
    * assign-type-mismatch
    * cast-local-type
    * cast-type-mismatch
    * inject-field
    * need-check-nil
    * param-type-mismatch
    * return-type-mismatch
    * undefined-field
    */
    "type-check": "Fallback",
    /*
    * missing-fields
    * missing-parameter
    * missing-return
    * missing-return-value
    * redundant-parameter
    * redundant-return-value
    * redundant-value
    * unbalanced-assignments
    */
    "unbalanced": "Fallback",
    /*
    * code-after-break
    * empty-block
    * redundant-return
    * trailing-space
    * unreachable-code
    * unused-function
    * unused-label
    * unused-local
    * unused-vararg
    */
    "unused": "Fallback"
}
```

# diagnostics.groupSeverity

Modifica el la severirad de los diagnósticos en un grupo.
`Fallback` significa que los diagnósticos en este grupo son controlados con una severida separada de `diagnostics.severity`.
Otras configuraciones descartan las configuraciones individuales que no terminen en `!`.


## type

```ts
object<string, string>
```

## enum

* ``"Error"``
* ``"Warning"``
* ``"Information"``
* ``"Hint"``
* ``"Fallback"``

## default

```jsonc
{
    /*
    * ambiguity-1
    * count-down-loop
    * different-requires
    * newfield-call
    * newline-call
    */
    "ambiguity": "Fallback",
    /*
    * await-in-sync
    * not-yieldable
    */
    "await": "Fallback",
    /*
    * codestyle-check
    * name-style-check
    * spell-check
    */
    "codestyle": "Fallback",
    /*
    * global-element
    */
    "conventions": "Fallback",
    /*
    * duplicate-index
    * duplicate-set-field
    */
    "duplicate": "Fallback",
    /*
    * global-in-nil-env
    * lowercase-global
    * undefined-env-child
    * undefined-global
    */
    "global": "Fallback",
    /*
    * circle-doc-class
    * doc-field-no-class
    * duplicate-doc-alias
    * duplicate-doc-field
    * duplicate-doc-param
    * incomplete-signature-doc
    * missing-global-doc
    * missing-local-export-doc
    * undefined-doc-class
    * undefined-doc-name
    * undefined-doc-param
    * unknown-cast-variable
    * unknown-diag-code
    * unknown-operator
    */
    "luadoc": "Fallback",
    /*
    * redefined-local
    */
    "redefined": "Fallback",
    /*
    * close-non-object
    * deprecated
    * discard-returns
    * invisible
    */
    "strict": "Fallback",
    /*
    * no-unknown
    */
    "strong": "Fallback",
    /*
    * assign-type-mismatch
    * cast-local-type
    * cast-type-mismatch
    * inject-field
    * need-check-nil
    * param-type-mismatch
    * return-type-mismatch
    * undefined-field
    */
    "type-check": "Fallback",
    /*
    * missing-fields
    * missing-parameter
    * missing-return
    * missing-return-value
    * redundant-parameter
    * redundant-return-value
    * redundant-value
    * unbalanced-assignments
    */
    "unbalanced": "Fallback",
    /*
    * code-after-break
    * empty-block
    * redundant-return
    * trailing-space
    * unreachable-code
    * unused-function
    * unused-label
    * unused-local
    * unused-vararg
    */
    "unused": "Fallback"
}
```

# diagnostics.ignoredFiles

Cómo diagnosticar los archivos ignorados.

## type

```ts
string
```

## enum

* ``"Enable"``: Estos archivos siempre se diagnostican.
* ``"Opened"``: Estos archivos se diagnostican solo cuando se abren.
* ``"Disable"``: Estos archivos no se diagnostican.

## default

```jsonc
"Opened"
```

# diagnostics.libraryFiles

Cómo diagnosticar los archivos cargados via `Lua.workspace.library`.

## type

```ts
string
```

## enum

* ``"Enable"``: Estos archivos siempre se diagnostican.
* ``"Opened"``: Estos archivos se diagnostican solo cuando se abren.
* ``"Disable"``: Estos archivos no se diagnostican.

## default

```jsonc
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  Solo diagnostica los archivos abiertos
* Any:     diagnostica todos los archivos
* None:    deshabilita este diagnóstico

Agregue `!` al final para descartar la configuración `diagnostics.groupFileStatus`.


## type

```ts
object<string, string>
```

## enum

* ``"Any"``
* ``"Opened"``
* ``"None"``
* ``"Any!"``
* ``"Opened!"``
* ``"None!"``

## default

```jsonc
{
    /*
    Habilita el diagnóstico de precedencia de operadores ambiguos. Por ejemplo, ante la expresión `num or 0 + 1` se sugerirrá `(num or 0) + 1`.
    */
    "ambiguity-1": "Any",
    /*
    Habilita el diagnóstico para asignaciones en las cuales el valor del tipo no calza con el tipo de la variable siendo asignada.
    */
    "assign-type-mismatch": "Opened",
    /*
    Habilita el diagnóstico para llamadas a funciones asíncronas dentro de una función síncrona.
    */
    "await-in-sync": "None",
    /*
    Habilita el diagnóstico para conversión de tipos de variables locales donde el tipo objetivo no calza con el tipo definido.
    */
    "cast-local-type": "Opened",
    /*
    Habilita el diagnóstico para conversiones de tipos donde el tipo objetivo no calza con el tipo inicial.
    */
    "cast-type-mismatch": "Opened",
    "circle-doc-class": "Any",
    /*
    Habilita el diagnóstico para intentos de cerra una variable con un no-objeto.
    */
    "close-non-object": "Any",
    /*
    Habilita el diagnóstico para el código que viene después de un `break` en un bucle.
    */
    "code-after-break": "Opened",
    /*
    Habilita el diagnóstico para líneas formateadas incorrectamente.
    */
    "codestyle-check": "None",
    /*
    Habilita el diagnóstico para bucles `for` en los cuales nunca se alcanza su máximo o límite por que el bucle es incremental en vez de decremental.
    */
    "count-down-loop": "Any",
    /*
    Habilita el diagnóstico para resaltar APIs obsoletas.
    */
    "deprecated": "Any",
    /*
    Habilita el diagnóstico para archivos que son requeridos con dos rutas distintas.
    */
    "different-requires": "Any",
    /*
    Habilita el diagnóstico para llamadas de funciones anotadas con `---@nodiscard` en las cuales se ignore los valores retornados.
    */
    "discard-returns": "Any",
    /*
    Habilita el diagnóstico para resaltar una anotación de campo sin una anotación de clase que lo defina.
    */
    "doc-field-no-class": "Any",
    /*
    Habilita el diagnóstico para nombres de alias duplicados en una anotación.
    */
    "duplicate-doc-alias": "Any",
    /*
    Habilita el diagnóstico para nombres de campo duplicados en una anotación.
    */
    "duplicate-doc-field": "Any",
    /*
    Habilita el diagnóstico para nombres de parámetros duplicados en una anotación.
    */
    "duplicate-doc-param": "Any",
    /*
    Habilita el diagnóstico de índices de tabla duplicados.
    */
    "duplicate-index": "Any",
    /*
    Habilita el diagnóstico para cuando se asigna el mismo campo en una clase más de una vez.
    */
    "duplicate-set-field": "Opened",
    /*
    Habilita el diagnóstico de bloques de código vacíos.
    */
    "empty-block": "Opened",
    /*
    Habilita el diagnóstico que alerta sobre elementos globales.
    */
    "global-element": "None",
    /*
    Habilita el diagnóstico para la prohibición de uso de variables globales (`_ENV` se fija a `nil`).
    */
    "global-in-nil-env": "Any",
    /*
    Habilita el diagnóstico para anotaciones @param o @return incompletas para funciones.
    */
    "incomplete-signature-doc": "None",
    "inject-field": "Opened",
    /*
    Habilita el diagnóstico para accesos a campos que son invisibles.
    */
    "invisible": "Any",
    /*
    Habilita el diagnóstico de definiciones de variables globacels con minúsculas.
    */
    "lowercase-global": "Any",
    "missing-fields": "Any",
    /*
    Habilita el diagnóstico para globales faltantes. Las funciones globales deben tener un comentario y anotaciones para todos sus parámetros y valores retornados.
    */
    "missing-global-doc": "None",
    /*
    Habilita el diagnóstico para locales exportadas. Las funciones locales deben tener un comentario y anotaciones para todos sus parámetros y valores retornados.
    */
    "missing-local-export-doc": "None",
    /*
    Habilita el diagnóstico para llamados de funciones donde el número de argumentos es menore que el número de parámetros anotados de la función.
    */
    "missing-parameter": "Any",
    /*
    Habilita el diagnóstico para para funciones con anotaciones de retorno que no tienen la expresión `return …`.
    */
    "missing-return": "Any",
    /*
    Habilita el diagnóstico para expresiones `return …` sin valores aunque la función que la contiene declare retornos.
    */
    "missing-return-value": "Any",
    /*
    Habilita el diagnóstico para el estilo de nombres.
    */
    "name-style-check": "None",
    /*
    Habilita el diagnóstico para usos de variables si `nil` o un valor opcional (potencialmente `nil`) haya sido asignado a la variable anteriormente.
    */
    "need-check-nil": "Opened",
    /*
    Habilita el diagnóstico de campo nuevo en una llamada. Se alza un error cuando los paréntesis de una llamada a una función aparecen en la siguiente línea cuando se define un campo en una tabla.
    */
    "newfield-call": "Any",
    /*
    Habilita el diagnóstico de llamadas en línea nueva. Se alza un error en las líneas que comienzan con `(`, lo que se lee sintácticamente como una llamada a la línea anterior.
    */
    "newline-call": "Any",
    /*
    Habilita el diagnóstico para los casos en que el tipo no puede ser inferido.
    */
    "no-unknown": "None",
    /*
    Habilita el diagnóstico para llamadas a `coroutine.yield()` cuando no esté permitido.
    */
    "not-yieldable": "None",
    /*
    Habilita el diagnóstico para llamadas a funciones donde el tipo de un parámetro provisto no calza con el tipo de la definición anotado de la función.
    */
    "param-type-mismatch": "Opened",
    /*
    Habilita el diagnóstico de variables locals redefinidas.
    */
    "redefined-local": "Opened",
    /*
    Habilita el diagnóstico de parámetros redundantes de una función.
    */
    "redundant-parameter": "Any",
    /*
    Habilita el diagnóstico para sentencias de retorno que no son necesarias porque la función terminaría de igual manera.
    */
    "redundant-return": "Opened",
    /*
    Habilita el diagnóstico para sentencias de retorno que retornan un valor extra que no fue especificado por una anotación de retorno.
    */
    "redundant-return-value": "Any",
    /*
    Habilita el diagnóstico de valores asignados redundantemente. Se alza un error en una asignación, cuando el número de valores es mayor que el número de objetos a los cuales se les asigna.
    */
    "redundant-value": "Any",
    /*
    Habilita el diagnóstico para valores retornados cuyo tipo no calza con el tipo declarado en la anotación correspondiente de la función.
    */
    "return-type-mismatch": "Opened",
    /*
    Habilita el diagnóstico para errores tipográficos en strings.
    */
    "spell-check": "None",
    /*
    Habilita el diagnóstico de espacios al final de línea.
    */
    "trailing-space": "Opened",
    /*
    Habilita el diagnóstico para asignaciones múltiplies si no todas las variables obtienen un valor (por ejemplo, `local x,y = 1`).
    */
    "unbalanced-assignments": "Any",
    /*
    Habilita el diagnóstico para las anotaciones de clase en las cuales una clase sin definir es referenciada.
    */
    "undefined-doc-class": "Any",
    /*
    Habilita el diagnóstico para anotaciones de tipo que referencian a un tipo o alias sin definir.
    */
    "undefined-doc-name": "Any",
    /*
    Habilita el diagnóstico para casos en que una anotación de parámetro es dado sin declarar el parámetro en la definición de la función.
    */
    "undefined-doc-param": "Any",
    /*
    Habilita el diagnóstico de variables de ambientes sin definir. Se alza un error cuando a la tabla `_ENV` se le asigna una tabla literal nueva, pero la variable global usada no está presente en el ambiente global.
    */
    "undefined-env-child": "Any",
    /*
    Habilita el diagnóstico para los casos en que se lee un campo sin definir de una variable.
    */
    "undefined-field": "Opened",
    /*
    Habilita el diagnóstico de variables globales sin definir.
    */
    "undefined-global": "Any",
    /*
    Habilita el diagnóstico para conversiones de tipo de variables sin definir.
    */
    "unknown-cast-variable": "Any",
    /*
    Habilita el diagnóstico para los casos en que un código desconocido de diagnóstico es ingresado.
    */
    "unknown-diag-code": "Any",
    /*
    Habilita el diagnóstico para operadores desconocidos.
    */
    "unknown-operator": "Any",
    /*
    Habilita el diagnóstico para código inalcanzable.
    */
    "unreachable-code": "Opened",
    /*
    Habilita el diagnóstico funcines sin uso.
    */
    "unused-function": "Opened",
    /*
    Habilita el diagnóstico de etiquetas sin uso.
    */
    "unused-label": "Opened",
    /*
    Habilita el diagnóstico de variables local sin uso.
    */
    "unused-local": "Opened",
    /*
    Habilita el diagnóstico de expresión de número variable de argumentos (vararg) sin uso.
    */
    "unused-vararg": "Opened"
}
```

# diagnostics.severity

Modifica el la severirad de los diagnósticos.

Agregue `!` al final para descartar la configuración `diagnostics.groupSeverity`.


## type

```ts
object<string, string>
```

## enum

* ``"Error"``
* ``"Warning"``
* ``"Information"``
* ``"Hint"``
* ``"Error!"``
* ``"Warning!"``
* ``"Information!"``
* ``"Hint!"``

## default

```jsonc
{
    /*
    Habilita el diagnóstico de precedencia de operadores ambiguos. Por ejemplo, ante la expresión `num or 0 + 1` se sugerirrá `(num or 0) + 1`.
    */
    "ambiguity-1": "Warning",
    /*
    Habilita el diagnóstico para asignaciones en las cuales el valor del tipo no calza con el tipo de la variable siendo asignada.
    */
    "assign-type-mismatch": "Warning",
    /*
    Habilita el diagnóstico para llamadas a funciones asíncronas dentro de una función síncrona.
    */
    "await-in-sync": "Warning",
    /*
    Habilita el diagnóstico para conversión de tipos de variables locales donde el tipo objetivo no calza con el tipo definido.
    */
    "cast-local-type": "Warning",
    /*
    Habilita el diagnóstico para conversiones de tipos donde el tipo objetivo no calza con el tipo inicial.
    */
    "cast-type-mismatch": "Warning",
    "circle-doc-class": "Warning",
    /*
    Habilita el diagnóstico para intentos de cerra una variable con un no-objeto.
    */
    "close-non-object": "Warning",
    /*
    Habilita el diagnóstico para el código que viene después de un `break` en un bucle.
    */
    "code-after-break": "Hint",
    /*
    Habilita el diagnóstico para líneas formateadas incorrectamente.
    */
    "codestyle-check": "Warning",
    /*
    Habilita el diagnóstico para bucles `for` en los cuales nunca se alcanza su máximo o límite por que el bucle es incremental en vez de decremental.
    */
    "count-down-loop": "Warning",
    /*
    Habilita el diagnóstico para resaltar APIs obsoletas.
    */
    "deprecated": "Warning",
    /*
    Habilita el diagnóstico para archivos que son requeridos con dos rutas distintas.
    */
    "different-requires": "Warning",
    /*
    Habilita el diagnóstico para llamadas de funciones anotadas con `---@nodiscard` en las cuales se ignore los valores retornados.
    */
    "discard-returns": "Warning",
    /*
    Habilita el diagnóstico para resaltar una anotación de campo sin una anotación de clase que lo defina.
    */
    "doc-field-no-class": "Warning",
    /*
    Habilita el diagnóstico para nombres de alias duplicados en una anotación.
    */
    "duplicate-doc-alias": "Warning",
    /*
    Habilita el diagnóstico para nombres de campo duplicados en una anotación.
    */
    "duplicate-doc-field": "Warning",
    /*
    Habilita el diagnóstico para nombres de parámetros duplicados en una anotación.
    */
    "duplicate-doc-param": "Warning",
    /*
    Habilita el diagnóstico de índices de tabla duplicados.
    */
    "duplicate-index": "Warning",
    /*
    Habilita el diagnóstico para cuando se asigna el mismo campo en una clase más de una vez.
    */
    "duplicate-set-field": "Warning",
    /*
    Habilita el diagnóstico de bloques de código vacíos.
    */
    "empty-block": "Hint",
    /*
    Habilita el diagnóstico que alerta sobre elementos globales.
    */
    "global-element": "Warning",
    /*
    Habilita el diagnóstico para la prohibición de uso de variables globales (`_ENV` se fija a `nil`).
    */
    "global-in-nil-env": "Warning",
    /*
    Habilita el diagnóstico para anotaciones @param o @return incompletas para funciones.
    */
    "incomplete-signature-doc": "Warning",
    "inject-field": "Warning",
    /*
    Habilita el diagnóstico para accesos a campos que son invisibles.
    */
    "invisible": "Warning",
    /*
    Habilita el diagnóstico de definiciones de variables globacels con minúsculas.
    */
    "lowercase-global": "Information",
    "missing-fields": "Warning",
    /*
    Habilita el diagnóstico para globales faltantes. Las funciones globales deben tener un comentario y anotaciones para todos sus parámetros y valores retornados.
    */
    "missing-global-doc": "Warning",
    /*
    Habilita el diagnóstico para locales exportadas. Las funciones locales deben tener un comentario y anotaciones para todos sus parámetros y valores retornados.
    */
    "missing-local-export-doc": "Warning",
    /*
    Habilita el diagnóstico para llamados de funciones donde el número de argumentos es menore que el número de parámetros anotados de la función.
    */
    "missing-parameter": "Warning",
    /*
    Habilita el diagnóstico para para funciones con anotaciones de retorno que no tienen la expresión `return …`.
    */
    "missing-return": "Warning",
    /*
    Habilita el diagnóstico para expresiones `return …` sin valores aunque la función que la contiene declare retornos.
    */
    "missing-return-value": "Warning",
    /*
    Habilita el diagnóstico para el estilo de nombres.
    */
    "name-style-check": "Warning",
    /*
    Habilita el diagnóstico para usos de variables si `nil` o un valor opcional (potencialmente `nil`) haya sido asignado a la variable anteriormente.
    */
    "need-check-nil": "Warning",
    /*
    Habilita el diagnóstico de campo nuevo en una llamada. Se alza un error cuando los paréntesis de una llamada a una función aparecen en la siguiente línea cuando se define un campo en una tabla.
    */
    "newfield-call": "Warning",
    /*
    Habilita el diagnóstico de llamadas en línea nueva. Se alza un error en las líneas que comienzan con `(`, lo que se lee sintácticamente como una llamada a la línea anterior.
    */
    "newline-call": "Warning",
    /*
    Habilita el diagnóstico para los casos en que el tipo no puede ser inferido.
    */
    "no-unknown": "Warning",
    /*
    Habilita el diagnóstico para llamadas a `coroutine.yield()` cuando no esté permitido.
    */
    "not-yieldable": "Warning",
    /*
    Habilita el diagnóstico para llamadas a funciones donde el tipo de un parámetro provisto no calza con el tipo de la definición anotado de la función.
    */
    "param-type-mismatch": "Warning",
    /*
    Habilita el diagnóstico de variables locals redefinidas.
    */
    "redefined-local": "Hint",
    /*
    Habilita el diagnóstico de parámetros redundantes de una función.
    */
    "redundant-parameter": "Warning",
    /*
    Habilita el diagnóstico para sentencias de retorno que no son necesarias porque la función terminaría de igual manera.
    */
    "redundant-return": "Hint",
    /*
    Habilita el diagnóstico para sentencias de retorno que retornan un valor extra que no fue especificado por una anotación de retorno.
    */
    "redundant-return-value": "Warning",
    /*
    Habilita el diagnóstico de valores asignados redundantemente. Se alza un error en una asignación, cuando el número de valores es mayor que el número de objetos a los cuales se les asigna.
    */
    "redundant-value": "Warning",
    /*
    Habilita el diagnóstico para valores retornados cuyo tipo no calza con el tipo declarado en la anotación correspondiente de la función.
    */
    "return-type-mismatch": "Warning",
    /*
    Habilita el diagnóstico para errores tipográficos en strings.
    */
    "spell-check": "Information",
    /*
    Habilita el diagnóstico de espacios al final de línea.
    */
    "trailing-space": "Hint",
    /*
    Habilita el diagnóstico para asignaciones múltiplies si no todas las variables obtienen un valor (por ejemplo, `local x,y = 1`).
    */
    "unbalanced-assignments": "Warning",
    /*
    Habilita el diagnóstico para las anotaciones de clase en las cuales una clase sin definir es referenciada.
    */
    "undefined-doc-class": "Warning",
    /*
    Habilita el diagnóstico para anotaciones de tipo que referencian a un tipo o alias sin definir.
    */
    "undefined-doc-name": "Warning",
    /*
    Habilita el diagnóstico para casos en que una anotación de parámetro es dado sin declarar el parámetro en la definición de la función.
    */
    "undefined-doc-param": "Warning",
    /*
    Habilita el diagnóstico de variables de ambientes sin definir. Se alza un error cuando a la tabla `_ENV` se le asigna una tabla literal nueva, pero la variable global usada no está presente en el ambiente global.
    */
    "undefined-env-child": "Information",
    /*
    Habilita el diagnóstico para los casos en que se lee un campo sin definir de una variable.
    */
    "undefined-field": "Warning",
    /*
    Habilita el diagnóstico de variables globales sin definir.
    */
    "undefined-global": "Warning",
    /*
    Habilita el diagnóstico para conversiones de tipo de variables sin definir.
    */
    "unknown-cast-variable": "Warning",
    /*
    Habilita el diagnóstico para los casos en que un código desconocido de diagnóstico es ingresado.
    */
    "unknown-diag-code": "Warning",
    /*
    Habilita el diagnóstico para operadores desconocidos.
    */
    "unknown-operator": "Warning",
    /*
    Habilita el diagnóstico para código inalcanzable.
    */
    "unreachable-code": "Hint",
    /*
    Habilita el diagnóstico funcines sin uso.
    */
    "unused-function": "Hint",
    /*
    Habilita el diagnóstico de etiquetas sin uso.
    */
    "unused-label": "Hint",
    /*
    Habilita el diagnóstico de variables local sin uso.
    */
    "unused-local": "Hint",
    /*
    Habilita el diagnóstico de expresión de número variable de argumentos (vararg) sin uso.
    */
    "unused-vararg": "Hint"
}
```

# diagnostics.unusedLocalExclude

Las variables que calcen con el siguiente patrón no se diagnostican con `unused-local`.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.workspaceDelay

Latencia en milisegundos para diagnósticos del espacio de trabajo.

## type

```ts
integer
```

## default

```jsonc
3000
```

# diagnostics.workspaceEvent

Fija el tiempo para lanzar los diagnósticos del espacio de trabajo.

## type

```ts
string
```

## enum

* ``"OnChange"``: Lanza los diagnósticos del espacio de trabajo cuando se cambie el archivo.
* ``"OnSave"``: Lanza los diagnósticos del espacio de trabajo cuando se guarde el archivo.
* ``"None"``: Deshabilita los diagnósticos del espacio de trabajo.

## default

```jsonc
"OnSave"
```

# diagnostics.workspaceRate

Tasa porcentual de diagnósticos del espacio de trabajo. Decremente este valor para reducir el uso de CPU, también reduciendo la velocidad de los diagnósticos del espacio de trabajo. El diagnóstico del archivo que esté editando siempre se hace a toda velocidad y no es afectado por esta configuración.

## type

```ts
integer
```

## default

```jsonc
100
```

# doc.packageName

Trata los nombres específicos de campo como del paquete. Por ejemplo `m_*` significa `XXX.m_id` y `XXX.m_tipo` son de paquete, por lo que solo pueden ser accedidos en el archivo donde son definidos.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.privateName

Trata los nombres específicos de campo como privados. Por ejemplo `m_*` significa `XXX.m_id` y `XXX.m_tipo` son privados, por lo que solo pueden ser accedidos donde se define la clase.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.protectedName

Trata los nombres específicos de campo como protegidos. Por ejemplo `m_*` significa `XXX.m_id` y `XXX.m_tipo` son privados, por lo que solo pueden ser accedidos donde se define la clase y sus subclases.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.regengine

Motor de expresiones regulares usado para coincidir nombres de ámbito de documentación.

## type

```ts
string
```

## enum

* ``"glob"``: Sintaxis de patrones ligera predeterminada.
* ``"lua"``: Expresiones regulares completas al estilo Lua.

## default

```jsonc
"glob"
```

# docScriptPath

Motor de expresiones regulares usado para coincidir nombres de ámbito de documentación.

## type

```ts
string
```

## default

```jsonc
""
```

# format.defaultConfig

La configuración de formateo predeterminada. Tiene menor prioridad que el archivo `.editorconfig`
en el espacio de trabajo.
Revise [la documentación del formateador](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)
para aprender más sobre su uso.


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# format.enable

Habilita el formateador de código.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.arrayIndex

Muestra las pistas de los índices de arreglos cuando se construye una tabla.

## type

```ts
string
```

## enum

* ``"Enable"``: Muestra las pistas en todas las tablas.
* ``"Auto"``: Muestra las pistas solo cuando la tabla tiene más de 3 ítemes, o cuando la tabla es mixta.
* ``"Disable"``: Deshabilita las pistas en de los índices de arreglos.

## default

```jsonc
"Auto"
```

# hint.await

Si la función que se llama está marcada con `---@async`, pregunta por un `await` en la llamada.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.awaitPropagate

Habilita la propagación de `await`. Cuando una función llama a una función marcada con `---@async`,se marcará automáticamente como `---@async`.

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.enable

Habilita pistas en línea.

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.paramName

Muestra las pistas de tipo en las llamadas a funciones.

## type

```ts
string
```

## enum

* ``"All"``: Se muestran odos los tipos de los parámetros.
* ``"Literal"``: Se muestran solo los parámetros de tipos literales.
* ``"Disable"``: Deshabilita las pistas de los parámetros.

## default

```jsonc
"All"
```

# hint.paramType

Muestra las pistas de tipo al parámetro de las funciones.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.semicolon

Si no hay punto y coma al final de la sentencia, despliega un punto y coma virtual.

## type

```ts
string
```

## enum

* ``"All"``: Todas las sentencias con un punto y coma virtual desplegado.
* ``"SameLine"``: Cuando dos sentencias están en la misma línea, despliega un punto y coma entre ellas.
* ``"Disable"``: Deshabilita punto y coma virtuales.

## default

```jsonc
"SameLine"
```

# hint.setType

Muestra las pistas de tipo en las asignación.

## type

```ts
boolean
```

## default

```jsonc
false
```

# hover.enable

Habilita la información bajo el cursor.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.enumsLimit

Cuando el valor corresponde a múltiples tipos, fija el límite de tipos en despliegue.

## type

```ts
integer
```

## default

```jsonc
5
```

# hover.expandAlias

Expandir o no los alias. Por ejemplo, la expansión de `---@alias miTipo boolean|number` aparece como `boolean|number`, caso contrarior, aparece como `miTipo`.


## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.previewFields

Cuando se ubica el cursor para ver una tabla, fija el máximo numero de previstas para los campos.

## type

```ts
integer
```

## default

```jsonc
10
```

# hover.viewNumber

Ubica el cursor para ver el contenido numérico (solo si el literal no es decimal).

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewString

Ubica el cursor bajo un string para ver su contenido (solo si el literal contiene un caracter de escape).

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewStringMax

Largo máximo de la información bajo el cursor para ver el contenido de un string.

## type

```ts
integer
```

## default

```jsonc
1000
```

# language.completeAnnotation

(Solo en VSCode) Inserta automáticamente un "---@ " después de un quiebre de línea que sucede a una anotación.

## type

```ts
boolean
```

## default

```jsonc
true
```

# language.fixIndent

(Solo en VSCode) Arregla la auto-indentación incorrecta, como aquella cuando los quiebres de línea ocurren dentro de un string que contengan la palabra "function".

## type

```ts
boolean
```

## default

```jsonc
true
```

# misc.executablePath

Especifica la ruta del ejecutable en VSCode.

## type

```ts
string
```

## default

```jsonc
""
```

# misc.parameters

[Parámetros de la línea de comando](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) para iniciar el servidor de lenguage en VSCode.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# nameStyle.config

Configuración de estilo para nombres.
Revise [la documentación del formateador](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)
para aprender más sobre su uso.


## type

```ts
Object<string, string | array>
```

## default

```jsonc
{}
```

# runtime.builtin

Ajuste de la habilitación de biblioteca interna provista. Puede deshabilitar (o redefinir) las bibliotecas inexistentes de acuerdo al ambiente de ejecución.

* `default`: Indica que la biblioteca será habilitada o deshabilitada de acuerdo a la versión que se ejecuta.
* `enable`: Habilitada
* `disable`: Deshabilitada


## type

```ts
object<string, string>
```

## enum

* ``"default"``
* ``"enable"``
* ``"disable"``

## default

```jsonc
{
    "basic": "default",
    "bit": "default",
    "bit32": "default",
    "builtin": "default",
    "coroutine": "default",
    "debug": "default",
    "ffi": "default",
    "io": "default",
    "jit": "default",
    "jit.profile": "default",
    "jit.util": "default",
    "math": "default",
    "os": "default",
    "package": "default",
    "string": "default",
    "string.buffer": "default",
    "table": "default",
    "table.clear": "default",
    "table.new": "default",
    "utf8": "default"
}
```

# runtime.enableLuaJITExtensions

Activa la sintaxis de extensión de LuaJIT (requiere que `Lua.runtime.version` esté establecido en `LuaJIT`).
Cada extensión también se puede habilitar individualmente mediante `Lua.runtime.nonstandardSymbol`.


## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.fileEncoding

Codificación de archivo. La opción `ansi` solo está disponible en la plataforma `Windows`.

## type

```ts
string
```

## enum

* ``"utf8"``
* ``"ansi"``
* ``"utf16le"``
* ``"utf16be"``

## default

```jsonc
"utf8"
```

# runtime.meta

Formato del nombre del directoria de los archivos meta.

## type

```ts
string
```

## default

```jsonc
"${version} ${language} ${encoding}"
```

# runtime.nonstandardSymbol

Soporte de símbolos no estándar. Asegúrese que la versión de Lua que se ejecuta soporte estos símbolos.

La sintaxis de extensión de LuaJIT 3.0 (`?.` `??` `?:` `~>>` `~>>=` `..=` `~=` `const` `->` `number_underscore`) también se puede habilitar individualmente aquí, sin requerir que `Lua.runtime.version` sea `LuaJIT`. Nota: `~=` solo actúa como asignación compuesta XOR en contexto de sentencia (p. ej. `a ~= b` en una línea); en expresiones sigue siendo el operador de desigualdad.


## type

```ts
Array<string>
```

## enum

* ``"//"``
* ``"/**/"``
* ``"`"``
* ``"+="``
* ``"-="``
* ``"*="``
* ``"/="``
* ``"%="``
* ``"^="``
* ``"//="``
* ``"|="``
* ``"&="``
* ``"<<="``
* ``">>="``
* ``"||"``
* ``"&&"``
* ``"!"``
* ``"!="``
* ``"continue"``
* ``"|lambda|"``
* ``"?."``: Navegación segura (`a?.b` / `a?.[k]` / `f?.()` / `obj?.:method()` / `obj:method?.()`).
* ``"??"``: Coalescencia nula (`a ?? b`; usa el lado derecho solo cuando el izquierdo es nil).
* ``"?:"``: Condicional ternario (`a ? b : c`, asociativo a la derecha).
* ``"~>>"``: Desplazamiento aritmético a la derecha (`a ~>> b`, específico de LuaJIT; `>>` normal es lógico).
* ``"~>>="``: Asignación compuesta de desplazamiento aritmético a la derecha (`a ~>>= b`).
* ``"..="``: Asignación compuesta de concatenación de cadenas (`a ..= b`).
* ``"~="``: Asignación compuesta XOR: solo en contexto de sentencia (p. ej. `a ~= b` en una línea); en expresiones sigue siendo el operador de desigualdad.
* ``"const"``: Declaración `const` (constante local de ámbito de bloque; no se puede reasignar ni redeclarar).
* ``"->"``: Flecha de función corta (`x -> expr` / `|x| -> expr` / `|| -> expr` / `-> do ... end`).
* ``"number_underscore"``: Guiones bajos en literales numéricos (p. ej. `1_000`, `0x1_2`, `0b1_0`).
* ``"?("``: Llamada opcional sin punto (`f?()` equivale a `f?.()`; entra en conflicto con el análisis del ternario `?:`, no recomendado juntos).
* ``"?["``: Índice opcional sin punto (`t?[1]` equivale a `t?.[1]`; entra en conflicto con el análisis del ternario `?:`, no recomendado juntos).

## default

```jsonc
[]
```

# runtime.path

Cuando se ocupa un `require`, cómo se encuentra el archivo basado en el nombre de entrada.

Asignar esta configuración a `?/init.lua` significa que cuando se ingresa `require 'myfile'` se busca en `${workspace}/myfile/init.lua` desde los archivos cargados.
Si `runtime.pathStrict` es `false`, también se busca en `${workspace}/**/myfile/init.lua`.
Si se desea cargar archivos fuera del espacio de trabajo, se debe asignar `Lua.workspace.library` primero.


## type

```ts
Array<string>
```

## default

```jsonc
["?.lua","?/init.lua"]
```

# runtime.pathStrict

Cuando está habilitado, `runtime.path` sólo buscará en el primer nivel de directorios, vea la descripción de `runtime.path`.

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.plugin

Ruta de plugin. Revise [la wiki](https://luals.github.io/wiki/plugins) para más información.

## type

```ts
string | array
```

## default

```jsonc
null
```

# runtime.pluginArgs

Argumentos adicionals al plugin.

## type

```ts
array | object
```

## default

```jsonc
null
```

# runtime.special

Las variables globales personalizadas son consideradas variables intrínsecas, y el servidor de lenguage proveerá un soporte especial.
El siguiente ejemplo muestra que 'include' es tratado como 'require'.
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# runtime.unicodeName

Se permiten los caracteres unicode en los nombres.

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.version

Versión de Lua que se ejecuta.

## type

```ts
string
```

## enum

* ``"Lua 5.1"``
* ``"Lua 5.2"``
* ``"Lua 5.3"``
* ``"Lua 5.4"``
* ``"Lua 5.5"``
* ``"LuaJIT"``

## default

```jsonc
"Lua 5.4"
```

# semantic.annotation

Coloración de las anotaciones de tipo.

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.enable

Habilita la coloración semántica. Puede ser necesario asignar `editor.semanticHighlighting.enabled`  a `true` para que tenga efecto.

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.keyword

Coloración semántica de palabras clave, literales y operadores. Se necesita habilitar esta característica si su editor no puede hacer coloración sintáctica.

## type

```ts
boolean
```

## default

```jsonc
false
```

# semantic.variable

Coloración semántica de variables, campos y parámetros.

## type

```ts
boolean
```

## default

```jsonc
true
```

# signatureHelp.enable

Habilita la ayuda de firma.

## type

```ts
boolean
```

## default

```jsonc
true
```

# spell.dict

Palabras extra para el corrector ortográfico.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# type.castNumberToInteger

Se permite asignar el tipo "número" al tipo "entero".

## type

```ts
boolean
```

## default

```jsonc
true
```

# type.checkTableShape

Chequea estrictamente la forma de la tabla.


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.inferParamType

Cuando un tipo de parámetro no está anotado, se infiere su tipo de los lugares donde la función es llamada.

Cuando esta configuración es `false`, el tipo del parámetro `any` cuando no puede ser anotado.


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.inferTableSize

Cantidad máxima de campos de tabla analizados durante la inferencia de tipos.

## type

```ts
integer
```

## default

```jsonc
10
```

# type.maxUnionVariants

**Missing description!!**

## type

```ts
integer
```

## default

```jsonc
0
```

# type.weakNilCheck

Cuando se revisa el tipo de un tipo de unión, los `nil` dentro son ignorados.

Cuando esta configuración es `false`, el tipo `number|nil` no puede ser asignado al tipo `number`. Solo se puede con `true`.


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.weakUnionCheck

Una vez que un sub-tipo de un tipo de unión satisface la condición, el tipo de unión también satisface la condición.

Cuando esta configuración es `false`, el tipo `number|boolean` no puede ser asignado al tipo `number`. Solo se puede con `true`.


## type

```ts
boolean
```

## default

```jsonc
false
```

# typeFormat.config

Configura el comportamiento del formateo mientras se tipea código Lua.

## type

```ts
object<string, string>
```

## default

```jsonc
{
    /*
    Controla si se completa automáticamente con `end` en las posiciones correspondientes.
    */
    "auto_complete_end": "true",
    /*
    Controla si se agrega automáticamente un separador al final de la declaración de una tabla.
    */
    "auto_complete_table_sep": "true",
    /*
    Controla si una línea se formatea
    */
    "format_line": "true"
}
```

# window.progressBar

Muestra la barra de progreso en la barra de estado.

## type

```ts
boolean
```

## default

```jsonc
true
```

# window.statusBar

Muestra el estado de la extensión en la barra de estado.

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.checkThirdParty

Detección y adaptación automática de bibliotecas externas. Actualmente soportadas:

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass


## type

```ts
string | boolean
```

## default

```jsonc
null
```

# workspace.ignoreDir

Directorios y archivos ignorados (se usa la misma gramática que en `.gitignore`)

## type

```ts
Array<string>
```

## default

```jsonc
[".vscode"]
```

# workspace.ignoreSubmodules

Ignora submódulos.

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.library

Además de los del espacio de trabajo actual, se cargan archivos de estos directorios. Los archivos en estos directorios serán tratados como bibliotecas con código externo y algunas características (como renombrar campos) no modificarán estos archivos.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# workspace.maxPreload

Máxima pre-carga de archivos.

## type

```ts
integer
```

## default

```jsonc
5000
```

# workspace.preloadFileSize

Cuando se pre-carga, se omiten los archivos más grandes que este valor (en KB).

## type

```ts
integer
```

## default

```jsonc
500
```

# workspace.useGitIgnore

Ignora los archivos enlistados en `gitignore` .

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.userThirdParty

Rutas archivos de configuración para bibliotecas externas privadas. Revise [el archivo de configuración](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd) provisto.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```