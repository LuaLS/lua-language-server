# addonManager.enable

Habilita ou desabilita o gerenciador de add-ons.

## type

```ts
boolean
```

## default

```jsonc
true
```

# addonManager.repositoryBranch

Define o branch Git usado pelo gerenciador de add-ons.

## type

```ts
string
```

## default

```jsonc
""
```

# addonManager.repositoryPath

Define o caminho Git usado pelo gerenciador de add-ons.

## type

```ts
string
```

## default

```jsonc
""
```

# addonRepositoryPath

Define o caminho do repositório de add-ons (não relacionado ao gerenciador de add-ons).

## type

```ts
string
```

## default

```jsonc
""
```

# codeLens.enable

Habilitar code lens.

## type

```ts
boolean
```

## default

```jsonc
false
```

# completion.autoRequire

Quando a entrada se parece com um nome de arquivo, fazer `require` desse arquivo automaticamente.

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.callSnippet

Mostra snippets de chamada de função.

## type

```ts
string
```

## enum

* ``"Disable"``: Mostra apenas o `nome da função`.
* ``"Both"``: Mostra o `nome da função` e o `trecho de chamada`.
* ``"Replace"``: Mostra apenas o `trecho de chamada`.

## default

```jsonc
"Disable"
```

# completion.displayContext

Pré-visualizar o trecho de código relevante da sugestão pode ajudar a entender seu uso. O número define quantas linhas são interceptadas no fragmento; definir como `0` desabilita este recurso.

## type

```ts
integer
```

## default

```jsonc
0
```

# completion.enable

Habilita autocompletar.

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.keywordSnippet

Mostra snippets de sintaxe de palavras-chave.

## type

```ts
string
```

## enum

* ``"Disable"``: Mostra apenas a `palavra-chave`.
* ``"Both"``: Mostra a `palavra-chave` e o `trecho de sintaxe`.
* ``"Replace"``: Mostra apenas o `trecho de sintaxe`.

## default

```jsonc
"Replace"
```

# completion.maxSuggestCount

Número máximo de campos analisados para autocompletar. Se um objeto tiver mais campos que esse limite, serão necessárias entradas mais específicas para que as sugestões apareçam.

## type

```ts
integer
```

## default

```jsonc
100
```

# completion.postfix

Símbolo usado para acionar sugestões de pós-fixo.

## type

```ts
string
```

## default

```jsonc
"@"
```

# completion.requireSeparator

Separador usado em `require`.

## type

```ts
string
```

## default

```jsonc
"."
```

# completion.showParams

Mostrar parâmetros na lista de conclusão. Se a função tiver várias definições, elas serão exibidas separadamente.

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.showWord

Mostrar palavras de contexto nas sugestões.

## type

```ts
string
```

## enum

* ``"Enable"``: Sempre mostrar palavras de contexto nas sugestões.
* ``"Fallback"``: Mostrar palavras de contexto somente quando não houver sugestões baseadas em semântica.
* ``"Disable"``: Não mostrar palavras de contexto.

## default

```jsonc
"Fallback"
```

# completion.workspaceWord

Define se as palavras de contexto exibidas incluem conteúdo de outros arquivos da workspace.

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.disable

Diagnósticos desabilitados (use o código nos colchetes do hover).

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

Habilita diagnósticos.

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

Variáveis globais definidas.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.globalsRegex

Encontra variáveis globais definidas usando regex.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.groupFileStatus

Modifica o status de arquivo necessário para diagnóstico em um grupo.

* Opened:  diagnosticar apenas arquivos abertos
* Any:     diagnosticar todos os arquivos
* None:    desabilitar este diagnóstico

`Fallback` significa que os diagnósticos deste grupo são controlados por `diagnostics.neededFileStatus` separadamente.
Outras configurações sobrescreverão configurações individuais sem terminar com `!`.


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

Modifica a gravidade do diagnóstico em um grupo.
`Fallback` significa que os diagnósticos deste grupo são controlados por `diagnostics.severity` separadamente.
Outras configurações sobrescreverão configurações individuais sem terminar com `!`.


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

Como diagnosticar arquivos ignorados.

## type

```ts
string
```

## enum

* ``"Enable"``: Sempre diagnosticar esses arquivos.
* ``"Opened"``: Diagnosticar esses arquivos apenas quando estiverem abertos.
* ``"Disable"``: Esses arquivos não são diagnosticados.

