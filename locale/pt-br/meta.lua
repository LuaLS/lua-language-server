---@diagnostic disable: undefined-global, lowercase-global

arg                 =
'Argumentos de inicialização para a versão standalone da linguagem Lua.'

assert              =
'Emite um erro se o valor de seu argumento v for falso (i.e., `nil` ou `false`); caso contrário, devolve todos os seus argumentos. Em caso de erro, `message` é o objeto de erro que, quando ausente, por padrão é `"assertion failed!"`'

cgopt.collect       =
'Realiza um ciclo completo de coleta de lixo (i.e., garbage-collection cycle).'
cgopt.stop          =
'Interrompe a execução automática.'
cgopt.restart       =
'Reinicia a execução automática.'
cgopt.count         =
'Retorna, em Kbytes, a quantidade total de memória utilizada pela linguagem Lua.'
cgopt.step          =
'Executa a coleta de lixo (i.e., garbage-collection) em uma única etapa. A quantidade de execuções por etapa é controlada via `arg`.'
cgopt.setpause      =
'Estabelece pausa. Defina via `arg` o intervalo de pausa do coletor de lixo (i.e., garbage-collection).'
cgopt.setstepmul    =
'Estabelece um multiplicador para etapa de coleta de lixo (i.e., garbage-collection). Defina via `arg` o valor multiplicador.'
cgopt.incremental   =
'Altera o modo do coletor para incremental.'
cgopt.generational  =
'Altera o modo do coletor para geracional.'
cgopt.isrunning     =
'Retorna um valor booleano indicando se o coletor de lixo (i.e., garbage-collection) está em execução.'

collectgarbage      =
'Esta função é uma interface genérica para o coletor de lixo (i.e., garbage-collection). Ela executa diferentes funções de acordo com seu primeiro argumento, `opt`.'

dofile              =
'Abre o arquivo fornecido por argumento e executa seu conteúdo como código Lua. Quando chamado sem argumentos, `dofile` executa o conteúdo da entrada padrão (`stdin`). Retorna todos os valores retornados pelo trecho de código contido no arquivo. Em caso de erros, o `dofile` propaga o erro para seu chamador. Ou seja, o `dofile` não funciona em modo protegido.'

error               =
[[
Termina a última chamada de função protegida e retorna `message` como objeto de `erro`.

Normalmente, o 'erro' adiciona algumas informações sobre a localização do erro no início da mensagem, quando a mensagem for uma string.
]]

_G                  =
'Uma variável global (não uma função) que detém o ambiente global (ver §2.2). Lua em si não usa esta variável; mudar seu valor não afeta nenhum ambiente e vice-versa.'

getfenv             =
'Retorna o ambiente atual em uso pela função. O `f` pode ser uma função Lua ou um número que especifica a função naquele nível de pilha.'

getmetatable        =
'Se o objeto não tiver uma metatable, o retorno é `nil`. Mas caso a metatable do objeto tenha um campo `__metatable`, é retornado o valor associado. Caso contrário, retorna a metatable do objeto dado.'

ipairs              =
[[
Retorna três valores (uma função iteradora, a tabela `t`, e `0`) para que a seguinte construção
```lua
    for i,v in ipairs(t) do body end
```
possa iterar sobre os pares de valor-chave `(1,t[1]), (2,t[2]), ...`, até o primeiro índice ausente.
]]

loadmode.b          =
'Somente blocos binários.'
loadmode.t          =
'Somente blocos de texto.'
loadmode.bt         =
'Tanto binário quanto texto.'

load['<5.1']        =
'Carrega um bloco utilizando a função `func` para obter suas partes. Cada chamada para o `func` deve retornar uma string que é concatenada com os resultados anteriores.'
load['>5.2']        =
[[
Carrega um bloco.

Se o bloco (i.e., `chunk`) é uma string, o bloco é essa string. Se o bloco é uma função, a função "load" é chamada repetidamente para obter suas partes. Cada chamada para o bloco deve retornar uma string que é concatenada com os resultados anteriores. O fim do bloco é sinalizado com o retorno de uma string vazia ou `nil`.
]]

loadfile            =
'Carrega um bloco de arquivo `filename` ou da entrada padrão, se nenhum nome de arquivo for dado.'

loadstring          =
'Carrega um bloco a partir de uma string dada.'

module              =
'Cria um módulo.'

