---@meta

---@class ccb.TextureBackend :cc.Ref
local TextureBackend={ }
ccb.TextureBackend=TextureBackend




---* Get texture format.<br>
---* return Texture format.
---@return int
function TextureBackend:getTextureFormat () end
---* Get texture type. Symbolic constant value can be either TEXTURE_2D or TEXTURE_CUBE.<br>
---* return Texture type.
---@return int
function TextureBackend:getTextureType () end
---* Update sampler<br>
---* param sampler Specifies the sampler descriptor.
---@param sampler cc.backend.SamplerDescriptor
---@return cc.backend.TextureBackend
function TextureBackend:updateSamplerDescriptor (sampler) end
---* Update texture description.<br>
---* param descriptor Specifies texture and sampler descriptor.
---@param descriptor cc.backend.TextureDescriptor
---@return cc.backend.TextureBackend
function TextureBackend:updateTextureDescriptor (descriptor) end
---* Get texture usage. Symbolic constant can be READ, WRITE or RENDER_TARGET.<br>
---* return Texture usage.
---@return int
function TextureBackend:getTextureUsage () end
---* Check if mipmap had generated before.<br>
---* return true if the mipmap has always generated before, otherwise false.
---@return boolean
function TextureBackend:hasMipmaps () end
---* / Generate mipmaps.
---@return cc.backend.TextureBackend
function TextureBackend:generateMipmaps () end
---* Read a block of pixels from the drawable texture<br>
---* param x,y Specify the window coordinates of the first pixel that is read from the drawable texture. This location is the lower left corner of a rectangular block of pixels.<br>
---* param width,height Specify the dimensions of the pixel rectangle. width and height of one correspond to a single pixel.<br>
---* param flipImage Specifies if needs to flip the image.<br>
---* param callback Specifies a call back function to deal with the image.
---@param x unsigned_int
---@param y unsigned_int
---@param width unsigned_int
---@param height unsigned_int
---@param flipImage boolean
---@param callback function
---@return cc.backend.TextureBackend
function TextureBackend:getBytes (x,y,width,height,flipImage,callback) end