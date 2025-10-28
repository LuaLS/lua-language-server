---@class Node.Template: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, name: string, params: table<string, Node.Generic?>): Node.Template
local M = ls.node.register 'Node.Template'

M.kind = 'template'

M.hasGeneric = true

---@param scope Scope
---@param name string
---@param params table<string, Node.Generic?>
function M:__init(scope, name, params)
    self.scope = scope
    self.name = name
    self.params = params
end

function M:resolveGeneric(map)
    local node = self.scope.rt
    local result

    local function nextToken(start, current)
        local startMark = self.name:find('`', start, true)
        if not startMark then
            result = result | node.type(current .. self.name:sub(start))
            return
        end
        current = current .. self.name:sub(start, startMark - 1)
        local endMark = self.name:find('`', startMark + 1, true)
        if not endMark then
            return
        end
        local paramName = self.name:sub(startMark + 1, endMark - 1)
        local param = self.params[paramName]
        if not param then
            return
        end
        local value = map[param]
        if not value then
            return
        end
        if value.kind == 'value' then
            ---@cast value Node.Value
            nextToken(endMark + 1, current .. tostring(value.literal))
            return
        end
        if value.kind == 'union' then
            ---@cast value Node.Union
            for _, v in ipairs(value.values) do
                if v.kind == 'value' then
                    ---@cast v Node.Value
                    nextToken(endMark + 1, current .. tostring(v.literal))
                else
                    result = result | node.UNKNOWN
                end
            end
        end
    end

    nextToken(1, '')

    return result or node.UNKNOWN
end

---@param self Node
---@return Node
---@return true
function M.__getter.value(self)
    return self.scope.rt.UNKNOWN, true
end
