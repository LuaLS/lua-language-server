---@diagnostic disable: undefined-global, lowercase-global

arg                 =
'LUAスタンドアローンに渡す引数'

assert              =
'引数 v が偽（i.e., `nil` または `false`）の場合、エラーを発生させる。それ以外の場合は、すべての引数を返えす。エラーが発生した際、`message` がエラーオブジェクトになる。`message` が指定されていない場合、デフォルトでエラーオブジェクトが `"assertion failed!"` になる。'

cgopt.collect       =
'完全なガベージコレクションサイクルを実行する。'
cgopt.stop          =
'自動実行を停止する。'
cgopt.restart       =
'自動実行を再開する。'
cgopt.count         =
'利用されているメモリ量の合計をキロバイト単位で返す。'
cgopt.step          =
'ガベージコレクションのステップを実行する。'
cgopt.setpause      =
'`pause` の値を設定する。'
cgopt.setstepmul    =
'`step multiplier` の値を設定する。'
cgopt.incremental   =
'ガベージコレクションのモードをインクリメンタルに変更する。'
cgopt.generational  =
'ガベージコレクションのモードを世代別に変更する。'
cgopt.isrunning     =
'ガベージコレクションが実行中かどうかを返す。'

collectgarbage      =
'この関数はガベージコレクション機能への汎用的なインターフェース。第一引数 `opt` に応じて異なる操作を実行する。'

dofile              =
'指定されたファイルを開き、その内容をLuaチャンクとして実行する。引数が指定されなかった場合、標準入力（`stdin`）の内容を実行する。チャンクによって返されたすべての値を返す。エラーが発生した場合、そのエラーが呼び出し元まで伝播される（つまり、`dofile` は保護モードでは実行されない）。'

error               =
[[
最後に実行された保護関数を終了させ、`message` をエラーオブジェクトとして返す。

一般的には、`message` が文字列だった場合にエラーの発生位置に関する情報がその先端に追加される。
]]

_G                  =
'グローバル環境を保持するグローバル変数（関数ではない）。Lua自体がこの変数を使用しないため、その値を変更しても環境には影響しないし、その逆も同様である。より詳細な説明には§2.2を参照。'

getfenv             =
'関数 `f` が現在使用している環境を返す。`f` はLua関数、またはスタックレベルを指定する数字である。'

getmetatable        =
'`object` にメタテーブルがない場合、nil を返す。メタテーブルがありそこに "__metatable" フィールドがある場合、その値を返す。 それ以外の場合、メタテーブル自身を返す。' -- TODO

ipairs              =
[[
三つの値（イテレータ関数、テーブル `t` 、そして `0`）を返す。三つの値は次の構文
```lua
    for i,v in ipairs(t) do body end
```
において `i,v` が `(1,t[1]), (2,t[2]), ...`　となるように設定される。
]]

loadmode.b          =
'バイナリチャンクのみ。'
loadmode.t          =
'テキストチャンクのみ。'
loadmode.bt         =
'バイナリとテキストの両方。'

load['<5.1']        =
'`func` を繰り返して呼び出すことによってチャンクを取得し、それをロードする。`func` は文字列を返す必要があり、それらの結果を結合したものがチャンクの値となる。'
load['>5.2']        =
[[
チャンクをロードする。

`chunk`が文字列の場合、チャンクがその文字列となる。`chunk` が関数の場合、その関数を繰り返して呼び出した結果ががチャンクの値となる。`chunk` への各呼び出しは以前の結果と結合される文字列か、反復の終了を指す空の文字列、nil、または空の値を返す必要がある。
]]

loadfile            =
'ファイル`filename` を一つのチャンクとしてロードする。`filename` が指定されていない場合、標準入力からチャンクをロードする。'

loadstring          =
'指定された文字列からチャンクをロードする。'

module              =
'モジュールを作成する。'

