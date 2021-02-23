---@meta

---@class cc.FadeIn :cc.FadeTo
local FadeIn={ }
cc.FadeIn=FadeIn




---* js NA
---@param ac cc.FadeTo
---@return self
function FadeIn:setReverseAction (ac) end
---* Creates the action.<br>
---* param d Duration time, in seconds.<br>
---* return An autoreleased FadeIn object.
---@param d float
---@return self
function FadeIn:create (d) end
---* 
---@param target cc.Node
---@return self
function FadeIn:startWithTarget (target) end
---* 
---@return self
function FadeIn:clone () end
---* 
---@return cc.FadeTo
function FadeIn:reverse () end
---* 
---@return self
function FadeIn:FadeIn () end