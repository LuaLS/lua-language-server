---@meta

---
---The `lovr.headset` module is where all the magical VR functionality is.  With it, you can access connected VR hardware and get information about the available space the player has.  Note that all units are reported in meters.  Position `(0, 0, 0)` is the center of the play area.
---
---@class lovr.headset
lovr.headset = {}

---
---Animates a device model to match its current input state.  The buttons and joysticks on a controller will move as they're pressed/moved and hand models will move to match skeletal input.
---
---The model should have been created using `lovr.headset.newModel` with the `animated` flag set to `true`.
---
---@param device? lovr.Device # The device to use for the animation data.
---@param model lovr.Model # The model to animate.
---@return boolean success # Whether the animation was applied successfully to the Model.  If the Model was not compatible or animation data for the device was not available, this will be `false`.
function lovr.headset.animate(device, model) end

---
---Returns the current angular velocity of a device.
---
---@param device? lovr.Device # The device to get the velocity of.
---@return number x # The x component of the angular velocity.
---@return number y # The y component of the angular velocity.
---@return number z # The z component of the angular velocity.
function lovr.headset.getAngularVelocity(device) end

---
---Get the current state of an analog axis on a device.  Some axes are multidimensional, for example a 2D touchpad or thumbstick with x/y axes.  For multidimensional axes, this function will return multiple values, one number for each axis.  In these cases, it can be useful to use the `select` function built in to Lua to select a particular axis component.
---
---@param device lovr.Device # The device.
---@param axis lovr.DeviceAxis # The axis.
function lovr.headset.getAxis(device, axis) end

---
---Returns the depth of the play area, in meters.
---
---@return number depth # The depth of the play area, in meters.
function lovr.headset.getBoundsDepth() end

---
---Returns the size of the play area, in meters.
---
---@return number width # The width of the play area, in meters.
---@return number depth # The depth of the play area, in meters.
function lovr.headset.getBoundsDimensions() end

---
---Returns a list of points representing the boundaries of the play area, or `nil` if the current headset driver does not expose this information.
---
---@param t? table # A table to fill with the points.  If `nil`, a new table will be created.
---@return table points # A flat table of 3D points representing the play area boundaries.
function lovr.headset.getBoundsGeometry(t) end

---
---Returns the width of the play area, in meters.
---
---@return number width # The width of the play area, in meters.
function lovr.headset.getBoundsWidth() end

---
---Returns the near and far clipping planes used to render to the headset.  Objects closer than the near clipping plane or further than the far clipping plane will be clipped out of view.
---
---@return number near # The distance to the near clipping plane, in meters.
---@return number far # The distance to the far clipping plane, in meters.
function lovr.headset.getClipDistance() end

---
---Returns the texture dimensions of the headset display (for one eye), in pixels.
---
---@return number width # The width of the display.
---@return number height # The height of the display.
function lovr.headset.getDisplayDimensions() end

---
---Returns the refresh rate of the headset display, in Hz.
---
---@return number frequency # The frequency of the display, or `nil` if I have no idea what it is.
function lovr.headset.getDisplayFrequency() end

---
---Returns the height of the headset display (for one eye), in pixels.
---
---@return number height # The height of the display.
function lovr.headset.getDisplayHeight() end

---
---Returns 2D triangle vertices that represent areas of the headset display that will never be seen by the user (due to the circular lenses).  This area can be masked out by rendering it to the depth buffer or stencil buffer.  Then, further drawing operations can skip rendering those pixels using the depth test (`lovr.graphics.setDepthTest`) or stencil test (`lovr.graphics.setStencilTest`), which improves performance.
---
---@return table points # A table of points.  Each point is a table with two numbers between 0 and 1.
function lovr.headset.getDisplayMask() end

---
---Returns the width of the headset display (for one eye), in pixels.
---
---@return number width # The width of the display.
function lovr.headset.getDisplayWidth() end

