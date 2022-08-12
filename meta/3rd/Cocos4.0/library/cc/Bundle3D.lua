---@meta

---@class cc.Bundle3D 
local Bundle3D={ }
cc.Bundle3D=Bundle3D




---* load a file. You must load a file first, then call loadMeshData, loadSkinData, and so on<br>
---* param path File to be loaded<br>
---* return result of load
---@param path string
---@return boolean
function Bundle3D:load (path) end
---* load skin data from bundle<br>
---* param id The ID of the skin, load the first Skin in the bundle if it is empty
---@param id string
---@param skindata cc.SkinData
---@return boolean
function Bundle3D:loadSkinData (id,skindata) end
---* 
---@return self
function Bundle3D:clear () end
---* 
---@param materialdatas cc.MaterialDatas
---@return boolean
function Bundle3D:loadMaterials (materialdatas) end
---* 
---@param nodedatas cc.NodeDatas
---@return boolean
function Bundle3D:loadNodes (nodedatas) end
---* load material data from bundle<br>
---* param id The ID of the animation, load the first animation in the bundle if it is empty
---@param id string
---@param animationdata cc.Animation3DData
---@return boolean
function Bundle3D:loadAnimationData (id,animationdata) end
---* get define data type<br>
---* param str The type in string
---@param str string
---@return int
function Bundle3D:parseSamplerAddressMode (str) end
---* 
---@param bundle cc.Bundle3D
---@return self
function Bundle3D:destroyBundle (bundle) end
---* create a new bundle, destroy it when finish using it
---@return self
function Bundle3D:createBundle () end
---* get define data type<br>
---* param str The type in string
---@param str string
---@param size int
---@return int
function Bundle3D:parseGLDataType (str,size) end
---* 
---@return self
function Bundle3D:Bundle3D () end