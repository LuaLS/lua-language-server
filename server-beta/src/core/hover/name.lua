local function asLocal(source)
    return source[1]
end

return function (source)
    local parent = source.parent
    if not parent then
        return ''
    end
    if parent.type == 'local'
    or parent.type == 'getlocal'
    or parent.type == 'setlocal' then
        return asLocal(parent)
    end
    return ''
end
