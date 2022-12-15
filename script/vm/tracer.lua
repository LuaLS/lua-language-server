---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'
local util      = require 'utility'

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
        local block = guide.getParentBlock(obj)
        if not block then
            return
        end
        obj = block
        if mark[obj] then
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
        if obj.type == 'getlocal' then
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

---@param source parser.object
---@return vm.node?
function mt:narrow(source)
    local node = self:getNode(source)
    if not node then
        return nil
    end

    if source.type == 'getlocal' then
        node = node:copy()
        node:setTruthy()
    end

    return node
end

---@param source parser.object
---@return vm.node?
function mt:calcGet(source)
    local parent = source.parent
    if parent.type == 'filter' then
        return self:calcGet(parent)
    end
    if parent.type == 'ifblock' then
        local parentBlock = guide.getParentBlock(parent.parent)
        if parentBlock then
            local lastAssign = self:getLastAssign(parentBlock, parent.start)
            local node       = self:getNode(lastAssign or parentBlock)
            return node
        end
    end
    if parent.type == 'unary' then
        return self:calcGet(parent)
    end
    return nil
end

---@param source parser.object
---@return vm.node?
function mt:calcNode(source)
    if source.type == 'getlocal' then
        if source.node ~= self.source then
            return nil
        end
        local block = guide.getParentBlock(source)
        if not block then
            return nil
        end
        local lastAssign = self:getLastAssign(block, source.start)
        if lastAssign then
            local node = self:getNode(lastAssign)
            return node
        end
        local node = self:calcGet(source)
        if node then
            return node
        end
    end
    if source.type == 'setlocal' then
        if source.node ~= self.source then
            return nil
        end
        local node = vm.compileNode(source)
        return node
    end
    if source.type == 'local'
    or source.type == 'self' then
        if source ~= self.source then
            return nil
        end
        local node = vm.compileNode(source)
        return node
    end
    if source.type == 'filter' then
        local node = self:narrow(source.exp)
        return node
    end
    if source.type == 'do' then
        local lastAssign = self:getLastAssign(source, source.finish)
        local node = self:getNode(lastAssign or source.parent)
        return node
    end
    if source.type == 'ifblock' then
        local filter = source.filter
        if filter then
            local node = self:getNode(filter)
            return node
        end
    end
    if source.type == 'if' then
        local parentBlock = guide.getParentBlock(source)
        if not parentBlock then
            return nil
        end
        local lastAssign = self:getLastAssign(parentBlock, source.start)
        local outNode    = self:getNode(lastAssign or source.parent) or vm.createNode()
        for _, block in ipairs(source) do
            local blockNode = self:getNode(block)
            if not blockNode then
                goto CONTINUE
            end
            if block.hasReturn
            or block.hasError
            or block.hasBreak then
                outNode:removeNode(blockNode)
                goto CONTINUE
            end
            local blockAssign = self:getLastAssign(block, block.finish)
            if not blockAssign then
                goto CONTINUE
            end
            local blockAssignNode = self:getNode(blockAssign)
            if not blockAssignNode then
                goto CONTINUE
            end
            outNode:removeNode(blockNode)
            outNode:merge(blockAssignNode)
            ::CONTINUE::
        end
    end
    if source.type == 'unary' then
        if source.op.type == 'not' then
            local node = self:getNode(source[1])
            if node then
                node = node:copy()
                node:setFalsy()
                return node
            end
        end
    end

    local block = guide.getParentBlock(source)
    if not block then
        return nil
    end
    local lastAssign = self:getLastAssign(block, source.start)
    local node = self:getNode(lastAssign or source.parent)
    return node
end

---@param source parser.object
---@return vm.node?
function mt:getNode(source)
    local cache = self.nodes[source]
    if cache ~= nil then
        return cache or nil
    end
    if source == self.main then
        self.nodes[source] = false
        return nil
    end
    self.nodes[source] = false
    local node = self:calcNode(source)
    if node then
        self.nodes[source] = node
    end
    return node
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
