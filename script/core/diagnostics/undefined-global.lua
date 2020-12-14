local files   = require 'files'
local vm      = require 'vm'
local lang    = require 'language'
local config  = require 'config'
local guide   = require 'parser.guide'
local define  = require 'proto.define'

local requireLike = {
    ['include'] = true,
    ['import']  = true,
    ['require'] = true,
    ['load']    = true,
}

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    -- 遍历全局变量，检查所有没有 set 模式的全局变量
    guide.eachSourceType(ast.ast, 'getglobal', function (src)
        local key = guide.getKeyName(src)
        if not key then
            return
        end
        if config.config.diagnostics.globals[key] then
            return
        end
        if config.config.runtime.special[key] then
            return
        end
        if #vm.getGlobalSets(key) == 0 then
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
        if not vm.isDeprecated(src, 0) then
            return
        end

        local message = lang.script('DIAG_UNDEF_GLOBAL', key)
        local defs = vm.getDefs(src, 0)
        local validVersions
        for _, def in ipairs(defs) do
            if def.bindDocs then
                for _, doc in ipairs(def.bindDocs) do
                    if doc.type == 'doc.version' then
                        validVersions = vm.getValidVersions(doc)
                        break
                    end
                end
            end
        end

        local versions
        if validVersions then
            versions = {}
            for version, valid in pairs(validVersions) do
                if valid then
                    versions[#versions+1] = version
                end
            end
            table.sort(versions)
            if #versions > 0 then
                message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_VERSION', table.concat(versions, '/'), config.config.runtime.version))
            end
        end

        callback {
            start   = src.start,
            finish  = src.finish,
            tags    = { define.DiagnosticTag.Deprecated },
            message = message,
            data    = {
                versions = versions,
            }
        }
    end)
end
