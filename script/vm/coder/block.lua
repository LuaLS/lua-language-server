---@param coder VM.Coder
---@param block LuaParser.Node.Block
local function parseBlock(coder, block)
    coder:pushBlock()
    for _, child in ipairs(block.childs) do
        coder:compile(child)
        coder:addLine('')
    end
    coder:popBlock()
end

ls.vm.registerCoderProvider('main', function (coder, source)
    ---@cast source LuaParser.Node.Main
    parseBlock(coder, source)
end)
