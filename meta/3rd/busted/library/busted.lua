---@diagnostic disable: lowercase-global
---@meta

---comment this api is hided
---@param filename string
function file(filename)
end

---comment
---@param name string
---@param block? fun()
function pending(name, block)
end

---comment
---@async
function async()
end

---comment
---@param name string
---@param block fun()
function describe(name, block)
end

context = describe

expose = describe


function randomize()
end

---comment
---@param name string
---@param block fun()
function it(name, block)
end

spec = it

test = it

---comment
---@param block fun()
function before_each(block)
end

---comment
---@param block fun()
function after_each(block)
end

---comment
---@param block fun()
function setup(block)
end

strict_setup = setup


---comment
---@param block fun()
function teardown(block)
end

strict_teardown = teardown

---comment
---@param block fun()
function lazy_setup(block)
end

---comment
---@param block fun()
function lazy_teardown(block)
end

---comment
---@param block fun()
function finally(block)
end

---@type luassert
assert = {}
---@param key 'assertion' | 'matcher'
function assert:register(key, ...)

end

---@type luassert_spy
spy   = {}
---@type luassert_mock
mock  = {}
---@type luassert_stub
stub  = {}
---@type luassert_match
match = {}
