---@meta

---Main toplevel type, provides access to most of the API though its members. An instance of LuaGameScript is available as the global object named `game`.
---@class LuaGameScript
---@field achievement_prototypes table<string, LuaAchievementPrototype> @A dictionary containing every LuaAchievementPrototype indexed by `name`.`[R]`
---The active mods versions. The keys are mod names, the values are the versions.`[R]`
---
---This will print the names and versions of active mods to player p's console. 
---```lua
---for name, version in pairs(game.active_mods) do
---  p.print(name .. " version " .. version)
---end
---```
---@field active_mods table<string, string>
---@field ammo_category_prototypes table<string, LuaAmmoCategoryPrototype> @A dictionary containing every LuaAmmoCategoryPrototype indexed by `name`.`[R]`
---@field autoplace_control_prototypes table<string, LuaAutoplaceControlPrototype> @A dictionary containing every LuaAutoplaceControlPrototype indexed by `name`.`[R]`
---@field autosave_enabled boolean @True by default. Can be used to disable autosaving. Make sure to turn it back on soon after.`[RW]`
---@field backer_names table<uint, string> @Array of the names of all the backers that supported the game development early on. These are used as names for labs, locomotives, radars, roboports, and train stops.`[R]`
---The players that are currently online.
---
---This is primarily useful when you want to do some action against all online players.`[R]`
---
---This does *not* index using player index. See [LuaPlayer::index](LuaPlayer::index) on each player instance for the player index.
---@field connected_players LuaPlayer[]
---@field custom_input_prototypes table<string, LuaCustomInputPrototype> @A dictionary containing every LuaCustomInputPrototype indexed by `name`.`[R]`
---@field damage_prototypes table<string, LuaDamagePrototype> @A dictionary containing every LuaDamagePrototype indexed by `name`.`[R]`
---@field decorative_prototypes table<string, LuaDecorativePrototype> @A dictionary containing every LuaDecorativePrototype indexed by `name`.`[R]`
---@field default_map_gen_settings MapGenSettings @The default map gen settings for this save.`[R]`
---@field difficulty defines.difficulty @Current scenario difficulty.`[R]`
---The currently active set of difficulty settings. Even though this property is marked as read-only, the members of the dictionary that is returned can be modified mid-game. This is however not recommended as different difficulties can have differing technology and recipe trees, which can cause problems for players.`[R]`
---
---This will set the technology price multiplier to 12. 
---```lua
---game.difficulty_settings.technology_price_multiplier = 12
---```
---@field difficulty_settings DifficultySettings
---@field draw_resource_selection boolean @True by default. Can be used to disable the highlighting of resource patches when they are hovered on the map.`[RW]`
---@field enemy_has_vision_on_land_mines boolean @Determines if enemy land mines are completely invisible or not.`[RW]`
---@field entity_prototypes table<string, LuaEntityPrototype> @A dictionary containing every LuaEntityPrototype indexed by `name`.`[R]`
---@field equipment_category_prototypes table<string, LuaEquipmentCategoryPrototype> @A dictionary containing every LuaEquipmentCategoryPrototype indexed by `name`.`[R]`
---@field equipment_grid_prototypes table<string, LuaEquipmentGridPrototype> @A dictionary containing every LuaEquipmentGridPrototype indexed by `name`.`[R]`
---@field equipment_prototypes table<string, LuaEquipmentPrototype> @A dictionary containing every LuaEquipmentPrototype indexed by `name`.`[R]`
---@field finished boolean @True while the victory screen is shown.`[R]`
---@field finished_but_continuing boolean @True after players finished the game and clicked "continue".`[R]`
---@field fluid_prototypes table<string, LuaFluidPrototype> @A dictionary containing every LuaFluidPrototype indexed by `name`.`[R]`
---@field font_prototypes table<string, LuaFontPrototype> @A dictionary containing every LuaFontPrototype indexed by `name`.`[R]`
---@field forces table<uint|string, LuaForce> @Get a table of all the forces that currently exist. This sparse table allows you to find forces by indexing it with either their `name` or `index`. Iterating this table with `pairs()` will only iterate the array part of the table. Iterating with `ipairs()` will not work at all.`[R]`
---@field fuel_category_prototypes table<string, LuaFuelCategoryPrototype> @A dictionary containing every LuaFuelCategoryPrototype indexed by `name`.`[R]`
---@field item_group_prototypes table<string, LuaGroup> @A dictionary containing every ItemGroup indexed by `name`.`[R]`
---@field item_prototypes table<string, LuaItemPrototype> @A dictionary containing every LuaItemPrototype indexed by `name`.`[R]`
---@field item_subgroup_prototypes table<string, LuaGroup> @A dictionary containing every ItemSubgroup indexed by `name`.`[R]`
---A dictionary containing every MapGenPreset indexed by `name`.`[R]`
---
---A MapGenPreset is an exact copy of the prototype table provided from the data stage.
---@field map_gen_presets table<string, MapGenPreset>
---The currently active set of map settings. Even though this property is marked as read-only, the members of the dictionary that is returned can be modified mid-game.`[R]`
---
---This does not contain difficulty settings, use [LuaGameScript::difficulty_settings](LuaGameScript::difficulty_settings) instead.
---@field map_settings MapSettings
---@field max_beacon_supply_area_distance double @`[R]`
---@field max_electric_pole_connection_distance double @`[R]`
---@field max_electric_pole_supply_area_distance float @`[R]`
---@field max_force_distraction_chunk_distance uint @`[R]`
---@field max_force_distraction_distance double @`[R]`
---@field max_gate_activation_distance double @`[R]`
---@field max_inserter_reach_distance double @`[R]`
---@field max_pipe_to_ground_distance uint8 @`[R]`
---@field max_underground_belt_distance uint8 @`[R]`
---@field mod_setting_prototypes table<string, LuaModSettingPrototype> @A dictionary containing every LuaModSettingPrototype indexed by `name`.`[R]`
---@field module_category_prototypes table<string, LuaModuleCategoryPrototype> @A dictionary containing every LuaModuleCategoryPrototype indexed by `name`.`[R]`
---@field named_noise_expressions table<string, LuaNamedNoiseExpression> @A dictionary containing every LuaNamedNoiseExpression indexed by `name`.`[R]`
---@field noise_layer_prototypes table<string, LuaNoiseLayerPrototype> @A dictionary containing every LuaNoiseLayerPrototype indexed by `name`.`[R]`
---@field object_name string @This object's name.`[R]`
---@field particle_prototypes table<string, LuaParticlePrototype> @A dictionary containing every LuaParticlePrototype indexed by `name`.`[R]`
---@field permissions LuaPermissionGroups @`[R]`
---This property is only populated inside [custom command](LuaCommandProcessor) handlers and when writing [Lua console commands](https://wiki.factorio.com/Console#Scripting_and_cheat_commands). Returns the player that is typing the command, `nil` in all other instances.
---
---See [LuaGameScript::players](LuaGameScript::players) for accessing all players.`[R]`
---@field player LuaPlayer
---@field players table<uint|string, LuaPlayer> @Get a table of all the players that currently exist. This sparse table allows you to find players by indexing it with either their `name` or `index`. Iterating this table with `pairs()` will only iterate the array part of the table. Iterating with `ipairs()` will not work at all.`[R]`
---@field pollution_statistics LuaFlowStatistics @The pollution statistics for this map.`[R]`
---@field recipe_category_prototypes table<string, LuaRecipeCategoryPrototype> @A dictionary containing every LuaRecipeCategoryPrototype indexed by `name`.`[R]`
---@field recipe_prototypes table<string, LuaRecipePrototype> @A dictionary containing every LuaRecipePrototype indexed by `name`.`[R]`
---@field resource_category_prototypes table<string, LuaResourceCategoryPrototype> @A dictionary containing every LuaResourceCategoryPrototype indexed by `name`.`[R]`
---@field shortcut_prototypes table<string, LuaShortcutPrototype> @A dictionary containing every LuaShortcutPrototype indexed by `name`.`[R]`
---Speed to update the map at. 1.0 is normal speed -- 60 UPS.`[RW]`
---
---Minimum value is 0.01.
---@field speed float
---@field styles table<string, string> @The styles that [LuaGuiElement](LuaGuiElement) can use, indexed by `name`.`[R]`
---@field surfaces table<uint|string, LuaSurface> @Get a table of all the surfaces that currently exist. This sparse table allows you to find surfaces by indexing it with either their `name` or `index`. Iterating this table with `pairs()` will only iterate the array part of the table. Iterating with `ipairs()` will not work at all.`[R]`
---@field technology_prototypes table<string, LuaTechnologyPrototype> @A dictionary containing every [LuaTechnologyPrototype](LuaTechnologyPrototype) indexed by `name`.`[R]`
---@field tick uint @Current map tick.`[R]`
---@field tick_paused boolean @If the tick has been paused. This means that entity update has been paused.`[RW]`
---The number of ticks since this game was 'created'. A game is 'created' either by using "new game" or "new game from scenario".`[R]`
---
---This differs over [LuaGameScript::tick](LuaGameScript::tick) in that making a game from a scenario always starts with ticks_played value at 0 even if the scenario has its own level data where the [LuaGameScript::tick](LuaGameScript::tick) is > 0.
---\
---This value has no relation with [LuaGameScript::tick](LuaGameScript::tick) and can be completely different values.
---@field ticks_played uint
---@field ticks_to_run uint @The number of ticks to be run while the tick is paused. When [LuaGameScript::tick_paused](LuaGameScript::tick_paused) is true, ticks_to_run behaves the following way: While this is > 0, the entity update is running normally and this value is decremented every tick. When this reaches 0, the game will pause again.`[RW]`
---@field tile_prototypes table<string, LuaTilePrototype> @A dictionary containing every LuaTilePrototype indexed by `name`.`[R]`
---@field trivial_smoke_prototypes table<string, LuaTrivialSmokePrototype> @A dictionary containing every LuaTrivialSmokePrototype indexed by `name`.`[R]`
---@field virtual_signal_prototypes table<string, LuaVirtualSignalPrototype> @A dictionary containing every LuaVirtualSignalPrototype indexed by `name`.`[R]`
local LuaGameScript = {}

---Instruct the game to perform an auto-save.
---
---Only the server will save in multiplayer. In single player a standard auto-save is triggered.
---@param _name? string @The autosave name if any. Saves will be named _autosave-*name* when provided.
function LuaGameScript.auto_save(_name) end

---Bans the given player from this multiplayer game. Does nothing if this is a single player game of if the player running this isn't an admin.
---@param _player PlayerIdentification @The player to ban.
---@param _reason? LocalisedString @The reason given if any.
function LuaGameScript.ban_player(_player, _reason) end

---Run internal consistency checks. Allegedly prints any errors it finds.
---
---Exists mainly for debugging reasons.
function LuaGameScript.check_consistency() end

---Goes over all items, entities, tiles, recipes, technologies among other things and logs if the locale is incorrect.
---
---Also prints true/false if called from the console.
function LuaGameScript.check_prototype_translations() end

---Counts how many distinct groups of pipes exist in the world.
function LuaGameScript.count_pipe_groups() end

---Create a new force.
---
---The game currently supports a maximum of 64 forces, including the three built-in forces. This means that a maximum of 61 new forces may be created.
---\
---Force names must be unique.
---@param _force string @Name of the new force
---@return LuaForce @The force that was just created
function LuaGameScript.create_force(_force) end

---Creates an inventory that is not owned by any game object. It can be resized later with [LuaInventory::resize](LuaInventory::resize).
---
---Make sure to destroy it when you are done with it using [LuaInventory::destroy](LuaInventory::destroy).
---@param _size uint16 @The number of slots the inventory initially has.
---@return LuaInventory
function LuaGameScript.create_inventory(_size) end

---Creates a [LuaProfiler](LuaProfiler), which is used for measuring script performance.
---
---LuaProfiler cannot be serialized.
---@param _stopped? boolean @Create the timer stopped
---@return LuaProfiler
function LuaGameScript.create_profiler(_stopped) end

---Creates a deterministic standalone random generator with the given seed or if a seed is not provided the initial map seed is used.
---
---*Make sure* you actually want to use this over math.random(...) as this provides entirely different functionality over math.random(...).
---@param _seed? uint
---@return LuaRandomGenerator
function LuaGameScript.create_random_generator(_seed) end

---Create a new surface.
---
---The game currently supports a maximum of 4,294,967,295 surfaces, including the default surface.
---\
---Surface names must be unique.
---@param _name string @Name of the new surface.
---@param _settings? MapGenSettings @Map generation settings.
---@return LuaSurface @The surface that was just created.
function LuaGameScript.create_surface(_name, _settings) end

---Base64 decodes and inflates the given string.
---@param _string string @The string to decode.
---@return string @The decoded string or `nil` if the decode failed.
function LuaGameScript.decode_string(_string) end

---Deletes the given surface and all entities on it.
---@param _surface string|LuaSurface @The surface to be deleted. Currently the primary surface (1, 'nauvis') cannot be deleted.
function LuaGameScript.delete_surface(_surface) end

---Converts the given direction into the string version of the direction.
---@param _direction defines.direction
function LuaGameScript.direction_to_string(_direction) end

---Disables replay saving for the current save file. Once done there's no way to re-enable replay saving for the save file without loading an old save.
function LuaGameScript.disable_replay() end

---Disables tutorial triggers, that unlock new tutorials and show notices about unlocked tutorials.
function LuaGameScript.disable_tutorial_triggers() end

---Deflates and base64 encodes the given string.
---@param _string string @The string to encode.
---@return string @The encoded string or `nil` if the encode failed.
function LuaGameScript.encode_string(_string) end

---Evaluate an expression, substituting variables as provided. For details on the formula, see the relevant page on the [Factorio wiki](https://wiki.factorio.com/Prototype/Technology#unit).
---
---Calculate the number of research units required to unlock mining productivity level 10. 
---```lua
---local formula = game.forces["player"].technologies["mining-productivity-4"].research_unit_count_formula
---local units = game.evaluate_expression(formula, { L = 10, l = 10 })
---```
---@param _expression string @The expression to evaluate.
---@param _variables? table<string, double> @Variables to be substituted.
---@return double
function LuaGameScript.evaluate_expression(_expression, _variables) end

---Force a CRC check. Tells all peers to calculate their current map CRC; these CRC are then compared against each other. If a mismatch is detected, the game is desynced and some peers are forced to reconnect.
function LuaGameScript.force_crc() end

---Gets the number of entities that are active (updated each tick).
---
---This is very expensive to determine.
---@param _surface? SurfaceIdentification @If give, only the entities active on this surface are counted.
---@return uint
function LuaGameScript.get_active_entities_count(_surface) end

---@param _tag string
---@return LuaEntity
function LuaGameScript.get_entity_by_tag(_tag) end

---Returns a dictionary of all LuaAchievementPrototypes that fit the given filters. The prototypes are indexed by `name`.
---
---Get every achievement prototype that is not allowed to be completed on the peaceful difficulty setting. 
---```lua
---local prototypes = game.get_filtered_achievement_prototypes{{filter="allowed-without-fight", invert=true}}
---```
---@param _filters AchievementPrototypeFilter[]
---@return table<string, LuaAchievementPrototype>
function LuaGameScript.get_filtered_achievement_prototypes(_filters) end

---Returns a dictionary of all LuaDecorativePrototypes that fit the given filters. The prototypes are indexed by `name`.
---
---Get every decorative prototype that is auto-placed. 
---```lua
---local prototypes = game.get_filtered_decorative_prototypes{{filter="autoplace"}}
---```
---@param _filters DecorativePrototypeFilter[]
---@return table<string, LuaDecorativePrototype>
function LuaGameScript.get_filtered_decorative_prototypes(_filters) end

---Returns a dictionary of all LuaEntityPrototypes that fit the given filters. The prototypes are indexed by `name`.
---
---Get every entity prototype that can craft recipes involving fluids in the way some assembling machines can. 
---```lua
---local prototypes = game.get_filtered_entity_prototypes{{filter="crafting-category", crafting_category="crafting-with-fluid"}}
---```
---@param _filters EntityPrototypeFilter[]
---@return table<string, LuaEntityPrototype>
function LuaGameScript.get_filtered_entity_prototypes(_filters) end

---Returns a dictionary of all LuaEquipmentPrototypes that fit the given filters. The prototypes are indexed by `name`.
---
---Get every equipment prototype that functions as a battery. 
---```lua
---local prototypes = game.get_filtered_equipment_prototypes{{filter="type", type="battery-equipment"}}
---```
---@param _filters EquipmentPrototypeFilter[]
---@return table<string, LuaEquipmentPrototype>
function LuaGameScript.get_filtered_equipment_prototypes(_filters) end

---Returns a dictionary of all LuaFluidPrototypes that fit the given filters. The prototypes are indexed by `name`.
---
---Get every fluid prototype that has a heat capacity of exactly `100`. 
---```lua
---local prototypes = game.get_filtered_fluid_prototypes{{filter="heat-capacity", comparison="=", value=100}}
---```
---@param _filters FluidPrototypeFilter[]
---@return table<string, LuaFluidPrototype>
function LuaGameScript.get_filtered_fluid_prototypes(_filters) end

---Returns a dictionary of all LuaItemPrototypes that fit the given filters. The prototypes are indexed by `name`.
---
---Get every item prototype that, when launched with a rocket, produces a result. 
---```lua
---local prototypes = game.get_filtered_item_prototypes{{filter="has-rocket-launch-products"}}
---```
---@param _filters ItemPrototypeFilter[]
---@return table<string, LuaItemPrototype>
function LuaGameScript.get_filtered_item_prototypes(_filters) end

---Returns a dictionary of all LuaModSettingPrototypes that fit the given filters. The prototypes are indexed by `name`.
---
---Get every mod setting prototype that belongs to the specified mod. 
---```lua
---local prototypes = game.get_filtered_mod_setting_prototypes{{filter="mod", mod="space-exploration"}}
---```
---@param _filters ModSettingPrototypeFilter[]
---@return table<string, LuaModSettingPrototype>
function LuaGameScript.get_filtered_mod_setting_prototypes(_filters) end

---Returns a dictionary of all LuaRecipePrototypes that fit the given filters. The prototypes are indexed by `name`.
---
---Get every recipe prototype that takes less than half a second to craft (at crafting speed `1`). 
---```lua
---local prototypes = game.get_filtered_recipe_prototypes{{filter="energy", comparison="<", value=0.5}}
---```
---@param _filters RecipePrototypeFilter[]
---@return table<string, LuaRecipePrototype>
function LuaGameScript.get_filtered_recipe_prototypes(_filters) end

---Returns a dictionary of all LuaTechnologyPrototypes that fit the given filters. The prototypes are indexed by `name`.
---
---Get every technology prototype that can be researched at the start of the game. 
---```lua
---local prototypes = game.get_filtered_technology_prototypes{{filter="has-prerequisites", invert=true}}
---```
---@param _filters TechnologyPrototypeFilter[]
---@return table<string, LuaTechnologyPrototype>
function LuaGameScript.get_filtered_technology_prototypes(_filters) end

---Returns a dictionary of all LuaTilePrototypes that fit the given filters. The prototypes are indexed by `name`.
---
---Get every tile prototype that improves a player's walking speed by at least 50%. 
---```lua
---local prototypes = game.get_filtered_tile_prototypes{{filter="walking-speed-modifier", comparison="≥", value=1.5}}
---```
---@param _filters TilePrototypeFilter[]
---@return table<string, LuaTilePrototype>
function LuaGameScript.get_filtered_tile_prototypes(_filters) end

---Gets the map exchange string for the map generation settings that were used to create this map.
---@return string
function LuaGameScript.get_map_exchange_string() end

---Gets the given player or returns `nil` if no player is found.
---
---This is a shortcut for game.players[...]
---@param _player uint|string @The player index or name.
---@return LuaPlayer
function LuaGameScript.get_player(_player) end

---Gets the inventories created through [LuaGameScript::create_inventory](LuaGameScript::create_inventory)
---
---Inventories created through console commands will be owned by `"core"`.
---@param _mod? string @The mod who's inventories to get. If not provided all inventories are returned.
---@return table<string, LuaInventory[]> @A mapping of mod name to array of inventories owned by that mod.
function LuaGameScript.get_script_inventories(_mod) end

---Gets the given surface or returns `nil` if no surface is found.
---
---This is a shortcut for game.surfaces[...]
---@param _surface uint|string @The surface index or name.
---@return LuaSurface
function LuaGameScript.get_surface(_surface) end

---Gets train stops matching the given filters.
---@param _table? LuaGameScript.get_train_stops
---@return LuaEntity[]
function LuaGameScript.get_train_stops(_table) end

---Is this the demo version of Factorio?
---@return boolean
function LuaGameScript.is_demo() end

---Is the map loaded is multiplayer?
---@return boolean
function LuaGameScript.is_multiplayer() end

---Checks if the given SoundPath is valid.
---@param _sound_path SoundPath @Path to the sound.
---@return boolean
function LuaGameScript.is_valid_sound_path(_sound_path) end

---Checks if the given SpritePath is valid and contains a loaded sprite. The existence of the image is not checked for paths of type `file`.
---@param _sprite_path SpritePath @Path to the image.
---@return boolean
function LuaGameScript.is_valid_sprite_path(_sprite_path) end

---Convert a JSON string to a table.
---@param _json string @The string to convert.
---@return AnyBasic @The returned object, or `nil` if the JSON string was invalid.
function LuaGameScript.json_to_table(_json) end

---Kicks the given player from this multiplayer game. Does nothing if this is a single player game or if the player running this isn't an admin.
---@param _player PlayerIdentification @The player to kick.
---@param _reason? LocalisedString @The reason given if any.
function LuaGameScript.kick_player(_player, _reason) end

---Marks two forces to be merged together. All entities in the source force will be reassigned to the target force. The source force will then be destroyed.
---
---The three built-in forces -- player, enemy and neutral -- can't be destroyed. I.e. they can't be used as the source argument to this function.
---\
---The source force is not removed until the end of the current tick, or if called during the [on_forces_merging](on_forces_merging) or [on_forces_merged](on_forces_merged) event, the end of the next tick.
---@param _source ForceIdentification @The force to remove.
---@param _destination ForceIdentification @The force to reassign all entities to.
function LuaGameScript.merge_forces(_source, _destination) end

---Mutes the given player. Does nothing if the player running this isn't an admin.
---@param _player PlayerIdentification @The player to mute.
function LuaGameScript.mute_player(_player) end

---Convert a map exchange string to map gen settings and map settings.
---@param _map_exchange_string string
---@return MapExchangeStringData
function LuaGameScript.parse_map_exchange_string(_map_exchange_string) end

---Play a sound for every player in the game.
---@param _table LuaGameScript.play_sound
function LuaGameScript.play_sound(_table) end

---Print text to the chat console all players.
---
---Messages that are identical to a message sent in the last 60 ticks are not printed again.
---@param _message LocalisedString
---@param _color? Color
function LuaGameScript.print(_message, _color) end

---Purges the given players messages from the game. Does nothing if the player running this isn't an admin.
---@param _player PlayerIdentification @The player to purge.
function LuaGameScript.purge_player(_player) end

---Regenerate autoplacement of some entities on all surfaces. This can be used to autoplace newly-added entities.
---
---All specified entity prototypes must be autoplacable.
---@param _entities string|string[] @Prototype names of entity or entities to autoplace.
function LuaGameScript.regenerate_entity(_entities) end

---Forces a reload of all mods.
---
---This will act like saving and loading from the mod(s) perspective.
---\
---This will do nothing if run in multiplayer.
---\
---This disables the replay if replay is enabled.
function LuaGameScript.reload_mods() end

---Forces a reload of the scenario script from the original scenario location.
---
---This disables the replay if replay is enabled.
function LuaGameScript.reload_script() end

---Remove players who are currently not connected from the map.
---@param _players? LuaPlayer|string[] @List of players to remove. If not specified, remove all offline players.
function LuaGameScript.remove_offline_players(_players) end

---Remove a file or directory in the `script-output` folder, located in the game's [user data directory](https://wiki.factorio.com/User_data_directory). Can be used to remove files created by [LuaGameScript::write_file](LuaGameScript::write_file).
---@param _path string @The path to the file or directory to remove, relative to `script-output`.
function LuaGameScript.remove_path(_path) end

---Reset scenario state (game_finished, player_won, etc.).
function LuaGameScript.reset_game_state() end

---Resets the amount of time played for this map.
function LuaGameScript.reset_time_played() end

---Saves the current configuration of Atlas to a file. This will result in huge file containing all of the game graphics moved to as small space as possible.
---
---Exists mainly for debugging reasons.
function LuaGameScript.save_atlas() end

---Instruct the server to save the map.
---@param _name? string @Save name. If not specified, writes into the currently-running save.
function LuaGameScript.server_save(_name) end

---Set scenario state.
---@param _table LuaGameScript.set_game_state
function LuaGameScript.set_game_state(_table) end

---Forces the screenshot saving system to wait until all queued screenshots have been written to disk.
function LuaGameScript.set_wait_for_screenshots_to_finish() end

---Show an in-game message dialog.
---
---Can only be used when the map contains exactly one player.
---@param _table LuaGameScript.show_message_dialog
function LuaGameScript.show_message_dialog(_table) end

---Convert a table to a JSON string
---@param _data table
---@return string
function LuaGameScript.table_to_json(_data) end

---Take a screenshot of the game and save it to the `script-output` folder, located in the game's [user data directory](https://wiki.factorio.com/User_data_directory). The name of the image file can be specified via the `path` parameter.
---
---If Factorio is running headless, this function will do nothing.
---@param _table LuaGameScript.take_screenshot
function LuaGameScript.take_screenshot(_table) end

---Take a screenshot of the technology screen and save it to the `script-output` folder, located in the game's [user data directory](https://wiki.factorio.com/User_data_directory). The name of the image file can be specified via the `path` parameter.
---@param _table LuaGameScript.take_technology_screenshot
function LuaGameScript.take_technology_screenshot(_table) end

---Unbans the given player from this multiplayer game. Does nothing if this is a single player game of if the player running this isn't an admin.
---@param _player PlayerIdentification @The player to unban.
function LuaGameScript.unban_player(_player) end

---Unmutes the given player. Does nothing if the player running this isn't an admin.
---@param _player PlayerIdentification @The player to unmute.
function LuaGameScript.unmute_player(_player) end

---Write a file to the `script-output` folder, located in the game's [user data directory](https://wiki.factorio.com/User_data_directory). The name and file extension of the file can be specified via the `filename` parameter.
---@param _filename string @The name of the file. Providing a directory path (ex. `"save/here/example.txt"`) will create the necessary folder structure in `script-output`.
---@param _data LocalisedString @The content to write to the file.
---@param _append? boolean @If `true`, `data` will be appended to the end of the file. Defaults to `false`, which will overwrite any pre-existing file with the new `data`.
---@param _for_player? uint @If given, the file will only be written for this `player_index`. Providing `0` will only write to the server's output if present.
function LuaGameScript.write_file(_filename, _data, _append, _for_player) end


---@class LuaGameScript.get_train_stops
---@field name? string|string[]
---@field surface? SurfaceIdentification
---@field force? ForceIdentification

---@class LuaGameScript.play_sound
---@field path SoundPath @The sound to play.
---@field position? MapPosition @Where the sound should be played. If not given, it's played at the current position of each player.
---@field volume_modifier? double @The volume of the sound to play. Must be between 0 and 1 inclusive.
---@field override_sound_type? SoundType @The volume mixer to play the sound through. Defaults to the default mixer for the given sound type.

---@class LuaGameScript.set_game_state
---@field game_finished boolean
---@field player_won boolean
---@field next_level string
---@field can_continue boolean
---@field victorious_force ForceIdentification

---@class LuaGameScript.show_message_dialog
---@field text LocalisedString @What the dialog should say
---@field image? string @Path to an image to show on the dialog
---@field point_to? GuiArrowSpecification @If specified, dialog will show an arrow pointing to this place. When not specified, the arrow will point to the player's position. (Use `point_to={type="nowhere"}` to remove the arrow entirely.) The dialog itself will be placed near the arrow's target.
---@field style? string @The gui style to use for this speech bubble. Must be of type speech_bubble.
---@field wrapper_frame_style? string @Must be of type flow_style.

---@class LuaGameScript.take_screenshot
---@field player? PlayerIdentification @The player to focus on. Defaults to the local player.
---@field by_player? PlayerIdentification @If defined, the screenshot will only be taken for this player.
---@field surface? SurfaceIdentification @If defined, the screenshot will be taken on this surface.
---@field position? MapPosition @If defined, the screenshot will be centered on this position. Otherwise, the screenshot will center on `player`.
---@field resolution? TilePosition @The maximum allowed resolution is 16384x16384 (8192x8192 when `anti_alias` is `true`), but the maximum recommended resolution is 4096x4096 (resp. 2048x2048).
---@field zoom? double @The map zoom to take the screenshot at. Defaults to `1`.
---@field path? string @The name of the image file. It should include a file extension indicating the desired format. Supports `.png`, `.jpg` /`.jpeg`, `.tga` and `.bmp`. Providing a directory path (ex. `"save/here/screenshot.png"`) will create the necessary folder structure in `script-output`. Defaults to `"screenshot.png"`.
---@field show_gui? boolean @Whether to include GUIs in the screenshot or not. Defaults to `false`.
---@field show_entity_info? boolean @Whether to include entity info ("Alt mode") or not. Defaults to `false`.
---@field show_cursor_building_preview? boolean @When `true` and when `player` is specified, the building preview for the item in the player's cursor will also be rendered. Defaults to `false`.
---@field anti_alias? boolean @Whether to render in double resolution and downscale the result (including GUI). Defaults to `false`.
---@field quality? int @The `.jpg` render quality as a percentage (from 0% to 100% inclusive), if used. A lower value means a more compressed image. Defaults to `80`.
---@field allow_in_replay? boolean @Whether to save the screenshot even during replay playback. Defaults to `false`.
---@field daytime? double @Overrides the current surface daytime for the duration of screenshot rendering.
---@field water_tick? uint @Overrides the tick of water animation, if animated water is enabled.
---@field force_render? boolean @Screenshot requests are processed in between game update and render. The game may skip rendering (ie. drop frames) if the previous frame has not finished rendering or the game simulation starts to fall below 60 updates per second. If `force_render` is set to `true`, the game won't drop frames and process the screenshot request at the end of the update in which the request was created. This is not honored on multiplayer clients that are catching up to server. Defaults to `false`.

---@class LuaGameScript.take_technology_screenshot
---@field force? ForceIdentification @The force whose technology to screenshot. If not given, the `"player`" force is used.
---@field path? string @The name of the image file. It should include a file extension indicating the desired format. Supports `.png`, `.jpg` /`.jpeg`, `.tga` and `.bmp`. Providing a directory path (ex. `"save/here/screenshot.png"`) will create the necessary folder structure in `script-output`. Defaults to `"technology-screenshot.png"`.
---@field by_player? PlayerIdentification @If given, the screenshot will only be taken for this player.
---@field selected_technology? TechnologyIdentification @The technology to highlight.
---@field skip_disabled? boolean @If `true`, disabled technologies will be skipped. Their successors will be attached to the disabled technology's parents. Defaults to `false`.
---@field quality? int @The `.jpg` render quality as a percentage (from 0% to 100% inclusive), if used. A lower value means a more compressed image. Defaults to `80`.

