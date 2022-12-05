---@meta

---@class luassert.internal
local internal = {}

---@class luassert:luassert.internal
local luassert = {}

--#region Assertions

---Assert that `value == true`.
---@param value any The value to confirm is `true`.
function internal.True(value) end

internal.is_true = internal.True
internal.is_not_true = internal.True

---Assert that `value == false`.
---@param value any The value to confirm is `false`.
function internal.False(value) end

internal.is_false = internal.False
internal.is_not_false = internal.False

---Assert that `type(value) == "boolean"`.
---@param value any The value to confirm is of type `boolean`.
function internal.Boolean(value) end

internal.boolean = internal.Boolean
internal.is_boolean = internal.Boolean
internal.is_not_boolean = internal.Boolean

---Assert that `type(value) == "number"`.
---@param value any The value to confirm is of type `number`.
function internal.Number(value) end

internal.number = internal.Number
internal.is_number = internal.Number
internal.is_not_number = internal.Number

---Assert that `type(value) == "string"`.
---@param value any The value to confirm is of type `string`.
function internal.String(value) end

internal.string = internal.String
internal.is_string = internal.String
internal.is_not_string = internal.String

---Assert that `type(value) == "table"`.
---@param value any The value to confirm is of type `table`.
function internal.Table(value) end

internal.table = internal.Table
internal.is_table = internal.Table
internal.is_not_table = internal.Table

---Assert that `type(value) == "nil"`.
---@param value any The value to confirm is of type `nil`.
function internal.Nil(value) end

internal.is_nil = internal.Nil
internal.is_not_nil = internal.Nil

---Assert that `type(value) == "userdata"`.
---@param value any The value to confirm is of type `userdata`.
function internal.Userdata(value) end

internal.userdata = internal.Userdata
internal.is_userdata = internal.Userdata
internal.is_not_userdata = internal.Userdata

---Assert that `type(value) == "function"`.
---@param value any The value to confirm is of type `function`.
function internal.Function(value) end

internal.is_function = internal.Function
internal.is_not_function = internal.Function

---Assert that `type(value) == "thread"`.
---@param value any The value to confirm is of type `thread`.
function internal.Thread(value) end

internal.thread = internal.Thread
internal.is_thread = internal.Thread
internal.is_not_thread = internal.Thread


---Assert that a value is truthy.
---@param value any The value to confirm is truthy.
function internal.truthy(value) end

internal.Truthy = internal.truthy
internal.is_truthy = internal.truthy
internal.is_not_truthy = internal.truthy

---Assert that a value is falsy.
---@param value any The value to confirm is falsy.
function internal.falsy(value) end

internal.Falsy = internal.falsy
internal.is_falsy = internal.falsy
internal.is_not_falsy = internal.falsy

---Assert that a callback throws an error.
---@param callback function A callback function that should error
---@param error? string The specific error message that will be asserted
function internal.error(callback, error) end

internal.Error = internal.error
internal.has_error = internal.error
internal.no_error = internal.error
internal.no_has_error = internal.error
internal.has_no_error = internal.error

--- the api is the same as string.find
---@param pattern string
---@param actual string
---@param init? integer
---@param plain? boolean
---## Example
--[[
```lua
  it("Checks matches() assertion does string matching", function()
    assert.is.error(function() assert.matches('.*') end)  -- minimum 2 arguments
    assert.is.error(function() assert.matches(nil, 's') end)  -- arg1 must be a string
    assert.is.error(function() assert.matches('s', {}) end)  -- arg2 must be convertable to string
    assert.is.error(function() assert.matches('s', 's', 's', 's') end)  -- arg3 or arg4 must be a number or nil
    assert.matches("%w+", "test")
    assert.has.match("%w+", "test")
    assert.has_no.match("%d+", "derp")
    assert.has.match("test", "test", nil, true)
    assert.has_no.match("%w+", "test", nil, true)
    assert.has.match("^test", "123 test", 5)
    assert.has_no.match("%d+", "123 test", '4')
  end)
```
]]
function internal.matches(pattern, actual, init, plain) end

internal.is_matches = internal.matches
internal.is_not_matches = internal.matches

internal.match = internal.matches
internal.is_match = internal.matches
internal.is_not_match = internal.matches

