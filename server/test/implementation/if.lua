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
x3 = 1
repeat
    <!x3!> = 1
until <?x3?> == 1
]]

TEST [[
<!x!> = 1
repeat
    <!x!> = 1
until 1
<?x?> = 1
]]

TEST [[
<!x!> = 1
while 1 do
    x = 1
    <!x!> = 1
end
<?x?> = 1
]]

TEST [[
<!x!> = 1
if 1 then
    if 1 then
        x = 1
    end
else
    if 1 then
        <?x?> = 1
    end
end
]]
