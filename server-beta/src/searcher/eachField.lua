local function ofLocal(seacher, source, callback)
    if source.ref then
        for _, ref in ipairs(source.ref) do
            if ref.type == 'getlocal' then
                local parent = ref.parent
                
            end
        end
    end
end

return function (seacher, source, callback)
    if     source.type == 'local' then
        ofLocal(seacher, source, callback)
    elseif source.type == 'getlocal'
    or     source.type == 'setlocal' then
        ofLocal(seacher, source.node, callback)
    end
end
