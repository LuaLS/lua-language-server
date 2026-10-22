DIAG_LINE_ONLY_SPACE    =
'Рядок має тільки пробіли.'
DIAG_LINE_POST_SPACE    =
'Рядок завершується пробілом.'
DIAG_UNUSED_LOCAL       =
'Невикористана локальна змінна `{}`.'
DIAG_UNDEF_GLOBAL       =
'Невизначена глобальна змінна `{}`.'
DIAG_UNDEF_FIELD        =
'Невизначене поле `{}`.'
DIAG_UNDEF_ENV_CHILD    =
'Невизначена змінна `{}` (перевантажений `_ENV`).'
DIAG_UNDEF_FENV_CHILD   =
'Невизначена змінна `{}` (всередині модуля).'
DIAG_GLOBAL_IN_NIL_ENV  =
'Некоректна глобальна змінна (`_ENV` має значення `nil`).'
DIAG_GLOBAL_IN_NIL_FENV =
'Некоректна глобальна змінна (модуль оточення має значення `nil`).'
DIAG_UNUSED_LABEL       =
'Невикористана мітка `{}`.'
DIAG_UNUSED_FUNCTION    =
'Невикористана функція.'
DIAG_UNUSED_VARARG      =
'Невикористаний `vararg`.'
DIAG_REDEFINED_LOCAL    =
'Перевизначена локальна змінна `{}`.'
DIAG_DUPLICATE_INDEX    =
'Дублювання індексу `{}`.'
DIAG_DUPLICATE_METHOD   =
'Дублювання методу `{}`.'
DIAG_PREVIOUS_CALL      =
'Буде інтерпретовано як `{}{}`. Додайте кому.'
DIAG_PREFIELD_CALL      =
'Буде інтерпретовано як `{}{}`. Додайте кому або крапку з комою.'
DIAG_OVER_MAX_ARGS      =
'Максимальна кількість аргументів: {:d}; отримано: {:d}.'
DIAG_MISS_ARGS          =
'Очікувана кількість аргументів: {:d}; отримано: {:d}.'
DIAG_UNNECESSARY_ASSERT =
'Безкорисний `assert`.'
DIAG_OVER_MAX_VALUES    =
'Є лише {} змінних, але ви задали {} значень.'
DIAG_AMBIGUITY_1        =
'Спочатку обчисліть `{}`. Потрібно додати дужки.'
DIAG_LOWERCASE_GLOBAL   =
'Глобальна змінна починається з малої літери, ви забули ключове слово `local` або просто помилились?'

ASSIGN_CONST_GLOBAL     =
'Не можна присвоїти значення `const` глобальній змінній `{}`.'

VARIABLE_NOT_DECLARED   =
'Змінна `{}` не оголошена (глобальні оголошення активні).'

