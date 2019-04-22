local function parseValueSimily(callback, vm, source, lsp)
    local key = source[1]
    if not key then
        return nil
    end
    vm:eachSource(function (other)
        if other == source then
            goto CONTINUE
        end
        if      other[1] == key
            and not other:bindLocal()
            and other:bindValue()
            and other:action() == 'set'
            and source:bindValue() ~= other:bindValue()
        then
            callback(other)
        end
        :: CONTINUE ::
    end)
end

local function parseLocal(callback, vm, source, lsp)
    local loc = source:bindLocal()
    local locSource = loc:getSource()
    callback(locSource)
end

local function parseValue(callback, vm, source, lsp)
    local value = source:bindValue()
    local isGlobal
    if value then
        isGlobal = value:isGlobal()
        value:eachInfo(function (info, src)
            if info.type == 'set' or info.type == 'local' or info.type == 'return' then
                if vm.uri == src:getUri() then
                    if isGlobal or source.id > src.id then
                        callback(src)
                    end
                elseif value.uri == src:getUri() then
                    callback(src)
                end
            end
        end)
    end
    local parent = source:get 'parent'
    if parent then
        parent:eachInfo(function (info, src)
            if info.type == 'set child' and info[1] == source[1] then
                callback(src)
            end
        end)
    end
    return isGlobal
end

local function parseLabel(callback, vm, label, lsp)
    label:eachInfo(function (info, src)
        if info.type == 'set' then
            callback(src)
        end
    end)
end

local function jumpUri(callback, vm, source, lsp)
    local uri = source:get 'target uri'
    callback {
        start = 0,
        finish = 0,
        uri = uri
    }
end

local function parseClass(callback, vm, source)
    local className = source:get 'target class'
    vm.emmyMgr:eachClass(className, function (class)
        if class.type == 'emmy.class' then
            local src = class:getSource()
            callback(src)
        end
    end)
end

local function makeList(source)
    local list = {}
    local mark = {}
    return list, function (src)
        if source == src then
            return
        end
        if mark[src] then
            return
        end
        mark[src] = true
        local uri = src.uri
        if uri == '' then
            uri = nil
        end
        list[#list+1] = {
            src.start,
            src.finish,
            src.uri
        }
    end
end

return function (vm, source, lsp)
    if not source then
        return nil
    end
    local list, callback = makeList(source)
    local isGlobal
    if source:bindLocal() then
        parseLocal(callback, vm, source, lsp)
    end
    if source:bindValue() then
        isGlobal = parseValue(callback, vm, source, lsp)
        --parseValueSimily(callback, vm, source, lsp)
    end
    if source:bindLabel() then
        parseLabel(callback, vm, source:bindLabel(), lsp)
    end
    if source:get 'target uri' then
        jumpUri(callback, vm, source, lsp)
    end
    if source:get 'in index' then
        isGlobal = parseValue(callback, vm, source, lsp)
        --parseValueSimily(callback, vm, source, lsp)
    end
    if source:get 'target class' then
        parseClass(callback, vm, source)
    end
    return list, isGlobal
end
