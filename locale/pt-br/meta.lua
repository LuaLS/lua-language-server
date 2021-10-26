-- basic
arg                 = 'Argumentos de inicialização para a versão Standalone da linguagem Lua.'
assert              = 'Emite um erro se o valor de seu argumento v for falso (i.e., `nil` ou `false`); caso contrário, devolve todos os seus argumentos. Em caso de erro, `message` é o objeto de erro que, quando ausente, por padrão é `"assertion failed!"`'
cgopt.collect       = 'Realiza um ciclo completo de coleta de lixo (i.e., garbage-collection cycle).'
cgopt.stop          = 'Interrompe a execução automática.'
cgopt.restart       = 'Reinicia a execução automática.'
cgopt.count         = 'Retorna, em Kbytes, a quantidade total de memória utilizada pela linguagem Lua.'
cgopt.step          = 'Executa a coleta de lixo (i.e., garbage-collection) em uma única etapa. A quantidade de execuções por etapa é controlada via `arg`.'
cgopt.setpause      = 'Estabelece pausa. Defina via `arg` o intervalo de pausa do coletor de lixo (i.e., garbage-collection).'
cgopt.setstepmul    = 'Estabelece um multiplicador para etapa de coleta de lixo (i.e., garbage-collection). Defina via `arg` o valor multiplicador.'
cgopt.incremental   = 'Altera o modo do coletor para incremental.'
cgopt.generational  = 'Altera o modo do coletor para geracional.'
cgopt.isrunning     = 'Retorna um valor booleano indicando se o coletor de lixo (i.e., garbage-collection) está em execução.'
collectgarbage      = 'Esta função é uma interface genérica para o coletor de lixo (i.e., garbage-collection). Ela executa diferentes funções de acordo com seu primeiro argumento, `opt`.'
dofile              = 'Abre o arquivo passado por argumento e executa seu conteúdo como código Lua. Quando chamado sem argumentos, `dofile` executa o conteúdo da entrada padrão (`stdin`). Retorna todos os valores retornados pelo trecho de código contido no arquivo. Em caso de erros, o `dofile` propaga o erro para seu chamador. Ou seja, o `dofile` não funciona em modo protegido.'
error               = [[
Termina a última chamada de função protegida e retorna `message` como objeto de `erro`.

Normalmente, o 'erro' adiciona algumas informações sobre a localização do erro no início da mensagem, quando a mensagem for uma string.
]]
_G                  = 'Uma variável global (não uma função) que detém o ambiente global (ver §2.2). Lua em si não usa esta variável; mudar seu valor não afeta nenhum ambiente e vice-versa.'
getfenv             = 'Retorna o ambiente atual em uso pela função. O `f` pode ser uma função Lua ou um número que especifica a função naquele nível de pilha.'
getmetatable        = 'Se o objeto não tiver uma metatable, o retorno é `nil`. Mas caso a metatable do objeto tenha um campo `__metatable`, é retornado o valor associado. Caso contrário, retorna a metatable do objeto dado.'
ipairs              = [[
Retorna três valores (uma função iteradora, a tabela `t`, e `0`) para que a seguinte construção
```lua
    for i,v in ipairs(t) do body end
```
possa iterar sobre os pares de valor-chave `(1,t[1]), (2,t[2]), ...`, até o primeiro índice ausente.
]]
loadmode.b          = 'Somente blocos binários.'
loadmode.t          = 'Somente blocos de texto.'
loadmode.bt         = 'Tanto binário quanto texto.'
load['<5.1']        = 'Carrega um bloco utilizando a função `func` para obter suas partes. Cada chamada para o `func` deve retornar uma string que é concatenada com os resultados anteriores.'
load['>5.2']        = [[
Carrega um bloco.

Se o bloco (i.e., `chunk`) é uma string, o bloco é essa string. Se o bloco é uma função, a função "load" é chamada repetidamente para obter suas partes. Cada chamada para o bloco deve retornar uma string que é concatenada com os resultados anteriores. O retorno de uma string vazia, `nil`, ou nenhum valor sinaliza o fim do bloco.
]]
loadfile            = 'Carrega um bloco de arquivo `filename` ou da entrada padrão, se nenhum nome de arquivo for dado.'
loadstring          = 'Carrega um bloco a partir de uma string dada.'
module              = 'Cria um módulo.'
next                = [[
Permite que um programa percorra todos os campos de uma tabela. Seu primeiro argumento é uma tabela e seu segundo argumento é um índice nesta tabela. Uma chamada `next` retorna o próximo índice da tabela e seu valor associado. Quando chamado usando `nil` como segundo argumento, `next` retorna um índice inicial e seu valor associado. Quando chamado com o último índice, ou com `nil` em uma tabela vazia, o `next` retorna o `nil`. Se o segundo argumento estiver ausente, então é interpretado como `nil`. Portanto, pode-se utilizar o `next(t)` para verificar se uma tabela está vazia.

A ordem na qual os índices são enumerados não é especificada, *mesmo para índices numéricos*. (Para percorrer uma tabela em ordem numérica, utilize um `for`).

O comportamento do `next` é indefinido se, durante a iteração/travessia, você atribuir qualquer valor a um campo inexistente na tabela. Você pode, entretanto, modificar os campos existentes e pode, inclusive, os definir como nulos.
]]
pairs               = [[
Se `t` tem um "meta" método (i.e., metamethod) `__pairs`, a chamada é feita usando t como argumento e retorna os três primeiros resultados.

Caso contrário, retorna três valores: a função $next, a tabela `t` e `nil`, para que a seguinte construção
```lua
    for k,v in pairs(t) do body end
```
possa iterar sobre todos os pares de valor-chave da tabela 't'.

Veja a função $next para saber as ressalvas em modificar uma tabela durante sua iteração.
]]
pcall               = [[
Chama a função `f` com os argumentos dados em modo *protegido*. Isto significa que qualquer erro dentro de `f` não é propagado; em vez disso, o `pcall` captura o erro e retorna um código de status. Seu primeiro resultado é o código de status (booleano), que é verdadeiro se a chamada for bem sucedida sem erros. Neste caso, `pcall' também retorna todos os resultados da chamada, após este primeiro resultado. Em caso de qualquer erro, `pcall` retorna `false` mais o objeto de erro.
]]
print               = [[
Recebe qualquer número de argumentos e imprime seus valores na saída padrão `stdout`, convertendo cada argumento em uma string seguindo as mesmas regras do $tostring.
A função `print` não é destinada à saída formatada, mas apenas como uma forma rápida de mostrar um valor, por exemplo, para debugging. Para controle completo sobre a saída, use $string.format e $io.write.
]]
rawequal            = 'Verifica se v1 é igual a v2, sem invocar a metatable `__eq`.'
rawget              = 'Obtém o valor real de `table[index]`, sem invocar a metatable `__index`.'
rawlen              = 'Retorna o comprimento do objeto `v`, sem invocar a metatable `__len`.'
rawset              = [[
Define o valor real de `table[index]` para `value`, sem utilizar o metavalue `__newindex`. `table` deve ser uma tabela, `index` qualquer valor diferente de `nil` e `NaN`, e `value` qualquer valor de tipos do Lua.
Esta função retorna uma `table`.
]]
select              = 'Se `index` é um número, retorna todos os argumentos após o número do argumento `index`; um número negativo de índices do final (`-1` é o último argumento). Caso contrário, `index` deve ser a string `"#"`, e `select` retorna o número total de argumentos extras dados.'
setfenv             = 'Define o ambiente a ser utilizado pela função em questão.'
setmetatable        = [[
Define a metatable para a tabela dada. Se `metatabela` for `nil`, remove a metatable da tabela em questão. Se a metatable original tiver um campo `__metatable', um erro é lançado.

Esta função retorna uma `table`.

Para alterar a metatable de outros tipos do código Lua, você deve utilizar a biblioteca de debugging (§6.10).
]]
tonumber            = [[
Quando chamado sem a base, `tonumber` tenta converter seu argumento para um número. Se o argumento já for um número ou uma string numérica, então `tonumber` retorna este número; caso contrário, retorna `fail`.

A conversão de strings pode resultar em números inteiros ou de ponto flutuante, de acordo com as convenções lexicais de Lua (ver §3.1). A string pode ter espaços antes e depois e um sinal.
]]
tostring            = [[
Recebe um valor de qualquer tipo e o converte em uma string em formato legível por humanos.

Se a metatable de `v` tem um campo `__tostring', então `tostring' chama o valor correspondente usando `v` como argumento, e utiliza o resultado da chamada como seu resultado. Caso contrário, se a metatable de `v` tiver um campo `__name` com um valor do tipo string, `tostring` pode utilizar essa string em seu resultado final.

Para controle completo de como os números são convertidos, utilize $string.format.
]]
type                = [[
Retorna o tipo de seu único argumento, codificado como uma string. Os resultados possíveis desta função são `"nil"` (uma string, não o valor `nil`), `"number"`, `"string"`, `"boolean"`, `"table"`, `"function"`, `"thread"`, e `"userdata"`.
]]
_VERSION            = 'Uma variável global (não uma função) que contém uma string contendo a versão Lua em execução.'
warn                = 'Emite um aviso com uma mensagem composta pela concatenação de todos os seus argumentos (que devem ser strings).'
xpcall['=5.1']      = 'Faz chamada a função `f` com os argumentos dados e em modo protegido, usando um manipulador de mensagens dado.'
xpcall['>5.2']      = 'Faz chamada a função `f` com os argumentos dados e em modo protegido, usando um manipulador de mensagens dado.'
unpack              = [[
Retorna os elementos da lista dada. Esta função é equivalente a
```lua
    return list[i], list[i+1], ···, list[j]
```
]]

