do
    if not debug.gethook() then
        return
    end

    local co = coroutine.create(function ()
        return debug.gethook()
    end)
    local ok, coHook = coroutine.resume(co)
    lt.assertEquals(ok, true)
    lt.assertEquals(type(coHook), 'function')

    local wrapped = coroutine.wrap(function ()
        return debug.gethook()
    end)
    lt.assertEquals(type(wrapped()), 'function')
end
