---@class Coder
local M = Class 'Coder'

---@type Coder.Tracer[]
M.tracers = nil

---@param source LuaParser.Node.Function
function M:startTracer(source)
    local tracerKey = self:getCustomKey('tracer|' .. source.uniqueKey)
    self:addLine('{tracer} = rt.tracer(r, p)' % {
        tracer = tracerKey,
    })
    if not self.tracers then
        self.tracers = {}
    end
    table.insert(self.tracers, New 'Coder.Tracer' (self, tracerKey))
end

function M:getTracer()
    return self.tracers[#self.tracers]
end

function M:finishTracer()
    ---@type Coder.Tracer
    local top = table.remove(self.tracers)
    local data = top:getData()
    self:addLine('{tracer}:setFlow {value}' % {
        tracer = top.key,
        value  = ls.util.dump(data, {
            noArrayKey = true,
        }),
    })
end

---@class Coder.Tracer
local T = Class 'Coder.Tracer'

Presize(T, 3)

---@param coder Coder
---@param key string
function T:__init(coder, key)
    self.coder = coder
    self.key = key
    self.stack = {{}}
    self.visibleVars = {}
end

---@param kind 'var'|'ref'
---@param id string
---@param alias string
function T:append(kind, id, alias)
    local top = self.stack[#self.stack]
    top[#top+1] = { kind, id, alias }
end

function T:appendVar(source)
    local id = self.coder:getVarName(source)
    if not id then
        return
    end
    self:append('var', id, source.uniqueKey)
    self.visibleVars[id] = true
end

function T:appendRef(source)
    local id = self.coder:getVarName(source)
    if not id then
        return
    end
    self:append('ref', id, source.uniqueKey)
    if self.visibleVars[id] then
        self.coder:addLine('{var}:setTracer({tracer})' % {
            var    = self.coder:getKey(source),
            tracer = self.key,
        })
    end
    self.visibleVars[id] = true
end

function T:pushStack()
    self.stack[#self.stack+1] = {}
end

function T:popStack()
    self.stack[#self.stack] = nil
end

function T:getData()
    return self.stack[#self.stack]
end
