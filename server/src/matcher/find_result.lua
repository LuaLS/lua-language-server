local function isContainPos(obj, pos)
    if obj.start <= pos and obj.finish + 1 >= pos then
        return true
    end
    return false, pos - (obj.finish + 1)
end

local function findAtPos(results, pos)
    for sources, object in pairs(results.sources) do
        if sources.type == 'multi-source' then
            for _, source in ipairs(source) do
                if source.type ~= 'simple' and isContainPos(source, pos) then
                    return object, source
                end
            end
        else
            local source = sources
            if source.type ~= 'simple' and isContainPos(source, pos) then
                return object, source
            end
        end
    end
    return nil
end

local function findClosePos(results, pos)
    local curDis = math.maxinteger
    local parent = nil
    for sources, object in pairs(results.sources) do
        if sources.type == 'multi-source' then
            for _, source in ipairs(source) do
                if source.type ~= 'simple' then
                    local inside, dis = isContainPos(source, pos)
                    if inside then
                        return object, source
                    elseif dis > 0 and dis < curDis then
                        curDis = dis
                        parent = object
                    end
                end
            end
        else
            local source = sources
            if source.type ~= 'simple' then
                local inside, dis = isContainPos(source, pos)
                if inside then
                    return object, source
                elseif dis > 0 and dis < curDis then
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
        return findClosePos(results, pos)
    else
        return findAtPos(results, pos)
    end
end
