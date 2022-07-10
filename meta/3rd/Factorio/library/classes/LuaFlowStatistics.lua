---@meta

---Encapsulates statistic data for different parts of the game. In the context of flow statistics, `input` and `output` describe on which side of the associated GUI the values are shown. Input values are shown on the left side, output values on the right side.
---
---Examples:
---- The item production GUI shows "consumption" on the right, thus `output` describes the item consumption numbers. The same goes for fluid consumption.
---- The kills GUI shows "losses" on the right, so `output` describes how many of the force's entities were killed by enemies.
---- The electric network GUI shows "power consumption" on the left side, so in this case `input` describes the power consumption numbers.
---@class LuaFlowStatistics
---@field force LuaForce @The force these statistics belong to or `nil` for pollution statistics.`[R]`
---@field input_counts table<string, uint64|double> @List of input counts indexed by prototype name. Represents the data that is shown on the left side of the GUI for the given statistics.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field output_counts table<string, uint64|double> @List of output counts indexed by prototype name. Represents the data that is shown on the right side of the GUI for the given statistics.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaFlowStatistics = {}

---Reset all the statistics data to 0.
function LuaFlowStatistics.clear() end

---Gets the flow count value for the given time frame. If `sample_index` is not provided, then the value returned is the average across the provided precision time period. These are the values shown in the bottom section of the statistics GUIs.
---
---Use `sample_index` to access the data used to generate the statistics graphs. Each precision level contains 300 samples of data so at a precision of 1 minute, each sample contains data averaged across 60s / 300 = 0.2s = 12 ticks.
---
---All return values are normalized to be per-tick for electric networks and per-minute for all other types.
---@param _table LuaFlowStatistics.get_flow_count
---@return double
function LuaFlowStatistics.get_flow_count(_table) end

---Gets the total input count for a given prototype.
---@param _name string @The prototype name.
---@return uint64|double
function LuaFlowStatistics.get_input_count(_name) end

---Gets the total output count for a given prototype.
---@param _name string @The prototype name.
---@return uint64|double
function LuaFlowStatistics.get_output_count(_name) end

---All methods and properties that this object supports.
---@return string
function LuaFlowStatistics.help() end

---Adds a value to this flow statistics.
---@param _name string @The prototype name.
---@param _count float @The count: positive or negative determines if the value goes in the input or output statistics.
function LuaFlowStatistics.on_flow(_name, _count) end

---Sets the total input count for a given prototype.
---@param _name string @The prototype name.
---@param _count uint64|double @The new count. The type depends on the instance of the statistics.
function LuaFlowStatistics.set_input_count(_name, _count) end

---Sets the total output count for a given prototype.
---@param _name string @The prototype name.
---@param _count uint64|double @The new count. The type depends on the instance of the statistics.
function LuaFlowStatistics.set_output_count(_name, _count) end


---@class LuaFlowStatistics.get_flow_count
---@field name string @The prototype name.
---@field input boolean @Read the input values or the output values
---@field precision_index defines.flow_precision_index @The precision range to read.
---@field sample_index? uint16 @The sample index to read from within the precision range. If not provided, the entire precision range is read. Must be between 1 and 300 where 1 is the most recent sample and 300 is the oldest.
---@field count? boolean @If true, the count of items/fluids/entities is returned instead of the per-time-frame value.

