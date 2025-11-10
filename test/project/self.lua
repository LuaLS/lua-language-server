do
    local root = ls.env.ROOT_URI
    local scope <close> = ls.scope.create(root, ls.afs)

    collectgarbage()
    print('加载项目前的内存为： {:.2f} MB' % { collectgarbage 'count' / 1024 })

    local result = scope:load(function (event, status, uri)
        if event == 'found' then
            print('已发现 {found} 个文件' % status)
        end
        if event == 'loading' then
            local ast = scope:getDocument(uri).ast
            assert(ast)
            local err = ast.errors[1]
            assert(err == nil, err and err.where)
        end
        if event == 'loaded' then
            print('已加载 {loaded} 个文件' % status)
        end
        if event == 'indexed' then
            print('已索引 {indexed} 个文件' % status)
        end
    end)

    collectgarbage()
    print('索引后的内存为： {:.2f} MB' % { collectgarbage 'count' / 1024 })

    for _, uri in ipairs(scope.uris) do
        local document = scope:getDocument(uri)
        document.ast = nil
    end

    collectgarbage()
    print('去除语法树后的内存为： {:.2f} MB' % { collectgarbage 'count' / 1024 })

    local c1 = os.clock()
    local count = 0
    for _, uri in ipairs(result.uris) do
        local doc = scope:getDocument(uri)
        local vfile = scope.vm:getFile(uri)
        ---@cast doc -?
        ---@cast vfile -?
        for _, nodes in pairs(doc.ast.nodesMap) do
            for _, src in ipairs(nodes) do
                vfile:getNode(src)
                count = count + 1
            end
        end
    end
    local c2 = os.clock()

    local duration = c2 - c1
    print('解析 {} 个token耗时: {:.2f} 秒' % { count, duration })

    collectgarbage()
    print('全量解析后的内存为： {:.2f} MB' % { collectgarbage 'count' / 1024 })
end
