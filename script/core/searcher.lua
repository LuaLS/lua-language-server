local linker = require 'core.linker'
local guide  = require 'parser.guide'
local files  = require 'files'

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
        or ref.type == 'function'
        or ref.type == 'doc.class.name'
        or ref.type == 'doc.alias.name' then
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
        or ref.type == 'function'
        or ref.type == 'doc.class.name'
        or ref.type == 'doc.type.name'
        or ref.type == 'doc.alias.name'
        or ref.type == 'doc.extends.name' then
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

    local function searchSource(idOrObj, field)
        local id
        if type(idOrObj) == 'string' then
            id = idOrObj
        else
            local link = linker.getLink(idOrObj)
            if not link then
                return
            end
            id = link.id
        end
        search(id, field)
        if field then
            id = id .. field
            search(id)
        end
    end

    local function getCallSelectByReturnIndex(func, index)
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
        local returnIndex = checkFunctionReturn(obj)
        if not returnIndex then
            return
        end
        local func = guide.getParentFunction(obj)
        if not func or func.type ~= 'function' then
            return
        end
        local parentID = linker.getID(func)
        if not parentID then
            return
        end
        search(parentID, ':' .. returnIndex)
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

    local function checkSpecial(link, field)
        local special = link.special
        if not special then
            return
        end
        if special.call then
            local newStatus = m.status(status)
            m.searchRefs(newStatus, special.call.node, 'def')
            for _, res in ipairs(newStatus.results) do
                local returns = linker.getSpecial(res, 'returns')
                if returns and returns[special.index] then
                    for _, rtn in ipairs(returns[special.index]) do
                        searchSource(rtn, field)
                    end
                end
            end
        end
        if special.returns then
            local newStatus = m.status(status)
            --m.searchRefs(newStatus, special.call.node, 'def')
        end
    end

    local stackCount = 0
    local mark = status.mark
    search = function (id, field)
        if not id then
            return
        end
        if mark[id] then
            return
        end
        mark[id] = true
        stackCount = stackCount + 1
        local links = linker.getLinksByID(root, id)
        if links then
            if stackCount >= 20 then
                error('stack overflow')
            end
            for _, eachLink in ipairs(links) do
                if field == nil then
                    m.pushResult(status, mode, eachLink.source)
                end
                checkForward(eachLink,    field)
                checkBackward(eachLink,   field)
                --checkSpecial(eachLink,    field)
            end
        end
        checkLastID(id, field)
        stackCount = stackCount - 1
    end

    search(expect)
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
    local root = guide.getRoot(source)
    linker.compileLinks(root)
    local uri  = guide.getUri(source)
    local id   = linker.getID(source)
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
        mark      = parentStatus and parentStatus.mark or {},
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
