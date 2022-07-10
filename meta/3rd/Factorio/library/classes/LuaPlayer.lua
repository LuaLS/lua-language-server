---@meta

---A player in the game. Pay attention that a player may or may not have a character, which is the [LuaEntity](LuaEntity) of the little guy running around the world doing things.
---@class LuaPlayer:LuaControl
---`true` if the player is an admin.`[RW]`
---
---Trying to change player admin status from the console when you aren't an admin does nothing.
---@field admin boolean
---@field afk_time uint @How many ticks since the last action of this player`[R]`
---@field auto_sort_main_inventory boolean @If the main inventory will be auto sorted.`[R]`
---@field blueprint_to_setup LuaItemStack @The item stack containing a blueprint to be setup.`[R]`
---The character attached to this player, or `nil` if no character.`[RW]`
---
---Will also return `nil` when the player is disconnected (see [LuaPlayer::connected](LuaPlayer::connected)).
---@field character LuaEntity
---@field chat_color Color @The color used when this player talks in game.`[RW]`
---@field color Color @The color associated with the player. This will be used to tint the player's character as well as their buildings and vehicles.`[RW]`
---@field connected boolean @`true` if the player is currently connected to the game.`[R]`
---@field controller_type defines.controllers @`[R]`
---When in a cutscene; the character this player would be using once the cutscene is over.`[R]`
---
---Will also return `nil` when the player is disconnected (see [LuaPlayer::connected](LuaPlayer::connected)).
---@field cutscene_character LuaEntity
---The display resolution for this player.`[R]`
---
---During [on_player_created](on_player_created), this attribute will always return a resolution of `{width=1920, height=1080}`. To get the actual resolution, listen to the [on_player_display_resolution_changed](on_player_display_resolution_changed) event raised shortly afterwards.
---@field display_resolution DisplayResolution
---The display scale for this player.`[R]`
---
---During [on_player_created](on_player_created), this attribute will always return a scale of `1`. To get the actual scale, listen to the [on_player_display_scale_changed](on_player_display_scale_changed) event raised shortly afterwards.
---@field display_scale double
---The source entity used during entity settings copy-paste if any.
---
---`nil` if there isn't currently a source entity.`[R]`
---@field entity_copy_source LuaEntity
---@field game_view_settings GameViewSettings @The player's game view settings.`[RW]`
---@field gui LuaGui @`[R]`
---@field hand_location ItemStackLocation @The original location of the item in the cursor, marked with a hand. When writing, the specified inventory slot must be empty and the cursor stack must not be empty.`[RW]`
---@field index uint @This player's unique index in [LuaGameScript::players](LuaGameScript::players). It is given to them when they are [created](on_player_created) and remains assigned to them until they are [removed](on_player_removed).`[R]`
---@field infinity_inventory_filters InfinityInventoryFilter[] @The filters for this map editor infinity inventory settings.`[RW]`
---@field last_online uint @At what tick this player was last online.`[R]`
---@field map_view_settings MapViewSettings @The player's map view settings. To write to this, use a table containing the fields that should be changed.`[W]`
---@field minimap_enabled boolean @`true` if the minimap is visible.`[RW]`
---Gets the current per-player settings for the this player, indexed by prototype name. Returns the same structure as [LuaSettings::get_player_settings](LuaSettings::get_player_settings).`[R]`
---
---This table will become invalid if its associated player does.
---@field mod_settings table<string, ModSetting>
---@field name string @The player's username.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field online_time uint @How many ticks did this player spend playing this save (all sessions combined)`[R]`
---@field opened_self boolean @`true` if the player opened itself. I.e. if they opened the character or god-controller GUI.`[R]`
---@field permission_group LuaPermissionGroup @The permission group this player is part of or `nil` if not part of any group.`[RW]`
---@field remove_unfiltered_items boolean @If items not included in this map editor infinity inventory filters should be removed.`[RW]`
---@field render_mode defines.render_mode @The render mode of the player, like map or zoom to world. The render mode can be set using [LuaPlayer::open_map](LuaPlayer::open_map), [LuaPlayer::zoom_to_world](LuaPlayer::zoom_to_world) and [LuaPlayer::close_map](LuaPlayer::close_map).`[R]`
---@field show_on_map boolean @If `true`, circle and name of given player is rendered on the map/chart.`[RW]`
---@field spectator boolean @If `true`, zoom-to-world noise effect will be disabled and environmental sounds will be based on zoom-to-world view instead of position of player's character.`[RW]`
---The stashed controller type or `nil` if no controller is stashed.`[R]`
---
---This is mainly useful when a player is in the map editor.
---@field stashed_controller_type defines.controllers
---@field tag string @The tag that is shown after the player in chat and on the map.`[RW]`
---The number of ticks until this player will respawn or `nil` if not waiting to respawn.`[RW]`
---
---Set to `nil` to immediately respawn the player.
---\
---Set to any positive value to trigger the respawn state for this player.
---@field ticks_to_respawn uint
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field zoom double @The player's zoom-level.`[W]`
local LuaPlayer = {}

