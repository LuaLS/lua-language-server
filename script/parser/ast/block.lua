
---@class LuaParser.Node.Block: LuaParser.Node.Base
---@field childs LuaParser.Node.State[]
---@field locals LuaParser.Node.Local[]
---@field labels LuaParser.Node.Label[]
---@field isMain boolean
---@field localMap table<string, LuaParser.Node.Local>
---@field labelMap table<string, LuaParser.Node.Label>
local Block = Class('LuaParser.Node.Block', 'LuaParser.Node.Base')

Block.kind = 'block'

Block.isBlock = true
Block.isMain = false

-- 局部变量和上值的数量
Block.localCount = 0

Block.__getter.childs = function ()
    return {}, true
end

Block.__getter.locals = function ()
    return {}, true
end

---@param self LuaParser.Node.Block
---@return table
---@return true
Block.__getter.localMap = function (self)
    local parentBlock = self.parentBlock
    if not parentBlock then
        return {}, true
    end
    local parentLocalMap = parentBlock.localMap
    return setmetatable({}, {
        __index = function (t, k)
            local v = parentLocalMap[k] or false
            t[k] = v
            return v
        end
    }), true
end

Block.__getter.labels = function ()
    return {}, true
end

---@param self LuaParser.Node.Block
---@return table
---@return true
Block.__getter.labelMap = function (self)
    if self.isFunction then
        return {}, true
    end
    local parentBlock = self.parentBlock
    if not parentBlock then
        return {}, true
    end
    local parentLabelMap = parentBlock.labelMap
    return setmetatable({}, {
        __index = function (t, k)
            local v = parentLabelMap[k] or false
            t[k] = v
            return v
        end
    }), true
end

Block.__getter.referBlock = function (self)
    return self, true
end

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

local FinishMap = {
    ['end']    = true,
    ['elseif'] = true,
    ['else']   = true,
    ['until']  = true,
    ['}']      = true,
    [')']      = true,
}

---@private
---@param block LuaParser.Node.Block
function Ast:blockStart(block)
    local parentBlock = self.blocks[#self.blocks]
    self.blocks[#self.blocks+1] = block
    self.curBlock = block
    block.parentBlock = parentBlock
end

---@private
---@param block LuaParser.Node.Block
function Ast:blockFinish(block)
    assert(self.curBlock == block)
    self.blocks[#self.blocks] = nil
    self.curBlock = self.blocks[#self.blocks]

    self.localCount = self.localCount - block.localCount
end

---@private
---@param block LuaParser.Node.Block
function Ast:blockParseChilds(block)
    local lastState
    while true do
        while self.lexer:consume ';' do
            self:skipSpace()
        end
        local token, _, pos = self.lexer:peek()
        if not token then
            break
        end
        ---@cast pos -?
        if FinishMap[token] and not block.isMain then
            break
        end
        local state = self:parseState()
        if state then
            state.parent = block
            block.childs[#block.childs+1] = state
            if lastState and lastState.kind == 'return' then
                ---@cast lastState LuaParser.Node.Return
                self:throw('ACTION_AFTER_RETURN', lastState.start, lastState.finish)
            end
            lastState = state
            self:skipSpace()
        else
            if block.isMain then
                self.lexer:next()
                self:throw('UNKNOWN_SYMBOL', pos, pos + #token)
            else
                break
            end
        end
    end
end

---@package
Ast.needSortBlock = true

-- 获取最近的block
---@public
---@param pos integer
---@return LuaParser.Node.Block?
function Ast:getRecentBlock(pos)
    if self.needSortBlock then
        self.needSortBlock = false
        table.sort(self.blocks, function (a, b)
            return a.start < b.start
        end)
    end

    local blocks = self.blockList
    -- 使用二分法找到最近的block
    local low = 1
    local high = #blocks
    while low <= high do
        local mid = (low + high) // 2
        if pos < blocks[mid].start then
            high = mid - 1
        elseif not blocks[mid+1] then
            return blocks[mid]
        elseif pos >= blocks[mid+1].start then
            low = mid + 1
        else
            return blocks[mid]
        end
    end

    return nil
end
