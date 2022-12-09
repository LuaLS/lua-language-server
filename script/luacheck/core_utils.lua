local decoder = require "luacheck.decoder"
local utils = require "luacheck.utils"

local core_utils = {}

-- Attempts to evaluate a node as a Lua value, without resolving locals.
-- Returns Lua value and its string representation on success, nothing on failure.
function core_utils.eval_const_node(node)
   if node.tag == "True" then
      return true, "true"
   elseif node.tag == "False" then
      return false, "false"
   elseif node.tag == "String" then
      local chars = decoder.decode(node[1])
      return node[1], chars:get_printable_substring(1, chars:get_length())
   else
      local is_negative

      if node.tag == "Op" and node[1] == "unm" then
         is_negative = true
         node = node[2]
      end

      if node.tag ~= "Number" then
         return
      end

      local str = node[1]

      if str:find("[iIuUlL]") then
         -- Ignore LuaJIT cdata literals.
         return
      end

      -- On Lua 5.3 convert to float to get same results as on Lua 5.1 and 5.2.
      if _VERSION == "Lua 5.3" and not str:find("[%.eEpP]") then
         str = str .. ".0"
      end

      local number = tonumber(str)

      if not number then
         return
      end

      if is_negative then
         number = -number
      end

      if number == number and number < 1/0 and number > -1/0 then
         return number, (is_negative and "-" or "") .. node[1]
      end
   end
end

local statement_containing_tags = utils.array_to_set({"Do", "While", "Repeat", "Fornum", "Forin", "If"})

-- `items` is an array of nodes or nested item arrays.
local function scan_for_statements(chstate, items, tags, callback, ...)
   for _, item in ipairs(items) do
      if tags[item.tag] then
         callback(chstate, item, ...)
      end

      if not item.tag or statement_containing_tags[item.tag] then
         scan_for_statements(chstate, item, tags, callback, ...)
      end
   end
end

-- Calls `callback(chstate, node, ...)` for each statement node within AST with tag in given array.
function core_utils.each_statement(chstate, tags_array, callback, ...)
   local tags = utils.array_to_set(tags_array)

   for _, line in ipairs(chstate.lines) do
      scan_for_statements(chstate, line.node[2], tags, callback, ...)
   end
end

local function location_comparator(warning1, warning2)
   if warning1.line ~= warning2.line then
      return warning1.line < warning2.line
   elseif warning1.column ~= warning2.column then
      return warning1.column < warning2.column
   else
      return warning1.code < warning2.code
   end
end

-- Sorts an array of warnings by location information as provided in `line` and `column` fields.
function core_utils.sort_by_location(warnings)
   table.sort(warnings, location_comparator)
end

return core_utils
