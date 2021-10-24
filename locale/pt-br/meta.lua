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
debug.debug                 = 'Enters an interactive mode with the user, running each string that the user enters.'
debug.getfenv               = 'Returns the environment of object `o` .'
debug.gethook               = 'Returns the current hook settings of the thread.'
debug.getinfo               = 'Returns a table with information about a function.'
debug.getlocal['<5.1']      = 'Returns the name and the value of the local variable with index `local` of the function at level `level` of the stack.'
debug.getlocal['>5.2']      = 'Returns the name and the value of the local variable with index `local` of the function at level `f` of the stack.'
debug.getmetatable          = 'Returns the metatable of the given value.'
debug.getregistry           = 'Returns the registry table.'
debug.getupvalue            = 'Returns the name and the value of the upvalue with index `up` of the function.'
debug.getuservalue['<5.3']  = 'Returns the Lua value associated to u.'
debug.getuservalue['>5.4']  = [[
Returns the `n`-th user value associated
to the userdata `u` plus a boolean,
`false` if the userdata does not have that value.
]]
debug.setcstacklimit        = [[
### **Deprecated in `Lua 5.4.2`**

Sets a new limit for the C stack. This limit controls how deeply nested calls can go in Lua, with the intent of avoiding a stack overflow.

In case of success, this function returns the old limit. In case of error, it returns `false`.
]]
debug.setfenv               = 'Sets the environment of the given `object` to the given `table` .'
debug.sethook               = 'Sets the given function as a hook.'
debug.setlocal              = 'Assigns the `value` to the local variable with index `local` of the function at `level` of the stack.'
debug.setmetatable          = 'Sets the metatable for the given value to the given table (which can be `nil`).'
debug.setupvalue            = 'Assigns the `value` to the upvalue with index `up` of the function.'
debug.setuservalue['<5.3']  = 'Sets the given value as the Lua value associated to the given udata.'
debug.setuservalue['>5.4']  = [[
Sets the given `value` as
the `n`-th user value associated to the given `udata`.
`udata` must be a full userdata.
]]
debug.traceback             = 'Returns a string with a traceback of the call stack. The optional message string is appended at the beginning of the traceback.'
debug.upvalueid             = 'Returns a unique identifier (as a light userdata) for the upvalue numbered `n` from the given function.'
debug.upvaluejoin           = 'Make the `n1`-th upvalue of the Lua closure `f1` refer to the `n2`-th upvalue of the Lua closure `f2`.'
infowhat.n                  = '`name` and `namewhat`'
infowhat.S                  = '`source`, `short_src`, `linedefined`, `lastlinedefined`, and `what`'
infowhat.l                  = '`currentline`'
infowhat.t                  = '`istailcall`'
infowhat.u['<5.1']          = '`nups`'
infowhat.u['>5.2']          = '`nups`, `nparams`, and `isvararg`'
infowhat.f                  = '`func`'
infowhat.r                  = '`ftransfer` and `ntransfer`'
infowhat.L                  = '`activelines`'
hookmask.c                  = 'Calls hook when Lua calls a function.'
hookmask.r                  = 'Calls hook when Lua returns from a function.'
hookmask.l                  = 'Calls hook when Lua enters a new line of code.'

file                        = ''
file[':close']              = 'Close `file`.'
file[':flush']              = 'Saves any written data to `file`.'
file[':lines']              = [[
------
```lua
for c in file:lines(...) do
    body
end
```
]]
file[':read']               = 'Reads the `file`, according to the given formats, which specify what to read.'
file[':seek']               = 'Sets and gets the file position, measured from the beginning of the file.'
file[':setvbuf']            = 'Sets the buffering mode for an output file.'
file[':write']              = 'Writes the value of each of its arguments to `file`.'
readmode.n                  = 'Reads a numeral and returns it as number.'
readmode.a                  = 'Reads the whole file.'
readmode.l                  = 'Reads the next line skipping the end of line.'
readmode.L                  = 'Reads the next line keeping the end of line.'
seekwhence.set              = 'Base is beginning of the file.'
seekwhence.cur              = 'Base is current position.'
seekwhence['.end']          = 'Base is end of file.'
vbuf.no                     = 'Output operation appears immediately.'
vbuf.full                   = 'Performed only when the buffer is full.'
vbuf.line                   = 'Buffered until a newline is output.'

io                          = ''
io.stdin                    = 'standard input.'
io.stdout                   = 'standard output.'
io.stderr                   = 'standard error.'
io.close                    = 'Close `file` or default output file.'
io.flush                    = 'Saves any written data to default output file.'
io.input                    = 'Sets `file` as the default input file.'
io.lines                    = [[
------
```lua
for c in io.lines(filename, ...) do
    body
end
```
]]
io.open                     = 'Opens a file, in the mode specified in the string `mode`.'
io.output                   = 'Sets `file` as the default output file.'
io.popen                    = 'Starts program prog in a separated process.'
io.read                     = 'Reads the `file`, according to the given formats, which specify what to read.'
io.tmpfile                  = 'In case of success, returns a handle for a temporary file.'
io.type                     = 'Checks whether `obj` is a valid file handle.'
io.write                    = 'Writes the value of each of its arguments to default output file.'
openmode.r                  = 'Read mode.'
openmode.w                  = 'Write mode.'
openmode.a                  = 'Append mode.'
openmode['.r+']             = 'Update mode, all previous data is preserved.'
openmode['.w+']             = 'Update mode, all previous data is erased.'
openmode['.a+']             = 'Append update mode, previous data is preserved, writing is only allowed at the end of file.'
openmode.rb                 = 'Read mode. (in binary mode.)'
openmode.wb                 = 'Write mode. (in binary mode.)'
openmode.ab                 = 'Append mode. (in binary mode.)'
openmode['.r+b']            = 'Update mode, all previous data is preserved. (in binary mode.)'
openmode['.w+b']            = 'Update mode, all previous data is erased. (in binary mode.)'
openmode['.a+b']            = 'Append update mode, previous data is preserved, writing is only allowed at the end of file. (in binary mode.)'
popenmode.r                 = 'Read data from this program by `file`.'
popenmode.w                 = 'Write data to this program by `file`.'
filetype.file               = 'Is an open file handle.'
filetype['.closed file']    = 'Is a closed file handle.'
filetype['.nil']            = 'Is not a file handle.'

