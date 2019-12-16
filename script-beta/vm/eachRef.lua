local guide   = require 'parser.guide'
local files   = require 'files'
local vm      = require 'vm.vm'
local library = require 'library'
local await   = require 'await'
local vm      = require 'vm.vm'
local guide   = require 'parser.guide'
local files   = require 'files'
local library = require 'library'

local function ofSelf(state, loc, callback)
    -- self 的2个特殊引用位置：
    -- 1. 当前方法定义时的对象（mt）
    local method = loc.method
    local node   = method.node
    callback(node)
    -- 2. 调用该方法时传入的对象
end

local function ofLocal(state, loc, callback)
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
            if ref.type == 'getlocal' then
                callback(ref, 'get')
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
            elseif ref.type == 'getglobal' then
                if loc.tag == '_ENV' then
                    if guide.getName(ref) == '_G' then
                        callback(ref, 'get')
                    end
                end
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
                    callback(info)
                end
            end
        end
    else
        vm.eachField(node, function (info)
            if key == info.key then
                state[info.source] = true
                callback(info)
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
                callback(info)
            end
        end)
    else
        local node = parent.node
        vm.eachField(node, function (info)
            if key == info.key then
                state[info.source] = true
                callback(info)
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
    if source.ref then
        for _, ref in ipairs(source.ref) do
            callback(ref, 'get')
        end
    end
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

--- 自己作为函数的参数
local function checkAsArg(state, source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type == 'callargs' then
        local call = parent.parent
        local func = call.node
        local name = func.special
        if name == 'setmetatable' then
            if parent[1] == source then
                if parent[2] then
                    vm.eachField(parent[2], function (info)
                        if info.key == 's|__index' then
                            callback(info)
                        end
                    end)
                end
                local recvs = getCallRecvs(call)
                if recvs and recvs[1] then
                    callback(recvs[1])
                end
                vm.setMeta(source, parent[2])
            end
        end
    end
end

local function ofCallSelect(state, call, index, callback)
    local slc = call.parent
    if slc.index == index then
        callback(slc.parent)
        return
    end
    if call.extParent then
        for i = 1, #call.extParent do
            slc = call.extParent[i]
            if slc.index == index then
                callback(slc.parent)
                return
            end
        end
    end
end

--- 自己作为函数的返回值
local function checkAsReturn(state, source, callback)
    local parent = source.parent
    if source.type == 'field'
    or source.type == 'method' then
        parent = parent.parent
    end
    if not parent or parent.type ~= 'return' then
        return
    end
    local func = guide.getParentFunction(source)
    if func.type == 'main' then
        local myUri = func.uri
        local uris = files.findLinkTo(myUri)
        if not uris then
            return
        end
        for i = 1, #uris do
            local uri = uris[i]
            local ast = files.getAst(uri)
            if ast then
                local links = vm.getLinks(ast.ast)
                if links then
                    for linkUri, calls in pairs(links) do
                        if files.eq(linkUri, myUri) then
                            for j = 1, #calls do
                                ofCallSelect(state, calls[j], 1, callback)
                            end
                        end
                    end
                end
            end
        end
    else
        local index
        for i = 1, #parent do
            if parent[i] == source then
                index = i
                break
            end
        end
        if not index then
            return
        end
        vm.eachRef(func, function (info)
            local src = info.source
            local call = src.parent
            if not call or call.type ~= 'call' then
                return
            end
            local recvs = getCallRecvs(call)
            if recvs and recvs[index] then
                callback(recvs[index])
            elseif index == 1 then
                callback(call, 'call')
            end
        end)
    end
end

local function checkAsParen(state, source, callback)
    if state[source] then
        return
    end
    state[source] = true
    if source.parent and source.parent.type == 'paren' then
        vm.refOf(state, source.parent, callback)
    end
end

local function checkValue(state, source, callback)
    if source.value then
        callback(source.value)
    end
end

local function checkSetValue(state, value, callback)
    if value.type == 'field'
    or value.type == 'method' then
        value = value.parent
    end
    local parent = value.parent
    if not parent then
        return
    end
    if parent.type == 'local'
    or parent.type == 'setglobal'
    or parent.type == 'setlocal'
    or parent.type == 'setfield'
    or parent.type == 'setmethod'
    or parent.type == 'setindex'
    or parent.type == 'tablefield'
    or parent.type == 'tableindex' then
        if parent.value == value then
            callback(parent)
            if guide.getName(parent) == '__index' then
                if parent.type == 'tablefield'
                or parent.type == 'tableindex' then
                    local t = parent.parent
                    local args = t.parent
                    if args[2] == t then
                        local call = args.parent
                        local func = call.node
                        if func.special == 'setmetatable' then
                            callback(args[1])
                        end
                    end
                end
            end
        end
    end
end

function vm.refOf(state, source, callback)
    local stype = source.type
    if stype     == 'local' then
        ofLocal(state, source, callback)
    elseif stype == 'getlocal'
    or     stype == 'setlocal' then
        ofLocal(state, source.node, callback)
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
        vm.refOf(state, source.exp, callback)
    end
    checkValue(state, source, callback)
    checkAsArg(state, source, callback)
    checkAsReturn(state, source, callback)
    checkAsParen(state, source, callback)
    checkSetValue(state, source, callback)
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

local function eachRef(source, callback)
    local list   = { source }
    local mark = {}
    local result = {}
    local state  = {}
    local function found(src, mode)
        local info
        if src.mode then
            info = src
            src = info.source
        end
        if not mark[src] then
            list[#list+1] = src
        end
        if info then
            mark[src] = info
        elseif mode then
            mark[src] = {
                source = src,
                mode   = mode,
            }
        end
    end
    while #list > 0 do
        local max = #list
        local src = list[max]
        list[max] = nil
        vm.refOf(state, src, found)
    end
    for _, info in pairs(mark) do
        result[#result+1] = info
    end
    return result
end

--- 判断2个对象是否拥有相同的引用
function vm.isSameRef(a, b)
    local cache = vm.cache.eachRef[a]
    if cache then
        -- 相同引用的source共享同一份cache
        return cache == vm.cache.eachRef[b]
    else
        return vm.eachRef(a, function (info)
            if info.source == b then
                return true
            end
        end) or false
    end
end

--- 获取所有的引用
function vm.eachRef(source, callback, max)
    local cache = vm.cache.eachRef[source]
    if cache then
        applyCache(cache, callback, max)
        return
    end
    local unlock = vm.lock('eachRef', source)
    if not unlock then
        return
    end
    cache = eachRef(source, callback)
    unlock()
    for i = 1, #cache do
        local src = cache[i].source
        vm.cache.eachRef[src] = cache
    end
    applyCache(cache, callback, max)
end
