local files     = require 'files'
local vm        = require 'vm'
local lang      = require 'language'
local config    = require 'config'
local guide     = require 'parser.guide'
local await     = require 'await'
local util      = require 'utility'

local requireLike = {
    ['include'] = true,
    ['import']  = true,
    ['require'] = true,
    ['load']    = true,
}

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    local dglobals = util.arrayToHash(config.get(uri, 'Lua.diagnostics.globals'))
    local rspecial = config.get(uri, 'Lua.runtime.special')
    local cache    = {}

    -- 遍历全局变量，检查所有没有 set 模式的全局变量
    guide.eachSourceType(state.ast, 'getglobal', function (src) ---@async
        local key = src[1]
        if not key then
            return
        end
        if dglobals[key] then
            return
        end
        if rspecial[key] then
            return
        end
        local node = src.node
        if node.tag ~= '_ENV' then
            return
        end
        if cache[key] == nil then
            await.delay()
            cache[key] = vm.hasGlobalSets(uri, 'variable', key)
        end
        if cache[key] then
            return
        end
        local message = lang.script('DIAG_UNDEF_GLOBAL', key)
        if requireLike[key:lower()] then
            message = ('%s(%s)'):format(message, lang.script('DIAG_REQUIRE_LIKE', key))
        end
        callback {
            start   = src.start,
            finish  = src.finish,
            message = message,
        }
    end)
end
