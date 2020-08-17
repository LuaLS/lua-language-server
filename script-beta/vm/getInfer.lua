local vm      = require 'vm.vm'
local guide   = require 'parser.guide'
local util    = require 'utility'

NIL = setmetatable({'<nil>'}, { __tostring = function () return 'nil' end })

--- 是否包含某种类型
function vm.hasType(source, type)
    local infers = vm.getInfers(source)
    for i = 1, #infers do
        local infer = infers[i]
        if infer.type == type then
            return true
        end
    end
    return false
end

function vm.getType(source)
    local infers = vm.getInfers(source)
    return guide.viewInfer(infers)
end

--- 获取对象的值
--- 会尝试穿透函数调用
function vm.getInfers(source)
    if not source then
        return
    end
    local clock = os.clock()
    local infers = guide.requestInfer(source, vm.interface)
    local passed = os.clock() - clock
    if passed > 0.1 then
        log.warn(('Request infer takes [%.3f]sec! %s'):format(passed, util.dump(source, { deep = 1 })))
    end
    return infers
end
