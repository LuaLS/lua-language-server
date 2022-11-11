---GUI API documentation
---GUI API documentation
---@class gui
gui = {}
---This is a callback-function, which is called by the engine when a gui component is finalized (destroyed). It can
---be used to e.g. take some last action, report the finalization to other game object instances
---or release user input focus (see release_input_focus). There is no use in starting any animations or similar
---from this function since the gui component is about to be destroyed.
---@param self object # reference to the script state to be used for storing data
function final(self) end

---fit adjust mode
gui.ADJUST_FIT = nil
---stretch adjust mode
gui.ADJUST_STRETCH = nil
---zoom adjust mode
gui.ADJUST_ZOOM = nil
---bottom y-anchor
gui.ANCHOR_BOTTOM = nil
---left x-anchor
gui.ANCHOR_LEFT = nil
---no anchor
gui.ANCHOR_NONE = nil
---right x-anchor
gui.ANCHOR_RIGHT = nil
---top y-anchor
gui.ANCHOR_TOP = nil
---additive blending
gui.BLEND_ADD = nil
---additive alpha blending
gui.BLEND_ADD_ALPHA = nil
---alpha blending
gui.BLEND_ALPHA = nil
---multiply blending
gui.BLEND_MULT = nil
---clipping mode none
gui.CLIPPING_MODE_NONE = nil
---clipping mode stencil
gui.CLIPPING_MODE_STENCIL = nil
---in-back
gui.EASING_INBACK = nil
---in-bounce
gui.EASING_INBOUNCE = nil
---in-circlic
gui.EASING_INCIRC = nil
---in-cubic
gui.EASING_INCUBIC = nil
---in-elastic
gui.EASING_INELASTIC = nil
---in-exponential
gui.EASING_INEXPO = nil
---in-out-back
gui.EASING_INOUTBACK = nil
---in-out-bounce
gui.EASING_INOUTBOUNCE = nil
---in-out-circlic
gui.EASING_INOUTCIRC = nil
---in-out-cubic
gui.EASING_INOUTCUBIC = nil
---in-out-elastic
gui.EASING_INOUTELASTIC = nil
---in-out-exponential
gui.EASING_INOUTEXPO = nil
---in-out-quadratic
gui.EASING_INOUTQUAD = nil
---in-out-quartic
gui.EASING_INOUTQUART = nil
---in-out-quintic
gui.EASING_INOUTQUINT = nil
---in-out-sine
gui.EASING_INOUTSINE = nil
---in-quadratic
gui.EASING_INQUAD = nil
---in-quartic
gui.EASING_INQUART = nil
---in-quintic
gui.EASING_INQUINT = nil
---in-sine
gui.EASING_INSINE = nil
---linear interpolation
gui.EASING_LINEAR = nil
---out-back
gui.EASING_OUTBACK = nil
---out-bounce
gui.EASING_OUTBOUNCE = nil
---out-circlic
gui.EASING_OUTCIRC = nil
---out-cubic
gui.EASING_OUTCUBIC = nil
---out-elastic
gui.EASING_OUTELASTIC = nil
---out-exponential
gui.EASING_OUTEXPO = nil
---out-in-back
gui.EASING_OUTINBACK = nil
---out-in-bounce
gui.EASING_OUTINBOUNCE = nil
---out-in-circlic
gui.EASING_OUTINCIRC = nil
---out-in-cubic
gui.EASING_OUTINCUBIC = nil
---out-in-elastic
gui.EASING_OUTINELASTIC = nil
---out-in-exponential
gui.EASING_OUTINEXPO = nil
---out-in-quadratic
gui.EASING_OUTINQUAD = nil
---out-in-quartic
gui.EASING_OUTINQUART = nil
---out-in-quintic
gui.EASING_OUTINQUINT = nil
---out-in-sine
gui.EASING_OUTINSINE = nil
---out-quadratic
gui.EASING_OUTQUAD = nil
---out-quartic
gui.EASING_OUTQUART = nil
---out-quintic
gui.EASING_OUTQUINT = nil
---out-sine
gui.EASING_OUTSINE = nil
---default keyboard
gui.KEYBOARD_TYPE_DEFAULT = nil
---email keyboard
gui.KEYBOARD_TYPE_EMAIL = nil
---number input keyboard
gui.KEYBOARD_TYPE_NUMBER_PAD = nil
---password keyboard
gui.KEYBOARD_TYPE_PASSWORD = nil
---elliptical pie node bounds
gui.PIEBOUNDS_ELLIPSE = nil
---rectangular pie node bounds
gui.PIEBOUNDS_RECTANGLE = nil
---center pivot
gui.PIVOT_CENTER = nil
---east pivot
gui.PIVOT_E = nil
---north pivot
gui.PIVOT_N = nil
---north-east pivot
gui.PIVOT_NE = nil
---north-west pivot
gui.PIVOT_NW = nil
---south pivot
gui.PIVOT_S = nil
---south-east pivot
gui.PIVOT_SE = nil
---south-west pivot
gui.PIVOT_SW = nil
---west pivot
gui.PIVOT_W = nil
---loop backward
gui.PLAYBACK_LOOP_BACKWARD = nil
---loop forward
gui.PLAYBACK_LOOP_FORWARD = nil
---ping pong loop
gui.PLAYBACK_LOOP_PINGPONG = nil
---once backward
gui.PLAYBACK_ONCE_BACKWARD = nil
---once forward
gui.PLAYBACK_ONCE_FORWARD = nil
---once forward and then backward
gui.PLAYBACK_ONCE_PINGPONG = nil
---color property
gui.PROP_COLOR = nil
---fill_angle property
gui.PROP_FILL_ANGLE = nil
---inner_radius property
gui.PROP_INNER_RADIUS = nil
---outline color property
gui.PROP_OUTLINE = nil
---position property
gui.PROP_POSITION = nil
---rotation property
gui.PROP_ROTATION = nil
---scale property
gui.PROP_SCALE = nil
---shadow color property
gui.PROP_SHADOW = nil
---size property
gui.PROP_SIZE = nil
---slice9 property
gui.PROP_SLICE9 = nil
---data error
gui.RESULT_DATA_ERROR = nil
---out of resource
gui.RESULT_OUT_OF_RESOURCES = nil
---texture already exists
gui.RESULT_TEXTURE_ALREADY_EXISTS = nil
---automatic size mode
gui.SIZE_MODE_AUTO = nil
---manual size mode
gui.SIZE_MODE_MANUAL = nil
---This starts an animation of a node property according to the specified parameters.
---If the node property is already being animated, that animation will be canceled and
---replaced by the new one. Note however that several different node properties
---can be animated simultaneously. Use gui.cancel_animation to stop the animation
---before it has completed.
---Composite properties of type vector3, vector4 or quaternion
---also expose their sub-components (x, y, z and w).
---You can address the components individually by suffixing the name with a dot '.'
---and the name of the component.
---For instance, "position.x" (the position x coordinate) or "color.w"
---(the color alpha value).
---If a complete_function (Lua function) is specified, that function will be called
---when the animation has completed.
---By starting a new animation in that function, several animations can be sequenced
---together. See the examples below for more information.
---@param node node # node to animate
---@param property string|constant # property to animate
---@param to vector3|vector4 # target property value
---@param easing constant|vector # easing to use during animation.      Either specify one of the gui.EASING_* constants or provide a      vector with a custom curve. See the animation guide <> for more information.
---@param duration number # duration of the animation in seconds.
---@param delay number? # delay before the animation starts in seconds.
---@param complete_function (fun(self: any, node: any))? # function to call when the      animation has completed
---@param playback constant? # playback mode
function gui.animate(node, property, to, easing, duration, delay, complete_function, playback) end

