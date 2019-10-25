local guide = require 'parser.guide'

local function ofSelf(searcher, loc, callback)
    -- self 的2个特殊引用位置：
    -- 1. 当前方法定义时的对象（mt）
    local method = loc.method
    local node   = method.node
    searcher:eachRef(node, callback)
    -- 2. 调用该方法时传入的对象
end

local function ofLocal(searcher, loc, callback)
    -- 方法中的 self 使用了一个虚拟的定义位置
    if loc.tag ~= 'self' then
        callback {
            searcher = searcher,
            source   = loc,
            mode     = 'declare',
        }
    end
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
    if loc.tag == 'self' then
        ofSelf(searcher, loc, callback)
    end
end

local function checkField(key, info, callback)
    local src = info.source
    if key ~= guide.getKeyName(src) then
        return
    end
    local mode
    if src.type == 'setglobal' then
        mode = 'set'
    elseif src.type == 'getglobal' then
        mode = 'get'
    elseif src.type == 'field' then
        local parent = src.parent
        if     parent.type == 'setfield' then
            mode = 'set'
        elseif parent.type == 'getfield' then
            mode = 'get'
        elseif parent.type == 'tablefield' then
            mode = 'set'
        end
    elseif src.type == 'method' then
        local parent = src.parent
        if     parent.type == 'setmethod' then
            mode = 'set'
        elseif parent.type == 'getmethod' then
            mode = 'get'
        end
    elseif src.type == 'number'
    or     src.type == 'string'
    or     src.type == 'boolean' then
        local parent = src.parent
        if     parent.type == 'setindex' then
            mode = 'set'
        elseif parent.type == 'getindex' then
            mode = 'get'
        end
    end
    if mode then
        callback {
            searcher = info.searcher,
            source   = src,
            mode     = mode,
        }
    end
end

local function ofGlobal(searcher, source, callback)
    local node = source.node
    local key  = guide.getKeyName(source)
    searcher:eachField(node, function (info)
        checkField(key, info, callback)
    end)
end

local function ofField(searcher, source, callback)
    local parent = source.parent
    local node   = parent.node
    local key    = guide.getKeyName(source)
    searcher:eachField(node, function (info)
        checkField(key, info, callback)
    end)
end

local function ofLiteral(searcher, source, callback)
    local parent = source.parent
    if parent.type == 'setindex'
    or parent.type == 'getindex' then
        ofField(searcher, source, callback)
    end
end

return function (searcher, source, callback)
    local stype = source.type
    if     stype == 'local' then
        ofLocal(searcher, source, callback)
    elseif stype == 'getlocal'
    or     stype == 'setlocal' then
        ofLocal(searcher, source.node, callback)
    elseif stype == 'setglobal'
    or     stype == 'getglobal' then
        ofGlobal(searcher, source, callback)
    elseif stype == 'field'
    or     stype == 'method'
    or     stype == 'index' then
        ofField(searcher, source, callback)
    elseif stype == 'number'
    or     stype == 'boolean'
    or     stype == 'string' then
        ofLiteral(searcher, source, callback)
    end
end
