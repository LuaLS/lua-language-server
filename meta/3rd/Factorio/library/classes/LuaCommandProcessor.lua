---@meta

---Allows for the registration of custom console commands. Similarly to [event subscriptions](LuaBootstrap::on_event), these don't persist through a save-and-load cycle.
---@class LuaCommandProcessor
---@field commands table<string, LocalisedString> @Lists the custom commands registered by scripts through `LuaCommandProcessor`.`[R]`
---@field game_commands table<string, LocalisedString> @Lists the built-in commands of the core game. The [wiki](https://wiki.factorio.com/Console) has an overview of these.`[R]`
---@field object_name string @This object's name.`[R]`
local LuaCommandProcessor = {}

---Add a custom console command.
---
---Trying to add a command with the `name` of a game command or the name of a custom command that is already in use will result in an error.
---
---This will register a custom event called `print_tick` that prints the current tick to either the player issuing the command or to everyone on the server, depending on the command parameter. It shows the usage of the table that gets passed to any function handling a custom command. This specific example makes use of the `tick` and the optional `player_index` and `parameter` fields. The user is supposed to either call it without any parameter (`"/print_tick"`) or with the `"me"` parameter (`"/print_tick me"`). 
---```lua
---commands.add_command("print_tick", nil, function(command)
---  if command.player_index ~= nil and command.parameter == "me" then
---    game.get_player(command.player_index).print(command.tick)
---  else
---    game.print(command.tick)
---  end
---end)
---```
---@param _name string @The desired name of the command (case sensitive).
---@param _help LocalisedString @The localised help message. It will be shown to players using the `/help` command.
---@param _function fun(_arg1:CustomCommandData) @The function that will be called when this command is invoked.
function LuaCommandProcessor.add_command(_name, _help, _function) end

---Remove a custom console command.
---@param _name string @The name of the command to remove (case sensitive).
---@return boolean @Whether the command was successfully removed. Returns `false` if the command didn't exist.
function LuaCommandProcessor.remove_command(_name) end

