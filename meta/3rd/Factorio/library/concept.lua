---@meta

---@class AchievementPrototypeFilter
---@field filter "type" @The condition to filter on. One of `"allowed-without-fight"`, `"type"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field type? string|string[]

---@class AdvancedMapGenSettings
---@field difficulty_settings DifficultySettings
---@field enemy_evolution EnemyEvolutionMapSettings
---@field enemy_expansion EnemyExpansionMapSettings
---@field pollution PollutionMapSettings

---@class Alert
---@field icon? SignalID @The SignalID used for a custom alert. Only present for custom alerts.
---@field message? LocalisedString @The message for a custom alert. Only present for custom alerts.
---@field position? MapPosition
---@field prototype? LuaEntityPrototype
---@field target? LuaEntity
---@field tick uint @The tick this alert was created.

---A [string](string) that specifies where a GUI element should be.
---@alias Alignment
---| "top-left"
---| "middle-left"
---| "left"
---| "bottom-left"
---| "top-center"
---| "middle-center"
---| "center"
---| "bottom-center"
---| "top-right"
---| "right"
---| "bottom-right"

---@class AmmoType
---@field action? TriggerItem[]
---@field category string @Ammo category of this ammo.
---@field clamp_position? boolean @When `true`, the gun will be able to shoot even when the target is out of range. Only applies when `target_type` is `position`. The gun will fire at the maximum range in the direction of the target position. Defaults to `false`.
---@field energy_consumption? double @Energy consumption of a single shot, if applicable. Defaults to `0`.
---@field target_type string @One of `"entity"` (fires at an entity), `"position"` (fires directly at a position), or `"direction"` (fires in a direction).

---Any basic type (string, number, boolean), table, or LuaObject.
---@alias Any  any

---Any basic type (string, number, boolean) or table.
---@alias AnyBasic  any

---@class ArithmeticCombinatorParameters
---@field first_constant? int @Constant to use as the first argument of the operation. Has no effect when `first_signal` is set. Defaults to `0`.
---@field first_signal? SignalID @First signal to use in an operation. If not specified, the second argument will be the value of `first_constant`.
---@field operation? string @Must be one of `"*"`, `"/"`, `"+"`, `"-"`, `"%"`, `"^"`, `"<<"`, `">>"`, `"AND"`, `"OR"`, `"XOR"`. When not specified, defaults to `"*"`.
---@field output_signal? SignalID @Specifies the signal to output.
---@field second_constant? int @Constant to use as the second argument of the operation. Has no effect when `second_signal` is set. Defaults to `0`.
---@field second_signal? SignalID @Second signal to use in an operation. If not specified, the second argument will be the value of `second_constant`.

---@class AttackParameterFluid
---@field damage_modifier double @Multiplier applied to the damage of an attack.
---@field type string @Name of the [LuaFluidPrototype](LuaFluidPrototype).

---@class AttackParameters
---@field ammo_categories? string[] @List of the names of compatible [LuaAmmoCategoryPrototypes](LuaAmmoCategoryPrototype).
---@field ammo_consumption_modifier float @Multiplier applied to the ammo consumption of an attack.
---@field ammo_type? AmmoType
---@field cooldown float @Minimum amount of ticks between shots. If this is less than `1`, multiple shots can be performed per tick.
---@field damage_modifier float @Multiplier applied to the damage of an attack.
---@field fire_penalty float @When searching for the nearest enemy to attack, `fire_penalty` is added to the enemy's distance if they are on fire.
---@field health_penalty float @When searching for an enemy to attack, a higher `health_penalty` will discourage targeting enemies with high health. A negative penalty will do the opposite.
---@field min_attack_distance float @If less than `range`, the entity will choose a random distance between `range` and `min_attack_distance` and attack from that distance. Used for spitters.
---@field min_range float @Minimum range of attack. Used with flamethrower turrets to prevent self-immolation.
---@field movement_slow_down_cooldown float
---@field movement_slow_down_factor double
---@field range float @Maximum range of attack.
---@field range_mode string @Defines how the range is determined. Either `'center-to-center'` or `'bounding-box-to-bounding-box'`.
---@field rotate_penalty float @When searching for an enemy to attack, a higher `rotate_penalty` will discourage targeting enemies that would take longer to turn to face.
---@field turn_range float @The arc that the entity can attack in as a fraction of a circle. A value of `1` means the full 360 degrees.
---@field type string @The type of AttackParameter. One of `'projectile'`, `'stream'` or `'beam'`.
---@field warmup uint @Number of ticks it takes for the weapon to actually shoot after it has been ordered to do so.

---@class AutoplaceControl
---@field frequency MapGenSize @For things that are placed as spots such as ores and enemy bases, frequency is generally proportional to number of spots placed per unit area. For continuous features such as forests, frequency is how compressed the probability function is over distance, i.e. the inverse of 'scale' (similar to terrain_segmentation). When the [LuaAutoplaceControlPrototype](LuaAutoplaceControlPrototype) is of the category `"terrain"`, then scale is shown in the map generator GUI instead of frequency.
---@field richness MapGenSize @Has different effects for different things, but generally affects the 'health' or density of a thing that is placed without affecting where it is placed. For trees, richness affects tree health. For ores, richness multiplies the amount of ore at any given tile in a patch. Metadata about autoplace controls (such as whether or not 'richness' does anything for them) can be found in the [LuaAutoplaceControlPrototype](LuaAutoplaceControlPrototype) by looking up `game.autoplace_control_prototypes[(control prototype name)]`, e.g. `game.autoplace_control_prototypes["enemy-base"].richness` is false, because enemy base autoplacement doesn't use richness.
---@field size MapGenSize @For things that are placed as spots, size is proportional to the area of each spot. For continuous features, size affects how much of the map is covered with the thing, and is called 'coverage' in the GUI.

---@class AutoplaceSettings
---@field settings table<string, AutoplaceControl>
---@field treat_missing_as_default boolean @Whether missing autoplace names for this type should be default enabled.

---Specifies how probability and richness are calculated when placing something on the map. Can be specified either using `probability_expression` and `richness_expression` or by using all the other fields.
---@class AutoplaceSpecification
---@field control? string @Control prototype name.
---@field coverage double
---@field default_enabled boolean
---@field force string
---@field max_probability double
---@field order string
---@field peaks? AutoplaceSpecificationPeak[]
---@field placement_density uint
---@field probability_expression NoiseExpression
---@field random_probability_penalty double
---@field richness_base double
---@field richness_expression NoiseExpression
---@field richness_multiplier double
---@field richness_multiplier_distance_bonus double
---@field sharpness double
---@field starting_area_size uint
---@field tile_restriction? AutoplaceSpecificationRestriction[]

---@class AutoplaceSpecificationPeak
---@field aux_max_range double
---@field aux_optimal double
---@field aux_range double
---@field aux_top_property_limit double
---@field distance_max_range double
---@field distance_optimal double
---@field distance_range double
---@field distance_top_property_limit double
---@field elevation_max_range double
---@field elevation_optimal double
---@field elevation_range double
---@field elevation_top_property_limit double
---@field influence double
---@field max_influence double
---@field min_influence double
---@field noisePersistence double
---@field noise_layer? string @Prototype name of the noise layer.
---@field noise_octaves_difference double
---@field richness_influence double
---@field starting_area_weight_max_range double
---@field starting_area_weight_optimal double
---@field starting_area_weight_range double
---@field starting_area_weight_top_property_limit double
---@field temperature_max_range double
---@field temperature_optimal double
---@field temperature_range double
---@field temperature_top_property_limit double
---@field tier_from_start_max_range double
---@field tier_from_start_optimal double
---@field tier_from_start_range double
---@field tier_from_start_top_property_limit double
---@field water_max_range double
---@field water_optimal double
---@field water_range double
---@field water_top_property_limit double

---@class AutoplaceSpecificationRestriction
---@field first? string @Tile prototype name
---@field second? string @Second prototype name

---@class BeamTarget
---@field entity? LuaEntity @The target entity.
---@field position? MapPosition @The target position.

---The representation of an entity inside of a blueprint. It has at least these fields, but can contain additional ones depending on the kind of entity.
---@class BlueprintEntity
---@field connections? BlueprintCircuitConnection @The circuit network connections of the entity, if there are any. Only relevant for entities that support circuit connections.
---@field control_behavior? BlueprintControlBehavior @The control behavior of the entity, if it has one. The format of the control behavior depends on the entity's type. Only relevant for entities that support control behaviors.
---@field direction? defines.direction @The direction the entity is facing. Only present for entities that can face in different directions and when the entity is not facing north.
---@field entity_number uint @The entity's unique identifier in the blueprint.
---@field items? table<string, uint> @The items that the entity will request when revived, if there are any. It's a mapping of prototype names to amounts. Only relevant for entity ghosts.
---@field name string @The prototype name of the entity.
---@field position MapPosition @The position of the entity.
---@field schedule? TrainScheduleRecord[] @The schedule of the entity, if it has one. Only relevant for locomotives.
---@field tags? Tags @The entity tags of the entity, if there are any. Only relevant for entity ghosts.

---@class BlueprintItemIcon
---@field index uint @Index of the icon in the blueprint icons slots. Has to be an integer in the range [1, 4].
---@field name string @Name of the item prototype whose icon should be used.

---@class BlueprintSignalIcon
---@field index uint @Index of the icon in the blueprint icons slots. Has to be an integer in the range [1, 4].
---@field signal SignalID @The icon to use. It can be any item icon as well as any virtual signal icon.

---Two positions, specifying the top-left and bottom-right corner of the box respectively. Like with [MapPosition](MapPosition), the names of the members may be omitted. When read from the game, the third member `orientation` is present if it is non-zero, however it is ignored when provided to the game.
---
---Explicit definition: 
---```lua
---{left_top = {x = -2, y = -3}, right_bottom = {x = 5, y = 8}}
---```
---\
---Shorthand: 
---```lua
---{{-2, -3}, {5, 8}}
---```
---@class BoundingBox
---@field left_top MapPosition
---@field [1] MapPosition
---@field right_bottom MapPosition
---@field [2] MapPosition
---@field orientation? RealOrientation
---@field [3] RealOrientation

---@class CapsuleAction
---@field attack_parameters? AttackParameters @Only present when `type` is `"throw"` or `"use-on-self"`.
---@field equipment? string @Only present when `type` is `"equipment-remote"`. It is the equipment prototype name.
---@field type string @One of `"throw"`, `"equipment-remote"`, `"use-on-self"`.

---
---Either `icon`, `text`, or both must be provided.
---@class ChartTagSpec
---@field icon? SignalID
---@field last_user? PlayerIdentification
---@field position MapPosition
---@field text? string

---Coordinates of a chunk in a [LuaSurface](LuaSurface) where each integer `x`/`y` represents a different chunk. This uses the same format as [MapPosition](MapPosition), meaning it can be specified either with or without explicit keys. A [MapPosition](MapPosition) can be translated to a ChunkPosition by dividing the `x`/`y` values by 32.
---@class ChunkPosition
---@field x int
---@field [1] int
---@field y int
---@field [2] int

---A [ChunkPosition](ChunkPosition) with an added bounding box for the area of the chunk.
---@class ChunkPositionAndArea
---@field area BoundingBox
---@field x int
---@field y int

---@class CircuitCondition
---@field comparator? ComparatorString @Specifies how the inputs should be compared. If not specified, defaults to `"<"`.
---@field constant? int @Constant to compare `first_signal` to. Has no effect when `second_signal` is set. When neither `second_signal` nor `constant` are specified, the effect is as though `constant` were specified with the value `0`.
---@field first_signal? SignalID @Defaults to blank
---@field second_signal? SignalID @What to compare `first_signal` to. If not specified, `first_signal` will be compared to `constant`.

---@class CircuitConditionDefinition
---@field condition CircuitCondition
---@field fulfilled? boolean @Whether the condition is currently fulfilled

---@class CircuitConnectionDefinition
---@field source_circuit_id defines.circuit_connector_id
---@field target_circuit_id defines.circuit_connector_id
---@field target_entity LuaEntity
---@field wire defines.wire_type @Wire color, either [defines.wire_type.red](defines.wire_type.red) or [defines.wire_type.green](defines.wire_type.green).

---@class CircularParticleCreationSpecification
---@field center Vector @This vector is a table with `x` and `y` keys instead of an array.
---@field creation_distance double
---@field creation_distance_orientation double
---@field direction float
---@field direction_deviation float
---@field height float
---@field height_deviation float
---@field name string @Name of the [LuaEntityPrototype](LuaEntityPrototype)
---@field speed float
---@field speed_deviation float
---@field starting_frame_speed float
---@field starting_frame_speed_deviation float
---@field use_source_position boolean
---@field vertical_speed float
---@field vertical_speed_deviation float

---An array with the following members:
---- A [RealOrientation](RealOrientation)
---- A [Vector](Vector)
---@alias CircularProjectileCreationSpecification  any

---@alias CliffOrientation
---| "west-to-east"
---| "north-to-south"
---| "east-to-west"
---| "south-to-north"
---| "west-to-north"
---| "north-to-east"
---| "east-to-south"
---| "south-to-west"
---| "west-to-south"
---| "north-to-west"
---| "east-to-north"
---| "south-to-east"
---| "west-to-none"
---| "none-to-east"
---| "east-to-none"
---| "none-to-west"
---| "north-to-none"
---| "none-to-south"
---| "south-to-none"
---| "none-to-north"

---@class CliffPlacementSettings
---@field cliff_elevation_0 float @Elevation at which the first row of cliffs is placed. The default is `10`, and this cannot be set from the map generation GUI.
---@field cliff_elevation_interval float @Elevation difference between successive rows of cliffs. This is inversely proportional to 'frequency' in the map generation GUI. Specifically, when set from the GUI the value is `40 / frequency`.
---@field name string @Name of the cliff prototype.
---@field richness MapGenSize @Corresponds to 'continuity' in the GUI. This value is not used directly, but is used by the 'cliffiness' noise expression, which in combination with elevation and the two cliff elevation properties drives cliff placement (cliffs are placed when elevation crosses the elevation contours defined by `cliff_elevation_0` and `cliff_elevation_interval` when 'cliffiness' is greater than `0.5`). The default 'cliffiness' expression interprets this value such that larger values result in longer unbroken walls of cliffs, and smaller values (between `0` and `1`) result in larger gaps in cliff walls.

---This is a set of masks given as a dictionary[[CollisionMaskLayer](CollisionMaskLayer) &rarr; [boolean](boolean)]. Only set masks are present in the dictionary and they have the value `true`. Unset flags aren't present at all.
---@alias CollisionMask  any

---A [string](string) specifying a collision mask layer.
---
---Possible values for the string are:
---- `"ground-tile"`
---- `"water-tile"`
---- `"resource-layer"`
---- `"doodad-layer"`
---- `"floor-layer"`
---- `"item-layer"`
---- `"ghost-layer"`
---- `"object-layer"`
---- `"player-layer"`
---- `"train-layer"`
---- `"rail-layer"`
---- `"transport-belt-layer"`
---- `"not-setup"`
---
---Additionally the values `"layer-13"` through `"layer-55"`. These layers are currently unused by the game but may change. If a mod is going to use one of the unused layers it's recommended to start at the higher layers because the base game will take from the lower ones.
---@alias CollisionMaskLayer  any

---A [CollisionMask](CollisionMask) which also includes any flags this mask has.
---
---Flags such as:
---- `"not-colliding-with-itself"`: Any two entities that both have this option enabled on their prototype and have an identical collision mask layers list will not collide. Other collision mask options are not included in the identical layer list check. This does mean that two different prototypes with the same collision mask layers and this option enabled will not collide.
---- `"consider-tile-transitions"`: Uses the prototypes position rather than its collision box when doing collision checks with tile prototypes. Allows the prototype to overlap colliding tiles up until its center point. This is only respected for character movement and cars driven by players.
---- `"colliding-with-tiles-only"`: Any prototype with this collision option will only be checked for collision with other prototype's collision masks if they are a tile.
---@alias CollisionMaskWithFlags  any

---Red, green, blue and alpha values, all in range [0, 1] or all in range [0, 255] if any value is > 1. All values here are optional. Color channels default to `0`, the alpha channel defaults to `1`.
---
---Similar to [MapPosition](MapPosition), Color allows the short-hand notation of passing an array of exactly 3 or 4 numbers. The game usually expects colors to be in pre-multiplied form (color channels are pre-multiplied by alpha).
---
---```lua
---red1 = {r = 0.5, g = 0, b = 0, a = 0.5}  -- Half-opacity red
---red2 = {r = 0.5, a = 0.5}                -- Same color as red1
---black = {}                               -- All channels omitted: black
---red1_short = {0.5, 0, 0, 0.5}            -- Same color as red1 in short-hand notation
---```
---@class Color
---@field r? float
---@field [1] float
---@field g? float
---@field [2] float
---@field b? float
---@field [3] float
---@field a? float
---@field [4] float

---Same as [Color](Color), but red, green, blue and alpha values can be any floating point number, without any special handling of the range [1, 255].
---@class ColorModifier
---@field r? float
---@field [1] float
---@field g? float
---@field [2] float
---@field b? float
---@field [3] float
---@field a? float
---@field [4] float

---Commands can be given to enemies and unit groups.
---@class Command
---@field type defines.command @Type of command. The remaining fields depend on the value of this field.

---
---While the API accepts both versions for `"less/greater than or equal to"` and `"not equal"`, it'll always return `"≥"`, `"≤"` or `"≠"` respectively when reading them back.
---@alias ComparatorString
---| "="
---| ">"
---| "<"
---| "≥"
---| ">="
---| "≤"
---| "<="
---| "≠"
---| "!="

---@class ConfigurationChangedData
---@field migration_applied boolean @`true` when mod prototype migrations have been applied since the last time this save was loaded.
---@field mod_changes table<string, ModChangeData> @Dictionary of mod changes. It is indexed by mod name.
---@field mod_startup_settings_changed boolean @`true` when mod startup settings have changed since the last time this save was loaded.
---@field new_version? string @New version of the map. Present only when loading map version other than the current version.
---@field old_version? string @Old version of the map. Present only when loading map version other than the current version.

---@class ConstantCombinatorParameters
---@field count int @Value of the signal to emit.
---@field index uint @Index of the constant combinator's slot to set this signal to.
---@field signal SignalID @Signal to emit.

---@class CraftingQueueItem
---@field count uint @The amount of items being crafted.
---@field index uint @The index of the item in the crafting queue.
---@field prerequisite boolean @The item is a prerequisite for another item in the queue.
---@field recipe string @The recipe being crafted.

---@alias CursorBoxRenderType
---| "entity"
---| "not-allowed"
---| "electricity"
---| "pair"
---| "copy"
---| "train-visualization"
---| "logistics"
---| "blueprint-snap-rectangle"

---@class CustomCommandData
---@field name string @The name of the command.
---@field parameter? string @The parameter passed after the command, if there is one.
---@field player_index? uint @The player who issued the command, or `nil` if it was issued from the server console.
---@field tick uint @The tick the command was used in.

---@class CutsceneWaypoint
---@field position? MapPosition @Position to pan the camera to.
---@field target? LuaEntity|LuaUnitGroup @Entity or unit group to pan the camera to.
---@field time_to_wait uint @Time in ticks to wait before moving to the next waypoint.
---@field transition_time uint @How many ticks it will take to reach this waypoint from the previous one.
---@field zoom? double @Zoom level to be set when the waypoint is reached. When not specified, the previous waypoint's zoom is used.

---@class DeciderCombinatorParameters
---@field comparator? ComparatorString @Specifies how the inputs should be compared. If not specified, defaults to `"<"`.
---@field constant? uint @Constant to use as the second argument of operation. Defaults to `0`.
---@field copy_count_from_input? boolean @Defaults to `true`. When `false`, will output a value of `1` for the given `output_signal`.
---@field first_signal? SignalID @Defaults to blank.
---@field output_signal? SignalID @Defaults to blank.
---@field second_signal? SignalID @Second signal to use in an operation, if any. If this is not specified, the second argument to a decider combinator's operation is assumed to be the value of `constant`.

---@class Decorative
---@field amount uint8
---@field name string @The name of the decorative prototype.
---@field position TilePosition

---@class DecorativePrototypeFilter
---@field filter "collision-mask" @The condition to filter on. One of `"decal"`, `"autoplace"`, `"collision-mask"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field mask_mode? string
---@field mask? CollisionMask|CollisionMaskWithFlags

