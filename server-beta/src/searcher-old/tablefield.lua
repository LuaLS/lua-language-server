local m = {}

function m:eachField(source, key, callback)
    if source.value then
        self:eachField(source.value, key, callback)
    end
end

function m:eachValue(source, callback)
    if source.value then
        self:eachValue(source.value, callback)
    end
end

function m:getValue(source)
    return source.value and self:getValue(source.value) or source
end

return m