bit32               = ''
bit32.arshift       = [[
Retorna o número `x` deslocado `disp` bits para a direita. Deslocamentos negativos movem os bits para a esquerda.

Esta operação de deslocamento é chamada de deslocamento aritmético. Os bits vagos à esquerda são preenchidos com cópias do bit mais significativo de `x`; os bits vagos à direita são preenchidos com zeros.
]]
bit32.band          = 'Retorna a operação bitwise *and* de seus operandos.'
bit32.bnot          = [[
Retorna a negação da operação bitwise de `x`.

```lua
assert(bit32.bnot(x) == (-1 - x) % 2^32)
```
]]
bit32.bor           = 'Retorna a operação bitwise *or* de seus operandos.'
bit32.btest         = 'Retorna um valor booleano verdadeiro se a operação bitwise *and* de seus operandos for diferente de zero. Falso, caso contrário.'
bit32.bxor          = 'Retorna a operação bitwise *exclusive or* de seus operandos.'
bit32.extract       = 'Retorna o número formado pelos bits de `field` a `field + width - 1` de `n`, sem sinal.'
bit32.replace       = 'Retorna uma cópia de `n` com os bits de `field` a `field + width - 1` substituídos pelo valor `v` .'
bit32.lrotate       = 'Retorna o número `x` rotacionado `disp` bits para a esquerda. Rotações negativos movem os bits para a direita. '
bit32.lshift        = [[
Retorna o número `x` deslocado `disp` bits para a esquerda. Deslocamentos negativos movem os bits para a direita. Em ambas as direções, os bits vazios/vagos são preenchidos com zeros.

```lua
assert(bit32.lshift(b, disp) == (b * 2^disp) % 2^32)
```
]]
bit32.rrotate       = 'Retorna o número `x` rotacionado `disp` bits para a direita. Deslocamentos negativos movem os bits para a esquerda.'
bit32.rshift        = [[
Retorna o número `x` deslocado `disp` bits para a direita. Deslocamentos negativos movem os bits para a esquerda. Em ambas as direções, os bits vazios são preenchidos com zeros.

```lua
assert(bit32.rshift(b, disp) == math.floor(b % 2^32 / 2^disp))
```
]]

