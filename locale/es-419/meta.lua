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
'Una variable global (no una función) que tiene el ambiente global (véase §2.2). Esta variable no se ocupa en Lua mismo; el cambiar su valor no afecta a ningún ambiente y vice-versa.'

getfenv             =
'Retorna el ambiente que usa la función actualmente. `f` puede ser una función de Lua o un número que especifica la función en ese nivel de la pila de llamadas.'

getmetatable        =
'Si el objecto no tiene una metatabla, returna nil. Si no, si la metatabla del objeto tiene un campo __metatable, retorna el valor asociado. Si tampoco es así, retorna la metatabla del objeto dado.'

ipairs              =
[[
Retorna tres valores (una función iteradora, la tabla `t` y `0`) cosa que la estructura
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

La conversión de strings puede resultar en enteros o flotantes, de acuerdo a las convenciones léxicas de Lua (véase §3.1). El string puede tener espacios al principio, al final y tener un signo.
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
'Retorna verdadero cuando la co-rutina `co` puede suspenderse cediendo el control. El valor predeterminado para `co` es la co-rutina actualmente en ejecución.'
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
'`name` y `namewhat`'
infowhat.S                  =
'`source`, `short_src`, `linedefined`, `lastlinedefined`, y `what`'
infowhat.l                  =
'`currentline`'
infowhat.t                  =
'`istailcall`'
infowhat.u['<5.1']          =
'`nups`'
infowhat.u['>5.2']          =
'`nups`, `nparams`, y `isvararg`'
infowhat.f                  =
'`func`'
infowhat.r                  =
'`ftransfer` y `ntransfer`'
infowhat.L                  =
'`activelines`'

hookmask.c                  =
'Llama al hook cuando se llama a una función desde Lua.'
hookmask.r                  =
'Llama al hook cuand se retorna de una función desde Lua.'
hookmask.l                  =
'Llama al hook cuand se entra a una nueva línea de código desde Lua.'

file                        =
''
file[':close']              =
'Cierra el archivo `file`.'
file[':flush']              =
'Guarda la data escrita al archivo `file`.'
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
'Lee el archivo `file`, de acuerdo a los formatos provistos, los cuales especifican qué leer.'
file[':seek']               =
'Fija y obtiene la posición del archivo, a contar del principio del archivo.'
file[':setvbuf']            =
'Fija el modo de buffer para un archivo de salida.'
file[':write']              =
'Escribe el valor de cada uno de sus argumentos al archivo`file`.'

readmode.n                  =
'Lee un numeral y lo devuelve como un número.'
readmode.a                  =
'Lee todo el archivo.'
readmode.l                  =
'Lee la siguiente línea, saltándose el fin-de-línea.'
readmode.L                  =
'Lee la siguiente línea, manteniendo el fin-de-línea.'

seekwhence.set              =
'Sitúa la posición base está al inicio del archivo.'
seekwhence.cur              =
'Sitúa la posición base en la actual.'

seekwhence['.end']          =
'Sitúa la posición base al final del archivo.'

vbuf.no                     =
'La salida de la operación aparece de inmediato.'
vbuf.full                   =
'Realizado solo cuando el `buffer` está lleno.'
vbuf.line                   =
'Almacenado en el `buffer` hasta que se encuentra un salto de línea en la salida.'

io                          =
''
io.stdin                    =
'Entrada estándar.'
io.stdout                   =
'Salida estándar.'
io.stderr                   =
'Salida de error estándar.'
io.close                    =
'Cierra el archivo `file` o el archivo de salida predeterminado.'
io.flush                    =
'Guarda la data escrita al archivo de salida predeterminado.'
io.input                    =
'Asigna `file` como el archivo de entrada predeterminado.'
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
'Abre un archivo en el modo especificado en el string `mode`.'
io.output                   =
'Asigna `file` como el archivo de salida predeterminado.'
io.popen                    =
'Inicia el programa provisto como un proceso separado.'
io.read                     =
'Lee el archivo de acuerdo a los formatos provistos, los cuales especifican qué leer.'
io.tmpfile                  =
'En caso de éxito retorna un descriptor de archvivo a un archivo temporal.'
io.type                     =
'Verifica si el objeto `obj` es un descriptor de archivo válido.'
io.write                    =
'Escribe el valor de cada uno de sus argumentos al archivo de salida predeterminado.'

openmode.r                  =
'Modo de lectura.'
openmode.w                  =
'Modo de escritura.'
openmode.a                  =
'Modo de agregado.'
openmode['.r+']             =
'Modo de actualización, toda data existente es preservada.'
openmode['.w+']             =
'Modo de actualización, toda data existente es borrada.'
openmode['.a+']             =
'Modo de agregado y actualización, toda data existente es preservada, la escritura solo es permitida al final del archivo.'
openmode.rb                 =
'Modo de lectura. (en modo binario)'
openmode.wb                 =
'Modo de escritura. (en modo binario)'
openmode.ab                 =
'Modo de agregado. (en modo binario)'
openmode['.r+b']            =
'Modo de actualización, toda data existente es preservada. (en modo binario)'
openmode['.w+b']            =
'Modo de actualización, toda data existente es borrada. (en modo binario)'
openmode['.a+b']            =
'Modo de agregado y actualización, toda data existente es preservada, la escritura solo es permitida al final del archivo. (en modo binario)'

popenmode.r                 =
'Lee data the este programa por archivo `file`.'
popenmode.w                 =
'Escribe data the este programa por archivo `file`.'

filetype.file               =
'Es un descriptor de archivo abierto.'
filetype['.closed file']    =
'Es un descriptor de archivo cerrado.'
filetype['.nil']            =
'No es un descriptor de archivo.'

math                        =
''
math.abs                    =
'Retorna el valor absoluto de `x`.'
math.acos                   =
'Retorna el arcocoseno de `x` (en radianes).'
math.asin                   =
'Retorna el arcoseno de `x` (en radianes).'
math.atan['<5.2']           =
'Retorna el arcotangente de `x` (en radianes).'
math.atan['>5.3']           =
'Retorna el arcotangente de `y/x` (en radianes).'
math.atan2                  =
'Retorna el arcotangente de `y/x` (en radianes).'
math.ceil                   =
'Retorna el menor valor integral mayor o igual a `x`.'
math.cos                    =
'Retorna el coseno de `x` (se asume que está en radianes).'
math.cosh                   =
'Retorna el coseno hiperbólico de `x` (se asume que está en radianes).'
math.deg                    =
'Convierte el ángulo `x` de radianes a grados.'
math.exp                    =
'Retorna el valor `e^x` (donde `e` es la base del logaritmo natural).'
math.floor                  =
'Retorna el mayor valor integral más menor o igual a `x`.'
math.fmod                   =
'Retorna el resto de la división de `x` por `y` que redondea el cuociente hacia cero.'
math.frexp                  =
'Descompone `x` en mantisa y exponente. Retorna `m` y `e` tal que  `x = m * (2 ^ e)`, `e` es un entero y el valor absoluto de `m` está en el rango [0.5, 1) (ó cero cuando `x` es cero).'
math.huge                   =
'Un valor mayor que cualquier otro valor numérico.'
math.ldexp                  =
'Retorna `m * (2 ^ e)` .'
math.log['<5.1']            =
'Retorna el logaritmo natural de `x` .'
math.log['>5.2']            =
'Retorna el logaritmo de `x` en la base provista.'
math.log10                  =
'Retorna el logaritmo en base 10 de `x` .'
math.max                    =
'Retorna el argumento con el valor máximo, de acuerdo al operador de Lua `<`.'
math.maxinteger['>5.3']     =
'Un entero con el valor máximo para un entero.'
math.min                    =
'Retorna el argumento con el valor mínimo, de acuerdo al operador de Lua `<`.'
math.mininteger['>5.3']     =
'Un entero con el valor mínimo para un entero.'
math.modf                   =
'Retorna la parte integral de `x` y la parte fraccional de `x`.'
math.pi                     =
'El valor de *π*.'
math.pow                    =
'Retorna `x ^ y` .'
math.rad                    =
'Convierte el ángulo `x` de grados a radianes.'
math.random                 =
[[
* `math.random()`: Returns a float in the range [0,1).
* `math.random(n)`: Returns a integer in the range [1, n].
* `math.random(m, n)`: Returns a integer in the range [m, n].
]]
math.randomseed['<5.3']     =
'Asigna `x` como el valor de semilla para el generador de números pseudo-aleatorios.'
math.randomseed['>5.4']     =
[[
* `math.randomseed(x, y)`: Concatenate `x` and `y` into a 128-bit `seed` to reinitialize the pseudo-random generator.
* `math.randomseed(x)`: Equate to `math.randomseed(x, 0)` .
* `math.randomseed()`: Generates a seed with a weak attempt for randomness.
]]
math.sin                    =
'Retorna el seno de `x` (se asume que está en radianes).'
math.sinh                   =
'Retorna el seno hiperbólico de `x` (se asume que está en radianes).'
math.sqrt                   =
'Retorna la raíz cuadrada de `x`.'
math.tan                    =
'Retorna la tangente de `x` (se asume que está en radianes).'
math.tanh                   =
'Retorna la tangente hiperbólica de `x` (se asume que está en radianes).'
math.tointeger['>5.3']      =
'Si el valor de `x` se puede convertir a un entero, retorna ese entero.'
math.type['>5.3']           =
'Retorna `"integer"` si `x` es un entero, `"float"` si es un flotante ó `nil` si `x` no es un número.'
math.ult['>5.3']            =
'Retorna `true` si y sólo si `m` es menor que `n` cuando son comparados como enteros sin signo.'

os                          =
''
os.clock                    =
'Retorna una aproximación de la cantidad de segundos en tiempo de CPU usado por el programa.'
os.date                     =
'Retorna un string o una tabla que contiene la fecha y el tiempo, formateados de acuerdo al string `format` provisto.'
os.difftime                 =
'Retorna la diferencia, en segundos, desde el tiempo `t1` al tiempo `t2`.'
os.execute                  =
'Pasa el comando `command` para ser ejecutado por una llamada al intérprete *shell* del sistema operativo.'
os.exit['<5.1']             =
'Llama la función de C `exit` para terminar el programa anfitrión.'
os.exit['>5.2']             =
'Llama la función de C ISO `exit` para terminar el programa anfitrión.'
os.getenv                   =
'Retorna el valor de la variable `varname` del ambiente del proceso.'
os.remove                   =
'Borra el archivo con el nombre provisto.'
os.rename                   =
'Renombra el archivo o directorio con nombre `oldname` al nuevo `newname`.'
os.setlocale                =
'Fija la localización linguística actual del programa.'
os.time                     =
'Retorna el tiempo actual cuando se le llama sin argumentos o el tiempo que representa la fecha y hora local especificadas por la tabla provista.'
os.tmpname                  =
'Retorna un string con un nombre de archivo que puede ser usado como archivo temporal.'

osdate.year                 =
'cuatro dígitos'
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
'día de la semana, 1-7, Domingo es 1'
osdate.yday                 =
'día del año, 1–366'
osdate.isdst                =
'indicador de horario de verano, un booleano'

package                     =
''

require['<5.3']             =
'Carga el módulo provisto, retorna cualquier valor retornado por el módulo provisto (`true` cuando es `nil`).'
require['>5.4']             =
'Carga el módulo provisto, retorna cualquier valor retornado por el buscador (`true` cuando es `nil`). Aparte de ese valor, también retorna el cargador de datos retornados por el buscador como segundo resultado, lo que indica cómo `require` encontró el módulo. (Por ejemplo, si el módulo viene de un archivo, los datos del cargador son la ruta a dicho archivo.'

package.config              =
'Un string describiendo algunas configuracions en tiempo de compilación para los paquetes.'
package.cpath               =
'La ruta usada por `require` para buscar por un cargador de C.'
package.loaded              =
'Una tabla usada por `require` para controlar qué módulos ya se han cargado.'
package.loaders             =
'Una tabla usada por `require` para controlar cómo cargar los módulos.'
package.loadlib             =
'Enlaza dinámicamente el programa anfitrión con la biblioteca de C `libname`.'
package.path                =
'Ruta usada por `require` para buscar por un cargador de Lua.'
package.preload             =
'Tabla para almacenar cargadores de módulos específicos.'
package.searchers           =
'Una tabla usada por `require` para controlar cómo buscar los módulos.'
package.searchpath          =
'Busca por el nombre `name` en la ruta `path`.'
package.seeall              =
'Asigna una metatabla para el `module` con su campo `__index` apuntando al ambiente global, de manera que este módulo hereda los valores del ambiente global. Se usa como opción para la función `module` .'

string                      =
''
string.byte                 =
'Retorna los códigos numéricos internos de los caracteres `s[i], s[i+1], ..., s[j]`.'
string.char                 =
'Retorna un string con largo igual al número de argumeentos, en el que cada caracter tiene el código numérico internol igual a su argumento correspondiente.'
string.dump                 =
'Retorna un string que contiene una representación binaria de la función provista.'
string.find                 =
'Busca el primer calce del patrón `pattern` (véase §6.4.1) en el string.'
string.format               =
'Retorna una versión formateada de su argumentos (en número variable) siguiendo la descripción dada en su primer argumento.'
string.gmatch               =
[[
Retorna una función iteradora que cada vez que es llamada retorna las siguientes capturas del patrón `pattern` (véase §6.4.1) sobre el string s.

Por ejemplo, el bucle siguiente itera sobre todas las palabras del sstring s, imprimiendo una por línea:
```lua
    s =
"hello world from Lua"
    for w in string.gmatch(s, "%a+") do
        print(w)
    end
```
]]
string.gsub                 =
'Retorna una copia de s en la cual todos (o los primeras `n`, si es provisto este argumento) ocurrencias del patrón `pattern` (vease §6.4.1) han sido reemplazadas por el string de reemplazo especificado por `repl`.'
string.len                  =
'Retorna el largo.'
string.lower                =
'Retorna una copia de este string con todas sus letras mayúsculas cambiadas a minúsculas.'
string.match                =
'Busca el primer calce del patrón `pattern` (véase §6.4.1) en el string.'
string.pack                 =
'Retorna el string binario que contiene los valores `v1`, `v2`, etc. empacados (serializados en forma binaria) de acuerdo al string de formato `fmt` (véase §6.4.2) .'
string.packsize             =
'Retorna el largo del string que retorna `string.pack` con el formato `fmt` (véase §6.4.2) provisto.'
string.rep['>5.2']          =
'Retorna el string que es la concatenación de `n` copias del string `s` separado por el string `sep`.'
string.rep['<5.1']          =
'Retorna el string que es la concatenación de `n` copias del string `s` .'
string.reverse              =
'Retorna el string que es el string `s` al revés.'
string.sub                  =
'Retorna el substring del string que empieza en `i` y continúa hasta `j`.'
string.unpack               =
'Retorna los valores empacados en el string de acuerdo al string de formato `fmt` (véase §6.4.2) .'
string.upper                =
'Retorna una copia de este string con todas sus letras minúsculas cambiadas a mayúsculas.'

table                       =
''
table.concat                =
'Dada una lista donde todos los elementos son strings o números, retorna el string `list[i]..sep..list[i+1] ··· sep..list[j]`.'
table.insert                =
'Inserta el elemento `value` en la posición `pos` en la lista `list`.'
table.maxn                  =
'Retorna el índice numérico positivo más grande de la tabla provista o cero si la tabla no tiene un índice numérico positivo.'
table.move                  =
[[
Mueve los elementos de la tabla `a1` a la tabla `a2`.
```lua
a2[t],··· =
a1[f],···,a1[e]
return a2
```
]]
table.pack                  =
'Retorna una nueva tabla con todos los argumentos almacenados en las claves `1`, `2`, etc. y con un campo `"n"` con el número total de argumentos.'
table.remove                =
'Remueve de la lista `list`, el elemento en la posición `pos`, retornando el valor del elemento removido.'
table.sort                  =
'Ordena los elementos de la lista en un orden dado, *modificando la propia lista*, desde `list[1]` hasta `list[#list]`.'
table.unpack                =
[[
Retorna los elementos de la lista provista. Esta función es equivalente a
```lua
    return list[i], list[i+1], ···, list[j]
```
By default, `i` is `1` and `j` is `#list`.
]]
table.foreach               =
'Llama a la función provista f sobre cada uno de los elementos de la tabla. Por cada elemento, f es llamada con el índice y valor respectivo como argumentos. Si f retorna un valor no-nulo, el bucle se termina forzosamente y este valor es retornado como el valor final de foreach.'
table.foreachi              =
'Ejecuta la f provista sobre los índices numéricos de la tabla. Por cada índice, f es llamada con el índice y valor respectivo como argumentos. Los índices son visitados en orden secuencial, de 1 a n, donde ne es el tamaño de la tabla. Si f retorna un valor no-nulo, el bucle se termina forzosamente y este valor es retornado como el valor final de foreachi.'
table.getn                  =
'Retorna el número de elmentos en la tabla. Esta función es equivalente a `#list`.'
table.new                   =
[[Esta función crea una tabla con el tamaño provisto, como la API en C equivalente `lua_createtable()`. Esta función es útil para tablas grandes si el tamaño final de la tabla es conocido y el agrandar automáticamente la tabla es muy caro. El parámetro `narray` especifica el número de ítemes de tipo de arreglo y el parámetro `nhash` especifica el número de ítemes de tipo diccionario.
```lua
    require("table.new")
```
]]
table.clear                 =
[[Esta función barre con todas las claves y valores de una tabla, pero preserva los tamaños de arreglo/diccionario reservados en memoria. Esta función es útil cuando una tabla que ha sido enlazada desde múltiples otras partes requiere ser vaciada y/o cuando se recicla una tabla para ser usada en el mismo contexto. Esto previene manejar enlaces de vuelta, previene tener que asignar memoria y el costo operativo del crecimiento incremental de la parte arreglo/diccionario.
```lua
    require("table.clear").
```
Nótese que esta función está hecha para situaciones muy específicas. En la mayoría de los casos es mejor reemplazar el enlace (el cual suele ser simple) con una tabla nueva y permitir que el recolector de basura haga su trabajo.
]]

utf8                        =
''
utf8.char                   =
'Recibe cero ó más enteros, convierte a cada uno a su secuencia de bytes en UTF-8 correspondiente y retorna un string con la concatenación de todas estas secuencias.'
utf8.charpattern            =
'El patrón con el que se calza exactamente una secuencia de bytes en UTF-8, asumiendo que el sujeto es un string en UTF-8 válido.'
utf8.codes                  =
[[
Retorna valores tal que el constructo
```lua
for p, c in utf8.codes(s) do
    body
end
```
itera sobre todos los caracteres en UTF-8 en el string s, con p siendo la posición en bytes y c el punto de código de cada caracter. Alza un error si se encuentra con alguna secuencia inválida de bytes.
]]
utf8.codepoint              =
'Retorna los puntos de códigos como enteros de todos los caracteres en `s` que empiezan entre la posición en bytes `i` y `j` (ambos inclusive).'
utf8.len                    =
'Retorna el número de caracteres en UTF-8 en el string `s` que empiezan entre las posiciones `i` y `j` (ambos inclusive).'
utf8.offset                 =
'Retorna la posición en bytes donde la codificación del caracter `n`-ésimo de `s` empieza, contado a partir de la posición `i`.'
