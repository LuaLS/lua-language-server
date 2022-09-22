-- This is an example of how to process the generated `doc.json` file.
-- You can use it to generate a markdown file or a html file.

local json     = require 'json'
local util     = require 'utility'
local markdown = require 'provider.markdown'

local doc = json.decode(util.loadFile(LOGPATH .. '/doc.json'))
local md  = markdown()

for _, class in ipairs(doc) do
    md:add('md', '# ' .. class.name)
    md:emptyLine()
    md:add('md', class.desc)
    md:emptyLine()
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
    md:splitLine()
end

util.saveFile(LOGPATH .. '/doc.md', md:string())
