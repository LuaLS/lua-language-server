-- 外部项目加载测试
-- 用法：bin\lua-language-server.exe --test project.external --test_project=D:/your/project
--
-- 若未传入 --test_project 则跳过此测试。

local projectPath = ls.args.TEST_PROJECT
if projectPath == '' or type(projectPath) ~= 'string' then
    return
end

do
    local rootUri = ls.uri.encode(projectPath)
    local scope <close> = ls.scope.create('external', rootUri, ls.afs)

    collectgarbage()
    print('项目路径：' .. projectPath)
    print('加载前内存：{%.2f} MB' % { collectgarbage 'count' / 1024 })

    local c1 = os.clock()

    local result = scope:load({}, function (event, status, uri)
        if event == 'scanning' then
            if status.scanned % 100 == 0 then
                print('正在扫描... 已扫描 {scanned} 个文件' % status)
            end
        end
        if event == 'found' then
            print('已发现 {found} 个文件' % status)
        end
        if event == 'loading' then
            local doc = scope:getDocument(uri)
            if doc then
                local ast = doc.ast
                assert(ast, 'AST 为 nil：' .. tostring(uri))
            end
            if status.loaded % 100 == 0 then
                print('正在加载... 已加载 {loaded} 个文件' % status)
            end
        end
        if event == 'loaded' then
            print('已加载 {loaded} 个文件' % status)
        end
        if event == 'indexed' then
            print('已索引 {indexed} 个文件' % status)
        end
    end)

    local c2 = os.clock()
    local duration = c2 - c1

    local totalSize = 0
    for _, uri in ipairs(result.uris) do
        local doc = scope:getDocument(uri)
        if doc then
            totalSize = totalSize + doc.file:getText():len() / 1024 / 1024
        end
    end

    print('文件数量：{}，总大小：{%.2f} MB，耗时：{%.2f} 秒，速度：{%.2f} MB/s' % {
        #result.uris,
        totalSize,
        duration,
        totalSize / math.max(duration, 0.001),
    })

    collectgarbage()
    local mem = collectgarbage 'count' / 1024
    print('加载后内存：{%.2f} MB (×{%.2f})' % { mem, mem / math.max(totalSize, 0.001) })

    local count = 0
    ls.util.withDuration(function ()
        for _, uri in ipairs(result.uris) do
            local doc = scope:getDocument(uri)
            local vfile = scope.vm:getFile(uri)
            ---@cast doc -?
            ---@cast vfile -?
            for _, nodes in pairs(doc.ast.nodesMap) do
                for _, src in ipairs(nodes) do
                    local node = vfile:getNode(src)
                    if node then
                        local _ = node.value
                    end
                    count = count + 1
                end
            end
        end
    end, function (duration)
        print('解析 {} 个token耗时: {%.2f} 秒 ({%.2f}K/秒)' % { count, duration, count / duration / 1000})
    end)

    collectgarbage()
    mem = collectgarbage 'count' / 1024
    print('全量解析后的内存为： {%.2f} MB (×{%.2f})' % { mem, mem / totalSize })
end
