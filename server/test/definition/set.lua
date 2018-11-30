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
        x = 2
    end
    <?x?>()
end
]]
