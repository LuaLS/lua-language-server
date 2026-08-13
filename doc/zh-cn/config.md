# addonManager.enable

是否启用扩展的附加插件管理器(Addon Manager)

## type

```ts
boolean
```

## default

```jsonc
true
```

# addonManager.repositoryBranch

指定插件管理器(Addon Manager)使用的git仓库分支

## type

```ts
string
```

## default

```jsonc
""
```

# addonManager.repositoryPath

指定插件管理器(Addon Manager)使用的git仓库路径

## type

```ts
string
```

## default

```jsonc
""
```

# addonRepositoryPath

指定插件仓库的路径（与 Addon Manager 无关）

## type

```ts
string
```

## default

```jsonc
""
```

# codeLens.enable

启用代码度量。

## type

```ts
boolean
```

## default

```jsonc
false
```

# completion.autoRequire

输入内容看起来是个文件名时，自动 `require` 此文件。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.callSnippet

显示函数调用片段。

## type

```ts
string
```

## enum

* ``"Disable"``: 只显示 `函数名`。
* ``"Both"``: 显示 `函数名` 与 `调用片段`。
* ``"Replace"``: 只显示 `调用片段`。

## default

```jsonc
"Disable"
```

# completion.displayContext

预览建议的相关代码片段，可能可以帮助你了解这项建议的用法。设置的数字表示代码片段的截取行数，设置为`0`可以禁用此功能。

## type

```ts
integer
```

## default

```jsonc
0
```

# completion.enable

启用自动完成。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.keywordSnippet

显示关键字语法片段

## type

```ts
string
```

## enum

* ``"Disable"``: 只显示 `关键字`。
* ``"Both"``: 显示 `关键字` 与 `语法片段`。
* ``"Replace"``: 只显示 `语法片段`。

## default

```jsonc
"Replace"
```

# completion.maxSuggestCount

自动完成时最多分析的字段数量。当对象字段超过此上限时，需要更精确的输入才会显示补全。

## type

```ts
integer
```

## default

```jsonc
100
```

# completion.postfix

用于触发后缀建议的符号。

## type

```ts
string
```

## default

```jsonc
"@"
```

# completion.requireSeparator

`require` 时使用的分隔符。

## type

```ts
string
```

## default

```jsonc
"."
```

# completion.showParams

在建议列表中显示函数的参数信息，函数拥有多个定义时会分开显示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# completion.showWord

在建议中显示上下文单词。

## type

```ts
string
```

## enum

* ``"Enable"``: 总是在建议中显示上下文单词。
* ``"Fallback"``: 无法根据语义提供建议时才显示上下文单词。
* ``"Disable"``: 不显示上下文单词。

## default

```jsonc
"Fallback"
```

# completion.workspaceWord

显示的上下文单词是否包含工作区中其他文件的内容。

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.disable

禁用的诊断（使用浮框括号内的代码）。

## type

```ts
Array<string>
```

## enum

