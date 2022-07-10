---@meta

---Allows rendering of geometric shapes, text and sprites in the game world. Each render object is identified by an id that is universally unique for the lifetime of a whole game.
---
---If an entity target of an object is destroyed or changes surface, then the object is also destroyed.
---@class LuaRendering
---@field object_name string @This object's name.`[R]`
local LuaRendering = {}

---Reorder this object so that it is drawn in front of the already existing objects.
---@param _id uint64
function LuaRendering.bring_to_front(_id) end

---Destroys all render objects.
---@param _mod_name? string @If provided, only the render objects created by this mod are destroyed.
function LuaRendering.clear(_mod_name) end

---Destroy the object with the given id.
---@param _id uint64
function LuaRendering.destroy(_id) end

---Create an animation.
---@param _table LuaRendering.draw_animation
---@return uint64 @Id of the render object
function LuaRendering.draw_animation(_table) end

---Create an arc.
---@param _table LuaRendering.draw_arc
---@return uint64 @Id of the render object
function LuaRendering.draw_arc(_table) end

---Create a circle.
---@param _table LuaRendering.draw_circle
---@return uint64 @Id of the render object
function LuaRendering.draw_circle(_table) end

---Create a light.
---
---The base game uses the utility sprites `light_medium` and `light_small` for lights.
---@param _table LuaRendering.draw_light
---@return uint64 @Id of the render object
function LuaRendering.draw_light(_table) end

---Create a line.
---
---Draw a white and 2 pixel wide line from {0, 0} to {2, 2}. 
---```lua
---rendering.draw_line{surface = game.player.surface, from = {0, 0}, to = {2, 2}, color = {1, 1, 1}, width = 2}
---```
---\
---Draw a red and 3 pixel wide line from {0, 0} to {0, 5}. The line has 1 tile long dashes and gaps. 
---```lua
---rendering.draw_line{surface = game.player.surface, from = {0, 0}, to = {0, 5}, color = {r = 1}, width = 3, gap_length = 1, dash_length = 1}
---```
---@param _table LuaRendering.draw_line
---@return uint64 @Id of the render object
function LuaRendering.draw_line(_table) end

---Create a triangle mesh defined by a triangle strip.
---@param _table LuaRendering.draw_polygon
---@return uint64 @Id of the render object
function LuaRendering.draw_polygon(_table) end

---Create a rectangle.
---@param _table LuaRendering.draw_rectangle
---@return uint64 @Id of the render object
function LuaRendering.draw_rectangle(_table) end

---Create a sprite.
---
---This will draw an iron plate icon at the character's feet. The sprite will move together with the character. 
---```lua
---rendering.draw_sprite{sprite = "item.iron-plate", target = game.player.character, surface = game.player.surface}
---```
---\
---This will draw an iron plate icon at the character's head. The sprite will move together with the character. 
---```lua
---rendering.draw_sprite{sprite = "item.iron-plate", target = game.player.character, target_offset = {0, -2}, surface = game.player.surface}
---```
---@param _table LuaRendering.draw_sprite
---@return uint64 @Id of the render object
function LuaRendering.draw_sprite(_table) end

---Create a text.
---
---Not all fonts support scaling.
---@param _table LuaRendering.draw_text
---@return uint64 @Id of the render object
function LuaRendering.draw_text(_table) end

---Get the alignment of the text with this id.
---@param _id uint64
---@return string @`nil` if the object is not a text.
function LuaRendering.get_alignment(_id) end

---Gets an array of all valid object ids.
---@param _mod_name? string @If provided, get only the render objects created by this mod.
---@return uint64[]
function LuaRendering.get_all_ids(_mod_name) end

---Get the angle of the arc with this id.
---@param _id uint64
---@return float @Angle in radian. `nil` if the object is not a arc.
function LuaRendering.get_angle(_id) end

---Get the animation prototype name of the animation with this id.
---@param _id uint64
---@return string @`nil` if the object is not an animation.
function LuaRendering.get_animation(_id) end

---Get the animation offset of the animation with this id.
---@param _id uint64
---@return double @Animation offset in frames. `nil` if the object is not an animation.
function LuaRendering.get_animation_offset(_id) end

