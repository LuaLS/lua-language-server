local rt = test.scope.rt

TEST_INDEX [[
---@alias A B
---@alias B A
local t = {}
]]

print('A isTableLike:', rt.type('A'):isTableLike())
print('A truthy:', rt.type('A').truthy.typeName)
print('done')
