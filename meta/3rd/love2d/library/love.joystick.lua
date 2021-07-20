---@class love.joystick
love.joystick = {}

---
---Gets the full gamepad mapping string of the Joysticks which have the given GUID, or nil if the GUID isn't recognized as a gamepad.
---
---The mapping string contains binding information used to map the Joystick's buttons an axes to the standard gamepad layout, and can be used later with love.joystick.loadGamepadMappings.
---
---@param guid string # The GUID value to get the mapping string for.
---@return string mappingstring # A string containing the Joystick's gamepad mappings, or nil if the GUID is not recognized as a gamepad.
function love.joystick.getGamepadMappingString(guid) end

---
---Gets the number of connected joysticks.
---
---@return number joystickcount # The number of connected joysticks.
function love.joystick.getJoystickCount() end

---
---Gets a list of connected Joysticks.
---
---@return table joysticks # The list of currently connected Joysticks.
function love.joystick.getJoysticks() end

---
---Loads a gamepad mappings string or file created with love.joystick.saveGamepadMappings.
---
---It also recognizes any SDL gamecontroller mapping string, such as those created with Steam's Big Picture controller configure interface, or this nice database. If a new mapping is loaded for an already known controller GUID, the later version will overwrite the one currently loaded.
---
---@param filename string # The filename to load the mappings string from.
function love.joystick.loadGamepadMappings(filename) end

---
---Saves the virtual gamepad mappings of all recognized as gamepads and have either been recently used or their gamepad bindings have been modified.
---
---The mappings are stored as a string for use with love.joystick.loadGamepadMappings.
---
---@param filename string # The filename to save the mappings string to.
---@return string mappings # The mappings string that was written to the file.
function love.joystick.saveGamepadMappings(filename) end

---
---Binds a virtual gamepad input to a button, axis or hat for all Joysticks of a certain type. For example, if this function is used with a GUID returned by a Dualshock 3 controller in OS X, the binding will affect Joystick:getGamepadAxis and Joystick:isGamepadDown for ''all'' Dualshock 3 controllers used with the game when run in OS X.
---
---LÖVE includes built-in gamepad bindings for many common controllers. This function lets you change the bindings or add new ones for types of Joysticks which aren't recognized as gamepads by default.
---
---The virtual gamepad buttons and axes are designed around the Xbox 360 controller layout.
---
---@param guid string # The OS-dependent GUID for the type of Joystick the binding will affect.
---@param button GamepadButton # The virtual gamepad button to bind.
---@param inputtype JoystickInputType # The type of input to bind the virtual gamepad button to.
---@param inputindex number # The index of the axis, button, or hat to bind the virtual gamepad button to.
---@param hatdir JoystickHat # The direction of the hat, if the virtual gamepad button will be bound to a hat. nil otherwise.
---@return boolean success # Whether the virtual gamepad button was successfully bound.
function love.joystick.setGamepadMapping(guid, button, inputtype, inputindex, hatdir) end
