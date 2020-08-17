local vm      = require 'vm.vm'
local guide   = require 'parser.guide'
local util    = require 'utility'

NIL = setmetatable({'<nil>'}, { __tostring = function () return 'nil' end })

--- 是否包含某种类型
function vm.hasType(source, type)
    local defs = vm.getDefs(source)
    for i = 1, #defs do
        local def = defs[i]
        local value = guide.getObjectValue(def) or def
        if value.type == type then
            return true
        end
    end
    return false
end

--- 是否包含某种类型
function vm.hasInferType(source, type)
    local infers = vm.getInfers(source)
    for i = 1, #infers do
        local infer = infers[i]
        if infer.type == type then
            return true
        end
    end
    return false
end

function vm.getInferType(source)
    local infers = vm.getInfers(source)
    return guide.viewInferType(infers)
end

function vm.getInferLiteral(source)
    local infers = vm.getInfers(source)
    local literals = {}
    local mark = {}
    for _, infer in ipairs(infers) do
        local value = infer.value
        if value and not mark[value] then
            mark[value] = true
            literals[#literals+1] = util.viewLiteral(value)
        end
    end
    if #literals == 0 then
        return nil
    end
    table.sort(literals)
    return table.concat(literals, '|')
end

--- 获取对象的值
--- 会尝试穿透函数调用
function vm.getInfers(source)
    if not source then
        return
    end
    local clock = os.clock()
    local infers = guide.requestInfer(source, vm.interface)
    if os.clock() - clock > 0.1 then
        log.warn(('Request infer takes [%.3f]sec! %s %s'):format(os.clock() - clock, guide.getRoot(source).uri, util.dump(source, { deep = 1 })))
    end
    return infers
end
