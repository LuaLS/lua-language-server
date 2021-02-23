---@meta

---@class ccs.Bone :cc.Node
local Bone={ }
ccs.Bone=Bone




---* 
---@return boolean
function Bone:isTransformDirty () end
---* 
---@param blendFunc cc.BlendFunc
---@return self
function Bone:setBlendFunc (blendFunc) end
---* 
---@return boolean
function Bone:isIgnoreMovementBoneData () end
---*  Update zorder
---@return self
function Bone:updateZOrder () end
---* 
---@return cc.Node
function Bone:getDisplayRenderNode () end
---* 
---@return boolean
function Bone:isBlendDirty () end
---* Add a child to this bone, and it will let this child call setParent(Bone *parent) function to set self to it's parent<br>
---* param     child  the child you want to add
---@param child ccs.Bone
---@return self
function Bone:addChildBone (child) end
---* 
---@return ccs.BaseData
function Bone:getWorldInfo () end
---* 
---@return ccs.Tween
function Bone:getTween () end
---* Get parent bone<br>
---* return parent bone
---@return self
function Bone:getParentBone () end
---*  Update color to render display
---@return self
function Bone:updateColor () end
---* 
---@param dirty boolean
---@return self
function Bone:setTransformDirty (dirty) end
---* 
---@return int
function Bone:getDisplayRenderNodeType () end
---* 
---@param index int
---@return self
function Bone:removeDisplay (index) end
---* 
---@param boneData ccs.BoneData
---@return self
function Bone:setBoneData (boneData) end
---* Initializes a Bone with the specified name<br>
---* param name Bone's name.
---@param name string
---@return boolean
function Bone:init (name) end
---* Set parent bone.<br>
---* If parent is null, then also remove this bone from armature.<br>
---* It will not set the Armature, if you want to add the bone to a Armature, you should use Armature::addBone(Bone *bone, const char* parentName).<br>
---* param parent  the parent bone.<br>
---* nullptr : remove this bone from armature
---@param parent ccs.Bone
---@return self
function Bone:setParentBone (parent) end
---@overload fun(ccs.DisplayData0:cc.Node,int:int):self
---@overload fun(ccs.DisplayData:ccs.DisplayData,int:int):self
---@param displayData ccs.DisplayData
---@param index int
---@return self
function Bone:addDisplay (displayData,index) end
---* 
---@return cc.BlendFunc
function Bone:getBlendFunc () end
---* Remove itself from its parent.<br>
---* param recursion    whether or not to remove childBone's display
---@param recursion boolean
---@return self
function Bone:removeFromParent (recursion) end
---* 
---@return ccs.ColliderDetector
function Bone:getColliderDetector () end
---* 
---@return ccs.Armature
function Bone:getChildArmature () end
---* 
---@return ccs.FrameData
function Bone:getTweenData () end
---* 
---@param index int
---@param force boolean
---@return self
function Bone:changeDisplayWithIndex (index,force) end
---* 
---@param name string
---@param force boolean
---@return self
function Bone:changeDisplayWithName (name,force) end
---* 
---@param armature ccs.Armature
---@return self
function Bone:setArmature (armature) end
---* 
---@param dirty boolean
---@return self
function Bone:setBlendDirty (dirty) end
---* Removes a child Bone<br>
---* param     bone   the bone you want to remove
---@param bone ccs.Bone
---@param recursion boolean
---@return self
function Bone:removeChildBone (bone,recursion) end
---* 
---@param childArmature ccs.Armature
---@return self
function Bone:setChildArmature (childArmature) end
---* 
---@return mat4_table
function Bone:getNodeToArmatureTransform () end
---* 
---@return ccs.DisplayManager
function Bone:getDisplayManager () end
---* 
---@return ccs.Armature
function Bone:getArmature () end
---* 
---@return ccs.BoneData
function Bone:getBoneData () end
---@overload fun(string:string):self
---@overload fun():self
---@param name string
---@return self
function Bone:create (name) end
---* 
---@return mat4_table
function Bone:getNodeToWorldTransform () end
---* 
---@param zOrder int
---@return self
function Bone:setLocalZOrder (zOrder) end
---* 
---@param delta float
---@return self
function Bone:update (delta) end
---* 
---@param parentOpacity unsigned_char
---@return self
function Bone:updateDisplayedOpacity (parentOpacity) end
---* Initializes an empty Bone with nothing init.
---@return boolean
function Bone:init () end
---* 
---@param parentColor color3b_table
---@return self
function Bone:updateDisplayedColor (parentColor) end
---* js ctor
---@return self
function Bone:Bone () end