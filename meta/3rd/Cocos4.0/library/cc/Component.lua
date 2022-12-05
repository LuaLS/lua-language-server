---@meta

---@class cc.Component :cc.Ref
local Component={ }
cc.Component=Component




---* 
---@param enabled boolean
---@return self
function Component:setEnabled (enabled) end
---* 
---@return self
function Component:onRemove () end
---* 
---@param name string
---@return self
function Component:setName (name) end
---* 
---@return boolean
function Component:isEnabled () end
---* 
---@param delta float
---@return self
function Component:update (delta) end
---* 
---@return cc.Node
function Component:getOwner () end
---* 
---@return boolean
function Component:init () end
---* 
---@param owner cc.Node
---@return self
function Component:setOwner (owner) end
---* 
---@return string
function Component:getName () end
---* 
---@return self
function Component:onAdd () end
---* 
---@return self
function Component:create () end