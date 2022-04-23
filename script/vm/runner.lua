---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'
local globalMgr = require 'vm.global-manager'

---@class vm.runner
---@field loc       parser.object
---@field mainBlock parser.object
---@field blocks    table<parser.object, true>
---@field steps     vm.runner.step[]
local mt = {}
mt.__index = mt
mt.index = 1

---@class parser.object
---@field _hasSorted boolean

---@class vm.runner.step
---@field type    'truthy' | 'falsy' | 'as' | 'add' | 'remove' | 'object' | 'save' | 'load' | 'merge'
---@field pos     integer
---@field order?  integer
---@field node?   vm.node
---@field object? parser.object
---@field name?   string
---@field tag?    string
---@field copy?   boolean
---@field ref1?   vm.runner.step
---@field ref2?   vm.runner.step

---@param filter    parser.object
---@param outStep   vm.runner.step
---@param blockStep vm.runner.step
function mt:_compileNarrowByFilter(filter, outStep, blockStep)
    if not filter then
        return
    end
    if filter.type == 'paren' then
        if filter.exp then
            self:_compileNarrowByFilter(filter.exp, outStep, blockStep)
        end
        return
    end
    if filter.type == 'unary' then
        if not filter.op
        or not filter[1] then
            return
        end
        if filter.op.type == 'not' then
            local exp = filter[1]
            if exp.type == 'getlocal' and exp.node == self.loc then
                self.steps[#self.steps+1] = {
                    type  = 'truthy',
                    pos   = filter.finish,
                    ref1  = outStep,
                }
                self.steps[#self.steps+1] = {
                    type  = 'falsy',
                    copy  = true,
                    pos   = filter.finish,
                    ref1  = blockStep,
                }
            end
        end
    elseif filter.type == 'binary' then
        if not filter.op
        or not filter[1]
        or not filter[2] then
            return
        end
        if filter.op.type == 'and' then
            self:_compileNarrowByFilter(filter[1], outStep, blockStep)
            self:_compileNarrowByFilter(filter[2], outStep, blockStep)
        end
        if filter.op.type == 'or' then
            local dummyStep = {
                type  = 'load',
                tag   = 'dummy',
                copy  = true,
                ref1  = outStep,
                pos   = filter.start - 1,
            }
            self.steps[#self.steps+1] = dummyStep
            self:_compileNarrowByFilter(filter[1], outStep, dummyStep)
            dummyStep = {
                type  = 'load',
                tag   = 'dummy',
                copy  = true,
                ref1  = outStep,
                pos   = filter.op.finish,
            }
            self.steps[#self.steps+1] = dummyStep
            self:_compileNarrowByFilter(filter[2], outStep, dummyStep)
            self.steps[#self.steps+1] = {
                type  = 'load',
                tag   = 'reset',
                ref1  = blockStep,
                pos   = filter.finish,
            }
        end
        if filter.op.type == '=='
        or filter.op.type == '~=' then
            local loc, exp
            for i = 1, 2 do
                loc = filter[i]
                if loc.type == 'getlocal' and loc.node == self.loc then
                    exp = filter[i % 2 + 1]
                    break
                end
            end
            if not loc or not exp then
                return
            end
            if guide.isLiteral(exp) then
                if filter.op.type == '==' then
                    self.steps[#self.steps+1] = {
                        type  = 'remove',
                        name  = exp.type,
                        pos   = filter.finish,
                        ref1  = outStep,
                    }
                    self.steps[#self.steps+1] = {
                        type  = 'as',
                        name  = exp.type,
                        copy  = true,
                        pos   = filter.finish,
                        ref1  = blockStep,
                    }
                end
                if filter.op.type == '~=' then
                    self.steps[#self.steps+1] = {
                        type  = 'as',
                        name  = exp.type,
                        pos   = filter.finish,
                        ref1  = outStep,
                    }
                    self.steps[#self.steps+1] = {
                        type  = 'remove',
                        name  = exp.type,
                        copy  = true,
                        pos   = filter.finish,
                        ref1  = blockStep,
                    }
                end
            end
        end
    else
        if filter.type == 'getlocal' and filter.node == self.loc then
            self.steps[#self.steps+1] = {
                type  = 'falsy',
                pos   = filter.finish,
                ref1  = outStep,
            }
            self.steps[#self.steps+1] = {
                type  = 'truthy',
                copy  = true,
                pos   = filter.finish,
                ref1  = blockStep,
            }
        end
    end
end

---@param block parser.object
function mt:_compileBlock(block)
    if self.blocks[block] then
        return
    end
    self.blocks[block] = true
    if block == self.mainBlock then
        return
    end

    local parentBlock = guide.getParentBlock(block)
    self:_compileBlock(parentBlock)

    if block.type == 'if' then
        ---@type vm.runner.step[]
        local finals = {}
        for _, childBlock in ipairs(block) do
            local outStep = {
                type  = 'save',
                tag   = 'out',
                copy  = true,
                pos   = block.start,
            }
            self.steps[#self.steps+1] = outStep
            local blockStep = {
                type  = 'load',
                tag   = 'block',
                copy  = true,
                pos   = childBlock.start,
            }
            self.steps[#self.steps+1] = blockStep
            self:_compileNarrowByFilter(childBlock.filter, outStep, blockStep)
            if  not childBlock.hasReturn
            and not childBlock.hasGoTo
            and not childBlock.hasBreak then
                finals[#finals+1] = blockStep
            end
            self.steps[#self.steps+1] = {
                type   = 'load',
                tag    = 'final',
                ref1   = outStep,
                pos    = childBlock.finish,
            }
        end
        for i, final in ipairs(finals) do
            self.steps[#self.steps+1] = {
                type  = 'merge',
                ref2  = final,
                pos   = block.finish,
            }
        end
    end

    if block.type == 'function'
    or block.type == 'while'
    or block.type == 'loop'
    or block.type == 'in'
    or block.type == 'repeat'
    or block.type == 'for' then
        self.steps[#self.steps+1] = {
            type  = 'load',
            pos   = block.start,
        }
        local savePoint = {
            type  = 'save',
            copy  = true,
            pos   = block.start,
        }
        self.steps[#self.steps+1] = savePoint
        self.steps[#self.steps+1] = {
            type = 'load',
            pos  = block.finish,
            ref1 = savePoint,
        }
    end
end

function mt:_preCompile()
    for _, ref in ipairs(self.loc.ref) do
        self.steps[#self.steps+1] = {
            type   = 'object',
            object = ref,
            pos    = ref.range or ref.start,
        }
        local block = guide.getParentBlock(ref)
        self:_compileBlock(block)
    end
    for i, step in ipairs(self.steps) do
        if step.type ~= 'object' then
            step.order = i
        end
    end
    table.sort(self.steps, function (a, b)
        if a.pos == b.pos then
            return (a.order or 0) < (b.order or 0)
        else
            return a.pos < b.pos
        end
    end)
end

---@param loc  parser.object
---@param node vm.node
---@return vm.node
local function checkAssert(loc, node)
    local parent = loc.parent
    if parent.type == 'binary' then
        if parent.op and (parent.op.type == '~=' or parent.op.type == '==') then
            local exp
            for i = 1, 2 do
                if parent[i] == loc then
                    exp = parent[i % 2 + 1]
                end
            end
            if exp and guide.isLiteral(exp) then
                local callargs = parent.parent
                if  callargs.type == 'callargs'
                and callargs.parent.node.special == 'assert'
                and callargs[1] == parent then
                    if parent.op.type == '~=' then
                        node:remove(exp.type)
                    end
                    if parent.op.type == '==' then
                        node = vm.compileNode(exp)
                    end
                end
            end
        end
    end
    if  parent.type == 'callargs'
    and parent.parent.node.special == 'assert'
    and parent[1] == loc then
        node:setTruthy()
    end
    return node
end

---@param callback    fun(src: parser.object, node: vm.node)
function mt:launch(callback)
    local topNode = vm.getNode(self.loc):copy()
    ---@type vm.runner.step
    local context
    for _, step in ipairs(self.steps) do
        local node = (step.ref1 and step.ref1.node)
                or (context and context.node)
                or topNode
        if step.copy then
            node = node:copy()
            if context then
                context.node = node
            end
        end
        if     step.type == 'truthy' then
            node:setTruthy()
        elseif step.type == 'falsy' then
            node:setFalsy()
        elseif step.type == 'as' then
            topNode = vm.createNode(globalMgr.getGlobal('type', step.name))
            if step.ref1 then
                step.ref1.node = topNode
            elseif context then
                context.node = topNode
            end
        elseif step.type == 'add' then
            node:merge(globalMgr.getGlobal('type', step.name))
        elseif step.type == 'remove' then
            node:remove(step.name)
        elseif step.type == 'object' then
            topNode = callback(step.object, node) or node
            if step.object.type == 'getlocal' then
                topNode = checkAssert(step.object, node)
            end
            if step.ref1 then
                step.ref1.node = topNode
            elseif context then
                context.node = topNode
            end
        elseif step.type == 'save' then
            step.node = node
        elseif step.type == 'load' then
            step.node = node
            context = step
        elseif step.type == 'merge' then
            node:merge(step.ref2.node)
        end
    end
end

---@param loc parser.object
---@return vm.runner
function vm.createRunner(loc)
    local self = setmetatable({
        loc       = loc,
        mainBlock = guide.getParentBlock(loc),
        blocks    = {},
        steps     = {},
    }, mt)

    self:_preCompile()

    return self
end
