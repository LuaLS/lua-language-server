---@meta

local signal = {
    version = 0.03,
}


---@alias resty.signal.name
---| "NONE"   # SIG_NONE
---| "HUP"    # SIG_HUP
---| "INT"    # SIG_INT
---| "QUIT"   # SIG_QUIT
---| "ILL"    # SIG_ILL
---| "TRAP"   # SIG_TRAP
---| "ABRT"   # SIG_ABRT
---| "BUS"    # SIG_BUS
---| "FPE"    # SIG_FPE
---| "KILL"   # SIG_KILL
---| "USR1"   # SIG_USR1
---| "SEGV"   # SIG_SEGV
---| "USR2"   # SIG_USR2
---| "PIPE"   # SIG_PIPE
---| "ALRM"   # SIG_ALRM
---| "TERM"   # SIG_TERM
---| "CHLD"   # SIG_CHLD
---| "CONT"   # SIG_CONT
---| "STOP"   # SIG_STOP
---| "TSTP"   # SIG_TSTP
---| "TTIN"   # SIG_TTIN
---| "TTOU"   # SIG_TTOU
---| "URG"    # SIG_URG
---| "XCPU"   # SIG_XCPU
---| "XFSZ"   # SIG_XFSZ
---| "VTALRM" # SIG_VTALRM
---| "PROF"   # SIG_PROF
---| "WINCH"  # SIG_WINCH
---| "IO"     # SIG_IO
---| "PWR"    # SIG_PWR
---| "EMT"    # SIG_EMT
---| "SYS"    # SIG_SYS
---| "INFO"   # SIG_INFO


---@alias resty.signal.signal
---| resty.signal.name
---| integer
---| string


---
-- Sends a signal with its name string or number value to the process of the specified pid.
--
-- All signal names accepted by signum are supported, like HUP, KILL, and TERM.
--
-- Signal numbers are also supported when specifying nonportable system-specific signals is desired.
--
---@param pid number
---@param signal_name_or_num resty.signal.signal
---
---@return boolean ok
---@return string? error
function signal.kill(pid, signal_name_or_num) end


---
-- Maps the signal name specified to the system-specific signal number.
-- Returns `nil` if the signal name is not known.
--
---@param name string|resty.signal.name
---@return integer|nil
function signal.signum(name) end


return signal