DIAG_EMPTY_BLOCK        =
'Порожній блок.'
DIAG_DIAGNOSTICS        =
'Діагностика `Lua`.'
DIAG_SYNTAX_CHECK       =
'Перевірка синтаксису `Lua`.'
DIAG_NEED_VERSION       =
'Підтримується у {}, поточне — {}.'
DIAG_DEFINED_VERSION    =
'Визначено у {}, поточне — {}.'
DIAG_DEFINED_CUSTOM     =
'Визначено у {}.'
DIAG_DUPLICATE_CLASS    =
'Дублювання класу `{}`.'
DIAG_UNDEFINED_CLASS    =
'Невизначений клас `{}`.'
DIAG_CYCLIC_EXTENDS     =
'Циклічне розширення.'
DIAG_INEXISTENT_PARAM   =
'Неіснуючий параметр.'
DIAG_DUPLICATE_PARAM    =
'Дублювання параметра.'
DIAG_NEED_CLASS         =
'Спочатку потрібно визначити клас.'
DIAG_DUPLICATE_SET_FIELD=
'Дублювання поля `{}`.'
DIAG_SET_CONST          =
'Присвоєння константі.'
DIAG_SET_FOR_STATE      =
'Присвоєння змінній циклу `for`.'
DIAG_CODE_AFTER_BREAK   =
'Неможливо виконати код після `break`.'
DIAG_UNBALANCED_ASSIGNMENTS =
'Значення змінної буде інтерпретовано як `nil`, адже ви не присвоїли їй значення власноруч. В `Lua` `x, y = 1 ` еквівалентно `x, y = 1, nil`.'
DIAG_REQUIRE_LIKE       =
'Ви можете використовувати `{}` як `require` за допомогою налаштувань.'
DIAG_CLOSE_NON_OBJECT    =
'Не можна закрити значення цього типу (але можна встановити метаметод `__close`).'
DIAG_COUNT_DOWN_LOOP    =
'Ви мали на увазі `{}`?'
DIAG_UNKNOWN            =
'Не можна вивести тип.'
DIAG_DEPRECATED         =
'Застаріло.'
DIAG_DIFFERENT_REQUIRES =
'Один і той самий файл імпортується під різними назвами.'
DIAG_REDUNDANT_RETURN   =
'Зайвий `return`.'
DIAG_AWAIT_IN_SYNC      =
'Асинхронна функція може викликатись лише в асинхронній функції.'
DIAG_NOT_YIELDABLE      =
'Параметр №{} функції не позначений таким, що може зупинитись, проте передано асинхронну функцію (використайте анотацію `---@param name async fun()`)'
DIAG_DISCARD_RETURNS    =
'Повернене функцією значення не можна ігнорувати.'
DIAG_NEED_CHECK_NIL     =
'Потребує перевірки на `nil`.'
DIAG_CIRCLE_DOC_CLASS                 =
'Циклічне успадкування класу.'
DIAG_DOC_FIELD_NO_CLASS               =
'Поле повинно визначатись після класу.'
DIAG_DUPLICATE_DOC_ALIAS              =
'Дублювання визначеного аліасу `{}`.'
DIAG_DUPLICATE_DOC_FIELD              =
'Дублювання визначеного поля `{}`.'
DIAG_DUPLICATE_DOC_PARAM              =
'Дублювання параметрів `{}`.'
DIAG_UNDEFINED_DOC_CLASS              =
'Невизначений клас `{}`.'
DIAG_UNDEFINED_DOC_NAME               =
'Невизначений тип або аліас `{}`.'
DIAG_UNDEFINED_DOC_PARAM              =
'Невизначений параметр `{}`.'
DIAG_MISSING_GLOBAL_DOC_COMMENT       =
'Пропущено коментар для глобальної функції `{}`.'
DIAG_MISSING_GLOBAL_DOC_PARAM         =
'Пропущена анотація `@param` для параметра `{}` у глобальній функції `{}`.'
DIAG_MISSING_GLOBAL_DOC_RETURN        =
'Пропущена анотація `@return` за індексом `{}` у глобальній функції `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_COMMENT  =
'Пропущено коментар для експортованої локальної функції `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_PARAM    =
'Пропущена анотація `@param` для параметра `{}` в експортованій локальній функції `{}`.'
DIAG_MISSING_LOCAL_EXPORT_DOC_RETURN   =
'Пропущена анотація `@return` за індексом `{}` в експортованій локальній функції `{}`.'
DIAG_INCOMPLETE_SIGNATURE_DOC_PARAM   =
'Неповна сигнатура. Пропущена анотація `@param` для параметра `{}`.'
DIAG_INCOMPLETE_SIGNATURE_DOC_RETURN  =
'Неповна сигнатура. Пропущена анотація `@return` за індексом `{}`.'
DIAG_UNKNOWN_DIAG_CODE                =
'Невідомий діагностичний код `{}`.'
DIAG_CAST_LOCAL_TYPE                  =
'Змінну визначено типом `{def}`, її неможливо конвертувати в `{ref}`.'
DIAG_CAST_FIELD_TYPE                  =
'Поле визначено типом `{def}`, його неможливо конвертувати в `{ref}`.'
DIAG_ASSIGN_TYPE_MISMATCH             =
'Не можна присвоїти значення `{ref}` типу `{def}`.'
DIAG_PARAM_TYPE_MISMATCH              =
'Не можна присвоїти значення `{ref}` параметру `{def}`.'
DIAG_UNKNOWN_CAST_VARIABLE            =
'Невідома змінна для касту до типу `{}`.'
DIAG_CAST_TYPE_MISMATCH               =
'Неможливо конвертувати `{def}` у `{ref}`.'
DIAG_MISSING_RETURN_VALUE             =
'Очікувана за анотацією кількість значень — {min}; повернуто лише {rmax}.'
DIAG_MISSING_RETURN_VALUE_RANGE       =
'Очікувана за анотацією кількість значень — {min}; повернуто від {rmin} до {rmax}.'
DIAG_REDUNDANT_RETURN_VALUE           =
'Очікувана за анотацією максимальна кількість значень — {max}; повернуто аж {rmax}.'
DIAG_REDUNDANT_RETURN_VALUE_RANGE     =
'Очікувана за анотацією максимальна кількість значень — {max}; повернуто від {rmin} до {rmax}.'
DIAG_MISSING_RETURN                   =
'За анотацією очікується повернення значення.'
DIAG_RETURN_TYPE_MISMATCH             =
'За анотацією очікується повернення значення #{index} з типом `{def}`, але натомість тип — `{ref}`.'
DIAG_UNKNOWN_OPERATOR                 =
'Невідомий оператор `{}`.'
DIAG_UNREACHABLE_CODE                 =
'Недоступний код.'
DIAG_INVISIBLE_PRIVATE                =
'Поле `{field}` приватне, доступ можливий лише у класі `{class}`.'
DIAG_INVISIBLE_PROTECTED              =
'Поле `{field}` захищене, доступ можливий лише у класі `{class}` та його підкласах.'
DIAG_INVISIBLE_PACKAGE                =
'Поле `{field}` може бути доступним лише в межах самого файлу `{uri}`.'
DIAG_GLOBAL_ELEMENT                   =
'Елемент є глобальним.'
DIAG_MISSING_FIELDS                   =
'Пропущені потрібні поля у типі `{1}`: {2}'
DIAG_INJECT_FIELD                     =
'Поля не можуть впровадитись у посилання `{class}` для `{field}`. {fix}'
DIAG_INJECT_FIELD_FIX_CLASS           =
'Використайте анотацію `---@class` для `{node}`.'
DIAG_INJECT_FIELD_FIX_TABLE           =
'Щоб уможливити впровадження, визначте `{fix}`.'

MWS_NOT_SUPPORT         =
'{} зараз не підтримує кілька робочих просторів. Потрібен перезапуск для підтримки нового робочого простору...'
MWS_RESTART             =
'Перезапуск'
MWS_NOT_COMPLETE        =
'Робочий простір ще не готовий, спробуйте пізніше...'
MWS_COMPLETE            =
'Робочий простір готовий'
MWS_MAX_PRELOAD         =
'Вичерпано ліміт для попередньо завантажених файлів ({}). Потрібно самостійно відкрити потрібні для завантаження файли.'
MWS_UCONFIG_FAILED      =
'Не вдалося зберегти налаштування користувача.'
MWS_UCONFIG_UPDATED     =
'Оновлено налаштування користувача.'
MWS_WCONFIG_UPDATED     =
'Оновлено налаштування робочого простору.'

WORKSPACE_SKIP_LARGE_FILE =
'Гігантський файл `{}` пропущено. Зараз ліміт — це `{}` кілобайтів, а розмір файлу — `{}` кілобайтів.'
WORKSPACE_LOADING         =
'Завантаження робочого простору'
WORKSPACE_DIAGNOSTIC      =
'Діагностування робочого простору'
WORKSPACE_SKIP_HUGE_FILE  =
'З міркувань продуктивності парсинг цього файлу було зупинено: {}'
WORKSPACE_NOT_ALLOWED     =
'Ваш робочий простір встановлено як `{}`. Мовний сервер `Lua` відмовив у завантаженні цієї директорії. Рекомендуємо перевірити конфігурацію. [Ось тут можна дізнатись більше](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)'
WORKSPACE_SCAN_TOO_MUCH   =
'Проскановано більше {} файлів. Просканована директорія — `{}`. Читайте [FAQ](https://luals.github.io/wiki/faq/#how-can-i-improve-startup-speeds), щоб зрозуміти, як підключити менше файлів. Також можливо, що ваша конфігурація [неправильна](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder).'