next                =
[[
テーブル内のすべてのフィールドを走査するための関数。
走査対象のテーブルと現在の走査位置を示すキーをを引数に取り、次のキーとそれに関連されている値を返す。次のキーがない場合には `nil` を返す。走査位置が `nil` の場合、テーブルの最初のキーとその値を返す。

`next`の走査順は不定。数値をキーとして持つテーブルを数値順で走査したい場合には `for` をご利用ください。

走査中に存在しないフィールドに値を設定した場合、`next` の動作は未定義。ただし、既存のフィールドを変更することは可能。特に、既存のフィールドを `nil` に設定することも可能。
]]

pairs               =
[[
テーブル `t` に `__pairs` のメタメソッドがある場合、それを `t` で呼び出された場合の戻り値を返す。
それ以外の場合、三つの値（イテレータ関数、テーブル `t` 、そして `nil`）を返す。三つの値は次の構文
```lua
    for k,v in pairs(t) do body end
```
において `k,v` が `t` 内のそれぞれのキーと値となるように設定される。

走査中にテーブルを変更するリスクについては、$next の説明を参照。
]]

pcall               =
[[
'保護モードで関数 `f` を指定された引数で呼び出す。
保護モードでは、実行中に発生したエラーがキャッチされ、状態コードとして返される。
`pcall`の最初の戻り値は状態コードを表すブール値。エラーなく関数の実行に成功した場合、状態コードは `true` でその後にすべての呼び出し結果を返す。エラーが発生した場合、状態コードは `false` でその後にエラーオブジェクトが返戻される。
]]

print               =
[[
任意数の引数を受け取り、それらを文字列に変換した後 `stdout` に出力する。文字列への変換は $tostring と同様な手順で行われる。
デバッグなどに置ける簡易的な値の確認を主な用途としているため、引数のフォーマッティングは指定できない。出力文字列のより細かな制御を行いたい場合には $string.format か $io.write をご利用ください。
]]

rawequal            =
'`v1` が `v2` と等しいかどうかを確認する。メタメソッド `__eq` が定義されていても、それを無視する。'

rawget              =
'`table[index]` の値を取得する。メタメソッド `__index` が定義されていても、それを無視する。'

rawlen              =
'オブジェクト `v` の長さを取得する。メタメソッド `__len` が定義されていても、それを無視する。'

rawset              =
[[
`table[index]` を `value` に設定し、`table` を返す。メタメソッド `__newindex` が定義されていても、それを無視する。
`table`はテーブル型、`index` は `nil` と `NaN` 以外の値である必要がある。
]]

select              =
[[
`index` が数字の場合、`select` に指定された `index` 番目以降の引数すべて返す。`index` が負の数値の場合には、最後の引数から数えられる（例えば、`-1` は最後の引数を指す）。
それ以外の場合、`index` は文字列 `"#"` である必要があり、`index` 以降の全引数の数を返す。
]]

setfenv             =
'指定された関数に使用される環境を設定する。'

setmetatable        =
[[
指定されたテーブルのメタテーブルを設定し、テーブルを返す。`metatable` が `nil` の場合、指定されたテーブルのメタテーブルを除去する。元のメタテーブルに `__metatable` フィールドがある場合、エラーを発生させる。

テーブル以外のオブジェクトのメタテーブルを変更するには、`debug` ライブラリを利用する必要がある (§6.10)。
]]

tonumber            =
[[
`base`が指定されていない場合、引数を数値に変換しようとする。引数がすでに数値か、数値に変換可能な文字列であれば、その数値を返す。それ以外の場合は `fail` を返す。

文字列からの変換の際、結果は整数、または浮動小数点数になる可能性がある（§3.1参照）。変換前の文字列は先頭と末尾にスペースや、符号を含むことができる。
]]

tostring            =
[[
任意の値を可読な文字列に変換する。

`v` のメタテーブルに `__tostring` フィールドがある場合、そのフィールドに格納されている関数を引数 `v` で呼び出し、その結果を返す。それ以外の場合、`v` のメタテーブルに `__name` というフィールドがあり、そのフィールドに文字列が格納されている場合、その文字列が結果に利用される可能性がある。

数値の変換を制御するには、$string.format を使用する。
]]

type                =
[[
引数の型を文字列として返す。可能な戻り値は`"nil"`, `"number"`, `"string"`, `"boolean"`, `"table"`, `"function"`, `"thread"`, と `"userdata"`.
]]

