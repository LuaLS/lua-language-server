local function unitTest(name)
    local clock = os.clock()
    print(('测试[%s]...'):format(name))
    require('parser_test.' .. name)
    print(('测试[%s]用时[%.3f]'):format(name, os.clock() - clock))
end

local function main()
    --collectgarbage 'stop'
    unitTest 'ast'
    unitTest 'grammar'
    --unitTest 'lines'
    unitTest 'grammar_check'
    unitTest 'syntax_check'
    --unitTest 'guide'
    --unitTest 'perform'

    print('测试完成')
end

main()
