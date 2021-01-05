local util   = require 'utility'
local parser = require 'parser'
local files  = require 'files'
local diag   = require 'core.diagnostics'
local config = require 'config'
local fs     = require 'bee.filesystem'
local luadoc = require "parser.luadoc"

-- 临时
local function testIfExit(path)
    config.config.workspace.preloadFileSize = 1000000000
    local buf = util.loadFile(path:string())
    if buf then
        local vm

        local clock = os.clock()
        local max = 100
        local need
        local parseClock = 0
        local compileClock = 0
        local luadocClock = 0
        local total
        for i = 1, max do
            vm = TEST(buf)
            local luadocStart = os.clock()
            luadoc(nil, vm)
            local luadocPassed = os.clock() - luadocStart
            local passed = os.clock() - clock
            parseClock   = parseClock + vm.parseClock
            compileClock = compileClock + vm.compileClock
            luadocClock  = luadocClock  + luadocPassed
            if passed >= 1.0 or i == max then
                need = passed / i
                total = i
                break
            end
        end
        print(('基准编译测试[%s]单次耗时：%.10f(解析：%.10f, 编译：%.10f, LuaDoc: %.10f)'):format(
            path:filename():string(),
            need,
            parseClock / total,
            compileClock / total,
            luadocClock / total
        ))

        local clock = os.clock()
        local max = 100
        local need
        local lines = parser:lines(buf)
        for i = 1, max do
            files.removeAll()
            files.open('')
            files.setText('', buf)
            diag('', function () end)
            local passed = os.clock() - clock
            if passed >= 1.0 or i == max then
                need = passed / i
                break
            end
        end
        print(('基准诊断测试[%s]单次耗时：%.10f'):format(path:filename():string(), need))
    end
end

require 'tracy' .enable()
testIfExit(ROOT / 'test' / 'example' / 'vm.txt')
testIfExit(ROOT / 'test' / 'example' / 'largeGlobal.txt')
testIfExit(ROOT / 'test' / 'example' / 'guide.txt')
testIfExit(fs.path [[D:\github\test\ECObject.lua]])
