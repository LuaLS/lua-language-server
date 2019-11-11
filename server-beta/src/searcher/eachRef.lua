local guide     = require 'parser.guide'
local files     = require 'files'
local workspace = require 'workspace'
local searcher  = require 'searcher.searcher'

local function ofCall(func, index, callback)
    searcher.eachRef(func, function (info)
        local src = info.source
        local funcDef = src.value
        if funcDef and funcDef.returns then
            -- 搜索函数第 index 个返回值
            for _, rtn in ipairs(funcDef.returns) do
                local val = rtn[index]
                if val then
                    callback {
                        source   = val,
                        mode     = 'return',
                    }
                    searcher.eachRef(val, callback)
                end
            end
        end
    end)
end

local function ofSpecialCall(call, func, index, callback)
    local name = searcher.getSpecialName(func)
    if name == 'setmetatable' then
        if index == 1 then
            local args = call.args
            if args[1] then
                searcher.eachRef(args[1], callback)
            end
            if args[2] then
                searcher.eachField(args[2], function (info)
                    if info.key == 's|__index' then
                        searcher.eachRef(info.source, callback)
                        if info.value then
                            searcher.eachRef(info.value, callback)
                        end
                    end
                end)
            end
        end
    elseif name == 'require' then
        if index == 1 then
            local args = call.args
            if args[1] then
                local literal = guide.getLiteral(args[1])
                if type(literal) == 'string' then
                    local result = workspace.findUrisByRequirePath(literal, true)
                    local myUri = guide.getRoot(call).uri
                    for _, uri in ipairs(result) do
                        if not files.eq(uri, myUri) then
                            local ast = files.getAst(uri)
                            if ast then
                                searcher.eachRef(ast.ast, callback)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function ofValue(value, callback)
    if value.type == 'select' then
        -- 检查函数返回值
        local call = value.vararg
        if call.type == 'call' then
            ofCall(call.node, value.index, callback)
            ofSpecialCall(call, call.node, value.index, callback)
        end
        return
    end

    if value.type == 'table'
    or value.type == 'string'
    or value.type == 'number'
    or value.type == 'boolean'
    or value.type == 'nil'
    or value.type == 'function' then
        callback {
            source   = value,
            mode     = 'value',
        }
    end

    searcher.eachRef(value, callback)

    local parent = value.parent
    if parent.type == 'local'
    or parent.type == 'setglobal'
    or parent.type == 'setlocal'
    or parent.type == 'setfield'
    or parent.type == 'setmethod'
    or parent.type == 'setindex' then
        if parent.value == value then
            searcher.eachRef(parent, callback)
        end
    end
end

local function ofSelf(loc, callback)
    -- self 的2个特殊引用位置：
    -- 1. 当前方法定义时的对象（mt）
    local method = loc.method
    local node   = method.node
    searcher.eachRef(node, callback)
    -- 2. 调用该方法时传入的对象
end

--- 自己作为赋值的值
local function asValue(source, callback)
    local parent = source.parent
    if parent and parent.value == source then
        if guide.getKeyName(parent) == 's|__index' then
            if parent.type == 'tablefield'
            or parent.type == 'tableindex' then
                local t = parent.parent
                local args = t.parent
                if args[2] == t then
                    local call = args.parent
                    local func = call.node
                    if searcher.getSpecialName(func) == 'setmetatable' then
                        searcher.eachRef(args[1], callback)
                    end
                end
            end
        end
    end
end

