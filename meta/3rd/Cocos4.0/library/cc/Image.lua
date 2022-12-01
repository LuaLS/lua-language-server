---@meta

---@class cc.Image :cc.Ref
local Image={ }
cc.Image=Image




---* 
---@return boolean
function Image:hasPremultipliedAlpha () end
---* 
---@return self
function Image:reversePremultipliedAlpha () end
---* 
---@return boolean
function Image:isCompressed () end
---* 
---@return boolean
function Image:hasAlpha () end
---* 
---@return int
function Image:getPixelFormat () end
---* 
---@return int
function Image:getHeight () end
---* 
---@return self
function Image:premultiplyAlpha () end
---* brief Load the image from the specified path.<br>
---* param path   the absolute file path.<br>
---* return true if loaded correctly.
---@param path string
---@return boolean
function Image:initWithImageFile (path) end
---* 
---@return int
function Image:getWidth () end
---* 
---@return int
function Image:getBitPerPixel () end
---* 
---@return int
function Image:getFileType () end
---* 
---@return string
function Image:getFilePath () end
---* 
---@return int
function Image:getNumberOfMipmaps () end
---* brief    Save Image data to the specified file, with specified format.<br>
---* param    filePath        the file's absolute path, including file suffix.<br>
---* param    isToRGB        whether the image is saved as RGB format.
---@param filename string
---@param isToRGB boolean
---@return boolean
function Image:saveToFile (filename,isToRGB) end
---*  treats (or not) PVR files as if they have alpha premultiplied.<br>
---* Since it is impossible to know at runtime if the PVR images have the alpha channel premultiplied, it is<br>
---* possible load them as if they have (or not) the alpha channel premultiplied.<br>
---* By default it is disabled.
---@param haveAlphaPremultiplied boolean
---@return self
function Image:setPVRImagesHavePremultipliedAlpha (haveAlphaPremultiplied) end
---* Enables or disables premultiplied alpha for PNG files.<br>
---* param enabled (default: true)
---@param enabled boolean
---@return self
function Image:setPNGPremultipliedAlphaEnabled (enabled) end
---* js ctor
---@return self
function Image:Image () end