local findSource = require 'core.find_source'
local parser = require 'parser'

local function parseResult(source, newName)
    local positions = {}
    if source:bindLabel() then
        if not parser:grammar(newName, 'Name') then
            return nil
        end
        source:bindLabel():eachInfo(function (info, src)
            positions[#positions+1] = { src.start, src.finish, src:getUri() }
        end)
        return positions
    end
    if source:bindLocal() then
        local loc = source:bindLocal()
        if loc:get 'hide' then
            return nil
        end
        if source:get 'in index' then
            if not parser:grammar(newName, 'Exp') then
                return positions
            end
        else
            if not parser:grammar(newName, 'Name') then
                return positions
            end
        end
        local mark = {}
        loc:eachInfo(function (info, src)
            if not mark[src] then
                mark[src] = info
                positions[#positions+1] = { src.start, src.finish, src:getUri() }
            end
        end)
        return positions
    end
    if source:bindValue() and source:get 'parent' then
        if source:get 'in index' then
            if not parser:grammar(newName, 'Exp') then
                return positions
            end
        else
            if not parser:grammar(newName, 'Name') then
                return positions
            end
        end
        local parent = source:get 'parent'
        local mark = {}
        parent:eachInfo(function (info, src)
            if not mark[src] then
                mark[src] = info
                if info.type == 'get child' or info.type == 'set child' then
                    if info[1] == source[1] then
                        positions[#positions+1] = {src.start, src.finish, src:getUri()}
                    end
                end
            end
        end)
        return positions
    end
    return nil
end

return function (vm, pos, newName)
    local source = findSource(vm, pos)
    if not source then
        return nil
    end
    local positions = parseResult(source, newName)
    return positions
end
