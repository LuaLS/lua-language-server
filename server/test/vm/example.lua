local fs = require 'bee.filesystem'

TEST(io.load(ROOT / 'src' / 'core' / 'vm.lua'))

-- 临时
TEST(io.load(fs.path [[D:\Github\lua\testes\constructs.lua]]))
