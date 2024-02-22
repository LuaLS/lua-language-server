---@diagnostic disable: undefined-global, lowercase-global

arg                 =
'獨立版Lua的啟動引數。'

assert              =
'如果其引數 `v` 的值為假（ `nil` 或 `false` ），它就呼叫 $error ；否則，回傳所有的引數。在錯誤情況時， `message` 指那個錯誤對象；如果不提供這個引數，預設為 `"assertion failed!"` 。'

cgopt.collect       =
'做一次完整的垃圾回收循環。'
cgopt.stop          =
'停止垃圾回收器的執行。'
cgopt.restart       =
'重新啟動垃圾回收器的自動執行。'
cgopt.count         =
'以 K 位元組數為單位回傳 Lua 使用的總記憶體數。'
cgopt.step          =
'單步執行垃圾回收器。 步長“大小”由 `arg` 控制。'
cgopt.setpause      =
'將 `arg` 設為回收器的 *間歇率* 。'
cgopt.setstepmul    =
'將 `arg` 設為回收器的 *步進倍率* 。'
cgopt.incremental   =
'改變回收器模式為增量模式。'
cgopt.generational  =
'改變回收器模式為分代模式。'
cgopt.isrunning     =
'回傳表示回收器是否在工作的布林值。'

collectgarbage      =
'這個函式是垃圾回收器的一般介面。透過引數 opt 它提供了一組不同的功能。'

dofile              =
'打開該名字的檔案，並執行檔案中的 Lua 程式碼區塊。不帶引數呼叫時， `dofile` 執行標準輸入的內容（`stdin`）。回傳該程式碼區塊的所有回傳值。對於有錯誤的情況， `dofile` 將錯誤回饋給呼叫者（即 `dofile` 沒有執行在保護模式下）。'

error               =
[[
中止上一次保護函式呼叫，將錯誤對象 `message` 回傳。函式 `error` 永遠不會回傳。

當 `message` 是一個字串時，通常 `error` 會把一些有關出錯位置的資訊附加在訊息的開頭。 `level` 引數指明了怎樣獲得出錯位置。
]]

_G                  =
'一個全域變數（非函式），內部儲存有全域環境（參見 §2.2）。 Lua 自己不使用這個變數；改變這個變數的值不會對任何環境造成影響，反之亦然。'

getfenv             =
'回傳給定函式的環境。 `f` 可以是一個Lua函式，也可是一個表示呼叫堆疊層級的數字。'

getmetatable        =
'如果 `object` 不包含中繼資料表，回傳 `nil` 。否則，如果在該物件的中繼資料表中有 `"__metatable"` 域時回傳其關聯值，沒有時回傳該對象的中繼資料表。'

ipairs              =
[[
回傳三個值（疊代函式、表 `t` 以及 `0` ），如此，以下程式碼
```lua
    for i,v in ipairs(t) do body end
```
將疊代鍵值對 `(1,t[1])、(2,t[2])...` ，直到第一個空值。
]]

loadmode.b        =
'只能是二進制程式碼區塊。'
loadmode.t        =
'只能是文字程式碼區塊。'
loadmode.bt       =
'可以是二進制也可以是文字。'

load['<5.1']      =
'使用 `func` 分段載入程式碼區塊。每次呼叫 `func` 必須回傳一個字串用於連接前文。'
load['>5.2']      =
[[
載入一個程式碼區塊。

如果 `chunk` 是一個字串，程式碼區塊指這個字串。如果 `chunk` 是一個函式， `load` 不斷地呼叫它獲取程式碼區塊的片段。每次對 `chunk` 的呼叫都必須回傳一個字串緊緊連接在上次呼叫的回傳串之後。當回傳空串、 `nil` 、或是不回傳值時，都表示程式碼區塊結束。
]]

loadfile            =
'從檔案 `filename` 或標準輸入（如果檔名未提供）中獲取程式碼區塊。'

loadstring          =
'使用給定字串載入程式碼區塊。'

module              =
'建立一個模組。'

