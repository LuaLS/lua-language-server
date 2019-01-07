local fs = require 'bee.filesystem'

TEST(io.load(ROOT / 'src' / 'core' / 'vm.lua'))

-- 临时
local function testIfExit(path)
    local buf = io.load(fs.path(path))
    if buf then
        TEST(buf)
    end
end
testIfExit[[D:\Github\lua\testes\constructs.lua]]