_VERSION            =
'実行中のLuaバージョンを表す文字列を保持するグローバル変数（関数ではない）。'

warn                =
'警告を発する。警告のメッセージは `warn` 関数に渡されたすべての引数を結合した文字列。`warn` に渡されるすべての引数が文字列である必要がある。'

xpcall['=5.1']      =
'新規メッセージハンドラ `err` を設定した上で、関数 `f` を指定された引数で保護モードで実行する。'
xpcall['>5.2']      =
'新規メッセージハンドラ `msgh` を設定した上で、関数 `f` を指定された引数で保護モードで実行する。'

unpack              =
[[
`list`の各要素を返す。この関数は下記文と同等に機能する。
```lua
    return list[i], list[i+1], ···, list[j]
```
]]

bit32               =
''
bit32.arshift       =
[[
数値 `x` を `disp` ビットだけ右にシフトした値を返す。`disp` が負の場合、左にシフトする。

シフト操作中、左に空いたビットは `x` の最上位ビットのコピーで埋められ、右に空いたビットはゼロで埋められるライブラリ (arithmetic shift)。
]]
bit32.band          =
'オペランドのビット単位ANDを返す。'
bit32.bnot          =
[[
`x`のビット単位NOTを返す。

```lua
assert(bit32.bnot(x) ==
(-1 - x) % 2^32)
```
]]
bit32.bor           =
'オペランドのビット単位ORを返す。'
bit32.btest         =
'オペランドのビット単位ANDがゼロと異なるかどうかのブール値を返す。'
bit32.bxor          =
'オペランドのビット単位XORを返す。'
bit32.extract       =
'数値 `n` のビット `field` から`field + width - 1`を符号なし整数として返す。'
bit32.replace       =
'数値 `n` のビット `field` から `field + width - 1` を `v` で置き換えた数値を返す。'
bit32.lrotate       =
'数値 `x` を `disp` ビットだけ左に回転した値を返す。`disp` が負の場合、右に回転する。'
bit32.lshift        =
[[
数値 `x` を `disp` ビットだけ左にシフトした値を返す。`disp` が負の場合、右にシフトする。シフトの方向に関わらず、空いたビットはゼロで埋められる。

```lua
assert(bit32.lshift(b, disp) ==
(b * 2^disp) % 2^32)
```
]]
bit32.rrotate       =
'数値 `x` を `disp` ビットだけ右に回転した値を返す。`disp` が負の場合、左に回転する。'
bit32.rshift        =
[[
数値 `x` を `disp` ビットだけ右にシフトした値を返す。`disp` が負の場合、左にシフトする。シフトの方向に関わらず、空いたビットはゼロで埋められる。

```lua
assert(bit32.rshift(b, disp) ==
math.floor(b % 2^32 / 2^disp))
```
]]

coroutine                   =
''
coroutine.create            =
'`f` をボディに持つ新しいコルーチンを作成し、それを返す。`f` は関数である必要がある。返されるオブジェクトの型は "thread" である。'
coroutine.isyieldable       =
'実行中のコルーチンがyieldできるかどうかを返す。'
coroutine.isyieldable['>5.4']=
'コルーチン `co` がyieldできるかどうかを返す。`co` が指定されていない場合、実行中のコルーチンに対して評価する。'
coroutine.close             =
'コルーチン `co` をクローズする: 保留中の変数をすべてクローズし、`co` の状態を `dead` にする。'
coroutine.resume            =
'コルーチン `co` の実行を開始、あるいは再開する。'
coroutine.running           =
'実行中のコルーチンと、実行中のコルーチンがメインのコルーチンであるかどうかのブール値を返す。'
coroutine.status            =
'コルーチン `co` の状況を表す文字列を返す。'
coroutine.wrap              =
'`f` をボディに持つ新しいコルーチンを作成し、呼び出される度にそのコルーチンを再開する関数を返す。`f` は関数である必要がある。'
coroutine.yield             =
'実行中のコルーチンを一時停止する。'

