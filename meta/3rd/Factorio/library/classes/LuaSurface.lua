---@meta

---A "domain" of the world. Surfaces can only be created and deleted through the API. Surfaces are uniquely identified by their name. Every game contains at least the surface "nauvis".
---@class LuaSurface
---@field always_day boolean @When set to true, the sun will always shine.`[RW]`
---Defines how surface daytime brightness influences each color channel of the current color lookup table (LUT).
---
---The LUT is multiplied by `((1 - weight) + brightness * weight)` and result is clamped to range [0, 1].
---
---Default is `{0, 0, 0}`, which means no influence.`[RW]`
---
---Makes night on the surface pitch black, assuming [LuaSurface::min_brightness](LuaSurface::min_brightness) being set to default value `0.15`. 
---```lua
---game.surfaces[1].brightness_visual_weights = { 1 / 0.85, 1 / 0.85, 1 / 0.85 }
---```
---@field brightness_visual_weights ColorModifier
---@field darkness float @Amount of darkness at the current time, as a number in range [0, 1].`[R]`
---@field dawn double @The daytime when dawn starts.`[RW]`
---@field daytime double @Current time of day, as a number in range [0, 1).`[RW]`
---@field dusk double @The daytime when dusk starts.`[RW]`
---@field evening double @The daytime when evening starts.`[RW]`
---@field freeze_daytime boolean @True if daytime is currently frozen.`[RW]`
---@field generate_with_lab_tiles boolean @When set to true, new chunks will be generated with lab tiles, instead of using the surface's map generation settings.`[RW]`
---@field index uint @Unique ID associated with this surface.`[R]`
---@field map_gen_settings MapGenSettings @The generation settings for this surface. These can be modified to after surface generation, but note that this will not retroactively update the surface. To manually adjust it, [LuaSurface::regenerate_entity](LuaSurface::regenerate_entity), [LuaSurface::regenerate_decorative](LuaSurface::regenerate_decorative) and [LuaSurface::delete_chunk](LuaSurface::delete_chunk) can be used.`[RW]`
---@field min_brightness double @The minimal brightness during the night. Default is `0.15`. The value has an effect on the game simalution only, it doesn't have any effect on rendering.`[RW]`
---@field morning double @The daytime when morning starts.`[RW]`
---The name of this surface. Names are unique among surfaces.`[RW]`
---
---the default surface can't be renamed.
---@field name string
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field peaceful_mode boolean @Is peaceful mode enabled on this surface?`[RW]`
---If clouds are shown on this surface.`[RW]`
---
---If false, clouds are never shown. If true the player must also have clouds enabled in graphics settings for them to be shown.
---@field show_clouds boolean
---The multiplier of solar power on this surface. Cannot be less than 0.`[RW]`
---
---Solar equipment is still limited to its maximum power output.
---@field solar_power_multiplier double
---@field ticks_per_day uint @The number of ticks per day for this surface.`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field wind_orientation RealOrientation @Current wind direction.`[RW]`
---@field wind_orientation_change double @Change in wind orientation per tick.`[RW]`
---@field wind_speed double @Current wind speed.`[RW]`
local LuaSurface = {}

---Adds the given script area.
---@param _area ScriptArea
---@return uint @The id of the created area.
function LuaSurface.add_script_area(_area) end

---Adds the given script position.
---@param _area ScriptPosition
---@return uint @The id of the created position.
function LuaSurface.add_script_position(_area) end

---Sets the given area to the checkerboard lab tiles.
---@param _area BoundingBox @The tile area.
function LuaSurface.build_checkerboard(_area) end

---Send a group to build a new base.
---
---The specified force must be AI-controlled; i.e. `force.ai_controllable` must be `true`.
---@param _position MapPosition @Location of the new base.
---@param _unit_count uint @Number of biters to send for the base-building task.
---@param _force? ForceIdentification @Force the new base will belong to. Defaults to enemy.
function LuaSurface.build_enemy_base(_position, _unit_count, _force) end

---@param _property_names string[] @Names of properties (e.g. "elevation") to calculate
---@param _positions MapPosition[] @Positions for which to calculate property values
---@return table<string, double[]> @Table of property value lists, keyed by property name
function LuaSurface.calculate_tile_properties(_property_names, _positions) end

---If there exists an entity at the given location that can be fast-replaced with the given entity parameters.
---@param _table LuaSurface.can_fast_replace
---@return boolean
function LuaSurface.can_fast_replace(_table) end

---Check for collisions with terrain or other entities.
---@param _table LuaSurface.can_place_entity
---@return boolean
function LuaSurface.can_place_entity(_table) end

---Cancel a deconstruction order.
---@param _table LuaSurface.cancel_deconstruct_area
function LuaSurface.cancel_deconstruct_area(_table) end

---Cancel a upgrade order.
---@param _table LuaSurface.cancel_upgrade_area
function LuaSurface.cancel_upgrade_area(_table) end

---Clears this surface deleting all entities and chunks on it.
---@param _ignore_characters? boolean @Whether characters on this surface that are connected to or associated with players should be ignored (not destroyed).
function LuaSurface.clear(_ignore_characters) end

---Clears all pollution on this surface.
function LuaSurface.clear_pollution() end

---Clones the given area.
---
---Entities are cloned in an order such that they can always be created, eg rails before trains.
---@param _table LuaSurface.clone_area
function LuaSurface.clone_area(_table) end

---Clones the given area.
---
---[defines.events.on_entity_cloned](defines.events.on_entity_cloned) is raised for each entity, and then [defines.events.on_area_cloned](defines.events.on_area_cloned) is raised.
---\
---Entities are cloned in an order such that they can always be created, eg rails before trains.
---@param _table LuaSurface.clone_brush
function LuaSurface.clone_brush(_table) end

---Clones the given entities.
---
---Entities are cloned in an order such that they can always be created, eg rails before trains.
---@param _table LuaSurface.clone_entities
function LuaSurface.clone_entities(_table) end

---Count entities of given type or name in a given area. Works just like [LuaSurface::find_entities_filtered](LuaSurface::find_entities_filtered), except this only returns the count. As it doesn't construct all the wrapper objects, this is more efficient if one is only interested in the number of entities.
---
---If no `area` or `position` are given, the entire surface is searched. If `position` is given, this returns the entities colliding with that position (i.e the given position is within the entity's collision box). If `position` and `radius` are given, this returns entities in the radius of the position. If `area` is specified, this returns entities colliding with that area.
---@param _table LuaSurface.count_entities_filtered
---@return uint
function LuaSurface.count_entities_filtered(_table) end

---Count tiles of a given name in a given area. Works just like [LuaSurface::find_tiles_filtered](LuaSurface::find_tiles_filtered), except this only returns the count. As it doesn't construct all the wrapper objects, this is more efficient if one is only interested in the number of tiles.
---
---If no `area` or `position` and `radius` is given, the entire surface is searched. If `position` and `radius` are given, only tiles within the radius of the position are included.
---@param _table LuaSurface.count_tiles_filtered
---@return uint
function LuaSurface.count_tiles_filtered(_table) end

---Adds the given decoratives to the surface.
---
---This will merge decoratives of the same type that already exist effectively increasing the "amount" field.
---@param _table LuaSurface.create_decoratives
function LuaSurface.create_decoratives(_table) end

---Create an entity on this surface.
---
---```lua
---asm = game.surfaces[1].create_entity{name = "assembling-machine-1", position = {15, 3}, force = game.forces.player, recipe = "iron-stick"}
---```
---\
---Creates a filter inserter with circuit conditions and a filter 
---```lua
---game.surfaces[1].create_entity{
---  name = "filter-inserter", position = {20, 15}, force = game.player.force,
---  conditions = {red = {name = "wood", count = 3, operator = ">"},
---              green = {name = "iron-ore", count = 1, operator = "<"},
---  logistics = {name = "wood", count = 3, operator = "="}},
---  filters = {{index = 1, name = "iron-ore"}}
---}
---```
---\
---Creates a requester chest already set to request 128 iron plates. 
---```lua
---game.surfaces[1].create_entity{
---  name = "logistic-chest-requester", position = {game.player.position.x+3, game.player.position.y},
---  force = game.player.force, request_filters = {{index = 1, name = "iron-plate", count = 128}}
---}
---```
---\
---```lua
---game.surfaces[1].create_entity{name = "big-biter", position = {15, 3}, force = game.forces.player} -- Friendly biter
---game.surfaces[1].create_entity{name = "medium-biter", position = {15, 3}, force = game.forces.enemy} -- Enemy biter
---```
---\
---Creates a basic inserter at the player's location facing north 
---```lua
---game.surfaces[1].create_entity{name = "inserter", position = game.player.position, direction = defines.direction.north}
---```
---@param _table LuaSurface.create_entity
---@return LuaEntity @The created entity or `nil` if the creation failed.
function LuaSurface.create_entity(_table) end

---Creates a particle at the given location
---@param _table LuaSurface.create_particle
function LuaSurface.create_particle(_table) end

---@param _table LuaSurface.create_trivial_smoke
function LuaSurface.create_trivial_smoke(_table) end

---Create a new unit group at a given position.
---@param _table LuaSurface.create_unit_group
---@return LuaUnitGroup
function LuaSurface.create_unit_group(_table) end

---Place a deconstruction request.
---@param _table LuaSurface.deconstruct_area
function LuaSurface.deconstruct_area(_table) end

---@param _prototype string @The decorative prototype to check
---@param _position MapPosition @The position to check
function LuaSurface.decorative_prototype_collides(_prototype, _position) end

---@param _position ChunkPosition @The chunk position to delete
function LuaSurface.delete_chunk(_position) end

---Removes all decoratives from the given area. If no area and no position are given, then the entire surface is searched.
---@param _table LuaSurface.destroy_decoratives
function LuaSurface.destroy_decoratives(_table) end

---Sets the given script area to the new values.
---@param _id uint @The area to edit.
---@param _area ScriptArea
function LuaSurface.edit_script_area(_id, _area) end

---Sets the given script position to the new values.
---@param _id uint @The position to edit.
---@param _area ScriptPosition
function LuaSurface.edit_script_position(_id, _area) end

---@param _prototype EntityPrototypeIdentification @The entity prototype to check
---@param _position MapPosition @The position to check
---@param _use_map_generation_bounding_box boolean @If the map generation bounding box should be used instead of the collision bounding box
---@param _direction? defines.direction
function LuaSurface.entity_prototype_collides(_prototype, _position, _use_map_generation_bounding_box, _direction) end

---Find decoratives of a given name in a given area.
---
---If no filters are given, returns all decoratives in the search area. If multiple filters are specified, returns only decoratives matching every given filter. If no area and no position are given, the entire surface is searched.
---
---```lua
---game.surfaces[1].find_decoratives_filtered{area = {{-10, -10}, {10, 10}}, name = "sand-decal"} -- gets all sand-decals in the rectangle
---game.surfaces[1].find_decoratives_filtered{area = {{-10, -10}, {10, 10}}, limit = 5}  -- gets the first 5 decoratives in the rectangle
---```
---@param _table LuaSurface.find_decoratives_filtered
---@return DecorativeResult[]
function LuaSurface.find_decoratives_filtered(_table) end

---Find enemy units (entities with type "unit") of a given force within an area.
---
---This is more efficient than [LuaSurface::find_entities](LuaSurface::find_entities).
---
---Find all units who would be interested to attack the player, within 100-tile area. 
---```lua
---local enemies = game.player.surface.find_enemy_units(game.player.position, 100)
---```
---@param _center MapPosition @Center of the search area
---@param _radius double @Radius of the circular search area
---@param _force? LuaForce|string @Force to find enemies of. If not given, uses the player force.
---@return LuaEntity[]
function LuaSurface.find_enemy_units(_center, _radius, _force) end

---Find entities in a given area.
---
---If no area is given all entities on the surface are returned.
---
---Will evaluate to a list of all entities within given area. 
---```lua
---game.surfaces["nauvis"].find_entities({{-10, -10}, {10, 10}})
---```
---@param _area? BoundingBox
---@return LuaEntity[]
function LuaSurface.find_entities(_area) end

---Find all entities of the given type or name in the given area.
---
---If no filters (`name`, `type`, `force`, etc.) are given, this returns all entities in the search area. If multiple filters are specified, only entities matching all given filters are returned.
---
---- If no `area` or `position` are given, the entire surface is searched.
---- If `position` is given, this returns the entities colliding with that position (i.e the given position is within the entity's collision box).
---- If `position` and `radius` are given, this returns the entities within the radius of the position. Looks for the center of entities.
---- If `area` is specified, this returns the entities colliding with that area.
---
---```lua
---game.surfaces[1].find_entities_filtered{area = {{-10, -10}, {10, 10}}, type = "resource"} -- gets all resources in the rectangle
---game.surfaces[1].find_entities_filtered{area = {{-10, -10}, {10, 10}}, name = "iron-ore"} -- gets all iron ores in the rectangle
---game.surfaces[1].find_entities_filtered{area = {{-10, -10}, {10, 10}}, name = {"iron-ore", "copper-ore"}} -- gets all iron ore and copper ore in the rectangle
---game.surfaces[1].find_entities_filtered{area = {{-10, -10}, {10, 10}}, force = "player"}  -- gets player owned entities in the rectangle
---game.surfaces[1].find_entities_filtered{area = {{-10, -10}, {10, 10}}, limit = 5}  -- gets the first 5 entities in the rectangle
---game.surfaces[1].find_entities_filtered{position = {0, 0}, radius = 10}  -- gets all entities within 10 tiles of the position [0,0].
---```
---@param _table LuaSurface.find_entities_filtered
---@return LuaEntity[]
function LuaSurface.find_entities_filtered(_table) end

---Find a specific entity at a specific position.
---
---```lua
---game.player.selected.surface.find_entity('filter-inserter', {0,0})
---```
---@param _entity string @Entity to look for.
---@param _position MapPosition @Coordinates to look at.
---@return LuaEntity @`nil` if no such entity is found.
function LuaSurface.find_entity(_entity, _position) end

---Find the logistic network that covers a given position.
---@param _position MapPosition
---@param _force ForceIdentification @Force the logistic network should belong to.
---@return LuaLogisticNetwork @The found network or `nil` if no such network was found.
function LuaSurface.find_logistic_network_by_position(_position, _force) end

---Finds all of the logistics networks whose construction area intersects with the given position.
---@param _position MapPosition
---@param _force ForceIdentification @Force the logistic networks should belong to.
---@return LuaLogisticNetwork[]
function LuaSurface.find_logistic_networks_by_construction_area(_position, _force) end

---Find the enemy military target ([military entity](https://wiki.factorio.com/Military_units_and_structures)) closest to the given position.
---@param _table LuaSurface.find_nearest_enemy
---@return LuaEntity @The nearest enemy military target or `nil` if no enemy could be found within the given area.
function LuaSurface.find_nearest_enemy(_table) end

---Find the enemy entity-with-owner closest to the given position.
---@param _table LuaSurface.find_nearest_enemy_entity_with_owner
---@return LuaEntity @The nearest enemy entity-with-owner or `nil` if no enemy could be found within the given area.
function LuaSurface.find_nearest_enemy_entity_with_owner(_table) end

---Find a non-colliding position within a given radius.
---
---Special care needs to be taken when using a radius of `0`. The game will not stop searching until it finds a suitable position, so it is important to make sure such a position exists. One particular case where it would not be able to find a solution is running it before any chunks have been generated.
---@param _name string @Prototype name of the entity to find a position for. (The bounding box for the collision checking is taken from this prototype.)
---@param _center MapPosition @Center of the search area.
---@param _radius double @Max distance from `center` to search in. A radius of `0` means an infinitely-large search area.
---@param _precision double @The step length from the given position as it searches, in tiles. Minimum value is `0.01`.
---@param _force_to_tile_center? boolean @Will only check tile centers. This can be useful when your intent is to place a building at the resulting position, as they must generally be placed at tile centers. Default false.
---@return MapPosition @The non-colliding position. May be `nil` if no suitable position was found.
function LuaSurface.find_non_colliding_position(_name, _center, _radius, _precision, _force_to_tile_center) end

---Find a non-colliding position within a given rectangle.
---@param _name string @Prototype name of the entity to find a position for. (The bounding box for the collision checking is taken from this prototype.)
---@param _search_space BoundingBox @The rectangle to search inside.
---@param _precision double @The step length from the given position as it searches, in tiles. Minimum value is 0.01.
---@param _force_to_tile_center? boolean @Will only check tile centers. This can be useful when your intent is to place a building at the resulting position, as they must generally be placed at tile centers. Default false.
---@return MapPosition @The non-colliding position. May be `nil` if no suitable position was found.
function LuaSurface.find_non_colliding_position_in_box(_name, _search_space, _precision, _force_to_tile_center) end

---Find all tiles of the given name in the given area.
---
---If no filters are given, this returns all tiles in the search area.
---
---If no `area` or `position` and `radius` is given, the entire surface is searched. If `position` and `radius` are given, only tiles within the radius of the position are included.
---@param _table LuaSurface.find_tiles_filtered
---@return LuaTile[]
function LuaSurface.find_tiles_filtered(_table) end

---Find units (entities with type "unit") of a given force and force condition within a given area.
---
---This is more efficient than [LuaSurface::find_entities](LuaSurface::find_entities).
---
---Find friendly units to "player" force 
---```lua
---local friendly_units = game.player.surface.find_units({area = {{-10, -10},{10, 10}}, force = "player", condition = "friend")
---```
---\
---Find units of "player" force 
---```lua
---local units = game.player.surface.find_units({area = {{-10, -10},{10, 10}}, force = "player", condition = "same"})
---```
---@param _table LuaSurface.find_units
---@return LuaEntity[]
function LuaSurface.find_units(_table) end

---Blocks and generates all chunks that have been requested using all available threads.
function LuaSurface.force_generate_chunk_requests() end

---Get an iterator going over every chunk on this surface.
---@return LuaChunkIterator
function LuaSurface.get_chunks() end

---Gets the closest entity in the list to this position.
---@param _position MapPosition
---@param _entities LuaEntity[] @The Entities to check
---@return LuaEntity
function LuaSurface.get_closest(_position, _entities) end

---Gets all tiles of the given types that are connected horizontally or vertically to the given tile position including the given tile position.
---
---This won't find tiles in non-generated chunks.
---@param _position TilePosition @The tile position to start at.
---@param _tiles string[] @The tiles to search for.
---@return TilePosition[] @The resulting set of tiles.
function LuaSurface.get_connected_tiles(_position, _tiles) end

---Returns all the military targets (entities with force) on this chunk for the given force.
---@param _position ChunkPosition @The chunk's position.
---@param _force LuaForce|string @Entities of this force will be returned.
---@return LuaEntity[]
function LuaSurface.get_entities_with_force(_position, _force) end

---The hidden tile name.
---@param _position TilePosition @The tile position.
---@return string @`nil` if there isn't one for the given position.
function LuaSurface.get_hidden_tile(_position) end

---Gets the map exchange string for the current map generation settings of this surface.
---@return string
function LuaSurface.get_map_exchange_string() end

---Get the pollution for a given position.
---
---Pollution is stored per chunk, so this will return the same value for all positions in one chunk.
---
---```lua
---game.surfaces[1].get_pollution({1,2})
---```
---@param _position MapPosition
---@return double
function LuaSurface.get_pollution(_position) end

---Gets a random generated chunk position or 0,0 if no chunks have been generated on this surface.
---@return ChunkPosition
function LuaSurface.get_random_chunk() end

---Gets the resource amount of all resources on this surface
---@return table<string, uint>
function LuaSurface.get_resource_counts() end

---Gets the first script area by name or id.
---@param _key? string|uint @The name or id of the area to get.
---@return ScriptArea
function LuaSurface.get_script_area(_key) end

---Gets the script areas that match the given name or if no name is given all areas are returned.
---@param _name? string
---@return ScriptArea[]
function LuaSurface.get_script_areas(_name) end

---Gets the first script position by name or id.
---@param _key? string|uint @The name or id of the position to get.
---@return ScriptPosition
function LuaSurface.get_script_position(_key) end

---Gets the script positions that match the given name or if no name is given all positions are returned.
---@param _name? string
---@return ScriptPosition[]
function LuaSurface.get_script_positions(_name) end

---Gets the starting area radius of this surface.
---@return double
function LuaSurface.get_starting_area_radius() end

---Get the tile at a given position.
---
---The input position params can also be a single tile position.
---@param _x int
---@param _y int
---@return LuaTile
function LuaSurface.get_tile(_x, _y) end

---Gets the total amount of pollution on the surface by iterating over all of the chunks containing pollution.
---@return double
function LuaSurface.get_total_pollution() end

---Gets train stops matching the given filters.
---@param _table? LuaSurface.get_train_stops
---@return LuaEntity[]
function LuaSurface.get_train_stops(_table) end

---@param _force? ForceIdentification @If given only trains matching this force are returned.
---@return LuaTrain[]
function LuaSurface.get_trains(_force) end

---All methods and properties that this object supports.
---@return string
function LuaSurface.help() end

---Is a given chunk generated?
---@param _position ChunkPosition @The chunk's position.
---@return boolean
function LuaSurface.is_chunk_generated(_position) end

---Play a sound for every player on this surface.
---@param _table LuaSurface.play_sound
function LuaSurface.play_sound(_table) end

---Spawn pollution at the given position.
---@param _source MapPosition @Where to spawn the pollution.
---@param _amount double @How much pollution to add.
function LuaSurface.pollute(_source, _amount) end

---Print text to the chat console of all players on this surface.
---
---Messages that are identical to a message sent in the last 60 ticks are not printed again.
---@param _message LocalisedString
---@param _color? Color
function LuaSurface.print(_message, _color) end

---Regenerate autoplacement of some decoratives on this surface. This can be used to autoplace newly-added decoratives.
---
---All specified decorative prototypes must be autoplacable. If nothing is given all decoratives are generated on all chunks.
---@param _decoratives? string|string[] @Prototype names of decorative or decoratives to autoplace. When `nil` all decoratives with an autoplace are used.
---@param _chunks? ChunkPosition[] @The chunk positions to regenerate the entities on. If not given all chunks are regenerated. Note chunks with status < entities are ignored.
function LuaSurface.regenerate_decorative(_decoratives, _chunks) end

---Regenerate autoplacement of some entities on this surface. This can be used to autoplace newly-added entities.
---
---All specified entity prototypes must be autoplacable. If nothing is given all entities are generated on all chunks.
---@param _entities? string|string[] @Prototype names of entity or entities to autoplace. When `nil` all entities with an autoplace are used.
---@param _chunks? ChunkPosition[] @The chunk positions to regenerate the entities on. If not given all chunks are regenerated. Note chunks with status < entities are ignored.
function LuaSurface.regenerate_entity(_entities, _chunks) end

---Removes the given script area.
---@param _id uint
---@return boolean @If the area was actually removed. False when it didn't exist.
function LuaSurface.remove_script_area(_id) end

---Removes the given script position.
---@param _id uint
---@return boolean @If the position was actually removed. False when it didn't exist.
function LuaSurface.remove_script_position(_id) end

---Generates a path with the specified constraints (as an array of [PathfinderWaypoints](PathfinderWaypoint)) using the unit pathfinding algorithm. This path can be used to emulate pathing behavior by script for non-unit entities, such as vehicles. If you want to command actual units (such as biters or spitters) to move, use [LuaEntity::set_command](LuaEntity::set_command) instead.
---
---The resulting path is ultimately returned asynchronously via [on_script_path_request_finished](on_script_path_request_finished).
---@param _table LuaSurface.request_path
---@return uint @A unique handle to identify this call when [on_script_path_request_finished](on_script_path_request_finished) fires.
function LuaSurface.request_path(_table) end

---Request that the game's map generator generate chunks at the given position for the given radius on this surface.
---@param _position MapPosition @Where to generate the new chunks.
---@param _radius uint @The chunk radius from `position` to generate new chunks in.
function LuaSurface.request_to_generate_chunks(_position, _radius) end

---Set generated status of a chunk. Useful when copying chunks.
---@param _position ChunkPosition @The chunk's position.
---@param _status defines.chunk_generated_status @The chunk's new status.
function LuaSurface.set_chunk_generated_status(_position, _status) end

---Set the hidden tile for the specified position. While during normal gameplay only [non-mineable](LuaTilePrototype::mineable_properties) tiles can become hidden, this method allows any kind of tile to be set as the hidden one.
---@param _position TilePosition @The tile position.
---@param _tile string|LuaTilePrototype @The new hidden tile or `nil` to clear the hidden tile.
function LuaSurface.set_hidden_tile(_position, _tile) end

---Give a command to multiple units. This will automatically select suitable units for the task.
---@param _table LuaSurface.set_multi_command
---@return uint @Number of units actually sent. May be less than `count` if not enough units were available.
function LuaSurface.set_multi_command(_table) end

---Set tiles at specified locations. Can automatically correct the edges around modified tiles.
---
---Placing a [mineable](LuaTilePrototype::mineable_properties) tile on top of a non-mineable one will turn the latter into the [LuaTile::hidden_tile](LuaTile::hidden_tile) for that tile. Placing a mineable tile on a mineable one or a non-mineable tile on a non-mineable one will not modify the hidden tile. This restriction can however be circumvented by using [LuaSurface::set_hidden_tile](LuaSurface::set_hidden_tile).
---
---It is recommended to call this method once for all the tiles you want to change rather than calling it individually for every tile. As the tile correction is used after every step, calling it one by one could cause the tile correction logic to redo some of the changes. Also, many small API calls are generally more performance intensive than one big one.
---@param _tiles Tile[]
---@param _correct_tiles? boolean @If `false`, the correction logic is not applied to the changed tiles. Defaults to `true`.
---@param _remove_colliding_entities? boolean|string @`true`, `false`, or `abort_on_collision`. Defaults to `true`.
---@param _remove_colliding_decoratives? boolean @`true` or `false`. Defaults to `true`.
---@param _raise_event? boolean @`true` or `false`. Defaults to `false`.
function LuaSurface.set_tiles(_tiles, _correct_tiles, _remove_colliding_entities, _remove_colliding_decoratives, _raise_event) end

---Spill items on the ground centered at a given location.
---@param _position MapPosition @Center of the spillage
---@param _items ItemStackIdentification @Items to spill
---@param _enable_looted? boolean @When true, each created item will be flagged with the [LuaEntity::to_be_looted](LuaEntity::to_be_looted) flag.
---@param _force? LuaForce|string @When provided (and not `nil`) the items will be marked for deconstruction by this force.
---@param _allow_belts? boolean @Whether items can be spilled onto belts. Defaults to `true`.
---@return LuaEntity[] @The created item-on-ground entities.
function LuaSurface.spill_item_stack(_position, _items, _enable_looted, _force, _allow_belts) end

---Place an upgrade request.
---@param _table LuaSurface.upgrade_area
function LuaSurface.upgrade_area(_table) end


---@class LuaSurface.can_fast_replace
---@field name string @Name of the entity to check
---@field position MapPosition @Where the entity would be placed
---@field direction? defines.direction @Direction the entity would be placed
---@field force? ForceIdentification @The force that would place the entity. If not specified, the enemy force is assumed.

---@class LuaSurface.can_place_entity
---@field name string @Name of the entity prototype to check.
---@field position MapPosition @Where the entity would be placed.
---@field direction? defines.direction @Direction of the placed entity.
---@field force? ForceIdentification @The force that would place the entity. If not specified, the enemy force is assumed.
---@field build_check_type? defines.build_check_type @Which type of check should be carried out.
---@field forced? boolean @If `true`, entities that can be marked for deconstruction are ignored. Only used if `build_check_type` is either `manual_ghost`, `script_ghost` or `blueprint_ghost`.
---@field inner_name? string @The prototype name of the entity contained in the ghost. Only used if `name` is `entity-ghost`.

---@class LuaSurface.cancel_deconstruct_area
---@field area BoundingBox @The area to cancel deconstruction orders in.
---@field force ForceIdentification @The force whose deconstruction orders to cancel.
---@field player? PlayerIdentification @The player to set the last_user to if any.
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.
---@field item? LuaItemStack @The deconstruction item to use if any.

---@class LuaSurface.cancel_upgrade_area
---@field area BoundingBox @The area to cancel upgrade orders in.
---@field force ForceIdentification @The force whose upgrade orders to cancel.
---@field player? PlayerIdentification @The player to set the last_user to if any.
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.
---@field item? LuaItemStack @The upgrade item to use if any.

---@class LuaSurface.clone_area
---@field source_area BoundingBox
---@field destination_area BoundingBox
---@field destination_surface? SurfaceIdentification
---@field destination_force? LuaForce|string
---@field clone_tiles? boolean @If tiles should be cloned
---@field clone_entities? boolean @If entities should be cloned
---@field clone_decoratives? boolean @If decoratives should be cloned
---@field clear_destination_entities? boolean @If the destination entities should be cleared
---@field clear_destination_decoratives? boolean @If the destination decoratives should be cleared
---@field expand_map? boolean @If the destination surface should be expanded when destination_area is outside current bounds. Default false.
---@field create_build_effect_smoke? boolean @If true, the building effect smoke will be shown around the new entities.

---@class LuaSurface.clone_brush
---@field source_offset TilePosition
---@field destination_offset TilePosition
---@field source_positions TilePosition[]
---@field destination_surface? SurfaceIdentification
---@field destination_force? LuaForce|string
---@field clone_tiles? boolean @If tiles should be cloned
---@field clone_entities? boolean @If entities should be cloned
---@field clone_decoratives? boolean @If decoratives should be cloned
---@field clear_destination_entities? boolean @If the destination entities should be cleared
---@field clear_destination_decoratives? boolean @If the destination decoratives should be cleared
---@field expand_map? boolean @If the destination surface should be expanded when destination_area is outside current bounds. Default false.
---@field manual_collision_mode? boolean @If manual-style collision checks should be done.
---@field create_build_effect_smoke? boolean @If true, the building effect smoke will be shown around the new entities.

---@class LuaSurface.clone_entities
---@field entities LuaEntity[]
---@field destination_offset Vector
---@field destination_surface? SurfaceIdentification
---@field destination_force? ForceIdentification
---@field snap_to_grid? boolean
---@field create_build_effect_smoke? boolean @If true, the building effect smoke will be shown around the new entities.

---@class LuaSurface.count_entities_filtered
---@field area? BoundingBox
---@field position? MapPosition
---@field radius? double @If given with position, will count all entities within the radius of the position.
---@field name? string|string[]
---@field type? string|string[]
---@field ghost_name? string|string[]
---@field ghost_type? string|string[]
---@field direction? defines.direction|defines.direction[]
---@field collision_mask? CollisionMaskLayer|CollisionMaskLayer[]
---@field force? ForceIdentification|ForceIdentification[]
---@field to_be_deconstructed? boolean
---@field to_be_upgraded? boolean
---@field limit? uint
---@field is_military_target? boolean
---@field invert? boolean @Whether the filters should be inverted.

---@class LuaSurface.count_tiles_filtered
---@field area? BoundingBox
---@field position? MapPosition @Ignored if not given with radius.
---@field radius? double @If given with position, will return all entities within the radius of the position.
---@field name? string|string[]
---@field force? ForceIdentification|ForceIdentification[]
---@field limit? uint
---@field has_hidden_tile? boolean
---@field has_tile_ghost? boolean @Can be further filtered by supplying a `force` filter.
---@field to_be_deconstructed? boolean @Can be further filtered by supplying a `force` filter.
---@field collision_mask? CollisionMaskLayer|CollisionMaskLayer[]
---@field invert? boolean @If the filters should be inverted.

---@class LuaSurface.create_decoratives
---@field check_collision? boolean @If collision should be checked against entities/tiles.
---@field decoratives Decorative[]

---@class LuaSurface.create_entity
---@field name string @The entity prototype name to create.
---@field position MapPosition @Where to create the entity.
---@field direction? defines.direction @Desired orientation of the entity after creation.
---@field force? ForceIdentification @Force of the entity, default is enemy.
---@field target? LuaEntity|MapPosition @Entity with health for the new entity to target.
---@field source? LuaEntity|MapPosition @Source entity. Used for beams and highlight-boxes.
---@field fast_replace? boolean @If true, building will attempt to simulate fast-replace building.
---@field player? PlayerIdentification @If given set the last_user to this player. If fast_replace is true simulate fast replace using this player.
---@field spill? boolean @If false while fast_replace is true and player is nil any items from fast-replacing will be deleted instead of dropped on the ground.
---@field raise_built? boolean @If true; [defines.events.script_raised_built](defines.events.script_raised_built) will be fired on successful entity creation.
---@field create_build_effect_smoke? boolean @If false, the building effect smoke will not be shown around the new entity.
---@field spawn_decorations? boolean @If true, entity types that have spawn_decorations property will apply triggers defined in the property.
---@field move_stuck_players? boolean @If true, any characters that are in the way of the entity are teleported out of the way.
---@field item? LuaItemStack @If provided, the entity will attempt to pull stored values from this item (for example; creating a spidertron from a previously named and mined spidertron)

---@class LuaSurface.create_particle
---@field name string @The particle name.
---@field position MapPosition @Where to create the particle.
---@field movement Vector
---@field height float
---@field vertical_speed float
---@field frame_speed float

---@class LuaSurface.create_trivial_smoke
---@field name string @The smoke prototype name to create.
---@field position MapPosition @Where to create the smoke.

---@class LuaSurface.create_unit_group
---@field position MapPosition @Initial position of the new unit group.
---@field force? ForceIdentification @Force of the new unit group. Defaults to `"enemy"`.

---@class LuaSurface.deconstruct_area
---@field area BoundingBox @The area to mark for deconstruction.
---@field force ForceIdentification @The force whose bots should perform the deconstruction.
---@field player? PlayerIdentification @The player to set the last_user to if any.
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.
---@field item? LuaItemStack @The deconstruction item to use if any.

---@class LuaSurface.destroy_decoratives
---@field area? BoundingBox
---@field position? TilePosition
---@field name? string|string[]|LuaDecorativePrototype|LuaDecorativePrototype[]
---@field collision_mask? CollisionMaskLayer|CollisionMaskLayer[]
---@field from_layer? string
---@field to_layer? string
---@field exclude_soft? boolean @Soft decoratives can be drawn over rails.
---@field limit? uint
---@field invert? boolean @If the filters should be inverted.

---@class LuaSurface.find_decoratives_filtered
---@field area? BoundingBox
---@field position? TilePosition
---@field name? string|string[]|LuaDecorativePrototype|LuaDecorativePrototype[]
---@field collision_mask? CollisionMaskLayer|CollisionMaskLayer[]
---@field from_layer? string
---@field to_layer? string
---@field exclude_soft? boolean @Soft decoratives can be drawn over rails.
---@field limit? uint
---@field invert? boolean @If the filters should be inverted.

---@class LuaSurface.find_entities_filtered
---@field area? BoundingBox
---@field position? MapPosition @Has precedence over area field.
---@field radius? double
---@field name? string|string[]
---@field type? string|string[]
---@field ghost_name? string|string[]
---@field ghost_type? string|string[]
---@field direction? defines.direction|defines.direction[]
---@field collision_mask? CollisionMaskLayer|CollisionMaskLayer[]
---@field force? ForceIdentification|ForceIdentification[]
---@field to_be_deconstructed? boolean
---@field to_be_upgraded? boolean
---@field limit? uint
---@field is_military_target? boolean
---@field invert? boolean @Whether the filters should be inverted.

---@class LuaSurface.find_nearest_enemy
---@field position MapPosition @Center of the search area.
---@field max_distance double @Radius of the circular search area.
---@field force? ForceIdentification @The force the result will be an enemy of. Uses the player force if not specified.

---@class LuaSurface.find_nearest_enemy_entity_with_owner
---@field position MapPosition @Center of the search area.
---@field max_distance double @Radius of the circular search area.
---@field force? ForceIdentification @The force the result will be an enemy of. Uses the player force if not specified.

---@class LuaSurface.find_tiles_filtered
---@field area? BoundingBox
---@field position? MapPosition @Ignored if not given with radius.
---@field radius? double @If given with position, will return all entities within the radius of the position.
---@field name? string|string[]
---@field force? ForceIdentification|ForceIdentification[]
---@field limit? uint
---@field has_hidden_tile? boolean
---@field has_tile_ghost? boolean @Can be further filtered by supplying a `force` filter.
---@field to_be_deconstructed? boolean @Can be further filtered by supplying a `force` filter.
---@field collision_mask? CollisionMaskLayer|CollisionMaskLayer[]
---@field invert? boolean @Whether the filters should be inverted.

---@class LuaSurface.find_units
---@field area BoundingBox @Box to find units within.
---@field force LuaForce|string @Force performing the search.
---@field condition ForceCondition @Only forces which meet the condition will be included in the search.

---@class LuaSurface.get_train_stops
---@field name? string|string[]
---@field force? ForceIdentification

---@class LuaSurface.play_sound
---@field path SoundPath @The sound to play.
---@field position? MapPosition @Where the sound should be played. If not given, it's played at the current position of each player.
---@field volume_modifier? double @The volume of the sound to play. Must be between 0 and 1 inclusive.
---@field override_sound_type? SoundType @The volume mixer to play the sound through. Defaults to the default mixer for the given sound type.

---@class LuaSurface.request_path
---@field bounding_box BoundingBox @The dimensions of the object that's supposed to travel the path.
---@field collision_mask CollisionMaskWithFlags|string[] @The list of masks the `bounding_box` collides with.
---@field start MapPosition @The position from which to start pathfinding.
---@field goal MapPosition @The position to find a path to.
---@field force ForceIdentification @The force for which to generate the path, determining which gates can be opened for example.
---@field radius? double @How close the pathfinder needs to get to its `goal` (in tiles). Defaults to `1`.
---@field pathfind_flags? PathfinderFlags @Flags that affect pathfinder behavior.
---@field can_open_gates? boolean @Whether the path request can open gates. Defaults to `false`.
---@field path_resolution_modifier? int @Defines how coarse the pathfinder's grid is. Smaller values mean a coarser grid (negative numbers allowed). Defaults to `0`.
---@field entity_to_ignore? LuaEntity @Makes the pathfinder ignore collisions with this entity if it is given.

---@class LuaSurface.set_multi_command
---@field command Command
---@field unit_count uint @Number of units to give the command to.
---@field force? ForceIdentification @Force of the units this command is to be given to. If not specified, uses the enemy force.
---@field unit_search_distance? uint @Radius to search for units. The search area is centered on the destination of the command.

---@class LuaSurface.upgrade_area
---@field area BoundingBox @The area to mark for upgrade.
---@field force ForceIdentification @The force whose bots should perform the upgrade.
---@field player? PlayerIdentification @The player to set the last_user to if any.
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.
---@field item LuaItemStack @The upgrade item to use.

