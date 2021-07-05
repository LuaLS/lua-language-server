---@meta

---@class ccs.BatchNode :cc.Node
local BatchNode={ }
ccs.BatchNode=BatchNode




---* 
---@return self
function BatchNode:create () end
---@overload fun(cc.Node:cc.Node,int:int,int2:string):self
---@overload fun(cc.Node:cc.Node,int:int,int:int):self
---@param pChild cc.Node
---@param zOrder int
---@param tag int
---@return self
function BatchNode:addChild (pChild,zOrder,tag) end
---* js NA
---@return boolean
function BatchNode:init () end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function BatchNode:draw (renderer,transform,flags) end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function BatchNode:removeChild (child,cleanup) end