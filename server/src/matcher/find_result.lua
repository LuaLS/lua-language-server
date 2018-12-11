local function isContainPos(obj, pos)
    return obj.start <= pos and obj.finish + 1 >= pos
end

local function findIn(name, group, pos)
    for _, obj in ipairs(group) do
        for _, info in ipairs(obj) do
            if isContainPos(info.source, pos) then
                return {
                    type   = name,
                    object = obj,
                    info   = info,
                }
            end
        end
    end
end

return function (results, pos)
    return findIn('local', results.locals, pos)
        or findIn('field', results.fields, pos)
        or findIn('label', results.labels, pos)
end
