local cache = require "luacheck.cache"
local options = require "luacheck.options"
local builtin_standards = require "luacheck.builtin_standards"
local fs = require "luacheck.fs"
local globbing = require "luacheck.globbing"
local standards = require "luacheck.standards"
local utils = require "luacheck.utils"

local config = {}

local function get_global_config_dir()
   if utils.is_windows then
      local local_app_data_dir = os.getenv("LOCALAPPDATA")

      if not local_app_data_dir then
         local user_profile_dir = os.getenv("USERPROFILE")

         if user_profile_dir then
            local_app_data_dir = fs.join(user_profile_dir, "Local Settings", "Application Data")
         end
      end

      if local_app_data_dir then
         return fs.join(local_app_data_dir, "Luacheck")
      end
   else
      local fh = assert(io.popen("uname -s"))
      local system = fh:read("*l")
      fh:close()

      if system == "Darwin" then
         local home_dir = os.getenv("HOME")

         if home_dir then
            return fs.join(home_dir, "Library", "Application Support", "Luacheck")
         end
      else
         local config_home_dir = os.getenv("XDG_CONFIG_HOME")

         if not config_home_dir then
            local home_dir = os.getenv("HOME")

            if home_dir then
               config_home_dir = fs.join(home_dir, ".config")
            end
         end

         if config_home_dir then
            return fs.join(config_home_dir, "luacheck")
         end
      end
   end
end

config.default_path = ".luacheckrc"

function config.get_default_global_path()
   local global_config_dir = get_global_config_dir()

   if global_config_dir then
      return fs.join(global_config_dir, config.default_path)
   end
end

-- A single config is represented by a table with fields:
-- * `options`: table with all config scope options, including `stds` and `files`.
-- * `config_path`: optional path to file from which config was loaded, used only in error messages.
-- * `anchor_dir`: absolute path to directory relative to which config was loaded,
--   or nil if the config is not anchored. Paths within a config are adjusted to be absolute
--   relative to anchor directory, or current directory if it's not anchored.
--   As current directory can change between config usages, this adjustment happens on demand.

-- Returns config path and optional anchor directory or nil and optional error message.
local function locate_config(path, global_path)
   if path == false then
      return
   end

   local is_default_path = not path
   path = path or config.default_path

   if fs.is_absolute(path) then
      return path
   end

   local current_dir = fs.get_current_dir()
   local anchor_dir, rel_dir = fs.find_file(current_dir, path)

   if anchor_dir then
      return fs.join(rel_dir, path), anchor_dir
   end

   if not is_default_path then
      return nil, ("Couldn't find configuration file %s"):format(path)
   end

   if global_path == false then
      return
   end

   global_path = global_path or config.get_default_global_path()

   if global_path and fs.is_file(global_path) then
      return global_path, (fs.split_base(global_path))
   end
end

local function try_load(path)
   local src = utils.read_file(path)

   if not src then
      return
   end

   local func, err = utils.load(src, nil, "@"..path)
   return err or func
end

local function add_relative_loader(anchor_dir)
   if not anchor_dir then
      return
   end

   local function loader(modname)
      local modpath = fs.join(anchor_dir, (modname:gsub("%.", utils.dir_sep)))
      return try_load(modpath..".lua") or try_load(modpath..utils.dir_sep.."init.lua"), modname
   end

   table.insert(package.loaders or package.searchers, 1, loader) -- luacheck: compat
   return loader
end

local function remove_relative_loader(loader)
   if not loader then
      return
   end

   for i, func in ipairs(package.loaders or package.searchers) do -- luacheck: compat
      if func == loader then
         table.remove(package.loaders or package.searchers, i) -- luacheck: compat
         return
      end
   end
end

-- Requires module from config anchor directory.
-- Returns success flag and module or error message.
function config.relative_require(anchor_dir, modname)
   local loader = add_relative_loader(anchor_dir)
   local ok, mod_or_err = pcall(require, modname)
   remove_relative_loader(loader)
   return ok, mod_or_err
end

-- Config must support special metatables for some keys:
-- autovivification for `files`, fallback to built-in stds for `stds`.

local special_mts = {
   stds = {__index = builtin_standards},
   files = {__index = function(files, key)
      files[key] = {}
      return files[key]
   end}
}

local function make_config_env_mt()
   local env_mt = {}
   local special_values = {}

   for key, mt in pairs(special_mts) do
      special_values[key] = setmetatable({}, mt)
   end

   function env_mt.__index(_, key)
      if special_mts[key] then
         return special_values[key]
      else
         return _G[key]
      end
   end

   function env_mt.__newindex(env, key, value)
      if special_mts[key] then
         if type(value) == "table" then
            setmetatable(value, special_mts[key])
         end

         special_values[key] = value
      else
         rawset(env, key, value)
      end
   end

   return env_mt, special_values
