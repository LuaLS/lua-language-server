local nodeMgr = require 'vm.node'
local guide   = require 'parser.guide'

---@class vm.value-manager
local m = {}

---@param source parser.object
---@return boolean|nil
function m.test(source)
    local compiler = require 'vm.compiler'
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
---@return string
local function getUnique(v)
    if v.type == 'local' then
        return ('loc:%s@%d'):format(guide.getUri(v), v.start)
    end
    if v.type == 'global' then
        return ('%s:%s'):format(v.cate, v.name)
    end
    if v.type == 'boolean' then
        return ('bool:%s'):format(v[1])
    end
    if v.type == 'number' then
        return ('num:%s'):format(v[1])
    end
    if v.type == 'integer' then
        return ('num:%s'):format(v[1])
    end
end

local function nodeToMap(node)
    local map = {}
    for n in nodeMgr.eachNode(node) do
        if n.type == 'local' then
            map[n] = true
        end
        if n.type == 'global' then
            
        end
    end
    return map
end

---@param a vm.node
---@param b vm.node
---@return boolean|nil
function m.equal(a, b)
    local compiler = require 'vm.compiler'
    local nodeA = compiler.compileNode(a)
    local nodeB = compiler.compileNode(b)
    local mapA = {}
    local mapB = {}
end

return m
