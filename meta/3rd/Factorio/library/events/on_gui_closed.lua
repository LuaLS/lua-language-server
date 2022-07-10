---@meta

---Called when the player closes the GUI they have open.
---
---This can only be raised when the GUI's player controller is still valid. If a GUI is thus closed due to the player disconnecting, dying, or becoming a spectator in other ways, it won't cause this event to be raised.
---
---It's not advised to open any other GUI during this event because if this is run as a request to open a different GUI the game will force close the new opened GUI without notice to ensure the original requested GUI is opened.
---@class on_gui_closed
---@field element? LuaGuiElement @The custom GUI element that was open
---@field entity? LuaEntity @The entity that was open
---@field equipment? LuaEquipment @The equipment that was open
---@field gui_type defines.gui_type @The GUI type that was open.
---@field item? LuaItemStack @The item that was open
---@field name defines.events @Identifier of the event
---@field other_player? LuaPlayer @The other player that was open
---@field player_index uint @The player.
---@field technology? LuaTechnology @The technology that was automatically selected when opening the research GUI
---@field tick uint @Tick the event was generated.
---@field tile_position? TilePosition @The tile position that was open
local on_gui_closed = {}

