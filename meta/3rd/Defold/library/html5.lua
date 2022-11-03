---HTML5 API documentation
---HTML5 platform specific functions.
--- The following functions are only available on HTML5 builds, the html5.* Lua namespace will not be available on other platforms.
---@class html5
html5 = {}
---Executes the supplied string as JavaScript inside the browser.
---A call to this function is blocking, the result is returned as-is, as a string.
---(Internally this will execute the string using the eval() JavaScript function.)
---@param code string # Javascript code to run
---@return string # result as string
function html5.run(code) end

---Set a JavaScript interaction listener callaback from lua that will be
---invoked when a user interacts with the web page by clicking, touching or typing.
---The callback can then call DOM restricted actions like requesting a pointer lock,
---or start playing sounds the first time the callback is invoked.
---@param callback fun(self: object) # The interaction callback. Pass an empty function or nil if you no longer wish to receive callbacks.
function html5.set_interaction_listener(callback) end




return html5