PARSER_CRASH            =
'Парсер впав! Його останні слова: `{}`'
PARSER_UNKNOWN          =
'Невідома синтаксична помилка...'
PARSER_MISS_NAME        =
'Очікується назва.'
PARSER_UNKNOWN_SYMBOL   =
'Неочікуваний символ `{symbol}`.'
PARSER_MISS_SYMBOL      =
'Пропущено символ `{symbol}`.'
PARSER_MISS_ESC_X       =
'Потрібні дві шістнадцяткові цифри.'
PARSER_UTF8_SMALL       =
'Потрібна щонайменше одна шістнадцяткова цифра.'
PARSER_UTF8_MAX         =
'Значення має бути в межах від {min} до {max}.'
PARSER_ERR_ESC          =
'Помилка екранування символів.'
PARSER_MUST_X16         =
'Повинні бути шістнадцяткові цифри.'
PARSER_MISS_EXPONENT    =
'Пропущено цифри для показника степеня.'
PARSER_MISS_EXP         =
'Пропущено вираз.'
PARSER_MISS_LOOP_MIN    =
'Пропущено початкове значення циклу.'
PARSER_MISS_LOOP_MAX    =
'Пропущено максимальне значення циклу.'
PARSER_MISS_FIELD       =
'Пропущено поле.'
PARSER_MISS_METHOD      =
'Пропущено метод.'
PARSER_ARGS_AFTER_DOTS  =
'`...` повинен бути останнім аргументом.'
PARSER_UNSUPPORT_NAMED_VARARG =
'Синтаксис `(...name)` підтримується лише у версії `{version}`.'
PARSER_KEYWORD          =
'Ключове слово не може використовуватись як назва.'
PARSER_EXP_IN_ACTION    =
'Неочікуваний вираз.'
PARSER_BREAK_OUTSIDE    =
'`break` знаходиться не в циклі.'
PARSER_MALFORMED_NUMBER =
'Некоректне число.'
PARSER_ACTION_AFTER_RETURN =
'Після `return` очікується кінець коду.'
PARSER_ACTION_AFTER_BREAK =
'Після `break` очікується кінець коду.'
PARSER_NO_VISIBLE_LABEL =
'Немає видимої мітки `{label}`.'
PARSER_REDEFINE_LABEL   =
'Мітка `{label}` вже визначена.'
PARSER_UNSUPPORT_SYMBOL =
'У версії `{version}` такий синтаксис не підтримується.'
PARSER_UNEXPECT_DOTS    =
'Не можна використовувати `...` ззовні `vararg` функції.'
PARSER_UNEXPECT_SYMBOL  =
'Неочікуваний символ `{symbol}`.'
PARSER_UNKNOWN_TAG      =
'Невідомий атрибут.'
PARSER_MULTI_TAG        =
'Кілька атрибутів не підтримуються.'
PARSER_UNEXPECT_LFUNC_NAME =
'Погана назва функції.'
PARSER_UNEXPECT_EFUNC_NAME =
'Функцію, оголошену як вираз, не можна іменувати.'
PARSER_ERR_LCOMMENT_END =
'Багаторядкова анотація повинна закриватись за допомогою `{symbol}`.'
PARSER_ERR_C_LONG_COMMENT =
'Слід використовувати `--[[ ]]` для багаторядкових коментарів.'
PARSER_ERR_LSTRING_END  =
'Довгий рядок повинен закриватись за допомогою `{symbol}`.'
PARSER_ERR_ASSIGN_AS_EQ =
'Слід використовувати `=` для присвоєння.'
PARSER_ERR_EQ_AS_ASSIGN =
'Слід використовувати `==` для рівності.'
PARSER_ERR_UEQ          =
'Слід використовувати `~=` для нерівності.'
PARSER_ERR_THEN_AS_DO   =
'Слід використовувати `then`.'
PARSER_ERR_DO_AS_THEN   =
'Слід використовувати `do`.'
PARSER_MISS_END         =
'Пропущено `end`.'
PARSER_ERR_COMMENT_PREFIX =
'Слід використовувати `--` для коментарів.'
PARSER_MISS_SEP_IN_TABLE =
'Пропущено кому або крапку з комою.'
PARSER_SET_CONST         =
'Спроба присвоєння нового значення константі.'
PARSER_DECLARE_CONST     =
'Не можна перевизначити константу `{name}`.'
PARSER_UNICODE_NAME      =
'Містить символи Юнікоду.'
PARSER_ERR_NONSTANDARD_SYMBOL =
'В `Lua` треба використовувати `{symbol}`.'
PARSER_MISS_SPACE_BETWEEN =
'Між символами варто залишати пробіл.'
PARSER_INDEX_IN_FUNC_NAME =
'Форму `[name]` не можна використовувати в якості назви функції'
PARSER_UNKNOWN_ATTRIBUTE  =
'Локальний атрибут повинен бути `const` або `close`'
PARSER_AMBIGUOUS_SYNTAX   =
'У версії `5.1` відкривна дужка функції повинна бути на тому ж рядку, що і назва функції.'
PARSER_NEED_PAREN         =
'Потрібно додати дужки.'
PARSER_NESTING_LONG_MARK  =
'Вкладені `[[...]]` не дозволені у версії `5.1`.'
PARSER_LOCAL_LIMIT        =
'Лише 200 активних локальних змінних і `upvalues` можуть існувати одночасно.'
PARSER_VARIABLE_NOT_DECLARED =
'Змінна `{name}` не визначена (використайте `global *`, щоб дозволити невизначені змінні або просто визначте її за допомогою `global {name}`)'
PARSER_ENV_IS_GLOBAL         =
'_ENV є глобальним при зверненні до змінної `{name}`.'
PARSER_ASSIGN_CONST_GLOBAL   =
'Не можна присвоїти значення глобальній константній змінній `{name}`.'
PARSER_LUADOC_MISS_CLASS_NAME           =
'Відсутня назва класу.'
PARSER_LUADOC_MISS_EXTENDS_SYMBOL       =
'Відсутня двокрапка.'
PARSER_LUADOC_MISS_CLASS_EXTENDS_NAME   =
'Відсутня назва батьківського класу.'
PARSER_LUADOC_MISS_SYMBOL               =
'Відсутній `{symbol}`.'
PARSER_LUADOC_MISS_ARG_NAME             =
'Відсутня назва аргументу.'
PARSER_LUADOC_MISS_TYPE_NAME            =
'Відсутня назва типу.'
PARSER_LUADOC_MISS_ALIAS_NAME           =
'Відсутня назва аліасу.'
PARSER_LUADOC_MISS_ALIAS_EXTENDS        =
'Відсутнє визначення аліасу.'
PARSER_LUADOC_MISS_PARAM_NAME           =
'Відсутня назва параметра.'
PARSER_LUADOC_MISS_PARAM_EXTENDS        =
'Відсутнє визначення параметра.'
PARSER_LUADOC_MISS_FIELD_NAME           =
'Відсутня назва поля.'
PARSER_LUADOC_MISS_FIELD_EXTENDS        =
'Відсутнє визначення поля.'
PARSER_LUADOC_MISS_GENERIC_NAME         =
'Відсутня назва дженерика.'
PARSER_LUADOC_MISS_GENERIC_EXTENDS_NAME =
'Відсутня назва класу, від якого має успадкуватись дженерик.'
PARSER_LUADOC_MISS_VARARG_TYPE          =
'Відсутній тип `vararg`.'
PARSER_LUADOC_MISS_FUN_AFTER_OVERLOAD   =
'Відсутня `fun`.'
PARSER_LUADOC_MISS_CATE_NAME            =
'Пропущено назву документа.'
PARSER_LUADOC_MISS_DIAG_MODE            =
'Відсутній режим діагностики.'
PARSER_LUADOC_ERROR_DIAG_MODE           =
'Некоректний режим діагностики.'
PARSER_LUADOC_MISS_LOCAL_NAME           =
'Відсутня локальна назва.'

