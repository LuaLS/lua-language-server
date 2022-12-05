---@meta

---@class cc.LayerGradient :cc.LayerColor
local LayerGradient={ }
cc.LayerGradient=LayerGradient




---*  Returns the start color of the gradient.<br>
---* return The start color.
---@return color3b_table
function LayerGradient:getStartColor () end
---*  Get the compressedInterpolation<br>
---* return The interpolation will be compressed if true.
---@return boolean
function LayerGradient:isCompressedInterpolation () end
---*  Returns the start opacity of the gradient.<br>
---* return The start opacity.
---@return unsigned_char
function LayerGradient:getStartOpacity () end
---*  Sets the directional vector that will be used for the gradient.<br>
---* The default value is vertical direction (0,-1). <br>
---* param alongVector The direction of gradient.
---@param alongVector vec2_table
---@return self
function LayerGradient:setVector (alongVector) end
---*  Returns the start opacity of the gradient.<br>
---* param startOpacity The start opacity, from 0 to 255.
---@param startOpacity unsigned_char
---@return self
function LayerGradient:setStartOpacity (startOpacity) end
---*  Whether or not the interpolation will be compressed in order to display all the colors of the gradient both in canonical and non canonical vectors.<br>
---* Default: true.<br>
---* param compressedInterpolation The interpolation will be compressed if true.
---@param compressedInterpolation boolean
---@return self
function LayerGradient:setCompressedInterpolation (compressedInterpolation) end
---*  Returns the end opacity of the gradient.<br>
---* param endOpacity The end opacity, from 0 to 255.
---@param endOpacity unsigned_char
---@return self
function LayerGradient:setEndOpacity (endOpacity) end
---*  Returns the directional vector used for the gradient.<br>
---* return The direction of gradient.
---@return vec2_table
function LayerGradient:getVector () end
---*  Sets the end color of the gradient.<br>
---* param endColor The end color.
---@param endColor color3b_table
---@return self
function LayerGradient:setEndColor (endColor) end
---@overload fun(color4b_table:color4b_table,color4b_table:color4b_table,vec2_table:vec2_table):self
---@overload fun(color4b_table:color4b_table,color4b_table:color4b_table):self
---@param start color4b_table
---@param _end color4b_table
---@param v vec2_table
---@return boolean
function LayerGradient:initWithColor (start,_end,v) end
---*  Returns the end color of the gradient.<br>
---* return The end color.
---@return color3b_table
function LayerGradient:getEndColor () end
---*  Returns the end opacity of the gradient.<br>
---* return The end opacity.
---@return unsigned_char
function LayerGradient:getEndOpacity () end
---*  Sets the start color of the gradient.<br>
---* param startColor The start color.
---@param startColor color3b_table
---@return self
function LayerGradient:setStartColor (startColor) end
---@overload fun(color4b_table:color4b_table,color4b_table:color4b_table):self
---@overload fun():self
---@overload fun(color4b_table:color4b_table,color4b_table:color4b_table,vec2_table:vec2_table):self
---@param start color4b_table
---@param _end color4b_table
---@param v vec2_table
---@return self
function LayerGradient:create (start,_end,v) end
---* 
---@return boolean
function LayerGradient:init () end
---* 
---@return string
function LayerGradient:getDescription () end
---* 
---@return self
function LayerGradient:LayerGradient () end