local files   = require 'files'
local guide   = require 'parser.guide'
local vm      = require 'vm'
local define  = require 'proto.define'
local lang    = require 'language'
local await   = require 'await'
local client  = require 'provider.client'

local function isToBeClosed(source)
    if not source.attrs then
        return false
    end
    for _, attr in ipairs(source.attrs) do
        if attr[1] == 'close' then
            return true
        end
    end
    return false
end

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    -- 只检查局部函数
    guide.eachSourceType(ast.ast, 'function', function (source)
        local parent = source.parent
        if not parent then
            return
        end
        if  parent.type ~= 'local'
        and parent.type ~= 'setlocal' then
            return
        end
        if isToBeClosed(parent) then
            return
        end
        local hasGet
        local refs = vm.getRefs(source)
        for _, src in ipairs(refs) do
            if vm.isGet(src) then
                hasGet = true
                break
            end
        end
        if not hasGet then
            if client.isVSCode() then
                callback {
                    start   = source.start,
                    finish  = source.finish,
                    tags    = { define.DiagnosticTag.Unnecessary },
                    message = lang.script.DIAG_UNUSED_FUNCTION,
                }
            else
                callback {
                    start   = source.keyword[1],
                    finish  = source.keyword[2],
                    tags    = { define.DiagnosticTag.Unnecessary },
                    message = lang.script.DIAG_UNUSED_FUNCTION,
                }
            end
        end
    end)
end
