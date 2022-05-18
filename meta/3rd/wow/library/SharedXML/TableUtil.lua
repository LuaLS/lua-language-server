---@meta
local function ripairsiter(table, index)
	index = index - 1;
	if index > 0 then
		return index, table[index];
	end
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/ripairs)
-- Reverse iterates over a sequential table. Example:
-- ```
-- for i, v in ripairs(tbl) do body end
-- ```
---@param table table
---@return function iter
---@return table invariant
---@return number init
function ripairs(table)
	return ripairsiter, table, #table + 1;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/tDeleteItem)
-- Removes a value from a sequential table.
---@param tbl table
---@param item any
function tDeleteItem(tbl, item)
	local index = 1;
	while tbl[index] do
		if ( item == tbl[index] ) then
			tremove(tbl, index);
		else
			index = index + 1;
		end
	end
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/tIndexOf)
-- Returns the index for a value in a table.
---@param tbl table
---@param item any
---@return number index
function tIndexOf(tbl, item)
	for i, v in ipairs(tbl) do
		if item == v then
			return i;
		end
	end
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/tContains)
-- Returns true if a table contains a value.
---@param tbl table
---@param item any
---@return boolean
function tContains(tbl, item)
	for k, v in pairs(tbl) do
		if item == v then
			return true;
		end
	end
	return false;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/tCompare)
-- This is a deep compare on the values of the table (based on depth) but not a deep comparison
-- of the keys, as this would be an expensive check and won't be necessary in most cases.
---@param lhsTable table
---@param rhsTable table
---@param depth? number
---@return boolean
function tCompare(lhsTable, rhsTable, depth)
	depth = depth or 1;
	for key, value in pairs(lhsTable) do
		if type(value) == "table" then
			local rhsValue = rhsTable[key];
			if type(rhsValue) ~= "table" then
				return false;
			end
			if depth > 1 then
				if not tCompare(value, rhsValue, depth - 1) then
					return false;
				end
			end
		elseif value ~= rhsTable[key] then
			return false;
		end
	end

	-- Check for any keys that are in rhsTable and not lhsTable.
	for key, value in pairs(rhsTable) do
		if lhsTable[key] == nil then
			return false;
		end
	end

	return true;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/tInvert)
-- Returns an inverted table.
---@param tbl table
---@return table
function tInvert(tbl)
	local inverted = {};
	for k, v in pairs(tbl) do
		inverted[v] = k;
	end
	return inverted;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/tFilter)
---@param tbl table
---@param pred function
---@param isIndexTable boolean
---@return table
function tFilter(tbl, pred, isIndexTable)
	local out = {};

	if (isIndexTable) then
		local currentIndex = 1;
		for i, v in ipairs(tbl) do
			if (pred(v)) then
				out[currentIndex] = v;
				currentIndex = currentIndex + 1;
			end
		end
	else
		for k, v in pairs(tbl) do
			if (pred(v)) then
				out[k] = v;
			end
		end
	end

	return out;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/tAppendAll)
-- Appends the contents of a sequential table to another table.
---@param table table
---@param addedArray table
function tAppendAll(table, addedArray)
	for i, element in ipairs(addedArray) do
		tinsert(table, element);
	end
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/tUnorderedRemove)
---@param tbl table
---@param index number
function tUnorderedRemove(tbl, index)
	if index ~= #tbl then
		tbl[index] = tbl[#tbl];
	end

	table.remove(tbl);
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/CopyTable)
-- Returns a deep copy of a table.
---@param settings table
---@return table
function CopyTable(settings)
	local copy = {};
	for k, v in pairs(settings) do
		if ( type(v) == "table" ) then
			copy[k] = CopyTable(v);
		else
			copy[k] = v;
		end
	end
	return copy;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/AccumulateIf)
---@param tbl table
---@param pred function
---@return number
function AccumulateIf(tbl, pred)
	local count = 0;
	for k, v in pairs(tbl) do
		if pred(v) then
			count = count + 1;
		end
	end
	return count;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/ContainsIf)
---@param tbl table
---@param pred function
---@return boolean
function ContainsIf(tbl, pred)
	for k, v in pairs(tbl) do
		if (pred(v)) then
			return true;
		end
	end

	return false;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/FindInTableIf)
---@param tbl table
---@param pred function
---@return string|number key
---@return any value
function FindInTableIf(tbl, pred)
	for k, v in pairs(tbl) do
		if (pred(v)) then
			return k, v;
		end
	end

	return nil;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/SafePack)
---@vararg any
---@return table
function SafePack(...)
	local tbl = { ... };
	tbl.n = select("#", ...);
	return tbl;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/SafeUnpack)
---@param tbl table
---@return ...
function SafeUnpack(tbl)
	return unpack(tbl, 1, tbl.n);
end
