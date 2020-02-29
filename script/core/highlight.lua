local findSource = require 'core.find_source'
local parser = require 'parser'

local DocumentHighlightKind = {
    Text = 1,
    Read = 2,
    Write = 3,
}

local function parseResult(source)
    local positions = {}
    if source:bindLabel() then
        source:bindLabel():eachInfo(function (info, src)
            positions[#positions+1] = { src.start, src.finish, DocumentHighlightKind.Text }
        end)
        return positions
    end
    if source:bindLocal() then
        local loc = source:bindLocal()
        local mark = {}
        loc:eachInfo(function (info, src)
            if not mark[src] then
                mark[src] = info
                positions[#positions+1] = { src.start, src.finish, DocumentHighlightKind.Text }
            end
        end)
        return positions
    end
    if source:bindValue() and source:get 'parent' then
        local parent = source:get 'parent'
        local mark = {}
        parent:eachInfo(function (info, src)
            if not mark[src] and source.uri == src.uri then
                mark[src] = info
                if info.type == 'get child' or info.type == 'set child' then
                    if info[1] == source[1] then
                        positions[#positions+1] = {src.start, src.finish, DocumentHighlightKind.Text}
                    end
                end
            end
        end)
        return positions
    end
    return nil
end

return function (vm, pos)
    local source = findSource(vm, pos)
    if not source then
        return nil
    end
    local positions = parseResult(source)
    return positions
end
