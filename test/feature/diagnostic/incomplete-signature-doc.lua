test.scope.config:set(test.rootUri, 'Lua.diagnostics.neededFileStatus', { ['incomplete-signature-doc'] = 'Any' })

TEST_DIAGNOSTIC [[
---@param p0 any
function f(p0, <?p1?>)
end
]] { 'incomplete-signature-doc' }

TEST_DIAGNOSTIC [[
---@param p0 any
---@param p1 any
function f(p0, p1)
end
]] { '-incomplete-signature-doc' }

TEST_DIAGNOSTIC [[
---@return integer
function f()
    return 0, <?1?>
end
]] { 'incomplete-signature-doc' }

TEST_DIAGNOSTIC [[
---@return integer
---@return integer
function f()
    return 0, 1
end
]] { '-incomplete-signature-doc' }

TEST_DIAGNOSTIC [[
---@param p any
function f(p)
    return <?0?>
end
]] { 'incomplete-signature-doc' }

TEST_DIAGNOSTIC [[
function f(p)
    return 0
end
]] { '-incomplete-signature-doc' }

test.scope.config:set(test.rootUri, 'Lua.diagnostics.neededFileStatus', nil)
