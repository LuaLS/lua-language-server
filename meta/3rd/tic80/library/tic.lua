---@meta

---@param row number
function BDR(row) end

function BOOT() end

---@param index number
function MENU(index) end

function OVR() end

---@param row number
function SCN(row) end

function TIC() end

---@param id number
---@return boolean pressed is button pressed
function btn(id) end

---@return number gamepads_data 32-bit value that represents current state of all GAMEPAD button inputs
function btn() end

---@param id number
---@param hold? number
---@param period? number
---@return boolean pressed button is pressed now but not in previous frame
function btnp(id, hold, period) end

---@return number gamepads_data 32-bit value that represents a bitwise AND of the current and prior state of GAMEPADS data
function btnp() end

---@param x number
---@param y number
---@param radius number
---@param color number
function circ(x, y, radius, color) end

---@param x number
---@param y number
---@param radius number
---@param color number
function circb(x, y, radius, color) end

---@param x number
---@param y number
---@param width number
---@param height number
function clip(x, y, width, height) end

function clip() end

---@param color? number
function cls(color) end

---@param x number
---@param y number
---@param a number
---@param b number
---@param color number
function elli(x, y, a, b, color) end

---@param x number
---@param y number
---@param a number
---@param b number
---@param color number
function ellib(x, y, a, b, color) end

function exit() end

---@param sprite_id any
---@param flag number
---@return boolean
function fget(sprite_id, flag) end

---@param text string
---@param x number
---@param y number
---@param chromakey? number
---@param char_width? number
---@param char_height? number
---@param fixed? boolean
---@param scale? number
---@param alt? boolean
---@return number text_width the width of the rendered text in pixels
function font(text, x, y, chromakey, char_width, char_height, fixed, scale, alt) end

---@param sprite_id number
---@param flag number
---@param value boolean
function fset(sprite_id, flag, value) end

---@param code? number
---@return boolean pressed whether or not the specified key is currently pressed
function key(code) end

---@return boolean any_pressed is any key currently pressed
function key() end

---@param code? number
---@param hold? number
---@param period? number
---@return boolean pressed key is pressed now but not in previous frame
function keyp(code, hold, period) end

---@return boolean any_pressed is any key currently pressed but not in the previous frame
function keyp() end

---@param x0 number
---@param y0 number
---@param x1 number
---@param y1 number
---@param color number
function line(x0, y0, x1, y1, color) end

---@param x? number
---@param y? number
---@param w? number
---@param h? number
---@param sx? number
---@param sy? number
---@param colorkey? number
---@param scale? number
---@param remap? fun(tile:number,x:number,y:number):number
function map(x, y, w, h, sx, sy, colorkey, scale, remap) end

---@param addr number
---@param source_addr number
---@param size number
function memcpy(addr, source_addr, size) end

---@param addr number
---@param value number
---@param size number
function memset(addr, value, size) end

---@param x number
---@param y number
---@return number tile_id tile index
function mget(x, y) end

---@return number x x coordinate of the mouse pointer
---@return number y y coordinate of the mouse pointer
---@return boolean left is left button down
---@return boolean right is right button down
---@return number scroll_x x scroll delta since last frame
---@return number scroll_y y scroll delta since last frame
function mouse() end

---@param x number
---@param y number
---@param tile_id number
function mset(x, y, tile_id) end

---@param track? number
---@param frame? number
---@param row? number
---@param loop? boolean
---@param sustain? boolean
---@param tempo? number
---@param speed? number
function music(track, frame, row, loop, sustain, tempo, speed) end

---@param addr number
---@param bits? number
---@return number value
function peek(addr, bits) end

---@param addr number
---@return number value
function peek1(addr) end

---@param addr number
---@return number value
function peek2(addr) end

---@param addr number
---@return number value
function peek4(addr) end

---@param x number
---@param y number
---@param color number
function pix(x, y, color) end

---@param x number
---@param y number
---@return number color the index of the palette color at the specified coordinates
function pix(x, y) end

---@param index number
---@param value number
---@return number value 32-bit value previously saved to the specified memory slot
function pmem(index, value) end

---@param index number
---@return number value 32-bit value saved to the specified memory slot
function pmem(index) end

---@param addr number
---@param value number
---@param bits? number
function poke(addr, value, bits) end

---@param addr number
---@param value number
function poke1(addr, value) end

---@param addr number
---@param value number
function poke2(addr, value) end

---@param addr number
---@param value number
function poke4(addr, value) end

---@param text string
---@param x? number
---@param y? number
---@param color? number
---@param fixed? boolean
---@param scale? number
---@param smallfont? boolean
---@return number width the width of the text in pixels
function print(text, x, y, color, fixed, scale, smallfont) end

---@param x number
---@param y number
---@param width number
---@param height number
---@param color number
function rect(x, y, width, height, color) end

---@param x number
---@param y number
---@param width number
---@param height number
---@param color number
function rectb(x, y, width, height, color) end

function reset() end

---@param id number
---@param note? number|string
---@param duration? number
---@param channel? number
---@param volume? number
---@param speed? number
function sfx(id, note, duration, channel, volume, speed) end

---@param id number
---@param x number
---@param y number
---@param colorkey? number
---@param scale? number
---@param flip? number
---@param rotate? number
---@param width? number
---@param height? number
function spr(id, x, y, colorkey, scale, flip, rotate, width, height) end

---@param mask? number
---@param bank? number
---@param tocart? boolean
function sync(mask, bank, tocart) end

---@return number time time elapsed since the game was started in milliseconds
function time() end

---@param message string
---@param color? number
function trace(message, color) end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param x3 number
---@param y3 number
---@param color number
function tri(x1, y1, x2, y2, x3, y3, color) end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param x3 number
---@param y3 number
---@param color number
function trib(x1, y1, x2, y2, x3, y3, color) end

---@return number timestamp the current Unix timestamp in seconds
function tstamp() end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param x3 number
---@param y3 number
---@param u1 number
---@param v1 number
---@param u2 number
---@param v2 number
---@param u3 number
---@param v3 number
---@param texsrc? number
---@param chromakey? number
---@param z1? number
---@param z2? number
---@param z3? number
function ttri(x1, y1, x2, y2, x3, y3, u1, v1, u2, v2, u3, v3, texsrc, chromakey, z1, z2, z3) end

---@param bank number
function vbank(bank) end