end

local function make_config_env()
   local mt, special_values = make_config_env_mt()
   return setmetatable({}, mt), special_values
end

local function remove_env_mt(env, special_values)
   setmetatable(env, nil)
   utils.update(env, special_values)
end

local function set_default_std(files, pattern, std)
   -- Avoid mutating option tables, they may be shared between different patterns.
   local pattern_opts = {std = std}

   if files[pattern] then
      pattern_opts = utils.update(pattern_opts, files[pattern])
   end

   files[pattern] = pattern_opts
end

local function add_default_path_options(opts)
   local files = {}

   if opts.files then
      files = utils.update(files, opts.files)
   end

   opts.files = files
   set_default_std(files, "**/spec/**/*_spec.lua", "+busted")
   set_default_std(files, "**/test/**/*_spec.lua", "+busted")
   set_default_std(files, "**/tests/**/*_spec.lua", "+busted")
   set_default_std(files, "**/*.rockspec", "+rockspec")
   set_default_std(files, "**/*.luacheckrc", "+luacheckrc")
end

local fallback_config = {options = {}, anchor_dir = ""}
add_default_path_options(fallback_config.options)

-- Loads config from a file, if possible.
-- `path` and `global_path` can be nil (will use default), false (will disable loading), or a string.
-- Doesn't validate the config.
-- Returns a table or nil and an error message.
function config.load_config(path, global_path)
   local config_path, anchor_dir = locate_config(path, global_path)

   if not config_path then
      if anchor_dir then
         return nil, anchor_dir
      else
         return fallback_config
      end
   end

   local env, special_values = make_config_env()
   local loader = add_relative_loader(anchor_dir)
   local load_ok, ret, load_err = utils.load_config(config_path, env)
   remove_relative_loader(loader)

   if not load_ok then
      return nil, ("Couldn't load configuration from %s: %s error (%s)"):format(config_path, ret, load_err)
   end

   -- Support returning some options from config instead of setting them as globals.
   -- This allows easily loading options from another file, for example using require.
   if type(ret) == "table" then
      utils.update(env, ret)
   end

   remove_env_mt(env, special_values)
   add_default_path_options(env)
   return {options = env, config_path = config_path, anchor_dir = anchor_dir}
end

function config.table_to_config(opts)
   return {options = opts}
end

-- Validates custom stds within a config table and adds them to stds map.
-- Returns true on success or nil and an error message on error.
local function add_stds_from_config(conf, stds)
   if conf.options.stds ~= nil then
      if type(conf.options.stds) ~= "table" then
         return nil, ("invalid option 'stds': table expected, got %s"):format(type(conf.options.stds))
      end

      -- Validate stds in sorted order for deterministic output when more than one std is invalid.
      local std_names = {}

      for std_name in pairs(conf.options.stds) do
         if type(std_name) == "string" then
            table.insert(std_names, std_name)
         end
      end

      table.sort(std_names)

      for _, std_name in ipairs(std_names) do
         local std = conf.options.stds[std_name]

         if type(std) ~= "table" then
            return nil, ("invalid custom std '%s': table expected, got %s"):format(std_name, type(std))
         end

         local ok, err = standards.validate_std_table(std)

         if not ok then
            return nil, ("invalid custom std '%s': %s"):format(std_name, err)
         end

         stds[std_name] = std
      end
   end

   return true
end

local function error_prefix(conf)
   if conf.config_path then
      return ("in config loaded from %s: "):format(conf.config_path)
   else
      return ""
   end
end

local function quiet_validator(x)
   if type(x) == "number" then
      if math.floor(x) == x and x >= 0 and x <= 3 then
         return true
      else
         return false, ("integer in range 0..3 expected, got %.20g"):format(x)
      end
   else
      return false, ("integer in range 0..3 expected, got %s"):format(type(x))
   end
end

local function jobs_validator(x)
   if type(x) == "number" then
      if math.floor(x) == x and x >= 1 then
         return true
      else
         return false, ("positive integer expected, got %.20g"):format(x)
      end
   else
      return false, ("positive integer expected, got %s"):format(type(x))
   end
end

config.format_options = {
   quiet = quiet_validator,
   color = utils.has_type("boolean"),
   codes = utils.has_type("boolean"),
   ranges = utils.has_type("boolean"),
   formatter = utils.has_either_type("string", "function")
}

local top_options = {
   cache = utils.has_either_type("string", "boolean"),
   jobs = jobs_validator,
   files = utils.has_type("table"),
   stds = utils.has_type("table"),
   exclude_files = utils.array_of("string"),
   include_files = utils.array_of("string")
}

utils.update(top_options, config.format_options)
utils.update(top_options, options.all_options)