SYMBOL_ANONYMOUS        =
'Анонімний'

HOVER_VIEW_DOCUMENTS    =
'Переглянути документи'
HOVER_DOCUMENT_LUA51    =
'http://www.lua.org/manual/5.1/manual.html#{}'
HOVER_DOCUMENT_LUA52    =
'http://www.lua.org/manual/5.2/manual.html#{}'
HOVER_DOCUMENT_LUA53    =
'http://www.lua.org/manual/5.3/manual.html#{}'
HOVER_DOCUMENT_LUA54    =
'http://www.lua.org/manual/5.4/manual.html#{}'
HOVER_DOCUMENT_LUA55    =
'https://www.lua.org/manual/5.5/manual.html#{}'
HOVER_DOCUMENT_LUAJIT   =
'http://www.lua.org/manual/5.1/manual.html#{}'
HOVER_NATIVE_DOCUMENT_LUA51     =
'command:extension.lua.doc?["en-us/51/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA52     =
'command:extension.lua.doc?["en-us/52/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA53     =
'command:extension.lua.doc?["en-us/53/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA54     =
'command:extension.lua.doc?["en-us/54/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUA55     =
'command:extension.lua.doc?["en-us/55/manual.html/{}"]'
HOVER_NATIVE_DOCUMENT_LUAJIT    =
'command:extension.lua.doc?["en-us/51/manual.html/{}"]'
HOVER_MULTI_PROTOTYPE      =
'({} прототипів)'
HOVER_STRING_BYTES         =
'{} байтів'
HOVER_STRING_CHARACTERS    =
'{} байтів, {} символів'
HOVER_MULTI_DEF_PROTO      =
'({} визначень, {} прототипів)'
HOVER_MULTI_PROTO_NOT_FUNC =
'({} нефункціональне визначення)'
HOVER_USE_LUA_PATH      =
'(Шлях пошуку: `{}`)'
HOVER_EXTENDS           =
'Розгорнути до {}'
HOVER_TABLE_TIME_UP     =
'Вимкнено часткове виведення типів для продуктивності.'
HOVER_WS_LOADING        =
'Завантаження робочого простору: {} / {}'
HOVER_AWAIT_TOOLTIP     =
'Викликається асинхронна функція, поточний потік може зупинитись.'

ACTION_DISABLE_DIAG     =
'Вимкнути діагностику в робочому просторі ({}).'
ACTION_MARK_GLOBAL      =
'Позначити `{}` визначеною глобальною змінною.'
ACTION_REMOVE_SPACE     =
'Видалити всі кінцеві пробіли.'
ACTION_ADD_SEMICOLON    =
'Додати крапку з комою.'
ACTION_ADD_BRACKETS     =
'Додати дужки.'
ACTION_RUNTIME_VERSION  =
'Змінити версію рантайму на `{}`.'
ACTION_OPEN_LIBRARY     =
'Завантажити глобальні змінні з {}.'
ACTION_ADD_DO_END       =
'Додати `do ... end`.'
ACTION_FIX_LCOMMENT_END =
'Замінити на коректний символ закриття багаторядкового коментаря.'
ACTION_ADD_LCOMMENT_END =
'Додати символ закриття багаторядкового коментаря.'
ACTION_FIX_C_LONG_COMMENT =
'Замінити на формат багаторядкового коментаря `Lua`.'
ACTION_FIX_LSTRING_END  =
'Замінити на коректний символ закриття довгого рядка.'
ACTION_ADD_LSTRING_END  =
'Додати символ закриття довгого рядка.'
ACTION_FIX_ASSIGN_AS_EQ =
'Замінити на `=`.'
ACTION_FIX_EQ_AS_ASSIGN =
'Замінити на `==`.'
ACTION_FIX_UEQ          =
'Замінити на `~=`.'
ACTION_FIX_THEN_AS_DO   =
'Замінити на `then`.'
ACTION_FIX_DO_AS_THEN   =
'Замінити на `do`.'
ACTION_ADD_END          =
'Додати ключове слово `end` (визначає місце за відступами).'
ACTION_FIX_COMMENT_PREFIX =
'Замінити на `--`.'
ACTION_FIX_NONSTANDARD_SYMBOL =
'Замінити на `{symbol}`.'
ACTION_RUNTIME_UNICODE_NAME =
'Дозволити символи Юнікоду.'
ACTION_SWAP_PARAMS      =
'Змінити на параметр {index} з `{node}`'
ACTION_FIX_INSERT_SPACE =
'Вставити пробіл.'
ACTION_JSON_TO_LUA      =
'Конвертувати `JSON` у `Lua`'
ACTION_DISABLE_DIAG_LINE=
'Вимкнути діагностику для цього рядка ({}).'
ACTION_DISABLE_DIAG_FILE=
'Вимкнути діагностику для цього файла ({}).'
ACTION_MARK_ASYNC       =
'Позначити функцію асинхронною.'
ACTION_ADD_DICT         =
'Додати \'{}\' у словник робочого простору'
ACTION_FIX_ADD_PAREN    =
'Додати дужки.'
ACTION_AUTOREQUIRE      =
"Імпортувати '{}' як {}"