next                =
[[
Permite que um programa percorra todos os campos de uma tabela. Seu primeiro argumento é uma tabela e seu segundo argumento é um índice nesta tabela. Uma chamada `next` retorna o próximo índice da tabela e seu valor associado. Quando chamado usando `nil` como segundo argumento, `next` retorna um índice inicial e seu valor associado. Quando chamado com o último índice, ou com `nil` em uma tabela vazia, o `next` retorna o `nil`. Se o segundo argumento estiver ausente, então é interpretado como `nil`. Portanto, pode-se utilizar o `next(t)` para verificar se uma tabela está vazia.

A ordem na qual os índices são enumerados não é especificada, *mesmo para índices numéricos*. (Para percorrer uma tabela em ordem numérica, utilize um `for`).

O comportamento do `next` é indefinido se, durante a iteração/travessia, você atribuir qualquer valor a um campo inexistente na tabela. Você pode, entretanto, modificar os campos existentes e pode, inclusive, os definir como nulos.
]]

pairs               =
[[
Se `t` tem um "meta" método (i.e., metamethod) `__pairs`, a chamada é feita usando t como argumento e retorna os três primeiros resultados.

Caso contrário, retorna três valores: a função $next, a tabela `t` e `nil`, para que a seguinte construção
```lua
    for k,v in pairs(t) do body end
```
possa iterar sobre todos os pares de valor-chave da tabela 't'.

Veja a função $next para saber as ressalvas em modificar uma tabela durante sua iteração.
]]

pcall               =
[[
Chama a função `f` com os argumentos dados em modo *protegido*. Isto significa que qualquer erro dentro de `f` não é propagado; em vez disso, o `pcall` captura o erro e retorna um código de status. Seu primeiro resultado é o código de status (booleano), que é verdadeiro se a chamada for bem sucedida sem erros. Neste caso, `pcall' também retorna todos os resultados da chamada, após este primeiro resultado. Em caso de qualquer erro, `pcall` retorna `false` mais o objeto de erro.
]]

print               =
[[
Recebe qualquer número de argumentos e imprime seus valores na saída padrão `stdout`, convertendo cada argumento em uma string seguindo as mesmas regras do $tostring.
A função `print` não é destinada à saída formatada, mas apenas como uma forma rápida de mostrar um valor, por exemplo, para debugging. Para controle completo sobre a saída, use $string.format e $io.write.
]]

rawequal            =
'Verifica se v1 é igual a v2, sem invocar a metatable `__eq`.'

rawget              =
'Obtém o valor real de `table[index]`, sem invocar a metatable `__index`.'

rawlen              =
'Retorna o comprimento do objeto `v`, sem invocar a metatable `__len`.'

rawset              =
[[
Define o valor real de `table[index]` para `value`, sem utilizar o metavalue `__newindex`. `table` deve ser uma tabela, `index` qualquer valor diferente de `nil` e `NaN`, e `value` qualquer valor de tipos do Lua.
Esta função retorna uma `table`.
]]

select              =
'Se `index` é um número, retorna todos os argumentos após o número do argumento `index`; um número negativo de índices do final (`-1` é o último argumento). Caso contrário, `index` deve ser a string `"#"`, e `select` retorna o número total de argumentos extras dados.'

setfenv             =
'Define o ambiente a ser utilizado pela função em questão.'

setmetatable        =
[[
Define a metatable para a tabela dada. Se `metatabela` for `nil`, remove a metatable da tabela em questão. Se a metatable original tiver um campo `__metatable', um erro é lançado.

Esta função retorna uma `table`.

Para alterar a metatable de outros tipos do código Lua, você deve utilizar a biblioteca de debugging (§6.10).
]]

tonumber            =
[[
Quando chamado sem a base, `tonumber` tenta converter seu argumento para um número. Se o argumento já for um número ou uma string numérica, então `tonumber` retorna este número; caso contrário, retorna `fail`.

A conversão de strings pode resultar em números inteiros ou de ponto flutuante, de acordo com as convenções lexicais de Lua (ver §3.1). A string pode ter espaços antes e depois e um sinal.
]]

tostring            =
[[
Recebe um valor de qualquer tipo e o converte em uma string em formato legível por humanos.

Se a metatable de `v` tem um campo `__tostring', então `tostring' chama o valor correspondente usando `v` como argumento, e utiliza o resultado da chamada como seu resultado. Caso contrário, se a metatable de `v` tiver um campo `__name` com um valor do tipo string, `tostring` pode utilizar essa string em seu resultado final.

Para controle completo de como os números são convertidos, utilize $string.format.
]]

