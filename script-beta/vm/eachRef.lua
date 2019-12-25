local guide   = require 'parser.guide'
local files   = require 'files'
local vm      = require 'vm.vm'

local function ofLocal(loc, callback)
    -- 方法中的 self 使用了一个虚拟的定义位置
    if loc.tag ~= 'self' then
        callback(loc)
    end
    local refs = loc.ref
    if refs then
        for i = 1, #refs do
            local ref = refs[i]
            if ref.type == 'getlocal' then
                callback(ref)
            elseif ref.type == 'setlocal' then
                callback(ref)
            end
        end
    end
end

local function ofGlobal(source, callback)
    local key = vm.getKeyName(source)
    local node = source.node
    if node.tag == '_ENV' then
        local uris = files.findGlobals(key)
        for _, uri in ipairs(uris) do
            local ast = files.getAst(uri)
            local globals = vm.getGlobals(ast.ast)
            if globals and globals[key] then
                for _, info in ipairs(globals[key]) do
                    callback(info)
                end
            end
        end
    else
        vm.eachField(node, function (src)
            if key == vm.getKeyName(src) then
                callback(src)
            end
        end)
    end
end

local function ofTableField(source, callback)
    local tbl = source.parent
    local src = tbl.parent
    if not src then
        return
    end
    local key = vm.getKeyName(source)
    vm.eachField(src, function (src)
        if key == vm.getKeyName(src) then
            callback(src)
        end
    end)
end

local function ofField(source, callback)
    local parent = source.parent
    local key    = vm.getKeyName(source)
    if parent.type == 'tablefield'
    or parent.type == 'tableindex' then
        ofTableField(parent, callback)
    else
        local node = parent.node
        vm.eachField(node, function (src)
            if key == vm.getKeyName(src) then
                callback(src)
            end
        end)
    end
end

local function ofLiteral(source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type == 'setindex'
    or parent.type == 'getindex'
    or parent.type == 'tableindex' then
        ofField(source, callback)
    end
end

local function ofLabel(source, callback)
    callback(source)
    if source.ref then
        for _, ref in ipairs(source.ref) do
            callback(ref)
        end
    end
end

local function ofGoTo(source, callback)
    local name = source[1]
    local label = guide.getLabel(source, name)
    if label then
        ofLabel(label, callback)
    end
end

local function findIndex(parent, source)
    for i = 1, #parent do
        if parent[i] == source then
            return i
        end
    end
    return nil
end

local function findCallRecvs(func, index, callback)
    vm.eachRef(func, function (source)
        local parent = source.parent
        if parent.type ~= 'call' then
            return
        end
        if index == 1 then
            local slt = parent.parent
            if not slt or slt.type ~= 'select' then
                return
            end
            callback(slt.parent)
        else
            local slt = parent.extParent and parent.extParent[index-1]
            if not slt or slt.type ~= 'select' then
                return
            end
            callback(slt.parent)
        end
    end)
end

local function ofFunction(source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type == 'return' then
        local func = guide.getParentFunction(parent)
        if not func then
            return
        end
        local index = findIndex(parent, source)
        if not index then
            return
        end
        findCallRecvs(func, index, function (src)
            vm.eachRef(src, callback)
        end)
    elseif parent.value == source then
        vm.eachRef(parent, callback)
    end
end

local function eachRef(source, callback)
    local stype = source.type
    if     stype == 'local' then
        ofLocal(source, callback)
    elseif stype == 'getlocal'
    or     stype == 'setlocal' then
        ofLocal(source.node, callback)
    elseif stype == 'setglobal'
    or     stype == 'getglobal' then
        ofGlobal(source, callback)
    elseif stype == 'field'
    or     stype == 'method' then
        ofField(source, callback)
    elseif stype == 'setfield'
    or     stype == 'getfield' then
        ofField(source.field, callback)
    elseif stype == 'setmethod'
    or     stype == 'getmethod' then
        ofField(source.method, callback)
    elseif stype == 'tablefield' then
        ofTableField(source, callback)
    elseif stype == 'number'
    or     stype == 'boolean'
    or     stype == 'string' then
        ofLiteral(source, callback)
    elseif stype == 'function' then
        ofFunction(source, callback)
    elseif stype == 'goto' then
        ofGoTo(source, callback)
    elseif stype == 'label' then
        ofLabel(source, callback)
    end
end

--- 获取所有的引用
function vm.eachRef(source, callback, max)
    local mark = {}
    eachRef(source, function (src)
        if mark[src] then
            return
        end
        mark[src] = true
        callback(src)
    end)
end
