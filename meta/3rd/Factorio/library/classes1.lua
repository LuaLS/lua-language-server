---@meta

---Collection of settings for overriding default ai behavior.
---@class LuaAISettings
---@field allow_destroy_when_commands_fail boolean @If enabled, units that repeatedly fail to succeed at commands will be destroyed.`[RW]`
---@field allow_try_return_to_spawner boolean @If enabled, units that have nothing else to do will attempt to return to a spawner.`[RW]`
---@field do_separation boolean @If enabled, units will try to separate themselves from nearby friendly units.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field path_resolution_modifier int8 @The pathing resolution modifier, must be between -8 and 8.`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaAISettings = {}

---All methods and properties that this object supports.
---@return string
function LuaAISettings.help() end

---Control behavior for accumulators.
---@class LuaAccumulatorControlBehavior:LuaControlBehavior
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field output_signal SignalID @`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaAccumulatorControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaAccumulatorControlBehavior.help() end

---Prototype of a achievement.
---@class LuaAchievementPrototype
---@field allowed_without_fight boolean @`[R]`
---@field hidden boolean @`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaAchievementPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaAchievementPrototype.help() end

---Prototype of a ammo category.
---@class LuaAmmoCategoryPrototype
---@field bonus_gui_order string @`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaAmmoCategoryPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaAmmoCategoryPrototype.help() end

---Control behavior for arithmetic combinators.
---@class LuaArithmeticCombinatorControlBehavior:LuaCombinatorControlBehavior
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---This arithmetic combinator's parameters.`[RW]`
---
---Writing `nil` clears the combinator's parameters.
---@field parameters ArithmeticCombinatorParameters
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaArithmeticCombinatorControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaArithmeticCombinatorControlBehavior.help() end

---Prototype of an autoplace control.
---@class LuaAutoplaceControlPrototype
---@field can_be_disabled boolean @`[R]`
---@field category string @Category name of this prototype.`[R]`
---@field control_order string @`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field richness boolean @`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaAutoplaceControlPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaAutoplaceControlPrototype.help() end

---Entry point for registering event handlers. It is accessible through the global object named `script`.
---@class LuaBootstrap
---A dictionary listing the names of all currently active mods and mapping them to their version.`[R]`
---
---This will print the names and versions of all active mods to the console. 
---```lua
---for name, version in pairs(script.active_mods) do
---  game.print(name .. " version " .. version)
---end
---```
---@field active_mods table<string, string>
---@field level LuaBootstrap.level @Information about the currently running scenario/campaign/tutorial.`[R]`
---@field mod_name string @The name of the mod from the environment this is used in.`[R]`
---@field object_name string @This object's name.`[R]`
local LuaBootstrap = {}

---Generate a new, unique event ID that can be used to raise custom events with [LuaBootstrap::raise_event](LuaBootstrap::raise_event).
---@return uint @The newly generated event ID.
function LuaBootstrap.generate_event_name() end

---Gets the filters for the given event.
---@param _event uint @ID of the event to get.
---@return EventFilter[] @The filters or `nil` if none are defined.
function LuaBootstrap.get_event_filter(_event) end

---Find the event handler for an event.
---@param _event uint @The event identifier to get a handler for.
---@return fun(_arg1:EventData) @Reference to the function currently registered as the handler, if it was found.
function LuaBootstrap.get_event_handler(_event) end

---Gets the mod event order as a string.
---@return string
function LuaBootstrap.get_event_order() end

---Register a function to be run when mod configuration changes. This is called when the major game version or any mod version changed, when any mod was added or removed, when a startup setting has changed, or when any prototypes have been added or removed. It allows the mod to make any changes it deems appropriate to both the data structures in its [global](global) table or to the game state through [LuaGameScript](LuaGameScript).
---
---For more context, refer to the [Data Lifecycle](data-lifecycle) page.
---@param _f fun(_arg1:ConfigurationChangedData) @The handler for this event. Passing `nil` will unregister it.
function LuaBootstrap.on_configuration_changed(_f) end

---Register a handler to run on the specified event(s). Each mod can only register once for every event, as any additional registration will overwrite the previous one. This holds true even if different filters are used for subsequent registrations.
---
---Register for the [on_tick](on_tick) event to print the current tick to console each tick. 
---```lua
---script.on_event(defines.events.on_tick,
---function(event) game.print(event.tick) end)
---```
---\
---Register for the [on_built_entity](on_built_entity) event, limiting it to only be received when a `"fast-inserter"` is built. 
---```lua
---script.on_event(defines.events.on_built_entity,
---function(event) game.print("Gotta go fast!") end,
---{{filter = "name", name = "fast-inserter"}})
---```
---@generic K
---@param _event defines.events|defines.events[]|string|K @The event(s) or custom-input to invoke the handler on.
---@param _f fun(event:K) @The handler for this event. Passing `nil` will unregister it.
---@param _filters? EventFilter[] @The filters for this event. Can only be used when registering for individual events.
function LuaBootstrap.on_event(_event, _f, _filters) end

---Register a function to be run on mod initialization. This is only called when a new save game is created or when a save file is loaded that previously didn't contain the mod. During it, the mod gets the chance to set up initial values that it will use for its lifetime. It has full access to [LuaGameScript](LuaGameScript) and the [global](global) table and can change anything about them that it deems appropriate. No other events will be raised for the mod until it has finished this step.
---
---For more context, refer to the [Data Lifecycle](data-lifecycle) page.
---
---Initialize a `players` table in `global` for later use. 
---```lua
---script.on_init(function()
---  global.players = {}
---end)
---```
---@param _f fun() @The handler for this event. Passing `nil` will unregister it.
function LuaBootstrap.on_init(_f) end

