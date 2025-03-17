---@diagnostic disable: undefined-global, lowercase-global

arg                 =
'Argumentos de línea de comandos para Lua Standalone.'

assert              =
'Alsa un error si el valor de sus argumentos es falso. (ej: `nil` ó `falso`); de lo contrario, retorna todos sus argumentos. En caso de error, `message` es el mensaje de error; cuando se omite, el valor predeterminado es `"assertion failed!"`'

cgopt.collect       =
'Realiza un ciclo completo de recolección de basura.'
cgopt.stop          =
'Detiene la ejecución automática.'
cgopt.restart       =
'Reinicia la ejecución automática.'
cgopt.count         =
'Retorna el total de memoria en Kbytes.'
cgopt.step          =
'Realiza un paso de recolección de basura.'
cgopt.setpause      =
'Establece la pausa.'
cgopt.setstepmul    =
'Establece el multiplicador para el paso de recolección de basura.'
cgopt.incremental   =
'Cambia el modo de recolección a incremental.'
cgopt.generational  =
'Cambia el modo de recolección a generacional.'
cgopt.isrunning     =
'Retorna si el recolector está corriendo.'

collectgarbage      =
'Esta función es una interfaz genérica al recolector de basura. Realiza diferentes funcionalidades según su primer argumento `opt`'

dofile              =
'Abre el archivo mencionado y ejecuta su contenido como un bloque Lua. Cuando es llamada sin argumentos, `dofile` ejecuta el contenido de la entrada estándar (`stdin`). Retorna todos los valores retornado por el bloque. En caso de error `dofile` propaga el error a la función que la llama. (Eso sí, `dofile` no corre en modo protegido.)'

error               =
[[
Termina la última función llamada y retorna el mensaje como el objecto de error.
Normalmente `error` tiene información extra acerca la posición del error al inicio del mensaje, si es que éste es un string.
]]

_G                  =
'Una variable global (no una función) que tiene el ambiente global (vea §2.2). Esta variable no se ocupa en Lua mismo; el cambiar su valor no afecta a ningún ambiente y vice-versa.'

getfenv             =
'Retorna el ambiente que usa la función actualmente. `f` puede ser una función de Lua o un número que especifica la función en ese nivel de la pila de llamadas.'

getmetatable        =
'Si el objecto no tiene una metatabla, returna nil. Si no, si la metatabla del objeto tiene un campo __metatable, retorna el valor asociado. Si tampoco es así, retorna la metatabla del objeto dado.'

ipairs              =
[[
Retorna tres valores (una función de iterador, la tabla `t` y `0`) cosa que la estructura
```lua
    for i,v in ipairs(t) do body end
```
itera sobre los pares clave-valor `(1,t[1]), (2,t[2]), ...`, hasta el primer índice ausente.
]]

loadmode.b          =
'Solo bloques binarios.'
loadmode.t          =
'Solo bloques de texto.'
loadmode.bt         =
'Bloques binarios y de texto.'

load['<5.1']        =
'Carga un bloque usando la función `func` para obtener sus partes. Cada llamada a `func` debe retornar un string que se concatena con los resultados anteriores.'
load['>5.2']        =
[[
Carga un bloque.

Si `chunk` es un string, el bloque es este string. Si `chunk` es una función, entonces `load` la llama repetidas veces para obtener las partes del bloque. Cada llamada a `chunk` debe retornar un string que se concatena con los resultados anteriores. El retornar un string vacío, `nil` ó ningún valor señala el fin del bloque.
]]

loadfile            =
'Carga un bloque del archivo `filename` o de la entrada estándar, si es que no se provee un nombre de archivo.'

loadstring          =
'Carga un bloque del string dado.'

module              =
'Crea un módulo.'

