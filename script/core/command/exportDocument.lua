local doc    = require 'cli.doc'
local client = require 'client'
local furi   = require 'file-uri'
local lang   = require 'language'
local files  = require 'files'

---@async
return function (args)
    local outputPath = args[1] and furi.decode(args[1]) or LOGPATH
    local docPath, mdPath = doc.makeDoc(outputPath)
    client.showMessage('Info', lang.script('CLI_DOC_DONE'
        , ('[%s](%s)'):format(files.normalize(docPath), furi.encode(docPath))
        , ('[%s](%s)'):format(files.normalize(mdPath),  furi.encode(mdPath))
    ))
end
