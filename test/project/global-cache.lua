---@param scope Scope
---@param kind string
---@param uri Uri
---@return Scope.Root
local function createRoot(scope, kind, uri)
    local root = New 'Scope.Root' (scope, kind, uri, scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    return root
end

---@param script string
---@return string script
---@return integer offset
local function parseMark(script)
    local newScript, catched = test.catch(script, '?')
    return newScript, catched['?'][1][1]
end

do
    local scope <close> = ls.scope.create('global-cache-test', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    local uriA = 'file:///root/a.lua'
    local uriB = 'file:///root/b.lua'
    local uriC = 'file:///root/c.lua'
    -- 加载中：只有 A 和当前文件 C
    root.uriSet[uriA] = true
    root.uriSet[uriC] = true

    local fileA <close> = ls.file.setServerText(uriA, [[

foo = 1
]])
    local scriptC, offsetC = parseMark [[
print(<?foo?>)
]]
    local fileC <close> = ls.file.setServerText(uriC, scriptC)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriC)

    ---@async
    --- 通过 definition 特性查看 foo 的定义
    local function getDefinitionUris()
        local results = ls.feature.definition(uriC, offsetC)
        ---@type string[]
        local uris = {}
        for _, r in ipairs(results) do
            uris[#uris+1] = r.uri
        end
        table.sort(uris)
        return uris
    end

    -- A 已加载：只有 A 一个定义
    lt.assertEquals(getDefinitionUris(), { uriA })

    -- B 加载（B 的 foo 在第 1 行，与 A 不同偏移）
    root.uriSet[uriB] = true
    local fileB <close> = ls.file.setServerText(uriB, [[
foo = 2
]])
    scope.vm:indexFile(uriB)

    -- 应有 A 和 B 两个定义
    lt.assertEquals(getDefinitionUris(), { uriA, uriB })
end

do
    -- 用户在 A、B 相同偏移处定义全局变量 foo 的场景
    local scope <close> = ls.scope.create('global-cache-test-2', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    local uriA = 'file:///root/a.lua'
    local uriB = 'file:///root/b.lua'
    local uriC = 'file:///root/c.lua'
    root.uriSet[uriA] = true
    root.uriSet[uriC] = true

    local fileA <close> = ls.file.setServerText(uriA, [[
foo = 1
]])
    local scriptC, offsetC = parseMark [[
print(<?foo?>)
]]
    local fileC <close> = ls.file.setServerText(uriC, scriptC)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriC)

    ---@async
    local function getDefinitionUris()
        local results = ls.feature.definition(uriC, offsetC)
        ---@type string[]
        local uris = {}
        for _, r in ipairs(results) do
            uris[#uris+1] = r.uri
        end
        table.sort(uris)
        return uris
    end

    -- 趁 A 加载后 B 未加载时查看：只有 A
    lt.assertEquals(getDefinitionUris(), { uriA })

    -- B 加载（与 A 相同偏移定义 foo）
    root.uriSet[uriB] = true
    local fileB <close> = ls.file.setServerText(uriB, [[
foo = 2
]])
    scope.vm:indexFile(uriB)

    -- B 加载后：A、B 都应显示
    lt.assertEquals(getDefinitionUris(), { uriA, uriB })
end