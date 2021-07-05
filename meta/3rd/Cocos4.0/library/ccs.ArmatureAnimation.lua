---@meta

---@class ccs.ArmatureAnimation 
local ArmatureAnimation={ }
ccs.ArmatureAnimation=ArmatureAnimation




---* 
---@return float
function ArmatureAnimation:getSpeedScale () end
---* Play animation by animation name.<br>
---* param  animationName  The animation name you want to play<br>
---* param  durationTo The frames between two animation changing-over.<br>
---* It's meaning is changing to this animation need how many frames<br>
---* -1 : use the value from MovementData get from flash design panel<br>
---* param  loop   Whether the animation is loop<br>
---* loop < 0 : use the value from MovementData get from flash design panel<br>
---* loop = 0 : this animation is not loop<br>
---* loop > 0 : this animation is loop
---@param animationName string
---@param durationTo int
---@param loop int
---@return self
function ArmatureAnimation:play (animationName,durationTo,loop) end
---* Go to specified frame and pause current movement.
---@param frameIndex int
---@return self
function ArmatureAnimation:gotoAndPause (frameIndex) end
---* 
---@param movementIndexes array_table
---@param durationTo int
---@param loop boolean
---@return self
function ArmatureAnimation:playWithIndexes (movementIndexes,durationTo,loop) end
---* 
---@param data ccs.AnimationData
---@return self
function ArmatureAnimation:setAnimationData (data) end
---* Scale animation play speed.<br>
---* param animationScale Scale value
---@param speedScale float
---@return self
function ArmatureAnimation:setSpeedScale (speedScale) end
---* 
---@return ccs.AnimationData
function ArmatureAnimation:getAnimationData () end
---* Go to specified frame and play current movement.<br>
---* You need first switch to the movement you want to play, then call this function.<br>
---* example : playByIndex(0);<br>
---* gotoAndPlay(0);<br>
---* playByIndex(1);<br>
---* gotoAndPlay(0);<br>
---* gotoAndPlay(15);
---@param frameIndex int
---@return self
function ArmatureAnimation:gotoAndPlay (frameIndex) end
---* Init with a Armature<br>
---* param armature The Armature ArmatureAnimation will bind to
---@param armature ccs.Armature
---@return boolean
function ArmatureAnimation:init (armature) end
---* 
---@param movementNames array_table
---@param durationTo int
---@param loop boolean
---@return self
function ArmatureAnimation:playWithNames (movementNames,durationTo,loop) end
---* Get movement count
---@return int
function ArmatureAnimation:getMovementCount () end
---* 
---@param animationIndex int
---@param durationTo int
---@param loop int
---@return self
function ArmatureAnimation:playWithIndex (animationIndex,durationTo,loop) end
---* Get current movementID<br>
---* return The name of current movement
---@return string
function ArmatureAnimation:getCurrentMovementID () end
---* Create with a Armature<br>
---* param armature The Armature ArmatureAnimation will bind to
---@param armature ccs.Armature
---@return self
function ArmatureAnimation:create (armature) end
---* Pause the Process
---@return self
function ArmatureAnimation:pause () end
---* Stop the Process
---@return self
function ArmatureAnimation:stop () end
---* 
---@param dt float
---@return self
function ArmatureAnimation:update (dt) end
---* Resume the Process
---@return self
function ArmatureAnimation:resume () end
---* js ctor
---@return self
function ArmatureAnimation:ArmatureAnimation () end