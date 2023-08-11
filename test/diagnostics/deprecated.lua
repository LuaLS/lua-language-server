TEST [[
local _ = <!unpack!>
]]

TEST [[
T = {}
---@deprecated # comment
T.x = 1

print(<!T.x!>)
]]

TEST [[
T = {}

---@deprecated
function T:ff()
end

<!T:ff!>()
]]
