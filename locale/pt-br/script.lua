DIAG_LINE_ONLY_SPACE    =
'Linha com espaços apenas.'
DIAG_LINE_POST_SPACE    =
'Linha com espaço extra ao final.'
DIAG_UNUSED_LOCAL       =
'Escopo não utilizado `{}`.'
DIAG_UNDEF_GLOBAL       =
'Escopo global indefinido `{}`.'
DIAG_UNDEF_FIELD        =
'Campo indefinido `{}`.'
DIAG_UNDEF_ENV_CHILD    =
'Variável indefinida `{}` (overloaded `_ENV` ).'
DIAG_UNDEF_FENV_CHILD   =
'Variável indefinida `{}` (módulo interno).'
DIAG_GLOBAL_IN_NIL_ENV  =
'Valor global inválido (`_ENV` é `nil`).'
DIAG_GLOBAL_IN_NIL_FENV =
'Valor global inválido (Ambiente do módulo é `nil`).'
DIAG_UNUSED_LABEL       =
'Identificador não utilizado `{}`.'
DIAG_UNUSED_FUNCTION    =
'Funções não utilizadas.'
DIAG_UNUSED_VARARG      =
'vararg não utilizado.'
DIAG_REDEFINED_LOCAL    =
'Valor local redefinido `{}`.'
DIAG_DUPLICATE_INDEX    =
'Índice duplicado `{}`.'
DIAG_DUPLICATE_METHOD   =
'Método duplicado `{}`.'
DIAG_PREVIOUS_CALL      =
'Será interpretado como `{}{}`. Pode ser necessário adicionar uma `,`.'
DIAG_PREFIELD_CALL      =
'Será interpretado como `{}{}`. Pode ser necessário adicionar uma `,` ou `;`.'
DIAG_OVER_MAX_ARGS      =
'A função aceita apenas os parâmetros {:d}, mas você passou {:d}.'
DIAG_MISS_ARGS          = -- TODO: need translate!
'the function received at least {:d} arguments, but got {:d}.'
DIAG_OVER_MAX_VALUES    = -- TODO: need translate!
'Only has {} variables, but you set {} values.'
DIAG_AMBIGUITY_1        =
'Calcule primeiro `{}`. Você pode precisar adicionar colchetes.'
DIAG_LOWERCASE_GLOBAL   =
'Variável global com inicial minúscula, você esqueceu o `local` ou digitou errado?'
DIAG_EMPTY_BLOCK        =
'Bloco vazio.'
DIAG_DIAGNOSTICS        =
'Diagnósticos Lua.'
DIAG_SYNTAX_CHECK       =
'Verificação de sintaxe Lua.'
DIAG_NEED_VERSION       =
'Suportado em {}, atual é {}.'
DIAG_DEFINED_VERSION    =
'Definido em {}, a corrente é {}.'
DIAG_DEFINED_CUSTOM     =
'Definido em {}.'
DIAG_DUPLICATE_CLASS    =
'Classe duplicada `{}`.'
DIAG_UNDEFINED_CLASS    =
'Classe indefinida `{}`.'
DIAG_CYCLIC_EXTENDS     =
'Herança cíclica.'
DIAG_INEXISTENT_PARAM   =
'Parâmetro inexistente.'
DIAG_DUPLICATE_PARAM    =
'Parâmetro duplicado.'
DIAG_NEED_CLASS         =
'Classe precisa ser definida primeiro.'
DIAG_DUPLICATE_SET_FIELD=
'Campo duplicado `{}`.'
DIAG_SET_CONST          =
'Atribuição à variável constante.'
DIAG_SET_FOR_STATE      =
'Atribuição à variável to tipo for-state.'
DIAG_CODE_AFTER_BREAK   =
'Não é possível executar o código depois `break`.'
DIAG_UNBALANCED_ASSIGNMENTS =
'O valor é atribuído como `nil` porque o número de valores não é suficiente. Em Lua, `x, y = 1` é equivalente a `x, y = 1, nil` .'
DIAG_REQUIRE_LIKE       =
'Você pode tratar `{}` como `require` por configuração.'
DIAG_COSE_NON_OBJECT    =
'Não é possível fechar um valor desse tipo. (A menos que se defina o meta método `__close`)'
DIAG_COUNT_DOWN_LOOP    =
'Você quer dizer `{}` ?'
DIAG_UNKNOWN            =
'Não pode inferir tipo.'
DIAG_DEPRECATED         =
'Descontinuada.'
DIAG_DIFFERENT_REQUIRES =
'O mesmo arquivo é necessário com nomes diferentes.'
DIAG_REDUNDANT_RETURN   =
'Retorno redundante.'
DIAG_AWAIT_IN_SYNC      = -- TODO: need translate!
'Async function can only be called in async function.'
DIAG_NOT_YIELDABLE      = -- TODO: need translate!
'The {}th parameter of this function was not marked as yieldable, but an async function was passed in. (Use `---@param name async fun()` to mark as yieldable)'
DIAG_DISCARD_RETURNS    = -- TODO: need translate!
'The return values of this function cannot be discarded.'
DIAG_NEED_CHECK_NIL     = -- TODO: need translate!
'Need check nil.'
DIAG_CIRCLE_DOC_CLASS                 =
'Classes com herança cíclica.'
DIAG_DOC_FIELD_NO_CLASS               =
'O campo deve ser definido após a classe.'
DIAG_DUPLICATE_DOC_CLASS              =
'Classe definida duplicada `{}`.'
DIAG_DUPLICATE_DOC_FIELD              =
'Campos definidos duplicados `{}`.'
DIAG_DUPLICATE_DOC_PARAM              =
'Parâmetros duplicados `{}`.'
DIAG_UNDEFINED_DOC_CLASS              =
'Classe indefinida `{}`.'
DIAG_UNDEFINED_DOC_NAME               =
'Tipo ou alias indefinido `{}`.'
DIAG_UNDEFINED_DOC_PARAM              =
'Parâmetro indefinido `{}`.'
DIAG_UNKNOWN_DIAG_CODE                =
'Código de diagnóstico desconhecido `{}`.'

