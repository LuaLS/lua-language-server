local root = arg[0] .. '\\..\\..'
package.path = package.path .. ';' .. root .. '\\src\\?.lua'
                            .. ';' .. root .. '\\src\\?\\init.lua'
                            .. ';' .. root .. '\\?.lua'
                            .. ';' .. root .. '\\?\\init.lua'

local fs = require 'bee.filesystem'

rawset(_G, 'ROOT', fs.path(root))

local function unitTest(name)
    local clock = os.clock()
    print(('测试[%s]...'):format(name))
    require('test.' .. name)
    print(('测试[%s]用时[%.3f]'):format(name, os.clock() - clock))
end

local function main()
    unitTest 'ast'
    unitTest 'grammar'
    unitTest 'syntax_check'
    unitTest 'perform'

    print('测试完成')
end

main()
