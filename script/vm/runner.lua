---@class vm
local vm    = require 'vm.vm'
local guide = require 'parser.guide'

---@class vm.local-compiler
---@field loc       parser.object
---@field mainBlock parser.object
---@field blocks    table<parser.object, table>
local mt = {}
mt.__index = mt
mt.index = 1


---@class parser.object
---@field _hasSorted      boolean

---@param source parser.object
local function sortRefs(source)
    if source._hasSorted then
        return
    end
    source._hasSorted = true
    table.sort(source.ref, function (a, b)
        return (a.range or a.start) < (b.range or b.start)
    end)
end

---@param node  vm.node
---@param block parser.object
---@return vm.node
function mt:_compileBlock(node, block)
    for _ = 1, 10000 do
        if self.blocks[block]
        or self.mainBlock == block
        or block.type == 'function'
        or block.type == 'main' then
            return node
        end
        self.blocks[block] = {}
        block = guide.getParentBlock(block)
    end
    error('compile block overstack')
end

---@param node        vm.node
---@param currentBlock parser.object
---@param callback     fun(src: parser.object, node: vm.node)
---@return vm.node
function mt:_runBlock(node, currentBlock, callback)
    local currentNode = self:_compileBlock(node, currentBlock)
    for _ = 1, 10000 do
        local ref = self.loc.ref[self.index]
        if not ref
        or ref.start > currentBlock.finish then
            return node
        end
        local block = guide.getParentBlock(ref)
        if block == currentBlock then
            callback(ref, currentNode)
            self.index = self.index + 1
            if ref.type == 'setlocal' then
                currentNode = vm.getNode(ref)
            end
        else
            currentNode = self:_runBlock(currentNode, block, callback)
        end
    end
    error('run block overstack')
end

---@param callback    fun(src: parser.object, node: vm.node)
function mt:launch(callback)
    self:_runBlock(vm.getNode(self.loc), self.mainBlock, callback)
end

---@param loc parser.object
---@return vm.local-compiler
function vm.createRunner(loc)
    local self = setmetatable({
        loc       = loc,
        mainBlock = guide.getParentBlock(loc),
        blocks    = {},
    }, mt)

    sortRefs(loc)

    return self
end
