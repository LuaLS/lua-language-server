local define = require 'feature.diagnostic.define'
local syntax = require 'feature.diagnostic.providers.syntax'

local validCodes
do
    validCodes = {}
    for name in pairs(define.diagnosticDatas) do
        validCodes[name] = true
    end
    for code in pairs(syntax.messages) do
        validCodes[code:lower():gsub('_', '-')] = true
    end
end

---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function unknownDiagCodeProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, node in ipairs(ast.nodesMap['catstatediagnostic']) do
        delayer:delay()
        ---@cast node LuaParser.Node.CatStateDiagnostic
        local names = node.names
        if not names then
            goto continue
        end
        for _, name in ipairs(names) do
            if not validCodes[name.id] then
                results[#results+1] = {
                    code    = 'unknown-diag-code',
                    level   = 0,
                    start   = name.start,
                    finish  = name.finish,
                    message = ('Unknown diagnostic code `%s`.'):format(name.id),
                }
            end
        end
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(unknownDiagCodeProvider)
