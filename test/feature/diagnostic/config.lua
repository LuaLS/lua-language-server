TEST_DIAGNOSTIC [[
<?break?>
]] { 'break-outside' }

test.scope.config:set(test.rootUri, 'Lua.diagnostics.disable', { 'break-outside' })
TEST_DIAGNOSTIC [[
break
]] {}
test.scope.config:set(test.rootUri, 'Lua.diagnostics.disable', nil)

test.scope.config:set(test.rootUri, 'Lua.diagnostics.enable', false)
TEST_DIAGNOSTIC [[
break
local x =
]] {}
test.scope.config:set(test.rootUri, 'Lua.diagnostics.enable', nil)

TEST_DIAGNOSTIC [[
<?break?>
]] { 'break-outside' }