next                =
[[
Le permite a un programa recorrer todos los campos de una tabla. El primer argumento es una tabla y el segundo es un índice de ésta. Un llamado a `next` retorna el siguiente índice de la tabla y su valor asociado. Cuando se llama con `nil` como segundo argumento, `next` retorna un índicie inicial y su valor asociado. Cuando se llama con el último índice, o con `nil` en una tabla vacía, `next` retorna `nil`. Si se omite el segundo argumento, entonces se le interpreta como `nil`. En particular, se puede llamara a `next(t)` para chequear si la tabla está vacía.

El orden en el cual los índices son enumerados no está especificado, *incluso para índices numéricos*. (Para recorrer una tabla en orden numérico, se debe usar un `for` numérico.)

El comportamiento de `next` no está definido si, durante un recorrido, se le asigna algún valor a un campo no existente de la tabla. Sin embargo, sí se pueden modificar los campos existentes. En particular, se pueden asignar campos existentes a `nil`.
]]

pairs               =
[[
Si `t` tiene un metamétodo `__pairs`, la llama con t como argumento y retorna los primeros tres resultados de la llamada.

Caso contrario, retorna tres valores: la función $next, la tabla `t`, y `nil` para que el bloque
```lua
    for k,v in pairs(t) do body end
```
itere sobre todos los pares clave-valor de la tabla `t`.

Vea la función $next para más detalles acerca de las limitaciones al modificar la tabla mientras se le recorre.
]]

pcall               =
[[
Llama a la función `f` con los argumentos provistos en *modo protegido*. Esto significa que cualquier error que ocurra dentro de `f` no es propagado; en vez de eso, `pcall` atrapa el error y retorna un código de estado. El primer resultado es el código de estado (verdadero/falso), si éste es verdadero, entonces la llamada fue completada sin errores. En tal caso, `pcall` también retorna todos los resultados de la llamada, después de este primer resultado. En caso de error, `pcall` retorna `false` junto al objeto de error.
]]

print               =
[[
Recibe cualquier número de argumentos e imprime sus valores a la salida estándar `stdout`, convirtiendo cada argumento a texto siguiendo las mismas reglas de $tostring.
La función `print` no está hecha para una salida formateada, si no que solo como una manera rápida de mostrar un valor, por ejemplo, para depurar. Para un control completo sobre la salida use $string.format e $io.write.
]]

rawequal            =
'Revisa que v1 sea igual a v2, sin llamar al metamétodo `__eq`.'

rawget              =
'Obtiene el valor real de `table[index]`, sin llamar al metamétodo `__index`.'

rawlen              =
'Retorna el largo del objeto `v`, sin invocar al metamétodo `__len`.'

rawset              =
[[
Asigna el valor real de `table[index]` a `value`, sin usar el metavalor `__newindex`. `table` debe ser una tabla, `index` cualquier valor distinto de `nil` y `NaN`, y `value` cualquier valor de Lua.
Esta función retorna `table`.
]]

select              =
'Si `index` es un número retorna todos los argumentos que siguen al `index`-ésimo argumento; un número negativo indiza desde el final (`-1` es el último argumento). Caso contrario, `index` debe ser el texto `"#"` y `select` retorna el número total de argumentos extra recibidos.'

setfenv             =
'Asigna el ambiente para ser usado para la función provista.'

setmetatable        =
[[
Asigna la metatabla para la tabla provista. Si `metatable` is `nil`, remueve la metatabla de tabla provista. Si la tabla original tiene un campo `__metatable`, alza un error.

Esta función retorna `table`.

Para cambiar la metatabla de otros tipos desde código Lua, se debe usar la biblioteca de depuración (§6.10).
]]

tonumber            =
[[
Cuando se llama sin `base`, `toNumber` intenta convertir el argumento a un número. Si el argumento ya es un número o un texto convertible a un número, entonces `tonumber` retorna este número; si no es el caso, retorna `fail`

La conversión de strings puede resultar en enteros o flotantes, de acuerdo a las convenciones léxicas de Lua (vea §3.1). El string puede tener espacios al principio, al final y tener un signo.
]]

