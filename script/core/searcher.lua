local linker = require 'core.linker'
local guide  = require 'parser.guide'
local files  = require 'files'

local m = {}

---@alias guide.searchmode '"ref"'|'"def"'|'"field"'

---添加结果
---@param status guide.status
---@param mode   guide.searchmode
---@param ref    parser.guide.object
function m.pushResult(status, mode, ref)
    local results = status.results
    if mode == 'def' then
        if ref.type == 'local'
        or ref.type == 'setlocal'
        or ref.type == 'setglobal'
        or ref.type == 'label'
        or ref.type == 'setfield'
        or ref.type == 'setmethod'
        or ref.type == 'setindex'
        or ref.type == 'tableindex'
        or ref.type == 'tablefield'
        or ref.type == 'function' then
            results[#results+1] = ref
        end
    elseif mode == 'ref' then
        if ref.type == 'local'
        or ref.type == 'setlocal'
        or ref.type == 'getlocal'
        or ref.type == 'setglobal'
        or ref.type == 'getglobal'
        or ref.type == 'label'
        or ref.type == 'goto'
        or ref.type == 'setfield'
        or ref.type == 'getfield'
        or ref.type == 'setmethod'
        or ref.type == 'getmethod'
        or ref.type == 'setindex'
        or ref.type == 'getindex'
        or ref.type == 'tableindex'
        or ref.type == 'tablefield'
        or ref.type == 'function' then
            results[#results+1] = ref
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
    linker.compileLinks(root)
    -- TODO
    return {}
end

-- TODO
function m.isGlobal(source)
    return false
end

function m.searchRefsByID(status, uri, expect, mode)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    local root = ast.ast
    linker.compileLinks(root)

    local search

    local function checkLastID(id, field)
        local lastID = linker.getLastID(root, id)
        if lastID then
            local newField = id:sub(#lastID + 1)
            if field then
                newField = newField .. field
            end
            search(lastID, newField)
        end
    end

    local function searchSource(obj, field)
        local link = linker.getLink(obj)
        if not link then
            return
        end
        local id = link.id
        checkLastID(id, field)
        if field then
            id = id .. field
        end
        search(id)
    end

    local function getReturnSetByFunc(func, index)
        local call = func.parent
        if call.type ~= 'call' then
            return nil
        end
        if index == 0 then
            return nil
        end
        if index == 1 then
            return call.parent
        else
            for _, sel in ipairs(call.extParent) do
                if sel.index == index then
                    return sel
                end
            end
        end
        return nil
    end

    local function searchFunction(id)
        local funcs = linker.getLinksByID(root, id)
        if not funcs then
            return
        end
        local obj = funcs[1].source
        if obj.type ~= 'function' then
            return
        end
        local link = linker.getLink(obj)
        if not link then
            return
        end
        if not link.freturn then
            return
        end
        local func = guide.getParentFunction(obj)
        if not func or func.type ~= 'function' then
            return
        end
        local newStatus = m.status(status)
        m.searchRefs(newStatus, func, 'ref')
        for _, ref in ipairs(newStatus.results) do
            local set = getReturnSetByFunc(ref, link.freturn)
            if set then
                local id = linker.getID(set)
                if id then
                    search(id)
                end
            end
        end
    end

    local function checkForward(link, field)
        if not link.forward then
            return
        end
        for _, forwardSources in ipairs(link.forward) do
            searchSource(forwardSources, field)
        end
    end

    local function checkBackward(link, field)
        if not link.backward then
            return
        end
        for _, backSources in ipairs(link.backward) do
            searchSource(backSources, field)
        end
    end

    local stackCount = 0
    local mark = {}
    search = function (id, field)
        if mark[id] then
            return
        end
        mark[id] = true
        local links = linker.getLinksByID(root, id)
        if not links then
            return
        end
        stackCount = stackCount + 1
        if stackCount >= 10 then
            error('stack overflow')
        end
        for _, eachLink in ipairs(links) do
            if field == nil then
                m.pushResult(status, mode, eachLink.source)
            end
            checkForward(eachLink,  field)
            checkBackward(eachLink, field)
        end
        stackCount = stackCount - 1
    end

    search(expect)
    checkLastID(expect)
    searchFunction(expect)
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
    local uri = guide.getUri(source)
    local id  = linker.getID(source)
    if not id then
        return
    end

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
        share     = parentStatus and parentStatus.share       or {
            count = 0,
        },
        interface = parentStatus and parentStatus.interface   or {},
        results   = {},
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

return m
