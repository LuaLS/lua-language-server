---@meta

--[[
Matchers are used to provide flexible argument matching for `called_with` and `returned_with` asserts. Just like with asserts, you can chain a modifier value using `is` or `is_not`, followed by the matcher you wish to use. Extending busted with your own matchers is done similar to asserts as well; just build a matcher with a common signature and [register it](#matcher-extend). Furthermore, matchers can be combined using [composite matchers](#matcher-composite).
]]
---@class luassert_match
local match = {}

--- this is a `placeholder`, match any thing
--[[
```lua
it("tests wildcard matcher", function()
    local s = spy.new(function() end)
    local _ = match._

    s("foo")

    assert.spy(s).was_called_with(_)        -- matches any argument
    assert.spy(s).was_not_called_with(_, _) -- does not match two arguments
end)
```]]
match._ = {}

--[[
If you're creating a spy for functions that mutate any properties on an table (for example `self`) and you want to use `was_called_with`, you should use `match.is_ref(obj)`.
```lua
describe("combine matchers", function()
    local match = require("luassert.match")

    it("tests ref matchers for passed in table", function()
      local t = { cnt = 0, }
      function t.incrby(t, i) t.cnt = t.cnt + i end

      local s = spy.on(t, "incrby")

      s(t, 2)

      assert.spy(s).was_called_with(match.is_ref(t), 2)
    end)

    it("tests ref matchers for self", function()
      local t = { cnt = 0, }
      function t:incrby(i) self.cnt = self.cnt + i end

      local s = spy.on(t, "incrby")

      t:incrby(2)

      assert.spy(s).was_called_with(match.is_ref(t), 2)
    end)
  end)
```]]
---@param obj any
function match.is_ref(obj)

end

--[[
Combine matchers using composite matchers.
```lua
    describe("combine matchers", function()
      local match = require("luassert.match")

      it("tests composite matchers", function()
        local s = spy.new(function() end)

        s("foo")

        assert.spy(s).was_called_with(match.is_all_of(match.is_not_nil(), match.is_not_number()))
        assert.spy(s).was_called_with(match.is_any_of(match.is_number(), match.is_string(), match.is_boolean())))
        assert.spy(s).was_called_with(match.is_none_of(match.is_number(), match.is_table(), match.is_boolean())))
      end)
    end)
```
]]
function match.is_all_of(...)
end

function match.is_any_of(...)
end

function match.is_none_of(...)
end

return match