---Assert that two values are near (equal to within a tolerance).
---@param expected number The expected value
---@param actual number The actual value
---@param tolerance number The tolerable difference between the two values
---## Example
--[[
    ```lua
      it("Checks near() assertion handles tolerances", function()
        assert.is.error(function() assert.near(0) end)  -- minimum 3 arguments
        assert.is.error(function() assert.near(0, 0) end)  -- minimum 3 arguments
        assert.is.error(function() assert.near('a', 0, 0) end)  -- arg1 must be convertable to number
        assert.is.error(function() assert.near(0, 'a', 0) end)  -- arg2 must be convertable to number
        assert.is.error(function() assert.near(0, 0, 'a') end)  -- arg3 must be convertable to number
        assert.is.near(1.5, 2.0, 0.5)
        assert.is.near('1.5', '2.0', '0.5')
        assert.is_not.near(1.5, 2.0, 0.499)
        assert.is_not.near('1.5', '2.0', '0.499')
    end)
    ```
]]
function internal.near(expected, actual, tolerance) end

internal.Near = internal.near
internal.is_near = internal.near
internal.is_not_near = internal.near

---Check that two or more items are equal.
---
---When comparing tables, a reference check will be used.
---@param expected any The expected value
---@param ... any Values to check the equality of
function internal.equal(expected, ...) end

internal.Equal = internal.equal
internal.are_equal = internal.equal
internal.are_not_equal = internal.equal

---Check that two or more items that are considered the "same".
---
---When comparing tables, a deep compare will be performed.
---@param expected any The expected value
---@param ... any Values to check
function internal.same(expected, ...) end

internal.Same = internal.same
internal.are_same = internal.same
internal.are_not_same = internal.same

--- Number of return values of function
---@param argument_number integer
---@param func fun()
function internal.returned_arguments(argument_number, func) end

internal.not_returned_arguments = internal.returned_arguments

--- check error message by string.match/string.find(`plain`=true)
---@param func function
---@param pattern string
---@param init? integer
---@param plain? boolean
---##Example
--[[
```lua
  it("Checks error_matches to accept only callable arguments", function()
    local t_ok = setmetatable( {}, { __call = function() end } )
    local t_nok = setmetatable( {}, { __call = function() error("some error") end } )
    local f_ok = function() end
    local f_nok = function() error("some error") end

    assert.error_matches(f_nok, ".*")
    assert.no_error_matches(f_ok, ".*")
    assert.error_matches(t_nok, ".*")
    assert.no_error_matches(t_ok, ".*")
  end)
```
]]
function internal.error_matches(func, pattern, init, plain) end

internal.no_error_matches = internal.error_matches

internal.error_match = internal.error_matches
internal.no_error_match = internal.error_matches

internal.matches_error = internal.error_matches
internal.no_matches_error = internal.error_matches

internal.match_error = internal.error_matches
internal.no_match_error = internal.error_matches

--#endregion

--[[ Helpers ]]

--#region

---Assert that all numbers in two arrays are within a specified tolerance of
---each other.
---@param expected number[] The expected values
---@param actual number[] The actual values
---@param tolerance number The tolerable difference between the values in the two arrays
function internal.all_near(expected, actual, tolerance) end

internal.are_all_near = internal.all_near
internal.are_not_all_near = internal.all_near

--- array is uniqued
---@param arr any[]
---## Example
---```lua
---it("Checks to see if table1 only contains unique elements", function()
---    local table2 = { derp = false}
---    local table3 = { derp = true }
---    local table1 = {table2,table3}
---    local tablenotunique = {table2,table2}
---    assert.is.unique(table1)
---    assert.is_not.unique(tablenotunique)
---  end)
---```
function internal.unique(arr) end

internal.is_unique = internal.unique
internal.is_not_unique = internal.unique

--#endregion

--#region Spies

---Perform an assertion on a spy object. This will allow you to call further
---functions to perform an assertion.
---@param spy luassert.spy The spy object to begin asserting
---@return luassert.spy.assert spyAssert A new object that has further assert function options
function internal.spy(spy) end

---Perform an assertion on a stub object. This will allow you to call further
---functions to perform an assertion.
---@param stub luassert.spy The stub object to begin asserting
---@return luassert.spy.assert stubAssert A new object that has further assert function options
function internal.stub(stub) end

--#endregion

--#region Array

---Perform an assertion on an array object. This will allow you to call further
---function to perform an assertion.
---@param object table<integer, any> The array object to begin asserting
---@return luassert.array arrayAssert A new object that has further assert function options
function internal.array(object) end

--#endregion

--#region test apis