tostring            =
[[
Recibe un valor de cualquier tipo y lo convierte en un string en un formato legible.

Si la metatabla de `v` tiene un campo `__tostring`, entonces `tostring` llama al valor correspondiente con `v` como argumento y usa el resultado de la llamada como su resultado. Si no lo tiene y si la metatabla de `v` tiene un campo `__name` con un valor de tipo string, `tostring` podría ocupar este valor en su resultado final.

Para un control completo de cómo se convierten los números, use $string.format.
]]

type                =
[[
Retorna el tipo de su único argumento, codificado como string. Los resultados posibles de esta función son `"nil"` (un string, no el valor `nil`), `"number"`, `"string"`, `"boolean"`, `"table"`, `"function"`, `"thread"`, y `"userdata"`.
]]

_VERSION            =
'Una variable global (no una función) que contiene un string con la versión de Lua en ejecución.'

warn                =
'Emite una advertencia con un mensaje compuesto por la concatenación de todos sus argumentos (todos estos deben ser strings).'

xpcall['=5.1']      =
'Llama a la función `f` con los argumentos provistos en modo protegido con un nuevo manejador de mensaje.'
xpcall['>5.2']      =
'Llama a la función `f` con los argumentos provistos en modo protegido con un nuevo manejador de mensaje.'

unpack              =
[[
Retorna los elementos de la lista provista. Esta función es equivalente a
```lua
    return list[i], list[i+1], ···, list[j]
```
]]

bit32               =
''
bit32.arshift       =
[[
Retorna el número `x` desplazado `disp` bits a la derecha. Los desplazamientos negativos lo hacen a la izquierda.

Esta operación de desplazamiento es lo que se llama desplazamiento aritmético. Los bits vacíos del lado izquierdo se llenan con copias del bit más alto de `x`; los bits vacíos del lado derecho se llenan con ceros.
]]
bit32.band          =
'Retorna la operación lógica *and* de sus operandos.'
bit32.bnot          =
[[
Retorna la negación lógica de `x` a nivel de bits.

```lua
assert(bit32.bnot(x) ==
(-1 - x) % 2^32)
```
]]
bit32.bor           =
'Retorna la operación lógica *or* de sus operandos.'
bit32.btest         =
'Retorna un booleano señalando si la operación lógica *and* a nivel de bits de sus operandos es diferente de cero.'
bit32.bxor          =
'Retorna la operación lógica *xor* de sus operandos.'
bit32.extract       =
'Retorna el número sin signo formado por los bits `field` hasta `field + width - 1` desde `n`.'
bit32.replace       =
'Retorna una copia de `n` con los bits `field` a `field + width - 1` remplazados por el valor `v` .'
bit32.lrotate       =
'Retorna el número `x` rotado `disp` bits a la izquierda. Las rotaciones negativas lo hacen a la derecha.'
bit32.lshift        =
[[
Retorna el número `x` desplazado `disp` bits a la izquierda. Los desplazamientos negativos lo hacen a la derecha. En cualquier dirección, los bits vacíos se llenan con ceros.

```lua
assert(bit32.lshift(b, disp) ==
(b * 2^disp) % 2^32)
```
]]
bit32.rrotate       =
'Retorna el número `x` rotado `disp` bits a la derecha. Las rotaciones negativas lo hacen a la izquierda.'
bit32.rshift        =
[[
Retorna el número `x` desplazado `disp` bits a la derecha. Los desplazamientos negativos lo hacen a la izquierda. En cualquier dirección, los bits vacíos se llenan con ceros.

```lua
assert(bit32.rshift(b, disp) ==
math.floor(b % 2^32 / 2^disp))
```
]]