type                =
[[
Retorna o tipo de seu único argumento, codificado como uma string. Os resultados possíveis desta função são `"nil"` (uma string, não o valor `nil`), `"number"`, `"string"`, `"boolean"`, `"table"`, `"function"`, `"thread"`, e `"userdata"`.
]]

_VERSION            =
'Uma variável global (não uma função) que contém uma string contendo a versão Lua em execução.'

warn                =
'Emite um aviso com uma mensagem composta pela concatenação de todos os seus argumentos (que devem ser strings).'

xpcall['=5.1']      =
'Faz chamada a função `f` com os argumentos dados e em modo protegido, usando um manipulador de mensagens dado.'
xpcall['>5.2']      =
'Faz chamada a função `f` com os argumentos dados e em modo protegido, usando um manipulador de mensagens dado.'

unpack              =
[[
Retorna os elementos da lista dada. Esta função é equivalente a
```lua
    return list[i], list[i+1], ···, list[j]
```
]]

bit32               =
''
bit32.arshift       =
[[
Retorna o número `x` deslocado `disp` bits para a direita. Deslocamentos negativos movem os bits para a esquerda.

Esta operação de deslocamento é chamada de deslocamento aritmético. Os bits vagos à esquerda são preenchidos com cópias do bit mais significativo de `x`; os bits vagos à direita são preenchidos com zeros.
]]
bit32.band          =
'Retorna a operação bitwise *and* de seus operandos.'
bit32.bnot          =
[[
Retorna a negação da operação bitwise de `x`.

```lua
assert(bit32.bnot(x) ==
(-1 - x) % 2^32)
```
]]
bit32.bor           =
'Retorna a operação bitwise *or* de seus operandos.'
bit32.btest         =
'Retorna um valor booleano verdadeiro se a operação bitwise *and* de seus operandos for diferente de zero. Falso, caso contrário.'
bit32.bxor          =
'Retorna a operação bitwise *exclusive or* de seus operandos.'
bit32.extract       =
'Retorna o número formado pelos bits de `field` a `field + width - 1` de `n`, sem sinal.'
bit32.replace       =
'Retorna uma cópia de `n` com os bits de `field` a `field + width - 1` substituídos pelo valor `v` .'
bit32.lrotate       =
'Retorna o número `x` rotacionado `disp` bits para a esquerda. Rotações negativos movem os bits para a direita. '
bit32.lshift        =
[[
Retorna o número `x` deslocado `disp` bits para a esquerda. Deslocamentos negativos movem os bits para a direita. Em ambas as direções, os bits vazios/vagos são preenchidos com zeros.

```lua
assert(bit32.lshift(b, disp) ==
(b * 2^disp) % 2^32)
```
]]
bit32.rrotate       =
'Retorna o número `x` rotacionado `disp` bits para a direita. Deslocamentos negativos movem os bits para a esquerda.'
bit32.rshift        =
[[
Retorna o número `x` deslocado `disp` bits para a direita. Deslocamentos negativos movem os bits para a esquerda. Em ambas as direções, os bits vazios são preenchidos com zeros.

```lua
assert(bit32.rshift(b, disp) ==
math.floor(b % 2^32 / 2^disp))
```
]]

coroutine                   =
''
coroutine.create            =
'Cria uma nova `coroutine`, a partir de uma função `f` e retorna esta coroutine como objeto do tipo `"thread"`.'
coroutine.isyieldable       =
'Retorna verdadeiro quando a `coroutine` em execução for finalizada.'
coroutine.isyieldable['>5.4']=
'Retorna verdadeiro quando a `coroutine` `co` for finalizada. Por padrão `co` é uma coroutine em execução.'
coroutine.close             =
'Finaliza a coroutine `co` , encerrando todas as variáveis pendentes e colocando a coroutine em um estado morto.'
coroutine.resume            =
'Inicia ou continua a execução da coroutine `co`.'
coroutine.running           =
'Retorna a `coroutine` corrente e um booleana verdadeiro quando a coroutine corrente é a principal.'
coroutine.status            =
'Retorna o status da `coroutine `co`.'
coroutine.wrap              =
'Cria uma nova `coroutine`, a partir de uma função `f` e retorna uma função que retorna a coroutine cada vez que ele é chamado.'
coroutine.yield             =
'Suspende a execução da coroutine chamada.'

