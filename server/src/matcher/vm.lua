local env = require 'matcher.env'
local library = require 'matcher.library'

local DefaultSource = { start = 0, finish = 0 }

local mt = {}

function mt:createLocal(key, source)
    local loc = {
        type = 'local',
        key = key,
        source = source or DefaultSource,
    }
    self.results.locals[#self.results.locals+1] = loc
    self.locals[key] = loc
    return loc
end

function mt:createTable(source)
    local tbl = {
        type   = 'table',
        source = source or DefaultSource,
    }
    return tbl
end

function mt:setValue(var, value)
    var.value = value
    return value
end

function mt:getValue(var)
    return var.value
end

function mt:addField(value, field)
    if not value.child then
        value.child = {}
    end
    value.child[#value.child+1] = field
end

function mt:createField(parent, name, source)
    local field = {
        type = 'field',
        key = name,
        source = source or DefaultSource,
    }
    self.results.fields[#self.results.fields+1] = field

    local value =  self:getValue(parent)
                or self:setValue(parent, self:createTable(source))
    self:addField(value, field)

    return field
end

function mt:createFunction(source)
    local func = {
        type   = 'function',
        source = source or DefaultSource,
    }
    return func
end

function mt:createString(str, source)
    local string = {
        type   = 'string',
        source = source or DefaultSource,
        value  = str,
    }
    return string
end

function mt:createBoolean(bool, source)
    local boolean = {
        type   = 'boolean',
        source = source or DefaultSource,
        value  = bool or false,
    }
    return boolean
end

function mt:createNumber(num, source)
    local number = {
        type   = 'number',
        source = source or DefaultSource,
        value  = num or 0.0,
    }
    return number
end

function mt:createInteger(int, source)
    local integer = {
        type   = 'integer',
        source = source or DefaultSource,
        value  = int or 0,
    }
    return integer
end

function mt:setLib(obj, lib)
    obj.lib = lib
    if lib.type == 'table' then
        self:setValue(obj, self:createTable())
    elseif lib.type == 'function' then
        self:setValue(obj, self:createFunction()) -- TODO
    elseif lib.type == 'string' then
        self:setValue(obj, self:createString(lib.value))
    elseif lib.type == 'boolean' then
        self:setValue(obj, self:createBoolean(lib.value))
    elseif lib.type == 'number' then
        self:setValue(obj, self:createNumber(lib.value))
    elseif lib.type == 'integer' then
        self:setValue(obj, self:createInteger(lib.value))
    end
end

function mt:doAction(action)
end

function mt:doActions(actions)
    for _, action in ipairs(actions) do
        self:doAction(action)
    end
end

function mt:createEnvironment()
    -- 所有脚本都有个隐藏的上值`_ENV`
    local parent = self:createLocal('_ENV')
    -- 设置全局变量
    for name, info in pairs(library.global) do
        local field = self:createField(parent, name)
        if info.lib then
            self:setLib(field, info.lib)
        end
        if info.child then
            for fname, flib in pairs(info.child) do
                local ffield = self:createField(field, fname)
                self:setLib(ffield, flib)
            end
        end
    end
end

local function compile(ast)
    local vm = setmetatable({
        locals  = env {},
        label   = env {},
        results = {
            locals = {},
            fields = {},
            labels = {},
        }
    }, mt)

    -- 创建初始环境
    vm:createEnvironment()

    -- 执行代码
    vm:doActions(ast)

    return vm.results
end

return function (ast)
    if not ast then
        return nil
    end
    local suc, res = xpcall(compile, log.error, ast)
    if not suc then
        return nil
    end
    return res
end