---If an animation of the specified node is currently running (started by gui.animate), it will immediately be canceled.
---@param node node # node that should have its animation canceled
---@param property string|constant # property for which the animation should be canceled
function gui.cancel_animation(node, property) end

---Cancels any running flipbook animation on the specified node.
---@param node node # node cancel flipbook animation for
function gui.cancel_flipbook(node) end

---Make a clone instance of a node.
---This function does not clone the supplied node's children nodes.
---Use gui.clone_tree for that purpose.
---@param node node # node to clone
---@return node # the cloned node
function gui.clone(node) end

---Make a clone instance of a node and all its children.
---Use gui.clone to clone a node excluding its children.
---@param node node # root node to clone
---@return table # a table mapping node ids to the corresponding cloned nodes
function gui.clone_tree(node) end

---Deletes the specified node. Any child nodes of the specified node will be
---recursively deleted.
---@param node node # node to delete
function gui.delete_node(node) end

---Delete a dynamically created texture.
---@param texture string|hash # texture id
function gui.delete_texture(texture) end

---Returns the adjust mode of a node.
---The adjust mode defines how the node will adjust itself to screen
---resolutions that differs from the one in the project settings.
---@param node node # node from which to get the adjust mode (node)
---@return constant # the current adjust mode
function gui.get_adjust_mode(node) end

