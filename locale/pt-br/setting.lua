---@diagnostic disable: undefined-global

config.addonManager.enable        =
"Habilita ou desabilita o gerenciador de add-ons."
config.addonManager.repositoryBranch =
"Define o branch Git usado pelo gerenciador de add-ons."
config.addonManager.repositoryPath =
"Define o caminho Git usado pelo gerenciador de add-ons."
config.addonRepositoryPath        =
"Define o caminho do repositório de add-ons (não relacionado ao gerenciador de add-ons)."
config.runtime.version            =
"Versão do runtime Lua."
config.runtime.path               =
[[
Ao usar `require`, define como encontrar o arquivo baseado no nome fornecido.
Definir esta configuração como `?/init.lua` significa que ao executar `require 'myfile'`, será buscado `${workspace}/myfile/init.lua` nos arquivos carregados.
Se `runtime.pathStrict` for `false`, `${workspace}/**/myfile/init.lua` também será buscado.
Para carregar arquivos fora da workspace, primeiro configure `Lua.workspace.library`.
]]
config.runtime.pathStrict         =
'Quando habilitado, `runtime.path` buscará apenas o primeiro nível de diretórios; veja a descrição de `runtime.path`.'
config.runtime.special            =
[[Variáveis globais personalizadas são tratadas como variáveis especiais internas, e o servidor fornecerá suporte especial.
O exemplo a seguir mostra que 'include' é tratado como 'require'.
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```
]]
config.runtime.unicodeName        =
"Permite caracteres Unicode em nomes."
config.runtime.nonstandardSymbol  =
"Suporta símbolos não-padrão. Certifique-se de que seu ambiente de runtime suporta esses símbolos."
config.runtime.plugin             =
"Caminho do plugin. Leia a [wiki](https://luals.github.io/wiki/plugins) para saber mais."
config.runtime.pluginArgs         =
"Argumentos adicionais para o plugin."
config.runtime.fileEncoding       =
"Codificação de arquivo. A opção `ansi` está disponível apenas na plataforma `Windows`."
config.runtime.builtin            =
[[
Ajusta o estado de habilitação das bibliotecas internas. Você pode desabilitar (ou redefinir) bibliotecas inexistentes conforme o ambiente de execução real.

* `default`: a biblioteca será habilitada ou desabilitada conforme a versão do runtime
* `enable`: sempre habilitar
* `disable`: sempre desabilitar
]]
config.runtime.meta               =
'Formato do nome do diretório dos arquivos meta.'
config.diagnostics.enable         =
"Habilita diagnósticos."
config.diagnostics.disable        =
"Diagnósticos desabilitados (use o código nos colchetes do hover)."
config.diagnostics.globals        =
"Variáveis globais definidas."
config.diagnostics.globalsRegex   =
"Encontra variáveis globais definidas usando regex."
config.diagnostics.severity       =
[[
Modifica a gravidade do diagnóstico.

Terminar com `!` significa sobrescrever a configuração de grupo `diagnostics.groupSeverity`.
]]
config.diagnostics.neededFileStatus =
[[
* Opened:  diagnosticar apenas arquivos abertos
* Any:     diagnosticar todos os arquivos
* None:    desabilitar este diagnóstico

Terminar com `!` significa sobrescrever a configuração de grupo `diagnostics.groupFileStatus`.
]]
config.diagnostics.groupSeverity  =
[[
Modifica a gravidade do diagnóstico em um grupo.
`Fallback` significa que os diagnósticos deste grupo são controlados por `diagnostics.severity` separadamente.
Outras configurações sobrescreverão configurações individuais sem terminar com `!`.
]]
config.diagnostics.groupFileStatus =
[[
Modifica o status de arquivo necessário para diagnóstico em um grupo.

* Opened:  diagnosticar apenas arquivos abertos
* Any:     diagnosticar todos os arquivos
* None:    desabilitar este diagnóstico

`Fallback` significa que os diagnósticos deste grupo são controlados por `diagnostics.neededFileStatus` separadamente.
Outras configurações sobrescreverão configurações individuais sem terminar com `!`.
]]
config.diagnostics.workspaceEvent =
"Define quando acionar diagnósticos da workspace."
config.diagnostics.workspaceEvent.OnChange =
"Aciona diagnósticos da workspace quando o arquivo é modificado."
config.diagnostics.workspaceEvent.OnSave =
"Aciona diagnósticos da workspace quando o arquivo é salvo."
config.diagnostics.workspaceEvent.None =
"Desabilita diagnósticos da workspace."
config.diagnostics.workspaceDelay =
"Latência (milissegundos) para diagnósticos da workspace."
config.diagnostics.workspaceRate  =
"Taxa de execução dos diagnósticos da workspace (%). Diminuir este valor reduz o uso de CPU, mas também reduz a velocidade dos diagnósticos. O diagnóstico do arquivo que você está editando sempre é feito em velocidade total e não é afetado por esta configuração."
config.diagnostics.libraryFiles   =
"Como diagnosticar arquivos carregados via `Lua.workspace.library`."
config.diagnostics.libraryFiles.Enable   =
"Sempre diagnosticar esses arquivos."
config.diagnostics.libraryFiles.Opened   =
"Diagnosticar esses arquivos apenas quando estiverem abertos."
config.diagnostics.libraryFiles.Disable  =
"Esses arquivos não são diagnosticados."
config.diagnostics.ignoredFiles   =
"Como diagnosticar arquivos ignorados."
config.diagnostics.ignoredFiles.Enable   =
"Sempre diagnosticar esses arquivos."
config.diagnostics.ignoredFiles.Opened   =
"Diagnosticar esses arquivos apenas quando estiverem abertos."
config.diagnostics.ignoredFiles.Disable  =
"Esses arquivos não são diagnosticados."
config.diagnostics.disableScheme  =
'Não diagnosticar arquivos Lua que usam os seguintes schemes.'
config.diagnostics.validScheme  =
'Habilita diagnósticos para arquivos Lua que usam os seguintes schemes.'
config.diagnostics.unusedLocalExclude =
'Não diagnosticar `unused-local` quando o nome da variável corresponder ao padrão a seguir.'
config.diagnostics.validScheme  =
'Habilita diagnósticos para arquivos Lua que usam os seguintes schemes.'
config.workspace.ignoreDir        =
"Arquivos e diretórios ignorados (usa sintaxe `.gitignore`)."-- .. example.ignoreDir,
config.workspace.ignoreSubmodules =
"Ignorar submódulos."
config.workspace.useGitIgnore     =
"Ignorar lista de arquivos em `.gitignore`."
config.workspace.maxPreload       =
"Número máximo de arquivos pré-carregados."
config.workspace.preloadFileSize  =
"Ignorar arquivos maiores que este valor (KB) ao pré-carregar."
config.workspace.library          =
"Além da workspace atual, de quais diretórios carregar arquivos. Os arquivos nesses diretórios serão tratados como bibliotecas de código externas, e alguns recursos (como renomear campos) não modificarão esses arquivos."
config.workspace.checkThirdParty  =
[[
Detecção e adaptação automáticas de bibliotecas de terceiros; atualmente suportadas:

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]]
config.workspace.userThirdParty          =
'Adicione aqui caminhos de configuração de bibliotecas de terceiros privadas; consulte o [caminho de configuração](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd) embutido.'
config.workspace.supportScheme           =
'Fornece language server para arquivos Lua dos seguintes schemes.'
config.completion.enable                 =
'Habilita autocompletar.'
config.completion.callSnippet            =
'Mostra snippets de chamada de função.'
config.completion.callSnippet.Disable    =
"Mostra apenas o `nome da função`."
config.completion.callSnippet.Both       =
"Mostra o `nome da função` e o `trecho de chamada`."
config.completion.callSnippet.Replace    =
"Mostra apenas o `trecho de chamada`."
config.completion.keywordSnippet         =
'Mostra snippets de sintaxe de palavras-chave.'
config.completion.keywordSnippet.Disable =
"Mostra apenas a `palavra-chave`."
config.completion.keywordSnippet.Both    =
"Mostra a `palavra-chave` e o `trecho de sintaxe`."
config.completion.keywordSnippet.Replace =
"Mostra apenas o `trecho de sintaxe`."
config.completion.displayContext         =
"Pré-visualizar o trecho de código relevante da sugestão pode ajudar a entender seu uso. O número define quantas linhas são interceptadas no fragmento; definir como `0` desabilita este recurso."
config.completion.workspaceWord          =
"Define se as palavras de contexto exibidas incluem conteúdo de outros arquivos da workspace."
config.completion.showWord               =
"Mostrar palavras de contexto nas sugestões."
config.completion.showWord.Enable        =
"Sempre mostrar palavras de contexto nas sugestões."
config.completion.showWord.Fallback      =
"Mostrar palavras de contexto somente quando não houver sugestões baseadas em semântica."
config.completion.showWord.Disable       =
"Não mostrar palavras de contexto."
config.completion.autoRequire            =
"Quando a entrada se parece com um nome de arquivo, fazer `require` desse arquivo automaticamente."
config.completion.maxSuggestCount        =
"Número máximo de campos analisados para autocompletar. Se um objeto tiver mais campos que esse limite, serão necessárias entradas mais específicas para que as sugestões apareçam."
config.completion.showParams             =
"Mostrar parâmetros na lista de conclusão. Se a função tiver várias definições, elas serão exibidas separadamente."
config.completion.requireSeparator       =
"Separador usado em `require`."
config.completion.postfix                =
"Símbolo usado para acionar sugestões de pós-fixo."
config.color.mode                        =
"Modo de colorização."
config.color.mode.Semantic               =
"Colorização semântica. Pode ser necessário definir `editor.semanticHighlighting.enabled` como `true`."
config.color.mode.SemanticEnhanced       =
"Colorização semântica aprimorada; semelhante a `Semantic`, mas com análise extra (mais custosa computacionalmente)."
config.color.mode.Grammar                =
"Colorização sintática."
config.semantic.enable                   =
"Habilita colorização semântica. Pode ser necessário definir `editor.semanticHighlighting.enabled` como `true`."
config.semantic.variable                 =
"Colorização semântica de variáveis/campos/parâmetros."
config.semantic.annotation               =
"Colorização semântica de anotações de tipo."
config.semantic.keyword                  =
"Colorização semântica de palavras-chave/literais/operadores. Só habilite se seu editor não oferecer colorização sintática."
config.signatureHelp.enable              =
"Habilitar ajuda de assinatura."
config.hover.enable                      =
"Habilitar hover."
config.hover.viewString                  =
"No hover, mostrar o conteúdo da string (apenas se o literal tiver caracteres de escape)."
config.hover.viewStringMax               =
"Comprimento máximo da string exibida no hover."
config.hover.viewNumber                  =
"No hover, mostrar conteúdo numérico (apenas se o literal não for decimal)."
config.hover.fieldInfer                  =
"Ao inspecionar uma tabela no hover, inferir o tipo de cada campo; se o tempo acumulado atingir o limite (ms), os campos restantes serão ignorados."
config.hover.previewFields               =
"Ao inspecionar uma tabela, limita o número máximo de campos pré-visualizados."
config.hover.enumsLimit                  =
"Quando um valor corresponde a vários tipos, limita quantos tipos são exibidos."
config.hover.expandAlias                 =
[[
Definir se aliases devem ser expandidos. Por exemplo, `---@alias myType boolean|number` aparecerá como `boolean|number`; caso contrário aparecerá como `myType`.
]]
config.develop.enable                    =
'Modo desenvolvedor. Não habilite; afeta o desempenho.'
config.develop.debuggerPort              =
'Porta de escuta do depurador.'
config.develop.debuggerWait              =
'Suspender antes de o depurador conectar.'
config.intelliSense.searchDepth          =
'Define a profundidade de busca do IntelliSense. Aumentar melhora a precisão, mas reduz o desempenho. Ajuste conforme a tolerância da sua workspace.'
config.intelliSense.fastGlobal           =
'Para completar globais e inspecionar `_G`, prioriza desempenho (ligeira perda de precisão de tipo); útil em projetos com muitas variáveis globais.'
config.window.statusBar                  =
'Mostrar status da extensão na barra de status.'
config.window.progressBar                =
'Mostrar barra de progresso na barra de status.'
config.hint.enable                       =
'Habilitar inlay hints.'
config.hint.paramType                    =
'Mostrar dicas de tipo nos parâmetros da função.'
config.hint.setType                      =
'Mostrar dicas de tipo em atribuições.'
config.hint.paramName                    =
'Mostrar dicas com o nome do parâmetro na chamada de função.'
config.hint.paramName.All                =
'Mostrar todos os tipos de parâmetros.'
config.hint.paramName.Literal            =
'Mostrar apenas parâmetros de tipo literal.'
config.hint.paramName.Disable            =
'Desativar dicas de nome de parâmetro.'
config.hint.arrayIndex                   =
'Mostrar dicas de índice de array ao construir uma tabela.'
config.hint.arrayIndex.Enable            =
'Mostrar dicas em todas as tabelas.'
config.hint.arrayIndex.Auto              =
'Mostrar dicas apenas quando a tabela tiver mais de 3 itens ou for uma tabela mista.'
config.hint.arrayIndex.Disable           =
'Desativar dicas de índice de array.'
config.hint.await                        =
'Se a função chamada estiver marcada com `---@async`, sugerir `await` na chamada.'
config.hint.awaitPropagate               =
'Habilita a propagação de `await`. Quando uma função chama outra marcada com `---@async`, ela será automaticamente marcada como `---@async`.'
config.hint.semicolon                    =
'Se não houver ponto e vírgula no fim da instrução, mostrar um ponto e vírgula virtual.'
config.hint.semicolon.All                =
'Todas as instruções exibem ponto e vírgula virtual.'
config.hint.semicolon.SameLine            =
'Quando duas instruções estiverem na mesma linha, mostrar um ponto e vírgula entre elas.'
config.hint.semicolon.Disable            =
'Desativar pontos e vírgulas virtuais.'
config.codeLens.enable                   =
'Habilitar code lens.'
config.format.enable                     =
'Habilitar formatador de código.'
config.format.defaultConfig              =
[[
Configuração de formatação padrão; tem prioridade menor que o arquivo `.editorconfig` da workspace.
Consulte a [documentação do formatador](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) para uso.
]]
config.spell.dict                        =
'Palavras personalizadas para verificação ortográfica.'
config.nameStyle.config                  =
[[
Configurações de estilo de nomes.
Consulte a [documentação do formatador](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) para uso.
]]
config.telemetry.enable                  =
[[
Habilita telemetria para enviar informações do editor e logs de erro pela rede. Leia nossa política de privacidade [aqui](https://luals.github.io/privacy/#language-server).
]]
config.misc.parameters                   =
'[Parâmetros de linha de comando](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) ao iniciar o serviço de linguagem no VSCode.'
config.misc.executablePath               =
'Especifica o caminho do executável no VSCode.'
config.language.fixIndent                =
'(Somente VSCode) Corrige indentação automática incorreta, como quebras de linha dentro de uma string contendo a palavra "function".'
config.language.completeAnnotation       =
'(Somente VSCode) Insere automaticamente "---@ " após uma quebra de linha seguinte a uma anotação.'
config.type.castNumberToInteger          =
'Permitir atribuir o tipo `number` ao tipo `integer`.'
config.type.weakUnionCheck               =
[[
Quando um subtipo de uma união atende à condição, considera-se que a união inteira atende.

Quando esta opção for `false`, `number|boolean` não pode ser atribuído a `number`; com `true`, pode.
]]
config.type.weakNilCheck                 =
[[
Ao verificar um tipo união, ignora o `nil` presente nele.

Quando esta opção for `false`, `number|nil` não pode ser atribuído a `number`; com `true`, pode.
]]
config.type.inferParamType               =
[[
Quando o parâmetro não tiver anotação, inferir o tipo a partir dos argumentos de chamada.

Quando esta opção for `false`, o tipo do parâmetro será `any` se não houver anotação.
]]
config.type.checkTableShape              =
[[
Verificação rigorosa do formato das tabelas.
]]
config.type.inferTableSize               =
'Número máximo de campos de tabela analisados durante a inferência de tipo.'
config.doc.privateName                   =
'Tratar nomes de campos específicos como privados; ex.: `m_*` significa que `XXX.m_id` e `XXX.m_type` são privados e só podem ser acessados na classe onde foram definidos.'
config.doc.protectedName                 =
'Tratar nomes de campos específicos como protegidos; ex.: `m_*` significa que `XXX.m_id` e `XXX.m_type` são protegidos e só podem ser acessados na classe onde foram definidos e em subclasses.'
config.doc.packageName                   =
'Tratar nomes de campos específicos como de pacote; ex.: `m_*` significa que `XXX.m_id` e `XXX.m_type` são de pacote e só podem ser acessados no arquivo onde foram definidos.'
config.doc.regengine                     =
'Mecanismo de expressão regular usado para corresponder nomes de escopo de documentação.'
config.doc.regengine.glob                =
'Sintaxe de padrão leve padrão.'
config.doc.regengine.lua                 =
'Expressões regulares completas no estilo Lua.'
config.docScriptPath                     =
'Mecanismo de expressão regular usado para corresponder nomes de escopo de documentação.'
config.diagnostics['unused-local']          =
'Variável local não utilizada'
config.diagnostics['unused-function']       =
'Função não utilizada'
config.diagnostics['undefined-global']      =
'Variável global não definida'
config.diagnostics['global-in-nil-env']     =
'Não é possível usar variáveis globais (`_ENV` foi definido como `nil`)'
config.diagnostics['unused-label']          =
'Rótulo não utilizado'
config.diagnostics['unused-vararg']         =
'Parâmetro vararg não utilizado'
config.diagnostics['trailing-space']        =
'Espaços à direita'
config.diagnostics['redefined-local']       =
'Variável local redefinida'
config.diagnostics['newline-call']          =
'Nova linha iniciando com `(` é analisada como chamada da linha anterior'
config.diagnostics['newfield-call']         =
'Em uma tabela literal, faltou um separador entre duas linhas; foi interpretado como uma operação de índice'
config.diagnostics['redundant-parameter']   =
'Chamada de função com parâmetros em excesso'
config.diagnostics['ambiguity-1']           =
'Ambiguidade de precedência, por exemplo `num or 0 + 1`; supõe-se que o esperado seja `(num or 0) + 1`'
config.diagnostics['lowercase-global']      =
'Definição de variável global com inicial minúscula'
config.diagnostics['undefined-env-child']   =
'`_ENV` foi definido como nova tabela literal, mas a variável global acessada não está nela'
config.diagnostics['duplicate-index']       =
'Índice duplicado em tabela literal'
config.diagnostics['empty-block']           =
'Bloco vazio'
config.diagnostics['redundant-value']       =
'Em uma atribuição, há mais valores que variáveis-alvo'
config.diagnostics['assign-type-mismatch']  =
'Habilita diagnóstico para atribuições em que o tipo do valor não corresponde ao tipo da variável alvo.'
config.diagnostics['await-in-sync']         =
'Habilita diagnóstico para chamadas de funções assíncronas dentro de uma função síncrona.'
config.diagnostics['cast-local-type']    =
'Habilita diagnóstico para coerções de variáveis locais em que o tipo alvo não corresponde ao tipo definido.'
config.diagnostics['cast-type-mismatch']    =
'Habilita diagnóstico para coerções em que o tipo alvo não corresponde ao tipo inicial.'
config.diagnostics['circular-doc-class']    =
'Habilita diagnóstico para classes que herdam entre si, formando relação circular.'
config.diagnostics['close-non-object']      =
'Habilita diagnóstico para tentativas de fechar uma variável que não é objeto.'
config.diagnostics['code-after-break']      =
'Habilita diagnóstico para código após um `break` em um loop.'
config.diagnostics['codestyle-check']       =
'Habilita diagnóstico para linhas que violam o estilo de código.'
config.diagnostics['count-down-loop']       =
'Habilita diagnóstico para laços `for` decrescentes que nunca atingem o limite porque são incrementados.'
config.diagnostics['deprecated']            =
'Habilita diagnóstico para APIs obsoletas.'
config.diagnostics['different-requires']    =
'Habilita diagnóstico para arquivos exigidos por dois caminhos diferentes.'
config.diagnostics['discard-returns']       =
'Habilita diagnóstico para chamadas de funções anotadas com `---@nodiscard` quando os retornos são ignorados.'
config.diagnostics['doc-field-no-class']    =
'Habilita diagnóstico para anotações de campo sem anotação de classe correspondente.'
config.diagnostics['duplicate-doc-alias']   =
'Habilita diagnóstico para nome de alias anotado duplicado.'
config.diagnostics['duplicate-doc-field']   =
'Habilita diagnóstico para nome de campo anotado duplicado.'
config.diagnostics['duplicate-doc-param']   =
'Habilita diagnóstico para nome de parâmetro anotado duplicado.'
config.diagnostics['duplicate-set-field']   =
'Habilita diagnóstico para definir o mesmo campo em uma classe mais de uma vez.'
config.diagnostics['incomplete-signature-doc'] =
'Anotações @param ou @return incompletas para funções.'
config.diagnostics['invisible']             =
'Habilita diagnóstico para acessos a campos invisíveis.'
config.diagnostics['missing-global-doc']    =
'Faltam anotações para globais! Funções globais devem ter comentário e anotações para todos os parâmetros e retornos.'
config.diagnostics['missing-local-export-doc'] =
'Faltam anotações para locais exportados! Funções locais exportadas devem ter comentário e anotações para todos os parâmetros e retornos.'
config.diagnostics['missing-parameter']     =
'Habilita diagnóstico para chamadas de função com menos argumentos que os parâmetros anotados.'
config.diagnostics['missing-return']        =
'Habilita diagnóstico para funções com anotação de retorno mas sem instrução return.'
config.diagnostics['missing-return-value']  =
'Habilita diagnóstico para retornos sem valores embora a função declare valores de retorno.'
config.diagnostics['need-check-nil']        =
'Habilita diagnóstico para uso de variável após ela receber `nil` ou valor opcional.'
config.diagnostics['unnecessary-assert']    =
'Habilita diagnóstico para asserts redundantes em valores verdadeiros.'
config.diagnostics['no-unknown']            =
'Habilita diagnóstico para casos em que o tipo não pode ser inferido.'
config.diagnostics['not-yieldable']         =
'Habilita diagnóstico para chamadas de `coroutine.yield()` quando não permitido.'
config.diagnostics['param-type-mismatch']   =
'Habilita diagnóstico para chamadas onde o tipo do parâmetro fornecido não corresponde à definição anotada.'
config.diagnostics['redundant-return']      =
'Habilita diagnóstico para retornos desnecessários porque a função já terminaria.'
config.diagnostics['redundant-return-value']=
'Habilita diagnóstico para retornos que entregam valor extra não especificado na anotação.'
config.diagnostics['return-type-mismatch']  =
'Habilita diagnóstico para retornos cujo tipo não corresponde ao tipo declarado.'
config.diagnostics['spell-check']           =
'Habilita diagnóstico para erros ortográficos em strings.'
config.diagnostics['name-style-check']      =
'Habilita diagnóstico para estilo de nomes.'
config.diagnostics['unbalanced-assignments']=
'Habilita diagnóstico em múltiplas atribuições se nem todas as variáveis recebem valor (ex.: `local x,y = 1`).'
config.diagnostics['undefined-doc-class']   =
'Habilita diagnóstico para anotações de classe que fazem referência a classe indefinida.'
config.diagnostics['undefined-doc-name']    =
'Habilita diagnóstico para anotações de tipo que referenciam tipo ou alias indefinido.'
config.diagnostics['undefined-doc-param']   =
'Habilita diagnóstico para anotações de parâmetro sem declaração correspondente na função.'
config.diagnostics['undefined-field']       =
'Habilita diagnóstico para leitura de campo indefinido de uma variável.'
config.diagnostics['unknown-cast-variable'] =
'Habilita diagnóstico para coerções de variáveis indefinidas.'
config.diagnostics['unknown-diag-code']     =
'Habilita diagnóstico quando um código de diagnóstico desconhecido é informado.'
config.diagnostics['unknown-operator']      =
'Habilita diagnóstico para operadores desconhecidos.'
config.diagnostics['unreachable-code']      =
'Habilita diagnóstico para código inalcançável.'
config.diagnostics['global-element']       =
'Habilita diagnóstico para avisar sobre elementos globais.'
config.typeFormat.config                    =
'Configura o comportamento de formatação enquanto digita código Lua.'
config.typeFormat.config.auto_complete_end  =
'Controla se `end` é completado automaticamente em posições adequadas.'
config.typeFormat.config.auto_complete_table_sep =
'Controla se um separador é adicionado automaticamente ao final de uma declaração de tabela.'
config.typeFormat.config.format_line        =
'Controla se uma linha deve ser formatada.'

command.exportDocument =
'Lua: Exportar Documento ...'
command.addon_manager.open =
'Lua: Abrir Gerenciador de Addon ...'
command.reloadFFIMeta =
'Lua: Recarregar metadados luajit ffi'
command.startServer =
'Lua: Reiniciar Language Server'
command.stopServer =
'Lua: Parar Language Server'
