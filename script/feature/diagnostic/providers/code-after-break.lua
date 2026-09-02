local pd = require 'feature.diagnostic.parser-diagnostics'

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function codeAfterBreakProvider(param, callback)
    local ast = param.ast
    local mark = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, kind in ipairs({ 'break', 'continue' }) do
        for _, brk in ipairs(ast.nodesMap[kind]) do
            delayer:delay()
            ---@cast brk LuaParser.Node.Break
            if not brk.breakBlock then
                goto continueNode
            end
            local list = brk.parent
            if not list or not list.childs then
                goto continueNode
            end
            if mark[list] then
                goto continueNode
            end
            mark[list] = true
            local childs = list.childs
            for i = #childs, 1, -1 do
                if childs[i] == brk then
                    if i < #childs then
                        local word = kind == 'break' and 'break' or 'continue'
                        pd.push(callback, 'code-after-break', childs[i+1].start, childs[#childs].finish, ('Unable to execute code after `%s`.'):format(word))
                    end
                    break
                end
            end
            ::continueNode::
        end
    end
end

ls.feature.provider.diagnostic(codeAfterBreakProvider)
