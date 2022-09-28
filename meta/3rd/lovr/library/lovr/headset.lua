---@meta

---
---The `lovr.headset` module is where all the magical VR functionality is.
---
---With it, you can access connected VR hardware and get information about the available space the player has.
---
---Note that all units are reported in meters.
---
---Position `(0, 0, 0)` is on the floor in the center of the play area.
---
---@class lovr.headset
lovr.headset = {}

---
---Animates a device model to match its current input state.
---
---The buttons and joysticks on a controller will move as they're pressed/moved and hand models will move to match skeletal input.
---
---The model should have been created using `lovr.headset.newModel` with the `animated` flag set to `true`.
---
---
---### NOTE:
---Currently this function is only supported for hand models on the Oculus Quest.
---
---It's possible to use models that weren't created with `lovr.headset.newModel` but they need to be set up carefully to have the same structure as the models provided by the headset SDK.
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
---Get the current state of an analog axis on a device.
---
---Some axes are multidimensional, for example a 2D touchpad or thumbstick with x/y axes.
---
---For multidimensional axes, this function will return multiple values, one number for each axis.
---
---In these cases, it can be useful to use the `select` function built in to Lua to select a particular axis component.
---
---
---### NOTE:
---The axis values will be between 0 and 1 for 1D axes, and between -1 and 1 for each component of a multidimensional axis.
---
---When hand tracking is active, pinch strength will be mapped to the `trigger` axis.
---
---@param device lovr.Device # The device.
---@param axis lovr.DeviceAxis # The axis.
function lovr.headset.getAxis(device, axis) end

---
---Returns the depth of the play area, in meters.
---
---
---### NOTE:
---This currently returns 0 on the Quest.
---
---@return number depth # The depth of the play area, in meters.
function lovr.headset.getBoundsDepth() end

---
---Returns the size of the play area, in meters.
---
---
---### NOTE:
---This currently returns 0 on the Quest.
---
---@return number width # The width of the play area, in meters.
---@return number depth # The depth of the play area, in meters.
function lovr.headset.getBoundsDimensions() end

---
---Returns a list of points representing the boundaries of the play area, or `nil` if the current headset driver does not expose this information.
---
---@param t table # A table to fill with the points.  If `nil`, a new table will be created.
---@return table points # A flat table of 3D points representing the play area boundaries.
function lovr.headset.getBoundsGeometry(t) end

---
---Returns the width of the play area, in meters.
---
---
---### NOTE:
---This currently returns 0 on the Quest.
---
---@return number width # The width of the play area, in meters.
function lovr.headset.getBoundsWidth() end

---
---Returns the near and far clipping planes used to render to the headset.
---
---Objects closer than the near clipping plane or further than the far clipping plane will be clipped out of view.
---
---
---### NOTE:
---The default near and far clipping planes are 0.01 meters and 0.0 meters.
---
---@return number near # The distance to the near clipping plane, in meters.
---@return number far # The distance to the far clipping plane, in meters, or 0 for an infinite far clipping plane with a reversed Z range.
function lovr.headset.getClipDistance() end

---
---Returns the headset delta time, which is the difference between the current and previous predicted display times.
---
---When the headset is active, this will be the `dt` value passed in to `lovr.update`.
---
---@return number dt # The delta time.
function lovr.headset.getDeltaTime() end

---
---Returns the texture dimensions of the headset display (for one eye), in pixels.
---
---@return number width # The width of the display.
---@return number height # The height of the display.
function lovr.headset.getDisplayDimensions() end

---
---Returns a table with all the refresh rates supported by the headset display, in Hz.
---
---@return table frequencies # A flat table of the refresh rates supported by the headset display, nil if not supported.
function lovr.headset.getDisplayFrequencies() end

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
---Returns the width of the headset display (for one eye), in pixels.
---
---@return number width # The width of the display.
function lovr.headset.getDisplayWidth() end

---
---Returns the `HeadsetDriver` that is currently in use, optionally for a specific device.
---
---The order of headset drivers can be changed using `lovr.conf` to prefer or exclude specific VR APIs.
---
---@overload fun(device: lovr.Device):lovr.HeadsetDriver
---@return lovr.HeadsetDriver driver # The driver of the headset in use, e.g. "OpenVR".
function lovr.headset.getDriver() end

---
---Returns a table with all of the currently tracked hand devices.
---
---
---### NOTE:
---The hand paths will *always* be either `hand/left` or `hand/right`.
---
---@return table hands # The currently tracked hand devices.
function lovr.headset.getHands() end