coroutine                   =
''
coroutine.create            =
'Crea una co-rutina nueva con cuerpo `f`. `f` debe ser una función. Retorna esta nueva co-rutina, un objeto con tipo `thread`.'
coroutine.isyieldable       =
'Retorna verdadero cuando la co-rutina en ejecución puede suspenderse cediendo el control.'
coroutine.isyieldable['>5.4']=
'Retorna verdadero cuando la co-rutina `co` puede suspenderse cediendo el control. El valor por omisión para `co` es la co-rutina actualmente en ejecución.' 
coroutine.close             =
'Cierra la co-rutina `co`, cerrando todas sus variables prontas a cerrarse, dejando la co-rutina en un estado muerto.'
coroutine.resume            =
'Empieza o continua la ejecución de la co-rutina `co`.'
coroutine.running           =
'Retorna la co-rutina en ejecución con un booleano adicional, señalando si la co-rutina en ejecución es la principal.'
coroutine.status            =
'Retorna el estado de la co-rutina `co`.'
coroutine.wrap              =
'Crea una co-rutina nueva con cuerpo `f`; `f` debe ser una función. Retorna una función que resume la co-rutina cada vez que se le llama.'
coroutine.yield             =
'Suspende la ejecución de la co-rutina que le llama, cediendo el control.'

costatus.running            =
'Está corriendo.'
costatus.suspended          =
'Está suspendida o no ha empezado.'
costatus.normal             =
'Está activa, pero no en ejecución.'
costatus.dead               =
'Ha terminado o se detuvo con un error.'

debug                       =
''
debug.debug                 =
'Entra a un modo interactivo con el usuario, ejecutando cada string que el usuario ingrese.'
debug.getfenv               =
'Retorna el ambiente del objeto `o` .'
debug.gethook               =
'Retorna las configuraciones `hook` de la hebra.'
debug.getinfo               =
'Retorna una tabla con información acerca de una función.'
debug.getlocal['<5.1']      =
'Retorna el nombre y el valor de la variable local con índice `local` de la función en el nivel `level` de la pila.'
debug.getlocal['>5.2']      =
'Retorna el nombre y el valor de la variable local con índice `local` de la función en el nivel `f` de la pila.'
debug.getmetatable          =
'Retorna la metatabla del valor provisto.'
debug.getregistry           =
'Retorna la tabla de registro.'
debug.getupvalue            =
'Retorna el nombre y el valor de la variable anterior con índice `up` de la función.'
debug.getuservalue['<5.3']  =
'Retorna el valor de Lua asociado a u.'
debug.getuservalue['>5.4']  =
[[
Retorna el `n`-ésimo valor asociado
a la data de usuario `u` con un booleano adicional,
`false` si la data de usuario no tiene ese valor.
]]
debug.setcstacklimit        =
[[
### **Obsoleto desde `Lua 5.4.2`**

Asigna un límite nuevo para la pila C. Este límite controla qué tan profundo pueden llegar las llamadas anidadas en Lua con la intención de evitar un desbordamiento de la pila (stack overflow).

En caso de éxito, esta función retorna el límite anterior. En caso de error, retorna `false`.
]]
debug.setfenv               =
'Asigna el ambiente del objeto `object` provisto a la tabla `table` provista.'
debug.sethook               =
'Asigna la función provista como un `hook`.'
debug.setlocal              =
'Asigna el valor `value` a la variable local con índice `local` de la función en el nivel `level` de la pila.'
debug.setmetatable          =
'Asigna la metatabla del valor provisto a la tabla provista (la cual puede ser `nil`).'
debug.setupvalue            =
'Asigna el valor `value` al valor anterior con índice `up` de la función.'
debug.setuservalue['<5.3']  =
'Asigna el valor provisto como el valor de Lua asociado a la provista data de usuario `udata`.'
debug.setuservalue['>5.4']  =
[[
Asigna el valor `value` como
el `n`-ésimo valor asociado a la data de usuario `udata` provista.
`udata` debe ser data de usuario completa.
]]
debug.traceback             =
'Retorna un string con la traza de la pila de llamadas. El string de mensaje opcional está anexado al principio de la traza.'
debug.upvalueid             =
'Retorna un identificador único (como data de usuario ligera) para el valor anterior número `n` de la función provista.'
debug.upvaluejoin           =
'Hace que el `n1`-ésimo valor anterior de la clausura de Lua `f1` se refiera a el `n2`-ésimo valor anterior de la clausura de Lua `f2`.'

