local vm = require 'vm.vm'

local function checkMetaArg1(source, callback)
    local node, index = vm.getArgInfo(source)
    local special = vm.getSpecial(node)
    if special == 'setmetatable' and index == 1 then
        local mt = node.next.args[2]
        if mt then
            vm.eachField(mt, function (src)
                if vm.getKeyName(src) == 's|__index' then
                    if src.value then
                        vm.eachField(src.value, callback)
                    end
                end
            end)
        end
    end
end

local function checkMetaRecv(source, callback)
    if not source or source.type ~= 'select' then
        return
    end
    if source.index ~= 1 then
        return
    end
    local call = source.vararg
    if not call or call.type ~= 'call' then
        return
    end
    local special = vm.getSpecial(call.node)
    if special ~= 'setmetatable' then
        return
    end
    vm.eachFieldInTable(call.args[1])
    local mt = call.args[2]
    if mt then
        vm.eachField(mt, function (src)
            if vm.getKeyName(src) == 's|__index' then
                if src.value then
                    vm.eachField(src.value, callback)
                end
            end
        end)
    end
end

function vm.checkMetaValue(source, callback)
    checkMetaArg1(source, callback)
    checkMetaRecv(source.value, callback)
end