---
---Returns the name of the headset as a string.
---
---The exact string that is returned depends on the hardware and VR SDK that is currently in use.
---
---
---### NOTE:
---The desktop driver name will always be `Simulator`.
---
---@return string name # The name of the headset as a string.
function lovr.headset.getName() end

---
---Returns the current orientation of a device, in angle/axis form.
---
---
---### NOTE:
---If the device isn't tracked, all zeroes will be returned.
---
---@param device? lovr.Device # The device to get the orientation of.
---@return number angle # The amount of rotation around the axis of rotation, in radians.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function lovr.headset.getOrientation(device) end

---
---Returns the type of origin used for the tracking volume.
---
---The different types of origins are explained on the `HeadsetOrigin` page.
---
---@return lovr.HeadsetOrigin origin # The type of origin.
function lovr.headset.getOriginType() end

---
---Returns a `Pass` that renders to the headset display.
---
---
---### NOTE:
---The same Pass will be returned until `lovr.headset.submit` is called.
---
---The first time this function is called during a frame, the views of the Pass will be initialized with the headset view poses and view angles.
---
---The pass will be cleared to the background color, which can be changed using `lovr.graphics.setBackgroundColor`.
---
---The pass will have a depth buffer.
---
---If `t.headset.stencil` was set to a truthy value in `lovr.conf`, the depth buffer will use the `d32fs8` format, otherwise `d32f` will be used.
---
---If `t.headset.antialias` was set to a truthy value in `lovr.conf`, the pass will be multisampled.
---
---@return lovr.Pass pass # The pass.
function lovr.headset.getPass() end

---
---Returns the current position and orientation of a device.
---
---
---### NOTE:
---Units are in meters.
---
---If the device isn't tracked, all zeroes will be returned.
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
---
---### NOTE:
---If the device isn't tracked, all zeroes will be returned.
---
---@param device? lovr.Device # The device to get the position of.
---@return number x # The x position of the device.
---@return number y # The y position of the device.
---@return number z # The z position of the device.
function lovr.headset.getPosition(device) end

---
---Returns a list of joint transforms tracked by a device.
---
---Currently, only hand devices are able to track joints.
---
---
---### NOTE:
---If the Device does not support tracking joints or the transforms are unavailable, `nil` is returned.
---
---The joint orientation is similar to the graphics coordinate system: -Z is the forwards direction, pointing towards the fingertips.
---
---The +Y direction is "up", pointing out of the back of the hand.
---
---The +X direction is to the right, perpendicular to X and Z.
---
---Hand joints are returned in the following order:
---
---<table>
---  <thead>
---    <tr>
---      <td colspan="2">Joint</td>
---      <td>Index</td>
---    </tr>
---  </thead>
---  <tbody>
---    <tr>
---      <td colspan="2">Palm</td>
---      <td>1</td>
---    </tr>
---    <tr>
---      <td colspan="2">Wrist</td>
---      <td>2</td>
---    </tr>
---    <tr>
---      <td rowspan="4">Thumb</td>
---      <td>Metacarpal</td>
---      <td>3</td>
---    </tr>
---    <tr>
---      <td>Proximal</td>
---      <td>4</td>
---    </tr>
---    <tr>
---      <td>Distal</td>
---      <td>5</td>
---    </tr>
---    <tr>
---      <td>Tip</td>
---      <td>6</td>
---    </tr>
---    <tr>
---      <td rowspan="5">Index</td>
---      <td>Metacarpal</td>
---      <td>7</td>
---    </tr>
---    <tr>
---      <td>Proximal</td>
---      <td>8</td>
---    </tr>
---    <tr>
---      <td>Intermediate</td>
---      <td>9</td>
---    </tr>
---    <tr>
---      <td>Distal</td>
---      <td>10</td>
---    </tr>
---    <tr>
---      <td>Tip</td>
---      <td>11</td>
---    </tr>
---    <tr>
---      <td rowspan="5">Middle</td>
---      <td>Metacarpal</td>
---      <td>12</td>
---    </tr>
---    <tr>
---      <td>Proximal</td>
---      <td>13</td>
---    </tr>
---    <tr>
---      <td>Intermediate</td>
---      <td>14</td>
---    </tr>
---    <tr>
---      <td>Distal</td>
---      <td>15</td>
---    </tr>
---    <tr>
---      <td>Tip</td>
---      <td>16</td>
---    </tr>
---    <tr>
---      <td rowspan="5">Ring</td>
---      <td>Metacarpal</td>
---      <td>17</td>
---    </tr>
---    <tr>
---      <td>Proximal</td>
---      <td>18</td>
---    </tr>
---    <tr>
---      <td>Intermediate</td>
---      <td>19</td>
---    </tr>
---    <tr>
---      <td>Distal</td>
---      <td>20</td>
---    </tr>
---    <tr>
---      <td>Tip</td>
---      <td>21</td>
---    </tr>
---    <tr>
---      <td rowspan="5">Pinky</td>
---      <td>Metacarpal</td>
---      <td>22</td>
---    </tr>
---    <tr>
---      <td>Proximal</td>
---      <td>23</td>
---    </tr>
---    <tr>
---      <td>Intermediate</td>
---      <td>24</td>
---    </tr>
---    <tr>
---      <td>Distal</td>
---      <td>25</td>
---    </tr>
---    <tr>
---      <td>Tip</td>
---      <td>26</td>
---    </tr>
---  </tbody> </table>
---
---@overload fun(device: lovr.Device, t: table):table
---@param device lovr.Device # The Device to query.
---@return table transforms # A list of joint transforms for the device.  Each transform is a table with 3 numbers for the position of the joint, 1 number for the joint radius (in meters), and 4 numbers for the angle/axis orientation of the joint.
function lovr.headset.getSkeleton(device) end

