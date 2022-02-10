---@class vm
local vm       = require 'vm.vm'
local util     = require 'utility'
local compiler = require 'vm.node.compiler'
local guide    = require 'parser.guide'

local simpleMap;simpleMap = util.switch()
    : case 'local'
    : call(function (source, results)
        results[#results+1] = source
        if source.ref then
            for _, ref in ipairs(source.ref) do
                if ref.type == 'setlocal' then
                    results[#results+1] = ref
                end
            end
        end

        if source.dummy then
            for _, res in ipairs(vm.getDefs(source.method.node)) do
                results[#results+1] = res
            end
        end
    end)
    : case 'getlocal'
    : case 'setlocal'
    : call(function (source, results)
        simpleMap['local'](source.node, results)
    end)
    : case 'field'
    : call(function (source, results)
        local node = source.parent.node
        if node.type == 'getlocal' then
            local key = guide.getKeyName(source)
            for _, ref in ipairs(node.node.ref) do
                if  ref.type == 'getlocal'
                and guide.isSet(ref.next)
                and guide.getKeyName(ref.next) == key then
                    results[#results+1] = ref.next
                end
            end
        end
    end)
    : case 'setfield'
    : case 'getfield'
    : call(function (source, results)
        simpleMap['field'](source.field, results)
    end)
    : getMap()

local noderMap = util.switch()
    : case 'global'
    ---@param node vm.node.global
    : call(function (node, results)
        for _, set in ipairs(node:getSets()) do
            results[#results+1] = set
        end
    end)
    : getMap()

function vm.getDefs(source)
    local results = {}

    -- search by simple
    local simple = simpleMap[source.type]
    if simple then
        simple(source, results)
    end
    local uri   = guide.getUri(source)

    -- search by node
    local node  = compiler.compileNode(uri, source)
    local noder = noderMap[node.type]
    if noder then
        noder(node, results)
    end

    return results
end

function vm.getAllDefs(source)
    return vm.getDefs(source)
end
