---@meta

---@class ccs.ComRender :cc.Component
local ComRender={ }
ccs.ComRender=ComRender




---* 
---@param node cc.Node
---@return self
function ComRender:setNode (node) end
---* 
---@return cc.Node
function ComRender:getNode () end
---@overload fun(cc.Node:cc.Node,char:char):self
---@overload fun():self
---@param node cc.Node
---@param comName char
---@return self
function ComRender:create (node,comName) end
---* 
---@return cc.Ref
function ComRender:createInstance () end
---* 
---@param r void
---@return boolean
function ComRender:serialize (r) end
---* js NA<br>
---* lua NA
---@return self
function ComRender:onRemove () end
---* js NA<br>
---* lua NA
---@return self
function ComRender:onAdd () end