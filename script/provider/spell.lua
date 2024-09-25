local suc, codeFormat = pcall(require, 'code_format')
if not suc then
    return
end

local fs = require 'bee.filesystem'
local config = require 'config'
local pformatting = require 'provider.formatting'

local m = {}

function m.loadDictionaryFromFile(filePath)
    return codeFormat.spell_load_dictionary_from_path(filePath)
end

function m.loadDictionaryFromBuffer(buffer)
    return codeFormat.spell_load_dictionary_from_buffer(buffer)
end

function m.addWord(word)
    return codeFormat.spell_load_dictionary_from_buffer(word)
end

function m.spellCheck(uri, text)
    if not m._dictionaryLoaded then
        m.initDictionary()
        m._dictionaryLoaded = true
    end

    local tempDict = config.get(uri, 'Lua.spell.dict')

    return codeFormat.spell_analysis(uri, text, tempDict)
end

function m.getSpellSuggest(word)
    local status, result = codeFormat.spell_suggest(word)
    if status then
        return result
    end
end

function m.initDictionary()
    local basicDictionary = fs.path(METAPATH) / "spell/dictionary.txt"
    local luaDictionary = fs.path(METAPATH) / "spell/lua_dict.txt"

    m.loadDictionaryFromFile(basicDictionary:string())
    m.loadDictionaryFromFile(luaDictionary:string())
    pformatting.updateNonStandardSymbols(config.get(nil, "Lua.runtime.nonstandardSymbol"))
end

return m
