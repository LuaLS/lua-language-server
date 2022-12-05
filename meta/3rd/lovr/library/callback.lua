---@meta

---
---The `lovr.conf` callback lets you configure default settings for LÖVR.
---
---It is called once right before the game starts.
---
---Make sure you put `lovr.conf` in a file called `conf.lua`, a special file that's loaded before the rest of the framework initializes.
---
---
---### NOTE:
---Disabling unused modules can improve startup time.
---
---`t.window` can be set to nil to avoid creating the window.
---
---The window can later be opened manually using `lovr.system.openWindow`.
---
---Enabling the `t.graphics.debug` flag will add additional error checks and will send messages from the GPU driver to the `lovr.log` callback.
---
---This will decrease performance but can help provide information on performance problems or other bugs.
---
---The `headset.offset` field is a vertical offset applied to the scene for headsets that do not center their tracking origin on the floor.
---
---This can be thought of as a "default user height". Setting this offset makes it easier to design experiences that work in both seated and standing VR configurations.
---
---@type fun(t: table)
lovr.conf = nil

---
---This callback is called every frame, and receives a `Pass` object as an argument which can be used to render graphics to the display.
---
---If a VR headset is connected, this function renders to the headset display, otherwise it will render to the desktop window.
---
---
---### NOTE:
---To render to the desktop window when a VR headset is connected, use the `lovr.mirror` callback.
---
---The display is cleared to the global background color before this callback is called, which can be changed using `lovr.graphics.setBackgroundColor`.
---
---Since the `lovr.graphics.submit` function always returns true, the following idiom can be used to submit graphics work manually and override the default submission:
---
---    function lovr.draw(pass)
---      local passes = {}
---
---      -- ... record multiple passes and add to passes table
---
---      return lovr.graphics.submit(passes)
---    end
---
---@type fun(pass: lovr.Pass):boolean
lovr.draw = nil

---
---The `lovr.errhand` callback is run whenever an error occurs.
---
---It receives a parameter containing the error message.
---
---It should return a handler function that will run in a loop to render the error screen.
---
---This handler function is of the same type as the one returned by `lovr.run` and has the same requirements (such as pumping events).
---
---If an error occurs while this handler is running, the program will terminate immediately -- `lovr.errhand` will not be given a second chance.
---
---Errors which occur in the error handler or in the handler it returns may not be cleanly reported, so be careful.
---
---A default error handler is supplied that renders the error message as text to the headset and to the window.
---
---@type fun(message: string):function
lovr.errhand = nil

---
---The `lovr.focus` callback is called whenever the application acquires or loses focus (for example, when opening or closing the Steam dashboard).
---
---The callback receives a single argument, focused, which is a boolean indicating whether or not the application is now focused.
---
---It may make sense to pause the game or reduce visual fidelity when the application loses focus.
---
---@type fun(focused: boolean)
lovr.focus = nil

---
---This callback is called when a key is pressed.
---
---@type fun(key: lovr.KeyCode, scancode: number, repeating: boolean)
lovr.keypressed = nil

---
---This callback is called when a key is released.
---
---@type fun(key: lovr.KeyCode, scancode: number)
lovr.keyreleased = nil

