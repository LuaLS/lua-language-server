---@meta
C_GamePad = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.ApplyConfigs)
function C_GamePad.ApplyConfigs() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.AxisIndexToConfigName)
---@param axisIndex number
---@return string? configName
function C_GamePad.AxisIndexToConfigName(axisIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.ButtonBindingToIndex)
---@param bindingName string
---@return number? buttonIndex
function C_GamePad.ButtonBindingToIndex(bindingName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.ButtonIndexToBinding)
---@param buttonIndex number
---@return string? bindingName
function C_GamePad.ButtonIndexToBinding(buttonIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.ButtonIndexToConfigName)
---@param buttonIndex number
---@return string? configName
function C_GamePad.ButtonIndexToConfigName(buttonIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.ClearLedColor)
function C_GamePad.ClearLedColor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.DeleteConfig)
---@param configID GamePadConfigID
function C_GamePad.DeleteConfig(configID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.GetActiveDeviceID)
---@return number deviceID
function C_GamePad.GetActiveDeviceID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.GetAllConfigIDs)
---@return GamePadConfigID[] configIDs
function C_GamePad.GetAllConfigIDs() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.GetAllDeviceIDs)
---@return number[] deviceIDs
function C_GamePad.GetAllDeviceIDs() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.GetCombinedDeviceID)
---@return number deviceID
function C_GamePad.GetCombinedDeviceID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.GetConfig)
---@param configID GamePadConfigID
---@return GamePadConfig? config
function C_GamePad.GetConfig(configID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.GetDeviceMappedState)
---@param deviceID? number
---@return GamePadMappedState? state
function C_GamePad.GetDeviceMappedState(deviceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.GetDeviceRawState)
---@param deviceID number
---@return GamePadRawState? rawState
function C_GamePad.GetDeviceRawState(deviceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.GetLedColor)
---@return ColorMixin color
function C_GamePad.GetLedColor() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.IsEnabled)
---@return boolean enabled
function C_GamePad.IsEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.SetConfig)
---@param config GamePadConfig
function C_GamePad.SetConfig(config) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.SetLedColor)
---@param color ColorMixin
function C_GamePad.SetLedColor(color) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.SetVibration)
---@param vibrationType string
---@param intensity number
function C_GamePad.SetVibration(vibrationType, intensity) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.StickIndexToConfigName)
---@param stickIndex number
---@return string? configName
function C_GamePad.StickIndexToConfigName(stickIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GamePad.StopVibration)
function C_GamePad.StopVibration() end

---@class GamePadAxisConfig
---@field axis string
---@field shift number|nil
---@field scale number|nil
---@field deadzone number|nil
---@field buttonThreshold number|nil
---@field buttonPos string|nil
---@field buttonNeg string|nil
---@field comment string|nil

---@class GamePadConfig
---@field comment string|nil
---@field name string|nil
---@field configID GamePadConfigID
---@field labelStyle string|nil
---@field rawButtonMappings GamePadRawButtonMapping[]
---@field rawAxisMappings GamePadRawAxisMapping[]
---@field axisConfigs GamePadAxisConfig[]
---@field stickConfigs GamePadStickConfig[]

---@class GamePadConfigID
---@field vendorID number|nil
---@field productID number|nil

---@class GamePadMappedState
---@field name string
---@field labelStyle string
---@field buttonCount number
---@field axisCount number
---@field stickCount number
---@field buttons boolean[]
---@field axes number[]
---@field sticks GamePadStick[]

---@class GamePadRawAxisMapping
---@field rawIndex number
---@field axis string|nil
---@field comment string|nil

---@class GamePadRawButtonMapping
---@field rawIndex number
---@field button string|nil
---@field axis string|nil
---@field axisValue number|nil
---@field comment string|nil

---@class GamePadRawState
---@field name string
---@field vendorID number
---@field productID number
---@field rawButtonCount number
---@field rawAxisCount number
---@field rawButtons boolean[]
---@field rawAxes number[]

---@class GamePadStick
---@field x number
---@field y number
---@field len number

---@class GamePadStickConfig
---@field stick string
---@field axisX string|nil
---@field axisY string|nil
---@field deadzone number|nil
---@field deadzoneX number|nil
---@field deadzoneY number|nil
---@field comment string|nil
