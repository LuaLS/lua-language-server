---@meta

local signal = {
    version = 0.03,
}

---@alias resty.signal.name
---| '"HUP"'
---| '"INT"'
---| '"QUIT"'
---| '"ILL"'
---| '"TRAP"'
---| '"ABRT"'
---| '"BUS"'
---| '"FPE"'
---| '"KILL"'
---| '"USR1"'
---| '"SEGV"'
---| '"USR2"'
---| '"PIPE"'
---| '"ALRM"'
---| '"TERM"'
---| '"CHLD"'
---| '"CONT"'
---| '"STOP"'
---| '"TSTP"'
---| '"TTIN"'
---| '"TTOU"'
---| '"URG"'
---| '"XCPU"'
---| '"XFSZ"'
---| '"VTALRM"'
---| '"PROF"'
---| '"WINCH"'
---| '"IO"'
---| '"PWR"'
---| '"EMT"'
---| '"SYS"'
---| '"INFO"'
---| '"NONE"' # The special signal name NONE is also supported, which is mapped to zero (0).


---
-- Sends a signal with its name string or number value to the process of the specified pid.
--
-- All signal names accepted by signum are supported, like HUP, KILL, and TERM.
--
-- Signal numbers are also supported when specifying nonportable system-specific signals is desired.
--
---@param pid number
---@param signal_name_or_num number|resty.signal.name
---
---@return boolean ok
---@return string? error
function signal.kill(pid, signal_name_or_num) end

---
-- Maps the signal name specified to the system-specific signal number.
-- Returns `nil` if the signal name is not known.
--
---@param name resty.signal.name
---@return number|nil
function signal.signum(name) end

return signal