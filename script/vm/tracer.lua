---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'
local util      = require 'utility'

---@class parser.object
---@field package _tracer? vm.tracer
---@field package _casts?  parser.object[]

---@alias tracer.mode 'local' | 'global'

---@class vm.tracer
---@field mode      tracer.mode
---@field name      string
---@field source    parser.object | vm.variable
---@field assigns   (parser.object | vm.variable)[]
---@field assignMap table<parser.object, true>
---@field getMap    table<parser.object, true>
---@field careMap   table<parser.object, true>
---@field mark      table<parser.object, true>
---@field casts     parser.object[]
---@field nodes     table<parser.object, vm.node|false>
---@field main      parser.object
---@field uri       uri
---@field castIndex integer?
local mt = {}
mt.__index = mt
mt.fastCalc    = true

---@return parser.object[]
function mt:getCasts()
    local root = guide.getRoot(self.main)
    if not root._casts then
        root._casts = {}
        local docs = root.docs
        for _, doc in ipairs(docs) do
            if doc.type == 'doc.cast' and doc.name then
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
        if not obj then
            return
        end
        self.careMap[obj] = true

        if self.fastCalc then
            if obj.type == 'if'
            or obj.type == 'while'
            or obj.type == 'binary' then
                self.fastCalc = false
            end
            if obj.type == 'call' and obj.node then
                if obj.node.special == 'assert'
                or obj.node.special == 'type' then
                    self.fastCalc = false
                end
            end
        end

        obj = obj.parent
    end
end

