local guide      = require 'parser.guide'
local util       = require 'utility'
local config     = require 'config'
local rpath      = require 'workspace.require-path'
local files      = require 'files'
---@class vm
local vm         = require 'vm.vm'

local LOCK = {}

---@class parser.object
---@field _compiledNodes  boolean
---@field _node           vm.node
---@field _globalBase     table
---@field cindex          integer
---@field func            parser.object
---@field operators?      parser.object[]

-- 该函数有副作用，会给source绑定node！
---@param source parser.object
---@return boolean
local function bindDocs(source)
    local docs = source.bindDocs
    if not docs then
        return false
    end
    for i = #docs, 1, -1 do
        local doc = docs[i]
        if doc.type == 'doc.type' then
            vm.setNode(source, vm.compileNode(doc))
            return true
        end
        if doc.type == 'doc.class' then
            vm.setNode(source, vm.compileNode(doc))
            return true
        end
        if doc.type == 'doc.param' then
            local node = vm.compileNode(doc)
            if doc.optional then
                node:addOptional()
            end
            vm.setNode(source, node)
            return true
        end
        if doc.type == 'doc.module' then
            local name = doc.module
            if not name then
                return true
            end
            local uri = rpath.findUrisByRequireName(guide.getUri(source), name)[1]
            if not uri then
                return true
            end
            local state = files.getState(uri)
            local ast   = state and state.ast
            if not ast then
                return true
            end
            vm.setNode(source, vm.compileNode(ast))
            return true
        end
        if doc.type == 'doc.overload' then
            vm.setNode(source, vm.compileNode(doc))
        end
    end
    return false
end

