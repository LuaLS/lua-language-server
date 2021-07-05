---@meta

---@class ccs.TextureFrame :ccs.Frame
local TextureFrame={ }
ccs.TextureFrame=TextureFrame




---* 
---@return string
function TextureFrame:getTextureName () end
---* 
---@param textureName string
---@return self
function TextureFrame:setTextureName (textureName) end
---* 
---@return self
function TextureFrame:create () end
---* 
---@return ccs.Frame
function TextureFrame:clone () end
---* 
---@param node cc.Node
---@return self
function TextureFrame:setNode (node) end
---* 
---@return self
function TextureFrame:TextureFrame () end