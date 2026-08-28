ls.capability.register('window/workDoneProgress/cancel', function (_, params)
    if params and params.token ~= nil then
        ls.progress.cancel(params.token)
    end
end)
