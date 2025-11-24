-- Compatibility layer for bee.lua API changes
local thread = require 'bee.thread'
local channel_mod = require 'bee.channel'
local select_mod = require 'bee.select'

-- Store original thread.create
local original_create = thread.create

-- Add thread.thread as alias for backward compatibility
thread.thread = original_create

-- Store channels globally
local channels = {}
local selector = select_mod.create()

-- Create a wrapper for errlog to make it compatible with channel interface
local errlog_channel = setmetatable({}, {
    __index = {
        pop = function()
            local err = thread.errlog()
            if err then
                return true, err
            else
                return false
            end
        end,
        bpop = function()
            while true do
                local err = thread.errlog()
                if err then
                    return err
                end
                thread.sleep(10)
            end
        end,
    }
})

-- Create a new channel
function thread.newchannel(name)
    if name == 'errlog' then
        return errlog_channel
    end
    if channels[name] then
        error("Channel already exists: " .. name)
    end
    local ch = channel_mod.create(name)
    channels[name] = ch
    -- Add to selector for blocking operations
    selector:event_add(ch:fd(), select_mod.SELECT_READ)
    return ch
end

-- Get an existing channel
function thread.channel(name)
    if name == 'errlog' then
        return errlog_channel
    end
    local ch = channels[name]
    if not ch then
        ch = channel_mod.query(name)
        if ch then
            channels[name] = ch
            selector:event_add(ch:fd(), select_mod.SELECT_READ)
        end
    end
    return ch
end

-- Add blocking pop support to channels
local channel_mt = debug.getregistry()['bee::channel']
if channel_mt and not channel_mt.bpop then
    function channel_mt:bpop()
        while true do
            local results = table.pack(self:pop())
            if results[1] then
                return table.unpack(results, 2, results.n)
            end
            -- Wait for data with a timeout
            selector:wait(100)
        end
    end
end

return thread