infowhat.n                  =
'`name` and `namewhat`'
infowhat.S                  =
'`source`, `short_src`, `linedefined`, `lastlinedefined`, and `what`'
infowhat.l                  =
'`currentline`'
infowhat.t                  =
'`istailcall`'
infowhat.u['<5.1']          =
'`nups`'
infowhat.u['>5.2']          =
'`nups`, `nparams`, and `isvararg`'
infowhat.f                  =
'`func`'
infowhat.r                  =
'`ftransfer` and `ntransfer`'
infowhat.L                  =
'`activelines`'

hookmask.c                  =
'Calls hook when Lua calls a function.'
hookmask.r                  =
'Calls hook when Lua returns from a function.'
hookmask.l                  =
'Calls hook when Lua enters a new line of code.'

file                        =
''
file[':close']              =
'Close `file`.'
file[':flush']              =
'Saves any written data to `file`.'
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
'Reads the `file`, according to the given formats, which specify what to read.'
file[':seek']               =
'Sets and gets the file position, measured from the beginning of the file.'
file[':setvbuf']            =
'Sets the buffering mode for an output file.'
file[':write']              =
'Writes the value of each of its arguments to `file`.'

readmode.n                  =
'Reads a numeral and returns it as number.'
readmode.a                  =
'Reads the whole file.'
readmode.l                  =
'Reads the next line skipping the end of line.'
readmode.L                  =
'Reads the next line keeping the end of line.'

seekwhence.set              =
'Base is beginning of the file.'
seekwhence.cur              =
'Base is current position.'
seekwhence['.end']          =
'Base is end of file.'

vbuf.no                     =
'Output operation appears immediately.'
vbuf.full                   =
'Performed only when the buffer is full.'
vbuf.line                   =
'Buffered until a newline is output.'

io                          =
''
io.stdin                    =
'standard input.'
io.stdout                   =
'standard output.'
io.stderr                   =
'standard error.'
io.close                    =
'Close `file` or default output file.'
io.flush                    =
'Saves any written data to default output file.'
io.input                    =
'Sets `file` as the default input file.'
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
'Opens a file, in the mode specified in the string `mode`.'
io.output                   =
'Sets `file` as the default output file.'
io.popen                    =
'Starts program prog in a separated process.'
io.read                     =
'Reads the `file`, according to the given formats, which specify what to read.'
io.tmpfile                  =
'In case of success, returns a handle for a temporary file.'
io.type                     =
'Checks whether `obj` is a valid file handle.'
io.write                    =
'Writes the value of each of its arguments to default output file.'

openmode.r                  =
'Read mode.'
openmode.w                  =
'Write mode.'
openmode.a                  =
'Append mode.'
openmode['.r+']             =
'Update mode, all previous data is preserved.'
openmode['.w+']             =
'Update mode, all previous data is erased.'
openmode['.a+']             =
'Append update mode, previous data is preserved, writing is only allowed at the end of file.'
openmode.rb                 =
'Read mode. (in binary mode.)'
openmode.wb                 =
'Write mode. (in binary mode.)'
openmode.ab                 =
'Append mode. (in binary mode.)'
openmode['.r+b']            =
'Update mode, all previous data is preserved. (in binary mode.)'
openmode['.w+b']            =
'Update mode, all previous data is erased. (in binary mode.)'
openmode['.a+b']            =
'Append update mode, previous data is preserved, writing is only allowed at the end of file. (in binary mode.)'

popenmode.r                 =
'Read data from this program by `file`.'
popenmode.w                 =
'Write data to this program by `file`.'

