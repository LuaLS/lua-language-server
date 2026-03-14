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

---@class Feature.Provider<P>
---@field queue PriorityQueue
---@field runner fun(param: P): any[]

---@class Feature.ProviderActions<R>
---@field push fun(item: R)
---@field skip fun(priority?: integer)
---@field has fun(predicate: fun(item: R): boolean): boolean
---@field hasLabel fun(label: string): boolean
---@field hasWord fun(word: string): boolean

---@return Feature.ProviderActions<any>
function ls.feature.helper.providers()
    local queue = ls.tools.pqueue.create()

    ---@param item any
    ---@return table<string, true>
    local function extractWords(item)
        local words = {}
        if type(item) ~= 'table' then
            return words
        end

        local function addFromString(s)
            if type(s) ~= 'string' then
                return
            end
            local w = s:match('^([%a_][%w_]*)')
            if w then
                words[w] = true
            end
        end

        addFromString(item.label)
        addFromString(item.insertText)
        if type(item.textEdit) == 'table' then
            addFromString(item.textEdit.newText)
        end
        return words
    end

    return {
        queue = queue,
        runner = function (param)
            local results = {}
            local skipPriorty = -1
            for provider, priority in queue:pairs() do
                if priority <= skipPriorty then
                    break
                end
                xpcall(provider, log.error, param, {
                    push = function (loc)
                        results[#results+1] = loc
                    end,
                    skip = function (p)
                        p = p or priority
                        if skipPriorty < p then
                            skipPriorty = p
                        end
                    end,
                    has = function (predicate)
                        for _, item in ipairs(results) do
                            if predicate(item) then
                                return true
                            end
                        end
                        return false
                    end,
                    hasLabel = function (label)
                        for _, item in ipairs(results) do
                            if item.label == label then
                                return true
                            end
                        end
                        return false
                    end,
                    hasWord = function (word)
                        for _, item in ipairs(results) do
                            if extractWords(item)[word] then
                                return true
                            end
                        end
                        return false
                    end
                })
            end
            return results
        end,
    }
end
