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
        return a.start < b.start
    end)
end


---@param pos  integer
---@param node vm.node
---@return vm.node
---@return parser.object?
function mt:_fastWard(pos, node)
    for i = self._index, #self._objs do
        local obj = self._objs[i]
        if obj.finish > pos then
            self._index = i
            return node, obj
        end
        if obj.type == 'getlocal' then
            self._callback(obj, node)
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

---@param exp      parser.object
---@param topNode  vm.node
---@param outNode? vm.node
---@return vm.node topNode
---@return vm.node outNode
function mt:_lookIntoExp(exp, topNode, outNode)
    if not exp then
        return topNode, outNode or topNode
    end
    if self._mark[exp] then
        return topNode, outNode or topNode
    end
    self._mark[exp] = true
    local top = self._objs[self._index]
    if not top then
        return topNode, outNode or topNode
    end
    if     exp.type == 'function' then
        self:_launchBlock(exp, topNode:copy())
    elseif exp.type == 'unary' then
        if not exp[1] then
            goto RETURN
        end
        if exp.op.type == 'not' then
            outNode = outNode or topNode:copy()
            outNode, topNode = self:_lookIntoExp(exp[1], topNode, outNode)
        end
    elseif exp.type == 'binary' then
        if not exp[1] or not exp[2] then
            goto RETURN
        end
        if     exp.op.type == 'and' then
            topNode = self:_lookIntoExp(exp[1], topNode)
            topNode = self:_lookIntoExp(exp[2], topNode)
        elseif exp.op.type == 'or' then
            outNode = outNode or topNode:copy()
            local topNode1, outNode1 = self:_lookIntoExp(exp[1], topNode, outNode)
            local topNode2, outNode2 = self:_lookIntoExp(exp[2], outNode1, outNode1:copy())
            topNode = vm.createNode(topNode1, topNode2)
            outNode = outNode2:copy()
        elseif exp.op.type == '=='
        or     exp.op.type == '~=' then
            local handler, checker
            for i = 1, 2 do
                if guide.isLiteral(exp[i]) then
                    checker = exp[i]
                    handler = exp[3-i] -- Copilot tells me use `3-i` instead of `i%2+1`
                end
            end
            if not handler then
                goto RETURN
            end
            if  handler.type == 'getlocal'
            and handler.node == self._loc then
                -- if x == y then
                self:_fastWard(exp.finish, topNode:copy())
                local checkerNode = vm.compileNode(checker)
                if exp.op.type == '==' then
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
            elseif handler.type == 'call'
            and    checker.type == 'string'
            and    handler.node.special == 'type'
            and    handler.args
            and    handler.args[1]
            and    handler.args[1].type == 'getlocal'
            and    handler.args[1].node == self._loc then
                -- if type(x) == 'string' then
                self:_fastWard(exp.finish, topNode:copy())
                if exp.op.type == '==' then
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
                    and call.args[1].node == self._loc then
                        -- `local tp = type(x);if tp == 'string' then`
                        if exp.op.type == '==' then
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
    elseif exp.type == 'getlocal' then
        if exp.node == self._loc then
            topNode = self:_fastWard(exp.finish, topNode)
            topNode = topNode:copy():setTruthy()
            if outNode then
                outNode:setFalsy()
            end
        end
    elseif exp.type == 'paren' then
        topNode, outNode = self:_lookIntoExp(exp.exp, topNode, outNode)
    elseif exp.type == 'getindex' then
        self:_lookIntoExp(exp.index, topNode)
    elseif exp.type == 'table' then
        for _, field in ipairs(exp) do
            self:_lookIntoAction(field, topNode)
        end
    end
    ::RETURN::
    topNode = self:_fastWard(exp.finish, topNode)
    return topNode, outNode or topNode
end

---@param action   parser.object
---@param topNode  vm.node
---@return vm.node topNode
function mt:_lookIntoAction(action, topNode)
    if not action then
        return topNode
    end
    if self._mark[action] then
        return topNode
    end
    self._mark[action] = true
    local top = self._objs[self._index]
    if not top then
        return topNode
    end
    if  not guide.isInRange(action, top.finish)
    -- trick for `local tp = type(x);if tp == 'string' then`
    and action.type ~= 'binary' then
        return topNode
    end
    local value = vm.getObjectValue(action)
    if value then
        self:_lookIntoExp(value, topNode:copy())
    end
    if action.type == 'setlocal' then
        local newTopNode = self._callback(action, topNode)
        if newTopNode then
            topNode = newTopNode
        end
    elseif action.type == 'function' then
        self:_launchBlock(action, topNode:copy())
    elseif action.type == 'loop'
    or     action.type == 'in'
    or     action.type == 'repeat'
    or     action.type == 'for' then
        topNode = self:_launchBlock(action, topNode:copy())
    elseif action.type == 'while' then
        local blockNode, mainNode = self:_lookIntoExp(action.filter, topNode:copy(), topNode:copy())
        if action.filter then
            self:_fastWard(action.filter.finish, blockNode)
        end
        blockNode = self:_launchBlock(action, blockNode:copy())
        if mainNode then
            topNode = mainNode:merge(blockNode)
        end
    elseif action.type == 'if' then
        local hasElse
        local mainNode = topNode:copy()
        local blockNodes = {}
        for _, subBlock in ipairs(action) do
            local blockNode = mainNode:copy()
            if subBlock.filter then
                blockNode, mainNode = self:_lookIntoExp(subBlock.filter, blockNode, mainNode)
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
    elseif action.type == 'call' then
        if action.node.special == 'assert' and action.args and action.args[1] then
            topNode = self:_lookIntoExp(action.args[1], topNode)
        elseif action.args then
            for _, arg in ipairs(action.args) do
                self:_lookIntoExp(arg, topNode)
            end
        end
    elseif action.type == 'return' then
        for _, rtn in ipairs(action) do
            self:_lookIntoExp(rtn, topNode)
        end
    end
    topNode = self:_fastWard(action.finish, topNode)
    return topNode
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
        if (action.range or action.finish) < top.finish then
            goto CONTINUE
        end
        topNode = self:_lookIntoAction(action, topNode)
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
        _mark     = {},
        _callback = callback,
    }, mt)

    self:_collect()

    if #self._objs == 0 then
        return
    end
    local main = guide.getParentBlock(loc)
    if not main then
        return
    end
    local topNode = self:_launchBlock(main, vm.getNode(loc):copy())
    self:_fastWard(math.maxinteger, topNode)
end
