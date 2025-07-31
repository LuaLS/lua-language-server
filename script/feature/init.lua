---@class Feature
ls.feature = {}

---@class Feature.Provider
ls.feature.provider = {}

---@param results Location[]
---@return Location[]
function ls.feature.organizeResults(results)
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

require 'feature.definition'
require 'feature.implementation'