costatus.running            =
'実行中。'
costatus.suspended          =
'一時停止、または開始されていない。'
costatus.normal             =
'有効かされているが、実行されていない。'
costatus.dead               =
'実行が終了したか、エラーによって中断された。'

debug                       =
''
debug.debug                 =
'ユーザー入力を順次に実行するインタラクティブモードに入る。contを入力するとインタラクティブモードの実行が中断される。'
debug.getfenv               =
'オブジェクト `o` の環境を返す。'
debug.gethook               =
'スレッドの現在のフック設定を返す。現在のフック関数、現在のフックマスク、現在のフックカウントの3つの値が返される。'
debug.getinfo               =
'関数に関する情報を持つテーブルを返す。'
debug.getlocal['<5.1']      =
'スタックのレベル `level` にある関数のインデックスが `local` のローカル変数に対して、その名前と値を返す。'
debug.getlocal['>5.2']      =
'スタックのレベル `f` にある関数のインデックスが `local` のローカル変数に対して、その名前と値を返す。'
debug.getmetatable          =
'指定された値のメタテーブルを返す。'
debug.getregistry           =
'レジストリテーブルを返す。'
debug.getupvalue            =
'関数 `f` のインデックスが `up` のアップバリューに対して、その名前と値を返す。'
debug.getuservalue['<5.3']  =
'`u` に関連付けられた値を返す。'
debug.getuservalue['>5.4']  =
'ユーザデータ `u` に関連付けられた第 `n` のユーザ値と、ユーザデータがその値を持っているかどうかのブール値を返す。'
debug.setcstacklimit        =
[[
### **Deprecated in `Lua 5.4.2`**

Cスタックの新しい閾値を設定し、古い閾値を返す。設定にしっばいした場合、`false` を返す。
閾値を設定することでLuaにおける呼び出し深さを制限し、スタックオーバーフローを防ぐことができる。
]]
debug.setfenv               =
'指定された `object` の環境を `table` に設定する。'
debug.sethook               =
'指定された関数をフックとして設定する。'
debug.setlocal              =
'スタックレベル `level` にある関数のインデックス `local` にあるローカル変数に `value` を割り当てる。'
debug.setmetatable          =
'指定された値のメタテーブルを `table` に設定する（`table` は `nil` であってもよい）。'
debug.setupvalue            =
'インデックス `up` のアップバリューに `value` を割り当てる。'
debug.setuservalue['<5.3']  =
'`value` を `udata` に関連付けられた値として設定する。'
debug.setuservalue['>5.4']  =
'`value` を `udata` の第 `n` の関連値として設定する。'
debug.traceback             =
'コールスタックのトレース情報を表す文字列を返す。`message` が指定された場合、トレース情報の先頭に追加される。'
debug.upvalueid             =
'指定された関数の第 `n` のアップバリューを一意的に特定できる軽量ユーザデータを返す。'
debug.upvaluejoin           =
'クロージャ `f1` の第 `n1` アップバリューを、クロージャ `f2` の第 `n2` アップバリューの参照に置き換える。'

infowhat.n                  =
'`name` と `namewhat`'
infowhat.S                  =
'`source`, `short_src`, `linedefined`, `lastlinedefined`, と `what` '
infowhat.l                  =
'`currentline`'
infowhat.t                  =
'`istailcall`'
infowhat.u['<5.1']          =
'`nups`'
infowhat.u['>5.2']          =
'`nups`, `nparams`, と `isvararg`'
infowhat.f                  =
'`func`'
infowhat.r                  =
'`ftransfer` と `ntransfer`'
infowhat.L                  =
'`activelines`'

hookmask.c                  =
'Lua が関数を呼び出すたびにフックを呼び出す。'
hookmask.r                  =
'Lua が関数から戻るたびにフックを呼び出す。'
hookmask.l                  =
'Lua が新しい行の実行を開始するたびにフックを呼び出す。'

file                        =
''
file[':close']              =
'ファイルをクローズする。'
file[':flush']              =
'書き込まれたデータを `file` に保存する。'
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
'指定されたフォーマットに従い `file` を読み取る。'
file[':seek']               =
'ファイルの先頭からの位置を設定、あるいは取得する。'
file[':setvbuf']            =
'出力ファイルのバッファリングモードを設定する。'
file[':write']              =
'渡された引数をすべて `file` に書き込む。'