next                =
[[
執行程式來走訪表中的所有域。第一個引數是要走訪的表，第二個引數是表中的某個鍵。 `next` 回傳該鍵的下一個鍵及其關聯的值。如果用 `nil` 作為第二個引數呼叫 `next` 將回傳初始鍵及其關聯值。當以最後一個鍵去呼叫，或是以 `nil` 呼叫一張空表時， `next` 回傳 `nil`。如果不提供第二個引數，將預設它就是 `nil`。特別指出，你可以用 `next(t)` 來判斷一張表是否是空的。

索引在走訪過程中的順序無定義，即使是數字索引也是這樣。（如果想按數字順序走訪表，可以使用數字形式的 `for` 。）

當在走訪過程中你給表中並不存在的域賦值， `next` 的行為是未定義的。然而你可以去修改那些已存在的域。特別指出，你可以清除一些已存在的域。
]]

pairs               =
[[
如果 `t` 有元方法 `__pairs` ，以 `t` 為引數呼叫它，並回傳其回傳的前三個值。

否則，回傳三個值： `next` 函式，表 `t` ，以及 `nil` 。因此以下程式碼
```lua
    for k,v in pairs(t) do body end
```
能疊代表 `t` 中的所有鍵值對。

參見函式 $next 中關於疊代過程中修改表的風險。
]]

pcall               =
'透過將函式 `f` 傳入引數，以 *保護模式* 呼叫 `f` 。這意味著 `f` 中的任何錯誤不會擲回；取而代之的是， `pcall` 會將錯誤捕獲到，並回傳一個狀態碼。第一個回傳值是狀態碼（一個布林值），當沒有錯誤時，其為 `true` 。此時， `pcall` 同樣會在狀態碼後回傳所有呼叫的結果。在有錯誤時，`pcall` 回傳 `false` 加錯誤訊息。'

print               =
'接收任意數量的引數，並將它們的值列印到 `stdout`。它用 `tostring` 函式將每個引數都轉換為字串。 `print` 不用於做格式化輸出。僅作為看一下某個值的快捷方式，多用於除錯。完整的對輸出的控制，請使用 $string.format 以及 $io.write。'

rawequal            =
'在不觸發任何元方法的情況下，檢查 `v1` 是否和 `v2` 相等。回傳一個布林值。'

rawget              =
'在不觸發任何元方法的情況下，獲取 `table[index]` 的值。 `table` 必須是一張表； `index` 可以是任何值。'

rawlen              =
'在不觸發任何元方法的情況下，回傳物件 `v` 的長度。 `v` 可以是表或字串。它回傳一個整數。'

rawset              =
[[
在不觸發任何元方法的情況下，將 `table[index]` 設為 `value`。 `table` 必須是一張表， `index` 可以是 `nil` 與 `NaN` 之外的任何值。 `value` 可以是任何 Lua 值。
這個函式回傳 `table`。
]]

select              =
'如果 `index` 是個數字，那麼回傳引數中第 `index` 個之後的部分；負的數字會從後向前索引（`-1` 指最後一個引數）。否則， `index` 必須是字串 `"#"` ，此時 `select` 回傳引數的個數。'

setfenv             =
'設定給定函式的環境。'

setmetatable        =
[[
為指定的表設定中繼資料表。（你不能在 Lua 中改變其它類型值的中繼資料表，那些只能在 C 裡做。）如果 `metatable` 是 `nil`，將指定的表的中繼資料表移除。如果原來那張中繼資料表有 `"__metatable"` 域，擲回一個錯誤。
]]

tonumber            =
[[
如果呼叫的時候沒有 `base` ， `tonumber` 嘗試把引數轉換為一個數字。如果引數已經是一個數字，或是一個可以轉換為數字的字串， `tonumber` 就回傳這個數字，否則回傳 `fail`。

字串的轉換結果可能是整數也可能是浮點數，這取決於 Lua 的轉換文法（參見 §3.1）。（字串可以有前置和後置的空格，可以帶符號。）
]]

tostring            =
[[
可以接收任何類型，它將其轉換為人可閱讀的字串形式。浮點數總被轉換為浮點數的表現形式（小數點形式或是指數形式）。
如果 `v` 有 `"__tostring"` 域的中繼資料表， `tostring` 會以 `v` 為引數呼叫它。並用它的結果作為回傳值。
如果想完全控制數字如何被轉換，可以使用 $string.format 。
]]

