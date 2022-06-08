package.path = package.path .. ';script/?.lua;tools/?.lua'

local fs       = require 'bee.filesystem'
local config   = require 'configuration'
local markdown = require 'provider.markdown'
local util     = require 'utility'
local lloader  = require 'locale-loader'
local json     = require 'json-beautify'

local function getLocale()
    local locale = {}

    for dirPath in fs.pairs(fs.path 'locale') do
        local lang = dirPath:filename():string()
        local text = util.loadFile((dirPath / 'setting.lua'):string())
        if text then
            locale[lang] = lloader(text, lang)
        end
    end

    return locale
end

local localeMap = getLocale()

local function getDesc(lang, desc)
    if not desc then
        return nil
    end
    if desc:sub(1, 1) ~= '%' or desc:sub(-1, -1) ~= '%' then
        return desc
    end
    local locale = localeMap[lang]
    if not locale then
        return desc
    end
    local id = desc:sub(2, -2)
    return locale[id]
end

local function buildType(md, lang, conf)
    md:add('md', '## type')
    if type(conf.type) == 'table' then
        md:add('ts', ('%s | %s'):format(conf.type[1], conf.type[2]))
    elseif conf.type == 'array' then
        md:add('ts', ('Array<%s>'):format(conf.items.type))
    elseif conf.type == 'object' then
        if conf.properties then
            local _, first = next(conf.properties)
            assert(first)
            md:add('ts', ('object<string, %s>'):format(first.type))
        elseif conf.patternProperties then
            local _, first = next(conf.patternProperties)
            assert(first)
            md:add('ts', ('Object<string, %s>'):format(first.type))
        else
            md:add('ts', '**Unknown object type!!**')
        end
    else
        md:add('ts', ('%s'):format(conf.type))
    end
end

local function buildDesc(md, lang, conf)
    local desc = conf.markdownDescription or conf.description
    desc = getDesc(lang, desc)
    if desc then
        md:add('md', desc)
    else
        md:add('md', '**Missing description!!**')
    end
    md:emptyLine()
end

local function buildDefault(md, lang, conf)
    local default = conf.default
    if default == json.null then
        default = nil
    end
    md:add('md', '## default')
    if conf.type == 'object' then
        if not default then
            default = {}
            for k, v in pairs(conf.properties) do
                default[k] = v.default
            end
        end
        setmetatable(default, json.object)
        md:add('json', ('%s'):format(json.beautify(default, { indent = '    ' })))
    else
        md:add('json', ('%s'):format(json.encode(default)))
    end
end

local function buildEnum(md, lang, conf)
    if conf.enum then
        md:add('md', '## enum')
        md:emptyLine()
        for i, enum in ipairs(conf.enum) do
            local desc = getDesc(lang, conf.markdownEnumDescriptions and conf.markdownEnumDescriptions[i])
            if desc then
                md:add('md', ('* ``%s``: %s'):format(json.encode(enum), desc))
            else
                md:add('md', ('* ``%s``'):format(json.encode(enum)))
            end
        end
        md:emptyLine()
        return
    end

    if conf.type == 'object' and conf.properties then
        local _, first = next(conf.properties)
        if first and first.enum then
            md:add('md', '## enum')
            md:emptyLine()
            for i, enum in ipairs(first.enum) do
                local desc = getDesc(lang, conf.markdownEnumDescriptions and conf.markdownEnumDescriptions[i])
                if desc then
                    md:add('md', ('* ``%s``: %s'):format(json.encode(enum), desc))
                else
                    md:add('md', ('* ``%s``'):format(json.encode(enum)))
                end
            end
            md:emptyLine()
            return
        end
    end

    if conf.type == 'array' and conf.items.enum then
        md:add('md', '## enum')
        md:emptyLine()
        for i, enum in ipairs(conf.items.enum) do
            local desc = getDesc(lang, conf.markdownEnumDescriptions and conf.markdownEnumDescriptions[i])
            if desc then
                md:add('md', ('* ``%s``: %s'):format(json.encode(enum), desc))
            else
                md:add('md', ('* ``%s``'):format(json.encode(enum)))
            end
        end
        md:emptyLine()
        return
    end
end

local function buildMarkdown(lang)
    local dir = fs.path 'doc' / lang
    fs.create_directories(dir)
    local configDoc = markdown()

    for name, conf in util.sortPairs(config) do
        configDoc:add('md', '# ' .. name:gsub('^Lua%.', ''))
        configDoc:emptyLine()
        buildDesc(configDoc, lang, conf)
        buildType(configDoc, lang, conf)
        buildEnum(configDoc, lang, conf)
        buildDefault(configDoc, lang, conf)
    end

    util.saveFile((dir / 'config.md'):string(), configDoc:string())
end

for lang in pairs(localeMap) do
    buildMarkdown(lang)
end
