local parser = require 'parser'
local lexer = require 'parser.lexer'

---@param uris Uri[]
local function testSyncTime(uris)
    local c1 = os.clock()
    ---@type Coder[]
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
    print('总大小为: {%.2f} MB，索引总时间为: {%.2f} 秒，速度： {%.2f} MB/s' % {
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
    print('总大小为: {%.2f} MB，索引总时间为: {%.2f} 秒，速度： {%.2f} MB/s' % {
        totalSize,
        duration,
        totalSize / duration,
    })
end

local function testLexerTime(uris)
    local c1 = os.clock()
    local refs = {}
    for _, uri in ipairs(uris) do
        local file = ls.file.get(uri) --[[@as File]]
        refs[#refs+1] = lexer.new():parse(assert(file:getText()))
    end
    local c2 = os.clock()
    local duration = c2 - c1

    assert(#refs == #uris)

    local totalSize = 0
    for _, uri in ipairs(uris) do
        totalSize = totalSize + ls.file.get(uri):getText():len() / 1024 / 1024
    end
    print('=== 词法解析 ===')
    print('总大小为: {%.2f} MB，解析总时间为: {%.2f} 秒，速度： {%.2f} MB/s' % {
        totalSize,
        duration,
        totalSize / duration,
    })
end

local function testParserTime(uris)
    local c1 = os.clock()
    local refs = {}
    for _, uri in ipairs(uris) do
        local file = ls.file.get(uri) --[[@as File]]
        refs[#refs+1] = parser.compile(assert(file:getText()), uri)
    end
    local c2 = os.clock()
    local duration = c2 - c1

    assert(#refs == #uris)

    local totalSize = 0
    for _, uri in ipairs(uris) do
        totalSize = totalSize + ls.file.get(uri):getText():len() / 1024 / 1024
    end
    print('=== 语法解析 ===')
    print('总大小为: {%.2f} MB，解析总时间为: {%.2f} 秒，速度： {%.2f} MB/s' % {
        totalSize,
        duration,
        totalSize / duration,
    })
end

do
    local root = ls.env.ROOT_URI
    local scope <close> = ls.scope.create('test', root, ls.afs)

    collectgarbage()
    print('加载项目前的内存为： {%.2f} MB' % { collectgarbage 'count' / 1024 })

    local result = scope:load({
        ignores = {
            'log',
        }
    }, function (event, status, uri)
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

    local size = 0
    for _, uri in ipairs(result.uris) do
        local doc = scope:getDocument(uri)
        if doc then
            size = size + doc.file:getText():len() / 1024 / 1024
        end
    end
    print('文件数量为： {}，总大小为： {%.2f} MB' % { #result.uris, size })

    collectgarbage()
    local mem = collectgarbage 'count' / 1024
    print('索引后的内存为： {%.2f} MB (×{%.2f})' % { mem, mem / size })

    for _, uri in ipairs(scope.uris) do
        local document = scope:getDocument(uri)
        document.ast = nil
    end

    collectgarbage()
    mem = collectgarbage 'count' / 1024
    print('去除语法树后的内存为： {%.2f} MB (×{%.2f})' % { mem, mem / size })

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
    print('全量解析后的内存为： {%.2f} MB (×{%.2f})' % { mem, mem / size })

    ls.util.withDuration(function ()
        for _, uri in ipairs(result.uris) do
            local vfile = scope.vm:getFile(uri)
            if vfile then
                vfile:remove()
            end
        end
    end, function (duration)
        print('释放所有文件耗时: {%.2f} 秒' % { duration })
    end)

    testSyncTime(result.uris)
    testAsyncTime(result.uris)
    testLexerTime(result.uris)
    testParserTime(result.uris)
end
