TEST_DIAGNOSTIC [[
local <?x <close>?>
]] { 'close-non-object' }

TEST_DIAGNOSTIC [[
local x <close> = 1
]] {}
