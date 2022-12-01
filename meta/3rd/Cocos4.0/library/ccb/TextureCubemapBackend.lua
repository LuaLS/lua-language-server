---@meta

---@class ccb.TextureCubemapBackend :ccb.TextureBackend
local TextureCubemapBackend={ }
ccb.TextureCubemapBackend=TextureCubemapBackend




---* Update texutre cube data in give slice side.<br>
---* param side Specifies which slice texture of cube to be update.<br>
---* param data Specifies a pointer to the image data in memory.
---@param side int
---@param data void
---@return cc.backend.TextureCubemapBackend
function TextureCubemapBackend:updateFaceData (side,data) end