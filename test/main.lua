require 'filesystem'
ROOT = fs.current_path()
package.path = (ROOT / 'src' / '?.lua'):string()
     .. ';' .. (ROOT / 'src' / '?' / 'init.lua'):string()
     .. ';' .. (ROOT / 'test' / '?.lua'):string()
     .. ';' .. (ROOT / 'test' / '?' / 'init.lua'):string()

log = require 'log'
log.init(ROOT, ROOT / 'log' / 'test.log')
log.debug('测试开始')

require 'utility'
require 'global_protect'
local dbg = require 'debugger'
dbg:io 'listen:0.0.0.0:546858'

local function main()
    local function test(name)
        local clock = os.clock()
        print(('测试[%s]...'):format(name))
        require(name)
        print(('测试[%s]用时[%.3f]'):format(name, os.clock() - clock))
    end

    test 'definition'

    print('测试完成')
end

main()

log.debug('测试完成')
