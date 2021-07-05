---@meta

---@class sp.SkeletonRenderer :cc.Node@all parent class: Node,BlendProtocol
local SkeletonRenderer={ }
sp.SkeletonRenderer=SkeletonRenderer




---* 
---@param scale float
---@return self
function SkeletonRenderer:setTimeScale (scale) end
---* 
---@return boolean
function SkeletonRenderer:getDebugSlotsEnabled () end
---* 
---@return self
function SkeletonRenderer:setBonesToSetupPose () end
---* 
---@param skeletonData spSkeletonData
---@param ownsSkeletonData boolean
---@return self
function SkeletonRenderer:initWithData (skeletonData,ownsSkeletonData) end
---* 
---@param enabled boolean
---@return self
function SkeletonRenderer:setDebugSlotsEnabled (enabled) end
---@overload fun(string:string,spAtlas1:string,float:float):self
---@overload fun(string:string,spAtlas:spAtlas,float:float):self
---@param skeletonDataFile string
---@param atlas spAtlas
---@param scale float
---@return self
function SkeletonRenderer:initWithJsonFile (skeletonDataFile,atlas,scale) end
---* 
---@return self
function SkeletonRenderer:setSlotsToSetupPose () end
---@overload fun(string:string,spAtlas1:string,float:float):self
---@overload fun(string:string,spAtlas:spAtlas,float:float):self
---@param skeletonDataFile string
---@param atlas spAtlas
---@param scale float
---@return self
function SkeletonRenderer:initWithBinaryFile (skeletonDataFile,atlas,scale) end
---* 
---@return self
function SkeletonRenderer:setToSetupPose () end
---* 
---@param enabled boolean
---@return self
function SkeletonRenderer:setDebugMeshesEnabled (enabled) end
---* 
---@return boolean
function SkeletonRenderer:isTwoColorTint () end
---* 
---@return cc.BlendFunc
function SkeletonRenderer:getBlendFunc () end
---* 
---@return self
function SkeletonRenderer:initialize () end
---* 
---@param enabled boolean
---@return self
function SkeletonRenderer:setDebugBonesEnabled (enabled) end
---* 
---@return boolean
function SkeletonRenderer:getDebugBonesEnabled () end
---* 
---@return float
function SkeletonRenderer:getTimeScale () end
---* 
---@param enabled boolean
---@return self
function SkeletonRenderer:setTwoColorTint (enabled) end
---* 
---@return boolean
function SkeletonRenderer:getDebugMeshesEnabled () end
---* 
---@param blendFunc cc.BlendFunc
---@return self
function SkeletonRenderer:setBlendFunc (blendFunc) end
---* 
---@param effect spVertexEffect
---@return self
function SkeletonRenderer:setVertexEffect (effect) end
---@overload fun(string0:char):self
---@overload fun(string:string):self
---@param skinName string
---@return boolean
function SkeletonRenderer:setSkin (skinName) end
---* 
---@return spSkeleton
function SkeletonRenderer:getSkeleton () end
---@overload fun(string:string,spAtlas1:string,float:float):self
---@overload fun(string:string,spAtlas:spAtlas,float:float):self
---@param skeletonDataFile string
---@param atlas spAtlas
---@param scale float
---@return self
function SkeletonRenderer:createWithFile (skeletonDataFile,atlas,scale) end
---* 
---@return self
function SkeletonRenderer:create () end
---* 
---@return self
function SkeletonRenderer:onEnter () end
---* 
---@return self
function SkeletonRenderer:onExit () end
---* 
---@param value boolean
---@return self
function SkeletonRenderer:setOpacityModifyRGB (value) end
---* 
---@return rect_table
function SkeletonRenderer:getBoundingBox () end
---* 
---@return boolean
function SkeletonRenderer:isOpacityModifyRGB () end
---@overload fun(string0:spSkeletonData,string1:boolean):self
---@overload fun():self
---@overload fun(string:string,string1:spAtlas,float:float):self
---@overload fun(string:string,string:string,float:float):self
---@param skeletonDataFile string
---@param atlasFile string
---@param scale float
---@return self
function SkeletonRenderer:SkeletonRenderer (skeletonDataFile,atlasFile,scale) end