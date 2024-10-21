local API = {}

local wvmt = { __mode = 'v' }

---@param weakValue? boolean
---@return table<string, any>
function API.create(weakValue)
    ---@type table<string, any>
    local lowerMap = {}
    if weakValue then
        setmetatable(lowerMap, wvmt)
    end
    ---@type table<string, string>
    local upperKeyMap = {}
    local out = {}

    local function nextKV(t, k)
        if t ~= lowerMap then
            error('invalid table')
        end
        if k then
            k = string.lower(k)
        end
        local nextK, nextV = next(lowerMap, k)
        if not nextK then
            return nil
        end
        local upperK = upperKeyMap[nextK]
        return upperK, nextV
    end

    setmetatable(out, {
        __newindex = function (t, k, v)
            local lk = string.lower(k)
            lowerMap[lk] = v
            if v == nil then
                upperKeyMap[lk] = nil
                return
            elseif not upperKeyMap[lk] then
                upperKeyMap[lk] = k
            end
        end,
        __index = function (t, k)
            local lk = string.lower(k)
            local v = lowerMap[lk]
            if v == nil then
                upperKeyMap[lk] = nil
            end
            return v
        end,
        __pairs = function ()
            ---@diagnostic disable-next-line: redundant-return-value
            return nextKV, lowerMap, nil
        end,
    })
    return out
end

return API
