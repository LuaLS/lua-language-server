---@class vm
local vm    = require 'vm.vm'
local guide = require 'parser.guide'

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
---@field type    'truly' | 'as' | 'object' | 'save' | 'load'
---@field pos     integer
---@field node?   vm.node
---@field object? parser.object
---@field ref?    vm.runner.step

---@param filter parser.object
---@param pos    integer
function mt:_compileNarrowByFilter(filter, pos)
    if filter.type == 'unary' then
    elseif filter.type == 'binary' then
    else
        if filter.type == 'getlocal' and filter.node == self.loc then
            self.steps[#self.steps+1] = {
                type = 'truly',
                pos = pos,
            }
        end
    end
end

function mt:_dropBlock(block)
    local savePoint = {
        type = 'save',
        pos  = block.start,
    }
    self.steps[#self.steps+1] = savePoint
    self.steps[#self.steps+1] = {
        type = 'load',
        pos  = block.finish,
        ref  = savePoint,
    }
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

    if block.type == 'ifblock' then
        if block[1] then
            self:_compileNarrowByFilter(block.filter, block[1].start)
        end
    end

    if block.type == 'if' then
        self:_dropBlock(block)
    end

    if block.type == 'function' then
        self:_dropBlock(block)
    end
end

function mt:_preCompile()
    for _, ref in ipairs(self.loc.ref) do
        self.steps[#self.steps+1] = {
            type   = 'object',
            object = ref,
            pos  = ref.start,
        }
        local block = guide.getParentBlock(ref)
        self:_compileBlock(block)
    end
    table.sort(self.steps, function (a, b)
        return a.pos < b.pos
    end)
end

---@param callback    fun(src: parser.object, node: vm.node)
function mt:launch(callback)
    local node = vm.getNode(self.loc)
    for _, step in ipairs(self.steps) do
        if     step.type == 'truly' then
            node = node:copyTruly()
        elseif step.type == 'as' then
        elseif step.type == 'object' then
            node = callback(step.object, node) or node
        elseif step.type == 'save' then
            -- Nothing need to do
        elseif step.type == 'load' then
            node = step.ref.node
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
