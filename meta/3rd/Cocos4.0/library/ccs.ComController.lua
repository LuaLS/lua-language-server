---@meta

---@class ccs.ComController :cc.Component@all parent class: Component,InputDelegate
local ComController={ }
ccs.ComController=ComController




---* 
---@return self
function ComController:create () end
---* 
---@return cc.Ref
function ComController:createInstance () end
---* js NA<br>
---* lua NA
---@return self
function ComController:onRemove () end
---* 
---@param delta float
---@return self
function ComController:update (delta) end
---* 
---@return boolean
function ComController:init () end
---* js NA<br>
---* lua NA
---@return self
function ComController:onAdd () end
---* js ctor
---@return self
function ComController:ComController () end