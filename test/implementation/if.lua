TEST [[
<!x!> = 1
if 1 then
    x = 1
else
    <?x?> = 1
end
]]

TEST [[
<!x!> = 1
if 1 then
    <!x!> = 1
else
    <!x!> = 1
end
<?x?> = 1
]]

TEST [[
<!x!> = 1
if 1 then
    <!x!> = 1
elseif 1 then
    <!x!> = 1
else
    <!x!> = 1
end
<?x?> = 1
]]

TEST [[
<!x!> = 1
if 1 then
    <!x!> = 1
elseif 1 then
    <!x!> = 1
    if 1 then
        <!x!> = 1
    end
else
    <!x!> = 1
end
<?x?> = 1
]]

TEST [[
<!x!> = 1
while true do
    <!x!> = 1
end
<?x?> = 1
]]

TEST [[
<!x!> = 1
for _ in _ do
    <!x!> = 1
end
<?x?> = 1
]]

TEST [[
<!x!> = 1
for _ = 1, 1 do
    <!x!> = 1
end
<?x?> = 1
]]

TEST [[
x = 1
repeat
    <!x!> = 1
until <?x?> == 1
]]

TEST [[
<!x!> = 1
repeat
    <!x!> = 1
until 1
<?x?> = 1
]]
