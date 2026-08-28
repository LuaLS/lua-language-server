local projectPath = ls.args.TEST_PROJECT
if projectPath == '' or type(projectPath) ~= 'string' then
    return
end

local SAMPLE_LIMIT = 15
local LINE_LIMIT   = 120

local function getSourceLine(text, offset)
    local pos = offset + 1
    local s = pos
    while s > 1 do
        local c = text:byte(s - 1)
        if c == 10 or c == 13 then
            break
        end
        s = s - 1
    end
    local e = pos
    while e <= #text do
        local c = text:byte(e)
        if c == 10 or c == 13 then
            break
        end
        e = e + 1
    end
    local line = text:sub(s, e - 1)
    if #line > LINE_LIMIT then
        line = line:sub(1, LINE_LIMIT) .. '...'
    end
    return line
end

local function relPath(projectPath, uri)
    local path = ls.uri.decode(uri)
    if path:sub(1, #projectPath) == projectPath then
        return path:sub(#projectPath + 2)
    end
    return path
end

do
    test.scope:remove()
    local rootUri = ls.uri.encode(projectPath)
    local scope <close> = ls.scope.create('external', rootUri, ls.afs)

    print('项目路径：' .. projectPath)

    local c1 = os.clock()
    local result = scope:load({}, function () end)
    local c2 = os.clock()
    print('文件数量：{}，加载耗时：{%.2f} 秒' % { #result.uris, c2 - c1 })

    local codeTotal  = {}
    local codeFiles  = {}
    local codeSample = {}
    local total      = 0
    local errFiles   = 0

    for _, uri in ipairs(result.uris) do
        local doc = scope:getDocument(uri)
        if doc and doc.ast then
            local errors = doc.ast.errors
            if errors and #errors > 0 then
                errFiles = errFiles + 1
                local text = doc.file:getText()
                for _, err in ipairs(errors) do
                    local code = err.errorCode or 'UNKNOWN'
                    total = total + 1
                    codeTotal[code] = (codeTotal[code] or 0) + 1
                    local files = codeFiles[code]
                    if not files then
                        files = {}
                        codeFiles[code] = files
                    end
                    files[uri] = true
                    local list = codeSample[code]
                    if not list then
                        list = {}
                        codeSample[code] = list
                    end
                    if #list < SAMPLE_LIMIT then
                        local row, col = doc.positionConverter:offsetToPosition(err.start)
                        list[#list+1] = '{}:{}:{} | {}' % {
                            relPath(projectPath, uri),
                            row + 1,
                            col + 1,
                            getSourceLine(text, err.start),
                        }
                    end
                end
            end
        end
    end

    print('语法错误总数：{}，涉及文件：{} / {}' % { total, errFiles, #result.uris })

    local codes = {}
    for code in pairs(codeTotal) do
        codes[#codes+1] = code
    end
    table.sort(codes, function (a, b)
        if codeTotal[a] ~= codeTotal[b] then
            return codeTotal[a] > codeTotal[b]
        end
        return a < b
    end)

    for _, code in ipairs(codes) do
        local fileN = 0
        for _ in pairs(codeFiles[code]) do
            fileN = fileN + 1
        end
        print('{%-24s} {%6d} 处 / {} 文件' % { code, codeTotal[code], fileN })
        for _, sample in ipairs(codeSample[code]) do
            print('    ' .. sample)
        end
    end
end
