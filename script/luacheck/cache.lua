local fs = require "luacheck.fs"
local serializer = require "luacheck.serializer"
local sha1 = require "luacheck.vendor.sha1"
local utils = require "luacheck.utils"

local cache = {}

-- Check results can be cached inside a given cache directory.
-- Check result for a file is stored in `<cache_dir>/<SHA1(filename)>`.
-- Cache file format: <format_version>\n<filename>\n<serialized check result`.

-- Returns default cache directory or nothing.
function cache.get_default_dir()
   if utils.is_windows then
      local local_app_data_dir = os.getenv("LOCALAPPDATA")

      if not local_app_data_dir then
         local user_profile_dir = os.getenv("USERPROFILE")

         if user_profile_dir then
            local_app_data_dir = fs.join(user_profile_dir, "Local Settings", "Application Data")
         end
      end

      if local_app_data_dir then
         return fs.join(local_app_data_dir, "Luacheck", "Cache")
      end
   else
      local fh = assert(io.popen("uname -s"))
      local system = fh:read("*l")
      fh:close()

      if system == "Darwin" then
         local home_dir = os.getenv("HOME")

         if home_dir then
            return fs.join(home_dir, "Library", "Caches", "Luacheck")
         end
      else
         local config_home_dir = os.getenv("XDG_CACHE_HOME")

         if not config_home_dir then
            local home_dir = os.getenv("HOME")

            if home_dir then
               config_home_dir = fs.join(home_dir, ".cache")
            end
         end

         if config_home_dir then
            return fs.join(config_home_dir, "luacheck")
         end
      end
   end
end

local format_version = "1"

local Cache = utils.class()

function Cache:__init(cache_directory)
   local ok, err = fs.make_dirs(cache_directory)

   if not ok then
      return nil, ("Couldn't initialize cache in %s: %s"):format(cache_directory, err)
   end

   self._dir = cache_directory
   self._current_dir = fs.get_current_dir()
end

-- Caches check result for a file. Returns true on success, nothing on error.
function Cache:put(filename, check_result)
   local normalized_filename = fs.normalize(fs.join(self._current_dir, filename))
   local cache_filename = fs.join(self._dir, sha1.sha1(normalized_filename))

   local fh = io.open(cache_filename, "wb")

   if not fh then
      return
   end

   local serialized_result = serializer.dump_check_result(check_result)
   fh:write(format_version, "\n", normalized_filename, "\n", serialized_result)
   fh:close()
   return true
end

-- Retrieves cached check result for a file.
-- Returns check result on cache hit, nothing on cache miss,
-- nil and true on malformed cache data.
function Cache:get(filename)
   local normalized_filename = fs.normalize(fs.join(self._current_dir, filename))
   local cache_filename = fs.join(self._dir, sha1.sha1(normalized_filename))

   local file_mtime = fs.get_mtime(filename)
   local cache_mtime = fs.get_mtime(cache_filename)

   if not file_mtime or not cache_mtime or file_mtime >= cache_mtime then
      return
   end

   local fh = io.open(cache_filename, "rb")

   if not fh then
      return
   end

   if fh:read() ~= format_version then
      fh:close()
      return
   end

   if fh:read() ~= normalized_filename then
      fh:close()
      return
   end

   local serialized_result = fh:read("*a")
   fh:close()

   if not serialized_result then
      return nil, true
   end

   local result = serializer.load_check_result(serialized_result)

   if not result then
      return nil, true
   end

   return result
end

function cache.new(cache_directory)
   return Cache(cache_directory)
end

return cache
