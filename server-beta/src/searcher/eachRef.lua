local function ofLocal(searcher, loc, callback)
    callback {
        searcher = searcher,
        source   = loc,
        mode     = 'declare',
    }
    if loc.ref then
        for _, ref in ipairs(loc.ref) do
            if ref.type == 'getlocal' then
                callback {
                    searcher = searcher,
                    source   = ref,
                    mode     = 'get',
                }
            elseif ref.type == 'setlocal' then
                callback {
                    searcher = searcher,
                    source   = ref,
                    mode     = 'set',
                }
            end
        end
    end
end

return function (searcher, source, callback)
    if     source.type == 'local' then
        ofLocal(searcher, source, callback)
    elseif source.type == 'getlocal'
    or     source.type == 'setlocal' then
        ofLocal(searcher, source.node, callback)
    end
end
