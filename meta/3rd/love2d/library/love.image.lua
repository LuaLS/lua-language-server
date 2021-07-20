---@meta

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
---@return love.CompressedImageData compressedImageData # The new CompressedImageData object.
function love.image.newCompressedData(filename) end

---
---Creates a new ImageData object.
---
---@param width number # The width of the ImageData.
---@param height number # The height of the ImageData.
---@return love.ImageData imageData # The new blank ImageData object. Each pixel's color values, (including the alpha values!) will be set to zero.
function love.image.newImageData(width, height) end

---@class love.CompressedImageData: love.Data, love.Object
local CompressedImageData = {}

---
---Gets the width and height of the CompressedImageData.
---
---@return number width # The width of the CompressedImageData.
---@return number height # The height of the CompressedImageData.
function CompressedImageData:getDimensions() end

---
---Gets the format of the CompressedImageData.
---
---@return love.CompressedImageFormat format # The format of the CompressedImageData.
function CompressedImageData:getFormat() end

---
---Gets the height of the CompressedImageData.
---
---@return number height # The height of the CompressedImageData.
function CompressedImageData:getHeight() end

---
---Gets the number of mipmap levels in the CompressedImageData. The base mipmap level (original image) is included in the count.
---
---@return number mipmaps # The number of mipmap levels stored in the CompressedImageData.
function CompressedImageData:getMipmapCount() end

---
---Gets the width of the CompressedImageData.
---
---@return number width # The width of the CompressedImageData.
function CompressedImageData:getWidth() end

---@class love.ImageData: love.Data, love.Object
local ImageData = {}

---
---Encodes the ImageData and optionally writes it to the save directory.
---
---@param format love.ImageFormat # The format to encode the image as.
---@param filename string # The filename to write the file to. If nil, no file will be written but the FileData will still be returned.
---@return love.FileData filedata # The encoded image as a new FileData object.
function ImageData:encode(format, filename) end

---
---Gets the width and height of the ImageData in pixels.
---
---@return number width # The width of the ImageData in pixels.
---@return number height # The height of the ImageData in pixels.
function ImageData:getDimensions() end

---
---Gets the height of the ImageData in pixels.
---
---@return number height # The height of the ImageData in pixels.
function ImageData:getHeight() end

---
---Gets the color of a pixel at a specific position in the image.
---
---Valid x and y values start at 0 and go up to image width and height minus 1. Non-integer values are floored.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
function ImageData:getPixel() end

---
---Gets the width of the ImageData in pixels.
---
---@return number width # The width of the ImageData in pixels.
function ImageData:getWidth() end

---
---Transform an image by applying a function to every pixel.
---
---This function is a higher-order function. It takes another function as a parameter, and calls it once for each pixel in the ImageData.
---
---The passed function is called with six parameters for each pixel in turn. The parameters are numbers that represent the x and y coordinates of the pixel and its red, green, blue and alpha values. The function should return the new red, green, blue, and alpha values for that pixel.
---
---function pixelFunction(x, y, r, g, b, a)
---
---    -- template for defining your own pixel mapping function
---
---    -- perform computations giving the new values for r, g, b and a
---
---    -- ...
---
---    return r, g, b, a
---
---end
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---@param pixelFunction function # Function to apply to every pixel.
---@param width number # The width of the area within the ImageData to apply the function to.
---@param height number # The height of the area within the ImageData to apply the function to.
function ImageData:mapPixel(pixelFunction, width, height) end

---
---Paste into ImageData from another source ImageData.
---
---@param source love.ImageData # Source ImageData from which to copy.
---@param dx number # Destination top-left position on x-axis.
---@param dy number # Destination top-left position on y-axis.
---@param sx number # Source top-left position on x-axis.
---@param sy number # Source top-left position on y-axis.
---@param sw number # Source width.
---@param sh number # Source height.
function ImageData:paste(source, dx, dy, sx, sy, sw, sh) end

---
---Sets the color of a pixel at a specific position in the image.
---
---Valid x and y values start at 0 and go up to image width and height minus 1.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
function ImageData:setPixel() end
