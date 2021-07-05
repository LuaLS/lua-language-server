---@meta

---@class sp.SkeletonAnimation :sp.SkeletonRenderer
local SkeletonAnimation={ }
sp.SkeletonAnimation=SkeletonAnimation




---* 
---@param entry spTrackEntry
---@param listener function
---@return self
function SkeletonAnimation:setTrackCompleteListener (entry,listener) end
---* 
---@param name string
---@return spAnimation
function SkeletonAnimation:findAnimation (name) end
---* 
---@param listener function
---@return self
function SkeletonAnimation:setCompleteListener (listener) end
---* 
---@param fromAnimation string
---@param toAnimation string
---@param duration float
---@return self
function SkeletonAnimation:setMix (fromAnimation,toAnimation,duration) end
---* 
---@param entry spTrackEntry
---@param listener function
---@return self
function SkeletonAnimation:setTrackStartListener (entry,listener) end
---* 
---@param trackIndex int
---@param mixDuration float
---@param delay float
---@return spTrackEntry
function SkeletonAnimation:addEmptyAnimation (trackIndex,mixDuration,delay) end
---* 
---@param listener function
---@return self
function SkeletonAnimation:setDisposeListener (listener) end
---* 
---@param entry spTrackEntry
---@param listener function
---@return self
function SkeletonAnimation:setTrackInterruptListener (entry,listener) end
---* 
---@param listener function
---@return self
function SkeletonAnimation:setEndListener (listener) end
---* 
---@param entry spTrackEntry
---@param listener function
---@return self
function SkeletonAnimation:setTrackDisposeListener (entry,listener) end
---* 
---@param listener function
---@return self
function SkeletonAnimation:setEventListener (listener) end
---* 
---@param trackIndex int
---@param mixDuration float
---@return spTrackEntry
function SkeletonAnimation:setEmptyAnimation (trackIndex,mixDuration) end
---* 
---@param entry spTrackEntry
---@param listener function
---@return self
function SkeletonAnimation:setTrackEventListener (entry,listener) end
---* 
---@return self
function SkeletonAnimation:clearTrack () end
---* 
---@param listener function
---@return self
function SkeletonAnimation:setInterruptListener (listener) end
---* 
---@param mixDuration float
---@return self
function SkeletonAnimation:setEmptyAnimations (mixDuration) end
---* 
---@return self
function SkeletonAnimation:clearTracks () end
---* 
---@param entry spTrackEntry
---@param listener function
---@return self
function SkeletonAnimation:setTrackEndListener (entry,listener) end
---* 
---@param listener function
---@return self
function SkeletonAnimation:setStartListener (listener) end
---@overload fun(string:string,spAtlas1:string,float:float):self
---@overload fun(string:string,spAtlas:spAtlas,float:float):self
---@param skeletonBinaryFile string
---@param atlas spAtlas
---@param scale float
---@return self
function SkeletonAnimation:createWithBinaryFile (skeletonBinaryFile,atlas,scale) end
---* 
---@return self
function SkeletonAnimation:create () end
---@overload fun(string:string,spAtlas1:string,float:float):self
---@overload fun(string:string,spAtlas:spAtlas,float:float):self
---@param skeletonJsonFile string
---@param atlas spAtlas
---@param scale float
---@return self
function SkeletonAnimation:createWithJsonFile (skeletonJsonFile,atlas,scale) end
---* 
---@return self
function SkeletonAnimation:initialize () end