---gets the node alpha
---@param node node # node from which to get alpha
function gui.get_alpha(node) end

---Returns the blend mode of a node.
---Blend mode defines how the node will be blended with the background.
---@param node node # node from which to get the blend mode
---@return constant # blend mode
function gui.get_blend_mode(node) end

---If node is set as an inverted clipping node, it will clip anything inside as opposed to outside.
---@param node node # node from which to get the clipping inverted state
---@return boolean # true or false
function gui.get_clipping_inverted(node) end

---Clipping mode defines how the node will clip it's children nodes
---@param node node # node from which to get the clipping mode
---@return constant # clipping mode
function gui.get_clipping_mode(node) end

---If node is set as visible clipping node, it will be shown as well as clipping. Otherwise, it will only clip but not show visually.
---@param node node # node from which to get the clipping visibility state
---@return boolean # true or false
function gui.get_clipping_visible(node) end

---Returns the color of the supplied node. The components
---of the returned vector4 contains the color channel values:
---
---Component                     Color value
---x                             Red value
---y                             Green value
---z                             Blue value
---w                             Alpha value
---@param node node # node to get the color from
---@return vector4 # node color
function gui.get_color(node) end

---Returns the sector angle of a pie node.
---@param node node # node from which to get the fill angle
---@return number # sector angle
function gui.get_fill_angle(node) end

---Get node flipbook animation.
---@param node node # node to get flipbook animation from
---@return hash # animation id
function gui.get_flipbook(node) end

---This is only useful nodes with flipbook animations. Gets the normalized cursor of the flipbook animation on a node.
---@param node node # node to get the cursor for (node)
---@return  # value number cursor value
function gui.get_flipbook_cursor(node) end

---This is only useful nodes with flipbook animations. Gets the playback rate of the flipbook animation on a node.
---@param node node # node to set the cursor for
---@return number # playback rate
function gui.get_flipbook_playback_rate(node) end

---This is only useful for text nodes. The font must be mapped to the gui scene in the gui editor.
---@param node node # node from which to get the font
---@return hash # font id
function gui.get_font(node) end

---This is only useful for text nodes. The font must be mapped to the gui scene in the gui editor.
---@param font_name hash|string # font of which to get the path hash
---@return hash # path hash to resource
function gui.get_font_resource(font_name) end

---Returns the scene height.
---@return number # scene height
function gui.get_height() end

---Retrieves the id of the specified node.
---@param node node # the node to retrieve the id from
---@return hash # the id of the node
function gui.get_id(node) end

---Retrieve the index of the specified node among its siblings.
---The index defines the order in which a node appear in a GUI scene.
---Higher index means the node is drawn on top of lower indexed nodes.
---@param node node # the node to retrieve the id from
---@return number # the index of the node
function gui.get_index(node) end

---gets the node inherit alpha state
---@param node node # node from which to get the inherit alpha state
function gui.get_inherit_alpha(node) end

---Returns the inner radius of a pie node.
---The radius is defined along the x-axis.
---@param node node # node from where to get the inner radius
---@return number # inner radius
function gui.get_inner_radius(node) end

---The layer must be mapped to the gui scene in the gui editor.
---@param node node # node from which to get the layer
---@return hash # layer id
function gui.get_layer(node) end

---gets the scene current layout
---@return hash # layout id
function gui.get_layout() end

