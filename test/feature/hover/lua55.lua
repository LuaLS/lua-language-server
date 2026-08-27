print('[feature.hover.lua55] 测试中...')

TEST_HOVER [[
global answer
answer = 42
print(answer<??>)
]] 'global answer: 42'

TEST_HOVER [[
function named(...args)
	print(<?args?>)
end
]] 'local args: { n: integer } & any[]'

TEST_HOVER [[
---@overload fun(x: number, y: number, z: number)
---@overload fun(v: string)
function new(...)
	local x, y, z = ...
	print(<?x?>)
end
]] 'local x: number | string'

TEST_HOVER [[
---@overload fun(x: number, y: number, z: number)
---@overload fun(v: string)
function new(...)
	local x, y, z = ...
	print(<?y?>)
end
]] 'local y: number | nil'

TEST_HOVER [[
---@overload fun(x: number, y: number, z: number)
---@overload fun(v: string)
function new(...)
	local x, y, z = ...
	print(<?z?>)
end
]] 'local z: number | nil'

TEST_HOVER [[
---@overload fun(x: number, ...)
function new(...)
	local a, b = ...
	print(<?a?>)
end
]] 'local a: number'

TEST_HOVER [[
---@overload fun(x: number, ...)
function new(...)
	local a, b = ...
	print(<?b?>)
end
]] 'local b: any'

TEST_HOVER [[
---@overload fun(...)
function new(...)
	local a = ...
	print(<?a?>)
end
]] 'local a: any'

TEST_HOVER [[
---@overload fun(x: number, y: number, z: number)
---@overload fun(v: string)
function new(...args)
	print(<?args?>)
end
]] (function(result)
	local label = result.items[1].label
	assert(label:find('[1]: number', 1, true))
	assert(label:find('[2]: number', 1, true))
	assert(label:find('[3]: number', 1, true))
	assert(label:find('n: 3', 1, true))
	assert(label:find('[1]: string', 1, true))
	assert(label:find('n: 1', 1, true))
end)

print('[feature.hover.lua55] 测试完毕')