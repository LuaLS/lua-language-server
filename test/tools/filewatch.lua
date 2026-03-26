local filewatch = require 'tools.filewatch'
local fs        = require 'bee.filesystem'
local thread    = require 'bee.thread'

print('正在测试 filewatch ...')

local function createFile(path, content)
    local f = assert(io.open(path, 'wb'))
    if content then
        f:write(content)
    end
    f:close()
end

--- Poll filewatch repeatedly to collect async OS events
local function waitForEvents(ms)
    ms = ms or 300
    local t0 = os.clock()
    while (os.clock() - t0) * 1000 < ms do
        filewatch.update()
        thread.sleep(10)
    end
    filewatch.update()
end

--- Check if any collected event matches a path substring
local function hasEventFor(events, pathPart, eventType)
    for _, e in ipairs(events) do
        if e.path:find(pathPart, 1, true) then
            if not eventType or e.event == eventType then
                return true
            end
        end
    end
    return false
end

-- Test 1: basic file creation
do
    local root = fs.absolute('./temp_fw_test1/'):lexically_normal()
    pcall(fs.remove_all, root)
    fs.create_directories(root)

    local events = {}
    local w = filewatch.watch(root:string(), function (path, event)
        events[#events + 1] = { path = path, event = event }
    end):recursive(true)

    -- 第一次 update 触发初始化，之后的文件变化才会被捕获
    filewatch.update()

    createFile((root / 'hello.txt'):string(), 'hello')
    waitForEvents()

    assert(hasEventFor(events, 'hello.txt'),
        'expected event for hello.txt creation')

    w:dispose()
    pcall(fs.remove_all, root)
    print('  test 1 基本创建事件  ✓')
end

-- Test 2: delete event
do
    local root = fs.absolute('./temp_fw_test2/'):lexically_normal()
    pcall(fs.remove_all, root)
    fs.create_directories(root)

    -- pre-create the file so the watcher sees a delete
    createFile((root / 'bye.txt'):string(), 'bye')

    local events = {}
    local w = filewatch.watch(root:string(), function (path, event)
        events[#events + 1] = { path = path, event = event }
    end):recursive(true)

    -- let the watcher start, then drain any creation noise
    waitForEvents()
    events = {}

    fs.remove(root / 'bye.txt')
    waitForEvents()

    assert(hasEventFor(events, 'bye.txt', 'delete'),
        'expected delete event for bye.txt')

    w:dispose()
    pcall(fs.remove_all, root)
    print('  test 2 删除事件      ✓')
end

-- Test 3: modify event
do
    local root = fs.absolute('./temp_fw_test3/'):lexically_normal()
    pcall(fs.remove_all, root)
    fs.create_directories(root)

    createFile((root / 'mod.txt'):string(), 'v1')

    local events = {}
    local w = filewatch.watch(root:string(), function (path, event)
        events[#events + 1] = { path = path, event = event }
    end):recursive(true)

    -- drain initial noise
    waitForEvents()
    events = {}

    -- modify the existing file
    createFile((root / 'mod.txt'):string(), 'v2')
    waitForEvents()

    assert(hasEventFor(events, 'mod.txt'),
        'expected event for mod.txt modification')

    w:dispose()
    pcall(fs.remove_all, root)
    print('  test 3 修改事件      ✓')
end

-- Test 4: event filter – only 'delete'
do
    local root = fs.absolute('./temp_fw_test4/'):lexically_normal()
    pcall(fs.remove_all, root)
    fs.create_directories(root)

    createFile((root / 'f.txt'):string(), '')

    local events = {}
    local w = filewatch.watch(root:string(), function (path, event)
        events[#events + 1] = { path = path, event = event }
    end):recursive(true):event('delete')

    waitForEvents()
    events = {}

    -- create a new file (should NOT be reported)
    createFile((root / 'g.txt'):string(), 'data')
    waitForEvents()

    for _, e in ipairs(events) do
        assert(e.event == 'delete',
            'expected only delete events, got ' .. e.event)
    end

    w:dispose()
    pcall(fs.remove_all, root)
    print('  test 4 事件过滤      ✓')
end

-- Test 5: glob pattern filtering – only *.lua files
do
    local root = fs.absolute('./temp_fw_test5/'):lexically_normal()
    pcall(fs.remove_all, root)
    fs.create_directories(root)
    fs.create_directories(root / 'sub')

    local pathGlob = root:string():gsub('\\', '/') .. '**/*.lua'
    local events = {}
    local w = filewatch.watch(pathGlob, function (path, event)
        events[#events + 1] = { path = path, event = event }
    end):recursive(true)

    filewatch.update()

    createFile((root / 'sub' / 'a.lua'):string(), 'return 1')
    createFile((root / 'sub' / 'b.txt'):string(), 'nope')
    waitForEvents()

    -- all reported paths must be .lua
    for _, e in ipairs(events) do
        assert(e.path:match('%.lua$') or e.path:match('%.lua/'),
            'unexpected non-lua event: ' .. e.path)
    end
    assert(hasEventFor(events, 'a.lua'),
        'expected event for a.lua')

    w:dispose()
    pcall(fs.remove_all, root)
    print('  test 5 glob 过滤     ✓')
end

-- Test 6: dispose stops delivery
do
    local root = fs.absolute('./temp_fw_test6/'):lexically_normal()
    pcall(fs.remove_all, root)
    fs.create_directories(root)

    local events = {}
    local w = filewatch.watch(root:string(), function (path, event)
        events[#events + 1] = { path = path, event = event }
    end):recursive(true)

    w:dispose()

    createFile((root / 'nope.txt'):string(), 'x')
    waitForEvents()

    assert(#events == 0,
        'expected no events after dispose, got ' .. #events)

    pcall(fs.remove_all, root)
    print('  test 6 dispose       ✓')
end

-- Test 7: recursive subdirectory events
do
    local root = fs.absolute('./temp_fw_test7/'):lexically_normal()
    pcall(fs.remove_all, root)
    fs.create_directories(root)

    local events = {}
    local w = filewatch.watch(root:string(), function (path, event)
        events[#events + 1] = { path = path, event = event }
    end):recursive(true)

    filewatch.update()

    fs.create_directories(root / 'deep' / 'nested')
    createFile((root / 'deep' / 'nested' / 'file.txt'):string(), '!')
    waitForEvents()

    assert(hasEventFor(events, 'file.txt'),
        'expected event for deeply nested file')

    w:dispose()
    pcall(fs.remove_all, root)
    print('  test 7 递归子目录    ✓')
end

-- Test 8: global config applies to new watchers
do
    local root = fs.absolute('./temp_fw_test8/'):lexically_normal()
    pcall(fs.remove_all, root)
    fs.create_directories(root)

    filewatch.recursive(true)

    local events = {}
    local w = filewatch.watch(root:string(), function (path, event)
        events[#events + 1] = { path = path, event = event }
    end) -- no explicit :recursive(true)

    filewatch.update()

    fs.create_directories(root / 'child')
    createFile((root / 'child' / 'x.txt'):string(), 'hi')
    waitForEvents()

    assert(hasEventFor(events, 'x.txt'),
        'expected event via global recursive setting')

    filewatch.recursive(false) -- restore default
    w:dispose()
    pcall(fs.remove_all, root)
    print('  test 8 全局配置      ✓')
end

print('filewatch 全部测试通过')