coroutine                   = ''
coroutine.create            = 'Cria uma nova `coroutine`, a partir de uma função `f` e retorna esta coroutine como objeto do tipo `"thread"`.'
coroutine.isyieldable       = 'Retorna verdadeiro quando a `coroutine` em execução for finalizada.'
coroutine.isyieldable['>5.4']= 'Retorna verdadeiro quando a `coroutine` `co` for finalizada. Por padrão `co` é uma coroutine em execução.'
coroutine.close             = 'Finaliza a coroutine `co` , encerrando todas as variáveis pendentes e colocando a coroutine em um estado morto.'
coroutine.resume            = 'Inicia ou continua a execução da coroutine `co`.'
coroutine.running           = 'Retorna a `coroutine` corrente e um booleana verdadeiro quando a coroutine corrente é a principal.'
coroutine.status            = 'Retorna o status da `coroutine `co`.'
coroutine.wrap              = 'Cria uma nova `coroutine`, a partir de uma função `f` e retorna uma função que retorna a coroutine cada vez que ele é chamado.'
coroutine.yield             = 'Suspende a execução da coroutine chamada.'
costatus.running            = 'Está em execução.'
costatus.suspended          = 'Está suspenso ou não foi iniciado.'
costatus.normal             = 'Está ativo, mas não está em execução.'
costatus.dead               = 'Terminou ou parou devido a erro'