---Returns the leading value for a text node.
---@param node node # node from where to get the leading
---@return number # leading scaling value (default=1)
function gui.get_leading(node) end

---Returns whether a text node is in line-break mode or not.
---This is only useful for text nodes.
---@param node node # node from which to get the line-break for
---@return boolean # true or false
function gui.get_line_break(node) end

---Retrieves the node with the specified id.
---@param id string|hash # id of the node to retrieve
---@return node # a new node instance
function gui.get_node(id) end

---Returns the outer bounds mode for a pie node.
---@param node node # node from where to get the outer bounds mode
---@return constant # the outer bounds mode of the pie node:
function gui.get_outer_bounds(node) end

---Returns the outline color of the supplied node.
---See gui.get_color <> for info how vectors encode color values.
---@param node node # node to get the outline color from
---@return vector4 # outline color
function gui.get_outline(node) end

---Returns the parent node of the specified node.
---If the supplied node does not have a parent, nil is returned.
---@param node node # the node from which to retrieve its parent
---@return node # parent instance or nil
function gui.get_parent(node) end

---Get the paricle fx for a gui node
---@param node node # node to get particle fx for
---@return hash # particle fx id
function gui.get_particlefx(node) end

---Returns the number of generated vertices around the perimeter
---of a pie node.
---@param node node # pie node
---@return number # vertex count
function gui.get_perimeter_vertices(node) end

---The pivot specifies how the node is drawn and rotated from its position.
---@param node node # node to get pivot from
---@return constant # pivot constant
function gui.get_pivot(node) end

---Returns the position of the supplied node.
---@param node node # node to get the position from
---@return vector3 # node position
function gui.get_position(node) end

---Returns the rotation of the supplied node.
---The rotation is expressed in degree Euler angles.
---@param node node # node to get the rotation from
---@return vector3 # node rotation
function gui.get_rotation(node) end

---Returns the scale of the supplied node.
---@param node node # node to get the scale from
---@return vector3 # node scale
function gui.get_scale(node) end

---Returns the screen position of the supplied node. This function returns the
---calculated transformed position of the node, taking into account any parent node
---transforms.
---@param node node # node to get the screen position from
---@return vector3 # node screen position
function gui.get_screen_position(node) end

---Returns the shadow color of the supplied node.
---See gui.get_color <> for info how vectors encode color values.
---@param node node # node to get the shadow color from
---@return vector4 # node shadow color
function gui.get_shadow(node) end

---Returns the size of the supplied node.
---@param node node # node to get the size from
---@return vector3 # node size
function gui.get_size(node) end

---Returns the size of a node.
---The size mode defines how the node will adjust itself in size. Automatic
---size mode alters the node size based on the node's content. Automatic size
---mode works for Box nodes and Pie nodes which will both adjust their size
---to match the assigned image. Particle fx and Text nodes will ignore
---any size mode setting.
---@param node node # node from which to get the size mode (node)
---@return constant # the current size mode
function gui.get_size_mode(node) end

---Returns the slice9 configuration values for the node.
---@param node node # node to manipulate
---@return vector4 # configuration values
function gui.get_slice9(node) end

---Returns the text value of a text node. This is only useful for text nodes.
---@param node node # node from which to get the text
---@return string # text value
function gui.get_text(node) end

---Returns the texture of a node.
---This is currently only useful for box or pie nodes.
---The texture must be mapped to the gui scene in the gui editor.
---@param node node # node to get texture from
---@return hash # texture id
function gui.get_texture(node) end

---Returns the tracking value of a text node.
---@param node node # node from where to get the tracking
---@return number # tracking scaling number (default=0)
function gui.get_tracking(node) end

---Returns true if a node is visible and false if it's not.
---Invisible nodes are not rendered.
---@param node node # node to query
---@return boolean # whether the node is visible or not
function gui.get_visible(node) end

---Returns the scene width.
---@return number # scene width
function gui.get_width() end

---The x-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node # node to get x-anchor from
---@return constant # anchor constant
function gui.get_xanchor(node) end

---The y-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node # node to get y-anchor from
---@return constant # anchor constant
function gui.get_yanchor(node) end

---Hides the on-display touch keyboard on the device.
function gui.hide_keyboard() end

