local linker = require 'core.linker'
local guide  = require 'parser.guide'
local files  = require 'files'

local UNI_CHAR = '~'

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
    if not ref then
        return
    end
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
    or obj.type == 'string'
    or obj.type == 'doc.type.table'
    or obj.type == 'doc.type.arrary' then
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

function m.searchRefsByID(status, uri, expect, mode)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    local root = ast.ast
    linker.compileLinks(root)

    local mark = status.mark
    local queueIDs    = {}
    local queueFields = {}
    local index       = 0

    local function search(id, field)
        if mark[id] then
            return
        end
        mark[id] = true
        index = index + 1
        queueIDs[index]    = id
        queueFields[index] = field
    end

    local function checkLastID(id, field)
        local lastID = linker.getLastID(id)
        if lastID then
            local newField = id:sub(#lastID + 1)
            if field then
                newField = newField .. field
            end
            search(lastID, newField)
        end
    end

    local function searchID(id, field)
        if field then
            id = id .. field
        end
        search(id)
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
        search(parentID, linker.SPLIT_CHAR .. linker.RETURN_INDEX_CHAR .. returnIndex)
    end

    local function checkForward(link, field)
        if not link.forward then
            return
        end
        for _, id in ipairs(link.forward) do
            searchID(id, field)
        end
    end

    local function checkBackward(link, field)
        if not link.backward then
            return
        end
        if mode == 'def' and not field then
            return
        end
        for _, id in ipairs(link.backward) do
            searchID(id, field)
        end
    end

    search(expect)
    searchFunction(expect)

    for _ = 1, 1000 do
        if index <= 0 then
            return
        end
        local id    = queueIDs[index]
        local field = queueFields[index]
        index = index - 1

        local links = linker.getLinksByID(root, id)
        if links then
            for _, eachLink in ipairs(links) do
                if field == nil then
                    m.pushResult(status, mode, eachLink.source)
                end
                checkForward(eachLink,    field)
                checkBackward(eachLink,   field)
            end
        end
        checkLastID(id, field)
    end
    error('too large')
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
