---Game object API documentation
---Functions, core hooks, messages and constants for manipulation of
---game objects. The "go" namespace is accessible from game object script
---files.
---@class go
go = {}
---This is a callback-function, which is called by the engine when a script component is finalized (destroyed). It can
---be used to e.g. take some last action, report the finalization to other game object instances, delete spawned objects
---or release user input focus (see release_input_focus <>).
---@param self object # reference to the script state to be used for storing data
function final(self) end

---in-back
go.EASING_INBACK = nil
---in-bounce
go.EASING_INBOUNCE = nil
---in-circlic
go.EASING_INCIRC = nil
---in-cubic
go.EASING_INCUBIC = nil
---in-elastic
go.EASING_INELASTIC = nil
---in-exponential
go.EASING_INEXPO = nil
---in-out-back
go.EASING_INOUTBACK = nil
---in-out-bounce
go.EASING_INOUTBOUNCE = nil
---in-out-circlic
go.EASING_INOUTCIRC = nil
---in-out-cubic
go.EASING_INOUTCUBIC = nil
---in-out-elastic
go.EASING_INOUTELASTIC = nil
---in-out-exponential
go.EASING_INOUTEXPO = nil
---in-out-quadratic
go.EASING_INOUTQUAD = nil
---in-out-quartic
go.EASING_INOUTQUART = nil
---in-out-quintic
go.EASING_INOUTQUINT = nil
---in-out-sine
go.EASING_INOUTSINE = nil
---in-quadratic
go.EASING_INQUAD = nil
---in-quartic
go.EASING_INQUART = nil
---in-quintic
go.EASING_INQUINT = nil
---in-sine
go.EASING_INSINE = nil
---linear interpolation
go.EASING_LINEAR = nil
---out-back
go.EASING_OUTBACK = nil
---out-bounce
go.EASING_OUTBOUNCE = nil
---out-circlic
go.EASING_OUTCIRC = nil
---out-cubic
go.EASING_OUTCUBIC = nil
---out-elastic
go.EASING_OUTELASTIC = nil
---out-exponential
go.EASING_OUTEXPO = nil
---out-in-back
go.EASING_OUTINBACK = nil
---out-in-bounce
go.EASING_OUTINBOUNCE = nil
---out-in-circlic
go.EASING_OUTINCIRC = nil
---out-in-cubic
go.EASING_OUTINCUBIC = nil
---out-in-elastic
go.EASING_OUTINELASTIC = nil
---out-in-exponential
go.EASING_OUTINEXPO = nil
---out-in-quadratic
go.EASING_OUTINQUAD = nil
---out-in-quartic
go.EASING_OUTINQUART = nil
---out-in-quintic
go.EASING_OUTINQUINT = nil
---out-in-sine
go.EASING_OUTINSINE = nil
---out-quadratic
go.EASING_OUTQUAD = nil
---out-quartic
go.EASING_OUTQUART = nil
---out-quintic
go.EASING_OUTQUINT = nil
---out-sine
go.EASING_OUTSINE = nil
---loop backward
go.PLAYBACK_LOOP_BACKWARD = nil
---loop forward
go.PLAYBACK_LOOP_FORWARD = nil
---ping pong loop
go.PLAYBACK_LOOP_PINGPONG = nil
---no playback
go.PLAYBACK_NONE = nil
---once backward
go.PLAYBACK_ONCE_BACKWARD = nil
---once forward
go.PLAYBACK_ONCE_FORWARD = nil
---once ping pong
go.PLAYBACK_ONCE_PINGPONG = nil
---This is only supported for numerical properties. If the node property is already being
---animated, that animation will be canceled and replaced by the new one.
---If a complete_function (lua function) is specified, that function will be called when the animation has completed.
---By starting a new animation in that function, several animations can be sequenced together. See the examples for more information.
--- If you call go.animate() from a game object's final() function,
---any passed complete_function will be ignored and never called upon animation completion.
---See the properties guide <> for which properties can be animated and the animation guide <> for how
---them.
---@param url string|hash|url # url of the game object or component having the property
---@param property string|hash # id of the property to animate
---@param playback constant # playback mode of the animation
---@param to number|vector3|vector4|quaternion # target property value
---@param easing constant|vector # easing to use during animation. Either specify a constant, see the animation guide <> for a complete list, or a vmath.vector with a curve
---@param duration number # duration of the animation in seconds
---@param delay number? # delay before the animation starts in seconds
---@param complete_function (fun(self: object, url: url, property: hash))? # optional function to call when the animation has completed
function go.animate(url, property, playback, to, easing, duration, delay, complete_function) end

