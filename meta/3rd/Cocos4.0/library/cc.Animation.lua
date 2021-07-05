---@meta

---@class cc.Animation :cc.Ref
local Animation={ }
cc.Animation=Animation




---*  Gets the times the animation is going to loop. 0 means animation is not animated. 1, animation is executed one time, ... <br>
---* return The times the animation is going to loop.
---@return unsigned_int
function Animation:getLoops () end
---*  Adds a SpriteFrame to a Animation.<br>
---* param frame The frame will be added with one "delay unit".
---@param frame cc.SpriteFrame
---@return self
function Animation:addSpriteFrame (frame) end
---*  Sets whether to restore the original frame when animation finishes. <br>
---* param restoreOriginalFrame Whether to restore the original frame when animation finishes.
---@param restoreOriginalFrame boolean
---@return self
function Animation:setRestoreOriginalFrame (restoreOriginalFrame) end
---* 
---@return self
function Animation:clone () end
---*  Gets the duration in seconds of the whole animation. It is the result of totalDelayUnits * delayPerUnit.<br>
---* return Result of totalDelayUnits * delayPerUnit.
---@return float
function Animation:getDuration () end
---*  Initializes a Animation with AnimationFrame.<br>
---* since v2.0
---@param arrayOfAnimationFrameNames array_table
---@param delayPerUnit float
---@param loops unsigned_int
---@return boolean
function Animation:initWithAnimationFrames (arrayOfAnimationFrameNames,delayPerUnit,loops) end
---*  Initializes a Animation. 
---@return boolean
function Animation:init () end
---*  Sets the array of AnimationFrames. <br>
---* param frames The array of AnimationFrames.
---@param frames array_table
---@return self
function Animation:setFrames (frames) end
---*  Gets the array of AnimationFrames.<br>
---* return The array of AnimationFrames.
---@return array_table
function Animation:getFrames () end
---*  Sets the times the animation is going to loop. 0 means animation is not animated. 1, animation is executed one time, ... <br>
---* param loops The times the animation is going to loop.
---@param loops unsigned_int
---@return self
function Animation:setLoops (loops) end
---*  Sets the delay in seconds of the "delay unit".<br>
---* param delayPerUnit The delay in seconds of the "delay unit".
---@param delayPerUnit float
---@return self
function Animation:setDelayPerUnit (delayPerUnit) end
---*  Adds a frame with an image filename. Internally it will create a SpriteFrame and it will add it.<br>
---* The frame will be added with one "delay unit".<br>
---* Added to facilitate the migration from v0.8 to v0.9.<br>
---* param filename The path of SpriteFrame.
---@param filename string
---@return self
function Animation:addSpriteFrameWithFile (filename) end
---*  Gets the total Delay units of the Animation. <br>
---* return The total Delay units of the Animation.
---@return float
function Animation:getTotalDelayUnits () end
---*  Gets the delay in seconds of the "delay unit".<br>
---* return The delay in seconds of the "delay unit".
---@return float
function Animation:getDelayPerUnit () end
---*  Initializes a Animation with frames and a delay between frames.<br>
---* since v0.99.5
---@param arrayOfSpriteFrameNames array_table
---@param delay float
---@param loops unsigned_int
---@return boolean
function Animation:initWithSpriteFrames (arrayOfSpriteFrameNames,delay,loops) end
---*  Checks whether to restore the original frame when animation finishes. <br>
---* return Restore the original frame when animation finishes.
---@return boolean
function Animation:getRestoreOriginalFrame () end
---*  Adds a frame with a texture and a rect. Internally it will create a SpriteFrame and it will add it.<br>
---* The frame will be added with one "delay unit".<br>
---* Added to facilitate the migration from v0.8 to v0.9.<br>
---* param pobTexture A frame with a texture.<br>
---* param rect The Texture of rect.
---@param pobTexture cc.Texture2D
---@param rect rect_table
---@return self
function Animation:addSpriteFrameWithTexture (pobTexture,rect) end
---@overload fun(array_table:array_table,float:float,unsigned_int:unsigned_int):self
---@overload fun():self
---@param arrayOfAnimationFrameNames array_table
---@param delayPerUnit float
---@param loops unsigned_int
---@return self
function Animation:create (arrayOfAnimationFrameNames,delayPerUnit,loops) end
---* 
---@param arrayOfSpriteFrameNames array_table
---@param delay float
---@param loops unsigned_int
---@return self
function Animation:createWithSpriteFrames (arrayOfSpriteFrameNames,delay,loops) end
---* 
---@return self
function Animation:Animation () end