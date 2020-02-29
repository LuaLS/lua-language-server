local guide   = require 'parser.guide'
local files   = require 'files'
local vm      = require 'vm.vm'

local function checkNext(source, callback)
    local nextSrc = source.next
    if not nextSrc then
        return
    end
    local ntype = nextSrc.type
    if ntype == 'setfield'
    or ntype == 'setmethod'
    or ntype == 'getfield'
    or ntype == 'getmethod' then
        callback(nextSrc)
    end
    if ntype == 'setindex'
    or ntype == 'getindex' then
        if nextSrc.node == source then
            callback(nextSrc)
        end
    end
    return
end

local function ofENV(source, callback)
    local refs = source.ref
    if not refs then
        return
    end
    for i = 1, #refs do
        local ref = refs[i]
        if ref.type == 'getglobal'
        or ref.type == 'setglobal' then
            callback(ref)
            if guide.getName(ref) == '_G' then
                vm.ofField(ref, callback)
                local call, index = vm.getArgInfo(ref)
                local special = vm.getSpecial(call)
                if (special == 'rawset' or special == 'rawget')
                and index == 1 then
                    callback(call.next)
                end
            end
        elseif ref.type == 'getlocal' then
            vm.ofField(ref, callback)
        end
        vm.eachFieldInTable(ref.value, callback)
    end
end

local function ofLocal(source, callback)
    if source.tag == '_ENV' then
        ofENV(source, callback)
    else
        vm.eachRef(source, function (src)
            vm.ofField(src, callback)
        end)
    end
end

local function ofGlobal(source, callback)
    vm.eachRef(source, function (src)
        vm.ofField(src, callback)
    end)
end

local function ofGetField(source, callback)
    vm.eachRef(source, function (src)
        vm.ofField(src, callback)
    end)
end

local function ofTable(source, callback)
    local parent = source.parent
    if parent and parent.value == source then
        return vm.eachField(parent, callback)
    else
        vm.eachFieldInTable(source, callback)
    end
end

local function ofTableField(source, callback)
    vm.eachRef(source, function (src)
        vm.ofField(src, callback)
    end)
end

function vm.ofField(source, callback)
    checkNext(source, callback)
    vm.eachMetaValue(source, callback)
    vm.eachFieldInTable(source.value, callback)
end

function vm.eachFieldInTable(value, callback)
    if not value then
        return
    end
    if value.type ~= 'table' then
        return
    end
    for i = 1, #value do
        local field = value[i]
        if field.type == 'tablefield'
        or field.type == 'tableindex' then
            callback(field)
            vm.eachMetaValue(field, callback)
        end
    end
end

function vm.eachField(source, callback)
    local stype = source.type
    if     stype == 'local' then
        ofLocal(source, callback)
    elseif stype == 'getlocal'
    or     stype == 'setlocal' then
        ofLocal(source.node, callback)
    elseif stype == 'getglobal'
    or     stype == 'setglobal' then
        ofGlobal(source, callback)
    elseif stype == 'table' then
        ofTable(source, callback)
    elseif stype == 'tablefield' then
        ofTableField(source, callback)
    elseif stype == 'getfield'
    or     stype == 'setfield'
    or     stype == 'getmethod'
    or     stype == 'setmethod'
    or     stype == 'getindex'
    or     stype == 'setindex' then
        ofGetField(source, callback)
    end
end
