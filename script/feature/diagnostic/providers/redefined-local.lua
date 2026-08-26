local pd = require 'feature.diagnostic.parser-diagnostics'

---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function redefinedLocalProvider(param)
    local ast = param.ast
    local results = {}
    for _, block in ipairs(ast.blockList) do
        ---@cast block LuaParser.Node.Block
        local seen = {}
        for _, loc in ipairs(block.locals) do
            ---@cast loc LuaParser.Node.Local
            local name = loc.id
            if seen[name] then
                pd.push(results, 'redefined-local', loc.start, loc.finish, ('Redefined local `%s`.'):format(name))
            else
                seen[name] = true
            end
        end
    end
    return results
end

ls.feature.provider.diagnostic(redefinedLocalProvider)