---Get the animation speed of the animation with this id.
---@param _id uint64
---@return double @Animation speed in frames per tick. `nil` if the object is not an animation.
function LuaRendering.get_animation_speed(_id) end

---Get the color or tint of the object with this id.
---@param _id uint64
---@return Color @`nil` if the object does not support color.
function LuaRendering.get_color(_id) end

---Get the dash length of the line with this id.
---@param _id uint64
---@return double @`nil` if the object is not a line.
function LuaRendering.get_dash_length(_id) end

---Get whether this is being drawn on the ground, under most entities and sprites.
---@param _id uint64
---@return boolean
function LuaRendering.get_draw_on_ground(_id) end

---Get if the circle or rectangle with this id is filled.
---@param _id uint64
---@return boolean @`nil` if the object is not a circle or rectangle.
function LuaRendering.get_filled(_id) end

---Get the font of the text with this id.
---@param _id uint64
---@return string @`nil` if the object is not a text.
function LuaRendering.get_font(_id) end

---Get the forces that the object with this id is rendered to or `nil` if visible to all forces.
---@param _id uint64
---@return LuaForce[]
function LuaRendering.get_forces(_id) end

---Get from where the line with this id is drawn.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if this object is not a line.
function LuaRendering.get_from(_id) end

---Get the length of the gaps in the line with this id.
---@param _id uint64
---@return double @`nil` if the object is not a line.
function LuaRendering.get_gap_length(_id) end

---Get the intensity of the light with this id.
---@param _id uint64
---@return float @`nil` if the object is not a light.
function LuaRendering.get_intensity(_id) end

---Get where top left corner of the rectangle with this id is drawn.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if the object is not a rectangle.
function LuaRendering.get_left_top(_id) end

---Get the radius of the outer edge of the arc with this id.
---@param _id uint64
---@return double @`nil` if the object is not a arc.
function LuaRendering.get_max_radius(_id) end

---Get the radius of the inner edge of the arc with this id.
---@param _id uint64
---@return double @`nil` if the object is not a arc.
function LuaRendering.get_min_radius(_id) end

---Get the minimum darkness at which the light with this id is rendered.
---@param _id uint64
---@return float @`nil` if the object is not a light.
function LuaRendering.get_minimum_darkness(_id) end

---Get whether this is only rendered in alt-mode.
---@param _id uint64
---@return boolean
function LuaRendering.get_only_in_alt_mode(_id) end

---Get the orientation of the object with this id.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@return RealOrientation @`nil` if the object is not a text, polygon, sprite, light or animation.
function LuaRendering.get_orientation(_id) end

---The object rotates so that it faces this target. Note that `orientation` is still applied to the object. Get the orientation_target of the object with this id.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if no target or if this object is not a polygon, sprite, or animation.
function LuaRendering.get_orientation_target(_id) end

---Get if the light with this id is rendered has the same orientation as the target entity. Note that `orientation` is still applied to the sprite.
---@param _id uint64
---@return boolean @`nil` if the object is not a light.
function LuaRendering.get_oriented(_id) end

---Offsets the center of the sprite or animation if `orientation_target` is given. This offset will rotate together with the sprite or animation. Get the oriented_offset of the sprite or animation with this id.
---@param _id uint64
---@return Vector @`nil` if this object is not a sprite or animation.
function LuaRendering.get_oriented_offset(_id) end

---Get the players that the object with this id is rendered to or `nil` if visible to all players.
---@param _id uint64
---@return LuaPlayer[]
function LuaRendering.get_players(_id) end

---Get the radius of the circle with this id.
---@param _id uint64
---@return double @`nil` if the object is not a circle.
function LuaRendering.get_radius(_id) end

---Get the render layer of the sprite or animation with this id.
---@param _id uint64
---@return RenderLayer @`nil` if the object is not a sprite or animation.
function LuaRendering.get_render_layer(_id) end

---Get where bottom right corner of the rectangle with this id is drawn.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if the object is not a rectangle.
function LuaRendering.get_right_bottom(_id) end

---Get the scale of the text or light with this id.
---@param _id uint64
---@return double @`nil` if the object is not a text or light.
function LuaRendering.get_scale(_id) end

---Get if the text with this id scales with player zoom.
---@param _id uint64
---@return boolean @`nil` if the object is not a text.
function LuaRendering.get_scale_with_zoom(_id) end

