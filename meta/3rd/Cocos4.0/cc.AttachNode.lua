---@meta

---@class cc.AttachNode :cc.Node
local AttachNode={ }
cc.AttachNode=AttachNode




---* creates an AttachNode<br>
---* param attachBone The bone to which the AttachNode is going to attach, the attacheBone must be a bone of the AttachNode's parent
---@param attachBone cc.Bone3D
---@return self
function AttachNode:create (attachBone) end
---* 
---@param renderer cc.Renderer
---@param parentTransform mat4_table
---@param parentFlags unsigned_int
---@return self
function AttachNode:visit (renderer,parentTransform,parentFlags) end
---* 
---@return mat4_table
function AttachNode:getWorldToNodeTransform () end
---* 
---@return mat4_table
function AttachNode:getNodeToWorldTransform () end
---* 
---@return mat4_table
function AttachNode:getNodeToParentTransform () end
---* 
---@return self
function AttachNode:AttachNode () end