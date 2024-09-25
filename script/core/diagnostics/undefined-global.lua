local files     = require 'files'
local vm        = require 'vm'
local lang      = require 'language'
local guide     = require 'parser.guide'

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

    -- 遍历全局变量，检查所有没有 set 模式的全局变量
    guide.eachSourceType(state.ast, 'getglobal', function (src) ---@async
        if vm.isUndefinedGlobal(src) then
            local key = src[1]
            local message = lang.script('DIAG_UNDEF_GLOBAL', key)
            if requireLike[key:lower()] then
                message = ('%s(%s)'):format(message, lang.script('DIAG_REQUIRE_LIKE', key))
            end

            callback {
                start   = src.start,
                finish  = src.finish,
                message = message,
                undefinedGlobal = src[1]
            }
        end
    end)
end
