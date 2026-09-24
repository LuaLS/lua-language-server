local rt = test.scope.rt

do
    TEST_INDEX [[
    local x = 10
    X = x
    x = 5
    X2 = x
    ]]

    local X = rt:globalGet('X')
    local X2 = rt:globalGet('X2')
    lt.assertEquals(X:view(), '10')
    lt.assertEquals(X2:view(), '5')
end

do
    TEST_INDEX [[
    local x
    X0 = x
    x = 10
    X1 = x
    x = 5
    X2 = x
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    lt.assertEquals(X0:view(), '5 | 10')
    lt.assertEquals(X1:view(), '10')
    lt.assertEquals(X2:view(), '5')
end

do
    TEST_INDEX [[
    a.b.c = 1
    X0 = a.b.c
    a.b.c = 2
    X1 = a.b.c
    a.b.c = 3
    X2 = a.b.c
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    lt.assertEquals(X0:view(), '1')
    lt.assertEquals(X1:view(), '2')
    lt.assertEquals(X2:view(), '3')

    local abc = rt:globalGet('a', 'b', 'c')
    lt.assertEquals(abc:view(), '1 | 2 | 3')
end

do
    TEST_INDEX [[
    local x = 0
    x = x + 1

    W = x
    ]]

    local W = rt:globalGet('W')
    lt.assertEquals(W:view(), 'op.add<0, 1>')
end

do
    TEST_INDEX [[
    ---@type integer?
    local x
    X0 = x --> integer | nil

    if x then
        X1 = x --> integer
    else
        X2 = x --> nil
    end

    X3 = x --> integer | nil
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')

    lt.assertEquals(X0:view(), 'integer | nil')
    lt.assertEquals(X1:view(), 'integer')
    lt.assertEquals(X2:view(), 'nil')
    lt.assertEquals(X3:view(), 'integer | nil')
end

do
    TEST_INDEX [[
    ---@type integer?
    local x
    X0 = x --> integer | nil

    if x then
        X1 = x --> integer
    else
        X2 = x --> nil
        x = 'string'
    end

    X3 = x --> integer | 'string'
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')

    lt.assertEquals(X0:view(), 'integer | nil')
    lt.assertEquals(X1:view(), 'integer')
    lt.assertEquals(X2:view(), 'nil')
    lt.assertEquals(X3:view(), [['string' | integer]])
end

do
    TEST_INDEX [[
    ---@type 1 | 2 | 3 | 4
    local x
    X0 = x --> 1 | 2 | 3 | 4

    if x == 1 then
        X1 = x --> 1
    elseif x == 2 then
        X2 = x --> 2
    else
        X3 = x --> 3 | 4
    end

    XX = x --> 1 | 2 | 3 | 4
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), '1 | 2 | 3 | 4')
    lt.assertEquals(X1:view(), '1')
    lt.assertEquals(X2:view(), '2')
    lt.assertEquals(X3:view(), '3 | 4')
    lt.assertEquals(XX:view(), '1 | 2 | 3 | 4')
end

do
    TEST_INDEX [[
    ---@type 1 | 2 | 3 | 4
    local x
    X0 = x --> 1 | 2 | 3 | 4

    if (1 == x) then
        X1 = x --> 1
    elseif (2 == x) then
        X2 = x --> 2
    else
        X3 = x --> 3 | 4
    end

    XX = x --> 1 | 2 | 3 | 4
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), '1 | 2 | 3 | 4')
    lt.assertEquals(X1:view(), '1')
    lt.assertEquals(X2:view(), '2')
    lt.assertEquals(X3:view(), '3 | 4')
    lt.assertEquals(XX:view(), '1 | 2 | 3 | 4')
end

do
    TEST_INDEX [[
    ---@type { a: 1 } | { a: 2 }
    local x
    X0 = x --> { a: 1 } | { a: 2 }

    if x.a == 1 then
        X1 = x --> { a: 1 }
    else
        X2 = x --> { a: 2 }
    end

    XX = x --> { a: 1 } | { a: 2 }
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), '{ a: 1 } | { a: 2 }')
    lt.assertEquals(X1:view(), '{ a: 1 }')
    lt.assertEquals(X2:view(), '{ a: 2 }')
    lt.assertEquals(XX:view(), '{ a: 1 } | { a: 2 }')
end

do
    TEST_INDEX [[
    ---@class A
    ---@field a integer

    ---@class B
    ---@field b integer
    
    ---@type A | B
    local x
    X0 = x --> A | B

    if x.a then
        X1 = x --> A
    else
        X2 = x --> B
    end

    XX = x --> A | B
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), 'A | B')
    lt.assertEquals(X1:view(), 'A')
    lt.assertEquals(X2:view(), 'B')
    lt.assertEquals(XX:view(), 'A | B')
end

do
    TEST_INDEX [[
    ---@type 1 | 2 | 3 | 4
    local x
    X0 = x --> 1 | 2 | 3 | 4

    if (1 ~= x) then
        X1 = x --> 2 | 3 | 4
    elseif (2 ~= x) then
        X2 = x --> 1
    else
        X3 = x --> never
    end

    XX = x --> 1 | 2 | 3 | 4
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), '1 | 2 | 3 | 4')
    lt.assertEquals(X1:view(), '2 | 3 | 4')
    lt.assertEquals(X2:view(), '1')
    lt.assertEquals(X3:view(), 'never')
    lt.assertEquals(XX:view(), '1 | 2 | 3 | 4')
end

do
    TEST_INDEX [[
    ---@type { a: 1 } | { a: 2 }
    local x
    X0 = x --> { a: 1 } | { a: 2 }

    if x.a ~= 1 then
        X1 = x --> { a: 2 }
    else
        X2 = x --> { a: 1 }
    end

    XX = x --> { a: 1 } | { a: 2 }
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), '{ a: 1 } | { a: 2 }')
    lt.assertEquals(X1:view(), '{ a: 2 }')
    lt.assertEquals(X2:view(), '{ a: 1 }')
    lt.assertEquals(XX:view(), '{ a: 1 } | { a: 2 }')
end

do
    TEST_INDEX [[
    ---@type integer?
    local x
    X0 = x --> integer | nil

    if not x then
        X1 = x --> nil
    else
        X2 = x --> integer
    end

    X3 = x --> integer | nil
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')

    lt.assertEquals(X0:view(), 'integer | nil')
    lt.assertEquals(X1:view(), 'nil')
    lt.assertEquals(X2:view(), 'integer')
    lt.assertEquals(X3:view(), 'integer | nil')
end

do
    TEST_INDEX [[
    ---@type { a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 1 } | { a: 2, b: 2 }
    local x
    X0 = x --> { a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 1 } | { a: 2, b: 2 }

    if x.a == 1 and x.b == 2 then
        X1 = x --> { a: 1, b: 2 }
    else
        X2 = x --> { a: 1, b: 1 } | { a: 2, b: 1 } | { a: 2, b: 2 }
    end

    XX = x --> { a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 1 } | { a: 2, b: 2 }
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), [[
{
    a: 1,
    b: 1,
} | {
    a: 1,
    b: 2,
} | {
    b: 1,
    a: 2,
} | {
    a: 2,
    b: 2,
}]])
    lt.assertEquals(X1:view(), [[
{
    a: 1,
    b: 2,
}]])
    lt.assertEquals(X2:view(), [[
{
    a: 1,
    b: 1,
} | {
    b: 1,
    a: 2,
} | {
    a: 2,
    b: 2,
}]])
    lt.assertEquals(XX:view(), [[
{
    a: 1,
    b: 1,
} | {
    a: 1,
    b: 2,
} | {
    b: 1,
    a: 2,
} | {
    a: 2,
    b: 2,
}]])
end

do
    TEST_INDEX [[
    ---@type { a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 1 } | { a: 2, b: 2 }
    local x
    X0 = x --> { a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 1 } | { a: 2, b: 2 }

    if x.a == 1 or x.b == 2 then
        X1 = x --> { a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 2 }
    else
        X2 = x --> { a: 2, b: 1 }
    end

    XX = x --> { a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 1 } | { a: 2, b: 2 }
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    lt.assertEquals(X0:view(), [[
{
    a: 1,
    b: 1,
} | {
    a: 1,
    b: 2,
} | {
    b: 1,
    a: 2,
} | {
    a: 2,
    b: 2,
}]])
end

do
    TEST_INDEX [[
    X = true and 1
    ]]

    local X = rt:globalGet('X')
    lt.assertEquals(X:view(), '1')
end

do
    TEST_INDEX [[
    X = false and 2
    ]]

    local X = rt:globalGet('X')
    lt.assertEquals(X:view(), 'false')
end

do
    TEST_INDEX [[
    X = true and 1
    ]]

    local X = rt:globalGet('X')
    lt.assertEquals(X:view(), '1')
end

do
    TEST_INDEX [[
    ---@type boolean
    local t

    X = t and 3
    ]]

    local X = rt:globalGet('X')
    lt.assertEquals(X:view(), '3 | false')
end

do
    TEST_INDEX [[
    X = true or 1
    ]]

    local X = rt:globalGet('X')
    lt.assertEquals(X:view(), 'true')
end

do
    TEST_INDEX [[
    X = false or 2
    ]]

    local X = rt:globalGet('X')
    lt.assertEquals(X:view(), '2')
end

do
    TEST_INDEX [[
    ---@type boolean
    local t

    X = t or 3
    ]]

    local X = rt:globalGet('X')
    lt.assertEquals(X:view(), '3 | true')
end

do
    TEST_INDEX [[
    ---@type string?
    local s

    X = s and s or 1
    ]]

    local X = rt:globalGet('X')
    lt.assertEquals(X:view(), '1 | string')
end

do
    TEST_INDEX [[
    ---@type 1 | 2
    local x
    X0 = x --> 1 | 2

    ---@type (fun(x: 1): true) | (fun(x: 2): false)
    local f

    if f(x) then
        X1 = x --> 1
    else
        X2 = x --> 2
    end

    XX = x --> 1 | 2
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), '1 | 2')
    lt.assertEquals(X1:view(), '1')
    lt.assertEquals(X2:view(), '2')
    lt.assertEquals(XX:view(), '1 | 2')
end

do
    TEST_INDEX [[
    ---@type 1 | 2
    local x
    X0 = x --> 1 | 2

    ---@type (fun(x: 1): true) | (fun(x: 2): false)
    local f

    if f(x) == false then
        X1 = x --> 2
    else
        X2 = x --> 1
    end

    XX = x --> 1 | 2
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), '1 | 2')
    lt.assertEquals(X1:view(), '2')
    lt.assertEquals(X2:view(), '1')
    lt.assertEquals(XX:view(), '1 | 2')
end

do
    local _ <close> = TEST_INDEX [[
    --!include type

    local x
    X0 = x --> any
    if type(x) == 'string' then
        X1 = x --> string
    elseif type(x) == 'number' then
        X2 = x --> number
    else
        X3 = x --> boolean | table | userdata | function | thread | nil
    end

    XX = x --> any
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), 'any')
    lt.assertEquals(X1:view(), 'string')
    lt.assertEquals(X2:view(), 'number')
    lt.assertEquals(X3:view(), 'boolean | table | function | thread | userdata | nil')
    lt.assertEquals(XX:view(), 'any')
end

do
    local _ <close> = TEST_INDEX [[
    --!include type

    ---@type string | number | boolean
    local x
    X0 = x --> string | number | boolean
    if type(x) == 'string' then
        X1 = x --> string
    elseif type(x) == 'number' then
        X2 = x --> number
    else
        X3 = x --> boolean
    end

    XX = x --> string | number | boolean
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), 'string | number | boolean')
    lt.assertEquals(X1:view(), 'string')
    lt.assertEquals(X2:view(), 'number')
    lt.assertEquals(X3:view(), 'boolean')
    lt.assertEquals(XX:view(), 'string | number | boolean')
end

do
    TEST_INDEX [[
    ---@type fun<T>(x: T): T
    local f

    local x
    X = x --> any
    
    if f(x) == 1 then
        X1 = x --> 1
    elseif f(x) == 2 then
        X2 = x --> 2
    else
        X3 = x --> any
    end

    XX = x --> any
    ]]

    local X = rt:globalGet('X')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X:view(), 'any')
    lt.assertEquals(X1:view(), '1')
    lt.assertEquals(X2:view(), '2')
    lt.assertEquals(X3:view(), 'any')
    lt.assertEquals(XX:view(), 'any')
end

do
    TEST_INDEX [[
    ---@type fun<T>(x: T): T
    local f

    local x
    X = x --> any
    
    if f(x) then
        X1 = x --> truthy
    else
        X2 = x --> false | nil
    end

    XX = x --> any
    ]]

    local X = rt:globalGet('X')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X:view(), 'any')
    lt.assertEquals(X1:view(), 'truthy')
    lt.assertEquals(X2:view(), 'false | nil')
    lt.assertEquals(XX:view(), 'any')
end

do
    TEST_INDEX [[
    local x
    X = x --> any
    
    if x == nil then
        X1 = x --> nil
    else
        X2 = x --> unknown
    end

    XX = x --> any
    ]]

    local X = rt:globalGet('X')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X:view(), 'any')
    lt.assertEquals(X1:view(), 'nil')
    lt.assertEquals(X2:view(), 'unknown')
    lt.assertEquals(XX:view(), 'any')
end

do
    TEST_INDEX [[
    ---@type fun<T>(x: T): T
    local f

    ---@type 1 | 2 | 3 | 4
    local x
    X = x --> 1 | 2 | 3 | 4
    
    if f(x) == 1 then
        X1 = x --> 1
    elseif f(x) == 2 then
        X2 = x --> 2
    else
        X3 = x --> 3 | 4
    end

    XX = x --> 1 | 2 | 3 | 4
    ]]

    local X = rt:globalGet('X')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X:view(), '1 | 2 | 3 | 4')
    lt.assertEquals(X1:view(), '1')
    lt.assertEquals(X2:view(), '2')
    lt.assertEquals(X3:view(), '3 | 4')
    lt.assertEquals(XX:view(), '1 | 2 | 3 | 4')
end

do
    TEST_INDEX [[
    ---@type fun<T>(x: T): T
    local f

    ---@type boolean
    local x
    X = x --> boolean
    
    if f(x) then
        X1 = x --> true
    else
        X2 = x --> false
    end

    XX = x --> boolean
    ]]

    local X = rt:globalGet('X')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X:view(), 'boolean')
    lt.assertEquals(X1:view(), 'true')
    lt.assertEquals(X2:view(), 'false')
    lt.assertEquals(XX:view(), 'boolean')
end

do
    TEST_INDEX [[
    ---@type fun<T>(x: T): T
    local f

    ---@type { a: 1 } | { a: 2 }
    local x
    X = x --> { a: 1 } | { a: 2 }
    
    if f(x.a) == 1 then
        X1 = x --> { a: 1 }
    else
        X2 = x --> { a: 2 }
    end

    XX = x --> { a: 1 } | { a: 2 }
    ]]

    local X = rt:globalGet('X')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X:view(), '{ a: 1 } | { a: 2 }')
    lt.assertEquals(X1:view(), '{ a: 1 }')
    lt.assertEquals(X2:view(), '{ a: 2 }')
    lt.assertEquals(XX:view(), '{ a: 1 } | { a: 2 }')
end

do
    local _ <close> = TEST_INDEX [[
    --!include type2

    local x
    X0 = x --> any
    if type(x) == 'string' then
        X1 = x --> string
    elseif type(x) == 'number' then
        X2 = x --> number
    else
        X3 = x --> any
    end

    XX = x --> any
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), 'any')
    lt.assertEquals(X1:view(), 'string')
    lt.assertEquals(X2:view(), 'number')
    lt.assertEquals(X3:view(), 'any')
    lt.assertEquals(XX:view(), 'any')
end

do
    local _ <close> = TEST_INDEX [[
    --!include type3

    local x
    X0 = x --> any
    if type(x) == 'string' then
        X1 = x --> string
    elseif type(x) == 'number' then
        X2 = x --> number
    else
        X3 = x --> any
    end

    XX = x --> any
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), 'any')
    lt.assertEquals(X1:view(), 'string')
    lt.assertEquals(X2:view(), 'number')
    lt.assertEquals(X3:view(), 'any')
    lt.assertEquals(XX:view(), 'any')
end

do
    local _ <close> = TEST_INDEX [[
    --!include type3

    local x
    X0 = x --> any

    local tp, _ = type(x)
    if tp == 'string' then
        X1 = x --> string
    elseif tp == 'number' then
        X2 = x --> number
    else
        X3 = x --> any
    end

    XX = x --> any
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), 'any')
    lt.assertEquals(X1:view(), 'string')
    lt.assertEquals(X2:view(), 'number')
    lt.assertEquals(X3:view(), 'any')
    lt.assertEquals(XX:view(), 'any')
end

do
    local _ <close> = TEST_INDEX [[
    --!include type3

    local x
    X0 = x --> any

    local tp, _ = type(x)
    if tp == 'string' then
        X1 = x --> string
    elseif tp == 'number' then
        X2 = x --> number
    else
        X3 = x --> any
    end

    XX = x --> any
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local XX = rt:globalGet('XX')

    lt.assertEquals(X0:view(), 'any')
    lt.assertEquals(X1:view(), 'string')
    lt.assertEquals(X2:view(), 'number')
    lt.assertEquals(X3:view(), 'any')
    lt.assertEquals(XX:view(), 'any')
end

do
    TEST_INDEX [[
    ---@overload fun(): true
    ---@overload fun(): false, string
    local function f() end

    local ok, err = f()
    X0 = ok --> true | false
    Y0 = err --> string | nil

    if ok then
        X1 = ok --> true
        Y1 = err --> nil
    else
        X2 = ok --> false
        Y2 = err --> string
    end

    XX = ok --> true | false
    YY = err --> string | nil
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local XX = rt:globalGet('XX')
    local Y0 = rt:globalGet('Y0')
    local Y1 = rt:globalGet('Y1')
    local Y2 = rt:globalGet('Y2')
    local YY = rt:globalGet('YY')

    lt.assertEquals(X0:view(), 'boolean')
    lt.assertEquals(X1:view(), 'true')
    lt.assertEquals(X2:view(), 'false')
    lt.assertEquals(XX:view(), 'boolean')

    lt.assertEquals(Y0:view(), 'string | nil')
    lt.assertEquals(Y1:view(), 'nil')
    lt.assertEquals(Y2:view(), 'string')
    lt.assertEquals(YY:view(), 'string | nil')
end

do
    TEST_INDEX [[
    x = 1

    X1 = x
    ---@alias X1 $X1

    local _ENV = { x = 2 }
    
    X2 = x

    ---@alias X2 $X2
    ]]

    lt.assertEquals(rt.type('X1').value:view(), '1')
    lt.assertEquals(rt.type('X2').value:view(), '2')
end

do
    TEST_INDEX [[
    local x

    local a, b = call(x.t)

    if a then
    end

    if b then
    end
    ]]
end

do
    local _ <close> = TEST_INDEX [[
    --!include assert

    ---@type string?
    local v

    assert(v)

    A1 = v
    ]]

    local A1 = rt:globalGet('A1')
    lt.assertEquals(A1.value:view(), 'string')
end

do
    TEST_INDEX [[
    ---@param s string
    ---@param n number
    ---@param b string
    ---@param w any
    ---@param u unknown
    local function eqProbe(s, n, b, w, u)
        if s == w then
            X1 = s --> string
        else
            X2 = s --> string
        end

        if s == u then
            X3 = s --> string
        else
            X4 = s --> string
        end

        if s == n then
            X5 = s --> string
        else
            X6 = s --> string
        end

        if s == b then
            X7 = s --> string
        else
            X8 = s --> string
        end

        if s == nil then
            X9 = s --> never
        else
            X10 = s --> string
        end
    end
    ]]

    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local X4 = rt:globalGet('X4')
    local X5 = rt:globalGet('X5')
    local X6 = rt:globalGet('X6')
    local X7 = rt:globalGet('X7')
    local X8 = rt:globalGet('X8')
    local X9 = rt:globalGet('X9')
    local X10 = rt:globalGet('X10')

    -- 与多值类型（any / unknown / 另一个同类型变量）比较时得不到信息：两支都保持原类型
    lt.assertEquals(X1:view(), 'string')
    lt.assertEquals(X2:view(), 'string')
    lt.assertEquals(X3:view(), 'string')
    lt.assertEquals(X4:view(), 'string')
    lt.assertEquals(X5:view(), 'string')
    lt.assertEquals(X6:view(), 'string')
    lt.assertEquals(X7:view(), 'string')
    lt.assertEquals(X8:view(), 'string')

    -- 单值（nil）比较仍按判等收窄
    lt.assertEquals(X9:view(), 'never')
    lt.assertEquals(X10:view(), 'string')
end

do
    TEST_INDEX [[
    ---@class parser.object
    ---@field [integer] parser.object | any
    ---@field enum parser.object

    ---@type parser.object
    local doc

    ---@param word any
    local function f(word)
        if not (doc.enum[1] == word or doc.enum[1]:match('x') == word) then
            X1 = doc --> parser.object
        end
        X2 = doc --> parser.object
        X3 = doc.enum[1] --> parser.object | any
    end
    ]]

    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')

    -- `字段 == any` 不应把基变量或字段读值算成 never（目标工程 auto-require.lua:106 一族）
    lt.assertEquals(X1:view(), 'parser.object')
    lt.assertEquals(X2:view(), 'parser.object')
    lt.assertEquals(X3:view(), 'parser.object | any')
end

do
    TEST_INDEX [[
    ---@type { type: string }
    local t

    if t.type == 'x' then
        X1 = t --> { type: string }
    end
    ]]

    local X1 = rt:globalGet('X1')

    -- 字段声明类型（string）比比较值（'x'）宽时，字段可能相等：相等一侧的基值不能被算成 never
    lt.assertEquals(X1:view(), '{ type: string }')
end

do
    TEST_INDEX [[
    ---@type integer[]
    local arr

    ---@type (integer?)[]
    local optArr

    ---@class State
    ---@field lines integer[]

    ---@return State?
    local function getState() end

    ---@param i integer
    local function tmpIndexProbe(i)
        X1 = arr[i]
        X2 = arr[1]
        X3 = optArr[i]

        local state = getState()
        if not state then
            return
        end
        local lines = state.lines
        X4 = lines[i]
    end
    ]]

    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')
    local X4 = rt:globalGet('X4')

    -- 非字面量键读取（`t[expr]`）按基值求值：`T[]` 取 T，`T?[]` 才带 nil
    lt.assertEquals(X1:view(), 'integer')
    lt.assertEquals(X2:view(), 'integer')
    lt.assertEquals(X3:view(), 'integer | nil')
    lt.assertEquals(X4:view(), 'integer')
end

do
    TEST_INDEX [[
    local T = {}

    ---@param x integer
    ---@param y integer
    local function tmpDynamicKeyProbe(x, y)
        T[x] = 1
        X1 = T[y]
    end
    ]]

    local X1 = rt:globalGet('X1')

    -- 动态键写入只把表标记成开放结构，写入值不扩散给其它动态键读取
    lt.assertEquals(X1:view(), 'any')
end

do
    TEST_INDEX [[
    ---@type integer[]
    local arr

    ---@param i integer
    local function tmpDynReadProbe(i)
        if arr[i] then
            X1 = arr[i]
        end
        X2 = arr[i]
    end
    ]]

    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')

    -- 动态键读取的读值不受共用槽位污染（条件分支里的真值收窄不再泄漏成 truthy）
    lt.assertEquals(X1:view(), 'integer')
    lt.assertEquals(X2:view(), 'integer')
end

do
    TEST_INDEX [[
    ---@param a integer
    ---@param s string
    local function tmpOpProbe(a, s)
        local n1 = a + 1
        local n2 = a // 2
        local n3 = #s // 2
        local t = { line = a, character = n3 }
        X1, X2, X3, XT = n1, n2, n3, t
    end
    ]]

    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    local X3 = rt:globalGet('X3')

    -- 未折叠的运算结果（op.*）仍可当作 integer/number 使用
    lt.assertEquals(X1:view(), 'op.add<integer, 1>')
    lt.assertEquals(X1:canCast(rt.INTEGER), true)
    lt.assertEquals(X2:canCast(rt.NUMBER), true)
    lt.assertEquals(X3:view(), 'op.idiv<op.len<string>, 2>')
    lt.assertEquals(X3:canCast(rt.INTEGER), true)
end
