---@meta

---@class cc.RenderState :cc.Ref
local RenderState={ }
cc.RenderState=RenderState




---* 
---@return string
function RenderState:getName () end
---* Binds the render state for this RenderState and any of its parents, top-down,<br>
---* for the given pass.
---@param pass cc.Pass
---@param d cc.MeshComman
---@return self
function RenderState:bindPass (pass,d) end