-- This is an example of how to process the generated `doc.json` file.
-- You can use it to generate a markdown file or a html file.

local jsonc    = require 'jsonc'
local util     = require 'utility'
local markdown = require 'provider.markdown'
local config   = require 'config'
local ws       = require 'workspace'
local fs       = require 'bee.filesystem'

local export = {}

function export.buildMD(outputPath)
    local jsonPath = fs.canonical(
       outputPath .. '/' .. config.get(ws.rootUri, 'Lua.doc.output.filenameJSON')):string()
    local mdPath = fs.canonical(
       outputPath .. '/' .. config.get(ws.rootUri, 'Lua.doc.output.filenameMD')):string()

    local doc = jsonc.decode_jsonc(util.loadFile(jsonPath))
    local md  = markdown()

    assert(type(doc) == 'table')

    for _, class in ipairs(doc) do
        md:add('md', '# ' .. class.name)
        md:emptyLine()
        md:add('md', class.desc)
        md:emptyLine()
        if class.defines then
            for _, define in ipairs(class.defines) do
                if define.extends then
                    md:add('lua', define.extends.view)
                    md:emptyLine()
                end
            end
        end
        if class.fields then
            local mark = {}
            for _, field in ipairs(class.fields) do
                if not mark[field.name] then
                    mark[field.name] = true
                    md:add('md', '## ' .. field.name)
                    md:emptyLine()
                    md:add('lua', field.extends.view)
                    md:emptyLine()
                    md:add('md', field.desc)
                    md:emptyLine()
                end
            end
        end
        md:splitLine()
    end

    util.saveFile(mdPath, md:string())

    return mdPath
end

return export
