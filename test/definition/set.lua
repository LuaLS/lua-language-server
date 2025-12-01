TEST [[
<!x!> = 1
<?x?>()
]]

TEST [[
do
    <!global!> = 1
end
<?global?>()
]]

TEST [[
<!x!> = 1
do
    local x = 1
end
<?x?>()
]]

TEST [[
x = 1
do
    local <!x!> = 1
    do
        <!x!> = 2
    end
    <?x?>()
end
]]

TEST [[
<!x!> = 1
if y then
    <!x!> = 2
else
    <!x!> = 3
end
print(<?x?>)
]]

TEST([[
local x
global <!x!> = 1

<?x?>
]], 'Lua 5.5')

TEST([[
global x = 1
local <!x!>

<?x?>
]], 'Lua 5.5')
