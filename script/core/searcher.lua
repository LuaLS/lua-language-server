local noder     = require 'core.noder'
local guide     = require 'parser.guide'
local files     = require 'files'
local generic   = require 'core.generic'
local ws        = require 'workspace'
local vm        = require 'vm.vm'
local collector = require 'core.collector'
local util      = require 'utility'

local TRACE        = TRACE
local FOOTPRINT    = FOOTPRINT
local TEST         = TEST
local log          = log
local select       = select
local tostring     = tostring
local ipairs       = ipairs
local next         = next
local error        = error
local type         = type
local setmetatable = setmetatable
local tconcat      = table.concat
local ssub         = string.sub
local sfind        = string.find
local sformat      = string.format

_ENV = nil

local ignoredSources = {
    ['int:']             = true,
    ['num:']             = true,
    ['str:']             = true,
    ['bool:']            = true,
    ['nil:']             = true,
}

local ignoredIDs = {
    ['dn:unknown']       = true,
    ['dn:nil']           = true,
    ['dn:any']           = true,
    ['dn:boolean']       = true,
    ['dn:table']         = true,
    ['dn:number']        = true,
    ['dn:integer']       = true,
    ['dn:userdata']      = true,
    ['dn:lightuserdata'] = true,
    ['dn:function']      = true,
    ['dn:thread']        = true,
}

local m = {}

---@alias guide.searchmode '"ref"'|'"def"'|'"field"'|'"allref"'|'"alldef"'

local pushDefResultsMap = util.switch()
    : case 'local'
    : case 'setlocal'
    : case 'setglobal'
    : case 'label'
    : case 'setfield'
    : case 'setmethod'
    : case 'setindex'
    : case 'tableindex'
    : case 'tablefield'
    : case 'tableexp'
    : case 'function'
    : case 'table'
    : case 'doc.class.name'
    : case 'doc.alias.name'
    : case 'doc.field.name'
    : case 'doc.type.enum'
    : case 'doc.resume'
    : case 'doc.type.array'
    : case 'doc.type.table'
    : case 'doc.type.ltable'
    : case 'doc.type.field'
    : case 'doc.type.function'
    : call(function (source, status)
        return true
    end)
    : case 'call'
    : call(function (source, status)
        if source.node.special == 'rawset' then
            return true
        end
    end)
    : getMap()