function mt:collectLocal()
    local startPos  = self.source.base.start
    local finishPos = 0

    local variable = self.source

    if  variable.base.type ~= 'local'
    and variable.base.type ~= 'self' then
        self.assigns[#self.assigns+1] = variable
        self.assignMap[self.source] = true
    end

    for _, set in ipairs(variable.sets) do
        self.assigns[#self.assigns+1] = set
        self.assignMap[set] = true
        self:collectCare(set)
        if set.finish > finishPos then
            finishPos = set.finish
        end
    end

    for _, get in ipairs(variable.gets) do
        self:collectCare(get)
        self.getMap[get] = true
        if get.finish > finishPos then
            finishPos = get.finish
        end
    end

    local casts = self:getCasts()
    for _, cast in ipairs(casts) do
        if  cast.name[1] == self.name
        and cast.start  > startPos
        and cast.finish < finishPos
        and vm.getCastTargetHead(cast) == variable.base then
            self.casts[#self.casts+1] = cast
        end
    end

    if #self.casts > 0 then
        self.fastCalc = false
    end
end

function mt:collectGlobal()
    self.assigns[#self.assigns+1] = self.source
    self.assignMap[self.source] = true

    local uri    = guide.getUri(self.source)
    local global = self.source.global
    local link   = global.links[uri]

    for _, set in ipairs(link.sets) do
        self.assigns[#self.assigns+1] = set
        self.assignMap[set] = true
        self:collectCare(set)
    end

    for _, get in ipairs(link.gets) do
        self:collectCare(get)
        self.getMap[get] = true
    end

    local casts = self:getCasts()
    for _, cast in ipairs(casts) do
        if cast.name[1] == self.name then
            local castTarget = vm.getCastTargetHead(cast)
            if castTarget and castTarget.type == 'global' then
                self.casts[#self.casts+1] = cast
            end
        end
    end

    if #self.casts > 0 then
        self.fastCalc = false
    end
end

---@param start  integer
---@param finish integer
---@return parser.object?
function mt:getLastAssign(start, finish)
    local lastAssign
    for _, assign in ipairs(self.assigns) do
        local obj
        if assign.type == 'variable' then
            ---@cast assign vm.variable
            obj = assign.base
        else
            ---@cast assign parser.object
            obj = assign
        end
        if obj.start < start then
            goto CONTINUE
        end
        if (obj.effect or obj.range or obj.start) >= finish then
            break
        end
        local objBlock = guide.getTopBlock(obj)
        if not objBlock then
            break
        end
        if  objBlock.start  <= finish
        and objBlock.finish >= finish then
            lastAssign = obj
        end
        ::CONTINUE::
    end
    return lastAssign
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

local lookIntoChild = util.switch()
    : case 'getlocal'
    : case 'getglobal'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        if tracer.getMap[action] then
            tracer.nodes[action] = topNode
            if outNode then
                topNode = topNode:copy():setTruthy()
                outNode = outNode:copy():setFalsy()
            end
        end
        return topNode, outNode
    end)
    : case 'repeat'
    : case 'loop'
    : case 'for'
    : case 'do'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        if action.type == 'loop' then
            tracer:lookIntoChild(action.init, topNode)
            tracer:lookIntoChild(action.max, topNode)
        end
        if action[1] then
            tracer:lookIntoBlock(action, action.bstart, topNode:copy())
            local lastAssign = tracer:getLastAssign(action.start, action.finish)
            if lastAssign then
                tracer:getNode(lastAssign)
            end
            if tracer.nodes[action] then
                topNode = tracer.nodes[action]:copy()
            end
        end
        if action.type == 'repeat' then
            tracer:lookIntoChild(action.filter, topNode)
        end
        return topNode, outNode
    end)
    : case 'in'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoChild(action.exps, topNode)
        if action[1] then
            tracer:lookIntoBlock(action, action.bstart, topNode:copy())
            local lastAssign = tracer:getLastAssign(action.start, action.finish)
            if lastAssign then
                tracer:getNode(lastAssign)
            end
            if tracer.nodes[action] then
                topNode = tracer.nodes[action]:copy()
            end
        end
        return topNode, outNode
    end)
    : case 'while'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        local blockNode, mainNode
        if action.filter then
            blockNode, mainNode = tracer:lookIntoChild(action.filter, topNode:copy(), topNode:copy())
        else
            blockNode = topNode:copy()
            mainNode  = topNode:copy()
        end
        if action[1] then
            tracer:lookIntoBlock(action, action.bstart, blockNode:copy())
            local lastAssign = tracer:getLastAssign(action.start, action.finish)
            if lastAssign then
                tracer:getNode(lastAssign)
            end
            if tracer.nodes[action] then
                topNode = mainNode:merge(tracer.nodes[action])
            end
        end
        if action.filter then
            -- look into filter again
            guide.eachSource(action.filter, function (src)
                tracer.mark[src] = nil
            end)
            blockNode, topNode = tracer:lookIntoChild(action.filter, topNode:copy(), topNode:copy())
        end
        return topNode, outNode
    end)
    : case 'if'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        local hasElse
        local mainNode = topNode:copy()
        local blockNodes = {}
        for _, subBlock in ipairs(action) do
            tracer:resetCastsIndex(subBlock.start)
            local blockNode = mainNode:copy()
            if subBlock.filter then
                blockNode, mainNode = tracer:lookIntoChild(subBlock.filter, blockNode, mainNode)
            else
                hasElse = true
                mainNode:clear()
            end
            local mergedNode
            if subBlock[1] then
                tracer:lookIntoBlock(subBlock, subBlock.bstart, blockNode:copy())
                local neverReturn = subBlock.hasReturn
                                or  subBlock.hasGoTo
                                or  subBlock.hasBreak
                                or  subBlock.hasExit
                if neverReturn then
                    mergedNode = true
                else
                    local lastAssign = tracer:getLastAssign(subBlock.start, subBlock.finish)
                    if lastAssign then
                        tracer:getNode(lastAssign)
                    end
                    if tracer.nodes[subBlock] then
                        blockNodes[#blockNodes+1] = tracer.nodes[subBlock]
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
        return topNode, outNode
    end)
    : case 'getfield'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoChild(action.node, topNode)
        tracer:lookIntoChild(action.field, topNode)
        if tracer.getMap[action] then
            tracer.nodes[action] = topNode
            if outNode then
                topNode = topNode:copy():setTruthy()
                outNode = outNode:copy():setFalsy()
            end
        end
        return topNode, outNode
    end)
    : case 'getmethod'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoChild(action.node, topNode)
        tracer:lookIntoChild(action.method, topNode)
        if tracer.getMap[action] then
            tracer.nodes[action] = topNode
            if outNode then
                topNode = topNode:copy():setTruthy()
                outNode = outNode:copy():setFalsy()
            end
        end
        return topNode, outNode
    end)
    : case 'getindex'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoChild(action.node, topNode)
        tracer:lookIntoChild(action.index, topNode)
        if tracer.getMap[action] then
            tracer.nodes[action] = topNode
            if outNode then
                topNode = topNode:copy():setTruthy()
                outNode = outNode:copy():setFalsy()
            end
        end
        return topNode, outNode
    end)
    : case 'setfield'
    : case 'setmethod'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoChild(action.node, topNode)
        tracer:lookIntoChild(action.value, topNode)
        return topNode, outNode
    end)
    : case 'setglobal'
    : case 'setlocal'
    : case 'tablefield'
    : case 'tableexp'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoChild(action.value, topNode)
        return topNode, outNode
    end)
    : case 'setindex'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoChild(action.node, topNode)
        tracer:lookIntoChild(action.index, topNode)
        tracer:lookIntoChild(action.value, topNode)
        return topNode, outNode
    end)
    : case 'tableindex'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoChild(action.index, topNode)
        tracer:lookIntoChild(action.value, topNode)
        return topNode, outNode
    end)
    : case 'local'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoChild(action.value, topNode)
        -- special treat for `local tp = type(x)`
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
                local getVar = call.args[1]
                if  getVar
                and tracer.getMap[getVar] then
                    for _, ref in ipairs(action.ref) do
                        tracer:collectCare(ref)
                    end
                end
            end
        end
        return topNode, outNode
    end)
    : case 'return'
    : case 'table'
    : case 'callargs'
    : case 'list'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        for _, ret in ipairs(action) do
            tracer:lookIntoChild(ret, topNode:copy())
        end
        return topNode, outNode
    end)
    : case 'select'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoChild(action.vararg, topNode)
        return topNode, outNode
    end)
    : case 'function'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        tracer:lookIntoBlock(action, action.bstart, topNode:copy())
        return topNode, outNode
    end)
    : case 'paren'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        topNode, outNode = tracer:lookIntoChild(action.exp, topNode, outNode)
        return topNode, outNode
    end)
    : case 'call'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        if action.node.special == 'assert' and action.args and action.args[1] then
            for i = 2, #action.args do
                tracer:lookIntoChild(action.args[i], topNode, topNode:copy())
            end
            topNode = tracer:lookIntoChild(action.args[1], topNode:copy(), topNode:copy())
        end
        tracer:lookIntoChild(action.node, topNode)
        tracer:lookIntoChild(action.args, topNode)
        return topNode, outNode
    end)
    : case 'binary'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
        : call(function (tracer, action, topNode, outNode)
        if not action[1] or not action[2] then
            tracer:lookIntoChild(action[1], topNode)
            tracer:lookIntoChild(action[2], topNode)
            return topNode, outNode
        end
        if     action.op.type == 'and' then
            topNode = tracer:lookIntoChild(action[1], topNode, topNode:copy())
            topNode = tracer:lookIntoChild(action[2], topNode, topNode:copy())
        elseif action.op.type == 'or' then
            outNode = outNode or topNode:copy()
            local topNode1, outNode1 = tracer:lookIntoChild(action[1], topNode, outNode)
            local topNode2, outNode2 = tracer:lookIntoChild(action[2], outNode1, outNode1:copy())
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
                tracer:lookIntoChild(action[1], topNode)
                tracer:lookIntoChild(action[2], topNode)
                return topNode, outNode
            end
            if tracer.getMap[handler] then
                -- if x == y then
                topNode = tracer:lookIntoChild(handler, topNode, outNode)
                local checkerNode = vm.compileNode(checker)
                local checkerName = vm.getNodeName(checker)
                if checkerName then
                    topNode = topNode:copy()
                    if action.op.type == '==' then
                        topNode:narrow(tracer.uri, checkerName)
                        if outNode then
                            outNode:removeNode(checkerNode)
                        end
                    else
                        topNode:removeNode(checkerNode)
                        if outNode then
                            outNode:narrow(tracer.uri, checkerName)
                        end
                    end
                end
            elseif handler.type == 'call'
            and    checker.type == 'string'
            and    handler.node.special == 'type'
            and    handler.args
            and    handler.args[1]
            and    tracer.getMap[handler.args[1]] then
                -- if type(x) == 'string' then
                tracer:lookIntoChild(handler, topNode)
                topNode = topNode:copy()
                if action.op.type == '==' then
                    topNode:narrow(tracer.uri, checker[1])
                    if outNode then
                        outNode:remove(checker[1])
                    end
                else
                    topNode:remove(checker[1])
                    if outNode then
                        outNode:narrow(tracer.uri, checker[1])
                    end
                end
            elseif handler.type == 'getlocal'
            and    checker.type == 'string' then
                -- `local tp = type(x);if tp == 'string' then`
                local nodeValue = vm.getObjectValue(handler.node)
                if  nodeValue
                and nodeValue.type == 'select'
                and nodeValue.sindex == 1 then
                    local call = nodeValue.vararg
                    if  call
                    and call.type == 'call'
                    and call.node.special == 'type'
                    and call.args
                    and tracer.getMap[call.args[1]] then
                        if action.op.type == '==' then
                            topNode:narrow(tracer.uri, checker[1])
                            if outNode then
                                outNode:remove(checker[1])
                            end
                        else
                            topNode:remove(checker[1])
                            if outNode then
                                outNode:narrow(tracer.uri, checker[1])
                            end
                        end
                    end
                end
            end
        end
        tracer:lookIntoChild(action[1], topNode)
        tracer:lookIntoChild(action[2], topNode)
        return topNode, outNode
    end)
    : case 'unary'
    ---@param tracer   vm.tracer
    ---@param action   parser.object
    ---@param topNode  vm.node
    ---@param outNode? vm.node
    : call(function (tracer, action, topNode, outNode)
        if not action[1] then
            tracer:lookIntoChild(action[1], topNode)
            return topNode, outNode
        end
        if action.op.type == 'not' then
            outNode = outNode or topNode:copy()
            outNode, topNode = tracer:lookIntoChild(action[1], topNode, outNode)
            outNode = outNode:copy()
        end
        tracer:lookIntoChild(action[1], topNode)
        return topNode, outNode
    end)

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
    topNode, outNode = lookIntoChild(action.type, self, action, topNode, outNode)
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
            if action.type == 'do'
            or action.type == 'loop'
            or action.type == 'in'
            or action.type == 'repeat' then
                return
            end
        end
        if action.finish > start and self.assignMap[action] then
            return
        end
        ::CONTINUE::
    end
    self.nodes[block] = node
    if block.type == 'repeat' then
        self:lookIntoChild(block.filter, node)
    end
    if block.type == 'do'
    or block.type == 'loop'
    or block.type == 'in'
    or block.type == 'repeat' then
        self:lookIntoBlock(block.parent, block.finish, node)
    end