type                =
[[
將引數的類型編碼為一個字串回傳。 函式可能的回傳值有 `"nil"` （一個字串，而不是 `nil` 值）、 `"number"` 、 `"string"` 、 `"boolean"` 、 `"table"` 、 `"function"` 、 `"thread"` 和 `"userdata"`。
]]

_VERSION            =
'一個包含有目前直譯器版本號的全域變數（並非函式）。'

warn                =
'使用所有引數組成的字串訊息來發送警告。'

xpcall['=5.1']      =
'透過將函式 `f` 傳入引數，以 *保護模式* 呼叫 `f` 。這個函式和 `pcall` 類似。不過它可以額外設定一個訊息處理器 `err`。'
xpcall['>5.2']      =
'透過將函式 `f` 傳入引數，以 *保護模式* 呼叫 `f` 。這個函式和 `pcall` 類似。不過它可以額外設定一個訊息處理器 `msgh`。'

unpack              =
[[
回傳給定 `list` 中的所有元素。該函式等價於
```lua
return list[i], list[i+1], ···, list[j]
```
]]

bit32               =
''
bit32.arshift       =
[[
回傳 `x` 向右位移 `disp` 位的結果。`disp` 為負時向左位移。這是算數位元運算，左側的空位使用 `x` 的高位元填充，右側空位使用 `0` 填充。
]]
bit32.band          =
'回傳參數按位元及的結果。'
bit32.bnot          =
[[
回傳 `x` 按位元取反的結果。

```lua
assert(bit32.bnot(x) ==
(-1 - x) % 2^32)
```
]]
bit32.bor           =
'回傳參數按位元或的結果。'
bit32.btest         =
'參數按位元與的結果不為 `0` 時，回傳 `true` 。'
bit32.bxor          =
'回傳參數按位元互斥或的結果。'
bit32.extract       =
'回傳 `n` 中第 `field` 到第 `field + width - 1` 位組成的結果。'
bit32.replace       =
'回傳 `v` 的第 `field` 到第 `field + width - 1` 位替換 `n` 的對應位後的結果。'
bit32.lrotate       =
'回傳 `x` 向左旋轉 `disp` 位的結果。`disp` 為負時向右旋轉。'
bit32.lshift        =
[[
回傳 `x` 向左位移 `disp` 位的結果。`disp` 為負時向右位移。空位總是使用 `0` 填充。

```lua
assert(bit32.lshift(b, disp) ==
(b * 2^disp) % 2^32)
```
]]
bit32.rrotate       =
'回傳 `x` 向右旋轉 `disp` 位的結果。`disp` 為負時向左旋轉。'
bit32.rshift        =
[[
回傳 `x` 向右位移 `disp` 位的結果。`disp` 為負時向左位移。空位總是使用 `0` 填充。

```lua
assert(bit32.lshift(b, disp) ==
(b * 2^disp) % 2^32)
```
]]

coroutine                     =
''
coroutine.create              =
'建立一個主體函式為 `f` 的新共常式。 f 必須是一個 Lua 的函式。回傳這個新共常式，它是一個類型為 `"thread"` 的物件。'
coroutine.isyieldable         =
'如果正在執行的共常式可以讓出，則回傳真。'
coroutine.isyieldable['>5.4'] =
'如果共常式 `co` 可以讓出，則回傳真。 `co` 預設為正在執行的共常式。'
coroutine.close               =
'關閉共常式 `co` ，並關閉它所有等待 *to-be-closed* 的變數，並將共常式狀態設為 `dead` 。'
coroutine.resume              =
'開始或繼續共常式 `co` 的執行。'
coroutine.running             =
'回傳目前正在執行的共常式加一個布林值。如果目前執行的共常式是主執行緒，其為真。'
coroutine.status              =
'以字串形式回傳共常式 `co` 的狀態。'
coroutine.wrap                =
'建立一個主體函式為 `f` 的新共常式。 f 必須是一個 Lua 的函式。回傳一個函式，每次呼叫該函式都會延續該共常式。'
coroutine.yield               =
'懸置正在呼叫的共常式的執行。'

