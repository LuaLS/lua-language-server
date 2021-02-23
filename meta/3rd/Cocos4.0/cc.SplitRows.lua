---@meta

---@class cc.SplitRows :cc.TiledGrid3DAction
local SplitRows={ }
cc.SplitRows=SplitRows




---* brief Initializes the action with the number rows and the duration.<br>
---* param duration Specify the duration of the SplitRows action. It's a value in seconds.<br>
---* param rows Specify the rows count should be split.<br>
---* return If the creation success, return true; otherwise, return false.
---@param duration float
---@param rows unsigned_int
---@return boolean
function SplitRows:initWithDuration (duration,rows) end
---* brief Create the action with the number of rows and the duration.<br>
---* param duration Specify the duration of the SplitRows action. It's a value in seconds.<br>
---* param rows Specify the rows count should be split.<br>
---* return If the creation success, return a pointer of SplitRows action; otherwise, return nil.
---@param duration float
---@param rows unsigned_int
---@return self
function SplitRows:create (duration,rows) end
---* 
---@param target cc.Node
---@return self
function SplitRows:startWithTarget (target) end
---* 
---@return self
function SplitRows:clone () end
---* 
---@param time float
---@return self
function SplitRows:update (time) end
---* 
---@return self
function SplitRows:SplitRows () end