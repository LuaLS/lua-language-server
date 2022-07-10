---@meta

---The root of the GUI. This type houses the root elements, `top`, `left`, `center`, `goal`, and `screen`, to which other elements can be added to be displayed on screen.
---
---Every player can have a different GUI state.
---@class LuaGui
---@field center LuaGuiElement @The center part of the GUI. It is a flow element.`[R]`
---@field children table<string, LuaGuiElement> @The children GUI elements mapped by name <> element.`[R]`
---@field goal LuaGuiElement @The flow used in the objectives window. It is a flow element. The objectives window is only visible when the flow is not empty or the objective text is set.`[R]`
---@field left LuaGuiElement @The left part of the GUI. It is a flow element inside a scroll pane element.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field player LuaPlayer @The player who owns this gui.`[R]`
---@field relative LuaGuiElement @For showing a GUI somewhere relative to one of the game GUIs. It is an empty-widget element.`[R]`
---@field screen LuaGuiElement @For showing a GUI somewhere on the entire screen. It is an empty-widget element.`[R]`
---@field top LuaGuiElement @The top part of the GUI. It is a flow element inside a scroll pane element.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaGui = {}

---All methods and properties that this object supports.
---@return string
function LuaGui.help() end

---Returns `true` if sprite_path is valid and contains loaded sprite, otherwise `false`. Sprite path of type `file` doesn't validate if file exists.
---
---If you want to avoid needing a LuaGui object, [LuaGameScript::is_valid_sprite_path](LuaGameScript::is_valid_sprite_path) can be used instead.
---@param _sprite_path SpritePath @Path to a image.
---@return boolean
function LuaGui.is_valid_sprite_path(_sprite_path) end

