print('[feature.diagnostic.global-element] 测试中...')

test.scope.config:set(test.rootUri, 'Lua.diagnostics.neededFileStatus', { ['global-element'] = 'Any' })

TEST_DIAGNOSTIC [[
local x = 123
x = 321
<?Y?> = "global"
<?z?> = "global"
]] { 'global-element' }

TEST_DIAGNOSTIC [[
local function test1()
    print()
end
test1()
]] {}

TEST_DIAGNOSTIC [[
GLOBAL1 = "allowed"
<?global2?> = "not allowed"
<?GLOBAL3?> = "not allowed"
]] { 'global-element' }

test.scope.config:set(test.rootUri, 'Lua.diagnostics.globals', { 'GLOBAL1', 'GLOBAL2', 'GLOBAL3' })
TEST_DIAGNOSTIC [[
GLOBAL1 = "allowed"
GLOBAL2 = "allowed"
GLOBAL3 = "allowed"
]] { '-global-element' }
test.scope.config:set(test.rootUri, 'Lua.diagnostics.globals', nil)

test.scope.config:set(test.rootUri, 'Lua.diagnostics.globalsRegex', { '^FOO_' })
TEST_DIAGNOSTIC [[
FOO_bar = 1
<?bar?> = 2
]] { 'global-element' }
test.scope.config:set(test.rootUri, 'Lua.diagnostics.globalsRegex', nil)

TEST_DIAGNOSTIC [[
<?foo?> = 1
]] { 'global-element' }

test.scope.config:set(test.rootUri, 'Lua.diagnostics.neededFileStatus', nil)

print('[feature.diagnostic.global-element] 测试完毕')