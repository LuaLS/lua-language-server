TEST [[
<!x!> = 1
<?x?> = 1
]]

TEST [[
do
    <!global!> = 1
end
<?global?> = 1
]]

TEST [[
<!x!> = 1
do
    local x = 1
end
<?x?> = 1
]]

TEST [[
x = 1
do
    local <!x!> = 1
    do
        x = 2
    end
    <?x?> = 1
end
]]
