---@meta

---
---Provides an interface for modifying and retrieving information about the program's window.
---
---@class love.window
love.window = {}

---
---Closes the window. It can be reopened with love.window.setMode.
---
function love.window.close() end

---
---Converts a number from pixels to density-independent units.
---
---The pixel density inside the window might be greater (or smaller) than the 'size' of the window. For example on a retina screen in Mac OS X with the highdpi window flag enabled, the window may take up the same physical size as an 800x600 window, but the area inside the window uses 1600x1200 pixels. love.window.fromPixels(1600) would return 800 in that case.
---
---This function converts coordinates from pixels to the size users are expecting them to display at onscreen. love.window.toPixels does the opposite. The highdpi window flag must be enabled to use the full pixel density of a Retina screen on Mac OS X and iOS. The flag currently does nothing on Windows and Linux, and on Android it is effectively always enabled.
---
---Most LÖVE functions return values and expect arguments in terms of pixels rather than density-independent units.
---
---@overload fun(px: number, py: number):number, number
---@param pixelvalue number # A number in pixels to convert to density-independent units.
---@return number value # The converted number, in density-independent units.
function love.window.fromPixels(pixelvalue) end

---
---Gets the DPI scale factor associated with the window.
---
---The pixel density inside the window might be greater (or smaller) than the 'size' of the window. For example on a retina screen in Mac OS X with the highdpi window flag enabled, the window may take up the same physical size as an 800x600 window, but the area inside the window uses 1600x1200 pixels. love.window.getDPIScale() would return 2.0 in that case.
---
---The love.window.fromPixels and love.window.toPixels functions can also be used to convert between units.
---
---The highdpi window flag must be enabled to use the full pixel density of a Retina screen on Mac OS X and iOS. The flag currently does nothing on Windows and Linux, and on Android it is effectively always enabled.
---
---@return number scale # The pixel scale factor associated with the window.
function love.window.getDPIScale() end

---
---Gets the width and height of the desktop.
---
---@param displayindex? number # The index of the display, if multiple monitors are available.
---@return string width # The width of the desktop.
---@return string height # The height of the desktop.
function love.window.getDesktopDimensions(displayindex) end

---
---Gets the number of connected monitors.
---
---@return number count # The number of currently connected displays.
function love.window.getDisplayCount() end

---
---Gets the name of a display.
---
---@param displayindex? number # The index of the display to get the name of.
---@return string name # The name of the specified display.
function love.window.getDisplayName(displayindex) end

---
---Gets current device display orientation.
---
---@param displayindex? number # Display index to get its display orientation, or nil for default display index.
---@return love.DisplayOrientation orientation # Current device display orientation.
function love.window.getDisplayOrientation(displayindex) end

---
---Gets whether the window is fullscreen.
---
---@return boolean fullscreen # True if the window is fullscreen, false otherwise.
---@return love.FullscreenType fstype # The type of fullscreen mode used.
function love.window.getFullscreen() end

---
---Gets a list of supported fullscreen modes.
---
---@param displayindex? number # The index of the display, if multiple monitors are available.
---@return table modes # A table of width/height pairs. (Note that this may not be in order.)
function love.window.getFullscreenModes(displayindex) end

---
---Gets the window icon.
---
---@return love.ImageData imagedata # The window icon imagedata, or nil if no icon has been set with love.window.setIcon.
function love.window.getIcon() end

---
---Gets the display mode and properties of the window.
---
---@return number width # Window width.
---@return number height # Window height.
---@return {fullscreen: boolean, fullscreentype: love.FullscreenType, vsync: boolean, msaa: number, resizable: boolean, borderless: boolean, centered: boolean, display: number, minwidth: number, minheight: number, highdpi: boolean, refreshrate: number, x: number, y: number, srgb: boolean} flags # Table with the window properties:
function love.window.getMode() end

---
---Gets the position of the window on the screen.
---
---The window position is in the coordinate space of the display it is currently in.
---
---@return number x # The x-coordinate of the window's position.
---@return number y # The y-coordinate of the window's position.
---@return number displayindex # The index of the display that the window is in.
function love.window.getPosition() end

