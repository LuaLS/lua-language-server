---@meta

---@class cc.MenuItemImage :cc.MenuItemSprite
local MenuItemImage={ }
cc.MenuItemImage=MenuItemImage




---*  Sets the sprite frame for the disabled image. 
---@param frame cc.SpriteFrame
---@return self
function MenuItemImage:setDisabledSpriteFrame (frame) end
---*  Sets the sprite frame for the selected image. 
---@param frame cc.SpriteFrame
---@return self
function MenuItemImage:setSelectedSpriteFrame (frame) end
---*  Sets the sprite frame for the normal image. 
---@param frame cc.SpriteFrame
---@return self
function MenuItemImage:setNormalSpriteFrame (frame) end
---* 
---@return boolean
function MenuItemImage:init () end
---*  Initializes a menu item with a normal, selected and disabled image with a callable object. 
---@param normalImage string
---@param selectedImage string
---@param disabledImage string
---@param callback function
---@return boolean
function MenuItemImage:initWithNormalImage (normalImage,selectedImage,disabledImage,callback) end
---* js ctor
---@return self
function MenuItemImage:MenuItemImage () end