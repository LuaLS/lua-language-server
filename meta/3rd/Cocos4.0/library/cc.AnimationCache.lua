---@meta

---@class cc.AnimationCache :cc.Ref
local AnimationCache={ }
cc.AnimationCache=AnimationCache




---*  Returns a Animation that was previously added.<br>
---* If the name is not found it will return nil.<br>
---* You should retain the returned copy if you are going to use it.<br>
---* return A Animation that was previously added. If the name is not found it will return nil.
---@param name string
---@return cc.Animation
function AnimationCache:getAnimation (name) end
---*  Adds a Animation with a name.<br>
---* param animation An animation.<br>
---* param name The name of animation.
---@param animation cc.Animation
---@param name string
---@return self
function AnimationCache:addAnimation (animation,name) end
---* 
---@return boolean
function AnimationCache:init () end
---*  Adds an animation from an NSDictionary.<br>
---* Make sure that the frames were previously loaded in the SpriteFrameCache.<br>
---* param dictionary An NSDictionary.<br>
---* param plist The path of the relative file,it use to find the plist path for load SpriteFrames.<br>
---* since v1.1<br>
---* js NA
---@param dictionary map_table
---@param plist string
---@return self
function AnimationCache:addAnimationsWithDictionary (dictionary,plist) end
---*  Deletes a Animation from the cache.<br>
---* param name The name of animation.
---@param name string
---@return self
function AnimationCache:removeAnimation (name) end
---*  Adds an animation from a plist file.<br>
---* Make sure that the frames were previously loaded in the SpriteFrameCache.<br>
---* since v1.1<br>
---* js addAnimations<br>
---* lua addAnimations<br>
---* param plist An animation from a plist file.
---@param plist string
---@return self
function AnimationCache:addAnimationsWithFile (plist) end
---*  Purges the cache. It releases all the Animation objects and the shared instance.<br>
---* js NA
---@return self
function AnimationCache:destroyInstance () end
---*  Returns the shared instance of the Animation cache <br>
---* js NA
---@return self
function AnimationCache:getInstance () end
---* js ctor
---@return self
function AnimationCache:AnimationCache () end