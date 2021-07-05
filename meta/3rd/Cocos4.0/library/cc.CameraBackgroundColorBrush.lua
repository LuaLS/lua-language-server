---@meta

---@class cc.CameraBackgroundColorBrush :cc.CameraBackgroundDepthBrush
local CameraBackgroundColorBrush={ }
cc.CameraBackgroundColorBrush=CameraBackgroundColorBrush




---* Set clear color<br>
---* param color Color used to clear the color buffer
---@param color color4f_table
---@return self
function CameraBackgroundColorBrush:setColor (color) end
---* Create a color brush<br>
---* param color Color used to clear the color buffer<br>
---* param depth Depth used to clear the depth buffer<br>
---* return Created brush
---@param color color4f_table
---@param depth float
---@return self
function CameraBackgroundColorBrush:create (color,depth) end
---* Get brush type. Should be BrushType::COLOR<br>
---* return brush type
---@return int
function CameraBackgroundColorBrush:getBrushType () end
---* Draw background
---@param camera cc.Camera
---@return self
function CameraBackgroundColorBrush:drawBackground (camera) end
---* 
---@return boolean
function CameraBackgroundColorBrush:init () end
---* 
---@return self
function CameraBackgroundColorBrush:CameraBackgroundColorBrush () end