costatus.running            =
'Está em execução.'
costatus.suspended          =
'Está suspenso ou não foi iniciado.'
costatus.normal             =
'Está ativo, mas não está em execução.'
costatus.dead               =
'Terminou ou parou devido a erro'

debug                       =
''
debug.debug                 =
'Entra em modo interativo com o usuário, executando os comandos de entrada.'
debug.getfenv               =
'Retorna o ambiente do objeto `o` .'
debug.gethook               =
'Retorna as configurações do `hook` atual da `thread`.'
debug.getinfo               =
'Retorna uma tabela com informações sobre uma função.'
debug.getlocal['<5.1']      =
'Retorna o nome e o valor da variável local com índice `local` da função de nível `level` da pilha.'
debug.getlocal['>5.2']      =
'Retorna o nome e o valor da variável local com índice `local` da função de nível `f` da pilha.'
debug.getmetatable          =
'Retorna a `metatable` do valor dado.'
debug.getregistry           =
'Retorna a tabela de registro.'
debug.getupvalue            =
'Retorna o nome e o valor da variável antecedente com índice `up` da função.'
debug.getuservalue['<5.3']  =
'Retorna o valor de Lua associado a `u` (i.e., user).'
debug.getuservalue['>5.4']  =
[[
Retorna o `n`-ésimo valor de usuário associado
aos dados do usuário `u` e um booleano,
`false`, se nos dados do usuário não existir esse valor.
]]
debug.setcstacklimit        =
[[
### **Deprecated in `Lua 5.4.2`**

Estabelece um novo limite para a pilha C. Este limite controla quão profundamente as chamadas aninhadas podem ir em Lua, com a intenção de evitar um transbordamento da pilha.

Em caso de sucesso, esta função retorna o antigo limite. Em caso de erro, ela retorna `false`.
]]
debug.setfenv               =
'Define o ambiente do `object` dado para a `table` dada .'
debug.sethook               =
'Define a função dada como um `hook`.'
debug.setlocal              =
'Atribui o valor `value` à variável local com índice `local` da função de nível `level` da pilha.'
debug.setmetatable          =
'Define a `metatable` com o valor dado para tabela dada (que pode ser `nil`).'
debug.setupvalue            =
'Atribui `value` a variável antecedente com índice `up` da função.'
debug.setuservalue['<5.3']  =
'Define o valor dado como o valor Lua associado ao `udata` (i.e., user data).'
debug.setuservalue['>5.4']  =
[[
Define o valor dado como
o `n`-ésimo valor de usuário associado ao `udata` (i.e., user data).
O `udata` deve ser um dado de usuário completo.
]]
debug.traceback             =
'Retorna uma string com um `traceback` de chamadas. A string de mensagen (opcional) é anexada no início do traceback.'
debug.upvalueid             =
'Retorna um identificador único (como um dado de usuário leve) para o valor antecedente de numero `n` da função dada.'
debug.upvaluejoin           =
'Faz o `n1`-ésimo valor da função `f1` (i.e., closure Lua) referir-se ao `n2`-ésimo valor da função `f2`.'

infowhat.n                  =
'`name` e `namewhat`'
infowhat.S                  =
'`source`, `short_src`, `linedefined`, `lastlinedefined` e `what`'
infowhat.l                  =
'`currentline`'
infowhat.t                  =
'`istailcall`'
infowhat.u['<5.1']          =
'`nups`'
infowhat.u['>5.2']          =
'`nups`, `nparams` e `isvararg`'
infowhat.f                  =
'`func`'
infowhat.r                  =
'`ftransfer` e `ntransfer`'
infowhat.L                  =
'`activelines`'

hookmask.c                  =
'Faz chamada a um `hook` quando o Lua chama uma função.'
hookmask.r                  =
'Faz chamada a um `hook` quando o retorno de uma função é executado.'
hookmask.l                  =
'Faz chamada a um `hook` quando encontra nova linha de código.'

file                        =
''
file[':close']              =
'Fecha o arquivo `file`.'
file[':flush']              =
'Salva qualquer dado de entrada no arquivo `file`.'
file[':lines']              =
[[
------
```lua
for c in file:lines(...) do
    body
end
```
]]
file[':read']               =
'Lê o arquivo de acordo com o formato fornecido e que especifica o que deve ser lido.'
file[':seek']               =
'Define e obtém a posição do arquivo, medida a partir do início do arquivo.'
file[':setvbuf']            =
'Define o modo de `buffer` para um arquivo de saída.'
file[':write']              =
'Escreve o valor de cada um de seus argumentos no arquivo.'

