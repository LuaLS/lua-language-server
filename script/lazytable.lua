---@class lazytable.builder
---@field source     table
---@field codeMap    table<integer, string>
---@field dumpMark   table<table, integer>
---@field keyMap     table<integer, string|integer>
---@field keyDual    table<string|integer, integer>
---@field excludes   table<table, true>
local mt = {}
mt.__index = mt
mt.tableID = 1
mt.keyID   = 1

local DUMMY = function () end

---@param k string|integer
---@return string
function mt:formatKey(k)
    if not self.keyDual[k] then
        local id = self.keyID
        self.keyID = self.keyID + 1
        self.keyDual[k] = id
        self.keyMap[id] = k
    end
    return string.format('[%d]', self.keyDual[k])
end

---@param v string|number|boolean
function mt:formatValue(v)
    if type(v) == 'string' then
        return ('%q'):format(v)
    end
    if type(v) == 'number' then
        if math.type(v) == 'integer' then
            local n10 = ('%d'):format(v)
            local n16 = ('0x%X'):format(v)
            if #n10 <= #n16 then
                return n10
            else
                return n16
            end
        else
            local n10 = ('%.16f'):format(v):gsub('0+$', '')
            local n16 = ('%q'):format(v)
            if #n10 <= #n16 then
                return n10
            else
                return n16
            end
        end
    end
    return ('%q'):format(v)
end

---@param t table|function|userdata|thread
---@return integer
function mt:dump(t)
    if self.dumpMark[t] then
        return self.dumpMark[t]
    end
    local id = self.tableID
    self.tableID = self.tableID + 1
    self.dumpMark[t] = id
    if self.excludes[t] or type(t) ~= 'table' then
        self.excludes[t] = true
        return id
    end

    local codeBuf = {}

    local hasTable
    codeBuf[#codeBuf + 1] = 'return{{'
    local hasFields
    for k, v in pairs(t) do
        local tp = type(v)
        if tp == 'string' or tp == 'number' or tp == 'boolean' then
            if hasFields then
                codeBuf[#codeBuf + 1] = ','
            else
                hasFields = true
            end
            codeBuf[#codeBuf+1] = string.format('%s=%s'
                , self:formatKey(k)
                , self:formatValue(v)
            )
        else
            hasTable = true
        end
    end
    codeBuf[#codeBuf+1] = '},'

    codeBuf[#codeBuf+1] = string.format('%d', self:formatValue(#t))

    if hasTable then
        codeBuf[#codeBuf + 1] = ',{'
        hasFields = false
        for k, v in pairs(t) do
            local tp = type(v)
            if tp == 'table' or tp == 'function' or tp == 'thread' or tp == 'userdata' then
                if hasFields then
                    codeBuf[#codeBuf + 1] = ','
                else
                    hasFields = true
                end
                codeBuf[#codeBuf + 1] = string.format('%s=%s'
                    , self:formatKey(k)
                    , self:dump(v)
                )
            end
        end
        codeBuf[#codeBuf+1] = '}'
    end

    codeBuf[#codeBuf+1] = '}'

    self.codeMap[id] = table.concat(codeBuf)

    return id
end

---@param writter fun(id: integer, code: string): boolean
---@param reader  fun(id: integer): string?
function mt:bind(writter, reader)
    setmetatable(self.codeMap, {
        __newindex = function (t, id, code)
            local suc = writter(id, code)
            if not suc then
                rawset(t, id, code)
            end
        end,
        __index = function (_, id)
            return reader(id)
        end
    })
end

---@param t table
function mt:exclude(t)
    self.excludes[t] = true
    return self
end

---@return table
function mt:entry()
    local entryID = self:dump(self.source)

    local codeMap = self.codeMap
    local keyMap  = self.keyMap
    local keyDual = self.keyDual
    local load    = load
    local setmt   = setmetatable
    local dump    = string.dump
    local rawset  = rawset
    local sbyte   = string.byte
    ---@type table<table, integer>
    local idMap   = {}
    ---@type table<integer, table>
    local instMap = {}
    local refMap  = {}
    ---@type table<table, table[]>
    local infoMap = setmt({}, {
        __mode = 'v',
        __index = function (map, t)
            local id   = idMap[t]
            local code = codeMap[id]
            if not code then
                return nil
            end
            local f = load(code)
            if not f then
                return nil
            end
            if sbyte(code, 1, 1) ~= 27 then
                codeMap[id] = dump(f, true)
            end
            local info = f()
            map[t] = info
            return info
        end
    })

    local lazyload = {
        __index = function(t, k)
            local info = infoMap[t]
            if not info then
                return nil
            end
            local fields = info[1]

            local keyID = keyDual[k]

            local v = fields[keyID]
            if v ~= nil then
                return v
            end

            local refs = info[3]
            if not refs then
                return nil
            end

            local ref = refs[keyID]
            if not ref then
                return nil
            end

            return instMap[ref]
        end,
        __newindex = function(t, k, v)
            rawset(t, k, v)
            refMap[t] = true
        end,
        __len = function (t)
            local info = infoMap[t]
            if not info then
                return 0
            end
            return info[2]
        end,
        __pairs = function (t)
            local info = infoMap[t]
            if not info then
                return DUMMY
            end
            local fields = info[1]
            local refs   = info[3]
            local keys   = {}
            for k in pairs(fields) do
                keys[#keys+1] = keyMap[k]
            end
            if refs then
                for k in pairs(refs) do
                    keys[#keys+1] = keyMap[k]
                end
            end
            local i = 0
            return function()
                i = i + 1
                local k = keys[i]
                return k, t[k]
            end
        end
    }

    setmetatable(idMap, { __mode = 'k' })

    setmetatable(instMap, {
        __mode  = 'v',
        __index = function (map, id)
            local inst  = {}
            idMap[inst] = id
            map[id]     = inst

            return setmt(inst, lazyload)
        end,
    })

    for t in pairs(self.excludes) do
        local id = self.dumpMark[t]
        refMap[t] = true
        instMap[id] = t
    end

    local entry = instMap[entryID]

    return entry
end

---@class lazytable
local m = {}

---@param t table
---@param writter? fun(id: integer, code: string): boolean
---@param reader?  fun(id: integer): string?
---@return lazytable.builder
function m.build(t, writter, reader)
    local builder = setmetatable({
        source     = t,
        codeMap    = {},
        dumpMark   = {},
        keyMap     = {},
        keyDual    = {},
        excludes   = {},
    }, mt)

    if writter and reader then
        builder:bind(writter, reader)
    end

    return builder
end

return m
