---@meta

---@class cc.CatmullRomTo :cc.CardinalSplineTo
local CatmullRomTo={ }
cc.CatmullRomTo=CatmullRomTo




---* Initializes the action with a duration and an array of points.<br>
---* param dt In seconds.<br>
---* param points An PointArray.
---@param dt float
---@param points point_table
---@return boolean
function CatmullRomTo:initWithDuration (dt,points) end
---* 
---@return self
function CatmullRomTo:clone () end
---* 
---@return self
function CatmullRomTo:reverse () end