---Get the sprite of the sprite or light with this id.
---@param _id uint64
---@return SpritePath @`nil` if the object is not a sprite or light.
function LuaRendering.get_sprite(_id) end

---Get where the arc with this id starts.
---@param _id uint64
---@return float @Angle in radian. `nil` if the object is not a arc.
function LuaRendering.get_start_angle(_id) end

---The surface the object with this id is rendered on.
---@param _id uint64
---@return LuaSurface
function LuaRendering.get_surface(_id) end

---Get where the object with this id is drawn.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if the object does not support target.
function LuaRendering.get_target(_id) end

---Get the text that is displayed by the text with this id.
---@param _id uint64
---@return LocalisedString @`nil` if the object is not a text.
function LuaRendering.get_text(_id) end

---Get the time to live of the object with this id. This will be 0 if the object does not expire.
---@param _id uint64
---@return uint
function LuaRendering.get_time_to_live(_id) end

---Get where the line with this id is drawn to.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if the object is not a line.
function LuaRendering.get_to(_id) end

---Gets the type of the given object. The types are "text", "line", "circle", "rectangle", "arc", "polygon", "sprite", "light" and "animation".
---@param _id uint64
---@return string
function LuaRendering.get_type(_id) end

---Get the vertical alignment of the text with this id.
---@param _id uint64
---@return string @`nil` if the object is not a text.
function LuaRendering.get_vertical_alignment(_id) end

---Get the vertices of the polygon with this id.
---@param _id uint64
---@return ScriptRenderTarget[] @`nil` if the object is not a polygon.
function LuaRendering.get_vertices(_id) end

---Get whether this is rendered to anyone at all.
---@param _id uint64
---@return boolean
function LuaRendering.get_visible(_id) end

---Get the width of the object with this id. Value is in pixels (32 per tile).
---@param _id uint64
---@return float @`nil` if the object does not support width.
function LuaRendering.get_width(_id) end

---Get the horizontal scale of the sprite or animation with this id.
---@param _id uint64
---@return double @`nil` if the object is not a sprite or animation.
function LuaRendering.get_x_scale(_id) end

---Get the vertical scale of the sprite or animation with this id.
---@param _id uint64
---@return double @`nil` if the object is not a sprite or animation.
function LuaRendering.get_y_scale(_id) end

---Does a font with this name exist?
---@param _font_name string
---@return boolean
function LuaRendering.is_font_valid(_font_name) end

---Does a valid object with this id exist?
---@param _id uint64
---@return boolean
function LuaRendering.is_valid(_id) end

---Set the alignment of the text with this id. Does nothing if this object is not a text.
---@param _id uint64
---@param _alignment string @"left", "right" or "center".
function LuaRendering.set_alignment(_id, _alignment) end

---Set the angle of the arc with this id. Does nothing if this object is not a arc.
---@param _id uint64
---@param _angle float @angle in radian
function LuaRendering.set_angle(_id, _angle) end

---Set the animation prototype name of the animation with this id. Does nothing if this object is not an animation.
---@param _id uint64
---@param _animation string
function LuaRendering.set_animation(_id, _animation) end

---Set the animation offset of the animation with this id. Does nothing if this object is not an animation.
---@param _id uint64
---@param _animation_offset double @Animation offset in frames.
function LuaRendering.set_animation_offset(_id, _animation_offset) end

---Set the animation speed of the animation with this id. Does nothing if this object is not an animation.
---@param _id uint64
---@param _animation_speed double @Animation speed in frames per tick.
function LuaRendering.set_animation_speed(_id, _animation_speed) end

---Set the color or tint of the object with this id. Does nothing if this object does not support color.
---@param _id uint64
---@param _color Color
function LuaRendering.set_color(_id, _color) end

---Set the corners of the rectangle with this id. Does nothing if this object is not a rectangle.
---@param _id uint64
---@param _left_top MapPosition|LuaEntity
---@param _left_top_offset Vector
---@param _right_bottom MapPosition|LuaEntity
---@param _right_bottom_offset Vector
function LuaRendering.set_corners(_id, _left_top, _left_top_offset, _right_bottom, _right_bottom_offset) end

---Set the dash length of the line with this id. Does nothing if this object is not a line.
---@param _id uint64
---@param _dash_length double
function LuaRendering.set_dash_length(_id, _dash_length) end