---
---Returns a Texture that will be submitted to the headset display.
---
---This will be the render target used in the headset's render pass.
---
---The texture is not guaranteed to be the same every frame, and must be called every frame to get the current texture.
---
---
---### NOTE:
---This function may return `nil` if the headset is not being rendered to this frame.
---
---@return lovr.Texture texture # The headset texture.
function lovr.headset.getTexture() end

---
---Returns the estimated time in the future at which the light from the pixels of the current frame will hit the eyes of the user.
---
---This can be used as a replacement for `lovr.timer.getTime` for timestamps that are used for rendering to get a smoother result that is synchronized with the display of the headset.
---
---
---### NOTE:
---This has a different epoch than `lovr.timer.getTime`, so it is not guaranteed to be close to that value.
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
---Returns the number of views used for rendering.
---
---Each view consists of a pose in space and a set of angle values that determine the field of view.
---
---This is usually 2 for stereo rendering configurations, but it can also be different.
---
---For example, one way of doing foveated rendering uses 2 views for each eye -- one low quality view with a wider field of view, and a high quality view with a narrower field of view.
---
---@return number count # The number of views.
function lovr.headset.getViewCount() end

---
---Returns the pose of one of the headset views.
---
---This info can be used to create view matrices or do other eye-dependent calculations.
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
---
---### NOTE:
---When hand tracking is active, pinching will be mapped to the `trigger` button.
---
---@param device lovr.Device # The device.
---@param button lovr.DeviceButton # The button.
---@return boolean down # Whether the button on the device is currently pressed, or `nil` if the device does not have the specified button.
function lovr.headset.isDown(device, button) end

---
---Returns whether LÖVR has VR input focus.
---
---Focus is lost when the VR system menu is shown.
---
---The `lovr.focus` callback can be used to detect when this changes.
---
---@return boolean focused # Whether the application is focused.
function lovr.headset.isFocused() end

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
---
---### NOTE:
---If a device is tracked, it is guaranteed to return a valid pose until the next call to `lovr.headset.update`.
---
---@param device? lovr.Device # The device to get the pose of.
---@return boolean tracked # Whether the device is currently tracked.
function lovr.headset.isTracked(device) end

---
---Returns a new Model for the specified device.
---
---
---### NOTE:
---Currently this is only implemented for hand models on the Oculus Quest.
---
---@param device? lovr.Device # The device to load a model for.
---@param options? {animated: boolean} # Options for loading the model.
---@return lovr.Model model # The new Model, or `nil` if a model could not be loaded.
function lovr.headset.newModel(device, options) end

---
---Sets the near and far clipping planes used to render to the headset.
---
---Objects closer than the near clipping plane or further than the far clipping plane will be clipped out of view.
---
---
---### NOTE:
---The default clip distances are 0.01 and 0.0.
---
---@param near number # The distance to the near clipping plane, in meters.
---@param far number # The distance to the far clipping plane, in meters, or 0 for an infinite far clipping plane with a reversed Z range.
function lovr.headset.setClipDistance(near, far) end

---
---Sets the display refresh rate, in Hz.
---
---
---### NOTE:
---Changing the display refresh-rate also changes the frequency of lovr.update() and lovr.draw() as they depend on the display frequency.
---
---@param frequency number # The new refresh rate, in Hz.
---@return boolean success # Whether the display refresh rate was successfully set.
function lovr.headset.setDisplayFrequency(frequency) end

