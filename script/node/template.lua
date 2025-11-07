---@class Node.Template: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, params: (string|Node.Generic)[]): Node.Template
local M = ls.node.register 'Node.Template'

M.kind = 'template'

M.hasGeneric = true

---@param scope Scope
---@param params (string|Node.Generic)[]
function M:__init(scope, params)
    self.scope = scope
    self.params = params
end

function M:resolveGeneric(map)
    local rt = self.scope.rt
    local result

    ---@param index integer
    ---@param current string
    local function nextToken(index, current)
        local token = self.params[index]
        if not token then
            result = result | rt.type(current)
        end
        if type(token) == 'string' then
            current = current .. token
            nextToken(index + 1, current)
            return
        end
        local value = map[token]
        if not value then
            return
        end
        ---@param node Node.Value
        value:each('value', function (node)
            nextToken(index + 1, current .. tostring(node.literal))
        end)
    end

    nextToken(1, '')

    return result or rt.UNKNOWN
end

---@param self Node
---@return Node
---@return true
function M.__getter.value(self)
    return self.scope.rt.UNKNOWN, true
end