---Returns true if a node is enabled and false if it's not.
---Disabled nodes are not rendered and animations acting on them are not evaluated.
---@param node node # node to query
---@param recursive boolean # check hierarchy recursively
---@return boolean # whether the node is enabled or not
function gui.is_enabled(node, recursive) end

---Alters the ordering of the two supplied nodes by moving the first node
---above the second.
---If the second argument is nil the first node is moved to the top.
---@param node node # to move
---@param node node|nil # reference node above which the first node should be moved
function gui.move_above(node, node) end

---Alters the ordering of the two supplied nodes by moving the first node
---below the second.
---If the second argument is nil the first node is moved to the bottom.
---@param node node # to move
---@param node node|nil # reference node below which the first node should be moved
function gui.move_below(node, node) end

---Dynamically create a new box node.
---@param pos vector3|vector4 # node position
---@param size vector3 # node size
---@return node # new box node
function gui.new_box_node(pos, size) end

---Dynamically create a particle fx node.
---@param pos vector3|vector4 # node position
---@param particlefx hash|string # particle fx resource name
---@return node # new particle fx node
function gui.new_particlefx_node(pos, particlefx) end

---Dynamically create a new pie node.
---@param pos vector3|vector4 # node position
---@param size vector3 # node size
---@return node # new pie node
function gui.new_pie_node(pos, size) end

---Dynamically create a new text node.
---@param pos vector3|vector4 # node position
---@param text string # node text
---@return node # new text node
function gui.new_text_node(pos, text) end

---Dynamically create a new texture.
---@param texture string|hash # texture id
---@param width number # texture width
---@param height number # texture height
---@param type string|constant # texture type
---@param buffer string # texture data
---@param flip boolean # flip texture vertically
---@return boolean # texture creation was successful
---@return number # one of the gui.RESULT_* codes if unsuccessful
function gui.new_texture(texture, width, height, type, buffer, flip) end

---Tests whether a coordinate is within the bounding box of a
---node.
---@param node node # node to be tested for picking
---@param x number # x-coordinate (see on_input <> )
---@param y number # y-coordinate (see on_input <> )
---@return boolean # pick result
function gui.pick_node(node, x, y) end

---Play flipbook animation on a box or pie node.
---The current node texture must contain the animation.
---Use this function to set one-frame still images on the node.
---@param node node # node to set animation for
---@param animation string|hash # animation id
---@param complete_function (fun(self: object, node: node))? # optional function to call when the animation has completed
---@param play_properties table? # optional table with properties
function gui.play_flipbook(node, animation, complete_function, play_properties) end

---Plays the paricle fx for a gui node
---@param node node # node to play particle fx for
---@param emitter_state_function (fun(self: object, node: hash, emitter: hash, state: constant))? # optional callback function that will be called when an emitter attached to this particlefx changes state.
function gui.play_particlefx(node, emitter_state_function) end

---Resets the input context of keyboard. This will clear marked text.
function gui.reset_keyboard() end

---Resets all nodes in the current GUI scene to their initial state.
---The reset only applies to static node loaded from the scene.
---Nodes that are created dynamically from script are not affected.
function gui.reset_nodes() end

---Convert the screen position to the local position of supplied node
---@param node node # node used for getting local transformation matrix
---@param screen_position vector3 # screen position
---@return vector3 # local position
function gui.screen_to_local(node, screen_position) end

---Sets the adjust mode on a node.
---The adjust mode defines how the node will adjust itself to screen
---resolutions that differs from the one in the project settings.
---@param node node # node to set adjust mode for
---@param adjust_mode constant # adjust mode to set
function gui.set_adjust_mode(node, adjust_mode) end

---sets the node alpha
---@param node node # node for which to set alpha
---@param alpha number # 0..1 alpha color
function gui.set_alpha(node, alpha) end

---Set the blend mode of a node.
---Blend mode defines how the node will be blended with the background.
---@param node node # node to set blend mode for
---@param blend_mode constant # blend mode to set
function gui.set_blend_mode(node, blend_mode) end

---If node is set as an inverted clipping node, it will clip anything inside as opposed to outside.
---@param node node # node to set clipping inverted state for
---@param inverted boolean # true or false
function gui.set_clipping_inverted(node, inverted) end

