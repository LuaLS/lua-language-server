local function mergeKey(key, k)
    if not key then
        return k
    end
    if k:sub(1, 1):match '%w' then
        return key .. '.' .. k
    else
        return key .. k
    end
end

local function proxy(results, key)
    return setmetatable({}, {
        __index = function (_, k)
            return proxy(results, mergeKey(key, k))
        end,
        __newindex = function (_, k, v)
            results[mergeKey(key, k)] = v
        end
    })
end

return function (text, path, results)
    results = results or {}
    assert(load(text, '@' .. path, "t", proxy(results)))()
    return results
end
