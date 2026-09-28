-- 联合体成员里有一个**没有该字段**时，`x.field` 的读值是否带 nil（另一个成员有该字段且有类型）
-- 现状（未满足，台账 F24）：带 nil ⇒ 传给非可选形参误报；去掉 disable 即见
-- 同族 = 目标工程 `completion.lua:1365` 的残留（`src` = `vm.object`，`src.node` = `parser.object | nil`，
-- 因为 `vm.generic` 没有声明 `---@field node`）

---@class reproUmA
---@field type string
---@field node integer

---@class reproUmB
---@field type string

---@alias reproUmU reproUmA | reproUmB

---@param v integer
---@return integer
local function needInteger(v)
    return v
end

---@param src reproUmU
---@return integer
local function f(src)
    ---@diagnostic disable-next-line: param-type-mismatch
    return needInteger(src.node)
end

return f