---
---Gets area inside the window which is known to be unobstructed by a system title bar, the iPhone X notch, etc. Useful for making sure UI elements can be seen by the user.
---
---@return number x # Starting position of safe area (x-axis).
---@return number y # Starting position of safe area (y-axis).
---@return number w # Width of safe area.
---@return number h # Height of safe area.
function love.window.getSafeArea() end

---
---Gets the window title.
---
---@return string title # The current window title.
function love.window.getTitle() end

---
---Gets current vertical synchronization (vsync).
---
---@return number vsync # Current vsync status. 1 if enabled, 0 if disabled, and -1 for adaptive vsync.
function love.window.getVSync() end

---
---Checks if the game window has keyboard focus.
---
---@return boolean focus # True if the window has the focus or false if not.
function love.window.hasFocus() end

---
---Checks if the game window has mouse focus.
---
---@return boolean focus # True if the window has mouse focus or false if not.
function love.window.hasMouseFocus() end

---
---Gets whether the display is allowed to sleep while the program is running.
---
---Display sleep is disabled by default. Some types of input (e.g. joystick button presses) might not prevent the display from sleeping, if display sleep is allowed.
---
---@return boolean enabled # True if system display sleep is enabled / allowed, false otherwise.
function love.window.isDisplaySleepEnabled() end

---
---Gets whether the Window is currently maximized.
---
---The window can be maximized if it is not fullscreen and is resizable, and either the user has pressed the window's Maximize button or love.window.maximize has been called.
---
---@return boolean maximized # True if the window is currently maximized in windowed mode, false otherwise.
function love.window.isMaximized() end

---
---Gets whether the Window is currently minimized.
---
---@return boolean minimized # True if the window is currently minimized, false otherwise.
function love.window.isMinimized() end

---
---Checks if the window is open.
---
---@return boolean open # True if the window is open, false otherwise.
function love.window.isOpen() end

---
---Checks if the game window is visible.
---
---The window is considered visible if it's not minimized and the program isn't hidden.
---
---@return boolean visible # True if the window is visible or false if not.
function love.window.isVisible() end

---
---Makes the window as large as possible.
---
---This function has no effect if the window isn't resizable, since it essentially programmatically presses the window's 'maximize' button.
---
function love.window.maximize() end

---
---Minimizes the window to the system's task bar / dock.
---
function love.window.minimize() end

---
---Causes the window to request the attention of the user if it is not in the foreground.
---
---In Windows the taskbar icon will flash, and in OS X the dock icon will bounce.
---
---@param continuous? boolean # Whether to continuously request attention until the window becomes active, or to do it only once.
function love.window.requestAttention(continuous) end

---
---Restores the size and position of the window if it was minimized or maximized.
---
function love.window.restore() end

---
---Sets whether the display is allowed to sleep while the program is running.
---
---Display sleep is disabled by default. Some types of input (e.g. joystick button presses) might not prevent the display from sleeping, if display sleep is allowed.
---
---@param enable boolean # True to enable system display sleep, false to disable it.
function love.window.setDisplaySleepEnabled(enable) end

---
---Enters or exits fullscreen. The display to use when entering fullscreen is chosen based on which display the window is currently in, if multiple monitors are connected.
---
---@overload fun(fullscreen: boolean, fstype: love.FullscreenType):boolean
---@param fullscreen boolean # Whether to enter or exit fullscreen mode.
---@return boolean success # True if an attempt to enter fullscreen was successful, false otherwise.
function love.window.setFullscreen(fullscreen) end

---
---Sets the window icon until the game is quit. Not all operating systems support very large icon images.
---
---@param imagedata love.ImageData # The window icon image.
---@return boolean success # Whether the icon has been set successfully.
function love.window.setIcon(imagedata) end

---
---Sets the display mode and properties of the window.
---
---If width or height is 0, setMode will use the width and height of the desktop. 
---
---Changing the display mode may have side effects: for example, canvases will be cleared and values sent to shaders with canvases beforehand or re-draw to them afterward if you need to.
---
---@param width number # Display width.
---@param height number # Display height.
---@param flags {fullscreen: boolean, fullscreentype: love.FullscreenType, vsync: boolean, msaa: number, stencil: boolean, depth: number, resizable: boolean, borderless: boolean, centered: boolean, display: number, minwidth: number, minheight: number, highdpi: boolean, x: number, y: number, usedpiscale: boolean, srgb: boolean} # The flags table with the options:
---@return boolean success # True if successful, false otherwise.
function love.window.setMode(width, height, flags) end

