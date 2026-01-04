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
    lt.assertEquals(X3:view(), '"string" | integer')
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
    a: 2,
    b: 1,
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
    a: 2,
    b: 1,
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
    a: 2,
    b: 1,
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
    a: 2,
    b: 1,
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
        X1 = x --> truly
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
    lt.assertEquals(X1:view(), 'truly')
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

    lt.assertEquals(X0:view(), 'true | false')
    lt.assertEquals(X1:view(), 'true')
    lt.assertEquals(X2:view(), 'false')
    lt.assertEquals(XX:view(), 'true | false')

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
