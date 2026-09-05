local rt = test.scope.rt

-- 函数匹配参数逆变（contravariance）：调用方按目标签名调用源，
-- 源参数须能接收目标参数。即「参数更宽的函数」可赋给「参数更窄的位置」。

do
    -- fun(number) >> fun(integer)：调用方传 integer，number 参数可接收
    local a = rt.func():addParamDef('x', rt.type 'number')
    local b = rt.func():addParamDef('x', rt.type 'integer')
    lt.assertEquals(a >> b, true)
    -- fun(integer) >> fun(number)：调用方传 number，integer 参数不安全
    lt.assertEquals(b >> a, false)
end

do
    -- 不相关参数类型：双向都不匹配
    local a = rt.func():addParamDef('x', rt.type 'number')
    local b = rt.func():addParamDef('x', rt.type 'boolean')
    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end

do
    -- 返回协变（covariance）保持不变：值越具体越能赋给宽松期望
    local b = rt.func():addReturnDef(nil, rt.type 'integer')
    local a = rt.func():addReturnDef(nil, rt.type 'number')
    -- fun():integer 返回 as fun():number
    lt.assertEquals(b >> a, true)
    -- fun():number 返回 as fun():integer 不允许
    lt.assertEquals(a >> b, false)
end

do
    -- 参数逆变 + 返回协变 组合
    local a = rt.func()
        :addParamDef('x', rt.type 'number')
        :addReturnDef(nil, rt.type 'integer')
    local b = rt.func()
        :addParamDef('x', rt.type 'integer')
        :addReturnDef(nil, rt.type 'number')
    -- a: fun(number):integer >> b: fun(integer):number
    lt.assertEquals(a >> b, true)
    -- b: fun(integer):number >> a: fun(number):integer
    lt.assertEquals(b >> a, false)
end

do
    -- rest 目标(`...:any`) 应可接收固定参函数：逆变下应兼容
    local fn = rt.func():addParamDef('m', rt.type 'string')
    local c  = rt.func():addVarargParamDef(rt.type 'any')
    lt.assertEquals(fn >> c, true)
    lt.assertEquals(c >> fn, true)
end
