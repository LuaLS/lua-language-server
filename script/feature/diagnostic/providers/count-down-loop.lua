---@param exp LuaParser.Node.Exp
---@return number?
local function getNumber(exp)
    if exp.kind == 'integer' then
        ---@cast exp LuaParser.Node.Integer
        return exp.value
    elseif exp.kind == 'float' then
        ---@cast exp LuaParser.Node.Float
        return exp.value
    end
end

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function countDownLoopProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, node in ipairs(ast.nodesMap['for']) do
        delayer:delay()
        ---@cast node LuaParser.Node.For
        if node.subtype ~= 'loop' then
            goto continue
        end
        local exps = node.exps
        if #exps < 2 then
            goto continue
        end
        local initExp = exps[1]
        local maxExp = exps[2]
        local maxNumber = getNumber(maxExp)
        if not maxNumber then
            goto continue
        end
        local initNumber = getNumber(initExp)
        if initNumber and initNumber <= maxNumber then
            goto continue
        end
        if not initNumber and maxNumber ~= 1 then
            goto continue
        end
        local text = ast.code:sub(initExp.start + 1, maxExp.finish)
        local stepExp = exps[3]
        if not stepExp then
            callback {
                code    = 'count-down-loop',
                level   = 0,
                start   = initExp.start,
                finish  = maxExp.finish,
                message = ('Do you mean `%s, -1` ?'):format(text),
            }
        else
            local stepNumber = getNumber(stepExp)
            if stepNumber and stepNumber > 0 then
                local stepText = ast.code:sub(stepExp.start + 1, stepExp.finish)
                callback {
                    code    = 'count-down-loop',
                    level   = 0,
                    start   = initExp.start,
                    finish  = stepExp.finish,
                    message = ('Do you mean `%s, -%s` ?'):format(text, stepText),
                }
            end
        end
        ::continue::
    end
end

ls.feature.provider.diagnostic(countDownLoopProvider)
