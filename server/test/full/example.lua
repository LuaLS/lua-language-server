local fs = require 'bee.filesystem'
local core = require 'core'
local parser = require 'parser'

TEST(io.load(ROOT / 'src' / 'vm' / 'vm.lua'))

-- 临时
local function testIfExit(path)
    local buf = io.load(fs.path(path))
    if buf then
        local vm

        local clock = os.clock()
        local max = 100
        local need
        for i = 1, max do
            vm = TEST(buf)
            local passed = os.clock() - clock
            if passed >= 1.0 or i == max then
                need = passed / i
                break
            end
        end
        print(('基准编译测试[%s]单次耗时：%.10f'):format(path:filename():string(), need))

        local clock = os.clock()
        local max = 100
        local need
        local lines = parser:lines(buf, 'utf8')
        for i = 1, max do
            core.diagnostics(vm, lines, 'test')
            local passed = os.clock() - clock
            if passed >= 1.0 or i == max then
                need = passed / i
                break
            end
        end
        print(('基准诊断测试[%s]单次耗时：%.10f'):format(path:filename():string(), need))
    end
end
testIfExit(ROOT / 'test' / 'example' / 'vm.txt')
testIfExit(ROOT / 'test' / 'example' / 'largeGlobal.txt')
