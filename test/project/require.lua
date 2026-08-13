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
    -- 验证方案 A：显式泛型 + alias 类型调用是否已可行
    test.scope.rt:reset()
    local rt = test.scope.rt
    local playground = ls.custom.playground(test.scope)
    do
        local _ENV = playground.env
        _ENV.alias('Module')
            : param('T')
            : onValue(function (c)
                local arg = c.args[1]
                if arg.kind == 'value' and type(arg.literal) == 'string' then
                    return c.value('M:' .. arg.literal)
                end
                return c.type 'never'
            end)
    end

    -- ---@generic T: string
    -- ---@param modname T
    -- ---@return Module<T>
    local T = rt.generic('T', rt.STRING)
    local requireFunc = rt.func()
        : addTypeParam(T)
        : addParamDef('modname', T)
        : addReturnDef(nil, rt.call('Module', { T }))

    -- require('a.b') 调用
    local call = rt.fcall(requireFunc, { rt.value 'a.b' })
    lt.assertEquals(call.value:view(), '"M:a.b"')
    playground:dispose()
end

do
    local scope <close> = ls.scope.create('require-test-1', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    root.uriSet['file:///root/a.lua'] = true
    root.uriSet['file:///root/a/b.lua'] = true

    local playground = ls.custom.playground(scope)
    do
        local _ENV = playground.env

        -- Module：modname -> 该模块文件根 return 的第一个值
        _ENV.alias('Module')
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
                local vfile = c.scope.vm:indexFile(uris[1])
                local ret = vfile:getMainReturn()
                if not ret then
                    return c.type 'never'
                end
                return ret
            end)
    end

    -- a.lua 返回 table
    local uriA = 'file:///root/a.lua'
    local fileA <close> = ls.file.setServerText(uriA, [[
local t = { x = 1 }
return t
]])
    -- a/b.lua 无 return
    local uriB = 'file:///root/a/b.lua'
    local fileB <close> = ls.file.setServerText(uriB, [[
local y = 2
]])

    local rt = scope.rt
    -- Module: modname='a' -> a.lua 的 main return
    local v = rt.call('Module', { rt.value 'a' })
    lt.assertEquals(v:view(), '{ x: 1 }')

    -- Module: modname='a.b' -> a/b.lua 无 return -> never
    local v2 = rt.call('Module', { rt.value 'a.b' })
    lt.assertEquals(v2:view(), 'never')

    -- Module: 无匹配返回 never
    local v3 = rt.call('Module', { rt.value 'zzz' })
    lt.assertEquals(v3:view(), 'never')

    playground:dispose()
end

do
    -- 验证循环 require 不会导致 RequireValue 回调无限递归
    local scope <close> = ls.scope.create('require-cycle-test', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    local uriA = 'file:///root/a.lua'
    local uriB = 'file:///root/b.lua'
    root.uriSet[uriA] = true
    root.uriSet[uriB] = true

    local fileMeta <close> = ls.file.setServerText('file:///root/meta.lua', [==[
--[[@@@
alias 'Module'
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
        local vfile = c.scope.vm:indexFile(uris[1])
        local ret = vfile:getMainReturn()
        if not ret then
            return c.type 'never'
        end
        return ret
    end)
]]
]==])
    -- a 依赖 b，b 依赖 a（循环 require）
    local fileA <close> = ls.file.setServerText(uriA, [[
local b = require 'b'
return b
]])
    local fileB <close> = ls.file.setServerText(uriB, [[
local a = require 'a'
return a
]])
    root.uriSet['file:///root/meta.lua'] = true
    scope.vm:indexFile('file:///root/meta.lua')
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriB)

    -- 循环 require（a->b->a）不会导致 Module 回调无限递归
    local ra = scope.rt.call('Module', { scope.rt.value 'a' })
    lt.assertEquals(ra:view() ~= nil, true)
    local rb = scope.rt.call('Module', { scope.rt.value 'b' })
    lt.assertEquals(rb:view() ~= nil, true)
end

