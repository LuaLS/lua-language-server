---@meta

---Called when a [CustomInput](https://wiki.factorio.com/Prototype/CustomInput) is activated.
---@class CustomInputEvent
---@field cursor_position MapPosition @The mouse cursor position when the custom input was activated.
---@field input_name string @The prototype name of the custom input that was activated.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player that activated the custom input.
---@field selected_prototype? SelectedPrototypeData @Information about the prototype that is selected when the custom input is used. Needs to be enabled on the custom input's prototype. `nil` if none is selected.
---@field tick uint @Tick the event was generated.
local CustomInputEvent = {}

