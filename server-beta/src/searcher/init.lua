local guide    = require 'parser.guide'
local files    = require 'files'
local getValue = require 'searcher.getValue'

local setmetatable = setmetatable
local assert       = assert

_ENV = nil

local specials = {
    ['_G']           = true,
    ['rawset']       = true,
    ['rawget']       = true,
    ['setmetatable'] = true,
    ['require']      = true,
    ['dofile']       = true,
    ['loadfile']     = true,
}

---@class searcher
local mt = {}
mt.__index = mt
mt.__name = 'searcher'
mt._step = 0

function mt:step()
    self._step = self._step + 1
    assert(self.step <= 100, 'Stack overflow!')
    if not self._stepClose then
        self._stepClose = setmetatable({}, {
            __close = function ()
                self._step = self._step - 1
            end
        })
    end
    return self._stepClose
end

--- 获取关联的值
---@param source table
---@return value table
function mt:getValue(source)
    local _ <close> = self:step()
    return getValue(self, source)
end

---@class engineer
local m = {}

--- 新建搜索器
---@param uri string
---@return searcher
function m.create(uri)
    local ast = files.getAst(uri)
    local searcher = setmetatable({
        ast  = ast.ast,
        uri  = uri,
        cache = {
            def   = {},
            ref   = {},
            field = {},
            value = {},
            specialName = {},
        },
        lock = {
            value = {},
        }
    }, mt)
    return searcher
end

return m