readmode.n                  =
'数値を読み取り、Lua の変換規則に従い浮動小数点数または整数を返す。'
readmode.a                  =
'現在の位置からファイル全体を読み取る。'
readmode.l                  =
'次の行を読み取る。改行コードは出力から除外される。'
readmode.L                  =
'次の行を読み取る。改行コードは出力に含まれる。'

seekwhence.set              =
'基準点はファイル先頭。'
seekwhence.cur              =
'基準点は現在位置。'
seekwhence['.end']          =
'基準点はファイル末尾。'

vbuf.no                     =
'バッファリングせずに、直ちに出力する。'
vbuf.full                   =
'バッファがいっぱいになるか、`flush` が呼び出されるまで出力されない。'
vbuf.line                   =
'改行時に出力する。'

io                          =
''
io.stdin                    =
'標準入力'
io.stdout                   =
'標準出力'
io.stderr                   =
'標準エラー'
io.close                    =
'`file` またはデフォルトの出力ファイルをクローズする。'
io.flush                    =
'書き込まれたデータをデフォルトの出力ファイルに保存する。'
io.input                    =
'`file` をデフォルトの入力ファイルとして設定する。'
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
'`mode` で指定された形式でファイルを開く。'
io.output                   =
'`file` をデフォルトの出力ファイルとして設定する。'
io.popen                    =
'プログラム `prog` をサブプロセスとして起動する。'
io.read                     =
'指定されたフォーマットに従い `file` を読み取る。'
io.tmpfile                  =
'成功した場合、新規のテンポラリファイルへのハンドルを返す。'
io.type                     =
'`obj` が有効なファイルハンドルであるかどうかを確認する。'
io.write                    =
'渡された引数をすべてデフォルトの出力ファイルに書き込む。'

openmode.r                  =
'読み取りモード。'
openmode.w                  =
'書き込みモード。'
openmode.a                  =
'追加モード。'
openmode['.r+']             =
'読み取り更新モード。既存のデータはすべて保持され、ファイルへの書き込みも可能。'
openmode['.w+']             =
'書き込み更新モード。既存のデータはすべて削除され、ファイルからの読み取りも可能。'
openmode['.a+']             =
'追加更新モード。既存のデータはすべて保持され、ファイルの末尾でのみ書き込みが可能。'
openmode.rb                 =
'バイナリ読み取りモード。'
openmode.wb                 =
'バイナリ書き込みモード。'
openmode.ab                 =
'バイナリ追加モード。'
openmode['.r+b']            =
'バイナリ読み取り更新モード。既存のデータはすべて保持され、ファイルへの書き込みも可能。'
openmode['.w+b']            =
'バイナリ書き込み更新モード。既存のデータはすべて削除され、ファイルからの読み取りも可能。'
openmode['.a+b']            =
'バイナリ追加更新モード。既存のデータはすべて保持され、ファイルの末尾でのみ書き込みが可能。'

popenmode.r                 =
'このプログラムからデータを読み取る。（バイナリモード）'
popenmode.w                 =
'このプログラムにデータを書き込む。（バイナリモード）'

filetype.file               =
'開いているファイルへのハンドル。'
filetype['.closed file']    =
'クローズされているファイルへのハンドル。'
filetype['.nil']            =
'ファイルハンドルではない。'

