---@meta

---@diagnostic disable: undefined-doc-name

---@class luassert
local luassert = {}

local spy = require("luassert.library.spy")
local stub = require("luassert.library.stub")
local mock = require("luassert.library.mock")

--#region

---Assert that `value == true`.
---@param value any The value to confirm is `true`.
function luassert.True(value) end

---Assert that `value == false`.
---@param value any The value to confirm is `false`.
function luassert.False(value) end

---Assert that `type(value) == "boolean"`.
---@param value any The value to confirm is of type `boolean`.
function luassert.Boolean(value) end

---Assert that `type(value) == "number"`.
---@param value any The value to confirm is of type `number`.
function luassert.Number(value) end

---Assert that `type(value) == "string"`.
---@param value any The value to confirm is of type `string`.
function luassert.String(value) end

---Assert that `type(value) == "table"`.
---@param value any The value to confirm is of type `table`.
function luassert.Table(value) end

---Assert that `type(value) == "nil"`.
---@param value any The value to confirm is of type `nil`.
function luassert.Nil(value) end

---Assert that `type(value) == "userdata"`.
---@param value any The value to confirm is of type `userdata`.
function luassert.Userdata(value) end

---Assert that `type(value) == "function"`.
---@param value any The value to confirm is of type `function`.
function luassert.Function(value) end

---Assert that `type(value) == "thread"`.
---@param value any The value to confirm is of type `thread`.
function luassert.Thread(value) end

---Assert that a value is truthy.
---@param value any The value to confirm is truthy.
function luassert.truthy(value) end

---Assert that a value is falsy.
---@param value any The value to confirm is falsy.
function luassert.falsy(value) end

---Assert that a callback throws an error.
---@param callback function A callback function that should error
---@param error? string The specific error message that will be asserted
function luassert.error(callback, error) end

luassert.has_error = luassert.error

---Assert that a callback does not error.
---@param callback function A callback function that should not error
function luassert.no_error(callback) end

---Assert that two values are near (equal to within a tolerance).
---@param expected number The expected value
---@param actual number The actual value
---@param tolerance number The tolerable difference between the two values
function luassert.near(expected, actual, tolerance) end

--#endregion


--[[ Are ]]

--#region

---Compare two or more items
luassert.are = {}

---Check that two or more items are equal.
---
---When comparing tables, a reference check will be used.
---@param expected any The expected value
---@param ... any Values to check the equality of
function luassert.are.equal(expected, ...) end

---Check that two or more items have the same value.
---
---When comparing tables, a deep compare will be performed.
---@param expected any The expected value
---@param ... any Values to check
function luassert.are.same(expected, ...) end

luassert.are_equal = luassert.are.equal
luassert.are_same = luassert.are.same
--#endregion


--[[ Are Not ]]

--#region

---Compare two or more items
luassert.are_not = {}

---Check that two or more items are **NOT** equal.
---
---When comparing tables, a reference check will be used.
---@param expected any The value that is **NOT** expected
---@param ... any Values to check the equality of
function luassert.are_not.equal(expected, ...) end

---Check that two or more items **DO NOT** have the same value.
---
---When comparing tables, a deep compare will be performed.
---@param expected any The value that is **NOT** expected
---@param ... any Values to check
function luassert.are_not.same(expected, ...) end

luassert.are_not_equal = luassert.are_not.equal
luassert.are_not_same = luassert.are_not.same
--#endregion


--[[ Is ]]

--#region

---Assert a single item
luassert.is = {}

---Assert that `value == true`.
---@param value any The value to confirm is `true`.
function luassert.is.True(value) end

---Assert that `value == false`.
---@param value any The value to confirm is `false`.
function luassert.is.False(value) end

---Assert that `type(value) == "boolean"`.
---@param value any The value to confirm is of type `boolean`.
function luassert.is.Boolean(value) end

---Assert that `type(value) == "number"`.
---@param value any The value to confirm is of type `number`.
function luassert.is.Number(value) end

---Assert that `type(value) == "string"`.
---@param value any The value to confirm is of type `string`.
function luassert.is.String(value) end

---Assert that `type(value) == "table"`.
---@param value any The value to confirm is of type `table`.
function luassert.is.Table(value) end

---Assert that `type(value) == "nil"`.
---@param value any The value to confirm is of type `nil`.
function luassert.is.Nil(value) end

---Assert that `type(value) == "userdata"`.
---@param value any The value to confirm is of type `userdata`.
function luassert.is.Userdata(value) end

---Assert that `type(value) == "function"`.
---@param value any The value to confirm is of type `function`.
function luassert.is.Function(value) end

---Assert that `type(value) == "thread"`.
---@param value any The value to confirm is of type `thread`.
function luassert.is.Thread(value) end

---Assert that a value is truthy.
---@param value any The value to confirm is truthy.
function luassert.is.truthy(value) end

---Assert that a value is falsy.
---@param value any The value to confirm is falsy.
function luassert.is.falsy(value) end

---Assert that a callback throws an error.
---@param callback function A callback function that should error
---@param error? string The specific error message that will be asserted
function luassert.is.error(callback, error) end

