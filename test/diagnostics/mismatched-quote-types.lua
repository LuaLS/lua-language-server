TEST [[
	local x = 'foo'
	local y = 'bar'
	local z = <!"baz"!>
]]

TEST [[
	local x = <!'foo'!>
	local y = "bar"
	local z = "baz"
]]

TEST [=[
	local x = [[foo]]
	local y = [[bar]]
	local z = "baz"
]=]

TEST [[
	local x = "foo"
	local y = "bar"
	local z = 'b"a"z'
]]

TEST [[
	local x = 'foo'
	local y = 'bar'
	local z = "b'a'z"
]]
