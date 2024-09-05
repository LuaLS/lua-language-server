local guide    = require 'parser.guide'
---@class vm
local vm       = require 'vm.vm'

---@param source parser.object?
---@return boolean|nil
function vm.testCondition(source)
    if not source then
        return nil
    end
    local node = vm.compileNode(source)
    if node.optional then
        return nil
    end
    local hasTrue, hasFalse
    for n in node:eachObject() do
        if n.type == 'boolean'
        or n.type == 'doc.type.boolean' then
            if n[1] == true then
                hasTrue = true
            end
            if n[1] == false then
                hasFalse = true
            end
        elseif n.type == 'global' and n.cate == 'type' then
            if n.name == 'boolean'
            or n.name == 'unknown' then
                return nil
            end
            if n.name == 'false'
            or n.name == 'nil' then
                hasFalse = true
            else
                hasTrue = true
            end
        elseif n.type == 'nil' then
            hasFalse = true
        elseif guide.isLiteral(n) then
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

---@param v vm.node.object
---@return string|false
local function getUnique(v)
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
        ---@cast v parser.object
        return ('table:%s@%d'):format(guide.getUri(v), v.start)
    end
    if v.type == 'function' then
        ---@cast v parser.object
        return ('func:%s@%d'):format(guide.getUri(v), v.start)
    end
    return false
end

---@param a parser.object?
---@param b parser.object?
---@return boolean|nil
function vm.equal(a, b)
    if not a or not b then
        return false
    end
    local nodeA = vm.compileNode(a)
    local nodeB = vm.compileNode(b)
    local mapA = {}
    for obj in nodeA:eachObject() do
        local unique = getUnique(obj)
        if not unique then
            return nil
        end
        mapA[unique] = true
    end
    for obj in nodeB:eachObject() do
        local unique = getUnique(obj)
        if not unique then
            return nil
        end
        if not mapA[unique] then
            return false
        end
    end
    return true
end

---@param v vm.object?
---@return integer?
function vm.getInteger(v)
    if not v then
        return nil
    end
    local node = vm.compileNode(v)
    local result
    for n in node:eachObject() do
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

---@param v vm.object?
---@return string?
function vm.getString(v)
    if not v then
        return nil
    end
    local node = vm.compileNode(v)
    local result
    for n in node:eachObject() do
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

---@param v vm.object?
---@return number?
function vm.getNumber(v)
    if not v then
        return nil
    end
    local node = vm.compileNode(v)
    local result
    for n in node:eachObject() do
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

---@param v vm.object
---@return boolean|nil
function vm.getBoolean(v)
    if not v then
        return nil
    end
    local node = vm.compileNode(v)
    local result
    for n in node:eachObject() do
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

---@param v vm.object
---@return table<any, boolean>?
---@return integer
function vm.getLiterals(v)
    if not v then
        return nil, 0
    end
    local map
    local count = 0
    local node = vm.compileNode(v)
    for n in node:eachObject() do
        local literal
        if n.type == 'boolean'
        or n.type == 'string'
        or n.type == 'number'
        or n.type == 'integer' then
            literal = n[1]
        end
        if n.type == 'doc.type.string'
        or n.type == 'doc.type.integer'
        or n.type == 'doc.type.boolean' then
            literal = n[1]
        end
        if literal ~= nil then
            if not map then
                map = {}
            end
            map[literal] = true
            count = count + 1
        end
    end
    return map, count
end
