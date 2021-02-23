---@meta

---@class cc.SplitCols :cc.TiledGrid3DAction
local SplitCols={ }
cc.SplitCols=SplitCols




---* brief Initializes the action with the number columns and the duration.<br>
---* param duration Specify the duration of the SplitCols action. It's a value in seconds.<br>
---* param cols Specify the columns count should be split.<br>
---* return If the creation success, return true; otherwise, return false.
---@param duration float
---@param cols unsigned_int
---@return boolean
function SplitCols:initWithDuration (duration,cols) end
---* brief Create the action with the number of columns and the duration.<br>
---* param duration Specify the duration of the SplitCols action. It's a value in seconds.<br>
---* param cols Specify the columns count should be split.<br>
---* return If the creation success, return a pointer of SplitCols action; otherwise, return nil.
---@param duration float
---@param cols unsigned_int
---@return self
function SplitCols:create (duration,cols) end
---* 
---@param target cc.Node
---@return self
function SplitCols:startWithTarget (target) end
---* 
---@return self
function SplitCols:clone () end
---* param time in seconds
---@param time float
---@return self
function SplitCols:update (time) end
---* 
---@return self
function SplitCols:SplitCols () end