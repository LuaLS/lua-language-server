---@meta

---@class cc.Pass :cc.Ref
local Pass={ }
cc.Pass=Pass




---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformPointLightPosition (d,t) end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformDirLightDir (d,t) end
---* 
---@param technique cc.Technique
---@return self
function Pass:setTechnique (technique) end
---* Returns the vertex attribute binding for this pass.<br>
---* return The vertex attribute binding for this pass.
---@return cc.VertexAttribBinding
function Pass:getVertexAttributeBinding () end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformSpotLightOuterAngleCos (d,t) end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformSpotLightDir (d,t) end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformMatrixPalette (d,t) end
---* 
---@param name string
---@return self
function Pass:setName (name) end
---* 
---@return string
function Pass:getName () end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformSpotLightRangeInverse (d,t) end
---* Returns a clone (deep-copy) of this instance 
---@return self
function Pass:clone () end
---* 
---@param meshCommand cc.MeshCommand
---@param globalZOrder float
---@param vertexBuffer cc.backend.Buffer
---@param indexBuffer cc.backend.Buffer
---@param primitive int
---@param indexFormat int
---@param indexCount unsigned_int
---@param modelView mat4_table
---@return self
function Pass:draw (meshCommand,globalZOrder,vertexBuffer,indexBuffer,primitive,indexFormat,indexCount,modelView) end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformPointLightRangeInverse (d,t) end
---* 
---@param slot unsigned_int
---@param d cc.backend.TextureBacken
---@return self
function Pass:setUniformNormTexture (slot,d) end
---* 
---@param modelView mat4_table
---@return self
function Pass:updateMVPUniform (modelView) end
---*  Returns the ProgramState 
---@return cc.backend.ProgramState
function Pass:getProgramState () end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformSpotLightColor (d,t) end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformAmbientLigthColor (d,t) end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformDirLightColor (d,t) end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformSpotLightPosition (d,t) end
---* Sets a vertex attribute binding for this pass.<br>
---* When a mesh binding is set, the VertexAttribBinding will be automatically<br>
---* bound when the bind() method is called for the pass.<br>
---* param binding The VertexAttribBinding to set (or NULL to remove an existing binding).
---@param binding cc.VertexAttribBinding
---@return self
function Pass:setVertexAttribBinding (binding) end
---* 
---@param slot unsigned_int
---@param d cc.backend.TextureBacken
---@return self
function Pass:setUniformTexture (slot,d) end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformSpotLightInnerAngleCos (d,t) end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformColor (d,t) end
---* 
---@param d voi
---@param t unsigned in
---@return self
function Pass:setUniformPointLightColor (d,t) end
---*  Creates a Pass with a GLProgramState.
---@param parent cc.Technique
---@param programState cc.backend.ProgramState
---@return self
function Pass:createWithProgramState (parent,programState) end
---* 
---@param parent cc.Technique
---@return self
function Pass:create (parent) end