local pushRefResultsMap = util.switch()
    : case 'local'
    : case 'setlocal'
    : case 'getlocal'
    : case 'setglobal'
    : case 'getglobal'
    : case 'label'
    : case 'goto'
    : case 'setfield'
    : case 'getfield'
    : case 'setmethod'
    : case 'getmethod'
    : case 'setindex'
    : case 'getindex'
    : case 'tableindex'
    : case 'tablefield'
    : case 'tableexp'
    : case 'function'
    : case 'table'
    : case 'string'
    : case 'boolean'
    : case 'number'
    : case 'integer'
    : case 'nil'
    : case 'doc.class.name'
    : case 'doc.type.name'
    : case 'doc.alias.name'
    : case 'doc.extends.name'
    : case 'doc.field.name'
    : case 'doc.type.enum'
    : case 'doc.resume'
    : case 'doc.type.array'
    : case 'doc.type.table'
    : case 'doc.type.ltable'
    : case 'doc.type.field'
    : case 'doc.type.function'
    : call(function (source, status)
        return true
    end)
    : case 'call'
    : call(function (source, status)
        if source.node.special == 'rawset'
        or source.node.special == 'rawget' then
            return true
        end
    end)
    : getMap()

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
    local mark = status.rmark
    if mark[source] then
        return
    end
    mark[source] = true
    if force then
        results[#results+1] = source
        return
    end

    if mode == 'def' or mode == 'alldef' then
        local f = pushDefResultsMap[source.type]
        if f and f(source, status) then
            results[#results+1] = source
            return
        end
    elseif mode == 'ref' or mode == 'field' or mode == 'allref' then
        local f = pushRefResultsMap[source.type]
        if f and f(source, status) then
            results[#results+1] = source
            return
        end
    end

    local parent = source.parent
    if parent.type == 'return' then
        if noder.getID(source) ~= status.id then
            results[#results+1] = source
            return
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

local function checkLock(status, k1, k2)
    local locks = status.lock
    local lock1 = locks[k1]
    if not lock1 then
        lock1 = {}
        locks[k1] = lock1
    end
    if lock1[''] then
        return true
    end
    if k2 == nil then
        k2 = ''
    end
    if lock1[k2] then
        return true
    end
    lock1[k2] = true
    return false
end

local strs = {}
local function footprint(status, ...)
    if TRACE then
        log.debug(...)
    end
    if FOOTPRINT then
        local n = select('#', ...)
        for i = 1, n do
            strs[i] = tostring(select(i, ...))
        end
        status.footprint[#status.footprint+1] = tconcat(strs, '\t', 1, n)
    end
end

local function crossSearch(status, uri, expect, mode, sourceUri)
    if status.dontCross > 0 then
        return
    end
    if checkLock(status, uri, expect) then
        return
    end
    footprint(status, 'crossSearch', uri, expect)
    m.searchRefsByID(status, uri, expect, mode)
    --status.lock[uri] = nil
    footprint(status, 'crossSearch finish, back to:', sourceUri)
end

local function checkCache(status, uri, expect, mode)
    local cache = status.cache
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
    return false, function ()
        fileCache[expect] = status.results
        if mode == 'def' then
            return
        end
        for id in next, status.ids do
            fileCache[id] = status.results
        end
    end
end

local function stop(status, msg)
    if TEST then
        if FOOTPRINT then
            log.debug(status.mode)
            log.debug(tconcat(status.footprint, '\n'))
        end
        error(msg)
    else
        log.warn(msg)
        if FOOTPRINT then
            log.debug(status.mode)
            log.debug(tconcat(status.footprint, '\n'))
        end
        return
    end
end

local function checkSLock(status, slock, id, field)
    local cmark = slock[id]
    if not cmark then
        cmark = {}
        slock[id] = {}
    end
    if cmark[field or ''] then
        return false
    end
    cmark[field or ''] = true
    local right = ''
    while field and field ~= '' do
        local lastID = noder.getLastID(field)
        if not lastID then
            break
        end
        right = lastID .. right
        if cmark[right] then
            return false
        end
        field = ssub(field, 1, - #lastID - 1)
    end
    return true
end

local function isCallID(field)
    if not field then
        return false
    end
    if ssub(field, 1, 2) == noder.RETURN_INDEX then
        return true
    end
    return false
end

local genercCache = {
    mark = {},
    genericCallArgs = {},
    closureCache = {},
}

local function flushGeneric()
    --清除来自泛型的临时对象
    for _, closure in next, genercCache.closureCache do
        local noders = noder.getNoders(closure)
        noder.removeID(noders, noder.getID(closure))
        if closure then
            for _, value in ipairs(closure.values) do
                noder.removeID(noders, noder.getID(value))
            end
        end
    end
    genercCache.mark = {}
    genercCache.closureCache = {}
    genercCache.genericCallArgs = {}
end

files.watch(function (ev)
    if ev == 'version' then
        flushGeneric()
    end
end)

local nodersMapMT = {__index = function (self, uri)
    local noders = noder.getNodersByUri(uri)
    self[uri] = noders
    return noders
end}

local uriMapMT = {__index = function (self, uri)
    local t = {}
    self[uri] = t
    return t
end}

function m.searchRefsByID(status, furi, expect, mode)
    local ast = files.getState(furi)
    if not ast then
        return
    end
    local searchStep

    status.id = expect

    local slocks    = status.slock
    local elocks    = status.elock
    local callStack = status.callStack
    local ids       = status.ids
    ---@type table<uri, noders>
    local nodersMap  = setmetatable({}, nodersMapMT)
    local frejectMap = setmetatable({}, uriMapMT)
    local brejectMap = setmetatable({}, uriMapMT)

    local function search(uri, id, field)
        if not field then
            local cached = checkCache(status, uri, id, mode)
            if cached then
                return
            end
            ids[id] = true
        end
        local firstID = noder.getFirstID(id)
        if ignoredIDs[firstID] and (field or firstID ~= id) then
            return
        end
        local slock = slocks[uri]
        if not slock then
            slock = {}
            slocks[uri] = slock
        end

        if not checkSLock(status, slock, id, field) then
            footprint(status, 'slocked:', id, field)
            return
        end
        footprint(status, 'search:', id, field)
        searchStep(uri, id, field)
        footprint(status, 'pop:', id, field)
    end

    local function splitID(uri, id, field)
        if field then
            return
        end
        local leftID = ''
        local rightID

        while true do
            local firstID = noder.getHeadID(rightID or id)
            if not firstID or firstID == id then
                return
            end
            leftID  = leftID .. firstID
            if leftID == id then
                return
            end
            rightID = ssub(id, #leftID + 1)
            search(uri, leftID, rightID)
            local isCall = isCallID(firstID)
            if isCall then
                break
            end
        end
    end

    local function searchID(uri, id, field)
        if not id then
            return
        end
        if field then
            id = id .. field
        end
        search(uri, id, nil)
    end

    ---@return parser.guide.object?
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

    local genericCallArgs = genercCache.genericCallArgs
    local closureCache    = genercCache.closureCache
    local function checkGeneric(uri, source, field)
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
        local id = genercCache.mark[call]
        if id == false then
            return
        end
        if id then
            searchID(uri, id, field)
            return
        end

        if call.args then
            for _, arg in ipairs(call.args) do
                genericCallArgs[arg] = true
            end
        end

        local cacheID = uri .. noder.getID(source) .. noder.getID(call)
        local closure = closureCache[cacheID]
        if closure == false then
            genercCache.mark[call] = false
            return
        end
        if not closure then
            closure = generic.createClosure(source, call)
            closureCache[cacheID] = closure or false
            if not closure then
                genercCache.mark[call] = false
                return
            end
        end
        id = noder.getID(closure)
        genercCache.mark[call] = id
        searchID(uri, id, field)
    end

    local function checkENV(uri, source, field)
        if not field then
            return
        end
        if source.special ~= '_G' then
            return
        end
        local newID = 'g:' .. ssub(field, 2)
        searchID(uri, newID)
    end

    ---@param ward '"forward"'|'"backward"'
    ---@param info node.info
    local function checkThenPushReject(uri, ward, info)
        local reject = info.reject
        if not reject then
            return true
        end
        local checkReject
        local pushReject
        if ward == 'forward' then
            checkReject = brejectMap[uri]
            pushReject  = frejectMap[uri]
        else
            checkReject = frejectMap[uri]
            pushReject  = brejectMap[uri]
        end
        if checkReject[reject] and checkReject[reject] > 0 then
            return false
        end
        pushReject[reject] = (pushReject[reject] or 0) + 1
        return true
    end

    ---@param ward '"forward"'|'"backward"'
    ---@param info node.info
    local function popReject(uri, ward, info)
        local reject = info.reject
        if not reject then
            return
        end
        local popTags
        if ward == 'forward' then
            popTags = frejectMap[uri]
        else
            popTags = brejectMap[uri]
        end
        popTags[reject] = popTags[reject] - 1
    end

    ---@type table<node.filter, integer>
    local filters = {}

    ---@param id   string
    ---@param info node.info
    local function pushInfoFilter(id, field, info)
        local filter = info.filter
        if not filter then
            return
        end
        local filterValid = info.filterValid
        if filterValid and not filterValid(id, field) then
            return
        end
        filters[filter] = (filters[filter] or 0) + 1
    end

    ---@param id   string
    ---@param info node.info
    local function releaseInfoFilter(id, field, info)
        local filter = info.filter
        if not filter then
            return
        end
        local filterValid = info.filterValid
        if filterValid and not filterValid(id, field) then
            return
        end
        if filters[filter] <= 1 then
            filters[filter] = nil
        else
            filters[filter] = filters[filter] - 1
        end
    end

    ---@param id string
    ---@param info node.info
    local function checkInfoFilter(id, field, info)
        for filter in next, filters do
            if not filter(id, field) then
                return false
            end
        end
        return true
    end

    ---@param id string
    ---@param info node.info
    local function checkInfoBeforeForward(uri, id, field, info)
        pushInfoFilter(id, field, info)
        if not checkThenPushReject(uri, 'forward', info) then
            return false
        end
        return true
    end

    ---@param id string
    ---@param info node.info
    local function releaseInfoAfterForward(uri, id, field, info)
        popReject(uri, 'forward', info)
        releaseInfoFilter(id, field, info)
    end

    local function checkForward(uri, id, field)
        for forwardID, info in noder.eachForward(nodersMap[uri], id) do
            if info and not checkInfoBeforeForward(uri, forwardID, field, info) then
                goto CONTINUE
            end
            if not checkInfoFilter(forwardID, field, info) then
                goto CONTINUE
            end
            local targetUri, targetID = noder.getUriAndID(forwardID)
            if targetUri and not files.eq(targetUri, uri) then
                crossSearch(status, targetUri, targetID .. (field or ''), mode, uri)
            else
                searchID(uri, targetID or forwardID, field)
            end
            if info then
                releaseInfoAfterForward(uri, forwardID, field, info)
            end
            ::CONTINUE::
        end
    end

    ---@param id string
    ---@param field string
    ---@param info node.info
    local function checkInfoBeforeBackward(uri, id, field, info)
        if info.deep and mode ~= 'allref' then
            return false
        end
        if not checkThenPushReject(uri, 'backward', info) then
            return false
        end
        pushInfoFilter(id, field, info)
        if info.dontCross then
            status.dontCross = status.dontCross + 1
        end
        return true
    end

    ---@param id string
    ---@param field string
    ---@param info node.info
    local function releaseInfoAfterBackward(uri, id, field, info)
        popReject(uri, 'backward', info)
        releaseInfoFilter(id, field, info)
        if info.dontCross then
            status.dontCross = status.dontCross - 1
        end
    end

    local function checkBackward(uri, id, field)
        if ignoredIDs[id] then
            return
        end
        if mode ~= 'ref' and mode ~= 'field' and mode ~= 'allref' and not field then
            return
        end
        for backwardID, info in noder.eachBackward(nodersMap[uri], id) do
            if info and not checkInfoBeforeBackward(uri, backwardID, field, info) then
                goto CONTINUE
            end
            if not checkInfoFilter(backwardID, field, info) then
                goto CONTINUE
            end
            local targetUri, targetID = noder.getUriAndID(backwardID)
            if targetUri and not files.eq(targetUri, uri) then
                crossSearch(status, targetUri, targetID .. (field or ''), mode, uri)
            else
                searchID(uri, targetID or backwardID, field)
            end
            if info then
                releaseInfoAfterBackward(uri, backwardID, field, info)
            end
            ::CONTINUE::
        end
    end

    local function searchSpecial(uri, id, field)
        -- Special rule: ('').XX -> stringlib.XX
        if id == 'str:'
        or id == 'dn:string' then
            if field or mode == 'field' then
                searchID(uri, 'dn:stringlib', field)
            else
                searchID(uri, 'dn:string', field)
            end
        end
    end

    local function checkRequire(uri, requireName, field)
        if not requireName then
            return
        end
        local tid = 'mainreturn' .. (field or '')
        local uris = ws.findUrisByRequirePath(requireName)
        footprint(status, 'require:', requireName)
        for _, ruri in ipairs(uris) do
            if not files.eq(uri, ruri) then
                crossSearch(status, ruri, tid, mode, uri)
            end
        end
    end

    local function searchGlobal(uri, id, field)
        if ssub(id, 1, 2) ~= 'g:' then
            return
        end
        if checkLock(status, id, field) then
            return
        end
        local tid = id .. (field or '')
        footprint(status, 'checkGlobal:', id, field)
        local crossed = {}
        if mode == 'def'
        or mode == 'alldef'
        or mode == 'field'
        or field then
            for _, guri in collector.each('def:' .. id) do
                if files.eq(uri, guri) then
                    goto CONTINUE
                end
                crossSearch(status, guri, tid, mode, uri)
                ::CONTINUE::
            end
        else
            for _, guri in collector.each(id) do
                if crossed[guri] then
                    goto CONTINUE
                end
                if mode == 'def' or mode == 'alldef' or mode == 'field' then
                    goto CONTINUE
                end
                if files.eq(uri, guri) then
                    goto CONTINUE
                end
                crossSearch(status, guri, tid, mode, uri)
                ::CONTINUE::
            end
        end
    end

    local function searchClass(uri, id, field)
        if ssub(id, 1, 3) ~= 'dn:' then
            return
        end
        if checkLock(status, id, field) then
            return
        end
        local tid = id .. (field or '')
        local sid = id
        if ignoredIDs[id]
        or id == 'dn:string' then
            sid = 'def:' .. sid
        end
        for _, guri in collector.each(sid) do
            if not files.eq(uri, guri) then
                crossSearch(status, guri, tid, mode, uri)
            end
        end
    end

    local function checkMainReturn(uri, id, field)
        if id ~= 'mainreturn' then
            return
        end
        local calls = vm.getLinksTo(uri)
        for _, call in ipairs(calls) do
            local curi = guide.getUri(call)
            local cid  = noder.getID(call) .. (field or '')
            if not files.eq(curi, uri) then
                crossSearch(status, curi, cid, mode, uri)
            end
        end
    end

    local function lockExpanding(uri, id, field)
        local elock = elocks[uri]
        if not elock then
            elock = {}
            elocks[uri] = elock
        end
        local locked = elock[id]
        if locked and field then
            if #locked <= #field then
                if ssub(field, -#locked) == locked then
                    footprint(status, 'elocked:', id, locked, field)
                    return false
                end
            end
        end
        elock[id] = field
        return true
    end

    local function releaseExpanding(uri, id, field)
        local elock = elocks[uri]
        elock[id] = nil
    end

    local function searchNode(uri, id, field)
        local noders = nodersMap[uri]
        local call   = noders.call[id]
        callStack[#callStack+1] = call

        if field == nil and not ignoredSources[id] then
            for source in noder.eachSource(noders, id) do
                local force = genericCallArgs[source]
                m.pushResult(status, mode, source, force)
            end
        end

        local requireName = noders.require[id]
        if requireName then
            checkRequire(uri, requireName, field)
        end

        if lockExpanding(uri, id, field) then
            if noders.forward[id] then
                checkForward(uri, id, field)
            end
            if noders.backward[id] then
                checkBackward(uri, id, field)
            end
            releaseExpanding(uri, id, field)
        end

        local source = noders.source[id]
        if source then
            checkGeneric(uri, source, field)
            checkENV(uri, source, field)
        end

        if mode == 'allref' or mode == 'alldef' then
            checkMainReturn(uri, id, field)
        end

        if call then
            callStack[#callStack] = nil
        end

        return false
    end

    local function searchAnyField(uri, id, field)
        if mode == 'ref' or mode == 'allref' then
            return
        end
        local lastID = noder.getLastID(id)
        if not lastID then
            return
        end
        local originField = ssub(id, #lastID + 1)
        if originField == noder.TABLE_KEY
        or originField == noder.WEAK_TABLE_KEY then
            return
        end
        local anyFieldID   = lastID .. noder.ANY_FIELD
        searchNode(uri, anyFieldID, field)
    end

    local function searchWeak(uri, id, field)
        local lastID = noder.getLastID(id)
        if not lastID then
            return
        end
        local originField = ssub(id, #lastID + 1)
        if originField == noder.WEAK_TABLE_KEY then
            local newID   = lastID .. noder.TABLE_KEY
            searchNode(uri, newID, field)
        end
        if originField == noder.WEAK_ANY_FIELD then
            local newID   = lastID .. noder.ANY_FIELD
            searchNode(uri, newID, field)
        end
    end

    local stepCount = 0
    local stepMaxCount = 1e3
    local statusMaxCount = 1e4
    if mode == 'allref' or mode == 'alldef' then
        stepMaxCount = 1e4
        statusMaxCount = 1e5
    end

    function searchStep(uri, id, field)
        stepCount = stepCount + 1
        status.count = status.count + 1
        if stepCount > stepMaxCount
        or status.count > statusMaxCount then
            stop(status, 'too deep!')
            return
        end
        searchSpecial(uri, id, field)
        searchNode(uri, id, field)
        if field and nodersMap[uri].skip[id] then
            return
        end
        searchGlobal(uri, id, field)
        searchClass(uri, id, field)
        splitID(uri, id, field)
        searchAnyField(uri, id, field)
        searchWeak(uri, id, field)
    end

    search(furi, expect, nil)
end

local function prepareSearch(source)
    if not source then
        return
    end
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    if not source then
        return
    end
    local root = guide.getRoot(source)
    if not root then
        return
    end
    noder.compileNodes(root)
    local uri  = guide.getUri(source)
    local id   = noder.getID(source)
    return uri, id
end

local function getField(status, source, mode)
    if source.type == 'table' then
        for _, field in ipairs(source) do
            m.pushResult(status, mode, field)
        end
        return
    end
    if source.type == 'doc.type.ltable' then
        for _, field in ipairs(source.fields) do
            m.pushResult(status, mode, field)
        end
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
        for source in noder.eachSource(noders, fullID) do
            m.pushResult(status, mode, source)
        end
    else
        for id in next, noders.source do
            if  ssub(id, 1, 2) == 'g:'
            and not sfind(id, noder.SPLIT_CHAR) then
                for source in noder.eachSource(noders, id) do
                    m.pushResult(status, mode, source)
                end
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
        local fullID
        if type(name) == 'string' then
            fullID = sformat('%s%s%s', 'g:', noder.STRING_CHAR, name)
        else
            fullID = sformat('%s%s%s', 'g:', '', name)
        end
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

    local cached, makeCache = checkCache(status, uri, id, mode)

    if cached then
        return
    end

    if TRACE then
        log.debug('searchRefs:', id)
    end
    m.searchRefsByID(status, uri, id, mode)
    makeCache()
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
            local cached, makeCache = checkCache(status, uri, '*', mode)
            if cached then
                return
            end
            searchAllGlobals(status, mode)
            makeCache()
        else
            local cached, makeCache = checkCache(status, uri, id .. '*', mode)
            if cached then
                return
            end
            local newStatus = m.status('field')
            m.searchRefsByID(newStatus, uri, id, 'field')
            for _, def in ipairs(newStatus.results) do
                getField(status, def, mode)
            end
            makeCache()
        end
    else
        if source.special == '_G' then
            local fullID
            if type(field) == 'string' then
                fullID = sformat('%s%s%s', 'g:', noder.STRING_CHAR, field)
            else
                fullID = sformat('%s%s%s', 'g:', '', field)
            end
            local cahced, makeCache = checkCache(status, uri, fullID, mode)
            if cahced then
                return
            end
            m.searchRefsByID(status, uri, fullID, mode)
            makeCache()
        else
            local fullID
            if type(field) == 'string' then
                fullID = sformat('%s%s%s', id, noder.STRING_FIELD, field)
            else
                fullID = sformat('%s%s%s', id, noder.SPLIT_CHAR, field)
            end
            local cahced, makeCache = checkCache(status, uri, fullID, mode)
            if cahced then
                return
            end
            m.searchRefsByID(status, uri, fullID, mode)
            makeCache()
        end
    end
end

---@class guide.status
---搜索结果
---@field results parser.guide.object[]
---@field rmark   table
---@field id      string

---创建搜索状态
---@param mode guide.searchmode
---@return guide.status
function m.status(mode)
    local status = {
        callStack = {},
        crossed   = {},
        lock      = {},
        slock     = {},
        elock     = {},
        results   = {},
        rmark     = {},
        smark     = {},
        footprint = {},
        count     = 0,
        ids       = {},
        ftag      = {},
        btag      = {},
        dontCross = 0,
        mode      = mode,
        cache     = vm.getCache('searcher:' .. mode),
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

--- 请求对象的全部定义（深度搜索）
---@param obj       parser.guide.object
---@param field?    string
---@return parser.guide.object[]
function m.requestAllDefinition(obj, field)
    local status = m.status('alldef')

    if field then
        m.searchFields(status, obj, 'alldef', field)
    else
        m.searchRefs(status, obj, 'alldef')
    end

    return status.results
end

--m.requestReference = m.requestAllReference
--m.requestDefinition = m.requestAllDefinition

return m
