---@type table<string, LSP.Type>
local all = {}

---@class LSP.Type
---@field name string
---@field checker fun(value: any): boolean, string?
local T = {}
T.__index = T

T.kind = 'type'

---@param value any
---@return boolean, string?
function T:check(value)
    return self.checker(value)
end

---@class LSP.Union: LSP.Type
---@field types string[]
local U = {}
U.__index = U

U.kind = 'union'

---@param value any
---@return boolean, string?
function U:check(value)
    local errBuf = {'should be one of:'}
    for _, tp in ipairs(self.types) do
        local ins = all[tp]
        if not ins then
            return false, ('unknown type %q'):format(tp)
        end
        local suc, err = ins.check(value)
        if suc then
            return true
        end
        errBuf[#errBuf+1] = err
    end
    return false, table.concat(errBuf, '\n  ')
end

---@class LSP.Object: LSP.Type
---@field kvs [string, string][]
---@field fields { [string]: string }
---@field optionFields { [string]: string }
local O = {}
O.__index = O

O.kind = 'object'

function O:check(value)
    if type(value) ~= 'table' then
        return false, 'should be an object'
    end
    local unused = {}
    for k, v in pairs(value) do
        local tp = self.fields[k] or self.optionFields[k]
        if not tp then
            unused[k] = v
            goto continue
        end
        local ins = all[tp]
        if not ins then
            return false, ('unknown field type %q'):format(tp)
        end
        local suc, err = ins.check(v)
        if not suc then
            return false, ('field %q %s'):format(k, err)
        end
        ::continue::
    end
    for k in pairs(self.fields) do
        if value[k] == nil then
            return false, ('missing field %q'):format(k)
        end
    end
    for k, v in pairs(unused) do
        for _, kv in ipairs(self.kvs) do
            local kIns = all[kv[1]]
            local vIns = all[kv[2]]
            if not kIns then
                return false, ('unknown key type %q'):format(kv[1])
            end
            if not vIns then
                return false, ('unknown value type %q'):format(kv[2])
            end
            if not kIns.check(k) then
                goto continue
            end
            local suc, err = vIns.check(v)
            if not suc then
                return false, ('field %q %s'):format(k, err)
            end
            ::continue::
        end
    end
end

---@class LSP.Array: LSP.Type
---@field element string
local A = {}
A.__index = A

A.kind = 'array'

---@param value any
---@return boolean, string?
function A:check(value)
    if type(value) ~= 'table' then
        return false, 'should be an array'
    end
    for i = 1, #value do
        local ins = all[self.element]
        if not ins then
            return false, ('unknown element type %q'):format(self.element)
        end
        local suc, err = ins.check(value[i])
        if not suc then
            return false, ('element %d %s'):format(i, err)
        end
    end
    return true
end

---@class LSP.Type.API
local API = {}

---@class LSP.TypeOptions
---@field checker fun(value: any): boolean, string?

---@param name string
---@return fun(options: LSP.TypeOptions): LSP.Type
function API.new(name)
    return function (options)
        local self = setmetatable({
            name = name,
            checker = options.checker,
        }, T)
        all[name] = self
        return self
    end
end

---@param name string
---@return fun(types: string[]): LSP.Union
function API.union(name)
    return function (types)
        local self = setmetatable({
            name = name,
            types = types,
        }, U)
        all[name] = self
        return self
    end
end

---@param name string
---@return fun(struct: { [string]: string, [integer]: [string, string] }): LSP.Object
function API.object(name)
    return function (struct)
        local self = setmetatable({
            name = name,
            kvs = {},
            fields = {},
            optionFields = {},
        }, O)
        for k, v in pairs(struct) do
            if type(k) == 'number' then
                assert(type(v) == 'table')
                self.kvs[#self.kvs+1] = v
            elseif k:sub(-1) == '?' then
                self.optionFields[k:sub(1, -2)] = v
            else
                self.fields[k] = v
            end
        end
        all[name] = self
        return self
    end
end

---@param name string
---@return fun(element: string): LSP.Array
function API.array(name)
    return function (element)
        local self = setmetatable({
            name = name,
            element = element,
        }, A)
        all[name] = self
        return self
    end
end

return API
