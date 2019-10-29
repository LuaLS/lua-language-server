local guide = require 'parser.guide'

local function ofCall(searcher, func, index, callback)
    searcher:eachRef(func, function (info)
        local src = info.source
        local funcDef = src.value
        if funcDef and funcDef.returns then
            -- 搜索函数第 index 个返回值
            for _, rtn in ipairs(funcDef.returns) do
                local val = rtn[index]
                if val then
                    callback {
                        searcher = info.searcher,
                        source   = val,
                        mode     = 'return',
                    }
                    info.searcher:eachRef(val, callback)
                end
            end
        end
    end)
end

local function ofSpecialCall(searcher, call, func, index, callback)
    local name = searcher:getSpecialName(func)
    if name == 'setmetatable' then
        if index == 1 then
            local args = call.args
            if args[1] then
                searcher:eachRef(args[1], callback)
            end
            if args[2] then
                searcher:eachField(args[2], function (info)
                    if info.key == 's|__index' then
                        info.searcher:eachRef(info.source, callback)
                        if info.value then
                            info.searcher:eachRef(info.value, callback)
                        end
                    end
                end)
            end
        end
    end
end

local function ofValue(searcher, value, callback)
    if value.type == 'select' then
        -- 检查函数返回值
        local call = value.vararg
        if call.type == 'call' then
            ofCall(searcher, call.node, value.index, callback)
            ofSpecialCall(searcher, call, call.node, value.index, callback)
        end
        return
    end
    callback {
        searcher = searcher,
        source   = value,
        mode     = 'value',
    }
end

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
                if ref.value then
                    ofValue(searcher, ref.value, callback)
                end
            end
        end
    end
    if loc.tag == 'self' then
        ofSelf(searcher, loc, callback)
    end
    if loc.value then
        ofValue(searcher, loc.value, callback)
    end
    if loc.tag == '_ENV' then
        for _, ref in ipairs(loc.ref) do
            if ref.type == 'getlocal' then
                local parent = ref.parent
                if parent.type == 'getfield'
                or parent.type == 'getindex' then
                    if guide.getKeyName(parent) == 's|_G' then
                        callback {
                            searcher = searcher,
                            source   = parent,
                            mode     = 'get',
                        }
                    end
                end
            elseif ref.type == 'getglobal' then
                if guide.getKeyName(ref) == 's|_G' then
                    callback {
                        searcher = searcher,
                        source   = ref,
                        mode     = 'get',
                    }
                end
            end
        end
    end
end

local function ofGlobal(searcher, source, callback)
    local node = source.node
    local key  = guide.getKeyName(source)
    searcher:eachField(node, function (info)
        if key == info.key then
            callback {
                searcher = info.searcher,
                source   = info.source,
                mode     = info.mode,
            }
            if info.value then
                ofValue(info.searcher, info.value, callback)
            end
        end
    end)
end

local function ofField(searcher, source, callback)
    local parent = source.parent
    local node   = parent.node
    local key    = guide.getKeyName(source)
    searcher:eachField(node, function (info)
        if key == info.key then
            callback {
                searcher = info.searcher,
                source   = info.source,
                mode     = info.mode,
            }
            if info.value then
                ofValue(info.searcher, info.value, callback)
            end
        end
    end)
end

local function ofLiteral(searcher, source, callback)
    local parent = source.parent
    if parent.type == 'setindex'
    or parent.type == 'getindex' then
        ofField(searcher, source, callback)
    end
end

local function ofGoTo(searcher, source, callback)
    local name = source[1]
    local label = guide.getLabel(source, name)
    if label then
        callback {
            searcher = searcher,
            source   = label,
            mode     = 'set',
        }
    end
end

local function ofLabel(searcher, source, callback)
    
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
    elseif stype == 'setfield'
    or     stype == 'getfield' then
        ofField(searcher, source.field, callback)
    elseif stype == 'setmethod'
    or     stype == 'getmethod' then
        ofField(searcher, source.method, callback)
    elseif stype == 'number'
    or     stype == 'boolean'
    or     stype == 'string' then
        ofLiteral(searcher, source, callback)
    elseif stype == 'goto' then
        ofGoTo(searcher, source, callback)
    elseif stype == 'label' then
        ofLabel(searcher, source, callback)
    else
        callback {
            searcher = searcher,
            source  = source,
        }
    end
end
