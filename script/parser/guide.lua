---@class LuaParser.Guide
local M = Class 'LuaParser.Guide'

--- 遍历在指定位置（offset）可见的所有局部变量（local 和 param）。
--- 从 source 所在的 block 开始，逐层向上遍历父 block，
--- 收集所有 effectStart <= offset 的局部变量声明。
---
--- 注意：同名变量可能被内层 block 遮蔽，由调用方决定是否处理遮蔽。
---
---@param source LuaParser.Node.Base         # 当前光标所在的节点
---@param offset integer                      # 光标偏移量
---@param callback fun(local_: LuaParser.Node.Local | LuaParser.Node.Param)
function M.eachVisibleLocal(source, offset, callback)
    local block = source.parentBlock
    while block do
        -- 遍历该 block 的局部变量
        for _, loc in ipairs(block.locals) do
            if loc.effectStart <= offset then
                callback(loc)
            end
        end
        -- 函数的 param 挂在函数节点上（而非 block），需要特殊处理
        if block.isFunction then
            ---@cast block LuaParser.Node.Function
            local params = block.params
            if params then
                for _, param in ipairs(params) do
                    callback(param)
                end
            end
        end
        -- 向上找父 block
        block = block.parentBlock
    end
end

return M
