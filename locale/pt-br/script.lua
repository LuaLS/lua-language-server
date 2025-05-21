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
DIAG_MISS_ARGS          =
'A função recebe pelo menos {:d} argumentos, mas há {:d}.'
DIAG_UNNECESSARY_ASSERT =
'Asserção desnecessária: esta expressão é sempre verdadeira.'
DIAG_OVER_MAX_VALUES    =
'Apenas há {} variáveis, mas você declarou {} valores.'
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
DIAG_AWAIT_IN_SYNC      =
'Funções assíncronas apenas podem ser chamada em funções assíncronas.'
DIAG_NOT_YIELDABLE      =
'O {}-ésimo parâmetro desta função não foi marcada como produzível, mas uma função assíncrona foi passada. (Use `---@param name async fun()` para marcar como produzível)'
DIAG_DISCARD_RETURNS    =
'Os valores retornados desta função não podem ser descartáveis.'
DIAG_NEED_CHECK_NIL     =
'Necessário checar o nil.'
DIAG_CIRCLE_DOC_CLASS                 =
'Classes com herança cíclica.'
DIAG_DOC_FIELD_NO_CLASS               =
'O campo deve ser definido após a classe.'
DIAG_DUPLICATE_DOC_ALIAS              = -- TODO: need translate!
'Duplicate defined alias `{}`.'
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
DIAG_MISSING_GLOBAL_DOC_COMMENT       = -- TODO: need translate!
'Missing comment for global function `{}`.'
DIAG_MISSING_GLOBAL_DOC_PARAM         = -- TODO: need translate!
'Missing @param annotation for parameter `{}` in global function `{}`.'
DIAG_MISSING_GLOBAL_DOC_RETURN        = -- TODO: need translate!
'Missing @return annotation at index `{}` in global function `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_COMMENT = -- TODO: need translate!
'Missing comment for exported local function `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_PARAM   = -- TODO: need translate!
'Missing @param annotation for parameter `{}` in exported local function `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_RETURN  = -- TODO: need translate!
'Missing @return annotation at index `{}` in exported local function `{}`.'
DIAG_INCOMPLETE_SIGNATURE_DOC_PARAM   = -- TODO: need translate!
'Incomplete signature. Missing @param annotation for parameter `{}`.'
DIAG_INCOMPLETE_SIGNATURE_DOC_RETURN  = -- TODO: need translate!
'Incomplete signature. Missing @return annotation at index `{}`.'
DIAG_UNKNOWN_DIAG_CODE                = -- TODO: need translate!
'Código de diagnóstico desconhecido `{}`.'
DIAG_CAST_LOCAL_TYPE                  = -- TODO: need translate!
'This variable is defined as type `{def}`. Cannot convert its type to `{ref}`.'
DIAG_CAST_FIELD_TYPE                  = -- TODO: need translate!
'This field is defined as type `{def}`. Cannot convert its type to `{ref}`.'
DIAG_ASSIGN_TYPE_MISMATCH             = -- TODO: need translate!
'Cannot assign `{ref}` to `{def}`.'
DIAG_PARAM_TYPE_MISMATCH              = -- TODO: need translate!
'Cannot assign `{ref}` to parameter `{def}`.'
DIAG_UNKNOWN_CAST_VARIABLE            = -- TODO: need translate!
'Unknown type conversion variable `{}`.'
DIAG_CAST_TYPE_MISMATCH               = -- TODO: need translate!
'Cannot convert `{ref}` to `{def}`。'
DIAG_MISSING_RETURN_VALUE             = -- TODO: need translate!
'At least {min} return values are required, but here only {rmax} values are returned.'
DIAG_MISSING_RETURN_VALUE_RANGE       = -- TODO: need translate!
'At least {min} return values are required, but here only {rmin} to {rmax} values are returned.'
DIAG_REDUNDANT_RETURN_VALUE           = -- TODO: need translate!
'At most {max} values returned, but the {rmax}th value was returned here.'
DIAG_REDUNDANT_RETURN_VALUE_RANGE     = -- TODO: need translate!
'At most {max} values returned, but {rmin}th to {rmax}th values were returned here.'
DIAG_MISSING_RETURN                   = -- TODO: need translate!
'Return value is required here.'
DIAG_RETURN_TYPE_MISMATCH             = -- TODO: need translate!
'The type of the {index} return value is `{def}`, but the actual return is `{ref}`.\n{err}'
DIAG_UNKNOWN_OPERATOR                 = -- TODO: need translate!
'Unknown operator `{}`.'
DIAG_UNREACHABLE_CODE                 = -- TODO: need translate!
'Unreachable code.'
DIAG_INVISIBLE_PRIVATE                = -- TODO: need translate!
'Field `{field}` is private, it can only be accessed in class `{class}`.'
DIAG_INVISIBLE_PROTECTED              = -- TODO: need translate!
'Field `{field}` is protected, it can only be accessed in class `{class}` and its subclasses.'
DIAG_INVISIBLE_PACKAGE                = -- TODO: need translate!
'Field `{field}` can only be accessed in same file `{uri}`.'
DIAG_GLOBAL_ELEMENT                  = -- TODO: need translate!
'Element is global.'
DIAG_MISSING_FIELDS                   = -- TODO: need translate!
'Missing required fields in type `{1}`: {2}'
DIAG_INJECT_FIELD                     = -- TODO: need translate!
'Fields cannot be injected into the reference of `{class}` for `{field}`. {fix}'
DIAG_INJECT_FIELD_FIX_CLASS           = -- TODO: need translate!
'To do so, use `---@class` for `{node}`.'
DIAG_INJECT_FIELD_FIX_TABLE           = -- TODO: need translate!
'如要允许注入，请在定义中添加 `{fix}` 。'

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
WORKSPACE_NOT_ALLOWED     =
'Seu espaço de trabalho foi definido para `{}`. Servidor da linguagem Lua recusou o carregamneto neste diretório. Por favor, cheque sua configuração. [aprenda mais aqui](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)'
WORKSPACE_SCAN_TOO_MUCH   = -- TODO: need translate!
'Mais do que {} arquivos foram escaneados. O diretório atual escaneado é `{}`. Please see the [FAQ](https://luals.github.io/wiki/faq#how-can-i-improve-startup-speeds) to see how you can include fewer files. It is also possible that your [configuration is incorrect](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder).'

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
PARSER_AMBIGUOUS_SYNTAX   = -- TODO: need translate!
'In Lua 5.1, the left brackets called by the function must be in the same line as the function.'
PARSER_NEED_PAREN         = -- TODO: need translate!
'需要添加一对括号。'
PARSER_NESTING_LONG_MARK  = -- TODO: need translate!
'Nesting of `[[...]]` is not allowed in Lua 5.1 .'
PARSER_LOCAL_LIMIT        = -- TODO: need translate!
'Only 200 active local variables and upvalues can be existed at the same time.'
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
PARSER_LUADOC_MISS_LOCAL_NAME           =
'<local name> esperado.'

