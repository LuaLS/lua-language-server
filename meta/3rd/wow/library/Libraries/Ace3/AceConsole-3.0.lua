---@meta
---@class AceConsole-3.0
---@field embeds table ---table containing objects AceConsole is embedded in.
---@field commands table ---table containing commands registered
---@field weakcommands table ---table containing self, command => func references for weak commands that don't persist through enable/disable
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0)
local AceConsole = {}

---@param chatframe Frame? Custom ChatFrame to print to (or any frame with an .AddMessage function)
---@param ... any List of any values to be printed
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0#title-3)
function AceConsole:Print(chatframe, ...) end


---@param chatframe? Frame Custom ChatFrame to print to (or any frame with an .AddMessage function)
---@param format string same syntax as standard Lua format()
---@param ...? any Arguments to the format string
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0#title-4)
function AceConsole:Printf(chatframe, format, ...) end

---@param command string Chat command to be registered WITHOUT leading "/"
---@param func function|string Function to call when the slash command is being used (funcref or methodname)
---@param persist? boolean if false, the command will be soft disabled/enabled when aceconsole is used as a mixin (default: true)
---@return boolean -- true if successful
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0#title-5)
function AceConsole:RegisterChatCommand(command, func, persist) end

---@param command string Chat command to be unregistered WITHOUT leading "/"
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0#title-6)
function AceConsole:UnregisterChatCommand( command )end

---@return table -- Iterator (pairs) over all commands
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0#title-2)
function AceConsole:IterateChatCommands() end

---@param str string The raw argument string
---@param numargs? number How many arguments to get (default 1)
---@param startpos? number Where in the string to start scanning (default  1)
---@return table
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0#title-1)
function AceConsole:GetArgs(str, numargs, startpos) end
