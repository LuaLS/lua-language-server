local fs = {}

local lfs = require "lfs"
local utils = require "luacheck.utils"

local function ensure_dir_sep(path)
   if path:sub(-1) ~= utils.dir_sep then
      return path .. utils.dir_sep
   end

   return path
end

function fs.split_base(path)
   if utils.is_windows then
      if path:match("^%a:\\") then
         return path:sub(1, 3), path:sub(4)
      else
         -- Disregard UNC paths and relative paths with drive letter.
         return "", path
      end
   else
      if path:match("^/") then
         if path:match("^//") then
            return "//", path:sub(3)
         else
            return "/", path:sub(2)
         end
      else
         return "", path
      end
   end
end

function fs.is_absolute(path)
   return fs.split_base(path) ~= ""
end

function fs.normalize(path)
   if utils.is_windows then
      path = path:lower()
   end
   local base, rest = fs.split_base(path)
   rest = rest:gsub("[/\\]", utils.dir_sep)

   local parts = {}

   for part in rest:gmatch("[^"..utils.dir_sep.."]+") do
      if part ~= "." then
         if part == ".." and #parts > 0 and parts[#parts] ~= ".." then
            parts[#parts] = nil
         else
            parts[#parts + 1] = part
         end
      end
   end

   if base == "" and #parts == 0 then
      return "."
   else
      return base..table.concat(parts, utils.dir_sep)
   end
end

local function join_two_paths(base, path)
   if base == "" or fs.is_absolute(path) then
      return path
   else
      return ensure_dir_sep(base) .. path
   end
end

function fs.join(base, ...)
   local res = base

   for i = 1, select("#", ...) do
      res = join_two_paths(res, select(i, ...))
   end

   return res
end

function fs.is_subpath(path, subpath)
   local base1, rest1 = fs.split_base(path)
   local base2, rest2 = fs.split_base(subpath)

   if base1 ~= base2 then
      return false
   end

   if rest2:sub(1, #rest1) ~= rest1 then
      return false
   end

   return rest1 == rest2 or rest2:sub(#rest1 + 1, #rest1 + 1) == utils.dir_sep
end

function fs.is_dir(path)
   return lfs.attributes(path, "mode") == "directory"
end

function fs.is_file(path)
   return lfs.attributes(path, "mode") == "file"
end

-- Searches for file starting from path, going up until the file
-- is found or root directory is reached.
-- Path must be absolute.
-- Returns absolute and relative paths to directory containing file or nil.
function fs.find_file(path, file)
   if fs.is_absolute(file) then
      return fs.is_file(file) and path, ""
   end

   path = fs.normalize(path)
   local base, rest = fs.split_base(path)
   local rel_path = ""

   while true do
      if fs.is_file(fs.join(base..rest, file)) then
         return base..rest, rel_path
      elseif rest == "" then
         return
      end

      rest = rest:match("^(.*)"..utils.dir_sep..".*$") or ""
      rel_path = rel_path..".."..utils.dir_sep
   end
end

-- Returns iterator over directory items or nil, error message.
function fs.dir_iter(dir_path)
   local ok, iter, state, var = pcall(lfs.dir, dir_path)

   if not ok then
      local err = utils.unprefix(iter, "cannot open " .. dir_path .. ": ")
      return nil, "couldn't list directory: " .. err
   end

   return iter, state, var
end

-- Returns list of all files in directory matching pattern.
-- Additionally returns a mapping from directory paths that couldn't be expanded
-- to error messages.
function fs.extract_files(dir_path, pattern)
   local res = {}
   local err_map = {}

   local function scan(dir)
      local iter, state, var = fs.dir_iter(dir)

      if not iter then
         err_map[dir] = state
         table.insert(res, dir)
         return
      end

      for path in iter, state, var do
         if path ~= "." and path ~= ".." then
            local full_path = fs.join(dir, path)

            if fs.is_dir(full_path) then
               scan(full_path)
            elseif path:match(pattern) and fs.is_file(full_path) then
               table.insert(res, full_path)
            end
         end
      end
   end

   scan(dir_path)
   table.sort(res)
   return res, err_map
end

local function make_absolute_dirs(dir_path)
   if fs.is_dir(dir_path) then
      return true
   end

   local upper_dir = fs.normalize(fs.join(dir_path, ".."))

   if upper_dir == dir_path then
      return nil, ("Filesystem root %s is not a directory"):format(upper_dir)
   end

   local upper_ok, upper_err = make_absolute_dirs(upper_dir)

   if not upper_ok then
      return nil, upper_err
   end

   local make_ok, make_error = lfs.mkdir(dir_path)

   if not make_ok then
      return nil, ("Couldn't make directory %s: %s"):format(dir_path, make_error)
   end

   return true
end

-- Ensures that a given path is a directory, creating intermediate directories if necessary.
-- Returns true on success, nil and an error message on failure.
function fs.make_dirs(dir_path)
   return make_absolute_dirs(fs.normalize(fs.join(fs.get_current_dir(), dir_path)))
end

-- Returns modification time for a file.
function fs.get_mtime(path)
   return lfs.attributes(path, "modification")
end

-- Returns absolute path to current working directory, with trailing directory separator.
function fs.get_current_dir()
   return ensure_dir_sep(assert(lfs.currentdir()))
end

return fs