MWS_NOT_SUPPORT         =
'{} não é suportado múltiplos espaços de trabalho por enquanto, posso precisar reiniciar para estabelecer um novo espaço de trabalho ...'
MWS_RESTART             =
'Reiniciar'
MWS_NOT_COMPLETE        =
'O espaço de trabalho ainda não está completo. Você pode tentar novamente mais tarde ...'
MWS_COMPLETE            =
'O espaço de trabalho está completo agora. Você pode tentar novamente ...'
MWS_MAX_PRELOAD         =
'Arquivos pré-carregados atingiram o limite máximo ({}), você precisa abrir manualmente os arquivos que precisam ser carregados.'
MWS_UCONFIG_FAILED      =
'Armazenamento da configuração do usuário falhou.'
MWS_UCONFIG_UPDATED     =
'Configuração do usuário atualizada.'
MWS_WCONFIG_UPDATED     =
'Configuração do espaço de trabalho atualizado.'

WORKSPACE_SKIP_LARGE_FILE =
'Arquivo muito grande: {} ignorada. O limite de tamanho atualmente definido é: {} KB, e o tamanho do arquivo é: {} KB.'
WORKSPACE_LOADING         =
'Carregando espaço de trabalho.'
WORKSPACE_DIAGNOSTIC      =
'Diagnóstico de espaço de trabalho.'
WORKSPACE_SKIP_HUGE_FILE  =
'Por motivos de desempenho, a análise deste arquivo foi interrompida: {}'

