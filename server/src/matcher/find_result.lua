local function isContainPos(obj, pos)
    return obj.start <= pos and obj.finish + 1 >= pos
end

return function (vm, pos)
    local results = vm.results
    for source, object in pairs(results.sources) do
        if source.type == 'multi-source' then
            for _, source in ipairs(source) do
                if source.type ~= 'simple' and isContainPos(source, pos) then
                    return object, source
                end
            end
        else
            if source.type ~= 'simple' and isContainPos(source, pos) then
                return object, source
            end
        end
    end
    return nil
end
