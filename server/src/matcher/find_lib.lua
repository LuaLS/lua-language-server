local function findLib(var)
    local value = var.value
    local lib = value.lib
    if not lib then
        return nil
    end
    if lib.parent then
        local res
        for _, parent in ipairs(lib.parent) do
            if parent.type == value.parentType then
                res = parent
            end
        end
        if not res then
            res = lib.parent[1]
        end
        if res.type == 'object' then
            local fullKey = ('*%s:%s'):format(res.nick or res.name, lib.name)
            return lib, fullKey, true
        else
            local fullKey = ('%s.%s'):format(res.nick or res.name, lib.name)
            return lib, fullKey, false
        end
    else
        return lib, lib.name, false
    end
end

return function (var)
    local lib, fullKey, oo = findLib(var)
    return lib, fullKey, oo
end
