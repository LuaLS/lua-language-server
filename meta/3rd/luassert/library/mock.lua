---@meta

---A mock wraps an entire table's functions in spies or mocks
---@class luassert.mock

---@generic T
---Create a new mock from a table, wrapping all of it's functions in spies or mocks.
---@param object T The table to wrap
---@param doStubs? boolean If the table should be wrapped with stubs instead of spies
---@param func? function Callback function used for stubs
---@param self? table Table to replace with a spy
---@param key? string The key of the method to replace in `self`
---@return T
function mock(object, doStubs, func, self, key) end

---@generic T
---Create a new mock from a table, wrapping all of it's functions in spies or mocks.
---@param object T The table to wrap
---@param doStubs? boolean If the table should be wrapped with stubs instead of spies
---@param func? function Callback function used for stubs
---@param self? table Table to replace with a spy
---@param key? string The key of the method to replace in `self`
---@return T
function mock.new(object, doStubs, func, self, key) end

---An instance of a mock.
---@class luassert.mockInstance : luassert.spyInstance

---The result of asserting a mock.
---
---Includes functions for performing assertions on a mock.
---@class luassert.mockAssert : luassert.spyAssert

return mock
