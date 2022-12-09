local decoder = require "luacheck.decoder"
local parser = require "luacheck.parser"

local stage = {}

function stage.run(chstate)
   chstate.source = decoder.decode(chstate.source_bytes)
   chstate.line_offsets = {}
   chstate.line_lengths = {}
   local ast, comments, code_lines, line_endings, useless_semicolons = parser.parse(
      chstate.source, chstate.line_offsets, chstate.line_lengths)
   chstate.ast = ast
   chstate.comments = comments
   chstate.code_lines = code_lines
   chstate.line_endings = line_endings
   chstate.useless_semicolons = useless_semicolons
end

return stage
