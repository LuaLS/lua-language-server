local check_state = require "luacheck.check_state"
local core_utils = require "luacheck.core_utils"
local parse_inline_options = require "luacheck.stages.parse_inline_options"
local parser = require "luacheck.parser"
local stages = require "luacheck.stages"
local utils = require "luacheck.utils"

local inline_option_fields = utils.array_to_set(parse_inline_options.inline_option_fields)

local function validate_fields(tables, per_code_fields)
   for _, t in ipairs(tables) do
      local fields_set

      if per_code_fields then
         if not t.code then
            error("Warning has no code", 0)
         end

         local warning_info = stages.warnings[t.code]

         if not warning_info then
            error("Unknown issue code " .. t.code, 0)
         end

         fields_set = warning_info.fields_set
      else
         fields_set = inline_option_fields
      end

      for field in pairs(t) do
         if not fields_set[field] then
            error("Unknown field " .. field .. " in " ..
               (per_code_fields and "issue with code " .. t.code or "inline option table"), 0)
         end
      end
   end
end

--- Checks source.
-- Returns a table with results, with the following fields:
--    `events`: array of issues and inline option events (options, push, or pop).
--    `per_line_options`: map from line numbers to arrays of inline option events.
--    `line_lengths`: map from line numbers to line lengths.
--    `line_endings`: map from line numbers to "comment", "string", or `nil` base on
--                    whether the line ending is within a token.
-- If `events` array contains a syntax error, the other fields are empty tables.
local function check(source)
   local chstate = check_state.new(source)
   local ok, error_wrapper = utils.try(stages.run, chstate)
   local warnings, inline_options, line_lengths, line_endings

   if ok then
      warnings = chstate.warnings
      core_utils.sort_by_location(warnings)
      inline_options = chstate.inline_options
      line_lengths = chstate.line_lengths
      line_endings = chstate.line_endings
   else
      local err = error_wrapper.err

      if not utils.is_instance(err, parser.SyntaxError) then
         error(error_wrapper, 0)
      end

      local syntax_error = {
         code = "011",
         line = err.line,
         column = chstate:offset_to_column(err.line, err.offset),
         end_column = chstate:offset_to_column(err.line, err.end_offset),
         msg = err.msg
      }

      if err.prev_line then
         syntax_error.prev_line = err.prev_line
         syntax_error.prev_column = chstate:offset_to_column(err.prev_line, err.prev_offset)
         syntax_error.prev_end_column = chstate:offset_to_column(err.prev_line, err.prev_end_offset)
      end

      warnings = {syntax_error}
      inline_options = {}
      line_lengths = {}
      line_endings = {}
   end

   validate_fields(warnings, true)
   validate_fields(inline_options)

   return {
      warnings = warnings,
      inline_options = inline_options,
      line_lengths = line_lengths,
      line_endings = line_endings
   }
end

return check