---Set the length of the dashes and the length of the gaps in the line with this id. Does nothing if this object is not a line.
---@param _id uint64
---@param _dash_length double
---@param _gap_length double
function LuaRendering.set_dashes(_id, _dash_length, _gap_length) end

---Set whether this is being drawn on the ground, under most entities and sprites.
---@param _id uint64
---@param _draw_on_ground boolean
function LuaRendering.set_draw_on_ground(_id, _draw_on_ground) end

---Set if the circle or rectangle with this id is filled. Does nothing if this object is not a circle or rectangle.
---@param _id uint64
---@param _filled boolean
function LuaRendering.set_filled(_id, _filled) end

---Set the font of the text with this id. Does nothing if this object is not a text.
---@param _id uint64
---@param _font string
function LuaRendering.set_font(_id, _font) end

---Set the forces that the object with this id is rendered to.
---@param _id uint64
---@param _forces ForceIdentification[] @Providing an empty array will set the object to be visible to all forces.
function LuaRendering.set_forces(_id, _forces) end

---Set from where the line with this id is drawn. Does nothing if the object is not a line.
---@param _id uint64
---@param _from MapPosition|LuaEntity
---@param _from_offset? Vector
function LuaRendering.set_from(_id, _from, _from_offset) end

---Set the length of the gaps in the line with this id. Does nothing if this object is not a line.
---@param _id uint64
---@param _gap_length double
function LuaRendering.set_gap_length(_id, _gap_length) end

---Set the intensity of the light with this id. Does nothing if this object is not a light.
---@param _id uint64
---@param _intensity float
function LuaRendering.set_intensity(_id, _intensity) end

---Set where top left corner of the rectangle with this id is drawn. Does nothing if this object is not a rectangle.
---@param _id uint64
---@param _left_top MapPosition|LuaEntity
---@param _left_top_offset? Vector
function LuaRendering.set_left_top(_id, _left_top, _left_top_offset) end

---Set the radius of the outer edge of the arc with this id. Does nothing if this object is not a arc.
---@param _id uint64
---@param _max_radius double
function LuaRendering.set_max_radius(_id, _max_radius) end

---Set the radius of the inner edge of the arc with this id. Does nothing if this object is not a arc.
---@param _id uint64
---@param _min_radius double
function LuaRendering.set_min_radius(_id, _min_radius) end

---Set the minimum darkness at which the light with this id is rendered. Does nothing if this object is not a light.
---@param _id uint64
---@param _minimum_darkness float
function LuaRendering.set_minimum_darkness(_id, _minimum_darkness) end

---Set whether this is only rendered in alt-mode.
---@param _id uint64
---@param _only_in_alt_mode boolean
function LuaRendering.set_only_in_alt_mode(_id, _only_in_alt_mode) end

---Set the orientation of the object with this id. Does nothing if this object is not a text, polygon, sprite, light or animation.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@param _orientation RealOrientation
function LuaRendering.set_orientation(_id, _orientation) end

---The object rotates so that it faces this target. Note that `orientation` is still applied to the object. Set the orientation_target of the object with this id. Does nothing if this object is not a polygon, sprite, or animation. Set to `nil` if the object should not have an orientation_target.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@param _orientation_target MapPosition|LuaEntity
---@param _orientation_target_offset? Vector
function LuaRendering.set_orientation_target(_id, _orientation_target, _orientation_target_offset) end

---Set if the light with this id is rendered has the same orientation as the target entity. Does nothing if this object is not a light. Note that `orientation` is still applied to the sprite.
---@param _id uint64
---@param _oriented boolean
function LuaRendering.set_oriented(_id, _oriented) end

---Offsets the center of the sprite or animation if `orientation_target` is given. This offset will rotate together with the sprite or animation. Set the oriented_offset of the sprite or animation with this id. Does nothing if this object is not a sprite or animation.
---@param _id uint64
---@param _oriented_offset Vector
function LuaRendering.set_oriented_offset(_id, _oriented_offset) end

---Set the players that the object with this id is rendered to.
---@param _id uint64
---@param _players PlayerIdentification[] @Providing an empty array will set the object to be visible to all players.
function LuaRendering.set_players(_id, _players) end

