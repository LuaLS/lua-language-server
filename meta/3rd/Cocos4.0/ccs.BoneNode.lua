---@meta

---@class ccs.BoneNode :cc.Node@all parent class: Node,BlendProtocol
local BoneNode={ }
ccs.BoneNode=BoneNode




---* 
---@return float
function BoneNode:getDebugDrawWidth () end
---@overload fun():self
---@overload fun():self
---@return array_table
function BoneNode:getChildBones () end
---* 
---@return cc.BlendFunc
function BoneNode:getBlendFunc () end
---* brief: get all bones in this bone tree
---@return array_table
function BoneNode:getAllSubBones () end
---* 
---@param blendFunc cc.BlendFunc
---@return self
function BoneNode:setBlendFunc (blendFunc) end
---* 
---@param isDebugDraw boolean
---@return self
function BoneNode:setDebugDrawEnabled (isDebugDraw) end
---* get displayings rect in self transform
---@return rect_table
function BoneNode:getVisibleSkinsRect () end
---* brief: get all skins in this bone tree
---@return array_table
function BoneNode:getAllSubSkins () end
---@overload fun(cc.Node0:string,boolean:boolean):self
---@overload fun(cc.Node:cc.Node,boolean:boolean):self
---@param skin cc.Node
---@param hideOthers boolean
---@return self
function BoneNode:displaySkin (skin,hideOthers) end
---* 
---@return boolean
function BoneNode:isDebugDrawEnabled () end
---@overload fun(cc.Node:cc.Node,boolean:boolean,boolean:boolean):self
---@overload fun(cc.Node:cc.Node,boolean:boolean):self
---@param skin cc.Node
---@param display boolean
---@param hideOthers boolean
---@return self
function BoneNode:addSkin (skin,display,hideOthers) end
---* 
---@return ccs.SkeletonNode
function BoneNode:getRootSkeletonNode () end
---* 
---@param length float
---@return self
function BoneNode:setDebugDrawLength (length) end
---@overload fun():self
---@overload fun():self
---@return array_table
function BoneNode:getSkins () end
---* 
---@return array_table
function BoneNode:getVisibleSkins () end
---* 
---@param width float
---@return self
function BoneNode:setDebugDrawWidth (width) end
---* 
---@return float
function BoneNode:getDebugDrawLength () end
---* 
---@param color color4f_table
---@return self
function BoneNode:setDebugDrawColor (color) end
---* 
---@return color4f_table
function BoneNode:getDebugDrawColor () end
---@overload fun(int:int):self
---@overload fun():self
---@param length int
---@return self
function BoneNode:create (length) end
---@overload fun(cc.Node:cc.Node,int:int,string2:int):self
---@overload fun(cc.Node:cc.Node,int:int,string:string):self
---@param child cc.Node
---@param localZOrder int
---@param name string
---@return self
function BoneNode:addChild (child,localZOrder,name) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function BoneNode:draw (renderer,transform,flags) end
---* 
---@param name string
---@return self
function BoneNode:setName (name) end
---* 
---@param anchorPoint vec2_table
---@return self
function BoneNode:setAnchorPoint (anchorPoint) end
---* 
---@param localZOrder int
---@return self
function BoneNode:setLocalZOrder (localZOrder) end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function BoneNode:removeChild (child,cleanup) end
---* 
---@return boolean
function BoneNode:init () end
---* 
---@return rect_table
function BoneNode:getBoundingBox () end
---* 
---@param contentSize size_table
---@return self
function BoneNode:setContentSize (contentSize) end
---* 
---@param visible boolean
---@return self
function BoneNode:setVisible (visible) end
---* 
---@return self
function BoneNode:BoneNode () end