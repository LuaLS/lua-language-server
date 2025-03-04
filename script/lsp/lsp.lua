local type = require 'lsp.type'

---@class LSP
local M = {}

type.new 'number' {
    checker = function (value)
        if type(value) ~= 'number' then
            return false, 'should be a number'
        end
        return true
    end
}

type.new 'integer' {
    checker = function (value)
        if type(value) ~= 'number' then
            return false, 'should be a number'
        end
        if math.tointeger(value) == nil then
            return false, 'can not convert to integer'
        end
        if value < (-2 ^ 31) or value > (2 ^ 31 - 1) then
            return false, 'should be a 32-bit integer'
        end
        return true
    end
}

type.new 'uinteger' {
    checker = function (value)
        if type(value) ~= 'number' then
            return false, 'should be a number'
        end
        if math.tointeger(value) == nil then
            return false, 'can not convert to integer'
        end
        if value < 0 or value > (2 ^ 32 - 1) then
            return false, 'should be a 32-bit unsigned integer'
        end
        return true
    end
}

type.new 'decimal' {
    checker = function (value)
        if type(value) ~= 'number' then
            return false, 'should be a number'
        end
        if value < 0 or value > 1 then
            return false, 'should be a decimal between 0 and 1'
        end
        return true
    end
}

type.new 'string' {
    checker = function (value)
        if type(value) ~= 'string' then
            return false, 'should be a string'
        end
        return true
    end
}

type.new 'boolean' {
    checker = function (value)
        if type(value) ~= 'boolean' then
            return false, 'should be a boolean'
        end
        return true
    end
}

type.new 'null' {
    checker = function (value)
        if value ~= nil then
            return false, 'should be null'
        end
        return true
    end
}

type.union 'LSPAny' {
    'LSPObject', 'LSPArray', 'string', 'integer', 'uinteger',
    'decimal', 'boolean', 'null'
}

type.object 'LSPObject' {
    {'string', 'LSPAny'}
}

type.array 'LSPArray' ('LSPAny')