SYMBOL_ANONYMOUS        =
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
HOVER_STRING_BYTES         =
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
HOVER_AWAIT_TOOLTIP     =
'Chamando a função assíncrona, a thread atual deve ser produzível'

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
ACTION_MARK_ASYNC       =
'Marque a função atual como assíncrona'
ACTION_ADD_DICT         =
'Adicione \'{}\' ao seu espaço de trabalho no '
ACTION_FIX_ADD_PAREN    = -- TODO: need translate!
'添加括号。'
ACTION_AUTOREQUIRE      = -- TODO: need translate!
"Import '{}' as {}"

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
COMMAND_ADD_DICT           =
'Adicione uma palavra ao dicionário'
COMMAND_REFERENCE_COUNT    = -- TODO: need translate!
'{} references'

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
WINDOW_PROCESSING_BUILD_META     = -- TODO: need translate!
'Processing build meta...'
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
WINDOW_LUA_STATUS_TIP            =
[[

Este ícone é um gato,
não é um cachorro nem uma raposa!
             ↓↓↓
]]
WINDOW_LUA_STATUS_DIAGNOSIS_TITLE=
'Execute seu diagnóstico do espaço de trabalho'
WINDOW_LUA_STATUS_DIAGNOSIS_MSG  =
'Você quer executar um diagnóstico do espaço de trabalho?'
WINDOW_APPLY_SETTING             =
'Aplicar configuração'
WINDOW_CHECK_SEMANTIC            =
'Se você estiver usando o tema de cores do market, talvez seja necessário modificar `editor.semanticHighlighting.enabled` para `true` para fazer com tokens semânticas sejam habilitados.'
WINDOW_TELEMETRY_HINT            =
'Por favor, permita o envio de dados de uso e relatórios de erro anônimos para nos ajudar a melhorar ainda mais essa extensão. Leia nossa política de privacidade [aqui](https://luals.github.io/privacy/#language-server) .'
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
'Procurando nos arquivos...'
WINDOW_CONFIG_LUA_DEPRECATED     = -- TODO: need translate!
'`config.lua` is deprecated, please use `config.json` instead.'
WINDOW_CONVERT_CONFIG_LUA        = -- TODO: need translate!
'Convert to `config.json`'
WINDOW_MODIFY_REQUIRE_PATH       = -- TODO: need translate!
'Do you want to modify the require path?'
WINDOW_MODIFY_REQUIRE_OK         = -- TODO: need translate!
'Modify'

