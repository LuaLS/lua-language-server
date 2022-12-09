local cache = require "luacheck.cache"
local config = require "luacheck.config"
local expand_rockspec = require "luacheck.expand_rockspec"
local format = require "luacheck.format"
local fs = require "luacheck.fs"
local globbing = require "luacheck.globbing"
local luacheck = require "luacheck"
local multithreading = require "luacheck.multithreading"
local options = require "luacheck.options"
local utils = require "luacheck.utils"

local runner = {}

local Runner = utils.class()

function Runner:__init(config_stack)
   self._config_stack = config_stack
end

local config_options = {
   config = utils.has_type_or_false("string"),
   default_config = utils.has_type_or_false("string")
}

function runner.new(opts)
   local ok, err = options.validate(config_options, opts)

   if not ok then
      error(("bad argument #1 to 'runner.new' (%s)"):format(err))
   end

   local base_config, config_err = config.load_config(opts.config, opts.default_config)

   if not base_config then
      return nil, config_err
   end

   local override_config = config.table_to_config(opts)

   local config_stack
   config_stack, err = config.stack_configs({base_config, override_config})

   if not config_stack then
      return nil, err
   end

   return Runner(config_stack)
end

local function validate_inputs(inputs)
   if type(inputs) ~= "table" then
      return nil, ("inputs table expected, got %s"):format(inputs)
   end

   for index, input in ipairs(inputs) do
      local context = ("invalid input table at index [%d]"):format(index)

      if type(input) ~= "table" then
         return nil, ("%s: table expected, got %s"):format(context, type(input))
      end

      local specifies_source

      for _, field in ipairs({"file", "filename", "path", "rockspec_path", "string"}) do
         if input[field] ~= nil then
            if field == "file" then
               if io.type(input[field]) ~= "file" then
                  return nil, ("%s: invalid field 'file': open file expected, got %s"):format(
                     context, type(input[field]))
               end
            elseif type(input[field]) ~= "string" then
               return nil, ("%s: invalid field '%s': string expected, got %s"):format(
                  context, field, type(input[field]))
            end

            if field ~= "filename" then
               specifies_source = true
            end
         end
      end

      if not specifies_source then
         return nil, ("%s: one of fields 'path', 'rockspec_path', 'file', or 'string' must be present"):format(context)
      end
   end

   return true
end

local function matches_any(globs, filename)
   for _, glob in ipairs(globs) do
      if globbing.match(glob, filename) then
         return true
      end
   end

   return false
end