## default

```jsonc
"Opened"
```

# diagnostics.libraryFiles

Como diagnosticar arquivos carregados via `Lua.workspace.library`.

## type

```ts
string
```

## enum

* ``"Enable"``: Sempre diagnosticar esses arquivos.
* ``"Opened"``: Diagnosticar esses arquivos apenas quando estiverem abertos.
* ``"Disable"``: Esses arquivos não são diagnosticados.

## default

```jsonc
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  diagnosticar apenas arquivos abertos
* Any:     diagnosticar todos os arquivos
* None:    desabilitar este diagnóstico

Terminar com `!` significa sobrescrever a configuração de grupo `diagnostics.groupFileStatus`.


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
    Ambiguidade de precedência, por exemplo `num or 0 + 1`; supõe-se que o esperado seja `(num or 0) + 1`
    */
    "ambiguity-1": "Any",
    /*
    Habilita diagnóstico para atribuições em que o tipo do valor não corresponde ao tipo da variável alvo.
    */
    "assign-type-mismatch": "Opened",
    /*
    Habilita diagnóstico para chamadas de funções assíncronas dentro de uma função síncrona.
    */
    "await-in-sync": "None",
    /*
    Habilita diagnóstico para coerções de variáveis locais em que o tipo alvo não corresponde ao tipo definido.
    */
    "cast-local-type": "Opened",
    /*
    Habilita diagnóstico para coerções em que o tipo alvo não corresponde ao tipo inicial.
    */
    "cast-type-mismatch": "Opened",
    "circle-doc-class": "Any",
    /*
    Habilita diagnóstico para tentativas de fechar uma variável que não é objeto.
    */
    "close-non-object": "Any",
    /*
    Habilita diagnóstico para código após um `break` em um loop.
    */
    "code-after-break": "Opened",
    /*
    Habilita diagnóstico para linhas que violam o estilo de código.
    */
    "codestyle-check": "None",
    /*
    Habilita diagnóstico para laços `for` decrescentes que nunca atingem o limite porque são incrementados.
    */
    "count-down-loop": "Any",
    /*
    Habilita diagnóstico para APIs obsoletas.
    */
    "deprecated": "Any",
    /*
    Habilita diagnóstico para arquivos exigidos por dois caminhos diferentes.
    */
    "different-requires": "Any",
    /*
    Habilita diagnóstico para chamadas de funções anotadas com `---@nodiscard` quando os retornos são ignorados.
    */
    "discard-returns": "Any",
    /*
    Habilita diagnóstico para anotações de campo sem anotação de classe correspondente.
    */
    "doc-field-no-class": "Any",
    /*
    Habilita diagnóstico para nome de alias anotado duplicado.
    */
    "duplicate-doc-alias": "Any",
    /*
    Habilita diagnóstico para nome de campo anotado duplicado.
    */
    "duplicate-doc-field": "Any",
    /*
    Habilita diagnóstico para nome de parâmetro anotado duplicado.
    */
    "duplicate-doc-param": "Any",
    /*
    Índice duplicado em tabela literal
    */
    "duplicate-index": "Any",
    /*
    Habilita diagnóstico para definir o mesmo campo em uma classe mais de uma vez.
    */
    "duplicate-set-field": "Opened",
    /*
    Bloco vazio
    */
    "empty-block": "Opened",
    /*
    Habilita diagnóstico para avisar sobre elementos globais.
    */
    "global-element": "None",
    /*
    Não é possível usar variáveis globais (`_ENV` foi definido como `nil`)
    */
    "global-in-nil-env": "Any",
    /*
    Anotações @param ou @return incompletas para funções.
    */
    "incomplete-signature-doc": "None",
    "inject-field": "Opened",
    /*
    Habilita diagnóstico para acessos a campos invisíveis.
    */
    "invisible": "Any",
    /*
    Definição de variável global com inicial minúscula
    */
    "lowercase-global": "Any",
    "missing-fields": "Any",
    /*
    Faltam anotações para globais! Funções globais devem ter comentário e anotações para todos os parâmetros e retornos.
    */
    "missing-global-doc": "None",
    /*
    Faltam anotações para locais exportados! Funções locais exportadas devem ter comentário e anotações para todos os parâmetros e retornos.
    */
    "missing-local-export-doc": "None",
    /*
    Habilita diagnóstico para chamadas de função com menos argumentos que os parâmetros anotados.
    */
    "missing-parameter": "Any",
    /*
    Habilita diagnóstico para funções com anotação de retorno mas sem instrução return.
    */
    "missing-return": "Any",
    /*
    Habilita diagnóstico para retornos sem valores embora a função declare valores de retorno.
    */
    "missing-return-value": "Any",
    /*
    Habilita diagnóstico para estilo de nomes.
    */
    "name-style-check": "None",
    /*
    Habilita diagnóstico para uso de variável após ela receber `nil` ou valor opcional.
    */
    "need-check-nil": "Opened",
    /*
    Em uma tabela literal, faltou um separador entre duas linhas; foi interpretado como uma operação de índice
    */
    "newfield-call": "Any",
    /*
    Nova linha iniciando com `(` é analisada como chamada da linha anterior
    */
    "newline-call": "Any",
    /*
    Habilita diagnóstico para casos em que o tipo não pode ser inferido.
    */
    "no-unknown": "None",
    /*
    Habilita diagnóstico para chamadas de `coroutine.yield()` quando não permitido.
    */
    "not-yieldable": "None",
    /*
    Habilita diagnóstico para chamadas onde o tipo do parâmetro fornecido não corresponde à definição anotada.
    */
    "param-type-mismatch": "Opened",
    /*
    Variável local redefinida
    */
    "redefined-local": "Opened",
    /*
    Chamada de função com parâmetros em excesso
    */
    "redundant-parameter": "Any",
    /*
    Habilita diagnóstico para retornos desnecessários porque a função já terminaria.
    */
    "redundant-return": "Opened",
    /*
    Habilita diagnóstico para retornos que entregam valor extra não especificado na anotação.
    */
    "redundant-return-value": "Any",
    /*
    Em uma atribuição, há mais valores que variáveis-alvo
    */
    "redundant-value": "Any",
    /*
    Habilita diagnóstico para retornos cujo tipo não corresponde ao tipo declarado.
    */
    "return-type-mismatch": "Opened",
    /*
    Habilita diagnóstico para erros ortográficos em strings.
    */
    "spell-check": "None",
    /*
    Espaços à direita
    */
    "trailing-space": "Opened",
    /*
    Habilita diagnóstico em múltiplas atribuições se nem todas as variáveis recebem valor (ex.: `local x,y = 1`).
    */
    "unbalanced-assignments": "Any",
    /*
    Habilita diagnóstico para anotações de classe que fazem referência a classe indefinida.
    */
    "undefined-doc-class": "Any",
    /*
    Habilita diagnóstico para anotações de tipo que referenciam tipo ou alias indefinido.
    */
    "undefined-doc-name": "Any",
    /*
    Habilita diagnóstico para anotações de parâmetro sem declaração correspondente na função.
    */
    "undefined-doc-param": "Any",
    /*
    `_ENV` foi definido como nova tabela literal, mas a variável global acessada não está nela
    */
    "undefined-env-child": "Any",
    /*
    Habilita diagnóstico para leitura de campo indefinido de uma variável.
    */
    "undefined-field": "Opened",
    /*
    Variável global não definida
    */
    "undefined-global": "Any",
    /*
    Habilita diagnóstico para coerções de variáveis indefinidas.
    */
    "unknown-cast-variable": "Any",
    /*
    Habilita diagnóstico quando um código de diagnóstico desconhecido é informado.
    */
    "unknown-diag-code": "Any",
    /*
    Habilita diagnóstico para operadores desconhecidos.
    */
    "unknown-operator": "Any",
    /*
    Habilita diagnóstico para código inalcançável.
    */
    "unreachable-code": "Opened",
    /*
    Função não utilizada
    */
    "unused-function": "Opened",
    /*
    Rótulo não utilizado
    */
    "unused-label": "Opened",
    /*
    Variável local não utilizada
    */
    "unused-local": "Opened",
    /*
    Parâmetro vararg não utilizado
    */
    "unused-vararg": "Opened"
}
```

# diagnostics.severity

Modifica a gravidade do diagnóstico.

Terminar com `!` significa sobrescrever a configuração de grupo `diagnostics.groupSeverity`.


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
    Ambiguidade de precedência, por exemplo `num or 0 + 1`; supõe-se que o esperado seja `(num or 0) + 1`
    */
    "ambiguity-1": "Warning",
    /*
    Habilita diagnóstico para atribuições em que o tipo do valor não corresponde ao tipo da variável alvo.
    */
    "assign-type-mismatch": "Warning",
    /*
    Habilita diagnóstico para chamadas de funções assíncronas dentro de uma função síncrona.
    */
    "await-in-sync": "Warning",
    /*
    Habilita diagnóstico para coerções de variáveis locais em que o tipo alvo não corresponde ao tipo definido.
    */
    "cast-local-type": "Warning",
    /*
    Habilita diagnóstico para coerções em que o tipo alvo não corresponde ao tipo inicial.
    */
    "cast-type-mismatch": "Warning",
    "circle-doc-class": "Warning",
    /*
    Habilita diagnóstico para tentativas de fechar uma variável que não é objeto.
    */
    "close-non-object": "Warning",
    /*
    Habilita diagnóstico para código após um `break` em um loop.
    */
    "code-after-break": "Hint",
    /*
    Habilita diagnóstico para linhas que violam o estilo de código.
    */
    "codestyle-check": "Warning",
    /*
    Habilita diagnóstico para laços `for` decrescentes que nunca atingem o limite porque são incrementados.
    */
    "count-down-loop": "Warning",
    /*
    Habilita diagnóstico para APIs obsoletas.
    */
    "deprecated": "Warning",
    /*
    Habilita diagnóstico para arquivos exigidos por dois caminhos diferentes.
    */
    "different-requires": "Warning",
    /*
    Habilita diagnóstico para chamadas de funções anotadas com `---@nodiscard` quando os retornos são ignorados.
    */
    "discard-returns": "Warning",
    /*
    Habilita diagnóstico para anotações de campo sem anotação de classe correspondente.
    */
    "doc-field-no-class": "Warning",
    /*
    Habilita diagnóstico para nome de alias anotado duplicado.
    */
    "duplicate-doc-alias": "Warning",
    /*
    Habilita diagnóstico para nome de campo anotado duplicado.
    */
    "duplicate-doc-field": "Warning",
    /*
    Habilita diagnóstico para nome de parâmetro anotado duplicado.
    */
    "duplicate-doc-param": "Warning",
    /*
    Índice duplicado em tabela literal
    */
    "duplicate-index": "Warning",
    /*
    Habilita diagnóstico para definir o mesmo campo em uma classe mais de uma vez.
    */
    "duplicate-set-field": "Warning",
    /*
    Bloco vazio
    */
    "empty-block": "Hint",
    /*
    Habilita diagnóstico para avisar sobre elementos globais.
    */
    "global-element": "Warning",
    /*
    Não é possível usar variáveis globais (`_ENV` foi definido como `nil`)
    */
    "global-in-nil-env": "Warning",
    /*
    Anotações @param ou @return incompletas para funções.
    */
    "incomplete-signature-doc": "Warning",
    "inject-field": "Warning",
    /*
    Habilita diagnóstico para acessos a campos invisíveis.
    */
    "invisible": "Warning",
    /*
    Definição de variável global com inicial minúscula
    */
    "lowercase-global": "Information",
    "missing-fields": "Warning",
    /*
    Faltam anotações para globais! Funções globais devem ter comentário e anotações para todos os parâmetros e retornos.
    */
    "missing-global-doc": "Warning",
    /*
    Faltam anotações para locais exportados! Funções locais exportadas devem ter comentário e anotações para todos os parâmetros e retornos.
    */
    "missing-local-export-doc": "Warning",
    /*
    Habilita diagnóstico para chamadas de função com menos argumentos que os parâmetros anotados.
    */
    "missing-parameter": "Warning",
    /*
    Habilita diagnóstico para funções com anotação de retorno mas sem instrução return.
    */
    "missing-return": "Warning",
    /*
    Habilita diagnóstico para retornos sem valores embora a função declare valores de retorno.
    */
    "missing-return-value": "Warning",
    /*
    Habilita diagnóstico para estilo de nomes.
    */
    "name-style-check": "Warning",
    /*
    Habilita diagnóstico para uso de variável após ela receber `nil` ou valor opcional.
    */
    "need-check-nil": "Warning",
    /*
    Em uma tabela literal, faltou um separador entre duas linhas; foi interpretado como uma operação de índice
    */
    "newfield-call": "Warning",
    /*
    Nova linha iniciando com `(` é analisada como chamada da linha anterior
    */
    "newline-call": "Warning",
    /*
    Habilita diagnóstico para casos em que o tipo não pode ser inferido.
    */
    "no-unknown": "Warning",
    /*
    Habilita diagnóstico para chamadas de `coroutine.yield()` quando não permitido.
    */
    "not-yieldable": "Warning",
    /*
    Habilita diagnóstico para chamadas onde o tipo do parâmetro fornecido não corresponde à definição anotada.
    */
    "param-type-mismatch": "Warning",
    /*
    Variável local redefinida
    */
    "redefined-local": "Hint",
    /*
    Chamada de função com parâmetros em excesso
    */
    "redundant-parameter": "Warning",
    /*
    Habilita diagnóstico para retornos desnecessários porque a função já terminaria.
    */
    "redundant-return": "Hint",
    /*
    Habilita diagnóstico para retornos que entregam valor extra não especificado na anotação.
    */
    "redundant-return-value": "Warning",
    /*
    Em uma atribuição, há mais valores que variáveis-alvo
    */
    "redundant-value": "Warning",
    /*
    Habilita diagnóstico para retornos cujo tipo não corresponde ao tipo declarado.
    */
    "return-type-mismatch": "Warning",
    /*
    Habilita diagnóstico para erros ortográficos em strings.
    */
    "spell-check": "Information",
    /*
    Espaços à direita
    */
    "trailing-space": "Hint",
    /*
    Habilita diagnóstico em múltiplas atribuições se nem todas as variáveis recebem valor (ex.: `local x,y = 1`).
    */
    "unbalanced-assignments": "Warning",
    /*
    Habilita diagnóstico para anotações de classe que fazem referência a classe indefinida.
    */
    "undefined-doc-class": "Warning",
    /*
    Habilita diagnóstico para anotações de tipo que referenciam tipo ou alias indefinido.
    */
    "undefined-doc-name": "Warning",
    /*
    Habilita diagnóstico para anotações de parâmetro sem declaração correspondente na função.
    */
    "undefined-doc-param": "Warning",
    /*
    `_ENV` foi definido como nova tabela literal, mas a variável global acessada não está nela
    */
    "undefined-env-child": "Information",
    /*
    Habilita diagnóstico para leitura de campo indefinido de uma variável.
    */
    "undefined-field": "Warning",
    /*
    Variável global não definida
    */
    "undefined-global": "Warning",
    /*
    Habilita diagnóstico para coerções de variáveis indefinidas.
    */
    "unknown-cast-variable": "Warning",
    /*
    Habilita diagnóstico quando um código de diagnóstico desconhecido é informado.
    */
    "unknown-diag-code": "Warning",
    /*
    Habilita diagnóstico para operadores desconhecidos.
    */
    "unknown-operator": "Warning",
    /*
    Habilita diagnóstico para código inalcançável.
    */
    "unreachable-code": "Hint",
    /*
    Função não utilizada
    */
    "unused-function": "Hint",
    /*
    Rótulo não utilizado
    */
    "unused-label": "Hint",
    /*
    Variável local não utilizada
    */
    "unused-local": "Hint",
    /*
    Parâmetro vararg não utilizado
    */
    "unused-vararg": "Hint"
}
```

# diagnostics.unusedLocalExclude

Não diagnosticar `unused-local` quando o nome da variável corresponder ao padrão a seguir.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.workspaceDelay

Latência (milissegundos) para diagnósticos da workspace.

## type

```ts
integer
```

## default

```jsonc
3000
```

# diagnostics.workspaceEvent

Define quando acionar diagnósticos da workspace.

## type

```ts
string
```

## enum

* ``"OnChange"``: Aciona diagnósticos da workspace quando o arquivo é modificado.
* ``"OnSave"``: Aciona diagnósticos da workspace quando o arquivo é salvo.
* ``"None"``: Desabilita diagnósticos da workspace.

## default

```jsonc
"OnSave"
```

# diagnostics.workspaceRate

Taxa de execução dos diagnósticos da workspace (%). Diminuir este valor reduz o uso de CPU, mas também reduz a velocidade dos diagnósticos. O diagnóstico do arquivo que você está editando sempre é feito em velocidade total e não é afetado por esta configuração.

## type

```ts
integer
```

## default

```jsonc
100
```

# doc.packageName

Tratar nomes de campos específicos como de pacote; ex.: `m_*` significa que `XXX.m_id` e `XXX.m_type` são de pacote e só podem ser acessados no arquivo onde foram definidos.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.privateName

Tratar nomes de campos específicos como privados; ex.: `m_*` significa que `XXX.m_id` e `XXX.m_type` são privados e só podem ser acessados na classe onde foram definidos.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.protectedName

Tratar nomes de campos específicos como protegidos; ex.: `m_*` significa que `XXX.m_id` e `XXX.m_type` são protegidos e só podem ser acessados na classe onde foram definidos e em subclasses.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.regengine

Mecanismo de expressão regular usado para corresponder nomes de escopo de documentação.

## type

```ts
string
```

## enum

* ``"glob"``: Sintaxe de padrão leve padrão.
* ``"lua"``: Expressões regulares completas no estilo Lua.

## default

```jsonc
"glob"
```

# docScriptPath

Mecanismo de expressão regular usado para corresponder nomes de escopo de documentação.

## type

```ts
string
```

## default

```jsonc
""
```

# format.defaultConfig

Configuração de formatação padrão; tem prioridade menor que o arquivo `.editorconfig` da workspace.
Consulte a [documentação do formatador](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) para uso.


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# format.enable

Habilitar formatador de código.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.arrayIndex

Mostrar dicas de índice de array ao construir uma tabela.

## type

```ts
string
```

## enum

* ``"Enable"``: Mostrar dicas em todas as tabelas.
* ``"Auto"``: Mostrar dicas apenas quando a tabela tiver mais de 3 itens ou for uma tabela mista.
* ``"Disable"``: Desativar dicas de índice de array.

## default

```jsonc
"Auto"
```

# hint.await

Se a função chamada estiver marcada com `---@async`, sugerir `await` na chamada.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.awaitPropagate

Habilita a propagação de `await`. Quando uma função chama outra marcada com `---@async`, ela será automaticamente marcada como `---@async`.

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.enable

Habilitar inlay hints.

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.paramName

Mostrar dicas com o nome do parâmetro na chamada de função.

## type

```ts
string
```

## enum

* ``"All"``: Mostrar todos os tipos de parâmetros.
* ``"Literal"``: Mostrar apenas parâmetros de tipo literal.
* ``"Disable"``: Desativar dicas de nome de parâmetro.

## default

```jsonc
"All"
```

# hint.paramType

Mostrar dicas de tipo nos parâmetros da função.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.semicolon

Se não houver ponto e vírgula no fim da instrução, mostrar um ponto e vírgula virtual.

## type

```ts
string
```

## enum

* ``"All"``: Todas as instruções exibem ponto e vírgula virtual.
* ``"SameLine"``: Quando duas instruções estiverem na mesma linha, mostrar um ponto e vírgula entre elas.
* ``"Disable"``: Desativar pontos e vírgulas virtuais.

## default

```jsonc
"SameLine"
```

# hint.setType

Mostrar dicas de tipo em atribuições.

## type

```ts
boolean
```

## default

```jsonc
false
```

# hover.enable

Habilitar hover.

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.enumsLimit

Quando um valor corresponde a vários tipos, limita quantos tipos são exibidos.

## type

```ts
integer
```

## default

```jsonc
5
```

# hover.expandAlias

Definir se aliases devem ser expandidos. Por exemplo, `---@alias myType boolean|number` aparecerá como `boolean|number`; caso contrário aparecerá como `myType`.


## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.previewFields

Ao inspecionar uma tabela, limita o número máximo de campos pré-visualizados.

## type

```ts
integer
```

## default

```jsonc
10
```

# hover.viewNumber

No hover, mostrar conteúdo numérico (apenas se o literal não for decimal).

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewString

No hover, mostrar o conteúdo da string (apenas se o literal tiver caracteres de escape).

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewStringMax

Comprimento máximo da string exibida no hover.

## type

```ts
integer
```

## default

```jsonc
1000
```

# language.completeAnnotation

(Somente VSCode) Insere automaticamente "---@ " após uma quebra de linha seguinte a uma anotação.

## type

```ts
boolean
```

## default

```jsonc
true
```

# language.fixIndent

(Somente VSCode) Corrige indentação automática incorreta, como quebras de linha dentro de uma string contendo a palavra "function".

## type

```ts
boolean
```

## default

```jsonc
true
```

# misc.executablePath

Especifica o caminho do executável no VSCode.

## type

```ts
string
```

## default

```jsonc
""
```

# misc.parameters

[Parâmetros de linha de comando](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) ao iniciar o serviço de linguagem no VSCode.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# nameStyle.config

Configurações de estilo de nomes.
Consulte a [documentação do formatador](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) para uso.


## type

```ts
Object<string, string | array>
```

## default

```jsonc
{}
```

# runtime.builtin

Ajusta o estado de habilitação das bibliotecas internas. Você pode desabilitar (ou redefinir) bibliotecas inexistentes conforme o ambiente de execução real.

* `default`: a biblioteca será habilitada ou desabilitada conforme a versão do runtime
* `enable`: sempre habilitar
* `disable`: sempre desabilitar


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

Ativa a sintaxe de extensão do LuaJIT (requer que `Lua.runtime.version` esteja definido como `LuaJIT`).
Cada extensão também pode ser habilitada individualmente via `Lua.runtime.nonstandardSymbol`.


## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.fileEncoding

Codificação de arquivo. A opção `ansi` está disponível apenas na plataforma `Windows`.

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

Formato do nome do diretório dos arquivos meta.

## type

```ts
string
```

## default

```jsonc
"${version} ${language} ${encoding}"
```

# runtime.nonstandardSymbol

Suporta símbolos não-padrão. Certifique-se de que seu ambiente de runtime suporta esses símbolos.

A sintaxe de extensão do LuaJIT 3.0 (`?.` `??` `?:` `~>>` `~>>=` `..=` `~=` `const` `->` `number_underscore`) também pode ser habilitada individualmente aqui, sem exigir que `Lua.runtime.version` seja `LuaJIT`. Nota: `~=` só atua como atribuição composta XOR em contexto de declaração (ex.: `a ~= b` em uma linha); em expressões continua sendo o operador de desigualdade.


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
* ``"?."``: Navegação segura (`a?.b` / `a?.[k]` / `f?.()` / `obj?.:method()` / `obj:method?.()`).
* ``"??"``: Coalescência nula (`a ?? b`; usa o lado direito apenas quando o esquerdo é nil).
* ``"?:"``: Condicional ternário (`a ? b : c`, associativo à direita).
* ``"~>>"``: Deslocamento aritmético à direita (`a ~>> b`, específico do LuaJIT; `>>` normal é lógico).
* ``"~>>="``: Atribuição composta de deslocamento aritmético à direita (`a ~>>= b`).
* ``"..="``: Atribuição composta de concatenação de strings (`a ..= b`).
* ``"~="``: Atribuição composta XOR: apenas em contexto de declaração (ex.: `a ~= b` em uma linha); em expressões continua sendo o operador de desigualdade.
* ``"const"``: Declaração `const` (constante local de escopo de bloco; não pode ser reatribuída nem redeclarada).
* ``"->"``: Seta de função curta (`x -> expr` / `|x| -> expr` / `|| -> expr` / `-> do ... end`).
* ``"number_underscore"``: Sublinhado em literais numéricos (ex.: `1_000`, `0x1_2`, `0b1_0`).

## default

```jsonc
[]
```

# runtime.path

Ao usar `require`, define como encontrar o arquivo baseado no nome fornecido.
Definir esta configuração como `?/init.lua` significa que ao executar `require 'myfile'`, será buscado `${workspace}/myfile/init.lua` nos arquivos carregados.
Se `runtime.pathStrict` for `false`, `${workspace}/**/myfile/init.lua` também será buscado.
Para carregar arquivos fora da workspace, primeiro configure `Lua.workspace.library`.


## type

```ts
Array<string>
```

## default

```jsonc
["?.lua","?/init.lua"]
```

# runtime.pathStrict

Quando habilitado, `runtime.path` buscará apenas o primeiro nível de diretórios; veja a descrição de `runtime.path`.

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.plugin

Caminho do plugin. Leia a [wiki](https://luals.github.io/wiki/plugins) para saber mais.

## type

```ts
string | array
```

## default

```jsonc
null
```

# runtime.pluginArgs

Argumentos adicionais para o plugin.

## type

```ts
array | object
```

## default

```jsonc
null
```

# runtime.special

Variáveis globais personalizadas são tratadas como variáveis especiais internas, e o servidor fornecerá suporte especial.
O exemplo a seguir mostra que 'include' é tratado como 'require'.
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

Permite caracteres Unicode em nomes.

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.version

Versão do runtime Lua.

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

Colorização semântica de anotações de tipo.

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.enable

Habilita colorização semântica. Pode ser necessário definir `editor.semanticHighlighting.enabled` como `true`.

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.keyword

Colorização semântica de palavras-chave/literais/operadores. Só habilite se seu editor não oferecer colorização sintática.

## type

```ts
boolean
```

## default

```jsonc
false
```

# semantic.variable

Colorização semântica de variáveis/campos/parâmetros.

## type

```ts
boolean
```

## default

```jsonc
true
```

# signatureHelp.enable

Habilitar ajuda de assinatura.

## type

```ts
boolean
```

## default

```jsonc
true
```

# spell.dict

Palavras personalizadas para verificação ortográfica.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# type.castNumberToInteger

Permitir atribuir o tipo `number` ao tipo `integer`.

## type

```ts
boolean
```

## default

```jsonc
true
```

# type.checkTableShape

Verificação rigorosa do formato das tabelas.


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.inferParamType

Quando o parâmetro não tiver anotação, inferir o tipo a partir dos argumentos de chamada.

Quando esta opção for `false`, o tipo do parâmetro será `any` se não houver anotação.


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.inferTableSize

Número máximo de campos de tabela analisados durante a inferência de tipo.

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

Ao verificar um tipo união, ignora o `nil` presente nele.

Quando esta opção for `false`, `number|nil` não pode ser atribuído a `number`; com `true`, pode.


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.weakUnionCheck

Quando um subtipo de uma união atende à condição, considera-se que a união inteira atende.

Quando esta opção for `false`, `number|boolean` não pode ser atribuído a `number`; com `true`, pode.


## type

```ts
boolean
```

## default

```jsonc
false
```

# typeFormat.config

Configura o comportamento de formatação enquanto digita código Lua.

## type

```ts
object<string, string>
```

## default

```jsonc
{
    /*
    Controla se `end` é completado automaticamente em posições adequadas.
    */
    "auto_complete_end": "true",
    /*
    Controla se um separador é adicionado automaticamente ao final de uma declaração de tabela.
    */
    "auto_complete_table_sep": "true",
    /*
    Controla se uma linha deve ser formatada.
    */
    "format_line": "true"
}
```

# window.progressBar

Mostrar barra de progresso na barra de status.

## type

```ts
boolean
```

## default

```jsonc
true
```

# window.statusBar

Mostrar status da extensão na barra de status.

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.checkThirdParty

Detecção e adaptação automáticas de bibliotecas de terceiros; atualmente suportadas:

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

Arquivos e diretórios ignorados (usa sintaxe `.gitignore`).

## type

```ts
Array<string>
```

## default

```jsonc
[".vscode"]
```

# workspace.ignoreSubmodules

Ignorar submódulos.

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.library

Além da workspace atual, de quais diretórios carregar arquivos. Os arquivos nesses diretórios serão tratados como bibliotecas de código externas, e alguns recursos (como renomear campos) não modificarão esses arquivos.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# workspace.maxPreload

Número máximo de arquivos pré-carregados.

## type

```ts
integer
```

## default

```jsonc
5000
```

# workspace.preloadFileSize

Ignorar arquivos maiores que este valor (KB) ao pré-carregar.

## type

```ts
integer
```

## default

```jsonc
500
```

# workspace.useGitIgnore

Ignorar lista de arquivos em `.gitignore`.

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.userThirdParty

Adicione aqui caminhos de configuração de bibliotecas de terceiros privadas; consulte o [caminho de configuração](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd) embutido.

## type

```ts
Array<string>
```

## default

```jsonc
[]
```