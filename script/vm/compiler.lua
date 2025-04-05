local guide      = require 'parser.guide'
local util       = require 'utility'
local config     = require 'config'
local rpath      = require 'workspace.require-path'
local files      = require 'files'
---@class vm
local vm         = require 'vm.vm'
local plugin     = require 'plugin'

---@class parser.object
---@field _compiledNodes        boolean
---@field _node                 vm.node
---@field cindex                integer
---@field func                  parser.object
---@field hideView              boolean
---@field package _returns?     parser.object[]
---@field package _callReturns? parser.object[]
---@field package _asCache?     parser.object[]

-- 该函数有副作用，会给source绑定node！
---@param source parser.object
---@return boolean
function vm.bindDocs(source)
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
            for j = i + 1, #docs do
                local overload = docs[j]
                if overload.type == 'doc.overload' then
                    overload.overload.hideView = true
                end
            end
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

---@param source parser.object | vm.variable
---@param key string|vm.global|vm.ANY|vm.ANYDOC
---@param pushResult fun(res: parser.object, markDoc?: boolean)
local function searchFieldByLocalID(source, key, pushResult)
    local fields
    if key ~= vm.ANY then
        if type(key) ~= 'string' then
            return
        end
        if source.type == 'variable' then
            ---@cast source vm.variable
            fields = source:getSets(key)
        else
            ---@cast source parser.object
            fields = vm.getVariableSets(source, key)
        end
    else
        if source.type == 'variable' then
            ---@cast source vm.variable
            fields = source:getFields(false)
        else
            ---@cast source parser.object
            fields = vm.getVariableFields(source, false)
        end
    end
    if not fields then
        return
    end

    --Exact classes do not allow injected fields
    if source.type ~= 'variable' and source.bindDocs then
        ---@cast source parser.object
        local uri = guide.getUri(source)
        for _, src in ipairs(fields) do
            if src.type == "setfield" then
                local class = vm.getDefinedClass(uri, source)
                if class then
                    for _, doc in ipairs(class:getSets(uri)) do
                        if vm.docHasAttr(doc, 'exact') then
                            return
                        end
                    end
                end
            end
        end
    end

    local hasMarkDoc = {}
    for _, src in ipairs(fields) do
        if src.bindDocs then
            if vm.bindDocs(src) then
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
---@param key string|vm.global|vm.ANY|vm.ANYDOC
---@param pushResult fun(res: parser.object, markDoc?: boolean)
local function searchFieldByGlobalID(suri, source, key, pushResult)
    local node = vm.getGlobalNode(source)
    if not node then
        return
    end
    if node.cate == 'variable' then
        if key ~= vm.ANY and key ~= vm.ANYDOC then
            if type(key) ~= 'string' then
                return
            end
            local global = vm.getGlobal('variable', node.name, key)
            if global then
                for _, set in ipairs(global:getSets(suri)) do
                    pushResult(set)
                end
            end
        else
            local globals = vm.getGlobalFields('variable', node.name)
            for _, global in ipairs(globals) do
                for _, set in ipairs(global:getSets(suri)) do
                    pushResult(set)
                end
            end
        end
    end
    if node.cate == 'type' then
        vm.getClassFields(suri, node, key, pushResult)
    end
end

