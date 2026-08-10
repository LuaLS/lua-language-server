print('[project.require-cache] 测试中...')

---@param scope Scope
---@param kind string
---@param uri Uri
---@return Scope.Root
local function createRoot(scope, kind, uri)
    local root = New 'Scope.Root' (scope, kind, uri, scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    return root
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
                -- 解析结果依赖 Scope 的文件集合：注册 alias 节点，Scope 增删文件时刷新
                c.scope:addRef(c.node)
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
    -- 工作区加载中 uriSet 不全时缓存的 require 结果，加载完成后必须失效重新解析
    -- A: log/init.lua（?/init.lua 命中，排在后）
    -- B: log.lua（?.lua 命中，排在前）
    -- 加载中只有 A，require 'log' 解析到 A；B 加入后应重新解析到 B
    local scope <close> = ls.scope.create('require-cache-test', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')

    local uriMeta = 'file:///root/meta.lua'
    local uriA    = 'file:///root/log/init.lua'
    local uriB    = 'file:///root/log.lua'
    local uriC    = 'file:///root/c.lua'

    -- 加载中：uriSet 只有 A
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriC] = true

    local playground = setupAliases(scope)

    -- meta 定义 require 签名
    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: string
---@param modname T
---@return RequireValue<RequireUri<T>>
function require(modname) end
]])
    -- A 返回 'A'，B 返回 'B'
    local fileA <close> = ls.file.setServerText(uriA, [[
return 'A'
]])
    local fileC <close> = ls.file.setServerText(uriC, [[
local log = require 'log'
]])
    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriC)

    -- 读取 c.lua 中 log 变量的类型
    local function getLogValue()
        local doc = scope:getDocument(uriC)
        local vfile = scope.vm:getFile(uriC)
        assert(doc and vfile)
        for _, node in ipairs(doc.ast.nodesMap['local'] or {}) do
            ---@cast node LuaParser.Node.Local
            if node.id == 'log' then
                return vfile:getNode(node):view()
            end
        end
        error('not found log')
    end

    -- 第一次访问：uriSet 只有 A，解析到 A
    lt.assertEquals(getLogValue(), "'A'")

    -- 工作区加载完成：B 加入（生产环境 loadFiles 扫描到新文件时会调用 scope:flushCache）
    root.uriSet[uriB] = true
    scope:flushCache()
    local fileB <close> = ls.file.setServerText(uriB, [[
return 'B'
]])
    scope.vm:indexFile(uriB)

    -- 第二次访问：缓存应失效，重新解析到 B
    lt.assertEquals(getLogValue(), "'B'")

    playground:dispose()
end

print('[project.require-cache] 测试完毕')