costatus.running              =
'正在執行。'
costatus.suspended            =
'懸置或是還沒有開始執行。'
costatus.normal               =
'是活動的，但並不在執行。'
costatus.dead                 =
'執行完主體函式或因錯誤停止。'

debug                       =
''
debug.debug               =
'進入一個使用者互動模式，執行使用者輸入的每個字串。'
debug.getfenv             =
'回傳物件 `o` 的環境。'
debug.gethook             =
'回傳三個表示執行緒攔截設定的值：目前攔截函式，目前攔截遮罩，目前攔截計數。'
debug.getinfo             =
'回傳關於一個函式資訊的表。'
debug.getlocal['<5.1']    =
'回傳在堆疊的 `level` 層處函式的索引為 `index` 的區域變數的名字和值。'
debug.getlocal['>5.2']    =
'回傳在堆疊的 `f` 層處函式的索引為 `index` 的區域變數的名字和值。'
debug.getmetatable        =
'回傳給定 `value` 的中繼資料表。'
debug.getregistry         =
'回傳註冊表。'
debug.getupvalue          =
'回傳函式 `f` 的第 `up` 個上值的名字和值。'
debug.getuservalue['<5.3']=
'回傳關聯在 `u` 上的 `Lua` 值。'
debug.getuservalue['>5.4']=
'回傳關聯在 `u` 上的第 `n` 個 `Lua` 值，以及一個布林， `false` 表示值不存在。'
debug.setcstacklimit      =
[[
### **已在 `Lua 5.4.2` 中棄用**

設定新的C堆疊限制。該限制控制Lua中巢狀呼叫的深度，以避免堆疊溢出。

如果設定成功，該函式回傳之前的限制；否則回傳`false`。
]]
debug.setfenv             =
'將 `table` 設定為 `object` 的環境。'
debug.sethook             =
'將一個函式設定為攔截函式。'
debug.setlocal            =
'將 `value` 賦給 堆疊上第 `level` 層函式的第 `local` 個區域變數。'
debug.setmetatable        =
'將 `value` 的中繼資料表設為 `table` （可以是 `nil` ）。'
debug.setupvalue          =
'將 `value` 設為函式 `f` 的第 `up` 個上值。'
debug.setuservalue['<5.3']=
'將 `value` 設為 `udata` 的關聯值。'
debug.setuservalue['>5.4']=
'將 `value` 設為 `udata` 的第 `n` 個關聯值。'
debug.traceback           =
'回傳呼叫堆疊的堆疊回溯資訊。字串可選項 `message` 被添加在堆疊回溯資訊的開頭。'
debug.upvalueid           =
'回傳指定函式第 `n` 個上值的唯一識別字（一個輕量使用者資料）。'
debug.upvaluejoin         =
'讓 Lua 閉包 `f1` 的第 `n1` 個上值 引用 `Lua` 閉包 `f2` 的第 `n2` 個上值。'

infowhat.n                =
'`name` 和 `namewhat`'
infowhat.S                =
'`source` 、 `short_src` 、 `linedefined` 、 `lalinedefined` 和 `what`'
infowhat.l                =
'`currentline`'
infowhat.t                =
'`istailcall`'
infowhat.u['<5.1']        =
'`nups`'
infowhat.u['>5.2']        =
'`nups` 、 `nparams` 和 `isvararg`'
infowhat.f                =
'`func`'
infowhat.r                =
'`ftransfer` 和 `ntransfer`'
infowhat.L                =
'`activelines`'

hookmask.c                =
'每當 Lua 呼叫一個函式時，呼叫攔截。'
hookmask.r                =
'每當 Lua 從一個函式內回傳時，呼叫攔截。'
hookmask.l                =
'每當 Lua 進入新的一行時，呼叫攔截。'

file                        =
''
file[':close']              =
'關閉 `file`。'
file[':flush']              =
'將寫入的資料儲存到 `file` 中。'
file[':lines']              =
[[
------
```lua
for c in file:lines(...) do
    body
end
```
]]
file[':read']                =
'讀取檔案 `file` ，指定的格式決定了要讀取什麼。'
file[':seek']                =
'設定及獲取基於檔案開頭處計算出的位置。'
file[':setvbuf']             =
'設定輸出檔案的緩衝模式。'
file[':write']               =
'將引數的值逐個寫入 `file` 。'

