local nodeMgr  = require 'vm.node'
local guide    = require 'parser.guide'
local compiler = require 'vm.compiler'

---@class vm.value-manager
local m = {}

---@param source parser.object
---@return boolean|nil
function m.test(source)
    local node = compiler.compileNode(source)
    local hasTrue, hasFalse
    for n in nodeMgr.eachNode(node) do
        if n.type == 'boolean' then
            if n[1] == true then
                hasTrue = true
            end
            if n[1] == false then
                hasTrue = false
            end
        end
        if n.type == 'nil' then
            hasFalse = true
        end
        if n.type == 'string'
        or n.type == 'number'
        or n.type == 'integer'
        or n.type == 'table'
        or n.type == 'function' then
            hasTrue = true
        end
    end
    if hasTrue == hasFalse then
        return nil
    end
    if hasTrue then
        return true
    else
        return false
    end
end

---@param v vm.node
---@return string?
local function getUnique(v)
    if v.type == 'local' then
        return ('loc:%s@%d'):format(guide.getUri(v), v.start)
    end
    if v.type == 'global' then
        return ('%s:%s'):format(v.cate, v.name)
    end
    if v.type == 'boolean' then
        if v[1] == nil then
            return false
        end
        return ('%s'):format(v[1])
    end
    if v.type == 'number' then
        if not v[1] then
            return false
        end
        return ('num:%s'):format(v[1])
    end
    if v.type == 'integer' then
        if not v[1] then
            return false
        end
        return ('num:%s'):format(v[1])
    end
    if v.type == 'table' then
        return ('table:%s@%d'):format(guide.getUri(v), v.start)
    end
    if v.type == 'function' then
        return ('func:%s@%d'):format(guide.getUri(v), v.start)
    end
    return false
end

---@param a vm.node
---@param b vm.node
---@return boolean|nil
function m.equal(a, b)
    local nodeA = compiler.compileNode(a)
    local nodeB = compiler.compileNode(b)
    local mapA = {}
    for n in nodeMgr.eachNode(nodeA) do
        local unique = getUnique(n)
        if not unique then
            return nil
        end
        mapA[unique] = true
    end
    for n in nodeMgr.eachNode(nodeB) do
        local unique = getUnique(n)
        if not unique then
            return nil
        end
        if not mapA[unique] then
            return false
        end
    end
    return true
end

---@param v vm.node
---@return integer?
function m.getInteger(v)
    local node = compiler.compileNode(v)
    local result
    for n in nodeMgr.eachNode(node) do
        if n.type == 'integer' then
            if result then
                return nil
            else
                result = n[1]
            end
        elseif n.type == 'number' then
            if result then
                return nil
            elseif not math.tointeger(n[1]) then
                return nil
            else
                result = math.tointeger(n[1])
            end
        elseif n.type ~= 'local'
        and    n.type ~= 'global' then
            return nil
        end
    end
    return result
end

---@param v vm.node
---@return integer?
function m.getString(v)
    local node = compiler.compileNode(v)
    local result
    for n in nodeMgr.eachNode(node) do
        if n.type == 'string' then
            if result then
                return nil
            else
                result = n[1]
            end
        elseif n.type ~= 'local'
        and    n.type ~= 'global' then
            return nil
        end
    end
    return result
end

---@param v vm.node
---@return number?
function m.getNumber(v)
    local node = compiler.compileNode(v)
    local result
    for n in nodeMgr.eachNode(node) do
        if n.type == 'number'
        or n.type == 'integer' then
            if result then
                return nil
            else
                result = n[1]
            end
        elseif n.type ~= 'local'
        and    n.type ~= 'global' then
            return nil
        end
    end
    return result
end

---@param v vm.node
---@return boolean|nil
function m.getBoolean(v)
    local node = compiler.compileNode(v)
    local result
    for n in nodeMgr.eachNode(node) do
        if n.type == 'boolean' then
            if result then
                return nil
            else
                result = n[1]
            end
        elseif n.type ~= 'local'
        and    n.type ~= 'global' then
            return nil
        end
    end
    return result
end

return m
