---@meta

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