debug                       = ''
debug.debug                 = 'Entra em modo interativo com o usuário, executando os comandos de entrada.'
debug.getfenv               = 'Retorna o ambiente do objeto `o` .'
debug.gethook               = 'Retorna as configurações do `hook` atual da `thread`.'
debug.getinfo               = 'Retorna uma tabela com informações sobre uma função.'
debug.getlocal['<5.1']      = 'Retorna o nome e o valor da variável local com índice `local` da função de nível `level` da pilha.'
debug.getlocal['>5.2']      = 'Retorna o nome e o valor da variável local com índice `local` da função de nível `f` da pilha.'
debug.getmetatable          = 'Retorna a `metatable` do valor dado.'
debug.getregistry           = 'Retorna a tabela de registro.'
debug.getupvalue            = 'Retorna o nome e o valor da variável antecedente com índice `up` da função.'
debug.getuservalue['<5.3']  = 'Retorna o valor de Lua associado a `u` (i.e., user).'
debug.getuservalue['>5.4']  = [[
Retorna o `n`-ésimo valor de usuário associado
aos dados do usuário `u` e um booleano, 
`false`, se nos dados do usuário não existir esse valor.
]]
debug.setcstacklimit        = [[
### **Deprecated in `Lua 5.4.2`**

Estabelece um novo limite para a pilha C. Este limite controla quão profundamente as chamadas aninhadas podem ir em Lua, com a intenção de evitar um transbordamento da pilha.

Em caso de sucesso, esta função retorna o antigo limite. Em caso de erro, ela retorna `false`.
]]
debug.setfenv               = 'Define o ambiente do `object` dado para a `table` dada .'
debug.sethook               = 'Define a função dada como um `hook`.'
debug.setlocal              = 'Atribui o valor `value` à variável local com índice `local` da função de nível `level` da pilha.'
debug.setmetatable          = 'Define a `metatable` com o valor dado para tabela dada (que pode ser `nil`).'
debug.setupvalue            = 'Atribui `value` a variável antecedente com índice `up` da função.'
debug.setuservalue['<5.3']  = 'Define o valor dado como o valor Lua associado ao `udata` (i.e., user data).'
debug.setuservalue['>5.4']  = [[
Define o valor dado como
o `n`-ésimo valor de usuário associado ao `udata` (i.e., user data).
O `udata` deve ser um dado de usuário completo.
]]
debug.traceback             = 'Retorna uma string com um `traceback` de chamadas. A string de mensagen (opcional) é anexada no início do traceback.'
debug.upvalueid             = 'Retorna um identificador único (como um dado de usuário leve) para o valor antecedente de numero `n` da função dada.'
debug.upvaluejoin           = 'Faz o `n1`-ésimo valor da função `f1` (i.e., closure Lua) referir-se ao `n2`-ésimo valor da função `f2`.'
infowhat.n                  = '`name` e `namewhat`'
infowhat.S                  = '`source`, `short_src`, `linedefined`, `lastlinedefined` e `what`'
infowhat.l                  = '`currentline`'
infowhat.t                  = '`istailcall`'
infowhat.u['<5.1']          = '`nups`'
infowhat.u['>5.2']          = '`nups`, `nparams` e `isvararg`'
infowhat.f                  = '`func`'
infowhat.r                  = '`ftransfer` e `ntransfer`'
infowhat.L                  = '`activelines`'
hookmask.c                  = 'Faz chamada a um `hook` quando o Lua chama uma função.'
hookmask.r                  = 'Faz chamada a um `hook` quando o retorno de uma função é executado.'
hookmask.l                  = 'Faz chamada a um `hook` quando encontra nova linha de código.'

