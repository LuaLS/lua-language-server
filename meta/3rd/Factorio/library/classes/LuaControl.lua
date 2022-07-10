---@meta

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