---
---Starts the headset session.
---
---This must be called after the graphics module is initialized, and can only be called once.
---
---Normally it is called automatically by `boot.lua`.
---
function lovr.headset.start() end

---
---Submits the current headset texture to the VR display.
---
---This should be called after calling `lovr.graphics.submit` with the headset render pass.
---
---Normally this is taken care of by `lovr.run`.
---
function lovr.headset.submit() end

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
---
---### NOTE:
---Some headset backends are not able to return pressed/released information.
---
---These drivers will always return false for `lovr.headset.wasPressed` and `lovr.headset.wasReleased`.
---
---Typically the internal `lovr.headset.update` function will update pressed/released status.
---
---@param device lovr.Device # The device.
---@param button lovr.DeviceButton # The button to check.
---@return boolean pressed # Whether the button on the device was pressed this frame.
function lovr.headset.wasPressed(device, button) end

---
---Returns whether a button on a device was released this frame.
---
---
---### NOTE:
---Some headset backends are not able to return pressed/released information.
---
---These drivers will always return false for `lovr.headset.wasPressed` and `lovr.headset.wasReleased`.
---
---Typically the internal `lovr.headset.update` function will update pressed/released status.
---
---@param device lovr.Device # The device.
---@param button lovr.DeviceButton # The button to check.
---@return boolean released # Whether the button on the device was released this frame.
function lovr.headset.wasReleased(device, button) end

---
---Different types of input devices supported by the `lovr.headset` module.
---
---@alias lovr.Device
---
---The headset.
---
---| "head"
---
---The left controller.
---
---| "hand/left"
---
---The right controller.
---
---| "hand/right"
---
---A shorthand for hand/left.
---
---| "left"
---
---A shorthand for hand/right.
---
---| "right"
---
---A device tracking the left elbow.
---
---| "elbow/left"
---
---A device tracking the right elbow.
---
---| "elbow/right"
---
---A device tracking the left shoulder.
---
---| "shoulder/left"
---
---A device tracking the right shoulder.
---
---| "shoulder/right"
---
---A device tracking the chest.
---
---| "chest"
---
---A device tracking the waist.
---
---| "waist"
---
---A device tracking the left knee.
---
---| "knee/left"
---
---A device tracking the right knee.
---
---| "knee/right"
---
---A device tracking the left foot or ankle.
---
---| "foot/left"
---
---A device tracking the right foot or ankle.
---
---| "foot/right"
---
---A camera device, often used for recording "mixed reality" footage.
---
---| "camera"
---
---A tracked keyboard.
---
---| "keyboard"
---
---The left eye.
---
---| "eye/left"
---
---The right eye.
---
---| "eye/right"

---
---Axes on an input device.
---
---@alias lovr.DeviceAxis
---
---A trigger (1D).
---
---| "trigger"
---
---A thumbstick (2D).
---
---| "thumbstick"
---
---A touchpad (2D).
---
---| "touchpad"
---
---A grip button or grab gesture (1D).
---
---| "grip"

---
---Buttons on an input device.
---
---@alias lovr.DeviceButton
---
---The trigger button.
---
---| "trigger"
---
---The thumbstick.
---
---| "thumbstick"
---
---The touchpad.
---
---| "touchpad"
---
---The grip button.
---
---| "grip"
---
---The menu button.
---
---| "menu"
---
---The A button.
---
---| "a"
---
---The B button.
---
---| "b"
---
---The X button.
---
---| "x"
---
---The Y button.
---
---| "y"
---
---The proximity sensor on a headset.
---
---| "proximity"

---
---These are all of the supported VR APIs that LÖVR can use to power the lovr.headset module.
---
---You can change the order of headset drivers using `lovr.conf` to prefer or exclude specific VR APIs.
---
---At startup, LÖVR searches through the list of drivers in order.
---
---@alias lovr.HeadsetDriver
---
---A VR simulator using keyboard/mouse.
---
---| "desktop"
---
---OpenXR.
---
---| "openxr"

---
---Represents the different types of origins for coordinate spaces.
---
---An origin of "floor" means that the origin is on the floor in the middle of a room-scale play area.
---
---An origin of "head" means that no positional tracking is available, and consequently the origin is always at the position of the headset.
---
---@alias lovr.HeadsetOrigin
---
---The origin is at the head.
---
---| "head"
---
---The origin is on the floor.
---
---| "floor"