CONFIG_LOAD_FAILED               =
'Não é possível ler o arquivo de configurações: {}'
CONFIG_LOAD_ERROR                =
'Configurando o erro de carregamento do arquivo: {}'
CONFIG_TYPE_ERROR                =
'O arquivo de configuração deve estar no formato LUA ou JSON: {}'
CONFIG_MODIFY_FAIL_SYNTAX_ERROR  = -- TODO: need translate!
'Failed to modify settings, there are syntax errors in the settings file: {}'
CONFIG_MODIFY_FAIL_NO_WORKSPACE  = -- TODO: need translate!
[[
Failed to modify settings:
* The current mode is single-file mode, server cannot create `.luarc.json` without workspace.
* The language client dose not support modifying settings from the server side.

Please modify following settings manually:
{}
]]
CONFIG_MODIFY_FAIL               = -- TODO: need translate!
[[
Failed to modify settings

Please modify following settings manually:
{}
]]

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

CLI_CHECK_ERROR_TYPE =
'O argumento do CHECK deve ser uma string, mas é {}'
CLI_CHECK_ERROR_URI =
'O argumento do CHECK deve ser uma uri válida, mas é {}'
CLI_CHECK_ERROR_LEVEL =
'Checklevel deve ser um de: {}'
CLI_CHECK_INITING =
'Inicializando ...'
CLI_CHECK_SUCCESS =
'Diagnóstico completo, nenhum problema encontrado'
CLI_CHECK_PROGRESS = -- TODO: need translate!
'Found {} problems in {} files'
CLI_CHECK_RESULTS_OUTPATH =
'Diagnóstico completo, {} problemas encontrados, veja {}'
CLI_CHECK_RESULTS_PRETTY =
'Diagnóstico completo, {} problemas encontrados'
CLI_CHECK_MULTIPLE_WORKERS = -- TODO: need translate!
'Starting {} worker tasks, progress output will be disabled. This may take a few minutes.'
CLI_DOC_INITING   = -- TODO: need translate!
'Loading documents ...'
CLI_DOC_DONE      =
'Documentos exportados:'
CLI_DOC_WORKING   =
'Construindo docs...'

