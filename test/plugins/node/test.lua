local files      = require 'files'
local scope      = require 'workspace.scope'
local nodeHelper = require 'plugins.nodeHelper'
local vm         = require 'vm'
local guide      = require 'parser.guide'


local pattern, msg = nodeHelper.createFieldPattern("*.components")
assert(pattern, msg)

---@param source parser.object
function OnCompileFunctionParam(next, func, source)
    if next(func, source) then
        return true
    end
    --从该参数的使用模式来推导该类型
    if nodeHelper.matchPattern(source, pattern) then
        local type = vm.declareGlobal('type', 'TestClass', TESTURI)
        vm.setNode(source, vm.createNode(type, source))
        return true
    end
end

local myplugin = { OnCompileFunctionParam = OnCompileFunctionParam }

---@diagnostic disable: await-in-sync
local function TestPlugin(script)
    local prefix = [[
        ---@class TestClass
        ---@field b string
    ]]
    ---@param checker fun(state:parser.state)
    return function (interfaces, checker)
        files.open(TESTURI)
        files.setText(TESTURI, prefix .. script, true)
        scope.getScope(TESTURI):set('pluginInterfaces', interfaces)
        local state = files.getState(TESTURI)
        assert(state)
        checker(state)
        files.remove(TESTURI)
    end
end

TestPlugin [[
    local function t(a)
        a.components:test()
    end
]]({ myplugin }, function (state)
    guide.eachSourceType(state.ast, 'local', function (src)
        if guide.getKeyName(src) == 'a' then
            local node = vm.compileNode(src)
            assert(node)
            assert(not vm.isUnknown(node))
        end
    end)
end)