---Gets a copy of the currently selected blueprint in the clipboard queue into the player's cursor, as if the player activated Paste.
function LuaPlayer.activate_paste() end

---Adds an alert to this player for the given entity of the given alert type.
---@param _entity LuaEntity
---@param _type defines.alert_type
function LuaPlayer.add_alert(_entity, _type) end

---Adds a custom alert to this player.
---@param _entity LuaEntity @If the alert is clicked, the map will open at the position of this entity.
---@param _icon SignalID
---@param _message LocalisedString
---@param _show_on_map boolean
function LuaPlayer.add_custom_alert(_entity, _icon, _message, _show_on_map) end

---Adds the given recipe to the list of recipe notifications for this player.
---@param _recipe string @Name of the recipe prototype to add.
function LuaPlayer.add_recipe_notification(_recipe) end

---Adds the given blueprint to this player's clipboard queue.
---@param _blueprint LuaItemStack @The blueprint to add.
function LuaPlayer.add_to_clipboard(_blueprint) end

---Associates a character with this player.
---
---The character must not be connected to any controller.
---\
---If this player is currently disconnected (see [LuaPlayer::connected](LuaPlayer::connected)) the character will be immediately "logged off".
---\
---See [LuaPlayer::get_associated_characters](LuaPlayer::get_associated_characters) for more information.
---@param _character LuaEntity @The character entity.
function LuaPlayer.associate_character(_character) end

---Builds what ever is in the cursor on the surface the player is on.
---
---Anything built will fire normal player-built events.
---\
---The cursor stack will automatically be reduced as if the player built normally.
---@param _table LuaPlayer.build_from_cursor
function LuaPlayer.build_from_cursor(_table) end

---Checks if this player can build what ever is in the cursor on the surface the player is on.
---@param _table LuaPlayer.can_build_from_cursor
---@return boolean
function LuaPlayer.can_build_from_cursor(_table) end

---Checks if this player can build the give entity at the given location on the surface the player is on.
---@param _table LuaPlayer.can_place_entity
---@return boolean
function LuaPlayer.can_place_entity(_table) end

---Clear the chat console.
function LuaPlayer.clear_console() end

---Invokes the "clear cursor" action on the player as if the user pressed it.
---@return boolean @Whether the cursor is now empty.
function LuaPlayer.clear_cursor() end

---Clears all recipe notifications for this player.
function LuaPlayer.clear_recipe_notifications() end

---Clears the players selection tool selection position.
function LuaPlayer.clear_selection() end

---Queues request to switch to the normal game view from the map or zoom to world view. Render mode change requests are processed before rendering of the next frame.
function LuaPlayer.close_map() end

---Asks the player if they would like to connect to the given server.
---
---This only does anything when used on a multiplayer peer. Single player and server hosts will ignore the prompt.
---@param _table LuaPlayer.connect_to_server
function LuaPlayer.connect_to_server(_table) end

---Creates and attaches a character entity to this player.
---
---The player must not have a character already connected and must be online (see [LuaPlayer::connected](LuaPlayer::connected)).
---@param _character? string @The character to create else the default is used.
---@return boolean @Whether the character was created.
function LuaPlayer.create_character(_character) end

---Spawn flying text that is only visible to this player. Either `position` or `create_at_cursor` are required. When `create_at_cursor` is `true`, all parameters other than `text` are ignored.
---
---If no custom `speed` is set and the text is longer than 25 characters, its `time_to_live` and `speed` are dynamically adjusted to give players more time to read it.
---\
---Local flying text is not saved, which means it will disappear after a save/load-cycle.
---@param _table LuaPlayer.create_local_flying_text
function LuaPlayer.create_local_flying_text(_table) end

---Disables alerts for the given alert category.
---@param _alert_type defines.alert_type
---@return boolean @Whether the alert type was disabled (false if it was already disabled).
function LuaPlayer.disable_alert(_alert_type) end

---Disable recipe groups.
function LuaPlayer.disable_recipe_groups() end

---Disable recipe subgroups.
function LuaPlayer.disable_recipe_subgroups() end

