---@meta

---@class ccb.Texture2DBackend :ccb.TextureBackend
local Texture2DBackend={ }
ccb.Texture2DBackend=Texture2DBackend




---* Get texture height.<br>
---* return Texture height.
---@return unsigned_int
function Texture2DBackend:getHeight () end
---* Get texture width.<br>
---* return Texture width.
---@return unsigned_int
function Texture2DBackend:getWidth () end
---* Update a two-dimensional texture image<br>
---* param data Specifies a pointer to the image data in memory.<br>
---* param width Specifies the width of the texture image.<br>
---* param height Specifies the height of the texture image.<br>
---* param level Specifies the level-of-detail number. Level 0 is the base image level. Level n is the nth mipmap reduction image.
---@param data unsigned_char
---@param width unsigned_int
---@param height unsigned_int
---@param level unsigned_int
---@return cc.backend.Texture2DBackend
function Texture2DBackend:updateData (data,width,height,level) end
---* Update a two-dimensional texture image in a compressed format<br>
---* param data Specifies a pointer to the compressed image data in memory.<br>
---* param width Specifies the width of the texture image.<br>
---* param height Specifies the height of the texture image.<br>
---* param dataLen Specifies the totoal size of compressed image in bytes.<br>
---* param level Specifies the level-of-detail number. Level 0 is the base image level. Level n is the nth mipmap reduction image.
---@param data unsigned_char
---@param width unsigned_int
---@param height unsigned_int
---@param dataLen unsigned_int
---@param level unsigned_int
---@return cc.backend.Texture2DBackend
function Texture2DBackend:updateCompressedData (data,width,height,dataLen,level) end
---* Update a two-dimensional texture subimage<br>
---* param xoffset Specifies a texel offset in the x direction within the texture array.<br>
---* param yoffset Specifies a texel offset in the y direction within the texture array.<br>
---* param width Specifies the width of the texture subimage.<br>
---* param height Specifies the height of the texture subimage.<br>
---* param level Specifies the level-of-detail number. Level 0 is the base image level. Level n is the nth mipmap reduction image.<br>
---* param data Specifies a pointer to the image data in memory.
---@param xoffset unsigned_int
---@param yoffset unsigned_int
---@param width unsigned_int
---@param height unsigned_int
---@param level unsigned_int
---@param data unsigned_char
---@return cc.backend.Texture2DBackend
function Texture2DBackend:updateSubData (xoffset,yoffset,width,height,level,data) end
---* Update a two-dimensional texture subimage in a compressed format<br>
---* param xoffset Specifies a texel offset in the x direction within the texture array.<br>
---* param yoffset Specifies a texel offset in the y direction within the texture array.<br>
---* param width Specifies the width of the texture subimage.<br>
---* param height Specifies the height of the texture subimage.<br>
---* param dataLen Specifies the totoal size of compressed subimage in bytes.<br>
---* param level Specifies the level-of-detail number. Level 0 is the base image level. Level n is the nth mipmap reduction image.<br>
---* param data Specifies a pointer to the compressed image data in memory.
---@param xoffset unsigned_int
---@param yoffset unsigned_int
---@param width unsigned_int
---@param height unsigned_int
---@param dataLen unsigned_int
---@param level unsigned_int
---@param data unsigned_char
---@return cc.backend.Texture2DBackend
function Texture2DBackend:updateCompressedSubData (xoffset,yoffset,width,height,dataLen,level,data) end