math                        = ''
math.abs                    = 'Returns the absolute value of `x`.'
math.acos                   = 'Returns the arc cosine of `x` (in radians).'
math.asin                   = 'Returns the arc sine of `x` (in radians).'
math.atan['<5.2']           = 'Returns the arc tangent of `x` (in radians).'
math.atan['>5.3']           = 'Returns the arc tangent of `y/x` (in radians).'
math.atan2                  = 'Returns the arc tangent of `y/x` (in radians).'
math.ceil                   = 'Returns the smallest integral value larger than or equal to `x`.'
math.cos                    = 'Returns the cosine of `x` (assumed to be in radians).'
math.cosh                   = 'Returns the hyperbolic cosine of `x` (assumed to be in radians).'
math.deg                    = 'Converts the angle `x` from radians to degrees.'
math.exp                    = 'Returns the value `e^x` (where `e` is the base of natural logarithms).'
math.floor                  = 'Returns the largest integral value smaller than or equal to `x`.'
math.fmod                   = 'Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.'
math.frexp                  = 'Decompose `x` into tails and exponents. Returns `m` and `e` such that `x = m * (2 ^ e)`, `e` is an integer and the absolute value of `m` is in the range [0.5, 1) (or zero when `x` is zero).'
math.huge                   = 'A value larger than any other numeric value.'
math.ldexp                  = 'Returns `m * (2 ^ e)` .'
math.log['<5.1']            = 'Returns the natural logarithm of `x` .'
math.log['>5.2']            = 'Returns the logarithm of `x` in the given base.'
math.log10                  = 'Returns the base-10 logarithm of x.'
math.max                    = 'Returns the argument with the maximum value, according to the Lua operator `<`.'
math.maxinteger             = 'An integer with the maximum value for an integer.'
math.min                    = 'Returns the argument with the minimum value, according to the Lua operator `<`.'
math.mininteger             = 'An integer with the minimum value for an integer.'
math.modf                   = 'Returns the integral part of `x` and the fractional part of `x`.'
math.pi                     = 'The value of *π*.'
math.pow                    = 'Returns `x ^ y` .'
math.rad                    = 'Converts the angle `x` from degrees to radians.'
math.random                 = [[
* `math.random()`: Returns a float in the range [0,1).
* `math.random(n)`: Returns a integer in the range [1, n].
* `math.random(m, n)`: Returns a integer in the range [m, n].
]]
math.randomseed['<5.3']     = 'Sets `x` as the "seed" for the pseudo-random generator.'
math.randomseed['>5.4']     = [[
* `math.randomseed(x, y)`: Concatenate `x` and `y` into a 128-bit `seed` to reinitialize the pseudo-random generator.
* `math.randomseed(x)`: Equate to `math.randomseed(x, 0)` .
* `math.randomseed()`: Generates a seed with a weak attempt for randomness.
]]
math.sin                    = 'Returns the sine of `x` (assumed to be in radians).'
math.sinh                   = 'Returns the hyperbolic sine of `x` (assumed to be in radians).'
math.sqrt                   = 'Returns the square root of `x`.'
math.tan                    = 'Returns the tangent of `x` (assumed to be in radians).'
math.tanh                   = 'Returns the hyperbolic tangent of `x` (assumed to be in radians).'
math.tointeger              = 'If the value `x` is convertible to an integer, returns that integer.'
math.type                   = 'Returns `"integer"` if `x` is an integer, `"float"` if it is a float, or `nil` if `x` is not a number.'
math.ult                    = 'Returns `true` if and only if `m` is below `n` when they are compared as unsigned integers.'

os                          = ''
os.clock                    = 'Returns an approximation of the amount in seconds of CPU time used by the program.'
os.date                     = 'Returns a string or a table containing date and time, formatted according to the given string `format`.'
os.difftime                 = 'Returns the difference, in seconds, from time `t1` to time `t2`.'
os.execute                  = 'Passes `command` to be executed by an operating system shell.'
os.exit['<5.1']             = 'Calls the C function `exit` to terminate the host program.'
os.exit['>5.2']             = 'Calls the ISO C function `exit` to terminate the host program.'
os.getenv                   = 'Returns the value of the process environment variable `varname`.'
os.remove                   = 'Deletes the file with the given name.'
os.rename                   = 'Renames the file or directory named `oldname` to `newname`.'
os.setlocale                = 'Sets the current locale of the program.'
os.time                     = 'Returns the current time when called without arguments, or a time representing the local date and time specified by the given table.'
os.tmpname                  = 'Returns a string with a file name that can be used for a temporary file.'
osdate.year                 = 'four digits'
osdate.month                = '1-12'
osdate.day                  = '1-31'
osdate.hour                 = '0-23'
osdate.min                  = '0-59'
osdate.sec                  = '0-61'
osdate.wday                 = 'weekday, 1–7, Sunday is 1'
osdate.yday                 = 'day of the year, 1–366'
osdate.isdst                = 'daylight saving flag, a boolean'

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
