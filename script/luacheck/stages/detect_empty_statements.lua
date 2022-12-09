local stage = {}

stage.warnings = {
   ["551"] = {message_format = "empty statement", fields = {}}
}

function stage.run(chstate)
   for _, range in ipairs(chstate.useless_semicolons) do
      chstate:warn_range("551", range)
   end
end

return stage
