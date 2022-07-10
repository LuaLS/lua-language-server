---@meta

---Called when a cutscene is playing, each time it reaches a waypoint in that cutscene.
---
---This refers to an index in the table previously passed to set_controller which started the cutscene.
---
---Due to implementation omission, waypoint_index is 0-based.
---@class on_cutscene_waypoint_reached
---@field name defines.events @Identifier of the event
---@field player_index uint @The player index of the player viewing the cutscene.
---@field tick uint @Tick the event was generated.
---@field waypoint_index uint @The index of the waypoint we just completed.
local on_cutscene_waypoint_reached = {}

