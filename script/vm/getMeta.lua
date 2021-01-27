---@type vm
local vm = require 'vm.vm'

local function eachMetaOfArg1(source, callback)
    local node, index = vm.getArgInfo(source)
    local special = vm.getSpecial(node)
    if special == 'setmetatable' and index == 1 then
        local mt = node.next.args[2]
        if mt then
            callback(mt)
        end
    end
end

local function eachMetaOfRecv(source, callback)
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
    local mt = call.args[2]
    if mt then
        callback(mt)
    end
end

function vm.eachMetaValue(source, callback)
    vm.eachMeta(source, function (mt)
        for _, src in ipairs(vm.getDefFields(mt)) do
            if vm.getKeyName(src) == '__index' then
                if src.value then
                    for _, valueSrc in ipairs(vm.getDefFields(src.value)) do
                        callback(valueSrc)
                    end
                end
            end
        end
    end)
end

function vm.eachMeta(source, callback)
    eachMetaOfArg1(source, callback)
    eachMetaOfRecv(source.value, callback)
end
