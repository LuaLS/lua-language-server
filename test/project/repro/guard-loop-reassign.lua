-- 守卫收窄 + 循环里重赋值：循环体内的读值退回未收窄的 guess（need-check-nil 误报）
-- 期望：无诊断（`exp` 在 if/else 两支里都成了非 nil，else 支还有 `if not exp then return nil end` 守卫）。
-- 现状：去掉下面那行 disable，`exp.start` 就报 Need check nil
-- （同族 = 目标工程 `script/parser/compile.lua` 的 29 条 need-check-nil）。
-- 详见 `.github/skills/luals-server-dev/references/facts/narrowing.md` F19

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
        ---@diagnostic disable-next-line: need-check-nil
        local bin = { start = exp.start, [1] = exp }
        exp = bin
    end
    return exp
end

return parseExp
