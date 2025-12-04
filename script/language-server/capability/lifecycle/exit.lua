ls.capability.register('exit', function (server)
    if server.status == 'stopped' then
        os.exit(0)
    else
        os.exit(1)
    end
end, { needInitialized = false, validAfterShutdown = true })