---
---Returns the `HeadsetDriver` that is currently in use, optionally for a specific device.  The order of headset drivers can be changed using `lovr.conf` to prefer or exclude specific VR APIs.
---
---@overload fun(device: lovr.Device):lovr.HeadsetDriver
---@return lovr.HeadsetDriver driver # The driver of the headset in use, e.g. "OpenVR".
function lovr.headset.getDriver() end

---
---Returns a table with all of the currently tracked hand devices.
---
---@return table hands # The currently tracked hand devices.
function lovr.headset.getHands() end

---
---Returns a Texture that contains whatever is currently rendered to the headset.
---
---Sometimes this can be `nil` if the current headset driver doesn't have a mirror texture, which can happen if the driver renders directly to the display.  Currently the `desktop`, `webxr`, and `vrapi` drivers do not have a mirror texture.
---
---It also isn't guaranteed that the same Texture will be returned by subsequent calls to this function.  Currently, the `oculus` driver exhibits this behavior.
---
---@return lovr.Texture mirror # The mirror texture.
function lovr.headset.getMirrorTexture() end

---
---Returns the name of the headset as a string.  The exact string that is returned depends on the hardware and VR SDK that is currently in use.
---
---@return string name # The name of the headset as a string.
function lovr.headset.getName() end

---
---Returns the current orientation of a device, in angle/axis form.
---
---@param device? lovr.Device # The device to get the orientation of.
---@return number angle # The amount of rotation around the axis of rotation, in radians.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function lovr.headset.getOrientation(device) end

---
---Returns the type of origin used for the tracking volume.  The different types of origins are explained on the `HeadsetOrigin` page.
---
---@return lovr.HeadsetOrigin origin # The type of origin.
function lovr.headset.getOriginType() end

---
---Returns the current position and orientation of a device.
---
---@param device? lovr.Device # The device to get the pose of.
---@return number x # The x position.
---@return number y # The y position.
---@return number z # The z position.
---@return number angle # The amount of rotation around the axis of rotation, in radians.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function lovr.headset.getPose(device) end

---
---Returns the current position of a device, in meters, relative to the play area.
---
---@param device? lovr.Device # The device to get the position of.
---@return number x # The x position of the device.
---@return number y # The y position of the device.
---@return number z # The z position of the device.
function lovr.headset.getPosition(device) end

---
---Returns a list of joint poses tracked by a device.  Currently, only hand devices are able to track joints.
---
---@overload fun(device: lovr.Device, t: table):table
---@param device lovr.Device # The Device to query.
---@return table poses # A list of joint poses for the device.  Each pose is a table with 3 numbers for the position of the joint followed by 4 numbers for the angle/axis orientation of the joint.
function lovr.headset.getSkeleton(device) end

---
---Returns the estimated time in the future at which the light from the pixels of the current frame will hit the eyes of the user.
---
---This can be used as a replacement for `lovr.timer.getTime` for timestamps that are used for rendering to get a smoother result that is synchronized with the display of the headset.
---
---@return number time # The predicted display time, in seconds.
function lovr.headset.getTime() end

---
---Returns the current linear velocity of a device, in meters per second.
---
---@param device? lovr.Device # The device to get the velocity of.
---@return number vx # The x component of the linear velocity.
---@return number vy # The y component of the linear velocity.
---@return number vz # The z component of the linear velocity.
function lovr.headset.getVelocity(device) end

---
---Returns the view angles of one of the headset views.
---
---These can be used with `Mat4:fov` to create a projection matrix.
---
---If tracking data is unavailable for the view or the index is invalid, `nil` is returned.
---
---@param view number # The view index.
---@return number left # The left view angle, in radians.
---@return number right # The right view angle, in radians.
---@return number top # The top view angle, in radians.
---@return number bottom # The bottom view angle, in radians.
function lovr.headset.getViewAngles(view) end

