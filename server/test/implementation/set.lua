TEST [[
<!x!> = 1
<?x?> = 1
]]

TEST [[
global = 1
do
    <!global!> = 2
end
<?global?> = 3
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
    local x = 1
    do
        <!x!> = 2
    end
    <?x?> = 1
end
]]
