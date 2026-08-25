---@class Feature.Diagnostic.Merge
local M = {}

---@param results Feature.Diagnostic[]
---@return Feature.Diagnostic[]
function M.merge(results)
    table.sort(results, function (a, b)
        if a.start == b.start then
            return a.finish < b.finish
        end
        return a.start < b.start
    end)

    local deduped = {}
    local i = 1
    while i <= #results do
        local best = results[i]
        local j = i + 1
        while j <= #results
        and results[j].start == best.start
        and results[j].finish == best.finish do
            if results[j].level < best.level then
                best = results[j]
            end
            j = j + 1
        end
        deduped[#deduped+1] = best
        i = j
    end
    return deduped
end

return M
