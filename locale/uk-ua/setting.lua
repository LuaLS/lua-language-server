---@diagnostic disable: undefined-global

config.addonManager.enable        =
"Чи увімкнений менеджер розширень?"
config.addonManager.repositoryBranch =
"Гілка `git`, яку використовуватиме менеджер розширень."
config.addonManager.repositoryPath =
"Шлях `git`, який використовуватиме менеджер розширень."
config.addonRepositoryPath        =
"Шлях репозиторію розширень (не пов'язаний з менеджером розширень)."
config.runtime.version            =
"Версія рантайму `Lua`."
config.runtime.path               =
[[
`require` потрібно знайти файл за вказаною назвою, але як йому це зробити?

Встановивши значення `?/init.lua`, шукатиме у `${workspace}/myfile/init.lua`.

Якщо `runtime.pathStrict` має значення `false`, шукатиме у `${workspace}/**/myfile/init.lua`.

Якщо ви хочете завантажити файли ззовні робочого простору, налаштуйте `Lua.workspace.library`.
]]
config.runtime.pathStrict         =
'Увімкнувши, `runtime.path` шукатиме лише у директоріях першого рівня. Для розуміння того, як це працює, дивіться `runtime.path`.'
config.runtime.special            =
[[
Користувацькі глобальні змінні трактуються як спеціальні вбудовані змінні, для яких мовний сервер забезпечує спеціальну підтримку.

Наведений приклад показує, що `include` обробляється як `require`.

```json
"Lua.runtime.special" : {
    "include" : "require"
}
```
]]
config.runtime.unicodeName        =
"Дозволити використання символів Юнікоду."
config.runtime.nonstandardSymbol  =
"Увімкнути підтримку нестандартних символів."
config.runtime.nonstandardSymbol['?.'] =
"Безпечна навігація (поле/метод: `a?.b` / `obj?.:method()` / `obj:method?.()`)."
config.runtime.nonstandardSymbol['?.('] =
"Безпечна навігація з викликом (`f?.()` / `f?.\"str\"` / `f?.{...}` / `f?.[[...]]`)."
config.runtime.nonstandardSymbol['?.['] =
"Безпечна навігація з індексом (`t?.[key]`)."
config.runtime.nonstandardSymbol['?('] =
"Опціональний виклик без крапки (`f?()` еквівалентний `f?.()`; конфліктує з парсингом тернарного оператора (`ternary`), не рекомендується використовувати)."
config.runtime.nonstandardSymbol['?['] =
"Опціональний індекс без крапки (`t?[1]` еквівалентний `t?.[1]`; конфліктує з парсингом тернарного оператора (`ternary`), не рекомендується використовувати)."
config.runtime.nonstandardSymbol['??'] =
"Об'єднання з `nil` (`a ?? b`; обирає `b`, лише якщо `a` — це `nil`)."
config.runtime.nonstandardSymbol['ternary'] =
"Тернарний оператор (`cond ? x : y`)."
config.runtime.nonstandardSymbol['?:'] =
"Безпечний метод без крапки (`obj?:get()` еквівалентний `obj?.:get()`)."
config.runtime.nonstandardSymbol['~>>'] =
"Арифметичний зсув праворуч (`a ~>> b`, специфічний для `LuaJIT`; звичайний `>>` є логічним зсувом)."
config.runtime.nonstandardSymbol['~>>='] =
"Арифметичний зсув праворуч з присвоєнням (`a ~>>= b`)."
config.runtime.nonstandardSymbol['..='] =
"Об'єднання рядка з присвоєнням (`a ..= b`)."
config.runtime.nonstandardSymbol['~='] =
"Побітовий `XOR` з присвоєнням, лише для інструкцій (наприклад, `a ~= b` окремим рядком); у виразах це просто `не дорівнює`."
config.runtime.nonstandardSymbol['const'] =
"Оголошення `const`."
config.runtime.nonstandardSymbol['->'] =
"Стрілкова функція (`x -> expr` / `|x| -> expr` / `|| -> expr` / `-> do ... end`)."
config.runtime.nonstandardSymbol['number_underscore'] =
"Підкреслення у числах (наприклад, `1_000`, `0x1_2`, `0b1_0`)."
config.runtime.nonstandardSymbol['//'] =
"Однорядковий коментар (у стилі `C`)."
config.runtime.nonstandardSymbol['/**/'] =
"Блоковий коментар (у стилі `C`)."
config.runtime.nonstandardSymbol['`'] =
"Рядковий літерал у зворотних лапках."
config.runtime.nonstandardSymbol['+='] =
"Додавання з присвоєнням."
config.runtime.nonstandardSymbol['-='] =
"Віднімання з присвоєнням."
config.runtime.nonstandardSymbol['*='] =
"Множення з присвоєнням."
config.runtime.nonstandardSymbol['/='] =
"Ділення з присвоєнням."
config.runtime.nonstandardSymbol['%='] =
"Остача від ділення з присвоєнням."
config.runtime.nonstandardSymbol['^='] =
"Піднесення до степеня з присвоєнням."
config.runtime.nonstandardSymbol['//='] =
"Ділення з округленням до низу та присвоєнням."
config.runtime.nonstandardSymbol['|='] =
"Побітовий `OR` з присвоєнням."
config.runtime.nonstandardSymbol['&='] =
"Побітовий `AND` з присвоєнням."
config.runtime.nonstandardSymbol['<<='] =
"Зсув ліворуч з присвоєнням."
config.runtime.nonstandardSymbol['>>='] =
"Зсув праворуч з присвоєнням."
config.runtime.nonstandardSymbol['||'] =
"Логічне `OR`."
config.runtime.nonstandardSymbol['&&'] =
"Логічне `AND`."
config.runtime.nonstandardSymbol['!'] =
"Логічне `NOT`."
config.runtime.nonstandardSymbol['!='] =
"Не дорівнює."
config.runtime.nonstandardSymbol['continue'] =
"Ключове слово `continue`."
config.runtime.nonstandardSymbol['|lambda|'] =
"Анонімна функція."
config.runtime.enableLuaJITExtensions =
[[
Увімкнути підтримку синтаксису `LuaJIT` (потрібно встановити значення `LuaJIT` для `Lua.runtime.version`).

Також можна власноруч додати потрібне розширення синтаксису за допомогою `Lua.runtime.nonstandardSymbol`.
]]
config.runtime.plugin             =
"Шлях плагіна. Можете прочитати [вікі](https://luals.github.io/wiki/plugins), щоб отримати додаткову інформацію."
config.runtime.pluginArgs         =
"Додаткові аргументи для плагіна."
config.runtime.fileEncoding       =
"Кодування файлу. Опція `ansi` доступна тільки на `Windows`."
config.runtime.builtin            =
[[
Налаштувати стан вбудованої бібліотеки. 

Можна вимкнути (або перевизначити) відсутню бібліотеку згідно з оточенням рантайму.

* `default`: стан залежить від версії рантайму
* `enable`: завжди увімкнено
* `disable`: завжди вимкнуто
]]
config.runtime.meta               =
'Формат з назвою директорії для метафайлів.'
config.diagnostics.enable         =
"Увімкнути діагностику."
config.diagnostics.disable        =
"Вимкнути діагностику."
config.diagnostics.globals        =
"Визначені глобальні змінні."
config.diagnostics.globalsRegex   =
"Знайти визначені глобальні змінні за допомогою регулярного виразу."
config.diagnostics.severity       =
[[
Змінити суворість діагностики.

`!` у кінці перевизначає групове налаштування `diagnostics.groupSeverity`.
]]
config.diagnostics.neededFileStatus =
[[
* Opened:  діагностувати тільки відкриті файли
* Any:     діагностувати усі файли
* None:    вимкнути діагностику

`!` у кінці перевизначає групове налаштування `diagnostics.groupFileStatus`.
]]
config.diagnostics.groupSeverity  =
[[
Змінити суворість діагностики всієї групи.

`Fallback` означає, що діагностика групи контролюється окремо за допомогою `diagnostics.severity`.

Перевизначає індивідуальні налаштування, якщо ті не мають `!` у кінці.
]]
config.diagnostics.groupFileStatus =
[[
Змінити стан файлу, що потребує діагностики всієї групи.

* Opened:  діагностувати тільки відкриті файли
* Any:     діагностувати усі файли
* None:    вимкнути діагностику

`Fallback` означає, що діагностика групи контролюється окремо за допомогою `diagnostics.neededFileStatus`.

Перевизначає індивідуальні налаштування, якщо ті не мають `!` у кінці.
]]
config.diagnostics.workspaceEvent =
"Коли запускати діагностику робочого простору?"
config.diagnostics.workspaceEvent.OnChange =
"Запустити діагностику робочого простору після зміни файлу."
config.diagnostics.workspaceEvent.OnSave =
"Запустити діагностику робочого простору, коли файл збережено."
config.diagnostics.workspaceEvent.None =
"Вимкнути діагностику робочого простору."
config.diagnostics.workspaceDelay =
"Затримка діагностики робочого простору (у мілісекундах)."
config.diagnostics.workspaceRate  =
"Швидкість діагностики робочого простору (у відсотках). Зменшення цього значення зменшує використання процесора, але також і швидкість діагностики. Діагностування відкритого файлу завжди працює на максимальній швидкості і не залежить від цього налаштування."
config.diagnostics.libraryFiles   =
"Як діагностувати файли у `Lua.workspace.library`?"
config.diagnostics.libraryFiles.Enable   =
"Завжди діагностувати."
config.diagnostics.libraryFiles.Opened   =
"Діагностувати лише відкриті файли."
config.diagnostics.libraryFiles.Disable  =
"Вимкнути діагностику."
config.diagnostics.ignoredFiles   =
"Як діагностувати проігноровані файли?"
config.diagnostics.ignoredFiles.Enable   =
"Завжди діагностувати файли."
config.diagnostics.ignoredFiles.Opened   =
"Діагностувати тільки відкриті файли."
config.diagnostics.ignoredFiles.Disable  =
"Вимкнути діагностику."
config.diagnostics.disableScheme  =
'Не діагностувати файли, що використовують схему.'
config.diagnostics.validScheme  =
'Діагностувати файли, що використовують схему.'
config.diagnostics.unusedLocalExclude =
'Не діагностувати за невикористаною локальною змінною, коли назва змінної збігається з наданим паттерном.'
config.workspace.ignoreDir        =
"Ігнорувати файли та директорії (використовуйте граматику `.gitignore`)."-- .. example.ignoreDir,
config.workspace.ignoreSubmodules =
"Ігнорувати підмодулі."
config.workspace.useGitIgnore     =
"Ігнорувати список файлів у `.gitignore`."
config.workspace.maxPreload       =
"Максимальна кількість файлів попереднього завантаження."
config.workspace.preloadFileSize  =
"Пропустити файли під час попереднього завантаження, розмір яких більше за вказане значення (у кілобайтах)."
config.workspace.library          =
[[
Звідки будуть завантажуватися файли? 

Файли у цих директоріях розглядатимуться як бібліотеки, надані ззовні.

Певні функції не змінюватимуть ці файли (наприклад, перейменування полів).
]]
config.workspace.dofileRoots      =
[[
Директорії, які `dofile` розглядатиме як можливий корінь. 

Файли у цих директоріях будуть завантажені миттєво.
]]
config.workspace.checkThirdParty  =
[[
Автоматичне виявлення та адаптація сторонніх бібліотек.

Наразі підтримуються:

* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]]
config.workspace.userThirdParty          =
'Шляхи конфігурацій сторонніх бібліотек. Посилайтеся на вбудований [шлях конфігурації](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)'
config.workspace.supportScheme           =
'Надати підтримку мовного сервера для файлів `Lua` за схемою.'
config.completion.enable                 =
'Увімкнути автодоповнення.'
config.completion.callSnippet            =
'Показувати приклад виклику функції.'
config.completion.callSnippet.Disable    =
"Показувати тільки назву функції."
config.completion.callSnippet.Both       =
"Показувати назву функції та приклад виклику."
config.completion.callSnippet.Replace    =
"Показувати тільки приклад виклику."
config.completion.keywordSnippet         =
'Показувати приклад синтаксису ключових слів.'
config.completion.keywordSnippet.Disable =
"Показувати тільки ключове слово."
config.completion.keywordSnippet.Both    =
"Показувати ключове слово та приклад синтаксису."
config.completion.keywordSnippet.Replace =
"Показувати тільки приклад синтаксису."
config.completion.displayContext         =
[[
Перегляд конкретного фрагмента коду.

Встановлене число вказує на захоплену кількість рядків коду для перегляду. 

`0` вимкне цю функцію.
]]
config.completion.workspaceWord          =
"Чи міститься відображене слово в інших файлах?"
config.completion.showWord               =
"Показувати пов'язані слова у підказках."
config.completion.showWord.Enable        =
"Увімкнути підказки."
config.completion.showWord.Fallback      =
"Показувати пов'язані слова, якщо семантичні підказки неможливі."
config.completion.showWord.Disable       =
"Вимкнути підказки."
config.completion.autoRequire            =
"Автоматично додавати `require`, якщо введення схоже на назву модуля."
config.completion.maxSuggestCount        =
"Максимальна кількість полів, що аналізуватиметься для автодоповнень. Коли об'єкт має більше полів, ніж ліміт, то щоб з'явились підказки, потрібне конкретніше введення."
config.completion.showParams             =
"Відображати параметри у списку автодоповнень. Якщо функція має кілька визначень, вони відображатимуться окремо."
config.completion.requireSeparator       =
"Роздільний символ для `require` (`.` або `/`)."
config.completion.postfix                =
"Символ для постфіксної підказки."
config.color.mode                        =
"Режим підсвічування."
config.color.mode.Semantic               =
"Семантичне підсвічування. Потрібно встановити `true` в `editor.semanticHighlighting.enabled`."
config.color.mode.SemanticEnhanced       =
"Покращене семантичне підсвічування. По суті звичайне, але з додатковим аналізом."
config.color.mode.Grammar                =
"Граматичне підсвічування."
config.semantic.enable                   =
"Увімкнути підсвічування. Потрібно встановити `true` у `editor.semanticHighlighting.enabled`."
config.semantic.variable                 =
"Підсвічування змінних, полів, параметрів."
config.semantic.annotation               =
"Підсвічування анотацій типів."
config.semantic.keyword                  =
"Підсвічування ключових слів, літералів, операторів. Використовуйте тільки тоді, якщо ваш редактор коду не має підсвічування."
config.signatureHelp.enable              =
"Увімкнути сигнатурну підтримку."
config.hover.enable                      =
"Увімкнути підказки при наведенні."
config.hover.viewString                  =
"При наведенні курсора на рядок з `escape`-послідовностями відображати його інтерпретований вміст."
config.hover.viewStringMax               =
"Максимальна довжина тексту при перегляді рядка."
config.hover.viewNumber                  =
"При наведенні курсора на число у недесятковому форматі показувати його звичайне значення."
config.hover.fieldInfer                  =
"Ліміт у мілісекундах на аналіз полів"
config.hover.previewFields               =
"Максимальна кількість полів таблиці у вікні підказки."
config.hover.enumsLimit                  =
"Обмежити кількість типів значень, якщо їх декілька."
config.hover.expandAlias                 =
[[
Чи розгортати аліас?

Наприклад, з `---@alias myType boolean|number` отримаємо `boolean|number`.

Інакше результатом буде `myType`.
]]
config.develop.enable                    =
'Режим розробника. Не вмикайте його, адже продуктивність суттєво знизиться.'
config.develop.debuggerPort              =
'Порт дебагера.'
config.develop.debuggerWait              =
'Зупинитись до підключення дебагера.'
config.intelliSense.searchDepth          =
'Встановити глибину `IntelliSense`. Збільшення значення покращує якість, але водночас споживатиметься більше ресурсів.'
config.intelliSense.fastGlobal           =
'Вимкнути автодоповнення з `_G`. Це знизить точність визначення типів, проте суттєво покращить продуктивність у проєктах, де багато глобальних змінних.'
config.window.statusBar                  =
'Показувати статус розширення у панелі стану.'
config.window.progressBar                =
'Показувати індикатор прогресу.'
config.hint.enable                       =
'Увімкнути підказки.'
config.hint.paramType                    =
'Показувати тип параметрів функції.'
config.hint.setType                      =
'Показувати тип присвоєння.'
config.hint.paramName                    =
'Показувати назви параметрів функції.'
config.hint.paramName.All                =
'Показувати усі типи параметрів.'
config.hint.paramName.Literal            =
'Показувати тільки літеральні типи параметрів.'
config.hint.paramName.Disable            =
'Вимкнути підказки для параметрів.'
config.hint.arrayIndex                   =
'Показувати індекси під час створення таблиці.'
config.hint.arrayIndex.Enable            =
'Підказки відображаються у всіх таблицях.'
config.hint.arrayIndex.Auto              =
'Показувати підказки тільки якщо таблиця містить більше ніж три елементи або якщо таблиця змішана.'
config.hint.arrayIndex.Disable           =
'Вимкнути підказки для індексів.'
config.hint.await                        =
'Функція, що позначена як `---@async`, вимагає `await` для виклику.'
config.hint.awaitPropagate               =
'Увімкнути поширення `await`. Коли одна функція викликає іншу, що позначена як `---@async`,\z
 вона також позначиться як `---@async`.'
