---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'

---@alias vm.runner.callback fun(src: parser.object, node: vm.node)

---@class vm.runner
---@field _loc      parser.object
---@field _objs     parser.object[]
---@field _callback vm.runner.callback
local mt = {}
mt.__index = mt
mt._index = 1

---@return parser.object[]
function mt:_getCasts()
    local root = guide.getRoot(self._loc)
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

function mt:_collect()
    local startPos  = self._loc.start
    local finishPos = 0

    for _, ref in ipairs(self._loc.ref) do
        if ref.type == 'getlocal'
        or ref.type == 'setlocal' then
            self._objs[#self._objs+1] = ref
            if ref.start > finishPos then
                finishPos = ref.start
            end
        end
    end

    if #self._objs == 0 then
        return
    end

    local casts = self:_getCasts()
    for _, cast in ipairs(casts) do
        if  cast.loc[1] == self._loc[1]
        and cast.start > startPos
        and cast.finish < finishPos
        and guide.getLocal(self._loc, self._loc[1], cast.start) == self._loc then
            self._objs[#self._objs+1] = cast
        end
    end

    table.sort(self._objs, function (a, b)
        return (a.range or a.start) < (b.range or b.start)
    end)
end


---@param pos  integer
---@param node vm.node
---@return vm.node
---@return parser.object?
function mt:_fastWard(pos, node)
    for i = self._index, #self._objs do
        local obj = self._objs[i]
        if obj.start > pos then
            self._index = i
            return node, obj
        end
        if obj.type == 'getlocal' then
            self._callback(obj, node)
        elseif obj.type == 'setlocal' then
            local newNode = self._callback(obj, node)
            if newNode then
                node = newNode:copy()
            end
        elseif obj.type == 'doc.cast' then
            node = node:copy()
            for _, cast in ipairs(obj.casts) do
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
    end
    self._index = math.huge
    return node, nil
end

---@param action   parser.object
---@param topNode  vm.node
---@param outNode? vm.node
---@return vm.node
function mt:_lookInto(action, topNode, outNode)
    action = vm.getObjectValue(action) or action
    if     action.type == 'function'
    or     action.type == 'loop'
    or     action.type == 'in'
    or     action.type == 'repeat'
    or     action.type == 'for' then
        self:_launchBlock(action, topNode:copy())
    elseif action.type == 'while' then
        local blockNode, mainNode = self:_lookInto(action.filter, topNode:copy(), topNode:copy())
        self:_fastWard(action.filter.finish, blockNode)
        self:_launchBlock(action, blockNode:copy())
        topNode = mainNode
    elseif action.type == 'if' then
        local mainNode  = topNode:copy()
        local blockNode = topNode:copy()
        for _, subBlock in ipairs(action) do
            if subBlock.type == 'ifblock' then
                blockNode, mainNode = self:_lookInto(subBlock.filter, blockNode, mainNode)
                self:_fastWard(subBlock.filter.finish, blockNode)
                blockNode = self:_launchBlock(subBlock, blockNode:copy())
                local neverReturn = subBlock.hasReturn
                                or  subBlock.hasGoTo
                                or  subBlock.hasBreak
                if not neverReturn then
                    mainNode:merge(blockNode)
                end
            end
        end
        topNode = mainNode
    elseif action.type == 'getlocal' then
        if action.node == self._loc then
            topNode = self:_fastWard(action.finish, topNode)
            topNode = topNode:copy():setTruthy()
            if outNode then
                outNode:setFalsy()
            end
        end
    elseif action.type == 'unary' then
        if not action[1] then
            goto RETURN
        end
        if action.op.type == 'not' then
            outNode, topNode = self:_lookInto(action[1], topNode, outNode)
        end
    elseif action.type == 'binary' then
        if not action[1] or not action[2] then
            goto RETURN
        end
        if     action.op.type == 'and' then
            topNode = self:_lookInto(action[1], topNode)
            topNode = self:_lookInto(action[2], topNode)
        elseif action.op.type == 'or' then
            outNode = outNode or topNode:copy()
            local topNode1, outNode1 = self:_lookInto(action[1], topNode, outNode)
            local topNode2, outNode2 = self:_lookInto(action[2], outNode1, outNode)
            topNode = vm.createNode(topNode1, topNode2)
            outNode = outNode2
        elseif action.op.type == '=='
        or     action.op.type == '~=' then
            local loc, checker
            for i = 1, 2 do
                if action[i].type == 'getlocal' and action[i].node == self._loc then
                    loc = action[i]
                    checker = action[3-i] -- Copilot tells me use `3-i` instead of `i%2+1`
                else
                    loc = action[3-i]
                    checker = action[i]
                end
            end
            if loc then
                if guide.isLiteral(checker) then
                    local checkerNode = vm.compileNode(checker)
                    if action.op.type == '==' then
                        topNode = checkerNode
                        if outNode then
                            outNode:removeNode(topNode)
                        end
                    else
                        topNode:removeNode(checkerNode)
                        if outNode then
                            outNode = checkerNode
                        end
                    end
                end
            end
        end
    elseif action.type == 'call' then
        if action.node.special == 'assert' and action.args and action.args[1] then
            topNode = self:_lookInto(action.args[1], topNode)
        end
    end
    ::RETURN::
    topNode = self:_fastWard(action.finish, topNode)
    return topNode, outNode
end

---@param block parser.object
---@param node  vm.node
---@return vm.node
function mt:_launchBlock(block, node)
    local topNode, top = self:_fastWard(block.start, node)
    if not top then
        return topNode
    end
    for _, action in ipairs(block) do
        local finish = action.range or action.finish
        if finish < top.start then
            goto CONTINUE
        end
        topNode = self:_lookInto(action, topNode)
        topNode, top = self:_fastWard(action.finish, topNode)
        if not top then
            return topNode
        end
        ::CONTINUE::
    end
    topNode = self:_fastWard(block.finish, topNode)
    return topNode
end

---@param loc parser.object
---@param callback vm.runner.callback
function vm.launchRunner(loc, callback)
    local self = setmetatable({
        _loc      = loc,
        _objs     = {},
        _callback = callback,
    }, mt)

    self:_collect()

    if #self._objs == 0 then
        return
    end

    self:_launchBlock(guide.getParentBlock(loc), vm.getNode(loc):copy())
end
