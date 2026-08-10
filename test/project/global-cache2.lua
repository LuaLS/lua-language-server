print('[project.global-cache2] 测试中...')

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
    local scope <close> = ls.scope.create('global-cache2-test', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    local uriA = 'file:///root/a.lua'
    local uriB = 'file:///root/b.lua'
    local uriC = 'file:///root/c.lua'
    root.uriSet[uriA] = true
    root.uriSet[uriB] = true
    root.uriSet[uriC] = true

    local fileA <close> = ls.file.setServerText(uriA, [[
foo = 1
]])
    local scriptC, offsetC = parseMark [[
print(<?foo?>)
]]
    local fileC <close> = ls.file.setServerText(uriC, scriptC)
    local fileB <close> = ls.file.setServerText(uriB, [[
foo = 2
]])

    ---@async
    ls.await.call(function ()
        -- 模拟真实加载：A 先索引，B 后索引
        scope.vm:awaitIndexFile(uriA)
        scope.vm:awaitIndexFile(uriC)

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

        -- A 加载后 B 未加载：只有 A
        lt.assertEquals(getDefinitionUris(), { uriA })

        -- B 加载
        scope.vm:awaitIndexFile(uriB)

        -- B 加载后：A、B 都应显示
        lt.assertEquals(getDefinitionUris(), { uriA, uriB })
    end)
end

print('[project.global-cache2] 测试完毕')
