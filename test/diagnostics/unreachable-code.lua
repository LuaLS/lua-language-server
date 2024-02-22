TEST [[
if X then
    return false
elseif X then
    return false
else
    return false
end
<!return true!>
]]

TEST [[
function X()
    if X then
        return false
    elseif X then
        return false
    else
        return false
    end
    <!return true!>
end
]]

TEST [[
while true do
end

<!print(1)!>
]]

TEST [[
while true do
end

<!print(1)!>
]]

TEST [[
while X do
    X = 1
end

print(1)
]]

TEST [[
while true do
    if not X then
        break
    end
end

print(1)

do return end
]]

TEST [[
local done = false

local function set_done()
    done = true
end

while not done do
    set_done()
end

print(1)
]]
