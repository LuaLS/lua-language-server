---@meta
--[[ Instance ]]

--#region

---An instance of a spy.
---@class luassert.spy
local spy = {}

---Revert the spied on function to its state before being spied on.
---
---Effectively removes spy from spied-on function.
function spy:revert() end

---Clear the call history for this spy.
function spy:clear() end

---Check how many times this spy has been called.
---@param times integer The expected number of calls
---@param compare? fun(callCount, expected): any A compare function, whose result will be returned as the first return value
---@return any result By default, `true` if the spy was called `times` times. Will be the result of `compare` if given
---@return integer calls Number of times called
function spy:called(times, compare) end

---Check that the spy was called with the provided arguments.
---@param args any[] An array of arguments that are expected to have been passed to this spy
---@return boolean was If this spy was called with the provided arguments
---@return any[] arguments If `was == false`, this will be an array of the arguments *last* given to this spy. If `was == true`, this will be an array of the arguments given to the matching call of this spy.
function spy:called_with(args) end

---Check that the spy returned the provided values
---@pasram ... any An array of values that are expected to have been returned by this spy
---@return boolean did If this spy did return the provided values.
---@return any[] returns If `did == false`, this will be an array of the values *last* returned by this spy. If `did == true`, this will be an array of the values returned by the matching call of this spy.
function spy:returned_with(...) end

--#endregion

--[[ Spy Assertion ]]

--#region

---The result of asserting a spy.
---
---Includes functions for performing assertions on a spy.
---@class luassert.spy.assert
local spy_assert = {}

---Assert that the function being spied on was called.
---@param times integer Assert the number of times the function was called
function spy_assert.called(times) end

---Assert that the function being spied on was called with the provided
---parameters.
---@param ... any The parameters that the function is expected to have been called with
function spy_assert.called_with(...) end

---Assert that the function being spied on was **NOT** called with the provided
---parameters.
---@param ... any The parameters that the function is expected to **NOT** have been called with
function spy_assert.not_called_with(...) end

---Assert that the function being spied on was called at **least** a specified
---number of times.
---@param times integer The minimum number of times that the spied-on function should have been called
function spy_assert.called_at_least(times) end

---Assert that the function being spied on was called at **most** a specified
---number of times.
---@param times integer The maximum number of times that the spied-on function should have been called
function spy_assert.called_at_most(times) end

---Assert that the function being spied on was called **more** than the
---specified number of times.
---@param times integer The number of times that the spied-on function should have been called more than
function spy_assert.called_more_than(times) end

---Assert that the function being spied on was called **less** than the
---specified number of times.
---@param times integer The number of times that the spied-on function should have been called less than
function spy_assert.called_less_than(times) end

---Check that the spy returned the provided values
---@param ... any An array of values that are expected to have been returned by this spy
---@return boolean did If this spy did return the provided values.
---@return any[] returns If `did == false`, this will be an array of the values *last* returned by this spy. If `did == true`, this will be an array of the values returned by the matching call of this spy.
function spy_assert.returned_with(...) end

spy_assert.was = {
    called = spy_assert.called,
    called_with = spy_assert.called_with,
    not_called_with = spy_assert.not_called_with,
    called_at_least = spy_assert.called_at_least,
    called_at_most = spy_assert.called_at_most,
    called_more_than = spy_assert.called_more_than,
    called_less_than = spy_assert.called_less_than,
    returned_with = spy_assert.returned_with,
}

--#endregion
