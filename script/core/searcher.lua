local noder     = require 'core.noder'
local guide     = require 'parser.guide'
local files     = require 'files'
local generic   = require 'core.generic'
local ws        = require 'workspace'
local vm        = require 'vm.vm'
local await     = require 'await'
local collector = require 'core.collector'

local NONE = {'NONE'}
local LAST = {'LAST'}

local ignoredIDs = {
    ['dn:unknown']       = true,
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

---@alias guide.searchmode '"ref"'|'"def"'|'"field"'|'"allref"'

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
    local mark = status.mark
    if mark[source] then
        return
    end
    mark[source] = true
    if force then
        results[#results+1] = source
        return
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
        or source.type == 'doc.resume'
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
    elseif mode == 'ref' or mode == 'field' or mode == 'allref' then
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
        or source.type == 'doc.resume'
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

local function crossSearch(status, uri, expect, mode, sourceUri)
    if status.lock[uri] then
        return
    end
    status.lock[uri] = true
    --await.delay()
    if TRACE then
        log.debug('crossSearch', uri, expect)
    end
    if FOOTPRINT then
        status.footprint[#status.footprint+1] = ('cross search:%s %s'):format(uri, expect)
    end
    m.searchRefsByID(status, uri, expect, mode)
    status.lock[uri] = nil
    if FOOTPRINT then
        status.footprint[#status.footprint+1] = ('cross search finish, back to: %s'):format(sourceUri)
    end
end

local function checkCache(status, uri, expect, mode)
    local cache = vm.getCache('search:' .. mode, true)
    local fileCache = cache[uri]
    if not fileCache then
        fileCache = {}
        cache[uri] = fileCache
    end
    if fileCache[expect] then
        for _, res in ipairs(fileCache[expect]) do
            m.pushResult(status, mode, res, true)
        end
        return true
    end
    fileCache[expect] = status.results
    return false
end

function m.searchRefsByID(status, uri, expect, mode)
    local ast = files.getState(uri)
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
        local firstID = noder.getFirstID(id)
        if ignoredIDs[firstID] and (field or firstID ~= id) then
            return
        end
        local cmark = mark[id]
        if not cmark then
            cmark = {}
            mark[id] = cmark
        end
        if cmark[field or NONE] then
            return
        end
        if TRACE then
            log.debug('search:', id, field)
        end
        if FOOTPRINT then
            if field then
                status.footprint[#status.footprint+1] = 'search\t' .. id .. '\t' .. field
            else
                status.footprint[#status.footprint+1] = 'search\t' .. id
            end
        end
        cmark[field or NONE] = true
        searchStep(id, field)
        if TRACE then
            log.debug('pop:', id, field)
        end
        if FOOTPRINT then
            if field then
                status.footprint[#status.footprint+1] = 'pop\t' .. id .. '\t' .. field
            else
                status.footprint[#status.footprint+1] = 'pop\t' .. id
            end
        end
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

    local function checkENV(source, field)
        if not field then
            return
        end
        if source.special ~= '_G' then
            return
        end
        local newID = 'g:' .. field:sub(2)
        searchID(newID)
    end

    local ftag = {}
    local btag = {}

    local function checkThenPushTag(ward, tag)
        if not tag or tag == 'deep' then
            return true
        end
        local checkTags
        local pushTags
        if ward == 'forward' then
            checkTags = btag
            pushTags  = ftag
        else
            checkTags = ftag
            pushTags  = btag
        end
        if checkTags[tag] and checkTags[tag] > 0 then
            return false
        end
        pushTags[tag] = (pushTags[tag] or 0) + 1
        return true
    end

    local function popTag(ward, tag)
        if not tag or tag == 'deep' then
            return
        end
        local popTags
        if ward == 'forward' then
            popTags = ftag
        else
            popTags = btag
        end
        popTags[tag] = popTags[tag] - 1
    end

    local function checkForward(id, node, field)
        noder.eachForward(node, function (forwardID, tag)
            if not checkThenPushTag('forward', tag) then
                return
            end
            local targetUri, targetID = noder.getUriAndID(forwardID)
            if targetUri and not files.eq(targetUri, uri) then
                crossSearch(status, targetUri, targetID .. (field or ''), mode, uri)
            else
                searchID(targetID or forwardID, field)
            end
            popTag('forward', tag)
        end)
    end

    local function checkBackward(id, node, field)
        if mode ~= 'ref' and mode ~= 'field' and mode ~= 'allref' and not field then
            return
        end
        noder.eachBackward(node, function (backwardID, tag)
            if tag == 'deep' and mode ~= 'allref' then
                return
            end
            if not checkThenPushTag('backward', tag) then
                return
            end
            local targetUri, targetID = noder.getUriAndID(backwardID)
            if targetUri and not files.eq(targetUri, uri) then
                crossSearch(status, targetUri, targetID .. (field or ''), mode, uri)
            else
                searchID(targetID or backwardID, field)
            end
            popTag('backward', tag)
        end)
    end

    local function checkSpecial(id, field)
        -- Special rule: ('').XX -> stringlib.XX
        if id == 'str:'
        or id == 'dn:string' then
            if field or mode == 'field' then
                searchID('dn:stringlib', field)
            end
        end
    end

    local function checkRequire(requireName, field)
        local tid = 'mainreturn' .. (field or '')
        local uris = ws.findUrisByRequirePath(requireName)
        if FOOTPRINT then
            status.footprint[#status.footprint+1] = ('require %q:\n%s'):format(requireName, table.concat(uris, '\n'))
        end
        for _, ruri in ipairs(uris) do
            if not files.eq(uri, ruri) then
                crossSearch(status, ruri, tid, mode, uri)
            end
        end
    end

    local function checkGlobal(id, node, field)
        if status.crossed[id] then
            return
        end
        status.crossed[id] = true
        --if not checkThenPushTag('forward', 'set') then
        --    return
        --end
        local isCall = field and field:sub(2, 2) == noder.RETURN_INDEX
        local tid = id .. (field or '')
        if FOOTPRINT then
            status.footprint[#status.footprint+1] = ('checkGlobal:%s + %s, isCall: %s'):format(id, field, isCall, tid)
        end
        local crossed = {}
        for _, guri in collector.each('def:' .. id) do
            if files.eq(uri, guri) then
                goto CONTINUE
            end
            crossed[guri] = true
            crossSearch(status, guri, tid, mode, uri)
            ::CONTINUE::
        end
        for _, guri in collector.each(id) do
            if crossed[guri] then
                goto CONTINUE
            end
            if isCall then
                goto CONTINUE
            end
            if not field and mode == 'def' then
                goto CONTINUE
            end
            if files.eq(uri, guri) then
                goto CONTINUE
            end
            crossSearch(status, guri, tid, mode, uri)
            ::CONTINUE::
        end
        --popTag('forward', 'set')
    end

    local function checkClass(id, node, field)
        if status.crossed[id] then
            return
        end
        status.crossed[id] = true
        local tid = id .. (field or '')
        for guri in collector.each(id) do
            if not files.eq(uri, guri) then
                crossSearch(status, guri, tid, mode, uri)
            end
        end
    end

    local function checkMainReturn(id, node, field)
        if id ~= 'mainreturn' then
            return
        end
        local calls = vm.getLinksTo(uri)
        for _, call in ipairs(calls) do
            local curi = guide.getUri(call)
            local cid  = ('%s%s'):format(
                noder.getID(call),
                field or ''
            )
            if not files.eq(curi, uri) then
                crossSearch(status, curi, cid, mode, uri)
            end
        end
    end

    local function searchNode(id, node, field)
        if node.call then
            callStack[#callStack+1] = node.call
        end
        if field == nil and node.source then
            noder.eachSource(node, function (source)
                local force = genericCallArgs[source]
                m.pushResult(status, mode, source, force)
            end)
        end

        if node.require then
            checkRequire(node.require, field)
        end

        if node.forward then
            checkForward(id, node, field)
        end
        if node.backward then
            checkBackward(id, node, field)
        end

        if node.source then
            checkGeneric(node.source, field)
            checkENV(node.source, field)
        end

        if mode == 'allref' then
            checkMainReturn(id, node, field)
        end

        if node.call then
            callStack[#callStack] = nil
        end

        return false
    end

    local function checkAnyField(id, field)
        if mode == 'ref' or mode == 'field' or mode == 'allref' then
            return
        end
        local lastID = noder.getLastID(id)
        if not lastID then
            return
        end
        local originField = id:sub(#lastID + 1)
        if originField == noder.TABLE_KEY then
            return
        end
        local anyFieldID   = lastID .. noder.ANY_FIELD
        local anyFieldNode = noder.getNodeByID(root, anyFieldID)
        if anyFieldNode then
            searchNode(anyFieldID, anyFieldNode, field)
        end
    end

    local stepCount = 0
    local stepMaxCount = 1e3
    local statusMaxCount = 1e4
    if mode == 'allref' then
        stepMaxCount = 1e4
        statusMaxCount = 1e5
    end
    function searchStep(id, field)
        stepCount = stepCount + 1
        status.count = status.count + 1
        if mode == 'allref' then
            if status.count % 1e4 == 0 then
                await.delay()
            end
        end
        if stepCount > stepMaxCount
        or status.count > statusMaxCount then
            if TEST then
                if FOOTPRINT then
                    log.debug(table.concat(status.footprint, '\n'))
                end
                error('too large!')
            else
                log.warn('too large!')
                if FOOTPRINT then
                    log.debug(table.concat(status.footprint, '\n'))
                end
                return
            end
        end
        checkSpecial(id, field)
        local node = noder.getNodeByID(root, id)
        if node then
            searchNode(id, node, field)
            if node.skip and field then
                return
            end
        end
        checkGlobal(id, node, field)
        checkClass(id, node, field)
        checkLastID(id, field)
        checkAnyField(id, field)
    end

    search(expect)

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

local function prepareSearch(source)
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    local root = guide.getRoot(source)
    noder.compileNodes(root)
    local uri  = guide.getUri(source)
    local id   = noder.getID(source)
    return uri, id
end

local function getField(status, source, mode)
    if source.type == 'table' then
        for _, field in ipairs(source) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                m.pushResult(status, mode, field)
            end
        end
        return
    end
    if source.type == 'doc.class.name' then
        local class = source.parent
        for _, field in ipairs(class.fields) do
            m.pushResult(status, mode, field.field)
        end
        return
    end
    local field = source.next
    if field then
        if field.type == 'getmethod'
        or field.type == 'setmethod'
        or field.type == 'getfield'
        or field.type == 'setfield'
        or field.type == 'getindex'
        or field.type == 'setindex' then
            m.pushResult(status, mode, field)
        end
        return
    end
end

local function searchAllGlobalByUri(status, mode, uri, fullID)
    local ast = files.getState(uri)
    if not ast then
        return
    end
    local root = ast.ast
    noder.compileNodes(root)
    local noders = noder.getNoders(root)
    if fullID then
        for id, node in pairs(noders) do
            if  node.source
            and id == fullID then
                noder.eachSource(node, function (source)
                    m.pushResult(status, mode, source)
                end)
            end
        end
    else
        for id, node in pairs(noders) do
            if  node.source
            and id:sub(1, 2) == 'g:'
            and not id:find(noder.SPLIT_CHAR) then
                noder.eachSource(node, function (source)
                    m.pushResult(status, mode, source)
                end)
            end
        end
    end
end

local function searchAllGlobals(status, mode)
    for uri in files.eachFile() do
        searchAllGlobalByUri(status, mode, uri)
    end
end

---查找全局变量
---@param uri uri
---@param mode guide.searchmode
---@param name string
---@return parser.guide.object[]
function m.findGlobals(uri, mode, name)
    local status = m.status(mode)

    if name then
        local fullID = ('g:%q'):format(name)
        searchAllGlobalByUri(status, mode, uri, fullID)
    else
        searchAllGlobalByUri(status, mode, uri)
    end

    return status.results
end

---搜索对象的引用
---@param status guide.status
---@param source parser.guide.object
---@param mode   guide.searchmode
function m.searchRefs(status, source, mode)
    local uri, id = prepareSearch(source)
    if not id then
        return
    end

    if checkCache(status, uri, id, mode) then
        return
    end

    if TRACE then
        log.debug('searchRefs:', id)
    end
    m.searchRefsByID(status, uri, id, mode)
end

---搜索对象的field
---@param status guide.status
---@param source parser.guide.object
---@param mode   guide.searchmode
---@param field  string
function m.searchFields(status, source, mode, field)
    local uri, id = prepareSearch(source)
    if not id then
        return
    end
    if TRACE then
        log.debug('searchFields:', id, field)
    end
    if field == '*' then
        if source.special == '_G' then
            if checkCache(status, uri, '*', mode) then
                return
            end
            searchAllGlobals(status, mode)
        else
            if checkCache(status, uri, id .. '*', mode) then
                return
            end
            local newStatus = m.status('field')
            m.searchRefsByID(newStatus, uri, id, 'field')
            for _, def in ipairs(newStatus.results) do
                getField(status, def, mode)
            end
        end
    else
        if source.special == '_G' then
            local fullID = ('g:%q'):format(field)
            if checkCache(status, uri, fullID, mode) then
                return
            end
            m.searchRefsByID(status, uri, fullID, mode)
        else
            local fullID = ('%s%s%q'):format(id, noder.SPLIT_CHAR, field)
            if checkCache(status, uri, fullID, mode) then
                return
            end
            m.searchRefsByID(status, uri, fullID, mode)
        end
    end
end

---@class guide.status
---搜索结果
---@field results parser.guide.object[]

---创建搜索状态
---@param mode guide.searchmode
---@return guide.status
function m.status(mode)
    local status = {
        callStack = {},
        crossed   = {},
        lock      = {},
        results   = {},
        mark      = {},
        footprint = {},
        count     = 0,
        ftag      = {},
        btag      = {},
        cache     = vm.getCache('searcher:' .. mode)
    }
    return status
end

--- 请求对象的引用
---@param obj       parser.guide.object
---@param field?    string
---@return parser.guide.object[]
function m.requestReference(obj, field)
    local status = m.status('ref')

    if field then
        m.searchFields(status, obj, 'ref', field)
    else
        m.searchRefs(status, obj, 'ref')
    end

    return status.results
end

--- 请求对象的全部引用（深度搜索）
---@param obj       parser.guide.object
---@param field?    string
---@return parser.guide.object[]
function m.requestAllReference(obj, field)
    local status = m.status('allref')

    if field then
        m.searchFields(status, obj, 'allref', field)
    else
        m.searchRefs(status, obj, 'allref')
    end

    return status.results
end

--- 请求对象的定义
---@param obj       parser.guide.object
---@param field?    string
---@return parser.guide.object[]
function m.requestDefinition(obj, field)
    local status = m.status('def')

    if field then
        m.searchFields(status, obj, 'def', field)
    else
        m.searchRefs(status, obj, 'def')
    end

    return status.results
end

return m