--- register custom assertions
---@param namespace 'assertion' | 'matcher' | 'modifier' | string
---@param name string
---@param callback function
---@param positive_message string
---@param negative_message string
---## Example
--[[
```lua
 it("Checks register creates custom assertions", function()
    local say = require("say")

    local function has_property(state, arguments)
      local property = arguments[1]
      local table = arguments[2]
      for key, value in pairs(table) do
        if key == property then
          return true
        end
      end
      return false
    end

    say:set_namespace("en")
    say:set("assertion.has_property.positive", "Expected property %s in:\n%s")
    say:set("assertion.has_property.negative", "Expected property %s to not be in:\n%s")
    assert:register("assertion", "has_property", has_property, "assertion.has_property.positive", "assertion.has_property.negative")

    assert.has_property("name", { name = "jack" })
    assert.has.property("name", { name = "jack" })
    assert.not_has_property("surname", { name = "jack" })
    assert.Not.has.property("surname", { name = "jack" })
    assert.has_error(function() assert.has_property("surname", { name = "jack" }) end)
    assert.has_error(function() assert.has.property("surname", { name = "jack" }) end)
    assert.has_error(function() assert.no_has_property("name", { name = "jack" }) end)
    assert.has_error(function() assert.no.has.property("name", { name = "jack" }) end)
  end)
```
]]
function luassert:register(namespace, name, callback, positive_message, negative_message) end

--[[
    ### Customized formatters
The formatters are functions taking a single argument that needs to be converted to a string representation. The formatter should examine the value provided, if it can format the value, it should return the formatted string, otherwise it should return `nil`.
Formatters can be added through `assert:add_formatter(formatter_func)`, and removed by calling `assert:remove_formatter(formatter_func)`.

Example using the included binary string formatter:
```lua
local binstring = require("luassert.formatters.binarystring")

describe("Tests using a binary string formatter", function()

  setup(function()
    assert:add_formatter(binstring)
  end)

  teardown(function()
    assert:remove_formatter(binstring)
  end)

  it("tests a string comparison with binary formatting", function()
    local s1, s2 = "", ""
    for n = 65,88 do
      s1 = s1 .. string.char(n)
      s2 = string.char(n) .. s2
    end
    assert.are.same(s1, s2)

  end)

end)
```

Because this formatter formats string values, and is added last, it will take precedence over the regular string formatter. The results will be:
```
Failure: ...ua projects\busted\formatter\spec\formatter_spec.lua @ 13
tests a string comparison with binary formatting
...ua projects\busted\formatter\spec\formatter_spec.lua:19: Expected objects to be the same. Passed in:
Binary string length; 24 bytes
58 57 56 55 54 53 52 51   50 4f 4e 4d 4c 4b 4a 49  XWVUTSRQ PONMLKJI
48 47 46 45 44 43 42 41                            HGFEDCBA

Expected:
Binary string length; 24 bytes
41 42 43 44 45 46 47 48   49 4a 4b 4c 4d 4e 4f 50  ABCDEFGH IJKLMNOP
51 52 53 54 55 56 57 58                            QRSTUVWX
```
]]
---@param callback fun(obj:any):string|nil
function luassert:add_formatter(callback) end

---@param fmtr function
function luassert:remove_formatter(fmtr) end

--- To register state information 'parameters' can be used. The parameter is included in a snapshot and can hence be restored in between tests. For an example see `Configuring table depth display` below.
---@param name any
---@param value any
---## Example
--[[
```lua
assert:set_parameter("my_param_name", 1)
local s = assert:snapshot()
assert:set_parameter("my_param_name", 2)
s:revert()
assert.are.equal(1, assert:get_parameter("my_param_name"))
```
]]
function luassert:set_parameter(name, value) end

--- get current snapshot parameter
---@param name any
---@return any value
function luassert:get_parameter(name) end

---To be able to revert changes created by tests, inserting spies and stubs for example, luassert supports 'snapshots'. A snapshot includes the following;
---@return {revert:fun()}
function luassert:snapshot() end

--#endregion

--- unregister custom assertions
---@param namespace 'assertion' | 'matcher' | 'modifier' | string
---@param name string
function luassert:unregister(namespace, name) end

--#region modifier namespace

internal.are = internal
internal.is = internal
internal.has = internal
internal.does = internal

internal.is_not = internal
internal.are_not = internal
internal.has_no = internal
internal.no_has = internal
internal.does_not = internal
internal.no = internal
internal.Not = internal

--#endregion

return luassert
