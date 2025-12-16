local parser = require 'parser'

---@class VM.Coder.Flow
local M = Class 'VM.Coder.Flow'

---@class VM.Coder.Variable
---@field name string
---@field isTable? boolean

function M:__init()
    ---@type table<string, VM.Coder.Variable>
    self.variables = {}
end

---@param var LuaParser.Node.Var | LuaParser.Node.Local | LuaParser.Node.Param | LuaParser.Node.Field
---@return string?
function M:getName(var)
    if var.kind == 'local' or var.kind == 'param' then
        return '{}@{}:{}' % {
            var.id,
            var.startRow,
            var.startCol,
        }
    end
    if var.kind == 'var' then
        ---@cast var LuaParser.Node.Var
        if var.loc then
            return self:getName(var.loc)
        end
        if var.env then
            local envName = self:getName(var.env)
            if not envName then
                return nil
            end
            return '{}.{}' % { envName, var.id }
        end
        return '_G.{}' % { var.id }
    end
    if var.kind == 'field' then
        ---@cast var LuaParser.Node.Field
        local parentName = self:getName(var.parent)
        if not parentName then
            return nil
        end
        local key = var.key
        if var.subtype == 'field' or var.subtype == 'method' then
            ---@cast key LuaParser.Node.FieldID
            return '{}.{}' % { parentName, key.id }
        end
        if var.subtype == 'index' then
            ---@cast key LuaParser.Node.Exp
            if key.isLiteral then
                ---@cast key LuaParser.Node.Literal
                local value = key.value
                if type(value) == 'string' then
                    if parser.isName(value) then
                        return '{}.{}' % { parentName, value }
                    else
                        return '{}[{:q}]' % { parentName, value }
                    end
                else
                    return '{}[{}]' % { parentName, tostring(value) }
                end
            end
            return nil
        end
    end
end
