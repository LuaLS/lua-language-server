-- 字段判等收窄的**假分支**（otherSide）成员分类：与「type ≠ 值」相容的成员不该被丢掉
-- （`reproOfA` 的 `type` 是多值 `string`，本可以 ≠ 'x'，修前却被当成「能取 x」排除了）
-- ⇒ 假分支里读该成员独有的字段误报未定义字段（已修，台账 F23）
-- 同族 = 目标工程 `script/core/completion/completion.lua:1365`（`src` 被收窄成 never）

---@class reproOfA
---@field type string
---@field onlyA integer

---@class reproOfB
---@field type 'b'

---@alias reproOfU reproOfA | reproOfB

---@param src reproOfU
---@return integer?
local function f(src)
    if src.type == 'x' then
        return nil
    end
    return src.onlyA
end

return f