COMMAND_DISABLE_DIAG       =
'Вимкнути діагностику'
COMMAND_MARK_GLOBAL        =
'Позначити визначену глобальну змінну'
COMMAND_REMOVE_SPACE       =
'Видалити всі кінцеві пробіли'
COMMAND_ADD_BRACKETS       =
'Додати дужки'
COMMAND_RUNTIME_VERSION    =
'Змінити версію рантайму'
COMMAND_OPEN_LIBRARY       =
'Завантажити глобальні змінні зі сторонньої бібліотеки'
COMMAND_UNICODE_NAME       =
'Дозволити символи Юнікоду.'
COMMAND_JSON_TO_LUA        =
'Конвертувати `JSON` в `Lua`'
COMMAND_JSON_TO_LUA_FAILED =
'Не вийшло конвертувати `JSON` в `Lua`: {}'
COMMAND_ADD_DICT           =
'Додати в словник'
COMMAND_REFERENCE_COUNT    =
'{} посилань'

COMPLETION_IMPORT_FROM           =
'Імпортувати з {}'
COMPLETION_DISABLE_AUTO_REQUIRE  =
'Вимкнути автоматичне додавання `require`'
COMPLETION_ASK_AUTO_REQUIRE      =
'Додати код з `require` для цього файлу?'

DEBUG_MEMORY_LEAK       =
"{} Вибачаюсь за такий серйозний витік пам'яті :D. Сервіс мовного сервера буде перезапущено."
DEBUG_RESTART_NOW       =
'Перезапустити зараз'

WINDOW_COMPILING                 =
'Компіляція'
WINDOW_DIAGNOSING                =
'Діагностика'
WINDOW_INITIALIZING              =
'Ініціалізація...'
WINDOW_PROCESSING_HOVER          =
'Обробка наведення курсора...'
WINDOW_PROCESSING_DEFINITION     =
'Обробка визначення...'
WINDOW_PROCESSING_REFERENCE      =
'Обробка посилання...'
WINDOW_PROCESSING_RENAME         =
'Обробка перейменування...'
WINDOW_PROCESSING_COMPLETION     =
'Обробка доповнення...'
WINDOW_PROCESSING_SIGNATURE      =
'Обробка допомоги за сигнатурою...'
WINDOW_PROCESSING_SYMBOL         =
'Обробка символів файлу...'
WINDOW_PROCESSING_WS_SYMBOL      =
'Обробка символів робочого простору...'
WINDOW_PROCESSING_SEMANTIC_FULL  =
'Обробка повних семантичних токенів...'
WINDOW_PROCESSING_SEMANTIC_RANGE =
'Обробка інкрементальних семантичних токенів...'
WINDOW_PROCESSING_HINT           =
'Обробка підказки...'
WINDOW_PROCESSING_BUILD_META     =
'Обробка збірки `meta`...'
WINDOW_INCREASE_UPPER_LIMIT      =
'Підвищити межу'
WINDOW_CLOSE                     =
'Закрити'
WINDOW_SETTING_WS_DIAGNOSTIC     =
'Ви можете відкласти або вимкнути діагностику робочого простору в налаштуваннях'
WINDOW_DONT_SHOW_AGAIN           =
"Не показувати знову"
WINDOW_DELAY_WS_DIAGNOSTIC       =
'Час затримки діагностики ({} секунд)'
WINDOW_DISABLE_DIAGNOSTIC        =
'Вимкнути діагностику робочого простору'
WINDOW_LUA_STATUS_WORKSPACE      =
'Робочий простір: {}'
WINDOW_LUA_STATUS_CACHED_FILES   =
'Кешовані файли: {ast}/{max}'
WINDOW_LUA_STATUS_MEMORY_COUNT   =
'Використання пам\'яті: {mem:.f}M'
WINDOW_LUA_STATUS_TIP            =
[[

Ця іконка — кіт!!!!!!
Не пес і не лис!
             ↓↓↓
]]
WINDOW_LUA_STATUS_DIAGNOSIS_TITLE=
'Виконати діагностику робочого простору'
WINDOW_LUA_STATUS_DIAGNOSIS_MSG  =
'Хочете виконати діагностику робочого простору?'
WINDOW_APPLY_SETTING             =
'Застосувати налаштування'
WINDOW_CHECK_SEMANTIC            =
'Якщо ви використовуєте колірну схему з маркетплейсу, то змініть `editor.semanticHighlighting.enabled` на `true`, щоб семантичні токени працювали належно.'
WINDOW_TELEMETRY_HINT            =
'Будь ласка, дозвольте надсилати дані використання та звіти про помилки (анонімно). Це допоможе нам покращити розширення. Наша політика приватності [тут](https://luals.github.io/privacy#language-server).'
WINDOW_TELEMETRY_ENABLE          =
'Дозволити'
WINDOW_TELEMETRY_DISABLE         =
'Заборонити'
WINDOW_CLIENT_NOT_SUPPORT_CONFIG =
'Ваш клієнт не підтримує зміну налаштувань з серверної частини, але ви можете самостійно змінити ось ці налаштування:'
WINDOW_LCONFIG_NOT_SUPPORT_CONFIG=
'Автоматична зміна локальних налаштувань поки що не підтримується, але ви можете самостійно змінити ось ці налаштування:'
WINDOW_MANUAL_CONFIG_ADD         =
'`{key}`: додати елемент `{value:q}` ;'
WINDOW_MANUAL_CONFIG_SET         =
'`{key}`: встановити як `{value:q}` ;'
WINDOW_MANUAL_CONFIG_PROP        =
'`{key}`: встановити властивість `{prop}` для `{value:q}`;'
WINDOW_APPLY_WITH_SETTING        =
'Застосувати та змінити налаштування'
WINDOW_APPLY_WITHOUT_SETTING     =
'Застосувати, але не змінювати налаштувань'
WINDOW_ASK_APPLY_LIBRARY         =
'Хочете налаштувати робочий простір як `{}`?'
WINDOW_SEARCHING_IN_FILES        =
'Пошук в файлах...'
WINDOW_CONFIG_LUA_DEPRECATED     =
'`config.lua` застарілий, замість нього використовуйте `config.json`.'
WINDOW_CONVERT_CONFIG_LUA        =
'Конвертувати в `config.json`'
WINDOW_MODIFY_REQUIRE_PATH       =
'Хочете змінити шлях `require`?'
WINDOW_MODIFY_REQUIRE_OK         =
'Змінити'