* ``"action-after-return"``: `return` 语句之后的代码
* ``"ambiguity-1"``: 优先级歧义，如：`num or 0 + 1`，推测用户的实际期望为 `(num or 0) + 1` 
* ``"ambiguous-syntax"``: 存在歧义的语法
* ``"args-after-dots"``: `...` 之后的参数
* ``"assign-const-global"``: 给 const 全局变量赋值
* ``"assign-type-mismatch"``: 值类型与赋值变量类型不匹配
* ``"await-in-sync"``: 同步函数中异步函数调用
* ``"block-after-else"``: `else` 之后的代码块
* ``"break-outside"``: 在循环外使用 `break`
* ``"cast-local-type"``: 已显式定义变量类型与要定义的值的类型不匹配
* ``"cast-type-mismatch"``: 变量被转换为与其初始类型不匹配的类型
* ``"circle-doc-class"``: `@class` 继承出现循环
* ``"close-non-object"``: 尝试关闭非对象变量的诊断
* ``"code-after-break"``: 放在循环中break语句后面的代码
* ``"codestyle-check"``: 启用对不正确样式行的诊断
* ``"count-down-loop"``: for循环永远无法达到最大/极限值(在递减时递增)
* ``"declare-const"``: 重复声明 const 常量
* ``"deprecated"``: 变量已被标记为deprecated(过时)但仍在使用
* ``"different-requires"``: required的同一个文件使用了两个不同的名字
* ``"discard-returns"``: 函数的返回值被忽略(函数被`@nodiscard`标记时)
* ``"doc-field-no-class"``: 为不存在的类`@class`标记`@field`字段
* ``"duplicate-doc-alias"``: `@alias`字段的名字冲突
* ``"duplicate-doc-field"``: `@field`字段的名字冲突
* ``"duplicate-doc-param"``: `@param`字段的名字冲突
* ``"duplicate-index"``: 在字面量表中重复定义了索引
* ``"duplicate-set-field"``: 在一个类中多次定义同一字段
* ``"empty-block"``: 空代码块
* ``"env-is-global"``: `_ENV` 作为全局变量使用
* ``"err-assign-as-eq"``
* ``"err-c-long-comment"``
* ``"err-comment-prefix"``
* ``"err-do-as-then"``
* ``"err-eq-as-assign"``
* ``"err-esc"``
* ``"err-nonstandard-symbol"``
* ``"err-then-as-do"``
* ``"exp-in-action"``: 表达式出现在语句位置
* ``"global-close-attribute"``: 全局变量使用 close 属性
* ``"global-element"``: 启用诊断以警告全局元素。
* ``"global-in-nil-env"``: 不能使用全局变量（ `_ENV` 被设置为了 `nil`）
* ``"incomplete-signature-doc"``: `@param`或`@return`的注释不完整
* ``"index-in-func-name"``: 函数名中包含索引
* ``"inject-field"``: 向对象注入字段
* ``"invisible"``: 使用不可见的值
* ``"jump-local-scope"``: 跳入局部变量作用域
* ``"keyword"``: 关键字使用不当
* ``"local-limit"``: 局部变量数量超过限制
* ``"lowercase-global"``: 首字母小写的全局变量定义
* ``"lua-doc-miss-sign"``: LuaDoc 注释缺少符号
* ``"luadoc-error-diag-mode"``
* ``"luadoc-miss-alias-extends"``
* ``"luadoc-miss-alias-name"``
* ``"luadoc-miss-arg-name"``
* ``"luadoc-miss-cate-name"``
* ``"luadoc-miss-class-extends-name"``
* ``"luadoc-miss-class-name"``
* ``"luadoc-miss-diag-mode"``
* ``"luadoc-miss-diag-name"``
* ``"luadoc-miss-field-extends"``
* ``"luadoc-miss-field-name"``
* ``"luadoc-miss-fun-after-overload"``
* ``"luadoc-miss-generic-name"``
* ``"luadoc-miss-local-name"``
* ``"luadoc-miss-module-name"``
* ``"luadoc-miss-operator-name"``
* ``"luadoc-miss-param-extends"``
* ``"luadoc-miss-param-name"``
* ``"luadoc-miss-see-name"``
* ``"luadoc-miss-sign-name"``
* ``"luadoc-miss-symbol"``
* ``"luadoc-miss-type-name"``
* ``"luadoc-miss-vararg-type"``
* ``"luadoc-miss-version"``
* ``"malformed-number"``: 格式错误的数字字面量
* ``"miss-end"``
* ``"miss-esc-x"``
* ``"miss-exp"``
* ``"miss-exponent"``
* ``"miss-field"``
* ``"miss-loop-max"``
* ``"miss-loop-min"``
* ``"miss-method"``
* ``"miss-name"``
* ``"miss-sep-in-table"``
* ``"miss-space-between"``
* ``"miss-symbol"``
* ``"missing-fields"``: 缺少字段
* ``"missing-global-doc"``: 全局变量的注释缺失(全局函数必须为所有参数和返回值提供注释和注释)
* ``"missing-local-export-doc"``: 导出的本地函数缺少注释(导出的本地函数必须有包括本身以及所有参数和返回值的注释)
* ``"missing-parameter"``: 函数参数数少于注释函数参数数
* ``"missing-return"``: 函数带有返回注释而无返回语句
* ``"missing-return-value"``: 函数无值返回但函数使用`@return`标记了返回值
* ``"multi-close"``: 多重 close 操作
* ``"name-style-check"``: 变量的名称样式检查
* ``"need-check-nil"``: 变量之前被赋值为`nil`或可选值(可能为 `nil`)
* ``"need-paren"``: 需要括号
* ``"nesting-long-mark"``: 嵌套的长注释标记
* ``"newfield-call"``: 在字面量表中，2行代码之间缺少分隔符，在语法上被解析为了一次索引操作
* ``"newline-call"``: 以 `(` 开始的新行，在语法上被解析为了上一行的函数调用
* ``"no-unknown"``: 变量的未知类型无法推断
* ``"no-visible-label"``: 不可见的标签
* ``"not-yieldable"``: 不允许调用 `coroutine.yield()` 
* ``"param-type-mismatch"``: 给定参数的类型与函数定义所要求的类型(`@param`)不匹配
* ``"redefined-label"``: 重复定义的标签
* ``"redefined-local"``: 重复定义的局部变量
* ``"redundant-parameter"``: 函数调用时，传入了多余的参数
* ``"redundant-return"``: 当放置一个不需要的返回值时触发(函数会自行退出)
* ``"redundant-return-value"``: 返回`@return`注释未指定的额外值
* ``"redundant-value"``: 赋值操作时，值的数量比被赋值的对象多
* ``"return-type-mismatch"``: 返回值的类型与`@return`中声明的类型不匹配
* ``"set-const"``: 给 const 常量赋值
* ``"spell-check"``: 启用字符串拼写检查的诊断。
* ``"trailing-space"``: 后置空格
* ``"unbalanced-assignments"``: 多重赋值时没有赋值所有变量(如`local x,y = 1`)
* ``"undefined-doc-class"``: 在`@class`注解中引用未定义的类。
* ``"undefined-doc-name"``: 在`@type`注解中引用未定义的类型或`@alias`
* ``"undefined-doc-param"``: 函数声明中`@param`引用了未定义的参数
* ``"undefined-env-child"``: `_ENV` 被设置为了新的字面量表，但是试图获取的全局变量不再这张表中
* ``"undefined-field"``: 引用变量的未定义字段
* ``"undefined-global"``: 未定义的全局变量
* ``"unexpect-dots"``
* ``"unexpect-efunc-name"``
* ``"unexpect-gfunc-name"``
* ``"unexpect-lfunc-name"``
* ``"unexpect-symbol"``
* ``"unicode-name"``: Unicode 名称使用
* ``"unknown-attribute"``: 未知的属性
* ``"unknown-cast-variable"``: 使用`@cast`对未定义变量的强制转换
* ``"unknown-diag-code"``: 未知的诊断代码
* ``"unknown-operator"``: 未知的运算符
* ``"unknown-symbol"``: 未知的符号
* ``"unreachable-code"``: 不可达的代码
* ``"unsupport-named-vararg"``: 不支持的命名变参
* ``"unsupport-symbol"``
* ``"unused-function"``: 未使用的函数
* ``"unused-label"``: 未使用的标签
* ``"unused-local"``: 未使用的局部变量
* ``"unused-vararg"``: 未使用的不定参数
* ``"variable-not-declared"``: 使用未声明的变量

## default

```jsonc
[]
```

# diagnostics.enable