end

---@param source parser.object
function mt:calcNode(source)
    if self.getMap[source] then
        local lastAssign = self:getLastAssign(0, source.finish)
        if not lastAssign then
            return
        end
        if self.fastCalc then
            self.nodes[source] = vm.compileNode(lastAssign)
            return
        end
        self:calcNode(lastAssign)
        return
    end
    if self.assignMap[source] then
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

---@param mode tracer.mode
---@param source parser.object | vm.variable
---@param name string
---@return vm.tracer?
local function createTracer(mode, source, name)
    local node = vm.compileNode(source)
    local tracer = node._tracer
    if tracer then
        return tracer
    end
    local main
    if source.type == 'variable' then
        ---@cast source vm.variable
        main = guide.getParentBlock(source.base)
    else
        ---@cast source parser.object
        main = guide.getParentBlock(source)
    end
    if not main then
        return nil
    end
    tracer = setmetatable({
        source    = source,
        mode      = mode,
        name      = name,
        assigns   = {},
        assignMap = {},
        getMap    = {},
        careMap   = {},
        mark      = {},
        casts     = {},
        nodes     = {},
        main      = main,
        uri       = guide.getUri(main),
    }, mt)
    node._tracer = tracer

    if tracer.mode == 'local' then
        tracer:collectLocal()
    else
        tracer:collectGlobal()
    end

    return tracer
end

---@param source parser.object
---@return vm.node?
function vm.traceNode(source)
    local mode, base, name
    if vm.getGlobalNode(source) then
        base = vm.getGlobalBase(source)
        if not base then
            return nil
        end
        mode = 'global'
        name = base.global:getCodeName()
    else
        base = vm.getVariable(source)
        if not base then
            return nil
        end
        name = base:getCodeName()
        mode = 'local'
    end
    local tracer = createTracer(mode, base, name)
    if not tracer then
        return nil
    end
    local node = tracer:getNode(source)
    return node
end