---
---Sets the position of the window on the screen.
---
---The window position is in the coordinate space of the specified display.
---
---@param x number # The x-coordinate of the window's position.
---@param y number # The y-coordinate of the window's position.
---@param displayindex? number # The index of the display that the new window position is relative to.
function love.window.setPosition(x, y, displayindex) end

---
---Sets the window title.
---
---@param title string # The new window title.
function love.window.setTitle(title) end

---
---Sets vertical synchronization mode.
---
---@param vsync number # VSync number: 1 to enable, 0 to disable, and -1 for adaptive vsync.
function love.window.setVSync(vsync) end

---
---Displays a message box dialog above the love window. The message box contains a title, optional text, and buttons.
---
---@overload fun(title: string, message: string, buttonlist: table, type: love.MessageBoxType, attachtowindow: boolean):number
---@param title string # The title of the message box.
---@param message string # The text inside the message box.
---@param type? love.MessageBoxType # The type of the message box.
---@param attachtowindow? boolean # Whether the message box should be attached to the love window or free-floating.
---@return boolean success # Whether the message box was successfully displayed.
function love.window.showMessageBox(title, message, type, attachtowindow) end

---
---Converts a number from density-independent units to pixels.
---
---The pixel density inside the window might be greater (or smaller) than the 'size' of the window. For example on a retina screen in Mac OS X with the highdpi window flag enabled, the window may take up the same physical size as an 800x600 window, but the area inside the window uses 1600x1200 pixels. love.window.toPixels(800) would return 1600 in that case.
---
---This is used to convert coordinates from the size users are expecting them to display at onscreen to pixels. love.window.fromPixels does the opposite. The highdpi window flag must be enabled to use the full pixel density of a Retina screen on Mac OS X and iOS. The flag currently does nothing on Windows and Linux, and on Android it is effectively always enabled.
---
---Most LÖVE functions return values and expect arguments in terms of pixels rather than density-independent units.
---
---@overload fun(x: number, y: number):number, number
---@param value number # A number in density-independent units to convert to pixels.
---@return number pixelvalue # The converted number, in pixels.
function love.window.toPixels(value) end

---
---Sets the display mode and properties of the window, without modifying unspecified properties.
---
---If width or height is 0, updateMode will use the width and height of the desktop. 
---
---Changing the display mode may have side effects: for example, canvases will be cleared. Make sure to save the contents of canvases beforehand or re-draw to them afterward if you need to.
---
---@param width number # Window width.
---@param height number # Window height.
---@param settings {fullscreen: boolean, fullscreentype: love.FullscreenType, vsync: boolean, msaa: number, resizable: boolean, borderless: boolean, centered: boolean, display: number, minwidth: number, minheight: number, highdpi: boolean, x: number, y: number} # The settings table with the following optional fields. Any field not filled in will use the current value that would be returned by love.window.getMode.
---@return boolean success # True if successful, false otherwise.
function love.window.updateMode(width, height, settings) end

---
---Types of device display orientation.
---
---@class love.DisplayOrientation
---
---Orientation cannot be determined.
---
---@field unknown integer
---
---Landscape orientation.
---
---@field landscape integer
---
---Landscape orientation (flipped).
---
---@field landscapeflipped integer
---
---Portrait orientation.
---
---@field portrait integer
---
---Portrait orientation (flipped).
---
---@field portraitflipped integer

---
---Types of fullscreen modes.
---
---@class love.FullscreenType
---
---Sometimes known as borderless fullscreen windowed mode. A borderless screen-sized window is created which sits on top of all desktop UI elements. The window is automatically resized to match the dimensions of the desktop, and its size cannot be changed.
---
---@field desktop integer
---
---Standard exclusive-fullscreen mode. Changes the display mode (actual resolution) of the monitor.
---
---@field exclusive integer
---
---Standard exclusive-fullscreen mode. Changes the display mode (actual resolution) of the monitor.
---
---@field normal integer

---
---Types of message box dialogs. Different types may have slightly different looks.
---
---@class love.MessageBoxType
---
---Informational dialog.
---
---@field info integer
---
---Warning dialog.
---
---@field warning integer
---
---Error dialog.
---
---@field error integer
