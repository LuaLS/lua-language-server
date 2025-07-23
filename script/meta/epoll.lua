---@meta bee.epoll

---@class bee.epoll
local M = {}

M.EPOLLIN      = 1 << 0
M.EPOLLPRI     = 1 << 1
M.EPOLLOUT     = 1 << 2
M.EPOLLERR     = 1 << 3
M.EPOLLHUP     = 1 << 4
M.EPOLLRDNORM  = 1 << 6
M.EPOLLRDBAND  = 1 << 7
M.EPOLLWRNORM  = 1 << 8
M.EPOLLWRBAND  = 1 << 9
M.EPOLLMSG     = 1 << 10
M.EPOLLRDHUP   = 1 << 13
M.EPOLLONESHOT = 1 << 30

---@param size integer
---@return bee.fd
function M.create(size)
end

---@class bee.fd
local FD = {}

---@param fd bee.fd
---@param id integer
---@param mark? string
function FD:event_add(fd, id, mark)
end

function FD:close()
end

---@param fd bee.fd
---@param id integer
---@param mark? string
function FD:event_mod(fd, id, mark)
end

---@param fd bee.fd
function FD:event_del(fd)
end

---@param timeout? integer
---@return fun(): string, integer
function FD:wait(timeout)
end

return M
