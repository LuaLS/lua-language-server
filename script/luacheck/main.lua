local argparse = require "argparse"
local cache = require "luacheck.cache"
local config = require "luacheck.config"
local luacheck = require "luacheck"
local multithreading = require "luacheck.multithreading"
local profiler = require "luacheck.profiler"
local runner = require "luacheck.runner"
local utils = require "luacheck.utils"
local version = require "luacheck.version"

local exit_codes = {
   ok = 0,
   warnings = 1,
   errors = 2,
   fatals = 3,
   critical = 4
}

local function critical(msg)
   io.stderr:write("Critical error: "..msg.."\n")
   os.exit(exit_codes.critical)
end

local function get_parser()
   local parser = argparse(
      "luacheck", "luacheck " .. luacheck._VERSION .. ", a linter and a static analyzer for Lua.", [[
Links:

   Luacheck on GitHub: https://github.com/mpeterv/luacheck
   Luacheck documentation: https://luacheck.readthedocs.org]])
      :help_max_width(80)

   parser:argument("files", "List of files, directories and rockspecs to check. Pass '-' to check stdin.")
      :args "+"
      :argname "<file>"

   parser:group("Options for filtering warnings",
      parser:flag("-g --no-global", "Filter out warnings related to global variables. " ..
         "Equivalent to --ignore 1."):target("global"):action("store_false"),
      parser:flag("-u --no-unused", "Filter out warnings related to unused variables and values. " ..
         "Equivalent to --ignore [23]."):target("unused"):action("store_false"),
      parser:flag("-r --no-redefined", "Filter out warnings related to redefined variables. " ..
         "Equivalent to --ignore 4."):target("redefined"):action("store_false"),

      parser:flag("-a --no-unused-args", "Filter out warnings related to unused arguments and " ..
         "loop variables. Equivalent to --ignore 21[23]."):target("unused_args"):action("store_false"),
      parser:flag("-s --no-unused-secondaries", "Filter out warnings related to unused variables set " ..
         "together with used ones."):target("unused_secondaries"):action("store_false"),
      parser:flag("--no-self", "Filter out warnings related to implicit self argument.")
         :target("self"):action("store_false"),

      parser:option("--ignore -i", "Filter out warnings matching these patterns.\n" ..
         "If a pattern contains slash, part before slash matches warning code and part after it matches name of " ..
         "related variable. Otherwise, if the pattern contains letters or underscore, it matches name of " ..
         "related variable. Otherwise, the pattern matches warning code.")
         :args "+"
         :count "*"
         :argname "<patt>"
         :action "concat"
         :init(nil),
      parser:option("--enable -e", "Do not filter out warnings matching these patterns.")
         :args "+"
         :count "*"
         :argname "<patt>"
         :action "concat"
         :init(nil),
      parser:option("--only -o", "Filter out warnings not matching these patterns.")
         :args "+"
         :count "*"
         :argname "<patt>"
         :action "concat"
         :init(nil))

   parser:group("Options for configuring allowed globals",
      parser:option("--std", "Set standard globals, default is max. <std> can be one of:\n" ..
         "   max - union of globals of Lua 5.1, Lua 5.2, Lua 5.3 and LuaJIT 2.x;\n" ..
         "   min - intersection of globals of Lua 5.1, Lua 5.2, Lua 5.3 and LuaJIT 2.x;\n" ..
         "   lua51 - globals of Lua 5.1 without deprecated ones;\n" ..
         "   lua51c - globals of Lua 5.1;\n" ..
         "   lua52 - globals of Lua 5.2;\n" ..
         "   lua52c - globals of Lua 5.2 with LUA_COMPAT_ALL;\n" ..
         "   lua53 - globals of Lua 5.3;\n" ..
         "   lua53c - globals of Lua 5.3 with LUA_COMPAT_5_2;\n" ..
         "   luajit - globals of LuaJIT 2.x;\n" ..
         "   ngx_lua - globals of Openresty lua-nginx-module 0.10.10, including standard LuaJIT 2.x globals;\n" ..
         "   love - globals added by LÖVE;\n" ..
         "   busted - globals added by Busted 2.0, by default added for files ending with _spec.lua within spec, " ..
         "test, and tests subdirectories;\n" ..
         "   rockspec - globals allowed in rockspecs, by default added for files ending with .rockspec;\n" ..
         "   luacheckrc - globals allowed in Luacheck configs, by default added for files ending with .luacheckrc;\n" ..
         "   none - no standard globals.\n\n" ..
         "Sets can be combined using '+'. Extra sets can be defined in config by " ..
         "adding to `stds` global in config."),
      parser:flag("-c --compat", "Equivalent to --std max."),

      parser:option("--globals", "Add custom global variables (e.g. foo) or fields (e.g. foo.bar) " ..
         "on top of standard ones.")
         :args "*"
         :count "*"
         :argname "<name>"
         :action "concat"
         :init(nil),
      parser:option("--read-globals", "Add read-only global variables or fields.")
         :args "*"
         :count "*"
         :argname "<name>"
         :action "concat"
         :init(nil),
      parser:option("--new-globals", "Set custom global variables or fields. Removes custom globals added previously.")
         :args "*"
         :count "*"
         :argname "<name>"
         :action "concat"
         :init(nil),
      parser:option("--new-read-globals", "Set read-only global variables or fields. " ..
         "Removes read-only globals added previously.")
         :args "*"
         :count "*"
         :argname "<name>"
         :action "concat"
         :init(nil),
      parser:option("--not-globals", "Remove custom and standard global variables or fields.")
         :args "*"
         :count "*"
         :argname "<name>"
         :action "concat"
         :init(nil),

      parser:flag("-d --allow-defined", "Allow defining globals implicitly by setting them."),
      parser:flag("-t --allow-defined-top",
         "Allow defining globals implicitly by setting them in the top level scope."),
      parser:flag("-m --module", "Limit visibility of implicitly defined globals to their files."))

   parser:group("Options for configuring line length limits",
      parser:option("--max-line-length", "Set maximum allowed line length (default: 120).")
         :argname "<length>"
         :convert(tonumber),
      parser:flag("--no-max-line-length", "Do not limit line length.")
         :action "store_false"
         :target "max_line_length",

      parser:option("--max-code-line-length", "Set maximum allowed length for lines ending with code (default: 120).")
         :argname "<length>"
         :convert(tonumber),
      parser:flag("--no-max-code-line-length", "Do not limit code line length.")
         :action "store_false"
         :target "max_code_line_length",

      parser:option("--max-string-line-length", "Set maximum allowed length for lines within a string (default: 120).")
         :argname "<length>"
         :convert(tonumber),
      parser:flag("--no-max-string-line-length", "Do not limit string line length.")
         :action "store_false"
         :target "max_string_line_length",

      parser:option("--max-comment-line-length", "Set maximum allowed length for comment lines (default: 120).")
         :argname "<length>"
         :convert(tonumber),
      parser:flag("--no-max-comment-line-length", "Do not limit comment line length.")
         :action "store_false"
         :target "max_comment_line_length")

   parser:option("--max-cyclomatic-complexity", "Set maximum cyclomatic complexity for functions.")
      :argname "<complexity>"
      :convert(tonumber)
   parser:flag("--no-max-cyclomatic-complexity", "Do not limit function cyclomatic complexity (default).")
      :action "store_false"
      :target "max_cyclomatic_complexity"

   local default_global_path = config.get_default_global_path()

   local config_opt = parser:option("--config", "Path to configuration file. (default: "..config.default_path..")")
   local no_config_opt = parser:flag("--no-config", "Do not look up configuration file.")
      :action "store_false"
      :target "config"

   parser:mutex(config_opt, no_config_opt)

   local default_config_opt = parser:option("--default-config", ("Path to configuration file to use if --[no-]config "..
      "is not used and project-specific %s is not found. (default: %s)"):format(
         config.default_path, default_global_path or "could not detect"))
   local no_default_config_opt = parser:flag("--no-default-config", "Do not use default configuration file.")
      :action "store_false"
      :target "default_config"

   parser:mutex(default_config_opt, no_default_config_opt)

   parser:group("Configuration file options",
      config_opt,
      no_config_opt,
      default_config_opt,
      no_default_config_opt)

   parser:group("File filtering options",
      parser:option("--exclude-files", "Do not check files matching these globbing patterns.")
         :args "+"
         :count "*"
         :argname "<glob>"
         :action "concat"
         :init(nil),
      parser:option("--include-files", "Do not check files not matching these globbing patterns.")
         :args "+"
         :count "*"
         :argname "<glob>"
         :action "concat"
         :init(nil))

   parser:option("--filename", "Use another filename in output and for selecting configuration overrides.")

   local cache_opt = parser:option("--cache", ("Path to cache directory. (default: %s)"):format(
         cache.get_default_dir()))
      :args "?"

   local no_cache_opt = parser:flag("--no-cache", "Do not use cache.")
      :action "store_false"
      :target "cache"

   parser:mutex(cache_opt, no_cache_opt)

   local lanes_notice = ""

   if not multithreading.has_lanes then
      lanes_notice = "\nWarning: LuaLanes not found, parallel checking disabled."
   end

   parser:group("Performance optimization options",
      cache_opt,
      no_cache_opt,
      parser:option(
         "-j --jobs", "Check <jobs> files in parallel (default: " ..
            tostring(multithreading.default_jobs) .. ")." .. lanes_notice):convert(tonumber))

   parser:group("Output formatting options",
      parser:option("--formatter" , "Use custom formatter. <formatter> must be a module name or one of:\n" ..
         "   TAP - Test Anything Protocol formatter;\n" ..
         "   JUnit - JUnit XML formatter;\n" ..
         "   visual_studio - MSBuild/Visual Studio aware formatter;\n" ..
         "   plain - simple warning-per-line formatter;\n" ..
         "   default - standard formatter."),
      parser:flag("-q --quiet", "Suppress output for files without warnings.\n" ..
         "-qq: Suppress output of warnings.\n" ..
         "-qqq: Only print total number of warnings and errors.")
         :count "0-3",
      parser:flag("--codes", "Show warning codes."),
      parser:flag("--ranges", "Show ranges of columns related to warnings."),
      parser:flag("--no-color", "Do not color output.")
         :action "store_false"
         :target "color")

   parser:flag("--profile", "Show performance statistics."):hidden(true)

   parser:flag("-v --version", "Show version info and exit.")
      :action(function() print(version.string) os.exit(exit_codes.ok) end)

   return parser
end

local function main()
   local parser = get_parser()
   local ok, args = parser:pparse()
   if not ok then
      io.stderr:write(("%s\n\nError: %s\n"):format(parser:get_usage(), args))
      os.exit(exit_codes.critical)
   end

   if args.profile then
      args.jobs = 1
      profiler.init()
   end

   if args.quiet == 0 then
      args.quiet = nil
   end

   if args.cache then
      args.cache = args.cache[1] or true
   end

   local checker, err, is_invalid_args_error = runner.new(args)

   if not checker then
      if is_invalid_args_error then
         io.stderr:write(("%s\n\nError: %s\n"):format(parser:get_usage(), err))
         os.exit(exit_codes.critical)
      else
         critical(err)
      end
   end

   local inputs = {}

   for _, file in ipairs(args.files) do
      local input = {filename = args.filename}

      if file == "-" then
         input.file = io.stdin
      elseif file:find("%.rockspec$") then
         input.rockspec_path = file
      else
         input.path = file
      end

      table.insert(inputs, input)
   end

   local report, check_err = checker:check(inputs)

   if not report then
      critical(check_err)
   end

   for _, file_report in ipairs(report) do
      if not file_report.filename then
         file_report.filename = "stdin"
      end
   end

   local output, format_err = checker:format(report)

   if not output then
      critical(format_err)
   end

   io.stdout:write(output)

   if args.profile then
      profiler.report()
   end

   if report.fatals > 0 then
      os.exit(exit_codes.fatals)
   elseif report.errors > 0 then
      os.exit(exit_codes.errors)
   elseif report.warnings > 0 then
      os.exit(exit_codes.warnings)
   else
      os.exit(exit_codes.ok)
   end
end

local _, error_wrapper = utils.try(main)
local err = error_wrapper.err
local traceback = error_wrapper.traceback

if utils.is_instance(err, utils.InvalidPatternError) then
   critical(("Invalid pattern '%s'"):format(err.pattern))
elseif type(err) == "string" and err:find("interrupted!$") then
   critical("Interrupted")
else
   local msg = ("Luacheck %s bug (please report at https://github.com/mpeterv/luacheck/issues):\n%s\n%s"):format(
      luacheck._VERSION, err, traceback)
   critical(msg)
end
