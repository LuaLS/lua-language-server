local guide         = require 'parser.guide'
---@class vm
local vm            = require 'vm.vm'

--- Find a generic name referenced in a doc.type.table's fields
--- that exists in the given genericMap.
---@param tableType parser.object  doc.type.table with fields
---@param genericMap table<string, vm.node>
---@return string?  The matching generic key name
local function findGenericInTableFields(tableType, genericMap)
    for _, field in ipairs(tableType.fields) do
        if field.extends then
            local found
            guide.eachSourceType(field.extends, 'doc.generic.name', function (src)
                if genericMap[src[1]] then
                    found = src[1]
                end
            end)
            if found then
                return found
            end
        end
    end
    return nil
end

--- Search for a generic name in extends tables of a class definition.
--- For classes like `@class list<T>: {[integer]:T}`, the [integer] field
--- lives in the extends doc.type.table, not in @field annotations.
---@param uri uri
---@param classGlobal vm.global
---@param genericMap table<string, vm.node>
---@return string?  The class generic name that maps to the integer field
local function findGenericInExtendsTable(uri, classGlobal, genericMap)
    for _, set in ipairs(classGlobal:getSets(uri)) do
        if set.type ~= 'doc.class' or not set.extends then
            goto CONTINUE
        end
        for _, ext in ipairs(set.extends) do
            if ext.type == 'doc.type.table' and ext.fields then
                local key = findGenericInTableFields(ext, genericMap)
                if key then
                    return key
                end
            end
        end
        ::CONTINUE::
    end
    return nil
end

---@class vm.sign
---@field parent    parser.object
---@field signList  vm.node[]
---@field docGeneric parser.object[]
local mt = {}
mt.__index = mt
mt.type = 'sign'