---@param source parser.object
---@param key any
---@param ref boolean
---@param pushResult fun(res: parser.object, markDoc?: boolean)
local function searchFieldByLocalID(source, key, ref, pushResult)
    local fields
    if key then
        fields = vm.getLocalSourcesSets(source, key)
        if ref then
            local gets = vm.getLocalSourcesGets(source, key)
            if gets then
                fields = fields or {}
                for _, src in ipairs(gets) do
                    fields[#fields+1] = src
                end
            end
        end
    else
        fields = vm.getLocalFields(source, false)
    end
    if not fields then
        return
    end
    local hasMarkDoc = {}
    for _, src in ipairs(fields) do
        if src.bindDocs then
            if bindDocs(src) then
                local skey = guide.getKeyName(src)
                if skey then
                    hasMarkDoc[skey] = true
                end
                pushResult(src, true)
            end
        end
    end
    for _, src in ipairs(fields) do
        local skey = guide.getKeyName(src)
        if not hasMarkDoc[skey] then
            pushResult(src)
        end
    end
end

---@param suri uri
---@param source parser.object
---@param key any
---@param ref boolean
---@param pushResult fun(res: parser.object, markDoc?: boolean)
local function searchFieldByGlobalID(suri, source, key, ref, pushResult)
    local node = source._globalNode
    if not node then
        return
    end
    if node.cate == 'variable' then
        if key then
            if type(key) ~= 'string' then
                return
            end
            local global = vm.getGlobal('variable', node.name, key)
            if global then
                for _, set in ipairs(global:getSets(suri)) do
                    pushResult(set)
                end
                for _, get in ipairs(global:getGets(suri)) do
                    pushResult(get)
                end
            end
        else
            local globals = vm.getGlobalFields('variable', node.name)
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
end

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
    : case 'doc.type.string'
    : call(function (suri, source, key, ref, pushResult)
        -- change to `string: stringlib` ?
        local stringlib = vm.getGlobal('type', 'stringlib')
        if stringlib then
            vm.getClassFields(suri, stringlib, key, ref, pushResult)
        end
    end)
    : case 'doc.type.array'
    : call(function (suri, source, key, ref, pushResult)
        if type(key) == 'number' then
            if key < 1
            or not math.tointeger(key) then
                return
            end
            pushResult(source.node)
        end
        if type(key) == 'table' then
            if vm.isSubType(suri, key, 'integer') then
                pushResult(source.node)
            end
        end
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
                local global = vm.getGlobal('variable', node.name, key)
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
                local globals = vm.getGlobalFields('variable', node.name)
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
        searchFieldByLocalID(source, key, ref, pushResult)
        searchFieldByGlobalID(suri, source, key, ref, pushResult)
    end)

---@param suri uri
---@param object vm.global
---@param key string|vm.global
---@param ref boolean
---@param pushResult fun(field: vm.object, isMark?: boolean)
function vm.getClassFields(suri, object, key, ref, pushResult)
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

                local function copyToSearched()
                    for fieldKey in pairs(hasFounded) do
                        searchedFields[fieldKey] = true
                        hasFounded[fieldKey] = nil
                    end
                end

                for _, field in ipairs(set.fields) do
                    local fieldKey = guide.getKeyName(field)
                    if fieldKey then
                        -- ---@field x boolean -> class.x
                        if key == nil
                        or fieldKey == key then
                            if not searchedFields[fieldKey] then
                                pushResult(field, true)
                                hasFounded[fieldKey] = true
                            end
                        end
                    elseif key and not hasFounded[key] then
                        local keyType = type(key)
                        if keyType == 'table' then
                            -- ---@field [integer] boolean -> class[integer]
                            local fieldNode = vm.compileNode(field.field)
                            if vm.isSubType(suri, key.name, fieldNode) then
                                local nkey = '|' .. key.name
                                if not searchedFields[nkey] then
                                    pushResult(field, true)
                                    hasFounded[nkey] = true
                                end
                            end
                        else
                            local typeName
                            if keyType == 'number' then
                                if math.tointeger(key) then
                                    typeName = 'integer'
                                else
                                    typeName = 'number'
                                end
                            elseif keyType == 'boolean'
                            or     keyType == 'string' then
                                typeName = keyType
                            end
                            if typeName and field.field.type ~= 'doc.field.name' then
                                -- ---@field [integer] boolean -> class[1]
                                local fieldNode = vm.compileNode(field.field)
                                if vm.isSubType(suri, typeName, fieldNode) then
                                    local nkey = '|' .. typeName
                                    if not searchedFields[nkey] then
                                        pushResult(field, true)
                                        hasFounded[nkey] = true
                                    end
                                end
                            end
                        end
                    end
                end
                copyToSearched()
                -- check local field and global field
                if not searchedFields[key] and set.bindSource then
                    local src = set.bindSource
                    if src.value and src.value.type == 'table' then
                        searchFieldSwitch('table', suri, src.value, key, ref, function (field)
                            local fieldKey = guide.getKeyName(field)
                            if fieldKey then
                                if  not searchedFields[fieldKey]
                                and guide.isSet(field) then
                                    hasFounded[fieldKey] = true
                                    pushResult(field, true)
                                end
                            end
                        end)
                    end
                    copyToSearched()
                    searchFieldSwitch(src.type, suri, src, key, ref, function (field)
                        local fieldKey = guide.getKeyName(field)
                        if fieldKey and not searchedFields[fieldKey] then
                            if  not searchedFields[fieldKey]
                            and guide.isSet(field)
                            and field.value then
                                if  vm.getLocalID(field)
                                and vm.getLocalID(field) == vm.getLocalID(field.value) then
                                elseif src._globalNode
                                and    src._globalNode == field.value._globalNode then
                                else
                                    hasFounded[fieldKey] = true
                                end
                                pushResult(field, true)
                            end
                        end
                    end)
                    copyToSearched()
                end
                -- look into extends(if field not found)
                if not searchedFields[key] and set.extends then
                    for _, extend in ipairs(set.extends) do
                        if extend.type == 'doc.extends.name' then
                            local extendType = vm.getGlobal('type', extend[1])
                            if extendType then
                                searchClass(extendType, searchedFields)
                            end
                        end
                    end
                    copyToSearched()
                end
            end
        end
    end

    local function searchGlobal(class)
        if class.cate == 'type' and class.name == '_G' then
            if key == nil then
                local sets = vm.getGlobalSets(suri, 'variable')
                for _, set in ipairs(sets) do
                    pushResult(set)
                end
            elseif type(key) == 'string' then
                local global = vm.getGlobal('variable', key)
                if global then
                    for _, set in ipairs(global:getSets(suri)) do
                        pushResult(set)
                    end
                end
            end
        end
    end

    searchClass(object)
    searchGlobal(object)
end

---@class parser.object
---@field _sign vm.sign|false

---@param source parser.object
---@return vm.sign|false
local function getObjectSign(source)
    if source._sign ~= nil then
        return source._sign
    end
    source._sign = false
    if source.type == 'function' then
        if not source.bindDocs then
            return false
        end
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == 'doc.generic' then
                if not source._sign then
                    source._sign = vm.createSign()
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
        source._sign = vm.createSign()
        if source.type == 'doc.type.function' then
            for _, arg in ipairs(source.args) do
                if arg.extends then
                    local argNode = vm.compileNode(arg.extends)
                    if arg.optional then
                        argNode:addOptional()
                    end
                    source._sign:addSign(argNode)
                else
                    source._sign:addSign(vm.createNode())
                end
            end
        end
    end
    return source._sign
end

---@param func  parser.object
---@param index integer
---@return (parser.object|vm.generic)?
function vm.getReturnOfFunction(func, index)
    if func.type == 'function' then
        if not func._returns then
            func._returns = {}
        end
        if not func._returns[index] then
            func._returns[index] = {
                type        = 'function.return',
                parent      = func,
                returnIndex = index,
            }
        end
        return func._returns[index]
    end
    if func.type == 'doc.type.function' then
        local rtn = func.returns[index]
        if not rtn then
            local lastReturn = func.returns[#func.returns]
            if lastReturn and lastReturn.name and lastReturn.name[1] == '...' then
                rtn = lastReturn
            else
                return nil
            end
        end
        local sign = getObjectSign(func)
        if not sign then
            return rtn
        end
        return vm.createGeneric(rtn, sign)
    end
    return nil
end

---@param args parser.object[]
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

---@param source parser.object
local function matchCall(source)
    local call = source.parent
    if not call
    or call.type ~= 'call'
    or call.node ~= source then
        return
    end
    local funcs = vm.getMatchedFunctions(source, call.args)
    local myNode = vm.getNode(source)
    if not myNode then
        return
    end
    local needRemove
    for n in myNode:eachObject() do
        if n.type == 'function'
        or n.type == 'doc.type.function' then
            if not util.arrayHas(funcs, n) then
                if not needRemove then
                    needRemove = vm.createNode()
                end
                needRemove:merge(n)
            end
        end
    end
    if needRemove then
        local newNode = myNode:copy()
        newNode:removeNode(needRemove)
        newNode:setData('originNode', myNode)
        vm.setNode(source, newNode, true)
    end
end

---@param func  parser.object
---@param index integer
---@param args  parser.object[]
---@return vm.node
local function getReturn(func, index, args)
    if not func._callReturns then
        func._callReturns = {}
    end
    if not func._callReturns[index] then
        local call = func.parent
        func._callReturns[index] = {
            type   = 'call.return',
            parent = call,
            func   = func,
            cindex = index,
            args   = args,
            start  = call.start,
            finish = call.finish,
        }
    end
    return vm.compileNode(func._callReturns[index])
end

---@param source parser.object
---@return boolean
local function bindAs(source)
    local root = guide.getRoot(source)
    local docs = root.docs
    if not docs then
        return false
    end
    local ases = docs._asCache
    if not ases then
        ases = {}
        docs._asCache = ases
        for _, doc in ipairs(docs) do
            if doc.type == 'doc.as' and doc.as and doc.touch then
                ases[#ases+1] = doc
            end
        end
        table.sort(ases, function (a, b)
            return a.touch < b.touch
        end)
    end

    if #ases == 0 then
        return false
    end

    local max = #ases
    local index
    local left  = 1
    local right = max
    for _ = 1, 1000 do
        if left == right then
            index = left
            break
        end
        index = left + (right - left) // 2
        local doc = ases[index]
        if doc.touch < source.finish then
            left = index + 1
        else
            right = index
        end
    end

    local doc = ases[index]
    if doc and doc.touch == source.finish then
        vm.setNode(source, vm.compileNode(doc.as), true)
        return true
    end

    return false
end

---@param source parser.object
---@param key? string|vm.global
---@param pushResult fun(source: parser.object)
function vm.compileByParentNode(source, key, ref, pushResult)
    local parentNode = vm.compileNode(source)
    local docedResults = {}
    local commonResults = {}
    local mark = {}
    local suri = guide.getUri(source)
    local hasClass
    for node in parentNode:eachObject() do
        if  node.type == 'global'
        and node.cate == 'type'
        ---@cast node vm.global
        and not guide.isBasicType(node.name) then
            hasClass = true
            break
        end
    end
    for node in parentNode:eachObject() do
        if not hasClass
        or (
                node.type == 'global'
            and node.cate == 'type'
            ---@cast node vm.global
            and not guide.isBasicType(node.name)
        )
        or guide.isLiteral(node) then
            searchFieldSwitch(node.type, suri, node, key, ref, function (res, markDoc)
                if mark[res] then
                    return
                end
                mark[res] = true
                if markDoc then
                    docedResults[#docedResults+1] = res
                else
                    commonResults[#commonResults+1] = res
                end
            end)
        end
    end

    if not next(mark) then
        searchFieldByLocalID(source, key, ref, function (res, markDoc)
            if mark[res] then
                return
            end
            mark[res] = true
            if markDoc then
                docedResults[#docedResults+1] = res
            else
                commonResults[#commonResults+1] = res
            end
        end)
    end

    if #docedResults > 0 then
        for _, res in ipairs(docedResults) do
            pushResult(res)
        end
    end
    if #docedResults == 0 or key == nil then
        for _, res in ipairs(commonResults) do
            pushResult(res)
        end
    end
end

---@param list  parser.object[]
---@param index integer
---@return vm.node
---@return parser.object?
function vm.selectNode(list, index)
    local exp
    if list[index] then
        exp = list[index]
        index = 1
    else
        for i = index, 1, -1 do
            if list[i] then
                local last = list[i]
                if last.type == 'call'
                or last.type == 'varargs' then
                    index = index - i + 1
                    exp = last
                end
                break
            end
        end
    end
    if not exp then
        return vm.createNode(vm.declareGlobal('type', 'nil')), nil
    end
    ---@type vm.node?
    local result
    if exp.type == 'call' then
        result = getReturn(exp.node, index, exp.args)
        if result:isEmpty() then
            result:merge(vm.declareGlobal('type', 'unknown'))
        end
    else
        ---@type vm.node
        result = vm.compileNode(exp)
        if result:isEmpty() then
            result:merge(vm.declareGlobal('type', 'unknown'))
        end
    end
    return result, exp
end

---@param source parser.object
---@param list   parser.object[]
---@param index  integer
---@return vm.node
local function selectNode(source, list, index)
    local result = vm.selectNode(list, index)
    if source.type == 'function.return' then
        -- remove any for returns
        local rtnNode = vm.createNode()
        for n in result:eachObject() do
            if guide.isLiteral(n) then
                rtnNode:merge(n)
            end
            if n.type == 'global' and n.cate == 'type' then
                if  n.name ~= 'any' then
                    rtnNode:merge(n)
                end
            else
                rtnNode:merge(n)
            end
        end
        vm.setNode(source, rtnNode)
        return rtnNode
    end
    vm.setNode(source, result)
    return result
end

---@param source parser.object
---@param node   vm.node.object
---@return boolean
local function isValidCallArgNode(source, node)
    if source.type == 'function' then
        return node.type == 'doc.type.function'
    end
    if source.type == 'table' then
        return node.type == 'doc.type.table' or node.type == 'doc.type.array'
            or (    node.type == 'global'
                and node.cate == 'type'
                ---@cast node vm.global
                and not guide.isBasicType(node.name)
            )
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
            ---@cast n parser.object
            local sign = getObjectSign(n)
            local farg = getFuncArg(n, myIndex)
            if farg then
                for fn in vm.compileNode(farg):eachObject() do
                    if isValidCallArgNode(arg, fn) then
                        if fn.type == 'doc.type.function' then
                            ---@cast fn parser.object
                            if sign then
                                local generic = vm.createGeneric(fn, sign)
                                local args    = {}
                                for i = fixIndex + 1, myIndex - 1 do
                                    args[#args+1] = call.args[i]
                                end
                                fn = generic:resolve(guide.getUri(call), args)
                            end
                        end
                        vm.setNode(arg, fn)
                    end
                end
            end
        end
        if n.type == 'doc.type.function' then
            ---@cast n parser.object
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
---@return vm.node?
function vm.compileCallArg(arg, call, index)
    if not index then
        for i, carg in ipairs(call.args) do
            if carg == arg then
                index = i
                break
            end
        end
        if not index then
            return nil
        end
    end

    local callNode = vm.compileNode(call.node)
    compileCallArgNode(arg, call, callNode, 0, index)

    if call.node.special == 'pcall'
    or call.node.special == 'xpcall' then
        local fixIndex = call.node.special == 'pcall' and 1 or 2
        if call.args and call.args[1] then
            callNode = vm.compileNode(call.args[1])
            compileCallArgNode(arg, call, callNode, fixIndex, index - fixIndex)
        end
    end
    return vm.getNode(arg)
end

---@class parser.object
---@field _iterator? table
---@field _iterArgs? table
---@field _iterVars? table<parser.object, vm.node>

---@param source parser.object
---@param target parser.object
local function compileForVars(source, target)
    if not source.exps then
        return
    end
    --  for k, v in pairs(t) do
    --> for k, v in iterator, status, initValue do
    --> local k, v = iterator(status, initValue)
    if not source._iterator then
        source._iterator = {
            type = 'dummyfunc',
            parent = source,
        }
        source._iterArgs = {{},{}}
        source._iterVars = {}
    end
    -- iterator
    if not vm.getNode(source._iterator) then
        selectNode(source._iterator,    source.exps, 1)
    end
    -- status
    if not vm.getNode(source._iterArgs[1]) then
        selectNode(source._iterArgs[1], source.exps, 2)
    end
    -- initValue
    if not vm.getNode(source._iterArgs[2]) then
        selectNode(source._iterArgs[2], source.exps, 3)
    end
    if source.keys then
        for i, loc in ipairs(source.keys) do
            if loc == target then
                local node = getReturn(source._iterator, i, source._iterArgs)
                node:removeOptional()
                vm.setNode(loc, node)
            end
        end
    end
end

---@param source parser.object
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
        vm.getNode(source):remove 'function'
    end
    local hasMarkValue
    if not hasMarkDoc and source.value then
        hasMarkValue = true
        if source.value.type == 'table' then
            vm.setNode(source, source.value)
        elseif source.value.type ~= 'nil' then
            vm.setNode(source, vm.compileNode(source.value))
        end
    end
    if not hasMarkValue and not hasMarkValue then
        if source.ref then
            for _, ref in ipairs(source.ref) do
                if  ref.type == 'setlocal'
                and ref.value
                and ref.value.type == 'function' then
                    vm.setNode(source, vm.compileNode(ref.value))
                end
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
                        local argNode = vm.compileNode(arg)
                        for an in argNode:eachObject() do
                            if an.type ~= 'doc.generic.name' then
                                vm.setNode(source, an)
                            end
                        end
                        hasDocArg = true
                    end
                end
            end
        end
        if not hasDocArg then
            vm.setNode(source, vm.declareGlobal('type', 'any'))
        end
    end
    -- for x in ... do
    if source.parent.type == 'in' then
        compileForVars(source.parent, source)
    end

    -- for x = ... do
    if source.parent.type == 'loop' then
        if source.parent.loc == source then
            if bindDocs(source) then
                return
            end
            vm.setNode(source, vm.declareGlobal('type', 'integer'))
        end
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
        or source.parent.type == 'tableexp'
        or source.parent.type == 'setfield'
        or source.parent.type == 'setindex' then
            local parentNode = vm.compileNode(source.parent)
            for _, pn in ipairs(parentNode) do
                if  pn.type == 'global'
                and pn.cate == 'type' then
                    ---@cast pn vm.global
                    if not guide.isBasicType(pn.name) then
                        vm.setNode(source, pn)
                    end
                elseif pn.type == 'doc.type.table' or pn.type == 'doc.type.array' then
                    vm.setNode(source, pn)
                end
            end
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
        if bindAs(source) then
            return
        end
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

        vm.launchRunner(source, function (src, node)
            if src.type == 'setlocal' then
                if src.bindDocs then
                    for _, doc in ipairs(src.bindDocs) do
                        if doc.type == 'doc.type' then
                            vm.setNode(src, vm.compileNode(doc), true)
                            return vm.getNode(src)
                        end
                    end
                end
                if src.value then
                    if src.value.type == 'table' then
                        vm.setNode(src, vm.createNode(src.value))
                        vm.setNode(src, node:copy():asTable())
                    else
                        local function clearLockedNode(child)
                            if not child then
                                return
                            end
                            if child.type == 'function' then
                                return
                            end
                            if child.type == 'setlocal'
                            or child.type == 'getlocal' then
                                if child.node == source then
                                    return
                                end
                            end
                            if LOCK[child] then
                                vm.removeNode(child)
                            end
                            guide.eachChild(child, clearLockedNode)
                        end
                        clearLockedNode(src.value)
                        vm.setNode(src, vm.compileNode(src.value), true)
                    end
                else
                    vm.setNode(src, node, true)
                end
                return vm.getNode(src)
            elseif src.type == 'getlocal' then
                if bindAs(src) then
                    return
                end
                vm.setNode(src, node, true)
                matchCall(src)
            end
        end)

        if not hasMark then
            local parentFunc = guide.getParentFunction(source)
            for _, ref in ipairs(source.ref) do
                if  ref.type == 'setlocal'
                and guide.getParentFunction(ref) == parentFunc then
                    local refNode = vm.getNode(ref)
                    if refNode then
                        vm.setNode(source, refNode)
                    end
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
        if bindAs(source) then
            return
        end
        vm.compileNode(source.node)
    end)
    : case 'setfield'
    : case 'setmethod'
    : case 'setindex'
    : case 'getfield'
    : case 'getmethod'
    : case 'getindex'
    : call(function (source)
        if guide.isGet(source) and bindAs(source) then
            return
        end
        ---@type (string|vm.node)?
        local key = guide.getKeyName(source)
        if key == nil and source.index then
            key = vm.compileNode(source.index)
        end
        if key == nil then
            return
        end
        if type(key) == 'table' then
            ---@cast key vm.node
            local uri = guide.getUri(source)
            local value = vm.getTableValue(uri, vm.compileNode(source.node), key)
            if value then
                vm.setNode(source, value)
            end
            for k in key:eachObject() do
                if k.type == 'global' and k.cate == 'type' then
                    ---@cast k vm.global
                    vm.compileByParentNode(source.node, k, false, function (src)
                        vm.setNode(source, vm.compileNode(src))
                        if src.value then
                            vm.setNode(source, vm.compileNode(src.value))
                        end
                    end)
                end
            end
        else
            ---@cast key string
            vm.compileByParentNode(source.node, key, false, function (src)
                if src.value then
                    if bindDocs(src) then
                        vm.setNode(source, vm.compileNode(src))
                    elseif src.value.type ~= 'nil' then
                        vm.setNode(source, vm.compileNode(src.value))
                        local node = vm.getNode(src)
                        if node then
                            vm.setNode(source, node)
                        end
                    end
                else
                    vm.setNode(source, vm.compileNode(src))
                end
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
        if bindAs(source) then
            return
        end
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

        if not hasMarkDoc then
            vm.compileByParentNode(source.node, guide.getKeyName(source), false, function (src)
                if src.type == 'doc.field'
                or src.type == 'doc.type.field' then
                    hasMarkDoc = true
                    vm.setNode(source, vm.compileNode(src))
                end
            end)
        end

        if not hasMarkDoc and source.value then
            vm.setNode(source, vm.compileNode(source.value))
        end

    end)
    : case 'field'
    : case 'method'
    : call(function (source)
        vm.setNode(source, vm.compileNode(source.parent))
    end)
    : case 'tableexp'
    : call(function (source)
        if (source.parent.type == 'table') then
            local node = vm.compileNode(source.parent)
            for n in node:eachObject() do
                if n.type == 'doc.type.array' then
                    vm.setNode(source, vm.compileNode(n.node))
                end
            end
        end
        vm.setNode(source, vm.compileNode(source.value))
    end)
    : case 'function.return'
    ---@param source parser.object
    : call(function (source)
        local func  = source.parent
        local index = source.returnIndex
        local hasMarkDoc
        if func.bindDocs then
            local sign = getObjectSign(func)
            local lastReturn
            for _, doc in ipairs(func.bindDocs) do
                if doc.type == 'doc.return' then
                    for _, rtn in ipairs(doc.returns) do
                        lastReturn = rtn
                        if rtn.returnIndex == index then
                            hasMarkDoc = true
                            local hasGeneric
                            if sign then
                                guide.eachSourceType(rtn, 'doc.generic.name', function (src)
                                    hasGeneric = true
                                end)
                            end
                            if hasGeneric then
                                ---@cast sign -false
                                vm.setNode(source, vm.createGeneric(rtn, sign))
                            else
                                vm.setNode(source, vm.compileNode(rtn))
                            end
                        end
                    end
                end
            end
            if  lastReturn
            and not hasMarkDoc then
                if lastReturn.name and lastReturn.name[1] == '...' then
                    hasMarkDoc = true
                    vm.setNode(source, vm.compileNode(lastReturn))
                end
            end
        end
        local hasReturn
        if func.returns and not hasMarkDoc then
            for _, rtn in ipairs(func.returns) do
                if selectNode(source, rtn, index) then
                    hasReturn = true
                end
            end
            if hasReturn then
                local hasKnownType
                local hasUnknownType
                for n in vm.getNode(source):eachObject() do
                    if guide.isLiteral(n) then
                        if n.type ~= 'nil' then
                            hasKnownType = true
                            break
                        end
                        goto CONTINUE
                    end
                    if n.type == 'global' and n.cate == 'type' then
                        if n.name ~= 'nil' then
                            hasKnownType = true
                            break
                        end
                        goto CONTINUE
                    end
                    hasUnknownType = true
                    ::CONTINUE::
                end
                if not hasKnownType and hasUnknownType then
                    vm.setNode(source, vm.declareGlobal('type', 'unknown'))
                end
            end
        end
        if not hasMarkDoc and not hasReturn then
            vm.setNode(source, vm.declareGlobal('type', 'nil'))
        end
    end)
    : case 'call.return'
    ---@param source parser.object
    : call(function (source)
        if bindAs(source) then
            return
        end
        local func  = source.func
        local args  = source.args
        local index = source.cindex
        if func.special == 'setmetatable' then
            if not args then
                return
            end
            vm.setNode(source, getReturnOfSetMetaTable(args))
            return
        end
        if func.special == 'pcall' and index > 1 then
            if not args then
                return
            end
            local newArgs = {}
            for i = 2, #args do
                newArgs[#newArgs+1] = args[i]
            end
            local node = getReturn(args[1], index - 1, newArgs)
            if node then
                vm.setNode(source, node)
            end
            return
        end
        if func.special == 'xpcall' and index > 1 then
            if not args then
                return
            end
            local newArgs = {}
            for i = 3, #args do
                newArgs[#newArgs+1] = args[i]
            end
            local node = getReturn(args[1], index - 1, newArgs)
            if node then
                vm.setNode(source, node)
            end
            return
        end
        if func.special == 'require' then
            if not args then
                return
            end
            local nameArg = args[1]
            if not nameArg or nameArg.type ~= 'string' then
                return
            end
            local name = nameArg[1]
            if not name or type(name) ~= 'string' then
                return
            end
            local uri = rpath.findUrisByRequireName(guide.getUri(func), name)[1]
            if not uri then
                return
            end
            local state = files.getState(uri)
            local ast   = state and state.ast
            if not ast then
                return
            end
            vm.setNode(source, vm.compileNode(ast))
            return
        end
        local funcNode = vm.compileNode(func)
        ---@type vm.node?
        for mfunc in funcNode:eachObject() do
            if mfunc.type == 'function'
            or mfunc.type == 'doc.type.function' then
                ---@cast mfunc parser.object
                local returnObject = vm.getReturnOfFunction(mfunc, index)
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
                                vm.setNode(source, rnode)
                            end
                        end
                        if returnNode:isOptional() then
                            vm.getNode(source):addOptional()
                        end
                    end
                end
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
            if node:isEmpty() then
                node = vm.runOperator('call', vararg.node) or node
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
        if node:isEmpty() then
            node = vm.runOperator('call', source.node) or node
        end
        vm.setNode(source, node)
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
    : case 'doc.type.code'
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
        if not source.node[1] then
            return
        end
        local global = vm.getGlobal('type', source.node[1])
        if not global then
            return
        end
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
    : case 'doc.enum.name'
    : call(function (source)
        vm.setNode(source, vm.compileNode(source.parent))
    end)
    : case 'doc.field'
    : call(function (source)
        if not source.extends then
            return
        end
        local fieldNode = vm.compileNode(source.extends)
        if source.optional then
            fieldNode:addOptional()
        end
        vm.setNode(source, fieldNode)
    end)
    : case 'doc.type.field'
    : call(function (source)
        if not source.extends then
            return
        end
        local fieldNode = vm.compileNode(source.extends)
        if source.optional then
            fieldNode:addOptional()
        end
        vm.setNode(source, fieldNode)
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
        if not source.bindDocs then
            return
        end
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == 'doc.vararg' then
                vm.setNode(source, vm.compileNode(doc))
            end
            if doc.type == 'doc.param' then
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
        local type = vm.getGlobal('type', source[1])
        if type then
            vm.setNode(source, type)
        end
    end)
    : case 'doc.type.arg'
    : call(function (source)
        if source.extends then
            vm.setNode(source, vm.compileNode(source.extends))
        else
            vm.setNode(source, vm.declareGlobal('type', 'any'))
        end
        if source.optional then
            vm.getNode(source):addOptional()
        end
    end)
    : case 'unary'
    : call(function (source)
        if bindAs(source) then
            return
        end
        if not source[1] then
            return
        end
        vm.unarySwich(source.op.type, source)
    end)
    : case 'binary'
    : call(function (source)
        if bindAs(source) then
            return
        end
        if not source[1] or not source[2] then
            return
        end
        vm.binarySwitch(source.op.type, source)
    end)

---@param source parser.object
local function compileByNode(source)
    compilerSwitch(source.type, source)
end

---@param source parser.object
local function compileByGlobal(source)
    local global = source._globalNode
    if not global then
        return
    end
    ---@cast source parser.object
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
    ---@type vm.node
    globalNode = vm.createNode(global)
    vm.setNode(root._globalBase[name], globalNode, true)
    vm.setNode(source, globalNode, true)

    -- TODO:don't mix
    --local sets = global.links[uri].sets or {}
    --local gets = global.links[uri].gets or {}
    --for _, set in ipairs(sets) do
    --    vm.setNode(set, globalNode, true)
    --end
    --for _, get in ipairs(gets) do
    --    vm.setNode(get, globalNode, true)
    --end

    if global.cate == 'variable' then
        local hasMarkDoc
        for _, set in ipairs(global:getSets(uri)) do
            if set.bindDocs and set.parent.type == 'main' then
                if bindDocs(set) then
                    globalNode:merge(vm.compileNode(set))
                    hasMarkDoc = true
                end
                if vm.getNode(set) then
                    globalNode:merge(vm.compileNode(set))
                end
            end
        end
        -- Set all globals node first to avoid recursive
        for _, set in ipairs(global:getSets(uri)) do
            vm.setNode(set, globalNode, true)
        end
        for _, set in ipairs(global:getSets(uri)) do
            if set.value and set.value.type ~= 'nil' and set.parent.type == 'main' then
                if not hasMarkDoc or guide.isLiteral(set.value) then
                    globalNode:merge(vm.compileNode(set.value))
                end
            end
        end
        for _, set in ipairs(global:getSets(uri)) do
            vm.setNode(set, globalNode, true)
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
        if TEST then
            error('Can not compile nil source')
        else
            log.error('Can not compile nil source')
        end
    end

    local cache = vm.getNode(source)
    if cache ~= nil then
        return cache
    end

    if source.type == 'generic' then
        vm.setNode(source, source)
        local node = vm.getNode(source)
        ---@cast node -?
        return node
    end

    ---@cast source parser.object
    vm.setNode(source, vm.createNode(), true)
    LOCK[source] = true
    compileByGlobal(source)
    compileByNode(source)
    matchCall(source)
    LOCK[source] = nil

    local node = vm.getNode(source)
    ---@cast node -?
    return node
end
