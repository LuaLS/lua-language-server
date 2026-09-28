-- setmetatable 的返回值是否保留字面量字段（字面量直读 vs 经 setmetatable 返回）

local t = setmetatable({ a = 1 }, {})
print(t.a)

local u = { b = 2 }
print(u.b)

return t, u
