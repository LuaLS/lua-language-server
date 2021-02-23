---@meta

---@class cc.TMXObjectGroup :cc.Ref
local TMXObjectGroup={ }
cc.TMXObjectGroup=TMXObjectGroup




---*  Sets the offset position of child objects. <br>
---* param offset The offset position of child objects.
---@param offset vec2_table
---@return self
function TMXObjectGroup:setPositionOffset (offset) end
---*  Return the value for the specific property name. <br>
---* param propertyName The specific property name.<br>
---* return Return the value for the specific property name.<br>
---* js NA
---@param propertyName string
---@return cc.Value
function TMXObjectGroup:getProperty (propertyName) end
---*  Gets the offset position of child objects. <br>
---* return The offset position of child objects.
---@return vec2_table
function TMXObjectGroup:getPositionOffset () end
---*  Return the dictionary for the specific object name.<br>
---* It will return the 1st object found on the array for the given name.<br>
---* return Return the dictionary for the specific object name.
---@param objectName string
---@return map_table
function TMXObjectGroup:getObject (objectName) end
---@overload fun():self
---@overload fun():self
---@return array_table
function TMXObjectGroup:getObjects () end
---*  Set the group name. <br>
---* param groupName A string,it is used to set the group name.
---@param groupName string
---@return self
function TMXObjectGroup:setGroupName (groupName) end
---@overload fun():self
---@overload fun():self
---@return map_table
function TMXObjectGroup:getProperties () end
---*  Get the group name. <br>
---* return The group name.
---@return string
function TMXObjectGroup:getGroupName () end
---*  Sets the list of properties.<br>
---* param properties The list of properties.
---@param properties map_table
---@return self
function TMXObjectGroup:setProperties (properties) end
---*  Sets the array of the objects.<br>
---* param objects The array of the objects.
---@param objects array_table
---@return self
function TMXObjectGroup:setObjects (objects) end
---* js ctor
---@return self
function TMXObjectGroup:TMXObjectGroup () end