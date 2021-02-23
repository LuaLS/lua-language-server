---@meta

---@class ccs.Armature :cc.Node@all parent class: Node,BlendProtocol
local Armature={ }
ccs.Armature=Armature




---* Get a bone with the specified name<br>
---* param name The bone's name you want to get
---@param name string
---@return ccs.Bone
function Armature:getBone (name) end
---* Change a bone's parent with the specified parent name.<br>
---* param bone The bone you want to change parent<br>
---* param parentName The new parent's name.
---@param bone ccs.Bone
---@param parentName string
---@return self
function Armature:changeBoneParent (bone,parentName) end
---* 
---@param animation ccs.ArmatureAnimation
---@return self
function Armature:setAnimation (animation) end
---* 
---@param x float
---@param y float
---@return ccs.Bone
function Armature:getBoneAtPoint (x,y) end
---* 
---@return boolean
function Armature:getArmatureTransformDirty () end
---* 
---@param version float
---@return self
function Armature:setVersion (version) end
---* Set contentsize and Calculate anchor point.
---@return self
function Armature:updateOffsetPoint () end
---* 
---@return ccs.Bone
function Armature:getParentBone () end
---* Remove a bone with the specified name. If recursion it will also remove child Bone recursionly.<br>
---* param bone The bone you want to remove<br>
---* param recursion Determine whether remove the bone's child  recursion.
---@param bone ccs.Bone
---@param recursion boolean
---@return self
function Armature:removeBone (bone,recursion) end
---* 
---@return ccs.BatchNode
function Armature:getBatchNode () end
---@overload fun(string:string,ccs.Bone:ccs.Bone):self
---@overload fun(string:string):self
---@param name string
---@param parentBone ccs.Bone
---@return boolean
function Armature:init (name,parentBone) end
---* 
---@param parentBone ccs.Bone
---@return self
function Armature:setParentBone (parentBone) end
---* 
---@param batchNode ccs.BatchNode
---@return self
function Armature:setBatchNode (batchNode) end
---* js NA<br>
---* lua NA
---@return cc.BlendFunc
function Armature:getBlendFunc () end
---* 
---@param armatureData ccs.ArmatureData
---@return self
function Armature:setArmatureData (armatureData) end
---* Add a Bone to this Armature,<br>
---* param bone  The Bone you want to add to Armature<br>
---* param parentName   The parent Bone's name you want to add to . If it's  nullptr, then set Armature to its parent
---@param bone ccs.Bone
---@param parentName string
---@return self
function Armature:addBone (bone,parentName) end
---* 
---@return ccs.ArmatureData
function Armature:getArmatureData () end
---* 
---@return float
function Armature:getVersion () end
---* 
---@return ccs.ArmatureAnimation
function Armature:getAnimation () end
---* 
---@return vec2_table
function Armature:getOffsetPoints () end
---* js NA<br>
---* lua NA
---@param blendFunc cc.BlendFunc
---@return self
function Armature:setBlendFunc (blendFunc) end
---* Get Armature's bone dictionary<br>
---* return Armature's bone dictionary
---@return map_table
function Armature:getBoneDic () end
---@overload fun(string:string):self
---@overload fun():self
---@overload fun(string:string,ccs.Bone:ccs.Bone):self
---@param name string
---@param parentBone ccs.Bone
---@return self
function Armature:create (name,parentBone) end
---* 
---@param point vec2_table
---@return self
function Armature:setAnchorPoint (point) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function Armature:draw (renderer,transform,flags) end
---* 
---@return vec2_table
function Armature:getAnchorPointInPoints () end
---* 
---@param dt float
---@return self
function Armature:update (dt) end
---* Init the empty armature
---@return boolean
function Armature:init () end
---* 
---@return mat4_table
function Armature:getNodeToParentTransform () end
---* This boundingBox will calculate all bones' boundingBox every time
---@return rect_table
function Armature:getBoundingBox () end
---* js ctor
---@return self
function Armature:Armature () end