---
---This callback is called once when the app starts.
---
---It should be used to perform initial setup work, like loading resources and initializing classes and variables.
---
---
---### NOTE:
---If the project was loaded from a restart using `lovr.event.restart`, the return value from the previously-run `lovr.restart` callback will be made available to this callback as the `restart` key in the `arg` table.
---
---The `arg` table follows the [Lua standard](https://en.wikibooks.org/wiki/Lua_Programming/command_line_parameter).
---
---The arguments passed in from the shell are put into a global table named `arg` and passed to `lovr.load`, but with indices offset such that the "script" (the project path) is at index 0.
---
---So all arguments (if any) intended for the project are at successive indices starting with 1, and the executable and its "internal" arguments are in normal order but stored in negative indices.
---
---@type fun(arg: table)
lovr.load = nil

---
---This callback is called when a message is logged.
---
---The default implementation of this callback prints the message to the console using `print`, but it's possible to override this callback to render messages in VR, write them to a file, filter messages, and more.
---
---The message can have a "tag" that is a short string representing the sender, and a "level" indicating how severe the message is.
---
---The `t.graphics.debug` flag in `lovr.conf` can be used to get log messages from the GPU driver (tagged as `GPU`).
---
---It is also possible to emit customlog messages using `lovr.event.push`, or by calling the callback.
---
---@type fun(message: string, level: string, tag: string)
lovr.log = nil

---
---This callback is called every frame after rendering to the headset and is usually used to render a mirror of the headset display onto the desktop window.
---
---It can be overridden for custom mirroring behavior.
---
---For example, a stereo view could be drawn instead of a single eye or a 2D HUD could be rendered.
---
---@type fun(pass: lovr.Pass):boolean
lovr.mirror = nil

---
---This callback contains a permission response previously requested with `lovr.system.requestPermission`.
---
---The callback contains information on whether permission was granted or denied.
---
---@type fun(permission: lovr.Permission, granted: boolean)
lovr.permission = nil

---
---This callback is called right before the application is about to quit.
---
---Use it to perform any necessary cleanup work.
---
---A truthy value can be returned from this callback to abort quitting.
---
---@type fun():boolean
lovr.quit = nil

---
---This callback is called when the desktop window is resized.
---
---@type fun(width: number, height: number)
lovr.resize = nil

---
---This callback is called when a restart from `lovr.event.restart` is happening.
---
---A value can be returned to send it to the next LÖVR instance, available as the `restart` key in the argument table passed to `lovr.load`.
---
---Object instances can not be used as the restart value, since they are destroyed as part of the cleanup process.
---
---
---### NOTE:
---Only nil, booleans, numbers, and strings are supported types for the return value.
---
---@type fun():any
lovr.restart = nil

---
---This callback is the main entry point for a LÖVR program.
---
---It calls `lovr.load` and returns a function that will be called every frame.
---
---
---### NOTE:
---The main loop function can return one of the following values:
---
---- Returning `nil` will keep the main loop running.
---- Returning the string 'restart' plus an optional value will restart LÖVR.
---
---The value can be
---  accessed in the `restart` key of the `arg` global.
---- Returning a number will exit LÖVR using the number as the exit code (0 means success).
---
---Care should be taken when overriding this callback.
---
---For example, if the main loop does not call `lovr.event.pump` then the OS will think LÖVR is unresponsive, and if the quit event is not handled then closing the window won't work.
---
---@type fun():function
lovr.run = nil

---
---This callback is called when text has been entered.
---
---For example, when `shift + 1` is pressed on an American keyboard, `lovr.textinput` will be called with `!`.
---
---
---### NOTE:
---Some characters in UTF-8 unicode take multiple bytes to encode.
---
---Due to the way Lua works, the length of these strings will be bigger than 1 even though they are just a single character. `Pass:text` is compatible with UTF-8 but doing other string processing on these strings may require a library.
---
---Lua 5.3+ has support for working with UTF-8 strings.
---
---@type fun(text: string, code: number)
lovr.textinput = nil

---
---The `lovr.threaderror` callback is called whenever an error occurs in a Thread.
---
---It receives the Thread object where the error occurred and an error message.
---
---The default implementation of this callback will call `lovr.errhand` with the error.
---
---@type fun(thread: lovr.Thread, message: string)
lovr.threaderror = nil

---
---The `lovr.update` callback should be used to update your game's logic.
---
---It receives a single parameter, `dt`, which represents the amount of elapsed time between frames.
---
---You can use this value to scale timers, physics, and animations in your game so they play at a smooth, consistent speed.
---
---@type fun(dt: number)
lovr.update = nil
