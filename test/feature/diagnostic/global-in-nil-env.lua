TEST_DIAGNOSTIC [[
local _ENV = nil
<?print?>(1)
]] { 'global-in-nil-env' }

TEST_DIAGNOSTIC [[
local x = 1
print(x)
]] { '-global-in-nil-env' }
