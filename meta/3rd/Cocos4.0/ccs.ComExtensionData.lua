---@meta

---@class ccs.ComExtensionData :cc.Component
local ComExtensionData={ }
ccs.ComExtensionData=ComExtensionData




---* 
---@param actionTag int
---@return self
function ComExtensionData:setActionTag (actionTag) end
---* 
---@return string
function ComExtensionData:getCustomProperty () end
---* 
---@return int
function ComExtensionData:getActionTag () end
---* 
---@param customProperty string
---@return self
function ComExtensionData:setCustomProperty (customProperty) end
---* 
---@return self
function ComExtensionData:create () end
---* 
---@return cc.Ref
function ComExtensionData:createInstance () end
---* 
---@return boolean
function ComExtensionData:init () end
---* js NA<br>
---* lua NA
---@return self
function ComExtensionData:onRemove () end
---* js NA<br>
---* lua NA
---@return self
function ComExtensionData:onAdd () end
---* 
---@return self
function ComExtensionData:ComExtensionData () end