PARSER_CRASH            =
'Parser quebrou! Últimas palavras: {}'
PARSER_UNKNOWN          =
'Erro de sintaxe desconhecido ...'
PARSER_MISS_NAME        =
'<name> esperado.'
PARSER_UNKNOWN_SYMBOL   =
'Símbolo inesperado `{symbol}`.'
PARSER_MISS_SYMBOL      =
'Símbolo não encontrado `{symbol}`.'
PARSER_MISS_ESC_X       =
'Deve ser 2 dígitos hexadecimais.'
PARSER_UTF8_SMALL       =
'Pelo menos 1 dígito hexadecimal.'
PARSER_UTF8_MAX         =
'Deve estar entre {min} e {max}.'
PARSER_ERR_ESC          =
'Sequência de saída inválida.'
PARSER_MUST_X16         =
'Deve ser dígitos hexadecimais.'
PARSER_MISS_EXPONENT    =
'Dígitos perdidos para o expoente.'
PARSER_MISS_EXP         =
'<exp> esperada.'
PARSER_MISS_FIELD       =
'<field> esperado.'
PARSER_MISS_METHOD      =
'<method> esperado.'
PARSER_ARGS_AFTER_DOTS  =
'`...` deve ser o último argumento.'
PARSER_KEYWORD          =
'<keyword> não pode ser usado como nome.'
PARSER_EXP_IN_ACTION    =
'Inesperada <exp>.'
PARSER_BREAK_OUTSIDE    =
'<break> não está dentro de um loop.'
PARSER_MALFORMED_NUMBER =
'Número malformado.'
PARSER_ACTION_AFTER_RETURN =
'<eof> esperado após `return`.'
PARSER_ACTION_AFTER_BREAK =
'<eof> esperado após `break`.'
PARSER_NO_VISIBLE_LABEL =
'Nenhum identificador visível `{label}` .'
PARSER_REDEFINE_LABEL   =
'Identificador `{label}` já foi definido.'
PARSER_UNSUPPORT_SYMBOL =
'{version} não suporta esta gramática.'
PARSER_UNEXPECT_DOTS    =
'Não pode usar `...` fora de uma função vararg.'
PARSER_UNEXPECT_SYMBOL  =
'Símbolo inesperado `{symbol}` .'
PARSER_UNKNOWN_TAG      =
'Atributo desconhecido.'
PARSER_MULTI_TAG        =
'Não suporta múltiplos atributos.'
PARSER_UNEXPECT_LFUNC_NAME =
'A função local só pode usar identificadores como nome.'
PARSER_UNEXPECT_EFUNC_NAME =
'Função como expressão não pode ser nomeada.'
PARSER_ERR_LCOMMENT_END =
'Anotações em múltiplas linhas devem ser fechadas por `{symbol}` .'
PARSER_ERR_C_LONG_COMMENT =
'Lua deve usar `--[[ ]]` para anotações em múltiplas linhas.'
PARSER_ERR_LSTRING_END  =
'String longa deve ser fechada por `{symbol}` .'
PARSER_ERR_ASSIGN_AS_EQ =
'Deveria usar `=` para atribuição.'
PARSER_ERR_EQ_AS_ASSIGN =
'Deveria usar `==` para comparação de igualdade.'
PARSER_ERR_UEQ          =
'Deveria usar `~=` para comparação de desigualdade.'
PARSER_ERR_THEN_AS_DO   =
'Deveria usar `then` .'
PARSER_ERR_DO_AS_THEN   =
'Deveria usar `do` .'
PARSER_MISS_END         =
'Falta o `end` correspondente.'
PARSER_ERR_COMMENT_PREFIX =
'Lua usa `--` para anotações/comentários.'
PARSER_MISS_SEP_IN_TABLE =
'Falta o símbolo `,` ou `;` .'
PARSER_SET_CONST         =
'Atribuição à variável constante.'
PARSER_UNICODE_NAME      =
'Contém caracteres Unicode.'
PARSER_ERR_NONSTANDARD_SYMBOL =
'Deveria usar `{symbol}`.'
PARSER_MISS_SPACE_BETWEEN =
'Devem ser deixados espaços entre símbolos.'
PARSER_INDEX_IN_FUNC_NAME =
'A forma `[name]` não pode ser usada em nome de uma função nomeada.'
PARSER_UNKNOWN_ATTRIBUTE  =
'Atributo local deve ser `const` ou `close`'
PARSER_LUADOC_MISS_CLASS_NAME           =
'Esperado <class name>.'
PARSER_LUADOC_MISS_EXTENDS_SYMBOL       =
'Esperado `:`.'
PARSER_LUADOC_MISS_CLASS_EXTENDS_NAME   =
'Esperado <class extends name>.'
PARSER_LUADOC_MISS_SYMBOL               =
'Esperado `{symbol}`.'
PARSER_LUADOC_MISS_ARG_NAME             =
'Esperado <arg name>.'
PARSER_LUADOC_MISS_TYPE_NAME            =
'Esperado <type name>.'
PARSER_LUADOC_MISS_ALIAS_NAME           =
'Esperado <alias name>.'
PARSER_LUADOC_MISS_ALIAS_EXTENDS        =
'Esperado <alias extends>.'
PARSER_LUADOC_MISS_PARAM_NAME           =
'Esperado <param name>.'
PARSER_LUADOC_MISS_PARAM_EXTENDS        =
'Esperado <param extends>.'
PARSER_LUADOC_MISS_FIELD_NAME           =
'Esperado <field name>.'
PARSER_LUADOC_MISS_FIELD_EXTENDS        =
'Esperado <field extends>.'
PARSER_LUADOC_MISS_GENERIC_NAME         =
'Esperado <generic name>.'
PARSER_LUADOC_MISS_GENERIC_EXTENDS_NAME =
'Esperado <generic extends name>.'
PARSER_LUADOC_MISS_VARARG_TYPE          =
'Esperado <vararg type>.'
PARSER_LUADOC_MISS_FUN_AFTER_OVERLOAD   =
'Esperado `fun`.'
PARSER_LUADOC_MISS_CATE_NAME            =
'Esperado <doc name>.'
PARSER_LUADOC_MISS_DIAG_MODE            =
'Esperado <diagnostic mode>.'
PARSER_LUADOC_ERROR_DIAG_MODE           =
'<diagnostic mode> incorreto.'
PARSER_LUADOC_MISS_LOCAL_NAME           = -- TODO: need translate!
'<local name> expected.'

