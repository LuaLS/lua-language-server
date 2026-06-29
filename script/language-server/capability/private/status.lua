---@async
ls.capability.register('$/status/refresh', function (server, params, task)
    ls.server:refreshStatusReporting()
end)
