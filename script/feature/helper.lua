---@class Feature.Helper
ls.feature.helper = {}

---@param results Location[]
---@return Location[]
function ls.feature.helper.organizeResultsByRange(results)
    table.sort(results, function (a, b)
        return a.range[1] < b.range[1]
    end)
    local organizedResults = {}

    local lastFinish = 0
    for _, result in ipairs(results) do
        local start = result.range[1]
        if start >= lastFinish then
            organizedResults[#organizedResults+1] = result
            lastFinish = result.range[2]
        else
            -- 如果有重叠的范围，取最小的范围
            if result.range[2] < lastFinish then
                organizedResults[#organizedResults] = result
                lastFinish = result.range[2]
            end
        end
    end

    return organizedResults
end

---@param loc Node.Location
---@param source? { start: integer, finish: integer }
---@return Location
function ls.feature.helper.convertLocation(loc, source)
    local location = {
        uri = loc.uri,
        range = { loc.offset, loc.offset + loc.length },
    }
    if source then
        location.originRange = { source.start, source.finish }
    end
    return location
end

---@return PriorityQueue
---@return fun(param: any): any[]
function ls.feature.helper.providers()
    local providers = ls.tools.pqueue.create()

    return providers, function (param)
        local results = {}
        local skipPriorty = -1
        for provider, priority in providers:pairs() do
            if priority <= skipPriorty then
                break
            end
            xpcall(provider, log.error, param, function (loc)
                results[#results+1] = loc
            end, function (p)
                p = p or priority
                if skipPriorty < p then
                    skipPriorty = p
                end
            end)
        end
        return results
    end
end
