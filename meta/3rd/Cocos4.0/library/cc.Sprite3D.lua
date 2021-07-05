---@meta

---@class cc.Sprite3D :cc.Node@all parent class: Node,BlendProtocol
local Sprite3D={ }
cc.Sprite3D=Sprite3D




---* 
---@param enable boolean
---@return self
function Sprite3D:setCullFaceEnabled (enable) end
---@overload fun(string0:cc.Texture2D):self
---@overload fun(string:string):self
---@param texFile string
---@return self
function Sprite3D:setTexture (texFile) end
---* 
---@return unsigned_int
function Sprite3D:getLightMask () end
---*  Adds a new material to a particular mesh of the sprite.<br>
---* meshIndex is the mesh that will be applied to.<br>
---* if meshIndex == -1, then it will be applied to all the meshes that belong to the sprite.
---@param meshIndex int
---@return cc.Material
function Sprite3D:getMaterial (meshIndex) end
---* 
---@param side int
---@return self
function Sprite3D:setCullFace (side) end
---* Get meshes used in sprite 3d
---@return array_table
function Sprite3D:getMeshes () end
---* remove all attach nodes
---@return self
function Sprite3D:removeAllAttachNode () end
---@overload fun(cc.Material:cc.Material,int:int):self
---@overload fun(cc.Material:cc.Material):self
---@param material cc.Material
---@param meshIndex int
---@return self
function Sprite3D:setMaterial (material,meshIndex) end
---* get mesh
---@return cc.Mesh
function Sprite3D:getMesh () end
---*  get mesh count 
---@return int
function Sprite3D:getMeshCount () end
---* get Mesh by index
---@param index int
---@return cc.Mesh
function Sprite3D:getMeshByIndex (index) end
---* 
---@return boolean
function Sprite3D:isForceDepthWrite () end
---* 
---@return cc.BlendFunc
function Sprite3D:getBlendFunc () end
---*  light mask getter & setter, light works only when _lightmask & light's flag is true, default value of _lightmask is 0xffff 
---@param mask unsigned_int
---@return self
function Sprite3D:setLightMask (mask) end
---* get AttachNode by bone name, return nullptr if not exist
---@param boneName string
---@return cc.AttachNode
function Sprite3D:getAttachNode (boneName) end
---* 
---@param blendFunc cc.BlendFunc
---@return self
function Sprite3D:setBlendFunc (blendFunc) end
---* force set this Sprite3D to 2D render queue
---@param force2D boolean
---@return self
function Sprite3D:setForce2DQueue (force2D) end
---* generate default material
---@return self
function Sprite3D:genMaterial () end
---* remove attach node
---@param boneName string
---@return self
function Sprite3D:removeAttachNode (boneName) end
---* 
---@return cc.Skeleton3D
function Sprite3D:getSkeleton () end
---* Force to write to depth buffer, this is useful if you want to achieve effects like fading.
---@param value boolean
---@return self
function Sprite3D:setForceDepthWrite (value) end
---* get Mesh by Name, it returns the first one if there are more than one mesh with the same name 
---@param name string
---@return cc.Mesh
function Sprite3D:getMeshByName (name) end
---@overload fun(string:string):self
---@overload fun():self
---@overload fun(string:string,string:string):self
---@param modelPath string
---@param texturePath string
---@return self
function Sprite3D:create (modelPath,texturePath) end
---* draw
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function Sprite3D:draw (renderer,transform,flags) end
---* Executes an action, and returns the action that is executed. For Sprite3D special logic are needed to take care of Fading.<br>
---* This node becomes the action's target. Refer to Action::getTarget()<br>
---* warning Actions don't retain their target.<br>
---* return An Action pointer
---@param action cc.Action
---@return cc.Action
function Sprite3D:runAction (action) end
---*  set ProgramState, you should bind attributes by yourself 
---@param programState cc.backend.ProgramState
---@return self
function Sprite3D:setProgramState (programState) end
---* Returns 2d bounding-box<br>
---* Note: the bounding-box is just get from the AABB which as Z=0, so that is not very accurate.
---@return rect_table
function Sprite3D:getBoundingBox () end