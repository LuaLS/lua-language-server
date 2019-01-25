local fs = require 'bee.filesystem'

TEST(io.load(ROOT / 'src' / 'core' / 'vm.lua'))

-- 临时
local function testIfExit(path)
    local buf = io.load(fs.path(path))
    if buf then
        local clock = os.clock()
        for _ = 1, 10 do
            TEST(buf)
        end
        print('基准测试耗时：', os.clock() - clock)
    end
end
testIfExit(ROOT / 'test' / 'example' / 'vm.lua')
