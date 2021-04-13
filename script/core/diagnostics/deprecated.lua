local files   = require 'files'
local vm      = require 'vm'
local lang    = require 'language'
local guide   = require 'core.guide'
local config  = require 'config'
local define  = require 'proto.define'
local await   = require 'await'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    guide.eachSource(ast.ast, function (src)
        if  src.type ~= 'getglobal'
        and src.type ~= 'getfield'
        and src.type ~= 'getindex'
        and src.type ~= 'getmethod' then
            return
        end
        if src.type == 'getglobal' then
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
        end

        await.delay()

        if not vm.isDeprecated(src, 0) then
            return
        end

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

        local message = lang.script.DIAG_DEPRECATED
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