---By calling this function, all or specified stored property animations of the game object or component will be canceled.
---See the properties guide <> for which properties can be animated and the animation guide <> for how to animate them.
---@param url string|hash|url # url of the game object or component
---@param property string|hash? # optional id of the property to cancel
function go.cancel_animations(url, property) end

---Delete one or more game objects identified by id. Deletion is asynchronous meaning that
---the game object(s) are scheduled for deletion which will happen at the end of the current
---frame. Note that game objects scheduled for deletion will be counted against
---max_instances in "game.project" until they are actually removed.
--- Deleting a game object containing a particle FX component emitting particles will not immediately stop the particle FX from emitting particles. You need to manually stop the particle FX using particlefx.stop().
--- Deleting a game object containing a sound component that is playing will not immediately stop the sound from playing. You need to manually stop the sound using sound.stop().
---@param id string|hash|url|table? # optional id or table of id's of the instance(s) to delete, the instance of the calling script is deleted by default
---@param recursive boolean? # optional boolean, set to true to recursively delete child hiearchy in child to parent order
function go.delete(id, recursive) end

---gets a named property of the specified game object or component
---@param url string|hash|url # url of the game object or component having the property
---@param property string|hash # id of the property to retrieve
---@param options table # (optional) options table - index integer index into array property (1 based) - key hash name of internal property
---@return any # the value of the specified property
function go.get(url, property, options) end

---Returns or constructs an instance identifier. The instance id is a hash
---of the absolute path to the instance.
---
---
--- * If path is specified, it can either be absolute or relative to the instance of the calling script.
---
--- * If path is not specified, the id of the game object instance the script is attached to will be returned.
---@param path string? # path of the instance for which to return the id
---@return hash # instance id
function go.get_id(path) end

---Get the parent for a game object instance.
---@param id string|hash|url? # optional id of the game object instance to get parent for, defaults to the instance containing the calling script
---@return hash # parent instance or nil
function go.get_parent(id) end

---The position is relative the parent (if any). Use go.get_world_position <> to retrieve the global world position.
---@param id string|hash|url? # optional id of the game object instance to get the position for, by default the instance of the calling script
---@return vector3 # instance position
function go.get_position(id) end

---The rotation is relative to the parent (if any). Use go.get_world_rotation <> to retrieve the global world rotation.
---@param id string|hash|url? # optional id of the game object instance to get the rotation for, by default the instance of the calling script
---@return quaternion # instance rotation
function go.get_rotation(id) end

---The scale is relative the parent (if any). Use go.get_world_scale <> to retrieve the global world 3D scale factor.
---@param id string|hash|url? # optional id of the game object instance to get the scale for, by default the instance of the calling script
---@return vector3 # instance scale factor
function go.get_scale(id) end

---The uniform scale is relative the parent (if any). If the underlying scale vector is non-uniform the min element of the vector is returned as the uniform scale factor.
---@param id string|hash|url? # optional id of the game object instance to get the uniform scale for, by default the instance of the calling script
---@return number # uniform instance scale factor
function go.get_scale_uniform(id) end

---The function will return the world position calculated at the end of the previous frame.
---Use go.get_position <> to retrieve the position relative to the parent.
---@param id string|hash|url? # optional id of the game object instance to get the world position for, by default the instance of the calling script
---@return vector3 # instance world position
function go.get_world_position(id) end

---The function will return the world rotation calculated at the end of the previous frame.
---Use go.get_rotation <> to retrieve the rotation relative to the parent.
---@param id string|hash|url? # optional id of the game object instance to get the world rotation for, by default the instance of the calling script
---@return quaternion # instance world rotation
function go.get_world_rotation(id) end

---The function will return the world 3D scale factor calculated at the end of the previous frame.
---Use go.get_scale <> to retrieve the 3D scale factor relative to the parent.
---This vector is derived by decomposing the transformation matrix and should be used with care.
---For most cases it should be fine to use go.get_world_scale_uniform <> instead.
---@param id string|hash|url? # optional id of the game object instance to get the world scale for, by default the instance of the calling script
---@return vector3 # instance world 3D scale factor
function go.get_world_scale(id) end