SYMBOL_ANONYMOUS        = -- TODO: need translate!
'<Anonymous>'

HOVER_VIEW_DOCUMENTS    =
'Visualizar documentos'
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
'({} protótipos)'
HOVER_STRING_BYTES         = -- TODO: need translate!
'{} bytes'
HOVER_STRING_CHARACTERS    =
'{} bytes, {} caracteres'
HOVER_MULTI_DEF_PROTO      =
'({} definições., {} protótipos)'
HOVER_MULTI_PROTO_NOT_FUNC =
'({} definição não funcional)'
HOVER_USE_LUA_PATH      =
'(Caminho de busca: `{}`)'
HOVER_EXTENDS           =
'Expande para {}'
HOVER_TABLE_TIME_UP     =
'Inferência de tipo parcial foi desativada por motivos de desempenho.'
HOVER_WS_LOADING        =
'Carregando espaço de trabalho: {} / {}'
HOVER_AWAIT_TOOLTIP     = -- TODO: need translate!
'Calling async function, current thread may be yielded.'

ACTION_DISABLE_DIAG     =
'Desativar diagnósticos no espaço de trabalho ({}).'
ACTION_MARK_GLOBAL      =
'Marque `{}` como definição global.'
ACTION_REMOVE_SPACE     =
'Limpe todos os espaços desnecessários.'
ACTION_ADD_SEMICOLON    =
'Adicione `;` .'
ACTION_ADD_BRACKETS     =
'Adicione colchetes.'
ACTION_RUNTIME_VERSION  =
'Altere a versão de tempo de execução para {}.'
ACTION_OPEN_LIBRARY     =
'Carregue variáveis globais de {}.'
ACTION_ADD_DO_END       =
'Adicione `do ... end`.'
ACTION_FIX_LCOMMENT_END =
'Modifique para o símbolo de fechamento de anotação/comentário de múltiplas linhas correto.'
ACTION_ADD_LCOMMENT_END =
'Feche as anotações/comentário de múltiplas linhas.'
ACTION_FIX_C_LONG_COMMENT =
'Modifique para o formato de anotações/comentários em múltiplas linhas.'
ACTION_FIX_LSTRING_END  =
'Modifique para o símbolo de fechamento de string correta.'
ACTION_ADD_LSTRING_END  =
'Feche a string longa.'
ACTION_FIX_ASSIGN_AS_EQ =
'Modifique para `=` .'
ACTION_FIX_EQ_AS_ASSIGN =
'Modifique para `==` .'
ACTION_FIX_UEQ          =
'Modifique para `~=` .'
ACTION_FIX_THEN_AS_DO   =
'Modifique para `then` .'
ACTION_FIX_DO_AS_THEN   =
'Modifique para `do` .'
ACTION_ADD_END          =
'Adicione `end` (Adiciona marcação de fim com base na identação).'
ACTION_FIX_COMMENT_PREFIX =
'Modifique para `--` .'
ACTION_FIX_NONSTANDARD_SYMBOL =
'Modifique para `{symbol}` .'
ACTION_RUNTIME_UNICODE_NAME =
'Permite caracteres Unicode.'
ACTION_SWAP_PARAMS      =
'Mude para o parâmetro {index} de `{node}`.'
ACTION_FIX_INSERT_SPACE =
'Insira espaço.'
ACTION_JSON_TO_LUA      =
'Converte de JSON para Lua.'
ACTION_DISABLE_DIAG_LINE=
'Desativa diagnósticos nesta linha ({}).'
ACTION_DISABLE_DIAG_FILE=
'Desativa diagnósticos nesta linha ({}).'
ACTION_MARK_ASYNC       = -- TODO: need translate!
'Mark current function as async.'

