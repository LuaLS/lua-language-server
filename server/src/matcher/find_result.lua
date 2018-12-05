local function isContainPos(obj, pos)
    return obj.start <= pos and obj.finish + 1 >= pos
end

return function (results, pos)
    for _, var in ipairs(results.vars) do
        for _, info in ipairs(var) do
            if isContainPos(info.source, pos) then
                return {
                    type = 'var',
                    var = var,
                }
            end
        end
    end
    for _, dots in ipairs(results.dots) do
        for _, info in ipairs(dots) do
            if isContainPos(info.source, pos) then
                return {
                    type = 'dots',
                    dots = dots,
                }
            end
        end
    end
    for _, label in ipairs(results.labels) do
        for _, info in ipairs(label) do
            if isContainPos(info.source, pos) then
                return {
                    type = 'label',
                    label = label,
                }
            end
        end
    end
    return nil
end