math                        =
''
math.abs                    =
'`x` の絶対値を返す。'
math.acos                   =
'`x` の逆余弦をラジアン単位で返す。'
math.asin                   =
'`x` の逆正弦をラジアン単位で返す。'
math.atan['<5.2']           =
'`x` の逆正接をラジアン単位で返す。'
math.atan['>5.3']           =
'`y/x`の逆正接をラジアン単位で返す。'
math.atan2                  =
'`y/x`の逆正接をラジアン単位で返す。'
math.ceil                   =
'`x` 以上の最小の整数値を返す。'
math.cos                    =
'`x` の余弦を返す。`x` はラジアン単位である必要がある。'
math.cosh                   =
'`x` の双曲線余弦を返す。`x` はラジアン単位である必要がある。'
math.deg                    =
'角度 `x` をラジアンから度に変換する。'
math.exp                    =
'`e^x`の値を返す（e は自然対数の底）。'
math.floor                  =
'`x` 以下の最大の整数値を返す。'
math.fmod                   =
'`x` を `y` で割った余りを返す。'
math.frexp                  =
'`x` を仮数と指数に分解し、`x = m * (2 ^ e)` となるような `m` と `e` を返す。`e` は整数で、`m` の絶対値は [0.5, 1) の範囲内にある。ただし、`x` が0の場合には `m` も0となる。'
math.huge                   =
'任意の数値よりも大きい浮動小数点数。'
math.ldexp                  =
'`m * (2 ^ e)`の値を返す。'
math.log['<5.1']            =
'`x` の自然対数を返す。'
math.log['>5.2']            =
'指定された底での `x` の対数を返す。'
math.log10                  =
'10を底とした `x` の対数を返す。'
math.max                    =
'引数の中で最も大きい値を返す。比較はLuaの`<`演算子によって行われる。'
math.maxinteger['>5.3']     =
'最大整数値。'
math.min                    =
'引数の中で最も小さい値を返す。比較はLuaの`<`演算子によって行われる。'
math.mininteger['>5.3']     =
'最小整数値。'
math.modf                   =
'`x` の整数部分と小数部分を返す。'
math.pi                     =
'*π*の値。'
math.pow                    =
'`x ^ y`の値を返す。'
math.rad                    =
'角度 `x` を度からラジアンに変換する。'
math.random                 =
[[
* `math.random()`: [0,1) 区間内の浮動小数点を返す。
* `math.random(n)`: [1, n] 区間内の整数を返す。
* `math.random(m, n)`: [m, n] 区間内の整数を返す。
]]
math.randomseed['<5.3']     =
'擬似乱数生成器のシードを `x` として設定する。'
math.randomseed['>5.4']     =
[[
* `math.randomseed(x, y)`: `x` と `y` を128ビットの数値に結合し、それを乱数生成器のシードとして設定する。
* `math.randomseed(x)`: `math.randomseed(x, 0)` と同等。
* `math.randomseed()`: ある程度ランダム性のある数値を乱数生成器のシードとして設定する。
]]
math.sin                    =
'`x` の正弦を返す。`x` はラジアン単位である必要がある。'
math.sinh                   =
'`x` の双曲線正弦を返す。`x` はラジアン単位である必要がある。'
math.sqrt                   =
'`x` の平方根を返す。'
math.tan                    =
'`x` の正接を返す。`x` はラジアン単位である必要がある。'
math.tanh                   =
'`x` の双曲線正接を返す。`x` はラジアン単位である必要がある。'
math.tointeger['>5.3']      =
'`x` が整数に変換可能であれば、その整数を返す。'
math.type['>5.3']           =
'`x` が整数であれば`"integer"`、浮動小数点数であれば `"float"`、数字でなければ `nil` を返す。'
math.ult['>5.3']            =
'整数 `m` と `n` を符号なし整数として比較し、`m` が `n` より小さい場合に `true` を返す。'

os                          =
''
os.clock                    =
'プログラムが使用したCPU時間の概算値を秒単位で返す。'
os.date                     =
'指定された `format` に従い、日付と時刻を含む文字列またはテーブルを返す。'
os.difftime                 =
'`t1` と `t2` の時刻差を秒単位で返す。'
os.execute                  =
'`command` をシステムインタプリタで実行する。'
os.exit['<5.1']             =
'C言語の `exit` 関数を呼び出しホストプログラムを終了させる。'
os.exit['>5.2']             =
'ISO Cの `exit` 関数を呼び出しホストプログラムを終了させる。'
os.getenv                   =
'環境変数 `varname` の値を返す。'
os.remove                   =
'指定された名前のファイルを削除する。'
os.rename                   =
'ファイルまたはディレクトリの名前を変更する。'
os.setlocale                =
'プログラムのロケールを設定する。'
os.time                     =
'引数がない場合、現在の時刻を返す。テーブルが渡されると、そのテーブルが表す時刻を返す。'
os.tmpname                  =
'テンポラリファイルに使用できるファイル名を返す。'

