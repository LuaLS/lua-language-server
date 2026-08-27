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

test.scope.config:set(test.rootUri, 'Lua.diagnostics.globals', { 'foo' })
TEST_DIAGNOSTIC [[
foo = 1
print(foo)
]] { '-lowercase-global' }
test.scope.config:set(test.rootUri, 'Lua.diagnostics.globals', nil)

test.scope.config:set(test.rootUri, 'Lua.diagnostics.globalsRegex', { '^foo$' })
TEST_DIAGNOSTIC [[
foo = 1
print(foo)
]] { '-lowercase-global' }
test.scope.config:set(test.rootUri, 'Lua.diagnostics.globalsRegex', nil)