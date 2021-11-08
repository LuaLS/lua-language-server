local files     = require 'files'
local vm        = require 'vm'
local lang      = require 'language'
local config    = require 'config'
local guide     = require 'parser.guide'
local noder     = require 'core.noder'
local collector = require 'core.collector'
local await     = require 'await'

local requireLike = {
    ['include'] = true,
    ['import']  = true,
    ['require'] = true,
    ['load']    = true,
}

---@async
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    -- 遍历全局变量，检查所有没有 set 模式的全局变量
    guide.eachSourceType(ast.ast, 'getglobal', function (src) ---@async
        local key = src[1]
        if not key then
            return
        end
        if config.get 'Lua.diagnostics.globals'[key] then
            return
        end
        if config.get 'Lua.runtime.special'[key] then
            return
        end
        local node = src.node
        if node.tag ~= '_ENV' then
            return
        end
        await.delay()
        local id = 'def:' .. noder.getID(src)
        if not collector.has(id) then
            local message = lang.script('DIAG_UNDEF_GLOBAL', key)
            if requireLike[key:lower()] then
                message = ('%s(%s)'):format(message, lang.script('DIAG_REQUIRE_LIKE', key))
            end
            callback {
                start   = src.start,
                finish  = src.finish,
                message = message,
            }
            return
        end
    end)
end
