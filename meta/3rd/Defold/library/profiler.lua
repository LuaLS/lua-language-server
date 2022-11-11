---Profiler API documentation
---Functions for getting profiling data in runtime.
---More detailed profiling <https://www.defold.com/manuals/profiling/> and debugging <http://www.defold.com/manuals/debugging/> information available in the manuals.
---@class profiler
profiler = {}
---pause on current frame
profiler.MODE_PAUSE = nil
---start recording
profiler.MODE_RECORD = nil
---continously show latest frame
profiler.MODE_RUN = nil
---pause at peak frame
profiler.MODE_SHOW_PEAK_FRAME = nil
---show full profiler ui
profiler.VIEW_MODE_FULL = nil
---show mimimal profiler ui
profiler.VIEW_MODE_MINIMIZED = nil
---Creates and shows or hides and destroys the on-sceen profiler ui
---The profiler is a real-time tool that shows the numbers of milliseconds spent
---in each scope per frame as well as counters. The profiler is very useful for
---tracking down performance and resource problems.
---@param enabled boolean # true to enable, false to disable
function profiler.enable_ui(enabled) end

---Get the percent of CPU usage by the application, as reported by the OS.
--- This function is not available on  HTML5.
---For some platforms ( Android,  Linux and  Windows), this information is only available
---by default in the debug version of the engine. It can be enabled in release version as well
---by checking track_cpu under profiler in the game.project file.
---(This means that the engine will sample the CPU usage in intervalls during execution even in release mode.)
---@return number # of CPU used by the application
function profiler.get_cpu_usage() end

---Get the amount of memory used (resident/working set) by the application in bytes, as reported by the OS.
--- This function is not available on  HTML5.
---The values are gathered from internal OS functions which correspond to the following;
---
---OS                            Value
--- iOS MacOSAndrod Linux <https://en.wikipedia.org/wiki/Resident_set_size>        Resident memory
--- Windows <https://en.wikipedia.org/wiki/Working_set>                      Working set
--- HTML5                         Not available
---@return number # used by the application
function profiler.get_memory_usage() end

---Send a text to the profiler
---@param text string # the string to send to the profiler
function profiler.log_text(text) end

---Get the number of recorded frames in the on-screen profiler ui recording buffer
---@return number # the number of recorded frames, zero if on-screen profiler is disabled
function profiler.recorded_frame_count() end

---Starts a profile scope.
---@param name string # The name of the scope
function profiler.scope_begin(name) end

---End the current profile scope.
function profiler.scope_end() end

---Set the on-screen profile mode - run, pause, record or show peak frame
---@param mode constant # the mode to set the ui profiler in
function profiler.set_ui_mode(mode) end

---Set the on-screen profile view mode - minimized or expanded
---@param mode constant # the view mode to set the ui profiler in
function profiler.set_ui_view_mode(mode) end

---Shows or hides the time the engine waits for vsync in the on-screen profiler
---Each frame the engine waits for vsync and depending on your vsync settings and how much time
---your game logic takes this time can dwarf the time in the game logic making it hard to
---see details in the on-screen profiler graph and lists.
---Also, by hiding this the FPS times in the header show the time spent each time excuding the
---time spent waiting for vsync. This shows you how long time your game is spending actively
---working each frame.
---This setting also effects the display of recorded frames but does not affect the actual
---recorded frames so it is possible to toggle this on and off when viewing recorded frames.
---By default the vsync wait times is displayed in the profiler.
---@param visible boolean # true to include it in the display, false to hide it.
function profiler.set_ui_vsync_wait_visible(visible) end

---Pauses and displays a frame from the recording buffer in the on-screen profiler ui
---The frame to show can either be an absolute frame or a relative frame to the current frame.
---@param frame_index table # a table where you specify one of the following parameters:
function profiler.view_recorded_frame(frame_index) end




return profiler