readmode.n                  =
'Lê um numeral e o devolve como número.'
readmode.a                  =
'Lê o arquivo completo.'
readmode.l                  =
'Lê a próxima linha pulando o final da linha.'
readmode.L                  =
'Lê a próxima linha mantendo o final da linha.'

seekwhence.set              =
'O cursor base é o início do arquivo.'
seekwhence.cur              =
'O cursor base é a posição atual.'
seekwhence['.end']          =
'O cursor base é o final do arquivo.'

vbuf.no                     =
'A saída da operação aparece imediatamente.'
vbuf.full                   =
'Realizado apenas quando o `buffer` está cheio.'
vbuf.line                   =
'`Buffered` até que uma nova linha seja encontrada.'

io                          =
''
io.stdin                    =
'Entrada padrão.'
io.stdout                   =
'Saída padrão.'
io.stderr                   =
'Erro padrão.'
io.close                    =
'Fecha o arquivo dado ou o arquivo de saída padrão.'
io.flush                    =
'Salva todos os dados gravados no arquivo de saída padrão.'
io.input                    =
'Define o arquivo de entrada padrão.'
io.lines                    =
[[
------
```lua
for c in io.lines(filename, ...) do
    body
end
```
]]
io.open                     =
'Abre um arquivo no modo especificado pela *string* `mode`.'
io.output                   =
'Define o arquivo de saída padrão.'
io.popen                    =
'Inicia o programa dado em um processo separado.'
io.read                     =
'Lê o arquivo de acordo com o formato fornecido e que especifica o que deve ser lido.'
io.tmpfile                  =
'Em caso de sucesso, retorna um `handler` para um arquivo temporário.'
io.type                     =
'Verifica se `obj` é um identificador de arquivo válido.'
io.write                    =
'Escreve o valor de cada um dos seus argumentos para o arquivo de saída padrão.'

openmode.r                  =
'Modo de leitura.'
openmode.w                  =
'Modo de escrita.'
openmode.a                  =
'Modo de anexação.'
openmode['.r+']             =
'Modo de atualização, todos os dados anteriores são preservados.'
openmode['.w+']             =
'Modo de atualização, todos os dados anteriores são apagados.'
openmode['.a+']             =
'Modo de anexação e atualização, os dados anteriores são preservados, a escrita só é permitida no final do arquivo.'
openmode.rb                 =
'Modo de leitura. (em modo binário)'
openmode.wb                 =
'Modo de escrita. (em modo binário)'
openmode.ab                 =
'Modo de anexação. (em modo binário)'
openmode['.r+b']            =
'Modo de atualização, todos os dados anteriores são preservados. (em modo binário)'
openmode['.w+b']            =
'Modo de atualização, todos os dados anteriores são apagados. (em modo binário)'
openmode['.a+b']            =
'Modo de anexação e atualização, todos os dados anteriores são preservados, a escrita só é permitida no final do arquivo. (em modo binário)'

popenmode.r                 =
'Leia dados deste programa pelo arquivo.'
popenmode.w                 =
'Escreva dados neste programa pelo arquivo.'

filetype.file               =
'`handler` para arquivo aberto.'
filetype['.closed file']    =
'`handler` para arquivo fechado.'
filetype['.nil']            =
'Não é um `handler` de arquivo'