readmode.n                  =
'讀取一個數字，根據 Lua 的轉換文法回傳浮點數或整數。'
readmode.a                  =
'從目前位置開始讀取整個檔案。'
readmode.l                  =
'讀取一行並忽略行尾標記。'
readmode.L                  =
'讀取一行並保留行尾標記。'

seekwhence.set              =
'基點為 0 （檔案開頭）。'
seekwhence.cur              =
'基點為目前位置。'
seekwhence['.end']          =
'基點為檔案尾。'

vbuf.no                     =
'不緩衝；輸出操作立刻生效。'
vbuf.full                   =
'完全緩衝；只有在快取滿或呼叫 flush 時才做輸出操作。'
vbuf.line                   =
'行緩衝；輸出將緩衝到每次換行前。'

io                          =
''
io.stdin                    =
'標準輸入。'
io.stdout                   =
'標準輸出。'
io.stderr                   =
'標準錯誤。'
io.close                    =
'關閉 `file` 或預設輸出檔案。'
io.flush                    =
'將寫入的資料儲存到預設輸出檔案中。'
io.input                    =
'設定 `file` 為預設輸入檔案。'
io.lines                    =
[[
------
```lua
for c in io.lines(filename, ...) do
    body
end
```
]]
io.open                    =
'用字串 `mode` 指定的模式打開一個檔案。'
io.output                  =
'設定 `file` 為預設輸出檔案。'
io.popen                   =
'用一個分離處理程序開啟程式 `prog` 。'
io.read                    =
'讀取檔案 `file` ，指定的格式決定了要讀取什麼。'
io.tmpfile                 =
'如果成功，回傳一個臨時檔案的控制代碼。'
io.type                    =
'檢查 `obj` 是否是合法的檔案控制代碼。'
io.write                   =
'將引數的值逐個寫入預設輸出檔案。'

openmode.r                 =
'讀取模式。'
openmode.w                 =
'寫入模式。'
openmode.a                 =
'追加模式。'
openmode['.r+']            =
'更新模式，所有之前的資料都保留。'
openmode['.w+']            =
'更新模式，所有之前的資料都刪除。'
openmode['.a+']            =
'追加更新模式，所有之前的資料都保留，只允許在檔案尾部做寫入。'
openmode.rb                =
'讀取模式。（二進制方式）'
openmode.wb                =
'寫入模式。（二進制方式）'
openmode.ab                =
'追加模式。（二進制方式）'
openmode['.r+b']           =
'更新模式，所有之前的資料都保留。（二進制方式）'
openmode['.w+b']           =
'更新模式，所有之前的資料都刪除。（二進制方式）'
openmode['.a+b']           =
'追加更新模式，所有之前的資料都保留，只允許在檔案尾部做寫入。（二進制方式）'

popenmode.r                =
'從這個程式中讀取資料。（二進制方式）'
popenmode.w                =
'向這個程式寫入輸入。（二進制方式）'

filetype.file              =
'是一個打開的檔案控制代碼。'
filetype['.closed file']   =
'是一個關閉的檔案控制代碼。'
filetype['.nil']           =
'不是檔案控制代碼。'