---@class DecorativeResult
---@field amount uint
---@field decorative LuaDecorativePrototype
---@field position TilePosition

---Technology and recipe difficulty settings. Updating any of the attributes will immediately take effect in the game engine.
---@class DifficultySettings
---@field recipe_difficulty defines.difficulty_settings.recipe_difficulty
---@field research_queue_setting string @Either `"after-victory"`, `"always"` or `"never"`. Changing this to `"always"` or `"after-victory"` does not automatically unlock the research queue. See [LuaForce](LuaForce) for that.
---@field technology_difficulty defines.difficulty_settings.technology_difficulty
---@field technology_price_multiplier double @A value in range [0.001, 1000].

---@class DisplayResolution
---@field height uint
---@field width uint

---These values represent a percentual increase in evolution. This means a value of `0.1` would increase evolution by 10%.
---@class EnemyEvolutionMapSettings
---@field destroy_factor double @The amount evolution progresses for every destroyed spawner. Defaults to `0.002`.
---@field enabled boolean @Whether enemy evolution is enabled at all.
---@field pollution_factor double @The amount evolution progresses for every unit of pollution. Defaults to `0.0000009`.
---@field time_factor double @The amount evolution naturally progresses by every second. Defaults to `0.000004`.

---Candidate chunks are given scores to determine which one of them should be expanded into. This score takes into account various settings noted below. The iteration is over a square region centered around the chunk for which the calculation is done, and includes the central chunk as well. Distances are calculated as [Manhattan distance](https://en.wikipedia.org/wiki/Taxicab_geometry).
---
---The pseudocode algorithm to determine a chunk's score is as follows:
---
---```lua
---player = 0
---for neighbour in all chunks within enemy_building_influence_radius from chunk:
---  player += number of player buildings on neighbour
---          * building_coefficient
---          * neighbouring_chunk_coefficient^distance(chunk, neighbour)
---
---base = 0
---for neighbour in all chunk within friendly_base_influence_radius from chunk:
---  base += num of enemy bases on neighbour
---          * other_base_coefficient
---          * neighbouring_base_chunk_coefficient^distance(chunk, neighbour)
---
---score(chunk) = 1 / (1 + player + base)
---```
---@class EnemyExpansionMapSettings
---@field building_coefficient double @Defaults to `0.1`.
---@field enabled boolean @Whether enemy expansion is enabled at all.
---@field enemy_building_influence_radius uint @Defaults to `2`.
---@field friendly_base_influence_radius uint @Defaults to `2`.
---@field max_colliding_tiles_coefficient double @A chunk has to have at most this high of a percentage of unbuildable tiles for it to be considered a candidate to avoid chunks full of water as candidates. Defaults to `0.9`, or 90%.
---@field max_expansion_cooldown uint @The maximum time between expansions in ticks. The actual cooldown is adjusted to the current evolution levels. Defaults to `60*3,600=216,000` ticks.
---@field max_expansion_distance uint @Distance in chunks from the furthest base around to prevent expansions from reaching too far into the player's territory. Defaults to `7`.
---@field min_expansion_cooldown uint @The minimum time between expansions in ticks. The actual cooldown is adjusted to the current evolution levels. Defaults to `4*3,600=14,400` ticks.
---@field neighbouring_base_chunk_coefficient double @Defaults to `0.4`.
---@field neighbouring_chunk_coefficient double @Defaults to `0.5`.
---@field other_base_coefficient double @Defaults to `2.0`.
---@field settler_group_max_size uint @The maximum size of a biter group that goes to build a new base. This is multiplied by the evolution factor. Defaults to `20`.
---@field settler_group_min_size uint @The minimum size of a biter group that goes to build a new base. This is multiplied by the evolution factor. Defaults to `5`.

---@class EntityPrototypeFilter
---@field filter "name"|"type"|"collision-mask"|"flag"|"build-base-evolution-requirement"|"selection-priority"|"emissions"|"crafting-category" @The condition to filter on. One of `"flying-robot"`, `"robot-with-logistics-interface"`, `"rail"`, `"ghost"`, `"explosion"`, `"vehicle"`, `"crafting-machine"`, `"rolling-stock"`, `"turret"`, `"transport-belt-connectable"`, `"wall-connectable"`, `"buildable"`, `"placable-in-editor"`, `"clonable"`, `"selectable"`, `"hidden"`, `"entity-with-health"`, `"building"`, `"fast-replaceable"`, `"uses-direction"`, `"minable"`, `"circuit-connectable"`, `"autoplace"`, `"blueprintable"`, `"item-to-place"`, `"name"`, `"type"`, `"collision-mask"`, `"flag"`, `"build-base-evolution-requirement"`, `"selection-priority"`, `"emissions"`, `"crafting-category"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field crafting_category? string
---@field type? string|string[]
---@field name? string|string[]
---@field value? double|uint8
---@field flag? string
---@field mask? CollisionMask|CollisionMaskWithFlags
---@field comparison? ComparatorString
---@field mask_mode? string

---This is a set of flags given as a dictionary[[string](string) &rarr; [boolean](boolean)]. When a flag is set, it is present in the dictionary with the value `true`. Unset flags aren't present in the dictionary at all. So, the boolean value is meaningless and exists just for easy table lookup if a flag is set.
---
---By default, none of these flags are set.
---@class EntityPrototypeFlags
---@field not-rotatable boolean @Prevents the entity from being rotated before or after placement.
---@field placeable-neutral boolean @Determines the default force when placing entities in the map editor and using the "AUTO" option for the force.
---@field placeable-player boolean @Determines the default force when placing entities in the map editor and using the "AUTO" option for the force.
---@field placeable-enemy boolean @Determines the default force when placing entities in the map editor and using the "AUTO" option for the force.
---@field placeable-off-grid boolean @Determines whether the entity needs to be aligned with the invisible grid within the world. Most entities are confined in this way, with a few exceptions such as trees and land mines.
---@field player-creation boolean @Makes it possible to blueprint, deconstruct, and repair the entity (which can be turned off again using the specific flags). Makes it possible for the biter AI to target the entity as a distraction. Enables dust to automatically be created when building the entity. If the entity does not have a `map_color` set, this flag makes the entity appear on the map with the default color specified by the UtilityConstants.
---@field building-direction-8-way boolean @Uses 45 degree angle increments when selecting direction.
---@field filter-directions boolean @Used to automatically detect the proper direction of the entity if possible. Used by the pump, train stop, and train signal by default.
---@field fast-replaceable-no-build-while-moving boolean @Fast replace will not apply when building while moving.
---@field breaths-air boolean @Used to specify that the entity breathes air, and is thus affected by poison.
---@field not-repairable boolean @Used to specify that the entity can not be 'healed' by repair packs.
---@field not-on-map boolean @Prevents the entity from being drawn on the map.
---@field not-deconstructable boolean @Prevents the entity from being deconstructed.
---@field not-blueprintable boolean @Prevents the entity from being part of a blueprint.
---@field hidden boolean @Hides the entity from the bonus GUI and from the "made in"-property of recipe tooltips.
---@field hide-alt-info boolean @Hides the alt-info of this entity when in alt-mode.
---@field fast-replaceable-no-cross-type-while-moving boolean @Does not fast replace this entity over other entity types when building while moving.
---@field no-gap-fill-while-building boolean
---@field not-flammable boolean @Does not apply fire stickers to the entity.
---@field no-automated-item-removal boolean @Prevents inserters and loaders from taking items from this entity.
---@field no-automated-item-insertion boolean @Prevents inserters and loaders from inserting items into this entity.
---@field no-copy-paste boolean @Prevents the entity from being copy-pasted.
---@field not-selectable-in-game boolean @Disallows selection of the entity even when a selection box is specified for other reasons. For example, selection boxes are used to determine the size of outlines to be shown when highlighting entities inside electric pole ranges.
---@field not-upgradable boolean @Prevents the entity from being selected by the upgrade planner.
---@field not-in-kill-statistics boolean @Prevents the entity from being shown in the kill statistics.

---@alias EntityPrototypeIdentification LuaEntity|LuaEntityPrototype|string

---A table used to define a manual shape for a piece of equipment.
---@class EquipmentPoint
---@field x uint
---@field y uint

---Position inside an equipment grid. This uses the same format as [MapPosition](MapPosition), meaning it can be specified either with or without explicit keys.
---
---Explicit definition: 
---```lua
---{x = 5, y = 2}
---{y = 2, x = 5}
---```
---\
---Shorthand: 
---```lua
---{1, 2}
---```
---@class EquipmentPosition
---@field x int
---@field [1] int
---@field y int
---@field [2] int

---@class EquipmentPrototypeFilter
---@field filter "type" @The condition to filter on. One of `"item-to-place"`, `"type"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field type? string|string[]

---Information about the event that has been raised. The table can also contain other fields depending on the type of event. See [the list of Factorio events](events.html) for more information on these.
---@class EventData
---@field mod_name? string @The name of the mod that raised the event if it was raised using [LuaBootstrap::raise_event](LuaBootstrap::raise_event).
---@field name defines.events @The identifier of the event this handler was registered to.
---@field tick uint @The tick during which the event happened.

---Used to filter out irrelevant event callbacks in a performant way.
---
---Available filters:
---- [LuaEntityClonedEventFilter](LuaEntityClonedEventFilter)
---- [LuaEntityDamagedEventFilter](LuaEntityDamagedEventFilter)
---- [LuaPlayerMinedEntityEventFilter](LuaPlayerMinedEntityEventFilter)
---- [LuaPreRobotMinedEntityEventFilter](LuaPreRobotMinedEntityEventFilter)
---- [LuaRobotBuiltEntityEventFilter](LuaRobotBuiltEntityEventFilter)
---- [LuaPostEntityDiedEventFilter](LuaPostEntityDiedEventFilter)
---- [LuaEntityDiedEventFilter](LuaEntityDiedEventFilter)
---- [LuaScriptRaisedReviveEventFilter](LuaScriptRaisedReviveEventFilter)
---- [LuaPrePlayerMinedEntityEventFilter](LuaPrePlayerMinedEntityEventFilter)
---- [LuaEntityMarkedForDeconstructionEventFilter](LuaEntityMarkedForDeconstructionEventFilter)
---- [LuaPreGhostDeconstructedEventFilter](LuaPreGhostDeconstructedEventFilter)
---- [LuaEntityDeconstructionCancelledEventFilter](LuaEntityDeconstructionCancelledEventFilter)
---- [LuaEntityMarkedForUpgradeEventFilter](LuaEntityMarkedForUpgradeEventFilter)
---- [LuaSectorScannedEventFilter](LuaSectorScannedEventFilter)
---- [LuaRobotMinedEntityEventFilter](LuaRobotMinedEntityEventFilter)
---- [LuaScriptRaisedDestroyEventFilter](LuaScriptRaisedDestroyEventFilter)
---- [LuaUpgradeCancelledEventFilter](LuaUpgradeCancelledEventFilter)
---- [LuaScriptRaisedBuiltEventFilter](LuaScriptRaisedBuiltEventFilter)
---- [LuaPlayerBuiltEntityEventFilter](LuaPlayerBuiltEntityEventFilter)
---- [LuaPlayerRepairedEntityEventFilter](LuaPlayerRepairedEntityEventFilter)
---
---Filters are always used as an array of filters of a specific type. Every filter can only be used with its corresponding event, and different types of event filters can not be mixed.
---@alias EventFilter  any

---@class Fluid
---@field amount double @Amount of the fluid.
---@field name string @Fluid prototype name of the fluid.
---@field temperature? double @The temperature. When reading from [LuaFluidBox](LuaFluidBox), this field will always be present. It is not necessary to specify it when writing, however. When not specified, the fluid will be set to the fluid's default temperature as specified in the fluid's prototype.

---A definition of a fluidbox connection point.
---@class FluidBoxConnection
---@field max_underground_distance? uint @The maximum tile distance this underground connection can connect at if this is an underground pipe.
---@field positions Vector[] @The 4 cardinal direction connection points for this pipe. This vector is a table with `x` and `y` keys instead of an array.
---@field type string @The connection type: "input", "output", or "input-output".

---@class FluidBoxFilter
---@field maximum_temperature double @The maximum temperature allowed into the fluidbox.
---@field minimum_temperature double @The minimum temperature allowed into the fluidbox.
---@field name string @Fluid prototype name of the filtered fluid.

---@class FluidBoxFilterSpec
---@field force? boolean @Force the filter to be set, regardless of current fluid content.
---@field maximum_temperature? double @The maximum temperature allowed into the fluidbox.
---@field minimum_temperature? double @The minimum temperature allowed into the fluidbox.
---@field name string @Fluid prototype name of the filtered fluid.

---@alias FluidIdentification string|LuaFluidPrototype|Fluid

---@class FluidPrototypeFilter
---@field filter "name"|"subgroup"|"default-temperature"|"max-temperature"|"heat-capacity"|"fuel-value"|"emissions-multiplier"|"gas-temperature" @The condition to filter on. One of `"hidden"`, `"name"`, `"subgroup"`, `"default-temperature"`, `"max-temperature"`, `"heat-capacity"`, `"fuel-value"`, `"emissions-multiplier"`, `"gas-temperature"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field value? double
---@field comparison? ComparatorString
---@field subgroup? string
---@field name? string|string[]

---@alias ForceCondition
---| "all"
---| "enemy"
---| "ally"
---| "friend"
---| "not-friend"
---| "same"
---| "not-same"

---@alias ForceIdentification string|LuaForce

---Parameters that affect the look and control of the game. Updating any of the member attributes here will immediately take effect in the game engine.
---@class GameViewSettings
---@field show_alert_gui boolean @Show the flashing alert icons next to the player's toolbar.`[RW]`
---@field show_controller_gui boolean @Show the controller GUI elements. This includes the toolbar, the selected tool slot, the armour slot, and the gun and ammunition slots.`[RW]`
---@field show_entity_info boolean @Show overlay icons on entities. Also known as "alt-mode".`[RW]`
---@field show_map_view_options boolean @Shows or hides the view options when map is opened.`[RW]`
---@field show_minimap boolean @Show the chart in the upper right-hand corner of the screen.`[RW]`
---@field show_quickbar boolean @Shows or hides quickbar of shortcuts.`[RW]`
---@field show_rail_block_visualisation boolean @When `true` (`false` is default), the rails will always show the rail block visualisation.`[RW]`
---@field show_research_info boolean @Show research progress and name in the upper right-hand corner of the screen.`[RW]`
---@field show_shortcut_bar boolean @Shows or hides the shortcut bar.`[RW]`
---@field show_side_menu boolean @Shows or hides the buttons row.`[RW]`
---@field update_entity_selection boolean @When `true` (the default), mousing over an entity will select it. Otherwise, moving the mouse won't update entity selection.`[RW]`

---@class GuiAnchor
---@field gui defines.relative_gui_type
---@field name? string @If provided, only anchors the GUI element when the opened thing matches the name. `name` takes precedence over `names`.
---@field names? string[] @If provided, only anchors the GUI element when the opened thing matches one of the names. When reading an anchor, `names` is always populated.
---@field position defines.relative_gui_position
---@field type? string @If provided, only anchors the GUI element when the opened things type matches the type.

---Used for specifying where a GUI arrow should point to.
---@class GuiArrowSpecification
---@field type string @This determines which of the following fields will be required. Must be one of `"nowhere"` (will remove the arrow entirely), `"goal"` (will point to the current goal), `"entity_info"`, `"active_window"`, `"entity"`, `"position"`, `"crafting_queue"` or `"item_stack"` (will point to a given item stack in an inventory). Depending on this value, other fields may have to be specified.

---Screen coordinates of a GUI element in a [LuaGui](LuaGui). This uses the same format as [TilePosition](TilePosition), meaning it can be specified either with or without explicit keys.
---@class GuiLocation
---@field x int
---@field [1] int
---@field y int
---@field [2] int

---@class HeatConnection
---@field direction defines.direction
---@field position Vector

---The settings used by a heat-interface type entity.
---@class HeatSetting
---@field mode? string @`"at-least"`, `"at-most"`, `"exactly"`, `"add"`, or `"remove"`. Defaults to `"at-least"`.
---@field temperature? double @The target temperature. Defaults to the minimum temperature of the heat buffer.

---A single filter used by an infinity-filters instance.
---@class InfinityInventoryFilter
---@field count? uint @The count of the filter.
---@field index uint @The index of this filter in the filters list.
---@field mode? string @`"at-least"`, `"at-most"`, or `"exactly"`. Defaults to `"at-least"`.
---@field name string @Name of the item.

---A single filter used by an infinity-pipe type entity.
---@class InfinityPipeFilter
---@field mode? string @`"at-least"`, `"at-most"`, `"exactly"`, `"add"`, or `"remove"`. Defaults to `"at-least"`.
---@field name string @Name of the fluid.
---@field percentage? double @The fill percentage the pipe (e.g. 0.5 for 50%). Can't be negative.
---@field temperature? double @The temperature of the fluid. Defaults to the default/minimum temperature of the fluid.

---@class Ingredient
---@field amount double @Amount of the item or fluid.
---@field catalyst_amount? uint|double @How much of this ingredient is a catalyst.
---@field name string @Prototype name of the required item or fluid.
---@field type string @`"item"` or `"fluid"`.

---@class InserterCircuitConditions
---@field circuit? CircuitCondition
---@field logistics? CircuitCondition

---@class InventoryFilter
---@field index uint @Position of the corresponding filter slot.
---@field name string @Item prototype name of the item to filter.

---@class ItemPrototypeFilter
---@field filter "place-result"|"burnt-result"|"place-as-tile"|"placed-as-equipment-result"|"name"|"type"|"flag"|"subgroup"|"fuel-category"|"stack-size"|"default-request-amount"|"wire-count"|"fuel-value"|"fuel-acceleration-multiplier"|"fuel-top-speed-multiplier"|"fuel-emissions-multiplier" @The condition to filter on. One of `"tool"`, `"mergeable"`, `"item-with-inventory"`, `"selection-tool"`, `"item-with-label"`, `"has-rocket-launch-products"`, `"fuel"`, `"place-result"`, `"burnt-result"`, `"place-as-tile"`, `"placed-as-equipment-result"`, `"name"`, `"type"`, `"flag"`, `"subgroup"`, `"fuel-category"`, `"stack-size"`, `"default-request-amount"`, `"wire-count"`, `"fuel-value"`, `"fuel-acceleration-multiplier"`, `"fuel-top-speed-multiplier"`, `"fuel-emissions-multiplier"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field value? uint|double
---@field type? string|string[]
---@field name? string|string[]
---@field fuel-category? string
---@field flag? string
---@field comparison? ComparatorString
---@field subgroup? string
---@field elem_filters? EntityPrototypeFilter[]|ItemPrototypeFilter[]|TilePrototypeFilter[]|EquipmentPrototypeFilter[]

---This is a set of flags given as dictionary[[string](string) &rarr; [boolean](boolean)]. When a flag is set, it is present in the dictionary with the value `true`. Unset flags aren't present in the dictionary at all. So, the boolean value is meaningless and exists just for easy table lookup if a flag is set.
---
---By default, none of these flags are set.
---@class ItemPrototypeFlags
---@field draw-logistic-overlay boolean @Determines whether the logistics areas of roboports should be drawn when holding this item. Used by the deconstruction planner by default.
---@field hidden boolean @Hides the item in the logistic requests and filters GUIs (among others).
---@field always-show boolean @Always shows the item in the logistic requests and filters GUIs (among others) even when the recipe for that item is locked.
---@field hide-from-bonus-gui boolean @Hides the item from the bonus GUI.
---@field hide-from-fuel-tooltip boolean @Hides the item from the tooltip that's shown when hovering over a burner inventory.
---@field not-stackable boolean @Prevents the item from being stacked. It also prevents the item from stacking in assembling machine input slots, which can otherwise exceed the item stack size if required by the recipe. Additionally, the item does not show an item count when in the cursor.
---@field can-extend-inventory boolean @Makes the item act as an extension to the inventory that it is placed in. Only has an effect for items with inventory.
---@field primary-place-result boolean @Makes construction bots prefer this item when building the entity specified by its `place_result`.
---@field mod-openable boolean @Allows the item to be opened by the player, firing the `on_mod_item_opened` event. Only has an effect for selection tool items.
---@field only-in-cursor boolean @Makes it so the item is deleted when clearing the cursor, instead of being put into the player's inventory. The copy-paste tools use this by default, for example.
---@field spawnable boolean @Allows the item to be spawned by a quickbar shortcut or custom input.

---@alias ItemPrototypeIdentification LuaItemStack|LuaItemPrototype|string

---@class ItemStackDefinition
---@field ammo? double @Amount of ammo in the ammo items in the stack.
---@field count? uint @Number of items the stack holds. If not specified, defaults to `1`.
---@field durability? double @Durability of the tool items in the stack.
---@field health? float @Health of the items in the stack. Defaults to `1.0`.
---@field name string @Prototype name of the item the stack holds.
---@field tags? string[] @Tags of the items with tags in the stack.

---@alias ItemStackIdentification SimpleItemStack|LuaItemStack

---@class ItemStackLocation
---@field inventory defines.inventory
---@field slot uint

---Localised strings are a way to support translation of in-game text. It is an array where the first element is the key and the remaining elements are parameters that will be substituted for placeholders in the template designated by the key.
---
---The key identifies the string template. For example, `"gui-alert-tooltip.attack"` (for the template `"__1__
---    objects are being damaged"`; see the file `data/core/locale/en.cfg`).
---
---The template can contain placeholders such as `__1__` or `__2__`. These will be replaced by the respective parameter in the LocalisedString. The parameters themselves can be other localised strings, which will be processed recursively in the same fashion. Localised strings can not be recursed deeper than 20 levels and can not have more than 20 parameters.
---
---As a special case, when the key is just the empty string, all the parameters will be concatenated (after processing, if any are localised strings). If there is only one parameter, it will be used as is.
---
---Furthermore, when an API function expects a localised string, it will also accept a regular string (i.e. not a table) which will not be translated, as well as a number, boolean or `nil`, which will be converted to their textual representation.
---
---In the English translation, this will print `"No ammo"`; in the Czech translation, it will print `"Bez munice"`: 
---```lua
---game.player.print({"description.no-ammo"})
---```
--- The `description.no-ammo` template contains no placeholders, so no further parameters are necessary.
---\
---In the English translation, this will print `"Durability: 5/9"`; in the Japanese one, it will print `"耐久度: 5/9"`: 
---```lua
---game.player.print({"description.durability", 5, 9})
---```
---\
---This will print `"hello"` in all translations: 
---```lua
---game.player.print({"", "hello"})
---```
---\
---This will print `"Iron plate: 60"` in the English translation and `"Eisenplatte: 60"` in the German translation. 
---```lua
---game.print({"", {"item-name.iron-plate"}, ": ", 60})
---```
---@alias LocalisedString  any

---@class LogisticFilter
---@field count uint @The count for this filter.
---@field index uint @The index this filter applies to.
---@field name string @The item name for this filter.

---@class LogisticParameters
---@field max? uint
---@field min? uint
---@field name? string @The item. `nil` clears the filter.

---@class Loot
---@field count_max double @Maximum amount of loot to drop.
---@field count_min double @Minimum amount of loot to drop.
---@field item string @Item prototype name of the result.
---@field probability double @Probability that any loot at all will drop, as a number in range [0, 1].

---@class LuaEntityClonedEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaEntityDamagedEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name"|"original-damage-amount"|"final-damage-amount"|"damage-type"|"final-health" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`, `"original-damage-amount"`, `"final-damage-amount"`, `"damage-type"`, `"final-health"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field value? float
---@field type? string
---@field name? string
---@field comparison? ComparatorString

---@class LuaEntityDeconstructionCancelledEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaEntityDiedEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaEntityMarkedForDeconstructionEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaEntityMarkedForUpgradeEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaPlayerBuiltEntityEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name"|"force" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`, `"force"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field type? string
---@field name? string
---@field force? string

---@class LuaPlayerMinedEntityEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaPlayerRepairedEntityEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaPostEntityDiedEventFilter
---@field filter "type" @The condition to filter on. Can only be `"type"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field type? string

---@class LuaPreGhostDeconstructedEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaPrePlayerMinedEntityEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaPreRobotMinedEntityEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaRobotBuiltEntityEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name"|"force" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`, `"force"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field type? string
---@field name? string
---@field force? string

---@class LuaRobotMinedEntityEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaScriptRaisedBuiltEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaScriptRaisedDestroyEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaScriptRaisedReviveEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaSectorScannedEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---@class LuaUpgradeCancelledEventFilter
---@field filter "type"|"name"|"ghost_type"|"ghost_name" @The condition to filter on. One of `"ghost"`, `"rail"`, `"rail-signal"`, `"rolling-stock"`, `"robot-with-logistics-interface"`, `"vehicle"`, `"turret"`, `"crafting-machine"`, `"wall-connectable"`, `"transport-belt-connectable"`, `"circuit-network-connectable"`, `"type"`, `"name"`, `"ghost_type"`, `"ghost_name"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field name? string
---@field type? string

---All regular [MapSettings](MapSettings) plus an additional table that contains the [DifficultySettings](DifficultySettings).
---@class MapAndDifficultySettings
---@field difficulty_settings DifficultySettings
---@field enemy_evolution EnemyEvolutionMapSettings
---@field enemy_expansion EnemyExpansionMapSettings
---@field max_failed_behavior_count uint @If a behavior fails this many times, the enemy (or enemy group) is destroyed. This solves biters getting stuck within their own base.
---@field path_finder PathFinderMapSettings
---@field pollution PollutionMapSettings
---@field steering SteeringMapSettings
---@field unit_group UnitGroupMapSettings

---The data that can be extracted from a map exchange string, as a plain table.
---@class MapExchangeStringData
---@field map_gen_settings MapGenSettings
---@field map_settings MapAndDifficultySettings

---@class MapGenPreset
---@field advanced_settings? AdvancedMapGenSettings
---@field basic_settings? MapGenSettings
---@field default? boolean @Whether this is the preset that is selected by default.
---@field order string @The string used to alphabetically sort the presets. It is a simple string that has no additional semantic meaning.

---The 'map type' dropdown in the map generation GUI is actually a selector for elevation generator. The base game sets `property_expression_names.elevation` to `"0_16-elevation"` to reproduce terrain from 0.16 or to `"0_17-island"` for the island preset. If generators are available for other properties, the 'map type' dropdown in the GUI will be renamed to 'elevation' and shown along with selectors for the other selectable properties.
---
---Assuming a NamedNoiseExpression with the name "my-alternate-grass1-probability" is defined 
---```lua
---local surface = game.player.surface
---local mgs = surface.map_gen_settings
---mgs.property_expression_names["tile:grass1:probability"] = "my-alternate-grass1-probability"
---surface.map_gen_settings = mgs
---```
--- would override the probability of grass1 being placed at any given point on the current surface.
---\
---To make there be no deep water on (newly generated chunks) a surface: 
---```lua
---local surface = game.player.surface
---local mgs = surface.map_gen_settings
---mgs.property_expression_names["tile:deepwater:probability"] = -1000
---surface.map_gen_settings = mgs
---```
--- This does not require a NamedNoiseExpression to be defined, since literal numbers (and strings naming literal numbers, e.g. `"123"`) are understood to stand for constant value expressions.
---@class MapGenSettings
---@field autoplace_controls table<string, AutoplaceControl> @Indexed by autoplace control prototype name.
---@field autoplace_settings table<string, AutoplaceSettings> @Each setting in this dictionary maps the string type to the settings for that type. Valid types are `"entity"`, `"tile"` and `"decorative"`.
---@field cliff_settings CliffPlacementSettings @Map generation settings for entities of the type "cliff".
---@field default_enable_all_autoplace_controls boolean @Whether undefined `autoplace_controls` should fall back to the default controls or not. Defaults to `true`.
---@field height uint @Height in tiles. If `0`, the map has 'infinite' height, with the actual limitation being one million tiles in each direction from the center.
---@field peaceful_mode boolean @Whether peaceful mode is enabled for this map.
---Overrides for tile property value generators. Values either name a NamedNoiseExpression or can be literal numbers, stored as strings (e.g. `"5"`). All other controls can be overridden by a property expression names. Notable properties: 
---- `moisture` - a value between 0 and 1 that determines whether a tile becomes sandy (low moisture) or grassy (high moisture).
---- `aux` - a value between 0 and 1 that determines whether low-moisture tiles become sand or red desert.
---- `temperature` - provides a value (vaguely representing degrees Celsius, varying between -20 and 50) that is used (together with moisture and aux) as part of tree and decorative placement.
---- `elevation` - tiles values less than zero become water. Cliffs are placed along certain contours according to [CliffPlacementSettings](CliffPlacementSettings).
---- `cliffiness` - determines whether (when >0.5) or not (when <0.5) a cliff will be placed at an otherwise suitable (according to [CliffPlacementSettings](CliffPlacementSettings)) location.
---- `enemy-base-intensity` - a number that is referenced by both `enemy-base-frequency` and `enemy-base-radius`. i.e. if this is overridden, enemy base frequency and size will both be affected and do something reasonable. By default, this expression returns a value proportional to distance from any starting point, clamped at about 7.
---- `enemy-base-frequency` - a number representing average number of enemy bases per tile for a region, by default in terms of `enemy-base-intensity`.
---- `enemy-base-radius` - a number representing the radius of an enemy base, if one were to be placed on the given tile, by default proportional to a constant plus `enemy-base-intensity`. Climate controls ('Moisture' and 'Terrain type' at the bottom of the Terrain tab in the map generator GUI) don't have their own dedicated structures in MapGenSettings. Instead, their values are stored as property expression overrides with long names: 
---- `control-setting:moisture:frequency:multiplier` - frequency (inverse of scale) multiplier for moisture noise. Default is 1.
---- `control-setting:moisture:bias` - global bias for moisture (which normally varies between 0 and 1). Default is 0.
---- `control-setting:aux:frequency:multiplier` - frequency (inverse of scale) multiplier for aux (called 'terrain type' in the GUI) noise. Default is 1.
---- `control-setting:aux:bias` - global bias for aux/terrain type (which normally varies between 0 and 1). Default is 0. All other MapGenSettings feed into named noise expressions, and therefore placement can be overridden by including the name of a property in this dictionary. The probability and richness functions for placing specific tiles, entities, and decoratives can be overridden by including an entry named `{tile|entity|decorative}:(prototype name):{probability|richness}`.
---@field property_expression_names table<string, string>
---@field seed uint @The random seed used to generated this map.
---@field starting_area MapGenSize @Size of the starting area.
---@field starting_points MapPosition[] @Positions of the starting areas.
---@field terrain_segmentation MapGenSize @The inverse of 'water scale' in the map generator GUI. Lower `terrain_segmentation` increases the scale of elevation features (lakes, continents, etc). This behavior can be overridden with alternate elevation generators (see `property_expression_names`, below).
---@field water MapGenSize @The equivalent to 'water coverage' in the map generator GUI. Specifically, when this value is non-zero, `water_level = 10 * log2` (the value of this field), and the elevation generator subtracts water level from elevation before adding starting lakes. If water is set to 'none', elevation is clamped to a small positive value before adding starting lakes. This behavior can be overridden with alternate elevation generators (see `property_expression_names`, below).
---@field width uint @Width in tiles. If `0`, the map has 'infinite' width, with the actual limitation being one million tiles in each direction from the center.

---A floating point number specifying an amount.
---
---For backwards compatibility, MapGenSizes can also be specified as one of the following strings, which will be converted to a number (when queried, a number will always be returned):
---
---- `"none"` - equivalent to `0`
---- `"very-low"`, `"very-small"`, `"very-poor"` - equivalent to `1/2`
---- `"low"`, `"small"`, `"poor"` - equivalent to `1/sqrt(2)`
---- `"normal"`, `"medium"`, `"regular"` - equivalent to `1`
---- `"high"`, `"big"`, `"good"` - equivalent to `sqrt(2)`
---- `"very-high"`, `"very-big"`, `"very-good"` - equivalent to `2`
---
---The map generation algorithm officially supports the range of values the in-game map generation screen shows (specifically `0` and values from `1/6` to `6`). Values outside this range are not guaranteed to work as expected.
---@alias MapGenSize  any

---Coordinates on a surface, for example of an entity. MapPositions may be specified either as a dictionary with `x`, `y` as keys, or simply as an array with two elements.
---
---The coordinates are saved as a fixed-size 32 bit integer, with 8 bits reserved for decimal precision, meaning the smallest value step is `1/2^8 = 0.00390625` tiles.
---
---Explicit definition: 
---```lua
---{x = 5.5, y = 2}
---{y = 2.25, x = 5.125}
---```
---\
---Shorthand: 
---```lua
---{1.625, 2.375}
---```
---@class MapPosition
---@field x double
---@field [1] double
---@field y double
---@field [2] double

---Various game-related settings. Updating any of the attributes will immediately take effect in the game engine.
---
---Increase the number of short paths the pathfinder can cache. 
---```lua
---game.map_settings.path_finder.short_cache_size = 15
---```
---@class MapSettings
---@field enemy_evolution EnemyEvolutionMapSettings
---@field enemy_expansion EnemyExpansionMapSettings
---@field max_failed_behavior_count uint @If a behavior fails this many times, the enemy (or enemy group) is destroyed. This solves biters getting stuck within their own base.
---@field path_finder PathFinderMapSettings
---@field pollution PollutionMapSettings
---@field steering SteeringMapSettings
---@field unit_group UnitGroupMapSettings

---What is shown in the map view. If a field is not given, that setting will not be changed.
---@class MapViewSettings
---@field show-electric-network? boolean
---@field show-logistic-network? boolean
---@field show-networkless-logistic-members? boolean
---@field show-non-standard-map-info? boolean
---@field show-player-names? boolean
---@field show-pollution? boolean
---@field show-train-station-names? boolean
---@field show-turret-range? boolean

---@class ModChangeData
---@field new_version string @New version of the mod. May be `nil` if the mod is no longer present (i.e. it was just removed).
---@field old_version string @Old version of the mod. May be `nil` if the mod wasn't previously present (i.e. it was just added).

---
---Runtime settings can be changed through console commands and by the mod that owns the settings by writing a new table to the ModSetting.
---@class ModSetting
---@field value uint|double|boolean|string @The value of the mod setting. The type depends on the setting.

---@class ModSettingPrototypeFilter
---@field filter "type"|"mod"|"setting-type" @The condition to filter on. One of `"type"`, `"mod"`, `"setting-type"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field mod? string
---@field type? string|string[]|string

---@class ModuleEffectValue
---@field bonus float @The percentual increase of the attribute. A value of `0.6` means a 60% increase.

---
---These are the effects of the vanilla Productivity Module 3 (up to floating point imprecisions): 
---```lua
---{consumption={bonus=0.6},
--- speed={bonus=-0.15},
--- productivity={bonus=0.06},
--- pollution={bonus=0.075}}
---```
---@class ModuleEffects
---@field consumption? ModuleEffectValue
---@field pollution? ModuleEffectValue
---@field productivity? ModuleEffectValue
---@field speed? ModuleEffectValue

---This is a set of flags given as a dictionary[[string](string) &rarr; [boolean](boolean)]. When a flag is set, it is present in the dictionary with the value `true`. Unset flags aren't present in the dictionary at all.
---
---To write to this, use an array[[string](string)] of the mouse buttons that should be possible to use with on button.
---
---When setting flags, the flag `"left-and-right"` can also be set which will set `"left"` and `"right"` true.
---
---Possible flags when reading are:
---- `"left"`
---- `"right"`
---- `"middle"`
---- `"button-4"`
---- `"button-5"`
---- `"button-6"`
---- `"button-7"`
---- `"button-8"`
---- `"button-9"`
---@alias MouseButtonFlags  any

---A fragment of a functional program used to generate coherent noise, probably for purposes related to terrain generation. These can only be meaningfully written/modified during the data load phase. More detailed information is found on the [wiki](https://wiki.factorio.com/Types/NoiseExpression).
---@class NoiseExpression
---@field type string @Names the type of the expression and determines what other fields are required.

---@class NthTickEventData
---@field nth_tick uint @The nth tick this handler was registered to.
---@field tick uint @The tick during which the event happened.

---A single offer on a market entity.
---@class Offer
---@field offer TechnologyModifier @The action that will take place when a player accepts the offer. Usually a `"give-item"` modifier.
---@field price Ingredient[] @List of prices.

---@class OldTileAndPosition
---@field old_tile LuaTilePrototype
---@field position TilePosition

---@class PathFinderMapSettings
---@field cache_accept_path_end_distance_ratio double @When looking for a path from cache, make sure it doesn't end too far from the requested end in relative terms. This is typically more lenient than the start ratio since the end target could be moving. Defaults to `0.15`.
---@field cache_accept_path_start_distance_ratio double @When looking for a path from cache, make sure it doesn't start too far from the requested start in relative terms. Defaults to `0.2`.
---@field cache_max_connect_to_cache_steps_multiplier uint @When looking for a connection to a cached path, search at most for this number of steps times the original estimate. Defaults to `100`.
---@field cache_path_end_distance_rating_multiplier double @When assigning a rating to the best path, this multiplier times end distances is considered. This value is typically higher than the start multiplier as this results in better end path quality. Defaults to `20`.
---@field cache_path_start_distance_rating_multiplier double @When assigning a rating to the best path, this multiplier times start distances is considered. Defaults to `10`.
---@field direct_distance_to_consider_short_request uint @The maximum direct distance in tiles before a request is no longer considered short. Defaults to `100`.
---@field enemy_with_different_destination_collision_penalty double @A penalty that is applied for another unit that is too close and either not moving or has a different goal. Defaults to `30`.
---@field extended_collision_penalty double @The collision penalty for collisions in the extended bounding box but outside the entity's actual bounding box. Defaults to `3`.
---@field fwd2bwd_ratio uint @The pathfinder performs a step of the backward search every `fwd2bwd_ratio`'th step. The minimum allowed value is `2`, which means symmetric search. The default value is `5`.
---@field general_entity_collision_penalty double @The general collision penalty with other units. Defaults to `10`.
---@field general_entity_subsequent_collision_penalty double @The collision penalty for positions that require the destruction of an entity to get to. Defaults to `3`.
---@field goal_pressure_ratio double @When looking at which node to check next, their heuristic value is multiplied by this ratio. The higher it is, the more the search is directed straight at the goal. Defaults to `2`.
---@field ignore_moving_enemy_collision_distance double @The distance in tiles after which other moving units are not considered for pathfinding. Defaults to `5`.
---@field long_cache_min_cacheable_distance double @The minimal distance to the goal in tiles required to be searched in the long path cache. Defaults to `30`.
---@field long_cache_size uint @Number of elements in the long cache. Defaults to `25`.
---@field max_clients_to_accept_any_new_request uint @The amount of path finder requests accepted per tick regardless of the requested path's length. Defaults to `10`.
---@field max_clients_to_accept_short_new_request uint @When the `max_clients_to_accept_any_new_request` amount is exhausted, only path finder requests with a short estimate will be accepted until this amount (per tick) is reached. Defaults to `100`.
---@field max_steps_worked_per_tick double @The maximum number of nodes that are expanded per tick. Defaults to `1,000`.
---@field max_work_done_per_tick uint @The maximum amount of work each pathfinding job is allowed to do per tick. Defaults to `8,000`.
---@field min_steps_to_check_path_find_termination uint @The minimum amount of steps that are guaranteed to be performed for every request. Defaults to `2000`.
---@field negative_cache_accept_path_end_distance_ratio double @Same principle as `cache_accept_path_end_distance_ratio`, but used for negative cache queries. Defaults to `0.3`.
---@field negative_cache_accept_path_start_distance_ratio double @Same principle as `cache_accept_path_start_distance_ratio`, but used for negative cache queries. Defaults to `0.3`.
---@field negative_path_cache_delay_interval uint @The delay in ticks between decrementing the score of all paths in the negative cache by one. Defaults to `20`.
---@field overload_levels uint[] @The thresholds of waiting clients after each of which the per-tick work limit will be increased by the corresponding value in `overload_multipliers`. This is to avoid clients having to wait too long. Must have the same number of elements as `overload_multipliers`. Defaults to `{0, 100, 500}`.
---@field overload_multipliers double[] @The multipliers to the amount of per-tick work applied after the corresponding thresholds in `overload_levels` have been reached. Must have the same number of elements as `overload_multipliers`. Defaults to `{2, 3, 4}`.
---@field short_cache_min_algo_steps_to_cache uint @The minimal number of nodes required to be searched in the short path cache. Defaults to `50`.
---@field short_cache_min_cacheable_distance double @The minimal distance to the goal in tiles required to be searched in the short path cache. Defaults to `10`.
---@field short_cache_size uint @Number of elements in the short cache. Defaults to `5`.
---@field short_request_max_steps uint @The maximum amount of nodes a short request will traverse before being rescheduled as a long request. Defaults to `1000`.
---@field short_request_ratio double @The amount of steps that are allocated to short requests each tick, as a percentage of all available steps. Defaults to `0.5`, or 50%.
---@field stale_enemy_with_same_destination_collision_penalty double @A penalty that is applied for another unit that is on the way to the goal. This is mainly relevant for situations where a group of units has arrived at the target they are supposed to attack, making units further back circle around to reach the target. Defaults to `30`.
---@field start_to_goal_cost_multiplier_to_terminate_path_find double @If the actual amount of steps is higher than the initial estimate by this factor, pathfinding is terminated. Defaults to `2000.0`.
---@field use_path_cache boolean @Whether to cache paths at all. Defaults to `true`.

---@class PathfinderFlags
---@field allow_destroy_friendly_entities? boolean @Allows pathing through friendly entities. Defaults to `false`.
---@field allow_paths_through_own_entities? boolean @Allows the pathfinder to path through entities of the same force. Defaults to `false`.
---@field cache? boolean @Enables path caching. This can be more efficient, but might fail to respond to changes in the environment. Defaults to `true`.
---@field low_priority? boolean @Sets lower priority on the path request, meaning it might take longer to find a path at the expense of speeding up others. Defaults to `false`.
---@field no_break? boolean @Makes the pathfinder not break in the middle of processing this pathfind, no matter how much work is needed. Defaults to `false`.
---@field prefer_straight_paths? boolean @Makes the pathfinder try to path in straight lines. Defaults to `false`.

---@class PathfinderWaypoint
---@field needs_destroy_to_reach boolean @`true` if the path from the previous waypoint to this one goes through an entity that must be destroyed.
---@field position MapPosition @The position of the waypoint on its surface.

---@class PlaceAsTileResult
---@field condition CollisionMask
---@field condition_size uint
---@field result LuaTilePrototype @The tile prototype.

---@alias PlayerIdentification uint|string|LuaPlayer

---These values are for the time frame of one second (60 ticks).
---@class PollutionMapSettings
---@field aeging double @The amount of pollution eaten by a chunk's tiles as a percentage of 1. Defaults to `1`.
---@field diffusion_ratio double @The amount that is diffused to a neighboring chunk (possibly repeated for other directions as well). Defaults to `0.02`.
---@field enabled boolean @Whether pollution is enabled at all.
---@field enemy_attack_pollution_consumption_modifier double @Defaults to `1`.
---@field expected_max_per_chunk double @Any amount of pollution larger than this value is visualized as this value instead. Defaults to `150`.
---@field max_pollution_to_restore_trees double @Defaults to `20`.
---@field min_pollution_to_damage_trees double @Defaults to `60`.
---@field min_to_diffuse double @The amount of PUs that need to be in a chunk for it to start diffusing. Defaults to `15`.
---@field min_to_show_per_chunk double @Any amount of pollution smaller than this value (but bigger than zero) is visualized as this value instead. Defaults to `50`.
---@field pollution_per_tree_damage double @Defaults to `50`.
---@field pollution_restored_per_tree_damage double @Defaults to `10`.
---@field pollution_with_max_forest_damage double @Defaults to `150`.

---
---Products of the "steel-chest" recipe (an array of Product): 
---```lua
---{{type="item", name="steel-chest", amount=1}}
---```
---\
---Products of the "advanced-oil-processing" recipe: 
---```lua
---{{type="fluid", name="heavy-oil", amount=1},
--- {type="fluid", name="light-oil", amount=4.5},
--- {type="fluid", name="petroleum-gas", amount=5.5}}
---```
---\
---What a custom recipe would look like that had a probability of 0.5 to return a minimum amount of 1 and a maximum amount of 5: 
---```lua
---{{type=0, name="custom-item", probability=0.5, amount_min=1, amount_max=5}}
---```
---@class Product
---@field amount? double @Amount of the item or fluid to give. If not specified, `amount_min`, `amount_max` and `probability` must all be specified.
---@field amount_max? uint|double @Maximum amount of the item or fluid to give. Has no effect when `amount` is specified.
---@field amount_min? uint|double @Minimal amount of the item or fluid to give. Has no effect when `amount` is specified.
---@field catalyst_amount? uint|double @How much of this product is a catalyst.
---@field name string @Prototype name of the result.
---@field probability? double @A value in range [0, 1]. Item or fluid is only given with this probability; otherwise no product is produced.
---@field type string @`"item"` or `"fluid"`.

---@class ProgrammableSpeakerAlertParameters
---@field alert_message string
---@field icon_signal_id SignalID
---@field show_alert boolean
---@field show_on_map boolean

---@class ProgrammableSpeakerCircuitParameters
---@field instrument_id uint
---@field note_id uint
---@field signal_value_is_pitch boolean

---@class ProgrammableSpeakerInstrument
---@field name string
---@field notes string[]

---@class ProgrammableSpeakerParameters
---@field allow_polyphony boolean
---@field playback_globally boolean
---@field playback_volume double

---Types `"signal"` and `"item-group"` do not support filters.
---
---Available filters:
---- [ItemPrototypeFilter](ItemPrototypeFilter) for type `"item"`
---- [TilePrototypeFilter](TilePrototypeFilter) for type `"tile"`
---- [EntityPrototypeFilter](EntityPrototypeFilter) for type `"entity"`
---- [FluidPrototypeFilter](FluidPrototypeFilter) for type `"fluid"`
---- [RecipePrototypeFilter](RecipePrototypeFilter) for type `"recipe"`
---- [DecorativePrototypeFilter](DecorativePrototypeFilter) for type `"decorative"`
---- [AchievementPrototypeFilter](AchievementPrototypeFilter) for type `"achievement"`
---- [EquipmentPrototypeFilter](EquipmentPrototypeFilter) for type `"equipment"`
---- [TechnologyPrototypeFilter](TechnologyPrototypeFilter) for type `"technology"`
---
---Filters are always used as an array of filters of a specific type. Every filter can only be used with its corresponding event, and different types of event filters can not be mixed.
---@alias PrototypeFilter  any

---The smooth orientation. It is a [float](float) in the range `[0, 1)` that covers a full circle, starting at the top and going clockwise. This means a value of `0` indicates "north", a value of `0.5` indicates "south".
---
---For example then, a value of `0.625` would indicate "south-west", and a value of `0.875` would indicate "north-west".
---@alias RealOrientation  any

---@class RecipePrototypeFilter
---@field filter "has-ingredient-item"|"has-ingredient-fluid"|"has-product-item"|"has-product-fluid"|"subgroup"|"category"|"energy"|"emissions-multiplier"|"request-paste-multiplier"|"overload-multiplier" @The condition to filter on. One of `"enabled"`, `"hidden"`, `"hidden-from-flow-stats"`, `"hidden-from-player-crafting"`, `"allow-as-intermediate"`, `"allow-intermediates"`, `"allow-decomposition"`, `"always-show-made-in"`, `"always-show-products"`, `"show-amount-in-title"`, `"has-ingredients"`, `"has-products"`, `"has-ingredient-item"`, `"has-ingredient-fluid"`, `"has-product-item"`, `"has-product-fluid"`, `"subgroup"`, `"category"`, `"energy"`, `"emissions-multiplier"`, `"request-paste-multiplier"`, `"overload-multiplier"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field comparison? ComparatorString
---@field subgroup? string
---@field category? string
---@field elem_filters? ItemPrototypeFilter[]|FluidPrototypeFilter[]
---@field value? double|uint

---A value between 0 and 255 inclusive represented by one of the following named [string](string) or string version of the value (for example `"27"` and `"decals"` are both valid). Higher values are rendered on top of lower values.
---
---- `"water-tile"`: 15
---- `"ground-tile"`: 25
---- `"tile-transition"`: 26
---- `"decals"`: 27
---- `"lower-radius-visualization"`: 29
---- `"radius-visualization"`: 30
---- `"transport-belt-integration"`: 65
---- `"resource"`:66
---- `"building-smoke"`:67
---- `"decorative"`: 92
---- `"ground-patch"`: 93
---- `"ground-patch-higher"`: 94
---- `"ground-patch-higher2"`: 95
---- `"remnants"`: 112
---- `"floor"`: 113
---- `"transport-belt"`: 114
---- `"transport-belt-endings"`: 115
---- `"floor-mechanics-under-corpse"`: 120
---- `"corpse"`: 121
---- `"floor-mechanics"`: 122
---- `"item"`: 123
---- `"lower-object"`: 124
---- `"transport-belt-circuit-connector"`: 126
---- `"lower-object-above-shadow"`: 127
---- `"object"`: 129
---- `"higher-object-under"`: 131
---- `"higher-object-above"`: 132
---- `"item-in-inserter-hand"`: 134
---- `"wires"`: 135
---- `"wires-above"`: 136
---- `"entity-info-icon"`: 138
---- `"entity-info-icon-above"`: 139
---- `"explosion"`: 142
---- `"projectile"`: 143
---- `"smoke"`: 144
---- `"air-object"`: 145
---- `"air-entity-info-icon"`: 147
---- `"light-effect"`: 148
---- `"selection-box"`: 187
---- `"higher-selection-box"`: 188
---- `"collision-selection-box"`: 189
---- `"arrow"`: 190
---- `"cursor"`: 210
---@alias RenderLayer  any

---@class Resistance
---@field decrease float @Absolute damage decrease
---@field percent float @Percentual damage decrease

---@class RidingState
---@field acceleration defines.riding.acceleration
---@field direction defines.riding.direction

---An area defined using the map editor.
---@class ScriptArea
---@field area BoundingBox
---@field color Color
---@field id uint
---@field name string

---A position defined using the map editor.
---@class ScriptPosition
---@field color Color
---@field id uint
---@field name string
---@field position MapPosition

---@class ScriptRenderTarget
---@field entity? LuaEntity
---@field entity_offset? Vector
---@field position? MapPosition

---One vertex of a ScriptRenderPolygon.
---@class ScriptRenderVertexTarget
---@field target MapPosition|LuaEntity
---@field target_offset? Vector @Only used if `target` is a LuaEntity.

---@class SelectedPrototypeData
---@field base_type string @E.g. `"entity"`.
---@field derived_type string @E.g. `"tree"`.
---@field name string @E.g. `"tree-05"`.

---This is a set of flags given as a dictionary[[string](string) &rarr; [boolean](boolean)]. Set flags are present in the dictionary with the value `true`; unset flags aren't present at all.
---@class SelectionModeFlags
---@field blueprint boolean @Entities that can be selected for blueprint.
---@field deconstruct boolean @Entities that can be marked for deconstruction.
---@field cancel-deconstruct boolean @Entities that can be marked for deconstruction cancelling.
---@field items boolean
---@field trees boolean
---@field buildable-type boolean @Buildable entities.
---@field nothing boolean @Only select an area.
---@field items-to-place boolean @Entities that can be placed using an item.
---@field any-entity boolean
---@field any-tile boolean
---@field same-force boolean @Entities with the same force as the selector.
---@field not-same-force boolean
---@field friend boolean
---@field enemy boolean
---@field upgrade boolean
---@field cancel-upgrade boolean
---@field entity-with-health boolean
---@field entity-with-force boolean
---@field entity-with-owner boolean

---An actual signal transmitted by the network.
---@class Signal
---@field count int @Value of the signal.
---@field signal SignalID @ID of the signal.

---@class SignalID
---@field name? string @Name of the item, fluid or virtual signal.
---@field type string @`"item"`, `"fluid"`, or `"virtual"`.

---
---Both of these lines specify an item stack of one iron plate: 
---```lua
---{name="iron-plate"}
---```
--- 
---```
---{name="iron-plate", count=1}
---```
---\
---This is a stack of 47 copper plates: 
---```lua
---{name="copper-plate", count=47}
---```
---\
---These are both full stacks of iron plates (for iron-plate, a full stack is 100 plates): 
---```lua
---"iron-plate"
---```
--- 
---```
---{name="iron-plate", count=100}
---```
---@alias SimpleItemStack string|ItemStackDefinition

---
---The vectors for all 5 position attributes are a table with `x` and `y` keys instead of an array.
---@class SmokeSource
---@field deviation? MapPosition
---@field east_position? Vector
---@field frequency double
---@field height float
---@field height_deviation float
---@field name string
---@field north_position? Vector
---@field offset double
---@field position? Vector
---@field slow_down_factor uint8
---@field south_position? Vector
---@field starting_frame uint16
---@field starting_frame_deviation double
---@field starting_frame_speed uint16
---@field starting_frame_speed_deviation double
---@field starting_vertical_speed float
---@field starting_vertical_speed_deviation float
---@field vertical_speed_slowdown float
---@field west_position? Vector

---A sound defined by a [string](string). It can be either the name of a [sound prototype](https://wiki.factorio.com/Prototype/Sound) defined in the data stage or a path in the form `"type/name"`. The latter option can be sorted into three categories.
---
---The validity of a SoundPath can be verified at runtime using [LuaGameScript::is_valid_sound_path](LuaGameScript::is_valid_sound_path).
---
---The utility and ambient types each contain general use sound prototypes defined by the game itself.
---- `"utility"` - Uses the [UtilitySounds](https://wiki.factorio.com/Prototype/UtilitySounds) prototype. Example: `"utility/wire_connect_pole"`
---- `"ambient"` - Uses [AmbientSound](https://wiki.factorio.com/Prototype/AmbientSound) prototypes. Example: `"ambient/resource-deficiency"`
---
---The following types can be combined with any tile name as long as its prototype defines the
---    corresponding sound.
---- `"tile-walking"` - Uses [Tile::walking_sound](https://wiki.factorio.com/Prototype/Tile#walking_sound). Example: `"tile-walking/concrete"`
---- `"tile-mined"` - Uses [Tile::mined_sound](https://wiki.factorio.com/Prototype/Tile#mined_sound)
---- `"tile-build-small"` - Uses [Tile::build_sound](https://wiki.factorio.com/Prototype/Tile#build_sound). Example: `"tile-build-small/concrete"`
---- `"tile-build-medium"` - Uses [Tile::build_sound](https://wiki.factorio.com/Prototype/Tile#build_sound)
---- `"tile-build-large"` - Uses [Tile::build_sound](https://wiki.factorio.com/Prototype/Tile#build_sound)
---
---The following types can be combined with any entity name as long as its prototype defines the
---    corresponding sound.
---- `"entity-build"` - Uses [Entity::build_sound](https://wiki.factorio.com/Prototype/Entity#build_sound). Example: `"entity-build/wooden-chest"`
---- `"entity-mined"` - Uses [Entity::mined_sound](https://wiki.factorio.com/Prototype/Entity#mined_sound)
---- `"entity-mining"` - Uses [Entity::mining_sound](https://wiki.factorio.com/Prototype/Entity#mining_sound)
---- `"entity-vehicle_impact"` - Uses [Entity::vehicle_impact_sound](https://wiki.factorio.com/Prototype/Entity#vehicle_impact_sound)
---- `"entity-rotated"` - Uses [Entity::rotated_sound](https://wiki.factorio.com/Prototype/Entity#rotated_sound)
---- `"entity-open"` - Uses [Entity::open_sound](https://wiki.factorio.com/Prototype/Entity#open_sound)
---- `"entity-close"` - Uses [Entity::close_sound](https://wiki.factorio.com/Prototype/Entity#close_sound)
---@alias SoundPath  any

---Defines which slider in the game's sound settings affects the volume of this sound. Furthermore, some sound types are mixed differently than others, e.g. zoom level effects are applied.
---@alias SoundType
---| "game-effect"
---| "gui-effect"
---| "ambient"
---| "environment"
---| "walking"
---| "alert"
---| "wind"

---@class SpawnPointDefinition
---@field evolution_factor double @Evolution factor for which this weight applies.
---@field weight double @Probability of spawning this unit at this evolution factor.

---It is specified by [string](string). It can be either the name of a [sprite prototype](https://wiki.factorio.com/Prototype/Sprite) defined in the data stage or a path in form "type/name".
---
---The validity of a SpritePath can be verified at runtime using [LuaGameScript::is_valid_sprite_path](LuaGameScript::is_valid_sprite_path).
---
---The supported types are:
---- `"item"` - for example "item/iron-plate" is the icon sprite of iron plate
---- `"entity"` - for example "entity/small-biter" is the icon sprite of the small biter
---- `"technology"`
---- `"recipe"`
---- `"item-group"`
---- `"fluid"`
---- `"tile"`
---- `"virtual-signal"`
---- `"achievement"`
---- `"equipment"`
---- `"file"` - path to an image file located inside the current scenario. This file is not preloaded so it will be slower; for frequently used sprites, it is better to define sprite prototype and use it instead.
---- `"utility"` - sprite defined in the utility-sprites object, these are the pictures used by the game internally for the UI.
---@alias SpritePath  any

---@class SteeringMapSetting
---@field force_unit_fuzzy_goto_behavior boolean @Used to make steering look better for aesthetic purposes.
---@field radius double @Does not include the radius of the unit.
---@field separation_factor double
---@field separation_force double

---@class SteeringMapSettings
---@field default SteeringMapSetting
---@field moving SteeringMapSetting

---@alias SurfaceIdentification uint|string|LuaSurface

---@class TabAndContent
---@field content LuaGuiElement
---@field tab LuaGuiElement

---A dictionary of string to the four basic Lua types: `string`, `boolean`, `number`, `table`.
---
---```lua
---{a = 1, b = true, c = "three", d = {e = "f"}}
---```
---@alias Tags  any

---@alias TechnologyIdentification string|LuaTechnology|LuaTechnologyPrototype

---The effect that is applied when a technology is researched. It is a table that contains at least the field `type`.
---@class TechnologyModifier
---@field type string @Modifier type. Specifies which of the other fields will be available. Possible values are: `"inserter-stack-size-bonus"`, `"stack-inserter-capacity-bonus"`, `"laboratory-speed"`, `"character-logistic-trash-slots"`, `"maximum-following-robots-count"`, `"worker-robot-speed"`, `"worker-robot-storage"`, `"ghost-time-to-live"`, `"turret-attack"`, `"ammo-damage"`, `"give-item"`, `"gun-speed"`, `"unlock-recipe"`, `"character-crafting-speed"`, `"character-mining-speed"`, `"character-running-speed"`, `"character-build-distance"`, `"character-item-drop-distance"`, `"character-reach-distance"`, `"character-resource-reach-distance"`, `"character-item-pickup-distance"`, `"character-loot-pickup-distance"`, `"character-inventory-slots-bonus"`, `"deconstruction-time-to-live"`, `"max-failed-attempts-per-tick-per-construction-queue"`, `"max-successful-attempts-per-tick-per-construction-queue"`, `"character-health-bonus"`, `"mining-drill-productivity-bonus"`, `"train-braking-force-bonus"`, `"zoom-to-world-enabled"`, `"zoom-to-world-ghost-building-enabled"`, `"zoom-to-world-blueprint-enabled"`, `"zoom-to-world-deconstruction-planner-enabled"`, `"zoom-to-world-upgrade-planner-enabled"`, `"zoom-to-world-selection-tool-enabled"`, `"worker-robot-battery"`, `"laboratory-productivity"`, `"follower-robot-lifetime"`, `"artillery-range"`, `"nothing"`, `"character-additional-mining-categories"`, `"character-logistic-requests"`.

---@class TechnologyPrototypeFilter
---@field filter "research-unit-ingredient"|"level"|"max-level"|"time" @The condition to filter on. One of `"enabled"`, `"hidden"`, `"upgrade"`, `"visible-when-disabled"`, `"has-effects"`, `"has-prerequisites"`, `"research-unit-ingredient"`, `"level"`, `"max-level"`, `"time"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field value? uint
---@field ingredient? string
---@field comparison? ComparatorString

---@class Tile
---@field name string @The prototype name of the tile.
---@field position TilePosition @The position of the tile.

---Coordinates of a tile on a [LuaSurface](LuaSurface) where each integer `x`/`y` represents a different tile. This uses the same format as [MapPosition](MapPosition), except it rounds any non-integer `x`/`y` down to whole numbers. It can be specified either with or without explicit keys.
---@class TilePosition
---@field x int
---@field [1] int
---@field y int
---@field [2] int

---@class TilePrototypeFilter
---@field filter "collision-mask"|"walking-speed-modifier"|"vehicle-friction-modifier"|"decorative-removal-probability"|"emissions" @The condition to filter on. One of `"minable"`, `"autoplace"`, `"blueprintable"`, `"item-to-place"`, `"collision-mask"`, `"walking-speed-modifier"`, `"vehicle-friction-modifier"`, `"decorative-removal-probability"`, `"emissions"`.
---@field mode? "or"|"and" @How to combine this with the previous filter. Must be `"or"` or `"and"`. Defaults to `"or"`. When evaluating the filters, `"and"` has higher precedence than `"or"`.
---@field invert? boolean @Inverts the condition. Default is `false`.
---@field value? double|float
---@field mask? CollisionMask|CollisionMaskWithFlags
---@field comparison? ComparatorString
---@field mask_mode? string

---@class TrainSchedule
---@field current uint @Index of the currently active record
---@field records TrainScheduleRecord[]

---@class TrainScheduleRecord
---@field rail? LuaEntity @Rail to path to. Ignored if `station` is present.
---@field rail_direction? defines.rail_direction @When a train is allowed to reach rail target from any direction it will be `nil`. If rail has to be reached from specific direction, this value allows to choose the direction. This value corresponds to [LuaEntity::connected_rail_direction](LuaEntity::connected_rail_direction) of a TrainStop.
---@field station? string @Name of the station.
---@field temporary? boolean @Only present when the station is temporary, the value is then always `true`.
---@field wait_conditions? WaitCondition[]

---@class TriggerDelivery
---@field source_effects TriggerEffectItem[]
---@field target_effects TriggerEffectItem[]
---@field type string @One of `"instant"`, `"projectile"`, `"flame-thrower"`, `"beam"`, `"stream"`, `"artillery"`.

---@class TriggerEffectItem
---@field affects_target boolean
---@field repeat_count uint
---@field show_in_tooltip boolean
---@field type string @One of`"damage"`, `"create-entity"`, `"create-explosion"`, `"create-fire"`, `"create-smoke"`, `"create-trivial-smoke"`, `"create-particle"`, `"create-sticker"`, `"nested-result"`, `"play-sound"`, `"push-back"`, `"destroy-cliffs"`, `"show-explosion-on-chart"`, `"insert-item"`, `"script"`.

---@class TriggerItem
---@field action_delivery? TriggerDelivery[]
---@field collision_mask CollisionMask @The trigger will only affect entities that would collide with given collision mask.
---@field entity_flags? EntityPrototypeFlags @The trigger will only affect entities that contain any of these flags.
---@field force ForceCondition @If `"enemy"`, the trigger will only affect entities whose force is different from the attacker's and for which there is no cease-fire set. `"ally"` is the opposite of `"enemy"`.
---@field ignore_collision_condition boolean
---@field repeat_count uint
---@field trigger_target_mask TriggerTargetMask
---@field type string @One of `"direct"`, `"area"`, `"line"`, `"cluster"`.

---This is a set of trigger target masks given as a dictionary[[string](string) &rarr; [boolean](boolean)].
---@alias TriggerTargetMask  any

---@class UnitGroupMapSettings
---@field max_gathering_unit_groups uint @The maximum number of automatically created unit groups gathering for attack at any time. Defaults to `30`.
---@field max_group_gathering_time uint @The maximum amount of time in ticks a group will spend gathering before setting off. The actual time is a random time between the minimum and maximum times. Defaults to `10*3,600=36,000` ticks.
---@field max_group_member_fallback_factor double @When a member of a group falls back more than this factor times the group radius, the group will slow down to its `max_group_slowdown_factor` speed to let them catch up. Defaults to `3`.
---@field max_group_radius double @The maximum group radius in tiles. The actual radius is adjusted based on the number of members. Defaults to `30.0`.
---@field max_group_slowdown_factor double @The minimum speed as a percentage of its maximum speed that a group will slow down to so members that fell behind can catch up. Defaults to `0.3`, or 30%.
---@field max_member_slowdown_when_ahead double @The minimum speed a percentage of its regular speed that a group member can slow down to when ahead of the group. Defaults to `0.6`, or 60%.
---@field max_member_speedup_when_behind double @The maximum speed a percentage of its regular speed that a group member can speed up to when catching up with the group. Defaults to `1.4`, or 140%.
---@field max_unit_group_size uint @The maximum number of members for an attack unit group. This only affects automatically created unit groups, manual groups created through the API are unaffected. Defaults to `200`.
---@field max_wait_time_for_late_members uint @After gathering has finished, the group is allowed to wait this long in ticks for delayed members. New members are not accepted anymore however. Defaults to `2*3,600=7,200` ticks.
---@field member_disown_distance double @When a member of a group falls back more than this factor times the group radius, it will be dropped from the group. Defaults to `10`.
---@field min_group_gathering_time uint @The minimum amount of time in ticks a group will spend gathering before setting off. The actual time is a random time between the minimum and maximum times. Defaults to `3,600` ticks.
---@field min_group_radius double @The minimum group radius in tiles. The actual radius is adjusted based on the number of members. Defaults to `5.0`.
---@field tick_tolerance_when_member_arrives uint

---@class UnitSpawnDefinition
---@field spawn_points SpawnPointDefinition[] @The points at which to spawn the unit.
---@field unit string @Prototype name of the unit that would be spawned.

---@class UpgradeFilter
---@field name? string @Name of the item, or entity.
---@field type string @`"item"`, or `"entity"`.

---A vector is a two-element array containing the `x` and `y` components. In some specific cases, the vector is a table with `x` and `y` keys instead, which the documentation will point out.
---
---```lua
---right = {1.0, 0.0}
---```
---@alias Vector  any

---@class VehicleAutomaticTargetingParameters
---@field auto_target_with_gunner boolean
---@field auto_target_without_gunner boolean

---@class WaitCondition
---@field compare_type string @Either `"and"`, or `"or"`. Tells how this condition is to be compared with the preceding conditions in the corresponding `wait_conditions` array.
---@field condition? CircuitCondition @Only present when `type` is `"item_count"`, `"circuit"` or `"fluid_count"`.
---@field ticks? uint @Number of ticks to wait or of inactivity. Only present when `type` is `"time"` or `"inactivity"`.
---@field type string @One of `"time"`, `"inactivity"`, `"full"`, `"empty"`, `"item_count"`, `"circuit"`, `"robots_inactive"`, `"fluid_count"`, `"passenger_present"`, `"passenger_not_present"`.

---@class WireConnectionDefinition
---@field source_circuit_id? defines.circuit_connector_id @Mandatory if the source entity has more than one circuit connection using circuit wire.
---@field source_wire_id? defines.circuit_connector_id @Mandatory if the source entity has more than one wire connection using copper wire.
---@field target_circuit_id? defines.circuit_connector_id @Mandatory if the target entity has more than one circuit connection using circuit wire.
---@field target_entity LuaEntity @The entity to (dis)connect the source entity with.
---@field target_wire_id? defines.circuit_connector_id @Mandatory if the target entity has more than one wire connection using copper wire.
---@field wire defines.wire_type @Wire color, either [defines.wire_type.red](defines.wire_type.red) or [defines.wire_type.green](defines.wire_type.green).

