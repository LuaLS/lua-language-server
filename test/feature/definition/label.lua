TEST_DEF [[
::<!LABEL!>::
goto <?LABEL?>
]]

TEST_DEF [[
goto <?LABEL?>
::<!LABEL!>::
]]

TEST_DEF [[
::LABEL::
function _()
    goto <?LABEL?>
end
]]

TEST_DEF [[
do
    goto <?LABEL?>
end
::<!LABEL!>::
]]

TEST_DEF [[
::LABEL::
goto <?LABEL?>
::<!LABEL!>::
]]
