---@meta

---@class love.event
love.event = {}

---
---Clears the event queue.
---
function love.event.clear() end

---
---Returns an iterator for messages in the event queue.
---
function love.event.poll() end

---
---Pump events into the event queue.
---
---This is a low-level function, and is usually not called by the user, but by love.run.
---
---Note that this does need to be called for any OS to think you're still running,
---
---and if you want to handle OS-generated events at all (think callbacks).
---
function love.event.pump() end

---
---Adds an event to the event queue.
---
---From 0.10.0 onwards, you may pass an arbitrary amount of arguments with this function, though the default callbacks don't ever use more than six.
---
function love.event.push() end

---
---Adds the quit event to the queue.
---
---The quit event is a signal for the event handler to close LÖVE. It's possible to abort the exit process with the love.quit callback.
---
---@param exitstatus number # The program exit status to use when closing the application.
function love.event.quit(exitstatus) end

---
---Like love.event.poll(), but blocks until there is an event in the queue.
---
function love.event.wait() end

---@class love.Event
---@field focus integer # Window focus gained or lost
---@field joystickpressed integer # Joystick pressed
---@field joystickreleased integer # Joystick released
---@field keypressed integer # Key pressed
---@field keyreleased integer # Key released
---@field mousepressed integer # Mouse pressed
---@field mousereleased integer # Mouse released
---@field quit integer # Quit
---@field resize integer # Window size changed by the user
---@field visible integer # Window is minimized or un-minimized by the user
---@field mousefocus integer # Window mouse focus gained or lost
---@field threaderror integer # A Lua error has occurred in a thread
---@field joystickadded integer # Joystick connected
---@field joystickremoved integer # Joystick disconnected
---@field joystickaxis integer # Joystick axis motion
---@field joystickhat integer # Joystick hat pressed
---@field gamepadpressed integer # Joystick's virtual gamepad button pressed
---@field gamepadreleased integer # Joystick's virtual gamepad button released
---@field gamepadaxis integer # Joystick's virtual gamepad axis moved
---@field textinput integer # User entered text
---@field mousemoved integer # Mouse position changed
---@field lowmemory integer # Running out of memory on mobile devices system
---@field textedited integer # Candidate text for an IME changed
---@field wheelmoved integer # Mouse wheel moved
---@field touchpressed integer # Touch screen touched
---@field touchreleased integer # Touch screen stop touching
---@field touchmoved integer # Touch press moved inside touch screen
---@field directorydropped integer # Directory is dragged and dropped onto the window
---@field filedropped integer # File is dragged and dropped onto the window.
---@field jp integer # Joystick pressed
---@field jr integer # Joystick released
---@field kp integer # Key pressed
---@field kr integer # Key released
---@field mp integer # Mouse pressed
---@field mr integer # Mouse released
---@field q integer # Quit
---@field f integer # Window focus gained or lost
