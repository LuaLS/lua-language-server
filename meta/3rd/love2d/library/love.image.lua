---@class love.image
love.image = {}

---
---Determines whether a file can be loaded as CompressedImageData.
---
---@param filename string # The filename of the potentially compressed image file.
---@return boolean compressed # Whether the file can be loaded as CompressedImageData or not.
function love.image.isCompressed(filename) end

---
---Create a new CompressedImageData object from a compressed image file. LÖVE supports several compressed texture formats, enumerated in the CompressedImageFormat page.
---
---@param filename string # The filename of the compressed image file.
---@return CompressedImageData compressedImageData # The new CompressedImageData object.
function love.image.newCompressedData(filename) end

---
---Creates a new ImageData object.
---
---@param width number # The width of the ImageData.
---@param height number # The height of the ImageData.
---@return ImageData imageData # The new blank ImageData object. Each pixel's color values, (including the alpha values!) will be set to zero.
function love.image.newImageData(width, height) end
