local function ofLocal(searcher, source, callback)
    if source.ref then
        for _, ref in ipairs(source.ref) do
            if     ref.type == 'getlocal' then
                local parent = ref.parent
                local field = searcher:getField(parent)
                if field then
                    callback {
                        searcher = searcher,
                        source  = field,
                    }
                end
            elseif ref.type == 'getglobal'
            or     ref.type == 'setglobal' then
                callback {
                    searcher = searcher,
                    source  = ref,
                }
            end
        end
    end
end

local function ofGlobal(searcher, source, callback)
    searcher:eachRef(source, function (info)
        local src = info.source
        if src.type == 'getglobal' then
            if src.parent then
                local field = info.searcher:getField(src.parent)
                if field then
                    callback {
                        searcher = info.searcher,
                        source  = field,
                    }
                end
            end
        end
    end)
end

return function (searcher, source, callback)
    if     source.type == 'local' then
        ofLocal(searcher, source, callback)
    elseif source.type == 'getlocal'
    or     source.type == 'setlocal' then
        ofLocal(searcher, source.node, callback)
    elseif source.type == 'getglobal'
    or     source.type == 'setglobal' then
        ofGlobal(searcher, source, callback)
    end
end
