local vm      = require 'vm.vm'
local guide   = require 'parser.guide'

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
    return guide.requestInfer(source, vm.interface)
end
