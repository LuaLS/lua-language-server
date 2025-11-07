---@class Node.OddTemplate: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, params: (string|Node.Generic)[]): Node.OddTemplate
local M = ls.node.register 'Node.OddTemplate'

M.kind = 'oddtemplate'

M.hasGeneric = true

---@param scope Scope
---@param params (string|Node.Generic)[]
function M:__init(scope, params)
    self.scope  = scope
    self.params = params
end

function M:inferGeneric(other, result)
    local rt = self.scope.rt
    local node

    ---@param index integer
    ---@param current string
    local function nextToken(index, current)
        local token = self.params[index]
        if not token then
            node = node | rt.type(current)
            return
        end
        if type(token) == 'string' then
            current = current .. token
            nextToken(index + 1, current)
            return
        end
        local value = other
        if not value then
            return
        end
        ---@param node Node.Value
        value:each('value', function (node)
            nextToken(index + 1, current .. tostring(node.literal))
        end)
    end

    nextToken(1, '')

    if not node then
        return
    end

    for _, param in ipairs(self.params) do
        if type(param) ~= 'string' then
            result[param] = node
        end
    end
end

function M:resolveGeneric(map)
    for _, param in ipairs(self.params) do
        if type(param) ~= 'string' then
            local value = map[param]
            if value then
                return value
            end
        end
    end
    return self.scope.rt.UNKNOWN
end

---@param self Node
---@return Node
---@return true
function M.__getter.value(self)
    return self.scope.rt.UNKNOWN, true
end
