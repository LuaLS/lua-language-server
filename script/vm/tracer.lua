---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'
local util      = require 'utility'

---@class parser.object
---@field package _tracer? vm.tracer
---@field package _casts?  parser.object[]

---@class vm.tracer
---@field source    parser.object
---@field assigns   parser.object[]
---@field assignMap table<parser.object, true>
---@field careMap   table<parser.object, true>
---@field mark      table<parser.object, true>
---@field casts     parser.object[]
---@field nodes     table<parser.object, vm.node|false>
---@field main      parser.object
---@field uri       uri
---@field castIndex integer?
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

---@param obj parser.object
function mt:collectAssign(obj)
    while true do
        local block = guide.getParentBlock(obj)
        if not block then
            return
        end
        obj = block
        if self.assignMap[obj] then
            return
        end
        if obj == self.main then
            return
        end
        self.assignMap[obj] = true
        self.assigns[#self.assigns+1] = obj
    end
end

---@param obj parser.object
function mt:collectCare(obj)
    while true do
        if self.careMap[obj] then
            return
        end
        if obj == self.main then
            return
        end
        self.careMap[obj] = true
        obj = obj.parent
    end
end

function mt:collectLocal()
    local startPos  = self.source.start
    local finishPos = 0

    self.assigns[#self.assigns+1] = self.source
    self.assignMap[self.source] = true

    for _, obj in ipairs(self.source.ref) do
        if obj.type == 'setlocal' then
            self.assigns[#self.assigns+1] = obj
            self.assignMap[obj] = true
            self:collectCare(obj)
            if obj.finish > finishPos then
                finishPos = obj.finish
            end
        end
        if obj.type == 'getlocal' then
            self:collectCare(obj)
            if obj.finish > finishPos then
                finishPos = obj.finish
            end
        end
    end

    local casts = self:getCasts()
    for _, cast in ipairs(casts) do
        if  cast.loc[1] == self.source[1]
        and cast.start  > startPos
        and cast.finish < finishPos
        and guide.getLocal(self.source, self.source[1], cast.start) == self.source then
            self.casts[#self.casts+1] = cast
        end
    end
end

---@param start  integer
---@param finish integer
---@return parser.object?
function mt:getLastAssign(start, finish)
    local assign
    for _, obj in ipairs(self.assigns) do
        if obj.start < start then
            goto CONTINUE
        end
        if (obj.range or obj.start) >= finish then
            break
        end
        local objBlock = guide.getParentBlock(obj)
        if not objBlock then
            break
        end
        if  objBlock.start  <= finish
        and objBlock.finish >= finish then
            assign = obj
        end
        ::CONTINUE::
    end
    return assign
end

---@param pos integer
function mt:resetCastsIndex(pos)
    for i = 1, #self.casts do
        local cast = self.casts[i]
        if cast.start > pos then
            self.castIndex = i
            return
        end
    end
    self.castIndex = nil
end

---@param pos integer
---@param node vm.node
---@return vm.node
function mt:fastWardCasts(pos, node)
    if not self.castIndex then
        return node
    end
    for i = self.castIndex, #self.casts do
        local action = self.casts[i]
        if action.start > pos then
            return node
        end
        node = node:copy()
        for _, cast in ipairs(action.casts) do
            if     cast.mode == '+' then
                if cast.optional then
                    node:addOptional()
                end
                if cast.extends then
                    node:merge(vm.compileNode(cast.extends))
                end
            elseif cast.mode == '-' then
                if cast.optional then
                    node:removeOptional()
                end
                if cast.extends then
                    node:removeNode(vm.compileNode(cast.extends))
                end
            else
                if cast.extends then
                    node:clear()
                    node:merge(vm.compileNode(cast.extends))
                end
            end
        end
    end
    self.castIndex = self.castIndex + 1
    return node
end

---@param action   parser.object
---@param topNode  vm.node
---@param outNode? vm.node
---@return vm.node topNode
---@return vm.node outNode
function mt:lookIntoChild(action, topNode, outNode)
    if not self.careMap[action]
    or self.mark[action] then
        return topNode, outNode or topNode
    end
    self.mark[action] = true
    topNode = self:fastWardCasts(action.start, topNode)
    if action.type == 'getlocal' then
        if action.node == self.source then
            self.nodes[action] = topNode
            if outNode then
                topNode = topNode:copy():setTruthy()
                outNode = outNode:copy():setFalsy()
            end
        end
    elseif action.type == 'function' then
        self:lookIntoBlock(action, action.args.finish, topNode:copy())
    elseif action.type == 'unary' then
        if not action[1] then
            goto RETURN
        end
        if action.op.type == 'not' then
            outNode = outNode or topNode:copy()
            outNode, topNode = self:lookIntoChild(action[1], topNode, outNode)
            outNode = outNode:copy()
        end
    elseif action.type == 'binary' then
        if not action[1] or not action[2] then
            goto RETURN
        end
        if     action.op.type == 'and' then
            topNode = self:lookIntoChild(action[1], topNode, topNode:copy())
            topNode = self:lookIntoChild(action[2], topNode, topNode:copy())
        elseif action.op.type == 'or' then
            outNode = outNode or topNode:copy()
            local topNode1, outNode1 = self:lookIntoChild(action[1], topNode, outNode)
            local topNode2, outNode2 = self:lookIntoChild(action[2], outNode1, outNode1:copy())
            topNode = vm.createNode(topNode1, topNode2)
            outNode = outNode2:copy()
        elseif action.op.type == '=='
        or     action.op.type == '~=' then
            local handler, checker
            for i = 1, 2 do
                if guide.isLiteral(action[i]) then
                    checker = action[i]
                    handler = action[3-i] -- Copilot tells me use `3-i` instead of `i%2+1`
                end
            end
            if not handler then
                goto RETURN
            end
            if  handler.type == 'getlocal'
            and handler.node == self.source then
                -- if x == y then
                topNode = self:lookIntoChild(handler, topNode, outNode)
                local checkerNode = vm.compileNode(checker)
                local checkerName = vm.getNodeName(checker)
                if checkerName then
                    topNode = topNode:copy()
                    if action.op.type == '==' then
                        topNode:narrow(self.uri, checkerName)
                        if outNode then
                            outNode:removeNode(checkerNode)
                        end
                    else
                        topNode:removeNode(checkerNode)
                        if outNode then
                            outNode:narrow(self.uri, checkerName)
                        end
                    end
                end
            elseif handler.type == 'call'
            and    checker.type == 'string'
            and    handler.node.special == 'type'
            and    handler.args
            and    handler.args[1]
            and    handler.args[1].type == 'getlocal'
            and    handler.args[1].node == self.source then
                -- if type(x) == 'string' then
                self:lookIntoChild(handler, topNode:copy())
                if action.op.type == '==' then
                    topNode:narrow(self.uri, checker[1])
                    if outNode then
                        outNode:remove(checker[1])
                    end
                else
                    topNode:remove(checker[1])
                    if outNode then
                        outNode:narrow(self.uri, checker[1])
                    end
                end
            elseif handler.type == 'getlocal'
            and    checker.type == 'string' then
                local nodeValue = vm.getObjectValue(handler.node)
                if  nodeValue
                and nodeValue.type == 'select'
                and nodeValue.sindex == 1 then
                    local call = nodeValue.vararg
                    if  call
                    and call.type == 'call'
                    and call.node.special == 'type'
                    and call.args
                    and call.args[1]
                    and call.args[1].type == 'getlocal'
                    and call.args[1].node == self.source then
                        -- `local tp = type(x);if tp == 'string' then`
                        if action.op.type == '==' then
                            topNode:narrow(self.uri, checker[1])
                            if outNode then
                                outNode:remove(checker[1])
                            end
                        else
                            topNode:remove(checker[1])
                            if outNode then
                                outNode:narrow(self.uri, checker[1])
                            end
                        end
                    end
                end
            end
        end
    elseif action.type == 'loop'
    or     action.type == 'in'
    or     action.type == 'repeat'
    or     action.type == 'for'
    or     action.type == 'do' then
        if action[1] then
            local actionStart
            if action.type == 'loop' then
                actionStart = action.keyword[4]
            elseif action.type == 'in' then
                actionStart = action.keyword[6]
            elseif action.type == 'repeat'
            or     action.type == 'for'
            or     action.type == 'do' then
                actionStart = action.keyword[2]
            end
            self:lookIntoBlock(action, actionStart, topNode:copy())
            local lastAssign = self:getLastAssign(action.start, action.finish)
            if lastAssign then
                self:getNode(lastAssign)
            end
            if self.nodes[action] then
                topNode = self.nodes[action]:copy()
            end
        end
    elseif action.type == 'while' then
        local blockNode, mainNode
        if action.filter then
            blockNode, mainNode = self:lookIntoChild(action.filter, topNode:copy(), topNode:copy())
        else
            blockNode = topNode:copy()
            mainNode  = topNode:copy()
        end
        if action[1] then
            self:lookIntoBlock(action, action.keyword[4], blockNode:copy())
            local lastAssign = self:getLastAssign(action.start, action.finish)
            if lastAssign then
                self:getNode(lastAssign)
            end
            if self.nodes[action] then
                topNode = mainNode:merge(self.nodes[action])
            end
        end
        if action.filter then
            -- look into filter again
            guide.eachSource(action.filter, function (src)
                self.mark[src] = nil
            end)
            blockNode, topNode = self:lookIntoChild(action.filter, topNode:copy(), topNode:copy())
        end
    elseif action.type == 'if' then
        local hasElse
        local mainNode = topNode:copy()
        local blockNodes = {}
        for _, subBlock in ipairs(action) do
            self:resetCastsIndex(subBlock.start)
            local blockNode = mainNode:copy()
            if subBlock.filter then
                blockNode, mainNode = self:lookIntoChild(subBlock.filter, blockNode, mainNode)
            else
                hasElse = true
                mainNode:clear()
            end
            local mergedNode
            if subBlock[1] then
                local actionStart
                if subBlock.type == 'ifblock'
                or subBlock.type == 'elseif' then
                    actionStart = subBlock.keyword[4]
                else
                    actionStart = subBlock.keyword[2]
                end
                self:lookIntoBlock(subBlock, actionStart, blockNode:copy())
                local neverReturn = subBlock.hasReturn
                                or  subBlock.hasGoTo
                                or  subBlock.hasBreak
                                or  subBlock.hasError
                if neverReturn then
                    mergedNode = true
                else
                    local lastAssign = self:getLastAssign(subBlock.start, subBlock.finish)
                    if lastAssign then
                        self:getNode(lastAssign)
                    end
                    if self.nodes[subBlock] then
                        blockNodes[#blockNodes+1] = self.nodes[subBlock]
                        mergedNode = true
                    end
                end
            end
            if not mergedNode then
                blockNodes[#blockNodes+1] = blockNode
            end
        end
        if not hasElse and not topNode:hasKnownType() then
            mainNode:merge(vm.declareGlobal('type', 'unknown'))
        end
        for _, blockNode in ipairs(blockNodes) do
            mainNode:merge(blockNode)
        end
        topNode = mainNode
    elseif action.type == 'call' then
        if action.node.special == 'assert' and action.args and action.args[1] then
            topNode = self:lookIntoChild(action.args[1], topNode, topNode:copy())
        end
    elseif action.type == 'paren' then
        topNode, outNode = self:lookIntoChild(action.exp, topNode, outNode)
    elseif action.type == 'setlocal' then
        if action.value then
            self:lookIntoChild(action.value, topNode)
        end
    elseif action.type == 'local' then
        if  action.value
        and action.ref
        and action.value.type == 'select' then
            local index = action.value.sindex
            local call  = action.value.vararg
            if  index == 1
            and call.type == 'call'
            and call.node
            and call.node.special == 'type'
            and call.args then
                local getLoc = call.args[1]
                if  getLoc
                and getLoc.type == 'getlocal'
                and getLoc.node == self.source then
                    for _, ref in ipairs(action.ref) do
                        self:collectCare(ref)
                    end
                end
            end
        end
    end
    ::RETURN::
    guide.eachChild(action, function (src)
        if self.careMap[src] then
            self:lookIntoChild(src, topNode)
        end
    end)
    return topNode, outNode or topNode
end

---@param block parser.object
---@param start integer
---@param node  vm.node
function mt:lookIntoBlock(block, start, node)
    self:resetCastsIndex(start)
    for _, action in ipairs(block) do
        if (action.effect or action.start) < start then
            goto CONTINUE
        end
        if self.careMap[action] then
            node = self:lookIntoChild(action, node)
        end
        if action.finish > start and self.assignMap[action] then
            return
        end
        ::CONTINUE::
    end
    self.nodes[block] = node
end

---@param source parser.object
function mt:calcNode(source)
    if source.type == 'getlocal' then
        local lastAssign = self:getLastAssign(0, source.start)
        if not lastAssign then
            lastAssign = source.node
        end
        self:calcNode(lastAssign)
        return
    end
    if source.type == 'local'
    or source.type == 'self'
    or source.type == 'setlocal' then
        local node = vm.compileNode(source)
        self.nodes[source] = node
        local parentBlock = guide.getParentBlock(source)
        if parentBlock then
            self:lookIntoBlock(parentBlock, source.finish, node)
        end
        return
    end
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
    self:calcNode(source)
    return self.nodes[source] or nil
end

---@class vm.node
---@field package _tracer vm.tracer

---@param source parser.object
---@return vm.tracer?
local function createTracer(source)
    local node = vm.compileNode(source)
    local tracer = node._tracer
    if tracer then
        return tracer
    end
    local main = guide.getParentBlock(source)
    if not main then
        return nil
    end
    tracer = setmetatable({
        source    = source,
        assigns   = {},
        assignMap = {},
        careMap   = {},
        mark      = {},
        casts     = {},
        nodes     = {},
        main      = main,
        uri       = guide.getUri(source),
    }, mt)
    node._tracer = tracer

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
