local guide   = require 'parser.guide'
local files   = require 'files'
local vm      = require 'vm.vm'
local library = require 'library'
local await   = require 'await'

local function ofSelf(state, loc, callback)
    -- self 的2个特殊引用位置：
    -- 1. 当前方法定义时的对象（mt）
    local method = loc.method
    local node   = method.node
    callback(node)
    -- 2. 调用该方法时传入的对象
end

local function ofLocal(state, loc, source, callback)
    if state[loc] then
        return
    end
    state[loc] = true
    -- 方法中的 self 使用了一个虚拟的定义位置
    if loc.tag ~= 'self' then
        callback(loc, 'declare')
    end
    local refs = loc.ref
    if refs then
        for i = 1, #refs do
            local ref = refs[i]
            if ref == source then
                break
            end
            if ref.type == 'getlocal' then
                if loc.tag == '_ENV' then
                    local parent = ref.parent
                    if parent.type == 'getfield'
                    or parent.type == 'getindex' then
                        if guide.getKeyName(parent) == '_G' then
                            callback(parent, 'declare')
                        end
                    end
                end
            elseif ref.type == 'setlocal' then
                callback(ref, 'set')
            end
        end
    end
    if loc.tag == 'self' then
        ofSelf(state, loc, callback)
    end
end

local function ofGlobal(state, source, callback)
    if state[source] then
        return
    end
    local key = guide.getKeyName(source)
    local node = source.node
    if node.tag == '_ENV' then
        local uris = files.findGlobals(key)
        for i = 1, #uris do
            local uri = uris[i]
            local ast = files.getAst(uri)
            local globals = vm.getGlobals(ast.ast)
            if globals and globals[key] then
                for _, info in ipairs(globals[key]) do
                    state[info.source] = true
                    if info.mode == 'set' then
                        callback(info)
                    end
                end
            end
        end
    else
        vm.eachField(node, function (info)
            if key == info.key then
                state[info.source] = true
                if info.mode == 'set' then
                    callback(info)
                end
            end
        end)
    end
end

local function ofField(state, source, callback)
    if state[source] then
        return
    end
    local parent = source.parent
    local key    = guide.getKeyName(source)
    if parent.type == 'tablefield'
    or parent.type == 'tableindex' then
        local tbl = parent.parent
        vm.eachField(tbl, function (info)
            if key == info.key then
                state[info.source] = true
                if info.mode == 'set' then
                    callback(info)
                end
            end
        end)
    else
        local node = parent.node
        vm.eachField(node, function (info)
            if key == info.key then
                state[info.source] = true
                if info.mode == 'set' then
                    callback(info)
                end
            end
        end)
    end
end

local function ofLabel(state, source, callback)
    if state[source] then
        return
    end
    state[source] = true
    callback(source, 'set')
end

local function ofGoTo(state, source, callback)
    local name = source[1]
    local label = guide.getLabel(source, name)
    if label then
        ofLabel(state, label, callback)
    end
end

local function ofValue(state, source, callback)
    callback(source, 'value')
end

