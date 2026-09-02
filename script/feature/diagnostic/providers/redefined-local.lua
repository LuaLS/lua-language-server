local pd = require 'feature.diagnostic.parser-diagnostics'

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function redefinedLocalProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, block in ipairs(ast.blockList) do
        delayer:delay()
        ---@cast block LuaParser.Node.Block
        local seen = {}
        for _, loc in ipairs(block.locals) do
            ---@cast loc LuaParser.Node.Local
            local name = loc.id
            if seen[name] then
                pd.push(callback, 'redefined-local', loc.start, loc.finish, ('Redefined local `%s`.'):format(name))
            else
                seen[name] = true
            end
        end
    end
end

ls.feature.provider.diagnostic(redefinedLocalProvider)
