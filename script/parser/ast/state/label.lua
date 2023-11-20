local class = require 'class'

---@class LuaParser.Node.Label: LuaParser.Node.Base
---@field name? LuaParser.Node.LabelName
---@field symbolPos? integer # 右边标签符号的位置
---@field gotos LuaParser.Node.Goto[] # 关联的Goto
local Label = class.declare('LuaParser.Node.Label', 'LuaParser.Node.Base')

Label.__getter.gotos = function (self)
    return {}, true
end

---@class LuaParser.Node.LabelName: LuaParser.Node.Base
---@field parent LuaParser.Node.Label | LuaParser.Node.Goto
---@field id string
local LabelName = class.declare('LuaParser.Node.LabelName', 'LuaParser.Node.Base')

---@class LuaParser.Node.Goto: LuaParser.Node.Base
---@field name? LuaParser.Node.LabelName
---@field label? LuaParser.Node.Label # 关联的Label
local Goto = class.declare('LuaParser.Node.Goto', 'LuaParser.Node.Base')

---@class LuaParser.Ast
local Ast = class.get 'LuaParser.Ast'

---@private
---@return LuaParser.Node.Label?
function Ast:parseLabel()
    local pos = self.lexer:consume '::'
    if not pos then
        return nil
    end

    self:skipSpace()
    local labelName = self:parseID('LuaParser.Node.LabelName', true, true)

    local symbolPos
    if labelName then
        self:skipSpace()
        symbolPos = self:assertSymbol '::'
    end

    local label = self:createNode('LuaParser.Node.Label', {
        start      = pos,
        finish     = self:getLastPos(),
        symbolPos  = symbolPos,
    })

    if labelName then
        label.name = labelName
        labelName.parent = label
        local curBlock = self.curBlock
        if curBlock then
            curBlock.labels[#curBlock.labels+1] = label

            local existLabel = curBlock.labelMap[labelName.id]
            if existLabel then
                if self.versionNum >= 54
                or curBlock == existLabel.parentBlock then
                    self:throw('REDEFINED_LABEL', labelName.start, labelName.finish, {
                        start = existLabel.name.start,
                        finish = existLabel.name.finish,
                    })
                end
            end

            curBlock.labelMap[labelName.id] = label
        end
    end

    if self.versionNum <= 51 and not self.jit then
        self:throw('UNSUPPORT_SYMBOL', pos, pos + 2)
    end

    return label
end

---@private
---@return LuaParser.Node.Goto?
function Ast:parseGoto()
    local token, _, pos = self.lexer:peek()
    if token ~= 'goto' then
        return nil
    end
    ---@cast pos -?
    if self:isKeyWord 'goto' then
        -- OK
    else
        local _, nextType = self.lexer:peek(1)
        if nextType == 'Word' then
            -- OK
        else
            return nil
        end
    end
    self.lexer:next()

    self:skipSpace()
    local labelName = self:parseID('LuaParser.Node.LabelName', true)

    local gotoNode = self:createNode('LuaParser.Node.Goto', {
        start      = pos,
        finish     = self:getLastPos(),
    })

    if labelName then
        gotoNode.name = labelName
        labelName.parent = gotoNode
    end

    if self.versionNum <= 51 and not self.jit then
        self:throw('UNSUPPORT_SYMBOL', pos, pos + #'goto')
    end

    return gotoNode
end

---@private
function Ast:resolveAllGoto()
    for _, gotoNode in ipairs(self.nodesMap['Goto']) do
        ---@cast gotoNode LuaParser.Node.Goto
        self:resolveGoto(gotoNode)
    end
end

---@private
---@param gotoNode LuaParser.Node.Goto
function Ast:resolveGoto(gotoNode)
    if not gotoNode.name then
        return
    end
    local myName = gotoNode.name.id

    local labelMap = self:findVisibleLabels(gotoNode.start)
    local labelNode = labelMap[myName]

    if not labelNode then
        self:throw('NO_VISIBLE_LABEL', gotoNode.name.start, gotoNode.name.finish)
        return
    end

    gotoNode.label = labelNode
    labelNode.gotos[#labelNode.gotos+1] = gotoNode

    -- 检查是否进入局部变量的作用域
    local labelBlock = labelNode.parentBlock
    if labelBlock then
        for _, loc in ipairs(labelBlock.locals) do
            if  loc.start > gotoNode.start
            and loc.start < labelNode.start then
                self:throw('JUMP_LOCAL_SCOPE', gotoNode.name.start, gotoNode.name.finish, {
                    loc    = loc.id,
                    start  = loc.start,
                    finish = loc.finish,
                })
                break
            end
        end
    end
end

-- 获取在指定位置可见的所有标签
---@public
---@param pos integer
---@return table<string, LuaParser.Node.Label>
function Ast:findVisibleLabels(pos)
    local results = {}
    local myBlock = self:getRecentBlock(pos)
    if not myBlock then
        return results
    end
    return myBlock.labelMap
end