---
---Returns the number of views used for rendering.  Each view consists of a pose in space and a set of angle values that determine the field of view.
---
---This is usually 2 for stereo rendering configurations, but it can also be different.  For example, one way of doing foveated rendering uses 2 views for each eye -- one low quality view with a wider field of view, and a high quality view with a narrower field of view.
---
---@return number count # The number of views.
function lovr.headset.getViewCount() end

---
---Returns the pose of one of the headset views.  This info can be used to create view matrices or do other eye-dependent calculations.
---
---If tracking data is unavailable for the view or the index is invalid, `nil` is returned.
---
---@param view number # The view index.
---@return number x # The x coordinate of the view position, in meters.
---@return number y # The y coordinate of the view position, in meters.
---@return number z # The z coordinate of the view position, in meters.
---@return number angle # The amount of rotation around the rotation axis, in radians.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function lovr.headset.getViewPose(view) end

---
---Returns whether a button on a device is pressed.
---
---@param device lovr.Device # The device.
---@param button lovr.DeviceButton # The button.
---@return boolean down # Whether the button on the device is currently pressed, or `nil` if the device does not have the specified button.
function lovr.headset.isDown(device, button) end

---
---Returns whether a button on a device is currently touched.
---
---@param device lovr.Device # The device.
---@param button lovr.DeviceButton # The button.
---@return boolean touched # Whether the button on the device is currently touched, or `nil` if the device does not have the button or it isn't touch-sensitive.
function lovr.headset.isTouched(device, button) end

---
---Returns whether any active headset driver is currently returning pose information for a device.
---
---@param device? lovr.Device # The device to get the pose of.
---@return boolean tracked # Whether the device is currently tracked.
function lovr.headset.isTracked(device) end

---
---Returns a new Model for the specified device.
---
---@param device? lovr.Device # The device to load a model for.
---@param options? {animated: boolean} # Options for loading the model.
---@return lovr.Model model # The new Model, or `nil` if a model could not be loaded.
function lovr.headset.newModel(device, options) end

---
---Renders to each eye of the headset using a function.
---
---This function takes care of setting the appropriate graphics transformations to ensure that the scene is rendered as though it is being viewed through each eye of the player.  It also takes care of setting the correct projection for the headset lenses.
---
---If the headset module is enabled, this function is called automatically by `lovr.run` with `lovr.draw` as the callback.
---
---@param callback function # The function used to render.  Any functions called will render to the headset instead of to the window.
function lovr.headset.renderTo(callback) end

---
---Sets the near and far clipping planes used to render to the headset.  Objects closer than the near clipping plane or further than the far clipping plane will be clipped out of view.
---
---@param near number # The distance to the near clipping plane, in meters.
---@param far number # The distance to the far clipping plane, in meters.
function lovr.headset.setClipDistance(near, far) end

---
---Causes the device to vibrate with a custom strength, duration, and frequency, if possible.
---
---@param device? lovr.Device # The device to vibrate.
---@param strength? number # The strength of the vibration (amplitude), between 0 and 1.
---@param duration? number # The duration of the vibration, in seconds.
---@param frequency? number # The frequency of the vibration, in hertz.  0 will use a default frequency.
---@return boolean vibrated # Whether the vibration was successfully triggered by an active headset driver.
function lovr.headset.vibrate(device, strength, duration, frequency) end

---
---Returns whether a button on a device was pressed this frame.
---
---@param device lovr.Device # The device.
---@param button lovr.DeviceButton # The button to check.
---@return boolean pressed # Whether the button on the device was pressed this frame.
function lovr.headset.wasPressed(device, button) end

---
---Returns whether a button on a device was released this frame.
---
---@param device lovr.Device # The device.
---@param button lovr.DeviceButton # The button to check.
---@return boolean released # Whether the button on the device was released this frame.
function lovr.headset.wasReleased(device, button) end

