---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'
local config    = require 'config.config'
local util      = require 'utility'
local lang      = require 'language'

---@class vm.ANY
vm.ANY = {'<VM.ANY>'}
---@class vm.ANYDOC
vm.ANYDOC = {'<VM.ANYDOC>'}

---@alias typecheck.err vm.node.object|string|vm.node

---@param object vm.node.object
---@return string?
function vm.getNodeName(object)
    if object.type == 'global' and object.cate == 'type' then
        ---@cast object vm.global
        return object.name
    end
    if object.type == 'nil'
    or object.type == 'boolean'
    or object.type == 'number'
    or object.type == 'string'
    or object.type == 'table'
    or object.type == 'function'
    or object.type == 'integer' then
        return object.type
    end
    if object.type == 'doc.type.boolean' then
        return 'boolean'
    end
    if object.type == 'doc.type.integer' then
        return 'integer'
    end
    if object.type == 'doc.type.function' then
        return 'function'
    end
    if object.type == 'doc.type.table' then
        return 'table'
    end
    if object.type == 'doc.type.array' then
        return 'table'
    end
    if object.type == 'doc.type.string' then
        return 'string'
    end
    if object.type == 'doc.field.name' then
        return 'string'
    end
    return nil
end

---@param parentName string
---@param child      vm.node.object
---@param uri        uri
---@param mark       table
---@param errs?      typecheck.err[]
---@return boolean?
local function checkParentEnum(parentName, child, uri, mark, errs)
    local parentClass = vm.getGlobal('type', parentName)
    if not parentClass then
        return nil
    end
    local enums
    for _, set in ipairs(parentClass:getSets(uri)) do
        if set.type == 'doc.enum' then
            local denums = vm.getEnums(set)
            if denums then
                if enums then
                    enums = util.arrayMerge(enums, denums)
                else
                    enums = util.arrayMerge({}, denums)
                end
            end
        end
    end
    if not enums then
        return nil
    end
    if child.type == 'global' then
        ---@cast child vm.global
        for _, enum in ipairs(enums) do
            if vm.isSubType(uri, child, vm.compileNode(enum), mark) then
                return true
            end
        end
        if errs then
            errs[#errs+1] = 'TYPE_ERROR_ENUM_GLOBAL_DISMATCH'
            errs[#errs+1] = child
            errs[#errs+1] = parentClass
        end
        return false
    elseif child.type == 'generic' then
        ---@cast child vm.generic
        if errs then
            errs[#errs+1] = 'TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED'
            errs[#errs+1] = child
        end
        return false
    else
        ---@cast child parser.object
        local childName = vm.getNodeName(child)
        if childName == 'number'
        or childName == 'integer'
        or childName == 'boolean'
        or childName == 'string' then
            for _, enum in ipairs(enums) do
                for nd in vm.compileNode(enum):eachObject() do
                    if childName == vm.getNodeName(nd) and nd[1] == child[1] then
                        return true
                    end
                end
            end
            if errs then
                errs[#errs+1] = 'TYPE_ERROR_ENUM_LITERAL_DISMATCH'
                errs[#errs+1] = child[1]
                errs[#errs+1] = parentClass
            end
            return false
        elseif childName == 'function'
        or     childName == 'table' then
            for _, enum in ipairs(enums) do
                for nd in vm.compileNode(enum):eachObject() do
                    if child == nd then
                        return true
                    end
                end
            end
            if errs then
                errs[#errs+1] = 'TYPE_ERROR_ENUM_OBJECT_DISMATCH'
                errs[#errs+1] = child
                errs[#errs+1] = parentClass
            end
            return false
        end
        if errs then
            errs[#errs+1] = 'TYPE_ERROR_ENUM_NO_OBJECT'
            errs[#errs+1] = child
        end
        return false
    end
end

---@param childName  string
---@param parent     vm.node.object
---@param uri        uri
---@param mark       table
---@param errs?      typecheck.err[]
---@return boolean?
local function checkChildEnum(childName, parent, uri, mark, errs)
    if mark[childName] then
        return
    end
    local childClass = vm.getGlobal('type', childName)
    if not childClass then
        return nil
    end
    local enums
    for _, set in ipairs(childClass:getSets(uri)) do
        if set.type == 'doc.enum' then
            enums = vm.getEnums(set)
            break
        end
    end
    if not enums then
        return nil
    end
    mark[childName] = true
    for _, enum in ipairs(enums) do
        if not vm.isSubType(uri, vm.compileNode(enum), parent, mark, errs) then
            mark[childName] = nil
            return false
        end
    end
    mark[childName] = nil
    return true
end

---@param parent vm.node.object
---@param child  vm.node.object
---@param mark   table
---@param errs?  typecheck.err[]
---@return boolean
local function checkValue(parent, child, mark, errs)
    if parent.type == 'doc.type.integer' then
        if child.type == 'integer'
        or child.type == 'doc.type.integer'
        or child.type == 'number' then
            if parent[1] ~= child[1] then
                if errs then
                    errs[#errs+1] = 'TYPE_ERROR_INTEGER_DISMATCH'
                    errs[#errs+1] = child[1]
                    errs[#errs+1] = parent[1]
                end
                return false
            end
        end
        return true
    end

    if parent.type == 'doc.type.string'
    or parent.type == 'doc.field.name' then
        if child.type == 'string'
        or child.type == 'doc.type.string'
        or child.type == 'doc.field.name' then
            if parent[1] ~= child[1] then
                if errs then
                    errs[#errs+1] = 'TYPE_ERROR_STRING_DISMATCH'
                    errs[#errs+1] = child[1]
                    errs[#errs+1] = parent[1]
                end
                return false
            end
        end
        return true
    end

    if parent.type == 'doc.type.boolean' then
        if child.type == 'boolean'
        or child.type == 'doc.type.boolean' then
            if parent[1] ~= child[1] then
                if errs then
                    errs[#errs+1] = 'TYPE_ERROR_BOOLEAN_DISMATCH'
                    errs[#errs+1] = child[1]
                    errs[#errs+1] = parent[1]
                end
                return false
            end
        end
        return true
    end

    if parent.type == 'doc.type.table' then
        if child.type == 'doc.type.table' then
            if child == parent then
                return true
            end
            ---@cast parent parser.object
            ---@cast child parser.object
            local uri = guide.getUri(parent)
            local tnode = vm.compileNode(child)
            for _, pfield in ipairs(parent.fields) do
                local knode = vm.compileNode(pfield.name)
                local cvalues = vm.getTableValue(uri, tnode, knode, true)
                if not cvalues then
                    if pfield.optional then
                        goto continue
                    end
                    if errs then
                        errs[#errs+1] = 'TYPE_ERROR_TABLE_NO_FIELD'
                        errs[#errs+1] = pfield.name
                    end
                    return false
                end
                local pvalues = vm.compileNode(pfield.extends)
                if vm.isSubType(uri, cvalues, pvalues, mark, errs) == false then
                    if errs then
                        errs[#errs+1] = 'TYPE_ERROR_TABLE_FIELD_DISMATCH'
                        errs[#errs+1] = pfield.name
                        errs[#errs+1] = cvalues
                        errs[#errs+1] = pvalues
                    end
                    return false
                end
                ::continue::
            end
        end
        return true
    end

    return true
end

---@param name string
---@param suri uri
---@return boolean
local function isAlias(name, suri)
    local global = vm.getGlobal('type', name)
    if not global then
        return false
    end
    for _, set in ipairs(global:getSets(suri)) do
        if set.type == 'doc.alias' then
            return true
        end
    end
    return false
end

local function checkTableShape(parent, child, uri, mark, errs)
    local set = parent:getSets(uri)
    local missedKeys = {}
    local failedCheck
    local myKeys
    for _, def in ipairs(set) do
        if not def.fields or #def.fields == 0 then
            goto continue
        end
        if not myKeys then
            myKeys = {}
            for _, field in ipairs(child) do
                local key = vm.getKeyName(field) or field.tindex
                if key then
                    myKeys[key] = vm.compileNode(field)
                end
            end
        end

        for _, field in ipairs(def.fields) do
            local key = vm.getKeyName(field)
            if not key then
                local fieldnode = vm.compileNode(field.field)[1]
                if fieldnode and fieldnode.type == 'doc.type.integer' then
                    ---@cast fieldnode parser.object
                    key = vm.getKeyName(fieldnode)
                end
            end
            if not key then
                goto continue
            end

            local ok
            local nodeField = vm.compileNode(field)
            if myKeys[key] then
                ok = vm.isSubType(uri, myKeys[key], nodeField, mark, errs)
                if ok == false then
                    if errs then
                        errs[#errs+1] = 'TYPE_ERROR_PARENT_ALL_DISMATCH' -- error display can be greatly improved
                        errs[#errs+1] = myKeys[key]
                        errs[#errs+1] = nodeField
                    end
                    failedCheck = true
                end
            elseif not nodeField:isNullable() then
                if type(key) == "number" then
                    missedKeys[#missedKeys+1] = ('`[%s]`'):format(key)
                else
                    missedKeys[#missedKeys+1] = ('`%s`'):format(key)
                end
                failedCheck = true
            end
        end
        ::continue::
    end
    if errs and #missedKeys > 0 then
        errs[#errs+1] = 'DIAG_MISSING_FIELDS'
        errs[#errs+1] = parent
        errs[#errs+1] = table.concat(missedKeys, ', ')
    end
    if failedCheck then
        return false
    end

    return true
end

---@param uri uri
---@param child  vm.node|string|vm.node.object
---@param parent vm.node|string|vm.node.object
---@param mark?  table
---@param errs? typecheck.err[]
---@return boolean|nil
function vm.isSubType(uri, child, parent, mark, errs)
    mark = mark or {}

    if type(child) == 'string' then
        local global = vm.getGlobal('type', child)
        if not global then
            return nil
        end
        child = global
    elseif child.type == 'vm.node' then
        if config.get(uri, 'Lua.type.weakUnionCheck') then
            local hasKnownType = 0
            local i = 0
            for n in child:eachObject() do
                i = i + 1
                if i > 100 then
                    break
                end
                if vm.getNodeName(n) then
                    local res = vm.isSubType(uri, n, parent, mark, errs)
                    if res == true then
                        return true
                    elseif res == false then
                        hasKnownType = hasKnownType + 1
                    end
                end
            end
            if hasKnownType > 0 then
                if  errs
                and hasKnownType > 1
                and #vm.getInfer(child):getSubViews(uri) > 1 then
                    errs[#errs+1] = 'TYPE_ERROR_CHILD_ALL_DISMATCH'
                    errs[#errs+1] = child
                    errs[#errs+1] = parent
                end
                return false
            end
            return true
        else
            local weakNil = config.get(uri, 'Lua.type.weakNilCheck')
            local skipTable
            local i = 0
            for n in child:eachObject() do
                i = i + 1
                if i > 100 then
                    break
                end
                if skipTable == nil and n.type == "table" and parent.type == "vm.node" then -- skip table type check if child has class
                    ---@cast parent vm.node
                    for _, c in ipairs(child) do
                        if c.type == 'global' and c.cate == 'type' then
                            for _, set in ipairs(c:getSets(uri)) do
                                if set.type == 'doc.class' then
                                    skipTable = true
                                    break
                                end
                            end
                        end
                        if skipTable then
                            break
                        end
                    end
                    if not skipTable then
                        skipTable = false
                    end
                end
                local nodeName = vm.getNodeName(n)
                if  nodeName
                and not (nodeName == 'nil' and weakNil) and not (skipTable and n.type == 'table')
                and vm.isSubType(uri, n, parent, mark, errs) == false then
                    if errs then
                        errs[#errs+1] = 'TYPE_ERROR_UNION_DISMATCH'
                        errs[#errs+1] = n
                        errs[#errs+1] = parent
                    end
                    return false
                end
            end
            if not weakNil and child:isOptional() then
                if vm.isSubType(uri, 'nil', parent, mark, errs) == false then
                    if errs then
                        errs[#errs+1] = 'TYPE_ERROR_OPTIONAL_DISMATCH'
                        errs[#errs+1] = parent
                    end
                    return false
                end
            end
            return true
        end
    end

    ---@cast child  vm.node.object
    local childName = vm.getNodeName(child)
    if childName == 'any'
    or childName == 'unknown' then
        return true
    end

    if not childName
    or isAlias(childName, uri) then
        return nil
    end

    if type(parent) == 'string' then
        local global = vm.getGlobal('type', parent)
        if not global then
            return false
        end
        parent = global
    elseif parent.type == 'vm.node' then
        local hasKnownType = 0
        local i = 0
        for n in parent:eachObject() do
            i = i + 1
            if i > 100 then
                break
            end
            if vm.getNodeName(n) then
                local res = vm.isSubType(uri, child, n, mark, errs)
                if res == true then
                    return true
                elseif res == false then
                    hasKnownType = hasKnownType + 1
                end
            end
            if n.type == 'doc.generic.name' then
                return true
            end
        end
        if parent:isOptional() then
            if vm.isSubType(uri, child, 'nil', mark, errs) == true then
                return true
            end
        end
        if hasKnownType > 0 then
            if  errs
            and hasKnownType > 1
            and #vm.getInfer(parent):getSubViews(uri) > 1 then
                errs[#errs+1] = 'TYPE_ERROR_PARENT_ALL_DISMATCH'
                errs[#errs+1] = child
                errs[#errs+1] = parent
            end
            return false
        end
        return true
    end

    ---@cast parent vm.node.object

    local parentName = vm.getNodeName(parent)
    if parentName == 'any'
    or parentName == 'unknown' then
        return true
    end

    if not parentName
    or isAlias(parentName, uri) then
        return nil
    end

    if childName == parentName then
        if not checkValue(parent, child, mark, errs) then
            return false
        end
        return true
    end

    if parentName == 'number' and childName == 'integer' then
        return true
    end

    if parentName == 'integer' and childName == 'number' then
        if config.get(uri, 'Lua.type.castNumberToInteger') then
            return true
        end
        if  child.type == 'number'
        and child[1]
        and not math.tointeger(child[1]) then
            if errs then
                errs[#errs+1] = 'TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER'
                errs[#errs+1] = child[1]
            end
            return false
        end
        if  child.type == 'global'
        and child.cate == 'type' then
            if errs then
                errs[#errs+1] = 'TYPE_ERROR_NUMBER_TYPE_TO_INTEGER'
            end
            return false
        end
        return true
    end

    local result = checkParentEnum(parentName, child, uri, mark, errs)
    if result ~= nil then
        return result
    end

    result = checkChildEnum(childName, parent, uri, mark, errs)
    if result ~= nil then
        return result
    end

    if parentName == 'table' and not guide.isBasicType(childName) then
        return true
    end
    if childName == 'table' and not guide.isBasicType(parentName) then
        if config.get(uri, 'Lua.type.checkTableShape') then
            return checkTableShape(parent, child, uri, mark, errs)
        else
            return true
        end
    end

    -- check class parent
    if childName and not mark[childName] then
        mark[childName] = true
        local isBasicType = guide.isBasicType(childName)
        local childClass = vm.getGlobal('type', childName)
        if childClass then
            for _, set in ipairs(childClass:getSets(uri)) do
                if set.type == 'doc.class' and set.extends then
                    for _, ext in ipairs(set.extends) do
                        if  ext.type == 'doc.extends.name'
                        and (not isBasicType or guide.isBasicType(ext[1]))
                        and vm.isSubType(uri, ext[1], parent, mark, errs) == true then
                            mark[childName] = nil
                            return true
                        end
                    end
                end
            end
        end
        mark[childName] = nil
    end

    --[[
    ---@class A: string

    ---@type A
    local x = '' --> `string` set to `A`
    ]]
    if  guide.isBasicType(childName)
    and not mark[childName] then
        mark[childName] = true
        if vm.isSubType(uri, parentName, childName, mark) then
            mark[childName] = nil
            return true
        end
        mark[childName] = nil
    end

    if errs then
        errs[#errs+1] = 'TYPE_ERROR_DISMATCH'
        errs[#errs+1] = child
        errs[#errs+1] = parent
    end
    return false
end

---@param node string|vm.node|vm.object
function vm.isUnknown(node)
    if type(node) == 'string' then
        return node == 'unknown'
    end
    if node.type == 'vm.node' then
        return not node:hasKnownType()
    end
    return false
end

---@param uri uri
---@param tnode vm.node
---@param knode vm.node|string
---@param inversion? boolean
---@return vm.node?
function vm.getTableValue(uri, tnode, knode, inversion)
    local result = vm.createNode()
    local inferSize = config.get(uri, "Lua.type.inferTableSize")
    for tn in tnode:eachObject() do
        if tn.type == 'doc.type.table' then
            for _, field in ipairs(tn.fields) do
                if field.extends then
                    if inversion then
                        if vm.isSubType(uri, vm.compileNode(field.name), knode) then
                            result:merge(vm.compileNode(field.extends))
                        end
                    else
                        if vm.isSubType(uri, knode, vm.compileNode(field.name)) then
                            result:merge(vm.compileNode(field.extends))
                        end
                    end
                end
            end
        end
        if tn.type == 'doc.type.array' then
            result:merge(vm.compileNode(tn.node))
        end
        if tn.type == 'table' then
            if vm.isUnknown(knode) then
                goto CONTINUE
            end
            for _, field in ipairs(tn) do
                if  field.type == 'tableindex'
                and field.value then
                    result:merge(vm.compileNode(field.value))
                end
                if  field.type == 'tablefield'
                and field.value then
                    if inversion then
                        if vm.isSubType(uri, 'string', knode) then
                            result:merge(vm.compileNode(field.value))
                        end
                    else
                        if vm.isSubType(uri, knode, 'string') then
                            result:merge(vm.compileNode(field.value))
                        end
                    end
                end
                if  field.type == 'tableexp'
                and field.value
                and field.tindex <= inferSize then
                    if inversion then
                        if vm.isSubType(uri, 'integer', knode) then
                            result:merge(vm.compileNode(field.value))
                        end
                    else
                        if vm.isSubType(uri, knode, 'integer') then
                            result:merge(vm.compileNode(field.value))
                        end
                    end
                end
                if field.type == 'varargs' then
                    result:merge(vm.compileNode(field))
                end
            end
        end
        ::CONTINUE::
    end
    if result:isEmpty() then
        return nil
    end
    return result
end

---@param uri uri
---@param tnode vm.node
---@param vnode vm.node|string|vm.object
---@param reverse? boolean
---@return vm.node?
function vm.getTableKey(uri, tnode, vnode, reverse)
    local result = vm.createNode()
    for tn in tnode:eachObject() do
        if tn.type == 'doc.type.table' then
            for _, field in ipairs(tn.fields) do
                if  field.name.type ~= 'doc.field.name'
                and field.extends then
                    if reverse then
                        if vm.isSubType(uri, vm.compileNode(field.extends), vnode) then
                            result:merge(vm.compileNode(field.name))
                        end
                    else
                        if vm.isSubType(uri, vnode, vm.compileNode(field.extends)) then
                            result:merge(vm.compileNode(field.name))
                        end
                    end
                end
            end
        end
        if tn.type == 'doc.type.array' then
            result:merge(vm.declareGlobal('type', 'integer'))
        end
        if tn.type == 'table' then
            if vm.isUnknown(tnode) then
                goto CONTINUE
            end
            for _, field in ipairs(tn) do
                if field.type == 'tableindex' then
                    if field.index then
                        result:merge(vm.compileNode(field.index))
                    end
                end
                if field.type == 'tablefield' then
                    result:merge(vm.declareGlobal('type', 'string'))
                end
                if field.type == 'tableexp' or field.type == 'varargs' then
                    result:merge(vm.declareGlobal('type', 'integer'))
                end
            end
        end
        ::CONTINUE::
    end
    if result:isEmpty() then
        return nil
    end
    return result
end

---@param uri uri
---@param defNode vm.node
---@param refNode vm.node
---@param errs typecheck.err[]?
---@return boolean
function vm.canCastType(uri, defNode, refNode, errs)
    local defInfer = vm.getInfer(defNode)
    local refInfer = vm.getInfer(refNode)

    if defInfer:hasAny(uri) then
        return true
    end
    if refInfer:hasAny(uri) then
        return true
    end
    if defInfer:view(uri) == 'unknown' then
        return true
    end
    if refInfer:view(uri) == 'unknown' then
        return true
    end
    if defInfer:view(uri) == 'nil' then
        return true
    end

    if vm.isSubType(uri, refNode, 'nil') then
        -- allow `local x = {};x = nil`,
        -- but not allow `local x ---@type table;x = nil`
        if  defInfer:hasType(uri, 'table')
        and not defNode:hasType 'table' then
            return true
        end
    end

    if vm.isSubType(uri, refNode, 'number') then
        -- allow `local x = 0;x = 1.0`,
        -- but not allow `local x ---@type integer;x = 1.0`
        if  defInfer:hasType(uri, 'integer')
        and not defNode:hasType 'integer' then
            return true
        end
    end

    if vm.isSubType(uri, refNode, defNode, {}, errs) then
        return true
    end


    return false
end

local ErrorMessageMap = {
    TYPE_ERROR_ENUM_GLOBAL_DISMATCH       = {'child', 'parent'},
    TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED   = {'child'},
    TYPE_ERROR_ENUM_LITERAL_DISMATCH      = {'child', 'parent'},
    TYPE_ERROR_ENUM_OBJECT_DISMATCH       = {'child', 'parent'},
    TYPE_ERROR_ENUM_NO_OBJECT             = {'child'},
    TYPE_ERROR_INTEGER_DISMATCH           = {'child', 'parent'},
    TYPE_ERROR_STRING_DISMATCH            = {'child', 'parent'},
    TYPE_ERROR_BOOLEAN_DISMATCH           = {'child', 'parent'},
    TYPE_ERROR_TABLE_NO_FIELD             = {'key'},
    TYPE_ERROR_TABLE_FIELD_DISMATCH       = {'key', 'child', 'parent'},
    TYPE_ERROR_CHILD_ALL_DISMATCH         = {'child', 'parent'},
    TYPE_ERROR_PARENT_ALL_DISMATCH        = {'child', 'parent'},
    TYPE_ERROR_UNION_DISMATCH             = {'child', 'parent'},
    TYPE_ERROR_OPTIONAL_DISMATCH          = {'parent'},
    TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER  = {'child'},
    TYPE_ERROR_NUMBER_TYPE_TO_INTEGER     = {},
    TYPE_ERROR_DISMATCH                   = {'child', 'parent'},
    DIAG_MISSING_FIELDS                   = {"1", "2"},
}

---@param uri uri
---@param errs typecheck.err[]
---@return string
function vm.viewTypeErrorMessage(uri, errs)
    local lines = {}
    local mark  = {}
    local index = 1
    while true do
        local name = errs[index]
        if not name then
            break
        end
        index = index + 1
        local params = ErrorMessageMap[name]
        local lparams = {}
        for _, paramName in ipairs(params) do
            local value = errs[index]
            if type(value) == 'string'
            or type(value) == 'number'
            or type(value) == 'boolean' then
                lparams[paramName] = util.viewLiteral(value)
            elseif value.type == 'global' then
                lparams[paramName] = value.name
            elseif value.type == 'vm.node' then
                ---@cast value vm.node
                lparams[paramName] = vm.getInfer(value):view(uri)
            elseif value.type == 'table' then
                lparams[paramName] = 'table'
            elseif value.type == 'generic' then
                ---@cast value vm.generic
                lparams[paramName] = vm.getInfer(value):view(uri)
            elseif value.type == 'variable' then
            else
                ---@cast value -string, -vm.global, -vm.node, -vm.generic, -vm.variable
                if paramName == 'key' then
                    lparams[paramName] = vm.viewKey(value, uri)
                else
                    lparams[paramName] = vm.getInfer(value):view(uri)
                                      or vm.getInfer(value):view(uri)
                end
            end
            index = index + 1
        end
        local line = lang.script(name, lparams)
        if not mark[line] then
            mark[line] = true
            lines[#lines+1] = '- ' .. line
        end
    end
    util.revertArray(lines)
    if #lines > 15 then
        lines[13] = ('...(+%d)'):format(#lines - 15)
        table.move(lines, #lines - 2, #lines, 14)
        return table.concat(lines, '\n', 1, 16)
    else
        return table.concat(lines, '\n')
    end
end

---@param name string
---@param uri uri
---@return parser.object[]?
function vm.getOverloadsByTypeName(name, uri)
    local global = vm.getGlobal('type', name)
    if not global then
        return nil
    end
    local results
    for _, set in ipairs(global:getSets(uri)) do
        for _, doc in ipairs(set.bindGroup) do
            if doc.type == 'doc.overload' then
                if not results then
                    results = {}
                end
                results[#results+1] = doc.overload
            end
        end
    end
    return results
end
