local guide     = require 'parser.guide'
local util      = require 'utility'
local union     = require 'vm.union'
local localID   = require 'vm.local-id'
local localMgr  = require 'vm.local-manager'
local globalMgr = require 'vm.global-manager'

---@class parser.object
---@field _compiledNodes  boolean
---@field _node           vm.node

---@class vm.node.compiler
local m = {}

---@class vm.node.cross

---@alias vm.node parser.object | vm.node.union | vm.node.cross | vm.node.global

function m.setNode(source, node)
    if not node then
        return
    end
    local me = source._node
    if not me then
        source._node = node
        return
    end
    if me == node then
        return
    end
    if me.type == 'union'
    or me.type == 'cross' then
        me:merge(node)
        return
    end
    source._node = union(me, node)
end

function m.eachNode(node)
    if node.type == 'union' then
        return node:eachNode()
    end
    local first = true
    return function ()
        if first then
            first = false
            return node
        end
        return nil
    end
end

local searchFieldMap = util.switch()
    : case 'table'
    : call(function (node, key, pushResult)
        for _, field in ipairs(node) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                if guide.getKeyName(field) == key then
                    pushResult(field)
                end
            end
        end
    end)
    : case 'global'
    ---@param node vm.node.global
    : call(function (node, key, pushResult)
        if node.cate == 'variable' then
            local global = globalMgr.getGlobal('variable', node.name, key)
            if global then
                pushResult(global)
            end
        end
        if node.cate == 'type' then
            m.getClassFields(node, key, pushResult)
        end
    end)
    : case 'local'
    : call(function (node, key, pushResult)
        local sources = localID.getSources(node, key)
        if sources then
            for _, src in ipairs(sources) do
                pushResult(src)
            end
        end
    end)
    : getMap()


function m.getClassFields(node, key, pushResult)
    local mark = {}
    local function searchClass(class)
        local name = class.name
        if mark[name] then
            return
        end
        mark[name] = true
        for _, set in ipairs(class:getSets()) do
            if set.type == 'doc.class' then
                -- check ---@field
                local hasFounded
                for _, field in ipairs(set.fields) do
                    if guide.getKeyName(field) == key then
                        hasFounded = true
                        pushResult(field)
                    end
                end
                -- check local field and global field
                if set.bindSources then
                    for _, src in ipairs(set.bindSources) do
                        if searchFieldMap[src.type] then
                            searchFieldMap[src.type](src, key, function (src)
                                hasFounded = true
                                pushResult(src)
                            end)
                        end
                    end
                end
                -- look into extends(if field not found)
                if not hasFounded and set.extends then
                    for _, extend in ipairs(set.extends) do
                        local extendType = globalMgr.getGlobal('type', extend[1])
                        if extendType then
                            searchClass(extendType)
                        end
                    end
                end
            end
        end
    end
    searchClass(node)
end

local function getReturnOfFunction(func, index)
    if not func._returns then
        func._returns = util.defaultTable(function ()
            return {
                type   = 'function.return',
                parent = func,
                index  = index,
            }
        end)
    end
    return m.compileNode(func._returns[index])
end

local function getReturnOfSetMetaTable(source, args)
    local tbl = args and args[1]
    local mt  = args and args[2]
    if tbl then
        m.setNode(source, m.compileNode(tbl))
    end
    if mt then
        m.compileByParentNode(mt, '__index', function (src)
            m.setNode(source, m.compileNode(src))
        end)
    end
    return source._node
end

local function getReturn(func, index, source, args)
    if func.special == 'setmetatable' then
        return getReturnOfSetMetaTable(source, args)
    end
    local node = m.compileNode(func)
    if node then
        for cnode in m.eachNode(node) do
            if cnode.type == 'function' then
                return getReturnOfFunction(cnode, index)
            end
        end
    end
end

local function compileByLocalID(source)
    local sources = localID.getSources(source)
    if not sources then
        return
    end
    for _, src in ipairs(sources) do
        if src.value then
            m.setNode(source, m.compileNode(src.value))
        end
    end
end

---@param source vm.node
---@param key any
---@param pushResult fun(source: parser.object)
function m.compileByParentNode(source, key, pushResult)
    local parentNode = m.compileNode(source)
    if not parentNode then
        return
    end
    for node in m.eachNode(parentNode) do
        local f = searchFieldMap[node.type]
        if f then
            f(node, key, pushResult)
        end
    end
end

local function selectNode(source, list, index)
    local exp
    if list[index] then
        exp = list[index]
    else
        for i = index, 1, -1 do
            if list[i] then
                exp = list[i]
                if exp.type == 'call'
                or exp.type == '...' then
                    index = index - i + 1
                end
                break
            end
        end
    end
    if not exp then
        return nil
    end
    if exp.type == 'call' then
        return getReturn(exp.node, index, source, exp.args)
    end
    if exp.type == '...' then
        -- TODO
    end
    return m.compileNode(exp)
end

local function bindDocs(source)
    local hasFounded = false
    local isParam = source.parent.type == 'funcargs'
    for _, doc in ipairs(source.bindDocs) do
        if doc.type == 'doc.type' then
            if not isParam then
                hasFounded = true
                m.setNode(source, m.compileNode(doc))
            end
        end
        if doc.type == 'doc.param' then
            if isParam and source[1] == doc.param[1] then
                hasFounded = true
                m.setNode(source, m.compileNode(doc))
            end
        end
    end
    return hasFounded