启用诊断。

## type

```ts
boolean
```

## default

```jsonc
true
```

# diagnostics.enableScheme

**Missing description!!**

## type

```ts
Array<string>
```

## default

```jsonc
["file"]
```

# diagnostics.globals

已定义的全局变量。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.globalsRegex

已定义的全局变量符合的正则表达式。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.groupFileStatus

批量修改一个组中的文件状态。

* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* None:    禁用此诊断

设置为 `Fallback` 意味着组中的诊断由 `diagnostics.neededFileStatus` 单独设置。
其他设置将覆盖单独设置，但是不会覆盖以 `!` 结尾的设置。


## type

```ts
object<string, string>
```

## enum

* ``"Any"``
* ``"Opened"``
* ``"None"``
* ``"Fallback"``

## default

```jsonc
{
    /*
    * ambiguity-1
    * count-down-loop
    * different-requires
    * newfield-call
    * newline-call
    */
    "ambiguity": "Fallback",
    /*
    * await-in-sync
    * not-yieldable
    */
    "await": "Fallback",
    /*
    * codestyle-check
    * name-style-check
    * spell-check
    */
    "codestyle": "Fallback",
    /*
    * global-element
    */
    "conventions": "Fallback",
    /*
    * duplicate-index
    * duplicate-set-field
    */
    "duplicate": "Fallback",
    /*
    * global-in-nil-env
    * lowercase-global
    * undefined-env-child
    * undefined-global
    */
    "global": "Fallback",
    /*
    * circle-doc-class
    * doc-field-no-class
    * duplicate-doc-alias
    * duplicate-doc-field
    * duplicate-doc-param
    * incomplete-signature-doc
    * missing-global-doc
    * missing-local-export-doc
    * undefined-doc-class
    * undefined-doc-name
    * undefined-doc-param
    * unknown-cast-variable
    * unknown-diag-code
    * unknown-operator
    */
    "luadoc": "Fallback",
    /*
    * redefined-local
    */
    "redefined": "Fallback",
    /*
    * close-non-object
    * deprecated
    * discard-returns
    * invisible
    */
    "strict": "Fallback",
    /*
    * no-unknown
    */
    "strong": "Fallback",
    /*
    * assign-type-mismatch
    * cast-local-type
    * cast-type-mismatch
    * inject-field
    * need-check-nil
    * param-type-mismatch
    * return-type-mismatch
    * undefined-field
    */
    "type-check": "Fallback",
    /*
    * missing-fields
    * missing-parameter
    * missing-return
    * missing-return-value
    * redundant-parameter
    * redundant-return-value
    * redundant-value
    * unbalanced-assignments
    */
    "unbalanced": "Fallback",
    /*
    * code-after-break
    * empty-block
    * redundant-return
    * trailing-space
    * unreachable-code
    * unused-function
    * unused-label
    * unused-local
    * unused-vararg
    */
    "unused": "Fallback"
}
```

# diagnostics.groupSeverity

批量修改一个组中的诊断等级。
设置为 `Fallback` 意味着组中的诊断由 `diagnostics.severity` 单独设置。
其他设置将覆盖单独设置，但是不会覆盖以 `!` 结尾的设置。


## type

```ts
object<string, string>
```

## enum

* ``"Error"``
* ``"Warning"``
* ``"Information"``
* ``"Hint"``
* ``"Fallback"``

## default

```jsonc
{
    /*
    * ambiguity-1
    * count-down-loop
    * different-requires
    * newfield-call
    * newline-call
    */
    "ambiguity": "Fallback",
    /*
    * await-in-sync
    * not-yieldable
    */
    "await": "Fallback",
    /*
    * codestyle-check
    * name-style-check
    * spell-check
    */
    "codestyle": "Fallback",
    /*
    * global-element
    */
    "conventions": "Fallback",
    /*
    * duplicate-index
    * duplicate-set-field
    */
    "duplicate": "Fallback",
    /*
    * global-in-nil-env
    * lowercase-global
    * undefined-env-child
    * undefined-global
    */
    "global": "Fallback",
    /*
    * circle-doc-class
    * doc-field-no-class
    * duplicate-doc-alias
    * duplicate-doc-field
    * duplicate-doc-param
    * incomplete-signature-doc
    * missing-global-doc
    * missing-local-export-doc
    * undefined-doc-class
    * undefined-doc-name
    * undefined-doc-param
    * unknown-cast-variable
    * unknown-diag-code
    * unknown-operator
    */
    "luadoc": "Fallback",
    /*
    * redefined-local
    */
    "redefined": "Fallback",
    /*
    * close-non-object
    * deprecated
    * discard-returns
    * invisible
    */
    "strict": "Fallback",
    /*
    * no-unknown
    */
    "strong": "Fallback",
    /*
    * assign-type-mismatch
    * cast-local-type
    * cast-type-mismatch
    * inject-field
    * need-check-nil
    * param-type-mismatch
    * return-type-mismatch
    * undefined-field
    */
    "type-check": "Fallback",
    /*
    * missing-fields
    * missing-parameter
    * missing-return
    * missing-return-value
    * redundant-parameter
    * redundant-return-value
    * redundant-value
    * unbalanced-assignments
    */
    "unbalanced": "Fallback",
    /*
    * code-after-break
    * empty-block
    * redundant-return
    * trailing-space
    * unreachable-code
    * unused-function
    * unused-label
    * unused-local
    * unused-vararg
    */
    "unused": "Fallback"
}
```

# diagnostics.ignoredFiles

如何诊断被忽略的文件。

## type

```ts
string
```

## enum

* ``"Enable"``: 总是诊断这些文件。
* ``"Opened"``: 只有打开这些文件时才会诊断。
* ``"Disable"``: 不诊断这些文件。

## default