config.hint.semicolon                    =
'Візуально показати крапку з комою, якщо її немає у кінці інструкції.'
config.hint.semicolon.All                =
'Усі інструкції закінчуються візуальною крапкою з комою.'
config.hint.semicolon.SameLine            =
'Коли дві (або більше) інструкції знаходяться на одному рядку, показати крапку з комою між ними.'
config.hint.semicolon.Disable            =
'Вимкнути показ крапки з комою.'
config.codeLens.enable                   =
'Увімкнути `Code Lens`.'
config.format.enable                     =
'Увімкнути форматування коду.'
config.format.defaultConfig              =
[[
Класична конфігурація форматування.

Має нижчий пріоритет, ніж файл `.editorconfig`.

Прочитайте [документацію форматування](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs), щоб зрозуміти, як користуватись.
]]
config.spell.dict                        =
'Слова для перевірки одруків.'
config.nameStyle.config                  =
[[
Установити правила іменування.

Прочитайте [документацію форматування](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs), щоб зрозуміти, як користуватись.
]]
config.telemetry.enable                  =
[[
Увімкнути телеметрію, щоб надсилати помилки та інформацію про ваш редактор коду.

Прочитайте нашу політику приватності [тут](https://luals.github.io/privacy/#language-server).
]]
config.misc.parameters                   =
'[Параметри командного рядка](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) при старті мовного сервера в `VSCode`.'
config.misc.executablePath               =
'Дозволити визначати шлях виконуваного файлу в `VSCode`.'
config.language.fixIndent                =
'Виправляти зайві відступи (тільки для `VSCode`).'
config.language.completeAnnotation       =
'Вставляти `"---@ "` після розриву рядка, користуючись анотацією (тільки для `VSCode`).'
config.type.castNumberToInteger          =
'Дозволити каст `number` до `integer`.'
config.type.weakUnionCheck               =
[[
Значення відповідає умові, якщо хоча б один тип з `union` її задовольняє.

`false` означає, що тип `number|boolean` не може бути присвоєний типу `number`.
]]
config.type.weakNilCheck                 =
[[
Ігнорувати `nil` під час перевірки об'єднаного типу.

У разі `false`, тип `number|nil` не може призначитись типу `number`.
]]
config.type.inferParamType               =
[[
Якщо параметр неописаний, він виводиться з місць виклику функції.

Тип параметра стає `any`, якщо ви поставили `false`.
]]
config.type.checkTableShape              =
'Жорстко перевіряє структуру таблиці.'
config.type.inferTableSize               =
'Максимальна кількість полів у таблиці, що аналізуватимуться під час виведення типів.'
config.doc.privateName                   =
'Трактувати специфічні поля як приватні. Наприклад, `m_*` означає, що `XXX.m_id` та `XXX.m_type` приватні. Доступ обмежений їх класом.'
config.doc.protectedName                 =
'Трактувати специфічні поля як захищені. Наприклад, `m_*` означає, що `XXX.m_id` та `XXX.m_type` захищені. Доступ обмежений їх класом та підкласами.'
config.doc.packageName                   =
'Трактувати специфічні поля як пакет. Наприклад, `m_*` означає, що `XXX.m_id` та `XXX.m_type` є пакетом. Доступ обмежений їх файлом.'
config.doc.regengine                     =
'Механізм регулярного виразу для порівняння з іменами областей видимості.'
config.doc.regengine.glob                =
'Спрощений синтаксис паттернів.'
config.doc.regengine.lua                 =
'Повний регулярний вираз у стилі `Lua`.'
config.docScriptPath                     =
'Механізм регулярного виразу для порівняння з іменами областей видимості.'
config.diagnostics['unused-local']          =
'Увімкнути діагностику невикористаних локальних змінних.'
config.diagnostics['unused-function']       =
'Увімкнути діагностику невикористаних функцій.'
config.diagnostics['undefined-global']      =
'Увімкнути діагностику невизначених глобальних змінних.'
config.diagnostics['global-in-nil-env']     =
'Увімкнути діагностику глобальних змінних (якщо `_ENV` має значення `nil`).'
config.diagnostics['unused-label']          =
'Увімкнути діагностику невикористаних міток.'
config.diagnostics['unused-vararg']         =
'Увімкнути діагностику невикористаних `vararg`.'
config.diagnostics['trailing-space']        =
'Увімкнути діагностику пробілів у кінці.'
config.diagnostics['redefined-local']       =
'Увімкнути діагностику перевизначених локальних змінних.'
config.diagnostics['newline-call']          =
'Увімкнути діагностику викликів функцій з нового рядка. Спрацьовує, коли зустрічається рядок, який починається з `(`, що парситься як виклик функції на попередньому рядку.'
config.diagnostics['newfield-call']         =
'Увімкнути діагностику функцій у полях таблиці, дужки яких починаються з нового рядка.'
config.diagnostics['redundant-parameter']   =
'Увімкнути діагностику непотрібних параметрів функцій.'
config.diagnostics['ambiguity-1']           =
'Увімкнути діагностику неоднозначного пріоритету операторів. Наприклад, на вираз `num or 0 + 1` буде запропоновано `(num or 0) + 1`.'
config.diagnostics['lowercase-global']      =
'Увімкнути діагностику глобальних змінних, що починаються з малої літери.'
config.diagnostics['undefined-env-child']   =
'Увімкнути діагностику невизначеної змінної оточення. Спрацьовує, коли таблиця присвоює собі `_ENV`, але глобальна змінна не існує.'
config.diagnostics['duplicate-index']       =
'Увімкнути діагностику дублювання індексів таблиці.'
config.diagnostics['empty-block']           =
'Увімкнути діагностику порожніх блоків коду.'
config.diagnostics['redundant-value']       =
'Увімкнути діагностику надлишкових присвоєних значень.'
config.diagnostics['assign-type-mismatch']  =
'Увімкнути діагностику присвоєння непов\'язаних між собою типів.'
config.diagnostics['await-in-sync']         =
'Увімкнути діагностику асинхронних викликів всередині звичайної функції.'
config.diagnostics['cast-local-type']    =
'Увімкнути діагностику кастів, де цільовий тип локальної змінної не відповідає вихідному.'
config.diagnostics['cast-type-mismatch']    =
'Увімкнути діагностику кастів, де цільовий тип не відповідає вихідному.'
config.diagnostics['circular-doc-class']    =
'Увімкнути діагностику циклічних зв\'язків між класами.'
config.diagnostics['close-non-object']      =
'Увімкнути діагностику спроб закрити змінну, яка не є об\'єктом.'
config.diagnostics['code-after-break']      =
'Увімкнути діагностику коду, що знаходиться після `break` у циклі.'
config.diagnostics['codestyle-check']       =
'Увімкнути діагностику невідповідного стилю коду.'
config.diagnostics['count-down-loop']       =
'Увімкнути діагностику циклів `for`, де лічильник рухається не в той бік.'
config.diagnostics['deprecated']            =
'Увімкнути діагностику застарілих `API`.'
config.diagnostics['different-requires']    =
'Увімкнути діагностику файлів, які імпортуються під різними назвами.'
config.diagnostics['discard-returns']       =
'Увімкнути діагностику ігнорування результатів функцій, позначених анотацією `---@nodiscard`.'
config.diagnostics['doc-field-no-class']    =
'Увімкнути діагностику анотацій полів, що не мають анотацій класу.'
config.diagnostics['duplicate-doc-alias']   =
'Увімкнути діагностику дублювання анотацій аліасу.'
config.diagnostics['duplicate-doc-field']   =
'Увімкнути діагностику дублювання анотацій поля.'
config.diagnostics['duplicate-doc-param']   =
'Увімкнути діагностику дублювання анотацій параметру.'
config.diagnostics['duplicate-set-field']   =
'Увімкнути діагностику повторного встановлення поля того самого класу.'
config.diagnostics['incomplete-signature-doc']    =
'Увімкнути діагностику неповних анотацій `@param` та `@return`.'
config.diagnostics['invisible']             =
'Увімкнути діагностику спроб доступу до невидимих полів.'
config.diagnostics['missing-global-doc']    =
'Відсутні анотації для глобальних функцій! Вони повинні мати коментар та анотацію для параметрів і значень, які повертає функція.'
config.diagnostics['missing-local-export-doc'] =
'Відсутні анотації для експортованих локальних функцій! Вони повинні мати коментар та анотацію для параметрів і значень, які повертає функція.'
config.diagnostics['missing-parameter']     =
'Увімкнути діагностику функцій, кількість аргументів яких менша за кількість параметрів.'
config.diagnostics['missing-return']        =
'Увімкнути діагностику функцій, де відсутній `return`.'
config.diagnostics['missing-return-value']  =
'Увімкнути діагностику функцій, де `return` не повертає значення.'
config.diagnostics['need-check-nil']        =
'Увімкнути діагностику використання змінних, яким раніше було присвоєно `nil` або значення, яке може бути `nil`.'
config.diagnostics['unnecessary-assert']    =
'Увімкнути діагностику безкорисних `assert`.'
config.diagnostics['no-unknown']            =
'Увімкнути діагностику типів, які не можна вивести.'
config.diagnostics['not-yieldable']         =
'Увімкнути діагностику недозволених викликів `coroutine.yield()`.'
config.diagnostics['param-type-mismatch']   =
'Увімкнути діагностику викликів функцій, де наданий тип не збігається з анотованим.'
config.diagnostics['redundant-return']      =
'Увімкнути діагностику функцій, які мають зайвий `return`.'
config.diagnostics['redundant-return-value']=
'Увімкнути діагностику `return`, що повертає додаткове значення, яке не передбачене анотацією.'
config.diagnostics['return-type-mismatch']  =
'Увімкнути діагностику `return`, що повертає значення, тип якого не збігається з анотованим.'
config.diagnostics['spell-check']           =
'Увімкнути діагностику одруків у рядках.'
config.diagnostics['name-style-check']      =
'Увімкнути діагностику стилів назв.'
config.diagnostics['unbalanced-assignments']=
'Увімкнути діагностику кількох присвоєнь, де не всі змінні отримують значення (наприклад, `local x,y = 1`).'
config.diagnostics['undefined-doc-class']   =
'Увімкнути діагностику анотацій класів, що вказують на невизначений клас.'
config.diagnostics['undefined-doc-name']    =
'Увімкнути діагностику анотацій типів, що вказують на невизначений тип або аліас.'
config.diagnostics['undefined-doc-param']   =
'Увімкнути діагностику анотацій параметра без самого параметра.'
config.diagnostics['undefined-field']       =
'Увімкнути діагностику випадків читання невизначеного поля змінної.'
config.diagnostics['unknown-cast-variable'] =
'Увімкнути діагностику кастів невизначених змінних.'
config.diagnostics['unknown-diag-code']     =
'Увімкнути діагностику випадків невідомого коду.'
config.diagnostics['unknown-operator']      =
'Увімкнути діагностику невідомих операторів.'
config.diagnostics['unreachable-code']      =
'Увімкнути діагностику недоступного коду.'
config.diagnostics['global-element']       =
'Увімкнути діагностику глобальних елементів.'
config.diagnostics['action-after-return'] =
'Код після `return`'
config.diagnostics['ambiguous-syntax'] =
'Неоднозначний синтаксис'
config.diagnostics['args-after-dots'] =
'Аргументи після `...`'
config.diagnostics['assign-const-global'] =
'Присвоєння константній глобальній змінній'
config.diagnostics['block-after-else'] =
'Блок після `else`'
config.diagnostics['break-outside'] =
'Використання `break` поза циклом'
config.diagnostics['circle-doc-class'] =
'Циклічне успадкування `@class`'
config.diagnostics['declare-const'] =
'Повторне визначення константи'
config.diagnostics['env-is-global'] =
'`_ENV` використано як глобальну змінну'
config.diagnostics['exp-in-action'] =
'Вираз використано як інструкцію'
config.diagnostics['global-close-attribute'] =
'Атрибут `close` у глобальній змінній'
config.diagnostics['index-in-func-name'] =
'Індекс в імені функції'
config.diagnostics['inject-field'] =
'Впровадження поля в об\'єкт'
config.diagnostics['jump-local-scope'] =
'Перехід у область видимості локальної змінної'
config.diagnostics['keyword'] =
'Неналежне використання ключового слова'
config.diagnostics['local-limit'] =
'Забагато локальних змінних'
config.diagnostics['lua-doc-miss-sign'] =
'Пропущений знак коментаря `LuaDoc`'
config.diagnostics['malformed-number'] =
'Некоректне число'
config.diagnostics['missing-fields'] =
'Пропущені поля'
config.diagnostics['multi-close'] =
'Неодноразова операція закриття'
config.diagnostics['need-paren'] =
'Потрібні дужки'
config.diagnostics['nesting-long-mark'] =
'Вкладені мітки довгих коментарів'
config.diagnostics['no-visible-label'] =
'Невидима мітка'
config.diagnostics['redefined-label'] =
'Перевизначена мітка'
config.diagnostics['set-const'] =
'Присвоєння константі'
config.diagnostics['unicode-name'] =
'Назва використовує Юнікод'
config.diagnostics['unknown-attribute'] =
'Невідомий атрибут'
config.diagnostics['unknown-symbol'] =
'Невідомий символ'
config.diagnostics['unsupport-named-vararg'] =
'Назва для `vararg` не підтримується'
config.diagnostics['variable-not-declared'] =
'Використання неоголошеної змінної'
config.typeFormat.config                    =
'Налаштування поведінки форматування під час написання коду.'
config.typeFormat.config.auto_complete_end  =
'Автоматично додає `end`.'
config.typeFormat.config.auto_complete_table_sep =
'Автоматично додає роздільник у кінці таблиці.'
config.typeFormat.config.format_line        =
'Автоматично форматує рядок.'

command.exportDocument =
'Lua: Експортувати документ ...'
command.addon_manager.open =
'Lua: Відкрити менеджер розширень ...'
command.reloadFFIMeta =
'Lua: Перезавантажити метадані `LuaJIT FFI`'
command.startServer =
'Lua: Перезапустити мовний сервер'
command.stopServer =
'Lua: Зупинити мовний сервер'
