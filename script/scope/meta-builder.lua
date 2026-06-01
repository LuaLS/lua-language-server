---@class MetaBuilder
local M = Class 'MetaBuilder'

---@param version 'Lua 5.1' | 'Lua 5.2' | 'Lua 5.3' | 'Lua 5.4' | 'Lua 5.5' | 'LuaJIT'
---@param language 'en-us' | 'zh-cn' | string
---@param encoding Encoder.Encoding
function M:__init(version, language, encoding)
    self.version  = version
    self.language = language
    self.encoding = encoding
end

---@param text string
---@return string
function M:compileFile(text)
    return text
end

---@class MetaBuilder.API
local API = {}

---@package
API.compiled = {}

---@async
---@param version 'Lua 5.1' | 'Lua 5.2' | 'Lua 5.3' | 'Lua 5.4' | 'Lua 5.5' | 'LuaJIT'
---@param language 'en-us' | 'zh-cn' | string
---@param encoding Encoder.Encoding
function API.compile(version, language, encoding)
    local key = '{version} {language} {encoding}' % {
        version  = version,
        language = language,
        encoding = encoding,
    }
    if API.compiled[key] then
        return
    end
    API.compiled[key] = true

    local sourceDir = ls.env.ROOT_URI / 'meta' / 'template'
    local targetDir = ls.env.META_URI / key

    local sourceFiles = ls.afs.getChilds(sourceDir)
    if not sourceFiles then
        log.error('Failed to read meta template:', sourceDir)
        return
    end

    local builder = New 'MetaBuilder' (version, language, encoding)
    for _, sourceFile in ipairs(sourceFiles) do
        local fileName = ls.fs.relative(sourceFile, sourceDir)
        local targetFile = targetDir / fileName

        local content = ls.afs.read(sourceFile)
        if not content then
            log.error('Failed to read meta template file:', sourceFile)
            goto continue
        end

        local compiledContent = builder:compileFile(content)
        ls.afs.write(targetFile, compiledContent)

        ::continue::
    end
end

return API