---Clipping mode defines how the node will clip it's children nodes
---@param node node # node to set clipping mode for
---@param clipping_mode constant # clipping mode to set
function gui.set_clipping_mode(node, clipping_mode) end

---If node is set as an visible clipping node, it will be shown as well as clipping. Otherwise, it will only clip but not show visually.
---@param node node # node to set clipping visibility for
---@param visible boolean # true or false
function gui.set_clipping_visible(node, visible) end

---Sets the color of the supplied node. The components
---of the supplied vector3 or vector4 should contain the color channel values:
---
---Component                     Color value
---x                             Red value
---y                             Green value
---z                             Blue value
---w vector4                     Alpha value
---@param node node # node to set the color for
---@param color vector3|vector4 # new color
function gui.set_color(node, color) end

---Sets a node to the disabled or enabled state.
---Disabled nodes are not rendered and animations acting on them are not evaluated.
---@param node node # node to be enabled/disabled
---@param enabled boolean # whether the node should be enabled or not
function gui.set_enabled(node, enabled) end

---Set the sector angle of a pie node.
---@param node node # node to set the fill angle for
---@param angle number # sector angle
function gui.set_fill_angle(node, angle) end

---This is only useful nodes with flipbook animations. The cursor is normalized.
---@param node node # node to set the cursor for
---@param cursor number # cursor value
function gui.set_flipbook_cursor(node, cursor) end

---This is only useful nodes with flipbook animations. Sets the playback rate of the flipbook animation on a node. Must be positive.
---@param node node # node to set the cursor for
---@param playback_rate number # playback rate
function gui.set_flipbook_playback_rate(node, playback_rate) end

---This is only useful for text nodes.
---The font must be mapped to the gui scene in the gui editor.
---@param node node # node for which to set the font
---@param font string|hash # font id
function gui.set_font(node, font) end

---Set the id of the specicied node to a new value.
---Nodes created with the gui.new_*_node() functions get
---an empty id. This function allows you to give dynamically
---created nodes an id.
--- No checking is done on the uniqueness of supplied ids.
---It is up to you to make sure you use unique ids.
---@param node node # node to set the id for
---@param id string|hash # id to set
function gui.set_id(node, id) end

---sets the node inherit alpha state
---@param node node # node from which to set the inherit alpha state
---@param inherit_alpha boolean # true or false
function gui.set_inherit_alpha(node, inherit_alpha) end

---Sets the inner radius of a pie node.
---The radius is defined along the x-axis.
---@param node node # node to set the inner radius for
---@param radius number # inner radius
function gui.set_inner_radius(node, radius) end

---The layer must be mapped to the gui scene in the gui editor.
---@param node node # node for which to set the layer
---@param layer string|hash # layer id
function gui.set_layer(node, layer) end

---Sets the leading value for a text node. This value is used to
---scale the line spacing of text.
---@param node node # node for which to set the leading
---@param leading number # a scaling value for the line spacing (default=1)
function gui.set_leading(node, leading) end

---Sets the line-break mode on a text node.
---This is only useful for text nodes.
---@param node node # node to set line-break for
---@param line_break boolean # true or false
function gui.set_line_break(node, line_break) end

---Sets the outer bounds mode for a pie node.
---@param node node # node for which to set the outer bounds mode
---@param bounds_mode constant # the outer bounds mode of the pie node:
function gui.set_outer_bounds(node, bounds_mode) end

---Sets the outline color of the supplied node.
---See gui.set_color <> for info how vectors encode color values.
---@param node node # node to set the outline color for
---@param color vector3|vector4 # new outline color
function gui.set_outline(node, color) end

---Sets the parent node of the specified node.
---@param node node # node for which to set its parent
---@param parent node # parent node to set
---@param keep_scene_transform boolean # optional flag to make the scene position being perserved
function gui.set_parent(node, parent, keep_scene_transform) end

---Set the paricle fx for a gui node
---@param node node # node to set particle fx for
---@param particlefx hash|string # particle fx id
function gui.set_particlefx(node, particlefx) end