TYPE_ERROR_ENUM_GLOBAL_DISMATCH = -- TODO: need translate!
'Type `{child}` cannot match enumeration type of `{parent}`'
TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED = -- TODO: need translate!
'Cannot use generic `{child}` in enumeration'
TYPE_ERROR_ENUM_LITERAL_DISMATCH = -- TODO: need translate!
'Literal `{child}` cannot match the enumeration value of `{parent}`'
TYPE_ERROR_ENUM_OBJECT_DISMATCH = -- TODO: need translate!
'The object `{child}` cannot match the enumeration value of `{parent}`. They must be the same object'
TYPE_ERROR_ENUM_NO_OBJECT = -- TODO: need translate!
'The passed in enumeration value `{child}` is not recognized'
TYPE_ERROR_INTEGER_DISMATCH = -- TODO: need translate!
'Literal `{child}` cannot match integer `{parent}`'
TYPE_ERROR_STRING_DISMATCH = -- TODO: need translate!
'Literal `{child}` cannot match string `{parent}`'
TYPE_ERROR_BOOLEAN_DISMATCH = -- TODO: need translate!
'Literal `{child}` cannot match boolean `{parent}`'
TYPE_ERROR_TABLE_NO_FIELD = -- TODO: need translate!
'Field `{key}` does not exist in the table'
TYPE_ERROR_TABLE_FIELD_DISMATCH = -- TODO: need translate!
'The type of field `{key}` is `{child}`, which cannot match `{parent}`'
TYPE_ERROR_CHILD_ALL_DISMATCH = -- TODO: need translate!
'All subtypes in `{child}` cannot match `{parent}`'
TYPE_ERROR_PARENT_ALL_DISMATCH = -- TODO: need translate!
'`{child}` cannot match any subtypes in `{parent}`'
TYPE_ERROR_UNION_DISMATCH = -- TODO: need translate!
'`{child}` cannot match `{parent}`'
TYPE_ERROR_OPTIONAL_DISMATCH = -- TODO: need translate!
'Optional type cannot match `{parent}`'
TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER = -- TODO: need translate!
'The number `{child}` cannot be converted to an integer'
TYPE_ERROR_NUMBER_TYPE_TO_INTEGER = -- TODO: need translate!
'Cannot convert number type to integer type'
TYPE_ERROR_DISMATCH = -- TODO: need translate!
'Type `{child}` cannot match `{parent}`'

LUADOC_DESC_CLASS = -- TODO: need translate!
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
LUADOC_DESC_TYPE = -- TODO: need translate!
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
LUADOC_DESC_ALIAS = -- TODO: need translate!
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
LUADOC_DESC_PARAM = -- TODO: need translate!
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
LUADOC_DESC_RETURN = -- TODO: need translate!
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
LUADOC_DESC_FIELD = -- TODO: need translate!
[=[
Declare a field in a class/table. This allows you to provide more in-depth
documentation for a table. As of `v3.6.0`, you can mark a field as `private`,
`protected`, `public`, or `package`.

## Syntax
`---@field <name> <type> [description]`

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
LUADOC_DESC_GENERIC = -- TODO: need translate!
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
LUADOC_DESC_VARARG = -- TODO: need translate!
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
[View Wiki](https://luals.github.io/wiki/annotations#vararg)
]=]
LUADOC_DESC_OVERLOAD = -- TODO: need translate!
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
LUADOC_DESC_DEPRECATED = -- TODO: need translate!
[=[
Marks a function as deprecated. This results in any deprecated function calls
being ~~struck through~~.

## Syntax
`---@deprecated`

---
[View Wiki](https://luals.github.io/wiki/annotations#deprecated)
]=]
LUADOC_DESC_META = -- TODO: need translate!
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
LUADOC_DESC_VERSION = -- TODO: need translate!
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
LUADOC_DESC_SEE = -- TODO: need translate!
[=[
Define something that can be viewed for more information

## Syntax
`---@see <text>`

---
[View Wiki](https://luals.github.io/wiki/annotations#see)
]=]
LUADOC_DESC_DIAGNOSTIC = -- TODO: need translate!
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
LUADOC_DESC_MODULE = -- TODO: need translate!
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
LUADOC_DESC_ASYNC = -- TODO: need translate!
[=[
Marks a function as asynchronous.

## Syntax
`---@async`

---
[View Wiki](https://luals.github.io/wiki/annotations#async)
]=]
LUADOC_DESC_NODISCARD = -- TODO: need translate!
[=[
Prevents this function's return values from being discarded/ignored.
This will raise the `discard-returns` warning should the return values
be ignored.

## Syntax
`---@nodiscard`

---
[View Wiki](https://luals.github.io/wiki/annotations#nodiscard)
]=]
LUADOC_DESC_CAST = -- TODO: need translate!
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
LUADOC_DESC_OPERATOR = -- TODO: need translate!
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
LUADOC_DESC_ENUM = -- TODO: need translate!
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
LUADOC_DESC_SOURCE = -- TODO: need translate!
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
LUADOC_DESC_PACKAGE = -- TODO: need translate!
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
LUADOC_DESC_PRIVATE = -- TODO: need translate!
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
LUADOC_DESC_PROTECTED = -- TODO: need translate!
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
