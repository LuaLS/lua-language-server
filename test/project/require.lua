print('[project.require] 测试中...')

---@param scope Scope
---@param kind string
---@param uri Uri
---@return Scope.Root
local function createRoot(scope, kind, uri)
    local root = New 'Scope.Root' (scope, kind, uri, scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    return root
end

do
    local scope <close> = ls.scope.create('require-test-1', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    root.uriSet['file:///root/a.lua'] = true
    root.uriSet['file:///root/a/b.lua'] = true

    local playground = ls.custom.playground(scope)
    do
        local _ENV = playground.env

        -- RequireUri：modname -> uri
        _ENV.alias('RequireUri')
            : param('T')
            : onValue(function (c)
                local modname = c.args[1]
                if modname.kind ~= 'value' then
                    return c.type 'never'
                end
                local literal = modname.literal
                if type(literal) ~= 'string' then
                    return c.type 'never'
                end
                local uris = c.scope:searchFiles(literal)
                if #uris == 0 then
                    return c.type 'never'
                end
                return c.value(uris[1])
            end)

        -- RequireValue：uri -> 该文件根 return 的第一个值
        _ENV.alias('RequireValue')
            : param('T')
            : onValue(function (c)
                local uriNode = c.args[1]
                if uriNode.kind ~= 'value' then
                    return c.type 'never'
                end
                local uri = uriNode.literal
                if type(uri) ~= 'string' then
                    return c.type 'never'
                end
                local vfile = c.scope.vm:indexFile(uri)
                local ret = vfile:getMainReturn()
                if not ret then
                    return c.type 'never'
                end
                return ret
            end)
    end

    local rt = scope.rt
    -- RequireUri: modname='a' 匹配到 a.lua
    local v = rt.call('RequireUri', { rt.value 'a' })
    lt.assertEquals(v:view(), '"file:///root/a.lua"')

    -- RequireUri: modname='a.b' 匹配到 a/b.lua
    local v2 = rt.call('RequireUri', { rt.value 'a.b' })
    lt.assertEquals(v2:view(), '"file:///root/a/b.lua"')

    -- RequireUri: 无匹配返回 never
    local v3 = rt.call('RequireUri', { rt.value 'zzz' })
    lt.assertEquals(v3:view(), 'never')

    -- RequireValue: uri -> main return
    local uriA = 'file:///root/a.lua'
    local fileA <close> = ls.file.setServerText(uriA, [[
local t = { x = 1 }
return t
]])
    local v4 = rt.call('RequireValue', { rt.value(uriA) })
    lt.assertEquals(v4:view(), '{ x: 1 }')

    -- RequireValue: 无 return 的文件返回 never
    local uriB = 'file:///root/a/b.lua'
    local fileB <close> = ls.file.setServerText(uriB, [[
local y = 2
]])
    local v5 = rt.call('RequireValue', { rt.value(uriB) })
    lt.assertEquals(v5:view(), 'never')

    -- RequireValue: 不存在的 uri 返回 never
    local v6 = rt.call('RequireValue', { rt.value 'file:///root/zzz.lua' })
    lt.assertEquals(v6:view(), 'never')

    playground:dispose()
end

print('[project.require] 测试完毕')