math                        =
''
math.abs                    =
'回傳 `x` 的絕對值。'
math.acos                   =
'回傳 `x` 的反餘弦值（用弧度表示）。'
math.asin                   =
'回傳 `x` 的反正弦值（用弧度表示）。'
math.atan['<5.2']           =
'回傳 `x` 的反正切值（用弧度表示）。'
math.atan['>5.3']           =
'回傳 `y/x` 的反正切值（用弧度表示）。'
math.atan2                  =
'回傳 `y/x` 的反正切值（用弧度表示）。'
math.ceil                   =
'回傳不小於 `x` 的最小整數值。'
math.cos                    =
'回傳 `x` 的餘弦（假定引數是弧度）。'
math.cosh                   =
'回傳 `x` 的雙曲餘弦（假定引數是弧度）。'
math.deg                    =
'將角 `x` 從弧度轉換為角度。'
math.exp                    =
'回傳 `e^x` 的值（e 為自然對數的底）。'
math.floor                  =
'回傳不大於 `x` 的最大整數值。'
math.fmod                   =
'回傳 `x` 除以 `y`，將商向零捨入後的餘數。'
math.frexp                  =
'將 `x` 分解為尾數與指數，回傳值符合 `x = m * (2 ^ e)` 。`e` 是一個整數，`m` 是 [0.5, 1) 之間的規格化小數 (`x` 為0時 `m` 為0)。'
math.huge                   =
'一個比任何數字值都大的浮點數。'
math.ldexp                  =
'回傳 `m * (2 ^ e)` 。'
math.log['<5.1']            =
'回傳 `x` 的自然對數。'
math.log['>5.2']            =
'回以指定底的 `x` 的對數。'
math.log10                  =
'回傳 `x` 的以10為底的對數。'
math.max                    =
'回傳引數中最大的值，大小由 Lua 運算子 `<` 決定。'
math.maxinteger['>5.3']     =
'最大值的整數。'
math.min                    =
'回傳引數中最小的值，大小由 Lua 運算子 `<` 決定。'
math.mininteger['>5.3']     =
'最小值的整數。'
math.modf                   =
'回傳 `x` 的整數部分和小數部分。'
math.pi                     =
'*π* 的值。'
math.pow                    =
'回傳 `x ^ y` 。'
math.rad                    =
'將角 `x` 從角度轉換為弧度。'
math.random                 =
[[
* `math.random()` ：回傳 [0,1) 區間內均勻分佈的浮點偽隨機數。
* `math.random(n)` ：回傳 [1, n] 區間內均勻分佈的整數偽隨機數。
* `math.random(m, n)` ：回傳 [m, n] 區間內均勻分佈的整數偽隨機數。
]]
math.randomseed['<5.3']     =
'把 `x` 設為偽隨機數發生器的“種子”： 相同的種子產生相同的隨機數列。'
math.randomseed['>5.4']     =
[[
* `math.randomseed(x, y)` ：將 `x` 與 `y` 連接為128位的種子來重新初始化偽隨機產生器。
* `math.randomseed(x)` ：等同於 `math.randomseed(x, 0)` 。
* `math.randomseed()` ：產生一個較弱的隨機種子。
]]
math.sin                    =
'回傳 `x` 的正弦值（假定引數是弧度）。'
math.sinh                   =
'回傳 `x` 的雙曲正弦值（假定引數是弧度）。'
math.sqrt                   =
'回傳 `x` 的平方根。'
math.tan                    =
'回傳 `x` 的正切值（假定引數是弧度）。'
math.tanh                   =
'回傳 `x` 的雙曲正切值（假定引數是弧度）。'
math.tointeger['>5.3']      =
'如果 `x` 可以轉換為一個整數，回傳該整數。'
math.type['>5.3']           =
'如果 `x` 是整數，回傳 `"integer"` ，如果它是浮點數，回傳 `"float"` ，如果 `x` 不是數字，回傳 `nil` 。'
math.ult['>5.3']            =
'整數 `m` 和 `n` 以無符號整數形式比較，如果 `m` 在 `n` 之下則回傳布林真，否則回傳假。'

os                          =
''
os.clock                    =
'回傳程式使用的 CPU 時間的近似值，單位為秒。'
os.date                     =
'回傳一個包含日期及時刻的字串或表。格式化方法取決於所給字串 `format` 。'
os.difftime                 =
'回傳以秒計算的時刻 `t1` 到 `t2` 的差值。'
os.execute                  =
'呼叫作業系統殼層執行 `command` 。'
os.exit['<5.1']             =
'呼叫 C 函式 `exit` 終止宿主程式。'
os.exit['>5.2']             =
'呼叫 ISO C 函式 `exit` 終止宿主程式。'
os.getenv                   =
'回傳處理程序環境變數 `varname` 的值。'
os.remove                   =
'刪除指定名字的檔案。'
os.rename                   =
'將名字為 `oldname` 的檔案或目錄更名為 `newname`。'
os.setlocale                =
'設定程式的目前區域。'
os.time                     =
'當不傳引數時，回傳目前時刻。如果傳入一張表，就回傳由這張表表示的時刻。'
os.tmpname                  =
'回傳一個可用於臨時檔案的檔名字串。'

