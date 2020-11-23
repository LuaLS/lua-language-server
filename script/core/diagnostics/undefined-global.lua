local files   = require 'files'
local vm      = require 'vm'
local lang    = require 'language'
local config  = require 'config'
local guide   = require 'parser.guide'
local define  = require 'proto.define'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    -- 遍历全局变量，检查所有没有 set 模式的全局变量
    guide.eachSourceType(ast.ast, 'getglobal', function (src)
        local key = guide.getName(src)
        if not key then
            return
        end
        if config.config.diagnostics.globals[key] then
            return
        end
        if #vm.getGlobalSets(guide.getKeyName(src)) == 0 then
            local message = lang.script('DIAG_UNDEF_GLOBAL', key)
            callback {
                start   = src.start,
                finish  = src.finish,
                message = message,
            }
            return
        end
        if not vm.isDeprecated(src, 'deep') then
            return
        end

        do return end

        callback {
            start   = src.start,
            finish  = src.finish,
            tags    = { define.DiagnosticTag.Deprecated },
            message = 'adsad',
        }

        do return end

        local defs = vm.getDefs(src, 'deep')
        local versions = {}
        for _, def in ipairs(defs) do
            
        end
        -- TODO check other version
        local otherVersion
        if otherVersion then
            message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_VERSION', table.concat(otherVersion, '/'), config.config.runtime.version))
        end
    end)
end