---
---Different types of input devices supported by the `lovr.headset` module.
---
---@class lovr.Device
---
---The headset.
---
---@field head integer
---
---The left controller.
---
---@field ["hand/left"] integer
---
---The right controller.
---
---@field ["hand/right"] integer
---
---A shorthand for hand/left.
---
---@field left integer
---
---A shorthand for hand/right.
---
---@field right integer
---
---A device tracking the left elbow.
---
---@field ["elbow/left"] integer
---
---A device tracking the right elbow.
---
---@field ["elbow/right"] integer
---
---A device tracking the left shoulder.
---
---@field ["shoulder/left"] integer
---
---A device tracking the right shoulder.
---
---@field ["shoulder/right"] integer
---
---A device tracking the chest.
---
---@field chest integer
---
---A device tracking the waist.
---
---@field waist integer
---
---A device tracking the left knee.
---
---@field ["knee/left"] integer
---
---A device tracking the right knee.
---
---@field ["knee/right"] integer
---
---A device tracking the left foot or ankle.
---
---@field ["foot/left"] integer
---
---A device tracking the right foot or ankle.
---
---@field ["foot/right"] integer
---
---A device used as a camera in the scene.
---
---@field camera integer
---
---A tracked keyboard.
---
---@field keyboard integer
---
---The left eye.
---
---@field ["eye/left"] integer
---
---The right eye.
---
---@field ["eye/right"] integer
---
---The first tracking device (i.e. lighthouse).
---
---@field ["beacon/1"] integer
---
---The second tracking device (i.e. lighthouse).
---
---@field ["beacon/2"] integer
---
---The third tracking device (i.e. lighthouse).
---
---@field ["beacon/3"] integer
---
---The fourth tracking device (i.e. lighthouse).
---
---@field ["beacon/4"] integer

---
---Axes on an input device.
---
---@class lovr.DeviceAxis
---
---A trigger (1D).
---
---@field trigger integer
---
---A thumbstick (2D).
---
---@field thumbstick integer
---
---A touchpad (2D).
---
---@field touchpad integer
---
---A grip button or grab gesture (1D).
---
---@field grip integer

---
---Buttons on an input device.
---
---@class lovr.DeviceButton
---
---The trigger button.
---
---@field trigger integer
---
---The thumbstick.
---
---@field thumbstick integer
---
---The touchpad.
---
---@field touchpad integer
---
---The grip button.
---
---@field grip integer
---
---The menu button.
---
---@field menu integer
---
---The A button.
---
---@field a integer
---
---The B button.
---
---@field b integer
---
---The X button.
---
---@field x integer
---
---The Y button.
---
---@field y integer
---
---The proximity sensor on a headset.
---
---@field proximity integer

---
---These are all of the supported VR APIs that LÖVR can use to power the lovr.headset module.  You can change the order of headset drivers using `lovr.conf` to prefer or exclude specific VR APIs.
---
---At startup, LÖVR searches through the list of drivers in order.  One headset driver will be used for rendering to the VR display, and all supported headset drivers will be used for device input.  The way this works is that when poses or button input is requested, the input drivers are queried (in the order they appear in `conf.lua`) to see if any of them currently have data for the specified device.  The first one that returns data will be used to provide the result. This allows projects to support multiple types of hardware devices.
---
---@class lovr.HeadsetDriver
---
---A VR simulator using keyboard/mouse.
---
---@field desktop integer
---
---Oculus Desktop SDK.
---
---@field oculus integer
---
---OpenVR.
---
---@field openvr integer
---
---OpenXR.
---
---@field openxr integer
---
---Oculus Mobile SDK.
---
---@field vrapi integer
---
---Pico.
---
---@field pico integer
---
---WebXR.
---
---@field webxr integer

---
---Represents the different types of origins for coordinate spaces.  An origin of "floor" means that the origin is on the floor in the middle of a room-scale play area.  An origin of "head" means that no positional tracking is available, and consequently the origin is always at the position of the headset.
---
---@class lovr.HeadsetOrigin
---
---The origin is at the head.
---
---@field head integer
---
---The origin is on the floor.
---
---@field floor integer
