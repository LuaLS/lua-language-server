local time = require 'bee.time'

do
    ls.util.withDuration(function ()
        for _ = 1, 1000000 do
            local _ = os.clock()
        end
    end, function (duration)
        print('os.clock 平均耗时：{%.2f} ns' % { duration * 1000 })
    end)
end

do
    ls.util.withDuration(function ()
        for _ = 1, 1000000 do
            local _ = time.monotonic()
        end
    end, function (duration)
        print('time.monotonic 平均耗时：{%.2f} ns' % { duration * 1000 })
    end)
end

do
    ls.util.withDuration(function ()
        for _ = 1, 1000000 do
            local _ = time.thread()
        end
    end, function (duration)
        print('time.thread 平均耗时：{%.2f} ns' % { duration * 1000 })
    end)
end