file                        = ''
file[':close']              = 'Fecha o arquivo `file`.'
file[':flush']              = 'Salva qualquer dado de entrada no arquivo `file`.'
file[':lines']              = [[
------
```lua
for c in file:lines(...) do
    body
end
```
]]
file[':read']               = 'Lê o arquivo de acordo com os formatos indicados, que especificam o que ler.'
file[':seek']               = 'Define e obtém a posição do arquivo, medida a partir do início do arquivo.'
file[':setvbuf']            = 'Define o modo de `buffer` para um arquivo de saída.'
file[':write']              = 'Escreve o valor de cada um de seus argumentos no arquivo.'
readmode.n                  = 'Lê um numeral e o devolve como número.'
readmode.a                  = 'Lê o arquivo completo.'
readmode.l                  = 'Lê a próxima linha pulando o final da linha.'
readmode.L                  = 'Lê a próxima linha mantendo o final da linha.'
seekwhence.set              = 'O cursor base é o início do arquivo.'
seekwhence.cur              = 'O cursor base é a posição atual.'
seekwhence['.end']          = 'O cursor base é o final do arquivo.'
vbuf.no                     = 'A saída da operação aparece imediatamente.'
vbuf.full                   = 'Realizado apenas quando o `buffer` está cheio.'
vbuf.line                   = '`Buffered` até que uma nova linha seja encontrada.'

io                          = ''
io.stdin                    = 'Entrada padrão.'
io.stdout                   = 'Saída padrão.'
io.stderr                   = 'Erro padrão.'
io.close                    = 'Fecha o arquivo dado ou o arquivo de saída padrão.'
io.flush                    = 'Salva todos os dados gravados no arquivo de saída padrão.'
io.input                    = 'Define o arquivo de entrada padrão.'
io.lines                    = [[
------
```lua
for c in io.lines(filename, ...) do
    body
end
```
]]
io.open                     = 'Abre um arquivo no modo especificado pela *string* `mode`.'
io.output                   = 'Define o arquivo de saída padrão.'
io.popen                    = 'Inicia o programa dado em um processo separado.'
io.read                     = 'Lê o arquivo de acordo com o formato passado, que especifica o que deve ser lido.'
io.tmpfile                  = 'Em caso de sucesso, retorna um `handler` para um arquivo temporário.'
io.type                     = 'Verifica se `obj` é um identificador de arquivo válido.'
io.write                    = 'Escreve o valor de cada um dos seus argumentos para o arquivo de saída padrão.'
openmode.r                  = 'Modo de leitura.'
openmode.w                  = 'Modo de escrita/gravação.'
openmode.a                  = 'Modo de anexação.'
openmode['.r+']             = 'Modo de atualização, todos os dados anteriores são preservados.'
openmode['.w+']             = 'Modo de atualização, todos os dados anteriores são apagados.'
openmode['.a+']             = 'Modo de anexação e atualização, os dados anteriores são preservados, a gravação/escrita só é permitida no final do arquivo.'
openmode.rb                 = 'Modo de leitura. (em modo binário)'
openmode.wb                 = 'Modo de escrita/gravação. (em modo binário)'
openmode.ab                 = 'Modo de anexação. (em modo binário)'
openmode['.r+b']            = 'Modo de atualização, todos os dados anteriores são preservados. (em modo binário)'
openmode['.w+b']            = 'Modo de atualização, todos os dados anteriores são apagados. (em modo binário)'
openmode['.a+b']            = 'Modo de anexação e atualização, todos os dados anteriores são preservados, a escrita/gravação só é permitida no final do arquivo. (em modo binário)'
popenmode.r                 = 'Leia dados deste programa pelo arquivo.'
popenmode.w                 = 'Escreva dados neste programa pelo arquivo.'
filetype.file               = '`handler` para arquivo aberto.'
filetype['.closed file']    = '`handler` para arquivo fechado.'
filetype['.nil']            = 'Não é um `handler` de arquivo'

