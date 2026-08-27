
---@class LuaParser.Node.Var: LuaParser.Node.Base
---@field subtype 'global' | 'local'
---@field id string
---@field env? LuaParser.Node.Local
---@field loc? LuaParser.Node.Local
---@field global? boolean
---@field globalConst? boolean
---@field next? LuaParser.Node.Field
---@field value? LuaParser.Node.Exp
local Var = Class('LuaParser.Node.Var', 'LuaParser.Node.Base')

Var.kind = 'var'

---@class LuaParser.Node.Varargs: LuaParser.Node.Base
---@field loc? LuaParser.Node.Local
local Varargs = Class('LuaParser.Node.Varargs', 'LuaParser.Node.Base')

Varargs.kind = 'varargs'

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.Var?
function Ast:parseVar()
    local var = self:parseID('LuaParser.Node.Var')
    if not var then
        return nil
    end

    local bindEnv = function ()
        local env = self:getVariable(self.envMode)
        if env then
            var.env = env
            env.envRefs[#env.envRefs+1] = var
        end
    end

    local declaration = self:getVariable(var.id)
    if self.parsingGlobalFunction then
        declaration = nil
    end
    if declaration and declaration.isGlobal then
        var.global = true
        var.globalConst = declaration.globalConst
        bindEnv()
        return var
    end
    if declaration then
        local loc = declaration
        var.loc = loc
        loc.refs[#loc.refs+1] = var
        return var
    end
    if self.parsingGlobalFunction then
        var.global = true
        bindEnv()
        return var
    end
    if self:getGlobal(var.id, var.start) == false then
        self:throw('GLOBAL_NOT_DECLARED', var.start, var.finish)
        return var
    end
    bindEnv()
    if self:isGlobalConst(var.id) then
        var.globalConst = true
    end

    return var
end

---@private
---@return LuaParser.Node.Local?
function Ast:bindVarargs()
    local loc = self:getLocal('...')

    if not loc then
        return nil
    end

    if loc.parentFunction ~= self:getCurrentFunction() then
        return nil
    end

    return loc
end

---@private
---@return LuaParser.Node.Varargs?
function Ast:parseVarargs()
    local pos = self.lexer:consume '...'
    if not pos then
        return nil
    end

    local loc = self:bindVarargs()
    if not loc and self:getCurrentFunction() then
        self:throw('UNEXPECT_DOTS', pos, pos + #'...')
    end

    return self:createNode('LuaParser.Node.Varargs', {
        start  = pos,
        finish = pos + 3,
        loc    = loc,
    })
end