-- Returns true if config is valid, nil and error message otherwise.
local function validate_config(conf, stds)
   local ok, err = options.validate(top_options, conf.options, stds)

   if not ok then
      return nil, err
   end

   if conf.options.files then
      for path, opts in pairs(conf.options.files) do
         if type(path) == "string" then
            ok, err = options.validate(options.all_options, opts, stds)

            if not ok then
               return nil, ("invalid options for path '%s': %s"):format(path, err)
            end
         end
      end
   end

   return true
end

local ConfigStack = utils.class()

function ConfigStack:__init(configs, stds)
   self._configs = configs
   self._stds = stds
end

function ConfigStack:get_stds()
   return self._stds
end

-- Accepts an array of config tables, as returned from `load_config` and `table_to_config`.
-- Assumes that configs closer to end of the array override configs closer to beginning.
-- Returns an instance of `ConfigStack`. On validation error returns nil and an error message.
function config.stack_configs(configs)
   -- First, collect and validate stds from all configs, they are required to validate `std` option.
   local stds = utils.update({}, builtin_standards)

   for _, conf in ipairs(configs) do
      local ok, err = add_stds_from_config(conf, stds)

      if not ok then
         return nil, error_prefix(conf) .. err
      end
   end

   for _, conf in ipairs(configs) do
      local ok, err = validate_config(conf, stds)

      if not ok then
         return nil, error_prefix(conf) .. err
      end
   end

   return ConfigStack(configs, stds)
end

-- Returns a table of top-level config options, except `files` and `stds`.
function ConfigStack:get_top_options()
   local res = {
      quiet = 0,
      color = true,
      codes = false,
      ranges = false,
      formatter = "default",
      cache = false,
      jobs = false,
      include_files = {},
      exclude_files = {}
   }

   local current_dir = fs.get_current_dir()
   local last_anchor_dir

   for _, conf in ipairs(self._configs) do
      for _, option in ipairs({"quiet", "color", "codes", "ranges", "jobs"}) do
         if conf.options[option] ~= nil then
            res[option] = conf.options[option]
         end
      end

      -- It's not immediately obvious relatively to which config formatter modules
      -- should be resolved when they are specified in a config without an anchor dir.
      -- For now, use the last anchor directory available, that should result
      -- in reasonable behaviour in the current case of a single anchored config (loaded from file)
      -- + a single not anchored config (loaded from CLI options).
      last_anchor_dir = conf.anchor_dir or last_anchor_dir

      if conf.options.formatter ~= nil then
         res.formatter = conf.options.formatter
         res.formatter_anchor_dir = last_anchor_dir
      end

      -- Path options, on the other hand, are interpreted relatively to the current directory
      -- when specified in a config without anchor. Behaviour similar to formatter could also
      -- make sense, but this is consistent with pre 0.22.0 behaviou
      local anchor_dir = conf.anchor_dir or current_dir

      for _, option in ipairs({"include_files", "exclude_files"}) do
         if conf.options[option] ~= nil then
            for _, glob in ipairs(conf.options[option]) do
               table.insert(res[option], fs.normalize(fs.join(anchor_dir, glob)))
            end
         end
      end

      if conf.options.cache ~= nil then
         if conf.options.cache == true then
            if not res.cache then
               res.cache = fs.normalize(fs.join(last_anchor_dir or current_dir, cache.get_default_dir()))
            end
         elseif conf.options.cache == false then
            res.cache = false
         else
            res.cache = fs.normalize(fs.join(anchor_dir, conf.options.cache))
         end
      end
   end

   return res
end

local function add_applying_overrides(option_stack, conf, filename)
   if not filename or not conf.options.files then
      return
   end

   local current_dir = fs.get_current_dir()
   local abs_filename = fs.normalize(fs.join(current_dir, filename))
   local anchor_dir

   if conf.anchor_dir == "" then
      anchor_dir = fs.split_base(current_dir)
   else
      anchor_dir = conf.anchor_dir or current_dir
   end

   local matching_pairs = {}

   for glob, opts in pairs(conf.options.files) do
      if type(glob) == "string" then
         local abs_glob = fs.normalize(fs.join(anchor_dir, glob))

         if globbing.match(abs_glob, abs_filename) then
            table.insert(matching_pairs, {
               abs_glob = abs_glob,
               opts = opts
            })
         end
      end
   end

   table.sort(matching_pairs, function(pair1, pair2)
      return globbing.compare(pair1.abs_glob, pair2.abs_glob)
   end)

   for _, pair in ipairs(matching_pairs) do
      table.insert(option_stack, pair.opts)
   end
end

-- Returns an option stack applicable to a file with given name, or in general if name is not given.
function ConfigStack:get_options(filename)
   local res = {}

   for _, conf in ipairs(self._configs) do
      table.insert(res, conf.options)
      add_applying_overrides(res, conf, filename)
   end

   return res
end

return config
