---@diagnostic disable: invisible

local function createRoot(scope, uri, fs)
    local root = New 'Scope.Root' (scope, 'workspace', uri, fs, scope.config)
    scope.roots[#scope.roots+1] = root
    return root
end

do
    local scope <close> = ls.scope.create('ignore-test', 'file:///ignore-root')

    local files = {
        ['file:///ignore-root/root.lua']         = '',
        ['file:///ignore-root/meta/x.lua']        = '',
        ['file:///ignore-root/script/y.lua']      = '',
        ['file:///ignore-root/script/meta/x.lua'] = '',
    }
    local dirs = {
        ['file:///ignore-root']             = { 'file:///ignore-root/root.lua', 'file:///ignore-root/meta', 'file:///ignore-root/script' },
        ['file:///ignore-root/meta']        = { 'file:///ignore-root/meta/x.lua' },
        ['file:///ignore-root/script']      = { 'file:///ignore-root/script/y.lua', 'file:///ignore-root/script/meta' },
        ['file:///ignore-root/script/meta'] = { 'file:///ignore-root/script/meta/x.lua' },
    }
    local fs = {}
    function fs.getType(uri)
        if dirs[uri] then
            return 'directory'
        end
        return 'file'
    end
    function fs.getChilds(uri)
        return dirs[uri]
    end
    function fs.read(uri)
        return files[uri]
    end

    scope.config:set('file:///ignore-root', 'Lua.workspace.ignoreDir', { '/meta' })

    local root = createRoot(scope, 'file:///ignore-root', fs)

    local found = {}
    root:load(root.uri, {}, function (event, _, uri)
        if event == 'finding' then
            found[#found+1] = uri
        end
    end)

    table.sort(found)
    lt.assertEquals(found, {
        'file:///ignore-root/root.lua',
        'file:///ignore-root/script/meta/x.lua',
        'file:///ignore-root/script/y.lua',
    })

    scope.config:set('file:///ignore-root', 'Lua.workspace.ignoreDir', { 'meta' })

    local root2 = createRoot(scope, 'file:///ignore-root', fs)

    local found2 = {}
    root2:load(root2.uri, {}, function (event, _, uri)
        if event == 'finding' then
            found2[#found2+1] = uri
        end
    end)

    table.sort(found2)
    lt.assertEquals(found2, {
        'file:///ignore-root/root.lua',
        'file:///ignore-root/script/y.lua',
    })

    scope.config:set('file:///ignore-root', 'Lua.workspace.ignoreDir', nil)
end
