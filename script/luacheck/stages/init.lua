local utils = require "luacheck.utils"

local stages = {}

-- Checking is organized into stages run one after another.
-- Each stage is in its own module and provides `run` function operating on a check state,
-- and optionally `warnings` table mapping issue codes to tables with fields `message_format`
-- containing format string for the issue or a function returning it given the issue,
-- and `fields` containing array of extra fields this warning can have.

stages.names = {
   "parse",
   "unwrap_parens",
   "linearize",
   "parse_inline_options",
   "name_functions",
   "resolve_locals",
   "detect_bad_whitespace",
   "detect_cyclomatic_complexity",
   "detect_empty_blocks",
   "detect_empty_statements",
   "detect_globals",
   "detect_reversed_fornum_loops",
   "detect_unbalanced_assignments",
   "detect_uninit_accesses",
   "detect_unreachable_code",
   "detect_unused_fields",
   "detect_unused_locals"
}

local log = require("log")
stages.modules = {}

for _, name in ipairs(stages.names) do
   local m,_ = require("luacheck.stages." .. name)
   table.insert(stages.modules, m)
end

stages.warnings = {}

local base_fields = {"code", "line", "column", "end_column"}

local function register_warnings(warnings)
   for code, warning in pairs(warnings) do
      assert(not stages.warnings[code])
      assert(warning.message_format)
      assert(warning.fields)

      local full_fields = utils.concat_arrays({base_fields, warning.fields})

      stages.warnings[code] = {
         message_format = warning.message_format,
         fields = full_fields,
         fields_set = utils.array_to_set(full_fields)
      }
   end
end

-- Issues that do not originate from normal check stages (excluding global related ones).
register_warnings({
   ["011"] = {message_format = "{msg}", fields = {"msg", "prev_line", "prev_column", "prev_end_column"}},
   ["631"] = {message_format = "line is too long ({end_column} > {max_length})", fields = {}}
})

for _, stage_module in ipairs(stages.modules) do
   if stage_module.warnings then
      register_warnings(stage_module.warnings)
   end
end

function stages.run(chstate)
   for _, stage_module in ipairs(stages.modules) do
      stage_module.run(chstate)
   end
end

return stages
