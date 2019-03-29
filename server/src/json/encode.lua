
local rep = string.rep
local format = string.format
local gsub = string.gsub
local sub = string.sub
local sort = table.sort
local find = string.find
local tostring = tostring
local getmetatable = debug.getmetatable
local type = type
local next = next
local ipairs = ipairs

local index
local lines
local n = -1
local tabs = {}

local esc_map = {
	['\\'] = '\\\\',
	['\r'] = '\\r',
	['\n'] = '\\n',
	['\t'] = '\\t',
	['"']  = '\\"',
}

local function encode(data, key)
	n = n + 1
	if not tabs[n] then
		tabs[n] = rep('    ', n)
	end
	local tp = type(data)
	if tp == 'table' then
		if not data[1] and next(data) then
			-- 认为这个是哈希表
			if key then
				index=index+1;lines[index] = tabs[n] .. '"' .. gsub(key, '[\\\r\n\t"]', esc_map) .. '": {\r\n'
			else
				index=index+1;lines[index] = tabs[n] .. '{\r\n'
			end
			local meta = getmetatable(data)
			local sep
			if meta and meta.__pairs then
				for k, v in meta.__pairs(data), data do
					if encode(v, k) then
						index=index+1;lines[index] = ',\r\n'
						sep = true
					end
				end
			else
				local list = {}
				local i = 0
				for k in next, data do
					i=i+1;list[i] = k
				end
				sort(list)
				for j = 1, i do
					local k = list[j]
					if encode(data[k], k) then
						index=index+1;lines[index] = ',\r\n'
						sep = true
					end
				end
			end
			if sep then
				lines[index] = '\r\n'
			end
			index=index+1;lines[index] = tabs[n] .. '}'
		else
			-- 认为这个是数组
			if key then
				index=index+1;lines[index] = tabs[n] .. '"' .. gsub(key, '[\\\r\n\t"]', esc_map) .. '": [\r\n'
			else
				index=index+1;lines[index] = tabs[n] .. '[\r\n'
			end
			local sep
			for k, v in pairs(data) do
				if encode(v) then
					index=index+1;lines[index] = ',\r\n'
					sep = true
				end
			end
			if sep then
				lines[index] = '\r\n'
			end
			index=index+1;lines[index] = tabs[n] .. ']'
		end
	elseif tp == 'number' then
		data = tostring(data)
		-- 判断 inf -inf -nan(ind) 1.#INF -1.#INF -1.#IND
		if find(data, '%a') then
			data = '0'
		end
		if key then
			index=index+1;lines[index] = tabs[n] .. '"' .. gsub(key, '[\\\r\n\t"]', esc_map) .. '": ' .. data
		else
			index=index+1;lines[index] = tabs[n] .. data
		end
	elseif tp == 'boolean' then
		if key then
			index=index+1;lines[index] = tabs[n] .. '"' .. gsub(key, '[\\\r\n\t"]', esc_map) .. '": ' .. tostring(data)
		else
			index=index+1;lines[index] = tabs[n] .. tostring(data)
		end
	elseif tp == 'nil' then
		if key then
			index=index+1;lines[index] = tabs[n] .. '"' .. gsub(key, '[\\\r\n\t"]', esc_map) .. '": null'
		else
			index=index+1;lines[index] = tabs[n] .. 'null'
		end
	elseif tp == 'string' then
		local str = gsub(data, '[\\\r\n\t"]', esc_map)
		if key then
			index=index+1;lines[index] = tabs[n] .. '"' .. gsub(key, '[\\\r\n\t"]', esc_map) .. '": "' .. str .. '"'
		else
			index=index+1;lines[index] = tabs[n] .. '"' .. str .. '"'
		end
	else
		n = n - 1
		return false
	end
	n = n - 1
	return true
end

local function json(t)
	lines = {}
	index = 0

	encode(t)

	return table.concat(lines)
end

return json