end

local compilerMap = util.switch()
    : case 'boolean'
    : case 'table'
    : case 'integer'
    : case 'number'
    : case 'string'
    : case 'doc.type.function'
    : case 'doc.type.table'
    : call(function (source)
        localMgr.declareLocal(source)
        m.setNode(source, source)
    end)
    : case 'function'
    : call(function (source)
        localMgr.declareLocal(source)
        m.setNode(source, source)

        if source.bindDocs then
            for _, doc in ipairs(source.bindDocs) do
                if doc.type == 'doc.overload' then
                    m.setNode(source, m.compileNode(doc))
                end
            end
        end
    end)
    : case 'local'
    : call(function (source)
        m.setNode(source, source)
        local hasMarkDoc
        if source.bindDocs then
            hasMarkDoc = bindDocs(source)
        end
        if source.ref and not hasMarkDoc then
            for _, ref in ipairs(source.ref) do
                if ref.type == 'setlocal' then
                    m.setNode(source, m.compileNode(ref.value))
                end
            end
        end
        if source.dummy and not hasMarkDoc then
            m.setNode(source, m.compileNode(source.method.node))
        end
        if source.value then
            if not hasMarkDoc or guide.isLiteral(source.value) then
                m.setNode(source, m.compileNode(source.value))
            end
        end
        -- function x.y(self, ...) --> function x:y(...)
        if  source[1] == 'self'
        and not hasMarkDoc
        and source.parent.type == 'funcargs'
        and source.parent[1] == source then
            local setfield = source.parent.parent.parent
            if setfield.type == 'setfield' then
                m.setNode(source, m.compileNode(setfield.node))
            end
        end
    end)
    : case 'getlocal'
    : call(function (source)
        m.setNode(source, m.compileNode(source.node))
    end)
    : case 'setfield'
    : case 'setmethod'
    : case 'setindex'
    : call(function (source)
        compileByLocalID(source)
    end)
    : case 'getfield'
    : case 'getmethod'
    : case 'getindex'
    : call(function (source)
        compileByLocalID(source)
        m.compileByParentNode(source.node, guide.getKeyName(source), function (src)
            m.setNode(source, m.compileNode(src))
        end)
    end)
    : case 'tablefield'
    : case 'tableindex'
    : call(function (source)
        if source.value then
            m.setNode(source, m.compileNode(source.value))
        end
    end)
    : case 'field'
    : case 'method'
    : call(function (source)
        m.setNode(source, m.compileNode(source.parent))
    end)
    : case 'function.return'
    : call(function (source)
        local func  = source.parent
        local index = source.index
        if func.returns then
            for _, rtn in ipairs(func.returns) do
                m.setNode(source, selectNode(source, rtn, index))
            end
        end
    end)
    : case 'select'
    : call(function (source)
        local vararg = source.vararg
        if vararg.type == 'call' then
            m.setNode(source, getReturn(vararg.node, source.sindex, source, vararg.args))
        end
    end)
    : case 'doc.type'
    : call(function (source)
        for _, typeUnit in ipairs(source.types) do
            m.setNode(source, m.compileNode(typeUnit))
        end
    end)
    : case 'doc.type.name'
    : call(function (source)
        local name = source[1]
        local uri  = guide.getUri(source)
        local type = globalMgr.declareGlobal('type', name, uri)
        type:addGet(uri, source)
        m.setNode(source, type)
    end)
    : case 'doc.field'
    : call(function (source)
        m.setNode(source, m.compileNode(source.extends))
    end)
    : case 'doc.extends.name'
    : call(function (source)
        local name = source[1]
        local uri  = guide.getUri(source)
        local type = globalMgr.declareGlobal('type', name, uri)
        type:addGet(uri, source)
        m.setNode(source, type)
    end)
    : case 'doc.param'
    : call(function (source)
        m.setNode(source, m.compileNode(source.extends))
    end)
    : case 'doc.vararg'
    : call(function (source)
        m.setNode(source, m.compileNode(source.vararg))
    end)
    : case '...'
    : call(function (source)
        local func = source.parent.parent
        if func.type ~= 'function' then
            return
        end
        if not func.bindDocs then
            return
        end
        for _, doc in ipairs(func.bindDocs) do
            if doc.type == 'doc.vararg' then
                m.setNode(source, m.compileNode(doc))
            end
            if doc.type == 'doc.param' and doc.param[1] == '...' then
                m.setNode(source, m.compileNode(doc))
            end
        end
    end)
    : case 'doc.overload'
    : call(function (source)
        m.setNode(source, m.compileNode(source.overload))
    end)
    : getMap()

---@param source parser.object
local function compileByNode(source)
    local compiler = compilerMap[source.type]
    if compiler then
        compiler(source)
    end
end

---@param source parser.object
local function compileByGlobal(source)
    if source.type == 'global' then
        m.setNode(source, source)
        return
    end
    if source._globalNode then
        m.setNode(source, source._globalNode)
        for _, set in ipairs(source._globalNode:getSets()) do
            if set.value then
                m.setNode(source, m.compileNode(set.value))
            end
        end
        return
    end
end

---@param source parser.object
---@return vm.node
function m.compileNode(source)
    if source._node ~= nil then
        return source._node
    end
    source._node = false
    compileByGlobal(source)
    compileByNode(source)

    localMgr.subscribeLocal(source, source._node)

    return source._node
end

return m
