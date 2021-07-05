---@meta

---@class cc.LayerRadialGradient :cc.Layer
local LayerRadialGradient={ }
cc.LayerRadialGradient=LayerRadialGradient




---* 
---@return color4b_table
function LayerRadialGradient:getStartColor () end
---* 
---@return cc.BlendFunc
function LayerRadialGradient:getBlendFunc () end
---* 
---@return color3b_table
function LayerRadialGradient:getStartColor3B () end
---* 
---@return unsigned_char
function LayerRadialGradient:getStartOpacity () end
---* 
---@param center vec2_table
---@return self
function LayerRadialGradient:setCenter (center) end
---* 
---@return color4b_table
function LayerRadialGradient:getEndColor () end
---* 
---@param opacity unsigned_char
---@return self
function LayerRadialGradient:setStartOpacity (opacity) end
---* 
---@return vec2_table
function LayerRadialGradient:getCenter () end
---* 
---@param opacity unsigned_char
---@return self
function LayerRadialGradient:setEndOpacity (opacity) end
---* 
---@param expand float
---@return self
function LayerRadialGradient:setExpand (expand) end
---* 
---@return unsigned_char
function LayerRadialGradient:getEndOpacity () end
---* 
---@param startColor color4b_table
---@param endColor color4b_table
---@param radius float
---@param center vec2_table
---@param expand float
---@return boolean
function LayerRadialGradient:initWithColor (startColor,endColor,radius,center,expand) end
---@overload fun(color3b_table0:color4b_table):self
---@overload fun(color3b_table:color3b_table):self
---@param color color3b_table
---@return self
function LayerRadialGradient:setEndColor (color) end
---* 
---@return color3b_table
function LayerRadialGradient:getEndColor3B () end
---* 
---@param radius float
---@return self
function LayerRadialGradient:setRadius (radius) end
---@overload fun(color3b_table0:color4b_table):self
---@overload fun(color3b_table:color3b_table):self
---@param color color3b_table
---@return self
function LayerRadialGradient:setStartColor (color) end
---* 
---@return float
function LayerRadialGradient:getExpand () end
---* 
---@param blendFunc cc.BlendFunc
---@return self
function LayerRadialGradient:setBlendFunc (blendFunc) end
---* 
---@return float
function LayerRadialGradient:getRadius () end
---@overload fun():self
---@overload fun(color4b_table:color4b_table,color4b_table:color4b_table,float:float,vec2_table:vec2_table,float:float):self
---@param startColor color4b_table
---@param endColor color4b_table
---@param radius float
---@param center vec2_table
---@param expand float
---@return self
function LayerRadialGradient:create (startColor,endColor,radius,center,expand) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function LayerRadialGradient:draw (renderer,transform,flags) end
---* 
---@param size size_table
---@return self
function LayerRadialGradient:setContentSize (size) end
---* 
---@return self
function LayerRadialGradient:LayerRadialGradient () end