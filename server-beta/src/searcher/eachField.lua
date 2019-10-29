local guide = require 'parser.guide'

local function ofTabel(searcher, value, callback)
    for _, field in ipairs(value) do
        if field.type == 'tablefield'
        or field.type == 'tableindex' then
            callback {
                searcher = searcher,
                source   = field,
                key      = guide.getKeyName(field),
                value    = field.value,
                mode     = 'set',
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
                source   = parent,
                key      = guide.getKeyName(parent),
                mode     = 'get',
            }
        end
    elseif source.type == 'getglobal' then
        callback {
            searcher = searcher,
            source   = source,
            key      = guide.getKeyName(source),
            mode     = 'get',
        }
    elseif source.type == 'setglobal' then
        callback {
            searcher = searcher,
            source   = source,
            key      = guide.getKeyName(source),
            mode     = 'set',
            value    = source.value,
        }
    end
end

local function ofSpecialArg(searcher, source, callback)
    local args = source.parent
    local call = args.parent
    local func = call.node
    local name = searcher:getSpecialName(func)
    if    name == 'rawset' then
        if args[1] == source and args[2] then
            callback {
                searcher = searcher,
                source   = call,
                key      = guide.getKeyName(args[2]),
                value    = args[3],
                mode     = 'set',
            }
        end
    elseif name == 'rawget' then
        if args[1] == source and args[2] then
            callback {
                searcher = searcher,
                source   = call,
                key      = guide.getKeyName(args[2]),
                mode     = 'get',
            }
        end
    elseif name == 'setmetatable' then
        if args[1] == source and args[2] then
            searcher:eachField(args[2], function (info)
                if info.key == 's|__index' and info.value then
                    info.searcher:eachField(info.value, callback)
                end
            end)
        end
    end
end

local function ofVar(searcher, source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type == 'getfield'
    or parent.type == 'getmethod'
    or parent.type == 'getindex' then
        callback {
            searcher = searcher,
            source   = parent,
            key      = guide.getKeyName(parent),
            mode     = 'get',
        }
        return
    end
    if parent.type == 'setfield'
    or parent.type == 'setmethod'
    or parent.type == 'setindex' then
        callback {
            searcher = searcher,
            source   = parent,
            key      = guide.getKeyName(parent),
            value    = parent.value,
            mode     = 'set',
        }
        return
    end
    if parent.type == 'callargs' then
        ofSpecialArg(searcher, source, callback)
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
