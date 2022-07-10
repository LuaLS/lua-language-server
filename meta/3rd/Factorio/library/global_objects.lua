---@meta

---Allows registering custom commands for the in-game console accessible via the grave key.
---@type LuaCommandProcessor
commands = {}

---This is the main object, through which most of the API is accessed. It is, however, not available inside handlers registered with [LuaBootstrap::on_load](LuaBootstrap::on_load).
---@type LuaGameScript
game = {}

---Allows printing messages to the calling RCON instance if any.
---@type LuaRCON
rcon = {}

---Allows inter-mod communication by way of providing a repository of interfaces that is shared by all mods.
---@type LuaRemote
remote = {}

---Allows rendering of geometric shapes, text and sprites in the game world.
---@type LuaRendering
rendering = {}

---Provides an interface for registering event handlers.
---@type LuaBootstrap
script = {}

---Allows reading the current mod settings.
---@type LuaSettings
settings = {}

---
---@type Defines
defines = {}

