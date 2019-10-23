local guide = require 'parser.guide'
local files = require 'files'

local setmetatable = setmetatable

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

---@class engineer
local m = {}

--- 新建搜索器
---@param uri string
---@return searcher
function m.create(uri)
    local ast = files.getAst(uri)
    local searcher = setmetatable({
        step = 0,
        ast  = ast.ast,
        uri  = uri,
        cache = {
            def   = {},
            ref   = {},
            field = {},
            value = {},
            specialName = {},
        },
    }, mt)
    return searcher
end

return m
