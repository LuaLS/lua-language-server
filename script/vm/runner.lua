---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'
local linked    = require 'linked-table'

---@alias vm.runner.callback fun(src: parser.object, node?: vm.node)

---@class vm.runner
---@field _loc      parser.object
---@field _casts    parser.object[]
---@field _callback vm.runner.callback
---@field _mark     table
---@field _has      table<parser.object, true>
---@field _main     parser.object
---@field _uri      uri
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

---@param obj parser.object
function mt:_markHas(obj)
    while true do
        if self._has[obj] then
            return
        end
        self._has[obj] = true
        if obj == self._main then
            return
        end
        obj = obj.parent
    end
end

function mt:collect()
    local startPos  = self._loc.start
    local finishPos = 0

    for _, ref in ipairs(self._loc.ref) do
        if ref.type == 'getlocal'
        or ref.type == 'setlocal' then
            self:_markHas(ref)
            if ref.finish > finishPos then
                finishPos = ref.finish
            end
        end
    end

    local casts = self:_getCasts()
    for _, cast in ipairs(casts) do
        if  cast.loc[1] == self._loc[1]
        and cast.start > startPos
        and cast.finish < finishPos
        and guide.getLocal(self._loc, self._loc[1], cast.start) == self._loc then
            self._casts[#self._casts+1] = cast
        end
    end
end

---@param pos integer
---@param topNode vm.node
---@return vm.node
function mt:_fastWardCasts(pos, topNode)
    for i = self._index, #self._casts do
        local action = self._casts[i]
        if action.start > pos then
            self._index = i
            return topNode
        end
        topNode = topNode:copy()
        for _, cast in ipairs(action.casts) do
            if     cast.mode == '+' then
                if cast.optional then
                    topNode:addOptional()
                end
                if cast.extends then
                    topNode:merge(vm.compileNode(cast.extends))
                end
            elseif cast.mode == '-' then
                if cast.optional then
                    topNode:removeOptional()
                end
                if cast.extends then
                    topNode:removeNode(vm.compileNode(cast.extends))
                end
            else
                if cast.extends then
                    topNode:clear()
                    topNode:merge(vm.compileNode(cast.extends))
                end
            end
        end
    end
    self._index = self._index + 1
    return topNode
end

---@param action   parser.object
---@param topNode  vm.node
---@param outNode? vm.node
---@return vm.node topNode
---@return vm.node outNode
function mt:_lookIntoChild(action, topNode, outNode)
    if not self._has[action]
    or self._mark[action] then
        return topNode, topNode or outNode
    end
    self._mark[action] = true
    topNode = self:_fastWardCasts(action.start, topNode)
    if     action.type == 'getlocal' then
        if action.node == self._loc then
            self._callback(action, topNode)
            if outNode then
                topNode = topNode:copy():setTruthy()
                outNode = outNode:copy():setFalsy()
            end
        end
    elseif action.type == 'function' then
        self:lookIntoBlock(action, topNode:copy())
    elseif action.type == 'unary' then
        if not action[1] then
            goto RETURN
        end
        if action.op.type == 'not' then
            outNode = outNode or topNode:copy()
            outNode, topNode = self:_lookIntoChild(action[1], topNode, outNode)
            outNode = outNode:copy()
        end
    elseif action.type == 'binary' then
        if not action[1] or not action[2] then
            goto RETURN
        end
        if     action.op.type == 'and' then
            topNode = self:_lookIntoChild(action[1], topNode, topNode:copy())
            topNode = self:_lookIntoChild(action[2], topNode, topNode:copy())
        elseif action.op.type == 'or' then
            outNode = outNode or topNode:copy()
            local topNode1, outNode1 = self:_lookIntoChild(action[1], topNode, outNode)
            local topNode2, outNode2 = self:_lookIntoChild(action[2], outNode1, outNode1:copy())
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
            and handler.node == self._loc then
                -- if x == y then
                topNode = self:_lookIntoChild(handler, topNode, outNode)
                local checkerNode = vm.compileNode(checker)
                local checkerName = vm.getNodeName(checker)
                if checkerName then
                    topNode = topNode:copy()
                    if action.op.type == '==' then
                        topNode:narrow(self._uri, checkerName)
                        if outNode then
                            outNode:removeNode(checkerNode)
                        end
                    else
                        topNode:removeNode(checkerNode)
                        if outNode then
                            outNode:narrow(self._uri, checkerName)
                        end
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
                self:_lookIntoChild(handler, topNode:copy())
                if action.op.type == '==' then
                    topNode:narrow(self._uri, checker[1])
                    if outNode then
                        outNode:remove(checker[1])
                    end
                else
                    topNode:remove(checker[1])
                    if outNode then
                        outNode:narrow(self._uri, checker[1])
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
                        if action.op.type == '==' then
                            topNode:narrow(self._uri, checker[1])
                            if outNode then
                                outNode:remove(checker[1])
                            end
                        else
                            topNode:remove(checker[1])
                            if outNode then
                                outNode:narrow(self._uri, checker[1])
                            end
                        end
                    end
                end
            end
        end
    elseif action.type == 'loop'
    or     action.type == 'in'
    or     action.type == 'repeat'
    or     action.type == 'for' then
        topNode = self:lookIntoBlock(action, topNode:copy())
    elseif action.type == 'while' then
        local blockNode, mainNode
        if action.filter then
            blockNode, mainNode = self:_lookIntoChild(action.filter, topNode:copy(), topNode:copy())
        else
            blockNode = topNode:copy()
            mainNode  = topNode:copy()
        end
        blockNode = self:lookIntoBlock(action, blockNode:copy())
        topNode = mainNode:merge(blockNode)
        if action.filter then
            -- look into filter again
            guide.eachSource(action.filter, function (src)
                self._mark[src] = nil
            end)
            blockNode, topNode = self:_lookIntoChild(action.filter, topNode:copy(), topNode:copy())
        end
    elseif action.type == 'if' then
        local hasElse
        local mainNode = topNode:copy()
        local blockNodes = {}
        for _, subBlock in ipairs(action) do
            local blockNode = mainNode:copy()
            if subBlock.filter then
                blockNode, mainNode = self:_lookIntoChild(subBlock.filter, blockNode, mainNode)
            else
                hasElse = true
                mainNode:clear()
            end
            blockNode = self:lookIntoBlock(subBlock, blockNode:copy())
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
            topNode = self:_lookIntoChild(action.args[1], topNode, topNode:copy())
        end
    elseif action.type == 'paren' then
        topNode, outNode = self:_lookIntoChild(action.exp, topNode, outNode)
    elseif action.type == 'setlocal' then
        if action.node == self._loc then
            if action.value then
                self:_lookIntoChild(action.value, topNode)
            end
            topNode = self._callback(action, topNode)
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
                and getLoc.node == self._loc then
                    for _, ref in ipairs(action.ref) do
                        self:_markHas(ref)
                    end
                end
            end
        end
    end
    ::RETURN::
    guide.eachChild(action, function (src)
        if self._has[src] then
            self:_lookIntoChild(src, topNode)
        end
    end)
    return topNode, outNode or topNode
end

---@param block   parser.object
---@param topNode  vm.node
---@return vm.node topNode
function mt:lookIntoBlock(block, topNode)
    if not self._has[block] then
        return topNode
    end
    for _, action in ipairs(block) do
        if self._has[action] then
            topNode = self:_lookIntoChild(action, topNode)
        end
    end
    topNode = self:_fastWardCasts(block.finish, topNode)
    return topNode
end

---@alias runner.info { target?: parser.object, loc: parser.object }

---@type thread?
local masterRunner = nil
---@type table<thread, runner.info>
local runnerInfo = setmetatable({}, {
    __mode = 'k',
    __index = function (self, k)
        self[k] = {}
        return self[k]
    end
})
---@type linked-table?
local runnerList = nil

---@async
---@param info runner.info
local function waitResolve(info)
    while true do
        if not info.target then
            break
        end
        if info.target.node == info.loc then
            break
        end
        local node = vm.getNode(info.target)
        if node and node.resolved then
            break
        end
        coroutine.yield()
    end
    info.target = nil
end

local function resolveDeadLock()
    if not runnerList then
        return
    end

    ---@type runner.info[]
    local infos = {}
    for runner in runnerList:pairs() do
        local info = runnerInfo[runner]
        infos[#infos+1] = info
    end

    table.sort(infos, function (a, b)
        local uriA = guide.getUri(a.loc)
        local uriB = guide.getUri(b.loc)
        if uriA ~= uriB then
            return uriA < uriB
        end
        return a.loc.start < b.loc.start
    end)

    local firstTarget = infos[1].target
    ---@cast firstTarget -?
    local firstNode = vm.setNode(firstTarget, vm.getNode(firstTarget):copy(), true)
    firstNode.resolved = true
    firstNode:setData('resolvedByDeadLock', true)
end

---@async
---@param loc parser.object
---@param start fun()
---@param finish fun()
---@param callback vm.runner.callback
function vm.launchRunner(loc, start, finish, callback)
    local locNode = vm.getNode(loc)
    if not locNode then
        return
    end

    local function resumeMaster()
        for i = 1, 10010 do
            if not runnerList or runnerList:getSize() == 0 then
                return
            end
            local deadLock = true
            for runner in runnerList:pairs() do
                local info = runnerInfo[runner]
                local waitingSource = info.target
                if coroutine.status(runner) == 'suspended' then
                    local suc, err = coroutine.resume(runner)
                    if not suc then
                        log.error(debug.traceback(runner, err))
                    end
                else
                    runnerList:pop(runner)
                    deadLock = false
                end
                if not waitingSource or waitingSource ~= info.target then
                    deadLock = false
                end
            end
            if runnerList:getSize() == 0 then
                return
            end
            if deadLock then
                resolveDeadLock()
            end
            if i == 10000 then
                local lines = {}
                lines[#lines+1] = 'Dead lock:'
                for runner in runnerList:pairs() do
                    local info = runnerInfo[runner]
                    lines[#lines+1] = '==============='
                    lines[#lines+1] = string.format('Runner `%s` at %d(%s)'
                        , info.loc[1]
                        , info.loc.start
                        , guide.getUri(info.loc)
                    )
                    lines[#lines+1] = string.format('Waiting `%s` at %d(%s)'
                        , info.target[1]
                        , info.target.start
                        , guide.getUri(info.target)
                    )
                end
                local msg = table.concat(lines, '\n')
                log.error(msg)
            end
        end
    end

    local function launch()
        start()
        if not loc.ref then
            finish()
            return
        end
        local main = guide.getParentBlock(loc)
        if not main then
            finish()
            return
        end
        local self = setmetatable({
            _loc      = loc,
            _casts    = {},
            _mark     = {},
            _has      = {},
            _main     = main,
            _uri      = guide.getUri(loc),
            _callback = callback,
        }, mt)

        self:collect()

        self:lookIntoBlock(main, locNode:copy())

        locNode:setData('runner', nil)

        finish()
    end

    local co = coroutine.create(launch)
    locNode:setData('runner', co)
    local info = runnerInfo[co]
    info.loc = loc

    if not runnerList then
        runnerList = linked()
    end
    runnerList:pushTail(co)

    if not masterRunner then
        masterRunner = coroutine.running()
        resumeMaster()
        masterRunner = nil
        return
    end
end

---@async
---@param source parser.object
function vm.waitResolveRunner(source)
    local myNode = vm.getNode(source)
    if myNode and myNode.resolved then
        return
    end

    local running = coroutine.running()
    if not masterRunner or running == masterRunner then
        return
    end

    local info = runnerInfo[running]

    local targetLoc
    if source.type == 'getlocal' then
        targetLoc = source.node
    elseif source.type == 'local'
    or     source.type == 'self' then
        targetLoc = source
        info.target = info.target or source
    else
        error('Unknown source type: ' .. source.type)
    end

    local targetNode = vm.getNode(targetLoc)
    if not targetNode then
        -- Wait for compiling local by `compiler`
        return
    end

    waitResolve(info)
end

---@param source parser.object
function vm.storeWaitingRunner(source)
    local sourceNode = vm.getNode(source)
    if sourceNode and sourceNode.resolved then
        return
    end

    local running = coroutine.running()
    local info = runnerInfo[running]
    info.target = source
end
