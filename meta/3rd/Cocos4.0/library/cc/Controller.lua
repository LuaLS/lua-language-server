---@meta

---@class cc.Controller 
local Controller={ }
cc.Controller=Controller




---* Activate receives key event from external key. e.g. back,menu.<br>
---* Controller receives only standard key which contained within enum Key by default.<br>
---* warning The API only work on the android platform for support diversified game controller.<br>
---* param externalKeyCode   External key code.<br>
---* param receive   True if external key event on this controller should be receive, false otherwise.
---@param externalKeyCode int
---@param receive boolean
---@return self
function Controller:receiveExternalKeyEvent (externalKeyCode,receive) end
---* Gets the name of this Controller object.
---@return string
function Controller:getDeviceName () end
---* Indicates whether the Controller is connected.
---@return boolean
function Controller:isConnected () end
---* Gets the Controller id.
---@return int
function Controller:getDeviceId () end
---* Changes the tag that is used to identify the controller easily.<br>
---* param tag   A integer that identifies the controller.
---@param tag int
---@return self
function Controller:setTag (tag) end
---* Returns a tag that is used to identify the controller easily.<br>
---* return An integer that identifies the controller.
---@return int
function Controller:getTag () end
---* Start discovering new controllers.<br>
---* warning The API has an empty implementation on Android.
---@return self
function Controller:startDiscoveryController () end
---* Stop the discovery process.<br>
---* warning The API has an empty implementation on Android.
---@return self
function Controller:stopDiscoveryController () end
---* Gets a Controller object with device ID.<br>
---* param deviceId   A unique identifier to find the controller.<br>
---* return A Controller object.
---@param deviceId int
---@return self
function Controller:getControllerByDeviceId (deviceId) end
---* Gets a Controller object with tag.<br>
---* param tag   An identifier to find the controller.<br>
---* return A Controller object.
---@param tag int
---@return self
function Controller:getControllerByTag (tag) end