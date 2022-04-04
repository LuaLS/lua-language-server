local guide      = require 'parser.guide'
local util       = require 'utility'
local localID    = require 'vm.local-id'
local globalMgr  = require 'vm.global-manager'
local nodeMgr    = require 'vm.node'
local signMgr    = require 'vm.sign'
local config     = require 'config'
local union      = require 'vm.union'
local genericMgr = require 'vm.generic'
local rpath      = require 'workspace.require-path'
local files      = require 'files'

---@class parser.object
---@field _compiledNodes  boolean
---@field _node           vm.node

---@class vm.node.compiler
local m = {}

local searchFieldSwitch = util.switch()
    : case 'table'
    : call(function (node, key, pushResult)
        local hasFiled = false
        for _, field in ipairs(node) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                if key == nil
                or key == guide.getKeyName(field) then
                    hasFiled = true
                    pushResult(field)
                end
            end
            if field.type == 'tableexp' then
                if key == nil
                or key == field.tindex then
                    hasFiled = true
                    pushResult(field)
                end
            end
            if field.type == 'varargs' then
                if not hasFiled
                and type(key) == 'number'
                and key >= 1
                and math.tointeger(key) then
                    hasFiled = true
                    pushResult(field)
                end
                if key == nil then
                    pushResult(field)
                end
            end
        end
    end)
    : case 'global'
    ---@param node vm.node.global
    : call(function (node, key, pushResult)
        if node.cate == 'variable' then
            if key then
                local global = globalMgr.getGlobal('variable', node.name, key)
                if global then
                    pushResult(global)
                end
            else
                local globals = globalMgr.getFields('variable', node.name)
                for _, global in ipairs(globals) do
                    pushResult(global)
                end
            end
        end
        if node.cate == 'type' then
            m.getClassFields(node, key, pushResult)
        end
    end)
    : case 'string'
    : call(function (node, key, pushResult)
        -- change to `string: stringlib` ?
        local stringlib = globalMgr.getGlobal('type', 'stringlib')
        m.getClassFields(stringlib, key, pushResult)
    end)
    : case 'local'
    : call(function (node, key, pushResult)
        local fields = key and localID.getSources(node, key) or localID.getFields(node)
        if fields then
            for _, src in ipairs(fields) do
                pushResult(src)
            end
        end
    end)
    : case 'doc.type.array'
    : call(function (node, key, pushResult)
        if  type(key) == 'number'
        and key >= 1
        and math.tointeger(key) then
            pushResult(node.node)
        end
        if key == nil then
            pushResult(node.node)
        end
    end)
    : case 'doc.type.table'
    : call(function (node, key, pushResult)
        for _, field in ipairs(node.fields) do
            local fieldKey = field.name
            if fieldKey.type == 'doc.type' then
                local fieldNode = m.compileNode(fieldKey)
                for fn in nodeMgr.eachNode(fieldNode) do
                    if fn.type == 'global' and fn.cate == 'type' then
                        if key == nil
                        or fn.name == 'any'
                        or (fn.name == 'boolean' and type(key) == 'boolean')
                        or (fn.name == 'number'  and type(key) == 'number')
                        or (fn.name == 'integer' and math.tointeger(key))
                        or (fn.name == 'string'  and type(key) == 'string') then
                            pushResult(field.extends)
                        end
                    end
                end
            end
            if fieldKey.type == 'doc.field.name' then
                if key == nil or fieldKey[1] == key then
                    pushResult(field.extends)
                end
            end
        end
    end)


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
                    if key == nil
                    or guide.getKeyName(field) == key then
                        hasFounded = true
                        pushResult(field)
                    end
                end
                -- check local field and global field
                if set.bindSources then
                    for _, src in ipairs(set.bindSources) do
                        searchFieldSwitch(src.type, src, key, function (field)
                            if guide.isSet(field) then
                                hasFounded = true
                                pushResult(field)
                            end
                        end)
                        if src._globalNode then
                            searchFieldSwitch('global', src._globalNode, key, function (field)
                                hasFounded = true
                                pushResult(field)
                            end)
                        end
                    end
                end
                -- look into extends(if field not found)
                if not hasFounded and set.extends then
                    for _, extend in ipairs(set.extends) do
                        if extend.type == 'doc.extends.name' then
                            local extendType = globalMgr.getGlobal('type', extend[1])
                            if extendType then
                                searchClass(extendType)
                            end
                        end
                    end
                end
            end
        end
    end

    local function searchGlobal(class)
        if class.cate == 'type' and class.name == '_G' then
            local globals = globalMgr.getGlobals('variable')
            for _, global in ipairs(globals) do
                local sets = global:getSets()
                for _, set in ipairs(sets) do
                    pushResult(set)
                end
            end
        end
    end

    searchClass(node)
    searchGlobal(node)