osdate.year                 =
'四位數字'
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
'星期幾，範圍為1-7，星期天為 1'
osdate.yday                 =
'該年的第幾天，範圍為1-366'
osdate.isdst                =
'是否為夏令時間，一個布林值'

package                     =
''

require['<5.3']             =
'載入一個模組，回傳該模組的回傳值（ `nil` 時為 `true` ）。'
require['>5.4']             =
'載入一個模組，回傳該模組的回傳值（ `nil` 時為 `true` ）與搜尋器回傳的載入資料。預設搜尋器的載入資料指示了載入位置，對於檔案來説就是檔案路徑。'

package.config              =
'一個描述一些為包管理準備的編譯時期組態的字串。'
package.cpath               =
'這個路徑被 `require` 在 C 載入器中做搜尋時用到。'
package.loaded              =
'用於 `require` 控制哪些模組已經被載入的表。'
package.loaders             =
'用於 `require` 控制如何載入模組的表。'
package.loadlib             =
'讓宿主程式動態連結 C 庫 `libname` 。'
package.path                =
'這個路徑被 `require` 在 Lua 載入器中做搜尋時用到。'
package.preload             =
'儲存有一些特殊模組的載入器。'
package.searchers           =
'用於 `require` 控制如何載入模組的表。'
package.searchpath          =
'在指定 `path` 中搜尋指定的 `name` 。'
package.seeall              =
'給 `module` 設定一個中繼資料表，該中繼資料表的 `__index` 域為全域環境，這樣模組便會繼承全域環境的值。可作為 `module` 函式的選項。'

string                      =
''
string.byte                 =
'回傳字元 `s[i]` 、 `s[i+1]` ... `s[j]` 的內部數字編碼。'
string.char                 =
'接收零或更多的整數，回傳和引數數量相同長度的字串。其中每個字元的內部編碼值等於對應的引數值。'
string.dump                 =
'回傳包含有以二進制方式表示的（一個 *二進制程式碼區塊* ）指定函式的字串。'
string.find                 =
'尋找第一個字串中配對到的 `pattern`（參見 §6.4.1）。'
string.format               =
'回傳不定數量引數的格式化版本，格式化字串為第一個引數。'
string.gmatch               =
[[
回傳一個疊代器函式。每次呼叫這個函式都會繼續以 `pattern` （參見　§6.4.1）對 s 做配對，並回傳所有捕獲到的值。

下面這個例子會循環疊代字串 s 中所有的單詞， 並逐行列印：
```lua
    s =
"hello world from Lua"
    for w in string.gmatch(s, "%a+") do
        print(w)
    end
```
]]
string.gsub                 =
'將字串 s 中，所有的（或是在 n 給出時的前 n 個） `pattern` （參見 §6.4.1）都替換成 `repl` ，並回傳其副本。'
string.len                  =
'回傳其長度。'
string.lower                =
'將其中的大寫字元都轉為小寫後回傳其副本。'
string.match                =
'在字串 s 中找到第一個能用 `pattern` （參見 §6.4.1）配對到的部分。如果能找到，回傳其中的捕獲物，否則回傳 `nil` 。'
string.pack                 =
'回傳一個壓縮了（即以二進制形式序列化） v1, v2 等值的二進制字串。字串 `fmt` 為壓縮格式（參見 §6.4.2）。'
string.packsize             =
[[回傳以指定格式用 $string.pack 壓縮的字串的長度。格式化字串中不可以有變長選項 's' 或 'z' （參見 §6.4.2）。]]
string.rep['>5.2']          =
'回傳 `n` 個字串 `s` 以字串 `sep` 為分割符連在一起的字串。預設的 `sep` 值為空字串（即沒有分割符）。如果 `n` 不是正數則回傳空字串。'
string.rep['<5.1']          =
'回傳 `n` 個字串 `s` 連在一起的字串。如果 `n` 不是正數則回傳空字串。'
string.reverse              =
'回傳字串 s 的反轉字串。'
string.sub                  =
'回傳一個從 `i` 開始並在 `j` 結束的子字串。'
string.unpack               =
'回傳以格式 `fmt` （參見 §6.4.2） 壓縮在字串 `s` （參見 $string.pack） 中的值。'
string.upper                =
'接收一個字串，將其中的小寫字元都轉為大寫後回傳其副本。'

