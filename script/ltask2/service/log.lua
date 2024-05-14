local fs  = require 'bee.filesystem'
local log = require 'log'

local S = {}

---@param root string
---@param path string
function S.init(root, path)
    log.init(fs.path(root), fs.path(path))
end

function S.log(params)
    log.raw(-1, params.level, params.msg, params.src, params.line, params.clock)
end

return S
