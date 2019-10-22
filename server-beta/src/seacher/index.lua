local m = {}

function m:eachValue(source, callback)
    local parent = source.parent
    if parent.type == 'setindex'
    or parent.type == 'tableindex' then
        if parent.value then
            self:eachValue(parent.value, callback)
        end
    end
end

return m