---Register a function to be run on save load. This is only called for mods that have been part of the save previously, or for players connecting to a running multiplayer session. It gives the mod the opportunity to do some very specific actions, should it need to. Doing anything other than these three will lead to desyncs, which breaks multiplayer and replay functionality. Access to [LuaGameScript](LuaGameScript) is not available. The [global](global) table can be accessed and is safe to read from, but not write to, as doing so will lead to an error.
---
---The only legitimate uses of this event are the following:
---- Re-setup [metatables](https://www.lua.org/pil/13.html) as they are not persisted through the save/load cycle.
---- Re-setup conditional event handlers, meaning subscribing to an event only when some condition is met to save processing time.
---- Create local references to data stored in the [global](global) table.
---
---For all other purposes, [LuaBootstrap::on_init](LuaBootstrap::on_init), [LuaBootstrap::on_configuration_changed](LuaBootstrap::on_configuration_changed) or [migrations](migrations) should be used instead.
---
---For more context, refer to the [Data Lifecycle](data-lifecycle) page.
---@param _f fun() @The handler for this event. Passing `nil` will unregister it.
function LuaBootstrap.on_load(_f) end

---Register a handler to run every nth-tick(s). When the game is on tick 0 it will trigger all registered handlers.
---@param _tick uint|uint[] @The nth-tick(s) to invoke the handler on. Passing `nil` as the only parameter will unregister all nth-tick handlers.
---@param _f fun(_arg1:NthTickEventData) @The handler to run. Passing `nil` will unregister it for the provided nth-tick(s).
function LuaBootstrap.on_nth_tick(_tick, _f) end

---@param _table LuaBootstrap.raise_biter_base_built
function LuaBootstrap.raise_biter_base_built(_table) end

---@param _table LuaBootstrap.raise_console_chat
function LuaBootstrap.raise_console_chat(_table) end

---Raise an event. Only events generated with [LuaBootstrap::generate_event_name](LuaBootstrap::generate_event_name) and the following can be raised:
---
---- [on_console_chat](on_console_chat)
---- [on_player_crafted_item](on_player_crafted_item)
---- [on_player_fast_transferred](on_player_fast_transferred)
---- [on_biter_base_built](on_biter_base_built)
---- [on_market_item_purchased](on_market_item_purchased)
---- [script_raised_built](script_raised_built)
---- [script_raised_destroy](script_raised_destroy)
---- [script_raised_revive](script_raised_revive)
---- [script_raised_set_tiles](script_raised_set_tiles)
---
---Raise the [on_console_chat](on_console_chat) event with the desired message 'from' the first player. 
---```lua
---local data = {player_index = 1, message = "Hello friends!"}
---script.raise_event(defines.events.on_console_chat, data)
---```
---@param _event uint @ID of the event to raise.
---@param _data table @Table with extra data that will be passed to the event handler. Any invalid LuaObjects will silently stop the event from being raised.
function LuaBootstrap.raise_event(_event, _data) end

---@param _table LuaBootstrap.raise_market_item_purchased
function LuaBootstrap.raise_market_item_purchased(_table) end

---@param _table LuaBootstrap.raise_player_crafted_item
function LuaBootstrap.raise_player_crafted_item(_table) end

---@param _table LuaBootstrap.raise_player_fast_transferred
function LuaBootstrap.raise_player_fast_transferred(_table) end

---@param _table LuaBootstrap.raise_script_built
function LuaBootstrap.raise_script_built(_table) end

---@param _table LuaBootstrap.raise_script_destroy
function LuaBootstrap.raise_script_destroy(_table) end

---@param _table LuaBootstrap.raise_script_revive
function LuaBootstrap.raise_script_revive(_table) end

---@param _table LuaBootstrap.raise_script_set_tiles
function LuaBootstrap.raise_script_set_tiles(_table) end

---Registers an entity so that after it's destroyed, [on_entity_destroyed](on_entity_destroyed) is called. Once an entity is registered, it stays registered until it is actually destroyed, even through save/load cycles. The registration is global across all mods, meaning once one mod registers an entity, all mods listening to [on_entity_destroyed](on_entity_destroyed) will receive the event when it is destroyed. Registering the same entity multiple times will still only fire the destruction event once, and will return the same registration number.
---
---Depending on when a given entity is destroyed, [on_entity_destroyed](on_entity_destroyed) will either be fired at the end of the current tick or at the end of the next tick.
---@param _entity LuaEntity @The entity to register.
---@return uint64 @The registration number. It is used to identify the entity in the [on_entity_destroyed](on_entity_destroyed) event.
function LuaBootstrap.register_on_entity_destroyed(_entity) end

---Sets the filters for the given event. The filters are only retained when set after the actual event registration, because registering for an event with different or no filters will overwrite previously set ones.
---
---Limit the [on_marked_for_deconstruction](on_marked_for_deconstruction) event to only be received when a non-ghost entity is marked for deconstruction. 
---```lua
---script.set_event_filter(defines.events.on_marked_for_deconstruction, {{filter = "ghost", invert = true}})
---```
---\
---Limit the [on_built_entity](on_built_entity) event to only be received when either a `unit` or a `unit-spawner` is built. 
---```lua
---script.set_event_filter(defines.events.on_built_entity, {{filter = "type", type = "unit"}, {filter = "type", type = "unit-spawner"}})
---```
---\
---Limit the [on_entity_damaged](on_entity_damaged) event to only be received when a `rail` is damaged by an `acid` attack. 
---```lua
---script.set_event_filter(defines.events.on_entity_damaged, {{filter = "rail"}, {filter = "damage-type", type = "acid", mode = "and"}})
---```
---@param _event uint @ID of the event to filter.
---@param _filters? EventFilter[] @The filters or `nil` to clear them.
function LuaBootstrap.set_event_filter(_event, _filters) end


---@class LuaBootstrap.level
---@field campaign_name? string @The campaign name if any.
---@field is_simulation? boolean @Is this level a simulation? (The main menu and 'Tips and tricks' use simulations)
---@field is_tutorial? boolean @Is this level a tutorial?
---@field level_name string @The level name.
---@field mod_name? string @The mod name if any.

---@class LuaBootstrap.raise_biter_base_built
---@field entity LuaEntity @The entity that was built.

---@class LuaBootstrap.raise_console_chat
---@field player_index uint @The player doing the chatting.
---@field message string @The chat message to send.

---@class LuaBootstrap.raise_market_item_purchased
---@field player_index uint @The player who did the purchasing.
---@field market LuaEntity @The market entity.
---@field offer_index uint @The index of the offer purchased.
---@field count uint @The amount of offers purchased.

---@class LuaBootstrap.raise_player_crafted_item
---@field item_stack LuaItemStack @The item that has been crafted.
---@field player_index uint @The player doing the crafting.
---@field recipe LuaRecipe @The recipe used to craft this item.

---@class LuaBootstrap.raise_player_fast_transferred
---@field player_index uint @The player transferred from or to.
---@field entity LuaEntity @The entity transferred from or to.
---@field from_player boolean @Whether the transfer was from player to entity. If `false`, the transfer was from entity to player.

---@class LuaBootstrap.raise_script_built
---@field entity LuaEntity @The entity that has been built.

---@class LuaBootstrap.raise_script_destroy
---@field entity LuaEntity @The entity that was destroyed.

---@class LuaBootstrap.raise_script_revive
---@field entity LuaEntity @The entity that was revived.
---@field tags? Tags @The tags associated with this entity, if any.

---@class LuaBootstrap.raise_script_set_tiles
---@field surface_index uint @The surface whose tiles have been changed.
---@field tiles Tile[] @The tiles that have been changed.

---A reference to the burner energy source owned by a specific [LuaEntity](LuaEntity) or [LuaEquipment](LuaEquipment).
---@class LuaBurner
---@field burnt_result_inventory LuaInventory @The burnt result inventory.`[R]`
---The currently burning item, or `nil` if no item is burning.`[RW]`
---
---Writing to this automatically handles correcting [LuaBurner::remaining_burning_fuel](LuaBurner::remaining_burning_fuel).
---@field currently_burning LuaItemPrototype
---The fuel categories this burner uses.`[R]`
---
---The value in the dictionary is meaningless and exists just to allow the dictionary type for easy lookup.
---@field fuel_categories table<string, boolean>
---@field heat double @The current heat (energy) stored in this burner.`[RW]`
---@field heat_capacity double @The maximum heat (maximum energy) that this burner can store.`[R]`
---@field inventory LuaInventory @The fuel inventory.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field owner LuaEntity|LuaEquipment @The owner of this burner energy source`[R]`
---The amount of energy left in the currently-burning fuel item.`[RW]`
---
---Writing to this will silently do nothing if there's no [LuaBurner::currently_burning](LuaBurner::currently_burning) set.
---@field remaining_burning_fuel double
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaBurner = {}

---All methods and properties that this object supports.
---@return string
function LuaBurner.help() end

---Prototype of a burner energy source.
---@class LuaBurnerPrototype
---@field burnt_inventory_size uint @`[R]`
---@field effectivity double @`[R]`
---@field emissions double @`[R]`
---`[R]`
---
---The value in the dictionary is meaningless and exists just to allow the dictionary type for easy lookup.
---@field fuel_categories table<string, boolean>
---@field fuel_inventory_size uint @`[R]`
---@field light_flicker LuaBurnerPrototype.light_flicker @The light flicker definition for this burner prototype if any.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field render_no_network_icon boolean @`[R]`
---@field render_no_power_icon boolean @`[R]`
---@field smoke SmokeSource[] @The smoke sources for this burner prototype if any.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaBurnerPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaBurnerPrototype.help() end


---@class LuaBurnerPrototype.light_flicker
---@field border_fix_speed float
---@field color Color
---@field derivation_change_deviation float
---@field derivation_change_frequency float
---@field light_intensity_to_size_coefficient float
---@field maximum_intensity float
---@field minimum_intensity float
---@field minimum_light_size float

---A chunk iterator can be used for iterating chunks coordinates of a surface.
---
---The returned type is a [ChunkPositionAndArea](ChunkPositionAndArea) containing the chunk coordinates and its area.
---
---```lua
---for chunk in some_surface.get_chunks() do
---  game.player.print("x: " .. chunk.x .. ", y: " .. chunk.y)
---  game.player.print("area: " .. serpent.line(chunk.area))
---end
---```
---@class LuaChunkIterator
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaChunkIterator = {}

---All methods and properties that this object supports.
---@return string
function LuaChunkIterator.help() end

---A circuit network associated with a given entity, connector, and wire type.
---@class LuaCircuitNetwork
---@field circuit_connector_id defines.circuit_connector_id @The circuit connector ID on the associated entity this network was gotten from.`[R]`
---@field connected_circuit_count uint @The number of circuits connected to this network.`[R]`
---@field entity LuaEntity @The entity this circuit network reference is associated with`[R]`
---@field network_id uint @The circuit networks ID.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field signals Signal[] @The circuit network signals last tick. `nil` if there are no signals.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field wire_type defines.wire_type @The wire type this network is associated with.`[R]`
local LuaCircuitNetwork = {}

---@param _signal SignalID @The signal to read.
---@return int @The current value of the signal.
function LuaCircuitNetwork.get_signal(_signal) end

---All methods and properties that this object supports.
---@return string
function LuaCircuitNetwork.help() end

---@class LuaCombinatorControlBehavior:LuaControlBehavior
---@field signals_last_tick Signal[] @The circuit network signals sent by this combinator last tick.`[R]`
local LuaCombinatorControlBehavior = {}

---Gets the value of a specific signal sent by this combinator behavior last tick or `nil` if the signal didn't exist.
---@param _signal SignalID @The signal to get
---@return int
function LuaCombinatorControlBehavior.get_signal_last_tick(_signal) end

---Allows for the registration of custom console commands. Similarly to [event subscriptions](LuaBootstrap::on_event), these don't persist through a save-and-load cycle.
---@class LuaCommandProcessor
---@field commands table<string, LocalisedString> @Lists the custom commands registered by scripts through `LuaCommandProcessor`.`[R]`
---@field game_commands table<string, LocalisedString> @Lists the built-in commands of the core game. The [wiki](https://wiki.factorio.com/Console) has an overview of these.`[R]`
---@field object_name string @This object's name.`[R]`
local LuaCommandProcessor = {}

---Add a custom console command.
---
---Trying to add a command with the `name` of a game command or the name of a custom command that is already in use will result in an error.
---
---This will register a custom event called `print_tick` that prints the current tick to either the player issuing the command or to everyone on the server, depending on the command parameter. It shows the usage of the table that gets passed to any function handling a custom command. This specific example makes use of the `tick` and the optional `player_index` and `parameter` fields. The user is supposed to either call it without any parameter (`"/print_tick"`) or with the `"me"` parameter (`"/print_tick me"`). 
---```lua
---commands.add_command("print_tick", nil, function(command)
---  if command.player_index ~= nil and command.parameter == "me" then
---    game.get_player(command.player_index).print(command.tick)
---  else
---    game.print(command.tick)
---  end
---end)
---```
---@param _name string @The desired name of the command (case sensitive).
---@param _help LocalisedString @The localised help message. It will be shown to players using the `/help` command.
---@param _function fun(_arg1:CustomCommandData) @The function that will be called when this command is invoked.
function LuaCommandProcessor.add_command(_name, _help, _function) end

---Remove a custom console command.
---@param _name string @The name of the command to remove (case sensitive).
---@return boolean @Whether the command was successfully removed. Returns `false` if the command didn't exist.
function LuaCommandProcessor.remove_command(_name) end

---Control behavior for constant combinators.
---@class LuaConstantCombinatorControlBehavior:LuaControlBehavior
---@field enabled boolean @Turns this constant combinator on and off.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---This constant combinator's parameters, or `nil` if the [item_slot_count](LuaEntityPrototype::item_slot_count) of the combinator's prototype is `0`.`[RW]`
---
---Writing `nil` clears the combinator's parameters.
---@field parameters ConstantCombinatorParameters[]
---@field signals_count uint @The number of signals this constant combinator supports`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaConstantCombinatorControlBehavior = {}

---Gets the signal at the given index. Returned [Signal](Signal) will not contain signal if none is set for the index.
---@param _index uint
---@return Signal
function LuaConstantCombinatorControlBehavior.get_signal(_index) end

---All methods and properties that this object supports.
---@return string
function LuaConstantCombinatorControlBehavior.help() end

---Sets the signal at the given index
---@param _index uint
---@param _signal Signal
function LuaConstantCombinatorControlBehavior.set_signal(_index, _signal) end

---Control behavior for container entities.
---@class LuaContainerControlBehavior:LuaControlBehavior
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaContainerControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaContainerControlBehavior.help() end

---This is an abstract base class containing the common functionality between [LuaPlayer](LuaPlayer) and entities (see [LuaEntity](LuaEntity)). When accessing player-related functions through a [LuaEntity](LuaEntity), it must refer to a character entity.
---@class LuaControl
---@field build_distance uint @The build distance of this character or max uint when not a character or player connected to a character.`[R]`
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_additional_mining_categories string[]
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_build_distance_bonus uint
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_crafting_speed_modifier double
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_health_bonus float
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_inventory_slots_bonus uint
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_item_drop_distance_bonus uint
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_item_pickup_distance_bonus uint
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_loot_pickup_distance_bonus uint
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_maximum_following_robot_count_bonus uint
---@field character_mining_progress double @Gets the current mining progress between 0 and 1 of this character, or 0 if they aren't mining.`[R]`
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_mining_speed_modifier double
---@field character_personal_logistic_requests_enabled boolean @If personal logistic requests are enabled for this character or players character.`[RW]`
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_reach_distance_bonus uint
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_resource_reach_distance_bonus uint
---@field character_running_speed double @Gets the current movement speed of this character, including effects from exoskeletons, tiles, stickers and shooting.`[R]`
---Modifies the running speed of this character by the given value as a percentage. Setting the running modifier to `0.5` makes the character run 50% faster. The minimum value of `-1` reduces the movement speed by 100%, resulting in a speed of `0`.`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_running_speed_modifier double
---`[RW]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character (see [LuaPlayer::character](LuaPlayer::character)).
---@field character_trash_slot_count_bonus uint
---@field cheat_mode boolean @When `true` hand crafting is free and instant`[RW]`
---@field crafting_queue CraftingQueueItem[] @Gets the current crafting queue items.`[R]`
---@field crafting_queue_progress double @The crafting queue progress [0-1] 0 when no recipe is being crafted.`[RW]`
---@field crafting_queue_size uint @Size of the crafting queue.`[R]`
---The ghost prototype in the player's cursor.`[RW]`
---
---When read, it will be a [LuaItemPrototype](LuaItemPrototype).
---\
---Items in the cursor stack will take priority over the cursor ghost.
---@field cursor_ghost ItemPrototypeIdentification
---The player's cursor stack, or `nil` if the player controller is a spectator. Even though this property is marked as read-only, it returns a [LuaItemStack](LuaItemStack), meaning it can be manipulated like so:`[R]`
---
---```lua
---player.cursor_stack.clear()
---```
---@field cursor_stack LuaItemStack
---@field driving boolean @`true` if the player is in a vehicle. Writing to this attribute puts the player in or out of a vehicle.`[RW]`
---@field drop_item_distance uint @The item drop distance of this character or max uint when not a character or player connected to a character.`[R]`
---The current combat robots following the character`[R]`
---
---When called on a [LuaPlayer](LuaPlayer), it must be associated with a character(see [LuaPlayer::character](LuaPlayer::character)).
---@field following_robots LuaEntity[]
---@field force ForceIdentification @The force of this entity. Reading will always give a [LuaForce](LuaForce), but it is possible to assign either [string](string) or [LuaForce](LuaForce) to this attribute to change the force.`[RW]`
---@field in_combat boolean @If this character entity is in combat.`[R]`
---@field item_pickup_distance double @The item pickup distance of this character or max double when not a character or player connected to a character.`[R]`
---@field loot_pickup_distance double @The loot pickup distance of this character or max double when not a character or player connected to a character.`[R]`
---Current mining state.`[RW]`
---
---When the player isn't mining tiles the player will mine what ever entity is currently selected. See [LuaControl::selected](LuaControl::selected) and [LuaControl::update_selected_entity](LuaControl::update_selected_entity).
---@field mining_state LuaControl.mining_state
---The GUI the player currently has open, or `nil` if no GUI is open.
---
---This is the GUI that will asked to close (by firing the [on_gui_closed](on_gui_closed) event) when the `Esc` or `E` keys are pressed. If this attribute is not `nil`, and a new GUI is written to it, the existing one will be asked to close.`[RW]`
---
---Write supports any of the types. Read will return the `entity`, `equipment`, `equipment-grid`, `player`, `element` or `nil`.
---@field opened LuaEntity|LuaItemStack|LuaEquipment|LuaEquipmentGrid|LuaPlayer|LuaGuiElement|defines.gui_type
---@field opened_gui_type defines.gui_type @Returns the [defines.gui_type](defines.gui_type) or `nil`.`[R]`
---@field picking_state boolean @Current item-picking state.`[RW]`
---@field position MapPosition @Current position of the entity.`[R]`
---@field reach_distance uint @The reach distance of this character or max uint when not a character or player connected to a character.`[R]`
---@field repair_state LuaControl.repair_state @Current repair state.`[RW]`
---@field resource_reach_distance double @The resource reach distance of this character or max double when not a character or player connected to a character.`[R]`
---@field riding_state RidingState @Current riding state of this car or the vehicle this player is riding in.`[RW]`
---@field selected LuaEntity @The currently selected entity; `nil` if none. Assigning an entity will select it if selectable otherwise clears selection.`[RW]`
---@field shooting_state LuaControl.shooting_state @Current shooting state.`[RW]`
---@field surface LuaSurface @The surface this entity is currently on.`[R]`
---@field vehicle LuaEntity @The vehicle the player is currently sitting in; `nil` if none.`[R]`
---@field vehicle_logistic_requests_enabled boolean @If personal logistic requests are enabled for this vehicle (spidertron).`[RW]`
---Current walking state.`[RW]`
---
---Make the player go north. Note that a one-shot action like this will only make the player walk for one tick. 
---```lua
---game.player.walking_state = {walking = true, direction = defines.direction.north}
---```
---@field walking_state LuaControl.walking_state
local LuaControl = {}

---Begins crafting the given count of the given recipe.
---@param _table LuaControl.begin_crafting
---@return uint @The count that was actually started crafting.
function LuaControl.begin_crafting(_table) end

---Can at least some items be inserted?
---@param _items ItemStackIdentification @Items that would be inserted.
---@return boolean @`true` if at least a part of the given items could be inserted into this inventory.
function LuaControl.can_insert(_items) end

---Can a given entity be opened or accessed?
---@param _entity LuaEntity
---@return boolean
function LuaControl.can_reach_entity(_entity) end

---Cancels crafting the given count of the given crafting queue index.
---@param _table LuaControl.cancel_crafting
function LuaControl.cancel_crafting(_table) end

---Removes the arrow created by `set_gui_arrow`.
function LuaControl.clear_gui_arrow() end

---Remove all items from this entity.
function LuaControl.clear_items_inside() end

---
---This will silently fail if personal logistics are not researched yet.
---@param _slot_index uint @The slot to clear.
function LuaControl.clear_personal_logistic_slot(_slot_index) end

---Unselect any selected entity.
function LuaControl.clear_selected_entity() end

---
---This will silently fail if the vehicle does not use logistics.
---@param _slot_index uint @The slot to clear.
function LuaControl.clear_vehicle_logistic_slot(_slot_index) end

---Disable the flashlight.
function LuaControl.disable_flashlight() end

---Enable the flashlight.
function LuaControl.enable_flashlight() end

---Gets the entities that are part of the currently selected blueprint, regardless of it being in a blueprint book or picked from the blueprint library.
---@return BlueprintEntity[] @Returns `nil` if there is no currently selected blueprint.
function LuaControl.get_blueprint_entities() end

---Gets the count of the given recipe that can be crafted.
---@param _recipe string|LuaRecipe @The recipe.
---@return uint @The count that can be crafted.
function LuaControl.get_craftable_count(_recipe) end

---Get an inventory belonging to this entity. This can be either the "main" inventory or some auxiliary one, like the module slots or logistic trash slots.
---
---A given [defines.inventory](defines.inventory) is only meaningful for the corresponding LuaObject type. EG: get_inventory(defines.inventory.character_main) is only meaningful if 'this' is a player character. You may get a value back but if the type of 'this' isn't the type referred to by the [defines.inventory](defines.inventory) it's almost guaranteed to not be the inventory asked for.
---@param _inventory defines.inventory
---@return LuaInventory @The inventory or `nil` if none with the given index was found.
function LuaControl.get_inventory(_inventory) end

---Get the number of all or some items in this entity.
---@param _item? string @Prototype name of the item to count. If not specified, count all items.
---@return uint
function LuaControl.get_item_count(_item) end

---Gets the main inventory for this character or player if this is a character or player.
---@return LuaInventory @The inventory or `nil` if this entity is not a character or player.
function LuaControl.get_main_inventory() end

---Gets the parameters of a personal logistic request and auto-trash slot. Only used on `spider-vehicle`.
---@param _slot_index uint @The slot to get.
---@return LogisticParameters @The logistic parameters. If personal logistics are not researched yet, their `name` will be `nil`.
function LuaControl.get_personal_logistic_slot(_slot_index) end

---Gets the parameters of a vehicle logistic request and auto-trash slot.
---@param _slot_index uint @The slot to get.
---@return LogisticParameters @The logistic parameters. If the vehicle does not use logistics, their `name` will be `nil`.
function LuaControl.get_vehicle_logistic_slot(_slot_index) end

---Does this entity have any item inside it?
---@return boolean
function LuaControl.has_items_inside() end

---Insert items into this entity. This works the same way as inserters or shift-clicking: the "best" inventory is chosen automatically.
---@param _items ItemStackIdentification @The items to insert.
---@return uint @The number of items that were actually inserted.
function LuaControl.insert(_items) end

---Returns whether the player is holding a blueprint. This takes both blueprint items as well as blueprint records from the blueprint library into account.
---
---Note that both this method and [LuaControl::get_blueprint_entities](LuaControl::get_blueprint_entities) refer to the currently selected blueprint, meaning a blueprint book with a selected blueprint will return the information as well.
---@return boolean
function LuaControl.is_cursor_blueprint() end

---Returns whether the player is holding something in the cursor. It takes into account items from the blueprint library, as well as items and ghost cursor.
---@return boolean
function LuaControl.is_cursor_empty() end

---Is the flashlight enabled.
---@return boolean
function LuaControl.is_flashlight_enabled() end

---When `true` control adapter is a LuaPlayer object, `false` for entities including characters with players.
---@return boolean
function LuaControl.is_player() end

---Mines the given entity as if this player (or character) mined it.
---@param _entity LuaEntity @The entity to mine
---@param _force? boolean @Forces mining the entity even if the items can't fit in the player.
---@return boolean @Whether the mining succeeded.
function LuaControl.mine_entity(_entity, _force) end

---Mines the given tile as if this player (or character) mined it.
---@param _tile LuaTile @The tile to mine.
---@return boolean @Whether the mining succeeded.
function LuaControl.mine_tile(_tile) end

---Open the technology GUI and select a given technology.
---@param _technology? TechnologyIdentification @The technology to select after opening the GUI.
function LuaControl.open_technology_gui(_technology) end

---Remove items from this entity.
---@param _items ItemStackIdentification @The items to remove.
---@return uint @The number of items that were actually removed.
function LuaControl.remove_item(_items) end

---Create an arrow which points at this entity. This is used in the tutorial. For examples, see `control.lua` in the campaign missions.
---@param _table LuaControl.set_gui_arrow
function LuaControl.set_gui_arrow(_table) end

---Sets a personal logistic request and auto-trash slot to the given value.
---
---This will silently fail if personal logistics are not researched yet.
---@param _slot_index uint @The slot to set.
---@param _value LogisticParameters @The logistic request parameters.
---@return boolean @Whether the slot was set successfully. `false` if personal logistics are not researched yet.
function LuaControl.set_personal_logistic_slot(_slot_index, _value) end

---Sets a vehicle logistic request and auto-trash slot to the given value. Only used on `spider-vehicle`.
---@param _slot_index uint @The slot to set.
---@param _value LogisticParameters @The logistic request parameters.
---@return boolean @Whether the slot was set successfully. `false` if the vehicle does not use logistics.
function LuaControl.set_vehicle_logistic_slot(_slot_index, _value) end

---Teleport the entity to a given position, possibly on another surface.
---
---Some entities may not be teleported. For instance, transport belts won't allow teleportation and this method will always return `false` when used on any such entity.
---\
---You can also pass 1 or 2 numbers as the parameters and they will be used as relative teleport coordinates `'teleport(0, 1)'` to move the entity 1 tile positive y. `'teleport(4)'` to move the entity 4 tiles to the positive x.
---@param _position MapPosition @Where to teleport to.
---@param _surface? SurfaceIdentification @Surface to teleport to. If not given, will teleport to the entity's current surface. Only players, cars, and spidertrons can be teleported cross-surface.
---@return boolean @`true` if the entity was successfully teleported.
function LuaControl.teleport(_position, _surface) end

---Select an entity, as if by hovering the mouse above it.
---@param _position MapPosition @Position of the entity to select.
function LuaControl.update_selected_entity(_position) end


---@class LuaControl.mining_state
---@field mining boolean @Whether the player is mining at all
---@field position? MapPosition @What tiles the player is mining; only used when the player is mining tiles (holding a tile in the cursor).

---@class LuaControl.repair_state
---@field position MapPosition @The position being repaired
---@field repairing boolean @The current state

---@class LuaControl.shooting_state
---@field position MapPosition @The position being shot at
---@field state defines.shooting @The current state

---@class LuaControl.walking_state
---@field direction defines.direction @Direction where the player is walking
---@field walking boolean @If `false`, the player is currently not walking; otherwise it's going somewhere

---@class LuaControl.begin_crafting
---@field count uint @The count to craft.
---@field recipe string|LuaRecipe @The recipe to craft.
---@field silent? boolean @If false and the recipe can't be crafted the requested number of times printing the failure is skipped.

---@class LuaControl.cancel_crafting
---@field index uint @The crafting queue index.
---@field count uint @The count to cancel crafting.

---@class LuaControl.set_gui_arrow
---@field type string @Where to point to. This field determines what other fields are mandatory. May be `"nowhere"`, `"goal"`, `"entity_info"`, `"active_window"`, `"entity"`, `"position"`, `"crafting_queue"`, or `"item_stack"`.

---The control behavior for an entity. Inserters have logistic network and circuit network behavior logic, lamps have circuit logic and so on. This is an abstract base class that concrete control behaviors inherit.
---
---An control reference becomes invalid once the control behavior is removed or the entity (see [LuaEntity](LuaEntity)) it resides in is destroyed.
---@class LuaControlBehavior
---@field entity LuaEntity @The entity this control behavior belongs to.`[R]`
---@field type defines.control_behavior.type @The concrete type of this control behavior.`[R]`
local LuaControlBehavior = {}

---@param _wire defines.wire_type @Wire color of the network connected to this entity.
---@param _circuit_connector? defines.circuit_connector_id @The connector to get circuit network for. Must be specified for entities with more than one circuit network connector.
---@return LuaCircuitNetwork @The circuit network or nil.
function LuaControlBehavior.get_circuit_network(_wire, _circuit_connector) end

---A custom tag that shows on the map view.
---@class LuaCustomChartTag
---@field force LuaForce @The force this tag belongs to.`[R]`
---@field icon SignalID @This tag's icon, if it has one. Writing `nil` removes it.`[RW]`
---@field last_user LuaPlayer @The player who last edited this tag.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field position MapPosition @The position of this tag.`[R]`
---@field surface LuaSurface @The surface this tag belongs to.`[R]`
---@field tag_number uint @The unique ID for this tag on this force.`[R]`
---@field text string @`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaCustomChartTag = {}

---Destroys this tag.
function LuaCustomChartTag.destroy() end

---All methods and properties that this object supports.
---@return string
function LuaCustomChartTag.help() end

---Prototype of a custom input.
---@class LuaCustomInputPrototype
---@field action string @The action that happens when this custom input is triggered.`[R]`
---@field alternative_key_sequence string @The default alternative key sequence for this custom input. `nil` when not defined.`[R]`
---@field consuming string @The consuming type: `"none"` or `"game-only"`.`[R]`
---@field enabled boolean @Whether this custom input is enabled. Disabled custom inputs exist but are not used by the game.`[R]`
---@field enabled_while_in_cutscene boolean @Whether this custom input is enabled while using the cutscene controller.`[R]`
---@field enabled_while_spectating boolean @Whether this custom input is enabled while using the spectator controller.`[R]`
---@field include_selected_prototype boolean @Whether this custom input will include the selected prototype (if any) when triggered.`[R]`
---@field item_to_spawn LuaItemPrototype @The item that gets spawned when this custom input is fired or `nil`.`[R]`
---@field key_sequence string @The default key sequence for this custom input.`[R]`
---@field linked_game_control string @The linked game control name or `nil`.`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaCustomInputPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaCustomInputPrototype.help() end

---Lazily evaluated table. For performance reasons, we sometimes return a custom table-like type instead of a native Lua table. This custom type lazily constructs the necessary Lua wrappers of the corresponding C++ objects, therefore preventing their unnecessary construction in some cases.
---
---There are some notable consequences to the usage of a custom table type rather than the native Lua table type: Iterating a custom table is only possible using the `pairs` Lua function; `ipairs` won't work. Another key difference is that custom tables cannot be serialised into a game save file -- if saving the game would require serialisation of a custom table, an error will be displayed and the game will not be saved.
---
---In previous versions of Factorio, this would create a [LuaPlayer](LuaPlayer) instance for every player in the game, even though only one such wrapper is needed. In the current version, accessing [game.players](LuaGameScript::players) by itself does not create any [LuaPlayer](LuaPlayer) instances; they are created lazily when accessed. Therefore, this example only constructs one [LuaPlayer](LuaPlayer) instance, no matter how many elements there are in `game.players`. 
---```lua
---game.players["Oxyd"].character.die()
---```
---\
---Custom tables may be iterated using `pairs`. 
---```lua
---for _, p in pairs(game.players) do game.player.print(p.name); end
---```
---\
---The following will produce no output because `ipairs` is not supported with custom tables. 
---```lua
---for _, p in ipairs(game.players) do game.player.print(p.name); end  -- incorrect; use pairs instead
---```
---\
---This statement will execute successfully and `global.p` will be useable as one might expect. However, as soon as the user tries to save the game, a "LuaCustomTable cannot be serialized" error will be shown. The game will remain unsaveable so long as `global.p` refers to an instance of a custom table. 
---```lua
---global.p = game.players  -- This has high potential to make the game unsaveable
---```
---@class LuaCustomTable
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field [number] Any @Access an element of this custom table.`[RW]`
local LuaCustomTable = {}

---All methods and properties that this object supports.
---@return string
function LuaCustomTable.help() end

---Prototype of a damage.
---@class LuaDamagePrototype
---@field hidden boolean @Whether this damage type is hidden from entity tooltips.`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaDamagePrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaDamagePrototype.help() end

---Control behavior for decider combinators.
---@class LuaDeciderCombinatorControlBehavior:LuaCombinatorControlBehavior
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---This decider combinator's parameters.`[RW]`
---
---Writing `nil` clears the combinator's parameters.
---@field parameters DeciderCombinatorParameters
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaDeciderCombinatorControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaDeciderCombinatorControlBehavior.help() end

---Prototype of an optimized decorative.
---@class LuaDecorativePrototype
---@field autoplace_specification AutoplaceSpecification @Autoplace specification for this decorative prototype. `nil` if none.`[R]`
---@field collision_box BoundingBox @The bounding box used for collision checking.`[R]`
---@field collision_mask CollisionMask @The collision masks this decorative uses`[R]`
---@field collision_mask_with_flags CollisionMaskWithFlags @`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaDecorativePrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaDecorativePrototype.help() end

---Prototype of an electric energy source.
---@class LuaElectricEnergySourcePrototype
---@field buffer_capacity double @`[R]`
---@field drain double @`[R]`
---@field emissions double @`[R]`
---@field input_flow_limit double @`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field output_flow_limit double @`[R]`
---@field render_no_network_icon boolean @`[R]`
---@field render_no_power_icon boolean @`[R]`
---@field usage_priority string @`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaElectricEnergySourcePrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaElectricEnergySourcePrototype.help() end

---The primary interface for interacting with entities through the Lua API. Entities are everything that exists on the map except for tiles (see [LuaTile](LuaTile)).
---
---Most functions on LuaEntity also work when the entity is contained in a ghost.
---@class LuaEntity:LuaControl
---Deactivating an entity will stop all its operations (car will stop moving, inserters will stop working, fish will stop moving etc).`[RW]`
---
---Entities that are not active naturally can't be set to be active (setting it to be active will do nothing)
---\
---Ghosts, simple smoke, and corpses can't be modified at this time.
---\
---It is even possible to set the character to not be active, so he can't move and perform most of the tasks.
---@field active boolean
---@field ai_settings LuaAISettings @The ai settings of this unit.`[R]`
---@field alert_parameters ProgrammableSpeakerAlertParameters @`[RW]`
---@field allow_dispatching_robots boolean @Whether this character's personal roboports are allowed to dispatch robots.`[RW]`
---@field amount uint @Count of resource units contained.`[RW]`
---@field armed boolean @If this land mine is armed.`[R]`
---The player this character is associated with, or `nil` if there isn't one. Set to `nil` to clear.
---
---The player will be automatically disassociated when a controller is set on the character. Also, all characters associated to a player will be logged off when the player logs off in multiplayer.
---
---Reading this property will return a [LuaPlayer](LuaPlayer), while [PlayerIdentification](PlayerIdentification) can be used when writing.`[RW]`
---
---A character associated with a player is not directly controlled by any player.
---@field associated_player LuaPlayer|PlayerIdentification
---@field auto_launch boolean @Whether this rocket silo automatically launches the rocket when cargo is inserted.`[RW]`
---@field autopilot_destination MapPosition @Destination position of spidertron's autopilot. Returns `nil` if autopilot doesn't have destination set.`[RW]`
---@field autopilot_destinations MapPosition[] @The queued destination positions of spidertron's autopilot.`[R]`
---The backer name assigned to this entity, or `nil` if this entity doesn't support backer names. Entities that support backer names are labs, locomotives, radars, roboports, and train stops.`[RW]`
---
---While train stops get the name of a backer when placed down, players can rename them if they want to. In this case, `backer_name` returns the player-given name of the entity.
---@field backer_name string
---@field belt_neighbours table<string, LuaEntity[]> @The belt connectable neighbours of this belt connectable entity. Only entities that input to or are outputs of this entity. Does not contain the other end of an underground belt, see [LuaEntity::neighbours](LuaEntity::neighbours) for that. This is a dictionary with `"inputs"`, `"outputs"` entries that are arrays of transport belt connectable entities, or empty tables if no entities.`[R]`
---@field belt_to_ground_type string @`"input"` or `"output"`, depending on whether this underground belt goes down or up.`[R]`
---@field bonus_mining_progress double @The bonus mining progress for this mining drill or `nil` if this isn't a mining drill. Read yields a number in range [0, mining_target.prototype.mineable_properties.mining_time]`[RW]`
---@field bonus_progress double @The current productivity bonus progress, as a number in range [0, 1].`[RW]`
---@field bounding_box BoundingBox @[LuaEntityPrototype::collision_box](LuaEntityPrototype::collision_box) around entity's given position and respecting the current entity orientation.`[R]`
---@field burner LuaBurner @The burner energy source for this entity or `nil` if there isn't one.`[R]`
---@field chain_signal_state defines.chain_signal_state @The state of this chain signal.`[R]`
---@field character_corpse_death_cause LocalisedString @The reason this character corpse character died (if any).`[RW]`
---The player index associated with this character corpse.`[RW]`
---
---The index is not guaranteed to be valid so it should always be checked first if a player with that index actually exists.
---@field character_corpse_player_index uint
---@field character_corpse_tick_of_death uint @The tick this character corpse died at.`[RW]`
---@field circuit_connected_entities LuaEntity.circuit_connected_entities @Entities that are directly connected to this entity via the circuit network.`[R]`
---@field circuit_connection_definitions CircuitConnectionDefinition[] @The connection definition for entities that are directly connected to this entity via the circuit network.`[R]`
---@field cliff_orientation CliffOrientation @The orientation of this cliff.`[R]`
---The character, rolling stock, train stop, car, spider-vehicle, flying text, corpse or simple-entity-with-owner color. Returns `nil` if this entity doesn't use custom colors.`[RW]`
---
---Car color is overridden by the color of the current driver/passenger, if there is one.
---@field color Color
---@field combat_robot_owner LuaEntity @The owner of this combat robot if any.`[RW]`
---@field command Command @The command given to this unit or `nil` is the unit has no command.`[R]`
---@field connected_rail LuaEntity @The rail entity this train stop is connected to or `nil` if there is none.`[R]`
---@field connected_rail_direction defines.rail_direction @Rail direction to which this train stop is binding. This returns a value even when no rails are present.`[R]`
---@field consumption_bonus double @The consumption bonus of this entity.`[R]`
---@field consumption_modifier float @Multiplies the energy consumption.`[RW]`
---Whether this corpse will ever fade away.`[RW]`
---
---Useable only on corpses.
---@field corpse_expires boolean
---If true, corpse won't be destroyed when entities are placed over it. If false, whether corpse will be removed or not depends on value of CorpsePrototype::remove_on_entity_placement.`[RW]`
---
---Useable only on corpses.
---@field corpse_immune_to_entity_placement boolean
---@field crafting_progress float @The current crafting progress, as a number in range [0, 1].`[RW]`
---@field crafting_speed double @The current crafting speed, including speed bonuses from modules and beacons.`[R]`
---@field damage_dealt double @The damage dealt by this turret, artillery turret, or artillery wagon.`[RW]`
---If set to `false`, this entity can't be damaged and won't be attacked automatically. It can however still be mined.`[RW]`
---
---Entities that are indestructible naturally (they have no health, like smoke, resource etc) can't be set to be destructible.
---@field destructible boolean
---@field direction defines.direction @The current direction this entity is facing.`[RW]`
---@field distraction_command Command @The distraction command given to this unit or `nil` is the unit currently isn't distracted.`[R]`
---@field driver_is_gunner boolean @Whether the driver of this car or spidertron is the gunner, if false, the passenger is the gunner.`[RW]`
---Position where the entity puts its stuff.`[RW]`
---
---Meaningful only for entities that put stuff somewhere, such as mining drills or inserters. Mining drills can't have their drop position changed; inserters must have `allow_custom_vectors` set to true on their prototype to allow changing the drop position.
---@field drop_position MapPosition
---The entity this entity is putting its items to, or `nil` if there is no such entity. If there are multiple possible entities at the drop-off point, writing to this attribute allows a mod to choose which one to drop off items to. The entity needs to collide with the tile box under the drop-off position.`[RW]`
---
---Meaningful only for entities that put items somewhere, such as mining drills or inserters. Returns `nil` for any other entity.
---@field drop_target LuaEntity
---@field effective_speed float @The current speed of this unit in tiles per tick, taking into account any walking speed modifier given by the tile the unit is standing on.`[R]`
---@field effectivity_modifier float @Multiplies the acceleration the vehicle can create for one unit of energy. By default is `1`.`[RW]`
---@field effects ModuleEffects @The effects being applied to this entity or `nil`. For beacons this is the effect the beacon is broadcasting.`[R]`
---The buffer size for the electric energy source or nil if the entity doesn't have an electric energy source.`[RW]`
---
---Write access is limited to the ElectricEnergyInterface type
---@field electric_buffer_size double
---@field electric_drain double @The electric drain for the electric energy source or nil if the entity doesn't have an electric energy source.`[R]`
---@field electric_emissions double @The emissions for the electric energy source or nil if the entity doesn't have an electric energy source.`[R]`
---@field electric_input_flow_limit double @The input flow limit for the electric energy source or nil if the entity doesn't have an electric energy source.`[R]`
---@field electric_network_id uint @Returns the id of the electric network that this entity is connected to or `nil`.`[R]`
---@field electric_network_statistics LuaFlowStatistics @The electric network statistics for this electric pole.`[R]`
---@field electric_output_flow_limit double @The output flow limit for the electric energy source or nil if the entity doesn't have an electric energy source.`[R]`
---@field enable_logistics_while_moving boolean @If equipment grid logistics are enabled while this vehicle is moving.`[RW]`
---Energy stored in the entity (heat in furnace, energy stored in electrical devices etc.). always 0 for entities that don't have the concept of energy stored inside.`[RW]`
---
---```lua
---game.player.print("Machine energy: " .. game.player.selected.energy .. "J")
---game.player.selected.energy = 3000
---```
---@field energy double
---@field energy_generated_last_tick double @How much energy this generator generated in the last tick.`[R]`
---The label of this entity if it has one or `nil`. Changing the value will trigger on_entity_renamed event`[RW]`
---
---only usable on entities that have labels (currently only spider-vehicles).
---@field entity_label string
---@field filter_slot_count uint @The number of filter slots this inserter, loader, or logistic storage container has. 0 if not one of those entities.`[R]`
---@field fluidbox LuaFluidBox @Fluidboxes of this entity.`[RW]`
---@field follow_offset Vector @The follow offset of this spidertron if any. If it is not following an entity this will be nil. This is randomized each time the follow entity is set.`[RW]`
---@field follow_target LuaEntity @The follow target of this spidertron if any.`[RW]`
---Multiplies the car friction rate.`[RW]`
---
---This will allow the car to go much faster 
---```lua
---game.player.vehicle.friction_modifier = 0.5
---```
---@field friction_modifier float
---@field ghost_localised_description LocalisedString @`[R]`
---@field ghost_localised_name LocalisedString @Localised name of the entity or tile contained in this ghost.`[R]`
---@field ghost_name string @Name of the entity or tile contained in this ghost`[R]`
---@field ghost_prototype LuaEntityPrototype|LuaTilePrototype @The prototype of the entity or tile contained in this ghost.`[R]`
---@field ghost_type string @The prototype type of the entity or tile contained in this ghost.`[R]`
---@field ghost_unit_number uint @The [unit_number](LuaEntity::unit_number) of the entity contained in this ghost. It is the same as the unit number of the [EntityWithOwner](https://wiki.factorio.com/Prototype/EntityWithOwner) that was destroyed to create this ghost. If it was created by other means, or if the inner entity doesn not support unit numbers, this property is `nil`.`[R]`
---@field graphics_variation uint8 @The graphics variation for this entity or `nil` if this entity doesn't use graphics variations.`[RW]`
---@field grid LuaEquipmentGrid @The equipment grid or `nil` if this entity doesn't have an equipment grid.`[R]`
---The current health of the entity, or `nil` if it doesn't have health. Health is automatically clamped to be between `0` and max health (inclusive). Entities with a health of `0` can not be attacked.`[RW]`
---
---To get the maximum possible health of this entity, see [LuaEntityPrototype::max_health](LuaEntityPrototype::max_health) on its prototype.
---@field health float
---@field held_stack LuaItemStack @The item stack currently held in an inserter's hand.`[R]`
---@field held_stack_position MapPosition @Current position of the inserter's "hand".`[R]`
---@field highlight_box_blink_interval uint @The blink interval of this highlight box entity. 0 indicates no blink.`[RW]`
---@field highlight_box_type string @The hightlight box type of this highlight box entity.`[RW]`
---@field infinity_container_filters InfinityInventoryFilter[] @The filters for this infinity container.`[RW]`
---Count of initial resource units contained.`[RW]`
---
---If this is not an infinite resource reading will give `nil` and writing will give an error.
---@field initial_amount uint
---@field inserter_filter_mode string @The filter mode for this filter inserter: "whitelist", "blacklist", or `nil` if this inserter doesn't use filters.`[RW]`
---Sets the stack size limit on this inserter. If the stack size is > than the force stack size limit the value is ignored.`[RW]`
---
---Set to 0 to reset.
---@field inserter_stack_size_override uint
---@field is_entity_with_force boolean @(deprecated by 1.1.51) If this entity is a MilitaryTarget. Returns same value as LuaEntity::is_military_target`[R]`
---@field is_entity_with_health boolean @If this entity is EntityWithHealth`[R]`
---@field is_entity_with_owner boolean @If this entity is EntityWithOwner`[R]`
---@field is_military_target boolean @If this entity is a MilitaryTarget. Can be written to if LuaEntityPrototype::allow_run_time_change_of_is_military_target returns true`[RW]`
---@field item_requests table<string, uint> @Items this ghost will request when revived or items this item request proxy is requesting. Result is a dictionary mapping each item prototype name to the required count.`[RW]`
---@field kills uint @The number of units killed by this turret, artillery turret, or artillery wagon.`[RW]`
---The last player that changed any setting on this entity. This includes building the entity, changing its color, or configuring its circuit network. Can be `nil` if the last user is not part of the save anymore.
---
---Reading this property will return a [LuaPlayer](LuaPlayer), while [PlayerIdentification](PlayerIdentification) can be used when writing.`[RW]`
---@field last_user LuaPlayer|PlayerIdentification
---@field link_id uint @The link ID this linked container is using.`[RW]`
---Neighbour to which this linked belt is connected to. Returns nil if not connected.`[R]`
---
---Can also be used on entity ghost if it contains linked-belt
---\
---May return entity ghost which contains linked belt to which connection is made
---@field linked_belt_neighbour LuaEntity
---Type of linked belt: it is either `"input"` or `"output"`. Changing type will also flip direction so the belt is out of the same side`[RW]`
---
---Can only be changed when linked belt is disconnected (has no neighbour set)
---\
---Can also be used on entity ghost if it contains linked-belt
---@field linked_belt_type string
---@field loader_container LuaEntity @The container entity this loader is pointing at/pulling from depending on the [LuaEntity::loader_type](LuaEntity::loader_type).`[R]`
---@field loader_type string @`"input"` or `"output"`, depending on whether this loader puts to or gets from a container.`[RW]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @Localised name of the entity.`[R]`
---@field logistic_cell LuaLogisticCell @The logistic cell this entity is a part of. Will be `nil` if this entity is not a part of any logistic cell.`[R]`
---@field logistic_network LuaLogisticNetwork @The logistic network this entity is a part of, or `nil` if this entity is not a part of any logistic network.`[RW]`
---`[RW]`
---
---Not minable entities can still be destroyed.
---\
---Entities that are not minable naturally (like smoke, character, enemy units etc) can't be set to minable.
---@field minable boolean
---@field mining_progress double @The mining progress for this mining drill or `nil` if this isn't a mining drill. Is a number in range [0, mining_target.prototype.mineable_properties.mining_time]`[RW]`
---@field mining_target LuaEntity @The mining target or `nil` if none`[R]`
---@field moving boolean @Returns true if this unit is moving.`[R]`
---@field name string @Name of the entity prototype. E.g. "inserter" or "filter-inserter".`[R]`
---@field neighbour_bonus double @The current total neighbour bonus of this reactor.`[R]`
---A list of neighbours for certain types of entities. Applies to electric poles, power switches, underground belts, walls, gates, reactors, cliffs, and pipe-connectable entities.
---
---- When called on an electric pole, this is a dictionary of all connections, indexed by the strings `"copper"`, `"red"`, and `"green"`.
---- When called on a pipe-connectable entity, this is an array of entity arrays of all entities a given fluidbox is connected to.
---- When called on an underground transport belt, this is the other end of the underground belt connection, or `nil` if none.
---- When called on a wall-connectable entity or reactor, this is a dictionary of all connections indexed by the connection direction "north", "south", "east", and "west".
---- When called on a cliff entity, this is a dictionary of all connections indexed by the connection direction "north", "south", "east", and "west".`[R]`
---@field neighbours table<string, LuaEntity[]>|LuaEntity[][]|LuaEntity
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field operable boolean @Player can't open gui of this entity and he can't quick insert/input stuff in to the entity when it is not operable.`[RW]`
---@field orientation RealOrientation @The smooth orientation of this entity, if it supports orientation.`[RW]`
---@field parameters ProgrammableSpeakerParameters @`[RW]`
---Where the inserter will pick up items from.`[RW]`
---
---Inserters must have `allow_custom_vectors` set to true on their prototype to allow changing the pickup position.
---@field pickup_position MapPosition
---@field pickup_target LuaEntity @The entity this inserter will attempt to pick up items from, or `nil` if there is no such entity. If there are multiple possible entities at the pick-up point, writing to this attribute allows a mod to choose which one to pick up items from. The entity needs to collide with the tile box under the pick-up position.`[RW]`
---@field player LuaPlayer @The player connected to this character or `nil` if none.`[R]`
---@field pollution_bonus double @The pollution bonus of this entity.`[R]`
---@field power_production double @The power production specific to the ElectricEnergyInterface entity type.`[RW]`
---@field power_switch_state boolean @The state of this power switch.`[RW]`
---@field power_usage double @The power usage specific to the ElectricEnergyInterface entity type.`[RW]`
---@field previous_recipe LuaRecipe @The previous recipe this furnace was using or nil if the furnace had no previous recipe.`[R]`
---The productivity bonus of this entity.`[R]`
---
---This includes force based bonuses as well as beacon/module bonuses.
---@field productivity_bonus double
---@field products_finished uint @The number of products this machine finished crafting in its lifetime.`[RW]`
---@field prototype LuaEntityPrototype @The entity prototype of this entity.`[R]`
---@field proxy_target LuaEntity @The target entity for this item-request-proxy or `nil``[R]`
---@field pump_rail_target LuaEntity @The rail target of this pump or `nil`.`[R]`
---@field radar_scan_progress float @The current radar scan progress, as a number in range [0, 1].`[R]`
---@field recipe_locked boolean @When locked; the recipe in this assembling machine can't be changed by the player.`[RW]`
---The relative orientation of the vehicle turret, artillery turret, artillery wagon or `nil` if this entity isn't a vehicle with a vehicle turret or artillery turret/wagon.`[RW]`
---
---Writing does nothing if the vehicle doesn't have a turret.
---@field relative_turret_orientation RealOrientation
---@field remove_unfiltered_items boolean @If items not included in this infinity container filters should be removed from the container.`[RW]`
---The player that this `simple-entity-with-owner`, `simple-entity-with-force`, `flying-text`, or `highlight-box` is visible to. `nil` means it is rendered for every player.
---
---Reading this property will return a [LuaPlayer](LuaPlayer), while [PlayerIdentification](PlayerIdentification) can be used when writing.`[RW]`
---@field render_player LuaPlayer|PlayerIdentification
---The forces that this `simple-entity-with-owner`, `simple-entity-with-force`, or `flying-text` is visible to. `nil` or an empty array means it is rendered for every force.`[RW]`
---
---Reading will always give an array of [LuaForce](LuaForce)
---@field render_to_forces ForceIdentification[]
---Whether this requester chest is set to also request from buffer chests.`[RW]`
---
---Useable only on entities that have requester slots.
---@field request_from_buffers boolean
---@field request_slot_count uint @The index of the configured request with the highest index for this entity. This means 0 if no requests are set and e.g. 20 if the 20th request slot is configured.`[R]`
---@field rocket_parts uint @Number of rocket parts in the silo.`[RW]`
---When entity is not to be rotatable (inserter, transport belt etc), it can't be rotated by player using the R key.`[RW]`
---
---Entities that are not rotatable naturally (like chest or furnace) can't be set to be rotatable.
---@field rotatable boolean
---@field secondary_bounding_box BoundingBox @The secondary bounding box of this entity or `nil` if it doesn't have one. This only exists for curved rails, and is automatically determined by the game.`[R]`
---@field secondary_selection_box BoundingBox @The secondary selection box of this entity or `nil` if it doesn't have one. This only exists for curved rails, and is automatically determined by the game.`[R]`
---@field selected_gun_index uint @Index of the currently selected weapon slot of this character, car, or spidertron, or `nil` if the car/spidertron doesn't have guns.`[RW]`
---@field selection_box BoundingBox @[LuaEntityPrototype::selection_box](LuaEntityPrototype::selection_box) around entity's given position and respecting the current entity orientation.`[R]`
---@field shooting_target LuaEntity @The shooting target for this turret or `nil`.`[RW]`
---@field signal_state defines.signal_state @The state of this rail signal.`[R]`
---@field spawner LuaEntity @The spawner associated with this unit entity or `nil` if the unit has no associated spawner.`[R]`
---@field speed float @The current speed of this car in tiles per tick, rolling stock, projectile or spider vehicle, or current max speed of the unit. Only the speed of units, cars, and projectiles are writable.`[RW]`
---The speed bonus of this entity.`[R]`
---
---This includes force based bonuses as well as beacon/module bonuses.
---@field speed_bonus double
---@field splitter_filter LuaItemPrototype @The filter for this splitter or `nil` if no filter is set.`[RW]`
---@field splitter_input_priority string @The input priority for this splitter : "left", "none", or "right".`[RW]`
---@field splitter_output_priority string @The output priority for this splitter : "left", "none", or "right".`[RW]`
---@field stack LuaItemStack @`[R]`
---@field status defines.entity_status @The status of this entity or `nil` if no status.`[R]`
---@field sticked_to LuaEntity @The entity this sticker is sticked to.`[R]`
---@field stickers LuaEntity[] @The sticker entities attached to this entity or `nil` if none.`[R]`
---@field storage_filter LuaItemPrototype @The storage filter for this logistic storage container.`[RW]`
---@field supports_direction boolean @Whether the entity has direction. When it is false for this entity, it will always return north direction when asked for.`[R]`
---@field tags Tags @The tags associated with this entity ghost or `nil` if not an entity ghost.`[RW]`
---@field temperature double @The temperature of this entities heat energy source if this entity uses a heat energy source or `nil`.`[RW]`
---@field text LocalisedString @The text of this flying-text entity.`[RW]`
---@field tick_of_last_attack uint @The last tick this character entity was attacked.`[RW]`
---@field tick_of_last_damage uint @The last tick this character entity was damaged.`[RW]`
---The ticks left before a ghost, combat robot, highlight box or smoke with trigger is destroyed.
---
---- for ghosts set to uint32 max (4,294,967,295) to never expire.
---- for ghosts Cannot be set higher than [LuaForce::ghost_time_to_live](LuaForce::ghost_time_to_live) of the entity's force.`[RW]`
---@field time_to_live uint
---@field time_to_next_effect uint @The ticks until the next trigger effect of this smoke-with-trigger.`[RW]`
---@field timeout uint @The timeout that's left on this landmine in ticks. It describes the time between the landmine being placed and it being armed.`[RW]`
---@field to_be_looted boolean @Will this entity be picked up automatically when the player walks over it?`[RW]`
---@field torso_orientation RealOrientation @The torso orientation of this spider vehicle.`[RW]`
---@field train LuaTrain @The train this rolling stock belongs to or nil if not rolling stock.`[R]`
---Amount of trains related to this particular train stop. Includes train stopped at this train stop (until it finds a path to next target) and trains having this train stop as goal or waypoint. Writing nil will disable the limit (will set a maximum possible value).`[R]`
---
---Train may be included multiple times when braking distance covers this train stop multiple times
---\
---Value may be read even when train stop has no control behavior
---@field trains_count uint
---@field trains_in_block uint @The number of trains in this rail block for this rail entity.`[R]`
---Amount of trains above which no new trains will be sent to this train stop.`[RW]`
---
---When a train stop has a control behavior with wire connected and set_trains_limit enabled, this value will be overwritten by it
---@field trains_limit uint
---@field tree_color_index uint8 @Index of the tree color.`[RW]`
---@field tree_color_index_max uint8 @Maximum index of the tree colors.`[R]`
---@field tree_gray_stage_index uint8 @Index of the tree gray stage`[RW]`
---@field tree_gray_stage_index_max uint8 @Maximum index of the tree gray stages.`[R]`
---@field tree_stage_index uint8 @Index of the tree stage.`[RW]`
---@field tree_stage_index_max uint8 @Maximum index of the tree stages.`[R]`
---@field type string @The entity prototype type of this entity.`[R]`
---@field unit_group LuaUnitGroup @The unit group this unit is a member of, or `nil` if none.`[R]`
---@field unit_number uint @A universally unique number identifying this entity for the lifetime of the save. Only entities inheriting from [EntityWithOwner](https://wiki.factorio.com/Prototype/EntityWithOwner), as well as [ItemRequestProxy](https://wiki.factorio.com/Prototype/ItemRequestProxy) and [EntityGhost](https://wiki.factorio.com/Prototype/EntityGhost) entities, are assigned a unit number. This property is `nil` for entities without unit number.`[R]`
---@field units LuaEntity[] @The units associated with this spawner entity.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field vehicle_automatic_targeting_parameters VehicleAutomaticTargetingParameters @Read when this spidertron auto-targets enemies`[RW]`
local LuaEntity = {}

---Adds the given position to this spidertron's autopilot's queue of destinations.
---@param _position MapPosition @The position the spidertron should move to.
function LuaEntity.add_autopilot_destination(_position) end

---Offer a thing on the market.
---
---Adds market offer, 1 copper ore for 10 iron ore. 
---```lua
---market.add_market_item{price={{"iron-ore", 10}}, offer={type="give-item", item="copper-ore"}}
---```
---\
---Adds market offer, 1 copper ore for 5 iron ore and 5 stone ore. 
---```lua
---market.add_market_item{price={{"iron-ore", 5}, {"stone", 5}}, offer={type="give-item", item="copper-ore"}}
---```
---@param _offer Offer
function LuaEntity.add_market_item(_offer) end

---Checks if the entity can be destroyed
---@return boolean @Whether the entity can be destroyed.
function LuaEntity.can_be_destroyed() end

---Whether this character can shoot the given entity or position.
---@param _target LuaEntity
---@param _position MapPosition
---@return boolean
function LuaEntity.can_shoot(_target, _position) end

---Can wires reach between these entities.
---@param _entity LuaEntity
---@return boolean
function LuaEntity.can_wires_reach(_entity) end

---Cancels deconstruction if it is scheduled, does nothing otherwise.
---@param _force ForceIdentification @The force who did the deconstruction order.
---@param _player? PlayerIdentification @The player to set the `last_user` to if any.
function LuaEntity.cancel_deconstruction(_force, _player) end

---Cancels upgrade if it is scheduled, does nothing otherwise.
---@param _force ForceIdentification @The force who did the upgrade order.
---@param _player? PlayerIdentification @The player to set the last_user to if any.
---@return boolean @Whether the cancel was successful.
function LuaEntity.cancel_upgrade(_force, _player) end

---Remove all fluids from this entity.
function LuaEntity.clear_fluid_inside() end

---Removes all offers from a market.
function LuaEntity.clear_market_items() end

---Clear a logistic requester slot.
---
---Useable only on entities that have requester slots.
---@param _slot uint @The slot index.
function LuaEntity.clear_request_slot(_slot) end

---Clones this entity.
---@param _table LuaEntity.clone
---@return LuaEntity @The cloned entity or `nil` if this entity can't be cloned/can't be cloned to the given location.
function LuaEntity.clone(_table) end

---Connects current linked belt with another one.
---
---Neighbours have to be of different type. If given linked belt is connected to something else it will be disconnected first. If provided neighbour is connected to something else it will also be disconnected first. Automatically updates neighbour to be connected back to this one.
---
---Can also be used on entity ghost if it contains linked-belt
---@param _neighbour LuaEntity @Another linked belt or entity ghost containing linked belt to connect or nil to disconnect
function LuaEntity.connect_linked_belts(_neighbour) end

---Connect two devices with a circuit wire or copper cable. Depending on which type of connection should be made, there are different procedures:
---
---- To connect two electric poles, `target` must be a [LuaEntity](LuaEntity) that specifies another electric pole. This will connect them with copper cable.
---- To connect two devices with circuit wire, `target` must be a table of type [WireConnectionDefinition](WireConnectionDefinition).
---@param _target LuaEntity|WireConnectionDefinition @The target with which to establish a connection.
---@return boolean @Whether the connection was successfully formed.
function LuaEntity.connect_neighbour(_target) end

---Connects the rolling stock in the given direction.
---@param _direction defines.rail_direction
---@return boolean @Whether any connection was made
function LuaEntity.connect_rolling_stock(_direction) end

---Copies settings from the given entity onto this entity.
---@param _entity LuaEntity
---@param _by_player? PlayerIdentification @If provided, the copying is done 'as' this player and [on_entity_settings_pasted](on_entity_settings_pasted) is triggered.
---@return table<string, uint> @Any items removed from this entity as a result of copying the settings.
function LuaEntity.copy_settings(_entity, _by_player) end

---Creates the same smoke that is created when you place a building by hand. You can play the building sound to go with it by using [LuaSurface::play_sound](LuaSurface::play_sound), eg: entity.surface.play_sound{path="entity-build/"..entity.prototype.name, position=entity.position}
function LuaEntity.create_build_effect_smoke() end

---Damages the entity.
---@param _damage float @The amount of damage to be done.
---@param _force ForceIdentification @The force that will be doing the damage.
---@param _type? string @The type of damage to be done, defaults to "impact".
---@param _dealer? LuaEntity @The entity to consider as the damage dealer. Needs to be on the same surface as the entity being damaged.
---@return float @the total damage actually applied after resistances.
function LuaEntity.damage(_damage, _force, _type, _dealer) end

---Depletes and destroys this resource entity.
function LuaEntity.deplete() end

---Destroys the entity.
---
---Not all entities can be destroyed - things such as rails under trains cannot be destroyed until the train is moved or destroyed.
---@param _table? LuaEntity.destroy
---@return boolean @Returns `false` if the entity was valid and destruction failed, `true` in all other cases.
function LuaEntity.destroy(_table) end

---Immediately kills the entity. Does nothing if the entity doesn't have health.
---
---Unlike [LuaEntity::destroy](LuaEntity::destroy), `die` will trigger the [on_entity_died](on_entity_died) event and the entity will produce a corpse and drop loot if it has any.
---
---This function can be called with only the `cause` argument and no `force`: 
---```lua
---entity.die(nil, killer_entity)
---```
---@param _force? ForceIdentification @The force to attribute the kill to.
---@param _cause? LuaEntity @The cause to attribute the kill to.
---@return boolean @Whether the entity was successfully killed.
function LuaEntity.die(_force, _cause) end

---Disconnects linked belt from its neighbour.
---
---Can also be used on entity ghost if it contains linked-belt
function LuaEntity.disconnect_linked_belts() end

---Disconnect circuit wires or copper cables between devices. Depending on which type of connection should be cut, there are different procedures:
---
---- To remove all copper cables, leave the `target` parameter blank: `pole.disconnect_neighbour()`.
---- To remove all wires of a specific color, set `target` to [defines.wire_type.red](defines.wire_type.red) or [defines.wire_type.green](defines.wire_type.green).
---- To remove a specific copper cable between two electric poles, `target` must be a [LuaEntity](LuaEntity) that specifies the other pole: `pole1.disconnect_neighbour(pole2)`.
---- To remove a specific circuit wire, `target` must be a table of type [WireConnectionDefinition](WireConnectionDefinition).
---@param _target? defines.wire_type|LuaEntity|WireConnectionDefinition @The target with which to cut a connection.
function LuaEntity.disconnect_neighbour(_target) end

---Tries to disconnect this rolling stock in the given direction.
---@param _direction defines.rail_direction
---@return boolean @If anything was disconnected
function LuaEntity.disconnect_rolling_stock(_direction) end

---Get the source of this beam.
---@return BeamTarget
function LuaEntity.get_beam_source() end

---Get the target of this beam.
---@return BeamTarget
function LuaEntity.get_beam_target() end

---The burnt result inventory for this entity or `nil` if this entity doesn't have a burnt result inventory.
---@return LuaInventory
function LuaEntity.get_burnt_result_inventory() end

---@param _wire defines.wire_type @Wire color of the network connected to this entity.
---@param _circuit_connector? defines.circuit_connector_id @The connector to get circuit network for. Must be specified for entities with more than one circuit network connector.
---@return LuaCircuitNetwork @The circuit network or nil.
function LuaEntity.get_circuit_network(_wire, _circuit_connector) end

---@param _table LuaEntity.get_connected_rail
---@return LuaEntity @Rail connected in the specified manner to this one, `nil` if unsuccessful.
function LuaEntity.get_connected_rail(_table) end

---Get the rails that this signal is connected to.
---@return LuaEntity[]
function LuaEntity.get_connected_rails() end

---Gets rolling stock connected to the given end of this stock.
---@param _direction defines.rail_direction
---@return LuaEntity @The rolling stock connected at the given end, `nil` if none is connected there.
---@return defines.rail_direction @The rail direction of the connected rolling stock if any.
function LuaEntity.get_connected_rolling_stock(_direction) end

---Gets the control behavior of the entity (if any).
---@return LuaControlBehavior @The control behavior or `nil`.
function LuaEntity.get_control_behavior() end

---Returns the amount of damage to be taken by this entity.
---@return float @`nil` if this entity does not have health.
function LuaEntity.get_damage_to_be_taken() end

---Gets the driver of this vehicle if any.
---@return LuaEntity|LuaPlayer @`nil` if the vehicle contains no driver. To check if there's a passenger see [LuaEntity::get_passenger](LuaEntity::get_passenger).
function LuaEntity.get_driver() end

---Get the filter for a slot in an inserter, loader, or logistic storage container.
---
---The entity must allow filters.
---@param _slot_index uint @Index of the slot to get the filter for.
---@return string @Prototype name of the item being filtered. `nil` if the given slot has no filter.
function LuaEntity.get_filter(_slot_index) end

---Get amounts of all fluids in this entity.
---
---If information about fluid temperatures is required, [LuaEntity::fluidbox](LuaEntity::fluidbox) should be used instead.
---@return table<string, double> @The amounts, indexed by fluid names.
function LuaEntity.get_fluid_contents() end

---Get the amount of all or some fluid in this entity.
---
---If information about fluid temperatures is required, [LuaEntity::fluidbox](LuaEntity::fluidbox) should be used instead.
---@param _fluid? string @Prototype name of the fluid to count. If not specified, count all fluids.
---@return double
function LuaEntity.get_fluid_count(_fluid) end

---The fuel inventory for this entity or `nil` if this entity doesn't have a fuel inventory.
---@return LuaInventory
function LuaEntity.get_fuel_inventory() end

---The health ratio of this entity between 1 and 0 (for full health and no health respectively).
---@return float @`nil` if this entity doesn't have health.
function LuaEntity.get_health_ratio() end

---Gets the heat setting for this heat interface.
---@return HeatSetting
function LuaEntity.get_heat_setting() end

---Gets the filter for this infinity container at the given index or `nil` if the filter index doesn't exist or is empty.
---@param _index uint @The index to get.
---@return InfinityInventoryFilter
function LuaEntity.get_infinity_container_filter(_index) end

---Gets the filter for this infinity pipe or `nil` if the filter is empty.
---@return InfinityPipeFilter
function LuaEntity.get_infinity_pipe_filter() end

---Gets all the `LuaLogisticPoint`s that this entity owns. Optionally returns only the point specified by the index parameter.
---
---When `index` is not given, this will be a single `LuaLogisticPoint` for most entities. For some (such as the player character), it can be zero or more.
---@param _index? defines.logistic_member_index @If provided, only returns the `LuaLogisticPoint` specified by this index.
---@return LuaLogisticPoint|LuaLogisticPoint[]
function LuaEntity.get_logistic_point(_index) end

---Get all offers in a market as an array.
---@return Offer[]
function LuaEntity.get_market_items() end

---Get the maximum transport line index of a belt or belt connectable entity.
---@return uint
function LuaEntity.get_max_transport_line_index() end

---Read a single signal from the combined circuit networks.
---@param _signal SignalID @The signal to read.
---@param _circuit_connector? defines.circuit_connector_id @The connector to get signals for. Must be specified for entities with more than one circuit network connector.
---@return int @The current value of the signal.
function LuaEntity.get_merged_signal(_signal, _circuit_connector) end

---The merged circuit network signals or `nil` if there are no signals.
---@param _circuit_connector? defines.circuit_connector_id @The connector to get signals for. Must be specified for entities with more than one circuit network connector.
---@return Signal[] @The sum of signals on both the red and green networks, or `nil` if it doesn't have a circuit connector.
function LuaEntity.get_merged_signals(_circuit_connector) end

---Inventory for storing modules of this entity; `nil` if this entity has no module inventory.
---@return LuaInventory
function LuaEntity.get_module_inventory() end

---Gets (and or creates if needed) the control behavior of the entity.
---@return LuaControlBehavior @The control behavior or `nil`.
function LuaEntity.get_or_create_control_behavior() end

---Gets the entity's output inventory if it has one.
---@return LuaInventory @A reference to the entity's output inventory.
function LuaEntity.get_output_inventory() end

---Gets the passenger of this car or spidertron if any.
---
---This differs over [LuaEntity::get_driver](LuaEntity::get_driver) in that the passenger can't drive the car.
---@return LuaEntity|LuaPlayer @`nil` if the vehicle contains no passenger. To check if there's a driver see [LuaEntity::get_driver](LuaEntity::get_driver).
function LuaEntity.get_passenger() end

---The radius of this entity.
---@return double
function LuaEntity.get_radius() end

---Get the rail at the end of the rail segment this rail is in.
---
---A rail segment is a continuous section of rail with no branches, signals, nor train stops.
---@param _direction defines.rail_direction
---@return LuaEntity @The rail entity.
---@return defines.rail_direction @A rail direction pointing out of the rail segment from the end rail.
function LuaEntity.get_rail_segment_end(_direction) end

---Get the rail signal or train stop at the start/end of the rail segment this rail is in.
---
---A rail segment is a continuous section of rail with no branches, signals, nor train stops.
---@param _direction defines.rail_direction @The direction of travel relative to this rail.
---@param _in_else_out boolean @If true, gets the entity at the entrance of the rail segment, otherwise gets the entity at the exit of the rail segment.
---@return LuaEntity @`nil` if the rail segment doesn't start/end with a signal nor a train stop.
function LuaEntity.get_rail_segment_entity(_direction, _in_else_out) end

---Get the length of the rail segment this rail is in.
---
---A rail segment is a continuous section of rail with no branches, signals, nor train stops.
---@return double
function LuaEntity.get_rail_segment_length() end

---Get a rail from each rail segment that overlaps with this rail's rail segment.
---
---A rail segment is a continuous section of rail with no branches, signals, nor train stops.
---@return LuaEntity[]
function LuaEntity.get_rail_segment_overlaps() end

---Current recipe being assembled by this machine or `nil` if no recipe is set.
---@return LuaRecipe
function LuaEntity.get_recipe() end

---Get a logistic requester slot.
---
---Useable only on entities that have requester slots.
---@param _slot uint @The slot index.
---@return SimpleItemStack @Contents of the specified slot; `nil` if the given slot contains no request.
function LuaEntity.get_request_slot(_slot) end

---Gets legs of given SpiderVehicle.
---@return LuaEntity[]
function LuaEntity.get_spider_legs() end

---The train currently stopped at this train stop or `nil` if none.
---@return LuaTrain
function LuaEntity.get_stopped_train() end

---The trains scheduled to stop at this train stop.
---@return LuaTrain[]
function LuaEntity.get_train_stop_trains() end

---Get a transport line of a belt or belt connectable entity.
---@param _index uint @Index of the requested transport line. Transport lines are 1-indexed.
---@return LuaTransportLine
function LuaEntity.get_transport_line(_index) end

---Returns the new entity direction after upgrading.
---@return defines.direction @`nil` if this entity is not marked for upgrade.
function LuaEntity.get_upgrade_direction() end

---Returns the new entity prototype.
---@return LuaEntityPrototype @`nil` if this entity is not marked for upgrade.
function LuaEntity.get_upgrade_target() end

---Same as [LuaEntity::has_flag](LuaEntity::has_flag), but targets the inner entity on a entity ghost.
---@param _flag string @The flag to test. See [EntityPrototypeFlags](EntityPrototypeFlags) for a list of flags.
---@return boolean @`true` if the entity has the given flag set.
function LuaEntity.ghost_has_flag(_flag) end

---Has this unit been assigned a command?
---@return boolean
function LuaEntity.has_command() end

---Test whether this entity's prototype has a certain flag set.
---
---`entity.has_flag(f)` is a shortcut for `entity.prototype.has_flag(f)`.
---@param _flag string @The flag to test. See [EntityPrototypeFlags](EntityPrototypeFlags) for a list of flags.
---@return boolean @`true` if this entity has the given flag set.
function LuaEntity.has_flag(_flag) end

---All methods and properties that this object supports.
---@return string
function LuaEntity.help() end

---Insert fluid into this entity. Fluidbox is chosen automatically.
---@param _fluid Fluid @Fluid to insert.
---@return double @Amount of fluid actually inserted.
function LuaEntity.insert_fluid(_fluid) end

---@return boolean @`true` if this gate is currently closed.
function LuaEntity.is_closed() end

---@return boolean @`true` if this gate is currently closing
function LuaEntity.is_closing() end

---Returns `true` if this entity produces or consumes electricity and is connected to an electric network that has at least one entity that can produce power.
---@return boolean
function LuaEntity.is_connected_to_electric_network() end

---Returns whether a craft is currently in process. It does not indicate whether progress is currently being made, but whether a crafting process has been started in this machine.
---@return boolean
function LuaEntity.is_crafting() end

---@return boolean @`true` if this gate is currently opened.
function LuaEntity.is_opened() end

---@return boolean @`true` if this gate is currently opening.
function LuaEntity.is_opening() end

---Is this entity or tile ghost or item request proxy registered for construction? If false, it means a construction robot has been dispatched to build the entity, or it is not an entity that can be constructed.
---@return boolean
function LuaEntity.is_registered_for_construction() end

---Is this entity registered for deconstruction with this force? If false, it means a construction robot has been dispatched to deconstruct it, or it is not marked for deconstruction. The complexity is effectively O(1) - it depends on the number of objects targeting this entity which should be small enough.
---@param _force ForceIdentification @The force construction manager to check.
---@return boolean
function LuaEntity.is_registered_for_deconstruction(_force) end

---Is this entity registered for repair? If false, it means a construction robot has been dispatched to upgrade it, or it is not damaged. This is worst-case O(N) complexity where N is the current number of things in the repair queue.
---@return boolean
function LuaEntity.is_registered_for_repair() end

---Is this entity registered for upgrade? If false, it means a construction robot has been dispatched to upgrade it, or it is not marked for upgrade. This is worst-case O(N) complexity where N is the current number of things in the upgrade queue.
---@return boolean
function LuaEntity.is_registered_for_upgrade() end

---@return boolean @`true` if the rocket was successfully launched. Return value of `false` means the silo is not ready for launch.
function LuaEntity.launch_rocket() end

---Mines this entity.
---
---'Standard' operation is to keep calling `LuaEntity.mine` with an inventory until all items are transferred and the items dealt with.
---\
---The result of mining the entity (the item(s) it produces when mined) will be dropped on the ground if they don't fit into the provided inventory.
---@param _table? LuaEntity.mine
---@return boolean @Whether mining succeeded.
function LuaEntity.mine(_table) end

---Sets the entity to be deconstructed by construction robots.
---@param _force ForceIdentification @The force whose robots are supposed to do the deconstruction.
---@param _player? PlayerIdentification @The player to set the `last_user` to if any.
---@return boolean @if the entity was marked for deconstruction.
function LuaEntity.order_deconstruction(_force, _player) end

---Sets the entity to be upgraded by construction robots.
---@param _table LuaEntity.order_upgrade
---@return boolean @Whether the entity was marked for upgrade.
function LuaEntity.order_upgrade(_table) end

---Plays a note with the given instrument and note.
---@param _instrument uint
---@param _note uint
---@return boolean @Whether the request is valid. The sound may or may not be played depending on polyphony settings.
function LuaEntity.play_note(_instrument, _note) end

---Release the unit from the spawner which spawned it. This allows the spawner to continue spawning additional units.
function LuaEntity.release_from_spawner() end

---Remove fluid from this entity.
---
---If temperature is given only fluid matching that exact temperature is removed. If minimum and maximum is given fluid within that range is removed.
---@param _table LuaEntity.remove_fluid
---@return double @Amount of fluid actually removed.
function LuaEntity.remove_fluid(_table) end

---Remove an offer from a market.
---
---The other offers are moved down to fill the gap created by removing the offer, which decrements the overall size of the offer array.
---@param _offer uint @Index of offer to remove.
---@return boolean @`true` if the offer was successfully removed; `false` when the given index was not valid.
function LuaEntity.remove_market_item(_offer) end

---@param _force ForceIdentification @The force that requests the gate to be closed.
function LuaEntity.request_to_close(_force) end

---@param _force ForceIdentification @The force that requests the gate to be open.
---@param _extra_time? uint @Extra ticks to stay open.
function LuaEntity.request_to_open(_force, _extra_time) end

---Revive a ghost. I.e. turn it from a ghost to a real entity or tile.
---@param _table? LuaEntity.revive
---@return table<string, uint> @Any items the new real entity collided with or `nil` if the ghost could not be revived.
---@return LuaEntity @The revived entity if an entity ghost was successfully revived.
---@return LuaEntity @The item request proxy if it was requested with `return_item_request_proxy`.
function LuaEntity.revive(_table) end

---Rotates this entity as if the player rotated it.
---@param _table? LuaEntity.rotate
---@return boolean @Whether the rotation was successful.
---@return table<string, uint> @Count of spilled items indexed by their prototype names if `spill_items` was `true`.
function LuaEntity.rotate(_table) end

---Set the source of this beam.
---@param _source LuaEntity|MapPosition
function LuaEntity.set_beam_source(_source) end

---Set the target of this beam.
---@param _target LuaEntity|MapPosition
function LuaEntity.set_beam_target(_target) end

---Give the entity a command.
---@param _command Command
function LuaEntity.set_command(_command) end

---Give the entity a distraction command.
---@param _command Command
function LuaEntity.set_distraction_command(_command) end

---Sets the driver of this vehicle.
---
---This differs over [LuaEntity::set_passenger](LuaEntity::set_passenger) in that the passenger can't drive the vehicle.
---@param _driver LuaEntity|PlayerIdentification @The new driver or `nil` to eject the current driver if any.
function LuaEntity.set_driver(_driver) end

---Set the filter for a slot in an inserter, loader, or logistic storage container.
---
---The entity must allow filters.
---@param _slot_index uint @Index of the slot to set the filter for.
---@param _item string @Prototype name of the item to filter.
function LuaEntity.set_filter(_slot_index, _item) end

---Sets the heat setting for this heat interface.
---@param _filter HeatSetting @The new setting.
function LuaEntity.set_heat_setting(_filter) end

---Sets the filter for this infinity container at the given index.
---@param _index uint @The index to set.
---@param _filter InfinityInventoryFilter @The new filter or `nil` to clear the filter.
function LuaEntity.set_infinity_container_filter(_index, _filter) end

---Sets the filter for this infinity pipe.
---@param _filter InfinityPipeFilter @The new filter or `nil` to clear the filter.
function LuaEntity.set_infinity_pipe_filter(_filter) end

---Sets the passenger of this car or spidertron.
---
---This differs over [LuaEntity::get_driver](LuaEntity::get_driver) in that the passenger can't drive the car.
---@param _passenger LuaEntity|PlayerIdentification
function LuaEntity.set_passenger(_passenger) end

---Sets the current recipe in this assembly machine.
---@param _recipe string|LuaRecipe @The new recipe or `nil` to clear the recipe.
---@return table<string, uint> @Any items removed from this entity as a result of setting the recipe.
function LuaEntity.set_recipe(_recipe) end

---Set a logistic requester slot.
---
---Useable only on entities that have requester slots.
---@param _request ItemStackIdentification @What to request.
---@param _slot uint @The slot index.
---@return boolean @Whether the slot was set.
function LuaEntity.set_request_slot(_request, _slot) end

---Revives a ghost silently.
---@param _table? LuaEntity.silent_revive
---@return table<string, uint> @Any items the new real entity collided with or `nil` if the ghost could not be revived.
---@return LuaEntity @The revived entity if an entity ghost was successfully revived.
---@return LuaEntity @The item request proxy if it was requested with `return_item_request_proxy`.
function LuaEntity.silent_revive(_table) end

---Triggers spawn_decoration actions defined in the entity prototype or does nothing if entity is not "turret" or "unit-spawner".
function LuaEntity.spawn_decorations() end

---Only works if the entity is a speech-bubble, with an "effect" defined in its wrapper_flow_style. Starts animating the opacity of the speech bubble towards zero, and destroys the entity when it hits zero.
function LuaEntity.start_fading_out() end

---Whether this entity supports a backer name.
---@return boolean
function LuaEntity.supports_backer_name() end

---Is this entity marked for deconstruction?
---@return boolean
function LuaEntity.to_be_deconstructed() end

---Is this entity marked for upgrade?
---@return boolean
function LuaEntity.to_be_upgraded() end

---Toggle this entity's equipment movement bonus. Does nothing if the entity does not have an equipment grid.
---
---This property can also be read and written on the equipment grid of this entity.
function LuaEntity.toggle_equipment_movement_bonus() end

---Reconnect loader, beacon, cliff and mining drill connections to entities that might have been teleported out or in by the script. The game doesn't do this automatically as we don't want to loose performance by checking this in normal games.
function LuaEntity.update_connections() end


---@class LuaEntity.circuit_connected_entities
---@field green LuaEntity[] @Entities connected via the green wire.
---@field red LuaEntity[] @Entities connected via the red wire.

---@class LuaEntity.clone
---@field position MapPosition @The destination position
---@field surface? LuaSurface @The destination surface
---@field force? ForceIdentification
---@field create_build_effect_smoke? boolean @If false, the building effect smoke will not be shown around the new entity.

---@class LuaEntity.destroy
---@field do_cliff_correction? boolean @Whether neighbouring cliffs should be corrected. Defaults to `false`.
---@field raise_destroy? boolean @If `true`, [script_raised_destroy](script_raised_destroy) will be called. Defaults to `false`.

---@class LuaEntity.get_connected_rail
---@field rail_direction defines.rail_direction
---@field rail_connection_direction defines.rail_connection_direction

---@class LuaEntity.mine
---@field inventory? LuaInventory @If provided the item(s) will be transferred into this inventory. If provided, this must be an inventory created with [LuaGameScript::create_inventory](LuaGameScript::create_inventory) or be a basic inventory owned by some entity.
---@field force? boolean @If true, when the item(s) don't fit into the given inventory the entity is force mined. If false, the mining operation fails when there isn't enough room to transfer all of the items into the inventory. Defaults to false. This is ignored and acts as `true` if no inventory is provided.
---@field raise_destroyed? boolean @If true, [script_raised_destroy](script_raised_destroy) will be raised. Defaults to `true`.
---@field ignore_minable? boolean @If true, the minable state of the entity is ignored. Defaults to `false`. If false, an entity that isn't minable (set as not-minable in the prototype or isn't minable for other reasons) will fail to be mined.

---@class LuaEntity.order_upgrade
---@field force ForceIdentification @The force whose robots are supposed to do the upgrade.
---@field target EntityPrototypeIdentification @The prototype of the entity to upgrade to.
---@field player? PlayerIdentification
---@field direction? defines.direction @The new direction if any.

---@class LuaEntity.remove_fluid
---@field name string @Fluid prototype name.
---@field amount double @Amount to remove
---@field minimum_temperature? double
---@field maximum_temperature? double
---@field temperature? double

---@class LuaEntity.revive
---@field return_item_request_proxy? boolean @If `true` the function will return item request proxy as the third return value.
---@field raise_revive? boolean @If true, and an entity ghost; [script_raised_revive](script_raised_revive) will be called. Else if true, and a tile ghost; [script_raised_set_tiles](script_raised_set_tiles) will be called.

---@class LuaEntity.rotate
---@field reverse? boolean @If `true`, rotate the entity in the counter-clockwise direction.
---@field by_player? PlayerIdentification @If not specified, the [on_player_rotated_entity](on_player_rotated_entity) event will not be fired.
---@field spill_items? boolean @If the player is not given should extra items be spilled or returned as a second return value from this.
---@field enable_looted? boolean @When true, each spilled item will be flagged with the [LuaEntity::to_be_looted](LuaEntity::to_be_looted) flag.
---@field force? LuaForce|string @When provided the spilled items will be marked for deconstruction by this force.

---@class LuaEntity.silent_revive
---@field return_item_request_proxy? boolean @If `true` the function will return item request proxy as the third parameter.
---@field raise_revive? boolean @If true, and an entity ghost; [script_raised_revive](script_raised_revive) will be called. Else if true, and a tile ghost; [script_raised_set_tiles](script_raised_set_tiles) will be called.

---Prototype of an entity.
---@class LuaEntityPrototype
---@field additional_pastable_entities LuaEntityPrototype[] @Entities this entity can be pasted onto in addition to the normal allowed ones.`[R]`
---@field adjacent_tile_collision_box BoundingBox @The bounding box that specifies which tiles adjacent to the offshore pump should be checked.`[R]`
---@field adjacent_tile_collision_mask CollisionMask @Tiles adjacent to the offshore pump must not collide with this collision mask.`[R]`
---@field adjacent_tile_collision_test CollisionMask @If this mask is not empty, tiles adjacent to the offshore pump must not collide with this collision mask.`[R]`
---@field affected_by_tiles boolean @Whether this unit prototype is affected by tile walking speed modifiers or `nil`.`[R]`
---@field air_resistance double @The air resistance of this rolling stock prototype or `nil` if not a rolling stock prototype.`[R]`
---@field alert_icon_shift Vector @The alert icon shift of this entity prototype.`[R]`
---@field alert_when_attacking boolean @Does this turret prototype alert when attacking? or `nil` if not turret prototype.`[R]`
---@field alert_when_damaged boolean @Does this entity with health prototype alert when damaged? or `nil` if not entity with health prototype.`[R]`
---@field allow_access_to_all_forces boolean @If this market allows access to all forces or just friendly ones.`[R]`
---@field allow_burner_leech boolean @If this inserter allows burner leeching.`[R]`
---@field allow_copy_paste boolean @When false copy-paste is not allowed for this entity.`[R]`
---@field allow_custom_vectors boolean @If this inserter allows custom pickup and drop vectors.`[R]`
---@field allow_passengers boolean @If this vehicle allows passengers.`[R]`
---@field allow_run_time_change_of_is_military_target boolean @True if this entity-with-owner's is_military_target can be changed run-time (on the entity, not on the prototype itself)`[R]`
---@field allowed_effects table<string, boolean> @The allowed module effects for this entity or `nil`.`[R]`
---@field always_on boolean @Whether the lamp is always on (except when out of power or turned off by the circuit network) or `nil`.`[R]`
---@field animation_speed_coefficient double @Gets the animation speed coefficient of this belt . `nil` if this is not transport belt connectable.`[R]`
---@field attack_parameters AttackParameters @The attack parameters for this entity or `nil` if the entity doesn't use attack parameters.`[R]`
---@field attack_result TriggerItem[] @The attack result of this entity if the entity has one, else `nil`.`[R]`
---@field automated_ammo_count uint @The amount of ammo that inserters automatically insert into this ammo-turret or artillery-turret or `nil`.`[R]`
---@field automatic_weapon_cycling boolean @Does this prototoype automaticly cycle weapons. `nil` if this is not a spider vechicle.`[R]`
---@field autoplace_specification AutoplaceSpecification @Autoplace specification for this entity prototype. `nil` if none.`[R]`
---@field base_productivity double @The base productivity of this crafting machine, lab, or mining drill, or `nil`.`[R]`
---@field belt_distance double @`[R]`
---@field belt_length double @`[R]`
---@field belt_speed double @The speed of this transport belt or `nil` if this isn't a transport belt related prototype.`[R]`
---@field braking_force double @The braking force of this vehicle prototype or `nil` if not a vehicle prototype.`[R]`
---@field build_base_evolution_requirement double @The evolution requirement to build this entity as a base when expanding enemy bases.`[R]`
---@field build_distance uint @`[R]`
---@field building_grid_bit_shift uint @The log2 of grid size of the building`[R]`
---@field burner_prototype LuaBurnerPrototype @The burner energy source prototype this entity uses or `nil`.`[R]`
---@field burns_fluid boolean @If this generator prototype burns fluid.`[R]`
---@field call_for_help_radius double @`[R]`
---@field can_open_gates boolean @Whether this unit prototype can open gates or `nil`.`[R]`
---@field center_collision_mask CollisionMask @The collision mask used only for collision test with tile directly at offshore pump position.`[R]`
---@field chain_shooting_cooldown_modifier double @Gets the chain shooting cooldown modifier of this prototype. `nil` if this is not a spider vechicle.`[R]`
---@field character_corpse LuaEntityPrototype @`[R]`
---@field chunk_exploration_radius double @Gets the chunk exploration radius of this prototype. `nil` if this is not a spider vechicle.`[R]`
---@field cliff_explosive_prototype string @The item prototype name used to destroy this cliff or `nil`.`[R]`
---@field collision_box BoundingBox @The bounding box used for collision checking.`[R]`
---@field collision_mask CollisionMask @The collision masks this entity uses`[R]`
---@field collision_mask_collides_with_self boolean @Does this prototype collision mask collide with itself?`[R]`
---@field collision_mask_collides_with_tiles_only boolean @Does this prototype collision mask collide with tiles only?`[R]`
---@field collision_mask_considers_tile_transitions boolean @Does this prototype collision mask consider tile transitions?`[R]`
---@field collision_mask_with_flags CollisionMaskWithFlags @`[R]`
---@field color Color @The color of the prototype, or `nil` if the prototype doesn't have color.`[R]`
---@field construction_radius double @The construction radius for this roboport prototype or `nil`.`[R]`
---@field consumption double @The energy consumption of this car prototype or `nil` if not a car prototype.`[R]`
---@field container_distance double @`[R]`
---@field corpses table<string, LuaEntityPrototype> @Corpses used when this entity is destroyed. It is a dictionary indexed by the corpse's prototype name.`[R]`
---@field count_as_rock_for_filtered_deconstruction boolean @If this simple-entity is counted as a rock for the deconstruction planner "trees and rocks only" filter.`[R]`
---The crafting categories this entity supports. Only meaningful when this is a crafting-machine or player entity type.`[R]`
---
---The value in the dictionary is meaningless and exists just to allow the dictionary type for easy lookup.
---@field crafting_categories table<string, boolean>
---@field crafting_speed double @The crafting speed of this crafting-machine or `nil`.`[R]`
---If this prototype will attempt to create a ghost of itself on death.`[R]`
---
---If this is false then a ghost will never be made, if it's true a ghost may be made.
---@field create_ghost_on_death boolean
---@field created_effect TriggerItem[] @The trigger run when this entity is created or `nil`.`[R]`
---@field created_smoke LuaEntityPrototype.created_smoke @The smoke trigger run when this entity is built or `nil`.`[R]`
---@field damage_hit_tint Color @`[R]`
---@field darkness_for_all_lamps_off float @Value between 0 and 1 darkness where all lamps of this lamp prototype are off or `nil`.`[R]`
---@field darkness_for_all_lamps_on float @Value between 0 and 1 darkness where all lamps of this lamp prototype are on or `nil`.`[R]`
---@field default_collision_mask_with_flags CollisionMaskWithFlags @The hardcoded default collision mask (with flags) for this entity prototype type.`[R]`
---@field destroy_non_fuel_fluid boolean @If this generator prototype destroys non fuel fluids.`[R]`
---@field distraction_cooldown uint @The distraction cooldown of this unit prototype or `nil`.`[R]`
---@field distribution_effectivity double @The distribution effectivity for this beacon prototype or `nil` if not a beacon prototype.`[R]`
---@field door_opening_speed double @The door opening speed for this rocket silo prototype or `nil`.`[R]`
---@field draw_cargo boolean @Whether this logistics or construction robot renders its cargo when flying or `nil`.`[R]`
---@field drawing_box BoundingBox @The bounding box used for drawing the entity icon.`[R]`
---@field drop_item_distance uint @`[R]`
---@field dying_speed float @The dying time of this corpse prototype. `nil` if not a corpse prototype.`[R]`
---@field effectivity double @The effectivity of this car prototype, generator prototype or `nil`.`[R]`
---@field electric_energy_source_prototype LuaElectricEnergySourcePrototype @The electric energy source prototype this entity uses or `nil`.`[R]`
---@field emissions_per_second double @Amount of pollution emissions per second this entity will create.`[R]`
---@field enemy_map_color Color @The enemy map color used when charting this entity.`[R]`
---@field energy_per_hit_point double @The energy used per hitpoint taken for this vehicle during collisions or `nil`.`[R]`
---@field energy_per_move double @The energy consumed per tile moved for this flying robot or `nil`.`[R]`
---@field energy_per_tick double @The energy consumed per tick for this flying robot or `nil`.`[R]`
---@field energy_usage double @The direct energy usage of this entity or `nil` if this entity doesn't have a direct energy usage.`[R]`
---@field engine_starting_speed double @The engine starting speed for this rocket silo rocket prototype or `nil`.`[R]`
---@field enter_vehicle_distance double @`[R]`
---@field explosion_beam double @Does this explosion have a beam or `nil` if not an explosion prototype.`[R]`
---@field explosion_rotate double @Does this explosion rotate or `nil` if not an explosion prototype.`[R]`
---@field fast_replaceable_group string @The group of mutually fast-replaceable entities. Possibly `nil`.`[R]`
---@field filter_count uint @The filter count of this inserter, loader, or logistic chest or `nil`. For logistic containers, `nil` means no limit.`[R]`
---@field final_attack_result TriggerItem[] @The final attack result for projectiles `nil` if not a projectile`[R]`
---@field fixed_recipe string @The fixed recipe name for this assembling machine prototype or `nil`.`[R]`
---@field flags EntityPrototypeFlags @The flags for this entity prototype.`[R]`
---@field fluid LuaFluidPrototype @The fluid this offshore pump produces or `nil`.`[R]`
---The fluid capacity of this entity or 0 if this entity doesn't support fluids.`[R]`
---
---Crafting machines will report 0 due to their fluid capacity being what ever a given recipe needs.
---@field fluid_capacity double
---@field fluid_energy_source_prototype LuaFluidEnergySourcePrototype @The fluid energy source prototype this entity uses or `nil`.`[R]`
---@field fluid_usage_per_tick double @The fluid usage of this generator prototype or `nil`.`[R]`
---@field fluidbox_prototypes LuaFluidBoxPrototype[] @The fluidbox prototypes for this entity.`[R]`
---@field flying_acceleration double @The flying acceleration for this rocket silo rocket prototype or `nil`.`[R]`
---@field flying_speed double @The flying speed for this rocket silo rocket prototype or `nil`.`[R]`
---@field friction_force double @The friction of this vehicle prototype or `nil` if not a vehicle prototype.`[R]`
---@field friendly_map_color Color @The friendly map color used when charting this entity.`[R]`
---@field grid_prototype LuaEquipmentGridPrototype @The equipment grid prototype for this entity or `nil`.`[R]`
---@field group LuaGroup @Group of this entity.`[R]`
---@field guns table<string, LuaItemPrototype> @A mapping of the gun name to the gun prototype this prototype uses, or `nil`.`[R]`
---@field has_belt_immunity boolean @Whether this unit, car, or character prototype has belt immunity, `nil` if not car, unit, or character prototype.`[R]`
---@field healing_per_tick float @Amount this entity can heal per tick.`[R]`
---@field heat_buffer_prototype LuaHeatBufferPrototype @The heat buffer prototype this entity uses or `nil`.`[R]`
---@field heat_energy_source_prototype LuaHeatEnergySourcePrototype @The heat energy source prototype this entity uses or `nil`.`[R]`
---@field height double @Gets the height of this prototype. `nil` if this is not a spider vechicle.`[R]`
---@field indexed_guns LuaItemPrototype[] @A vector of the gun prototypes this prototype uses, or `nil`.`[R]`
---@field infinite_depletion_resource_amount uint @Every time this infinite resource 'ticks' down it is reduced by this amount. `nil` when not a resource. Meaningless if this isn't an infinite type resource.`[R]`
---@field infinite_resource boolean @Is this resource infinite? Will be `nil` when used on a non-resource.`[R]`
---@field ingredient_count uint @The max number of ingredients this crafting-machine prototype supports or `nil` if this isn't a crafting-machine prototype.`[R]`
---@field inserter_chases_belt_items boolean @True if this inserter chases items on belts for pickup or `nil`.`[R]`
---@field inserter_drop_position Vector @The drop position for this inserter or `nil`.`[R]`
---@field inserter_extension_speed double @The extension speed of this inserter or `nil`.`[R]`
---@field inserter_pickup_position Vector @The pickup position for this inserter or `nil`.`[R]`
---@field inserter_rotation_speed double @The rotation speed of this inserter or `nil`.`[R]`
---@field inserter_stack_size_bonus double @Gets the built-in stack size bonus of this inserter prototype. `nil` if this is not an inserter.`[R]`
---@field instruments ProgrammableSpeakerInstrument[] @The instruments for this programmable speaker or `nil`.`[R]`
---@field is_building boolean @`[R]`
---@field is_entity_with_owner boolean @True if this is entity-with-owner`[R]`
---@field is_military_target boolean @True if this entity-with-owner is military target`[R]`
---@field item_pickup_distance double @`[R]`
---@field item_slot_count uint @The item slot count of this constant combinator prototype or `nil`.`[R]`
---@field items_to_place_this SimpleItemStack[] @Items that, when placed, will produce this entity. It is an array of items, or `nil` if no items place this entity. Construction bots will always choose the first item in this list to build this entity.`[R]`
---@field lab_inputs string[] @The item prototype names that are the inputs of this lab prototype or `nil`.`[R]`
---@field launch_wait_time uint8 @The rocket launch delay for this rocket silo prototype or `nil`.`[R]`
---@field light_blinking_speed double @The light blinking speed for this rocket silo prototype or `nil`.`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field logistic_mode string @The logistic mode of this logistic container or `nil` if this isn't a logistic container prototype. One of `"requester"`, `"active-provider"`, `"passive-provider"`, `"buffer"`, `"storage"`, `"none"`.`[R]`
---The logistic parameters for this roboport. or `nil`.`[R]`
---
---Both the `charging_station_shift` and `stationing_offset` vectors are tables with `x` and `y` keys instead of an array.
---@field logistic_parameters LuaEntityPrototype.logistic_parameters
---@field logistic_radius double @The logistic radius for this roboport prototype or `nil`.`[R]`
---@field loot Loot[] @Loot that will be dropped when this entity is killed. `nil` if there is no loot.`[R]`
---@field loot_pickup_distance double @`[R]`
---Get the manual range modifier for artillery turret and artillery wagon prototypes. `nil` if not artillery type prototype
---
---subclass(ArtilleryWagon, ArtilleryTurret)`[R]`
---@field manual_range_modifier double
---@field map_color Color @The map color used when charting this entity if a friendly or enemy color isn't defined or `nil`.`[R]`
---@field map_generator_bounding_box BoundingBox @The bounding box used for map generator collision checking.`[R]`
---@field max_circuit_wire_distance double @The maximum circuit wire distance for this entity. 0 when the entity doesn't support circuit wires.`[R]`
---@field max_count_of_owned_units double @Count of enemies this spawner can sustain.`[R]`
---@field max_darkness_to_spawn float @The maximum darkness at which this unit spawner can spawn entities.`[R]`
---@field max_distance_of_nearby_sector_revealed uint @The radius of the area constantly revealed by this radar, in chunks.`[R]`
---@field max_distance_of_sector_revealed uint @The radius of the area this radar can chart, in chunks.`[R]`
---@field max_energy double @The max energy for this flying robot or `nil`.`[R]`
---@field max_energy_production double @The theoretical maximum energy production for this this entity.`[R]`
---@field max_energy_usage double @The theoretical maximum energy usage for this entity.`[R]`
---@field max_friends_around_to_spawn double @How many friendly units are required within the spawning_radius of this spawner for it to stop producing more units.`[R]`
---@field max_health float @Max health of this entity. Will be `0` if this is not an entity with health.`[R]`
---@field max_payload_size uint @The max payload size of this logistics or construction robot or `nil`.`[R]`
---@field max_polyphony uint @The maximum polyphony for this programmable speaker or `nil`.`[R]`
---@field max_power_output double @The default maximum power output of this generator prototype or `nil`.`[R]`
---@field max_pursue_distance double @The maximum pursue distance of this unit prototype or `nil`.`[R]`
---@field max_speed double @The max speed of this projectile prototype or flying robot prototype or `nil`.`[R]`
---@field max_to_charge float @The maximum energy for this flying robot above which it won't try to recharge when stationing or `nil`.`[R]`
---@field max_underground_distance uint8 @The max underground distance for underground belts and underground pipes or `nil` if this isn't one of those prototypes.`[R]`
---@field max_wire_distance double @The maximum wire distance for this entity. 0 when the entity doesn't support wires.`[R]`
---@field maximum_corner_sliding_distance double @`[R]`
---@field maximum_temperature double @The maximum fluid temperature of this generator prototype or `nil`.`[R]`
---@field min_darkness_to_spawn float @The minimum darkness at which this unit spawner can spawn entities.`[R]`
---@field min_pursue_time uint @The minimum pursue time of this unit prototype or `nil`.`[R]`
---@field min_to_charge float @The minimum energy for this flying robot before it tries to recharge or `nil`.`[R]`
---@field mineable_properties LuaEntityPrototype.mineable_properties @Whether this entity is minable and what can be obtained by mining it.`[R]`
---@field minimum_resource_amount uint @Minimum amount of this resource. Will be `nil` when used on a non-resource.`[R]`
---@field mining_drill_radius double @The mining radius of this mining drill prototype or `nil` if this isn't a mining drill prototype.`[R]`
---@field mining_speed double @The mining speed of this mining drill/character prototype or `nil`.`[R]`
---@field module_inventory_size uint @The module inventory size or `nil` if this entity doesn't support modules.`[R]`
---@field move_while_shooting boolean @Whether this unit prototype can move while shooting or `nil`.`[R]`
---@field name string @Name of this prototype.`[R]`
---@field neighbour_bonus double @`[R]`
---@field next_upgrade LuaEntityPrototype @The next upgrade for this entity or `nil`.`[R]`
---@field normal_resource_amount uint @The normal amount for this resource. `nil` when not a resource.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field pollution_to_join_attack float @The amount of pollution that has to be absorbed by the unit's spawner before the unit will leave the spawner and attack the source of the pollution. `nil` when prototype is not a unit prototype.`[R]`
---@field protected_from_tile_building boolean @True if this entity prototype should be included during tile collision checks with [LuaTilePrototype::check_collision_with_entities](LuaTilePrototype::check_collision_with_entities) enabled.`[R]`
---@field pumping_speed double @The pumping speed of this offshore pump, normal pump, or `nil`.`[R]`
---@field radar_range uint @The radar range of this unit prototype or `nil`.`[R]`
---@field radius double @The radius of this entity prototype.`[R]`
---@field reach_distance uint @`[R]`
---@field reach_resource_distance double @`[R]`
---@field related_underground_belt LuaEntityPrototype @`[R]`
---@field remains_when_mined LuaEntityPrototype[] @The remains left behind when this entity is mined.`[R]`
---@field remove_decoratives string @`[R]`
---@field repair_speed_modifier uint @Repair-speed modifier for this entity. Actual repair speed will be `tool_repair_speed * entity_repair_speed_modifier`. May be `nil`.`[R]`
---@field researching_speed double @The base researching speed of this lab prototype or `nil`.`[R]`
---@field resistances table<string, Resistance> @List of resistances towards each damage type. It is a dictionary indexed by damage type names (see `data/base/prototypes/damage-type.lua`).`[R]`
---The resource categories this character or mining drill supports, or `nil` if not a character or mining dill.`[R]`
---
---The value in the dictionary is meaningless and exists just to allow the dictionary type for easy lookup.
---@field resource_categories table<string, boolean>
---Name of the category of this resource or `nil` when not a resource.`[R]`
---
---During data stage this property is named "category".
---@field resource_category string
---@field respawn_time uint @`[R]`
---@field result_units UnitSpawnDefinition[] @The result units and spawn points with weight and evolution factor for a biter spawner entity.`[R]`
---@field rising_speed double @The rising speed for this rocket silo rocket prototype or `nil`.`[R]`
---@field rocket_entity_prototype LuaEntityPrototype @The rocket entity prototype associated with this rocket silo prototype or `nil`.`[R]`
---@field rocket_parts_required uint @The rocket parts required for this rocket silo prototype or `nil`.`[R]`
---@field rocket_rising_delay uint8 @The rocket rising delay for this rocket silo prototype or `nil`.`[R]`
---@field rotation_speed double @The rotation speed of this car prototype or `nil` if not a car prototype.`[R]`
---@field running_speed double @Gets the current movement speed of this character, including effects from exoskeletons, tiles, stickers and shooting.`[R]`
---@field scale_fluid_usage boolean @If this generator prototype scales fluid usage.`[R]`
---@field secondary_collision_box BoundingBox @The secondary bounding box used for collision checking, or `nil` if it doesn't have one. This is only used in rails and rail remnants.`[R]`
---@field selectable_in_game boolean @Is this entity selectable?`[R]`
---@field selection_box BoundingBox @The bounding box used for drawing selection.`[R]`
---@field selection_priority uint @The selection priority of this entity - a value between 0 and 255`[R]`
---@field shooting_cursor_size double @The cursor size used when shooting at this entity.`[R]`
---@field spawn_cooldown LuaEntityPrototype.spawn_cooldown @The spawning cooldown for this enemy spawner prototype or `nil`.`[R]`
---@field spawning_radius double @How far from the spawner can the units be spawned.`[R]`
---@field spawning_spacing double @What spaces should be between the spawned units.`[R]`
---@field spawning_time_modifier double @The spawning time modifier of this unit prototype or `nil`.`[R]`
---The default speed of this flying robot, rolling stock or unit, `nil` if not one of these.`[R]`
---
---For rolling stocks, this is their `max_speed`.
---@field speed double
---@field speed_multiplier_when_out_of_energy float @The speed multiplier when this flying robot is out of energy or `nil`.`[R]`
---@field stack boolean @If this inserter is a stack-type.`[R]`
---@field sticker_box BoundingBox @The bounding box used to attach sticker type entities.`[R]`
---@field subgroup LuaGroup @Subgroup of this entity.`[R]`
---@field supply_area_distance double @The supply area of this electric pole, beacon, or `nil` if this is neither.`[R]`
---@field supports_direction boolean @If this entity prototype could possibly ever be rotated.`[R]`
---@field tank_driving boolean @If this car prototype uses tank controls to drive or `nil` if this is not a car prototype.`[R]`
---@field target_temperature double @The target temperature of this boiler prototype or `nil`.`[R]`
---@field terrain_friction_modifier float @The terrain friction modifier for this vehicle.`[R]`
---@field ticks_to_keep_aiming_direction uint @`[R]`
---@field ticks_to_keep_gun uint @`[R]`
---@field ticks_to_stay_in_combat uint @`[R]`
---@field time_to_live uint @The time to live for this prototype or `0` if prototype doesn't have time_to_live or time_before_removed.`[R]`
---@field timeout uint @The time it takes this land mine to arm.`[R]`
---@field torso_rotation_speed double @Gets the torso rotation speed of this prototype. `nil` if this is not a spider vechicle.`[R]`
---@field tree_color_count uint8 @If it is a tree, return the number of colors it supports. `nil` otherwise.`[R]`
---@field trigger_collision_mask CollisionMaskWithFlags @Collision mask entity must collide with to make landmine blowup`[R]`
---@field turret_range uint @The range of this turret or `nil` if this isn't a turret related prototype.`[R]`
---@field turret_rotation_speed double @The turret rotation speed of this car prototype or `nil` if not a car prototype.`[R]`
---@field type string @Type of this prototype.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field vision_distance double @The vision distance of this unit prototype or `nil`.`[R]`
---@field void_energy_source_prototype LuaVoidEnergySourcePrototype @The void energy source prototype this entity uses or `nil`.`[R]`
---@field weight double @The weight of this vehicle prototype or `nil` if not a vehicle prototype.`[R]`
local LuaEntityPrototype = {}

---Gets the base size of the given inventory on this entity or `nil` if the given inventory doesn't exist.
---@param _index defines.inventory
---@return uint
function LuaEntityPrototype.get_inventory_size(_index) end

---Test whether this entity prototype has a certain flag set.
---@param _flag string @The flag to test. See [EntityPrototypeFlags](EntityPrototypeFlags) for a list of flags.
---@return boolean @`true` if this prototype has the given flag set.
function LuaEntityPrototype.has_flag(_flag) end

---All methods and properties that this object supports.
---@return string
function LuaEntityPrototype.help() end


---@class LuaEntityPrototype.created_smoke
---@field initial_height float
---@field max_radius? float
---@field offset_deviation BoundingBox
---@field offsets Vector[]
---@field smoke_name string
---@field speed Vector
---@field speed_from_center float
---@field speed_from_center_deviation float
---@field speed_multiplier float
---@field speed_multiplier_deviation float
---@field starting_frame float
---@field starting_frame_deviation float
---@field starting_frame_speed float
---@field starting_frame_speed_deviation float

---@class LuaEntityPrototype.logistic_parameters
---@field charge_approach_distance float
---@field charging_distance float
---@field charging_energy double
---@field charging_station_count uint
---@field charging_station_shift Vector
---@field charging_threshold_distance float
---@field construction_radius float
---@field logistic_radius float
---@field logistics_connection_distance float
---@field robot_limit uint
---@field robot_vertical_acceleration float
---@field robots_shrink_when_entering_and_exiting boolean
---@field spawn_and_station_height float
---@field spawn_and_station_shadow_height_offset float
---@field stationing_offset Vector

---@class LuaEntityPrototype.mineable_properties
---@field fluid_amount? double @The required fluid amount if any.
---@field minable boolean @Is this entity mineable at all?
---@field mining_particle? string @Prototype name of the particle produced when mining this entity. Will only be present if this entity produces any particle during mining.
---@field mining_time double @Energy required to mine an entity.
---@field mining_trigger? TriggerItem[] @The mining trigger if any.
---@field products? Product[] @Products obtained by mining this entity.
---@field required_fluid? string @The prototype name of the required fluid if any.

---@class LuaEntityPrototype.spawn_cooldown
---@field max double
---@field min double