---Sets the number of generated vertices around the perimeter of a pie node.
---@param node node # pie node
---@param vertices number # vertex count
function gui.set_perimeter_vertices(node, vertices) end

---The pivot specifies how the node is drawn and rotated from its position.
---@param node node # node to set pivot for
---@param pivot constant # pivot constant
function gui.set_pivot(node, pivot) end

---Sets the position of the supplied node.
---@param node node # node to set the position for
---@param position vector3|vector4 # new position
function gui.set_position(node, position) end

---Set the order number for the current GUI scene.
---The number dictates the sorting of the "gui" render predicate,
---in other words in which order the scene will be rendered in relation
---to other currently rendered GUI scenes.
---The number must be in the range 0 to 15.
---@param order number # rendering order (0-15)
function gui.set_render_order(order) end

---Sets the rotation of the supplied node.
---The rotation is expressed in degree Euler angles.
---@param node node # node to set the rotation for
---@param rotation vector3|vector4 # new rotation
function gui.set_rotation(node, rotation) end

---Sets the scaling of the supplied node.
---@param node node # node to set the scale for
---@param scale vector3|vector4 # new scale
function gui.set_scale(node, scale) end

---Set the screen position to the supplied node
---@param node node # node to set the screen position to
---@param screen_position vector3 # screen position
function gui.set_screen_position(node, screen_position) end

---Sets the shadow color of the supplied node.
---See gui.set_color <> for info how vectors encode color values.
---@param node node # node to set the shadow color for
---@param color vector3|vector4 # new shadow color
function gui.set_shadow(node, color) end

---Sets the size of the supplied node.
--- You can only set size on nodes with size mode set to SIZE_MODE_MANUAL
---@param node node # node to set the size for
---@param size vector3|vector4 # new size
function gui.set_size(node, size) end

---Sets the size mode of a node.
---The size mode defines how the node will adjust itself in size. Automatic
---size mode alters the node size based on the node's content. Automatic size
---mode works for Box nodes and Pie nodes which will both adjust their size
---to match the assigned image. Particle fx and Text nodes will ignore
---any size mode setting.
---@param node node # node to set size mode for
---@param size_mode constant # size mode to set
function gui.set_size_mode(node, size_mode) end

---Set the slice9 configuration values for the node.
---@param node node # node to manipulate
---@param values vector4 # new values
function gui.set_slice9(node, values) end

---Set the text value of a text node. This is only useful for text nodes.
---@param node node # node to set text for
---@param text string # text to set
function gui.set_text(node, text) end

---Set the texture on a box or pie node. The texture must be mapped to
---the gui scene in the gui editor. The function points out which texture
---the node should render from. If the texture is an atlas, further
---information is needed to select which image/animation in the atlas
---to render. In such cases, use gui.play_flipbook() in
---addition to this function.
---@param node node # node to set texture for
---@param texture string|hash # texture id
function gui.set_texture(node, texture) end

---Set the texture buffer data for a dynamically created texture.
---@param texture string|hash # texture id
---@param width number # texture width
---@param height number # texture height
---@param type string|constant # texture type
---@param buffer string # texture data
---@param flip boolean # flip texture vertically
---@return boolean # setting the data was successful
function gui.set_texture_data(texture, width, height, type, buffer, flip) end

---Sets the tracking value of a text node. This value is used to
---adjust the vertical spacing of characters in the text.
---@param node node # node for which to set the tracking
---@param tracking number # a scaling number for the letter spacing (default=0)
function gui.set_tracking(node, tracking) end

---Set if a node should be visible or not. Only visible nodes are rendered.
---@param node node # node to be visible or not
---@param visible boolean # whether the node should be visible or not
function gui.set_visible(node, visible) end

---The x-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node # node to set x-anchor for
---@param anchor constant # anchor constant
function gui.set_xanchor(node, anchor) end

---The y-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node # node to set y-anchor for
---@param anchor constant # anchor constant
function gui.set_yanchor(node, anchor) end

---Shows the on-display touch keyboard.
---The specified type of keyboard is displayed if it is available on
---the device.
---This function is only available on iOS and Android. .
---@param type constant # keyboard type
---@param autoclose boolean # if the keyboard should automatically close when clicking outside
function gui.show_keyboard(type, autoclose) end

