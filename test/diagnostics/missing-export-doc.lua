TEST [[
local M = {}

<!function M.f1() end!>

---comment
function M.f2()
end
]]

TEST [[
local M = {}

function M.f1(<!p!>)
end

---@param p integer
function M.f2(p)
end
]]

TEST [[
local M = {}

function M.f1()
    return <!42!>
end

---@return integer
function M.f2()
    return 42
end
]]

TEST [[
local M = {}

M.f1 = <!function() end!>

---comment
M.f1 = function()
end
]]

TEST [[
local M = {}

M.f1 = function(<!p!>)
end

---@param p integer
M.f1 = function(p)
end
]]

TEST [[
local M = {}

M.f1 = function()
    return <!42!>
end

---@return integer
M.f2 = function()
    return 42
end
]]


TEST [[
local M = {}

function <!M:f1!>() end

---comment
function M:f2()
end
]]

TEST [[
local M = {}

function M:f1(<!p!>)
end

---@param p integer
function M:f2(p)
end
]]

TEST [[
local M = {}

function M:f1()
    return <!42!>
end

---@return integer
function M:f2()
    return 42
end
]]
