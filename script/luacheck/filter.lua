local core_utils = require "luacheck.core_utils"
local decoder = require "luacheck.decoder"
local options = require "luacheck.options"
local utils = require "luacheck.utils"

local filter = {}

-- Returns two optional booleans indicating if warning matches pattern by code and name.
local function match(pattern, code, name)
   local matches_code, matches_name
   local code_pattern, name_pattern = pattern[1], pattern[2]

   if code_pattern then
      matches_code = utils.pmatch(code, code_pattern)
   end

   if name_pattern then
      if not name then
         -- Warnings without name field can't match by name.
         matches_name = false
      else
         matches_name = utils.pmatch(name, name_pattern)
      end
   end

   return matches_code, matches_name
end

local function passes_rules_filter(rules, code, name)
   -- A warning is enabled when its code and name are enabled.
   local enabled_code, enabled_name = false, false

   for _, rule in ipairs(rules) do
      local matches_one = false

      for _, pattern in ipairs(rule[1]) do
         local matches_code, matches_name = match(pattern, code, name)

         -- If a factor is enabled, warning can't be disabled by it.
         if enabled_code then
            matches_code = rule[2] ~= "disable"
         end

         if enabled_name then
            matches_code = rule[2] ~= "disable"
         end

         if (matches_code and matches_name ~= false) or
               (matches_name and matches_code ~= false) then
            matches_one = true
         end

         if rule[2] == "enable" then
            if matches_code then
               enabled_code = true
            end

            if matches_name then
               enabled_name = true
            end

            if enabled_code and enabled_name then
               -- Enable as matching to some `enable` pattern by code and to another by name.
               return true
            end
         elseif rule[2] == "disable" then
            if matches_one then
               -- Disable as matching to `disable` pattern.
               return false
            end
         end
      end

      if rule[2] == "only" and not matches_one then
         -- Disable as not matching to any of `only` patterns.
         return false
      end
   end

   -- Enable by default.
   return true
end

local function get_field_string(warning)
   local parts = {}

   if warning.indexing then
      for _, index in ipairs(warning.indexing) do
         local part

         if type(index) == "string" then
            local chars = decoder.decode(index)
            part = chars:get_printable_substring(1, chars:get_length())
         else
            part = "?"
         end

         table.insert(parts, part)
      end
   end

   return table.concat(parts, ".")
end

