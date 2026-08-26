local pd = require 'feature.diagnostic.parser-diagnostics'

---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function trailingSpaceProvider(param)
    local ast = param.ast
    local text = ast.code
    local results = {}
    local pos = 1
    while pos <= #text do
        local lineEnd = text:find('[\r\n]', pos)
        local lineText
        if lineEnd then
            lineText = text:sub(pos, lineEnd - 1)
        else
            lineText = text:sub(pos)
        end
        if #lineText > 0 and (lineText:sub(-1) == ' ' or lineText:sub(-1) == '\t') then
            local first = 1
            for i = #lineText, 1, -1 do
                local ch = lineText:sub(i, i)
                if ch ~= ' ' and ch ~= '\t' then
                    first = i + 1
                    break
                end
            end
            local start  = pos + first - 2
            local finish = pos + #lineText - 1
            if not pd.isInStringOrComment(ast, start, finish) then
                if first == 1 then
                    pd.push(results, 'trailing-space', start, finish, 'Line contains only whitespace.')
                else
                    pd.push(results, 'trailing-space', start, finish, 'Trailing whitespace.')
                end
            end
        end
        if not lineEnd then
            break
        end
        pos = lineEnd + 1
    end
    return results
end

ls.feature.provider.diagnostic(trailingSpaceProvider)
