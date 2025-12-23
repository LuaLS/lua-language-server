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

ASSIGN_CONST_GLOBAL     =
'Não é possível atribuir à variável global <const> `{}`.'

VARIABLE_NOT_DECLARED =
'Variável `{}` não declarada (declarações globais ativas).'

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
DIAG_DUPLICATE_DOC_ALIAS              =
'Alias `{}` definido de forma duplicada.'
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
DIAG_MISSING_GLOBAL_DOC_COMMENT       =
'Comentário ausente para função global `{}`.'
DIAG_MISSING_GLOBAL_DOC_PARAM         =
'Anotação @param ausente para parâmetro `{}` na função global `{}`.'
DIAG_MISSING_GLOBAL_DOC_RETURN        =
'Anotação @return ausente no índice `{}` na função global `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_COMMENT =
'Comentário ausente para função local exportada `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_PARAM   =
'Anotação @param ausente para parâmetro `{}` na função local exportada `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_RETURN  =
'Anotação @return ausente no índice `{}` na função local exportada `{}`.'
DIAG_INCOMPLETE_SIGNATURE_DOC_PARAM   =
'Assinatura incompleta. Anotação @param ausente para parâmetro `{}`.'
DIAG_INCOMPLETE_SIGNATURE_DOC_RETURN  =
'Assinatura incompleta. Anotação @return ausente no índice `{}`.'
DIAG_UNKNOWN_DIAG_CODE                =
'Código de diagnóstico desconhecido `{}`.'
DIAG_CAST_LOCAL_TYPE                  =
'Esta variável é definida como tipo `{def}`. Não é possível converter seu tipo para `{ref}`.'
DIAG_CAST_FIELD_TYPE                  =
'Este campo é definido como tipo `{def}`. Não é possível converter seu tipo para `{ref}`.'
DIAG_ASSIGN_TYPE_MISMATCH             =
'Não é possível atribuir `{ref}` a `{def}`.'
DIAG_PARAM_TYPE_MISMATCH              =
'Não é possível atribuir `{ref}` ao parâmetro `{def}`.'
DIAG_UNKNOWN_CAST_VARIABLE            =
'Variável de conversão de tipo desconhecida `{}`.'
DIAG_CAST_TYPE_MISMATCH               =
'Não é possível converter `{ref}` para `{def}`。'
DIAG_MISSING_RETURN_VALUE             =
'Pelo menos {min} valores de retorno são necessários, mas aqui apenas {rmax} valores são retornados.'
DIAG_MISSING_RETURN_VALUE_RANGE       =
'Pelo menos {min} valores de retorno são necessários, mas aqui apenas {rmin} a {rmax} valores são retornados.'
DIAG_REDUNDANT_RETURN_VALUE           =
'No máximo {max} valores retornados, mas o {rmax}º valor foi retornado aqui.'
DIAG_REDUNDANT_RETURN_VALUE_RANGE     =
'No máximo {max} valores retornados, mas {rmin}º a {rmax}º valores foram retornados aqui.'
DIAG_MISSING_RETURN                   =
'Valor de retorno é necessário aqui.'
DIAG_RETURN_TYPE_MISMATCH             =
'O tipo do {index}º valor de retorno é `{def}`, mas o retorno real é `{ref}`.\n{err}'
DIAG_UNKNOWN_OPERATOR                 =
'Operador desconhecido `{}`.'
DIAG_UNREACHABLE_CODE                 =
'Código inalcançável.'
DIAG_INVISIBLE_PRIVATE                =
'Campo `{field}` é privado, pode ser acessado apenas na classe `{class}`.'
DIAG_INVISIBLE_PROTECTED              =
'Campo `{field}` é protegido, pode ser acessado apenas na classe `{class}` e suas subclasses.'
DIAG_INVISIBLE_PACKAGE                =
'Campo `{field}` pode ser acessado apenas no mesmo arquivo `{uri}`.'
DIAG_GLOBAL_ELEMENT                  =
'Elemento é global.'
DIAG_MISSING_FIELDS                   =
'Campos obrigatórios ausentes no tipo `{1}`: {2}'
DIAG_INJECT_FIELD                     =
'Campos não podem ser injetados na referência de `{class}` para `{field}`. {fix}'
DIAG_INJECT_FIELD_FIX_CLASS           =
'Para fazer isso, use `---@class` para `{node}`.'
DIAG_INJECT_FIELD_FIX_TABLE           =
'Para permitir injeção, adicione `{fix}` na definição.'

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
WORKSPACE_SCAN_TOO_MUCH   =
'Mais de {} arquivos foram escaneados. O diretório atual escaneado é `{}`. Por favor, veja o [FAQ](https://luals.github.io/wiki/faq#how-can-i-improve-startup-speeds) para saber como incluir menos arquivos. Também é possível que sua [configuração esteja incorreta](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder).'

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
PARSER_MISS_LOOP_MIN    =
'Falta o valor inicial do loop.'
PARSER_MISS_LOOP_MAX    =
'Falta o valor limite do loop.'
PARSER_MISS_FIELD       =
'<field> esperado.'
PARSER_MISS_METHOD      =
'<method> esperado.'
PARSER_ARGS_AFTER_DOTS  =
'`...` deve ser o último argumento.'
PARSER_UNSUPPORT_NAMED_VARARG =
'A sintaxe `(...name)` é suportada em {version}.'
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
PARSER_AMBIGUOUS_SYNTAX   =
'Em Lua 5.1, os colchetes esquerdos chamados pela função devem estar na mesma linha da função.'
PARSER_NEED_PAREN         =
'É necessário adicionar um par de parênteses.'
PARSER_NESTING_LONG_MARK  =
'Aninhamento de `[[...]]` não é permitido em Lua 5.1.'
PARSER_LOCAL_LIMIT        =
'Apenas 200 variáveis locais ativas e upvalues podem existir ao mesmo tempo.'
PARSER_VARIABLE_NOT_DECLARED =
'Variável `{name}` não foi declarada. (Use `global *` para permitir variáveis indefinidas, ou declare com `global {name}`)'
PARSER_ENV_IS_GLOBAL         =
'_ENV é global ao acessar a variável `{name}`.'
PARSER_ASSIGN_CONST_GLOBAL   =
'Não é possível atribuir à variável global constante `{name}`.'
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
HOVER_DOCUMENT_LUA55    =
'https://www.lua.org/manual/5.5/manual.html#{}'
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
HOVER_NATIVE_DOCUMENT_LUA55     =
'command:extension.lua.doc?["en-us/55/manual.html/{}"]'
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
ACTION_FIX_ADD_PAREN    =
'Adicionar parênteses.'
ACTION_AUTOREQUIRE      =
"Importar '{}' como {}"

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
COMMAND_REFERENCE_COUNT    =
'{} referências'

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
WINDOW_PROCESSING_BUILD_META     =
'Processando meta de construção...'
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
WINDOW_SEARCHING_IN_FILES        =
'Procurando nos arquivos...'
WINDOW_CONFIG_LUA_DEPRECATED     =
'`config.lua` está obsoleto, por favor use `config.json` em vez disso.'
WINDOW_CONVERT_CONFIG_LUA        =
'Converter para `config.json`'
WINDOW_MODIFY_REQUIRE_PATH       =
'Deseja modificar o caminho do require?'
WINDOW_MODIFY_REQUIRE_OK         =
'Modificar'

