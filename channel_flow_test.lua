local channel = require 'bee.channel'
local thread  = require 'bee.thread'
local select  = require 'bee.select'
local time    = require 'bee.time'

-- 极简复现：只保留必要前提与关键路径；所有时间单位为毫秒。

-- 独立测试通道，避免与服务通道冲突
local taskpad = channel.create('test_taskpad_flow')
local waiter  = channel.create('test_waiter_flow')

-- 启动 4 个子线程：阻塞抢任务；其中处理 initial(2) 的线程延迟 100ms 后回复；收到 post 立即回复。
local WORKER_COUNT = 2
local worker_src = [[
local channel = require 'bee.channel'
local select  = require 'bee.select'
local thread  = require 'bee.thread'
local taskpad = channel.query('test_taskpad_flow')
local waiter  = channel.query('test_waiter_flow')
local sel = select.create(); sel:event_add(taskpad:fd(), select.SELECT_READ)
while true do
    local ok, name, id = taskpad:pop()
    if not ok then sel:wait(-1) else
        if name == '__end' then break end
        if name == 'initial' and id == 2 then
            waiter:push(0, 'reply', id)
        elseif name == 'post' then
            waiter:push(0, 'postDone', id)
        end
    end
end
]]
for i = 1, WORKER_COUNT do
    assert(thread.create(worker_src))
end

-- 主线程：推送 2 个 initial 任务
taskpad:push('initial', 2, nil)

-- 等待 reply（阻塞式，毫秒超时步进）
local sel = select.create()
sel:event_add(waiter:fd(), select.SELECT_READ)
while true do
    local ok, _, name = waiter:pop()
    if not ok then
        sel:wait(100)
    else
        if name == 'reply' then
            break
        end
    end
end

-- 立即发送 post 任务，观察是否卡住
print('[INFO] sending post task immediately after reply')
taskpad:push('post', 3, nil)
print('[INFO] sending post task done')
