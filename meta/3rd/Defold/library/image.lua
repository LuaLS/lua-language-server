---Image API documentation
---Functions for creating image objects.
---@class image
image = {}
---luminance image type
image.TYPE_LUMINANCE = nil
---RGB image type
image.TYPE_RGB = nil
---RGBA image type
image.TYPE_RGBA = nil
---Load image (PNG or JPEG) from buffer.
---@param buffer string # image data buffer
---@param premult boolean? # optional flag if alpha should be premultiplied. Defaults to false
---@return table # object or nil if loading fails. The object is a table with the following fields:
function image.load(buffer, premult) end




return image