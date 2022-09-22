---@meta

assert = require("luassert")
spy = require("luassert.spy")
stub = require("luassert.stub")
mock = require("luassert.mock")

---Undocumented feature with unknown purpose.
---@param filename string
function file(filename) end

---Mark a test as placeholder.
---
---This will not fail or pass, it will simply be marked as "pending".
---@param name string
---@param block fun()
function pending(name, block) end

---Define the start of an asynchronous test.
---
---Call `done()` at the end of your test to complete it.
---
---## Example
---```
---it("Makes an http request", function()
---    async()
---    http.get("https://github.com", function()
---        print("Got Website!")
---        done()
---    end)
---end)
---```
function async() end

---Mark the end of an asynchronous test.
---
---Should be paired with a call to `async()`.
function done() end

---Used to define a set of tests. Can be nested to define sub-tests.
---
---## Example
---```
---describe("Test Item Class", function()
---    it("Creates an item", function()
---        --...
---    end)
---    describe("Test Tags", function()
---        it("Creates a tag", function()
---            --...
---        end)
---    end)
---end)
---```
---@param name string
---@param block fun()
function describe(name, block) end

context = describe

---Functions like `describe()` except it exposes the test's environment to
---outer contexts
---
---## Example
---```
---describe("Test exposing", function()
---    expose("Exposes a value", function()
---        _G.myValue = 10
---    end)
---
---end)
---
---describe("Another test in the same file", function()
---    assert.are.equal(10, myValue)
---end)
---```
---@param name string
---@param block fun()
function expose(name, block) end

---Functions like `describe()` except it insulates the test's environment to
---only this context.
---
---This is the default behaviour of `describe()`.
---
---## Example
---```
---describe("Test exposing", function()
---    insulate("Insulates a value", function()
---        _G.myValue = 10
---    end)
---
---end)
---
---describe("Another test in the same file", function()
---    assert.is.Nil(myValue)
---end)
---```
---@param name string
---@param block fun()
function insulate(name, block) end

---Randomize tests nested in this block.
---
---## Example
---```
---describe("A randomized test", function()
---    randomize()
---    it("My order is random", function() end)
---    it("My order is also random", function() end)
---end)
---```
function randomize() end

---Define a test that will pass, fail, or error.
---
---You can also use `spec()` and `test()` as aliases.
---
---## Example
---```
---describe("Test something", function()
---    it("Runs a test", function()
---        assert.is.True(10 == 10)
---    end)
---end)
---```
---@param name string
---@param block fun()
function it(name, block) end

spec = it
test = it

---Define a function to run before each child test, this includes tests nested
---in a child describe block.
---
---## Example
---```
---describe("Test Array Class", function()
---    local a
---    local b
---
---    before_each(function()
---        a = Array.new(1, 2, 3, 4)
---        b = Array.new(11, 12, 13, 14)
---    end)
---
---    it("Assures instance is an Array", function()
---        assert.True(Array.isArray(a))
---        assert.True(Array.isArray(b))
---    end)
---
---    describe("Nested tests", function()
---        it("Also runs before_each", function()
---            assert.are.same(
---                { 1, 2, 3, 4, 11, 12, 13, 14 },
---                a:concat(b))
---        end)
---    end)
---end)
---```
---@param block fun()
function before_each(block) end

---Define a function to run after each child test, this includes tests nested
---in a child describe block.
---
---## Example
---```
---describe("Test saving", function()
---    local game
---
---    after_each(function()
---        game.save.reset()
---    end)
---
---    it("Creates game", function()
---        game = game.new()
---        game.save.save()
---    end)
---
---    describe("Saves metadata", function()
---        it("Saves objects", function()
---            game = game.new()
---            game.save.save()
---            assert.is_not.Nil(game.save.objects)
---        end)
---    end)
---end)
---```
---@param block fun()
function after_each(block) end

---Runs first in a context block before any tests.
---
---Will always run even if there are no child tests to run. If you don't want
---them to run regardless, you can use `lazy_setup()` or use the `--lazy` flag
---when running.
---
---## Example
---```
---describe("Test something", function()
---    local helper
---
---    setup(function()
---         helper = require("helper")
---    end)
---
---    it("Can use helper", function()
---        assert.is_not.Nil(helper)
---    end)
---end)
---```
---@param block fun()
function setup(block) end

strict_setup = setup

---Runs first in a context block before any tests. Only runs if there are child
---tests to run.
---
---## Example
---```
---describe("Test something", function()
---    local helper
---
---    -- Will not run because there are no tests
---    lazy_setup(function()
---         helper = require("helper")
---    end)
---
---end)
---```
---@param block fun()
function lazy_setup(block) end

---Runs last in a context block after all tests.
---
---Will run ever if no tests were run in this context. If you don't want this
---to run regardless, you can use `lazy_teardown()` or use the `--lazy` flag
---when running.
---
---## Example
---```
---describe("Remove persistent value", function()
---    local persist
---
---    it("Sets a persistent value", function()
---        persist = "hello"
---    end)
---
---    teardown(function()
---         persist = nil
---    end)
---
---end)
---```
---@param block fun()
function teardown(block) end

strict_teardown = teardown

---Runs last in a context block after all tests.
---
---Will only run if tests were run in this context.
---
---## Example
---```
---describe("Remove persistent value", function()
---    local persist
---
---    -- Will not run because no tests were run
---    lazy_teardown(function()
---         persist = nil
---    end)
---
---end)
---```
---@param block fun()
function lazy_teardown(block) end

---Runs last in a context block regardless of test outcome
---
---## Example
---```
---it("Read File Contents",function()
---    local f = io.open("file", "r")
---
---    -- always close file after test
---    finally(function()
---        f:close()
---    end)
---
---    -- do stuff with f
---end)
---```
---@param block fun()
function finally(block) end
