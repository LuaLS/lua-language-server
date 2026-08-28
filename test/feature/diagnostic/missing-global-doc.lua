test.scope.config:set(test.rootUri, 'Lua.diagnostics.neededFileStatus', { ['missing-global-doc'] = 'Any' })

TEST_DIAGNOSTIC [[
<?function F()
end?>
]] { 'missing-global-doc' }

TEST_DIAGNOSTIC [[
---@comment
function F()
end
]] { 'missing-global-doc' }

TEST_DIAGNOSTIC [[
function F(<?p?>)
end
]] { 'missing-global-doc' }

TEST_DIAGNOSTIC [[
---@param p any
function F(p)
end
]] { '-missing-global-doc' }

TEST_DIAGNOSTIC [[
function F()
    return <?0?>
end
]] { 'missing-global-doc' }

TEST_DIAGNOSTIC [[
---@return integer
function F()
    return 0
end
]] { '-missing-global-doc' }

TEST_DIAGNOSTIC [[
---@param p any
---@return integer
function F(p)
    return p
end
]] { '-missing-global-doc' }

TEST_DIAGNOSTIC [[
local function F()
end
F()
]] { '-missing-global-doc' }

test.scope.config:set(test.rootUri, 'Lua.diagnostics.neededFileStatus', nil)