CONFIG_LOAD_FAILED               =
'Não é possível ler o arquivo de configurações: {}'
CONFIG_LOAD_ERROR                =
'Configurando o erro de carregamento do arquivo: {}'
CONFIG_TYPE_ERROR                =
'O arquivo de configuração deve estar no formato LUA ou JSON: {}'
CONFIG_MODIFY_FAIL_SYNTAX_ERROR  =
'Falha ao modificar configurações, há erros de sintaxe no arquivo de configurações: {}'
CONFIG_MODIFY_FAIL_NO_WORKSPACE  =
[[
Falha ao modificar configurações:
* O modo atual é modo de arquivo único, o servidor não pode criar `.luarc.json` sem espaço de trabalho.
* O cliente de linguagem não suporta modificar configurações do lado do servidor.

Por favor, modifique as seguintes configurações manualmente:
{}
]]
CONFIG_MODIFY_FAIL               =
[[
Falha ao modificar configurações

Por favor, modifique as seguintes configurações manualmente:
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
CLI_CHECK_PROGRESS =
'Encontrados {} problemas em {} arquivos'
CLI_CHECK_RESULTS=
'Diagnóstico concluído, {} problema(s) encontrado(s), veja {}'
CLI_CHECK_RESULTS_OUTPATH =
'Diagnóstico completo, {} problemas encontrados, veja {}'
CLI_CHECK_RESULTS_PRETTY =
'Diagnóstico completo, {} problemas encontrados'
CLI_CHECK_MULTIPLE_WORKERS =
'Iniciando {} tarefas de trabalho, saída de progresso será desabilitada. Isso pode levar alguns minutos.'
CLI_DOC_INITING   =
'Carregando documentos...'
CLI_DOC_DONE      =
'Documentos exportados:'
CLI_DOC_WORKING   =
'Construindo docs...'

TYPE_ERROR_ENUM_GLOBAL_DISMATCH =
'Tipo `{child}` não pode corresponder ao tipo de enumeração de `{parent}`'
TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED =
'Não é possível usar genérico `{child}` em enumeração'
TYPE_ERROR_ENUM_LITERAL_DISMATCH =
'Literal `{child}` não pode corresponder ao valor de enumeração de `{parent}`'
TYPE_ERROR_ENUM_OBJECT_DISMATCH =
'O objeto `{child}` não pode corresponder ao valor de enumeração de `{parent}`. Eles devem ser o mesmo objeto'
TYPE_ERROR_ENUM_NO_OBJECT =
'O valor de enumeração `{child}` passado não é reconhecido'
TYPE_ERROR_INTEGER_DISMATCH =
'Literal `{child}` não pode corresponder ao inteiro `{parent}`'
TYPE_ERROR_STRING_DISMATCH =
'Literal `{child}` não pode corresponder à string `{parent}`'
TYPE_ERROR_BOOLEAN_DISMATCH =
'Literal `{child}` não pode corresponder ao booleano `{parent}`'
TYPE_ERROR_TABLE_NO_FIELD =
'Campo `{key}` não existe na tabela'
TYPE_ERROR_TABLE_FIELD_DISMATCH =
'O tipo do campo `{key}` é `{child}`, que não pode corresponder a `{parent}`'
TYPE_ERROR_CHILD_ALL_DISMATCH =
'Todos os subtipos em `{child}` não podem corresponder a `{parent}`'
TYPE_ERROR_PARENT_ALL_DISMATCH =
'`{child}` não pode corresponder a nenhum subtipo em `{parent}`'
TYPE_ERROR_UNION_DISMATCH =
'`{child}` não pode corresponder a `{parent}`'
TYPE_ERROR_OPTIONAL_DISMATCH =
'Tipo opcional não pode corresponder a `{parent}`'
TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER =
'O número `{child}` não pode ser convertido para um inteiro'
TYPE_ERROR_NUMBER_TYPE_TO_INTEGER =
'Não é possível converter tipo número para tipo inteiro'
TYPE_ERROR_DISMATCH =
'Tipo `{child}` não pode corresponder a `{parent}`'

LUADOC_DESC_CLASS =
[=[
Define uma estrutura de classe/tabela
## Sintaxe
`---@class <nome> [: <pai>[, <pai>]...]`
## Uso
```
---@class Manager: Person, Human
Manager = {}
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#class)
]=]
LUADOC_DESC_TYPE =
[=[
Especifica o tipo de uma determinada variável

Tipos padrão: `nil`, `any`, `boolean`, `string`, `number`, `integer`,
`function`, `table`, `thread`, `userdata`, `lightuserdata`

(Tipos personalizados podem ser fornecidos usando `@alias`)

## Sintaxe
`---@type <tipo>[| [tipo]...`

## Uso
### Geral
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

### Tabelas
```
---@type table<string, boolean>
local settings = {
    disableLogging = true,
    preventShutdown = false,
}

---@type { [string]: true }
local x --x[""] é true
```

### Funções
```
---@type fun(mode?: "r"|"w"): string
local myFunction
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#type)
]=]
LUADOC_DESC_ALIAS =
[=[
Crie seu próprio tipo personalizado que pode ser usado com `@param`, `@type`, etc.

## Sintaxe
`---@alias <nome> <tipo> [descrição]`\
ou
```
---@alias <nome>
---| 'valor' [# comentário]
---| 'valor2' [# comentário]
...
```

## Uso
### Expandir para outro tipo
```
---@alias filepath string Caminho para um arquivo

---@param path filepath Caminho para o arquivo a pesquisar
function find(path, pattern) end
```

### Enums
```
---@alias font-style
---| '"underlined"' # Sublinhar o texto
---| '"bold"' # Negrito no texto
---| '"italic"' # Italicizar o texto

---@param style font-style Estilo a aplicar
function setFontStyle(style) end
```

### Enum Literal
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
[Ver Wiki](https://luals.github.io/wiki/annotations#alias)
]=]
LUADOC_DESC_PARAM =
[=[
Declara um parâmetro de função

## Sintaxe
`@param <nome>[?] <tipo> [comentário]`

## Uso
### Geral
```
---@param url string A url para solicitar
---@param headers? table<string, string> Cabeçalhos HTTP a enviar
---@param timeout? number Tempo limite em segundos
function get(url, headers, timeout) end
```

### Argumentos Variáveis
```
---@param base string A base para concatenar
---@param ... string Os valores a concatenar
function concat(base, ...) end
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#param)
]=]
LUADOC_DESC_RETURN =
[=[
Declara um valor de retorno

## Sintaxe
`@return <tipo> [nome] [descrição]`\
ou\
`@return <tipo> [# descrição]`

## Uso
### Geral
```
---@return number
---@return number # O componente verde
---@return number b O componente azul
function hexToRGB(hex) end
```

### Apenas tipo e nome
```
---@return number x, number y
function getCoords() end
```

### Apenas tipo
```
---@return string, string
function getFirstLast() end
```

### Retornar valores variáveis
```
---@return string ... As tags do item
function getTags(item) end
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#return)
]=]
LUADOC_DESC_FIELD =
[=[
Declara um campo em uma classe/tabela. Isso permite fornecer documentação mais detalhada
para uma tabela. A partir da versão `v3.6.0`, você pode marcar um campo como `private`,
`protected`, `public`, ou `package`.

## Sintaxe
`---@field <nome> <tipo> [descrição]`

## Uso
```
---@class HTTP_RESPONSE
---@field status HTTP_STATUS
---@field headers table<string, string> Os cabeçalhos da resposta

---@class HTTP_STATUS
---@field code number O código de status da resposta
---@field message string Uma mensagem informando o status

---@return HTTP_RESPONSE response A resposta do servidor
function get(url) end

--Esta variável response tem todos os campos definidos acima
response = get("localhost")

--Intellisense fornecido pela extensão para a atribuição abaixo
statusCode = response.status.code
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#field)
]=]
LUADOC_DESC_GENERIC =
[=[
Simula genéricos. Genéricos podem permitir que os tipos sejam reutilizados, pois ajudam a definir
uma "forma genérica" que pode ser usada com diferentes tipos.

## Sintaxe
`---@generic <nome> [:tipo_pai] [, <nome> [:tipo_pai]]`

## Uso
### Geral
```
---@generic T
---@param value T O valor a retornar
---@return T value O mesmo valor exato
function echo(value)
    return value
end

-- Tipo é string
s = echo("e")

-- Tipo é number
n = echo(10)

-- Tipo é boolean
b = echo(true)

-- Obtivemos todas essas informações apenas usando
-- @generic em vez de especificar manualmente
-- cada tipo permitido
```

### Capturar nome do tipo genérico
```
---@class Foo
local Foo = {}
function Foo:Bar() end

---@generic T
---@param name `T` # o nome do tipo genérico é capturado aqui
---@return T       # tipo genérico é retornado
function Generic(name) end

local v = Generic("Foo") -- v é um objeto de Foo
```

### Como as tabelas Lua usam genéricos
```
---@class table<K, V>: { [K]: V }

-- Isso é o que nos permite criar uma tabela
-- e o intellisense mantém o controle de qualquer tipo
-- que damos para chave (K) ou valor (V)
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations/#generic)
]=]
LUADOC_DESC_VARARG =
[=[
Principalmente para suporte legado de anotações EmmyLua. `@vararg` não
fornece tipagem ou permite descrições.

**Você deve usar `@param` ao documentar parâmetros (variáveis ou não).**

## Sintaxe
`@vararg <tipo>`

## Uso
```
---Concatenar strings
---@vararg string
function concat(...) end
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#vararg)
]=]
LUADOC_DESC_OVERLOAD =
[=[
Permite a definição de múltiplas assinaturas de função.

## Sintaxe
`---@overload fun(<nome>[: <tipo>] [, <nome>[: <tipo>]]...)[: <tipo>[, <tipo>]...]`

## Uso
```
---@overload fun(t: table, value: any): number
function table.insert(t, position, value) end
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#overload)
]=]
LUADOC_DESC_DEPRECATED =
[=[
Marca uma função como obsoleta. Isso resulta em quaisquer chamadas de função obsoletas
sendo ~~riscadas~~.

## Sintaxe
`---@deprecated`

---
[Ver Wiki](https://luals.github.io/wiki/annotations#deprecated)
]=]
LUADOC_DESC_META =
[=[
Indica que este é um arquivo meta e deve ser usado apenas para definições e intellisense.

Há 3 distinções principais a observar com arquivos meta:
1. Não haverá intellisense baseado em contexto em um arquivo meta
2. Passar o mouse sobre um caminho de arquivo `require` em um arquivo meta mostra `[meta]` em vez de um caminho absoluto
3. A função `Localizar Referência` ignorará arquivos meta

## Sintaxe
`---@meta`

---
[Ver Wiki](https://luals.github.io/wiki/annotations#meta)
]=]
LUADOC_DESC_VERSION =
[=[
Especifica as versões Lua às quais esta função é exclusiva.

Versões Lua: `5.1`, `5.2`, `5.3`, `5.4`, `JIT`.

Requer configurar a configuração `Diagnostics: Needed File Status`.

## Sintaxe
`---@version <versão>[, <versão>]...`

## Uso
### Geral
```
---@version JIT
function onlyWorksInJIT() end
```
### Especificar múltiplas versões
```
---@version <5.2,JIT
function oldLuaOnly() end
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#version)
]=]
LUADOC_DESC_SEE =
[=[
Define algo que pode ser visualizado para mais informações

## Sintaxe
`---@see <texto>`

---
[Ver Wiki](https://luals.github.io/wiki/annotations#see)
]=]
LUADOC_DESC_DIAGNOSTIC =
[=[
Habilitar/desabilitar diagnósticos para erros/avisos/etc.

Ações: `disable`, `enable`, `disable-line`, `disable-next-line`

[Nomes](https://github.com/LuaLS/lua-language-server/blob/cbb6e6224094c4eb874ea192c5f85a6cba099588/script/proto/define.lua#L54)

## Sintaxe
`---@diagnostic <ação>[: <nome>]`

## Uso
### Desabilitar próxima linha
```
---@diagnostic disable-next-line: undefined-global
```

### Alternar manualmente
```
---@diagnostic disable: unused-local
local unused = "hello world"
---@diagnostic enable: unused-local
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#diagnostic)
]=]
LUADOC_DESC_MODULE =
[=[
Fornece a semântica de `require`.

## Sintaxe
`---@module <'nome_modulo'>`

## Uso
```
---@module 'string.utils'
local stringUtils
-- Isso é funcionalmente o mesmo que:
local module = require('string.utils')
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#module)
]=]
LUADOC_DESC_ASYNC =
[=[
Marca uma função como assíncrona.

## Sintaxe
`---@async`

---
[Ver Wiki](https://luals.github.io/wiki/annotations#async)
]=]
LUADOC_DESC_NODISCARD =
[=[
Impede que os valores de retorno desta função sejam descartados/ignorados.
Isso levantará o aviso `discard-returns` caso os valores de retorno
sejam ignorados.

## Sintaxe
`---@nodiscard`

---
[Ver Wiki](https://luals.github.io/wiki/annotations#nodiscard)
]=]
LUADOC_DESC_CAST =
[=[
Permite conversão de tipo (type casting).

## Sintaxe
`@cast <variável> <[+|-]tipo>[, <[+|-]tipo>]...`

## Uso
### Sobrescrever tipo
```
---@type integer
local x --> integer

---@cast x string
print(x) --> string
```
### Adicionar tipo
```
---@type string
local x --> string

---@cast x +boolean, +number
print(x) --> string|boolean|number
```
### Remover tipo
```
---@type string|table
local x --> string|table

---@cast x -string
print(x) --> table
```
---
[Ver Wiki](https://luals.github.io/wiki/annotations#cast)
]=]
LUADOC_DESC_OPERATOR =
[=[
Fornecer declaração de tipo para [metamethods de operador](http://lua-users.org/wiki/MetatableEvents).

## Sintaxe
`@operator <operação>[(tipo_entrada)]:<tipo_resultado>`

## Uso
### Metamethod de adição de vetor
```
---@class Vector
---@operator add(Vector):Vector

vA = Vector.new(1, 2, 3)
vB = Vector.new(10, 20, 30)

vC = vA + vB
--> Vector
```
### Menos unário
```
---@class Passcode
---@operator unm:integer

pA = Passcode.new(1234)
pB = -pA
--> integer
```
[Ver Solicitação](https://github.com/LuaLS/lua-language-server/issues/599)
]=]
LUADOC_DESC_ENUM =
[=[
Marca uma tabela como um enum. Se você deseja um enum mas não pode defini-lo como uma
tabela Lua, veja a tag [`@alias`](https://luals.github.io/wiki/annotations#alias).

## Sintaxe
`@enum <nome>`

## Uso
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

-- Completion e hover são fornecidos para o parâmetro abaixo
setColor(colors.green)
```
]=]
LUADOC_DESC_SOURCE =
[=[
Fornecer uma referência a algum código-fonte que reside em outro arquivo. Ao
pesquisar a definição de um item, seu `@source` será usado.

## Sintaxe
`@source <caminho>`

## Uso
```
---Você pode usar caminhos absolutos
---@source C:/Users/me/Documents/program/myFile.c
local a

---Ou URIs
---@source file:///C:/Users/me/Documents/program/myFile.c:10
local b

---Ou caminhos relativos
---@source local/file.c
local c

---Você também pode incluir números de linha e caractere
---@source local/file.c:10:8
local d
```
]=]
LUADOC_DESC_PACKAGE =
[=[
Marca uma função como privada ao arquivo em que é definida. Uma função empacotada
não pode ser acessada de outro arquivo.

## Sintaxe
`@package`

## Uso
```
---@class Animal
---@field private eyes integer
local Animal = {}

---@package
---Isso não pode ser acessado em outro arquivo
function Animal:eyesCount()
    return self.eyes
end
```
]=]
LUADOC_DESC_PRIVATE =
[=[
Marca uma função como privada a uma @class. Funções privadas podem ser acessadas apenas
dentro de sua classe e não são acessíveis a partir de classes filhas.

## Sintaxe
`@private`

## Uso
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

---NÃO PERMITIDO!
myDog:eyesCount();
```
]=]
LUADOC_DESC_PROTECTED =
[=[
Marca uma função como protegida dentro de uma @class. Funções protegidas podem ser
acessadas apenas de dentro de sua classe ou de classes filhas.

## Sintaxe
`@protected`

## Uso
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

---Permitido porque a função é protegida, não privada.
myDog:eyesCount();
```
]=]