---Set the radius of the circle with this id. Does nothing if this object is not a circle.
---@param _id uint64
---@param _radius double
function LuaRendering.set_radius(_id, _radius) end

---Set the render layer of the sprite or animation with this id. Does nothing if this object is not a sprite or animation.
---@param _id uint64
---@param _render_layer RenderLayer
function LuaRendering.set_render_layer(_id, _render_layer) end

---Set where top bottom right of the rectangle with this id is drawn. Does nothing if this object is not a rectangle.
---@param _id uint64
---@param _right_bottom MapPosition|LuaEntity
---@param _right_bottom_offset? Vector
function LuaRendering.set_right_bottom(_id, _right_bottom, _right_bottom_offset) end

---Set the scale of the text or light with this id. Does nothing if this object is not a text or light.
---@param _id uint64
---@param _scale double
function LuaRendering.set_scale(_id, _scale) end

---Set if the text with this id scales with player zoom, resulting in it always being the same size on screen, and the size compared to the game world changes. Does nothing if this object is not a text.
---@param _id uint64
---@param _scale_with_zoom boolean
function LuaRendering.set_scale_with_zoom(_id, _scale_with_zoom) end

---Set the sprite of the sprite or light with this id. Does nothing if this object is not a sprite or light.
---@param _id uint64
---@param _sprite SpritePath
function LuaRendering.set_sprite(_id, _sprite) end

---Set where the arc with this id starts. Does nothing if this object is not a arc.
---@param _id uint64
---@param _start_angle float @angle in radian
function LuaRendering.set_start_angle(_id, _start_angle) end

---Set where the object with this id is drawn. Does nothing if this object does not support target.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@param _target MapPosition|LuaEntity
---@param _target_offset? Vector
function LuaRendering.set_target(_id, _target, _target_offset) end

---Set the text that is displayed by the text with this id. Does nothing if this object is not a text.
---@param _id uint64
---@param _text LocalisedString
function LuaRendering.set_text(_id, _text) end

---Set the time to live of the object with this id. Set to 0 if the object should not expire.
---@param _id uint64
---@param _time_to_live uint
function LuaRendering.set_time_to_live(_id, _time_to_live) end

---Set where the line with this id is drawn to. Does nothing if this object is not a line.
---@param _id uint64
---@param _to MapPosition|LuaEntity
---@param _to_offset? Vector
function LuaRendering.set_to(_id, _to, _to_offset) end

---Set the vertical alignment of the text with this id. Does nothing if this object is not a text.
---@param _id uint64
---@param _alignment string @"top", "middle", "baseline" or "bottom"
function LuaRendering.set_vertical_alignment(_id, _alignment) end

---Set the vertices of the polygon with this id. Does nothing if this object is not a polygon.
---@param _id uint64
---@param _vertices ScriptRenderVertexTarget[]
function LuaRendering.set_vertices(_id, _vertices) end

---Set whether this is rendered to anyone at all.
---@param _id uint64
---@param _visible boolean
function LuaRendering.set_visible(_id, _visible) end

---Set the width of the object with this id. Does nothing if this object does not support width. Value is in pixels (32 per tile).
---@param _id uint64
---@param _width float
function LuaRendering.set_width(_id, _width) end

---Set the horizontal scale of the sprite or animation with this id. Does nothing if this object is not a sprite or animation.
---@param _id uint64
---@param _x_scale double
function LuaRendering.set_x_scale(_id, _x_scale) end

---Set the vertical scale of the sprite or animation with this id. Does nothing if this object is not a sprite or animation.
---@param _id uint64
---@param _y_scale double
function LuaRendering.set_y_scale(_id, _y_scale) end