local function get_field_status(opts, warning, depth)
   local def = opts.std
   local defined = true
   local read_only = true

   for i = 1, depth or (warning.indexing and #warning.indexing or 0) + 1 do
      local index_string = i == 1 and warning.name or warning.indexing[i - 1]

      if index_string == true then
         -- Indexing with something that may or may not be a string.
         if (def.fields and next(def.fields)) or def.other_fields then
            if def.deep_read_only then
               read_only = true
            else
               read_only = false
            end
         else
            defined = false
         end

         break
      elseif index_string == false then
         -- Indexing with not a string.
         if not def.other_fields then
            defined = false
         end

         break
      else
         -- Indexing with a constant string.
         if def.fields and def.fields[index_string] then
            -- The field is defined, recurse into it.
            def = def.fields[index_string]

            if def.read_only ~= nil then
               read_only = def.read_only
            end
         else
            -- The field is not defined, but it may be okay to index if `other_fields` is true.
            if not def.other_fields then
               defined = false
            end

            break
         end
      end
   end

   return defined and (read_only and "read_only" or "global") or "undefined"
end

-- Checks if a warning passes options filter. May add some fields required for formatting.
local function passes_filter(normalized_options, warning)
   if warning.code == "561" then
      local max_complexity = normalized_options.max_cyclomatic_complexity

      if not max_complexity or warning.complexity <= max_complexity then
         return false
      end

      warning.max_complexity = max_complexity
   elseif warning.code:find("^[234]") and warning.name == "_" and not warning.useless then
      return false
   elseif warning.code:find("^1[14]") then
      if warning.indirect and
            get_field_status(normalized_options, warning, warning.previous_indexing_len) == "undefined" then
         return false
      end

      if not warning.module and get_field_status(normalized_options, warning) ~= "undefined" then
         return false
      end
   end

   if warning.code:find("^1[24][23]") then
      warning.field = get_field_string(warning)
   end

   if warning.secondary and not normalized_options.unused_secondaries then
      return false
   end

   if warning.self and not normalized_options.self then
      return false
   end

   return passes_rules_filter(normalized_options.rules, warning.code, warning.name)
end

local empty_options = {}

-- Updates option_stack for given line with next_index pointing to the inline option past the previous line.
-- Adds warnings for invalid inline options to check_result, filtered_warnings.
-- Returns updated next_index.
local function update_option_stack_for_new_line(check_result, stds, option_stack, line, next_index)
   local inline_option = check_result.inline_options[next_index]

   if not inline_option or inline_option.line > line then
      -- No inline options on this line, option stack for the line is ready.
      return next_index
   end

   next_index = next_index + 1

   if inline_option.pop_count then
      for _ = 1, inline_option.pop_count do
         table.remove(option_stack)
      end
   end

   if not inline_option.options then
      -- No inline option push on this line, option stack for the line is ready.
      return next_index
   end

   local options_ok, err_msg = options.validate(options.all_options, inline_option.options, stds)

   if not options_ok then
      -- Warn about invalid inline option, push a dummy empty table instead to keep pop counts correct.
      inline_option.options = nil
      inline_option.code = "021"
      inline_option.msg = err_msg
      table.insert(check_result.filtered_warnings, inline_option)

      -- Reuse empty table identity so that normalized option caching works better.
      table.insert(option_stack, empty_options)
   else
      table.insert(option_stack, inline_option.options)
   end

   return next_index
end

-- Warns (adds to check_result.filtered_warnings) about a line if it's too long
-- and the warning is not filtered out by options.
local function check_line_length(check_result, normalized_options, line)
   local line_length = check_result.line_lengths[line]
   local line_type = check_result.line_endings[line]
   local max_length = normalized_options["max_" .. (line_type or "code") .. "_line_length"]

   if max_length and line_length > max_length then
      if passes_rules_filter(normalized_options.rules, "631") then
         table.insert(check_result.filtered_warnings, {
            code = "631",
            line = line,
            column = max_length + 1,
            end_column = line_length,
            max_length = max_length,
            line_ending = line_type
         })
      end
   end
end

-- Adds warnings passing filtering and not related to globals to check_result.filtered_warnings.
-- If there is a global related warning on this line, sets check_results[line] to normalized_optuons.
local function filter_warnings_on_new_line(check_result, normalized_options, line, next_index)
   while true do
      local warning = check_result.warnings[next_index]

      if not warning or warning.line > line then
         -- No more warnings on this line.
         break
      end

      if warning.code:find("^1") then
         check_result.normalized_options[line] = normalized_options
      elseif passes_filter(normalized_options, warning) then
         table.insert(check_result.filtered_warnings, warning)
      end

      next_index = next_index + 1
   end

   return next_index
end

-- Normalizing options is relatively expensive because full std definitions are quite large.
-- `CachingOptionsNormalizer` implements a caching layer that reduces number of `options.normalize` calls.
-- Caching is done based on identities of option tables.

local CachingOptionsNormalizer = utils.class()

function CachingOptionsNormalizer:__init()
   self.result_trie = {}
end

function CachingOptionsNormalizer:normalize_options(stds, option_stack)
   local result_node = self.result_trie

   for _, option_table in ipairs(option_stack) do
      if not result_node[option_table] then
         result_node[option_table] = {}
      end

      result_node = result_node[option_table]
   end

   if result_node.result then
      return result_node.result
   end

   local result = options.normalize(option_stack, stds)
   result_node.result = result
   return result
end

-- May mutate base_opts_stack.
local function filter_not_global_related_in_file(check_result, options_normalizer, stds, option_stack)
   check_result.filtered_warnings = {}
   check_result.normalized_options = {}

   -- Iterate over lines, warnings, and inline options at the same time, keeping opts_stack up to date.
   local next_warning_index = 1
   local next_inline_option_index = 1

   for line in ipairs(check_result.line_lengths) do
      next_inline_option_index = update_option_stack_for_new_line(
         check_result, stds, option_stack, line, next_inline_option_index)
      local normalized_options = options_normalizer:normalize_options(stds, option_stack)
      check_line_length(check_result, normalized_options, line)
      next_warning_index = filter_warnings_on_new_line(check_result, normalized_options, line, next_warning_index)
   end
end

local function may_have_options(opts_table)
   for key in pairs(opts_table) do
      if type(key) == "string" then
         return true
      end
   end

   return false
end

local function get_option_stack(opts, file_index)
   local res = {opts}

   if opts and opts[file_index] then
      -- Don't add useless per-file option tables, that messes up normalized option caching
      -- since it memorizes based on option table identities.
      if may_have_options(opts[file_index]) then
         table.insert(res, opts[file_index])
      end

      for _, nested_opts in ipairs(opts[file_index]) do
         table.insert(res, nested_opts)
      end
   end

   return res
end

-- For each file check result:
-- * Stores invalid inline options, not filtered out not global-related warnings, and newly created line length warnings
--   in .filtered_warnings.
-- * Stores a map from line numbers to normalized options for lines of global-related warnings in .normalized_options.
local function filter_not_global_related(check_results, opts, stds)
   local caching_options_normalizer = CachingOptionsNormalizer()

   for file_index, check_result in ipairs(check_results) do
      if not check_result.fatal then
         if check_result.warnings[1] and check_result.warnings[1].code == "011" then
            -- Special case syntax errors, they don't have line numbers so normal filtering does not work.
            check_result.filtered_warnings = check_result.warnings
            check_result.normalized_options = {}
         else
            local base_file_option_stack = get_option_stack(opts, file_index)
            filter_not_global_related_in_file(check_result, caching_options_normalizer, stds, base_file_option_stack)
         end
      end
   end
end

-- A global is implicitly defined in a file if opts.allow_defined == true and it is set anywhere in the file,
--    or opts.allow_defined_top == true and it is set in the top level function scope.
-- By default, accessing and setting globals in a file is allowed for explicitly defined globals (standard and custom)
--    for that file and implicitly defined globals from that file and
--    all other files except modules (files with opts.module == true).
-- Accessing other globals results in "accessing undefined variable" warning.
-- Setting other globals results in "setting non-standard global variable" warning.
-- Unused implicitly defined global results in "unused global variable" warning.
-- For modules, accessing globals uses same rules as normal files, however,
--    setting globals is only allowed for implicitly defined globals from the module.
-- Setting a global not defined in the module results in "setting non-module global variable" warning.

local function is_definition(normalized_options, warning)
   return normalized_options.allow_defined or (normalized_options.allow_defined_top and warning.top)
end

-- Extracts sets of defined, exported and used globals from a file check result.
local function get_implicit_globals_in_file(check_result)
   local defined = {}
   local exported = {}
   local used = {}

   for _, warning in ipairs(check_result.warnings) do
      if warning.code:find("^11") then
         if warning.code == "111" then
            local normalized_options = check_result.normalized_options[warning.line]

            if is_definition(normalized_options, warning) then
               if normalized_options.module then
                  defined[warning.name] = true
               else
                  exported[warning.name] = true
               end
            end
         else
            used[warning.name] = true
         end
      end
   end

   return defined, exported, used
end

-- Returns set of globals defines across all files except modules, a set of globals used across all files,
-- and an array of sets of globals defined per file, parallel to the check results array.
local function get_implicit_globals(check_results)
   local globally_defined = {}
   local globally_used = {}
   local locally_defined = {}

   for file_index, check_result in ipairs(check_results) do
      if not check_result.fatal then
         local defined, exported, used = get_implicit_globals_in_file(check_result)
         utils.update(globally_defined, exported)
         utils.update(globally_used, used)
         locally_defined[file_index] = defined
      end
   end

   return globally_defined, globally_used, locally_defined
end

-- Mutates the warning and returns it or discards it by returning nothing if it's filtered out.
local function apply_implicit_definitions(globally_defined, globally_used, locally_defined, normalized_options, warning)
   if not warning.code:find("^11") then
      return warning
   end

   if warning.code == "111" then
      if normalized_options.module then
         if locally_defined[warning.name] then
            return
         end

         warning.module = true
      else
         if is_definition(normalized_options, warning) then
            if globally_used[warning.name] then
               return
            end

            warning.code = "131"
            warning.top = nil
         else
            if globally_defined[warning.name] then
               return
            end
         end
      end
   else
      if globally_defined[warning.name] or locally_defined[warning.name] then
         return
      end
   end

   return warning
end

local function filter_global_related_in_file(check_result, globally_defined, globally_used, locally_defined)
   for _, warning in ipairs(check_result.warnings) do
      if warning.code:find("^1") then
         local normalized_options = check_result.normalized_options[warning.line]
         warning = apply_implicit_definitions(
            globally_defined, globally_used, locally_defined, normalized_options, warning)

         if warning then
            if warning.code:find("^11[12]") and not warning.module and
                  get_field_status(normalized_options, warning) == "read_only" then
               warning.code = "12" .. warning.code:sub(3, 3)
            elseif warning.code:find("^11[23]") and get_field_status(normalized_options, warning, 1) ~= "undefined" then
               warning.code = "14" .. warning.code:sub(3, 3)
            end

            if warning.code:match("11[23]") and get_field_status(normalized_options, warning, 1) ~= "undefined" then
               warning.code = "14" .. warning.code:sub(3, 3)
            end

            if passes_filter(normalized_options, warning) then
               table.insert(check_result.filtered_warnings, warning)
            end
         end
      end
   end
end

local function filter_global_related(check_results)
   local globally_defined, globally_used, locally_defined = get_implicit_globals(check_results)

   for file_index, check_result in ipairs(check_results) do
      if not check_result.fatal then
         filter_global_related_in_file(check_result, globally_defined, globally_used, locally_defined[file_index])
      end
   end
end

-- Processes an array of results of the check stage (or tables with .fatal field) into the final report.
-- `opts[i]`, if present, is used as options when processing `report[i]` together with options in its array part.
-- This function may mutate check results or reuse its parts in the return value.
function filter.filter(check_results, opts, stds)
   filter_not_global_related(check_results, opts, stds)
   filter_global_related(check_results)

   local report = {}

   for file_index, check_result in ipairs(check_results) do
      if check_result.fatal then
         report[file_index] = check_result
      else
         core_utils.sort_by_location(check_result.filtered_warnings)
         report[file_index] = check_result.filtered_warnings
      end
   end

   return report
end

return filter
