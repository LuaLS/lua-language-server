do
    local guard = require 'tools.mem-guard'
    if not guard.isEnabled() then
        return
    end

    lt.assertEquals(guard.enable(1), false)
    lt.assertEquals(type(debug.gethook()), 'function')

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