do
    -- 验证 meta/template/package.lua 用 --[[@@@ cat block 定义 Module，
    -- 编译后的 meta 保留该块，index 后 alias 自动注册
    local metaBuilder = require 'scope.meta-builder'
    local metaUri = metaBuilder.compile('Lua 5.5', 'zh-cn', 'utf-8')
    local content = ls.afs.read(metaUri / 'package.lua')
    assert(content)
    lt.assertEquals(content:find('--[[@@@', 1, true) ~= nil, true)
    lt.assertEquals(content:find("alias 'Module'", 1, true) ~= nil, true)

    local scope <close> = ls.scope.create('require-meta-test', 'file:///root')
    local root = createRoot(scope, 'meta', metaUri)
    local uriPackage = metaUri / 'package.lua'
    root.uriSet[uriPackage] = true

    -- meta 编译产物通过文档系统注册后 index（模拟真实加载）
    local filePackage <close> = ls.file.setServerText(uriPackage, content)

    local uriA = 'file:///root/a.lua'
    root.uriSet[uriA] = true
    local fileA <close> = ls.file.setServerText(uriA, [[
return {
    x = 1,
}
]])

    scope.vm:indexFile(uriPackage)
    scope.vm:indexFile(uriA)

    -- Module 的 custom alias 已注册
    local function hasCustomAlias(name)
        local t = scope.rt.type(name)
        if t.aliases then
            for _, alias in ipairs(t.aliases) do
                if alias.customValue then
                    return true
                end
            end
        end
        return false
    end
    lt.assertEquals(hasCustomAlias 'Module', true)

    -- Module：modname -> main return
    local v = scope.rt.call('Module', { scope.rt.value 'a' })
    lt.assertEquals(v:view(), '{ x: 1 }')
end

do
    -- require 使用调用点过滤自身文件，并按距离优先匹配最近的同名文件
    local scope <close> = ls.scope.create('require-location-test', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    local uriA = 'file:///root/a.lua'
    local uriSubA = 'file:///root/sub/a.lua'
    local uriX = 'file:///root/x.lua'
    local uriSubX = 'file:///root/sub/x.lua'
    root.uriSet[uriA] = true
    root.uriSet[uriSubA] = true
    root.uriSet[uriX] = true
    root.uriSet[uriSubX] = true

    -- 同名文件返回不同值，用于区分匹配到的是哪一个
    local fileA <close> = ls.file.setServerText(uriA, 'return 1')
    local fileSubA <close> = ls.file.setServerText(uriSubA, 'return 2')
    local fileX <close> = ls.file.setServerText(uriX, 'return 3')
    local fileSubX <close> = ls.file.setServerText(uriSubX, 'return 4')

    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriSubA)
    scope.vm:indexFile(uriX)
    scope.vm:indexFile(uriSubX)

    local playground = ls.custom.playground(scope)
    do
        local _ENV = playground.env

        _ENV.alias('Module')
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
                local suri = c.location and c.location.uri
                local uris = c.scope:searchFiles(literal, suri)
                if #uris == 0 then
                    return c.type 'never'
                end
                local vfile = c.scope.vm:getFile(uris[1])
                if not vfile then
                    return c.type 'never'
                end
                local ret = vfile:getMainReturn()
                if not ret then
                    return c.type 'never'
                end
                return ret
            end)
    end

    local rt = scope.rt
    local T = rt.generic('T', rt.STRING)
    local requireFunc = rt.func()
        : addTypeParam(T)
        : addParamDef('modname', T)
        : addReturnDef(nil, rt.call('Module', { T }))

    local function requireAt(modname, uri)
        local call = rt.fcall(requireFunc, { rt.value(modname) })
        call:setLocation({ uri = uri, offset = 0, length = 0 })
        return call
    end

    -- 不会 require 到自己所在的文件：排除自身后匹配到另一个同名文件
    lt.assertEquals(requireAt('a', uriA).value:view(), '2')
    lt.assertEquals(requireAt('a', uriSubA).value:view(), '1')

    -- 不同文件中 require 同名模块，结果不同（最近文件优先）
    lt.assertEquals(requireAt('x', 'file:///root/main.lua').value:view(), '3')
    lt.assertEquals(requireAt('x', 'file:///root/sub/main.lua').value:view(), '4')

    playground:dispose()
end

print('[project.require] 测试完毕')
