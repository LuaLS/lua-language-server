local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local define  = require 'proto.define'

-- 检查空代码块
-- 但是排除忙等待（repeat/while)
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

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
