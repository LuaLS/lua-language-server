---@meta

---Spies allow you to wrap a function in order to track how that function was
---called.
---@class luassert.spy.factory
---## Example
---```
---describe("New Spy", function()
---    it("Registers a new function to spy on", function()
---        local s = spy.new(function() end)
---
---        s(1, 2, 3)
---        s(4, 5, 6)
---
---        assert.spy(s).was.called()
---        assert.spy(s).was.called(2)
---        assert.spy(s).was.called_with(1, 2, 3)
---   end)
---```
---@overload fun(target:function):luassert.spy
local spy_factory = {}

--#region

---Register a new function to spy on.
---@param target function The function to spy on
---@return luassert.spy spy A spy object that can be used to perform assertions
---
---## Example
---```
---describe("New Spy", function()
---    it("Registers a new function to spy on", function()
---        local s = spy.new(function() end)
---
---        s(1, 2, 3)
---        s(4, 5, 6)
---
---        assert.spy(s).was.called()
---        assert.spy(s).was.called(2)
---        assert.spy(s).was.called_with(1, 2, 3)
---   end)
---```
function spy_factory.new(target) end

---Create a new spy that replaces a method in a table in place.
---@param table table The table that the method is a part of
---@param methodName string The method to spy on
---@return luassert.spy spy A spy object that can be used to perform assertions
---
---## Example
---```
---describe("Spy On", function()
---    it("Replaces a method in a table", function()
---        local t = {
---            greet = function(msg) print(msg) end
---        }
---
---        local s = spy.on(t, "greet")
---
---        t.greet("Hey!") -- prints 'Hey!'
---        assert.spy(t.greet).was_called_with("Hey!")
---
---        t.greet:clear()   -- clears the call history
---        assert.spy(s).was_not_called_with("Hey!")
---
---        t.greet:revert()  -- reverts the stub
---        t.greet("Hello!") -- prints 'Hello!', will not pass through the spy
---        assert.spy(s).was_not_called_with("Hello!")
---    end)
---end)
---```
function spy_factory.on(table, methodName) end

---Check that the provided object is a spy.
---@param object any The object to confirm is a spy
---@return boolean isSpy If the object is a spy or not
function spy_factory.is_spy(object) end

--#endregion

return spy_factory
