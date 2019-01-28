local m = require 'lpeglabel'

local m_cut  = m.S'/\\'
local m_path = (1-m_cut)^1

local function match_any(p, pass)
    return m.P{p + pass * m.V(1)}
end

local function compile_format(fmt)
    local function next(cur)
        local pos, fn = fmt:find('%*+', cur)
        if not pos then
            return m.P(fmt:sub(cur)) * -1
        end
        local word = m.P(fmt:sub(cur, pos-1))
        return word * match_any(next(fn+1), 1)
    end
    return next(1)
end

local function compile_exp(exp)
    if exp:sub(1, 1) == '/' then
        exp = exp:sub(2)
    else
        exp = '**/' .. exp
    end
    local function next(cur)
        local pos, fn = exp:find('[/\\]+', cur)
        if not pos then
            return compile_format(exp:sub(cur))
        end
        local fmt = exp:sub(cur, pos-1)
        if fmt == '**' then
            return match_any(next(fn+1), m_path * m_cut)
        elseif fmt == '' then
            return m_cut
        else
            if fn < #exp then
                return m.P(fmt) * m_cut * next(fn+1)
            else
                return m.P(fmt) * m_cut
            end
        end
    end
    return next(1)
end

local function compile_exps(exp)
    local matcher
    for _, exp in ipairs(exp) do
        exp = exp:lower()
        if matcher then
            matcher = matcher + compile_exp(exp)
        else
            matcher = compile_exp(exp)
        end
    end
    return matcher
end

return function (exp)
    local matcher = compile_exps(exp)
    return function (path)
        local filename = path:lower()
        return not not matcher:match(filename)
    end
end
