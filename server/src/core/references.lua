local findSource = require 'core.find_source'

local function parseResult(vm, source, declarat, callback)
    local isGlobal
    if source:bindLabel() then
        source:bindLabel():eachInfo(function (info, src)
            if (declarat and info.type == 'set') or info.type == 'get' then
                callback(src)
            end
        end)
    end
    if source:bindLocal() then
        local loc = source:bindLocal()
        callback(loc:getSource())
        loc:eachInfo(function (info, src)
            if (declarat and info.type == 'set') or info.type == 'get' then
                callback(src)
            end
        end)
        loc:getValue():eachInfo(function (info, src)
            if (declarat and (info.type == 'set' or info.type == 'local' or info.type == 'return')) or info.type == 'get' then
                callback(src)
            end
        end)
    end
    if source:bindFunction() then
        if declarat then
            callback(source:bindFunction():getSource())
        end
        source:bindFunction():eachInfo(function (info, src)
            if (declarat and (info.type == 'set' or info.type == 'local')) or info.type == 'get' then
                callback(src)
            end
        end)
    end
    if source:bindValue() then
        source:bindValue():eachInfo(function (info, src)
            if (declarat and (info.type == 'set' or info.type == 'local')) or info.type == 'get' then
                callback(src)
            end
        end)
        if source:bindValue():isGlobal() then
            isGlobal = true
        end
    end
    local parent = source:get 'parent'
    if parent then
        parent:eachInfo(function (info, src)
            if info[1] == source[1] then
                if (declarat and info.type == 'set child') or info.type == 'get child' then
                    callback(src)
                end
            end
        end)
    end
    --local emmy = source:getEmmy()
    --if emmy then
    --    if emmy.type == 'emmy.class' or emmy.type == 'emmy.type' --then
--
    --    end
    --end
    return isGlobal
end

return function (vm, pos, declarat)
    local source = findSource(vm, pos)
    if not source then
        return nil
    end
    local positions = {}
    local mark = {}
    local isGlobal = parseResult(vm, source, declarat, function (src)
        if mark[src] then
            return
        end
        mark[src] = true
        if src.start == 0 then
            return
        end
        local uri = src.uri
        if uri == '' then
            uri = nil
        end
        positions[#positions+1] = {
            src.start,
            src.finish,
            uri,
        }
    end)
    return positions, isGlobal
end