math                        =
''
math.abs                    =
'Retorna o valor absoluto de `x`.'
math.acos                   =
'Retorna o arco cosseno de `x` (em radianos).'
math.asin                   =
'Retorna o arco seno de `x` (em radianos).'
math.atan['<5.2']           =
'Retorna o arco tangente de `x` (em radianos).'
math.atan['>5.3']           =
'Retorna o arco tangente de `y/x` (em radianos).'
math.atan2                  =
'Retorna o arco tangente de `y/x` (em radianos).'
math.ceil                   =
'Retorna o menor valor inteiro maior ou igual a `x`.'
math.cos                    =
'Retorna o cosseno de `x` (requer valor em radianos).'
math.cosh                   =
'Retorna o cosseno hiperbólico de `x` (requer valor em radianos).'
math.deg                    =
'Converte o ângulo `x` de radianos para graus.'
math.exp                    =
'Retorna o valor `e^x` (onde `e` é a base do logaritmo natural).'
math.floor                  =
'Retorna o maior valor inteiro menor ou igual a `x`.'
math.fmod                   =
'Retorna o resto da divisão de `x` por `y` que arredonda o quociente para zero.'
math.frexp                  =
'Decompõe `x` em fatores e expoentes. Retorna `m` e `e` tal que `x = m * (2 ^ e)` é um inteiro e o valor absoluto de `m` está no intervalo [0,5, 1) (ou zero quando `x` é zero).'
math.huge                   =
'Um valor maior que qualquer outro valor numérico.'
math.ldexp                  =
'Retorna `m * (2 ^ e)`.'
math.log['<5.1']            =
'Retorna o logaritmo natural de `x`.'
math.log['>5.2']            =
'Retorna o logaritmo de `x` na base dada.'
math.log10                  =
'Retorna o logaritmo `x` na base 10.'
math.max                    =
'Retorna o argumento com o valor máximo de acordo com o operador `<`.'
math.maxinteger['>5.3']     =
'Retorna o valor máximo para um inteiro.'
math.min                    =
'Retorna o argumento com o valor mínimo de acordo com o operador `<`.'
math.mininteger['>5.3']     =
'Retorna o valor mínimo para um inteiro.'
math.modf                   =
'Retorna a parte inteira e a parte fracionária de `x`.'
math.pi                     =
'O valor de *π*.'
math.pow                    =
'Retorna `x ^ y`.'
math.rad                    =
'Converte o ângulo `x` de graus para radianos.'
math.random                 =
[[
* `math.random()`: Retorna um valor real (i.e., ponto flutuante) no intervalo [0,1).
* `math.random(n)`: Retorna um inteiro no intervalo [1, n].
* `math.random(m, n)`: Retorna um inteiro no intervalo [m, n].
]]
math.randomseed['<5.3']     =
'Define `x` como valor semente (i.e., `seed`) para a função geradora de números pseudo-aleatória.'
math.randomseed['>5.4']     =
[[
* `math.randomseed(x, y)`: Concatena `x` e `y` em um espaço de 128-bits que é usado como valor semente (`seed`) para reinicializar o gerador de números pseudo-aleatório.
* `math.randomseed(x)`: Equivale a `math.randomseed(x, 0)` .
* `math.randomseed()`: Gera um valor semente (i.e., `seed`) com fraca probabilidade de aleatoriedade.
]]
math.sin                    =
'Retorna o seno de `x` (requer valor em radianos).'
math.sinh                   =
'Retorna o seno hiperbólico de `x` (requer valor em radianos).'
math.sqrt                   =
'Retorna a raiz quadrada de `x`.'
math.tan                    =
'Retorna a tangente de `x` (requer valor em radianos).'
math.tanh                   =
'Retorna a tangente hiperbólica de `x` (requer valor em radianos).'
math.tointeger['>5.3']      =
'Se o valor `x` pode ser convertido para um inteiro, retorna esse inteiro.'
math.type['>5.3']           =
'Retorna `"integer"` se `x` é um inteiro, `"float"` se for um valor real (i.e., ponto flutuante), ou `nil` se `x` não é um número.'
math.ult['>5.3']            =
'Retorna `true` se e somente se `m` é menor `n` quando eles são comparados como inteiros sem sinal.'

os                          =
''
os.clock                    =
'Retorna uma aproximação do valor, em segundos, do tempo de CPU usado pelo programa.'
os.date                     =
'Retorna uma string ou uma tabela contendo data e hora, formatada de acordo com a string `format` fornecida.'
os.difftime                 =
'Retorna a diferença, em segundos, do tempo `t1` para o tempo` t2`.'
os.execute                  =
'Passa `command` para ser executado por um `shell` do sistema operacional.'
os.exit['<5.1']             =
'Chama a função `exit` do C para encerrar o programa.'
os.exit['>5.2']             =
'Chama a função `exit` do ISO C para encerrar o programa.'
os.getenv                   =
'Retorna o valor da variável de ambiente de processo `varname`.'
os.remove                   =
'Remove o arquivo com o nome dado.'
os.rename                   =
'Renomeia o arquivo ou diretório chamado `oldname` para `newname`.'
os.setlocale                =
'Define a localidade atual do programa.'
os.time                     =
'Retorna a hora atual quando chamada sem argumentos, ou um valor representando a data e a hora local especificados pela tabela fornecida.'
os.tmpname                  =
'Retorna uma string com um nome de arquivo que pode ser usado como arquivo temporário.'

