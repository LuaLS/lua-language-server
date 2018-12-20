local function isContainPos(obj, pos)
    if obj.start <= pos and obj.finish + 1 >= pos then
        return true
    end
    return false
end

local function findAtPos(results, pos)
    local res = {}
    for sources, object in pairs(results.sources) do
        if sources.type == 'multi-source' then
            for _, source in ipairs(sources) do
                if source.type ~= 'simple' and isContainPos(source, pos) then
                    res[#res+1] = {
                        object = object,
                        source = source,
                        range = source.finish - source.start,
                    }
                end
            end
        else
            local source = sources
            if source.type ~= 'simple' and isContainPos(source, pos) then
                res[#res+1] = {
                    object = object,
                    source = source,
                    range = source.finish - source.start,
                }
            end
        end
    end
    if #res == 0 then
        return nil
    end
    table.sort(res, function (a, b)
        return a.range < b.range
    end)
    return res[1].object, res[1].source
end

local function findClosePos(results, pos)
    local curDis = math.maxinteger
    local parent = nil
    for sources, object in pairs(results.sources) do
        if sources.type == 'multi-source' then
            for _, source in ipairs(sources) do
                if source.type ~= 'simple' then
                    local dis = pos - source.finish
                    if dis > 0 and dis < curDis then
                        curDis = dis
                        parent = object
                    end
                end
            end
        else
            local source = sources
            if source.type ~= 'simple' then
                local dis = pos - source.finish
                if dis > 0 and dis < curDis then
                    curDis = dis
                    parent = object
                end
            end
        end
    end
    if parent then
        -- 造个假的 DirtyName
        local source = {
            type = 'name',
            start = pos,
            finish = pos,
            [1]    = '',
        }
        local result = {
            type = 'field',
            parent = parent,
            key = '',
            source = source,
        }
        return result, source
    end
    return nil
end

return function (vm, pos, close)
    local results = vm.results
    if close then
        local obj, source = findAtPos(results, pos)
        if obj then
            return obj, source
        else
            return findClosePos(results, pos)
        end
    else
        return findAtPos(results, pos)
    end
end
