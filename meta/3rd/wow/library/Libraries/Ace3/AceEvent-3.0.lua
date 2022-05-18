---@meta
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0)
---@class AceEvent-3.0
local AceEvent = {}

---@param event WowEvent The event to register for
---@param callback function The callback function to call when the event is triggered (funcref or method, defaults to a method with the event name)
---@param arg any An optional argument to pass to the callback function
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0#title-1)
function AceEvent:RegisterEvent(event, callback, arg) end

---@param event WowEvent The event to unregister
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0#title-4)
function AceEvent:UnregisterEvent(event) end

---@param message string The message to register for
---@param callback function The callback function to call when the message is triggered (funcref or method, defaults to a method with the event name)
---@param arg any An optional argument to pass to the callback function
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0#title-2)
function AceEvent:RegisterMessage(message, callback, arg) end

---@param message string The message to unregister
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0#title-5)
function AceEvent:UnregisterMessage(message) end

---@name AceEvent:SendMessage
---@param message string The message to send
---@param  ... any Any arguments to the message
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0#title-3)
function AceEvent:SendMessage(message, ...) end


---@param target any target object to embed AceEvent in
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0)
function AceEvent:Embed(target) end

---@param target AceEvent-3.0
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0)
function AceEvent:OnEmbedDisable(target) end