table                       =
''
table.concat                =
'提供一個列表，其所有元素都是字串或數字，回傳字串 `list[i]..sep..list[i+1] ··· sep..list[j]`。'
table.insert                =
'在 `list` 的位置 `pos` 處插入元素 `value`。'
table.maxn                  =
'回傳給定表的最大正數索引，如果表沒有正數索引，則回傳零。'
table.move                  =
[[
將元素從表 `a1` 移到表 `a2`。
```lua
a2[t],··· =
a1[f],···,a1[e]
return a2
```
]]
table.pack                  =
'回傳用所有引數以鍵 `1`,`2`, 等填充的新表，並將 `"n"` 這個域設為引數的總數。'
table.remove                =
'移除 `list` 中 `pos` 位置上的元素，並回傳這個被移除的值。'
table.sort                  =
'在表內從 `list[1]` 到 `list[#list]` *原地* 對其間元素按指定順序排序。'
table.unpack                =
[[
回傳列表中的元素。這個函式等價於
```lua
    return list[i], list[i+1], ···, list[j]
```
i 預設為 1 ， j 預設為 #list。
]]
table.foreach               =
'走訪表中的每一個元素，並以key和value執行回呼函式。如果回呼函式回傳一個非nil值則循環終止，並且回傳這個值。該函式等同pair(list)，比pair(list)更慢。不推薦使用。'
table.foreachi              =
'走訪表中的每一個元素，並以索引號index和value執行回呼函式。如果回呼函式回傳一個非nil值則循環終止，並且回傳這個值。該函式等同ipair(list)，比ipair(list)更慢。不推薦使用。'
table.getn                  =
'回傳表的長度。該函式等價於#list。'
table.new                   =
[[這將建立一個預先確定大小的表，就像和 C API 等價的 `lua_createtable()` 一樣。如果已確定最終表的大小，而且自動更改大小很耗效能的話，這對大表很有用。 `narray` 參數指定像陣列般元素的數量，而 `nhash` 參數指定像雜湊般元素的數量。使用這個函式前需要先 require。
```lua
    require("table.new")
```
]]
table.clear                 =
[[這會清除表中的所有的鍵值對，但保留分配的陣列或雜湊大小。當需要清除從多個位置連結的表，或回收表以供同一上下文使用時很有用。這避免了管理反向連結，節省了分配和增加陣列/雜湊部分而增長的開銷。使用這個函式前需要先 require。
```lua
    require("table.clear")
```
請注意，此函式適用於非常特殊的情況。在大多數情況下，最好用新表替換（通常是單個）連結，並讓垃圾回收自行處理。
]]

utf8                        =
''
utf8.char                   =
'接收零或多個整數，將每個整數轉換成對應的 UTF-8 位元組序列，並回傳這些序列連接到一起的字串。'
utf8.charpattern            =
'用於精確配對到一個 UTF-8 位元組序列的模式，它假定處理的對象是一個合法的 UTF-8 字串。'
utf8.codes                  =
[[
回傳一系列的值，可以讓
```lua
for p, c in utf8.codes(s) do
    body
end
```
疊代出字串 `s` 中所有的字元。這裡的 `p` 是位置（按位元組數）而 `c` 是每個字元的編號。如果處理到一個不合法的位元組序列，將擲回一個錯誤。
]]
utf8.codepoint              =
'以整數形式回傳 `s` 中 從位置 `i` 到 `j` 間（包括兩端）所有字元的編號。'
utf8.len                    =
'回傳字串 `s` 中 從位置 `i` 到 `j` 間 （包括兩端） UTF-8 字元的個數。'
utf8.offset                 =
'回傳編碼在 `s` 中的第 `n` 個字元的開始位置（按位元組數）（從位置 `i` 處開始統計）。'
