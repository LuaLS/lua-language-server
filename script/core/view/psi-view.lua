local files = require("files")
local guide = require("parser.guide")


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
---@return psi.view.node | nil
local function toPsiNode(astNode, state)
    if not astNode then
        return
    end
    if astNode.type == "doc" then
        return
    end

    local startOffset = guide.positionToOffset(state, astNode.start)
    local finishOffset = guide.positionToOffset(state, astNode.finish)
    return {
        name = string.format("%s@%d..%d", astNode.type, startOffset, finishOffset),
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

    if psiNode.children and psiNode.attr then
        local range = psiNode.attr.range
        if range.start > psiNode.children[1].attr.range.start then
            range.start = psiNode.children[1].attr.range.start
        end
        if range["end"] < psiNode.children[#psiNode.children].attr.range["end"] then
            range["end"] = psiNode.children[#psiNode.children].attr.range["end"]
        end
    end

    -- if not psiNode.children then
    --     psiNode.name = psiNode.name
    -- end

    return psiNode
end

return function(uri)
    local state = files.getState(uri)
    if not state then
        return
    end

    return { data = collectPsi(state.ast, state) }
end