osdate.year                 =
'年（4桁）'
osdate.month                =
'月（1-12）'
osdate.day                  =
'日（1-31）'
osdate.hour                 =
'時間（0-23）'
osdate.min                  =
'分（0-59）'
osdate.sec                  =
'秒（0-61）'
osdate.wday                 =
'曜日（1-7の数字で、1が日曜日）'
osdate.yday                 =
'その年の元日からの日数（1-366）'
osdate.isdst                =
'夏時間（日光節約時間）を表すブール値'

package                     =
''

require['<5.3']             =
'モジュールを読み込み、そのモジュールの戻り値を返す。ただし、モジュールの戻り値が `nil` の場合、`true` を返す。'
require['>5.4']             =
'モジュールを読み込み、そのモジュールの戻り値を返す（モジュールの戻り値が `nil` の場合、`true` を返す）。第二の戻り値として、読み込まれたモジュールの探索結果を返す （ファイルの場合にはファイルパス）。'

package.config              =
'パッケージ管理に関連したコンパイル時設定を表す文字列。'
package.cpath               =
'`require` がCローダーで検索する際に使用するパス。'
package.loaded              =
'`require` が利用するテーブルの一つ。特定のモジュールが既に読み込まれたかどうかの確認に用いられる。'
package.loaders             =
'`require` が利用するテーブルの一つ。モジュールがどのようにロードされるかを制御するのに用いられる。'
package.loadlib             =
'Cライブラリ `libname` をホストプログラムに動的リンクする。'
package.path                =
'`require` が利用する設定の一つ。Luaローダーの検索パスを表す。'
package.preload             =
'特定のモジュールの読み込みに利用されるローダーを保持するテーブル。'
package.searchers           =
'`require` が利用するテーブルの一つ。モジュールがどのようにロードされるかを制御するのに用いられる。'
package.searchpath          =
'指定された `path` から `name` を検索する。'
package.seeall              =
'指定されたモジュールのメタテーブルにグローバル環境を参照した `__index` を設定することで、モジュール内からグローバル環境の値をアクセスできるようにする。`module` 関数に渡される設定の一つ。'

string                      =
''
string.byte                 =
'文字列 `s[i]`、`s[i+1]`、...、`s[j]` の文字コードを返す。'
string.char                 =
'0個以上の整数を受け取り、それぞれを対応する文字に変換し、これらのシーケンスを連結した文字列を返す。'
string.dump                 =
'指定した関数をバイナリ形式（*バイナリコードブロック*）で表した文字列を返す。'
string.find                 =
'文字列の中から `pattern` に最初にマッチした部分を探す（§6.4.1 を参照）。マッチしたものが見つかった場合、マッチした部分の最初と最後のインデックスを返す。見つからなかった場合、`nil` を返す。'
string.format               =
'第一引数で指定されたフォーマットに沿って、可変数の引数を成形したものを返す。'
string.gmatch               =
[[
呼び出される度に文字列 `s` から `pattern` に次にマッチした部分を返すイテレータ関数を返す（§6.4.1 を参照）。

例えば、次のコードは文字列 `s` 内のすべての単語を反復処理し、各単語を一行ずつ出力する： 
```lua
    s = "hello world from Lua"
    for w in string.gmatch(s, "%a+") do
        print(w)
    end
```
]]
string.gsub                 =
'文字列 `s` の中の `pattern` にマッチした部分をすべて `repl` に置き換えた文字列を返す（§6.4.1 を参照）。`n` が指定された場合、最初にマッチした `n` 個の部分のみを置き換える。'
string.len                  =
'文字列の長さを返す。'
string.lower                =
'文字列内のすべての大文字を小文字に取り換えた文字列を返す。'
string.match                =
'文字列の中から `pattern` に最初にマッチした部分を返す（§6.4.1 を参照）。マッチしたものがない場合、`nil` を返す。'
string.pack                 =
'第一引数で指定されたフォーマットに沿って、可変数の引数をバイナリ文字列にシリアライズしたものを返す（§6.4.2 を参照）。'
string.packsize             =
'指定されたフォーマットを用いて`string.pack`によって生成された文字列の長さを返す。フォーマット文字列には可変長オプション `s` または `z` を含めることはできない（§6.4.2 を参照）。'
string.rep['>5.2']          =
'`n` 個の文字列 `s` を文字列 `sep` で区切って連結した文字列を返す。デフォルトの `sep` は空文字列。`n` が正数でない場合は空文字列を返す。'
string.rep['<5.1']          =
'`n` 個の文字列 `s` を連結した文字列を返す。`n` が正数でない場合は空文字列を返す。'
string.reverse              =
'文字列 `s` を逆順で並び変えた文字列を返す。'
string.sub                  =
'インデックス `i` で始まり、`j` まで続く部分文字列を返す。'
string.unpack               =
'フォーマット `fmt` を用いて`string.pack`によって生成された文字列の元の値を返す（§6.4.2 を参照）。'
string.upper                =
'文字列内のすべての小文字を大文字に取り換えた文字列を返す。'

