local noder   = require 'core.noder'
local guide   = require 'parser.guide'
local files   = require 'files'
local generic = require 'core.generic'
local ws      = require 'workspace'
local vm      = require 'vm.vm'

local NONE = {'NONE'}
local LAST = {'LAST'}

local function checkFunctionReturn(source)
    if  source.parent
    and source.parent.type == 'return' then
        if source.parent.parent.type == 'main' then
            return 0
        elseif source.parent.parent.type == 'function' then
            for i = 1, #source.parent do
                if source.parent[i] == source then
                    return i
                end
            end
        end
    end
    return nil
end

local ignoredIDs = {
    ['dn:nil']           = true,
    ['dn:any']           = true,
    ['dn:boolean']       = true,
    ['dn:string']        = true,
    ['dn:table']         = true,
    ['dn:number']        = true,
    ['dn:integer']       = true,
    ['dn:userdata']      = true,
    ['dn:lightuserdata'] = true,
    ['dn:function']      = true,
    ['dn:thread']        = true,
}

local m = {}

---@alias guide.searchmode '"ref"'|'"def"'|'"field"'

---添加结果
---@param status guide.status
---@param mode   guide.searchmode
---@param source parser.guide.object
---@param force  boolean
function m.pushResult(status, mode, source, force)
    if not source then
        return
    end
    local results = status.results
    if force then
        results[#results+1] = source
    end
    local parent = source.parent
    if mode == 'def' then
        if source.type == 'local'
        or source.type == 'setlocal'
        or source.type == 'setglobal'
        or source.type == 'label'
        or source.type == 'setfield'
        or source.type == 'setmethod'
        or source.type == 'setindex'
        or source.type == 'tableindex'
        or source.type == 'tablefield'
        or source.type == 'function'
        or source.type == 'table'
        or source.type == 'doc.class.name'
        or source.type == 'doc.alias.name'
        or source.type == 'doc.field.name'
        or source.type == 'doc.type.enum'
        or source.type == 'doc.type.array'
        or source.type == 'doc.type.table'
        or source.type == 'doc.type.function' then
            results[#results+1] = source
            return
        end
        if source.type == 'call' then
            if source.node.special == 'rawset' then
                results[#results+1] = source
            end
        end
        if parent.type == 'return' then
            if noder.getID(source) ~= status.id then
                results[#results+1] = source
            end
        end
    elseif mode == 'ref' then
        if source.type == 'local'
        or source.type == 'setlocal'
        or source.type == 'getlocal'
        or source.type == 'setglobal'
        or source.type == 'getglobal'
        or source.type == 'label'
        or source.type == 'goto'
        or source.type == 'setfield'
        or source.type == 'getfield'
        or source.type == 'setmethod'
        or source.type == 'getmethod'
        or source.type == 'setindex'
        or source.type == 'getindex'
        or source.type == 'tableindex'
        or source.type == 'tablefield'
        or source.type == 'function'
        or source.type == 'table'
        or source.type == 'string'
        or source.type == 'boolean'
        or source.type == 'number'
        or source.type == 'nil'
        or source.type == 'doc.class.name'
        or source.type == 'doc.type.name'
        or source.type == 'doc.alias.name'
        or source.type == 'doc.extends.name'
        or source.type == 'doc.field.name'
        or source.type == 'doc.type.enum'
        or source.type == 'doc.type.array'
        or source.type == 'doc.type.table'
        or source.type == 'doc.type.function' then
            results[#results+1] = source
            return
        end
        if source.type == 'call' then
            if source.node.special == 'rawset'
            or source.node.special == 'rawget' then
                results[#results+1] = source
            end
        end
        if parent.type == 'return' then
            if noder.getID(source) ~= status.id then
                results[#results+1] = source
            end
        end
    elseif mode == 'field' then
    end
end

---获取uri
---@param  obj parser.guide.object
---@return uri
function m.getUri(obj)
    if obj.uri then
        return obj.uri
    end
    local root = guide.getRoot(obj)
    if root then
        return root.uri
    end
    return ''
end

-- TODO
function m.findGlobals(root)
    noder.compileNode(noder.getNoders(root), root)
    -- TODO
    return {}
end

-- TODO
function m.isGlobal(source)
    return false
end

---@param obj parser.guide.object
---@return parser.guide.object?
function m.getObjectValue(obj)
    while obj.type == 'paren' do
        obj = obj.exp
        if not obj then
            return nil
        end
    end
    if obj.type == 'boolean'
    or obj.type == 'number'
    or obj.type == 'integer'
    or obj.type == 'string' then
        return obj
    end
    if obj.value then
        return obj.value
    end
    if obj.type == 'field'
    or obj.type == 'method' then
        return obj.parent and obj.parent.value
    end
    if obj.type == 'call' then
        if obj.node.special == 'rawset' then
            return obj.args and obj.args[3]
        else
            return obj
        end
    end
    if obj.type == 'select' then
        return obj
    end
    return nil
end

local function crossSearch(status, uri, expect, mode)
    m.searchRefsByID(status, uri, expect, mode)
end

function m.searchRefsByID(status, uri, expect, mode)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    local root = ast.ast
    local searchStep
    noder.compileNodes(root)

    status.id = expect

    local callStack = status.callStack

    local mark = {}

    local function search(id, field)
        if ignoredIDs[id] and field then
            return
        end
        local cmark = mark[id]
        if not cmark then
            cmark = {}
            mark[id] = cmark
        end
        log.debug('search:', id, field)
        if field then
            if cmark[field] then
                return
            end
            cmark[field] = true
            searchStep(id, field)
            cmark[field] = nil
        else
            if cmark[NONE] then
                return
            end
            cmark[NONE] = true
            searchStep(id, nil)
            cmark[NONE] = nil
        end
        log.debug('pop:', id, field)
    end

    local function checkLastID(id, field)
        local cmark = mark[id]
        if not cmark then
            cmark = {}
            mark[id] = cmark
        end
        if cmark[LAST] then
            return
        end
        local lastID = noder.getLastID(id)
        if not lastID then
            return
        end
        local newField = id:sub(#lastID + 1)
        if field then
            newField = newField .. field
        end
        cmark[LAST] = true
        search(lastID, newField)
        cmark[LAST] = nil
        return lastID
    end

    local function searchID(id, field)
        if not id then
            return
        end
        if field then
            id = id .. field
        end
        search(id, nil)
    end

    local function searchFunction(id)
        local node = noder.getNodeByID(root, id)
        if not node or not node.sources then
            return
        end
        local obj = node.sources[1]
        if not obj or obj.type ~= 'function' then
            return
        end
        local returnIndex = checkFunctionReturn(obj)
        if not returnIndex then
            return
        end
        local func = guide.getParentFunction(obj)
        if not func then
            return
        end
        if func.type == 'function' then
            local parentID = noder.getID(func)
            if not parentID then
                return
            end
            search(parentID, noder.RETURN_INDEX .. returnIndex)
        end
        if func.type == 'main' then
            local calls = vm.getLinksTo(uri)
            for _, call in ipairs(calls) do
                local turi = guide.getUri(call)
                local tid  = noder.getID(call)
                crossSearch(status, turi, tid, mode)
            end
        end
    end

    local function isCallID(field)
        if not field then
            return false
        end
        if field:sub(1, 2) == noder.RETURN_INDEX then
            return true
        end
        return false
    end

    local function findLastCall()
        for i = #callStack, 1, -1 do
            local call = callStack[i]
            if call then
                -- 标记此处的call失效，等待在堆栈平衡时弹出
                callStack[i] = false
                return call
            end
        end
        return nil
    end

    local genericCallArgs = {}
    local closureCache = {}
    local function checkGeneric(source, field)
        if not source.isGeneric then
            return
        end
        if not isCallID(field) then
            return
        end
        local call = findLastCall()
        if not call then
            return
        end

        if call.args then
            for _, arg in ipairs(call.args) do
                genericCallArgs[arg] = true
            end
        end

        local cacheID = noder.getID(source) .. noder.getID(call)
        local closure = closureCache[cacheID]
        if closure == false then
            return
        end
        if not closure then
            closure = generic.createClosure(source, call)
            closureCache[cacheID] = closure or false
            if not closure then
                return
            end
        end
        local id = noder.getID(closure)
        searchID(id, field)
    end

    local function checkForward(id, node, field)
        for _, forwardID in ipairs(node.forward) do
            searchID(forwardID, field)
        end
    end

    local function checkBackward(id, node, field)
        if mode ~= 'ref' and not field or ignoredIDs[id] then
            return
        end
        for _, backwardID in ipairs(node.backward) do
            searchID(backwardID, field)
        end
    end

    local function checkRequire(requireName, field)
        local tid = 'mainreturn' .. (field or '')
        local uris = ws.findUrisByRequirePath(requireName)
        for _, ruri in ipairs(uris) do
            if not files.eq(uri, ruri) then
                crossSearch(status, ruri, tid, mode)
            end
        end
    end

    local function checkGlobal(id, node, field)
        if id:sub(1, 2) ~= 'g:' then
            return
        end
        local firstID = noder.getFirstID(id)
        if status.crossedGlobal[firstID] then
            return
        end
        status.crossedGlobal[firstID] = true
        local tid = id .. (field or '')
        for guri in files.eachFile() do
            if not files.eq(uri, guri) then
                crossSearch(status, guri, tid, mode)
            end
        end
    end

    local function checkClass(id, node, field)
        if id:sub(1, 3) ~= 'dn:' then
            return
        end
        local firstID = noder.getFirstID(id)
        if status.crossedClass[firstID] then
            return
        end
        status.crossedClass[firstID] = true
        local tid = id .. (field or '')
        for guri in files.eachFile() do
            if not files.eq(uri, guri) then
                crossSearch(status, guri, tid, mode)
            end
        end
    end

    local function searchNode(id, node, field)
        if node.call then
            callStack[#callStack+1] = node.call
        end
        if field == nil and node.sources then
            for _, source in ipairs(node.sources) do
                local force = genericCallArgs[source]
                m.pushResult(status, mode, source, force)
            end
        end
        if node.forward then
            checkForward(id, node, field)
        end
        if node.backward then
            checkBackward(id, node, field)
        end

        if node.sources then
            checkGeneric(node.sources[1], field)
        end

        if node.require then
            checkRequire(node.require, field)
        end

        checkGlobal(id, node, field)
        checkClass(id, node, field)

        if node.call then
            callStack[#callStack] = nil
        end
    end

    local stepCount = 0
    function searchStep(id, field)
        stepCount = stepCount + 1
        if stepCount > 1000 then
            error('too large')
        end
        local node = noder.getNodeByID(root, id)
        if node then
            searchNode(id, node, field)
        end
        local lastID = checkLastID(id, field)
        if not lastID then
            return
        end
        local originField  = id:sub(#lastID + 1)
        if originField == noder.TABLE_KEY then
            return
        end
        local anyFieldID   = lastID .. noder.ANY_FIELD
        local anyFieldNode = noder.getNodeByID(root, anyFieldID)
        if anyFieldNode then
            searchNode(anyFieldID, anyFieldNode, field)
        end
    end

    search(expect)
    --searchFunction(expect)

    --清除来自泛型的临时对象
    for _, closure in pairs(closureCache) do
        noder.removeID(root, noder.getID(closure))
        if closure then
            for _, value in ipairs(closure.values) do
                noder.removeID(root, noder.getID(value))
            end
        end
    end
end

---搜索对象的引用
---@param status guide.status
---@param source parser.guide.object
---@param mode   guide.searchmode
function m.searchRefs(status, source, mode)
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    local root = guide.getRoot(source)
    noder.compileNodes(root)
    local uri  = guide.getUri(source)
    local id   = noder.getID(source)
    if not id then
        return
    end

    log.debug('searchRefs:', id)
    m.searchRefsByID(status, uri, id, mode)
end

---@class guide.status
---搜索结果
---@field results parser.guide.object[]

---创建搜索状态
---@param parentStatus guide.status
---@param interface table
---@param deep integer
---@return guide.status
function m.status(parentStatus, interface, deep)
    local status = {
        --mark      = parentStatus and parentStatus.mark or {},
        callStack     = {},
        crossedGlobal = {},
        crossedClass  = {},
        results       = {},
    }
    return status
end

--- 请求对象的引用
---@param obj       parser.guide.object
---@param interface table
---@param deep      integer
---@return parser.guide.object[]
---@return integer
function m.requestReference(obj, interface, deep)
    local status = m.status(nil, interface, deep)
    -- 根据 field 搜索引用
    m.searchRefs(status, obj, 'ref')

    return status.results, 0
end

--- 请求对象的定义
---@param obj       parser.guide.object
---@param interface table
---@param deep      integer
---@return parser.guide.object[]
---@return integer
function m.requestDefinition(obj, interface, deep)
    local status = m.status(nil, interface, deep)
    -- 根据 field 搜索引用
    m.searchRefs(status, obj, 'def')

    return status.results, 0
end

return m
