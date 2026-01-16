---@class Node.Tracer: Node
local M = ls.node.register 'Node.Tracer'

M.kind = 'tracer'

---@param map table<string, Node>
function M:__init(map)
    self.map = map
end

---@param self Node.Tracer
---@return Node
---@return true
M.__getter.value = function (self)
    return self.scope.rt.NEVER, true
end

---@param flow table
function M:setFlow(flow)
    self.flow = flow
end

---@type Node.Tracer.Walker?
M.walker = nil

M.__getter.walker = function (self)
    return New 'Node.Tracer.Walker' (self.scope, self.map), true
end

function M:trace()
    self.walker:start(self.flow)
end

---@class Node.Tracer.Walker
local W = Class 'Node.Tracer.Walker'

---@param scope Scope
---@param map table<string, Node.Variable>
function W:__init(scope, map)
    self.scope = scope
    self.map   = map
end

function W:start(block)
    if self.started then
        return
    end
    self.started = true
    self.idValue = {}
    self.aliasID = {}
    self:traceBlock(block)
end

---@param block table[]
function W:traceBlock(block)
    for _, v in ipairs(block) do
        local tag = v[1]
        if tag == 'var' then
            self:traceVar(v)
            goto continue
        end
        if tag == 'ref' then
            self:traceRef(v)
            goto continue
        end
        if tag == 'if' then
            self:traceIf(v)
        end
        ::continue::
    end
end

function W:traceVar(var)
    local id, alias = var[2], var[3]
    self.aliasID[alias] = id
    self.idValue[id] = self.map[alias].value
end

function W:traceRef(ref)
    local id, alias = ref[2], ref[3]
    self.aliasID[alias] = id
    self.map[alias]:setCurrentValue(self.idValue[id])
end

function W:traceIf(ifNode)
    for i = 2, #ifNode do
        self:traceIfChild(ifNode[i])
    end
end

function W:traceIfChild(block)
    
end
