---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'

---@class parser.object
---@field package _tracer? vm.tracer
---@field package _casts?  parser.object[]

---@class vm.tracer
---@field source   parser.object
---@field assigns  parser.object[]
---@field nodes    table<parser.object, vm.node>
---@field main     parser.object
---@field uri      uri
local mt = {}
mt.__index = mt

---@return parser.object[]
function mt:getCasts()
    local root = guide.getRoot(self.source)
    if not root._casts then
        root._casts = {}
        local docs = root.docs
        for _, doc in ipairs(docs) do
            if doc.type == 'doc.cast' and doc.loc then
                root._casts[#root._casts+1] = doc
            end
        end
    end
    return root._casts
end

---@param obj  parser.object
---@param mark table
function mt:collectBlock(obj, mark)
    while true do
        if mark[obj] then
            return
        end
        mark[obj] = true
        self.assigns[#self.assigns+1] = obj
        if obj == self.main then
            return
        end
        obj = obj.parent
    end
end

function mt:collectLocal()
    local startPos  = self.source.start
    local finishPos = 0

    local mark = {}

    for _, obj in ipairs(self.source.ref) do
        if obj.type == 'setlocal' then
            self.assigns[#self.assigns+1] = obj
            self:collectBlock(obj, mark)
        end
    end

    local casts = self:getCasts()
    for _, cast in ipairs(casts) do
        if  cast.loc[1] == self.source[1]
        and cast.start > startPos
        and cast.finish < finishPos
        and guide.getLocal(self.source, self.source[1], cast.start) == self.source then
            self.assigns[#self.assigns+1] = cast
        end
    end

    table.sort(self.assigns, function (a, b)
        return a.start < b.start
    end)
end

---@param source parser.object
---@return parser.object?
function mt:getLastAssign(source)
    local assign = self.source
    for _, obj in ipairs(self.assigns) do
        if obj.start > source.start then
            break
        end
        assign = obj
    end
    return assign
end

---@param source parser.object
---@return vm.node?
function mt:getNode(source)
    if self.nodes[source] then
        return self.nodes[source]
    end
    local lastAssign = self:getLastAssign(source)
    if not lastAssign then
        return nil
    end
    if guide.isSet(lastAssign) then
        local lastNode = vm.compileNode(lastAssign)
        return lastNode
    end
end

---@param source parser.object
---@return vm.tracer?
local function createTracer(source)
    if source._tracer then
        return source._tracer
    end
    local main = guide.getParentBlock(source)
    if not main then
        return nil
    end
    local tracer = setmetatable({
        source   = source,
        assigns  = {},
        nodes    = {},
        main     = main,
        uri      = guide.getUri(source),
    }, mt)
    source._tracer = tracer

    tracer:collectLocal()

    return tracer
end

---@param source parser.object
---@return vm.node?
function vm.traceNode(source)
    local loc
    if source.type == 'getlocal'
    or source.type == 'setlocal' then
        loc = source.node
    end
    local tracer = createTracer(loc)
    if not tracer then
        return nil
    end
    local node = tracer:getNode(source)
    return node
end