end

---@class parser.object
---@field _sign? vm.sign

---@param source parser.object
---@return vm.sign?
local function getObjectSign(source)
    if source._sign ~= nil then
        return source._sign
    end
    source._sign = false
    if source.type == 'function' then
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == 'doc.generic' then
                if not source._sign then
                    source._sign = signMgr()
                    break
                end
            end
        end
        if not source._sign then
            return false
        end
        if source.args then
            for _, arg in ipairs(source.args) do
                local argNode = m.compileNode(arg)
                if arg.optional then
                    argNode = nodeMgr.addOptional(argNode)
                end
                source._sign:addSign(argNode)
            end
        end
    end
    if source.type == 'doc.type.function'
    or source.type == 'doc.type.table' then
        local hasGeneric
        guide.eachSourceType(source, 'doc.generic.name', function ()
            hasGeneric = true
        end)
        if not hasGeneric then
            return false
        end
        source._sign = signMgr()
        if source.type == 'doc.type.function' then
            for _, arg in ipairs(source.args) do
                local argNode = m.compileNode(arg.extends)
                if arg.optional then
                    argNode = nodeMgr.addOptional(argNode)
                end
                source._sign:addSign(argNode)
            end
        end
    end
    return source._sign
end

function m.getReturnOfFunction(func, index)
    if func.type == 'function' then
        if not func._returns then
            func._returns = {}
        end
        if not func._returns[index] then
            func._returns[index] = {
                type   = 'function.return',
                parent = func,
                index  = index,
            }
        end
        return m.compileNode(func._returns[index])
    end
    if func.type == 'doc.type.function' then
        local rtn = func.returns[index]
        if not rtn then
            return nil
        end
        local rtnNode = m.compileNode(rtn)
        local sign = getObjectSign(func)
        if not sign then
            return rtnNode
        end
        return genericMgr(rtnNode, sign)
    end
end

local function getReturnOfSetMetaTable(args)
    local tbl  = args and args[1]
    local mt   = args and args[2]
    local node = union()
    if tbl then
        node:merge(m.compileNode(tbl))
    end
    if mt then
        m.compileByParentNode(mt, '__index', function (src)
            for n in nodeMgr.eachNode(m.compileNode(src)) do
                if n.type == 'global'
                or n.type == 'local'
                or n.type == 'table'
                or n.type == 'doc.type.table' then
                    node:merge(n)
                end
            end
        end)
    end
    return node
end

