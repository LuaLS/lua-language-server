---@meta

---@class cc.ParallaxNode :cc.Node
local ParallaxNode={ }
cc.ParallaxNode=ParallaxNode




---*  Adds a child to the container with a local z-order, parallax ratio and position offset.<br>
---* param child A child node.<br>
---* param z Z order for drawing priority.<br>
---* param parallaxRatio A given parallax ratio.<br>
---* param positionOffset A given position offset.
---@param child cc.Node
---@param z int
---@param parallaxRatio vec2_table
---@param positionOffset vec2_table
---@return self
function ParallaxNode:addChild (child,z,parallaxRatio,positionOffset) end
---* 
---@param cleanup boolean
---@return self
function ParallaxNode:removeAllChildrenWithCleanup (cleanup) end
---*  Create a Parallax node. <br>
---* return An autoreleased ParallaxNode object.
---@return self
function ParallaxNode:create () end
---@overload fun(cc.Node:cc.Node,int:int,int2:string):self
---@overload fun(cc.Node:cc.Node,int:int,int:int):self
---@param child cc.Node
---@param zOrder int
---@param tag int
---@return self
function ParallaxNode:addChild (child,zOrder,tag) end
---* 
---@param renderer cc.Renderer
---@param parentTransform mat4_table
---@param parentFlags unsigned_int
---@return self
function ParallaxNode:visit (renderer,parentTransform,parentFlags) end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function ParallaxNode:removeChild (child,cleanup) end
---*  Adds a child to the container with a z-order, a parallax ratio and a position offset<br>
---* It returns self, so you can chain several addChilds.<br>
---* since v0.8<br>
---* js ctor
---@return self
function ParallaxNode:ParallaxNode () end