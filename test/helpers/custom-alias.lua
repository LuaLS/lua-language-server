--- 注册标准 Module alias（modname -> 模块文件 main return），返回 playground
---@param scope Scope
---@return table playground 需要 <close> 释放
local function setupModule(scope)
    local playground = ls.custom.playground(scope)
    do
        local _ENV = playground.env
        _ENV.alias('Module')
            : define(function (c)
                c.param('T')
                c.resetCacheOnScopeChanged()
            end)
            : onValue(function (c)
                local modname = c.args[1]
                local literal = modname?.value?.literal
                if type(literal) ~= 'string' then
                    return c.type 'never'
                end
                local suri = c.location?.uri
                local uris = c.scope:searchFiles(literal, suri)
                if #uris == 0 then
                    return c.type 'never'
                end
                local ret = c.scope:getMainReturn(uris[1])
                if not ret then
                    return c.type 'never'
                end
                return ret
            end)
    end
    return playground
end

--- 注册标准 ModName alias（继承 string，hover 显示命中的文件路径），返回 playground
---@param scope Scope
---@return table playground 需要 <close> 释放
local function setupModName(scope)
    local playground = ls.custom.playground(scope)
    do
        local _ENV = playground.env
        _ENV.alias('ModName')
            : define(function (c)
                c.setValue(c.type 'string')
            end)
            : onHover(function (c)
                local src = c.source
                if not src or src.kind ~= 'string' then
                    return
                end
                ---@cast src LuaParser.Node.String
                local uris, searchers = c.scope:searchFiles(src.value, c.location?.uri)
                if #uris == 0 then
                    return
                end
                local lines = {}
                for i, uri in ipairs(uris) do
                    local path = c.scope:getRelativePath(uri) or uri
                    lines[#lines+1] = '* [{}]({}) （搜索路径：`{}`）' % { path, uri, searchers[i] }
                end
                return {
                    description = table.concat(lines, '\n'),
                }
            end)
            : onCompletion(function (c)
                local src = c.source
                if not src or src.kind ~= 'string' then
                    return
                end
                ---@cast src LuaParser.Node.String
                local items = c.scope:searchFilesByPartial(src.value, c.location?.uri)
                local results = {}
                for _, item in ipairs(items) do
                    local path = c.scope:getRelativePath(item.uri) or item.uri
                    results[#results+1] = {
                        label       = item.name,
                        detail      = path,
                        description = '* [{}]({}) （搜索路径：`{}`）' % { path, item.uri, item.searcher },
                        kind        = c.kind.Module,
                    }
                end
                return results
            end)
    end
    return playground
end

return {
    module  = setupModule,
    modname = setupModName,
}
