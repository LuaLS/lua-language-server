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

local function ofValue(searcher, value, callback)
    if value.type == 'table' then
        ofTabel(searcher, value, callback)
    end
end

local function rawField(searcher, source, callback)
    if source.type == 'getlocal' then
        local parent = source.parent
        local field = searcher:getField(parent)
        if field then
            callback {
                searcher = searcher,
                source  = field,
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

return function (searcher, source, callback)
    searcher:eachRef(source, function (info)
        local src = info.source
        if src.tag == '_ENV' then
            if src.ref then
                for _, ref in ipairs(src.ref) do
                    rawField(info.searcher, ref, callback)
                end
            end
        elseif src.type == 'local' then
            if src.value then
                ofValue(searcher, src.value, callback)
            end
        elseif src.type == 'getlocal' then
            if src.parent then
                local field = info.searcher:getField(src.parent)
                if field then
                    callback {
                        searcher = info.searcher,
                        source  = field,
                    }
                end
            end
        elseif src.type == 'setlocal' then
            ofValue(info.searcher, src.value, callback)
        elseif src.type == 'getglobal' then
            if src.parent then
                local field = info.searcher:getField(src.parent)
                if field then
                    callback {
                        searcher = info.searcher,
                        source  = field,
                    }
                end
            end
        elseif src.type == 'setglobal' then
            ofValue(info.searcher, src.value, callback)
        end
    end)
end
