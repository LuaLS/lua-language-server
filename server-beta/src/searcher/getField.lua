return function (searcher, source)
    local stype = source.type
    if     stype == 'getfield'
    or     stype == 'setfield' then
        return source.field
    elseif stype == 'getmethod'
    or     stype == 'setmethod' then
        return source.method
    elseif stype == 'getindex'
    or     stype == 'setindex' then
        return source.index
    end
    return nil
end
