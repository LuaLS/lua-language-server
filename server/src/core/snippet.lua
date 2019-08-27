local snippet = {}

snippet.key = {}

snippet.key['do'] = {
    {
        label = 'do .. end',
        text  = [[
do
    $0
end
]]
    }
}

return snippet
