TEST_DIAGNOSTIC [[
local function <?f?>()
end
]] { 'unused-function' }

TEST_DIAGNOSTIC [[
local function f()
end
f()
]] {}

TEST_DIAGNOSTIC [[
<?::label::?>
]] { 'unused-label' }

TEST_DIAGNOSTIC [[
::label::
goto label
]] {}

TEST_DIAGNOSTIC [[
local function _(<?...?>)
end
]] { 'unused-vararg' }

TEST_DIAGNOSTIC [[
local function _(...)
    return ...
end
]] {}

TEST_DIAGNOSTIC [[
local x = 1
local x = 2
print(x)
]] { 'unused-local', 'redefined-local' }

TEST_DIAGNOSTIC [[
local x = 1 
print(x)
]] { 'trailing-space' }