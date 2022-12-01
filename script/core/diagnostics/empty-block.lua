local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local define  = require 'proto.define'
local await   = require 'await'

-- 检查空代码块  
-- 但是排除忙等待（repeat/while)
---@async
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    await.delay()
    guide.eachSourceType(ast.ast, 'if', function (source)
        for _, block in ipairs(source) do
            if #block > 0 then
                return
            end
        end
        callback {
            start   = source.start,
            finish  = source.finish,
            tags    = { define.DiagnosticTag.Unnecessary },
            message = lang.script.DIAG_EMPTY_BLOCK,
        }
    end)
    await.delay()
    guide.eachSourceType(ast.ast, 'loop', function (source)
        if #source > 0 then
            return
        end
        callback {
            start   = source.start,
            finish  = source.finish,
            tags    = { define.DiagnosticTag.Unnecessary },
            message = lang.script.DIAG_EMPTY_BLOCK,
        }
    end)
    await.delay()
    guide.eachSourceType(ast.ast, 'in', function (source)
        if #source > 0 then
            return
        end
        callback {
            start   = source.start,
            finish  = source.finish,
            tags    = { define.DiagnosticTag.Unnecessary },
            message = lang.script.DIAG_EMPTY_BLOCK,
        }
    end)
end
