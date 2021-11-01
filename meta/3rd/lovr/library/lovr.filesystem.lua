---@meta

---
---The `lovr.filesystem` module provides access to the filesystem.
---
---@class lovr.filesystem
lovr.filesystem = {}

---
---Appends content to the end of a file.
---
---@overload fun(filename: string, blob: lovr.Blob):number
---@param filename string # The file to append to.
---@param content string # A string to write to the end of the file.
---@return number bytes # The number of bytes actually appended to the file.
function lovr.filesystem.append(filename, content) end

---
---Creates a directory in the save directory.  Any parent directories that don't exist will also be created.
---
---@param path string # The directory to create, recursively.
---@return boolean success # Whether the directory was created.
function lovr.filesystem.createDirectory(path) end

---
---Returns the application data directory.  This will be something like:
---
---- `C:\Users\user\AppData\Roaming` on Windows.
---- `/home/user/.config` on Linux.
---- `/Users/user/Library/Application Support` on macOS.
---
---@return string path # The absolute path to the appdata directory.
function lovr.filesystem.getAppdataDirectory() end

---
---Returns a sorted table containing all files and folders in a single directory.
---
---@param path string # The directory.
---@return lovr.items table # A table with a string for each file and subfolder in the directory.
function lovr.filesystem.getDirectoryItems(path) end

---
---Returns the absolute path of the LÖVR executable.
---
---@return string path # The absolute path of the LÖVR executable, or `nil` if it is unknown.
function lovr.filesystem.getExecutablePath() end

---
---Returns the identity of the game, which is used as the name of the save directory.  The default is `default`.  It can be changed using `t.identity` in `lovr.conf`.
---
---@return string identity # The name of the save directory, or `nil` if it isn't set.
function lovr.filesystem.getIdentity() end

---
---Returns when a file was last modified, since some arbitrary time in the past.
---
---@param path string # The file to check.
---@return number time # The modification time of the file, in seconds, or `nil` if it's unknown.
function lovr.filesystem.getLastModified(path) end

---
---Get the absolute path of the mounted archive containing a path in the virtual filesystem.  This can be used to determine if a file is in the game's source directory or the save directory.
---
---@param path string # The path to check.
---@return string realpath # The absolute path of the mounted archive containing `path`.
function lovr.filesystem.getRealDirectory(path) end

---
---Returns the require path.  The require path is a semicolon-separated list of patterns that LÖVR will use to search for files when they are `require`d.  Any question marks in the pattern will be replaced with the module that is being required.  It is similar to Lua\'s `package.path` variable, but the main difference is that the patterns are relative to the virtual filesystem.
---
---@return string path # The semicolon separated list of search patterns.
function lovr.filesystem.getRequirePath() end

---
---Returns the absolute path to the save directory.
---
---@return string path # The absolute path to the save directory.
function lovr.filesystem.getSaveDirectory() end

---
---Returns the size of a file, in bytes.
---
---@param file string # The file.
---@return number size # The size of the file, in bytes.
function lovr.filesystem.getSize(file) end

---
---Get the absolute path of the project's source directory or archive.
---
---@return string path # The absolute path of the project's source, or `nil` if it's unknown.
function lovr.filesystem.getSource() end

---
---Returns the absolute path of the user's home directory.
---
---@return string path # The absolute path of the user's home directory.
function lovr.filesystem.getUserDirectory() end

---
---Returns the absolute path of the working directory.  Usually this is where the executable was started from.
---
---@return string path # The current working directory, or `nil` if it's unknown.
function lovr.filesystem.getWorkingDirectory() end

---
---Check if a path exists and is a directory.
---
---@param path string # The path to check.
---@return boolean isDirectory # Whether or not the path is a directory.
function lovr.filesystem.isDirectory(path) end

---
---Check if a path exists and is a file.
---
---@param path string # The path to check.
---@return boolean isFile # Whether or not the path is a file.
function lovr.filesystem.isFile(path) end

---
---Returns whether the current project source is fused to the executable.
---
---@return boolean fused # Whether or not the project is fused.
function lovr.filesystem.isFused() end

---
---Load a file containing Lua code, returning a Lua chunk that can be run.
---
---@param filename string # The file to load.
---@return function chunk # The runnable chunk.
function lovr.filesystem.load(filename) end

---
---Mounts a directory or `.zip` archive, adding it to the virtual filesystem.  This allows you to read files from it.
---
---@param path string # The path to mount.
---@param mountpoint? string # The path in the virtual filesystem to mount to.
---@param append? boolean # Whether the archive will be added to the end or the beginning of the search path.
---@param root? string # A subdirectory inside the archive to use as the root.  If `nil`, the actual root of the archive is used.
---@return boolean success # Whether the archive was successfully mounted.
function lovr.filesystem.mount(path, mountpoint, append, root) end

---
---Creates a new Blob that contains the contents of a file.
---
---@param filename string # The file to load.
---@return lovr.Blob blob # The new Blob.
function lovr.filesystem.newBlob(filename) end

---
---Read the contents of a file.
---
---@param filename string # The name of the file to read.
---@param bytes? number # The number of bytes to read (if -1, all bytes will be read).
---@return string contents # The contents of the file.
---@return number bytes # The number of bytes read from the file.
function lovr.filesystem.read(filename, bytes) end

---
---Remove a file or directory in the save directory.
---
---@param path string # The file or directory to remove.
---@return boolean success # Whether the path was removed.
function lovr.filesystem.remove(path) end

---
---Set the name of the save directory.
---
---@param identity string # The new name of the save directory.
function lovr.filesystem.setIdentity(identity) end

---
---Sets the require path.  The require path is a semicolon-separated list of patterns that LÖVR will use to search for files when they are `require`d.  Any question marks in the pattern will be replaced with the module that is being required.  It is similar to Lua\'s `package.path` variable, but the main difference is that the patterns are relative to the save directory and the project directory.
---
---@param path? string # An optional semicolon separated list of search patterns.
function lovr.filesystem.setRequirePath(path) end

---
---Sets the location of the project's source.  This can only be done once, and is usually done internally.
---
---@param identity string # The path containing the project's source.
function lovr.filesystem.setSource(identity) end

---
---Unmounts a directory or archive previously mounted with `lovr.filesystem.mount`.
---
---@param path string # The path to unmount.
---@return boolean success # Whether the archive was unmounted.
function lovr.filesystem.unmount(path) end

---
---Write to a file.
---
---@overload fun(filename: string, blob: lovr.Blob):number
---@param filename string # The file to write to.
---@param content string # A string to write to the file.
---@return number bytes # The number of bytes written.
function lovr.filesystem.write(filename, content) end