local function getReturn(func, index, args)
    if func.special == 'setmetatable' then
        return getReturnOfSetMetaTable(args)
    end
    if func.special == 'pcall' and index > 1 then
        local newArgs = {}
        for i = 2, #args do
            newArgs[#newArgs+1] = args[i]
        end
        return getReturn(args[1], index - 1, newArgs)
    end
    if func.special == 'xpcall' and index > 1 then
        local newArgs = {}
        for i = 3, #args do
            newArgs[#newArgs+1] = args[i]
        end
        return getReturn(args[1], index - 1, newArgs)
    end
    if func.special == 'require' then
        local nameArg = args[1]
        if not nameArg or nameArg.type ~= 'string' then
            return nil
        end
        local name = nameArg[1]
        if not name or type(name) ~= 'string' then
            return nil
        end
        local uri = rpath.findUrisByRequirePath(guide.getUri(func), name)[1]
        if not uri then
            return nil
        end
        local state = files.getState(uri)
        local ast   = state and state.ast
        if not ast then
            return nil
        end
        return m.compileNode(ast)
    end
    local node = m.compileNode(func)
    ---@type vm.node.union
    local result, hasCalled
    if node then
        for cnode in nodeMgr.eachNode(node) do
            if cnode.type == 'function'
            or cnode.type == 'doc.type.function' then
                hasCalled = true
                local returnNode = m.getReturnOfFunction(cnode, index)
                if returnNode and returnNode.type == 'generic' then
                    returnNode = returnNode:resolve(args)
                end
                if returnNode and returnNode.type ~= 'doc.generic.name' then
                    result = result or union()
                    result:merge(m.compileNode(returnNode))
                end
            end
        end
    end
    if not hasCalled then
        result = globalMgr.getGlobal('type', 'unknown')
    end
    return result
end

local function bindDocs(source)
    local hasFounded = false
    local isParam = source.parent.type == 'funcargs'
                 or source.parent.type == 'in'
    local docs = source.bindDocs
    for i = #docs, 1, -1 do
        local doc = docs[i]
        if doc.type == 'doc.type' then
            if not isParam then
                nodeMgr.setNode(source, m.compileNode(doc))
                return true
            end
        end
        if doc.type == 'doc.class' then
            if (source.type == 'local' and not isParam)
            or (source._globalNode and guide.isSet(source))
            or source.type == 'tablefield'
            or source.type == 'tableindex' then
                nodeMgr.setNode(source, m.compileNode(doc))
                return true
            end
        end
        if doc.type == 'doc.param' then
            if isParam and source[1] == doc.param[1] then
                nodeMgr.setNode(source, m.compileNode(doc))
                return true
            end
        end
    end
    return false
end

local function compileByLocalID(source)
    local sources = localID.getSources(source)
    if not sources then
        return
    end
    local hasMarkDoc
    for _, src in ipairs(sources) do
        if src.bindDocs then
            if bindDocs(src) then
                hasMarkDoc = true
                nodeMgr.setNode(source, m.compileNode(src))
            end
        end
    end
    for _, src in ipairs(sources) do
        if src.value then
            if not hasMarkDoc or guide.isLiteral(src.value) then
                nodeMgr.setNode(source, m.compileNode(src.value))
            end
        end
    end
end

---@param source vm.node
---@param key? any
---@param pushResult fun(source: parser.object)
function m.compileByParentNode(source, key, pushResult)
    local parentNode = m.compileNode(source)
    if not parentNode then
        return
    end
    for node in nodeMgr.eachNode(parentNode) do
        searchFieldSwitch(node.type, node, key, pushResult)
    end
end

local function selectNode(source, list, index)
    local exp
    if list[index] then
        exp = list[index]
    else
        for i = index, 1, -1 do
            if list[i] then
                local last = list[i]
                if last.type == 'call'
                or last.type == '...' then
                    index = index - i + 1
                    exp = last
                end
                break
            end
        end
    end
    if not exp then
        return nil
    end
    local result
    if exp.type == 'call' then
        result = getReturn(exp.node, index, exp.args)
    else
        result = m.compileNode(exp)
    end
    if not result then
        return nodeMgr.setNode(source, result)
    end
    local hasKnownType
    for n in nodeMgr.eachNode(result) do
        if guide.isLiteral(n)
        or n.type == 'doc.type.function'
        or n.type == 'doc.type.table'
        or n.type == 'doc.type.integer'
        or n.type == 'doc.type.string'
        or (n.type == 'global' and n.cate == 'type') then
            hasKnownType = true
            break
        end
    end
    if not hasKnownType then
        result = nodeMgr.mergeNode(result, globalMgr.getGlobal('type', 'unknown'))
    end
    return nodeMgr.setNode(source, result)
end

---@param source parser.object
---@param node   vm.node
---@return boolean
local function isValidCallArgNode(source, node)
    if source.type == 'function' then
        return node.type == 'doc.type.function'
    end
    if source.type == 'table' then
        return node.type == 'doc.type.table'
            or (node.type == 'global' and node.cate == 'type' and not guide.isBasicType(node.name))
    end
    return false
end

local function setCallArgNode(source, call, callNode, fixIndex)
    local valueMgr = require 'vm.value'
    local myIndex
    for i, arg in ipairs(call.args) do
        if arg == source then
            myIndex = i - fixIndex
            break
        end
    end

    local eventIndex = 1
    local eventArg = call.args[eventIndex + fixIndex]
    if eventArg and eventArg.dummy then
        eventIndex = 2
        eventArg = call.args[eventIndex + fixIndex]
    end
    local eventMap = valueMgr.getLiterals(eventArg)

    for n in nodeMgr.eachNode(callNode) do
        if n.type == 'function' then
            local arg = n.args[myIndex]
            for fn in nodeMgr.eachNode(m.compileNode(arg)) do
                if isValidCallArgNode(source, fn) then
                    nodeMgr.setNode(source, fn)
                end
            end
        end
        if n.type == 'doc.type.function' then
            local event = m.compileNode(n.args[eventIndex])
            if not event
            or not eventMap
            or event.type ~= 'doc.type.string'
            or eventMap[event[1]] then
                local arg = n.args[myIndex]
                for fn in nodeMgr.eachNode(m.compileNode(arg)) do
                    if isValidCallArgNode(source, fn) then
                        nodeMgr.setNode(source, fn)
                    end
                end
            end
        end
    end
end

local compilerSwitch = util.switch()
    : case 'nil'
    : case 'boolean'
    : case 'integer'
    : case 'number'
    : case 'string'
    : case 'union'
    : case 'doc.type.function'
    : case 'doc.type.table'
    : case 'doc.type.array'
    : call(function (source)
        nodeMgr.setNode(source, source)
    end)
    : case 'table'
    : call(function (source)
        nodeMgr.setNode(source, source)

        if source.parent.type == 'callargs' then
            local call = source.parent.parent
            local callNode = m.compileNode(call.node)
            setCallArgNode(source, call, callNode, 0)

            if call.node.special == 'pcall'
            or call.node.special == 'xpcall' then
                local fixIndex = call.node.special == 'pcall' and 1 or 2
                callNode = m.compileNode(call.args[1])
                setCallArgNode(source, call, callNode, fixIndex)
            end
        end

        if source.parent.type == 'setglobal'
        or source.parent.type == 'setlocal'
        or source.parent.type == 'tablefield'
        or source.parent.type == 'tableindex'
        or source.parent.type == 'setfield'
        or source.parent.type == 'setindex' then
            nodeMgr.setNode(source, m.compileNode(source.parent))
        end
    end)
    : case 'function'
    : call(function (source)
        nodeMgr.setNode(source, source)

        if source.bindDocs then
            for _, doc in ipairs(source.bindDocs) do
                if doc.type == 'doc.overload' then
                    nodeMgr.setNode(source, m.compileNode(doc))
                end
            end
        end

        -- table.sort(string[], function (<?x?>) end)
        if source.parent.type == 'callargs' then
            local call = source.parent.parent
            local callNode = m.compileNode(call.node)
            setCallArgNode(source, call, callNode, 0)

            if call.node.special == 'pcall'
            or call.node.special == 'xpcall' then
                local fixIndex = call.node.special == 'pcall' and 1 or 2
                callNode = m.compileNode(call.args[1])
                setCallArgNode(source, call, callNode, fixIndex)
            end
        end
    end)
    : case 'paren'
    : call(function (source)
        nodeMgr.setNode(source, m.compileNode(source.exp))
    end)
    : case 'local'
    : call(function (source)
        --localMgr.declareLocal(source)
        nodeMgr.setNode(source, source)
        local hasMarkDoc
        if source.bindDocs then
            hasMarkDoc = bindDocs(source)
        end
        if source.ref and not hasMarkDoc then
            for _, ref in ipairs(source.ref) do
                if ref.type == 'setlocal' then
                    nodeMgr.setNode(source, m.compileNode(ref.value))
                end
            end
        end
        local hasMarkParam
        if source.dummy and not hasMarkDoc then
            hasMarkParam = true
            nodeMgr.setNode(source, m.compileNode(source.method.node))
        end
        if source.value then
            if not hasMarkDoc or guide.isLiteral(source.value) then
                nodeMgr.setNode(source, m.compileNode(source.value))
            end
        end
        -- function x.y(self, ...) --> function x:y(...)
        if  source[1] == 'self'
        and not hasMarkDoc
        and source.parent.type == 'funcargs'
        and source.parent[1] == source then
            local setfield = source.parent.parent.parent
            if setfield.type == 'setfield' then
                hasMarkParam = true
                nodeMgr.setNode(source, m.compileNode(setfield.node))
            end
        end
        if source.parent.type == 'funcargs' and not hasMarkDoc and not hasMarkParam then
            local func = source.parent.parent
            local funcNode = m.compileNode(func)
            local hasDocArg
            for n in nodeMgr.eachNode(funcNode) do
                if n.type == 'doc.type.function' then
                    for index, arg in ipairs(n.args) do
                        if func.args[index] == source then
                            nodeMgr.setNode(source, m.compileNode(arg))
                            hasDocArg = true
                        end
                    end
                end
            end
            if not hasDocArg then
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'any'))
            end
        end
        -- for x in ... do
        if source.parent.type == 'in' then
            m.compileNode(source.parent)
        end

        -- for x = ... do
        if source.parent.type == 'loop' then
            nodeMgr.setNode(source, globalMgr.getGlobal('type', 'integer'))
        end
    end)
    : case 'setlocal'
    : case 'getlocal'
    : call(function (source)
        nodeMgr.setNode(source, m.compileNode(source.node))
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
            nodeMgr.setNode(source, m.compileNode(src))
        end)
    end)
    : case 'tablefield'
    : case 'tableindex'
    : call(function (source)
        local hasMarkDoc
        if source.bindDocs then
            hasMarkDoc = bindDocs(source)
        end

        if source.value then
            if not hasMarkDoc or guide.isLiteral(source.value) then
                nodeMgr.setNode(source, m.compileNode(source.value))
            end
        end

        if not hasMarkDoc then
            m.compileByParentNode(source.parent, guide.getKeyName(source), function (src)
                nodeMgr.setNode(source, m.compileNode(src))
            end)
        end
    end)
    : case 'field'
    : case 'method'
    : call(function (source)
        nodeMgr.setNode(source, m.compileNode(source.parent))
    end)
    : case 'tableexp'
    : call(function (source)
        nodeMgr.setNode(source, m.compileNode(source.value))
    end)
    : case 'function.return'
    : call(function (source)
        local func  = source.parent
        local index = source.index
        local hasMarkDoc
        if func.bindDocs then
            local sign = getObjectSign(func)
            for _, doc in ipairs(func.bindDocs) do
                if doc.type == 'doc.return' then
                    for _, rtn in ipairs(doc.returns) do
                        if rtn.returnIndex == index then
                            hasMarkDoc = true
                            local hasGeneric
                            if sign then
                                guide.eachSourceType(rtn, 'doc.generic.name', function (src)
                                    hasGeneric = true
                                end)
                            end
                            local rtnNode = m.compileNode(rtn)
                            if hasGeneric then
                                nodeMgr.setNode(source, genericMgr(rtnNode, sign))
                            else
                                nodeMgr.setNode(source, rtnNode)
                            end
                        end
                    end
                end
            end
        end
        if func.returns and not hasMarkDoc then
            for _, rtn in ipairs(func.returns) do
                selectNode(source, rtn, index)
            end
        end
    end)
    : case 'main'
    : call(function (source)
        if source.returns then
            for _, rtn in ipairs(source.returns) do
                nodeMgr.setNode(source, m.compileNode(rtn[1]))
            end
        end
    end)
    : case 'select'
    : call(function (source)
        local vararg = source.vararg
        if vararg.type == 'call' then
            local node = getReturn(vararg.node, source.sindex, vararg.args)
            nodeMgr.setNode(source, node)
        end
        if vararg.type == 'varargs' then
            nodeMgr.setNode(source, m.compileNode(vararg))
        end
    end)
    : case 'varargs'
    : call(function (source)
        nodeMgr.setNode(source, m.compileNode(source.node))
    end)
    : case 'call'
    : call(function (source)
        local node = getReturn(source.node, 1, source.args)
        nodeMgr.setNode(source, node)
    end)
    : case 'in'
    : call(function (source)
        if not source._iterator then
            --  for k, v in pairs(t) do
            --> for k, v in iterator, status, initValue do
            --> local k, v = iterator(status, initValue)
            source._iterator = {}
            source._iterArgs = {{}, {}}
            -- iterator
            selectNode(source._iterator,    source.exps, 1)
            -- status
            selectNode(source._iterArgs[1], source.exps, 2)
            -- initValue
            selectNode(source._iterArgs[2], source.exps, 3)
        end
        for i, loc in ipairs(source.keys) do
            local node = getReturn(source._iterator, i, source._iterArgs)
            nodeMgr.setNode(loc, node)
        end
    end)
    : case 'doc.type'
    : call(function (source)
        for _, typeUnit in ipairs(source.types) do
            nodeMgr.setNode(source, m.compileNode(typeUnit))
        end
    end)
    : case 'doc.type.integer'
    : call(function (source)
        nodeMgr.setNode(source, source)
    end)
    : case 'doc.type.string'
    : call(function (source)
        nodeMgr.setNode(source, source)
    end)
    : case 'doc.generic.name'
    : call(function (source)
        nodeMgr.setNode(source, source)
    end)
    : case 'doc.type.name'
    : call(function (source)
        if source.signs then
            nodeMgr.setNode(source, source)
            local global = globalMgr.getGlobal('type', source[1])
            for _, set in ipairs(global:getSets()) do
                if set.type == 'doc.class' then
                    if set.extends then
                        for _, ext in ipairs(set.extends) do
                            if ext.type == 'doc.type.table' then
                                if ext._generic then
                                    local resolved = ext._generic:resolve(source.signs)
                                    nodeMgr.setNode(source, resolved)
                                end
                            end
                        end
                    end
                end
                if set.type == 'doc.alias' then
                    if set.extends._generic then
                        local resolved = set.extends._generic:resolve(source.signs)
                        nodeMgr.setNode(source, resolved)
                    end
                end
            end
        end
    end)
    : case 'doc.class.name'
    : call(function (source)
        nodeMgr.setNode(source, m.compileNode(source.parent))
    end)
    : case 'doc.field'
    : call(function (source)
        nodeMgr.setNode(source, m.compileNode(source.extends))
    end)
    : case 'doc.param'
    : call(function (source)
        nodeMgr.setNode(source, m.compileNode(source.extends))
    end)
    : case 'doc.vararg'
    : call(function (source)
        nodeMgr.setNode(source, m.compileNode(source.vararg))
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
                nodeMgr.setNode(source, m.compileNode(doc))
            end
            if doc.type == 'doc.param' and doc.param[1] == '...' then
                nodeMgr.setNode(source, m.compileNode(doc))
            end
        end
    end)
    : case 'doc.overload'
    : call(function (source)
        nodeMgr.setNode(source, m.compileNode(source.overload))
    end)
    : case 'doc.see.name'
    : call(function (source)
        local type = globalMgr.getGlobal('type', source[1])
        if type then
            nodeMgr.setNode(source, m.compileNode(type))
        end
    end)
    : case 'doc.type.arg'
    : call(function (source)
        if source.extends then
            nodeMgr.setNode(source, m.compileNode(source.extends))
        else
            nodeMgr.setNode(source, globalMgr.getGlobal('type', 'any'))
        end
    end)
    : case 'generic'
    : call(function (source)
        nodeMgr.setNode(source, source)
    end)
    : case 'unary'
    : call(function (source)
        local valueMgr = require 'vm.value'
        if source.op.type == 'not' then
            local result = valueMgr.test(source[1])
            if result == nil then
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'boolean'))
                return
            else
                nodeMgr.setNode(source, {
                    type   = 'boolean',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = not result,
                })
                return
            end
        end
        if source.op.type == '#' then
            nodeMgr.setNode(source, globalMgr.getGlobal('type', 'integer'))
            return
        end
        if source.op.type == '-' then
            local v = valueMgr.getNumber(source[1])
            if v == nil then
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            else
                nodeMgr.setNode(source, {
                    type   = 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = -v,
                })
                return
            end
        end
        if source.op.type == '~' then
            local v = valueMgr.getInteger(source[1])
            if v == nil then
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            else
                nodeMgr.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = ~v,
                })
                return
            end
        end
    end)
    : case 'binary'
    : call(function (source)
        local valueMgr = require 'vm.value'
        if source.op.type == 'and' then
            local r1 = valueMgr.test(source[1])
            if r1 == true then
                nodeMgr.setNode(source, m.compileNode(source[2]))
                return
            end
            if r1 == false then
                nodeMgr.setNode(source, m.compileNode(source[1]))
                return
            end
            nodeMgr.setNode(source, globalMgr.getGlobal('type', 'boolean'))
            return
        end
        if source.op.type == 'or' then
            local r1 = valueMgr.test(source[1])
            if r1 == true then
                nodeMgr.setNode(source, m.compileNode(source[1]))
                return
            end
            if r1 == false then
                nodeMgr.setNode(source, m.compileNode(source[2]))
                return
            end
            nodeMgr.setNode(source, globalMgr.getGlobal('type', 'boolean'))
            return
        end
        if source.op.type == '==' then
            local result = valueMgr.equal(source[1], source[2])
            if result == nil then
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'boolean'))
                return
            else
                nodeMgr.setNode(source, {
                    type   = 'boolean',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            end
        end
        if source.op.type == '~=' then
            local result = valueMgr.equal(source[1], source[2])
            if result == nil then
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'boolean'))
                return
            else
                nodeMgr.setNode(source, {
                    type   = 'boolean',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = not result,
                })
                return
            end
        end
        if source.op.type == '<<' then
            local a = valueMgr.getInteger(source[1])
            local b = valueMgr.getInteger(source[2])
            if a and b then
                nodeMgr.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a << b,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            end
        end
        if source.op.type == '>>' then
            local a = valueMgr.getInteger(source[1])
            local b = valueMgr.getInteger(source[2])
            if a and b then
                nodeMgr.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a >> b,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            end
        end
        if source.op.type == '&' then
            local a = valueMgr.getInteger(source[1])
            local b = valueMgr.getInteger(source[2])
            if a and b then
                nodeMgr.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a & b,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            end
        end
        if source.op.type == '|' then
            local a = valueMgr.getInteger(source[1])
            local b = valueMgr.getInteger(source[2])
            if a and b then
                nodeMgr.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a | b,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            end
        end
        if source.op.type == '~' then
            local a = valueMgr.getInteger(source[1])
            local b = valueMgr.getInteger(source[2])
            if a and b then
                nodeMgr.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a ~ b,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            end
        end
        if source.op.type == '+' then
            local a = valueMgr.getNumber(source[1])
            local b = valueMgr.getNumber(source[2])
            if a and b then
                local result = a + b
                nodeMgr.setNode(source, {
                    type   = math.type(result) == 'integer' and 'integer' or 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '-' then
            local a = valueMgr.getNumber(source[1])
            local b = valueMgr.getNumber(source[2])
            if a and b then
                local result = a - b
                nodeMgr.setNode(source, {
                    type   = math.type(result) == 'integer' and 'integer' or 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '*' then
            local a = valueMgr.getNumber(source[1])
            local b = valueMgr.getNumber(source[2])
            if a and b then
                local result = a * b
                nodeMgr.setNode(source, {
                    type   = math.type(result) == 'integer' and 'integer' or 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '/' then
            local a = valueMgr.getNumber(source[1])
            local b = valueMgr.getNumber(source[2])
            if a and b then
                nodeMgr.setNode(source, {
                    type   = 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a / b,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '%' then
            local a = valueMgr.getNumber(source[1])
            local b = valueMgr.getNumber(source[2])
            if a and b then
                local result = a % b
                nodeMgr.setNode(source, {
                    type   = math.type(result) == 'integer' and 'integer' or 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '^' then
            local a = valueMgr.getNumber(source[1])
            local b = valueMgr.getNumber(source[2])
            if a and b then
                nodeMgr.setNode(source, {
                    type   = 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a ^ b,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '//' then
            local a = valueMgr.getNumber(source[1])
            local b = valueMgr.getNumber(source[2])
            if a and b then
                local result = a // b
                nodeMgr.setNode(source, {
                    type   = math.type(result) == 'integer' and 'integer' or 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '..' then
            local a = valueMgr.getString(source[1])
                   or valueMgr.getNumber(source[1])
            local b = valueMgr.getString(source[2])
                   or valueMgr.getNumber(source[2])
            if a and b then
                if type(a) == 'number' or type(b) == 'number' then
                    local uri     = guide.getUri(source)
                    local version = config.get(uri, 'Lua.runtime.version')
                    if math.tointeger(a) and math.type(a) == 'float' then
                        if version == 'Lua 5.3' or version == 'Lua 5.4' then
                            a = ('%.1f'):format(a)
                        else
                            a = ('%.0f'):format(a)
                        end
                    end
                    if math.tointeger(b) and math.type(b) == 'float' then
                        if version == 'Lua 5.3' or version == 'Lua 5.4' then
                            b = ('%.1f'):format(b)
                        else
                            b = ('%.0f'):format(b)
                        end
                    end
                end
                nodeMgr.setNode(source, {
                    type   = 'string',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a .. b,
                })
                return
            else
                nodeMgr.setNode(source, globalMgr.getGlobal('type', 'string'))
                return
            end
        end
    end)

---@param source parser.object
local function compileByNode(source)
    compilerSwitch(source.type, source)
end

---@param source vm.node
local function compileByGlobal(source)
    if source.type == 'global' then
        nodeMgr.setNode(source, source)
        if source.cate == 'variable' then
            local hasMarkDoc
            for _, set in ipairs(source:getSets()) do
                if set.bindDocs then
                    if bindDocs(set) then
                        nodeMgr.setNode(source, m.compileNode(set))
                        hasMarkDoc = true
                    end
                end
            end
            for _, set in ipairs(source:getSets()) do
                if set.value then
                    if not hasMarkDoc or guide.isLiteral(set.value) then
                        nodeMgr.setNode(source, m.compileNode(set.value))
                    end
                end
            end
        end
        if source.cate == 'type' then
            for _, set in ipairs(source:getSets()) do
                if set.type == 'doc.class' then
                    if set.extends then
                        for _, ext in ipairs(set.extends) do
                            if ext.type == 'doc.type.table' then
                                if not ext._generic then
                                    nodeMgr.setNode(source, m.compileNode(ext))
                                end
                            end
                        end
                    end
                end
                if set.type == 'doc.alias' then
                    if not set.extends._generic then
                        nodeMgr.setNode(source, m.compileNode(set.extends))
                    end
                end
            end
        end
        return
    end
    if source._globalNode then
        nodeMgr.setNode(source, m.compileNode(source._globalNode))
        return
    end
end

---@param source parser.object
---@return vm.node
function m.compileNode(source)
    if not source then
        return false
    end
    if nodeMgr.nodeCache[source] ~= nil then
        return nodeMgr.nodeCache[source]
    end
    nodeMgr.nodeCache[source] = false
    compileByGlobal(source)
    compileByNode(source)

    --localMgr.subscribeLocal(source, source._node)

    return nodeMgr.nodeCache[source]
end

return m
