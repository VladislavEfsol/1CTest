
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СправочникПодключаемоеОборудование.Ссылка КАК Устройство,
	|	СправочникПодключаемоеОборудование.ТипОборудования КАК ТипОборудования
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК СправочникПодключаемоеОборудование
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КассыККМ КАК КассыККМ
	|		ПО (КассыККМ.ПодключаемоеОборудование = СправочникПодключаемоеОборудование.Ссылка)
	|ГДЕ
	|	СправочникПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.ККМОфлайн)
	|	И СправочникПодключаемоеОборудование.ПравилоОбмена <> ЗНАЧЕНИЕ(Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ПустаяСсылка)
	|	И СправочникПодключаемоеОборудование.УстройствоИспользуется
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СправочникПодключаемоеОборудование.Ссылка,
	|	СправочникПодключаемоеОборудование.ТипОборудования
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК СправочникПодключаемоеОборудование
	|ГДЕ
	|	СправочникПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток)
	|	И СправочникПодключаемоеОборудование.ПравилоОбмена <> ЗНАЧЕНИЕ(Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ПустаяСсылка)
	|	И СправочникПодключаемоеОборудование.УстройствоИспользуется");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Оборудование.Добавить();
		НоваяСтрока.ВыполнятьОбмен         = Истина;
		НоваяСтрока.Устройство             = Выборка.Устройство;
		НоваяСтрока.ТипОборудования        = Выборка.ТипОборудования;
		НоваяСтрока.СостояниеВыгрузки      = НСтр("ru = '<Выгрузка не производилась>'");
		НоваяСтрока.ИндексКартинкиЗагрузки = 1;
		НоваяСтрока.ИндексКартинкиВыгрузки = 1;
		
		Если НоваяСтрока.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
			НоваяСтрока.СостояниеЗагрузки = НСтр("ru = '<Не требуется>'");
		Иначе
			НоваяСтрока.СостояниеЗагрузки = НСтр("ru = '<Загрузка не производилась>'");
		КонецЕсли;
		
	КонецЦикла;
	
	Состояние = "";
	
	Элементы.Начать.Доступность              = Истина;
	Элементы.Завершить.Доступность           = Ложь;
	
	НастроитьФормуМобильныйКлиент();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД

&НаКлиенте
Процедура Начать(Команда)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(ПериодичностьОбмена) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задана периодичность обмена с оборудованием'"),,"ПериодичностьОбмена");
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьОборудованиеДляОбмена() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбрано оборудование для обмена'"),,"Оборудование");
		Возврат;
	КонецЕсли;
	
	Элементы.ПериодичностьОбмена.Доступность                         = Ложь;
	Элементы.ОборудованиеВыполнятьОбмен.Доступность                  = Ложь;
	Элементы.ОборудованиеУстановитьФлажки.Доступность                = Ложь;
	Элементы.ОборудованиеСнятьФлажки.Доступность                     = Ложь;
	Элементы.ОборудованиеКонтекстноеМенюУстановитьФлажки.Доступность = Ложь;
	Элементы.ОборудованиеКонтекстноеМенюСнятьФлажки.Доступность      = Ложь;
	
	Элементы.Начать.Доступность              = Ложь;
	Элементы.Завершить.Доступность           = Истина;
	
	Состояние = НСтр("ru = 'Выполняется обмен с подключенным оборудованием...'");
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбмен", ПериодичностьОбмена * 60, Ложь);
	
	ОбменВыполняется = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Завершить(Команда)
	
	Элементы.ПериодичностьОбмена.Доступность                         = Истина;
	Элементы.ОборудованиеВыполнятьОбмен.Доступность                  = Истина;
	Элементы.ОборудованиеУстановитьФлажки.Доступность                = Истина;
	Элементы.ОборудованиеСнятьФлажки.Доступность                     = Истина;
	Элементы.ОборудованиеКонтекстноеМенюУстановитьФлажки.Доступность = Истина;
	Элементы.ОборудованиеКонтекстноеМенюСнятьФлажки.Доступность      = Истина;
	
	Элементы.Начать.Доступность              = Истина;
	Элементы.Завершить.Доступность           = Ложь;
	
	Состояние = НСтр("ru = 'Обмен завершен'");
	
	ОтключитьОбработчикОжидания("ОбработчикОжиданияОбмен");
	
	ОбменВыполняется = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ОбменВыполняется Тогда
		
		ПоказатьПредупреждение(, НСтр("ru='После закрытия формы обмен с оборудованием выполняться не будет.'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	УстановитьФлажкиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	СнятьФлажкиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСейчас(Команда)
	
	Состояние = НСтр("ru = 'Выполняется обмен с подключенным оборудованием...'");
	ВыполнитьОбмен();
	Состояние = НСтр("ru = 'Обмен завершен'");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаКлиенте
Процедура ВыполнитьОбмен()
	
	Для каждого СтрокаТЧ Из Оборудование Цикл
		
		Если НЕ СтрокаТЧ.ВыполнятьОбмен Тогда
			Продолжить;
		КонецЕсли;
		
		МассивУстройств = Новый Массив;
		МассивУстройств.Добавить(СтрокаТЧ.Устройство);
		
		// Выгрузка данных
		ТекстСообщения = "";
		ОповещениеОВыполнении = Новый ОписаниеОповещения(
			"ВыполнитьОбменЗавершение",
			ЭтотОбъект,
			Новый Структура ("ТекстСообщения, СтрокаТЧ, Устройство, МассивУстройств", ТекстСообщения, СтрокаТЧ, СтрокаТЧ.Устройство, МассивУстройств)
		);
		
		Если СтрокаТЧ.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток") Тогда
			ПодключаемоеОборудованиеOfflineКлиент.АсинхронныйВыгрузитьТоварыВОборудованиеOffline(СтрокаТЧ.ТипОборудования, МассивУстройств, ТекстСообщения, Ложь, ОповещениеОВыполнении, Истина);
		Иначе
			МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуДанныхНаККМ(СтрокаТЧ.Устройство, УникальныйИдентификатор, ОповещениеОВыполнении);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменЗавершение(Результат, Параметры) Экспорт
	
	Если Параметры.СтрокаТЧ.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток") Тогда
		Параметры.СтрокаТЧ.ИндексКартинкиВыгрузки = ?(Результат, 1, 0);
		Параметры.СтрокаТЧ.СостояниеВыгрузки = Параметры.ТекстСообщения;
	Иначе
		Параметры.СтрокаТЧ.ИндексКартинкиВыгрузки = ?(Результат.Результат, 1, 0);
		Параметры.СтрокаТЧ.СостояниеВыгрузки = Результат.ОписаниеОшибки;
	КонецЕсли;
	
	Параметры.СтрокаТЧ.ДатаЗавершенияВыгрузки = ТекущаяДата();
	
	// Загрузка данных
	Если Параметры.СтрокаТЧ.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККМОфлайн") Тогда
		
		ТекстСообщения = "";
		
		ОповещениеОВыполнении = Новый ОписаниеОповещения(
			"ВыполнитьЗагрузкуЗавершение",
			ЭтотОбъект,
			Параметры
		);
		
		МенеджерОфлайнОборудованияКлиент.НачатьЗагрузкуДанныхИзККМ(Параметры.Устройство, УникальныйИдентификатор, ОповещениеОВыполнении);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуЗавершение(Результат, Параметры) Экспорт
	
	Параметры.СтрокаТЧ.СостояниеЗагрузки = Результат.ОписаниеОшибки;
	Параметры.СтрокаТЧ.ИндексКартинкиЗагрузки = ?(Результат.Результат, 1, 0);
	Параметры.СтрокаТЧ.ДатаЗавершенияЗагрузки = ТекущаяДата();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияОбмен()
	
	ВыполнитьОбмен();
	
	ОтключитьОбработчикОжидания("ОбработчикОжиданияОбмен");
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбмен", ПериодичностьОбмена * 60, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФлажкиНаСервере()
	
	Для Каждого СтрокаТЧ Из Оборудование Цикл
		СтрокаТЧ.ВыполнятьОбмен = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СнятьФлажкиНаСервере()
	
	Для Каждого СтрокаТЧ Из Оборудование Цикл
		СтрокаТЧ.ВыполнятьОбмен = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЕстьОборудованиеДляОбмена()
	
	Возврат Оборудование.НайтиСтроки(новый Структура("ВыполнятьОбмен", Истина)).Количество() > 0;
	
КонецФункции

&НаСервере
Процедура НастроитьФормуМобильныйКлиент()
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ОборудованиеУстановитьФлажки.Видимость = Ложь;
		Элементы.ОборудованиеСнятьФлажки.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры
