
local pairs = pairs
local next = next
local sort = table.sort
local type = type
local rawset = rawset
local move = table.move
local setmetatable = setmetatable

local function sort_table(tbl)
	if not tbl then
		tbl = {}
	end
	local mt = {}
	local keys = {}
	local mark = {}
	local n = 0
	for key in next, tbl do
		n=n+1;keys[n] = key
		mark[key] = true
	end
	sort(keys)
	function mt:__newindex(key, value)
		rawset(self, key, value)
		n=n+1;keys[n] = key
		mark[key] = true
		if type(value) == 'table' then
			sort_table(value)
		end
	end
	function mt:__pairs()
		local list = {}
		local m = 0
		for key in next, self do
			if not mark[key] then
				m=m+1;list[m] = key
			end
		end
		if m > 0 then
			move(keys, 1, n, m+1)
			sort(list)
			for i = 1, m do
				local key = list[i]
				keys[i] = key
				mark[key] = true
			end
			n = n + m
		end
		local i = 0
		return function ()
			i = i + 1
			local key = keys[i]
			return key, self[key]
		end
	end
	
	return setmetatable(tbl, mt)
end

return function (tbl)
    return sort_table(tbl)
end
