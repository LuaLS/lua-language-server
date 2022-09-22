---@meta

---@class luassert
local luassert = {}

---Compare two or more items.
luassert.are = {}

---Compare the boolean inverse of two or more items.
luassert.are_not = {}

---Assert a single item.
luassert.is = {}

---Compare the boolean inverse of a single item.
luassert.is_not = {}


--[[ Assertions ]]
--#region

---Assert that `value == true`.
---@param value any The value to confirm is `true`.
function luassert.True(value) end
luassert.is.True = luassert.True
luassert.is_true = luassert.True

---Assert that `value == false`.
---@param value any The value to confirm is `false`.
function luassert.False(value) end
luassert.is.False = luassert.False
luassert.is_false = luassert.False

---Assert that `type(value) == "boolean"`.
---@param value any The value to confirm is of type `boolean`.
function luassert.Boolean(value) end
luassert.boolean = luassert.Boolean
luassert.is.Boolean = luassert.Boolean
luassert.is.boolean = luassert.Boolean
luassert.is_boolean = luassert.Boolean

---Assert that `type(value) == "number"`.
---@param value any The value to confirm is of type `number`.
function luassert.Number(value) end
luassert.number = luassert.Number
luassert.is.Number = luassert.Number
luassert.is_number = luassert.Number

---Assert that `type(value) == "string"`.
---@param value any The value to confirm is of type `string`.
function luassert.String(value) end
luassert.is.string = luassert.String
luassert.is.String = luassert.String
luassert.is.string = luassert.String
luassert.is_string = luassert.String

---Assert that `type(value) == "table"`.
---@param value any The value to confirm is of type `table`.
function luassert.Table(value) end
luassert.table = luassert.Table
luassert.is.Table = luassert.Table
luassert.is.table = luassert.Table
luassert.is_table = luassert.Table

---Assert that `type(value) == "nil"`.
---@param value any The value to confirm is of type `nil`.
function luassert.Nil(value) end
luassert.is.Nil = luassert.Nil
luassert.is_nil = luassert.Nil

---Assert that `type(value) == "userdata"`.
---@param value any The value to confirm is of type `userdata`.
function luassert.Userdata(value) end
luassert.userdata = luassert.Userdata
luassert.is.Userdata = luassert.Userdata
luassert.is.userdata = luassert.Userdata
luassert.is_userdata = luassert.Userdata

---Assert that `type(value) == "function"`.
---@param value any The value to confirm is of type `function`.
function luassert.Function(value) end
luassert.is.Function = luassert.Function
luassert.is_function = luassert.Function

---Assert that `type(value) == "thread"`.
---@param value any The value to confirm is of type `thread`.
function luassert.Thread(value) end
luassert.thread = luassert.Thread
luassert.is.Thread = luassert.Thread
luassert.is.thread = luassert.Thread
luassert.is_thread = luassert.Thread


---Assert that a value is truthy.
---@param value any The value to confirm is truthy.
function luassert.truthy(value) end
luassert.Truthy = luassert.truthy
luassert.is.truthy = luassert.truthy
luassert.is.Truthy = luassert.truthy
luassert.is_truthy = luassert.truthy

---Assert that a value is falsy.
---@param value any The value to confirm is falsy.
function luassert.falsy(value) end
luassert.Falsy = luassert.falsy
luassert.is.falsy = luassert.falsy
luassert.is.Falsy = luassert.falsy
luassert.is_falsy = luassert.falsy

---Assert that a callback throws an error.
---@param callback function A callback function that should error
---@param error? string The specific error message that will be asserted
function luassert.error(callback, error) end
luassert.Error = luassert.error
luassert.is.error = luassert.error
luassert.is.Error = luassert.error
luassert.has_error = luassert.error

---Assert that a callback does not throw an error.
---@param callback function A callback function that should not error
function luassert.no_error(callback) end
luassert.has_no_error = luassert.no_error
luassert.is.no_error = luassert.no_error

---Assert that two values are near (equal to within a tolerance).
---@param expected number The expected value
---@param actual number The actual value
---@param tolerance number The tolerable difference between the two values
function luassert.near(expected, actual, tolerance) end
luassert.Near = luassert.near
luassert.is.near = luassert.near
luassert.is.Near = luassert.near
luassert.is_near = luassert.near

---Check that two or more items are equal.
---
---When comparing tables, a reference check will be used.
---@param expected any The expected value
---@param ... any Values to check the equality of
function luassert.equal(expected, ...) end
luassert.Equal = luassert.equal
luassert.are.equal = luassert.equal
luassert.are.Equal = luassert.equal
luassert.are_equal = luassert.equal

---Check that two or more items that are considered the "same".
---
---When comparing tables, a deep compare will be performed.
---@param expected any The expected value
---@param ... any Values to check
function luassert.same(expected, ...) end
luassert.Same = luassert.same
luassert.are.same = luassert.same
luassert.are.Same = luassert.same
luassert.are_same = luassert.same

--#endregion


--[[ Inverse Assertions ]]

--#region

---Assert that `value ~= true`.
---@param value any The value to confirm is **NOT** `true`.
function luassert.is_not.True(value) end
luassert.is_not_true = luassert.is_not.True

---Assert that `value ~= false`.
---@param value any The value to confirm is **NOT** `false`.
function luassert.is_not.False(value) end
luassert.is_not_false = luassert.is_not.False