---Disassociates a character from this player. This is functionally the same as setting [LuaEntity::associated_player](LuaEntity::associated_player) to `nil`.
---
---See [LuaPlayer::get_associated_characters](LuaPlayer::get_associated_characters) for more information.
---@param _character LuaEntity @The character entity
function LuaPlayer.disassociate_character(_character) end

---Start/end wire dragging at the specified location, wire type is based on the cursor contents
---@param _table LuaPlayer.drag_wire
---@return boolean @`true` if the action did something
function LuaPlayer.drag_wire(_table) end

---Enables alerts for the given alert category.
---@param _alert_type defines.alert_type
---@return boolean @Whether the alert type was enabled (false if it was already enabled).
function LuaPlayer.enable_alert(_alert_type) end

---Enable recipe groups.
function LuaPlayer.enable_recipe_groups() end

---Enable recipe subgroups.
function LuaPlayer.enable_recipe_subgroups() end

---Exit the current cutscene. Errors if not in a cutscene.
function LuaPlayer.exit_cutscene() end

---Gets which quick bar page is being used for the given screen page or `nil` if not known.
---@param _index uint @The screen page. Index 1 is the top row in the gui. Index can go beyond the visible number of bars on the screen to account for the interface config setting change.
---@return uint8
function LuaPlayer.get_active_quick_bar_page(_index) end

---Get all alerts matching the given filters, or all alerts if no filters are given.
---@param _table LuaPlayer.get_alerts
---@return table<uint, table<defines.alert_type, Alert[]>> @A mapping of surface index to an array of arrays of [alerts](Alert) indexed by the [alert type](defines.alert_type).
function LuaPlayer.get_alerts(_table) end

---The characters associated with this player.
---
---The array will always be empty when the player is disconnected (see [LuaPlayer::connected](LuaPlayer::connected)) regardless of there being associated characters.
---\
---Characters associated with this player will be logged off when this player disconnects but are not controlled by any player.
---@return LuaEntity[]
function LuaPlayer.get_associated_characters() end

---Get the current goal description, as a localised string.
---@return LocalisedString
function LuaPlayer.get_goal_description() end

---Gets the filter for this map editor infinity filters at the given index or `nil` if the filter index doesn't exist or is empty.
---@param _index uint @The index to get.
---@return InfinityInventoryFilter
function LuaPlayer.get_infinity_inventory_filter(_index) end

---Gets the quick bar filter for the given slot or `nil`.
---@param _index uint @The slot index. 1 for the first slot of page one, 2 for slot two of page one, 11 for the first slot of page 2, etc.
---@return LuaItemPrototype
function LuaPlayer.get_quick_bar_slot(_index) end

---All methods and properties that this object supports.
---@return string
function LuaPlayer.help() end

---If the given alert type is currently enabled.
---@param _alert_type defines.alert_type
---@return boolean
function LuaPlayer.is_alert_enabled(_alert_type) end

---If the given alert type is currently muted.
---@param _alert_type defines.alert_type
---@return boolean
function LuaPlayer.is_alert_muted(_alert_type) end

---Is a custom Lua shortcut currently available?
---@param _prototype_name string @Prototype name of the custom shortcut.
---@return boolean
function LuaPlayer.is_shortcut_available(_prototype_name) end

---Is a custom Lua shortcut currently toggled?
---@param _prototype_name string @Prototype name of the custom shortcut.
---@return boolean
function LuaPlayer.is_shortcut_toggled(_prototype_name) end

---Jump to the specified cutscene waypoint. Only works when the player is viewing a cutscene.
---@param _waypoint_index uint
function LuaPlayer.jump_to_cutscene_waypoint(_waypoint_index) end

---Logs a dictionary of chunks -> active entities for the surface this player is on.
function LuaPlayer.log_active_entity_chunk_counts() end

---Logs a dictionary of active entities -> count for the surface this player is on.
function LuaPlayer.log_active_entity_counts() end

---Mutes alerts for the given alert category.
---@param _alert_type defines.alert_type
---@return boolean @Whether the alert type was muted (false if it was already muted).
function LuaPlayer.mute_alert(_alert_type) end

---Queues a request to open the map at the specified position. If the map is already opened, the request will simply set the position (and scale). Render mode change requests are processed before rendering of the next frame.
---@param _position MapPosition
---@param _scale? double
function LuaPlayer.open_map(_position, _scale) end

---Invokes the "smart pipette" action on the player as if the user pressed it.
---@param _entity string|LuaEntity|LuaEntityPrototype
---@return boolean @Whether the smart pipette found something to place.
function LuaPlayer.pipette_entity(_entity) end

