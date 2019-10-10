local m = {}

function m:field(source, callback)
    for i = 1, #source do
        local src = source[i]
        if src.type == 'tablefield'
        or src.type == 'tableindex' then
            callback(src)
        end
    end
end

return m
