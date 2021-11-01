---@meta

---@class lovr
lovr = {}

---
---The `lovr.conf` callback lets you configure default settings for LÖVR.  It is called once right before the game starts.  Make sure you put `lovr.conf` in a file called `conf.lua`, a special file that's loaded before the rest of the framework initializes.
---
---@alias lovr.conf fun(t: table)

---
---This callback is called every frame.  Use it to render the scene.  If a VR headset is connected, anything rendered by this function will appear in the headset display.  The display is cleared to the background color before this function is called.
---
---@alias lovr.draw fun()

---
---The "lovr.errhand" callback is run whenever an error occurs.  It receives two parameters. The first is a string containing the error message. The second is either nil, or a string containing a traceback (as returned by "debug.traceback()"); if nil, this means "lovr.errhand" is being called in the stack where the error occurred, and it can call "debug.traceback()" itself.
---
---"lovr.errhand" should return a handler function to run in a loop to show the error screen. This handler function is of the same type as the one returned by "lovr.run" and has the same requirements (such as pumping events). If an error occurs while this handler is running, the program will terminate immediately-- "lovr.errhand" will not be given a second chance. Errors which occur inside "lovr.errhand" or in the handler it returns may not be cleanly reported, so be careful.
---
---A default error handler is supplied that renders the error message as text to the headset and to the window.
---
---@alias lovr.errhand fun(message: string, traceback: string):function

---
---The `lovr.focus` callback is called whenever the application acquires or loses focus (for example, when opening or closing the Steam dashboard).  The callback receives a single argument, focused, which is a boolean indicating whether or not the application is now focused.  It may make sense to pause the game or reduce visual fidelity when the application loses focus.
---
---@alias lovr.focus fun(focused: boolean)

---
---This callback is called when a key is pressed.
---
---@alias lovr.keypressed fun(key: lovr.KeyCode, scancode: number, repeating: boolean)

---
---This callback is called when a key is released.
---
---@alias lovr.keyreleased fun(key: lovr.KeyCode, scancode: number)

---
---This callback is called once when the app starts.  It should be used to perform initial setup work, like loading resources and initializing classes and variables.
---
---@alias lovr.load fun(args: table)

---
---This callback is called when a message is logged.  The default implementation of this callback prints the message to the console using `print`, but it's possible to override this callback to render messages in VR, write them to a file, filter messages, and more.
---
---The message can have a "tag" that is a short string representing the sender, and a "level" indicating how severe the message is.
---
---The `t.graphics.debug` flag in `lovr.conf` can be used to get log messages from the GPU driver (tagged as `GL`).  It is also possible to emit your own log messages using `lovr.event.push`.
---
---@alias lovr.log fun(message: string, level: string, tag: string)

---
---This callback is called every frame after rendering to the headset and is usually used to render a mirror of the headset display onto the desktop window.  It can be overridden for custom mirroring behavior.  For example, you could render a single eye instead of a stereo view, apply postprocessing effects, add 2D UI, or render the scene from an entirely different viewpoint for a third person camera.
---
---@alias lovr.mirror fun()

---
---This callback contains a permission response previously requested with `lovr.system.requestPermission`.  The callback contains information on whether permission was granted or denied.
---
---@alias lovr.permission fun(permission: lovr.Permission, granted: boolean)

---
---This callback is called right before the application is about to quit.  Use it to perform any necessary cleanup work.  A truthy value can be returned from this callback to abort quitting.
---
---@alias lovr.quit fun():boolean

---
---This callback is called when the desktop window is resized.
---
---@alias lovr.resize fun(width: number, height: number)

---
---This callback is called when a restart from `lovr.event.restart` is happening.  A value can be returned to send it to the next LÖVR instance, available as the `restart` key in the argument table passed to `lovr.load`.  Object instances can not be used as the restart value, since they are destroyed as part of the cleanup process.
---
---@alias lovr.restart fun():lovr.*

---
---This callback is the main entry point for a LÖVR program.  It is responsible for calling `lovr.load` and returning the main loop function.
---
---@alias lovr.run fun():function

---
---This callback is called when text has been entered.
---
---For example, when `shift + 1` is pressed on an American keyboard, `lovr.textinput` will be called with `!`.
---
---@alias lovr.textinput fun(text: string, code: number)

---
---The `lovr.threaderror` callback is called whenever an error occurs in a Thread.  It receives the Thread object where the error occurred and an error message.
---
---The default implementation of this callback will call `lovr.errhand` with the error.
---
---@alias lovr.threaderror fun(thread: lovr.Thread, message: string)

---
---The `lovr.update` callback should be used to update your game's logic.  It receives a single parameter, `dt`, which represents the amount of elapsed time between frames.  You can use this value to scale timers, physics, and animations in your game so they play at a smooth, consistent speed.
---
---@alias lovr.update fun(dt: number)
