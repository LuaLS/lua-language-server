local fs = require 'bee.filesystem'
local thread = require 'bee.thread'
local parser = require 'parser'
local utility = require 'utility'

thread.newchannel 'TEST'
local ch = thread.channel 'TEST'

local function scanDirectory(path)
    local files = {}

    local function scan(path)
        if fs.is_directory(path) then
            for path in fs.pairs(path) do
                scan(path)
            end
        else
            files[#files+1] = path
        end
    end

    scan(path)

    local i = 0
    return function ()
        i = i + 1
        return files[i]
    end
end

local function performTest()
    local targetPath = ROOT
    local files = {}
    local size = 0
    for path in scanDirectory(targetPath) do
        if path:extension():string() == '.lua' then
            local buf = utility.loadFile(path:string())
            files[path] = buf
            size = size + #buf
        end
    end
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
    print(('综合性能测试完成，总大小[%.3f]kb，速度[%.3f]mb/s，用时[%.3f]秒'):format(size / 1000, size / passed / 1000 / 1000, passed))
end

local function test(path)
    local buf = utility.loadFile(path)
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
test[[test\perform\1.txt]]
test[[test\perform\2.txt]]
test[[test\perform\3.txt]]
test[[test\perform\4.txt]]
test[[test\perform\5.txt]]
test[[test\perform\6.txt]]
test[[test\perform\7.txt]]
performTest()
collectgarbage 'restart'