```jsonc
"Opened"
```

# diagnostics.libraryFiles

如何诊断通过 `Lua.workspace.library` 加载的文件。

## type

```ts
string
```

## enum

* ``"Enable"``: 总是诊断这些文件。
* ``"Opened"``: 只有打开这些文件时才会诊断。
* ``"Disable"``: 不诊断这些文件。

## default

```jsonc
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  只诊断打开的文件
* Any:     诊断任何文件
* None:    禁用此诊断

以 `!` 结尾的设置优先级高于组设置 `diagnostics.groupFileStatus`。


## type

```ts
object<string, string>
```

## enum

* ``"Any"``
* ``"Opened"``
* ``"None"``
* ``"Any!"``
* ``"Opened!"``
* ``"None!"``

## default

```jsonc
{
    /*
    优先级歧义，如：`num or 0 + 1`，推测用户的实际期望为 `(num or 0) + 1` 
    */
    "ambiguity-1": "Any",
    /*
    值类型与赋值变量类型不匹配
    */
    "assign-type-mismatch": "Opened",
    /*
    同步函数中异步函数调用
    */
    "await-in-sync": "None",
    /*
    已显式定义变量类型与要定义的值的类型不匹配
    */
    "cast-local-type": "Opened",
    /*
    变量被转换为与其初始类型不匹配的类型
    */
    "cast-type-mismatch": "Opened",
    /*
    `@class` 继承出现循环
    */
    "circle-doc-class": "Any",
    /*
    尝试关闭非对象变量的诊断
    */
    "close-non-object": "Any",
    /*
    放在循环中break语句后面的代码
    */
    "code-after-break": "Opened",
    /*
    启用对不正确样式行的诊断
    */
    "codestyle-check": "None",
    /*
    for循环永远无法达到最大/极限值(在递减时递增)
    */
    "count-down-loop": "Any",
    /*
    变量已被标记为deprecated(过时)但仍在使用
    */
    "deprecated": "Any",
    /*
    required的同一个文件使用了两个不同的名字
    */
    "different-requires": "Any",
    /*
    函数的返回值被忽略(函数被`@nodiscard`标记时)
    */
    "discard-returns": "Any",
    /*
    为不存在的类`@class`标记`@field`字段
    */
    "doc-field-no-class": "Any",
    /*
    `@alias`字段的名字冲突
    */
    "duplicate-doc-alias": "Any",
    /*
    `@field`字段的名字冲突
    */
    "duplicate-doc-field": "Any",
    /*
    `@param`字段的名字冲突
    */
    "duplicate-doc-param": "Any",
    /*
    在字面量表中重复定义了索引
    */
    "duplicate-index": "Any",
    /*
    在一个类中多次定义同一字段
    */
    "duplicate-set-field": "Opened",
    /*
    空代码块
    */
    "empty-block": "Opened",
    /*
    启用诊断以警告全局元素。
    */
    "global-element": "None",
    /*
    不能使用全局变量（ `_ENV` 被设置为了 `nil`）
    */
    "global-in-nil-env": "Any",
    /*
    `@param`或`@return`的注释不完整
    */
    "incomplete-signature-doc": "None",
    /*
    向对象注入字段
    */
    "inject-field": "Opened",
    /*
    使用不可见的值
    */
    "invisible": "Any",
    /*
    首字母小写的全局变量定义
    */
    "lowercase-global": "Any",
    /*
    缺少字段
    */
    "missing-fields": "Any",
    /*
    全局变量的注释缺失(全局函数必须为所有参数和返回值提供注释和注释)
    */
    "missing-global-doc": "None",
    /*
    导出的本地函数缺少注释(导出的本地函数必须有包括本身以及所有参数和返回值的注释)
    */
    "missing-local-export-doc": "None",
    /*
    函数参数数少于注释函数参数数
    */
    "missing-parameter": "Any",
    /*
    函数带有返回注释而无返回语句
    */
    "missing-return": "Any",
    /*
    函数无值返回但函数使用`@return`标记了返回值
    */
    "missing-return-value": "Any",
    /*
    变量的名称样式检查
    */
    "name-style-check": "None",
    /*
    变量之前被赋值为`nil`或可选值(可能为 `nil`)
    */
    "need-check-nil": "Opened",
    /*
    在字面量表中，2行代码之间缺少分隔符，在语法上被解析为了一次索引操作
    */
    "newfield-call": "Any",
    /*
    以 `(` 开始的新行，在语法上被解析为了上一行的函数调用
    */
    "newline-call": "Any",
    /*
    变量的未知类型无法推断
    */
    "no-unknown": "None",
    /*
    不允许调用 `coroutine.yield()` 
    */
    "not-yieldable": "None",
    /*
    给定参数的类型与函数定义所要求的类型(`@param`)不匹配
    */
    "param-type-mismatch": "Opened",
    /*
    重复定义的局部变量
    */
    "redefined-local": "Opened",
    /*
    函数调用时，传入了多余的参数
    */
    "redundant-parameter": "Any",
    /*
    当放置一个不需要的返回值时触发(函数会自行退出)
    */
    "redundant-return": "Opened",
    /*
    返回`@return`注释未指定的额外值
    */
    "redundant-return-value": "Any",
    /*
    赋值操作时，值的数量比被赋值的对象多
    */
    "redundant-value": "Any",
    /*
    返回值的类型与`@return`中声明的类型不匹配
    */
    "return-type-mismatch": "Opened",
    /*
    启用字符串拼写检查的诊断。
    */
    "spell-check": "None",
    /*
    后置空格
    */
    "trailing-space": "Opened",
    /*
    多重赋值时没有赋值所有变量(如`local x,y = 1`)
    */
    "unbalanced-assignments": "Any",
    /*
    在`@class`注解中引用未定义的类。
    */
    "undefined-doc-class": "Any",
    /*
    在`@type`注解中引用未定义的类型或`@alias`
    */
    "undefined-doc-name": "Any",
    /*
    函数声明中`@param`引用了未定义的参数
    */
    "undefined-doc-param": "Any",
    /*
    `_ENV` 被设置为了新的字面量表，但是试图获取的全局变量不再这张表中
    */
    "undefined-env-child": "Any",
    /*
    引用变量的未定义字段
    */
    "undefined-field": "Opened",
    /*
    未定义的全局变量
    */
    "undefined-global": "Any",
    /*
    使用`@cast`对未定义变量的强制转换
    */
    "unknown-cast-variable": "Any",
    /*
    未知的诊断代码
    */
    "unknown-diag-code": "Any",
    /*
    未知的运算符
    */
    "unknown-operator": "Any",
    /*
    不可达的代码
    */
    "unreachable-code": "Opened",
    /*
    未使用的函数
    */
    "unused-function": "Opened",
    /*
    未使用的标签
    */
    "unused-label": "Opened",
    /*
    未使用的局部变量
    */
    "unused-local": "Opened",
    /*
    未使用的不定参数
    */
    "unused-vararg": "Opened"
}
```

# diagnostics.severity

修改诊断等级。
以 `!` 结尾的设置优先级高于组设置 `diagnostics.groupSeverity`。


## type

```ts
object<string, string>
```

## enum

* ``"Error"``
* ``"Warning"``
* ``"Information"``
* ``"Hint"``
* ``"Error!"``
* ``"Warning!"``
* ``"Information!"``
* ``"Hint!"``

## default

```jsonc
{
    /*
    优先级歧义，如：`num or 0 + 1`，推测用户的实际期望为 `(num or 0) + 1` 
    */
    "ambiguity-1": "Warning",
    /*
    值类型与赋值变量类型不匹配
    */
    "assign-type-mismatch": "Warning",
    /*
    同步函数中异步函数调用
    */
    "await-in-sync": "Warning",
    /*
    已显式定义变量类型与要定义的值的类型不匹配
    */
    "cast-local-type": "Warning",
    /*
    变量被转换为与其初始类型不匹配的类型
    */
    "cast-type-mismatch": "Warning",
    /*
    `@class` 继承出现循环
    */
    "circle-doc-class": "Warning",
    /*
    尝试关闭非对象变量的诊断
    */
    "close-non-object": "Warning",
    /*
    放在循环中break语句后面的代码
    */
    "code-after-break": "Hint",
    /*
    启用对不正确样式行的诊断
    */
    "codestyle-check": "Warning",
    /*
    for循环永远无法达到最大/极限值(在递减时递增)
    */
    "count-down-loop": "Warning",
    /*
    变量已被标记为deprecated(过时)但仍在使用
    */
    "deprecated": "Warning",
    /*
    required的同一个文件使用了两个不同的名字
    */
    "different-requires": "Warning",
    /*
    函数的返回值被忽略(函数被`@nodiscard`标记时)
    */
    "discard-returns": "Warning",
    /*
    为不存在的类`@class`标记`@field`字段
    */
    "doc-field-no-class": "Warning",
    /*
    `@alias`字段的名字冲突
    */
    "duplicate-doc-alias": "Warning",
    /*
    `@field`字段的名字冲突
    */
    "duplicate-doc-field": "Warning",
    /*
    `@param`字段的名字冲突
    */
    "duplicate-doc-param": "Warning",
    /*
    在字面量表中重复定义了索引
    */
    "duplicate-index": "Warning",
    /*
    在一个类中多次定义同一字段
    */
    "duplicate-set-field": "Warning",
    /*
    空代码块
    */
    "empty-block": "Hint",
    /*
    启用诊断以警告全局元素。
    */
    "global-element": "Warning",
    /*
    不能使用全局变量（ `_ENV` 被设置为了 `nil`）
    */
    "global-in-nil-env": "Warning",
    /*
    `@param`或`@return`的注释不完整
    */
    "incomplete-signature-doc": "Warning",
    /*
    向对象注入字段
    */
    "inject-field": "Warning",
    /*
    使用不可见的值
    */
    "invisible": "Warning",
    /*
    首字母小写的全局变量定义
    */
    "lowercase-global": "Information",
    /*
    缺少字段
    */
    "missing-fields": "Warning",
    /*
    全局变量的注释缺失(全局函数必须为所有参数和返回值提供注释和注释)
    */
    "missing-global-doc": "Warning",
    /*
    导出的本地函数缺少注释(导出的本地函数必须有包括本身以及所有参数和返回值的注释)
    */
    "missing-local-export-doc": "Warning",
    /*
    函数参数数少于注释函数参数数
    */
    "missing-parameter": "Warning",
    /*
    函数带有返回注释而无返回语句
    */
    "missing-return": "Warning",
    /*
    函数无值返回但函数使用`@return`标记了返回值
    */
    "missing-return-value": "Warning",
    /*
    变量的名称样式检查
    */
    "name-style-check": "Warning",
    /*
    变量之前被赋值为`nil`或可选值(可能为 `nil`)
    */
    "need-check-nil": "Warning",
    /*
    在字面量表中，2行代码之间缺少分隔符，在语法上被解析为了一次索引操作
    */
    "newfield-call": "Warning",
    /*
    以 `(` 开始的新行，在语法上被解析为了上一行的函数调用
    */
    "newline-call": "Warning",
    /*
    变量的未知类型无法推断
    */
    "no-unknown": "Warning",
    /*
    不允许调用 `coroutine.yield()` 
    */
    "not-yieldable": "Warning",
    /*
    给定参数的类型与函数定义所要求的类型(`@param`)不匹配
    */
    "param-type-mismatch": "Warning",
    /*
    重复定义的局部变量
    */
    "redefined-local": "Hint",
    /*
    函数调用时，传入了多余的参数
    */
    "redundant-parameter": "Warning",
    /*
    当放置一个不需要的返回值时触发(函数会自行退出)
    */
    "redundant-return": "Hint",
    /*
    返回`@return`注释未指定的额外值
    */
    "redundant-return-value": "Warning",
    /*
    赋值操作时，值的数量比被赋值的对象多
    */
    "redundant-value": "Warning",
    /*
    返回值的类型与`@return`中声明的类型不匹配
    */
    "return-type-mismatch": "Warning",
    /*
    启用字符串拼写检查的诊断。
    */
    "spell-check": "Information",
    /*
    后置空格
    */
    "trailing-space": "Hint",
    /*
    多重赋值时没有赋值所有变量(如`local x,y = 1`)
    */
    "unbalanced-assignments": "Warning",
    /*
    在`@class`注解中引用未定义的类。
    */
    "undefined-doc-class": "Warning",
    /*
    在`@type`注解中引用未定义的类型或`@alias`
    */
    "undefined-doc-name": "Warning",
    /*
    函数声明中`@param`引用了未定义的参数
    */
    "undefined-doc-param": "Warning",
    /*
    `_ENV` 被设置为了新的字面量表，但是试图获取的全局变量不再这张表中
    */
    "undefined-env-child": "Information",
    /*
    引用变量的未定义字段
    */
    "undefined-field": "Warning",
    /*
    未定义的全局变量
    */
    "undefined-global": "Warning",
    /*
    使用`@cast`对未定义变量的强制转换
    */
    "unknown-cast-variable": "Warning",
    /*
    未知的诊断代码
    */
    "unknown-diag-code": "Warning",
    /*
    未知的运算符
    */
    "unknown-operator": "Warning",
    /*
    不可达的代码
    */
    "unreachable-code": "Hint",
    /*
    未使用的函数
    */
    "unused-function": "Hint",
    /*
    未使用的标签
    */
    "unused-label": "Hint",
    /*
    未使用的局部变量
    */
    "unused-local": "Hint",
    /*
    未使用的不定参数
    */
    "unused-vararg": "Hint"
}
```

# diagnostics.unusedLocalExclude

如果变量名匹配以下规则，则不对其进行 `unused-local` 诊断。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# diagnostics.workspaceDelay

进行工作区诊断的延迟（毫秒）。

## type

```ts
integer
```

## default

```jsonc
3000
```

# diagnostics.workspaceEvent

设置触发工作区诊断的时机。

## type

```ts
string
```

## enum

* ``"OnChange"``: 当文件发生变化时触发工作区诊断。
* ``"OnSave"``: 当文件保存时触发工作区诊断。
* ``"None"``: 关闭工作区诊断。

## default

```jsonc
"OnSave"
```

# diagnostics.workspaceRate

工作区诊断的运行速率（百分比）。降低该值会减少CPU占用，但是也会降低工作区诊断的速度。你当前正在编辑的文件的诊断总是全速完成，不受该选项影响。

## type

```ts
integer
```

## default

```jsonc
100
```

# doc.packageName

将特定名称的字段视为package，例如 `m_*` 意味着 `XXX.m_id` 与 `XXX.m_type` 只能在定义所在的文件中访问。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.privateName

将特定名称的字段视为私有，例如 `m_*` 意味着 `XXX.m_id` 与 `XXX.m_type` 是私有字段，只能在定义所在的类中访问。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.protectedName

将特定名称的字段视为受保护，例如 `m_*` 意味着 `XXX.m_id` 与 `XXX.m_type` 是受保护的字段，只能在定义所在的类极其子类中访问。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# doc.regengine

用于匹配文档作用域名称的正则表达式引擎。

## type

```ts
string
```

## enum

* ``"glob"``: 默认轻量级模式语法。
* ``"lua"``: 完整的 Lua 风格正则表达式。

## default

```jsonc
"glob"
```

# docScriptPath

自定义 Lua 脚本路径，覆盖默认文档生成行为。

## type

```ts
string
```

## default

```jsonc
""
```

# format.defaultConfig

默认的格式化配置，优先级低于工作区内的 `.editorconfig` 文件。
请查阅[格式化文档](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)了解用法。


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# format.enable

启用代码格式化程序。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.arrayIndex

在构造表时提示数组索引。

## type

```ts
string
```

## enum

* ``"Enable"``: 所有的表中都提示数组索引。
* ``"Auto"``: 只有表大于3项，或者表是混合类型时才进行提示。
* ``"Disable"``: 禁用数组索引提示。

## default

```jsonc
"Auto"
```

# hint.await

如果调用的函数被标记为了 `---@async` ，则在调用处提示 `await` 。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.awaitPropagate

启用 `await` 的传播, 当一个函数调用了一个`---@async`标记的函数时，会自动标记为`---@async`。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.enable

启用内联提示。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hint.paramName

在函数调用处提示参数名。

## type

```ts
string
```

## enum

* ``"All"``: 所有类型的参数均进行提示。
* ``"Literal"``: 只有字面量类型的参数进行提示。
* ``"Disable"``: 禁用参数提示。

## default

```jsonc
"All"
```

# hint.paramType

在函数的参数位置提示类型。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hint.semicolon

若语句尾部没有分号，则显示虚拟分号。

## type

```ts
string
```

## enum

* ``"All"``: 所有语句都显示虚拟分号。
* ``"SameLine"``: 2个语句在同一行时，在它们之间显示分号。
* ``"Disable"``: 禁用虚拟分号。

## default

```jsonc
"SameLine"
```

# hint.setType

在赋值操作位置提示类型。

## type

```ts
boolean
```

## default

```jsonc
false
```

# hover.enable

启用悬停提示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.enumsLimit

当值对应多个类型时，限制类型的显示数量。

## type

```ts
integer
```

## default

```jsonc
5
```

# hover.expandAlias

是否展开别名。例如 `---@alias myType boolean|number` 展开后显示为 `boolean|number`，否则显示为 `myType`。


## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.previewFields

悬停提示查看表时，限制表内字段的最大预览数量。

## type

```ts
integer
```

## default

```jsonc
10
```

# hover.viewNumber

悬停提示查看数字内容（仅当字面量不是十进制时）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewString

悬停提示查看字符串内容（仅当字面量包含转义符时）。

## type

```ts
boolean
```

## default

```jsonc
true
```

# hover.viewStringMax

悬停提示查看字符串内容时的最大长度。

## type

```ts
integer
```

## default

```jsonc
1000
```

# language.completeAnnotation

(仅VSCode) 在注解后换行时自动插入 "---@ "。

## type

```ts
boolean
```

## default

```jsonc
true
```

# language.fixIndent

(仅VSCode) 修复错误的自动缩进，例如在包含单词 "function" 的字符串中换行时出现的错误缩进。

## type

```ts
boolean
```

## default

```jsonc
true
```

# misc.executablePath

VSCode中指定可执行文件路径。

## type

```ts
string
```

## default

```jsonc
""
```

# misc.parameters

VSCode中启动语言服务时的[命令行参数](https://luals.github.io/wiki/usage#arguments)。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# nameStyle.config

设定命名风格检查的配置。
请查阅[格式化文档](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs)了解用法。


## type

```ts
Object<string, string | array>
```

## default

```jsonc
{}
```

# runtime.builtin

调整内置库的启用状态，你可以根据实际运行环境禁用掉不存在的库（或重新定义）。

* `default`: 表示库会根据运行版本启用或禁用
* `enable`: 总是启用
* `disable`: 总是禁用


## type

```ts
object<string, string>
```

## enum

* ``"default"``
* ``"enable"``
* ``"disable"``

## default

```jsonc
{
    "basic": "default",
    "bit": "default",
    "bit32": "default",
    "builtin": "default",
    "coroutine": "default",
    "debug": "default",
    "ffi": "default",
    "io": "default",
    "jit": "default",
    "jit.profile": "default",
    "jit.util": "default",
    "math": "default",
    "os": "default",
    "package": "default",
    "string": "default",
    "string.buffer": "default",
    "table": "default",
    "table.clear": "default",
    "table.new": "default",
    "utf8": "default"
}
```

# runtime.enableLuaJITExtensions

启用 LuaJIT 扩展语法（需要将 `Lua.runtime.version` 设置为 `LuaJIT`）。
各项扩展语法也可以单独通过 `Lua.runtime.nonstandardSymbol` 启用。


## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.fileEncoding

文件编码，`ansi` 选项只在 `Windows` 平台下有效。

## type

```ts
string
```

## enum

* ``"utf8"``
* ``"ansi"``
* ``"utf16le"``
* ``"utf16be"``

## default

```jsonc
"utf8"
```

# runtime.meta

meta文件的目录名称格式。

## type

```ts
string
```

## default

```jsonc
"${version} ${language} ${encoding}"
```

# runtime.nonstandardSymbol

支持非标准的符号。请务必确认你的运行环境支持这些符号。

## type

```ts
Array<string>
```

## enum

* ``"//"``: 行注释（C 风格）。
* ``"/**/"``: 块注释（C 风格）。
* ``"`"``: 反引号字符串字面量。
* ``"+="``: 加法复合赋值。
* ``"-="``: 减法复合赋值。
* ``"*="``: 乘法复合赋值。
* ``"/="``: 除法复合赋值。
* ``"%="``: 取模复合赋值。
* ``"^="``: 幂复合赋值。
* ``"//="``: 地板除复合赋值。
* ``"|="``: 按位或复合赋值。
* ``"&="``: 按位与复合赋值。
* ``"<<="``: 左移复合赋值。
* ``">>="``: 右移复合赋值。
* ``"||"``: 逻辑或（等价于 or）。
* ``"&&"``: 逻辑与（等价于 and）。
* ``"!"``: 逻辑非（等价于 not）。
* ``"!="``: 不等于（等价于 ~=）。
* ``"continue"``: continue 语句。
* ``"|lambda|"``: 管道参数短函数（`|x| expr`）。
* ``"?."``: 安全导航（字段/方法：`a?.b` / `obj?.:method()` / `obj:method?.()`）。
* ``"?.("``: 安全导航调用（`f?.()` / `f?."str"` / `f?.{...}` / `f?.[[...]]`）。
* ``"?.["``: 安全导航索引（`t?.[key]`）。
* ``"??"``: 空值合并（`a ?? b`，仅当左侧为 nil 时取右侧）。
* ``"?:"``: 三元条件（`a ? b : c`，右结合；b 部分禁止方法调用）。
* ``"~>>"``: 算术右移（`a ~>> b`，LuaJIT 特有；普通 `>>` 为逻辑右移）。
* ``"~>>="``: 算术右移复合赋值（`a ~>>= b`）。
* ``"..="``: 字符串连接复合赋值（`a ..= b`）。
* ``"~="``: 异或复合赋值：仅语句上下文（如 `a ~= b` 单独成行）生效；表达式中仍是不等于比较。
* ``"const"``: `const` 声明（块级局部常量，不可重新赋值/重复声明）。
* ``"->"``: 短函数箭头（`x -> expr` / `|x| -> expr` / `|| -> expr` / `-> do ... end`）。
* ``"number_underscore"``: 数字字面量下划线（如 `1_000`、`0x1_2`、`0b1_0`）。
* ``"?("``: 无点号可选链调用（`f?()` 等价于 `f?.()`；与三元 `?:` 解析冲突，不建议同时启用）。
* ``"?["``: 无点号可选链索引（`t?[1]` 等价于 `t?.[1]`；与三元 `?:` 解析冲突，不建议同时启用）。

