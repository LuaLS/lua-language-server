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
---@field type    'truly' | 'falsy' | 'as' | 'add' | 'remove' | 'object' | 'save' | 'load' | 'merge'
---@field pos     integer
---@field order?  integer
---@field node?   vm.node
---@field object? parser.object
---@field name?   string
---@field copy?   boolean
---@field ref1?   vm.runner.step
---@field ref2?   vm.runner.step

---@param filter parser.object
---@param pos    integer
function mt:_compileNarrowByFilter(filter, pos)
    if not filter then
        return
    end
    if filter.type == 'paren' then
        if filter.exp then
            self:_compileNarrowByFilter(filter.exp, pos)
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
                    type  = 'truly',
                    pos   = pos,
                    order = 2,
                }
                self.steps[#self.steps+1] = {
                    type  = 'falsy',
                    pos   = pos,
                    order = 4,
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
            self:_compileNarrowByFilter(filter[1], pos)
            self:_compileNarrowByFilter(filter[2], pos)
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
                        pos   = pos,
                        order = 2,
                    }
                    self.steps[#self.steps+1] = {
                        type  = 'as',
                        name  = exp.type,
                        pos   = pos,
                        order = 4,
                    }
                end
                if filter.op.type == '~=' then
                    self.steps[#self.steps+1] = {
                        type  = 'as',
                        name  = exp.type,
                        pos   = pos,
                        order = 2,
                    }
                    self.steps[#self.steps+1] = {
                        type  = 'remove',
                        name  = exp.type,
                        pos   = pos,
                        order = 4,
                    }
                end
            end
        end
    else
        if filter.type == 'getlocal' and filter.node == self.loc then
            self.steps[#self.steps+1] = {
                type  = 'falsy',
                pos   = pos,
                order = 2,
            }
            self.steps[#self.steps+1] = {
                type  = 'truly',
                pos   = pos,
                order = 4,
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
            if #childBlock > 0 then
                local initState = {
                    type  = 'save',
                    copy  = true,
                    pos   = childBlock.start,
                    order = 1,
                }
                local outState = {
                    type  = 'save',
                    copy  = true,
                    pos   = childBlock.start,
                    order = 2,
                }
                local filterState = {
                    type  = 'save',
                    copy  = true,
                    pos   = childBlock.start,
                    order = 3,
                }
                self.steps[#self.steps+1] = initState
                self.steps[#self.steps+1] = outState
                self.steps[#self.steps+1] = filterState
                self.steps[#self.steps+1] = {
                    type  = 'load',
                    ref1  = outState,
                    pos   = childBlock[1].start - 1,
                    order = 1,
                }
                self.steps[#self.steps+1] = {
                    type  = 'load',
                    ref1  = initState,
                    pos   = childBlock[1].start - 1,
                    order = 3,
                }
                self:_compileNarrowByFilter(childBlock.filter, childBlock[1].start - 1)
                if childBlock.returns then
                    self.steps[#self.steps+1] = {
                        type   = 'load',
                        ref1   = outState,
                        pos    = childBlock.finish,
                        order  = 1,
                    }
                else
                    local finalState = {
                        type  = 'save',
                        pos   = childBlock.finish,
                        order = 1,
                    }
                    finals[#finals+1] = finalState
                    self.steps[#self.steps+1] = finalState
                    self.steps[#self.steps+1] = {
                        type   = 'load',
                        ref1   = outState,
                        pos    = childBlock.finish,
                        order  = 2,
                    }
                end
            end
        end
        for i, final in ipairs(finals) do
            self.steps[#self.steps+1] = {
                type  = 'merge',
                ref1  = final,
                pos   = block.finish,
                order = i,
            }
        end
    end

    if block.type == 'function' then
        local savePoint = {
            type = 'save',
            copy = true,
            pos  = block.start,
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
        node:setTruly()
    end
    return node
end

---@param callback    fun(src: parser.object, node: vm.node)
function mt:launch(callback)
    local node = vm.getNode(self.loc):copy()
    for _, step in ipairs(self.steps) do
        if step.copy then
            node = node:copy()
        end
        if     step.type == 'truly' then
            node:setTruly()
        elseif step.type == 'falsy' then
            node:setFalsy()
        elseif step.type == 'as' then
            node = vm.createNode(globalMgr.getGlobal('type', step.name))
        elseif step.type == 'add' then
            node:merge(globalMgr.getGlobal('type', step.name))
        elseif step.type == 'remove' then
            node:remove(step.name)
        elseif step.type == 'object' then
            node = callback(step.object, node) or node
            if step.object.type == 'getlocal' then
                node = checkAssert(step.object, node)
            end
        elseif step.type == 'save' then
            -- nothing to do
        elseif step.type == 'load' then
            node = step.ref1.node
        elseif step.type == 'merge' then
            node:merge(step.ref1.node)
        end
        step.node = node
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
