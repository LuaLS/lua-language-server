local util  = require 'utility'
local guide = require 'parser.guide'
---@class vm
local vm    = require 'vm.vm'

---@class vm.variable
---@field root parser.object
---@field id string
---@field base parser.object
---@field sets parser.object[]
---@field gets parser.object[]
local mt = {}
mt.__index = mt
mt.type = 'vm.variable'

---@param id string
---@return vm.variable
local function createVariable(root, id)
    local variable = setmetatable({
        root = root,
        id   = id,
        sets = {},
        gets = {},
    }, mt)
    return variable
end

---@class parser.object
---@field package _variableNode vm.variable|false
---@field package _variableNodes table<string, vm.variable>

local compileVariables, getLoc

---@param id string
---@param source parser.object
---@return vm.variable
local function insertVariableID(id, source)
    local root = guide.getRoot(source)
    if not root._variableNodes then
        root._variableNodes = util.multiTable(2, function (lid)
            local variable = createVariable(root, lid)
            if source.type == 'local'
            or source.type == 'self' then
                variable.base = source
            end
            return variable
        end)
    end
    local variable = root._variableNodes[id]
    if guide.isAssign(source) then
        variable.sets[#variable.sets+1] = source
    else
        variable.gets[#variable.gets+1] = source
    end
    return variable
end

local compileSwitch = util.switch()
    : case 'local'
    : case 'self'
    : call(function (source)
        local id = ('%d'):format(source.start)
        local variable = insertVariableID(id, source)
        source._variableNode = variable
        if not source.ref then
            return
        end
        for _, ref in ipairs(source.ref) do
            compileVariables(ref)
        end
    end)
    : case 'setlocal'
    : case 'getlocal'
    : call(function (source)
        local id = ('%d'):format(source.node.start)
        local variable = insertVariableID(id, source)
        source._variableNode = variable
        compileVariables(source.next)
    end)
    : case 'getfield'
    : case 'setfield'
    : call(function (source)
        local parentNode = source.node._variableNode
        if not parentNode then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        local id = parentNode.id .. vm.ID_SPLITE .. key
        local variable = insertVariableID(id, source)
        source._variableNode = variable
        source.field._variableNode = variable
        if source.type == 'getfield' then
            compileVariables(source.next)
        end
    end)
    : case 'getmethod'
    : case 'setmethod'
    : call(function (source)
        local parentNode = source.node._variableNode
        if not parentNode then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        local id = parentNode.id .. vm.ID_SPLITE .. key
        local variable = insertVariableID(id, source)
        source._variableNode = variable
        source.method._variableNode = variable
        if source.type == 'getmethod' then
            compileVariables(source.next)
        end
    end)
    : case 'getindex'
    : case 'setindex'
    : call(function (source)
        local parentNode = source.node._variableNode
        if not parentNode then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        local id = parentNode.id .. vm.ID_SPLITE .. key
        local variable = insertVariableID(id, source)
        source._variableNode = variable
        source.index._variableNode = variable
        if source.type == 'setindex' then
            compileVariables(source.next)
        end
    end)

local leftSwitch = util.switch()
    : case 'field'
    : case 'method'
    : call(function (source)
        return getLoc(source.parent)
    end)
    : case 'getfield'
    : case 'setfield'
    : case 'getmethod'
    : case 'setmethod'
    : case 'getindex'
    : case 'setindex'
    : call(function (source)
        return getLoc(source.node)
    end)
    : case 'getlocal'
    : call(function (source)
        return source.node
    end)
    : case 'local'
    : case 'self'
    : call(function (source)
        return source
    end)

---@param source parser.object
---@return parser.object?
function getLoc(source)
    return leftSwitch(source.type, source)
end

---@return parser.object
function mt:getBase()
    return self.base
end

---@return string
function mt:getCodeName()
    local name = self.id:gsub(vm.ID_SPLITE, '.'):gsub('^%d+', self.base[1])
    return name
end

function compileVariables(source)
    if not source then
        return
    end
    source._variableNode = false
    if not compileSwitch:has(source.type) then
        return
    end
    compileSwitch(source.type, source)
end

---@param source parser.object
---@return string?
function vm.getVariableID(source)
    local variable = vm.getVariableNode(source)
    if not variable then
        return nil
    end
    return variable.id
end

---@param source parser.object
---@param key?   string
---@return vm.variable?
function vm.getVariable(source, key)
    local variable = vm.getVariableNode(source)
    if not variable then
        return nil
    end
    if not key then
        return variable
    end
    if type(key) ~= 'string' then
        return nil
    end
    local root = guide.getRoot(source)
    if not root._variableNodes then
        return nil
    end
    local id = variable.id .. vm.ID_SPLITE .. key
    return root._variableNodes[id]
end

---@param source parser.object
---@return vm.variable?
function vm.getVariableNode(source)
    local variable = source._variableNode
    if variable ~= nil then
        return variable or nil
    end

    source._variableNode = false
    local loc = getLoc(source)
    if not loc then
        return nil
    end
    compileVariables(loc)
    return source._variableNode or nil
end

---@param source parser.object
---@param name   string
---@return vm.variable?
function vm.getVariableInfoByCodeName(source, name)
    local id = vm.getVariableID(source)
    if not id then
        return nil
    end
    local root = guide.getRoot(source)
    if not root._variableNodes then
        return nil
    end
    local headPos = name:find('.', 1, true)
    if not headPos then
        return root._variableNodes[id]
    end
    local vid = id .. name:sub(headPos):gsub('%.', vm.ID_SPLITE)
    return root._variableNodes[vid]
end

---@param source parser.object
---@param key?   string
---@return parser.object[]?
function vm.getVariableSets(source, key)
    local variable = vm.getVariable(source, key)
    if not variable then
        return nil
    end
    return variable.sets
end

---@param source parser.object
---@param key?   string
---@return parser.object[]?
function vm.getVariableGets(source, key)
    local variable = vm.getVariable(source, key)
    if not variable then
        return nil
    end
    return variable.gets
end

---@param source parser.object
---@param includeGets boolean
---@return parser.object[]?
function vm.getVariableFields(source, includeGets)
    local id = vm.getVariableID(source)
    if not id then
        return nil
    end
    local root = guide.getRoot(source)
    if not root._variableNodes then
        return nil
    end
    -- TODO：optimize
    local clock = os.clock()
    local fields = {}
    for lid, variable in pairs(root._variableNodes) do
        if  lid ~= id
        and util.stringStartWith(lid, id)
        and lid:sub(#id + 1, #id + 1) == vm.ID_SPLITE
        -- only one field
        and not lid:find(vm.ID_SPLITE, #id + 2) then
            for _, src in ipairs(variable.sets) do
                fields[#fields+1] = src
            end
            if includeGets then
                for _, src in ipairs(variable.gets) do
                    fields[#fields+1] = src
                end
            end
        end
    end
    local cost = os.clock() - clock
    if cost > 1.0 then
        log.warn('variable-id getFields takes %.3f seconds', cost)
    end
    return fields
end

---@param source parser.object
local function compileSelf(source)
    if source.parent.type ~= 'funcargs' then
        return
    end
    ---@type parser.object
    local node = source.parent.parent and source.parent.parent.parent and source.parent.parent.parent.node
    if not node then
        return
    end
    local fields = vm.getVariableFields(source, false)
    if not fields then
        return
    end
    local nodeLocalID = vm.getVariableID(node)
    local globalNode  = vm.getGlobalNode(node)
    if not nodeLocalID and not globalNode then
        return
    end
    for _, field in ipairs(fields) do
        if field.type == 'setfield' then
            local key = guide.getKeyName(field)
            if key then
                if nodeLocalID then
                    local myID = nodeLocalID .. vm.ID_SPLITE .. key
                    insertVariableID(myID, field)
                end
                if globalNode then
                    local myID = globalNode:getName() .. vm.ID_SPLITE .. key
                    local myGlobal = vm.declareGlobal('variable', myID, guide.getUri(node))
                    myGlobal:addSet(guide.getUri(node), field)
                end
            end
        end
    end
end

---@param source parser.object
local function compileAst(source)
    --[[
    local mt
    function mt:xxx()
        self.a = 1
    end

    mt.a --> find this definition
    ]]
    guide.eachSourceType(source, 'self', function (src)
        compileSelf(src)
    end)
end

return {
    compileAst = compileAst,
}
