local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local config  = require 'config'
local library = require 'library'

-- 不允许定义首字母小写的全局变量（很可能是拼错或者漏删）
return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    local definedGlobal = {}
    for name in pairs(config.config.diagnostics.globals) do
        definedGlobal[name] = true
    end
    for name in pairs(library.global) do
        definedGlobal[name] = true
    end

    guide.eachSourceType(ast.ast, 'setglobal', function (source)
        local name = guide.getName(source)
        if definedGlobal[name] then
            return
        end
        local first = name:match '%w'
        if not first then
            return
        end
        if first:match '%l' then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script.DIAG_LOWERCASE_GLOBAL,
            }
        end
    end)
end
