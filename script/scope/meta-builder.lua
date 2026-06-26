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

function M:getDocFormater()
    if not ls.server then
        return nil
    end
    if ls.server.client.params.initializationOptions['viewDocument'] then
        if self.version == 'Lua 5.1' then
            return 'HOVER_NATIVE_DOCUMENT_LUA51'
        elseif self.version == 'Lua 5.2' then
            return 'HOVER_NATIVE_DOCUMENT_LUA52'
        elseif self.version == 'Lua 5.3' then
            return 'HOVER_NATIVE_DOCUMENT_LUA53'
        elseif self.version == 'Lua 5.4' then
            return 'HOVER_NATIVE_DOCUMENT_LUA54'
        elseif self.version == 'Lua 5.5' then
            return 'HOVER_NATIVE_DOCUMENT_LUA55'
        elseif self.version == 'LuaJIT' then
            return 'HOVER_NATIVE_DOCUMENT_LUAJIT'
        end
    else
        if self.version == 'Lua 5.1' then
            return 'HOVER_DOCUMENT_LUA51'
        elseif self.version == 'Lua 5.2' then
            return 'HOVER_DOCUMENT_LUA52'
        elseif self.version == 'Lua 5.3' then
            return 'HOVER_DOCUMENT_LUA53'
        elseif self.version == 'Lua 5.4' then
            return 'HOVER_DOCUMENT_LUA54'
        elseif self.version == 'Lua 5.5' then
            return 'HOVER_DOCUMENT_LUA55'
        elseif self.version == 'LuaJIT' then
            return 'HOVER_DOCUMENT_LUAJIT'
        end
    end
end

function M:convertLink(text)
    local fmt = self:getDocFormater()
    return text:gsub('%$([%.%w_%:]+)', function (name)
        local lastDot = ''
        if name:sub(-1) == '.' then
            name = name:sub(1, -2)
            lastDot = '.'
        end
        if fmt then
            return ('[%s](%s)' % { name, ~fmt % { 'pdf-' .. name } })
                .. lastDot
        else
            return ('`%s`'):format(name) .. lastDot
        end
    end):gsub('§([%.%w]+)', function (name)
        local lastDot = ''
        if name:sub(-1) == '.' then
            name = name:sub(1, -2)
            lastDot = '.'
        end
        if fmt then
            return ('[§%s](%s)' % { name, ~fmt % { name } }) .. lastDot
        else
            return ('`%s`'):format(name) .. lastDot
        end
    end)
end

function M:createViewDocument(name)
    local fmt = self:getDocFormater()
    if not fmt then
        return nil
    end
    name = name:match '[%w_%.%:]+'
    if name:sub(-1) == '.' then
        name = name:sub(1, -2)
    end
    return '[%s](%s)' % {
        ~'HOVER_VIEW_DOCUMENTS',
        ~fmt % { 'pdf-' .. name },
    }
end

---@param script string
---@return string
function M:compileFile(script)
    local middleBuf = {}
    local compileBuf = {}

    local last = 1
    for start, lua, finish in script:gmatch '()%-%-%-%#([^\n\r]*)()' do
        middleBuf[#middleBuf+1] = ('PUSH [===[%s]===]'):format(script:sub(last, start - 1))
        middleBuf[#middleBuf+1] = lua
        last = finish
    end
    middleBuf[#middleBuf+1] = ('PUSH [===[%s]===]'):format(script:sub(last))
    local middleScript = table.concat(middleBuf, '\n')
    local version, jit
    if self.version == 'LuaJIT' then
        version = 5.1
        jit = true
    else
        version = tonumber(self.version:sub(-3)) or 5.5
        jit = false
    end

    local env = setmetatable({
        VERSION = version,
        JIT     = jit,
        PUSH    = function (text)
            compileBuf[#compileBuf+1] = text
        end,
        ---@param name string
        DES     = function (name)
            ---@type string
            ---@diagnostic disable-next-line: assign-type-mismatch
            local des = ~name
            compileBuf[#compileBuf+1] = '---\n'
            for line in ls.util.eachLine(des) do
                compileBuf[#compileBuf+1] = '---'
                compileBuf[#compileBuf+1] = self:convertLink(line)
                compileBuf[#compileBuf+1] = '\n'
            end
            local viewDocument = self:createViewDocument(name)
            if viewDocument then
                compileBuf[#compileBuf+1] = '---\n---'
                compileBuf[#compileBuf+1] = viewDocument
                compileBuf[#compileBuf+1] = '\n'
            end
            compileBuf[#compileBuf+1] = '---\n'
        end,
        ---@param name string
        DESTAIL = function (name)
            ---@type string
            ---@diagnostic disable-next-line: assign-type-mismatch
            local des = ~name
            compileBuf[#compileBuf+1] = self:convertLink(des):gsub('[\r\n]', '...')
            compileBuf[#compileBuf+1] = '\n'
        end,
        ALIVE   = function (str)
            local isAlive
            for piece in str:gmatch '[^%,]+' do
                if piece:sub(1, 1) == '>' then
                    local alive = tonumber(piece:sub(2))
                    if not alive or version >= alive then
                        isAlive = true
                        break
                    end
                elseif piece:sub(1, 1) == '<' then
                    local alive = tonumber(piece:sub(2))
                    if not alive or version <= alive then
                        isAlive = true
                        break
                    end
                else
                    local alive = tonumber(piece)
                    if not alive or version == alive then
                        isAlive = true
                        break
                    end
                end
            end
            if not isAlive then
                compileBuf[#compileBuf+1] = '---@deprecated\n'
            end
        end,
        DISABLE = function ()
        end
    }, { __index = _ENV })

    local suc = xpcall(function ()
        assert(load(middleScript, middleScript, 't', env))()
    end, log.error)
    if not suc then
        log.debug('MiddleScript:\n', middleScript)
    end
    local text = table.concat(compileBuf)
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
---@return Uri
function API.compile(version, language, encoding)
    local key = '{version} {language} {encoding}' % {
        version  = version,
        language = language,
        encoding = encoding,
    }
    local sourceDir = ls.env.ROOT_URI / 'meta' / 'template'
    local targetDir = ls.env.META_URI / key

    if API.compiled[key] then
        return targetDir
    end
    API.compiled[key] = true

    local sourceFiles = ls.afs.getChilds(sourceDir)
    if not sourceFiles then
        log.error('Failed to read meta template:', sourceDir)
        return targetDir
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

    return targetDir
end

return API