---Assert that `type(value) ~= "boolean"`.
---@param value any The value to confirm is **NOT** of type `boolean`.
function luassert.is_not.Boolean(value) end
luassert.is_not.boolean = luassert.is_not.Boolean
luassert.is_not_boolean = luassert.is_not.Boolean

---Assert that `type(value) ~= "number"`.
---@param value any The value to confirm is **NOT** of type `number`.
function luassert.is_not.Number(value) end
luassert.is_not.number = luassert.is_not.Number
luassert.is_not_number = luassert.is_not.Number

---Assert that `type(value) ~= "string"`.
---@param value any The value to confirm is **NOT** of type `string`.
function luassert.is_not.String(value) end
luassert.is_not.string = luassert.is_not.String
luassert.is_not_string = luassert.is_not.String

---Assert that `type(value) ~= "table"`.
---@param value any The value to confirm is **NOT** of type `table`.
function luassert.is_not.Table(value) end
luassert.is_not.table = luassert.is_not.Table
luassert.is_not_table = luassert.is_not.Table

---Assert that `type(value) ~= "nil"`.
---@param value any The value to confirm is **NOT** of type `nil`.
function luassert.is_not.Nil(value) end
luassert.is_not_nil = luassert.is_not.Nil

---Assert that `type(value) ~= "userdata"`.
---@param value any The value to confirm is **NOT** of type `userdata`.
function luassert.is_not.Userdata(value) end
luassert.is_not.userdata = luassert.is_not.Userdata
luassert.is_not_userdata = luassert.is_not.Userdata

---Assert that `type(value) ~= "function"`.
---@param value any The value to confirm is **NOT** of type `function`.
function luassert.is_not.Function(value) end
luassert.is_not_function = luassert.is_not.Function

---Assert that `type(value) ~= "thread"`.
---@param value any The value to confirm is **NOT** of type `thread`.
function luassert.is_not.Thread(value) end
luassert.is_not.thread = luassert.is_not.Thread
luassert.is_not_thread = luassert.is_not.Thread

---Assert that a value is **NOT** truthy.
---@param value any The value to confirm is **NOT** truthy.
function luassert.is_not.truthy(value) end
luassert.is_not.Truthy = luassert.is_not.truthy
luassert.is_not_truthy = luassert.is_not.truthy

---Assert that a value is **NOT** falsy.
---@param value any The value to confirm is **NOT** falsy.
function luassert.is_not.falsy(value) end
luassert.is_not.Falsy = luassert.is_not.falsy
luassert.is_not_falsy = luassert.is_not.falsy

---Assert that a callback does not throw an error.
---@param callback function A callback that should not error
---@param error? string The specific error that should not be thrown
function luassert.is_not.error(callback, error) end
luassert.is_not.Error = luassert.is_not.error
luassert.is_not_error = luassert.is_not.error

---Assert that a callback throws an error.
---@param callback function A callback that should error
function luassert.is_not.no_error(callback) end
luassert.is_not_no_error = luassert.is_not.no_error

---Check that two or more items are **NOT** equal.
---
---When comparing tables, a reference check will be used.
---@param expected any The value that is **NOT** expected
---@param ... any Values to check the equality of
function luassert.are_not.equal(expected, ...) end
luassert.are_not.Equal = luassert.are_not.equal
luassert.are_not_equal = luassert.are_not.equal

---Check that two or more items **DO NOT** have the same value.
---
---When comparing tables, a deep compare will be performed.
---@param expected any The value that is **NOT** expected
---@param ... any Values to check
function luassert.are_not.same(expected, ...) end
luassert.are_not.Same = luassert.are_not.same
luassert.are_not_same = luassert.are_not.same

--#endregion


--[[ Helpers ]]

--#region

---Assert that all numbers in two arrays are within a specified tolerance of
---each other.
---@param expected number[] The expected values
---@param actual number[] The actual values
---@param tolerance number The tolerable difference between the values in the two arrays
assert.are.all_near = function(expected, actual, tolerance) end
assert.are_all_near = assert.are.all_near

---Assert that all numbers in two arrays are **NOT** within a specified
---tolerance of each other.
---@param expected number[] The expected values
---@param actual number[] The actual values
---@param tolerance number The tolerable differences between the values in the two arrays
assert.are_not.all_near = function(expected, actual, tolerance) end
assert.are_not_all_near = assert.are_not.all_near

--#endregion


--[[ Spies ]]

--#region

---Perform an assertion on a spy object. This will allow you to call further
---functions to perform an assertion.
---@param spy luassert.spy The spy object to begin asserting
---@return luassert.spy.assert spyAssert A new object that has further assert function options
function luassert.spy(spy) end

---Perform an assertion on a stub object. This will allow you to call further
---functions to perform an assertion.
---@param stub luassert.spy The stub object to begin asserting
---@return luassert.spy.assert stubAssert A new object that has further assert function options
function luassert.stub(stub) end

--#endregion


--[[ Array ]]

--#region

---Perform an assertion on an array object. This will allow you to call further
---function to perform an assertion.
---@param object table<integer, any> The array object to begin asserting
---@return luassert.array arrayAssert A new object that has further assert function options
function luassert.array(object) end

--#endregion

return luassert
