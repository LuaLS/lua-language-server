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

---@param scope Scope
---@return table playground 需要 <close> 释放
local function setupAliases(scope)
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

        -- RequireValue：uri -> main return
        _ENV.alias('RequireValue')
            : param('T')
            : onValue(function (c)
                local uriNode = c.args[1]
                -- 兼容嵌套 alias：取解析后的值
                if uriNode.kind == 'call' then
                    uriNode = uriNode.value
                end
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
    return playground
end

do
    -- 验证：t.<?x?> 通过 RequireValue 类型定位到 a.lua 中 x 的定义
    local scope <close> = ls.scope.create('require-def-return-test', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')

    local uriMeta = 'file:///root/meta.lua'
    local uriA = 'file:///root/a.lua'
    local uriB = 'file:///root/b.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriB] = true

    -- 注册 RequireValue alias
    local playground = setupAliases(scope)

    -- meta 定义 require 签名
    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: string
---@param modname T
---@return RequireValue<RequireUri<T>>
function require(modname) end
]])
    -- a.lua 返回 table
    local fileA <close> = ls.file.setServerText(uriA, [[
return {
    x = 1,
}
]])
    -- b.lua 使用
    local scriptB, offsetB = parseMark [[
local t = require 'a'
print(t.<?x?>)
]]
    local fileB <close> = ls.file.setServerText(uriB, scriptB)

    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriB)

    local results = ls.feature.definition(uriB, offsetB)
    lt.assertEquals(#results, 1)
    lt.assertEquals(results[1].uri, uriA)
    -- a.lua: 'return {\n    x = 1,\n}' 中 x 位于 offset 13
    lt.assertEquals(results[1].range[1], 13)
    lt.assertEquals(results[1].range[2], 14)

    -- t 的类型应为 a.lua 的 main return
    local docB = scope:getDocument(uriB)
    local vfileB = scope.vm:getFile(uriB)
    assert(docB and vfileB)
    local tNode
    local ast = docB.ast
    if ast then
        for _, node in ipairs(ast.nodesMap['local'] or {}) do
            ---@cast node LuaParser.Node.Local
            if node.id == 't' then
                tNode = vfileB:getNode(node)
                break
            end
        end
    end
    assert(tNode)
    lt.assertEquals(tNode:view(), '{ x: 1 }')

    playground:dispose()
end

do
    -- require 'a' 的返回值无该字段时无定义结果
    local scope <close> = ls.scope.create('require-return-test-2', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')

    local uriMeta = 'file:///root/meta.lua'
    local uriA = 'file:///root/a.lua'
    local uriB = 'file:///root/b.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriB] = true

    local playground = setupAliases(scope)

    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: string
---@param modname T
---@return RequireValue<RequireUri<T>>
function require(modname) end
]])
    local fileA <close> = ls.file.setServerText(uriA, [[
return {
    x = 1,
}
]])
    local scriptB, offsetB = parseMark [[
local t = require 'a'
print(t.<?y?>)
]]
    local fileB <close> = ls.file.setServerText(uriB, scriptB)

    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriB)

    local results = ls.feature.definition(uriB, offsetB)
    lt.assertEquals(#results, 0)

    playground:dispose()
end
