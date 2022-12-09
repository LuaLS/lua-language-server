local fs = require "luacheck.fs"
local utils = require "luacheck.utils"

local blacklist = utils.array_to_set({"spec", ".luarocks", "lua_modules", "test.lua", "tests.lua"})

-- This reimplements relevant parts of `luarocks.build.builtin.autodetect_modules`.
-- Autodetection works relatively to the directory containing the rockspec.
local function autodetect_modules(rockspec_path)
   rockspec_path = fs.normalize(rockspec_path)
   local base, rest = fs.split_base(rockspec_path)
   local project_dir = base .. (rest:match("^(.*)" .. utils.dir_sep .. ".*$") or "")

   if project_dir == "" then
      project_dir = "."
   end

   local module_dir = project_dir

   for _, module_subdir in ipairs({"src", "lua", "lib"}) do
      local full_module_dir = fs.join(project_dir, module_subdir)

      if fs.is_dir(full_module_dir) then
         module_dir = full_module_dir
         break
      end
   end

   local res = {}

   for _, file in ipairs((fs.extract_files(module_dir, "%.lua$"))) do
      -- Extract first part of the path from module_dir to the file, or file name itself.
      if not blacklist[file:match("^" .. module_dir:gsub("%p", "%%%0") .. "[\\/]*([^\\/]*)")] then
         table.insert(res, file)
      end
   end

   local bin_dir

   for _, bin_subdir in ipairs({"src/bin", "bin"}) do
      local full_bin_dir = fs.join(project_dir, bin_subdir)

      if fs.is_dir(full_bin_dir) then
         bin_dir = full_bin_dir
      end
   end

   if bin_dir then
      local iter, state, var = fs.dir_iter(bin_dir)

      if iter then
         for basename in iter, state, var do
            if basename:sub(-#".lua") == ".lua" then
               table.insert(res, fs.join(bin_dir, basename))
            end
         end
      end
   end

   return res
end

local function extract_lua_files(rockspec_path, rockspec)
   local build = rockspec.build

   if type(build) ~= "table" then
      return autodetect_modules(rockspec_path)
   end

   if not build.type or build.type == "builtin" or build.type == "module" then
      if not build.modules then
         return autodetect_modules(rockspec_path)
      end
   end

   local res = {}

   local function scan(t)
      if type(t) == "table" then
         for _, file in pairs(t) do
            if type(file) == "string" and file:sub(-#".lua") == ".lua" then
               table.insert(res, file)
            end
         end
      end
   end

   scan(build.modules)

   if type(build.install) == "table" then
      scan(build.install.lua)
      scan(build.install.bin)
   end

   table.sort(res)
   return res
end

-- Receives a name of a rockspec, returns list of related .lua files.
-- On error returns nil and "I/O", "syntax", or "runtime" and error message.
local function expand_rockspec(rockspec_path)
   local rockspec, err_type, err_msg = utils.load_config(rockspec_path)

   if not rockspec then
      return nil, err_type, err_msg
   end

   return extract_lua_files(rockspec_path, rockspec)
end

return expand_rockspec
