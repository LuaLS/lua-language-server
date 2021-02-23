---@meta

---@class ccui.RichElement :cc.Ref
local RichElement={ }
ccui.RichElement=RichElement




---* 
---@param type int
---@return boolean
function RichElement:equalType (type) end
---* brief Initialize a rich element with different arguments.<br>
---* param tag A integer tag value.<br>
---* param color A color in @see `Color3B`.<br>
---* param opacity A opacity value in `GLubyte`.<br>
---* return True if initialize success, false otherwise.
---@param tag int
---@param color color3b_table
---@param opacity unsigned_char
---@return boolean
function RichElement:init (tag,color,opacity) end
---* 
---@param color color3b_table
---@return self
function RichElement:setColor (color) end
---* brief Default constructor.<br>
---* js ctor<br>
---* lua new
---@return self
function RichElement:RichElement () end