---Play a sound for this player.
---@param _table LuaPlayer.play_sound
function LuaPlayer.play_sound(_table) end

---Print text to the chat console.
---
---Messages that are identical to a message sent in the last 60 ticks are not printed again.
---@param _message LocalisedString
---@param _color? Color
function LuaPlayer.print(_message, _color) end

---Print entity statistics to the player's console.
---@param _entities? string[] @Entity prototypes to get statistics for. If not specified or empty, display statistics for all entities.
function LuaPlayer.print_entity_statistics(_entities) end

---Print LuaObject counts per mod.
function LuaPlayer.print_lua_object_statistics() end

---Print construction robot job counts to the players console.
function LuaPlayer.print_robot_jobs() end

---Removes all alerts matching the given filters or if an empty filters table is given all alerts are removed.
---@param _table LuaPlayer.remove_alert
function LuaPlayer.remove_alert(_table) end

---Requests a translation for the given localised string. If the request is successful the [on_string_translated](on_string_translated) event will be fired at a later time with the results.
---
---Does nothing if this player is not connected. (see [LuaPlayer::connected](LuaPlayer::connected)).
---@param _localised_string LocalisedString
---@return boolean @Whether the request was sent or not.
function LuaPlayer.request_translation(_localised_string) end

---Sets which quick bar page is being used for the given screen page.
---@param _screen_index uint @The screen page. Index 1 is the top row in the gui. Index can go beyond the visible number of bars on the screen to account for the interface config setting change.
---@param _page_index uint @The new quick bar page.
function LuaPlayer.set_active_quick_bar_page(_screen_index, _page_index) end

---Set the controller type of the player.
---
---Setting a player to [defines.controllers.editor](defines.controllers.editor) auto promotes the player to admin and enables cheat mode.
---\
---Setting a player to [defines.controllers.editor](defines.controllers.editor) also requires the calling player be an admin.
---@param _table LuaPlayer.set_controller
function LuaPlayer.set_controller(_table) end

---Setup the screen to be shown when the game is finished.
---@param _message LocalisedString @Message to be shown.
---@param _file? string @Path to image to be shown.
function LuaPlayer.set_ending_screen_data(_message, _file) end

---Set the text in the goal window (top left).
---@param _text? LocalisedString @The text to display. Lines can be delimited with `\n`. Passing an empty string or omitting this parameter entirely will make the goal window disappear.
---@param _only_update? boolean @When `true`, won't play the "goal updated" sound.
function LuaPlayer.set_goal_description(_text, _only_update) end

---Sets the filter for this map editor infinity filters at the given index.
---@param _index uint @The index to set.
---@param _filter InfinityInventoryFilter @The new filter or `nil` to clear the filter.
function LuaPlayer.set_infinity_inventory_filter(_index, _filter) end

---Sets the quick bar filter for the given slot.
---@param _index uint @The slot index. 1 for the first slot of page one, 2 for slot two of page one, 11 for the first slot of page 2, etc.
---@param _filter string|LuaItemPrototype|LuaItemStack @The filter or `nil`.
function LuaPlayer.set_quick_bar_slot(_index, _filter) end

---Make a custom Lua shortcut available or unavailable.
---@param _prototype_name string @Prototype name of the custom shortcut.
---@param _available boolean
function LuaPlayer.set_shortcut_available(_prototype_name, _available) end

---Toggle or untoggle a custom Lua shortcut
---@param _prototype_name string @Prototype name of the custom shortcut.
---@param _toggled boolean
function LuaPlayer.set_shortcut_toggled(_prototype_name, _toggled) end

---Starts selection with selection tool from the specified position. Does nothing if the players cursor is not a selection tool.
---@param _position MapPosition @The position to start selection from.
---@param _selection_mode string @The type of selection to start. Can be `select`, `alternative-select`, `reverse-select`.
function LuaPlayer.start_selection(_position, _selection_mode) end

---Toggles this player into or out of the map editor. Does nothing if this player isn't an admin or if the player doesn't have permission to use the map editor.
function LuaPlayer.toggle_map_editor() end

---Unlock the achievements of the given player. This has any effect only when this is the local player, the achievement isn't unlocked so far and the achievement is of the type "achievement".
---@param _name string @name of the achievement to unlock
function LuaPlayer.unlock_achievement(_name) end

