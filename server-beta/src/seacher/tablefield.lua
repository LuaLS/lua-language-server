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

return m