---The function will return the world scale factor calculated at the end of the previous frame.
---Use go.get_scale_uniform <> to retrieve the scale factor relative to the parent.
---@param id string|hash|url? # optional id of the game object instance to get the world scale for, by default the instance of the calling script
---@return number # instance world scale factor
function go.get_world_scale_uniform(id) end

---The function will return the world transform matrix calculated at the end of the previous frame.
---@param id string|hash|url? # optional id of the game object instance to get the world transform for, by default the instance of the calling script
---@return matrix4 # instance world transform
function go.get_world_transform(id) end

---This function defines a property which can then be used in the script through the self-reference.
---The properties defined this way are automatically exposed in the editor in game objects and collections which use the script.
---Note that you can only use this function outside any callback-functions like init and update.
---@param name string # the id of the property
---@param value number|hash|url|vector3|vector4|quaternion|resource # default value of the property. In the case of a url, only the empty constructor msg.url() is allowed. In the case of a resource one of the resource constructors (eg resource.atlas(), resource.font() etc) is expected.
function go.property(name, value) end

---sets a named property of the specified game object or component, or a material constant
---@param url string|hash|url # url of the game object or component having the property
---@param property string|hash # id of the property to set
---@param value any # the value to set
---@param options table # (optional) options table - index integer index into array property (1 based) - key hash name of internal property
function go.set(url, property, value, options) end

---Sets the parent for a game object instance. This means that the instance will exist in the geometrical space of its parent,
---like a basic transformation hierarchy or scene graph. If no parent is specified, the instance will be detached from any parent and exist in world
---space.
---This function will generate a set_parent message. It is not until the message has been processed that the change actually takes effect. This
---typically happens later in the same frame or the beginning of the next frame. Refer to the manual to learn how messages are processed by the
---engine.
---@param id string|hash|url? # optional id of the game object instance to set parent for, defaults to the instance containing the calling script
---@param parent_id string|hash|url? # optional id of the new parent game object, defaults to detaching game object from its parent
---@param keep_world_transform boolean? # optional boolean, set to true to maintain the world transform when changing spaces. Defaults to false.
function go.set_parent(id, parent_id, keep_world_transform) end

---The position is relative to the parent (if any). The global world position cannot be manually set.
---@param position vector3 # position to set
---@param id string|hash|url? # optional id of the game object instance to set the position for, by default the instance of the calling script
function go.set_position(position, id) end

---The rotation is relative to the parent (if any). The global world rotation cannot be manually set.
---@param rotation quaternion # rotation to set
---@param id string|hash|url? # optional id of the game object instance to get the rotation for, by default the instance of the calling script
function go.set_rotation(rotation, id) end

---The scale factor is relative to the parent (if any). The global world scale factor cannot be manually set.
--- Physics are currently not affected when setting scale from this function.
---@param scale number|vector3 # vector or uniform scale factor, must be greater than 0
---@param id string|hash|url? # optional id of the game object instance to get the scale for, by default the instance of the calling script
function go.set_scale(scale, id) end

---This is a callback-function, which is called by the engine when a script component is initialized. It can be used
---to set the initial state of the script.
---@param self object # reference to the script state to be used for storing data
function init(self) end

---This is a callback-function, which is called by the engine when user input is sent to the game object instance of the script.
---It can be used to take action on the input, e.g. move the instance according to the input.
---For an instance to obtain user input, it must first acquire input focus
---through the message acquire_input_focus.
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

---This is a callback-function, which is called by the engine whenever a message has been sent to the script component.
---It can be used to take action on the message, e.g. send a response back to the sender of the message.
---The message parameter is a table containing the message data. If the message is sent from the engine, the
---documentation of the message specifies which data is supplied.
---@param self object # reference to the script state to be used for storing data
---@param message_id hash # id of the received message
---@param message table # a table containing the message data
---@param sender url # address of the sender
function on_message(self, message_id, message, sender) end

---This is a callback-function, which is called by the engine when the script component is reloaded, e.g. from the editor.
---It can be used for live development, e.g. to tweak constants or set up the state properly for the instance.
---@param self object # reference to the script state to be used for storing data
function on_reload(self) end

---This is a callback-function, which is called by the engine every frame to update the state of a script component.
---It can be used to perform any kind of game related tasks, e.g. moving the game object instance.
---@param self object # reference to the script state to be used for storing data
---@param dt number # the time-step of the frame update
function update(self, dt) end




return go