osdate.year                 =
'Quatro dígitos.'
osdate.month                =
'1-12'
osdate.day                  =
'1-31'
osdate.hour                 =
'0-23'
osdate.min                  =
'0-59'
osdate.sec                  =
'0-61'
osdate.wday                 =
'Dia da semana, 1–7, Domingo é 1'
osdate.yday                 =
'Dia do ano, 1–366'
osdate.isdst                =
'Bandeira para indicar horário de verão (i.e., `Daylight Saving Time`), um valor booleano.'

package                     =
''

require['<5.3']             =
'Carrega o módulo fornecido e retorna qualquer valor retornado pelo módulo (`true` quando `nil`).'
require['>5.4']             =
'Carrega o módulo fornecido e retorna qualquer valor retornado pelo pesquisador (`true` quando `nil`). Além desse valor, também retorna como segundo resultado um carregador de dados retornados pelo pesquisador, o que indica como `require` encontrou o módulo. (Por exemplo, se o módulo vier de um arquivo, este carregador de dados é o caminho do arquivo.)'

package.config              =
'string descrevendo configurações a serem utilizadas durante a compilação de pacotes.'
package.cpath               =
'O caminho usado pelo `require` para procurar pelo carregador C.'
package.loaded              =
'Uma tabela usada pelo `require` para controlar quais módulos já estão carregados.'
package.loaders             =
'Uma tabela usada pelo `require` para controlar como carregar módulos.'
package.loadlib             =
'Dinamicamente vincula o programa no `host` com a biblioteca C `libname`.'
package.path                =
'O caminho usado pelo `require` para procurar por um carregador Lua.'
package.preload             =
'Uma tabela para armazenar carregadores de módulos específicos.'
package.searchers           =
'Uma tabela usada pelo `require` para controlar como buscar módulos.'
package.searchpath          =
'Procura por `name` em `path`.'
package.seeall              =
'Define uma `metatable` `module` com o campo `__index` referenciando o ambiente global, para que este módulo herde valores do ambiente global. Para ser usado como uma opção a função `module`.'

string                      =
''
string.byte                 =
'Retorna os códigos numéricos internos dos caracteres `s[i], s[i+1], ..., s[j]`.'
string.char                 =
'Retorna uma string com comprimento igual ao número de argumentos, no qual cada caractere possui o código numérico interno igual ao seu argumento correspondente.'
string.dump                 =
'Retorna uma string contendo uma representação binária (i.e., *binary chunk*) da função dada.'
string.find                 =
'Procura a primeira correspondencia de `pattern` (veja §6.4.1) na string.'
string.format               =
'Retorna uma versão formatada de seu número variável de argumentos após a descrição dada em seu primeiro argumento.'
string.gmatch               =
[[
Retorna um iterator que, a cada vez que é chamado, retorna as próximas capturas de `pattern` (veja §6.4.1) sobre a string *s*.

Por exemplo, o loop a seguir irá iterar em todas as palavras da string *s*, imprimindo cada palavra por linha:
```lua
    s =
"hello world from Lua"
    for w in string.gmatch(s, "%a+") do
        print(w)
    end
```
]]
string.gsub                 =
'Retorna uma cópia da *s* em que todas ou, caso fornecido, as primeiras `n` ocorrências de `pattern` (veja §6.4.1) que tiverem sido substituídas por uma string de substituição especificada por `repl`.'
string.len                  =
'Retorna o comprimento da string.'
string.lower                =
'Retorna uma cópia desta string com todas as letras maiúsculas alteradas para minúsculas.'
string.match                =
'Procura a primeira ocorrência do `pattern` (veja §6.4.1) na string.'
string.pack                 =
'Retorna uma string binária contendo os valores `V1`, `v2`, etc. empacotados (isto é, serializado de forma binário) de acordo com o formato da string `fmt` fornecida (veja §6.4.2).'
string.packsize             =
'Retorna o tamanho de uma string resultante de `string.pack` com o formato da string `fmt` fornecida (veja §6.4.2).'
string.rep['>5.2']          =
'Retorna uma string que é a concatenação de `n` cópias da string `s` separadas pela string `sep`.'
string.rep['<5.1']          =
'Retorna uma string que é a concatenação de `n` cópias da string `s`.'
string.reverse              =
'Retorna uma string que representa a string `s` invertida.'
string.sub                  =
'Retorna a substring da string `s` que começa no índice `i` e continua até o índice `j`.'
string.unpack               =
'Retorna os valores empacotados na string de acordo com o formato da string `fmt` fornecida (veja §6.4.2).'
string.upper                =
'Retorna uma cópia desta string com todas as letras minúsculas alteradas para maiúsculas.'

