---@meta
---@class UIObject
local UIObject = {}

--- Returns the widget object's name
---@return string name
---[Documentation](https://wowpedia.fandom.com/wiki/API_UIObject_GetName)
function UIObject:GetName() end

--- Returns the object's widget type
---@return string objectType
---[Documentation](https://wowpedia.fandom.com/wiki/API_UIObject_GetObjectType)
function UIObject:GetObjectType() end

--- Returns whether the object belongs to a given widget type
---@param type string
---@return boolean isType
---[Documentation](https://wowpedia.fandom.com/wiki/API_UIObject_IsObjectType)
function UIObject:IsObjectType(type) end


---@class ParentedObject : UIObject
---[Documentation](https://wowpedia.fandom.com/wiki/UIOBJECT_ParentedObject)
local ParentedObject = {}

--- Returns the widget object's debug name
---@return string debugName
---[Documentation](https://wowpedia.fandom.com/wiki/API_ParentedObject_GetDebugName)
function ParentedObject:GetDebugName() end

--- Returns the widget's parent object
---@return ParentedObject parent
---[Documentation](https://wowpedia.fandom.com/wiki/API_ParentedObject_GetParent)
function ParentedObject:GetParent() end

--- Returns if this widget's methods may only be called from secure execution paths
---@return boolean isForbidden
---[Documentation](https://wowpedia.fandom.com/wiki/API_ParentedObject_IsForbidden)
function ParentedObject:IsForbidden() end

--- Sets the widget to be forbidden for insecure code
---@param forbidden boolean
---[Documentation](https://wowpedia.fandom.com/wiki/API_ParentedObject_SetForbidden)
function ParentedObject:SetForbidden(forbidden) end
