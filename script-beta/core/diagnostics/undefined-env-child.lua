local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    -- 再遍历一次 getglobal ，找出 _ENV 被重载的情况
    guide.eachSourceType(ast.ast, 'getglobal', function (source)
        -- 单独验证自己是否在重载过的 _ENV 中有定义
        if source.node.tag == '_ENV' then
            return
        end
        local setInENV = vm.eachRef(source, function (info)
            if info.mode == 'set' then
                return true
            end
        end)
        if setInENV then
            return
        end
        local key = source[1]
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script('DIAG_UNDEF_ENV_CHILD', key),
        }
    end)
end
