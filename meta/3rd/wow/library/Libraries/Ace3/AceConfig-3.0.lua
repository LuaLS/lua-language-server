---@meta
---@class AceConfig-3.0
local AceConfig = {}

---@paramsig appName, options [, slashcmd]
---@param appName string The application name for the config table.
---@param options table|function|AceConfigOptionsTable The option table (or a function to generate one on demand). [Options table documentation](http://www.wowace.com/addons/ace3/pages/ace-config-3-0-options-tables/)
---@param slashcmd? string|table A slash command to register for the option table, or a table of slash commands.
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0#title-1)
function AceConfig:RegisterOptionsTable(appName, options, slashcmd) end

---@alias Ace3Width
---| '"double"'
---| '"half"'
---| '"full"'
---| '"normal"'

---@alias AceConfigTypes
---| '"execute"'
---| '"input"'
---| '"toggle"'
---| '"range"'
---| '"select"'
---| '"multiselect"'
---| '"color"'
---| '"keybinding"'
---| '"header"'
---| '"description"'
---| '"group"'

---@class AceConfigOptionsTable
---@field name string|function Display name for the option
---@field type AceConfigTypes Type of the option
---@field args table<string, AceConfigOptionsTable> a table containing a list of options
---@field childGroups '"tree"'|'"tab"'|'"select"' Child groups for the option
---@field desc? string|function description for the option (or nil for a self-describing name)
---@field descStyle? string|nil "inline" if you want the description to show below the option in a GUI (rather than as a tooltip). Currently only supported by AceGUI "Toggle".
---@field order? number|string|function relative position of item (default = 100, 0=first, -1=last)
---@field validate? string|function|false validate the input/value before setting it. return a string (error message) to indicate error.
---@field confirm? string|function|boolean prompt for confirmation before changing a value if true display "name - desc", or contents of .confirmText if supplied.
---@field confirmText? string text to display in the confirmation dialog
---@field disabled? string|function|boolean
---@field hidden? string|function|boolean
---@field guiHidden? boolean
---@field dialogHidden? boolean
---@field dropdownHidden? boolean
---@field cmdHidden? boolean
---@field icon? string|function
---@field iconCoords? table|string|function
---@field handler? table
---@field get? function getter function
---@field set? function setter function
---@field func? function
---[Documentation](http://www.wowace.com/addons/ace3/pages/ace-config-3-0-options-tables/)
local OptionsTable = {}
OptionsTable.width = "normal" ---@type number|Ace3Width If a number multiplier of the default width, ie. 0.5 equals "half", 2.0 equals "double"
OptionsTable.descStyle = 100
OptionsTable.order = 100
OptionsTable.disabled = false
OptionsTable.hidden = false
OptionsTable.guiHidden = false
OptionsTable.dialogHidden = false
OptionsTable.dropdownHidden = false
OptionsTable.dropdownHidden = false
OptionsTable.cmdHidden = false

