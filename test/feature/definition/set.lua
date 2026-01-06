TEST_DEF [[
<!x!> = 1
<?x?>()
]]

TEST_DEF [[
do
    <!global!> = 1
end
<?global?>()
]]

TEST_DEF [[
<!x!> = 1
do
    local x = 1
end
<?x?>()
]]

TEST_DEF [[
x = 1
do
    local <!x!> = 1
    do
        x = 2
    end
    <?x?>()
end
]]

TEST_DEF [[
<!x!> = 1
if y then
    <!x!> = 2
else
    <!x!> = 3
end
print(<?x?>)
]]
