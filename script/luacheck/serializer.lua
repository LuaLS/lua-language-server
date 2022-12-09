local parse_inline_options = require "luacheck.stages.parse_inline_options"
local stages = require "luacheck.stages"
local utils = require "luacheck.utils"

local serializer = {}

local option_fields = {
   "ignore", "std", "globals", "unused_args", "self", "compat", "global", "unused", "redefined",
   "unused_secondaries", "allow_defined", "allow_defined_top", "module",
   "read_globals", "new_globals", "new_read_globals", "enable", "only", "not_globals",
   "max_line_length", "max_code_line_length", "max_string_line_length", "max_comment_line_length",
   "max_cyclomatic_complexity"
}

local function compress_table(t, fields)
   local res = {}

   for index, field in ipairs(fields) do
      local value = t[field]

      if value ~= nil then
         if field == "options" then
            value = compress_table(value, option_fields)
         end

         res[index] = value
      end
   end

   return res
end

local function compress_tables(tables, per_code_fields)
   local res = {}

   for _, t in ipairs(tables) do
      local fields = per_code_fields and stages.warnings[t.code].fields or parse_inline_options.inline_option_fields
      table.insert(res, compress_table(t, fields))
   end

   return res
end

local function compress_result(result)
   local res = {}
   res[1] = compress_tables(result.warnings, true)
   res[2] = compress_tables(result.inline_options)
   res[3] = result.line_lengths
   res[4] = result.line_endings
   return res
end

local function decompress_table(t, fields)
   local res = {}

   for index, field in ipairs(fields) do
      local value = t[index]

      if value ~= nil then
         if field == "options" then
            value = decompress_table(value, option_fields)
         end

         res[field] = value
      end
   end

   return res
end

local function decompress_tables(tables, per_code_fields)
   local res = {}

   for _, t in ipairs(tables) do
      local fields

      if per_code_fields then
         fields = stages.warnings[t[1]].fields
      else
         fields = parse_inline_options.inline_option_fields
      end

      table.insert(res, decompress_table(t, fields))
   end

   return res
end

local function decompress_result(compressed)
   local result = {}
   result.warnings = decompress_tables(compressed[1], true)
   result.inline_options = decompress_tables(compressed[2])
   result.line_lengths = compressed[3]
   result.line_endings = compressed[4]
   return result
end

local function get_local_name(index)
   return string.char(index + (index > 26 and 70 or 64))
end

local function max_n(t)
   local res = 0

   for k in pairs(t) do
      res = math.max(res, k)
   end

   return res
end

-- Serializes a value into buffer.
-- `strings` is a table mapping string values to where they first occured or to name of local
-- variable used to represent it.
-- Array part contains representations of values saved into locals.
local function add_value(buffer, strings, value, level)
   if type(value) == "string" then
      local prev = strings[value]

      if type(prev) == "string" then
         -- There is a local with such value.
         table.insert(buffer, prev)
      elseif type(prev) == "number" and #strings < 52 then
         -- Value is used second time, put it into a local.
         table.insert(strings, ("%q"):format(value))
         local local_name = get_local_name(#strings)
         buffer[prev] = local_name
         table.insert(buffer, local_name)
         strings[value] = local_name
      else
         table.insert(buffer, ("%q"):format(value))
         strings[value] = #buffer
      end
   elseif type(value) == "table" then
      -- Level 1 has the result, level 2 has warning/inline option/line info arrays,
      -- level 3 has warnings/inline option containers, level 4 has inline options.
      local allow_sparse = level ~= 3
      local nil_tail_start
      local is_sparse
      local put_one
      table.insert(buffer, "{")

      for index = 1, max_n(value) do
         local item = value[index]

         if item == nil then
            is_sparse = allow_sparse
            nil_tail_start = nil_tail_start or index
         else
            if put_one then
               table.insert(buffer, ",")
            end

            if is_sparse then
               table.insert(buffer, ("[%d]="):format(index))
            elseif nil_tail_start then
               for _ = nil_tail_start, index - 1 do
                  table.insert(buffer, "nil,")
               end

               nil_tail_start = nil
            end

            add_value(buffer, strings, item, level + 1)
            put_one = true
         end
      end

      table.insert(buffer, "}")
   else
      table.insert(buffer, tostring(value))
   end
end

-- Serializes check result, returns a string.
function serializer.dump_check_result(result)
   local strings = {}
   local buffer = {"", "return "}
   add_value(buffer, strings, compress_result(result), 1)

   if strings[1] then
      local names = {}

      for index in ipairs(strings) do
         table.insert(names, get_local_name(index))
      end

      buffer[1] = "local " .. table.concat(names, ",") .. "=" .. table.concat(strings, ",") .. ";"
   end

   return table.concat(buffer)
end

-- Loads check result from a string, returns check result table or nothing on error.
function serializer.load_check_result(dumped)
   local func = utils.load(dumped, {})

   if not func then
      return
   end

   local ok, compressed_result = pcall(func)

   if not ok or type(compressed_result) ~= "table" then
      return
   end

   return decompress_result(compressed_result)
end

return serializer
