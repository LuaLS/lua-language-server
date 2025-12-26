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
    assert(X:view() == '10')
    assert(X2:view() == '5')
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
    assert(X0:view() == '5 | 10')
    assert(X1:view() == '10')
    assert(X2:view() == '5')
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
    assert(X0:view() == '1')
    assert(X1:view() == '2')
    assert(X2:view() == '3')

    local abc = rt:globalGet('a', 'b', 'c')
    assert(abc:view() == '1 | 2 | 3')
end

do
    TEST_INDEX [[
    local x = 0
    x = x + 1

    W = x
    ]]

    local W = rt:globalGet('W')
    assert(W:view() == 'op.add<0, 1>')
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

    assert(X0:view() == 'integer | nil')
    assert(X1:view() == 'integer')
    assert(X2:view() == 'nil')
    assert(X3:view() == 'integer | nil')
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

    assert(X0:view() == 'integer | nil')
    assert(X1:view() == 'integer')
    assert(X2:view() == 'nil')
    assert(X3:view() == '"string" | integer')
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

    assert(X0:view() == '1 | 2 | 3 | 4')
    assert(X1:view() == '1')
    assert(X2:view() == '2')
    assert(X3:view() == '3 | 4')
    assert(XX:view() == '1 | 2 | 3 | 4')
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

    assert(X0:view() == '1 | 2 | 3 | 4')
    assert(X1:view() == '1')
    assert(X2:view() == '2')
    assert(X3:view() == '3 | 4')
    assert(XX:view() == '1 | 2 | 3 | 4')
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

    assert(X0:view() == '{ a: 1 } | { a: 2 }')
    assert(X1:view() == '{ a: 1 }')
    assert(X2:view() == '{ a: 2 }')
    assert(XX:view() == '{ a: 1 } | { a: 2 }')
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

    assert(X0:view() == 'A | B')
    assert(X1:view() == 'A')
    assert(X2:view() == 'B')
    assert(XX:view() == 'A | B')
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

    assert(X0:view() == '1 | 2 | 3 | 4')
    assert(X1:view() == '2 | 3 | 4')
    assert(X2:view() == '1')
    assert(X3:view() == 'never')
    assert(XX:view() == '1 | 2 | 3 | 4')
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

    assert(X0:view() == '{ a: 1 } | { a: 2 }')
    assert(X1:view() == '{ a: 2 }')
    assert(X2:view() == '{ a: 1 }')
    assert(XX:view() == '{ a: 1 } | { a: 2 }')
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

    assert(X0:view() == 'integer | nil')
    assert(X1:view() == 'nil')
    assert(X2:view() == 'integer')
    assert(X3:view() == 'integer | nil')
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

    assert(X0:view() == '{ a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 1 } | { a: 2, b: 2 }')
    assert(X1:view() == '{ a: 1, b: 2 }')
    assert(X2:view() == '{ a: 1, b: 1 } | { a: 2, b: 1 } | { a: 2, b: 2 }')
    assert(XX:view() == '{ a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 1 } | { a: 2, b: 2 }')
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
    local XX = rt:globalGet('XX')

    assert(X0:view() == '{ a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 1 } | { a: 2, b: 2 }')
    assert(X1:view() == '{ a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 2 }')
    assert(X2:view() == '{ a: 2, b: 1 }')
    assert(XX:view() == '{ a: 1, b: 1 } | { a: 1, b: 2 } | { a: 2, b: 1 } | { a: 2, b: 2 }')
end

do
    TEST_INDEX [[
    X = true and 1
    ]]

    local X = rt:globalGet('X')
    assert(X:view() == '1')
end

do
    TEST_INDEX [[
    X = false and 2
    ]]

    local X = rt:globalGet('X')
    assert(X:view() == 'false')
end

do
    TEST_INDEX [[
    X = true and 1
    ]]

    local X = rt:globalGet('X')
    assert(X:view() == '1')
end

do
    TEST_INDEX [[
    ---@type boolean
    local t

    X = t and 3
    ]]

    local X = rt:globalGet('X')
    assert(X:view() == '3 | false')
end

do
    TEST_INDEX [[
    X = true or 1
    ]]

    local X = rt:globalGet('X')
    assert(X:view() == 'true')
end

do
    TEST_INDEX [[
    X = false or 2
    ]]

    local X = rt:globalGet('X')
    assert(X:view() == '2')
end

do
    TEST_INDEX [[
    ---@type boolean
    local t

    X = t or 3
    ]]

    local X = rt:globalGet('X')
    assert(X:view() == '3 | true')
end

do
    TEST_INDEX [[
    ---@type string?
    local s

    X = s and s or 1
    ]]

    local X = rt:globalGet('X')
    assert(X:view() == '1 | string')
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

    assert(X0:view() == '1 | 2')
    assert(X1:view() == '1')
    assert(X2:view() == '2')
    assert(XX:view() == '1 | 2')
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

    assert(X0:view() == '1 | 2')
    assert(X1:view() == '2')
    assert(X2:view() == '1')
    assert(XX:view() == '1 | 2')
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

    assert(X0:view() == 'any')
    assert(X1:view() == 'string')
    assert(X2:view() == 'number')
    assert(X3:view() == 'boolean | table | function | thread | userdata | nil')
    assert(XX:view() == 'any')
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

    assert(X0:view() == 'string | number | boolean')
    assert(X1:view() == 'string')
    assert(X2:view() == 'number')
    assert(X3:view() == 'boolean')
    assert(XX:view() == 'string | number | boolean')
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

    assert(X:view() == 'any')
    assert(X1:view() == '1')
    assert(X2:view() == '2')
    assert(X3:view() == 'any')
    assert(XX:view() == 'any')
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

    assert(X:view() == 'any')
    assert(X1:view() == 'truly')
    assert(X2:view() == 'false | nil')
    assert(XX:view() == 'any')
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

    assert(X:view() == 'any')
    assert(X1:view() == 'nil')
    assert(X2:view() == 'unknown')
    assert(XX:view() == 'any')
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

    assert(X:view() == '1 | 2 | 3 | 4')
    assert(X1:view() == '1')
    assert(X2:view() == '2')
    assert(X3:view() == '3 | 4')
    assert(XX:view() == '1 | 2 | 3 | 4')
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

    assert(X:view() == 'boolean')
    assert(X1:view() == 'true')
    assert(X2:view() == 'false')
    assert(XX:view() == 'boolean')
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

    assert(X:view() == '{ a: 1 } | { a: 2 }')
    assert(X1:view() == '{ a: 1 }')
    assert(X2:view() == '{ a: 2 }')
    assert(XX:view() == '{ a: 1 } | { a: 2 }')
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

    assert(X0:view() == 'any')
    assert(X1:view() == 'string')
    assert(X2:view() == 'number')
    assert(X3:view() == 'any')
    assert(XX:view() == 'any')
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

    assert(X0:view() == 'any')
    assert(X1:view() == 'string')
    assert(X2:view() == 'number')
    assert(X3:view() == 'any')
    assert(XX:view() == 'any')
end
