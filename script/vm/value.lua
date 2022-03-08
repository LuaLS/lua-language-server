local nodeMgr = require 'vm.node'

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

return m
