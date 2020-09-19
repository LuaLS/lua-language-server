local files   = require 'files'
local vm      = require 'vm'
local lang    = require 'language'
local library = require 'library'
local config  = require 'config'
local guide   = require 'parser.guide'

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
        if library.global[key] then
            return
        end
        if #vm.getGlobalSets(guide.getKeyName(src)) > 0 then
            return
        end
        local message = lang.script('DIAG_UNDEF_GLOBAL', key)
        local otherVersion  = library.other[key]
        local customVersion = library.custom[key]
        if otherVersion then
            message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_VERSION', table.concat(otherVersion, '/'), config.config.runtime.version))
        elseif customVersion then
            message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_CUSTOM', table.concat(customVersion, '/')))
        end
        callback {
            start   = src.start,
            finish  = src.finish,
            message = message,
        }
    end)
end
