---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'

---@alias vm.runner.callback fun(src: parser.object, node: vm.node)

---@class vm.runner
---@field _loc      parser.object
---@field _objs     parser.object[]
---@field _callback vm.runner.callback
---@field _mark     table
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
        return (a.range or a.finish) < (b.range or b.start)
    end)
end


---@param pos  integer
---@param node vm.node
---@return vm.node
---@return parser.object?
function mt:_fastWard(pos, node)
    for i = self._index, #self._objs do
        local obj = self._objs[i]
        if (obj.range or obj.finish) > pos then
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
    self._index = #self._objs + 1
    return node, nil
end

---@param action   parser.object
---@param topNode  vm.node
---@param outNode? vm.node
---@return vm.node
function mt:_lookInto(action, topNode, outNode)
    if not action then
        return topNode, outNode
    end
    if self._mark[action] then
        return topNode, outNode
    end
    self._mark[action] = true
    local top = self._objs[self._index]
    if not top then
        return topNode, outNode
    end
    if  not guide.isInRange(action, top.finish)
    -- trick for `local tp = type(x);if tp == 'string' then`
    and action.type ~= 'binary' then
        return topNode, outNode
    end
    local set
    local value = vm.getObjectValue(action)
    if value then
        set = action
        action = value
    end
    if     action.type == 'function'
    or     action.type == 'loop'
    or     action.type == 'in'
    or     action.type == 'repeat'
    or     action.type == 'for' then
        self:_launchBlock(action, topNode:copy())
    elseif action.type == 'while' then
        local blockNode, mainNode = self:_lookInto(action.filter, topNode:copy(), topNode:copy())
        if action.filter then
            self:_fastWard(action.filter.finish, blockNode)
        end
        self:_launchBlock(action, blockNode:copy())
        topNode = mainNode
    elseif action.type == 'if' then
        local hasElse
        local mainNode = topNode:copy()
        local blockNodes = {}
        for _, subBlock in ipairs(action) do
            local blockNode = mainNode:copy()
            if subBlock.filter then
                blockNode, mainNode = self:_lookInto(subBlock.filter, blockNode, mainNode)
                self:_fastWard(subBlock.filter.finish, blockNode)
            else
                hasElse = true
                mainNode:clear()
            end
            blockNode = self:_launchBlock(subBlock, blockNode:copy())
            local neverReturn = subBlock.hasReturn
                            or  subBlock.hasGoTo
                            or  subBlock.hasBreak
                            or  subBlock.hasError
            if not neverReturn then
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
            outNode = outNode or topNode:copy()
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
            local topNode2, outNode2 = self:_lookInto(action[2], outNode1, outNode1:copy())
            topNode = vm.createNode(topNode1, topNode2)
            outNode = outNode2
        elseif action.op.type == '=='
        or     action.op.type == '~=' then
            local exp, checker
            for i = 1, 2 do
                if guide.isLiteral(action[i]) then
                    checker = action[i]
                    exp     = action[3-i] -- Copilot tells me use `3-i` instead of `i%2+1`
                end
            end
            if not exp then
                goto RETURN
            end
            if  exp.type == 'getlocal'
            and exp.node == self._loc then
                -- if x == y then
                self:_fastWard(exp.finish, topNode:copy())
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
            elseif exp.type == 'call'
            and    checker.type == 'string'
            and    exp.node.special == 'type'
            and    exp.args
            and    exp.args[1]
            and    exp.args[1].type == 'getlocal'
            and    exp.args[1].node == self._loc then
                -- if type(x) == 'string' then
                self:_fastWard(exp.finish, topNode:copy())
                if action.op.type == '==' then
                    topNode:narrow(checker[1])
                    if outNode then
                        outNode:remove(checker[1])
                    end
                else
                    topNode:remove(checker[1])
                    if outNode then
                        outNode:narrow(checker[1])
                    end
                end
            elseif exp.type == 'getlocal'
            and    checker.type == 'string' then
                local nodeValue = vm.getObjectValue(exp.node)
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
                    and call.args[1].node == self._loc then
                        -- `local tp = type(x);if tp == 'string' then`
                        if action.op.type == '==' then
                            topNode:narrow(checker[1])
                            if outNode then
                                outNode:remove(checker[1])
                            end
                        else
                            topNode:remove(checker[1])
                            if outNode then
                                outNode:narrow(checker[1])
                            end
                        end
                    end
                end
            end
        end
    elseif action.type == 'call' then
        if action.node.special == 'assert' and action.args and action.args[1] then
            topNode = self:_lookInto(action.args[1], topNode)
        elseif action.args then
            for _, arg in ipairs(action.args) do
                self:_lookInto(arg, topNode)
            end
        end
    else
        guide.eachSourceContain(action, top.finish, function(source)
            self:_lookInto(source, topNode)
        end)
    end
    ::RETURN::
    topNode = self:_fastWard(action.finish, topNode)
    if set then
        topNode = self:_fastWard(set.range or set.finish, topNode)
    end
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
        if (action.range or action.finish) < (top.range or top.finish) then
            goto CONTINUE
        end
        topNode = self:_lookInto(action, topNode)
        topNode, top = self:_fastWard(action.range or action.finish, topNode)
        if not top then
            return topNode
        end
        ::CONTINUE::
    end
    -- `x = function () end`: don't touch `x` in the end of function
    topNode = self:_fastWard(block.finish - 1, topNode)
    return topNode
end

---@param loc parser.object
---@param callback vm.runner.callback
function vm.launchRunner(loc, callback)
    local self = setmetatable({
        _loc      = loc,
        _objs     = {},
        _mark     = {},
        _callback = callback,
    }, mt)

    self:_collect()

    if #self._objs == 0 then
        return
    end

    self:_launchBlock(guide.getParentBlock(loc), vm.getNode(loc):copy())
end