COMMAND_DISABLE_DIAG       =
'Desativar diagnósticos.'
COMMAND_MARK_GLOBAL        =
'Marca como variável global.'
COMMAND_REMOVE_SPACE       =
'Limpa todos os espaços desnecessários.'
COMMAND_ADD_BRACKETS       =
'Adiciona colchetes.'
COMMAND_RUNTIME_VERSION    =
'Altera a versão de tempo de execução.'
COMMAND_OPEN_LIBRARY       =
'Carrega variáveis globais de bibliotecas de terceiros.'
COMMAND_UNICODE_NAME       =
'Permite caracteres Unicode.'
COMMAND_JSON_TO_LUA        =
'Converte de JSON para Lua.'
COMMAND_JSON_TO_LUA_FAILED =
'Converção de JSON para Lua falhou: {}.'

COMPLETION_IMPORT_FROM           =
'Importa de {}.'
COMPLETION_DISABLE_AUTO_REQUIRE  =
'Desativa auto require.'
COMPLETION_ASK_AUTO_REQUIRE      =
'Adicione o código na parte superior do arquivo como auto require?'

DEBUG_MEMORY_LEAK       =
"{} Sinto muito pelo sério vazamento de memória. O serviço de idioma será reiniciado em breve."
DEBUG_RESTART_NOW       =
'Reinicie agora'

