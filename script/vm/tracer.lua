---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'

---@class parser.object
---@field package _tracer? vm.tracer
---@field package _casts?  parser.object[]

---@class vm.tracer
---@field source   parser.object
---@field assigns  parser.object[]
---@field nodes    table<parser.object, vm.node|false>
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
        obj = obj.parent
        if mark[obj] then
            return
        end
        if not guide.isBlockType(obj) then
            return
        end
        if obj == self.main then
            return
        end
        mark[obj] = true
        self.assigns[#self.assigns+1] = obj
    end
end

function mt:collectLocal()
    local startPos  = self.source.start
    local finishPos = 0

    local mark = {}

    self.assigns[#self.assigns+1] = self.source

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

---@param block parser.object
---@param pos   integer
---@return parser.object?
function mt:getLastAssign(block, pos)
    if not block then
        return nil
    end
    local assign
    for _, obj in ipairs(self.assigns) do
        if obj.start >= pos then
            break
        end
        local objBlock = guide.getParentBlock(obj)
        if not objBlock then
            break
        end
        if objBlock == block then
            assign = obj
        end
    end
    return assign
end

---@param filter parser.object
---@param node vm.node?
---@return vm.node
function mt:narrowByFilter(filter, node)
    if not node then
        node = vm.createNode()
    end
    if filter.type == 'filter' then
        node = self:narrowByFilter(filter.exp, node)
        return node
    end
    if filter.type == 'getlocal' then
        if filter.node == self.source then
            node = node:copy()
            node:removeOptional()
        end
        return node
    end
    return node
end

---@param source parser.object
---@return vm.node?
function mt:calcNode(source)
    if source.type == 'getlocal' then
        return nil
    end
    if source.type == 'local' then
        if source ~= self.source then
            return nil
        end
    end
    if source.type == 'setlocal' then
        if source.node ~= self.source then
            return nil
        end
    end
    if guide.isSet(source) then
        local node = vm.compileNode(source)
        return node
    end
    if source.type == 'do' then
        local lastAssign = self:getLastAssign(source, source.finish)
        return self:getNode(lastAssign or source.parent)
    end
    if source.type == 'ifblock' then
        local currentNode  = self:getNode(source.parent)
        local narrowedNode = self:narrowByFilter(source.filter, currentNode)
        return narrowedNode
    end
    if source.type == 'filter' then
        local parent = source.parent
        ---@type parser.object
        local outBlock
        if parent.type == 'ifblock' then
            outBlock = parent.parent.parent
            local lastAssign = self:getLastAssign(outBlock, parent.start)
            return self:getNode(lastAssign or source.parent)
        elseif parent.type == 'elseifblock' then
            outBlock = parent.parent.parent
            local lastAssign = self:getLastAssign(outBlock, parent.start)
            return self:getNode(lastAssign or source.parent)
        elseif parent.type == 'while' then
            outBlock = parent.parent
            local lastAssign = self:getLastAssign(outBlock, parent.start)
            return self:getNode(lastAssign or source.parent)
        elseif parent.type == 'repeat' then
            outBlock = parent.parent
            local lastAssign = self:getLastAssign(outBlock, parent.start)
            return self:getNode(lastAssign or source.parent)
        end
        assert(outBlock, parent.type)
    end
    return nil
end

---@param source parser.object
---@return vm.node?
function mt:getNode(source)
    if self.nodes[source] ~= nil then
        return self.nodes[source] or nil
    end
    local parentBlock = guide.getParentBlock(source)
    if not parentBlock then
        self.nodes[source] = false
        return nil
    end
    if source == self.main then
        self.nodes[source] = false
        return nil
    end
    local node = self:calcNode(source)
    if node then
        self.nodes[source] = node
        return node
    end
    local lastAssign = self:getLastAssign(parentBlock, source.start)
    local parentNode = self:getNode(lastAssign or source.parent)
    self.nodes[source] = parentNode or false
    return parentNode
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
