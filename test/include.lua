test.includeUri = ls.uri.encode(test.rootPath .. '/include.lua')

test.includeCodes = {}

test.includeCodes['setmetatable'] = [[
---@generic T: table, MT: table|nil
---@param t T
---@param mt MT
---@return T & MT['__index']
function setmetatable(t, mt) end
]]

test.includeCodes['select'] = [[
---@overload fun(index: "#", ...):integer
---@overload fun<T: any[]>(index: integer, ...T):...T
---@nodiscard
function select(...) end
]]

test.includeCodes['tableremove'] = [[
table = {}

---@generic T
---@param list T[]
---@param pos? integer
---@return T
function table.remove(list, pos) end
]]

test.includeCodes['tablemove'] = [[
table = {}

---@generic T: table
---@param a1  T
---@param f   integer
---@param e   integer
---@param t   integer
---@param a2? T
---@return T a2
function table.move(a1, f, e, t, a2) end
]]

test.includeCodes['mathmaxmin'] = [[
math = {}

---@generic Number: number
---@param x Number
---@param ... Number
---@return Number
---@nodiscard
function math.max(x, ...) end

---@generic Number: number
---@param x Number
---@param ... Number
---@return Number
---@nodiscard
function math.min(x, ...) end
]]

test.includeCodes['pcall'] = [[
---@overload fun<R: any[]>(f: async fun(...):(...R), ...any):true, ...R
---@overload fun(f: async fun(), ...any):false, string
function pcall(...) end

---@overload fun<R: any[]>(f: async fun(...):(...R), msgh: function, ...any):true, ...R
---@overload fun(f: async fun(), msgh: function, ...any):false, string
function xpcall(...) end
]]

test.includeCodes['tonumber'] = [[
---@overload fun<T: number>(e: T):T
---@overload fun(e: string, base?: integer):number?
---@nodiscard
function tonumber(e) end
]]

test.includeCodes['cowrap'] = [[
coroutine = {}

---@generic R: any[]
---@param f async fun(...):...R
---@return async fun(...):...R
---@nodiscard
function coroutine.wrap(f) end
]]

test.includeCodes['osdate'] = [[
os = {}

---@class osdate
---@field year  integer|string

---@overload fun(format: "*t", time?: integer):osdate
---@overload fun(format?: string, time?: integer):string
---@param format? string
---@param time?   integer
---@nodiscard
function os.date(format, time) end
]]

test.includeCodes['tableinsert'] = [[
table = {}

---@generic T
---@overload fun(list: T[], value: T)
---@param list T[]
---@param pos integer
---@param value T
function table.insert(list, pos, value) end
]]

test.includeCodes['tablepack'] = [[
table = {}

---@param ...T any
---@return T & { n: integer }
function table.pack(...) end
]]

test.includeCodes['tableunpack'] = [[
---@generic T: any[]
---@param list T
---@param i?   integer
---@param j?   integer
---@return ...T
function table.unpack(list, i, j) end
]]

test.includeCodes['require'] = [[
---@generic T: string
---@param modname T
---@return Module<T>
function require(modname) end
]]

test.includeCodes['assert'] = [[
---@generic T
---@param v? T
---@param message? any
---@param ... any
---@return T
---@return any ...
---@narrow v
function assert(v, message, ...) end
]]

test.includeCodes['binary'] = [[
---@alias op.add<A: any, B: any> number
---@alias op.add<A: integer, B: integer> integer
]]

test.includeCodes['unary'] = [[
---@alias op.len<A: any> integer
]]

test.includeCodes['type'] = [[
---@overload fun(x: nil): 'nil'
---@overload fun(x: boolean): 'boolean'
---@overload fun(x: number): 'number'
---@overload fun(x: string): 'string'
---@overload fun(x: table): 'table'
---@overload fun(x: function): 'function'
---@overload fun(x: thread): 'thread'
---@overload fun(x: userdata): 'userdata'
function type(...) end
]]

test.includeCodes['type2'] = [[
---@alias TypeViewMap {
---    [nil]: 'nil',
---    [boolean]: 'boolean',
---    [number]: 'number',
---    [string]: 'string',
---    [table]: 'table',
---    [function]: 'function',
---    [thread]: 'thread',
---    [userdata]: 'userdata',
---}

---@generic T
---@param obj T
---@return TypeViewMap[T]
function type(obj) end
]]

test.includeCodes['type3'] = [[
---@alias TypeViewMap {
---    [nil]: 'nil',
---    [boolean]: 'boolean',
---    [number]: 'number',
---    [string]: 'string',
---    [table]: 'table',
---    [function]: 'function',
---    [thread]: 'thread',
---    [userdata]: 'userdata',
---}

---@alias TypeView<T> TypeViewMap[T]

---@generic T
---@param obj T
---@return TypeView<T>
function type(obj) end
]]

test.includeCodes['pairs'] = [[
---@generic K, V
---@param t table<K, V>
---@return fun(t: table<K, V>, k?: K): K, V
---@return table<K, V>
---@return K?
function pairs(t) end
]]

test.includeCodes['print'] = [[
---@param ... any
function print(...) end
]]

--- 使用 `--!include setmetatable` 在测试中包含预定义代码片段。
---@param script string
---@return function?
function test.checkInclude(script)
    local buf = {}
    for include in script:gmatch('%-%-!include%s+([%w_]+)') do
        local code = test.includeCodes[include]
        assert(code, 'Include file not found: ' .. include)
        buf[#buf+1] = code
    end

    if #buf == 0 then
        return nil
    end

    local text = table.concat(buf, '\n')
    local file = ls.file.setServerText(test.includeUri, text)
    local vfile = test.scope.vm:indexFile(test.includeUri)

    return function ()
        file:remove()
        vfile:remove()
    end
end
