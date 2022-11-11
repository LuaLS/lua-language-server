---System API documentation
---Functions and messages for using system resources, controlling the engine,
---error handling and debugging.
---@class sys
sys = {}
---network connected through other, non cellular, connection
sys.NETWORK_CONNECTED = nil
---network connected through mobile cellular
sys.NETWORK_CONNECTED_CELLULAR = nil
---no network connection found
sys.NETWORK_DISCONNECTED = nil
---deserializes buffer into a lua table
---@param buffer string # buffer to deserialize from
---@return table # lua table with deserialized data
function sys.deserialize(buffer) end

---Terminates the game application and reports the specified code to the OS.
---@param code number # exit code to report to the OS, 0 means clean exit
function sys.exit(code) end

---Returns a table with application information for the requested app.
--- On iOS, the app_string is an url scheme for the app that is queried. Your
---game needs to list the schemes that are queried in an LSApplicationQueriesSchemes array
---in a custom "Info.plist".
--- On Android, the app_string is the package identifier for the app.
---@param app_string string # platform specific string with application package or query, see above for details.
---@return table # table with application information in the following fields:
function sys.get_application_info(app_string) end

---The path from which the application is run.
---@return string # path to application executable
function sys.get_application_path() end

---Get config value from the game.project configuration file.
---In addition to the project file, configuration values can also be passed
---to the runtime as command line arguments with the --config argument.
---@param key string # key to get value for. The syntax is SECTION.KEY
---@return string # config value as a string. nil if the config key doesn't exists
function sys.get_config(key) end

---Get config value from the game.project configuration file with default value
---@param key string # key to get value for. The syntax is SECTION.KEY
---@param default_value string # default value to return if the value does not exist
---@return string # config value as a string. default_value if the config key does not exist
function sys.get_config(key, default_value) end

--- Returns the current network connectivity status
---on mobile platforms.
---On desktop, this function always return sys.NETWORK_CONNECTED.
---@return constant # network connectivity status:
function sys.get_connectivity() end

---Returns a table with engine information.
---@return table # table with engine information in the following fields:
function sys.get_engine_info() end

---Returns an array of tables with information on network interfaces.
---@return table # an array of tables. Each table entry contain the following fields:
function sys.get_ifaddrs() end

---The save-file path is operating system specific and is typically located under the user's home directory.
---@param application_id string # user defined id of the application, which helps define the location of the save-file
---@param file_name string # file-name to get path for
---@return string # path to save-file
function sys.get_save_file(application_id, file_name) end

---Returns a table with system information.
---@param options table # (optional) options table - ignore_secure boolean this flag ignores values might be secured by OS e.g. device_ident
---@return table # table with system information in the following fields:
function sys.get_sys_info(options) end

---If the file exists, it must have been created by sys.save to be loaded.
---@param filename string # file to read from
---@return table # lua table, which is empty if the file could not be found
function sys.load(filename) end

---Loads a custom resource. Specify the full filename of the resource that you want
---to load. When loaded, the file data is returned as a string.
---If loading fails, the function returns nil plus the error message.
---In order for the engine to include custom resources in the build process, you need
---to specify them in the "custom_resources" key in your "game.project" settings file.
---You can specify single resource files or directories. If a directory is included
---in the resource list, all files and directories in that directory is recursively
---included:
---For example "main/data/,assets/level_data.json".
---@param filename string # resource to load, full path
---@return string # loaded data, or nil if the resource could not be loaded
---@return string # the error message, or nil if no error occurred
function sys.load_resource(filename) end

---Open URL in default application, typically a browser
---@param url string # url to open
---@param attributes table? # table with attributes target - string : Optional. Specifies the target attribute or the name of the window. The following values are supported: - _self - (default value) URL replaces the current page. - _blank - URL is loaded into a new window, or tab. - _parent - URL is loaded into the parent frame. - _top - URL replaces any framesets that may be loaded. - name - The name of the window (Note: the name does not specify the title of the new window).
---@return boolean # a boolean indicating if the url could be opened or not
function sys.open_url(url, attributes) end

---Reboots the game engine with a specified set of arguments.
---Arguments will be translated into command line arguments. Calling reboot
---function is equivalent to starting the engine with the same arguments.
---On startup the engine reads configuration from "game.project" in the
---project root.
---@param arg1 string # argument 1
---@param arg2 string # argument 2
---@param arg3 string # argument 3
---@param arg4 string # argument 4
---@param arg5 string # argument 5
---@param arg6 string # argument 6
function sys.reboot(arg1, arg2, arg3, arg4, arg5, arg6) end

---The table can later be loaded by sys.load.
---Use sys.get_save_file to obtain a valid location for the file.
---Internally, this function uses a workspace buffer sized output file sized 512kb.
---This size reflects the output file size which must not exceed this limit.
---Additionally, the total number of rows that any one table may contain is limited to 65536
---(i.e. a 16 bit range). When tables are used to represent arrays, the values of
---keys are permitted to fall within a 32 bit range, supporting sparse arrays, however
---the limit on the total number of rows remains in effect.
---@param filename string # file to write to
---@param table table # lua table to save
---@return boolean # a boolean indicating if the table could be saved or not
function sys.save(filename, table) end

---The buffer can later deserialized by sys.deserialize.
---This method has all the same limitations as sys.save.
---@param table table # lua table to serialize
---@return string # serialized data buffer
function sys.serialize(table) end

---Sets the host that is used to check for network connectivity against.
---@param host string # hostname to check against
function sys.set_connectivity_host(host) end

---Set the Lua error handler function.
---The error handler is a function which is called whenever a lua runtime error occurs.
---@param error_handler fun(source: string, message: string, traceback: string) # the function to be called on error
function sys.set_error_handler(error_handler) end

---Set game update-frequency (frame cap). This option is equivalent to display.update_frequency in
---the "game.project" settings but set in run-time. If Vsync checked in "game.project", the rate will
---be clamped to a swap interval that matches any detected main monitor refresh rate. If Vsync is
---unchecked the engine will try to respect the rate in software using timers. There is no
---guarantee that the frame cap will be achieved depending on platform specifics and hardware settings.
---@param frequency number # target frequency. 60 for 60 fps
function sys.set_update_frequency(frequency) end

---Set the vsync swap interval. The interval with which to swap the front and back buffers
---in sync with vertical blanks (v-blank), the hardware event where the screen image is updated
---with data from the front buffer. A value of 1 swaps the buffers at every v-blank, a value of
---2 swaps the buffers every other v-blank and so on. A value of 0 disables waiting for v-blank
---before swapping the buffers. Default value is 1.
---When setting the swap interval to 0 and having vsync disabled in
---"game.project", the engine will try to respect the set frame cap value from
---"game.project" in software instead.
---This setting may be overridden by driver settings.
---@param swap_interval number # target swap interval.
function sys.set_vsync_swap_interval(swap_interval) end




return sys