math                        = ''
math.abs                    = 'Retorna o valor absoluto de `x`.'
math.acos                   = 'Retorna o arco cosseno de `x` (em radianos).'
math.asin                   = 'Retorna o arco seno de `x` (em radianos).'
math.atan['<5.2']           = 'Retorna o arco tangente de `x` (em radianos).'
math.atan['>5.3']           = 'Retorna o arco tangente de `y/x` (em radianos).'
math.atan2                  = 'Retorna o arco tangente de `y/x` (em radianos).'
math.ceil                   = 'Retorna o menor valor inteiro maior ou igual a `x`.'
math.cos                    = 'Retorna o cosseno de `x` (requer valor em radianos).'
math.cosh                   = 'Retorna o cosseno hiperbólico de `x` (requer valor em radianos).'
math.deg                    = 'Converte o ângulo `x` de radianos para graus.'
math.exp                    = 'Retorna o valor `e^x` (onde `e` é a base do logaritmo natural).'
math.floor                  = 'Retorna o maior valor inteiro menor ou igual a `x`.'
math.fmod                   = 'Retorna o resto da divisão de `x` por `y` que arredonda o quociente para zero.'
math.frexp                  = 'Decompõe `x` em fatores e expoentes. Retorna `m` e `e` tal que `x = m * (2 ^ e)` é um inteiro e o valor absoluto de `m` está no intervalo [0,5, 1) (ou zero quando `x` é zero).'
math.huge                   = 'Um valor maior que qualquer outro valor numérico.'
math.ldexp                  = 'Retorna `m * (2 ^ e)`.'
math.log['<5.1']            = 'Retorna o logaritmo natural de `x`.'
math.log['>5.2']            = 'Retorna o logaritmo de `x` na base dada.'
math.log10                  = 'Retorna o logaritmo `x` na base 10.'
math.max                    = 'Retorna o argumento com o valor máximo de acordo com o operador `<`.'
math.maxinteger             = 'Retorna o valor máximo para um inteiro.'
math.min                    = 'Retorna o argumento com o valor mínimo de acordo com o operador `<`.'
math.mininteger             = 'Retorna o valor mínimo para um inteiro.'
math.modf                   = 'Retorna a parte inteira e a parte fracionária de `x`.'
math.pi                     = 'O valor de *π*.'
math.pow                    = 'Retorna `x ^ y`.'
math.rad                    = 'Converte o ângulo `x` de graus para radianos.'
math.random                 = [[
* `math.random()`: Retorna um valor real (i.e., ponto flutuante) no intervalo [0,1).
* `math.random(n)`: Retorna um inteiro no intervalo [1, n].
* `math.random(m, n)`: Retorna um inteiro no intervalo [m, n].
]]
math.randomseed['<5.3']     = 'Define `x` como valor semente (i.e., `seed`) para a função geradora de números pseudo-aleatória.'
math.randomseed['>5.4']     = [[
* `math.randomseed(x, y)`: Concatena `x` e `y` em um espaço de 128-bits que é usado como valor semente (`seed`) para reinicializar o gerador de números pseudo-aleatório.
* `math.randomseed(x)`: Equivale a `math.randomseed(x, 0)` .
* `math.randomseed()`: Gera um valor semente (i.e., `seed`) com fraca probabilidade de aleatoriedade.
]]
math.sin                    = 'Retorna o seno de `x` (requer valor em radianos).'
math.sinh                   = 'Retorna o seno hiperbólico de `x` (requer valor em radianos).'
math.sqrt                   = 'Retorna a raiz quadrada de `x`.'
math.tan                    = 'Retorna a tangente de `x` (requer valor em radianos).'
math.tanh                   = 'Retorna a tangente hiperbólica de `x` (requer valor em radianos).'
math.tointeger              = 'Se o valor `x` pode ser convertido para um inteiro, retorna esse inteiro.'
math.type                   = 'Retorna `"integer"` se `x` é um inteiro, `"float"` se for um valor real (i.e., ponto flutuante), ou `nil` se `x` não é um número.'
math.ult                    = 'Retorna `true` se e somente se `m` é menor `n` quando eles são comparados como inteiros sem sinal.'