function Runner:_is_filename_included(abs_filename)
   return not matches_any(self._top_opts.exclude_files, abs_filename) and (
      #self._top_opts.include_files == 0 or matches_any(self._top_opts.include_files, abs_filename))
end

-- Normalizes inputs and filters inputs using `exclude_files` and `include_files` options.
-- Returns an array of prepared input tables.
-- Differences between normal and prepated inputs:
-- * Prepared inputs can't have `rockspec_path` field.
-- * Prepared inputs can't have `path` pointing to a directory (unless it has an error).
-- * Prepared inputs have `filename` field if possible (copied from `path` if not given).
-- * Prepared inputs that have `path` field also have `abs_path` field.
-- * Prepared inputs can have `fatal` field if the input can't be checked. The value is error type as a string.
--   `fatal` is always accompanied by an error message in `msg` field.
function Runner:_prepare_inputs(inputs)
   local current_dir = fs.get_current_dir()
   local dir_pattern = #self._top_opts.include_files > 0 and "" or "%.lua$"

   local res = {}

   local function add(input)
      if input.path then
         -- TODO: get rid of this, adjust fs.extract_files to avoid leading `./` instead.
         input.path = input.path:gsub("^%.[/\\]([^/])", "%1")
         input.abs_path = fs.normalize(fs.join(current_dir, input.path))
      end

      local abs_filename

      if input.filename then
         abs_filename = fs.normalize(fs.join(current_dir, input.filename))
      else
         input.filename = input.path
         abs_filename = input.abs_path
      end

      if not input.filename or self:_is_filename_included(abs_filename) then
         table.insert(res, input)
      end
   end

   for _, input in ipairs(inputs) do
      if input.path then
         if fs.is_dir(input.path) then
            local filenames, err_map = fs.extract_files(input.path, dir_pattern)

            for _, filename in ipairs(filenames) do
               local err = err_map[filename]
               if err then
                  add({path = filename, fatal = "I/O", msg = err, filename = input.filename})
               else
                  add({path = filename, filename = input.filename})
               end
            end
         else
            add({path = input.path, filename = input.filename})
         end
      elseif input.rockspec_path then
         local filenames, fatal, err = expand_rockspec(input.rockspec_path)

         if filenames then
            for _, filename in ipairs(filenames) do
               add({path = filename, filename = input.filename})
            end
         else
            add({path = input.rockspec_path, fatal = fatal, msg = err, filename = input.filename})
         end
      elseif input.file then
         add({file = input.file, filename = input.filename})
      elseif input.string then
         add({string = input.string, filename = input.filename})
      else
         -- Validation should ensure this never happens.
         error("input doesn't specify source to check")
      end
   end

   return res
end

-- Loads cached reports for inputs with `path` field, assigns them to `cached_report` field.
-- For each file on cache load error sets its `fatal` and `msg` fields.
function Runner:_add_cached_reports(inputs)
   for _, input in ipairs(inputs) do
      if not input.fatal and input.path then
         local report, err = self._cache:get(input.path)

         if err then
            input.fatal = "I/O"
            input.msg = ("Couldn't load cache for %s from %s: malformed data"):format(
               self._top_opts.cache, input.path)
         else
            input.cached_report = report
         end
      end
   end
end

-- Adds report as `new_report` field to all inputs that don't have a fatal error or a cached report.
-- Adds `fatal` and `msg` instead if there was an I/O error.
function Runner:_add_new_reports(inputs)
   local sources = {}
   local original_indexes = {}

   for index, input in ipairs(inputs) do
      if not input.fatal and not input.cached_report then
         if input.string then
            table.insert(sources, input.string)
            table.insert(original_indexes, index)
         else
            local source, err = utils.read_file(input.path or input.file)

            if source then
               table.insert(sources, source)
               table.insert(original_indexes, index)
            else
               input.fatal = "I/O"
               input.msg = err
            end
         end
      end
   end

   local map = multithreading.has_lanes and multithreading.pmap or utils.map
   local reports = map(luacheck.get_report, sources, self._top_opts.jobs)

   for index, report in ipairs(reports) do
      inputs[original_indexes[index]].new_report = report
   end
end

-- Saves `new_report` for files eligible for caching to cache.
-- Returns true on success or nil and an error message on failure.
function Runner:_save_new_reports_to_cache(inputs)
   for _, input in ipairs(inputs) do
      if input.new_report and input.path then
         local ok = self._cache:put(input.path, input.new_report)

         if not ok then
            return nil, ("Couldn't save cache for %s from %s: I/O error"):format(input.path, self._top_opts.cache)
         end
      end
   end

   return true
end

-- Inputs are prepared here, see `Runner:_prepare_inputs`.
-- Returns an array of reports, one per input, possibly annotated with fields `fatal`, `msg`, and `filename`.
-- On critical error returns nil and an error message.
function Runner:_get_reports(inputs)
   if self._top_opts.cache then
      local err
      self._cache, err = cache.new(self._top_opts.cache)

      if not self._cache then
         return nil, err
      end

      self:_add_cached_reports(inputs)
   end

   self:_add_new_reports(inputs)

   if self._top_opts.cache then
      local ok, err = self:_save_new_reports_to_cache(inputs)

      if not ok then
         return nil, err
      end
   end

   local res = {}

   for _, input in ipairs(inputs) do
      local report = input.cached_report or input.new_report

      if not report then
         report = {fatal = input.fatal, msg = input.msg}
      end

      report.filename = input.filename
      table.insert(res, report)
   end

   return res
end

function Runner:_get_final_report(reports)
   local processing_options = {}

   for index, report in ipairs(reports) do
      if not report.fatal then
         processing_options[index] = self._config_stack:get_options(report.filename)
      end
   end

   local final_report = luacheck.process_reports(reports, processing_options, self._config_stack:get_stds())

   -- `luacheck.process_reports` doesn't preserve `filename` fields, re-add them.
   -- TODO: make it preserve them?
   for index, report in ipairs(reports) do
      final_report[index].filename = report.filename
   end

   return final_report
end

-- Inputs is an array of tables, each one specifies an input.
-- Each input table must have one of the following fields:
-- * `path`: string pointing to a file or directory to check. Checking directories requires LuaFileSystem,
--   and recursively checks all files within the directory. If `include_files` option is not used,
--   only files with `.lua` extensions within the directory are considered.
-- * `rockspec_path`: string pointing to a rockspec, all files with `.lua` extension within its `build.modules`,
--   `build.install.lua`, and `build.install.bin` tables are checked.
-- * `file`: an open file object. It is read till EOF and closed, contents are checked.
-- * `string`: Lua code to check as a string.
-- Additionally, each input table can have `filename` field: a string used when applying `exclude_files`
-- and `include_files` options to the input, and also when figuring out which per-path option overrides to use.
-- By default, if `path` field is given, it is also used as `filename`, otherwise the input is considered unnamed.
-- Unnamed files always pass `exclude_files` and `include_files` filters and don't have any per-path options applied.
function Runner:check(inputs)
   local ok, err = validate_inputs(inputs)

   if not ok then
      error(("bad argument #1 to 'Runner:check' (%s)"):format(err))
   end

   -- Path-related top options can depend on current directory.
   -- Assume it can't somehow change during `:check` call.
   self._top_opts = self._config_stack:get_top_options()

   local prepared_inputs = self:_prepare_inputs(inputs)
   local reports, reports_err = self:_get_reports(prepared_inputs)

   if not reports then
      return nil, reports_err
   end

   return self:_get_final_report(reports)
end

-- Formats given report (same format as returned by `Runner:check`).
-- Optionally a table of options can be passed as `format_opts`,
-- it can contain options `formatter`. `quiet`, `color`, `codes`, and `ranges`,
-- with priority over options from initialization and config.
-- Returns formatted report as a string. It always has a newline at the end unless it is empty.
-- On error returns nil and an error message.
function Runner:format(report, format_opts)
   if type(report) ~= "table" then
      error(("bad argument #1 to 'Runner:format' (report table expected, got %s"):format(type(report)))
   end

   local is_valid, err = options.validate(config.format_options, format_opts)

   if not is_valid then
      error(("bad argument #2 to 'Runner:format' (%s)"):format(err))
   end

   local top_opts = self._config_stack:get_top_options()
   format_opts = format_opts or {}

   local combined_opts = {}

   for _, option in ipairs({"formatter", "quiet", "color", "codes", "ranges"}) do
      combined_opts[option] = top_opts[option]

      if format_opts[option] ~= nil then
         combined_opts[option] = format_opts[option]
      end
   end

   local filenames = {}

   for _, file_report in ipairs(report) do
      table.insert(filenames, file_report.filename or "<unnamed source>")
   end

   local output

   if format.builtin_formatters[combined_opts.formatter] then
      output = format.format(report, filenames, combined_opts)
   else
      local formatter_func = combined_opts.formatter

      if type(combined_opts.formatter) == "string" then
         local require_ok
         local formatter_anchor_dir

         if not format_opts.formatter then
            formatter_anchor_dir = top_opts.formatter_anchor_dir
         end

         require_ok, formatter_func = config.relative_require(formatter_anchor_dir, combined_opts.formatter)

         if not require_ok then
            return nil, ("Couldn't load custom formatter '%s': %s"):format(combined_opts.formatter, formatter_func)
         end
      end

      local ok
      ok, output = pcall(formatter_func, report, filenames, combined_opts)

      if not ok then
         return nil, ("Couldn't run custom formatter '%s': %s"):format(tostring(combined_opts.formatter), output)
      end
   end

   if #output > 0 and output:sub(-1) ~= "\n" then
      output = output .. "\n"
   end

   return output
end

return runner
