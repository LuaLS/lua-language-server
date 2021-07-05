---@meta

---@class cc.MotionStreak :cc.Node@all parent class: Node,TextureProtocol
local MotionStreak={ }
cc.MotionStreak=MotionStreak




---*  Remove all living segments of the ribbon.
---@return self
function MotionStreak:reset () end
---* js NA<br>
---* lua NA
---@return cc.BlendFunc
function MotionStreak:getBlendFunc () end
---* js NA<br>
---* lua NA
---@param blendFunc cc.BlendFunc
---@return self
function MotionStreak:setBlendFunc (blendFunc) end
---*  Color used for the tint.<br>
---* param colors The color used for the tint.
---@param colors color3b_table
---@return self
function MotionStreak:tintWithColor (colors) end
---* 
---@return cc.Texture2D
function MotionStreak:getTexture () end
---*  Sets the starting position initialized or not.<br>
---* param bStartingPositionInitialized True if initialized the starting position.
---@param bStartingPositionInitialized boolean
---@return self
function MotionStreak:setStartingPositionInitialized (bStartingPositionInitialized) end
---* 
---@param texture cc.Texture2D
---@return self
function MotionStreak:setTexture (texture) end
---*  Is the starting position initialized or not.<br>
---* return True if the starting position is initialized.
---@return boolean
function MotionStreak:isStartingPositionInitialized () end
---*  When fast mode is enabled, new points are added faster but with lower precision. <br>
---* return True if fast mode is enabled.
---@return boolean
function MotionStreak:isFastMode () end
---*  Get stroke.<br>
---* return float stroke.
---@return float
function MotionStreak:getStroke () end
---@overload fun(float:float,float:float,float:float,color3b_table:color3b_table,string4:cc.Texture2D):self
---@overload fun(float:float,float:float,float:float,color3b_table:color3b_table,string:string):self
---@param fade float
---@param minSeg float
---@param stroke float
---@param color color3b_table
---@param path string
---@return boolean
function MotionStreak:initWithFade (fade,minSeg,stroke,color,path) end
---*  Sets fast mode or not.<br>
---* param bFastMode True if enabled fast mode.
---@param bFastMode boolean
---@return self
function MotionStreak:setFastMode (bFastMode) end
---*  Set stroke.<br>
---* param stroke The width of stroke.
---@param stroke float
---@return self
function MotionStreak:setStroke (stroke) end
---@overload fun(float:float,float:float,float:float,color3b_table:color3b_table,string4:cc.Texture2D):self
---@overload fun(float:float,float:float,float:float,color3b_table:color3b_table,string:string):self
---@param timeToFade float
---@param minSeg float
---@param strokeWidth float
---@param strokeColor color3b_table
---@param imagePath string
---@return self
function MotionStreak:create (timeToFade,minSeg,strokeWidth,strokeColor,imagePath) end
---* 
---@return boolean
function MotionStreak:isOpacityModifyRGB () end
---* 
---@param opacity unsigned_char
---@return self
function MotionStreak:setOpacity (opacity) end
---* 
---@param y float
---@return self
function MotionStreak:setPositionY (y) end
---* 
---@param x float
---@return self
function MotionStreak:setPositionX (x) end
---* 
---@return float
function MotionStreak:getPositionY () end
---* 
---@return float
function MotionStreak:getPositionX () end
---* 
---@return vec3_table
function MotionStreak:getPosition3D () end
---* 
---@param value boolean
---@return self
function MotionStreak:setOpacityModifyRGB (value) end
---* 
---@return unsigned_char
function MotionStreak:getOpacity () end
---@overload fun(float:float,float:float):self
---@overload fun(float0:vec2_table):self
---@param x float
---@param y float
---@return self
function MotionStreak:setPosition (x,y) end
---@overload fun(float:float,float:float):self
---@overload fun():self
---@param x float
---@param y float
---@return self
function MotionStreak:getPosition (x,y) end
---* 
---@return self
function MotionStreak:MotionStreak () end