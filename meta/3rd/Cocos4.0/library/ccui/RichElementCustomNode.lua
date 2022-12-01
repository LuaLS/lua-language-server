---@meta

---@class ccui.RichElementCustomNode :ccui.RichElement
local RichElementCustomNode={ }
ccui.RichElementCustomNode=RichElementCustomNode




---* brief Initialize a RichElementCustomNode with various arguments.<br>
---* param tag A integer tag value.<br>
---* param color A color in Color3B.<br>
---* param opacity A opacity in GLubyte.<br>
---* param customNode A custom node pointer.<br>
---* return True if initialize success, false otherwise.
---@param tag int
---@param color color3b_table
---@param opacity unsigned_char
---@param customNode cc.Node
---@return boolean
function RichElementCustomNode:init (tag,color,opacity,customNode) end
---* brief Create a RichElementCustomNode with various arguments.<br>
---* param tag A integer tag value.<br>
---* param color A color in Color3B.<br>
---* param opacity A opacity in GLubyte.<br>
---* param customNode A custom node pointer.<br>
---* return A RichElementCustomNode instance.
---@param tag int
---@param color color3b_table
---@param opacity unsigned_char
---@param customNode cc.Node
---@return self
function RichElementCustomNode:create (tag,color,opacity,customNode) end
---* brief Default constructor.<br>
---* js ctor<br>
---* lua new
---@return self
function RichElementCustomNode:RichElementCustomNode () end