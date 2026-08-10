TEST_COMPLETION [[
mt = {}
function mt:f(a, b, c)
end
mt:f<??>
]] (function (results)
    print('DEBUG A (global method partial) count=', results and #results or 0)
    for i, r in ipairs(results or {}) do
        print('  ', i, r.label, r.kind, 'ins=' .. tostring(r.insertText))
    end
end)

TEST_COMPLETION [[
mt = {}
function mt:f(a, b, c)
end
mt:<??>
]] (function (results)
    print('DEBUG B (global method empty) count=', results and #results or 0)
    for i, r in ipairs(results or {}) do
        print('  ', i, r.label, r.kind, 'ins=' .. tostring(r.insertText))
    end
end)

TEST_COMPLETION [[
local t = {
    ['a.b.c'] = {}
}
t.<??>
]] (function (results)
    print('DEBUG C (dotted key empty) count=', results and #results or 0)
    for i, r in ipairs(results or {}) do
        print('  ', i, r.label, r.kind,
            r.textEdit and ('te=' .. ls.inspect(r.textEdit)) or '',
            r.additionalTextEdits and ('add=' .. ls.inspect(r.additionalTextEdits)) or '')
    end
end)
