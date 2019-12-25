local guide   = require 'parser.guide'
local files   = require 'files'
local vm      = require 'vm.vm'

local function checkNext(source)
    local nextSrc = source.next
    if not nextSrc then
        return nil
    end
    local ntype = nextSrc.type
    if ntype == 'setfield'
    or ntype == 'setmethod'
    or ntype == 'getfield'
    or ntype == 'getmethod' then
        return nextSrc
    end
    if ntype == 'setindex'
    or ntype == 'getindex' then
        if nextSrc.node == source then
            return nextSrc
        end
    end
    return nil
end

local function ofENV(source, callback)
    local refs = source.ref
    if not refs then
        return
    end
    for i = 1, #refs do
        local ref = refs[i]
        if ref.type == 'getglobal' then
            callback(ref)
            if guide.getName(ref) == '_G' then
                local nextSrc = checkNext(ref)
                if nextSrc then
                    callback(nextSrc)
                end
            end
        elseif ref.type == 'setglobal' then
            callback(ref)
            if guide.getName(ref) == '_G' then
                local nextSrc = checkNext(ref)
                if nextSrc then
                    callback(nextSrc)
                end
            end
        elseif ref.type == 'getlocal' then
            local nextSrc = checkNext(ref)
            if nextSrc then
                callback(nextSrc)
            end
        end
        vm.eachFieldInTable(ref.value, callback)
    end
end

local function ofLocal(source, callback)
    if source.tag == '_ENV' then
        ofENV(source, callback)
    else
        vm.eachRef(source, function (src)
            vm.eachFieldInTable(src.value, callback)
            local nextSrc = checkNext(src)
            if not nextSrc then
                return
            end
            callback(nextSrc)
        end)
    end
end

local function ofGlobal(source, callback)
    vm.eachRef(source, function (src)
        local nextSrc = checkNext(src)
        if not nextSrc then
            return
        end
        callback(nextSrc)
        vm.eachFieldInTable(src.value, callback)
    end)
end

local function ofGetField(source, callback)
    vm.eachRef(source, function (src)
        local nextSrc = checkNext(src)
        if not nextSrc then
            return
        end
        callback(nextSrc)
        vm.eachFieldInTable(src.value, callback)
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
        local nextSrc = checkNext(src)
        if nextSrc then
            callback(nextSrc)
        end
    end)
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
