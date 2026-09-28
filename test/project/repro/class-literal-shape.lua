-- 「字面量 → 类」实参的形状检查三态（缺字段不算不匹配；已出现字段的类型照旧要比）：
--   ① 完整字面量            → 干净
--   ② 写了部分同名字段（缺别的）→ 干净（缺字段交给 missing-fields 那类专门规则，
--                                 下面按目标工程的写法禁用该代码）
--   ③ 已出现字段类型错      → 报（disable 标出期望的诊断）
-- 同族 = 目标工程 `completion.lua:1683`、`vm/operator.lua:180/210/227/...`（那些行目标工程自己
-- 就是按 `---@diagnostic disable-next-line: missing-fields` 处理的）

---@class reproCf
---@field kind string
---@field n integer

---@param v reproCf
---@return reproCf
local function need(v)
    return v
end

need({ kind = 'x', n = 1 })

---@diagnostic disable-next-line: missing-fields
need({ kind = 'x' })

---@diagnostic disable-next-line: missing-fields, param-type-mismatch, assign-type-mismatch
need({ kind = 1, n = 1 })

return need
