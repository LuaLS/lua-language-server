local findSource = require 'core.find_source'

local function parseResult(vm, source, declarat, callback)
    if source:bindLabel() then
        source:bindLabel():eachInfo(function (info)
            if declarat or info.type == 'get' then
                callback(info.source)
            end
        end)
        return
    end
    if source:bindLocal() then
        local loc = source:bindLocal()
        loc:eachInfo(function (info)
            if declarat or info.type == 'get' then
                callback(info.source)
            end
        end)
        loc:getValue():eachInfo(function (info, src)
            if declarat or info.type == 'get' then
                callback(src)
            end
        end)
        return
    end
    if source:bindValue() then
        source:bindValue():eachInfo(function (info, src)
            if declarat or info.type == 'get' then
                callback(src)
            end
        end)
        local parent = source:get 'parent'
        parent:eachInfo(function (info, src)
            if info[1] == source[1] then
                if (declarat and info.type == 'set child') or info.type == 'get child' then
                    callback(src)
                end
            end
        end)
        return
    end
end

return function (vm, pos, declarat)
    local source = findSource(vm, pos)
    if not source then
        return nil
    end
    local positions = {}
    local mark = {}
    parseResult(vm, source, declarat, function (src)
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
    return positions
end
