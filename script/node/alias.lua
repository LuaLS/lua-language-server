---@class Node.Alias: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@field params? Node.Generic[]
local M = ls.node.register 'Node.Alias'

M.kind = 'alias'
M.typeName = 'alias'

---@param scope Scope
---@param name string
---@param params? Node.Generic[]
---@param value? Node
function M:__init(scope, name, params, value)
    self.aliasName = name
    self.scope = scope
    self.params = params
    self.aliasValue = value

    self.masterType = scope.rt.type(name)
    self.masterType:addAlias(self)
end

function M:__del()
    self.masterType:removeAlias(self)
end

function M:__close()
    self:dispose()
end

function M:dispose()
    Delete(self)
end

---@param param Node.Generic
---@return Node.Alias
function M:addTypeParam(param)
    if not self.params then
        self.params = {}
    end
    table.insert(self.params, param)

    self:flushCache()

    return self
end

---@param value Node
---@return Node.Alias
function M:setValue(value)
    self.extendsValue = value

    self:flushCache()

    return self
end

---@param callback fun(self: Node.Alias, args: Node[], location?: Node.Location): Node
---@return Node.Alias
function M:setCustomValue(callback)
    self.customValue = callback
    return self
end

---@alias Node.Alias.CustomHover fun(self: Node.Alias, location?: Node.Location, source?: LuaParser.Node.Base): string | { label?: string, description?: string } | nil

---@type Node.Alias.CustomHover?
M.customHover = nil

---@param callback Node.Alias.CustomHover
---@return Node.Alias
function M:setCustomHover(callback)
    self.customHover = callback
    return self
end

---@alias Node.Alias.CustomCompletion fun(self: Node.Alias, location?: Node.Location, source?: LuaParser.Node.Base): { label: string, detail?: string, description?: string, kind?: LSP.CompletionItemKind }[] | nil

---@type Node.Alias.CustomCompletion?
M.customCompletion = nil

---@param callback Node.Alias.CustomCompletion
---@return Node.Alias
function M:setCustomCompletion(callback)
    self.customCompletion = callback
    return self
end

---@param args Node[]
---@param location? Node.Location
---@return Node
function M:call(args, location)
    if self.customValue then
        local value = self.customValue(self, args, location)
        value:addRef(self)
        return value
    end
    if not self.params then
        return self.value
    end
    return self.value:resolveGeneric(self:makeGenericMap(args))
end

M.__getter.value = function (self)
    if self.aliasValue then
        return self.aliasValue
    end
    if self.extendsValue then
        self.extendsValue:addRef(self)
        return self.extendsValue, true
    end
    return self.scope.rt.UNKNOWN, true
end

---@type Node.Location?
M.location = nil

---@param location Node.Location
function M:setLocation(location)
    self.location = location
end

---@param self Node.Class
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    local params = self.params
    if params then
        for _, param in ipairs(params) do
            param:addRef(self)
        end
        return true, true
    else
        return false, true
    end
end

---@param map table<Node.Generic, Node>
---@param ctx? Node.ResolveContext
---@return Node
function M:resolveGeneric(map, ctx)
    if not self.params then
        return self
    end
    return self.value:resolveGeneric(map, ctx)
end

---@param args Node[]
---@return table<Node.Generic, Node>
function M:makeGenericMap(args)
    local map = {}
    if not self.params then
        return map
    end
    for i, param in ipairs(self.params) do
        map[param] = args[i]
    end
    return map
end

function M:onView(viewer, options)
    if self.params then
        return '{}<{}>' % {
            self.aliasName,
            table.concat(ls.util.map(self.params, function (param)
                return viewer:view(param)
            end), ', ')
        }
    else
        return self.aliasName
    end
end