---Stops the particle fx for a gui node
---@param node node # node to stop particle fx for
---@param options table # options when stopping the particle fx. Supported options:
function gui.stop_particlefx(node, options) end

---This is a callback-function, which is called by the engine when a gui component is initialized. It can be used
---to set the initial state of the script and gui scene.
---@param self object # reference to the script state to be used for storing data
function init(self) end

---This is a callback-function, which is called by the engine when user input is sent to the instance of the gui component.
---It can be used to take action on the input, e.g. modify the gui according to the input.
---For an instance to obtain user input, it must first acquire input
---focus through the message acquire_input_focus.
---Any instance that has obtained input will be put on top of an
---input stack. Input is sent to all listeners on the stack until the
---end of stack is reached, or a listener returns true
---to signal that it wants input to be consumed.
---See the documentation of acquire_input_focus <> for more
---information.
---The action parameter is a table containing data about the input mapped to the
---action_id.
---For mapped actions it specifies the value of the input and if it was just pressed or released.
---Actions are mapped to input in an input_binding-file.
---Mouse movement is specifically handled and uses nil as its action_id.
---The action only contains positional parameters in this case, such as x and y of the pointer.
---Here is a brief description of the available table fields:
---
---Field                         Description
---value                         The amount of input given by the user. This is usually 1 for buttons and 0-1 for analogue inputs. This is not present for mouse movement.
---pressed                       If the input was pressed this frame. This is not present for mouse movement.
---released                      If the input was released this frame. This is not present for mouse movement.
---repeated                      If the input was repeated this frame. This is similar to how a key on a keyboard is repeated when you hold it down. This is not present for mouse movement.
---x                             The x value of a pointer device, if present.
---y                             The y value of a pointer device, if present.
---screen_x                      The screen space x value of a pointer device, if present.
---screen_y                      The screen space y value of a pointer device, if present.
---dx                            The change in x value of a pointer device, if present.
---dy                            The change in y value of a pointer device, if present.
---screen_dx                     The change in screen space x value of a pointer device, if present.
---screen_dy                     The change in screen space y value of a pointer device, if present.
---gamepad                       The index of the gamepad device that provided the input.
---touch                         List of touch input, one element per finger, if present. See table below about touch input
---Touch input table:
---
---Field                         Description
---id                            A number identifying the touch input during its duration.
---pressed                       True if the finger was pressed this frame.
---released                      True if the finger was released this frame.
---tap_count                     Number of taps, one for single, two for double-tap, etc
---x                             The x touch location.
---y                             The y touch location.
---dx                            The change in x value.
---dy                            The change in y value.
---acc_x                         Accelerometer x value (if present).
---acc_y                         Accelerometer y value (if present).
---acc_z                         Accelerometer z value (if present).
---@param self object # reference to the script state to be used for storing data
---@param action_id hash # id of the received input action, as mapped in the input_binding-file
---@param action table # a table containing the input data, see above for a description
---@return boolean? # optional boolean to signal if the input should be consumed (not passed on to others) or not, default is false
function on_input(self, action_id, action) end

---This is a callback-function, which is called by the engine whenever a message has been sent to the gui component.
---It can be used to take action on the message, e.g. update the gui or send a response back to the sender of the message.
---The message parameter is a table containing the message data. If the message is sent from the engine, the
---documentation of the message specifies which data is supplied.
---See the update <> function for examples on how to use this callback-function.
---@param self object # reference to the script state to be used for storing data
---@param message_id hash # id of the received message
---@param message table # a table containing the message data
function on_message(self, message_id, message) end

---
---This is a callback-function, which is called by the engine when the gui script is reloaded, e.g. from the editor.
---It can be used for live development, e.g. to tweak constants or set up the state properly for the script.
---@param self object # reference to the script state to be used for storing data
function on_reload(self) end

---This is a callback-function, which is called by the engine every frame to update the state of a gui component.
---It can be used to perform any kind of gui related tasks, e.g. animating nodes.
---@param self object # reference to the script state to be used for storing data
---@param dt number # the time-step of the frame update
function update(self, dt) end




return gui