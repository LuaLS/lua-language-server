-- 循环变量在「守卫 + 循环内调用（形参注解比实参宽，如 `list: repro.Obj[] | nil`）+ 嵌套 if」下，
-- 读位置的 `ret` 退回列表值（`repro.Obj[] | nil`），元素字段读被算成「未定义字段」。
-- 同族 = 目标工程 `script/core/diagnostics/missing-return-value.lua` 的 30/31（`ret.start`）。
-- 现状：去掉下面那行 disable，`ret.start` 就报 Undefined field `start`

---@class repro.Obj
---@field start integer

---@class repro.Src
---@field returns? repro.Obj[]

---@param list repro.Obj[] | nil
---@return integer
local function countList(list)
    return 0
end

---@param source repro.Src
---@param callback fun(v: table)
local function f(source, callback)
    local returns = source.returns
    if not returns then
        return
    end
    local min = countList(returns)
    if min == 0 then
        return
    end
    for _, ret in ipairs(returns) do
        local rmin, rmax = countList(ret), 1
        if rmax < min then
            if rmin == rmax then
                callback {
                    ---@diagnostic disable-next-line: undefined-field
                    start = ret.start,
                }
            end
        end
    end
end

return f
