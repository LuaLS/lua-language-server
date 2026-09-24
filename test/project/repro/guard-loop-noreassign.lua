-- 对照组：同样有守卫、同样在循环里读 `exp.start`，但循环内**不重赋值** `exp` —— 不报诊断
-- （确认 `guard-loop-reassign.lua` 的诱因是「循环内重赋值」这一步）

local function parseExpUnit()
    return nil
end

local function parseBop()
    return false
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
    while true do
        local bop = parseBop()
        if not bop then
            break
        end
        local bin = { start = exp.start }
        if bin.start then
            return bin
        end
    end
    return exp
end

return parseExp
