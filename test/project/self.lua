do
    local root = ls.env.rootUri
    local scope = ls.scope.create(root, ls.afs)

    scope:load(function (event, status, uri)
        if event == 'found' then
            print('已发现 {found} 个文件' % status)
        end
        if event == 'loaded' then
            print('已加载 {loaded} 个文件' % status)
        end
        if event == 'indexed' then
            print('已索引 {indexed} 个文件' % status)
        end
    end)
end
