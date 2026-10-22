# addonManager.enable

Чи увімкнений менеджер розширень?

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# addonManager.repositoryBranch

Гілка `git`, яку використовуватиме менеджер розширень.

## Тип

```ts
string
```

## За замовчуванням

```jsonc
""
```

# addonManager.repositoryPath

Шлях `git`, який використовуватиме менеджер розширень.

## Тип

```ts
string
```

## За замовчуванням

```jsonc
""
```

# addonRepositoryPath

Шлях репозиторію розширень (не пов'язаний з менеджером розширень).

## Тип

```ts
string
```

## За замовчуванням

```jsonc
""
```

# codeLens.enable

Увімкнути `Code Lens`.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# completion.autoRequire

Автоматично додавати `require`, якщо введення схоже на назву модуля.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# completion.callSnippet

Показувати приклад виклику функції.

## Тип

```ts
string
```

## Опції

* ``"Disable"``: Показувати тільки назву функції.
* ``"Both"``: Показувати назву функції та приклад виклику.
* ``"Replace"``: Показувати тільки приклад виклику.

## За замовчуванням

```jsonc
"Disable"
```

# completion.displayContext

Перегляд конкретного фрагмента коду.

Встановлене число вказує на захоплену кількість рядків коду для перегляду. 

`0` вимкне цю функцію.

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
0
```

# completion.enable

Увімкнути автодоповнення.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# completion.keywordSnippet

Показувати приклад синтаксису ключових слів.

## Тип

```ts
string
```

## Опції

* ``"Disable"``: Показувати тільки ключове слово.
* ``"Both"``: Показувати ключове слово та приклад синтаксису.
* ``"Replace"``: Показувати тільки приклад синтаксису.

## За замовчуванням

```jsonc
"Replace"
```

# completion.maxSuggestCount

Максимальна кількість полів, що аналізуватиметься для автодоповнень. Коли об'єкт має більше полів, ніж ліміт, то щоб з'явились підказки, потрібне конкретніше введення.

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
100
```

# completion.postfix

Символ для постфіксної підказки.

## Тип

```ts
string
```

## За замовчуванням

```jsonc
"@"
```

# completion.requireSeparator

Роздільний символ для `require` (`.` або `/`).

## Тип

```ts
string
```

## За замовчуванням

```jsonc
"."
```

# completion.showParams

Відображати параметри у списку автодоповнень. Якщо функція має кілька визначень, вони відображатимуться окремо.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# completion.showWord

Показувати пов'язані слова у підказках.

## Тип

```ts
string
```

## Опції

* ``"Enable"``: Увімкнути підказки.
* ``"Fallback"``: Показувати пов'язані слова, якщо семантичні підказки неможливі.
* ``"Disable"``: Вимкнути підказки.

## За замовчуванням

```jsonc
"Fallback"
```

# completion.workspaceWord

Чи міститься відображене слово в інших файлах?

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# diagnostics.disable

Вимкнути діагностику.

## Тип

```ts
Array<string>
```

## Опції

* ``"action-after-return"``: Код після `return`
* ``"ambiguity-1"``: Увімкнути діагностику неоднозначного пріоритету операторів. Наприклад, на вираз `num or 0 + 1` буде запропоновано `(num or 0) + 1`.
* ``"ambiguous-syntax"``: Неоднозначний синтаксис.
* ``"args-after-dots"``: Аргументи після `...`
* ``"assign-const-global"``: Присвоєння константній глобальній змінній
* ``"assign-type-mismatch"``: Увімкнути діагностику присвоєння непов'язаних між собою типів.
* ``"await-in-sync"``: Увімкнути діагностику асинхронних викликів всередині звичайної функції.
* ``"block-after-else"``: Блок після `else`
* ``"break-outside"``: Використання `break` поза циклом
* ``"cast-local-type"``: Увімкнути діагностику кастів, де цільовий тип локальної змінної не відповідає вихідному.
* ``"cast-type-mismatch"``: Увімкнути діагностику кастів, де цільовий тип не відповідає вихідному.
* ``"circle-doc-class"``: Циклічне успадкування `@class`
* ``"close-non-object"``: Увімкнути діагностику спроб закрити змінну, яка не є об'єктом.
* ``"code-after-break"``: Увімкнути діагностику коду, що знаходиться після `break` у циклі.
* ``"codestyle-check"``: Увімкнути діагностику невідповідного стилю коду.
* ``"count-down-loop"``: Увімкнути діагностику циклів `for`, де лічильник рухається не в той бік.
* ``"declare-const"``: Повторне визначення константи
* ``"deprecated"``: Увімкнути діагностику застарілих `API`.
* ``"different-requires"``: Увімкнути діагностику файлів, які імпортуються під різними назвами.
* ``"discard-returns"``: Увімкнути діагностику ігнорування результатів функцій, позначених анотацією `---@nodiscard`.
* ``"doc-field-no-class"``: Увімкнути діагностику анотацій полів, що не мають анотацій класу.
* ``"duplicate-doc-alias"``: Увімкнути діагностику дублювання анотацій аліасу.
* ``"duplicate-doc-field"``: Увімкнути діагностику дублювання анотацій поля.
* ``"duplicate-doc-param"``: Увімкнути діагностику дублювання анотацій параметру.
* ``"duplicate-index"``: Увімкнути діагностику дублювання індексів таблиці.
* ``"duplicate-set-field"``: Увімкнути діагностику повторного встановлення поля того самого класу.
* ``"empty-block"``: Увімкнути діагностику порожніх блоків коду.
* ``"env-is-global"``: `_ENV` використано як глобальну змінну
* ``"err-assign-as-eq"``
* ``"err-c-long-comment"``
* ``"err-comment-prefix"``
* ``"err-do-as-then"``
* ``"err-eq-as-assign"``
* ``"err-esc"``
* ``"err-nonstandard-symbol"``
* ``"err-then-as-do"``
* ``"exp-in-action"``: Вираз використано як інструкцію
* ``"global-close-attribute"``: Атрибут `close` у глобальній змінній
* ``"global-element"``: Увімкнути діагностику глобальних елементів.
* ``"global-in-nil-env"``: Увімкнути діагностику глобальних змінних (якщо `_ENV` має значення `nil`).
* ``"incomplete-signature-doc"``: Увімкнути діагностику неповних анотацій `@param` та `@return`.
* ``"index-in-func-name"``: Індекс в імені функції
* ``"inject-field"``: Впровадження поля в об'єкт
* ``"invisible"``: Увімкнути діагностику спроб доступу до невидимих полів.
* ``"jump-local-scope"``: Перехід у область видимості локальної змінної
* ``"keyword"``: Неналежне використання ключового слова
* ``"local-limit"``: Забагато локальних змінних
* ``"lowercase-global"``: Увімкнути діагностику глобальних змінних, що починаються з малої літери.
* ``"lua-doc-miss-sign"``: Пропущений знак коментаря `LuaDoc`
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
* ``"malformed-number"``: Некоректне число
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
* ``"missing-fields"``: Пропущені поля
* ``"missing-global-doc"``: Відсутні анотації для глобальних функцій! Вони повинні мати коментар та анотацію для параметрів і значень, які повертає функція.
* ``"missing-local-export-doc"``: Відсутні анотації для експортованих локальних функцій! Вони повинні мати коментар та анотацію для параметрів і значень, які повертає функція.
* ``"missing-parameter"``: Увімкнути діагностику функцій, кількість аргументів яких менша за кількість параметрів.
* ``"missing-return"``: Увімкнути діагностику функцій, де відсутній `return`.
* ``"missing-return-value"``: Увімкнути діагностику функцій, де `return` не повертає значення.
* ``"multi-close"``: Неодноразова операція закриття
* ``"name-style-check"``: Увімкнути діагностику стилів назв.
* ``"need-check-nil"``: Увімкнути діагностику використання змінних, яким раніше було присвоєно `nil` або значення, яке може бути `nil`.
* ``"need-paren"``: Потрібні дужки
* ``"nesting-long-mark"``: Вкладені мітки довгих коментарів
* ``"newfield-call"``: Увімкнути діагностику функцій у полях таблиці, дужки яких починаються з нового рядка.
* ``"newline-call"``: Увімкнути діагностику викликів функцій з нового рядка. Спрацьовує, коли зустрічається рядок, який починається з `(`, що парситься як виклик функції на попередньому рядку.
* ``"no-unknown"``: Увімкнути діагностику типів, які не можна вивести.
* ``"no-visible-label"``: Невидима мітка
* ``"not-yieldable"``: Увімкнути діагностику недозволених викликів `coroutine.yield()`.
* ``"param-type-mismatch"``: Увімкнути діагностику викликів функцій, де наданий тип не збігається з анотованим.
* ``"redefined-label"``: Перевизначена мітка
* ``"redefined-local"``: Увімкнути діагностику перевизначених локальних змінних.
* ``"redundant-parameter"``: Увімкнути діагностику непотрібних параметрів функцій.
* ``"redundant-return"``: Увімкнути діагностику функцій, які мають зайвий `return`.
* ``"redundant-return-value"``: Увімкнути діагностику `return`, що повертає додаткове значення, яке не передбачене анотацією.
* ``"redundant-value"``: Увімкнути діагностику надлишкових присвоєних значень.
* ``"return-type-mismatch"``: Увімкнути діагностику `return`, що повертає значення, тип якого не збігається з анотованим.
* ``"set-const"``: Присвоєння константі
* ``"spell-check"``: Увімкнути діагностику одруків у рядках.
* ``"trailing-space"``: Увімкнути діагностику пробілів у кінці.
* ``"unbalanced-assignments"``: Увімкнути діагностику кількох присвоєнь, де не всі змінні отримують значення (наприклад, `local x,y = 1`).
* ``"undefined-doc-class"``: Увімкнути діагностику анотацій класів, що вказують на невизначений клас.
* ``"undefined-doc-name"``: Увімкнути діагностику анотацій типів, що вказують на невизначений тип або аліас.
* ``"undefined-doc-param"``: Увімкнути діагностику анотацій параметра без самого параметра.
* ``"undefined-env-child"``: Увімкнути діагностику невизначеної змінної оточення. Спрацьовує, коли таблиця присвоює собі `_ENV`, але глобальна змінна не існує.
* ``"undefined-field"``: Увімкнути діагностику випадків читання невизначеного поля змінної.
* ``"undefined-global"``: Увімкнути діагностику невизначених глобальних змінних.
* ``"unexpect-dots"``
* ``"unexpect-efunc-name"``
* ``"unexpect-gfunc-name"``
* ``"unexpect-lfunc-name"``
* ``"unexpect-symbol"``
* ``"unicode-name"``: Назва використовує Юнікод
* ``"unknown-attribute"``: Невідомий атрибут
* ``"unknown-cast-variable"``: Увімкнути діагностику кастів невизначених змінних.
* ``"unknown-diag-code"``: Увімкнути діагностику випадків невідомого коду.
* ``"unknown-operator"``: Увімкнути діагностику невідомих операторів.
* ``"unknown-symbol"``: Невідомий символ
* ``"unreachable-code"``: Увімкнути діагностику недоступного коду.
* ``"unsupport-named-vararg"``: Назва для `vararg` не підтримується
* ``"unsupport-symbol"``
* ``"unused-function"``: Увімкнути діагностику невикористаних функцій.
* ``"unused-label"``: Увімкнути діагностику невикористаних міток.
* ``"unused-local"``: Увімкнути діагностику невикористаних локальних змінних.
* ``"unused-vararg"``: Увімкнути діагностику невикористаних `vararg`.
* ``"variable-not-declared"``: Використання неоголошеної змінної

## За замовчуванням

```jsonc
[]
```

# diagnostics.enable

Увімкнути діагностику.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# diagnostics.enableScheme

**Опис відсутній!!**

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
["file"]
```

# diagnostics.globals

Визначені глобальні змінні.

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[]
```

# diagnostics.globalsRegex

Знайти визначені глобальні змінні за допомогою регулярного виразу.

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[]
```

# diagnostics.groupFileStatus

Змінити стан файлу, що потребує діагностики всієї групи.

* Opened:  діагностувати тільки відкриті файли
* Any:     діагностувати усі файли
* None:    вимкнути діагностику

`Fallback` означає, що діагностика групи контролюється окремо за допомогою `diagnostics.neededFileStatus`.

Перевизначає індивідуальні налаштування, якщо ті не мають `!` у кінці.


## Тип

```ts
object<string, string>
```

## Опції

* ``"Any"``
* ``"Opened"``
* ``"None"``
* ``"Fallback"``

## За замовчуванням

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

Змінити суворість діагностики всієї групи.

`Fallback` означає, що діагностика групи контролюється окремо за допомогою `diagnostics.severity`.

Перевизначає індивідуальні налаштування, якщо ті не мають `!` у кінці.


## Тип

```ts
object<string, string>
```

## Опції

* ``"Error"``
* ``"Warning"``
* ``"Information"``
* ``"Hint"``
* ``"Fallback"``

## За замовчуванням

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

Як діагностувати проігноровані файли?

## type

```ts
string
```

## Опції

* ``"Enable"``: Завжди діагностувати файли.
* ``"Opened"``: Діагностувати тільки відкриті файли.
* ``"Disable"``: Вимкнути діагностику.

## За замовчуванням

```jsonc
"Opened"
```

# diagnostics.libraryFiles

Як діагностувати файли у `Lua.workspace.library`?

## type

```ts
string
```

## Опції

* ``"Enable"``: Завжди діагностувати.
* ``"Opened"``: Діагностувати лише відкриті файли.
* ``"Disable"``: Вимкнути діагностику.

## За замовчуванням

```jsonc
"Opened"
```

# diagnostics.neededFileStatus

* Opened:  діагностувати тільки відкриті файли
* Any:     діагностувати усі файли
* None:    вимкнути діагностику

`!` у кінці перевизначає групове налаштування `diagnostics.groupFileStatus`.


## type

```ts
object<string, string>
```

## Опції

* ``"Any"``
* ``"Opened"``
* ``"None"``
* ``"Any!"``
* ``"Opened!"``
* ``"None!"``

## За замовчуванням

```jsonc
{
    /*
    Увімкнути діагностику неоднозначного пріоритету операторів. Наприклад, на вираз `num or 0 + 1` буде запропоновано `(num or 0) + 1`.
    */
    "ambiguity-1": "Any",
    /*
    Увімкнути діагностику присвоєння непов'язаних між собою типів.
    */
    "assign-type-mismatch": "Opened",
    /*
    Увімкнути діагностику асинхронних викликів всередині звичайної функції.
    */
    "await-in-sync": "None",
    /*
    Увімкнути діагностику кастів, де цільовий тип локальної змінної не відповідає вихідному.
    */
    "cast-local-type": "Opened",
    /*
    Увімкнути діагностику кастів, де цільовий тип не відповідає вихідному.
    */
    "cast-type-mismatch": "Opened",
    /*
    Циклічне успадкування `@class`
    */
    "circle-doc-class": "Any",
    /*
    Увімкнути діагностику спроб закрити змінну, яка не є об'єктом.
    */
    "close-non-object": "Any",
    /*
    Увімкнути діагностику коду, що знаходиться після `break` у циклі.
    */
    "code-after-break": "Opened",
    /*
    Увімкнути діагностику невідповідного стилю коду.
    */
    "codestyle-check": "None",
    /*
    Увімкнути діагностику циклів `for`, де лічильник рухається не в той бік.
    */
    "count-down-loop": "Any",
    /*
    Увімкнути діагностику застарілих `API`.
    */
    "deprecated": "Any",
    /*
    Увімкнути діагностику файлів, які імпортуються під різними назвами.
    */
    "different-requires": "Any",
    /*
    Увімкнути діагностику ігнорування результатів функцій, позначених анотацією `---@nodiscard`.
    */
    "discard-returns": "Any",
    /*
    Увімкнути діагностику анотацій полів, що не мають анотацій класу.
    */
    "doc-field-no-class": "Any",
    /*
    Увімкнути діагностику дублювання анотацій аліасу.
    */
    "duplicate-doc-alias": "Any",
    /*
    Увімкнути діагностику дублювання анотацій поля.
    */
    "duplicate-doc-field": "Any",
    /*
    Увімкнути діагностику дублювання анотацій параметру.
    */
    "duplicate-doc-param": "Any",
    /*
    Увімкнути діагностику дублювання індексів таблиці.
    */
    "duplicate-index": "Any",
    /*
    Увімкнути діагностику повторного встановлення поля того самого класу.
    */
    "duplicate-set-field": "Opened",
    /*
    Увімкнути діагностику порожніх блоків коду.
    */
    "empty-block": "Opened",
    /*
    Увімкнути діагностику глобальних елементів.
    */
    "global-element": "None",
    /*
    Увімкнути діагностику глобальних змінних (якщо `_ENV` має значення `nil`).
    */
    "global-in-nil-env": "Any",
    /*
    Увімкнути діагностику неповних анотацій `@param` та `@return`.
    */
    "incomplete-signature-doc": "None",
    /*
    Впровадження поля в об'єкт
    */
    "inject-field": "Opened",
    /*
    Увімкнути діагностику спроб доступу до невидимих полів.
    */
    "invisible": "Any",
    /*
    Увімкнути діагностику глобальних змінних, що починаються з малої літери.
    */
    "lowercase-global": "Any",
    /*
    Пропущені поля
    */
    "missing-fields": "Any",
    /*
    Відсутні анотації для глобальних функцій! Вони повинні мати коментар та анотацію для параметрів і значень, які повертає функція.
    */
    "missing-global-doc": "None",
    /*
    Відсутні анотації для експортованих локальних функцій! Вони повинні мати коментар та анотацію для параметрів і значень, які повертає функція.
    */
    "missing-local-export-doc": "None",
    /*
    Увімкнути діагностику функцій, кількість аргументів яких менша за кількість параметрів.
    */
    "missing-parameter": "Any",
    /*
    Увімкнути діагностику функцій, де відсутній `return`.
    */
    "missing-return": "Any",
    /*
    Увімкнути діагностику функцій, де `return` не повертає значення.
    */
    "missing-return-value": "Any",
    /*
    Увімкнути діагностику стилів назв.
    */
    "name-style-check": "None",
    /*
    Увімкнути діагностику використання змінних, яким раніше було присвоєно `nil` або значення, яке може бути `nil`.
    */
    "need-check-nil": "Opened",
    /*
    Увімкнути діагностику функцій у полях таблиці, дужки яких починаються з нового рядка.
    */
    "newfield-call": "Any",
    /*
    Увімкнути діагностику викликів функцій з нового рядка. Спрацьовує, коли зустрічається рядок, який починається з `(`, що парситься як виклик функції на попередньому рядку.
    */
    "newline-call": "Any",
    /*
    Увімкнути діагностику типів, які не можна вивести.
    */
    "no-unknown": "None",
    /*
    Увімкнути діагностику недозволених викликів `coroutine.yield()`.
    */
    "not-yieldable": "None",
    /*
    Увімкнути діагностику викликів функцій, де наданий тип не збігається з анотованим.
    */
    "param-type-mismatch": "Opened",
    /*
    Увімкнути діагностику перевизначених локальних змінних.
    */
    "redefined-local": "Opened",
    /*
    Увімкнути діагностику непотрібних параметрів функцій.
    */
    "redundant-parameter": "Any",
    /*
    Увімкнути діагностику функцій, які мають зайвий `return`.
    */
    "redundant-return": "Opened",
    /*
    Увімкнути діагностику `return`, що повертає додаткове значення, яке не передбачене анотацією.
    */
    "redundant-return-value": "Any",
    /*
    Увімкнути діагностику надлишкових присвоєних значень.
    */
    "redundant-value": "Any",
    /*
    Увімкнути діагностику `return`, що повертає значення, тип якого не збігається з анотованим.
    */
    "return-type-mismatch": "Opened",
    /*
    Увімкнути діагностику одруків у рядках.
    */
    "spell-check": "None",
    /*
    Увімкнути діагностику пробілів у кінці.
    */
    "trailing-space": "Opened",
    /*
    Увімкнути діагностику кількох присвоєнь, де не всі змінні отримують значення (наприклад, `local x,y = 1`).
    */
    "unbalanced-assignments": "Any",
    /*
    Увімкнути діагностику анотацій класів, що вказують на невизначений клас.
    */
    "undefined-doc-class": "Any",
    /*
    Увімкнути діагностику анотацій типів, що вказують на невизначений тип або аліас.
    */
    "undefined-doc-name": "Any",
    /*
    Увімкнути діагностику анотацій параметра без самого параметра.
    */
    "undefined-doc-param": "Any",
    /*
    Увімкнути діагностику невизначеної змінної оточення. Спрацьовує, коли таблиця присвоює собі `_ENV`, але глобальна змінна не існує.
    */
    "undefined-env-child": "Any",
    /*
    Увімкнути діагностику випадків читання невизначеного поля змінної.
    */
    "undefined-field": "Opened",
    /*
    Увімкнути діагностику невизначених глобальних змінних.
    */
    "undefined-global": "Any",
    /*
    Увімкнути діагностику кастів невизначених змінних.
    */
    "unknown-cast-variable": "Any",
    /*
    Увімкнути діагностику випадків невідомого коду.
    */
    "unknown-diag-code": "Any",
    /*
    Увімкнути діагностику невідомих операторів.
    */
    "unknown-operator": "Any",
    /*
    Увімкнути діагностику недоступного коду.
    */
    "unreachable-code": "Opened",
    /*
    Увімкнути діагностику невикористаних функцій.
    */
    "unused-function": "Opened",
    /*
    Увімкнути діагностику невикористаних міток.
    */
    "unused-label": "Opened",
    /*
    Увімкнути діагностику невикористаних локальних змінних.
    */
    "unused-local": "Opened",
    /*
    Увімкнути діагностику невикористаних `vararg`.
    */
    "unused-vararg": "Opened"
}
```

# diagnostics.severity

Змінити суворість діагностики.

`!` у кінці перевизначає групове налаштування `diagnostics.groupSeverity`.


## Тип

```ts
object<string, string>
```

## Опції

* ``"Error"``
* ``"Warning"``
* ``"Information"``
* ``"Hint"``
* ``"Error!"``
* ``"Warning!"``
* ``"Information!"``
* ``"Hint!"``

## За замовчуванням

```jsonc
{
    /*
    Увімкнути діагностику неоднозначного пріоритету операторів. Наприклад, на вираз `num or 0 + 1` буде запропоновано `(num or 0) + 1`.
    */
    "ambiguity-1": "Warning",
    /*
    Увімкнути діагностику присвоєння непов'язаних між собою типів.
    */
    "assign-type-mismatch": "Warning",
    /*
    Увімкнути діагностику асинхронних викликів всередині звичайної функції.
    */
    "await-in-sync": "Warning",
    /*
    Увімкнути діагностику кастів, де цільовий тип локальної змінної не відповідає вихідному.
    */
    "cast-local-type": "Warning",
    /*
    Увімкнути діагностику кастів, де цільовий тип не відповідає вихідному.
    */
    "cast-type-mismatch": "Warning",
    /*
    Циклічне успадкування `@class`
    */
    "circle-doc-class": "Warning",
    /*
    Увімкнути діагностику спроб закрити змінну, яка не є об'єктом.
    */
    "close-non-object": "Warning",
    /*
    Увімкнути діагностику коду, що знаходиться після `break` у циклі.
    */
    "code-after-break": "Hint",
    /*
    Увімкнути діагностику невідповідного стилю коду.
    */
    "codestyle-check": "Warning",
    /*
    Увімкнути діагностику циклів `for`, де лічильник рухається не в той бік.
    */
    "count-down-loop": "Warning",
    /*
    Увімкнути діагностику застарілих `API`.
    */
    "deprecated": "Warning",
    /*
    Увімкнути діагностику файлів, які імпортуються під різними назвами.
    */
    "different-requires": "Warning",
    /*
    Увімкнути діагностику ігнорування результатів функцій, позначених анотацією `---@nodiscard`.
    */
    "discard-returns": "Warning",
    /*
    Увімкнути діагностику анотацій полів, що не мають анотацій класу.
    */
    "doc-field-no-class": "Warning",
    /*
    Увімкнути діагностику дублювання анотацій аліасу.
    */
    "duplicate-doc-alias": "Warning",
    /*
    Увімкнути діагностику дублювання анотацій поля.
    */
    "duplicate-doc-field": "Warning",
    /*
    Увімкнути діагностику дублювання анотацій параметру.
    */
    "duplicate-doc-param": "Warning",
    /*
    Увімкнути діагностику дублювання індексів таблиці.
    */
    "duplicate-index": "Warning",
    /*
    Увімкнути діагностику повторного встановлення поля того самого класу.
    */
    "duplicate-set-field": "Warning",
    /*
    Увімкнути діагностику порожніх блоків коду.
    */
    "empty-block": "Hint",
    /*
    Увімкнути діагностику глобальних елементів.
    */
    "global-element": "Warning",
    /*
    Увімкнути діагностику глобальних змінних (якщо `_ENV` має значення `nil`).
    */
    "global-in-nil-env": "Warning",
    /*
    Увімкнути діагностику неповних анотацій `@param` та `@return`.
    */
    "incomplete-signature-doc": "Warning",
    /*
    Впровадження поля в об'єкт
    */
    "inject-field": "Warning",
    /*
    Увімкнути діагностику спроб доступу до невидимих полів.
    */
    "invisible": "Warning",
    /*
    Увімкнути діагностику глобальних змінних, що починаються з малої літери.
    */
    "lowercase-global": "Information",
    /*
    Пропущені поля
    */
    "missing-fields": "Warning",
    /*
    Відсутні анотації для глобальних функцій! Вони повинні мати коментар та анотацію для параметрів і значень, які повертає функція.
    */
    "missing-global-doc": "Warning",
    /*
    Відсутні анотації для експортованих локальних функцій! Вони повинні мати коментар та анотацію для параметрів і значень, які повертає функція.
    */
    "missing-local-export-doc": "Warning",
    /*
    Увімкнути діагностику функцій, кількість аргументів яких менша за кількість параметрів.
    */
    "missing-parameter": "Warning",
    /*
    Увімкнути діагностику функцій, де відсутній `return`.
    */
    "missing-return": "Warning",
    /*
    Увімкнути діагностику функцій, де `return` не повертає значення.
    */
    "missing-return-value": "Warning",
    /*
    Увімкнути діагностику стилів назв.
    */
    "name-style-check": "Warning",
    /*
    Увімкнути діагностику використання змінних, яким раніше було присвоєно `nil` або значення, яке може бути `nil`.
    */
    "need-check-nil": "Warning",
    /*
    Увімкнути діагностику функцій у полях таблиці, дужки яких починаються з нового рядка.
    */
    "newfield-call": "Warning",
    /*
    Увімкнути діагностику викликів функцій з нового рядка. Спрацьовує, коли зустрічається рядок, який починається з `(`, що парситься як виклик функції на попередньому рядку.
    */
    "newline-call": "Warning",
    /*
    Увімкнути діагностику типів, які не можна вивести.
    */
    "no-unknown": "Warning",
    /*
    Увімкнути діагностику недозволених викликів `coroutine.yield()`.
    */
    "not-yieldable": "Warning",
    /*
    Увімкнути діагностику викликів функцій, де наданий тип не збігається з анотованим.
    */
    "param-type-mismatch": "Warning",
    /*
    Увімкнути діагностику перевизначених локальних змінних.
    */
    "redefined-local": "Hint",
    /*
    Увімкнути діагностику непотрібних параметрів функцій.
    */
    "redundant-parameter": "Warning",
    /*
    Увімкнути діагностику функцій, які мають зайвий `return`.
    */
    "redundant-return": "Hint",
    /*
    Увімкнути діагностику `return`, що повертає додаткове значення, яке не передбачене анотацією.
    */
    "redundant-return-value": "Warning",
    /*
    Увімкнути діагностику надлишкових присвоєних значень.
    */
    "redundant-value": "Warning",
    /*
    Увімкнути діагностику `return`, що повертає значення, тип якого не збігається з анотованим.
    */
    "return-type-mismatch": "Warning",
    /*
    Увімкнути діагностику одруків у рядках.
    */
    "spell-check": "Information",
    /*
    Увімкнути діагностику пробілів у кінці.
    */
    "trailing-space": "Hint",
    /*
    Увімкнути діагностику кількох присвоєнь, де не всі змінні отримують значення (наприклад, `local x,y = 1`).
    */
    "unbalanced-assignments": "Warning",
    /*
    Увімкнути діагностику анотацій класів, що вказують на невизначений клас.
    */
    "undefined-doc-class": "Warning",
    /*
    Увімкнути діагностику анотацій типів, що вказують на невизначений тип або аліас.
    */
    "undefined-doc-name": "Warning",
    /*
    Увімкнути діагностику анотацій параметра без самого параметра.
    */
    "undefined-doc-param": "Warning",
    /*
    Увімкнути діагностику невизначеної змінної оточення. Спрацьовує, коли таблиця присвоює собі `_ENV`, але глобальна змінна не існує.
    */
    "undefined-env-child": "Information",
    /*
    Увімкнути діагностику випадків читання невизначеного поля змінної.
    */
    "undefined-field": "Warning",
    /*
    Увімкнути діагностику невизначених глобальних змінних.
    */
    "undefined-global": "Warning",
    /*
    Увімкнути діагностику кастів невизначених змінних.
    */
    "unknown-cast-variable": "Warning",
    /*
    Увімкнути діагностику випадків невідомого коду.
    */
    "unknown-diag-code": "Warning",
    /*
    Увімкнути діагностику невідомих операторів.
    */
    "unknown-operator": "Warning",
    /*
    Увімкнути діагностику недоступного коду.
    */
    "unreachable-code": "Hint",
    /*
    Увімкнути діагностику невикористаних функцій.
    */
    "unused-function": "Hint",
    /*
    Увімкнути діагностику невикористаних міток.
    */
    "unused-label": "Hint",
    /*
    Увімкнути діагностику невикористаних локальних змінних.
    */
    "unused-local": "Hint",
    /*
    Увімкнути діагностику невикористаних `vararg`.
    */
    "unused-vararg": "Hint"
}
```

# diagnostics.unusedLocalExclude

Не діагностувати за невикористаною локальною змінною, коли назва змінної збігається з наданим паттерном.

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[]
```

# diagnostics.workspaceDelay

Затримка діагностики робочого простору (у мілісекундах).

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
3000
```

# diagnostics.workspaceEvent

Коли запускати діагностику робочого простору?

## Тип

```ts
string
```

## Опції

* ``"OnChange"``: Запустити діагностику робочого простору після зміни файлу.
* ``"OnSave"``: Запустити діагностику робочого простору, коли файл збережено.
* ``"None"``: Вимкнути діагностику робочого простору.

## За замовчуванням

```jsonc
"OnSave"
```

# diagnostics.workspaceRate

Швидкість діагностики робочого простору (у відсотках). Зменшення цього значення зменшує використання процесора, але також і швидкість діагностики. Діагностування відкритого файлу завжди працює на максимальній швидкості і не залежить від цього налаштування.

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
100
```

# doc.packageName

Трактувати специфічні поля як пакет. Наприклад, `m_*` означає, що `XXX.m_id` та `XXX.m_type` є пакетом. Доступ обмежений їх файлом.

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[]
```

# doc.privateName

Трактувати специфічні поля як приватні. Наприклад, `m_*` означає, що `XXX.m_id` та `XXX.m_type` приватні. Доступ обмежений їх класом.

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[]
```

# doc.protectedName

Трактувати специфічні поля як захищені. Наприклад, `m_*` означає, що `XXX.m_id` та `XXX.m_type` захищені. Доступ обмежений їх класом та підкласами.

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[]
```

# doc.regengine

Механізм регулярного виразу для порівняння з іменами областей видимості.

## Тип

```ts
string
```

## Опції

* ``"glob"``: Спрощений синтаксис паттернів.
* ``"lua"``: Повний регулярний вираз у стилі `Lua`.

## За замовчуванням

```jsonc
"glob"
```

# docScriptPath

Механізм регулярного виразу для порівняння з іменами областей видимості.

## Тип

```ts
string
```

## За замовчуванням

```jsonc
""
```

# format.defaultConfig

Класична конфігурація форматування.

Має нижчий пріоритет, ніж файл `.editorconfig`.

Прочитайте [документацію форматування](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs), щоб зрозуміти, як користуватись.


## Тип

```ts
Object<string, string>
```

## За замовчуванням

```jsonc
{}
```

# format.enable

Увімкнути форматування коду.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# hint.arrayIndex

Показувати індекси під час створення таблиці.

## Тип

```ts
string
```

## Опції

* ``"Enable"``: Підказки відображаються у всіх таблицях.
* ``"Auto"``: Показувати підказки тільки якщо таблиця містить більше ніж три елементи або якщо таблиця змішана.
* ``"Disable"``: Вимкнути підказки для індексів.

## За замовчуванням

```jsonc
"Auto"
```

# hint.await

Функція, що позначена як `---@async`, вимагає `await` для виклику.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# hint.awaitPropagate

Увімкнути поширення `await`. Коли одна функція викликає іншу, що позначена як `---@async`,вона також позначиться як `---@async`.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# hint.enable

Увімкнути підказки.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# hint.paramName

Показувати назви параметрів функції.

## Тип

```ts
string
```

## Опції

* ``"All"``: Показувати усі типи параметрів.
* ``"Literal"``: Показувати тільки літеральні типи параметрів.
* ``"Disable"``: Вимкнути підказки для параметрів.

## За замовчуванням

```jsonc
"All"
```

# hint.paramType

Показувати тип параметрів функції.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# hint.semicolon

Візуально показати крапку з комою, якщо її немає у кінці інструкції.

## Тип

```ts
string
```

## Опції

* ``"All"``: Усі інструкції закінчуються візуальною крапкою з комою.
* ``"SameLine"``: Коли дві (або більше) інструкції знаходяться на одному рядку, показати крапку з комою між ними.
* ``"Disable"``: Вимкнути показ крапки з комою.

## За замовчуванням

```jsonc
"SameLine"
```

# hint.setType

Показувати тип присвоєння.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# hover.enable

Увімкнути підказки при наведенні.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# hover.enumsLimit

Обмежити кількість типів значень, якщо їх декілька.

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
5
```

# hover.expandAlias

Чи розгортати аліас?

Наприклад, з `---@alias myType boolean|number` отримаємо `boolean|number`.

Інакше результатом буде `myType`.


## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# hover.previewFields

Максимальна кількість полів таблиці у вікні підказки.

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
10
```

# hover.viewNumber

При наведенні курсора на число у недесятковому форматі показувати його звичайне значення.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# hover.viewString

При наведенні курсора на рядок з `escape`-послідовностями відображати його інтерпретований вміст.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# hover.viewStringMax

Максимальна довжина тексту при перегляді рядка.

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
1000
```

# language.completeAnnotation

Вставляти `"---@ "` після розриву рядка, користуючись анотацією (тільки для VSCode).

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# language.fixIndent

Виправляти зайві відступи (тільки для `VSCode`).

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# misc.executablePath

Дозволити визначати шлях виконуваного файлу в `VSCode`.

## Тип

```ts
string
```

## За замовчуванням

```jsonc
""
```

# misc.parameters

[Параметри командного рядка](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) при старті мовного сервера в `VSCode`.

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[]
```

# nameStyle.config

Установити правила іменування.

Прочитайте [документацію форматування](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs), щоб зрозуміти, як користуватись.


## Тип

```ts
Object<string, string | array>
```

## За замовчуванням

```jsonc
{}
```

# runtime.builtin

Налаштувати стан вбудованої бібліотеки.

Можна вимкнути (або перевизначити) відсутню бібліотеку згідно з оточенням рантайму.

* `default`: стан залежить від версії рантайму
* `enable`: завжди увімкнено
* `disable`: завжди вимкнуто


## Тип

```ts
object<string, string>
```

## Опції

* ``"default"``
* ``"enable"``
* ``"disable"``

## За замовчуванням

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

Увімкнути підтримку синтаксису `LuaJIT` (потрібно встановити значення `LuaJIT` для `Lua.runtime.version`).

Також можна власноруч додати потрібне розширення синтаксису за допомогою `Lua.runtime.nonstandardSymbol`.


## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# runtime.fileEncoding

Кодування файлу. Опція `ansi` доступна тільки на `Windows`.

## Тип

```ts
string
```

## Опції

* ``"utf8"``
* ``"ansi"``
* ``"utf16le"``
* ``"utf16be"``

## За замовчуванням

```jsonc
"utf8"
```

# runtime.meta

Формат з назвою директорії для метафайлів.

## Тип

```ts
string
```

## За замовчуванням

```jsonc
"${version} ${language} ${encoding}"
```

# runtime.nonstandardSymbol

Увімкнути підтримку нестандартних символів.

## Тип

```ts
Array<string>
```

## Опції

* ``"//"``: Однорядковий коментар (у стилі `C`).
* ``"/**/"``: Блоковий коментар (у стилі `C`).
* ``"`"``: Рядковий літерал у зворотних лапках.
* ``"+="``: Додавання з присвоєнням.
* ``"-="``: Віднімання з присвоєнням.
* ``"*="``: Множення з присвоєнням.
* ``"/="``: Ділення з присвоєнням.
* ``"%="``: Остача від ділення з присвоєнням.
* ``"^="``: Піднесення до степеня з присвоєнням.
* ``"//="``: Ділення з округленням до низу та присвоєнням.
* ``"|="``: Побітовий `OR` з присвоєнням.
* ``"&="``: Побітовий `AND` з присвоєнням.
* ``"<<="``: Зсув ліворуч з присвоєнням.
* ``">>="``: Зсув праворуч з присвоєнням.
* ``"||"``: Логічне `OR`.
* ``"&&"``: Логічне `AND`.
* ``"!"``: Логічне `NOT`.
* ``"!="``: Не дорівнює.
* ``"continue"``: Ключове слово `continue`.
* ``"|lambda|"``: Анонімна функція.
* ``"?."``: Безпечна навігація (поле/метод: `a?.b` / `obj?.:method()` / `obj:method?.()`).
* ``"?.("``: Безпечна навігація з викликом (`f?.()` / `f?."str"` / `f?.{...}` / `f?.[[...]]`).
* ``"?.["``: Безпечна навігація з індексом (`t?.[key]`).
* ``"??"``: Об'єднання з `nil` (`a ?? b`; обирає `b`, лише якщо `a` — це `nil`).
* ``"ternary"``: Тернарний оператор (`cond ? x : y`).
* ``"~>>"``: Арифметичний зсув праворуч (`a ~>> b`, специфічний для `LuaJIT`; звичайний `>>` є логічним зсувом).
* ``"~>>="``: Арифметичний зсув праворуч з присвоєнням (`a ~>>= b`).
* ``"..="``: Об'єднання рядка з присвоєнням (`a ..= b`).
* ``"~="``: Побітовий `XOR` з присвоєнням, лише для інструкцій (наприклад, `a ~= b` окремим рядком); у виразах це просто `не дорівнює`.
* ``"const"``: Оголошення `const`.
* ``"->"``: Стрілкова функція (`x -> expr` / `|x| -> expr` / `|| -> expr` / `-> do ... end`).
* ``"number_underscore"``: Підкреслення у числах (наприклад, `1_000`, `0x1_2`, `0b1_0`).
* ``"?("``: Опціональний виклик без крапки (`f?()` еквівалентний `f?.()`; конфліктує з парсингом тернарного оператора (`ternary`), не рекомендується використовувати).
* ``"?["``: Опціональний індекс без крапки (`t?[1]` еквівалентний `t?.[1]`; конфліктує з парсингом тернарного оператора (`ternary`), не рекомендується використовувати).
* ``"?:"``: Безпечний метод без крапки (`obj?:get()` еквівалентний `obj?.:get()`).

## За замовчуванням

```jsonc
[]
```

# runtime.path

`require` потрібно знайти файл за вказаною назвою, але як йому це зробити?

Встановивши значення `?/init.lua`, шукатиме у `${workspace}/myfile/init.lua`.

Якщо `runtime.pathStrict` має значення `false`, шукатиме у `${workspace}/**/myfile/init.lua`.

Якщо ви хочете завантажити файли ззовні робочого простору, налаштуйте `Lua.workspace.library`.


## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
["?.lua","?/init.lua"]
```

# runtime.pathStrict

Увімкнувши, `runtime.path` шукатиме лише у директоріях першого рівня. Для розуміння того, як це працює, дивіться `runtime.path`.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# runtime.plugin

Шлях плагіна. Можете прочитати [вікі](https://luals.github.io/wiki/plugins), щоб отримати додаткову інформацію.

## Тип

```ts
string | array
```

## За замовчуванням

```jsonc
null
```

# runtime.pluginArgs

Додаткові аргументи для плагіна.

## Тип

```ts
array | object
```

## За замовчуванням

```jsonc
null
```

# runtime.special

Користувацькі глобальні змінні трактуються як спеціальні вбудовані змінні, для яких мовний сервер забезпечує спеціальну підтримку.

Наведений приклад показує, що `include` обробляється як `require`.
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```


## Тип

```ts
Object<string, string>
```

## За замовчуванням

```jsonc
{}
```

# runtime.unicodeName

Дозволити використання символів Юнікоду.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# runtime.version

Версія рантайму `Lua`.

## Тип

```ts
string
```

## Опції

* ``"Lua 5.1"``
* ``"Lua 5.2"``
* ``"Lua 5.3"``
* ``"Lua 5.4"``
* ``"Lua 5.5"``
* ``"LuaJIT"``

## За замовчуванням

```jsonc
"Lua 5.4"
```

# semantic.annotation

Підсвічування анотацій типів.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# semantic.enable

Увімкнути підсвічування. Потрібно встановити `true` у `editor.semanticHighlighting.enabled`.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# semantic.keyword

Підсвічування ключових слів, літералів, операторів. Використовуйте тільки тоді, якщо ваш редактор коду не має підсвічування.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# semantic.variable

Підсвічування змінних, полів, параметрів.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# signatureHelp.enable

Увімкнути сигнатурну підтримку.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# spell.dict

Слова для перевірки одруків.

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[]
```

# type.castNumberToInteger

Дозволити каст `number` до `integer`.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# type.checkTableShape

Жорстко перевіряє структуру таблиці.


## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# type.inferParamType

Якщо параметр неописаний, він виводиться з місць виклику функції.

Тип параметра стає `any`, якщо ви поставили `false`.


## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# type.inferTableSize

Максимальна кількість полів у таблиці, що аналізуватимуться під час виведення типів.

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
10
```

# type.maxUnionVariants

**Опис відсутній!!**

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
0
```

# type.weakNilCheck

Ігнорувати `nil` під час перевірки об'єднаного типу.

У разі `false`, тип `number|nil` не може призначитись типу `number`.


## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# type.weakUnionCheck

Значення відповідає умові, якщо хоча б один тип з `union` її задовольняє.

`false` означає, що тип `number|boolean` не може бути присвоєний типу `number`.


## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
false
```

# typeFormat.config

Налаштування поведінки форматування під час написання коду.

## Тип

```ts
object<string, string>
```

## За замовчуванням

```jsonc
{
    /*
    Автоматично додає `end`.
    */
    "auto_complete_end": "true",
    /*
    Автоматично додає роздільник у кінці таблиці.
    */
    "auto_complete_table_sep": "true",
    /*
    Автоматично форматує рядок.
    */
    "format_line": "true"
}
```

# window.progressBar

Показувати індикатор прогресу.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# window.statusBar

Показувати статус розширення у панелі стану.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# workspace.checkThirdParty

Автоматичне виявлення та адаптація сторонніх бібліотек.

Наразі підтримуються:

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass


## Тип

```ts
string | boolean
```

## За замовчуванням

```jsonc
null
```

# workspace.ignoreDir

Ігнорувати файли та директорії (використовуйте граматику `.gitignore`).

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[".vscode"]
```

# workspace.ignoreSubmodules

Ігнорувати підмодулі.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# workspace.library

Звідки будуть завантажуватися файли?

Файли у цих директоріях розглядатимуться як бібліотеки, надані ззовні.

Певні функції не змінюватимуть ці файли (наприклад, перейменування полів).

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[]
```

# workspace.maxPreload

Максимальна кількість файлів попереднього завантаження.

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
5000
```

# workspace.preloadFileSize

Пропустити файли під час попереднього завантаження, розмір яких більше за вказане значення (у кілобайтах).

## Тип

```ts
integer
```

## За замовчуванням

```jsonc
500
```

# workspace.useGitIgnore

Ігнорувати список файлів у `.gitignore`.

## Тип

```ts
boolean
```

## За замовчуванням

```jsonc
true
```

# workspace.userThirdParty

Шляхи конфігурацій сторонніх бібліотек. Посилайтеся на вбудований [шлях конфігурації](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)

## Тип

```ts
Array<string>
```

## За замовчуванням

```jsonc
[]
```