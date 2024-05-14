---@meta ltask

---@class ltask
local M = {}

---@return string
function M.self() end

---@return string
function M.label() end

function M.pushlog(...) end

function M.pack(...) end

function M.send_message(...) end

---@return ...
function M.message_receipt() end

function M.remove(...) end

---@return ...
function M.unpack_remove(...) end

function M.timer_add(...) end

---@return ...
function M.recv_message() end

---@return ...
function M.poplog() end

function M.eventinit() end

function M.timer_update(message) end

---@param ms integer
function M.timer_sleep(ms) end

return M
