---@meta

---@class cc.Material :cc.Ref
local Material={ }
cc.Material=Material




---*  returns a clone (deep-copy) of the material 
---@return self
function Material:clone () end
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
function Material:draw (meshCommand,globalZOrder,vertexBuffer,indexBuffer,primitive,indexFormat,indexCount,modelView) end
---* 
---@return cc.RenderState
function Material:getRenderState () end
---* / sets the material name
---@param name string
---@return self
function Material:setName (name) end
---*  Returns a Technique by index. <br>
---* returns `nullptr` if the index is invalid.
---@param index int
---@return cc.Technique
function Material:getTechniqueByIndex (index) end
---* / returns the material name
---@return string
function Material:getName () end
---*  Returns the list of Techniques 
---@return array_table
function Material:getTechniques () end
---*  Returns the number of Techniques in the Material. 
---@return int
function Material:getTechniqueCount () end
---*  Sets the current technique 
---@param techniqueName string
---@return self
function Material:setTechnique (techniqueName) end
---*  Returns a Technique by its name.<br>
---* returns `nullptr` if the Technique can't be found.
---@param name string
---@return cc.Technique
function Material:getTechniqueByName (name) end
---*  Adds a Technique into the Material 
---@param technique cc.Technique
---@return self
function Material:addTechnique (technique) end
---*  Returns the Technique used by the Material 
---@return cc.Technique
function Material:getTechnique () end
---* Creates a Material using the data from the Properties object defined at the specified URL,<br>
---* where the URL is of the format "<file-path>.<extension>#<namespace-id>/<namespace-id>/.../<namespace-id>"<br>
---* (and "#<namespace-id>/<namespace-id>/.../<namespace-id>" is optional).<br>
---* param url The URL pointing to the Properties object defining the material.<br>
---* return A new Material or NULL if there was an error.
---@param path string
---@return self
function Material:createWithFilename (path) end
---* Creates a material from the specified properties object.<br>
---* param materialProperties The properties object defining the<br>
---* material (must have namespace equal to 'material').<br>
---* return A new Material.
---@param materialProperties cc.Properties
---@return self
function Material:createWithProperties (materialProperties) end
---*  Creates a Material with a GLProgramState.<br>
---* It will only contain one Technique and one Pass.<br>
---* Added in order to support legacy code.
---@param programState cc.backend.ProgramState
---@return self
function Material:createWithProgramState (programState) end