local function ofIndex(state, source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type == 'setindex'
    or parent.type == 'getindex'
    or parent.type == 'tableindex' then
        ofField(state, source, callback)
    end
end

local function ofCall(state, func, index, callback, offset)
    offset = offset or 0
    vm.eachRef(func, function (info)
        local src = info.source
        local returns
        if src.type == 'main' or src.type == 'function' then
            returns = src.returns
        end
        if returns then
            -- 搜索函数第 index 个返回值
            for i = 1, #returns do
                local rtn = returns[i]
                local val = rtn[index-offset]
                if val then
                    callback(val)
                end
            end
        end
    end)
end

local function ofSpecialCall(state, call, func, index, callback, offset)
    local name = func.special
    offset = offset or 0
    if name == 'setmetatable' then
        if index == 1 + offset then
            local args = call.args
            if args[1+offset] then
                callback(args[1+offset])
            end
            if args[2+offset] then
                vm.eachField(args[2+offset], function (info)
                    if info.key == 's|__index' then
                        callback(info.source)
                    end
                end)
            end
            vm.setMeta(args[1+offset], args[2+offset])
        end
    elseif name == 'require' then
        if index == 1 + offset then
            local result = vm.getLinkUris(call)
            if result then
                local myUri = guide.getRoot(call).uri
                for i = 1, #result do
                    local uri = result[i]
                    if not files.eq(uri, myUri) then
                        local ast = files.getAst(uri)
                        if ast then
                            ofCall(state, ast.ast, 1, callback)
                        end
                    end
                end
            end

            local args = call.args
            if args[1+offset] then
                if args[1+offset].type == 'string' then
                    local objName = args[1+offset][1]
                    local lib = library.library[objName]
                    if lib then
                        callback(lib)
                    end
                end
            end
        end
    elseif name == 'pcall'
    or     name == 'xpcall' then
        if index >= 2-offset then
            local args = call.args
            if args[1+offset] then
                vm.eachRef(args[1+offset], function (info)
                    local src = info.source
                    if src.type == 'function' then
                        ofCall(state, src, index, callback, 1+offset)
                        ofSpecialCall(state, call, src, index, callback, 1+offset)
                    end
                end)
            end
        end
    end
end

local function ofSelect(state, source, callback)
    -- 检查函数返回值
    local call = source.vararg
    if call.type == 'call' then
        ofCall(state, call.node, source.index, callback)
        ofSpecialCall(state, call, call.node, source.index, callback)
    end
end

local function ofMain(state, source, callback)
    callback(source, 'main')
end

local function getCallRecvs(call)
    local parent = call.parent
    if parent.type ~= 'select' then
        return nil
    end
    local extParent = call.extParent
    local recvs = {}
    recvs[1] = parent.parent
    if extParent then
        for i = 1, #extParent do
            local p = extParent[i]
            recvs[#recvs+1] = p.parent
        end
    end
    return recvs
end

local function checkValue(state, source, callback)
    if source.value then
        callback(source.value)
    end
end

function vm.defCheck(state, source, callback)
    checkValue(state, source, callback)
end

function vm.defOf(state, source, callback)
    local stype = source.type
    if stype     == 'local' then
        ofLocal(state, source, source, callback)
    elseif stype == 'getlocal'
    or     stype == 'setlocal' then
        ofLocal(state, source.node, source, callback)
    elseif stype == 'setglobal'
    or     stype == 'getglobal' then
        ofGlobal(state, source, callback)
    elseif stype == 'field'
    or     stype == 'method' then
        ofField(state, source, callback)
    elseif stype == 'setfield'
    or     stype == 'getfield'
    or     stype == 'tablefield' then
        ofField(state, source.field, callback)
    elseif stype == 'setmethod'
    or     stype == 'getmethod' then
        ofField(state, source.method, callback)
    elseif stype == 'goto' then
        ofGoTo(state, source, callback)
    elseif stype == 'label' then
        ofLabel(state, source, callback)
    elseif stype == 'number'
    or     stype == 'boolean'
    or     stype == 'string' then
        ofIndex(state, source, callback)
        ofValue(state, source, callback)
    elseif stype == 'table'
    or     stype == 'function' then
        ofValue(state, source, callback)
    elseif stype == 'select' then
        ofSelect(state, source, callback)
    elseif stype == 'call' then
        ofCall(state, source.node, 1, callback)
        ofSpecialCall(state, source, source.node, 1, callback)
    elseif stype == 'main' then
        ofMain(state, source, callback)
    elseif stype == 'paren' then
        vm.defOf(state, source.exp, callback)
    end
end

local function eachDef(source, result)
    local list     = { source }
    local mark     = {}
    local state    = {}
    local hasOf    = {}
    local hasCheck = {}
    local function found(src, mode)
        local info
        if src.mode then
            info = src
            src = info.source
        end
        if mark[src] == nil then
            list[#list+1] = src
        end
        if info then
            mark[src] = info
        elseif mode then
            mark[src] = {
                source = src,
                mode   = mode,
            }
        else
            mark[src] = mark[src] or false
        end
    end
    for _ = 1, 10000 do
        if _ == 10000 then
            error('stack overflow!')
        end
        local max = #list
        if max == 0 then
            break
        end
        local src = list[max]
        list[max] = nil
        if not hasOf[src] then
            hasOf[src] = true
            vm.defOf(state, src, found)
        end
        if not hasCheck[src] then
            hasCheck[src] = true
            vm.defCheck(state, src, found)
        end
    end
    for _, info in pairs(mark) do
        if info then
            result[#result+1] = info
        end
    end
    return result
end

local function applyCache(cache, callback, max)
    await.delay(function ()
        return files.globalVersion
    end)
    if max then
        if max > #cache then
            max = #cache
        end
    else
        max = #cache
    end
    for i = 1, max do
        local res = callback(cache[i])
        if res ~= nil then
            return res
        end
    end
end

--- 获取所有的引用
function vm.eachDef(source, callback, max)
    local cache = vm.cache.eachDef[source]
    if cache then
        applyCache(cache, callback, max)
        return
    end
    local unlock = vm.lock('eachDef', source)
    if not unlock then
        return
    end
    cache = {}
    vm.cache.eachDef[source] = cache
    eachDef(source, cache)
    unlock()
    applyCache(cache, callback, max)
end
