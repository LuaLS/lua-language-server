---@meta

---Registry of interfaces between scripts. An interface is simply a dictionary mapping names to functions. A script or mod can then register an interface with [LuaRemote](LuaRemote), after that any script can call the registered functions, provided it knows the interface name and the desired function name. An instance of LuaRemote is available through the global object named `remote`.
---
---Will register a remote interface containing two functions. Later, it will call these functions through `remote`. 
---```lua
---remote.add_interface("human interactor",
---                     {hello = function() game.player.print("Hi!") end,
---                      bye = function(name) game.player.print("Bye " .. name) end})
----- Some time later, possibly in a different mod...
---remote.call("human interactor", "hello")
---remote.call("human interactor", "bye", "dear reader")
---```
---@class LuaRemote
---List of all registered interfaces. For each interface name, `remote.interfaces[name]` is a dictionary mapping the interface's registered functions to the value `true`.`[R]`
---
---Assuming the "human interactor" interface is registered as above 
---```lua
---game.player.print(tostring(remote.interfaces["human interactor"]["hello"]))        -- prints true
---game.player.print(tostring(remote.interfaces["human interactor"]["nonexistent"]))  -- prints nil
---```
---@field interfaces table<string, table<string, boolean>>
---@field object_name string @This object's name.`[R]`
local LuaRemote = {}

---Add a remote interface.
---
---It is an error if the given interface `name` is already registered.
---@param _name string @Name of the interface.
---@param _functions table<string, fun()> @List of functions that are members of the new interface.
function LuaRemote.add_interface(_name, _functions) end

---Call a function of an interface.
---@param _interface string @Interface to look up `function` in.
---@param _function string @Function name that belongs to `interface`.
---@return Any
function LuaRemote.call(_interface, _function) end

---Removes an interface with the given name.
---@param _name string @Name of the interface.
---@return boolean @Whether the interface was removed. `False` if the interface didn't exist.
function LuaRemote.remove_interface(_name) end