---@param node vm.node
function mt:addSign(node)
    self.signList[#self.signList+1] = node
end

---@param doc parser.object
function mt:addDocGeneric(doc)
    self.docGeneric[#self.docGeneric+1] = doc
end

---@param uri uri
---@param args parser.object
---@return table<string, vm.node>?
function mt:resolve(uri, args)
    if not args then
        return nil
    end

    ---@type table<string, vm.node>
    local resolved = {}
    ---@type table<string, boolean>
    local visited = {}

    ---@param object vm.node|vm.node.object
    ---@param node   vm.node
    local function resolve(object, node)
        local visitedHash = ("%s|%s"):format(object, node)
        if visited[visitedHash] then
            return -- prevent circular resolve calls by only visiting each pair once
        end
        visited[visitedHash] = true
        if object.type == 'vm.node' then
            for o in object:eachObject() do
                resolve(o, node)
            end
            return
        end
        if object.type == 'doc.type' then
            ---@cast object parser.object
            resolve(vm.compileNode(object), node)
            return
        end
        if object.type == 'doc.generic.name' then
            ---@type string
            local key = object[1]
            if object.literal then
                -- 'number' -> `T`
                for n in node:eachObject() do
                    local typeName = nil
                    local typeUri = nil
                    if n.type == 'string' then
                        typeName = n[1]
                        typeUri = guide.getUri(n)
                    elseif n.type == "global" and n.cate == "type" then
                        typeName = n:getName()
                    elseif (n.type == "function" or n.type == "doc.type.function")
                        and #n.returns > 0 then
                        ---@cast n parser.object
                        local fret = vm.getReturnOfFunction(n, 1)
                        if fret then
                            local compiled = vm.compileNode(fret)
                            local r1 = compiled and compiled[1]
                            if r1 and r1.cate == "type" then
                                typeName = r1:getName()
                            end
						end
                    end
                    if typeName ~= nil then
                        ---@cast n parser.object
                        local type = vm.declareGlobal('type',
                            object.pattern and object.pattern:format(typeName) or typeName, typeUri)
                        resolved[key] = vm.createNode(type, resolved[key])
                    end
                end
            else
                -- number -> T
                for n in node:eachObject() do
                    if  n.type ~= 'doc.generic.name'
                    and n.type ~= 'generic' then
                        if resolved[key] then
                            resolved[key]:merge(n)
                        else
                            resolved[key] = vm.createNode(n)
                        end
                    end
                end
                if resolved[key] and node:isOptional() then
                    resolved[key]:addOptional()
                end
            end
            return
        end
        if object.type == 'doc.type.array' then
            -- If the argument contains a doc.type.sign (generic class like
            -- list<T> extending { [integer]: V }), resolve element type
            -- exclusively through class generic map. This directly maps
            -- the array element generic (V) to the sign parameter, even
            -- when it's another generic name (T inside a method body).
            local handled = false
            for n in node:eachObject() do
                if n.type == 'doc.type.sign' and n.signs and n.node and n.node[1] then
                    local classGlobal = vm.getGlobal('type', n.node[1])
                    if classGlobal then
                        local genericMap = vm.getClassGenericMap(uri, classGlobal, n.signs)
                        if genericMap and object.node and object.node.type == 'doc.generic.name' then
                            -- V[] matching list<T>: look up [integer] field,
                            -- find which class generic it references, then
                            -- map V directly to the sign's concrete parameter
                            local vKey = object.node[1]
                            -- First try @field annotations
                            vm.getClassFields(uri, classGlobal, vm.declareGlobal('type', 'integer'), function (field)
                                if field.extends then
                                    guide.eachSourceType(field.extends, 'doc.generic.name', function (src)
                                        if genericMap[src[1]] then
                                            resolved[vKey] = genericMap[src[1]]
                                            handled = true
                                        end
                                    end)
                                end
                            end)
                            -- Also search extends tables (for @class list<T>: {[integer]:T})
                            if not handled then
                                local genericKey = findGenericInExtendsTable(uri, classGlobal, genericMap)
                                if genericKey then
                                    resolved[vKey] = genericMap[genericKey]
                                    handled = true
                                end
                            end
                        end
                    end
                    if handled then break end
                end
            end
            if not handled then
                for n in node:eachObject() do
                    if n.type == 'doc.type.array' then
                        -- number[] -> T[]
                        resolve(object.node, vm.compileNode(n.node))
                    elseif n.type == 'doc.type.table' then
                        -- { [integer]: number } -> T[]
                        local tvalueNode = vm.getTableValue(uri, node, 'integer', true)
                        if tvalueNode then
                            resolve(object.node, tvalueNode)
                        end
                    elseif n.type == 'global' and n.cate == 'type' then
                        -- ---@field [integer]: number -> T[]
                        ---@cast n vm.global
                        vm.getClassFields(uri, n, vm.declareGlobal('type', 'integer'), function (field)
                            resolve(object.node, vm.compileNode(field.extends))
                        end)
                    elseif n.type == 'table' and #n >= 1 then
                        -- { x } / { ... } -> T[]
                        resolve(object.node, vm.compileNode(n[1]))
                    end
                end
            end
            return
        end
        if object.type == 'doc.type.table' then
            ---@cast object parser.object
            for _, ufield in ipairs(object.fields) do
                local ufieldNode = vm.compileNode(ufield.name)
                local uvalueNode = vm.compileNode(ufield.extends)
                local firstField = ufieldNode:get(1)
                local firstValue = uvalueNode:get(1)
                if not firstField or not firstValue then
                    goto CONTINUE
                end
                if firstField.type == 'doc.generic.name' and firstValue.type == 'doc.generic.name' then
                    -- { [number]: number} -> { [K]: V }
                    local tfieldNode = vm.getTableKey(uri, node, 'any', true)
                    local tvalueNode = vm.getTableValue(uri, node, 'any', true)
                    if tfieldNode then
                        resolve(firstField, tfieldNode)
                    end
                    if tvalueNode then
                        resolve(firstValue, tvalueNode)
                    end
                else
                    if ufieldNode:get(1).type == 'doc.generic.name' then
                        -- { [number]: number}|number[] -> { [K]: number }
                        local tnode = vm.getTableKey(uri, node, uvalueNode, true)
                        if tnode then
                            resolve(firstField, tnode)
                        end
                    elseif uvalueNode:get(1).type == 'doc.generic.name' then
                        -- { [number]: number}|number[] -> { [number]: V }
                        local tnode = vm.getTableValue(uri, node, ufieldNode, true)
                        if tnode then
                            resolve(firstValue, tnode)
                        end
                    end
                end
                ::CONTINUE::
            end
            return
        end
        if object.type == 'doc.type.function' then
            for i, arg in ipairs(object.args) do
                if arg.extends then
                    for n in node:eachObject() do
                        if n.type == 'function'
                        or n.type == 'doc.type.function' then
                            ---@cast n parser.object
                            local farg = n.args and n.args[i]
                            if farg then
                                resolve(arg.extends, vm.compileNode(farg))
                            end
                        end
                    end
                end
            end
            for i, ret in ipairs(object.returns) do
                for n in node:eachObject() do
                    if n.type == 'function'
                    or n.type == 'doc.type.function' then
                        ---@cast n parser.object
                        local fret = vm.getReturnOfFunction(n, i)
                        if fret then
                            resolve(ret, vm.compileNode(fret))
                        end
                    end
                end
            end
            return
        end
        if object.type == 'doc.type.sign' and object.signs then
            -- list<T> -> list<string>: match sign parameters positionally
            for n in node:eachObject() do
                if  n.type == 'doc.type.sign' and n.signs
                and n.node and object.node
                and n.node[1] == object.node[1] then
                    for i, signParam in ipairs(object.signs) do
                        if n.signs[i] then
                            resolve(vm.compileNode(signParam), vm.compileNode(n.signs[i]))
                        end
                    end
                end
            end
            return
        end
    end

    ---@param sign vm.node
    ---@return table<string, true>
    ---@return table<string, true>
    local function getSignInfo(sign)
        local knownTypes = {}
        local genericsNames   = {}
        for obj in sign:eachObject() do
            if obj.type == 'doc.generic.name' then
                genericsNames[obj[1]] = true
                goto CONTINUE
            end
            if obj.type == 'doc.type.table'
            or obj.type == 'doc.type.function'
            or obj.type == 'doc.type.array'
            or obj.type == 'doc.type.sign' then
                ---@cast obj parser.object
                local hasGeneric
                guide.eachSourceType(obj, 'doc.generic.name', function (src)
                    hasGeneric = true
                    genericsNames[src[1]] = true
                end)
                if hasGeneric then
                    goto CONTINUE
                end
            end
            if obj.type == 'variable'
            or obj.type == 'local'
            or obj.type == 'self' then
                goto CONTINUE
            end
            local view = vm.getInfer(obj):view(uri)
            if view then
                knownTypes[view] = true
            end
            ::CONTINUE::
        end
        return knownTypes, genericsNames
    end

    -- remove un-generic type
    ---@param argNode vm.node
    ---@param sign vm.node
    ---@param knownTypes table<string, true>
    ---@return vm.node
    local function buildArgNode(argNode, sign, knownTypes)
        local newArgNode = vm.createNode()
        local needRemoveNil = sign:hasFalsy()
        for n in argNode:eachObject() do
            if needRemoveNil then
                if n.type == 'nil' then
                    goto CONTINUE
                end
                if n.type == 'global' and n.cate == 'type' and n.name == 'nil' then
                    goto CONTINUE
                end
            end
            local view = vm.getInfer(n):view(uri)
            if knownTypes[view] then
                goto CONTINUE
            end
            newArgNode:merge(n)
            ::CONTINUE::
        end
        if not needRemoveNil and argNode:isOptional() then
            newArgNode:addOptional()
        end
        return newArgNode
    end

    ---@param genericNames table<string, true>
    local function isAllResolved(genericNames)
        for n in pairs(genericNames) do
            if not resolved[n] then
                return false
            end
        end
        return true
    end

    for i, arg in ipairs(args) do
        local sign = self.signList[i]
        if not sign then
            break
        end
        local argNode = vm.compileNode(arg)
        local knownTypes, genericNames = getSignInfo(sign)
        if not isAllResolved(genericNames) then
            local newArgNode = buildArgNode(argNode, sign, knownTypes)
            resolve(sign, newArgNode)
        end
    end

    return resolved
end

---@return vm.sign
function vm.createSign()
    local genericMgr = setmetatable({
        signList  = {},
        docGeneric = {},
    }, mt)
    return genericMgr
end

---@class parser.object
---@field package _sign vm.sign|false|nil

---@param source parser.object
---@param sign vm.sign
function vm.setSign(source, sign)
    source._sign = sign
end

---@param source parser.object
---@return vm.sign?
function vm.getSign(source)
    if source._sign ~= nil then
        return source._sign or nil
    end
    source._sign = false
    if source.type == 'function' then
        if not source.bindDocs then
            return nil
        end
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == 'doc.generic' then
                if not source._sign then
                    source._sign = vm.createSign()
                end
                source._sign:addDocGeneric(doc)
            end
        end
        if not source._sign then
            return nil
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
        guide.eachSourceType(source, 'doc.generic.name', function (_)
            hasGeneric = true
        end)
        if not hasGeneric then
            return nil
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
    return source._sign or nil
end
