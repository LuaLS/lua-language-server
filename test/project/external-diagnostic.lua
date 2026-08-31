local projectPath = ls.args.TEST_PROJECT
if projectPath == '' or type(projectPath) ~= 'string' then
    return
end

local SAMPLE_LIMIT = 100000
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

    do
        for _, uri in ipairs(result.uris) do
            if uri:find('dotted', 1, true) then
                local mv = scope.vm:getFile(uri)
                if mv and mv.coder then
                    for line in mv.coder.code:gmatch('[^\r\n]+') do
                        if line:find('addParamDef', 1, true)
                        or line:find('param@5:18', 1, true) then
                            print('PARAMDEF ' .. line)
                        end
                    end
                end
                break
            end
        end
    end

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

    local diagTotal  = {}
    local diagFiles  = {}
    local diagSample = {}
    local diagN      = 0
    local diagFileN  = 0

    scope.config:set(rootUri, 'Lua.diagnostics.groupFileStatus', {
        ['type-check'] = 'Any',
    })

    local c3 = os.clock()
    for _, uri in ipairs(result.uris) do
        local isProjectFile = uri:sub(1, #rootUri) == rootUri
        local doc = isProjectFile and scope:getDocument(uri) or nil
        if doc then
            local diags = ls.feature.diagnostic(uri)
            if diags and #diags > 0 then
                diagFileN = diagFileN + 1
                local text = doc.file:getText()
                for _, diag in ipairs(diags) do
                    diagN = diagN + 1
                    diagTotal[diag.code] = (diagTotal[diag.code] or 0) + 1
                    local files = diagFiles[diag.code]
                    if not files then
                        files = {}
                        diagFiles[diag.code] = files
                    end
                    files[uri] = true
                    local list = diagSample[diag.code]
                    if not list then
                        list = {}
                        diagSample[diag.code] = list
                    end
                    if #list < SAMPLE_LIMIT then
                        local row, col = doc.positionConverter:offsetToPosition(diag.start)
                        list[#list+1] = '{}:{}:{} | {} | {}' % {
                            relPath(projectPath, uri),
                            row + 1,
                            col + 1,
                            getSourceLine(text, diag.start),
                            diag.message,
                        }
                    end
                end
            end
        end
    end
    local c4 = os.clock()

    print('语义诊断总数：{}，涉及文件：{}，耗时：{%.2f} 秒' % { diagN, diagFileN, c4 - c3 })

    local diagCodes = {}
    for code in pairs(diagTotal) do
        diagCodes[#diagCodes+1] = code
    end
    table.sort(diagCodes, function (a, b)
        if diagTotal[a] ~= diagTotal[b] then
            return diagTotal[a] > diagTotal[b]
        end
        return a < b
    end)

    for _, code in ipairs(diagCodes) do
        local fileN = 0
        for _ in pairs(diagFiles[code]) do
            fileN = fileN + 1
        end
        print('{%-24s} {%6d} 处 / {} 文件' % { code, diagTotal[code], fileN })
        for _, sample in ipairs(diagSample[code]) do
            print('    ' .. sample)
        end
    end
end
