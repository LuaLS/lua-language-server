local parser = require 'parser'

---@param uris Uri[]
local function testSyncTime(uris)
    local c1 = os.clock()
    ---@type VM.Coder[]
    local coders = {}
    for _, uri in ipairs(uris) do
        local file = ls.file.get(uri) --[[@as File]]
        local ast = parser.compile(file:getText()--[[@as string]], uri)
        local coder = ls.vm.createCoder()
        coder:makeFromAst(ast)
        coders[#coders+1] = coder
    end
    local c2 = os.clock()
    local duration = c2 - c1

    assert(#coders == #uris)
    for _, coder in ipairs(coders) do
        assert(coder.func)
    end

    local totalSize = 0
    for _, uri in ipairs(uris) do
        totalSize = totalSize + ls.file.get(uri):getText():len() / 1024 / 1024
    end
    print('=== 同步解析 ===')
    print('总大小为: {:.2f} MB，索引总时间为: {:.2f} 秒，速度： {:.2f} MB/s' % {
        totalSize,
        duration,
        totalSize / duration,
    })
end

---@param uris Uri[]
---@async
local function testAsyncTime(uris)
    local c1 = os.clock()
    local coders = {}
    local tasks = {}
    for _, uri in ipairs(uris) do
        ---@async
        tasks[#tasks+1] = function ()
            local file = ls.file.get(uri) --[[@as File]]
            local coder = ls.vm.createCoder()
            coder:makeFromFile(file)
            coders[#coders+1] = coder
        end
    end
    ls.await.waitAll(tasks)
    local c2 = os.clock()
    local duration = c2 - c1

    assert(#coders == #uris)
    for _, coder in ipairs(coders) do
        assert(coder.func)
    end

    local totalSize = 0
    for _, uri in ipairs(uris) do
        totalSize = totalSize + ls.file.get(uri):getText():len() / 1024 / 1024
    end
    print('=== 异步解析 ===')
    print('总大小为: {:.2f} MB，索引总时间为: {:.2f} 秒，速度： {:.2f} MB/s' % {
        totalSize,
        duration,
        totalSize / duration,
    })
end

do
    local root = ls.env.ROOT_URI
    local scope <close> = ls.scope.create('test', root, ls.afs)

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

    testSyncTime(result.uris)
    testAsyncTime(result.uris)
end