---Unmutes alerts for the given alert category.
---@param _alert_type defines.alert_type
---@return boolean @Whether the alert type was unmuted (false if it was wasn't muted).
function LuaPlayer.unmute_alert(_alert_type) end

---Uses the current item in the cursor if it's a capsule or does nothing if not.
---@param _position MapPosition @Where the item would be used.
function LuaPlayer.use_from_cursor(_position) end

---Queues a request to zoom to world at the specified position. If the player is already zooming to world, the request will simply set the position (and scale). Render mode change requests are processed before rendering of the next frame.
---@param _position MapPosition
---@param _scale? double
function LuaPlayer.zoom_to_world(_position, _scale) end


---@class LuaPlayer.build_from_cursor
---@field position MapPosition @Where the entity would be placed
---@field direction? defines.direction @Direction the entity would be placed
---@field alt? boolean @If alt build should be used instead of normal build. Defaults to normal.
---@field terrain_building_size? uint @The size for building terrain if building terrain. Defaults to 2.
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.

---@class LuaPlayer.can_build_from_cursor
---@field position MapPosition @Where the entity would be placed
---@field direction? defines.direction @Direction the entity would be placed
---@field alt? boolean @If alt build should be used instead of normal build. Defaults to normal.
---@field terrain_building_size? uint @The size for building terrain if building terrain. Defaults to 2.
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.

---@class LuaPlayer.can_place_entity
---@field name string @Name of the entity to check
---@field position MapPosition @Where the entity would be placed
---@field direction? defines.direction @Direction the entity would be placed

---@class LuaPlayer.connect_to_server
---@field address string @The server (address:port) if port is not given the default Factorio port is used.
---@field name? LocalisedString @The name of the server.
---@field description? LocalisedString
---@field password? string @The password if different from the one used to join this game. Note, if the current password is not empty but the one required to join the new server is an empty string should be given for this field.

---@class LuaPlayer.create_local_flying_text
---@field text LocalisedString @The flying text to show.
---@field position? MapPosition @The location on the map at which to show the flying text.
---@field create_at_cursor? boolean @If `true`, the flying text is created at the player's cursor. Defaults to `false`.
---@field color? Color @The color of the flying text. Defaults to white text.
---@field time_to_live? uint @The amount of ticks that the flying text will be shown for. Defaults to `80`.
---@field speed? double @The speed at which the text rises upwards in tiles/second. Can't be a negative value.

---@class LuaPlayer.drag_wire
---@field position MapPosition @Position at which cursor was clicked. Used only to decide which side of arithmetic combinator, decider combinator or power switch is to be connected. Entity itself to be connected is based on the player's selected entity.

---@class LuaPlayer.get_alerts
---@field entity? LuaEntity
---@field prototype? LuaEntityPrototype
---@field position? MapPosition
---@field type? defines.alert_type
---@field surface? SurfaceIdentification

---@class LuaPlayer.play_sound
---@field path SoundPath @The sound to play.
---@field position? MapPosition @Where the sound should be played. If not given, it's played at the current position of the player.
---@field volume_modifier? double @The volume of the sound to play. Must be between 0 and 1 inclusive.
---@field override_sound_type? SoundType @The volume mixer to play the sound through. Defaults to the default mixer for the given sound type.

---@class LuaPlayer.remove_alert
---@field entity? LuaEntity
---@field prototype? LuaEntityPrototype
---@field position? MapPosition
---@field type? defines.alert_type
---@field surface? SurfaceIdentification
---@field icon? SignalID
---@field message? LocalisedString

---@class LuaPlayer.set_controller
---@field type defines.controllers @Which controller to use.
---@field character? LuaEntity @Entity to control. Mandatory when `type` is [defines.controllers.character](defines.controllers.character), ignored otherwise.
---@field waypoints? CutsceneWaypoint @List of waypoints for the cutscene controller. This parameter is mandatory when `type` is [defines.controllers.cutscene](defines.controllers.cutscene).
---@field start_position? MapPosition @If specified and `type` is [defines.controllers.cutscene](defines.controllers.cutscene), the cutscene will start at this position. If not given the start position will be the player position.
---@field start_zoom? double @If specified and `type` is [defines.controllers.cutscene](defines.controllers.cutscene), the cutscene will start at this zoom level. If not given the start zoom will be the players zoom.
---@field final_transition_time? uint @If specified and `type` is [defines.controllers.cutscene](defines.controllers.cutscene), it is the time in ticks it will take for the camera to pan from the final waypoint back to the starting position. If not given the camera will not pan back to the start position/zoom.
---@field chart_mode_cutoff? double @If specified and `type` is [defines.controllers.cutscene](defines.controllers.cutscene), the game will switch to chart-mode (map zoomed out) rendering when the zoom level is less than this value.