table                       =
''
table.concat                =
'Dada uma lista onde todos os elementos são strings ou números, retorna a string `list[i]..sep..list[i+1] ··· sep..list[j]`.'
table.insert                =
'Insere o elemento `value` na posição `pos` de `list`.'
table.maxn                  =
'Retorna o maior índice numérico positivo da tabela fornecida ou zero se a tabela não tiver índices numéricos positivos.'
table.move                  =
[[
Move os elementos da tabela `a1` para tabela `a2`.
```lua
a2[t],··· =
a1[f],···,a1[e]
return a2
```
]]
table.pack                  =
'Retorna uma nova tabela com todos os argumentos armazenados em chaves `1`, `2`, etc. e com um campo `"n"` com o número total de argumentos.'
table.remove                =
'Remove de `list` o elemento na posição `pos`, retornando o valor do elemento removido.'
table.sort                  =
'Ordena os elementos de `list` em uma determinada ordem, *in-place*, de `list[1]` para `list[#list]`.'
table.unpack                =
[[
Retorna os elementos da lista fornecida. Esta função é equivalente a
```lua
    return list[i], list[i+1], ···, list[j]
```
Por padrão, `i` é `1` e `j` é `#list`.
]]
table.foreach               = -- TODO: need translate!
'Executes the given f over all elements of table. For each element, f is called with the index and respective value as arguments. If f returns a non-nil value, then the loop is broken, and this value is returned as the final value of foreach.'
table.foreachi              = -- TODO: need translate!
'Executes the given f over the numerical indices of table. For each index, f is called with the index and respective value as arguments. Indices are visited in sequential order, from 1 to n, where n is the size of the table. If f returns a non-nil value, then the loop is broken and this value is returned as the result of foreachi.'
table.getn                  = -- TODO: need translate!
'Returns the number of elements in the table. This function is equivalent to `#list`.'
table.new                   = -- TODO: need translate!
[[This creates a pre-sized table, just like the C API equivalent `lua_createtable()`. This is useful for big tables if the final table size is known and automatic table resizing is too expensive. `narray` parameter specifies the number of array-like items, and `nhash` parameter specifies the number of hash-like items. The function needs to be required before use.
```lua
	require("table.new")
```
]]
table.clear                 = -- TODO: need translate!
[[This clears all keys and values from a table, but preserves the allocated array/hash sizes. This is useful when a table, which is linked from multiple places, needs to be cleared and/or when recycling a table for use by the same context. This avoids managing backlinks, saves an allocation and the overhead of incremental array/hash part growth. The function needs to be required before use.
```lua
	require("table.clear").
```
Please note this function is meant for very specific situations. In most cases it's better to replace the (usually single) link with a new table and let the GC do its work.
]]

utf8                        =
''
utf8.char                   =
'Recebe zero ou mais inteiros, converte cada um à sua sequência de byte UTF-8 correspondente e retorna uma string com a concatenação de todas essas sequências.'
utf8.charpattern            =
'O padrão que corresponde exatamente uma sequência de byte UTF-8, supondo que seja uma sequência válida UTF-8.'
utf8.codes                  =
[[
Retorna valores tal que a seguinte construção
```lua
for p, c in utf8.codes(s) do
    body
end
```
itere em todos os caracteres UTF-8 na string s, com p sendo a posição (em bytes) e c o *codepoint* de cada caractere. Ele gera um erro se encontrado qualquer sequência de byte inválida.
]]
utf8.codepoint              =
'Retorna os *codepoints* (em inteiros) de todos os caracteres em `s` que iniciam entre as posições do byte `i` e `j` (ambos inclusos).'
utf8.len                    =
'Retorna o número de caracteres UTF-8 na string `s` que começa entre as posições `i` e `j` (ambos inclusos).'
utf8.offset                 =
'Retorna a posição (em bytes) onde a codificação do `n`-ésimo caractere de `s` inícia (contando a partir da posição `i`).'
