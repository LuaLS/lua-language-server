---@class lazytable.builder
---@field source     table
---@field codeMap    table<integer, string>
---@field dumpMark   table<table, integer>
---@field excludes   table<table, true>
---@field refMap     table<any, integer>
---@field instMap    table<integer, table|function|thread|userdata>
local mt = {}
mt.__index = mt
mt.tableID = 1
mt.keyID   = 1

local DUMMY = function() end

local RESERVED = {
    ['and']      = true,
    ['break']    = true,
    ['do']       = true,
    ['else']     = true,
    ['elseif']   = true,
    ['end']      = true,
    ['false']    = true,
    ['for']      = true,
    ['function'] = true,
    ['if']       = true,
    ['in']       = true,
    ['local']    = true,
    ['nil']      = true,
    ['not']      = true,
    ['or']       = true,
    ['repeat']   = true,
    ['return']   = true,
    ['then']     = true,
    ['true']     = true,
    ['until']    = true,
    ['while']    = true,
    ['goto']     = true
}

---@param k string|integer
---@return string
local function formatKey(k)
    if type(k) == 'string' then
        if not RESERVED[k] and k:match '^[%a_][%w_]*$' then
            return k
        else
            return ('[%q]'):format(k)
        end
    end
    if type(k) == 'number' then
        if math.type(k) == 'integer' then
            local n10 = ('%d'):format(k)
            local n16 = ('0x%X'):format(k)
            if #n10 <= #n16 then
                return '[' .. n10 .. ']'
            else
                return '[' .. n16 .. ']'
            end
        else
            local n10 = ('%.16f'):format(k):gsub('0+$', '')
            local n16 = ('%q'):format(k)
            if #n10 <= #n16 then
                return '[' .. n10 .. ']'
            else
                return '[' .. n16 .. ']'
            end
        end
    end
    error('invalid key type: ' .. type(k))
end

---@param v string|number|boolean
local function formatValue(v)
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

---@param info {[1]: table, [2]: integer, [3]: table?}
---@return string
local function dump(info)
    local codeBuf = {}

    codeBuf[#codeBuf + 1] = 'return{{'
    local hasFields
    for k, v in pairs(info[1]) do
        if hasFields then
            codeBuf[#codeBuf + 1] = ','
        else
            hasFields = true
        end
        codeBuf[#codeBuf+1] = string.format('%s=%s'
            , formatKey(k)
            , formatValue(v)
        )
    end
    codeBuf[#codeBuf+1] = '}'

    codeBuf[#codeBuf+1] = string.format(',%d', formatValue(info[2]))

    if info[3] then
        codeBuf[#codeBuf+1] = ',{'
        hasFields = false
        for k, v in pairs(info[3]) do
            if hasFields then
                codeBuf[#codeBuf+1] = ','
            else
                hasFields = true
            end
            codeBuf[#codeBuf+1] = string.format('%s=%s'
                , formatKey(k)
                , formatValue(v)
            )
        end
        codeBuf[#codeBuf+1] = '}'
    end

    codeBuf[#codeBuf + 1] = '}'

    return table.concat(codeBuf)
end

---@param obj table|function|userdata|thread
---@return integer
function mt:getObjectID(obj)
    if self.dumpMark[obj] then
        return self.dumpMark[obj]
    end
    local id = self.tableID
    self.tableID = self.tableID + 1
    self.dumpMark[obj] = id
    if self.excludes[obj] or type(obj) ~= 'table' then
        self.refMap[obj] = id
        self.instMap[id] = obj
        return id
    end

    if not next(obj) then
        self.codeMap[id] = nil
        return id
    end

    local fields = {}
    local objs
    for k, v in pairs(obj) do
        local tp = type(v)
        if tp == 'string' or tp == 'number' or tp == 'boolean' then
            fields[k] = v
        else
            if not objs then
                objs = {}
            end
            objs[k] = self:getObjectID(v)
        end
    end

    local code = dump({fields, #obj, objs})

    self.codeMap[id] = code
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
    local entryID = self:getObjectID(self.source)

    local codeMap = self.codeMap
    local refMap  = self.refMap
    local instMap = self.instMap
    local load    = load
    local setmt   = setmetatable
    local sdump   = string.dump
    local type    = type
    local sbyte   = string.byte
    local tableID = self.tableID
    ---@type table<table, integer>
    local idMap   = {}
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
                codeMap[id] = sdump(f, true)
            end
            local info = f()
            map[t] = info
            return info
        end
    })

    local lazyload = {
        ref = refMap,
        __index = function(t, k)
            local info = infoMap[t]
            if not info then
                return nil
            end
            local fields = info[1]

            local keyID = k

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
            local info = infoMap[t]
            if not info then
                return
            end
            local fields = info[1]
            local objs   = info[3]
            fields[k]    = nil
            if objs then
                objs[k] = nil
            end
            if v ~= nil then
                local tp = type(v)
                if tp == 'string' or tp == 'number' or tp == 'boolean' then
                    fields[k] = v
                else
                    if not objs then
                        objs = {}
                    end
                    local id = refMap[v]
                    if not id then
                        id = tableID
                        refMap[v] = id -- 新赋值的对象一定会被引用住
                        instMap[id] = v
                        tableID = tableID + 1
                    end
                    objs[k] = id
                end
            end
            info = { fields, info[2], objs }
            local id = idMap[t]
            local code = dump(info)
            codeMap[id] = code
            infoMap[id] = nil
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
            local objs   = info[3]
            local keys   = {}
            for k in pairs(fields) do
                keys[#keys+1] = k
            end
            if objs then
                for k in pairs(objs) do
                    keys[#keys+1] = k
                end
            end
            local i = 0
            return function()
                i = i + 1
                local k = keys[i]
                return k, t[k]
            end
        end,
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

    local entry = instMap[entryID] --[[@as table]]

    self.source = nil

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
        refMap     = {},
        instMap    = {},
        dumpMark   = {},
        excludes   = {},
    }, mt)

    if writter and reader then
        builder:bind(writter, reader)
    end

    return builder
end

return m
