TEST_DIAGNOSTIC [[
<?break?>
]] { 'break-outside' }

do
    local scope = test.scope
    scope.roots[#scope.roots+1] = {
        uri  = test.rootUri,
        kind = 'workspace',
        glob = { check = function () return true end },
    }
    local root = scope.roots[#scope.roots]

    test.scope.config:set(test.rootUri, 'Lua.diagnostics.ignoredFiles', 'Disable')
    TEST_DIAGNOSTIC [[
    break
    ]] {}

    test.scope.config:set(test.rootUri, 'Lua.diagnostics.ignoredFiles', 'Enable')
    TEST_DIAGNOSTIC [[
    <?break?>
    ]] { 'break-outside' }
    test.scope.config:set(test.rootUri, 'Lua.diagnostics.ignoredFiles', nil)

    root.kind = 'library'
    test.scope.config:set(test.rootUri, 'Lua.diagnostics.libraryFiles', 'Disable')
    TEST_DIAGNOSTIC [[
    break
    ]] {}
    test.scope.config:set(test.rootUri, 'Lua.diagnostics.libraryFiles', nil)

    table.remove(scope.roots)
end

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