local vm      = require 'vm.vm'
local guide   = require 'parser.guide'
local util    = require 'utility'
local await   = require 'await'

NIL = setmetatable({'<nil>'}, { __tostring = function () return 'nil' end })

--- 是否包含某种类型
function vm.hasType(source, type, deep)
    local defs = vm.getDefs(source, deep)
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
function vm.hasInferType(source, type, deep)
    local infers = vm.getInfers(source, deep)
    for i = 1, #infers do
        local infer = infers[i]
        if infer.type == type then
            return true
        end
    end
    return false
end

function vm.getInferType(source, deep)
    local infers = vm.getInfers(source, deep)
    return guide.viewInferType(infers)
end

function vm.getInferLiteral(source, deep)
    local infers = vm.getInfers(source, deep)
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

local function getInfers(source, deep)
    local results = {}
    local lock = vm.lock('getInfers', source)
    if not lock then
        return results
    end

    await.delay()

    local clock = os.clock()
    local myResults, count = guide.requestInfer(source, vm.interface, deep)
    if DEVELOP and os.clock() - clock > 0.1 then
        log.warn('requestInfer', count, os.clock() - clock, guide.getUri(source), util.dump(source, { deep = 1 }))
    end
    vm.mergeResults(results, myResults)

    lock()

    return results
end

--- 获取对象的值
--- 会尝试穿透函数调用
function vm.getInfers(source, deep)
    if guide.isGlobal(source) then
        local name = guide.getKeyName(source)
        local cache =  vm.getCache('getInfersOfGlobal')[name]
                    or vm.getCache('getInfers')[source]
                    or getInfers(source, 'deep')
        vm.getCache('getInfersOfGlobal')[name] = cache
        vm.getCache('getInfers')[source] = cache
        return cache
    else
        local cache =  vm.getCache('getInfers')[source]
                    or getInfers(source, deep)
        if deep then
            vm.getCache('getInfers')[source] = cache
        end
        return cache
    end
end
