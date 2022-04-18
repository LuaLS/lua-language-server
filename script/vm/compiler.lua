local guide      = require 'parser.guide'
local util       = require 'utility'
local localID    = require 'vm.local-id'
local globalMgr  = require 'vm.global-manager'
local signMgr    = require 'vm.sign'
local config     = require 'config'
local genericMgr = require 'vm.generic'
local rpath      = require 'workspace.require-path'
local files      = require 'files'
---@class vm
local vm         = require 'vm.vm'

---@class parser.object
---@field _compiledNodes  boolean
---@field _node           vm.node
---@field _localBase      table
---@field _globalBase     table
---@field _hasSorted      boolean

local searchFieldSwitch = util.switch()
    : case 'table'
    : call(function (suri, source, key, ref, pushResult)
        local hasFiled = false
        for _, field in ipairs(source) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                local fieldKey = guide.getKeyName(field)
                if key == nil
                or key == fieldKey then
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
    : case 'string'
    : call(function (suri, source, key, ref, pushResult)
        -- change to `string: stringlib` ?
        local stringlib = globalMgr.getGlobal('type', 'stringlib')
        if stringlib then
            vm.getClassFields(suri, stringlib, key, ref, pushResult)
        end
    end)
    : case 'local'
    : case 'self'
    : call(function (suri, node, key, ref, pushResult)
        local fields
        if key then
            fields = localID.getSources(node, key)
        else
            fields = localID.getFields(node)
        end
        if fields then
            for _, src in ipairs(fields) do
                if ref or guide.isSet(src) then
                    pushResult(src)
                end
            end
        end
    end)
    : case 'doc.type.array'
    : call(function (suri, source, key, ref, pushResult)
        if type(key) == 'number' then
            if key < 1
            or not math.tointeger(key) then
                return
            end
        end
        pushResult(source.node)
    end)
    : case 'doc.type.table'
    : call(function (suri, source, key, ref, pushResult)
        for _, field in ipairs(source.fields) do
            local fieldKey = field.name
            if fieldKey.type == 'doc.type' then
                local fieldNode = vm.compileNode(fieldKey)
                for fn in fieldNode:eachObject() do
                    if fn.type == 'global' and fn.cate == 'type' then
                        if key == nil
                        or fn.name == 'any'
                        or (fn.name == 'boolean' and type(key) == 'boolean')
                        or (fn.name == 'number'  and type(key) == 'number')
                        or (fn.name == 'integer' and math.tointeger(key))
                        or (fn.name == 'string'  and type(key) == 'string') then
                            pushResult(field)
                        end
                    end
                end
            end
            if fieldKey.type == 'doc.field.name' then
                if key == nil or fieldKey[1] == key then
                    pushResult(field)
                end
            end
        end
    end)
    : case 'global'
    : call(function (suri, node, key, ref, pushResult)
        if node.cate == 'variable' then
            if key then
                if type(key) ~= 'string' then
                    return
                end
                local global = globalMgr.getGlobal('variable', node.name, key)
                if global then
                    for _, set in ipairs(global:getSets(suri)) do
                        pushResult(set)
                    end
                    if ref then
                        for _, get in ipairs(global:getGets(suri)) do
                            pushResult(get)
                        end
                    end
                end
            else
                local globals = globalMgr.getFields('variable', node.name)
                for _, global in ipairs(globals) do
                    for _, set in ipairs(global:getSets(suri)) do
                        pushResult(set)
                    end
                    if ref then
                        for _, get in ipairs(global:getGets(suri)) do
                            pushResult(get)
                        end
                    end
                end
            end
        end
        if node.cate == 'type' then
            vm.getClassFields(suri, node, key, ref, pushResult)
        end
    end)
    : default(function (suri, source, key, ref, pushResult)
        local node = source._globalNode
        if not node then
            return
        end
        if node.cate == 'variable' then
            if key then
                if type(key) ~= 'string' then
                    return
                end
                local global = globalMgr.getGlobal('variable', node.name, key)
                if global then
                    for _, set in ipairs(global:getSets(suri)) do
                        pushResult(set)
                    end
                    for _, get in ipairs(global:getGets(suri)) do
                        pushResult(get)
                    end
                end
            else
                local globals = globalMgr.getFields('variable', node.name)
                for _, global in ipairs(globals) do
                    for _, set in ipairs(global:getSets(suri)) do
                        pushResult(set)
                    end
                    for _, get in ipairs(global:getGets(suri)) do
                        pushResult(get)
                    end
                end
            end
        end
        if node.cate == 'type' then
            vm.getClassFields(suri, node, key, ref, pushResult)
        end
    end)


function vm.getClassFields(suri, node, key, ref, pushResult)
    local mark = {}

    local function searchClass(class, searchedFields)
        local name = class.name
        if mark[name] then
            return
        end
        mark[name] = true
        searchedFields = searchedFields or {}
        for _, set in ipairs(class:getSets(suri)) do
            if set.type == 'doc.class' then
                -- check ---@field
                local hasFounded = {}
                for _, field in ipairs(set.fields) do
                    local fieldKey = guide.getKeyName(field)
                    if key == nil
                    or fieldKey == key then
                        if not searchedFields[fieldKey] then
                            pushResult(field)
                            hasFounded[fieldKey] = true
                        end
                    end
                end
                -- check local field and global field
                if set.bindSources then
                    for _, src in ipairs(set.bindSources) do
                        searchFieldSwitch(src.type, suri, src, key, ref, function (field)
                            local fieldKey = guide.getKeyName(field)
                            if  not searchedFields[fieldKey]
                            and guide.isSet(field) then
                                hasFounded[fieldKey] = true
                                pushResult(field)
                            end
                        end)
                        if src.value and src.value.type == 'table' then
                            searchFieldSwitch('table', suri, src.value, key, ref, function (field)
                                local fieldKey = guide.getKeyName(field)
                                if  not searchedFields[fieldKey]
                                and guide.isSet(field) then
                                    hasFounded[fieldKey] = true
                                    pushResult(field)
                                end
                            end)
                        end
                    end
                end
                -- look into extends(if field not found)
                if not hasFounded[key] and set.extends then
                    for fieldKey in pairs(hasFounded) do
                        searchedFields[fieldKey] = true
                    end
                    for _, extend in ipairs(set.extends) do
                        if extend.type == 'doc.extends.name' then
                            local extendType = globalMgr.getGlobal('type', extend[1])
                            if extendType then
                                searchClass(extendType, searchedFields)
                            end
                        end
                    end
                end
            end
        end
    end

    local function searchGlobal(class)
        if class.cate == 'type' and class.name == '_G' then
            if key == nil then
                local sets = globalMgr.getGlobalSets(suri, 'variable')
                for _, set in ipairs(sets) do
                    pushResult(set)
                end
            else
                local global = globalMgr.getGlobal('variable', key)
                if global then
                    for _, set in ipairs(global:getSets(suri)) do
                        pushResult(set)
                    end
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
                local argNode = vm.compileNode(arg)
                if arg.optional then
                    argNode:addOptional()
                end
                source._sign:addSign(argNode)
            end
        end
    end
    if source.type == 'doc.type.function'
    or source.type == 'doc.type.table'
    or source.type == 'doc.type.array' then
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
                local argNode = vm.compileNode(arg.extends)
                if arg.optional then
                    argNode:addOptional()
                end
                source._sign:addSign(argNode)
            end
        end
    end
    return source._sign
end

---@param func  parser.object
---@param index integer
---@return vm.object?
function vm.getReturnOfFunction(func, index)
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
        return func._returns[index]
    end
    if func.type == 'doc.type.function' then
        local rtn = func.returns[index]
        if not rtn then
            return nil
        end
        local sign = getObjectSign(func)
        if not sign then
            return rtn
        end
        return genericMgr(rtn, sign)
    end
end

---@return vm.node
local function getReturnOfSetMetaTable(args)
    local tbl  = args[1]
    local mt   = args[2]
    local node = vm.createNode()
    if tbl then
        node:merge(vm.compileNode(tbl))
    end
    if mt then
        vm.compileByParentNode(mt, '__index', false, function (src)
            for n in vm.compileNode(src):eachObject() do
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

---@return vm.node?
local function getReturn(func, index, args)
    if func.special == 'setmetatable' then
        if not args then
            return nil
        end
        return getReturnOfSetMetaTable(args)
    end
    if func.special == 'pcall' and index > 1 then
        if not args then
            return nil
        end
        local newArgs = {}
        for i = 2, #args do
            newArgs[#newArgs+1] = args[i]
        end
        return getReturn(args[1], index - 1, newArgs)
    end
    if func.special == 'xpcall' and index > 1 then
        if not args then
            return nil
        end
        local newArgs = {}
        for i = 3, #args do
            newArgs[#newArgs+1] = args[i]
        end
        return getReturn(args[1], index - 1, newArgs)
    end
    if func.special == 'require' then
        if not args then
            return nil
        end
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
        return vm.compileNode(ast)
    end
    local node = vm.compileNode(func)
    ---@type vm.node?
    local result
    for cnode in node:eachObject() do
        if cnode.type == 'function'
        or cnode.type == 'doc.type.function' then
            local returnObject = vm.getReturnOfFunction(cnode, index)
            if returnObject then
                local returnNode = vm.compileNode(returnObject)
                for rnode in returnNode:eachObject() do
                    if rnode.type == 'generic' then
                        returnNode = rnode:resolve(guide.getUri(func), args)
                        break
                    end
                end
                if returnNode then
                    for rnode in returnNode:eachObject() do
                        -- TODO: narrow type
                        if rnode.type ~= 'doc.generic.name' then
                            result = result or vm.createNode()
                            result:merge(rnode)
                        end
                    end
                    if result and returnNode:isOptional() then
                        result:addOptional()
                    end
                end
            end
        end
    end
    return result
end

local function bindDocs(source)
    local isParam = source.parent.type == 'funcargs'
                 or source.parent.type == 'in'
    local docs = source.bindDocs
    for i = #docs, 1, -1 do
        local doc = docs[i]
        if doc.type == 'doc.type' then
            if not isParam then
                vm.setNode(source, vm.compileNode(doc))
                return true
            end
        end
        if doc.type == 'doc.class' then
            if (source.type == 'local' and not isParam)
            or (source._globalNode and guide.isSet(source))
            or source.type == 'tablefield'
            or source.type == 'tableindex' then
                vm.setNode(source, vm.compileNode(doc))
                return true
            end
        end
        if doc.type == 'doc.param' then
            if isParam and source[1] == doc.param[1] then
                vm.setNode(source, vm.compileNode(doc))
                return true
            end
        end
        if doc.type == 'doc.module' then
            local name = doc.module
            local uri = rpath.findUrisByRequirePath(guide.getUri(source), name)[1]
            if not uri then
                return nil
            end
            local state = files.getState(uri)
            local ast   = state and state.ast
            if not ast then
                return nil
            end
            vm.setNode(source, vm.compileNode(ast))
            return true
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
                vm.setNode(source, vm.compileNode(src))
            end
        end
    end
    for _, src in ipairs(sources) do
        if src.value then
            if not hasMarkDoc or guide.isLiteral(src.value) then
                if src.value.type ~= 'nil' then
                    vm.setNode(source, vm.compileNode(src.value))
                end
            end
        end
    end
end

---@param source vm.node
---@param key? any
---@param pushResult fun(source: parser.object)
function vm.compileByParentNode(source, key, ref, pushResult)
    local parentNode = vm.compileNode(source)
    local suri = guide.getUri(source)
    for node in parentNode:eachObject() do
        searchFieldSwitch(node.type, suri, node, key, ref, pushResult)
    end
end

---@return vm.node?
local function selectNode(source, list, index)
    if not list then
        return nil
    end
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
        if not result then
            vm.setNode(source, globalMgr.getGlobal('type', 'unknown'))
            return vm.getNode(source)
        end
    else
        result = vm.compileNode(exp)
    end
    if source.type == 'function.return' then
        -- remove any for returns
        local rtnNode = vm.createNode()
        local hasKnownType
        for n in result:eachObject() do
            if guide.isLiteral(n) then
                hasKnownType = true
                rtnNode:merge(n)
            end
            if n.type == 'global' and n.cate == 'type' then
                if  n.name ~= 'any'
                and n.name ~= 'unknown' then
                    hasKnownType = true
                    rtnNode:merge(n)
                end
            else
                rtnNode:merge(n)
            end
        end
        if not hasKnownType then
            rtnNode:merge(globalMgr.getGlobal('type', 'unknown'))
        end
        vm.setNode(source, rtnNode)
        return rtnNode
    end
    vm.setNode(source, result)
    return result
end

---@param source parser.object
---@param node   vm.object
---@return boolean
local function isValidCallArgNode(source, node)
    if source.type == 'function' then
        return node.type == 'doc.type.function'
    end
    if source.type == 'table' then
        return node.type == 'doc.type.table'
            or (node.type == 'global' and node.cate == 'type' and not guide.isBasicType(node.name))
    end
    if source.type == 'dummyarg' then
        return true
    end
    return false
end

---@param func parser.object
---@param index integer
---@return parser.object?
local function getFuncArg(func, index)
    local args = func.args
    if not args then
        return nil
    end
    if args[index] then
        return args[index]
    end
    local lastArg = args[#args]
    if lastArg and lastArg.type == '...' then
        return lastArg
    end
    return nil
end

---@param arg      parser.object
---@param call     parser.object
---@param callNode vm.node
---@param fixIndex integer
---@param myIndex  integer
local function compileCallArgNode(arg, call, callNode, fixIndex, myIndex)
    local eventIndex, eventMap
    if call.args then
        for i = 1, 2 do
            local eventArg = call.args[i + fixIndex]
            if not eventArg then
                break
            end
            eventMap = vm.getLiterals(eventArg)
            if eventMap then
                eventIndex = i
                break
            end
        end
    end

    for n in callNode:eachObject() do
        if n.type == 'function' then
            local farg = getFuncArg(n, myIndex)
            if farg then
                for fn in vm.compileNode(farg):eachObject() do
                    if isValidCallArgNode(arg, fn) then
                        vm.setNode(arg, fn)
                    end
                end
            end
        end
        if n.type == 'doc.type.function' then
            local myEvent
            if n.args[eventIndex] then
                local argNode = vm.compileNode(n.args[eventIndex])
                myEvent = argNode:get(1)
            end
            if not myEvent
            or not eventMap
            or myIndex <= eventIndex
            or myEvent.type ~= 'doc.type.string'
            or eventMap[myEvent[1]] then
                local farg = getFuncArg(n, myIndex)
                if farg then
                    for fn in vm.compileNode(farg):eachObject() do
                        if isValidCallArgNode(arg, fn) then
                            vm.setNode(arg, fn)
                        end
                    end
                end
            end
        end
    end
end

---@param arg parser.object
---@param call parser.object
---@param index? integer
function vm.compileCallArg(arg, call, index)
    if not index then
        for i, carg in ipairs(call.args) do
            if carg == arg then
                index = i
                break
            end
        end
    end

    local callNode = vm.compileNode(call.node)
    compileCallArgNode(arg, call, callNode, 0, index)

    if call.node.special == 'pcall'
    or call.node.special == 'xpcall' then
        local fixIndex = call.node.special == 'pcall' and 1 or 2
        callNode = vm.compileNode(call.args[1])
        compileCallArgNode(arg, call, callNode, fixIndex, index - fixIndex)
    end
    return vm.getNode(arg)
end

---@param source parser.object
---@return vm.node
local function compileLocal(source)
    vm.setNode(source, source)

    local hasMarkDoc
    if source.bindDocs then
        hasMarkDoc = bindDocs(source)
    end
    local hasMarkParam
    if source.type == 'self' and not hasMarkDoc then
        hasMarkParam = true
        if source.parent.type == 'callargs' then
            -- obj:func(...)
            if source.parent.parent and source.parent.parent.node and source.parent.parent.node.node then
                vm.setNode(source, vm.compileNode(source.parent.parent.node.node))
            end
        else
            -- function obj:func(...)
            if source.parent.parent and source.parent.parent.parent and source.parent.parent.parent.node then
                vm.setNode(source, vm.compileNode(source.parent.parent.parent.node))
            end
        end
    end
    local hasMarkValue
    if source.value then
        if not hasMarkDoc or guide.isLiteral(source.value) then
            hasMarkValue = true
            if source.value.type == 'table' then
                vm.setNode(source, source.value)
            elseif source.value.type ~= 'nil' then
                vm.setNode(source, vm.compileNode(source.value))
            end
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
            vm.setNode(source, vm.compileNode(setfield.node))
        end
    end
    if source.parent.type == 'funcargs' and not hasMarkDoc and not hasMarkParam then
        local func = source.parent.parent
        local funcNode = vm.compileNode(func)
        local hasDocArg
        for n in funcNode:eachObject() do
            if n.type == 'doc.type.function' then
                for index, arg in ipairs(n.args) do
                    if func.args[index] == source then
                        vm.setNode(source, vm.compileNode(arg))
                        hasDocArg = true
                    end
                end
            end
        end
        if not hasDocArg then
            vm.setNode(source, globalMgr.getGlobal('type', 'any'))
        end
    end
    -- for x in ... do
    if source.parent.type == 'in' then
        vm.compileNode(source.parent)
    end

    -- for x = ... do
    if source.parent.type == 'loop' then
        vm.setNode(source, globalMgr.getGlobal('type', 'integer'))
    end

    vm.getNode(source):setData('hasDefined', hasMarkDoc or hasMarkParam or hasMarkValue)
end

local compilerSwitch = util.switch()
    : case 'nil'
    : case 'boolean'
    : case 'integer'
    : case 'number'
    : case 'string'
    : case 'doc.type.function'
    : case 'doc.type.table'
    : case 'doc.type.array'
    : call(function (source)
        vm.setNode(source, source)
    end)
    : case 'table'
    : call(function (source)
        vm.setNode(source, source)

        if source.parent.type == 'callargs' then
            local call = source.parent.parent
            vm.compileCallArg(source, call)
        end

        if source.parent.type == 'setglobal'
        or source.parent.type == 'local'
        or source.parent.type == 'setlocal'
        or source.parent.type == 'tablefield'
        or source.parent.type == 'tableindex'
        or source.parent.type == 'setfield'
        or source.parent.type == 'setindex' then
            vm.setNode(source, vm.compileNode(source.parent))
        end
    end)
    : case 'function'
    : call(function (source)
        vm.setNode(source, source)

        if source.bindDocs then
            for _, doc in ipairs(source.bindDocs) do
                if doc.type == 'doc.overload' then
                    vm.setNode(source, vm.compileNode(doc))
                end
            end
        end

        -- table.sort(string[], function (<?x?>) end)
        if source.parent.type == 'callargs' then
            local call = source.parent.parent
            vm.compileCallArg(source, call)
        end
    end)
    : case 'paren'
    : call(function (source)
        if source.exp then
            vm.setNode(source, vm.compileNode(source.exp))
        end
    end)
    : case 'local'
    : case 'self'
    ---@param source parser.object
    : call(function (source)
        compileLocal(source)
        local refs = source.ref
        if not refs then
            return
        end

        local hasMark = vm.getNode(source):getData 'hasDefined'

        if not source._hasSorted then
            source._hasSorted = true
            table.sort(refs, function (a, b)
                return (a.range or a.start) < (b.range or b.start)
            end)
        end

        local parentFunc = guide.getParentFunction(source)

        local index = 1
        local function runFunction(loc, currentFunc)
            while true do
                local ref = refs[index]
                if not ref then
                    break
                end
                if ref.start > currentFunc.finish then
                    break
                end
                local func = guide.getParentFunction(ref)
                if func == currentFunc then
                    index = index + 1
                    if ref.type == 'setlocal' then
                        if ref.value and not hasMark then
                            if ref.value.type == 'table' then
                                vm.setNode(ref, ref.value)
                            else
                                vm.setNode(ref, vm.compileNode(ref.value))
                            end
                        else
                            vm.setNode(ref, vm.getNode(loc))
                        end
                        loc = ref
                    elseif ref.type == 'getlocal' then
                        vm.setNode(ref, vm.getNode(loc), true)
                    end
                else
                    runFunction(loc, func)
                end
            end
        end

        runFunction(source, parentFunc)

        if not hasMark then
            for _, ref in ipairs(source.ref) do
                if  ref.type == 'setlocal'
                and guide.getParentFunction(ref) == parentFunc then
                    vm.setNode(source, vm.getNode(ref))
                end
            end
        end
    end)
    : case 'setlocal'
    : call(function (source)
        vm.compileNode(source.node)
    end)
    : case 'getlocal'
    : call(function (source)
        vm.compileNode(source.node)
    end)
    : case 'setfield'
    : case 'setmethod'
    : case 'setindex'
    : call(function (source)
        compileByLocalID(source)
        local key = guide.getKeyName(source)
        if key == nil then
            return
        end
        vm.compileByParentNode(source.node, key, false, function (src)
            if src.type == 'doc.type.field'
            or src.type == 'doc.field' then
                vm.setNode(source, vm.compileNode(src))
            end
        end)
    end)
    : case 'getfield'
    : case 'getmethod'
    : case 'getindex'
    : call(function (source)
        compileByLocalID(source)
        local key = guide.getKeyName(source)
        if key == nil and source.index then
            key = vm.compileNode(source.index)
        end
        if key == nil then
            return
        end
        if type(key) == 'table' then
            local uri = guide.getUri(source)
            local value = vm.getTableValue(uri, vm.compileNode(source.node), key)
            if value then
                vm.setNode(source, value)
            end
        else
            vm.compileByParentNode(source.node, key, false, function (src)
                vm.setNode(source, vm.compileNode(src))
            end)
        end
    end)
    : case 'setglobal'
    : call(function (source)
        if source.node[1] ~= '_ENV' then
            return
        end
        local key = guide.getKeyName(source)
        vm.compileByParentNode(source.node, key, false, function (src)
            if src.type == 'doc.type.field'
            or src.type == 'doc.field' then
                vm.setNode(source, vm.compileNode(src))
            end
        end)
    end)
    : case 'getglobal'
    : call(function (source)
        if source.node[1] ~= '_ENV' then
            return
        end
        local key = guide.getKeyName(source)
        vm.compileByParentNode(source.node, key, false, function (src)
            vm.setNode(source, vm.compileNode(src))
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
                if source.value.type == 'table' then
                    vm.setNode(source, source.value)
                elseif source.value.type ~= 'nil' then
                    vm.setNode(source, vm.compileNode(source.value))
                end
            end
        end

        if not hasMarkDoc then
            vm.compileByParentNode(source.parent, guide.getKeyName(source), false, function (src)
                vm.setNode(source, vm.compileNode(src))
            end)
        end
    end)
    : case 'field'
    : case 'method'
    : call(function (source)
        vm.setNode(source, vm.compileNode(source.parent))
    end)
    : case 'tableexp'
    : call(function (source)
        vm.setNode(source, vm.compileNode(source.value))
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
                            if hasGeneric then
                                vm.setNode(source, genericMgr(rtn, sign))
                            else
                                vm.setNode(source, vm.compileNode(rtn))
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
                if rtn[1] then
                    vm.setNode(source, vm.compileNode(rtn[1]))
                end
            end
        end
    end)
    : case 'select'
    : call(function (source)
        local vararg = source.vararg
        if vararg.type == 'call' then
            local node = getReturn(vararg.node, source.sindex, vararg.args)
            if not node then
                return
            end
            for n in node:eachObject() do
                if  n.type == 'global'
                and n.cate == 'type'
                and n.name == '...' then
                    return
                end
            end
            vm.setNode(source, node)
        end
        if vararg.type == 'varargs' then
            vm.setNode(source, vm.compileNode(vararg))
        end
    end)
    : case 'varargs'
    : call(function (source)
        if source.node then
            vm.setNode(source, vm.compileNode(source.node))
        end
    end)
    : case 'call'
    : call(function (source)
        local node = getReturn(source.node, 1, source.args)
        if not node then
            return
        end
        for n in node:eachObject() do
            if  n.type == 'global'
            and n.cate == 'type'
            and n.name == '...' then
                return
            end
        end
        vm.setNode(source, node)
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
        if source.keys then
            for i, loc in ipairs(source.keys) do
                local node = getReturn(source._iterator, i, source._iterArgs)
                if node then
                    vm.setNode(loc, node)
                end
            end
        end
    end)
    : case 'doc.type'
    : call(function (source)
        for _, typeUnit in ipairs(source.types) do
            vm.setNode(source, vm.compileNode(typeUnit))
        end
        if source.optional then
            vm.getNode(source):addOptional()
        end
    end)
    : case 'doc.type.integer'
    : case 'doc.type.string'
    : case 'doc.type.boolean'
    : call(function (source)
        vm.setNode(source, source)
    end)
    : case 'doc.generic.name'
    : call(function (source)
        vm.setNode(source, source)
    end)
    : case 'doc.type.sign'
    : call(function (source)
        local uri = guide.getUri(source)
        vm.setNode(source, source)
        local global = globalMgr.getGlobal('type', source.node[1])
        for _, set in ipairs(global:getSets(uri)) do
            if set.type == 'doc.class' then
                if set.extends then
                    for _, ext in ipairs(set.extends) do
                        if ext.type == 'doc.type.table' then
                            if ext._generic then
                                local resolved = ext._generic:resolve(uri, source.signs)
                                vm.setNode(source, resolved)
                            end
                        end
                    end
                end
            end
            if set.type == 'doc.alias' then
                if set.extends._generic then
                    local resolved = set.extends._generic:resolve(uri, source.signs)
                    vm.setNode(source, resolved)
                end
            end
        end
    end)
    : case 'doc.class.name'
    : call(function (source)
        vm.setNode(source, vm.compileNode(source.parent))
    end)
    : case 'doc.field'
    : call(function (source)
        if not source.extends then
            return
        end
        vm.setNode(source, vm.compileNode(source.extends))
    end)
    : case 'doc.type.field'
    : call(function (source)
        if not source.extends then
            return
        end
        vm.setNode(source, vm.compileNode(source.extends))
    end)
    : case 'doc.param'
    : call(function (source)
        if not source.extends then
            return
        end
        vm.setNode(source, vm.compileNode(source.extends))
    end)
    : case 'doc.vararg'
    : call(function (source)
        if not source.vararg then
            return
        end
        vm.setNode(source, vm.compileNode(source.vararg))
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
                vm.setNode(source, vm.compileNode(doc))
            end
            if doc.type == 'doc.param' and doc.param[1] == '...' then
                vm.setNode(source, vm.compileNode(doc))
            end
        end
    end)
    : case 'doc.overload'
    : call(function (source)
        vm.setNode(source, vm.compileNode(source.overload))
    end)
    : case 'doc.see.name'
    : call(function (source)
        local type = globalMgr.getGlobal('type', source[1])
        if type then
            vm.setNode(source, vm.compileNode(type))
        end
    end)
    : case 'doc.type.arg'
    : call(function (source)
        if source.extends then
            vm.setNode(source, vm.compileNode(source.extends))
        else
            vm.setNode(source, globalMgr.getGlobal('type', 'any'))
        end
        if source.optional then
            vm.getNode(source):addOptional()
        end
    end)
    : case 'generic'
    : call(function (source)
        vm.setNode(source, source)
    end)
    : case 'unary'
    : call(function (source)
        if source.op.type == 'not' then
            local result = vm.test(source[1])
            if result == nil then
                vm.setNode(source, globalMgr.getGlobal('type', 'boolean'))
                return
            else
                vm.setNode(source, {
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
            vm.setNode(source, globalMgr.getGlobal('type', 'integer'))
            return
        end
        if source.op.type == '-' then
            local v = vm.getNumber(source[1])
            if v == nil then
                vm.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            else
                vm.setNode(source, {
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
            local v = vm.getInteger(source[1])
            if v == nil then
                vm.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            else
                vm.setNode(source, {
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
        if source.op.type == 'and' then
            local r1 = vm.test(source[1])
            if r1 == true then
                vm.setNode(source, vm.compileNode(source[2]))
                return
            end
            if r1 == false then
                vm.setNode(source, vm.compileNode(source[1]))
                return
            end
            return
        end
        if source.op.type == 'or' then
            local r1 = vm.test(source[1])
            if r1 == true then
                vm.setNode(source, vm.compileNode(source[1]))
                return
            end
            if r1 == false then
                vm.setNode(source, vm.compileNode(source[2]))
                return
            end
            return
        end
        if source.op.type == '==' then
            local result = vm.equal(source[1], source[2])
            if result == nil then
                vm.setNode(source, globalMgr.getGlobal('type', 'boolean'))
                return
            else
                vm.setNode(source, {
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
            local result = vm.equal(source[1], source[2])
            if result == nil then
                vm.setNode(source, globalMgr.getGlobal('type', 'boolean'))
                return
            else
                vm.setNode(source, {
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
            local a = vm.getInteger(source[1])
            local b = vm.getInteger(source[2])
            if a and b then
                vm.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a << b,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            end
        end
        if source.op.type == '>>' then
            local a = vm.getInteger(source[1])
            local b = vm.getInteger(source[2])
            if a and b then
                vm.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a >> b,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            end
        end
        if source.op.type == '&' then
            local a = vm.getInteger(source[1])
            local b = vm.getInteger(source[2])
            if a and b then
                vm.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a & b,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            end
        end
        if source.op.type == '|' then
            local a = vm.getInteger(source[1])
            local b = vm.getInteger(source[2])
            if a and b then
                vm.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a | b,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            end
        end
        if source.op.type == '~' then
            local a = vm.getInteger(source[1])
            local b = vm.getInteger(source[2])
            if a and b then
                vm.setNode(source, {
                    type   = 'integer',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a ~ b,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'integer'))
                return
            end
        end
        if source.op.type == '+' then
            local a = vm.getNumber(source[1])
            local b = vm.getNumber(source[2])
            if a and b then
                local result = a + b
                vm.setNode(source, {
                    type   = math.type(result) == 'integer' and 'integer' or 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '-' then
            local a = vm.getNumber(source[1])
            local b = vm.getNumber(source[2])
            if a and b then
                local result = a - b
                vm.setNode(source, {
                    type   = math.type(result) == 'integer' and 'integer' or 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '*' then
            local a = vm.getNumber(source[1])
            local b = vm.getNumber(source[2])
            if a and b then
                local result = a * b
                vm.setNode(source, {
                    type   = math.type(result) == 'integer' and 'integer' or 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '/' then
            local a = vm.getNumber(source[1])
            local b = vm.getNumber(source[2])
            if a and b then
                vm.setNode(source, {
                    type   = 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a / b,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '%' then
            local a = vm.getNumber(source[1])
            local b = vm.getNumber(source[2])
            if a and b then
                local result = a % b
                vm.setNode(source, {
                    type   = math.type(result) == 'integer' and 'integer' or 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '^' then
            local a = vm.getNumber(source[1])
            local b = vm.getNumber(source[2])
            if a and b then
                vm.setNode(source, {
                    type   = 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a ^ b,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '//' then
            local a = vm.getNumber(source[1])
            local b = vm.getNumber(source[2])
            if a and b and b ~= 0 then
                local result = a // b
                vm.setNode(source, {
                    type   = math.type(result) == 'integer' and 'integer' or 'number',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = result,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'number'))
                return
            end
        end
        if source.op.type == '..' then
            local a = vm.getString(source[1])
                   or vm.getNumber(source[1])
            local b = vm.getString(source[2])
                   or vm.getNumber(source[2])
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
                vm.setNode(source, {
                    type   = 'string',
                    start  = source.start,
                    finish = source.finish,
                    parent = source,
                    [1]    = a .. b,
                })
                return
            else
                vm.setNode(source, globalMgr.getGlobal('type', 'string'))
                return
            end
        end
    end)

---@param source vm.object
local function compileByNode(source)
    compilerSwitch(source.type, source)
end

---@param source vm.object
local function compileByGlobal(source)
    local global = source._globalNode
    if not global then
        return
    end
    local root = guide.getRoot(source)
    local uri = guide.getUri(source)
    if not root._globalBase then
        root._globalBase = {}
    end
    local name = global:asKeyName()
    if not root._globalBase[name] then
        root._globalBase[name] = {
            type   = 'globalbase',
            parent = root,
        }
    end
    local globalNode = vm.getNode(root._globalBase[name])
    if globalNode then
        vm.setNode(source, globalNode, true)
        return
    end
    globalNode = vm.createNode(global)
    vm.setNode(root._globalBase[name], globalNode, true)
    vm.setNode(source, globalNode, true)

    -- TODO:don't mix
    local sets = global.links[uri].sets or {}
    local gets = global.links[uri].gets or {}
    for _, set in ipairs(sets) do
        vm.setNode(set, globalNode, true)
    end
    for _, get in ipairs(gets) do
        vm.setNode(get, globalNode, true)
    end

    if global.cate == 'variable' then
        local hasMarkDoc
        for _, set in ipairs(global:getSets(uri)) do
            if set.bindDocs then
                if bindDocs(set) then
                    globalNode:merge(vm.compileNode(set))
                    hasMarkDoc = true
                end
            end
        end
        for _, set in ipairs(global:getSets(uri)) do
            if set.value then
                if not hasMarkDoc or guide.isLiteral(set.value) then
                    if set.value.type ~= 'nil' then
                        globalNode:merge(vm.compileNode(set.value))
                    end
                end
            end
        end
    end
    if global.cate == 'type' then
        for _, set in ipairs(global:getSets(uri)) do
            if set.type == 'doc.class' then
                if set.extends then
                    for _, ext in ipairs(set.extends) do
                        if ext.type == 'doc.type.table' then
                            if not ext._generic then
                                globalNode:merge(vm.compileNode(ext))
                            end
                        end
                    end
                end
            end
            if set.type == 'doc.alias' then
                if not set.extends._generic then
                    globalNode:merge(vm.compileNode(set.extends))
                end
            end
        end
    end
end

---@param source vm.object
---@return vm.node
function vm.compileNode(source)
    if not source then
        error('Can not compile nil node')
    end

    if source.type == 'global' then
        return source
    end

    local cache = vm.getNode(source)
    if cache ~= nil then
        return cache
    end

    local node = vm.createNode()
    vm.setNode(source, node, true)
    compileByGlobal(source)
    compileByNode(source)

    node = vm.getNode(source)

    return node
end