---@class LuaRendering.draw_animation
---@field animation string @Name of an [animation prototype](https://wiki.factorio.com/Prototype/Animation).
---@field orientation? RealOrientation @The orientation of the animation. Default is 0.
---@field x_scale? double @Horizontal scale of the animation. Default is 1.
---@field y_scale? double @Vertical scale of the animation. Default is 1.
---@field tint? Color
---@field render_layer? RenderLayer
---@field animation_speed? double @How many frames the animation goes forward per tick. Default is 1.
---@field animation_offset? double @Offset of the animation in frames. Default is 0.
---@field orientation_target? MapPosition|LuaEntity @If given, the animation rotates so that it faces this target. Note that `orientation` is still applied to the animation.
---@field orientation_target_offset? Vector @Only used if `orientation_target` is a LuaEntity.
---@field oriented_offset? Vector @Offsets the center of the animation if `orientation_target` is given. This offset will rotate together with the animation.
---@field target MapPosition|LuaEntity @Center of the animation.
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_arc
---@field color Color
---@field max_radius double @The radius of the outer edge of the arc, in tiles.
---@field min_radius double @The radius of the inner edge of the arc, in tiles.
---@field start_angle float @Where the arc starts, in radian.
---@field angle float @The angle of the arc, in radian.
---@field target MapPosition|LuaEntity
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_circle
---@field color Color
---@field radius double @In tiles.
---@field width? float @Width of the outline, used only if filled = false. Value is in pixels (32 per tile).
---@field filled boolean @If the circle should be filled.
---@field target MapPosition|LuaEntity
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_light
---@field sprite SpritePath
---@field orientation? RealOrientation @The orientation of the light. Default is 0.
---@field scale? float @Default is 1.
---@field intensity? float @Default is 1.
---@field minimum_darkness? float @The minimum darkness at which this light is rendered. Default is 0.
---@field oriented? boolean @If this light has the same orientation as the entity target, default is false. Note that `orientation` is still applied to the sprite.
---@field color? Color @Defaults to white (no tint).
---@field target MapPosition|LuaEntity @Center of the light.
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_line
---@field color Color
---@field width float @In pixels (32 per tile).
---@field gap_length? double @Length of the gaps that this line has, in tiles. Default is 0.
---@field dash_length? double @Length of the dashes that this line has. Used only if gap_length > 0. Default is 0.
---@field from MapPosition|LuaEntity
---@field from_offset? Vector @Only used if `from` is a LuaEntity.
---@field to MapPosition|LuaEntity
---@field to_offset? Vector @Only used if `to` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_polygon
---@field color Color
---@field vertices ScriptRenderVertexTarget[]
---@field target? MapPosition|LuaEntity @Acts like an offset applied to all vertices that are not set to an entity.
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field orientation? RealOrientation @The orientation applied to all vertices. Default is 0.
---@field orientation_target? MapPosition|LuaEntity @If given, the vertices (that are not set to an entity) rotate so that it faces this target. Note that `orientation` is still applied.
---@field orientation_target_offset? Vector @Only used if `orientation_target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_rectangle
---@field color Color
---@field width? float @Width of the outline, used only if filled = false. Value is in pixels (32 per tile).
---@field filled boolean @If the rectangle should be filled.
---@field left_top MapPosition|LuaEntity
---@field left_top_offset? Vector @Only used if `left_top` is a LuaEntity.
---@field right_bottom MapPosition|LuaEntity
---@field right_bottom_offset? Vector @Only used if `right_bottom` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_sprite
---@field sprite SpritePath
---@field orientation? RealOrientation @The orientation of the sprite. Default is 0.
---@field x_scale? double @Horizontal scale of the sprite. Default is 1.
---@field y_scale? double @Vertical scale of the sprite. Default is 1.
---@field tint? Color
---@field render_layer? RenderLayer
---@field orientation_target? MapPosition|LuaEntity @If given, the sprite rotates so that it faces this target. Note that `orientation` is still applied to the sprite.
---@field orientation_target_offset? Vector @Only used if `orientation_target` is a LuaEntity.
---@field oriented_offset? Vector @Offsets the center of the sprite if `orientation_target` is given. This offset will rotate together with the sprite.
---@field target MapPosition|LuaEntity @Center of the sprite.
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_text
---@field text LocalisedString @The text to display.
---@field surface SurfaceIdentification
---@field target MapPosition|LuaEntity
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field color Color
---@field scale? double
---@field font? string @Name of font to use. Defaults to the same font as flying-text.
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field orientation? RealOrientation @The orientation of the text. Default is 0.
---@field alignment? string @Defaults to "left". Other options are "right" and "center".
---@field vertical_alignment? string @Defaults to "top". Other options are "middle", "baseline" and "bottom".
---@field scale_with_zoom? boolean @Defaults to false. If true, the text scales with player zoom, resulting in it always being the same size on screen, and the size compared to the game world changes.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