os                          = ''
os.clock                    = 'Retorna uma aproximação do valor, em segundos, do tempo de CPU usado pelo programa.'
os.date                     = 'Retorna uma string ou uma tabela contendo data e hora, formatada de acordo com a string `format` fornecida.'
os.difftime                 = 'Retorna a diferença, em segundos, do tempo `t1` para o tempo` t2`.'
os.execute                  = 'Passa `command` para ser executado por um `shell` do sistema operacional.'
os.exit['<5.1']             = 'Chama a função `exit` do C para encerrar o programa.'
os.exit['>5.2']             = 'Chama a função `exit` do ISO C para encerrar o programa.'
os.getenv                   = 'Retorna o valor da variável de ambiente de processo `varname`.'
os.remove                   = 'Remove o arquivo com o nome dado.'
os.rename                   = 'Renomeia o arquivo ou diretório chamado `oldname` para `newname`.'
os.setlocale                = 'Define a localidade atual do programa.'
os.time                     = 'Retorna a hora atual quando chamada sem argumentos, ou um valor representando a data e a hora local especificados pela tabela fornecida.'
os.tmpname                  = 'Retorna uma string com um nome de arquivo que pode ser usado como arquivo temporário.'
osdate.year                 = 'Quatro dígitos.'
osdate.month                = '1-12'
osdate.day                  = '1-31'
osdate.hour                 = '0-23'
osdate.min                  = '0-59'
osdate.sec                  = '0-61'
osdate.wday                 = 'Dia da semana, 1–7, Domingo é 1'
osdate.yday                 = 'Dia do ano, 1–366'
osdate.isdst                = 'Bandeira para indicar horário de verão (i.e., `Daylight Saving Time`), um valor booleano.'

package                     = ''
require['<5.3']             = 'Loads the given module, returns any value returned by the given module(`true` when `nil`).'
require['>5.4']             = 'Loads the given module, returns any value returned by the searcher(`true` when `nil`). Besides that value, also returns as a second result the loader data returned by the searcher, which indicates how `require` found the module. (For instance, if the module came from a file, this loader data is the file path.)'
package.config              = 'A string describing some compile-time configurations for packages.'
package.cpath               = 'The path used by `require` to search for a C loader.'
package.loaded              = 'A table used by `require` to control which modules are already loaded.'
package.loaders             = 'A table used by `require` to control how to load modules.'
package.loadlib             = 'Dynamically links the host program with the C library `libname`.'
package.path                = 'The path used by `require` to search for a Lua loader.'
package.preload             = 'A table to store loaders for specific modules.'
package.searchers           = 'A table used by `require` to control how to load modules.'
package.searchpath          = 'Searches for the given `name` in the given `path`.'
package.seeall              = 'Sets a metatable for `module` with its `__index` field referring to the global environment, so that this module inherits values from the global environment. To be used as an option to function `module` .'