filetype.file               =
'Is an open file handle.'
filetype['.closed file']    =
'Is a closed file handle.'
filetype['.nil']            =
'Is not a file handle.'

math                        =
''
math.abs                    =
'Returns the absolute value of `x`.'
math.acos                   =
'Returns the arc cosine of `x` (in radians).'
math.asin                   =
'Returns the arc sine of `x` (in radians).'
math.atan['<5.2']           =
'Returns the arc tangent of `x` (in radians).'
math.atan['>5.3']           =
'Returns the arc tangent of `y/x` (in radians).'
math.atan2                  =
'Returns the arc tangent of `y/x` (in radians).'
math.ceil                   =
'Returns the smallest integral value larger than or equal to `x`.'
math.cos                    =
'Returns the cosine of `x` (assumed to be in radians).'
math.cosh                   =
'Returns the hyperbolic cosine of `x` (assumed to be in radians).'
math.deg                    =
'Converts the angle `x` from radians to degrees.'
math.exp                    =
'Returns the value `e^x` (where `e` is the base of natural logarithms).'
math.floor                  =
'Returns the largest integral value smaller than or equal to `x`.'
math.fmod                   =
'Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.'
math.frexp                  =
'Decompose `x` into tails and exponents. Returns `m` and `e` such that `x = m * (2 ^ e)`, `e` is an integer and the absolute value of `m` is in the range [0.5, 1) (or zero when `x` is zero).'
math.huge                   =
'A value larger than any other numeric value.'
math.ldexp                  =
'Returns `m * (2 ^ e)` .'
math.log['<5.1']            =
'Returns the natural logarithm of `x` .'
math.log['>5.2']            =
'Returns the logarithm of `x` in the given base.'
math.log10                  =
'Returns the base-10 logarithm of x.'
math.max                    =
'Returns the argument with the maximum value, according to the Lua operator `<`.'
math.maxinteger['>5.3']     =
'An integer with the maximum value for an integer.'
math.min                    =
'Returns the argument with the minimum value, according to the Lua operator `<`.'
math.mininteger['>5.3']     =
'An integer with the minimum value for an integer.'
math.modf                   =
'Returns the integral part of `x` and the fractional part of `x`.'
math.pi                     =
'The value of *π*.'
math.pow                    =
'Returns `x ^ y` .'
math.rad                    =
'Converts the angle `x` from degrees to radians.'
math.random                 =
[[
* `math.random()`: Returns a float in the range [0,1).
* `math.random(n)`: Returns a integer in the range [1, n].
* `math.random(m, n)`: Returns a integer in the range [m, n].
]]
math.randomseed['<5.3']     =
'Sets `x` as the "seed" for the pseudo-random generator.'
math.randomseed['>5.4']     =
[[
* `math.randomseed(x, y)`: Concatenate `x` and `y` into a 128-bit `seed` to reinitialize the pseudo-random generator.
* `math.randomseed(x)`: Equate to `math.randomseed(x, 0)` .
* `math.randomseed()`: Generates a seed with a weak attempt for randomness.
]]
math.sin                    =
'Returns the sine of `x` (assumed to be in radians).'
math.sinh                   =
'Returns the hyperbolic sine of `x` (assumed to be in radians).'
math.sqrt                   =
'Returns the square root of `x`.'
math.tan                    =
'Returns the tangent of `x` (assumed to be in radians).'
math.tanh                   =
'Returns the hyperbolic tangent of `x` (assumed to be in radians).'
math.tointeger['>5.3']      =
'If the value `x` is convertible to an integer, returns that integer.'
math.type['>5.3']           =
'Returns `"integer"` if `x` is an integer, `"float"` if it is a float, or `nil` if `x` is not a number.'
math.ult['>5.3']            =
'Returns `true` if and only if `m` is below `n` when they are compared as unsigned integers.'

