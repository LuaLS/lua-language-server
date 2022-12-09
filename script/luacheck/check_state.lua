local utils = require "luacheck.utils"

local check_state = {}

local CheckState = utils.class()

function CheckState:__init(source_bytes)
   self.source_bytes = source_bytes
   self.warnings = {}
end

-- Returns column of a character in a line given its offset.
-- The column is never larger than the line length.
-- This can be called if line length is not yet known.
function CheckState:offset_to_column(line, offset)
   local line_length = self.line_lengths[line]
   local column = offset - self.line_offsets[line] + 1

   if not line_length then
      return column
   end

   return math.max(1, math.min(line_length, column))
end

function CheckState:warn_column_range(code, range, warning)
   warning = warning or {}
   warning.code = code
   warning.line = range.line
   warning.column = range.column
   warning.end_column = range.end_column
   table.insert(self.warnings, warning)
   return warning
end

function CheckState:warn(code, line, offset, end_offset, warning)
   warning = warning or {}
   warning.code = code
   warning.line = line
   warning.column = self:offset_to_column(line, offset)
   warning.end_column = self:offset_to_column(line, end_offset)
   table.insert(self.warnings, warning)
   return warning
end

function CheckState:warn_range(code, range, warning)
   return self:warn(code, range.line, range.offset, range.end_offset, warning)
end

function CheckState:warn_var(code, var, warning)
   warning = self:warn_range(code, var.node, warning)
   warning.name = var.name
   return warning
end

function CheckState:warn_value(code, value, warning)
   warning = self:warn_range(code, value.var_node, warning)
   warning.name = value.var.name
   return warning
end

function check_state.new(source_bytes)
   return CheckState(source_bytes)
end

return check_state
