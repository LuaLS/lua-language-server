local guide = require 'parser.guide'

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

local function ofGlobal(searcher, source, callback)
    local node = source.node
    local key  = guide.getKeyName(source)
    searcher.node:eachField(node, function (info)
        local src = info.source
        if key == guide.getKeyName(src) then
            if src.type == 'setglobal' then
                callback {
                    searcher = searcher,
                    source   = src,
                    mode     = 'set',
                }
            elseif src.type == 'getglobal' then
                callback {
                    searcher = searcher,
                    source   = src,
                    mode     = 'get',
                }
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
    elseif source.type == 'setglobal'
    or     source.type == 'getglobal' then
        ofGlobal(searcher, source, callback)
    end
end
