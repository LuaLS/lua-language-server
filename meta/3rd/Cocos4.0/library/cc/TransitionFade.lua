---@meta

---@class cc.TransitionFade :cc.TransitionScene
local TransitionFade={ }
cc.TransitionFade=TransitionFade




---@overload fun(float:float,cc.Scene:cc.Scene):self
---@overload fun(float:float,cc.Scene:cc.Scene,color3b_table:color3b_table):self
---@param t float
---@param scene cc.Scene
---@param color color3b_table
---@return boolean
function TransitionFade:initWithDuration (t,scene,color) end
---@overload fun(float:float,cc.Scene:cc.Scene):self
---@overload fun(float:float,cc.Scene:cc.Scene,color3b_table:color3b_table):self
---@param duration float
---@param scene cc.Scene
---@param color color3b_table
---@return self
function TransitionFade:create (duration,scene,color) end
---* 
---@return self
function TransitionFade:TransitionFade () end