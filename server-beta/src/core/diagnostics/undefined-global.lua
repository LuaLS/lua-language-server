local files    = require 'files'
local searcher = require 'searcher'
local lang     = require 'language'
local library  = require 'library'
local config   = require 'config'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    -- 遍历全局变量，检查所有没有 mode['set'] 的全局变量
    local globals = searcher.getGlobals(ast.ast)
    for key, infos in pairs(globals) do
        if infos.mode['set'] == true then
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
        local message
        local otherVersion  = library.other[skey]
        local customVersion = library.custom[skey]
        if otherVersion then
            message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_VERSION', table.concat(otherVersion, '/'), config.config.runtime.version))
        elseif customVersion then
            message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_CUSTOM', table.concat(customVersion, '/')))
        else
            message = lang.script('DIAG_UNDEF_GLOBAL', skey)
        end
        for _, info in ipairs(infos) do
            callback {
                start   = info.source.start,
                finish  = info.source.finish,
                message = message,
            }
        end
        ::CONTINUE::
    end
end
