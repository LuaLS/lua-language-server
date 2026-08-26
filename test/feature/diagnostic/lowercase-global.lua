TEST_DIAGNOSTIC [[
<?foo?> = 1
]] { 'lowercase-global' }

TEST_DIAGNOSTIC [[
local foo = 1
print(foo)
]] {}

TEST_DIAGNOSTIC [[
Foo = 1
]] {}

TEST_DIAGNOSTIC [[
foo = 1
print(foo)
]] { 'lowercase-global' }
