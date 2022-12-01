local files = require("files")
local guide = require("parser.guide")
local converter = require("proto.converter")
local subString = require 'core.substring'



---@class psi.view.node
---@field name string
---@field attr? psi.view.attr
---@field children? psi.view.node[]

---@class psi.view.attr
---@field range psi.view.range

---@class psi.view.range
---@field start integer
---@field end integer

---@param astNode parser.object
---@param state parser.state
---@return psi.view.node | nil
local function toPsiNode(astNode, state)
    if not astNode or not astNode.start then
        return
    end

    local startOffset = guide.positionToOffset(state, astNode.start)
    local finishOffset = guide.positionToOffset(state, astNode.finish)
    local startPosition = converter.packPosition(state, astNode.start)
    local finishPosition = converter.packPosition(state, astNode.finish)
    return {
        name = string.format("%s@[%d:%d .. %d:%d]",
            astNode.type,
            startPosition.line + 1, startPosition.character + 1,
            finishPosition.line + 1, finishPosition.character + 1),
        attr = {
            range = {
                start = startOffset,
                ["end"] = finishOffset
            }
        }
    }
end

---@param astNode parser.object
---@return psi.view.node | nil
local function collectPsi(astNode, state)
    local psiNode = toPsiNode(astNode, state)

    if not psiNode then
        return
    end

    guide.eachChild(astNode, function(child)
        if psiNode.children == nil then
            psiNode.children = {}
        end

        local psi = collectPsi(child, state)
        if psi then
            psiNode.children[#psiNode.children+1] = psi
        end
    end)

    if psiNode.children and #psiNode.children > 0 and psiNode.attr then
        local range = psiNode.attr.range
        if range.start > psiNode.children[1].attr.range.start then
            range.start = psiNode.children[1].attr.range.start
        end
        if range["end"] < psiNode.children[#psiNode.children].attr.range["end"] then
            range["end"] = psiNode.children[#psiNode.children].attr.range["end"]
        end
    end

    if not psiNode.children then
        local subber = subString(state)
        local showText = subber(astNode.start + 1, astNode.finish)
        if string.len(showText) > 30 then
            showText = showText:sub(0, 30).. " ... "
        end

        psiNode.name = psiNode.name .. "   " .. showText
    end

    return psiNode
end

return function(uri)
    local state = files.getState(uri)
    if not state then
        return
    end

    return { data = collectPsi(state.ast, state) }
end