os                          =
''
os.clock                    =
'Returns an approximation of the amount in seconds of CPU time used by the program.'
os.date                     =
'Returns a string or a table containing date and time, formatted according to the given string `format`.'
os.difftime                 =
'Returns the difference, in seconds, from time `t1` to time `t2`.'
os.execute                  =
'Passes `command` to be executed by an operating system shell.'
os.exit['<5.1']             =
'Calls the C function `exit` to terminate the host program.'
os.exit['>5.2']             =
'Calls the ISO C function `exit` to terminate the host program.'
os.getenv                   =
'Returns the value of the process environment variable `varname`.'
os.remove                   =
'Deletes the file with the given name.'
os.rename                   =
'Renames the file or directory named `oldname` to `newname`.'
os.setlocale                =
'Sets the current locale of the program.'
os.time                     =
'Returns the current time when called without arguments, or a time representing the local date and time specified by the given table.'
os.tmpname                  =
'Returns a string with a file name that can be used for a temporary file.'

osdate.year                 =
'four digits'
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
'weekday, 1–7, Sunday is 1'
osdate.yday                 =
'day of the year, 1–366'
osdate.isdst                =
'daylight saving flag, a boolean'

package                     =
''

require['<5.3']             =
'Loads the given module, returns any value returned by the given module(`true` when `nil`).'
require['>5.4']             =
'Loads the given module, returns any value returned by the searcher(`true` when `nil`). Besides that value, also returns as a second result the loader data returned by the searcher, which indicates how `require` found the module. (For instance, if the module came from a file, this loader data is the file path.)'

package.config              =
'A string describing some compile-time configurations for packages.'
package.cpath               =
'The path used by `require` to search for a C loader.'
package.loaded              =
'A table used by `require` to control which modules are already loaded.'
package.loaders             =
'A table used by `require` to control how to load modules.'
package.loadlib             =
'Dynamically links the host program with the C library `libname`.'
package.path                =
'The path used by `require` to search for a Lua loader.'
package.preload             =
'A table to store loaders for specific modules.'
package.searchers           =
'A table used by `require` to control how to load modules.'
package.searchpath          =
'Searches for the given `name` in the given `path`.'
package.seeall              =
'Sets a metatable for `module` with its `__index` field referring to the global environment, so that this module inherits values from the global environment. To be used as an option to function `module` .'

string                      =
''
string.byte                 =
'Returns the internal numeric codes of the characters `s[i], s[i+1], ..., s[j]`.'
string.char                 =
'Returns a string with length equal to the number of arguments, in which each character has the internal numeric code equal to its corresponding argument.'
string.dump                 =
'Returns a string containing a binary representation (a *binary chunk*) of the given function.'
string.find                 =
'Looks for the first match of `pattern` (see §6.4.1) in the string.'
string.format               =
'Returns a formatted version of its variable number of arguments following the description given in its first argument.'
string.gmatch               =
[[
Returns an iterator function that, each time it is called, returns the next captures from `pattern` (see §6.4.1) over the string s.

As an example, the following loop will iterate over all the words from string s, printing one per line:
```lua
    s =
"hello world from Lua"
    for w in string.gmatch(s, "%a+") do
        print(w)
    end
```
]]
string.gsub                 =
'Returns a copy of s in which all (or the first `n`, if given) occurrences of the `pattern` (see §6.4.1) have been replaced by a replacement string specified by `repl`.'
string.len                  =
'Returns its length.'
string.lower                =
'Returns a copy of this string with all uppercase letters changed to lowercase.'
string.match                =
'Looks for the first match of `pattern` (see §6.4.1) in the string.'
string.pack                 =
'Returns a binary string containing the values `v1`, `v2`, etc. packed (that is, serialized in binary form) according to the format string `fmt` (see §6.4.2) .'
string.packsize             =
'Returns the size of a string resulting from `string.pack` with the given format string `fmt` (see §6.4.2) .'
string.rep['>5.2']          =
'Returns a string that is the concatenation of `n` copies of the string `s` separated by the string `sep`.'
string.rep['<5.1']          =
'Returns a string that is the concatenation of `n` copies of the string `s` .'
string.reverse              =
'Returns a string that is the string `s` reversed.'
string.sub                  =
'Returns the substring of the string that starts at `i` and continues until `j`.'
string.unpack               =
'Returns the values packed in string according to the format string `fmt` (see §6.4.2) .'
string.upper                =
'Returns a copy of this string with all lowercase letters changed to uppercase.'

