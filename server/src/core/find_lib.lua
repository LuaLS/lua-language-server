local function findLib(value)
    local lib = value:getLib()
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
        local res
        if not lib.source then
            return lib, lib.nick or lib.name, false
        end
        for _, source in ipairs(lib.source) do
            if source.type == value.parentType then
                res = source
            end
        end
        if not res then
            return lib, lib.nick or lib.name, false
        end
        return lib, res.nick or res.name or lib.nick or lib.name, false
    end
end

return function (source)
    if source:bindValue() then
        local lib, fullKey, oo = findLib(source:bindValue())
        return lib, fullKey, oo
    end
    return nil
end
