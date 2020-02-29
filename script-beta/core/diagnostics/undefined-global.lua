local files   = require 'files'
local vm      = require 'vm'
local lang    = require 'language'
local library = require 'library'
local config  = require 'config'

local function hasSet(sources)
    if sources.hasSet ~= nil then
        return sources.hasSet
    end
    sources.hasSet = false
    for i = 1, #sources do
        if vm.isSet(sources[i]) then
            sources.hasSet = true
        end
    end
    return sources.hasSet
end

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    local globalCache = {}

    -- 遍历全局变量，检查所有没有 set 模式的全局变量
    local globals = vm.getGlobals(ast.ast)
    if not globals then
        return
    end
    for key, sources in pairs(globals) do
        if hasSet(sources) then
            goto CONTINUE
        end
        if globalCache[key] then
            goto CONTINUE
        end
        local skey = key and key:match '^s|(.+)$'
        if not skey then
            goto CONTINUE
        end
        if library.global[skey] then
            goto CONTINUE
        end
        if config.config.diagnostics.globals[skey] then
            goto CONTINUE
        end
        if globalCache[key] == nil then
            local uris = files.findGlobals(key)
            for i = 1, #uris do
                local destAst = files.getAst(uris[i])
                local destGlobals = vm.getGlobals(destAst.ast)
                if destGlobals[key] and hasSet(destGlobals[key]) then
                    globalCache[key] = true
                    goto CONTINUE
                end
            end
        end
        globalCache[key] = false
        local message = lang.script('DIAG_UNDEF_GLOBAL', skey)
        local otherVersion  = library.other[skey]
        local customVersion = library.custom[skey]
        if otherVersion then
            message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_VERSION', table.concat(otherVersion, '/'), config.config.runtime.version))
        elseif customVersion then
            message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_CUSTOM', table.concat(customVersion, '/')))
        end
        for _, source in ipairs(sources) do
            callback {
                start   = source.start,
                finish  = source.finish,
                message = message,
            }
        end
        ::CONTINUE::
    end
end