## default

```jsonc
[]
```

# runtime.path

当使用 `require` 时，如何根据输入的名字来查找文件。
此选项设置为 `?/init.lua` 意味着当你输入 `require 'myfile'` 时，会从已加载的文件中搜索 `{workspace}/myfile/init.lua`。
当 `runtime.pathStrict` 设置为 `false` 时，还会尝试搜索 `${workspace}/**/myfile/init.lua`。
如果你想要加载工作区以外的文件，你需要先设置 `Lua.workspace.library`。


## type

```ts
Array<string>
```

## default

```jsonc
["?.lua","?/init.lua"]
```

# runtime.pathStrict

启用后 `runtime.path` 将只搜索第一层目录，见 `runtime.path` 的说明。

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.plugin

插件路径，请查阅[文档](https://luals.github.io/wiki/plugins)了解用法。

## type

```ts
string | array
```

## default

```jsonc
null
```

# runtime.pluginArgs

插件的额外参数。

## type

```ts
array | object
```

## default

```jsonc
null
```

# runtime.special

将自定义全局变量视为一些特殊的内置变量，语言服务将提供特殊的支持。
下面这个例子表示将 `include` 视为 `require` 。
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```


## type

```ts
Object<string, string>
```

## default

```jsonc
{}
```

# runtime.unicodeName

允许在名字中使用 Unicode 字符。

## type

```ts
boolean
```

## default

```jsonc
false
```

# runtime.version

Lua运行版本。

## type

```ts
string
```

## enum

* ``"Lua 5.1"``
* ``"Lua 5.2"``
* ``"Lua 5.3"``
* ``"Lua 5.4"``
* ``"Lua 5.5"``
* ``"LuaJIT"``

## default

```jsonc
"Lua 5.4"
```

# semantic.annotation

对类型注解进行语义着色。

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.enable

启用语义着色。你可能需要同时将 `editor.semanticHighlighting.enabled` 设置为 `true` 才能生效。

## type

```ts
boolean
```

## default

```jsonc
true
```

# semantic.keyword

对关键字/字面量/运算符进行语义着色。只有当你的编辑器无法进行语法着色时才需要启用此功能。

## type

```ts
boolean
```

## default

```jsonc
false
```

# semantic.variable

对变量/字段/参数进行语义着色。

## type

```ts
boolean
```

## default

```jsonc
true
```

# signatureHelp.enable

启用参数提示。

## type

```ts
boolean
```

## default

```jsonc
true
```

# spell.dict

拼写检查的自定义单词。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# type.castNumberToInteger

允许将 `number` 类型赋给 `integer` 类型。

## type

```ts
boolean
```

## default

```jsonc
true
```

# type.checkTableShape

对表的形状进行严格检查。


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.inferParamType

未注释参数类型时，参数类型由函数传入参数推断。

如果设置为 "false"，则在未注释时，参数类型为 "any"。


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.inferTableSize

类型推断期间分析的表字段的最大数量。

## type

```ts
integer
```

## default

```jsonc
10
```

# type.maxUnionVariants

**Missing description!!**

## type

```ts
integer
```

## default

```jsonc
0
```

# type.weakNilCheck

对联合类型进行类型检查时，忽略其中的 `nil`。

此设置为 `false` 时，`numer|nil` 类型无法赋给 `number` 类型；为 `true` 是则可以。


## type

```ts
boolean
```

## default

```jsonc
false
```

# type.weakUnionCheck

联合类型中只要有一个子类型满足条件，则联合类型也满足条件。

此设置为 `false` 时，`number|boolean` 类型无法赋给 `number` 类型；为 `true` 时则可以。


## type

```ts
boolean
```

## default

```jsonc
false
```

# typeFormat.config

配置输入Lua代码时的格式化行为

## type

```ts
object<string, string>
```

## default

```jsonc
{
    /*
    是否在合适的位置自动完成 `end`
    */
    "auto_complete_end": "true",
    /*
    是否在table末尾自动添加分隔符
    */
    "auto_complete_table_sep": "true",
    /*
    是否对某一行进行格式化
    */
    "format_line": "true"
}
```

# window.progressBar

在状态栏显示进度条。

## type

```ts
boolean
```

## default

```jsonc
true
```

# window.statusBar

在状态栏显示插件状态。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.checkThirdParty

自动检测与适配第三方库，目前支持的库为：

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass


## type

```ts
string | boolean
```

## default

```jsonc
null
```

# workspace.ignoreDir

忽略的文件与目录（使用 `.gitignore` 语法）。

## type

```ts
Array<string>
```

## default

```jsonc
[".vscode"]
```

# workspace.ignoreSubmodules

忽略子模块。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.library

除了当前工作区以外，还会从哪些目录中加载文件。这些目录中的文件将被视作外部提供的代码库，部分操作（如重命名字段）不会修改这些文件。

## type

```ts
Array<string>
```

## default

```jsonc
[]
```

# workspace.maxPreload

最大预加载文件数。

## type

```ts
integer
```

## default

```jsonc
5000
```

# workspace.preloadFileSize

预加载时跳过大小大于该值（KB）的文件。

## type

```ts
integer
```

## default

```jsonc
500
```

# workspace.useGitIgnore

忽略 `.gitignore` 中列举的文件。

## type

```ts
boolean
```

## default

```jsonc
true
```

# workspace.userThirdParty

在这里添加私有的第三方库适配文件路径，请参考内置的[配置文件路径](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)

## type

```ts
Array<string>
```

## default

```jsonc
[]
```