WINDOW_COMPILING                 =
'Compilando'
WINDOW_DIAGNOSING                =
'Realizando diagnóstico'
WINDOW_INITIALIZING              =
'Inicializando...'
WINDOW_PROCESSING_HOVER          =
'Processando hover...'
WINDOW_PROCESSING_DEFINITION     =
'Processando definições...'
WINDOW_PROCESSING_REFERENCE      =
'Processando referências...'
WINDOW_PROCESSING_RENAME         =
'Processando renomeações...'
WINDOW_PROCESSING_COMPLETION     =
'Processando finalizações...'
WINDOW_PROCESSING_SIGNATURE      =
'Processando ajuda de assinatura...'
WINDOW_PROCESSING_SYMBOL         =
'Processando símbolos do arquivo...'
WINDOW_PROCESSING_WS_SYMBOL      =
'Processando símbolos do espaço de trabalho...'
WINDOW_PROCESSING_SEMANTIC_FULL  =
'Processando tokens semânticas completos...'
WINDOW_PROCESSING_SEMANTIC_RANGE =
'Processando tokens semânticas incrementais...'
WINDOW_PROCESSING_HINT           =
'Processando dicas de lina...'
WINDOW_INCREASE_UPPER_LIMIT      =
'Aumente o limite superior'
WINDOW_CLOSE                     =
'Fechar'
WINDOW_SETTING_WS_DIAGNOSTIC     =
'Você pode atrasar ou desativar os diagnósticos do espaço de trabalho nas configurações'
WINDOW_DONT_SHOW_AGAIN           =
'Não mostre novamente'
WINDOW_DELAY_WS_DIAGNOSTIC       =
'Diagnóstico de tempo ocioso (atraso de {} segundos)'
WINDOW_DISABLE_DIAGNOSTIC        =
'Desativa diagnósticos do espaço de trabalho'
WINDOW_LUA_STATUS_WORKSPACE      =
'Área de trabalho : {}'
WINDOW_LUA_STATUS_CACHED_FILES   =
'Arquivos em cache: {ast}/{max}'
WINDOW_LUA_STATUS_MEMORY_COUNT   =
'Uso de memória   : {mem:.f}M'
WINDOW_LUA_STATUS_TIP            = -- TODO: need translate!
[[

This icon is a cat,
Not a dog nor a fox!
             ↓↓↓
]]
WINDOW_LUA_STATUS_DIAGNOSIS_TITLE= -- TODO: need translate!
'Perform workspace diagnosis'
WINDOW_LUA_STATUS_DIAGNOSIS_MSG  = -- TODO: need translate!
'Do you want to perform workspace diagnosis?'
WINDOW_APPLY_SETTING             =
'Aplicar configuração'
WINDOW_CHECK_SEMANTIC            =
'Se você estiver usando o tema de cores do market, talvez seja necessário modificar `editor.semanticHighlighting.enabled` para `true` para fazer com tokens semânticas sejam habilitados.'
WINDOW_TELEMETRY_HINT            =
'Por favor, permita o envio de dados de uso e relatórios de erro anônimos para nos ajudar a melhorar ainda mais essa extensão. Leia nossa política de privacidade [aqui](https://github.com/sumneko/lua-language-server/wiki/Privacy-Policy) .'
WINDOW_TELEMETRY_ENABLE          =
'Permitir'
WINDOW_TELEMETRY_DISABLE         =
'Desabilitar'
WINDOW_CLIENT_NOT_SUPPORT_CONFIG =
'Seu cliente não suporta configurações de modificação do lado do servidor, modifique manualmente as seguintes configurações:'
WINDOW_LCONFIG_NOT_SUPPORT_CONFIG=
'A modificação automática de configurações locais não é suportada atualmente, modifique manualmente as seguintes configurações:'
WINDOW_MANUAL_CONFIG_ADD         =
'`{key}`: adiciona o elemento `{value:q}` ;'
WINDOW_MANUAL_CONFIG_SET         =
'`{key}`: defini como `{value:q}` ;'
WINDOW_MANUAL_CONFIG_PROP        =
'`{key}`: define a propriedade `{prop}` para `{value:q}`;'
WINDOW_APPLY_WHIT_SETTING        =
'Aplicar e modificar configurações'
WINDOW_APPLY_WHITOUT_SETTING     =
'Aplicar mas não modificar configurações'
WINDOW_ASK_APPLY_LIBRARY         =
'Você precisa configurar seu ambiente de trabalho como `{}`?'
WINDOW_SEARCHING_IN_FILES        = -- TODO: need translate!
'Searching in files...'

CONFIG_LOAD_FAILED               =
'Não é possível ler o arquivo de configurações: {}'
CONFIG_LOAD_ERROR                =
'Configurando o erro de carregamento do arquivo: {}'
CONFIG_TYPE_ERROR                =
'O arquivo de configuração deve estar no formato LUA ou JSON: {}'

PLUGIN_RUNTIME_ERROR             =
[[
Ocorreu um erro no plugin, envie o erro ao autor do plugin.
Por favor, verifique os detalhes na saída ou log.
Caminho do plugin: {}
]]
PLUGIN_TRUST_LOAD                =
[[
As configurações atuais tentam carregar o plugin neste local: {}

Note que plugins mal-intencionados podem prejudicar seu computador
]]
PLUGIN_TRUST_YES                 =
[[
Confie e carregue este plugin
]]
PLUGIN_TRUST_NO                  =
[[
Não carregue este plugin
]]

CLI_CHECK_ERROR_TYPE = -- TODO: need translate!
'The argument of CHECK must be a string, but got {}'
CLI_CHECK_ERROR_URI = -- TODO: need translate!
'The argument of CHECK must be a valid uri, but got {}'
CLI_CHECK_ERROR_LEVEL = -- TODO: need translate!
'Checklevel must be one of: {}'
CLI_CHECK_INITING = -- TODO: need translate!
'Initializing ...'
CLI_CHECK_SUCCESS = -- TODO: need translate!
'Diagnosis completed, no problems found'
CLI_CHECK_RESULTS = -- TODO: need translate!
'Diagnosis complete, {} problems found, see {}'
