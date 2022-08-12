---@meta

---@class ccs.Skin :cc.Sprite
local Skin={ }
ccs.Skin=Skin




---* 
---@return ccs.Bone
function Skin:getBone () end
---* 
---@return mat4_table
function Skin:getNodeToWorldTransformAR () end
---* 
---@return string
function Skin:getDisplayName () end
---* 
---@return self
function Skin:updateArmatureTransform () end
---* 
---@param bone ccs.Bone
---@return self
function Skin:setBone (bone) end
---@overload fun(string:string):self
---@overload fun():self
---@param pszFileName string
---@return self
function Skin:create (pszFileName) end
---* 
---@param pszSpriteFrameName string
---@return self
function Skin:createWithSpriteFrameName (pszSpriteFrameName) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function Skin:draw (renderer,transform,flags) end
---* 
---@return mat4_table
function Skin:getNodeToWorldTransform () end
---* 
---@param spriteFrameName string
---@return boolean
function Skin:initWithSpriteFrameName (spriteFrameName) end
---* 
---@param filename string
---@return boolean
function Skin:initWithFile (filename) end
---* 
---@return self
function Skin:updateTransform () end
---* js ctor
---@return self
function Skin:Skin () end