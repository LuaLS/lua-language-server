TEST [[
::<!LABEL!>::
goto <?LABEL?>
]]

TEST [[
goto <?LABEL?>
::<!LABEL!>::
]]

TEST [[
::LABEL::
function _()
    goto <?LABEL?>
end
]]

TEST [[
do
    goto <?LABEL?>
end
::<!LABEL!>::
]]
