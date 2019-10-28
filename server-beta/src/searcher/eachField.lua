local function ofTabel(searcher, value, callback)
    for _, field in ipairs(value) do
        if field.type == 'tablefield' then
            callback {
                searcher = searcher,
                source   = field.field,
            }
        elseif field.type == 'tableindex' then
            callback {
                searcher = searcher,
                source   = field.index,
            }
        else
            callback {
                searcher = searcher,
                source   = field,
            }
        end
    end
end

local function ofENV(searcher, source, callback)
    if source.type == 'getlocal' then
        local parent = source.parent
        if parent.type == 'getfield'
        or parent.type == 'getmethod'
        or parent.type == 'getindex' then
            callback {
                searcher = searcher,
                source  = parent,
            }
        end
    elseif source.type == 'getglobal'
    or     source.type == 'setglobal' then
        callback {
            searcher = searcher,
            source  = source,
        }
    end
end

local function ofVar(searcher, source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type == 'getfield'
    or parent.type == 'getmethod'
    or parent.type == 'getindex'
    or parent.type == 'setfield'
    or parent.type == 'setmethod'
    or parent.type == 'setindex' then
        callback {
            searcher = searcher,
            source   = parent,
        }
        return
    end
    if parent.type == 'callargs' then
        local call = parent.parent
        local func = call.node
        local name = searcher:getSpecialName(func)
        if name == 'rawset'
        or name == 'rawget' then
            if parent[1] == source then
                callback {
                    searcher = searcher,
                    source   = call,
                }
            end
        end
    end
end

return function (searcher, source, callback)
    searcher:eachRef(source, function (info)
        local src = info.source
        if src.tag == '_ENV' then
            if src.ref then
                for _, ref in ipairs(src.ref) do
                    ofENV(info.searcher, ref, callback)
                end
            end
        elseif src.type == 'getlocal'
        or     src.type == 'getglobal'
        or     src.type == 'getfield'
        or     src.type == 'getmethod'
        or     src.type == 'getindex' then
            ofVar(info.searcher, src, callback)
        elseif src.type == 'table' then
            ofTabel(info.searcher, src, callback)
        end
    end)
end
