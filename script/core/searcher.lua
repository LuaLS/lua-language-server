local linker = require 'core.linker'
local guide  = require 'parser.guide'
local files  = require 'files'

local MARK_CHAR = '\x1E'

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
---@param source parser.guide.object
function m.pushResult(status, mode, source)
    if not source then
        return
    end
    local results = status.results
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
            if linker.getID(source) ~= status.id then
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
        or source.type == 'doc.class.name'
        or source.type == 'doc.type.name'
        or source.type == 'doc.alias.name'
        or source.type == 'doc.extends.name'
        or source.type == 'doc.field.name'
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
    local searchStep
    linker.compileLinks(root)

    status.id = expect

    local mark = status.mark
    local queueIndex  = 0

    -- 缓存过程中的泛型，以泛型关联表为key
    local genericStashMap = {}

    local function search(id, field)
        local fieldLen
        if field then
            local _, len = field:gsub(linker.SPLIT_CHAR, '')
            fieldLen = len
        else
            fieldLen = 0
        end
        if mark[id] and mark[id] <= fieldLen then
            return
        end
        mark[id] = fieldLen
        queueIndex = queueIndex + 1
        searchStep(id, field)
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
        if not id then
            return
        end
        if field then
            id = id .. field
        end
        search(id, nil)
    end

    local function searchFunction(id)
        local link = linker.getLinkByID(root, id)
        if not link or not link.sources then
            return
        end
        local obj = link.sources[1]
        if not obj or obj.type ~= 'function' then
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

    local callStash = {}

    local function getGenericID(typeUnit, call, index)
        local key = typeUnit[1]
        local generics = typeUnit.typeGeneric[key]
        local callParam = call.args[index]
        if not callParam then
            return nil
        end
        if typeUnit.literal then
            if callParam.type == 'string' then
                return generics, ('dn:%s'):format(callParam[1] or '')
            end
        else
            return generics, linker.getID(callParam)
        end
        return nil
    end

    local function genericStashParam(docType, call, index)
        for _, typeUnit in ipairs(docType.types) do
            if typeUnit.typeGeneric then
                local generics, id = getGenericID(typeUnit, call, index)
                if id then
                    genericStashMap[generics] = id
                end
            end
            -- 支持 V[]
            if typeUnit.type == 'doc.type.array' then
                if typeUnit.node.typeGeneric then
                    local generics, id = getGenericID(typeUnit.node, call, index)
                    if id then
                        genericStashMap[generics] = id .. linker.SPLIT_CHAR
                    end
                end
            end
            -- 支持 table<number, V>
            if typeUnit.type == 'doc.type.table' then
                if typeUnit.value then
                    for _, typeUnit2 in ipairs(typeUnit.value.types) do
                        if typeUnit2.typeGeneric then
                            local generics, id = getGenericID(typeUnit2, call, index)
                            if id then
                                genericStashMap[generics] = id .. linker.SPLIT_CHAR
                            end
                        end
                    end
                end
            end
        end
    end

    -- TODO 这里的实现是有问题的，在多次穿透泛型时可能出错，不过错就错吧，让用户自己写注解
    local function genericStash(source)
        if source.type ~= 'function'
        and source.type ~= 'doc.type.function' then
            return
        end
        local top = #callStash
        if top == 0 then
            return
        end
        local call = callStash[top]
        callStash[top] = nil
        if not call.args then
            return
        end
        if source.type == 'function' then
            if not source.docParamMap then
                return
            end
            for index, param in ipairs(source.args) do
                local docParam = param.docParam
                if docParam then
                    genericStashParam(docParam.extends, call, index)
                end
            end
        end
        if source.type == 'doc.type.function' then
            for index, param in ipairs(source.args) do
                genericStashParam(param.extends, call, index)
            end
        end
    end

    local function genericResolve(source, field)
        if not source.typeGeneric then
            return
        end
        local key = source[1]
        local generics = source.typeGeneric[key]
        local paramID = genericStashMap[generics]
        if paramID then
            searchID(paramID, field)
        end
    end

    local stepCount = 0
    function searchStep(id, field)
        stepCount = stepCount + 1
        if stepCount > 1000 then
            error('too large')
        end
        local link = linker.getLinkByID(root, id)
        if link then
            if field == nil and link.sources then
                for _, source in ipairs(link.sources) do
                    m.pushResult(status, mode, source)
                end
            end
            if link.forward then
                for _, forwardID in ipairs(link.forward) do
                    searchID(forwardID, field)
                end
            end
            if link.backward and (mode == 'ref' or field) then
                for _, backwardID in ipairs(link.backward) do
                    searchID(backwardID, field)
                end
            end

            if link.sources then
                genericStash(link.sources[1])
                genericResolve(link.sources[1], field)
            end
        end
        checkLastID(id, field)
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
