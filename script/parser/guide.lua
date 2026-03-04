---@class LuaParser.Guide
local M = Class 'LuaParser.Guide'

--- 返回在指定位置（offset）可见的所有局部变量（local 和 param）。
--- 从 source 所在的 block 开始，逐层向上遍历父 block，
--- 收集所有 effectStart <= offset 的局部变量声明，
--- 内层声明会遮蔽外层同名声明（内层优先，外层被跳过）。
---
---@param source LuaParser.Node.Base  # 当前光标所在的节点
---@param offset integer               # 光标偏移量
---@return (LuaParser.Node.Local | LuaParser.Node.Param)[]
function M.getVisibleLocals(source, offset)
    ---@type table<string, true>
    local seen   = {}
    ---@type (LuaParser.Node.Local | LuaParser.Node.Param)[]
    local result = {}

    local block = source.parentBlock
    while block do
        -- 倒序遍历：越靠后声明的越"内层"，优先加入，外层同名的会被 seen 跳过
        local locals = block.locals
        for i = #locals, 1, -1 do
            local loc = locals[i]
            if loc.effectStart <= offset then
                local name = loc.id
                if type(name) == 'string' and not seen[name] then
                    seen[name] = true
                    result[#result+1] = loc
                end
            end
        end
        -- 函数的 param 挂在函数节点上，需要特殊处理
        if block.isFunction then
            ---@cast block LuaParser.Node.Function
            local params = block.params
            if params then
                for i = #params, 1, -1 do
                    local param = params[i]
                    local name = param.id
                    if type(name) == 'string' and not seen[name] then
                        seen[name] = true
                        result[#result+1] = param
                    end
                end
            end
        end
        -- 向上找父 block
        block = block.parentBlock
    end

    return result
end

return M
