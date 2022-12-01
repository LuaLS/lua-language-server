---@meta

---@class cc.FadeOut :cc.FadeTo
local FadeOut={ }
cc.FadeOut=FadeOut




---* js NA
---@param ac cc.FadeTo
---@return self
function FadeOut:setReverseAction (ac) end
---* Creates the action.<br>
---* param d Duration time, in seconds.
---@param d float
---@return self
function FadeOut:create (d) end
---* 
---@param target cc.Node
---@return self
function FadeOut:startWithTarget (target) end
---* 
---@return self
function FadeOut:clone () end
---* 
---@return cc.FadeTo
function FadeOut:reverse () end
---* 
---@return self
function FadeOut:FadeOut () end