---Assert that a callback does not error.
---@param callback function A callback function that should not error
function luassert.is.no_error(callback) end

luassert.is_true = luassert.is.True
luassert.is_false = luassert.is.False
luassert.is_boolean = luassert.is.Boolean
luassert.is_number = luassert.is.Number
luassert.is_string = luassert.is.String
luassert.is_table = luassert.is.Table
luassert.is_nil = luassert.is.Nil
luassert.is_userdata = luassert.is.Userdata
luassert.is_function = luassert.is.Function
luassert.is_thread = luassert.is.Thread
luassert.is_truthy = luassert.is.truthy
luassert.is_falsy = luassert.is.falsy
luassert.is_falsy = luassert.is.falsy
luassert.is_error = luassert.is.error
luassert.is_no_error = luassert.is.no_error

--#endregion


--[[ Is Not ]]

--#region

---Assert the boolean opposite of a single item.
luassert.is_not = {}

---Assert that `value ~= true`.
---@param value any The value to confirm is **NOT** `true`.
function luassert.is_not.True(value) end

---Assert that `value ~= false`.
---@param value any The value to confirm is **NOT** `false`.
function luassert.is_not.False(value) end

---Assert that `type(value) ~= "boolean"`.
---@param value any The value to confirm is **NOT** of type `boolean`.
function luassert.is_not.Boolean(value) end

---Assert that `type(value) ~= "number"`.
---@param value any The value to confirm is **NOT** of type `number`.
function luassert.is_not.Number(value) end

---Assert that `type(value) ~= "string"`.
---@param value any The value to confirm is **NOT** of type `string`.
function luassert.is_not.String(value) end

---Assert that `type(value) ~= "table"`.
---@param value any The value to confirm is **NOT** of type `table`.
function luassert.is_not.Table(value) end

---Assert that `type(value) ~= "nil"`.
---@param value any The value to confirm is **NOT** of type `nil`.
function luassert.is_not.Nil(value) end

---Assert that `type(value) ~= "userdata"`.
---@param value any The value to confirm is **NOT** of type `userdata`.
function luassert.is_not.Userdata(value) end

---Assert that `type(value) ~= "function"`.
---@param value any The value to confirm is **NOT** of type `function`.
function luassert.is_not.Function(value) end

---Assert that `type(value) ~= "thread"`.
---@param value any The value to confirm is **NOT** of type `thread`.
function luassert.is_not.Thread(value) end

---Assert that a value is **NOT** truthy.
---@param value any The value to confirm is **NOT** truthy.
function luassert.is_not.truthy(value) end

---Assert that a value is **NOT** falsy.
---@param value any The value to confirm is **NOT** falsy.
function luassert.is_not.falsy(value) end

---Assert that a callback does not throw an error.
---@param callback function A callback that should not error
---@param error? string The specific error that should not be thrown
function luassert.is_not.error(callback, error) end

---Assert that a callback throws an error.
---@param callback function A callback that should error
function luassert.is_not.no_error(callback) end

luassert.is_not_true = luassert.is_not.True
luassert.is_not_false = luassert.is_not.False
luassert.is_not_boolean = luassert.is_not.Boolean
luassert.is_not_number = luassert.is_not.Number
luassert.is_not_string = luassert.is_not.String
luassert.is_not_table = luassert.is_not.Table
luassert.is_not_nil = luassert.is_not.Nil
luassert.is_not_userdata = luassert.is_not.Userdata
luassert.is_not_function = luassert.is_not.Function
luassert.is_not_thread = luassert.is_not.Thread
luassert.is_not_truthy = luassert.is_not.truthy
luassert.is_not_falsy = luassert.is_not.falsy
luassert.is_not_falsy = luassert.is_not.falsy
luassert.is_not_error = luassert.is_not.error
luassert.is_not_no_error = luassert.is_not.no_error

--#endregion


--[[ Helpers ]]

--#region

---Assert that all numbers in two arrays are within a specified tolerance of
---each other.
---@param expected number[] The expected values
---@param actual number[] The actual values
---@param tolerance number The tolerable difference between the values in the two arrays
assert.are.all_near = function(expected, actual, tolerance) end

---Assert that all numbers in two arrays are **NOT** within a specified
---tolerance of each other.
---@param expected number[] The expected values
---@param actual number[] The actual values
---@param tolerance number The tolerable differences between the values in the two arrays
assert.are_not.all_near = function(expected, actual, tolerance) end

assert.are_all_near = assert.are.all_near
assert.are_not_all_near = assert.are_not.all_near

--#endregion


--[[ Spies ]]

--#region

---Perform an assertion on a spy object. This will allow you to call further
---functions to perform an assertion.
---@param spy luassert.spyInstance The spy object to begin asserting
---@return luassert.spyAssert spyAssert A new object that has further assert function options
function luassert.spy(spy) end

---Perform an assertion on a stub object. This will allow you to call further
---functions to perform an assertion.
---@param stub luassert.spyInstance The stub object to begin asserting
---@return luassert.spyAssert stubAssert A new object that has further assert function options
function luassert.stub(stub) end

--#endregion

return luassert
