-- if 分支里的赋值没有与「条件不成立」那条路的值合并：分支赋值把旧值顶掉了
-- （`c` 在 if 之后应是 `reproP | reproQ`，现在只剩 `reproQ` ⇒ `c.a` 误报未定义字段）
-- 同族 = 目标工程 `script/vm/operator.lua:157`（if 块里 `---@cast`/赋值后，块外读 `c.node`）
-- 现状：去掉下面那行 disable 就报；两条修法都试过但目标工程净变差，见
-- `.github/skills/luals-server-dev/references/facts/narrowing.md` F21

---@class reproP
---@field a integer?

---@class reproQ
---@field b integer

---@type reproQ
local G

---@param v reproP | reproQ
---@return integer?
local function f(v)
    local c = v
    if c.a then
        c = G
    end
    ---@diagnostic disable-next-line: undefined-field
    return c.a
end

return f