table                       =
''
table.concat                =
'すべての要素が文字列または数値であるリストに対して、`list[i]..sep..list[i+1] ··· sep..list[j]` という文字列を返す。'
table.insert                =
'要素 `value` を `list` の位置 `pos` に挿入する。'
table.maxn                  =
'指定されたテーブルの最も大きな正の数値インデックスを返す。正の数値インデックスがない場合はゼロを返す。'
table.move                  =
[[
テーブル `a1` からテーブル `a2` に要素を移動する。
```lua
a2[t],··· =
a1[f],···,a1[e]
return a2
```
]]
table.pack                  =
'すべての引数をキー `1`、`2` などに格納し、引数の総数を示す `"n"` フィールドを持つテーブルを返す。'
table.remove                =
'`list` の位置 `pos` にある要素を削除し、削除された要素の値を返す。'
table.sort                  =
'リストの要素を指定された順序で*内部*ソートする。ソートは `list[1]` から `list[#list]` まで行われる。'
table.unpack                =
[[
指定されたリストの要素を返す。この関数は次と同等である（デフォルトでは `i` が `1` で `j` が `#list`）。
```lua
    return list[i], list[i+1], ···, list[j]
```
]]
table.foreach               =
[[
テーブル内の各要素に対し `f` を適用する。`f` は各要素のキーと値を引数として呼び出される。`f` が `nil` 以外の値を返すとループが終了し、その値が `foreach` の最終的な戻り値として返される。
非推薦関数のため、$pairs を優先してください。
]]
table.foreachi              =
[[
テーブル内の数値キーを持つ要素に対して `f` を適用する。`f` は各要素のキーと値を引数として呼び出される。`f` が `nil` 以外の値を返すとループが終了し、その値が `foreach` の最終的な戻り値として返される。
非推薦関数のため、$ipairs を優先してください。
]]
table.getn                  =
'テーブルの長さを返す。`#list` と同等。'
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
'0個以上の整数を受け取り、それぞれを対応するUTF-8文字に変換し、これらの文字を連結した文字列を返す。'
utf8.charpattern            =
'1つのUTF-8文字にマッチするパターンを返す。このパターンを用いる際には、対象の文字列が有効なUTF-8文字列である必要がある。'
utf8.codes                  =
[[
次の構文において`p`が各UTF-8文字のバイト位置、`c`が各UTF-8文字の文字コードとなるような値を返す。無効なバイトシーケンスが文字列に含まれた場合にはエラーを出す。
```lua
for p, c in utf8.codes(s) do
    body
end
```
]]
utf8.codepoint              =
'バイト位置 `i` から `j`（両方含む）の間に含まれるすべてのUTF-8文字コード（整数）を返す。'
utf8.len                    =
'バイト位置 `i` から `j`（両方含む）の間に含まれるUTF-8文字の数を返す。'
utf8.offset                 =
'文字列 `s` における `n` 番目の文字が始まるバイト位置をを返す。`i` が指定された場合、`i` から数えたバイト位置を返す。'