string                      = ''
string.byte                 = 'Returns the internal numeric codes of the characters `s[i], s[i+1], ..., s[j]`.'
string.char                 = 'Returns a string with length equal to the number of arguments, in which each character has the internal numeric code equal to its corresponding argument.'
string.dump                 = 'Returns a string containing a binary representation (a *binary chunk*) of the given function.'
string.find                 = 'Looks for the first match of `pattern` (see §6.4.1) in the string.'
string.format               = 'Returns a formatted version of its variable number of arguments following the description given in its first argument.'
string.gmatch               = [[
Returns an iterator function that, each time it is called, returns the next captures from `pattern` (see §6.4.1) over the string s. 

As an example, the following loop will iterate over all the words from string s, printing one per line:
```lua
    s = "hello world from Lua"
    for w in string.gmatch(s, "%a+") do
        print(w)
    end
```
]]
string.gsub                 = 'Returns a copy of s in which all (or the first `n`, if given) occurrences of the `pattern` (see §6.4.1) have been replaced by a replacement string specified by `repl`.'
string.len                  = 'Returns its length.'
string.lower                = 'Returns a copy of this string with all uppercase letters changed to lowercase.'
string.match                = 'Looks for the first match of `pattern` (see §6.4.1) in the string.'
string.pack                 = 'Returns a binary string containing the values `v1`, `v2`, etc. packed (that is, serialized in binary form) according to the format string `fmt` (see §6.4.2) .'
string.packsize             = 'Returns the size of a string resulting from `string.pack` with the given format string `fmt` (see §6.4.2) .'
string.rep['>5.2']          = 'Returns a string that is the concatenation of `n` copies of the string `s` separated by the string `sep`.'
string.rep['<5.1']          = 'Returns a string that is the concatenation of `n` copies of the string `s` .'
string.reverse              = 'Returns a string that is the string `s` reversed.'
string.sub                  = 'Returns the substring of the string that starts at `i` and continues until `j`.'
string.unpack               = 'Returns the values packed in string according to the format string `fmt` (see §6.4.2) .'
string.upper                = 'Returns a copy of this string with all lowercase letters changed to uppercase.'

table                       = ''
table.concat                = 'Given a list where all elements are strings or numbers, returns the string `list[i]..sep..list[i+1] ··· sep..list[j]`.'
table.insert                = 'Inserts element `value` at position `pos` in `list`.'
table.maxn                  = 'Returns the largest positive numerical index of the given table, or zero if the table has no positive numerical indices.'
table.move                  = [[
Moves elements from table `a1` to table `a2`.
```lua
a2[t],··· = a1[f],···,a1[e]
return a2
```
]]
table.pack                  = 'Returns a new table with all arguments stored into keys `1`, `2`, etc. and with a field `"n"` with the total number of arguments.'
table.remove                = 'Removes from `list` the element at position `pos`, returning the value of the removed element.'
table.sort                  = 'Sorts list elements in a given order, *in-place*, from `list[1]` to `list[#list]`.'
table.unpack                = [[
Returns the elements from the given list. This function is equivalent to
```lua
    return list[i], list[i+1], ···, list[j]
```
By default, `i` is `1` and `j` is `#list`.
]]

utf8                        = ''
utf8.char                   = 'Receives zero or more integers, converts each one to its corresponding UTF-8 byte sequence and returns a string with the concatenation of all these sequences.'
utf8.charpattern            = 'The pattern which matches exactly one UTF-8 byte sequence, assuming that the subject is a valid UTF-8 string.'
utf8.codes                  = [[
Returns values so that the construction
```lua
for p, c in utf8.codes(s) do
    body
end
```
will iterate over all UTF-8 characters in string s, with p being the position (in bytes) and c the code point of each character. It raises an error if it meets any invalid byte sequence.
]]
utf8.codepoint              = 'Returns the codepoints (as integers) from all characters in `s` that start between byte position `i` and `j` (both included).'
utf8.len                    = 'Returns the number of UTF-8 characters in string `s` that start between positions `i` and `j` (both inclusive).'
utf8.offset                 = 'Returns the position (in bytes) where the encoding of the `n`-th character of `s` (counting from position `i`) starts.'