table                       =
''
table.concat                =
'Given a list where all elements are strings or numbers, returns the string `list[i]..sep..list[i+1] ··· sep..list[j]`.'
table.insert                =
'Inserts element `value` at position `pos` in `list`.'
table.maxn                  =
'Returns the largest positive numerical index of the given table, or zero if the table has no positive numerical indices.'
table.move                  =
[[
Moves elements from table `a1` to table `a2`.
```lua
a2[t],··· =
a1[f],···,a1[e]
return a2
```
]]
table.pack                  =
'Returns a new table with all arguments stored into keys `1`, `2`, etc. and with a field `"n"` with the total number of arguments.'
table.remove                =
'Removes from `list` the element at position `pos`, returning the value of the removed element.'
table.sort                  =
'Sorts list elements in a given order, *in-place*, from `list[1]` to `list[#list]`.'
table.unpack                =
[[
Returns the elements from the given list. This function is equivalent to
```lua
    return list[i], list[i+1], ···, list[j]
```
By default, `i` is `1` and `j` is `#list`.
]]
table.foreach               =
'Executes the given f over all elements of table. For each element, f is called with the index and respective value as arguments. If f returns a non-nil value, then the loop is broken, and this value is returned as the final value of foreach.'
table.foreachi              =
'Executes the given f over the numerical indices of table. For each index, f is called with the index and respective value as arguments. Indices are visited in sequential order, from 1 to n, where n is the size of the table. If f returns a non-nil value, then the loop is broken and this value is returned as the result of foreachi.'
table.getn                  =
'Returns the number of elements in the table. This function is equivalent to `#list`.'
table.new                   =
[[This creates a pre-sized table, just like the C API equivalent `lua_createtable()`. This is useful for big tables if the final table size is known and automatic table resizing is too expensive. `narray` parameter specifies the number of array-like items, and `nhash` parameter specifies the number of hash-like items. The function needs to be required before use.
```lua
    require("table.new")
```
]]
table.clear                 =
[[This clears all keys and values from a table, but preserves the allocated array/hash sizes. This is useful when a table, which is linked from multiple places, needs to be cleared and/or when recycling a table for use by the same context. This avoids managing backlinks, saves an allocation and the overhead of incremental array/hash part growth. The function needs to be required before use.
```lua
    require("table.clear").
```
Please note this function is meant for very specific situations. In most cases it's better to replace the (usually single) link with a new table and let the GC do its work.
]]

utf8                        =
''
utf8.char                   =
'Receives zero or more integers, converts each one to its corresponding UTF-8 byte sequence and returns a string with the concatenation of all these sequences.'
utf8.charpattern            =
'The pattern which matches exactly one UTF-8 byte sequence, assuming that the subject is a valid UTF-8 string.'
utf8.codes                  =
[[
Returns values so that the construction
```lua
for p, c in utf8.codes(s) do
    body
end
```
will iterate over all UTF-8 characters in string s, with p being the position (in bytes) and c the code point of each character. It raises an error if it meets any invalid byte sequence.
]]
utf8.codepoint              =
'Returns the codepoints (as integers) from all characters in `s` that start between byte position `i` and `j` (both included).'
utf8.len                    =
'Returns the number of UTF-8 characters in string `s` that start between positions `i` and `j` (both inclusive).'
utf8.offset                 =
'Returns the position (in bytes) where the encoding of the `n`-th character of `s` (counting from position `i`) starts.'
