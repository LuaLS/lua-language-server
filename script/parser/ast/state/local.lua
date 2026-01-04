
---@class LuaParser.Node.LocalDef: LuaParser.Node.Base
---@field vars LuaParser.Node.Local[]
---@field symbolPos? integer # 等号的位置
---@field values? LuaParser.Node.Exp[]
local LocalDef = Class('LuaParser.Node.LocalDef', 'LuaParser.Node.Base')

LocalDef.kind = 'localdef'

---@class LuaParser.Node.Local: LuaParser.Node.Base
---@field id string
---@field parent LuaParser.Node.LocalDef | LuaParser.Node.For | LuaParser.Node.Function
---@field index integer
---@field effectStart integer
---@field effectFinish integer
---@field value? LuaParser.Node.Exp
---@field refs? LuaParser.Node.Var[]
---@field gets? LuaParser.Node.Var[]
---@field sets? LuaParser.Node.Var[]
---@field envRefs? LuaParser.Node.Var[]
---@field attr? LuaParser.Node.Attr
local Local = Class('LuaParser.Node.Local', 'LuaParser.Node.Base')

Local.kind = 'local'

-- 所有的引用对象
Local.__getter.refs = function ()
    return {}, true
end

-- 所有的赋值对象
---@param self LuaParser.Node.Local
---@return LuaParser.Node.Var[]
---@return true
Local.__getter.sets = function (self)
    local sets = {}
    for _, ref in ipairs(self.refs) do
        if ref.value then
            sets[#sets+1] = ref
        else
            local parent = ref.parent
            if parent and parent.kind == 'assign' then
                sets[#sets+1] = ref
            end
        end
    end
    return sets, true
end

-- 所有的获取对象
---@param self LuaParser.Node.Local
---@return LuaParser.Node.Var[]
---@return true
Local.__getter.gets = function (self)
    local gets = {}
    for _, ref in ipairs(self.refs) do
        local parent = ref.parent
        if parent and parent.kind ~= 'assign' then
            gets[#gets+1] = ref
        end
    end
    return gets, true
end

-- _ENV的隐式引用
Local.__getter.envRefs = function ()
    return {}, true
end

---@param self LuaParser.Node.Local
---@return integer
---@return boolean
Local.__getter.effectStart = function (self)
    return self.finish + 1, true
end

---@param self LuaParser.Node.Local
---@return integer
---@return boolean
Local.__getter.effectFinish = function (self)
    local block = self.parentBlock
    if not block then
        return #self.ast.code + 1, true
    end
    return block.finish, true
end

---@class LuaParser.Node.Attr: LuaParser.Node.Base
---@field name LuaParser.Node.AttrName
---@field symbolPos? integer # > 的位置
local Attr = Class('LuaParser.Node.Attr', 'LuaParser.Node.Base')

Attr.kind = 'attr'

---@class LuaParser.Node.AttrName: LuaParser.Node.Base
---@field parent LuaParser.Node.Attr
---@field id string
local AttrName = Class('LuaParser.Node.AttrName', 'LuaParser.Node.Base')

AttrName.kind = 'attrname'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return (LuaParser.Node.LocalDef | LuaParser.Node.Function)?
function Ast:parseLocal()
    local pos = self.lexer:consume 'local'
    if not pos then
        return nil
    end
    self:skipSpace()

    if self.lexer:peek() == 'function' then
        return self:parseFunction(true)
    end

    local localdef = self:createNode('LuaParser.Node.LocalDef', {
        start  = pos,
    })

    local vars = self:parseLocalList(true)
    localdef.vars = vars

    self:skipSpace()
    local symbolPos = self.lexer:consume '='
    if symbolPos then
        localdef.symbolPos = symbolPos
        self:skipSpace()
        local values = self:parseExpList(true)
        self:convertValuesToSelect(values, #vars)
        localdef.values = values
        for i = 1, #values do
            local value = values[i]
            value.parent = localdef
            value.index  = i

            local var = vars[i]
            if var then
                var.value = value
            end
        end
    end

    localdef.finish = self:getLastPos()

    for i = 1, #vars do
        local var = vars[i]
        var.parent = localdef
        var.index  = i
        self:initLocal(var)
    end

    return localdef
end

---@package
Ast.hasThrowedLocalLimit = false

---@private
---@param loc LuaParser.Node.Local
function Ast:initLocal(loc)
    local block = self.curBlock
    if not block then
        block = New 'LuaParser.Node.Block' ()
        self:blockStart(block)
    end

    block.locals[#block.locals+1] = loc

    loc.effectStart = self:getLastPos()

    local name = loc.id
    local lastLoc = rawget(block.localMap, name)
    if lastLoc then
        lastLoc.effectFinish = loc.effectStart
    end
    block.localMap[name] = loc

    if name ~= '...' then
        if self.localCount >= 200 and not self.hasThrowedLocalLimit then
            self.hasThrowedLocalLimit = true
            self:throw('LOCAL_LIMIT', loc.start, loc.finish)
        end
        self.localCount = self.localCount + 1
        block.localCount = block.localCount + 1
    end
end

---@private
---@param name string
---@return LuaParser.Node.Local?
function Ast:getLocal(name)
    local block = self.curBlock
    if not block then
        return nil
    end
    return block.localMap[name] or nil
end

---@private
---@param parseAttr? boolean
---@return LuaParser.Node.Local[]
function Ast:parseLocalList(parseAttr)
    ---@type LuaParser.Node.ID[]
    local list = {}
    local first = self:parseID('LuaParser.Node.Local', true)
    list[#list+1] = first
    if parseAttr then
        self:skipSpace()
        local attr = self:parseLocalAttr()
        if attr then
            first.attr = attr
            first.finish = attr.finish
        end
    end
    while true do
        self:skipSpace()
        local token, tp = self.lexer:peek()
        if not token then
            break
        end
        if tp == 'Symbol' then
            if token == ',' then
                self.lexer:next()
                self:skipSpace()
            else
                break
            end
        else
            break
        end
        local loc = self:parseID('LuaParser.Node.Local', true)
        if loc then
            list[#list+1] = loc
            if parseAttr then
                self:skipSpace()
                local attr = self:parseLocalAttr()
                if attr then
                    loc.attr = attr
                    loc.finish = attr.finish
                end
            end
        end
    end
    return list
end

---@private
---@return LuaParser.Node.Attr?
function Ast:parseLocalAttr()
    local pos = self.lexer:consume '<'
    if not pos then
        return nil
    end

    self:skipSpace()
    local attrName = self:parseID('LuaParser.Node.AttrName', true)
    if not attrName then
        return nil
    end

    local attrNode = self:createNode('LuaParser.Node.Attr', {
        start = pos,
        name  = attrName,
    })
    attrName.parent = attrNode

    if  attrName.id ~= 'const'
    and attrName.id ~= 'close' then
        self:throw('UNKNOWN_ATTRIBUTE', attrName.start, attrName.finish)
    end

    self:skipSpace()
    local symbolPos = self.lexer:consume '>'
    attrNode.symbolPos = symbolPos

    attrNode.finish = self:getLastPos()

    if not symbolPos and self.lexer:peek() == '>=' then
        local _, _, ltPos = self.lexer:peek()
        ---@cast ltPos integer
        self:throw('MISS_SPACE_BETWEEN', ltPos, ltPos + 2)
    end

    if self.versionNum <= 53 then
        self:throw('UNSUPPORT_SYMBOL', attrNode.start, attrNode.finish)
    end

    return attrNode
end

---@private
function Ast:checkAssignConst()
    for _, loc in ipairs(self.nodesMap['local']) do
        ---@cast loc LuaParser.Node.Local
        local attr = loc.attr and loc.attr.name and loc.attr.name.id
        if attr == 'const' or attr == 'close' then
            for _, set in ipairs(loc.sets) do
                self:throw('SET_CONST', set.start, set.finish)
            end
        end
    end
end

---@param name string
---@param pos integer
---@return LuaParser.Node.Local?
function Ast:findLocal(name, pos)
    local block = self:getRecentBlock(pos)
    if not block then
        return nil
    end
    local loc = block.localMap[name]
    do -- first try
        if not loc then
            return nil
        end
        if loc.effectStart <= pos and pos <= loc.effectFinish then
            return loc
        end
    end
    do -- search all locals
        block = loc.parentBlock
        while block do
            for _, localVar in ipairs(block.locals) do
                if  localVar.id == name
                and localVar.effectStart <= pos
                and localVar.effectFinish >= pos then
                    return localVar
                end
            end
            block = block.parentBlock
        end
    end
    return nil
end