local function getCallRecvs(call)
    local parent = call.parent
    if parent.type ~= 'select' then
        return nil
    end
    local exParent = call.exParent
    local recvs = {}
    recvs[1] = parent.parent
    if exParent then
        for _, p in ipairs(exParent) do
            recvs[#recvs+1] = p.parent
        end
    end
    return recvs
end

--- 自己作为函数的参数
local function asArg(source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type == 'callargs' then
        local call = parent.parent
        local func = call.node
        local name = searcher.getSpecialName(func)
        if name == 'setmetatable' then
            if parent[1] == source then
                if parent[2] then
                    searcher.eachField(parent[2], function (info)
                        if info.key == 's|__index' then
                            searcher.eachRef(info.source, callback)
                            if info.value then
                                searcher.eachRef(info.value, callback)
                            end
                        end
                    end)
                end
            end
            local recvs = getCallRecvs(call)
            if recvs and recvs[1] then
                searcher.eachRef(recvs[1], callback)
            end
        end
    end
end

local function ofLocal(loc, callback)
    -- 方法中的 self 使用了一个虚拟的定义位置
    if loc.tag ~= 'self' then
        callback {
            source   = loc,
            mode     = 'declare',
        }
    end
    if loc.ref then
        for _, ref in ipairs(loc.ref) do
            if ref.type == 'getlocal' then
                callback {
                    source   = ref,
                    mode     = 'get',
                }
                asValue(ref, callback)
            elseif ref.type == 'setlocal' then
                callback {
                    source   = ref,
                    mode     = 'set',
                }
                if ref.value then
                    ofValue(ref.value, callback)
                end
            end
        end
    end
    if loc.tag == 'self' then
        ofSelf(loc, callback)
    end
    if loc.value then
        ofValue(loc.value, callback)
    end
    if loc.tag == '_ENV' and loc.ref then
        for _, ref in ipairs(loc.ref) do
            if ref.type == 'getlocal' then
                local parent = ref.parent
                if parent.type == 'getfield'
                or parent.type == 'getindex' then
                    if guide.getKeyName(parent) == 's|_G' then
                        callback {
                            source   = parent,
                            mode     = 'get',
                        }
                    end
                end
            elseif ref.type == 'getglobal' then
                if guide.getKeyName(ref) == 's|_G' then
                    callback {
                        source   = ref,
                        mode     = 'get',
                    }
                end
            end
        end
    end
end

local function ofGlobal(source, callback)
    local key = guide.getKeyName(source)
    local node = source.node
    if node.tag == '_ENV' then
        local uris = files.findGlobals(key)
        for _, uri in ipairs(uris) do
            local ast = files.getAst(uri)
            local globals = searcher.getGlobals(ast.ast)
            if globals[key] then
                for _, info in ipairs(globals[key]) do
                    callback(info)
                    if info.value then
                        ofValue(info.value, callback)
                    end
                end
            end
        end
    else
        searcher.eachField(node, function (info)
            if key == info.key then
                callback {
                    source   = info.source,
                    mode     = info.mode,
                }
                if info.value then
                    ofValue(info.value, callback)
                end
            end
        end)
    end
end

local function ofField(source, callback)
    local parent = source.parent
    local key    = guide.getKeyName(source)
    if parent.type == 'tablefield' then
        local tbl = parent.parent
        searcher.eachField(tbl, function (info)
            if key == info.key then
                callback {
                    source   = info.source,
                    mode     = info.mode,
                }
                if info.value then
                    ofValue(info.value, callback)
                end
            end
        end)
    else
        local node = parent.node
        searcher.eachField(node, function (info)
            if key == info.key then
                callback {
                    source   = info.source,
                    mode     = info.mode,
                }
                if info.value then
                    ofValue(info.value, callback)
                end
            end
        end)
    end
end

local function ofLiteral(source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type == 'setindex'
    or parent.type == 'getindex' then
        ofField(source, callback)
    end
end

local function ofLabel(source, callback)
    callback {
        source = source,
        mode   = 'set',
    }
    if source.ref then
        for _, ref in ipairs(source.ref) do
            callback {
                source = ref,
                mode   = 'get',
            }
        end
    end
end

local function ofGoTo(source, callback)
    local name = source[1]
    local label = guide.getLabel(source, name)
    if label then
        ofLabel(label, callback)
    end
end

local function ofMain(source, callback)
    if source.returns then
        for _, rtn in ipairs(source.returns) do
            local val = rtn[1]
                if val then
                    callback {
                        source   = val,
                        mode     = 'return',
                    }
                    searcher.eachRef(val, callback)
                end
        end
    end
end

local function eachRef(source, callback)
    local stype = source.type
    if     stype == 'local' then
        ofLocal(source, callback)
    elseif stype == 'getlocal'
    or     stype == 'setlocal' then
        ofLocal(source.node, callback)
    elseif stype == 'setglobal'
    or     stype == 'getglobal' then
        ofGlobal(source, callback)
    elseif stype == 'field'
    or     stype == 'method'
    or     stype == 'index' then
        ofField(source, callback)
    elseif stype == 'setfield'
    or     stype == 'getfield'
    or     stype == 'tablefield' then
        ofField(source.field, callback)
    elseif stype == 'setmethod'
    or     stype == 'getmethod' then
        ofField(source.method, callback)
    elseif stype == 'number'
    or     stype == 'boolean'
    or     stype == 'string' then
        ofLiteral(source, callback)
    elseif stype == 'goto' then
        ofGoTo(source, callback)
    elseif stype == 'label' then
        ofLabel(source, callback)
    elseif stype == 'table'
    or     stype == 'function' then
        ofValue(source, callback)
    elseif stype == 'main' then
        ofMain(source, callback)
    end
    asArg(source, callback)
end

--- 获取所有的引用
function searcher.eachRef(source, callback)
    local cache = searcher.cache.eachRef[source]
    if cache then
        for i = 1, #cache do
            local res = callback(cache[i])
            if res ~= nil then
                return res
            end
        end
        return
    end
    local unlock = searcher.lock('eachRef', source)
    if not unlock then
        return
    end
    cache = {}
    searcher.cache.eachRef[source] = cache
    local mark = {}
    eachRef(source, function (info)
        local src = info.source
        if mark[src] then
            return
        end
        mark[src] = true
        cache[#cache+1] = info
    end)
    unlock()
    for i = 1, #cache do
        local src = cache[i].source
        searcher.cache.eachRef[src] = cache
    end
    for i = 1, #cache do
        local res = callback(cache[i])
        if res ~= nil then
            return res
        end
    end
end
