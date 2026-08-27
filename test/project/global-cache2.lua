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

    -- 模拟真实加载：A 先索引，B 后索引。
    -- 用 waitAll 同步等待索引完成（而非 fire-and-forget 的 ls.await.call），
    -- 否则异步索引让出时 do 块会先退出，<close> 的 file/scope 被销毁，
    -- 恢复后索引不会执行（见 awaitIndex 中 getDocument 返回 nil）。
    ls.await.waitAll {
        ---@async
        function ()
            scope.vm:awaitIndexFile(uriA)
            scope.vm:awaitIndexFile(uriC)
        end,
    }

    -- A 加载后 B 未加载：只有 A
    lt.assertEquals(getDefinitionUris(), { uriA })

    -- B 加载
    ls.await.waitAll {
        ---@async
        function ()
            scope.vm:awaitIndexFile(uriB)
        end,
    }

    -- B 加载后：A、B 都应显示
    lt.assertEquals(getDefinitionUris(), { uriA, uriB })
end