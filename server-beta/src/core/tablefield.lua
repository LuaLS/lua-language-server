local m = {}

function m:field(source, key, callback)
    if source.value then
        self:eachField(source.value, key, callback)
    end
end

return m
