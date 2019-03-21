local function isContainPos(obj, pos)
    if obj.start <= pos and obj.finish + 1 >= pos then
        return true
    end
    return false
end

local function isValidSource(source)
    return source.start ~= nil and source.start ~= 0
end

local function findAtPos(sources, pos, level)
    local res = {}
    for _, source in ipairs(sources) do
        if isValidSource(source) and isContainPos(source, pos) then
            res[#res+1] = source
        end
    end
    if #res == 0 then
        return nil
    end
    table.sort(res, function (a, b)
        if a == b then
            return false
        end
        local rangeA = a.finish - a.start
        local rangeB = b.finish - b.start
        -- 特殊处理：func 'str' 的情况下，list与string的范围会完全相同，此时取string
        if rangeA == rangeB then
            if b.type == 'call' and #b == 1 and b[1] == a then
                return true
            else
                return false
            end
        end
        return rangeA < rangeB
    end)
    local source = res[level or 1]
    if not source then
        return nil
    end
    return source
end

return function (vm, pos, level)
    return findAtPos(vm.sources, pos, level)
end
