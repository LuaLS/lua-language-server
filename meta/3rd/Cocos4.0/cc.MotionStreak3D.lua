---@meta

---@class cc.MotionStreak3D :cc.Node@all parent class: Node,TextureProtocol
local MotionStreak3D={ }
cc.MotionStreak3D=MotionStreak3D




---*  Remove all living segments of the ribbon.
---@return self
function MotionStreak3D:reset () end
---* 
---@param texture cc.Texture2D
---@return self
function MotionStreak3D:setTexture (texture) end
---* 
---@return cc.Texture2D
function MotionStreak3D:getTexture () end
---*  Color used for the tint.<br>
---* param colors The color used for the tint.
---@param colors color3b_table
---@return self
function MotionStreak3D:tintWithColor (colors) end
---* Get the direction of sweeping line segment
---@return vec3_table
function MotionStreak3D:getSweepAxis () end
---* js NA<br>
---* lua NA
---@param blendFunc cc.BlendFunc
---@return self
function MotionStreak3D:setBlendFunc (blendFunc) end
---*  Sets the starting position initialized or not.<br>
---* param bStartingPositionInitialized True if initialized the starting position.
---@param bStartingPositionInitialized boolean
---@return self
function MotionStreak3D:setStartingPositionInitialized (bStartingPositionInitialized) end
---* js NA<br>
---* lua NA
---@return cc.BlendFunc
function MotionStreak3D:getBlendFunc () end
---*  Is the starting position initialized or not.<br>
---* return True if the starting position is initialized.
---@return boolean
function MotionStreak3D:isStartingPositionInitialized () end
---*  Get stroke.<br>
---* return float stroke.
---@return float
function MotionStreak3D:getStroke () end
---@overload fun(float:float,float:float,float:float,color3b_table:color3b_table,string4:cc.Texture2D):self
---@overload fun(float:float,float:float,float:float,color3b_table:color3b_table,string:string):self
---@param fade float
---@param minSeg float
---@param stroke float
---@param color color3b_table
---@param path string
---@return boolean
function MotionStreak3D:initWithFade (fade,minSeg,stroke,color,path) end
---* Set the direction of sweeping line segment.<br>
---* param sweepAxis Direction of sweeping line segment
---@param sweepAxis vec3_table
---@return self
function MotionStreak3D:setSweepAxis (sweepAxis) end
---*  Set stroke.<br>
---* param stroke The width of stroke.
---@param stroke float
---@return self
function MotionStreak3D:setStroke (stroke) end
---@overload fun(float:float,float:float,float:float,color3b_table:color3b_table,string4:cc.Texture2D):self
---@overload fun(float:float,float:float,float:float,color3b_table:color3b_table,string:string):self
---@param fade float
---@param minSeg float
---@param stroke float
---@param color color3b_table
---@param path string
---@return self
function MotionStreak3D:create (fade,minSeg,stroke,color,path) end
---* js NA<br>
---* lua NA
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function MotionStreak3D:draw (renderer,transform,flags) end
---* 
---@param value boolean
---@return self
function MotionStreak3D:setOpacityModifyRGB (value) end
---* 
---@param y float
---@return self
function MotionStreak3D:setPositionY (y) end
---* 
---@param rotation vec3_table
---@return self
function MotionStreak3D:setRotation3D (rotation) end
---* 
---@param x float
---@return self
function MotionStreak3D:setPositionX (x) end
---* 
---@param position vec3_table
---@return self
function MotionStreak3D:setPosition3D (position) end
---* 
---@return float
function MotionStreak3D:getPositionY () end
---* 
---@return float
function MotionStreak3D:getPositionX () end
---* 
---@return vec3_table
function MotionStreak3D:getPosition3D () end
---* 
---@param opacity unsigned_char
---@return self
function MotionStreak3D:setOpacity (opacity) end
---* lua NA
---@param delta float
---@return self
function MotionStreak3D:update (delta) end
---* 
---@param quat cc.Quaternion
---@return self
function MotionStreak3D:setRotationQuat (quat) end
---* 
---@return unsigned_char
function MotionStreak3D:getOpacity () end
---@overload fun(float:float,float:float):self
---@overload fun(float0:vec2_table):self
---@param x float
---@param y float
---@return self
function MotionStreak3D:setPosition (x,y) end
---@overload fun(float:float,float:float):self
---@overload fun():self
---@param x float
---@param y float
---@return self
function MotionStreak3D:getPosition (x,y) end
---* 
---@return boolean
function MotionStreak3D:isOpacityModifyRGB () end
---* 
---@return self
function MotionStreak3D:MotionStreak3D () end