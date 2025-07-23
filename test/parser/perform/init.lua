local thread = require 'bee.thread'
local parser = require 'parser'

local function performTest()
    local targetPath = ls.env.rootPath
    local files = {}
    local size = 0
    ls.fsu.scanDirectory(targetPath, function (fullPath)
        if fullPath:extension() == '.lua' then
            local buf = ls.fsu.loadFile(fullPath)
            files[fullPath] = buf
            size = size + #buf
        end
    end)
    print(string.format('已收集[%d]个文件，总大小[%.3f]mb'
        , ls.util.countTable(files)
        , size / 1000 / 1000
    ))
    local clock = os.clock()
    for path, buf in pairs(files) do
        local ast = parser.compile(buf, 'Lua 5.4')
        if not ast then
            error(('文件解析失败：%s'):format(path:string()))
        end
        --local dump = utility.unpack(state.root)
        --utility.pack(dump)

        --ch:push(dump)
        --ch:pop()
    end
    local passed = os.clock() - clock
    print(('综合性能测试完成，总大小[%.3f]mb，速度[%.3f]mb/s，用时[%.3f]秒'):format(size / 1000 / 1000, size / passed / 1000 / 1000, passed))
end

local function test(path)
    local buf = ls.util.loadFile(ls.env.rootPath .. '/test/parser/perform/' .. path)
    if not buf then
        return
    end
    local testTimes = 10
    local ast
    local clock = os.clock()
    for i = 1, testTimes do
        ast = parser.compile(buf, 'Lua 5.4')
        if not ast then
            error(('文件解析失败：%s'):format(path:string()))
        end
        if os.clock() - clock > 1.0 then
            testTimes = i
            break
        end
    end
    local passed = os.clock() - clock

    --local clock = os.clock()
    --local dump = utility.unpack(state.ast)
    --utility.pack(dump)
    --local unpackPassed = os.clock() - clock

    --local clock = os.clock()
    --ch:push(dump)
    --ch:pop()
    --local channelPassed = os.clock() - clock

    local size = #buf * testTimes
    print(('[%s]测试完成，大小[%.3f]kb，速度[%.3f]mb/s，平均用时[%.3f]毫秒'):format(path, size / testTimes / 1000, size / passed / 1000 / 1000, passed / testTimes * 1000))
end

collectgarbage 'stop'
test[[1.txt]]
test[[2.txt]]
test[[3.txt]]
test[[4.txt]]
test[[5.txt]]
test[[6.txt]]
test[[7.txt]]
performTest()
collectgarbage 'restart'