local VARARGKEY = {'<VARARGKEY>'}
local function searchLiteralFieldFromTable(source, key, callback)
    local cache = source._literalFieldsCache
    local cache2 = source._literalFieldsCache2
    if not cache then
        cache = {}
        cache2 = {}
        source._literalFieldsCache = cache
        source._literalFieldsCache2 = cache2

        for _, field in ipairs(source) do
            local fkey
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                fkey = guide.getKeyName(field)
            end
            if field.type == 'tableexp' then
                fkey = field.tindex
            end
            if field.type == 'varargs' then
                fkey = VARARGKEY
            end
            if fkey ~= nil then
                if cache[fkey] == nil then
                    cache[fkey] = field
                else
                    if cache2[fkey] == nil then
                        cache2[fkey] = {}
                    end
                    cache2[fkey][#cache2[fkey]+1] = field
                end
            end
        end
    end
    local value = cache[key]
    if value ~= nil then
        callback(value)
        if cache2[key] then
            for _, field in ipairs(cache2[key]) do
                callback(field)
            end
        end
        return
    end
    if type(key) == 'number'
    and key >= 1
    and math.tointeger(key) then
        value = cache[VARARGKEY]
    end
    if value ~= nil then
        callback(value)
        if cache2[VARARGKEY] then
            for _, field in ipairs(cache2[VARARGKEY]) do
                callback(field)
            end
        end
    end
end

local searchFieldSwitch = util.switch()
    : case 'table'
    : call(function (_suri, source, key, pushResult)
        if type(key) == 'string'
        or type(key) == 'number' then
            searchLiteralFieldFromTable(source, key, pushResult)
        elseif key == vm.ANY then
            for _, field in ipairs(source) do
                if field.type == 'tablefield'
                or field.type == 'tableindex'
                or field.type == 'tableexp'
                or field.type == 'varargs' then
                    pushResult(field)
                end
            end
        end
        local docs = source.bindDocs
        if docs then
            for _, doc in ipairs(docs) do
                if doc.type == 'doc.enum' then
                    if not vm.docHasAttr(doc, 'partial')  then
                        return
                    end
                    for _, def in ipairs(vm.getDefs(doc)) do
                        if def.type ~= 'doc.enum' then
                            goto CONTINUE
                        end
                        local tbl = def.bindSource
                        if not tbl then
                            return
                        end
                        for _, field in ipairs(tbl) do
                            if field.type == 'tablefield'
                            or field.type == 'tableindex' then
                                if not field.value then
                                    goto CONTINUE
                                end
                                local fieldKey = guide.getKeyName(field)
                                if key == vm.ANY
                                or key == vm.ANYDOC
                                or key == fieldKey then
                                    pushResult(field)
                                end
                                ::CONTINUE::
                            end
                        end
                        ::CONTINUE::
                    end
                end
            end
        end
    end)
    : case 'string'
    : case 'doc.type.string'
    : call(function (suri, _source, key, pushResult)
        -- change to `string: stringlib` ?
        local stringlib = vm.getGlobal('type', 'stringlib')
        if stringlib then
            vm.getClassFields(suri, stringlib, key, pushResult)
        end
    end)
    : case 'doc.type.array'
    : call(function (suri, source, key, pushResult)
        if type(key) == 'number' then
            if key < 1
            or not math.tointeger(key) then
                return
            end
            pushResult(source.node, true)
        end
        if type(key) == 'table' then
            if vm.isSubType(suri, key, 'integer') then
                pushResult(source.node, true)
            end
        end
    end)
    : case 'doc.type.table'
    : call(function (_suri, source, key, pushResult)
        if type(key) == 'string' and key:find(vm.ID_SPLITE) then
            return
        end
        for _, field in ipairs(source.fields) do
            local fieldKey = field.name
            if fieldKey.type == 'doc.type' then
                local fieldNode = vm.compileNode(fieldKey)
                for fn in fieldNode:eachObject() do
                    if fn.type == 'global' and fn.cate == 'type' then
                        if key == vm.ANY
                        or key == vm.ANYDOC
                        or fn.name == 'any'
                        or (fn.name == 'boolean' and type(key) == 'boolean')
                        or (fn.name == 'number'  and type(key) == 'number')
                        or (fn.name == 'integer' and math.tointeger(key))
                        or (fn.name == 'string'  and type(key) == 'string') then
                            pushResult(field, true)
                        end
                    elseif fn.type == 'doc.type.string'
                    or     fn.type == 'doc.type.integer'
                    or     fn.type == 'doc.type.boolean' then
                        if key == vm.ANY
                        or key == vm.ANYDOC
                        or fn[1] == key then
                            pushResult(field, true)
                        end
                    end
                end
            end
            if fieldKey.type == 'doc.field.name' then
                if key == vm.ANY or key == vm.ANYDOC or fieldKey[1] == key then
                    pushResult(field, true)
                end
            end
        end
    end)
    : case 'doc.type.sign'
    : call(function (suri, source, key, pushResult)
        if not source.node[1] then
            return
        end
        local global = vm.getGlobal('type', source.node[1])
        if not global then
            return
        end
        vm.getClassFields(suri, global, key, pushResult)
    end)
    : case 'global'
    : call(function (suri, node, key, pushResult)
        if node.cate == 'variable' then
            if key ~= vm.ANY and key ~= vm.ANYDOC then
                if type(key) ~= 'string' then
                    return
                end
                local global = vm.getGlobal('variable', node.name, key)
                if global then
                    for _, set in ipairs(global:getSets(suri)) do
                        pushResult(set)
                    end
                end
            else
                local globals = vm.getGlobalFields('variable', node.name)
                for _, global in ipairs(globals) do
                    for _, set in ipairs(global:getSets(suri)) do
                        pushResult(set)
                    end
                end
            end
        end
        if node.cate == 'type' then
            vm.getClassFields(suri, node, key, pushResult)
        end
    end)
    : default(function (suri, source, key, pushResult)
        searchFieldByLocalID(source, key, pushResult)
        searchFieldByGlobalID(suri, source, key, pushResult)
    end)

---@param suri uri
---@param object vm.global
---@param key string|number|integer|boolean|vm.global|vm.ANY|vm.ANYDOC
---@param pushResult fun(field: vm.object, isMark?: boolean)
function vm.getClassFields(suri, object, key, pushResult)
    local mark = {}

    local function searchClass(class, searchedFields)
        local name = class.name
        if mark[name] then
            return
        end
        mark[name] = true
        searchedFields = searchedFields or {}

        local hasFounded = {}
        local function copyToSearched()
            for fieldKey in pairs(hasFounded) do
                searchedFields[fieldKey] = true
                hasFounded[fieldKey] = nil
            end
        end

        local sets = class:getSets(suri)
        for _, set in ipairs(sets) do
            if set.type == 'doc.class' then
                -- check ---@field
                for _, field in ipairs(set.fields) do
                    local fieldKey = guide.getKeyName(field)
                    if fieldKey then
                        -- ---@field x boolean -> class.x
                        if key == vm.ANY
                        or key == vm.ANYDOC
                        or fieldKey == key then
                            if not searchedFields[fieldKey] then
                                pushResult(field, true)
                                hasFounded[fieldKey] = true
                            end
                        end
                        goto CONTINUE
                    end
                    if key == vm.ANY or key == vm.ANYDOC then
                        pushResult(field, true)
                        goto CONTINUE
                    end
                    if hasFounded[key] then
                        goto CONTINUE
                    end
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
                        local keyObject
                        if keyType == 'number' then
                            if math.tointeger(key) then
                                keyObject = { type = 'integer', [1] = key }
                            else
                                keyObject = { type = 'number', [1] = key }
                            end
                        elseif keyType == 'boolean'
                        or     keyType == 'string' then
                            keyObject = { type = keyType, [1] = key }
                        end
                        if keyObject and field.field.type ~= 'doc.field.name' then
                            -- ---@field [integer] boolean -> class[1]
                            local fieldNode = vm.compileNode(field.field)
                            if vm.isSubType(suri, keyObject, fieldNode) then
                                local nkey = '|' .. keyType
                                if not searchedFields[nkey] then
                                    pushResult(field, true)
                                    hasFounded[nkey] = true
                                end
                            end
                        end
                    end
                    ::CONTINUE::
                end
            end
        end
        copyToSearched()

        for _, set in ipairs(sets) do
            if set.type == 'doc.class' then
                -- check local field and global field
                if not searchedFields[key] and set.bindSource then
                    local src = set.bindSource
                    if src.value and src.value.type == 'table' then
                        searchFieldSwitch('table', suri, src.value, key, function (field)
                            local fieldKey = guide.getKeyName(field)
                            if fieldKey then
                                if  not searchedFields[fieldKey]
                                and guide.isAssign(field) then
                                    hasFounded[fieldKey] = true
                                    pushResult(field, true)
                                end
                            end
                        end)
                    end
                    if  src.value
                    and src.value.type == 'select'
                    and src.value.vararg.type == 'call' then
                        local func = src.value.vararg.node
                        local args = src.value.vararg.args
                        if  func.special == 'setmetatable'
                        and args
                        and args[1]
                        and args[1].type == 'table' then
                            searchFieldSwitch('table', suri, args[1], key, function (field)
                                local fieldKey = guide.getKeyName(field)
                                if fieldKey then
                                    if  not searchedFields[fieldKey]
                                    and guide.isAssign(field) then
                                        hasFounded[fieldKey] = true
                                        pushResult(field, true)
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
        copyToSearched()

        for _, set in ipairs(sets) do
            if set.type == 'doc.class' then
                if not searchedFields[key] and set.bindSource then
                    local src = set.bindSource
                    searchFieldSwitch(src.type, suri, src, key, function (field)
                        local fieldKey = guide.getKeyName(field)
                        if fieldKey and not searchedFields[fieldKey] then
                            if  not searchedFields[fieldKey]
                            and guide.isAssign(field)
                            and field.value then
                                if  vm.getVariableID(field)
                                and vm.getVariableID(field) == vm.getVariableID(field.value) then
                                elseif vm.getGlobalNode(src)
                                and    vm.getGlobalNode(src) == vm.getGlobalNode(field.value) then
                                else
                                    hasFounded[fieldKey] = true
                                end
                                pushResult(field, true)
                            end
                        end
                    end)
                end
            end
        end
        copyToSearched()

        for _, set in ipairs(sets) do
            if set.type == 'doc.class' then
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
                end
            end
        end
        copyToSearched()
    end

    local function searchGlobal(class)
        if class.cate == 'type' and class.name == '_G' then
            if key == vm.ANY then
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

---@param func  parser.object
---@param index integer
---@return (parser.object|vm.generic)?
function vm.getReturnOfFunction(func, index)
    if func.type == 'function' then
        if not func._returns then
            func._returns = {}
        end
        if not func._returns[index] then
            ---@diagnostic disable-next-line: missing-fields
            func._returns[index] = {
                type        = 'function.return',
                parent      = func,
                returnIndex = index,
            }
            vm.compileNode(func._returns[index])
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
        local sign = vm.getSign(func)
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
        vm.compileByParentNodeAll(mt, '__index', function (src)
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
    --过滤nil
   node:remove 'nil'
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
    local myNode = vm.getNode(source)
    if not myNode then
        return
    end
    local funcs = vm.getExactMatchedFunctions(source, call.args)
    if not funcs then
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
        newNode.originNode = myNode
        vm.setNode(source, newNode, true)
        if call.args then
            -- recompile existing node caches of args to allow recomputation with the type narrowed call
            for _, arg in ipairs(call.args) do
                if vm.getNode(arg) then
                    vm.removeNode(arg)
                    vm.compileNode(arg)
                end
            end
        end
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
        ---@diagnostic disable-next-line: missing-fields
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
function vm.bindAs(source)
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
        local asNode = vm.compileNode(doc.as)
        vm.setNode(source, asNode, true)
        return true
    end

    return false
end

---@param source parser.object | vm.variable
---@param key string|vm.global|vm.ANY|vm.ANYDOC
---@return parser.object[] docedResults
---@return parser.object[] commonResults
function vm.getNodesOfParentNode(source, key)
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
            searchFieldSwitch(node.type, suri, node, key, function (res, markDoc)
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
        searchFieldByLocalID(source, key, function (res, markDoc)
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

    return docedResults, commonResults
end

-- 遍历所有字段（按照优先级）
---@param source parser.object | vm.variable
---@param key string|vm.global|vm.ANY|vm.ANYDOC
---@param pushResult fun(source: parser.object)
function vm.compileByParentNode(source, key, pushResult)
    local docedResults, commonResults = vm.getNodesOfParentNode(source, key)

    if #docedResults > 0 then
        for _, res in ipairs(docedResults) do
            pushResult(res)
        end
    end
    if #docedResults == 0 or key == vm.ANY then
        for _, res in ipairs(commonResults) do
            pushResult(res)
        end
    end
end

-- 遍历所有字段（无视优先级）
---@param source parser.object | vm.variable
---@param key string|vm.global|vm.ANY|vm.ANYDOC
---@param pushResult fun(source: parser.object)
function vm.compileByParentNodeAll(source, key, pushResult)
    local docedResults, commonResults = vm.getNodesOfParentNode(source, key)

    for _, res in ipairs(docedResults) do
        pushResult(res)
    end
    for _, res in ipairs(commonResults) do
        pushResult(res)
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

    if vm.bindDocs(list) then
        return vm.compileNode(list), exp
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
    ---@type integer?, table<any, boolean>?
    local eventIndex, eventMap
    if call.args then
        for i = 1, 10 do
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

    ---@param n parser.object
    local function dealDocFunc(n)
        local myEvent
        if n.args[eventIndex] then
            if eventMap and myIndex > eventIndex then
                -- if call param has literal types, then also check if function def param has literal types
                -- 1. has no literal values => not enough info, thus allowed by default
                -- 2. has literal values and >= 1 matches call param's literal types => allowed
                -- 3. has literal values but none matches call param's literal types => filtered
                local myEventMap = vm.getLiterals(n.args[eventIndex])
                if myEventMap then
                    local found = false
                    for k in pairs(eventMap) do
                        if myEventMap[k] then
                            -- there is a matching literal
                            found = true
                            break
                        end
                    end
                    if not found then
                        return
                    end
                end
            end
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

    ---@param n parser.object
    local function dealFunction(n)
        local sign = vm.getSign(n)
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
                            local resolvedNode = generic:resolve(guide.getUri(call), args)
                            vm.setNode(arg, resolvedNode)
                            goto CONTINUE
                        end
                    end
                    vm.setNode(arg, fn)
                    ::CONTINUE::
                end
            end
        end
    end

    for n in callNode:eachObject() do
        if n.type == 'function' then
            ---@cast n parser.object
            dealFunction(n)
        elseif n.type == 'doc.type.function' then
            ---@cast n parser.object
            dealDocFunc(n)
        elseif n.type == 'global' and n.cate == 'type' then
            ---@cast n vm.global
            local overloads = vm.getOverloadsByTypeName(n.name, guide.getUri(arg))
            if overloads then
                for _, func in ipairs(overloads) do
                    dealDocFunc(func)
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
---@field package _iterator? table
---@field package _iterArgs? table
---@field package _iterVars? table<parser.object, vm.node>

---@param source parser.object
---@param target parser.object
---@return boolean
local function compileForVars(source, target)
    if not source.exps then
        return false
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
                return true
            end
        end
    end
    return false
end

---@param func parser.object
---@param source parser.object
local function compileFunctionParam(func, source)
    local aindex
    for index, arg in ipairs(func.args) do
        if arg == source then
            aindex = index
            break
        end
    end
    ---@cast aindex integer

    local funcNode = vm.compileNode(func)
    if func.parent.type == 'callargs' then
        -- local call ---@type fun(f: fun(x: number));call(function (x) end) --> x -> number
        for n in funcNode:eachObject() do
            if n.type == 'doc.type.function' and n.args[aindex] then
                local argNode = vm.compileNode(n.args[aindex])
                for an in argNode:eachObject() do
                    if an.type ~= 'doc.generic.name' then
                        vm.setNode(source, an)
                    end
                end
                -- NOTE: keep existing behavior for function as argument which only set type based on the 1st match
                return true
            end
        end
    else
        -- function declaration: use info from all `fun()`, also from the base function when overriding
        --[[
            ---@type fun(x: string)|fun(x: number)
            local function f1(x) end --> x -> string|number

            ---@overload fun(x: string)
            ---@overload fun(x: number)
            local function f2(x) end --> x -> string|number

            ---@class A
            local A = {}
            ---@param x number
            function A:f(x) end --> x -> number
            ---@type A
            local a = {}
            function a:f(x) end --> x -> number
        ]]
        local found = false
        for n in funcNode:eachObject() do
            if (n.type == 'doc.type.function' or n.type == 'function')
            and n.args[aindex] and n.args[aindex] ~= source
            then
                local argNode = vm.compileNode(n.args[aindex])
                for an in argNode:eachObject() do
                    if an.type ~= 'doc.generic.name' then
                        vm.setNode(source, an)
                    end
                end
                found = true
            end
        end
        if found then
            return true
        end
    end

    local derviationParam = config.get(guide.getUri(func), 'Lua.type.inferParamType')
    if derviationParam and func.parent.type == 'local' and func.parent.ref then
        local refs = func.parent.ref
        local found
        for _, ref in ipairs(refs) do
            if ref.parent.type ~= 'call' then
                goto continue
            end
            local caller = ref.parent
            if not caller.args then
                goto continue
            end
            local callerArg = caller.args[aindex]
            if callerArg then
                vm.setNode(source, vm.compileNode(callerArg))
                found = true
            end
            ::continue::
        end
        if found then
            return true
        end
        -- infer local callback function param type
        --[[
            ---@param callback fun(a: integer)
            function register(callback) end

            local function callback(a) end  --> a: integer
            register(callback)
        ]]
        for _, ref in ipairs(refs) do
            if ref.parent.type ~= 'callargs' then
                goto continue
            end
            -- the parent function is a variable used as callback param, find the callback arg index first
            local call = ref.parent.parent
            local cbIndex
            for i, arg in ipairs(call.args) do
                if arg == ref then
                    cbIndex = i
                    break
                end
            end
            ---@cast cbIndex integer

            -- simulate a completion at `cbIndex` to infer this callback function type
            ---@diagnostic disable-next-line: missing-fields
            local node = vm.compileCallArg({ type = 'dummyarg', uri = guide.getUri(call) }, call, cbIndex)
            if not node then
                goto continue
            end
            for n in node:eachObject() do
                -- check if the inferred function has arg at `aindex`
                if n.type == 'doc.type.function' and n.args and n.args[aindex] then
                    -- use type info on this `aindex` arg
                    local argNode = vm.compileNode(n.args[aindex])
                    for an in argNode:eachObject() do
                        if an.type ~= 'doc.generic.name' then
                            vm.setNode(source, an)
                            found = true
                        end
                    end
                end
            end
            ::continue::
        end
        if found then
            return true
        end
    end

    do
        local parent = func.parent
        local key = vm.getKeyName(parent)
        local classDef = vm.getParentClass(parent)
        local suri = guide.getUri(func)
        if classDef and key then
            local found
            for _, set in ipairs(classDef:getSets(suri)) do
                if set.type == 'doc.class' and set.extends then
                    for _, ext in ipairs(set.extends) do
                        if not ext[1] then
                            goto continue
                        end
                        local extClass = vm.getGlobal('type', ext[1])
                        if not extClass then
                            goto continue
                        end
                        vm.getClassFields(suri, extClass, key, function (field, _isMark)
                            for n in vm.compileNode(field):eachObject() do
                                if n.type == 'function' and n.args[aindex] then
                                    local argNode = vm.compileNode(n.args[aindex])
                                    for an in argNode:eachObject() do
                                        if an.type ~= 'doc.generic.name' then
                                            vm.setNode(source, an)
                                            found = true
                                        end
                                    end
                                end
                            end
                        end)
                        ::continue::
                    end
                end
            end
            if found then
                return true
            end
        end
    end
end

---@param source parser.object
local function compileLocal(source)
    local myNode = vm.setNode(source, source)

    local hasMarkDoc
    if source.bindDocs then
        hasMarkDoc = vm.bindDocs(source)
    end
    local hasMarkParam
    if not hasMarkDoc then
        local selfNode = guide.getSelfNode(source)
        if selfNode then
            hasMarkParam = true
            vm.setNode(source, vm.compileNode(selfNode))
            myNode:remove 'function'
        end
    end
    local hasMarkValue
    if (not hasMarkDoc and source.value)
    or (source.value and source.value.type == 'table') then
        hasMarkValue = true
        if source.value.type == 'table' then
            vm.setNode(source, source.value)
        elseif source.value.type ~= 'nil' then
            vm.setNode(source, vm.compileNode(source.value))
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
        local interfaces = plugin.getPluginInterfaces(guide.getUri(source))
        local hasDocArg = false
        if interfaces then
            for _, interface in ipairs(interfaces) do
                if interface.VM then
                    hasDocArg = interface.VM.OnCompileFunctionParam(compileFunctionParam, func, source)
                    if hasDocArg then break end
                end
            end
        end
        if not hasDocArg and not compileFunctionParam(func, source) then
            vm.setNode(source, vm.declareGlobal('type', 'any'))
        end
    end

    -- for x in ... do
    if source.parent.type == 'in' then
        compileForVars(source.parent, source)
        hasMarkDoc = true
    end

    -- for x = ... do
    if source.parent.type == 'loop' then
        if source.parent.loc == source then
            if vm.bindDocs(source) then
                return
            end
            vm.setNode(source, vm.declareGlobal('type', 'integer'))
            hasMarkDoc = true
        end
    end

    if  not hasMarkDoc
    and not hasMarkValue
    and source.ref then
        local firstSet
        local myFunction = guide.getParentFunction(source)
        for _, ref in ipairs(source.ref) do
            if ref.type == 'setlocal' then
                firstSet = ref
                break
            end
            if ref.type == 'getlocal' then
                if guide.getParentFunction(ref) == myFunction then
                    break
                end
            end
        end
        if  firstSet
        and guide.getBlock(firstSet) == guide.getBlock(source) then
            vm.setNode(source, vm.compileNode(firstSet))
        end
    end

    if  source.value
    and source.value.type == 'nil'
    and not myNode:hasKnownType() then
        vm.setNode(source, vm.compileNode(source.value))
    end

    myNode.hasDefined = hasMarkDoc or hasMarkParam or hasMarkValue
end

---@param source parser.object
---@param mfunc  parser.object
---@param index  integer
---@param args   parser.object[]
local function bindReturnOfFunction(source, mfunc, index, args)
    local returnObject = vm.getReturnOfFunction(mfunc, index)
    if not returnObject then
        return
    end
    local returnNode = vm.compileNode(returnObject)
    for rnode in returnNode:eachObject() do
        if rnode.type == 'generic' then
            returnNode = rnode:resolve(guide.getUri(source), args)
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
        if vm.bindAs(source) then
            return
        end
        vm.setNode(source, source)

        if source.parent.type == 'callargs' then
            local call = source.parent.parent
            vm.compileCallArg(source, call)
        end

        if source.parent.type == 'return' then
            local myIndex = util.arrayIndexOf(source.parent, source)
            ---@cast myIndex -?
            local parentNode = vm.selectNode(source.parent, myIndex)
            if not parentNode:isEmpty() then
                vm.setNode(source, parentNode)
                return
            end
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

        local parent = source.parent

        if source.bindDocs then
            for _, doc in ipairs(source.bindDocs) do
                if doc.type == 'doc.overload' then
                    vm.setNode(source, vm.compileNode(doc))
                end
            end
        end

        -- table.sort(string[], function (<?x?>) end)
        if parent.type == 'callargs' then
            local call = parent.parent
            vm.compileCallArg(source, call)
        end

        -- function f() return function (<?x?>) end end
        if parent.type == 'return' then
            for i, ret in ipairs(parent) do
                if ret == source then
                    local func = guide.getParentFunction(parent)
                    if func then
                        local returnObj = vm.getReturnOfFunction(func, i)
                        if returnObj then
                            vm.setNode(source, vm.compileNode(returnObj))
                        end
                    end
                    break
                end
            end
        end

        -- { f = function (<?x?>) end }
        if  guide.isAssign(parent)
        and parent.value == source then
            vm.setNode(source, vm.compileNode(parent))
        end
    end)
    : case 'paren'
    : call(function (source)
        if vm.bindAs(source) then
            return
        end
        if source.exp then
            vm.setNode(source, vm.compileNode(source.exp))
        end
    end)
    : case 'local'
    : case 'self'
    ---@async
    ---@param source parser.object
    : call(function (source)
        compileLocal(source)
    end)
    : case 'setlocal'
    : call(function (source)
        if vm.bindDocs(source) then
            return
        end
        local locNode = vm.compileNode(source.node)
        if not source.value then
            vm.setNode(source, locNode)
            return
        end
        local valueNode = vm.compileNode(source.value)
        vm.setNode(source, valueNode)
        if  locNode.hasDefined
        and guide.isLiteral(source.value) then
            vm.setNode(source, locNode)
            vm.getNode(source):narrow(guide.getUri(source), source.value.type)
        else
            vm.setNode(source, valueNode)
        end
    end)
    : case 'getlocal'
    ---@async
    : call(function (source)
        if vm.bindAs(source) then
            return
        end
        local node = vm.traceNode(source)
        if not node then
            return
        end
        vm.setNode(source, node, true)
    end)
    : case 'setfield'
    : case 'setmethod'
    : case 'setindex'
    : case 'getfield'
    : case 'getmethod'
    : case 'getindex'
    : call(function (source)
        if guide.isGet(source) and vm.bindAs(source) then
            return
        end
        if vm.bindDocs(source) then
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
                    vm.compileByParentNode(source.node, k, function (src)
                        vm.setNode(source, vm.compileNode(src))
                    end)
                end
            end
        else
            ---@cast key string
            vm.compileByParentNode(source.node, key, function (src)
                vm.setNode(source, vm.compileNode(src))
                if src == source and source.value and source.value.type ~= 'nil' then
                    vm.setNode(source, vm.compileNode(source.value))
                end
            end)
        end
    end)
    : case 'setglobal'
    : call(function (source)
        if vm.bindDocs(source) then
            return
        end
        if source.node[1] ~= '_ENV' then
            return
        end
        if not source.value then
            return
        end
        vm.setNode(source, vm.compileNode(source.value))
    end)
    : case 'getglobal'
    : call(function (source)
        if vm.bindAs(source) then
            return
        end
        if source.node[1] ~= '_ENV' then
            return
        end
        local key = guide.getKeyName(source)
        if not key then
            return
        end
        vm.compileByParentNode(source.node, key, function (src)
            vm.setNode(source, vm.compileNode(src))
        end)
    end)
    : case 'tablefield'
    : case 'tableindex'
    : call(function (source)
        local hasMarkDoc
        if source.bindDocs then
            hasMarkDoc = vm.bindDocs(source)
        end

        local key = guide.getKeyName(source)
        if not hasMarkDoc then
            if key then
                vm.compileByParentNode(source.node, key, function (src)
                    if src.type == 'doc.field'
                    or src.type == 'doc.type.field'
                    or src.type == 'doc.type.name'
                    or src.type == 'doc.type.function'
                    then
                        hasMarkDoc = true
                        vm.setNode(source, vm.compileNode(src))
                    end
                end)
            end
        end

        if not hasMarkDoc and source.type == 'tableindex' then
            vm.compileByParentNode(source.node, vm.ANYDOC, function (src)
                if src.type == 'doc.field'
                or src.type == 'doc.type.field' then
                    if vm.isSubType(guide.getUri(source), vm.compileNode(source.index), vm.compileNode(src.field or src.name)) then
                        hasMarkDoc = true
                        vm.setNode(source, vm.compileNode(src))
                    end
                end
            end)
        end

        if source.value then
            if not hasMarkDoc
            or (type(key) == 'string' and util.stringStartWith(key, '__')) then
                vm.setNode(source, vm.compileNode(source.value))
            end
        end

    end)
    : case 'field'
    : case 'method'
    : call(function (source)
        vm.setNode(source, vm.compileNode(source.parent))
    end)
    : case 'tableexp'
    : call(function (source)
        local hasMarkDoc
        vm.compileByParentNode(source.parent, source.tindex, function (src)
            if src.type == 'doc.field'
            or src.type == 'doc.type.field'
            or src.type == 'doc.type.name'
            or src.type == 'doc.type'
            or guide.isLiteral(src) then
                hasMarkDoc = true
                vm.setNode(source, vm.compileNode(src))
            end
        end)
        if not hasMarkDoc then
            vm.setNode(source, vm.compileNode(source.value))
        end
    end)
    : case 'function.return'
    ---@param source parser.object
    : call(function (source)
        local func  = source.parent
        local index = source.returnIndex
        local hasMarkDoc
        if func.bindDocs then
            local sign = vm.getSign(func)
            local lastReturn
            for _, doc in ipairs(func.bindDocs) do
                if doc.type == 'doc.return' then
                    for _, rtn in ipairs(doc.returns) do
                        lastReturn = rtn
                        if rtn.returnIndex == index then
                            hasMarkDoc = true
                            source.comment = doc.comment
                            if rtn.name then
                                source.name = rtn.name[1]
                            end
                            local hasGeneric
                            if sign then
                                guide.eachSourceType(rtn, 'doc.generic.name', function (_src)
                                    hasGeneric = true
                                end)
                            end
                            if hasGeneric then
                                ---@cast sign -?
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
        if vm.bindAs(source) then
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
            if index == 2 then
                local uri = guide.getUri(source)
                local version = config.get(uri, 'Lua.runtime.version')
                if version == 'Lua 5.3'
                or version == 'Lua 5.4' then
                    vm.setNode(source, vm.declareGlobal('type', 'unknown'))
                else
                    vm.setNode(source, vm.declareGlobal('type', 'nil'))
                end
                return
            end
            if index >= 3 then
                vm.setNode(source, vm.declareGlobal('type', 'nil'))
                return
            end
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
        for nd in funcNode:eachObject() do
            if nd.type == 'function'
            or nd.type == 'doc.type.function' then
                ---@cast nd parser.object
                bindReturnOfFunction(source, nd, index, args)
            elseif nd.type == 'global' and nd.cate == 'type' then
                ---@cast nd vm.global
                for _, set in ipairs(nd:getSets(guide.getUri(source))) do
                    if set.type == 'doc.class' then
                        for _, overload in ipairs(set.calls) do
                            bindReturnOfFunction(source, overload.overload, index, args)
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
            if not node:isTyped() then
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
        -- ignore rawset
        if source.node.special == 'rawset' then
            return
        end
        local node = getReturn(source.node, 1, source.args)
        if not node then
            return
        end
        if not node:isTyped() then
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
    : case 'doc.type.name'
    : call(function (source)
        if source[1] == 'self' then
            local state = guide.getDocState(source)
            if state.type == 'doc.return'
            or state.type == 'doc.param' then
                local func = state.bindSource
                if func and func.type == 'function' then
                    local node = guide.getFunctionSelfNode(func)
                    if node then
                        vm.setNode(source, vm.compileNode(node))
                        return
                    end
                end
            elseif state.type == 'doc.field'
            or     state.type == 'doc.overload' then
                local class = state.class
                if class then
                    vm.setNode(source, vm.compileNode(class))
                    return
                end
            end
        end
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
                            if vm.getGeneric(ext) then
                                local resolved = vm.getGeneric(ext):resolve(uri, source.signs)
                                vm.setNode(source, resolved)
                            end
                        end
                    end
                end
            end
            if set.type == 'doc.alias' then
                if vm.getGeneric(set.extends) then
                    local resolved = vm.getGeneric(set.extends):resolve(uri, source.signs)
                    vm.setNode(source, resolved)
                end
            end
        end
    end)
    : case 'doc.class.name'
    : case 'doc.alias.name'
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
    : case 'doc.field.name'
    : call(function (source)
        vm.setNode(source, source)
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
        if vm.bindAs(source) then
            return
        end
        if not source[1] then
            return
        end
        vm.unarySwich(source.op.type, source)
    end)
    : case 'binary'
    : call(function (source)
        if vm.bindAs(source) then
            return
        end
        if not source[1] or not source[2] then
            return
        end
        vm.binarySwitch(source.op.type, source)
    end)
    : case 'globalbase'
    : call(function (source)
        ---@type vm.global
        local global = source.global
        local uri = guide.getUri(source)
        vm.setNode(source, global)
        if global.cate == 'variable' then
            for luri, link in pairs(global.links) do
                local firstSet = link.sets[1]
                if firstSet then
                    local setNode = vm.compileNode(firstSet)
                    vm.setNode(source, setNode)
                    if vm.isMetaFile(luri) then
                        for i = 2, #link.sets do
                            setNode = vm.compileNode(link.sets[i])
                            vm.setNode(source, setNode)
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
                                if not vm.getGeneric(ext) then
                                    vm.setNode(source, vm.compileNode(ext))
                                end
                            end
                        end
                    end
                end
                if set.type == 'doc.alias' then
                    if not vm.getGeneric(set.extends) then
                        vm.setNode(source, vm.compileNode(set.extends))
                    end
                end
            end
        end
    end)
    : case 'variable'
    ---@param variable vm.variable
    : call(function (variable)
        if variable == vm.getVariable(variable.base) then
            vm.setNode(variable, vm.compileNode(variable.base))
            return
        end
    end)
    : case 'global'
    : case 'generic'
    : call(function (source)
        vm.setNode(source, source)
    end)

---@param source parser.object
local function compileByNode(source)
    compilerSwitch(source.type, source)
end

local nodeSwitch;nodeSwitch = util.switch()
    : case 'field'
    : case 'method'
    : call(function (source, lastKey, pushResult)
        return nodeSwitch(source.parent.type, source.parent, lastKey, pushResult)
    end)
    : case 'getfield'
    : case 'setfield'
    : case 'getmethod'
    : case 'setmethod'
    : case 'getindex'
    : case 'setindex'
    : call(function (source, lastKey, pushResult)
        local parentNode = vm.compileNode(source.node)
        local uri = guide.getUri(source)
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        if lastKey then
            key = key .. vm.ID_SPLITE .. lastKey
        end
        for pn in parentNode:eachObject() do
            searchFieldSwitch(pn.type, uri, pn, key, pushResult)
        end
        return key, source.node
    end)
    : case 'tableindex'
    : case 'tablefield'
    : call(function (source, lastKey, pushResult)
        if lastKey then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        local uri = guide.getUri(source)
        local parentNode = vm.compileNode(source.node)
        for pn in parentNode:eachObject() do
            searchFieldSwitch(pn.type, uri, pn, key, pushResult)
        end
    end)

function vm.compileByNodeChain(source, pushResult)
    local lastKey
    local src = source
    while true do
        local key, node = nodeSwitch(src.type, src, lastKey, pushResult)
        if not key then
            break
        end
        src = node
        lastKey = key
    end
end

---@param source vm.object
local function compileByParentNode(source)
    if vm.getNode(source):isTyped() then
        return
    end
    vm.compileByNodeChain(source, function (result)
        vm.setNode(source, vm.compileNode(result))
    end)
end

---@param source vm.node.object | vm.variable
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

    ---@cast source parser.object
    vm.setNode(source, vm.createNode(), true)
    vm.compileByGlobal(source)
    vm.compileByVariable(source)
    compileByNode(source)
    compileByParentNode(source)
    matchCall(source)

    local node = vm.getNode(source)
    ---@cast node -?
    return node
end