CONFIG_LOAD_FAILED               =
'Не вдалося прочитати файл налаштувань: {}'
CONFIG_LOAD_ERROR                =
'Помилка завантаження файла налаштувань: {}'
CONFIG_TYPE_ERROR                =
'Файл налаштувань повинен бути у форматі `lua` або `json`: {}'
CONFIG_MODIFY_FAIL_SYNTAX_ERROR  =
'Не вдалося змінити налаштування, синтаксична помилка у файлі: {}'
CONFIG_MODIFY_FAIL_NO_WORKSPACE  =
[[
Не вдалося змінити налаштування:
* Поточний режим однофайловий, сервер не може створити `.luarc.json` без робочого простору.
* Мовний клієнт не підтримує зміну налаштувань серверної частини.

Змініть ось ці налаштування самостійно:
{}
]]
CONFIG_MODIFY_FAIL               =
[[
Не вдалося змінити налаштування

Змініть ось ці налаштування самостійно:
{}
]]

PLUGIN_RUNTIME_ERROR             =
[[
Помилка у плагіні, будь ласка, повідомте про неї автора.

Деталі вже виведені або у логах.

Шлях: {}
]]
PLUGIN_TRUST_LOAD                =
[[
Спроба завантажити плагін сюди: {}

Зверніть увагу, зловмисні плагіни можуть завдати шкоди вашому комп'ютеру
]]
PLUGIN_TRUST_YES                 =
'Довіритися та завантажити плагін'
PLUGIN_TRUST_NO                  =
'Не завантажувати плагін'

CLI_CHECK_ERROR_TYPE =
'`CHECK` мусить бути рядком, але він є {}'
CLI_CHECK_ERROR_URI =
'`CHECK` мусить бути коректним `URI`, але він є {}'
CLI_CHECK_ERROR_LEVEL =
'Допустимі значення `Checklevel`: {}'
CLI_CHECK_INITING =
'Ініціалізація...'
CLI_CHECK_SUCCESS =
'Завершено діагностику, жодних проблем, все добре'
CLI_CHECK_PROGRESS =
'Знайдено {} проблем у {} файлах'
CLI_CHECK_RESULTS =
'Завершено діагностику, знайдено {} проблем, дивіться {}'
CLI_CHECK_RESULTS_OUTPATH =
'Завершено діагностику, знайдено {} проблем, дивіться {}'
CLI_CHECK_RESULTS_PRETTY =
'Завершено діагностику, знайдено {} проблем'
CLI_CHECK_MULTIPLE_WORKERS =
'Запуск {} завдань воркера, виведення прогресу вимкнеться. Заберемо у вас кілька хвилин (будь ласка)...'
CLI_DOC_INITING   =
'Завантаження документів...'
CLI_DOC_DONE      =
[[
Експорт документації завершено!

Звичайні дані: {}
Markdown(приклад): {}
]]
CLI_DOC_WORKING   =
'Генерація документації...'

TYPE_ERROR_ENUM_GLOBAL_DISMATCH =
'Тип `{child}` не збігається з перелічуваним типом `{parent}`'
TYPE_ERROR_ENUM_GENERIC_UNSUPPORTED =
'Не можна використовувати дженерик `{child}` у переліку'
TYPE_ERROR_ENUM_LITERAL_DISMATCH =
'`{child}` не збігається з перелічуваним значенням `{parent}`'
TYPE_ERROR_ENUM_OBJECT_DISMATCH =
'Об\'єкт `{child}` не збігається з перелічуваним значенням `{parent}`'
TYPE_ERROR_ENUM_NO_OBJECT =
'Значення перелічення `{child}` не можна визначити'
TYPE_ERROR_INTEGER_DISMATCH =
'`{child}` не збігається з цілим числом `{parent}`'
TYPE_ERROR_STRING_DISMATCH =
'`{child}` не збігається з рядком `{parent}`'
TYPE_ERROR_BOOLEAN_DISMATCH =
'`{child}` не збігається з `boolean` `{parent}`'
TYPE_ERROR_TABLE_NO_FIELD =
'Поля `{key}` не існує в таблиці'
TYPE_ERROR_TABLE_FIELD_DISMATCH =
'Поле `{key}` має тип `{child}`, він не збігається з `{parent}`'
TYPE_ERROR_CHILD_ALL_DISMATCH =
'Підтипи `{child}` не збігаються з `{parent}`'
TYPE_ERROR_PARENT_ALL_DISMATCH =
'`{child}` не збігається з жодним з підтипів у `{parent}`'
TYPE_ERROR_UNION_DISMATCH =
'`{child}` не збігається з `{parent}`'
TYPE_ERROR_OPTIONAL_DISMATCH =
'Опціональний тип не збігається з `{parent}`'
TYPE_ERROR_NUMBER_LITERAL_TO_INTEGER =
'Число `{child}` не можна конвертувати в ціле'
TYPE_ERROR_NUMBER_TYPE_TO_INTEGER =
'Не можна конвертувати число у ціле'
TYPE_ERROR_DISMATCH =
'Тип `{child}` не збігається з `{parent}`'

