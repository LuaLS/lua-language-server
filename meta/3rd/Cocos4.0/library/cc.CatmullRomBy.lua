---@meta

---@class cc.CatmullRomBy :cc.CardinalSplineBy
local CatmullRomBy={ }
cc.CatmullRomBy=CatmullRomBy




---*  Initializes the action with a duration and an array of points.<br>
---* param dt In seconds.<br>
---* param points An PointArray.
---@param dt float
---@param points point_table
---@return boolean
function CatmullRomBy:initWithDuration (dt,points) end
---* 
---@return self
function CatmullRomBy:clone () end
---* 
---@return self
function CatmullRomBy:reverse () end