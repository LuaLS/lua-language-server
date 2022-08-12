---@meta

---@class cc.Mesh :cc.Ref
local Mesh={ }
cc.Mesh=Mesh




---*  Returns the Material being used by the Mesh 
---@return cc.Material
function Mesh:getMaterial () end
---* get per vertex size in bytes
---@return int
function Mesh:getVertexSizeInBytes () end
---*   Sets a new ProgramState for the Mesh<br>
---* A new Material will be created for it
---@param programState cc.backend.ProgramState
---@return self
function Mesh:setProgramState (programState) end
---*  Sets a new Material to the Mesh 
---@param material cc.Material
---@return self
function Mesh:setMaterial (material) end
---* name getter 
---@return string
function Mesh:getName () end
---* get MeshVertexAttribute by index
---@param idx int
---@return cc.MeshVertexAttrib
function Mesh:getMeshVertexAttribute (idx) end
---* calculate the AABB of the mesh<br>
---* note the AABB is in the local space, not the world space
---@return self
function Mesh:calculateAABB () end
---* 
---@param renderer cc.Renderer
---@param globalZ float
---@param transform mat4_table
---@param flags unsigned_int
---@param lightMask unsigned_int
---@param color vec4_table
---@param forceDepthWrite boolean
---@return self
function Mesh:draw (renderer,globalZ,transform,flags,lightMask,color,forceDepthWrite) end
---* 
---@return cc.BlendFunc
function Mesh:getBlendFunc () end
---* name setter
---@param name string
---@return self
function Mesh:setName (name) end
---* Mesh index data setter
---@param indexdata cc.MeshIndexData
---@return self
function Mesh:setMeshIndexData (indexdata) end
---* get ProgramState<br>
---* lua NA
---@return cc.backend.ProgramState
function Mesh:getProgramState () end
---* get mesh vertex attribute count
---@return int
function Mesh:getMeshVertexAttribCount () end
---* 
---@param blendFunc cc.BlendFunc
---@return self
function Mesh:setBlendFunc (blendFunc) end
---* force set this Sprite3D to 2D render queue
---@param force2D boolean
---@return self
function Mesh:setForce2DQueue (force2D) end
---* skin setter
---@param skin cc.MeshSkin
---@return self
function Mesh:setSkin (skin) end
---* 
---@return boolean
function Mesh:isVisible () end
---* visible getter and setter
---@param visible boolean
---@return self
function Mesh:setVisible (visible) end
---* 
---@return self
function Mesh:Mesh () end