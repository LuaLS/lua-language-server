-- 对照组：守卫后立刻读字段（没有循环）—— 不报诊断
-- 说明「守卫 + 重赋值」本身没问题，要再加上循环里的读才复现（见 guard-loop-reassign.lua）

local function parseExpUnit()
    return nil
end

---@param uop boolean?
---@return table?
local function parseExp(uop)
    local exp
    if uop then
        exp = { start = 1 }
    else
        exp = parseExpUnit()
        if not exp then
            return nil
        end
    end
    return exp
end

return parseExp
