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
    local scope <close> = ls.scope.create('require-path-test-1', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    root.uriSet['file:///root/a.lua'] = true
    root.uriSet['file:///root/a/b.lua'] = true
    root.uriSet['file:///root/a/b/init.lua'] = true
    root.uriSet['file:///root/other.lua'] = true

    -- 默认 searcher：?.lua 与 ?/init.lua
    lt.assertEquals(scope:searchFiles('a'), { 'file:///root/a.lua' })
    -- a.b 同时命中 a/b.lua（?.lua）与 a/b/init.lua（?/init.lua）
    local results, searchers = scope:searchFiles('a.b')
    lt.assertEquals(#results, 2)
    lt.assertEquals(ls.util.arrayHas(results, 'file:///root/a/b.lua'), true)
    lt.assertEquals(ls.util.arrayHas(results, 'file:///root/a/b/init.lua'), true)
    -- searchers 与 uris 一一对应
    for i, uri in ipairs(results) do
        if uri == 'file:///root/a/b.lua' then
            lt.assertEquals(searchers[i], '?.lua')
        elseif uri == 'file:///root/a/b/init.lua' then
            lt.assertEquals(searchers[i], '?/init.lua')
        end
    end
    lt.assertEquals(scope:searchFiles('a.b.c'), {})
end

do
    local scope <close> = ls.scope.create('require-path-test-2', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    root.uriSet['file:///root/a.lua'] = true
    root.uriSet['file:///root/x/a.lua'] = true
    root.uriSet['file:///root/x/y/a.lua'] = true

    -- 默认 pathStrict=false：任意层级都匹配
    local results = scope:searchFiles('a')
    lt.assertEquals(#results, 3)

    -- pathStrict=true：只匹配第一层
    scope.config:set('file:///root', 'Lua.runtime.pathStrict', true)
    results = scope:searchFiles('a')
    lt.assertEquals(#results, 1)
    lt.assertEquals(results[1], 'file:///root/a.lua')
end

do
    local scope <close> = ls.scope.create('require-path-test-3', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    root.uriSet['file:///root/a/b.lua'] = true
    root.uriSet['file:///root/a/b/init.lua'] = true

    -- 自定义 searcher：?/init.lua
    scope.config:set('file:///root', 'Lua.runtime.path', { '?/init.lua' })
    lt.assertEquals(scope:searchFiles('a.b'), { 'file:///root/a/b/init.lua' })

    -- 自定义 requireSeparator
    scope.config:set('file:///root', 'Lua.completion.requireSeparator', '/')
    lt.assertEquals(scope:searchFiles('a/b'), { 'file:///root/a/b/init.lua' })
end

do
    local scope <close> = ls.scope.create('require-path-test-4', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    root.uriSet['file:///root/a.lua'] = true
    root.uriSet['file:///root/b.lua'] = true

    -- 传入当前 uri 时排除自身
    lt.assertEquals(scope:searchFiles('a', 'file:///root/a.lua'), {})
    lt.assertEquals(scope:searchFiles('a', 'file:///root/b.lua'), { 'file:///root/a.lua' })
end

do
    local scope <close> = ls.scope.create('require-path-test-5', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    root.uriSet['file:///root/aaa.lua'] = true
    root.uriSet['file:///root/x/aaa.lua'] = true
    root.uriSet['file:///root/x/y/aaa.lua'] = true
    root.uriSet['file:///root/x/y/z/aaa.lua'] = true

    -- 按距离当前 uri 排序：同层优先
    local suri = 'file:///root/x/y/aaa.lua'
    local results, searchers = scope:searchFiles('aaa', suri)
    -- 排除自身后剩 3 个：x/aaa.lua（上 1 层）、aaa.lua（上 2 层）、x/y/z/aaa.lua（下 1 层）
    lt.assertEquals(#results, 3)
    lt.assertEquals(results[1], 'file:///root/x/aaa.lua')
    lt.assertEquals(results[2], 'file:///root/x/y/z/aaa.lua')
    lt.assertEquals(results[3], 'file:///root/aaa.lua')
    -- 排序后 searchers 与 uris 仍一一对应（均命中默认 ?.lua）
    for i = 1, #results do
        lt.assertEquals(searchers[i], '?.lua')
    end
end

do
    local scope <close> = ls.scope.create('require-path-test-6', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    root.uriSet['file:///root/x/y/a.lua'] = true
    root.uriSet['file:///root/x/y/z/a.lua'] = true

    -- 同目录文件优先于子目录文件
    local results = scope:searchFiles('a', 'file:///root/x/y/main.lua')
    lt.assertEquals(results, { 'file:///root/x/y/a.lua', 'file:///root/x/y/z/a.lua' })
end

do
    -- 反向推导：getRequireNameByPath
    local scope <close> = ls.scope.create('require-path-test-7', 'file:///root')
    createRoot(scope, 'workspace', 'file:///root')

    lt.assertEquals(scope:getRequireNameByPath('a.lua', '?.lua'), 'a')
    lt.assertEquals(scope:getRequireNameByPath('a/b.lua', '?.lua'), 'a.b')
    lt.assertEquals(scope:getRequireNameByPath('a/b/init.lua', '?/init.lua'), 'a.b')
    lt.assertEquals(scope:getRequireNameByPath('a/b/init.lua', '?.lua'), 'a.b.init')
    -- 前缀不匹配返回 nil
    lt.assertEquals(scope:getRequireNameByPath('b/a.lua', 'c/?.lua'), nil)
end

do
    -- getVisiblePath：文件 -> 可能的 require 名（含 searcher）
    local scope <close> = ls.scope.create('require-path-test-8', 'file:///root')
    createRoot(scope, 'workspace', 'file:///root')

    lt.assertEquals(scope:getVisiblePath('file:///root/a.lua'), {
        { name = 'a', searcher = '?.lua' },
    })
    -- pathStrict=false：多级尝试
    lt.assertEquals(scope:getVisiblePath('file:///root/Folder/a.lua'), {
        { name = 'Folder.a', searcher = '?.lua' },
        { name = 'a',        searcher = 'Folder/?.lua' },
    })
    -- pathStrict=true：只第一层
    scope.config:set('file:///root', 'Lua.runtime.pathStrict', true)
    lt.assertEquals(scope:getVisiblePath('file:///root/Folder/a.lua'), {
        { name = 'Folder.a', searcher = '?.lua' },
    })
end

do
    -- searchFilesByPartial：部分字符 -> 匹配文件（含 searcher）
    local scope <close> = ls.scope.create('require-path-test-9', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')
    root.uriSet['file:///root/abc.lua'] = true
    root.uriSet['file:///root/abc/init.lua'] = true
    root.uriSet['file:///root/abc/bbc.lua'] = true
    root.uriSet['file:///root/zzz.lua'] = true

    local function names(results)
        return ls.util.map(results, function (r)
            return r.name
        end)
    end

    lt.assertEquals(names(scope:searchFilesByPartial('abc')), {
        'abc',      -- abc.lua（?.lua）
        'abc.bbc',  -- abc/bbc.lua（?.lua）
        'abc.init', -- abc/init.lua（?.lua）
    })
    -- 大小写不敏感
    lt.assertEquals(names(scope:searchFilesByPartial('ABC')), {
        'abc',
        'abc.bbc',
        'abc.init',
    })
    -- 无匹配
    lt.assertEquals(names(scope:searchFilesByPartial('xyz')), {})
end