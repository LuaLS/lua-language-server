---@param loc LuaParser.Node.Local
---@param envMode string
---@return boolean
local function isExcluded(loc, envMode)
    local name = loc.id
    if name == '_' or name == envMode then
        return true
    end
    if loc.isGlobal then
        return true
    end
    if loc.attr and loc.attr.name and loc.attr.name.id == 'close' then
        return true
    end
    local parent = loc.parent
    if parent and (parent.kind == 'function' or parent.kind == 'for') then
        return true
    end
    return false
end

---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function unusedLocalProvider(param)
    local ast = param.ast
    local results = {}
    for _, loc in ipairs(ast.nodesMap['local']) do
        ---@cast loc LuaParser.Node.Local
        if isExcluded(loc, ast.envMode) then
            goto continue
        end
        if #loc.gets > 0 then
            goto continue
        end
        results[#results+1] = {
            code    = 'unused-local',
            start   = loc.start,
            finish  = loc.finish,
            message = ('Unused local `%s`.'):format(loc.id),
            tags    = { ls.spec.DiagnosticTag.Unnecessary },
        }
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(unusedLocalProvider)
