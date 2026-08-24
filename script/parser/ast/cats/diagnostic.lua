---@class LuaParser.Node.CatStateDiagnostic: LuaParser.Node.Base
---@field mode 'disable' | 'enable' | 'disable-line' | 'disable-next-line'
---@field names LuaParser.Node.CatDiagnosticName[]?
local CatStateDiagnostic = Class('LuaParser.Node.CatStateDiagnostic', 'LuaParser.Node.Base')

CatStateDiagnostic.kind = 'catstatediagnostic'

---@class LuaParser.Node.CatDiagnosticName: LuaParser.Node.Base
---@field id string
local CatDiagnosticName = Class('LuaParser.Node.CatDiagnosticName', 'LuaParser.Node.Base')

CatDiagnosticName.kind = 'catdiagnosticname'

local MODES = { 'disable-next-line', 'disable-line', 'disable', 'enable' }

---@class LuaParser.Ast
local Ast = Class 'LuaParser.Ast'

---@private
---@return LuaParser.Node.CatStateDiagnostic?
function Ast:parseCatDiagnostic()
    local _, _, pos = self.lexer:peek()
    if not pos then
        return nil
    end

    local modeStart1 = self.code:match('^[ \t]*()', pos + 1)
    local mode
    for _, m in ipairs(MODES) do
        if self.code:sub(modeStart1, modeStart1 + #m - 1) == m then
            mode = m
            break
        end
    end
    if not mode then
        return nil
    end

    local start  = modeStart1 - 1
    local finish = start + #mode

    local names
    local colonStart, colonFinish = self.code:find('^[ \t]*:', finish + 1)
    if colonStart then
        names = {}
        local namePos = colonFinish
        while true do
            local nameStart1, name = self.code:match('^[ \t,]*()([%a_][%w_%-]*)', namePos + 1)
            if not name then
                break
            end
            names[#names+1] = self:createNode('LuaParser.Node.CatDiagnosticName', {
                id     = name,
                start  = nameStart1 - 1,
                finish = nameStart1 - 1 + #name,
            })
            namePos = nameStart1 - 1 + #name
        end
        if #names == 0 then
            names  = nil
            finish = colonFinish
        else
            finish = names[#names].finish
        end
    end

    self.lexer:moveTo(finish)

    local diagnostic = self:createNode('LuaParser.Node.CatStateDiagnostic', {
        mode   = mode,
        names  = names,
        start  = start,
        finish = finish,
    })
    if names then
        for _, name in ipairs(names) do
            name.parent = diagnostic
        end
    end

    return diagnostic
end
