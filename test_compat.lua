-- Simple test for bee.lua compatibility layer
print("Testing bee.lua compatibility layer...")

local thread = require 'bee-compat'
local channel = require 'bee.channel'

-- Test 1: Create channel
print("Test 1: Creating channel 'test1'...")
local ch1 = thread.newchannel('test1')
assert(ch1, "Failed to create channel")
print("✓ Channel created")

-- Test 2: Query channel
print("Test 2: Querying channel 'test1'...")
local ch2 = thread.channel('test1')
assert(ch2, "Failed to query channel")
print("✓ Channel queried")

-- Test 3: Push and pop
print("Test 3: Push and pop...")
ch1:push(1, "hello", 123)
local ok, id, msg, num = ch2:pop()
assert(ok == true, "Pop should succeed")
assert(id == 1, "ID should be 1")
assert(msg == "hello", "Message should be 'hello'")
assert(num == 123, "Number should be 123")
print("✓ Push and pop work")

-- Test 4: errlog channel
print("Test 4: errlog channel...")
local errch = thread.channel('errlog')
assert(errch, "Failed to get errlog channel")
local ok2, err = errch:pop()
assert(ok2 == false or type(err) == "string", "errlog should return false or string")
print("✓ errlog channel works")

-- Test 5: sys.exe_path
print("Test 5: sys.exe_path...")
local sys = require 'bee.sys'
local fs = require 'bee.filesystem'
local exepath = sys.exe_path()
assert(exepath, "Failed to get exe_path")
print("✓ exe_path: " .. tostring(exepath))

print("\n✓ All compatibility tests passed!")