LUADOC_DESC_CLASS =
[=[
Визначити структуру класу/таблиці
## Синтаксис
`---@class <name> [: <parent>[, <parent>]...]`
## Використання
```
---@class Manager: Person, Human
Manager = {}
```
---
[Вікі](https://luals.github.io/wiki/annotations#class)
]=]
LUADOC_DESC_TYPE =
[=[
Тип змінної.

Класичні: `nil`, `any`, `boolean`, `string`, `number`, `integer`, `function`, `table`, `thread`, `userdata`, `lightuserdata`.

(Власні типи можна створити за допомогою анотації `@alias`)

## Синтаксис
`---@type <type>[| [type]...`

## Використання
```
---@type nil|table|myClass
local Example = nil
```

### Масиви
```
---@type number[]
local phoneNumbers = {}
```

### Перелік
```
---@type "red"|"green"|"blue"
local color = ""
```

### Таблиці
```
---@type table<string, boolean>
local settings = {
    disableLogging = true,
    preventShutdown = false,
}

---@type { [string]: true }
local x --x[""] is true
```

### Функції
```
---@type fun(mode?: "r"|"w"): string
local myFunction
```
---
[Вікі](https://luals.github.io/wiki/annotations#type)
]=]
LUADOC_DESC_ALIAS =
[=[
Створити власний тип, який можна використовувати в анотаціях `@param`, `@type`, тощо.

## Синтаксис
`---@alias <name> <type> [description]`\
або
```
---@alias <name>
---| 'value' [# comment]
---| 'value2' [# comment]
...
```

## Використання
```
---@alias filepath string Шлях до файлу

---@param path filepath Шлях до файлу для пошуку
function find(path, pattern) end
```

### Перелік
```
---@alias font-style
---| '"underlined"' # Підкреслений
---| '"bold"' # Жирний
---| '"italic"' # Курсив

---@param style font-style Стиль для застосування
function setFontStyle(style) end
```

### Літеральний перелік
```
local enums = {
    READ = 0,
    WRITE = 1,
    CLOSE = 2
}

---@alias FileStates
---| `enums.READ`
---| `enums.WRITE`
---| `enums.CLOSE`
```
---
[Вікі](https://luals.github.io/wiki/annotations#alias)
]=]
LUADOC_DESC_PARAM =
[=[
Визначити параметр функції

## Синтаксис
`@param <name>[?] <type> [comment]`

## Використання
```
---@param url string Посилання для запиту
---@param headers? table<string, string> HTTP заголовки
---@param timeout? number Таймаут у секундах
function get(url, headers, timeout) end
```

### Змінні аргументи
```
---@param base string Основа, до якої виконується приєднання
---@param ... string Те, що приєднується
function concat(base, ...) end
```
---
[Вікі](https://luals.github.io/wiki/annotations#param)
]=]
LUADOC_DESC_RETURN =
[=[
Визначити тип, який поверне `return`

## Синтаксис
`@return <type> [name] [description]`\
або\
`@return <type> [# description]`

## Використання
```
---@return number   Червоний
---@return number # Зелений
---@return number b Синій
function hexToRGB(hex) end
```

### Тип та лише назва
```
---@return number x, number y
function getCoords() end
```

### Тільки тип
```
---@return string, string
function getFirstLast() end
```

### Повернути значення змінної
```
---@return string ... Теги елемента
function getTags(item) end
```
---
[Вікі](https://luals.github.io/wiki/annotations#return)
]=]
LUADOC_DESC_FIELD =
[=[
Визначити поле в класі/таблиці. 

Це дає змогу краще задокументувати таблицю.

Починаючи з версії `3.6.0`, ви можете позначити поле як `private`, `protected`, `public`, `package`.

## Синтаксис
`---@field [scope] <name> <type> [description]`

## Використання
```
---@class HTTP_RESPONSE
---@field status HTTP_STATUS
---@field headers table<string, string> Заголовки відповіді

---@class HTTP_STATUS
---@field code number Код відповіді
---@field message string Повідомлення статусу

---@return HTTP_RESPONSE response Відповідь сервера
function get(url) end

--Змінна, що містить усі поля відповіді
response = get("localhost")

--Розширення надало `IntelliSense` для наведеного нижче присвоєння
statusCode = response.status.code
```
---
[Вікі](https://luals.github.io/wiki/annotations#field)
]=]
LUADOC_DESC_GENERIC =
[=[
Симуляція дженериків. 

Дженерики дозволяють перевикористання типів, оскільки дають "узагальнену структуру", яку можна застосувати з різними типами.

## Синтаксис
`---@generic <name> [:parent_type] [, <name> [:parent_type]]`

## Використання
```
---@generic T
---@param value T Те, що повернути
---@return T value Точно таке саме значення
function echo(value)
    return value
end

-- Рядок
s = echo("e")

-- Число
n = echo(10)

-- `boolean`
b = echo(true)

-- Ми отримали інформацію просто використовуючи
-- @generic, взагалі не визначавши окремо кожен
-- дозволений тип
```

### Захопити назву типу дженерику
```
---@class Foo
local Foo = {}
function Foo:Bar() end

---@generic T
---@param name `T` # назва дженерику
---@return T       # функція повертає дженерик
function Generic(name) end

local v = Generic("Foo") -- v є об'єктом `Foo`
```

### Як таблиці використовують дженерики
```
---@class table<K, V>: { [K]: V }

-- Дозволяє створити таблицю
-- та `IntelliSense` відстежує будь-який тип
-- надаємо для ключа (K) або значення (V)
```
---
[Вікі](https://luals.github.io/wiki/annotations/#generic)
]=]
LUADOC_DESC_VARARG =
[=[
Здебільшого для зворотної сумісності з анотаціями `EmmyLua`.

`@vararg` не підтримує типізацію та не дозволяє описи.

**Використовуйте `@param` для документації параметрів.**

## Синтаксис
`@vararg <type>`

## Використання
```
---Об'єднує рядки
---@vararg string
function concat(...) end
```
---
[Вікі](https://luals.github.io/wiki/annotations/#vararg)
]=]
LUADOC_DESC_OVERLOAD =
[=[
Дозволити визначення кількох сигнатур однієї функції.

## Синтаксис
`---@overload fun(<name>[: <type>] [, <name>[: <type>]]...)[: <type>[, <type>]...]`

## Використання
```
---@overload fun(t: table, value: any): number
function table.insert(t, position, value) end
```
---
[Вікі](https://luals.github.io/wiki/annotations#overload)
]=]
LUADOC_DESC_DEPRECATED =
[=[
Позначає функцію застарілою; у результаті вона буде ~~перекресленою~~.

## Синтаксис
`---@deprecated`

---
[Вікі](https://luals.github.io/wiki/annotations#deprecated)
]=]
LUADOC_DESC_META =
[=[
Визначити метафайл, який використовуватиметься тільки для визначень та `IntelliSense`.

Зверніть увагу на три основні відмінності:
1. У метафайлі не буде контекстних підказок `IntelliSense`
2. При наведенні курсора на шлях у `require` показує `[meta]` замість абсолютного шляху
3. Функція `Find Reference` ігноруватиме метафайли

## Синтаксис
`---@meta`

---
[Вікі](https://luals.github.io/wiki/annotations#meta)
]=]
LUADOC_DESC_VERSION =
[=[
Визначити версію `Lua`, для якої призначена конкретна функція.

Версії: `5.1`, `5.2`, `5.3`, `5.4`, `JIT`.

Потребує налаштування `Diagnostics: Needed File Status`.

## Синтаксис
`---@version <version>[, <version>]...`

## Використання
```
---@version JIT
function onlyWorksInJIT() end
```
### Визначити кілька версій
```
---@version <5.2,JIT
function oldLuaOnly() end
```
---
[Вікі](https://luals.github.io/wiki/annotations#version)
]=]
LUADOC_DESC_SEE =
[=[
Визначити щось, що може бути переглянуто для отримання інформації

## Синтаксис
`---@see <text>`

---
[Вікі](https://luals.github.io/wiki/annotations#see)
]=]
LUADOC_DESC_DIAGNOSTIC =
[=[
Увімкнути/вимкнути діагностику помилок/попереджень/тощо.

Опції: `disable`, `enable`, `disable-line`, `disable-next-line`

[Назви](https://github.com/LuaLS/lua-language-server/blob/cbb6e6224094c4eb874ea192c5f85a6cba099588/script/proto/define.lua#L54)

## Синтаксис
`---@diagnostic <action>[: <name>]`

## Використання
### Вимкнути наступний рядок
```
---@diagnostic disable-next-line: undefined-global
```

### Перемикати власноруч
```
---@diagnostic disable: unused-local
local unused = "hello world"
---@diagnostic enable: unused-local
```
---
[Вікі](https://luals.github.io/wiki/annotations#diagnostic)
]=]
LUADOC_DESC_MODULE =
[=[
Надати семантику для `require`.

## Синтаксис
`---@module <'module_name'>`

## Використання
```
---@module 'string.utils'
local stringUtils
-- Рівносильно до:
local module = require('string.utils')
```
---
[Вікі](https://luals.github.io/wiki/annotations#module)
]=]
LUADOC_DESC_ASYNC =
[=[
Позначити функцію асинхронною.

## Синтаксис
`---@async`

---
[Вікі](https://luals.github.io/wiki/annotations#async)
]=]
LUADOC_DESC_NODISCARD =
[=[
Показувати попередження `discard-returns`, при ігноруванні повернутих функцією значень.

## Синтаксис
`---@nodiscard`

---
[Вікі](https://luals.github.io/wiki/annotations#nodiscard)
]=]
LUADOC_DESC_CAST =
[=[
Дозволити касти.

## Синтаксис
`@cast <variable> <[+|-]type>[, <[+|-]type>]...`

## Використання
### Перезаписати тип
```
---@type integer
local x --> integer

---@cast x string
print(x) --> string
```
### Додати тип
```
---@type string
local x --> string

---@cast x +boolean, +number
print(x) --> string|boolean|number
```
### Видалити тип
```
---@type string|table
local x --> string|table

---@cast x -string
print(x) --> table
```
---
[Вікі](https://luals.github.io/wiki/annotations#cast)
]=]
LUADOC_DESC_OPERATOR =
[=[
Надати визначення типів для [метаметодів оператора](http://lua-users.org/wiki/MetatableEvents).

## Синтаксис
`@operator <operation>[(input_type)]:<resulting_type>`

## Використання
### Метаметод векторного додавання
```
---@class Vector
---@operator add(Vector):Vector

vA = Vector.new(1, 2, 3)
vB = Vector.new(10, 20, 30)

vC = vA + vB
--> Vector
```
### Унарний мінус
```
---@class Passcode
---@operator unm:integer

pA = Passcode.new(1234)
pB = -pA
--> integer
```
[Запит](https://github.com/LuaLS/lua-language-server/issues/599)
]=]
LUADOC_DESC_ENUM =
[=[
Визначити таблицю переліченням. 

Хочете перелічення, але не можете визначити його через таблицю? 

Подивіться на [`@alias`](https://luals.github.io/wiki/annotations#alias).

## Синтаксис
`@enum <name>`

## Використання
```
---@enum colors
local colors = {
	white = 0,
	orange = 2,
	yellow = 4,
	green = 8,
	black = 16,
}

---@param color colors
local function setColor(color) end

-- Параметр нижче матиме автодоповнення та надасть інформацію при наведенні курсора
setColor(colors.green)
```
]=]
LUADOC_DESC_SOURCE =
[=[
Надати посилання на код в іншому файлі.

Під час пошуку визначення елемента використовуватиметься його `@source`.

## Синтаксис
`@source <path>`

## Використання
```
---Можна підключити за абсолютним шляхом
---@source C:/Users/me/Documents/program/myFile.c
local a

---Або з URI
---@source file:///C:/Users/me/Documents/program/myFile.c:10
local b

---Або відносні шляхи
---@source local/file.c
local c

---Також можна підключити конкретний рядок та номер символа
---@source local/file.c:10:8
local d
```
]=]
LUADOC_DESC_PACKAGE =
[=[
Позначити функцію приватною для файлу, у якому вона визначена.

Функція не буде доступна ззовні.

## Синтаксис
`@package`

## Використання
```
---@class Animal
---@field private eyes integer
local Animal = {}

---@package
---Доступ з іншого файлу неможливий
function Animal:eyesCount()
    return self.eyes
end
```
]=]
LUADOC_DESC_PRIVATE =
[=[
Позначити функцію приватною.

Доступ можливий тільки в класі функції.

## Синтаксис
`@private`

## Використання
```
---@class Animal
---@field private eyes integer
local Animal = {}

---@private
function Animal:eyesCount()
    return self.eyes
end

---@class Dog:Animal
local myDog = {}

---ЗАБОРОНЕНО!
myDog:eyesCount();
```
]=]
LUADOC_DESC_PROTECTED =
[=[
Позначити функцію захищеною.

Доступ можливий тільки у класі та підкласах функції.

## Синтаксис
`@protected`

## Використання
```
---@class Animal
---@field private eyes integer
local Animal = {}

---@protected
function Animal:eyesCount()
    return self.eyes
end

---@class Dog:Animal
local myDog = {}

---Працює, адже функція захищена, а не приватна.
myDog:eyesCount();
```
]=]
