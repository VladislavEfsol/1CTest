&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// инициализируем вспомогательные переменные
	ИзмененыСвойстваМодуля  = Ложь;
	
	Элементы.УстановитьКомпоненту.Видимость = Ложь;
	
	ПоддерживаемыеКриптопровайдеры = КриптографияЭДКОКлиентСервер.ПоддерживаемыеКриптопровайдеры();
	Для каждого СвойстваКриптопровайдера Из ПоддерживаемыеКриптопровайдеры Цикл
		ДобавитьСтрокуВТаблицуCSP(
			СвойстваКриптопровайдера.Имя,
			?(СвойстваКриптопровайдера.ТипКриптопровайдера = Перечисления.ТипыКриптоПровайдеров.CryptoPro, 1, 2),
			СвойстваКриптопровайдера.Тип);
	КонецЦикла;
	
	// восстанавливаем редактируемые (отображаемые) настройки
	ВосстановитьНастройки();
	УправлениеЭУВРежимеСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ПрограммноеЗакрытие = Не Модифицированность;
	
	ТекстПредупреждения = НСтр("ru = 'Настройки были изменены. Закрыть без сохранения?'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПриОтказеОтЗакрытияФормы", 
		ЭтотОбъект); 
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
		ЭтотОбъект, 
		Отказ, 
		ЗавершениеРаботы,
		ТекстПредупреждения, 
		"ПрограммноеЗакрытие",
		ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеМодульДокументооборотаПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	ИзмененыСвойстваМодуля = Истина;
	ВерсияМодуля           = Неопределено;
	ДанныеМодуля           = Неопределено;
	Модифицированность     = Истина;
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеИспользоватьВнешнийМодульПриИзменении(Элемент)
	
	ИзмененыСвойстваМодуля = Истина;
	
	УправлениеЭУ();
	
	Если ИспользоватьВнешнийМодуль И НЕ ЗначениеЗаполнено(ДанныеМодуля) Тогда
		ВыбратьВнешнийМодуль();
	ИначеЕсли НЕ ИспользоватьВнешнийМодуль Тогда
		
		ВерсияМодуля        = Неопределено;
		ДанныеМодуля        = Неопределено;
		Модифицированность  = Истина;
		
		УправлениеЭУ();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеРазрешитьОбновлениеМодуляПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПрограммЭлектроннойПодписиИШифрованияНажатие(Элемент)
	
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования("Программы");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Новая версия модуля документооборота зарегистрирована в информационной базе" Тогда
		
		ИзмененыСвойстваМодуля = Истина;
		Модифицированность     = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеМодульДокументооборотаПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьВнешнийМодуль();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если СохранитьНастройки() Тогда
		
		Оповестить("ИзменениеНастроекДокументооборота");

		Если ИзмененыСвойстваМодуля Тогда
			ВопросПерезапуститьПрограммуПослеОбновленияМодуля();
		Иначе
			Закрыть();
		КонецЕсли;
		
	Иначе
		// При сохранении были выданы ошибки, форму не закрываем.
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПараметрыПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКомпоненту(Команда)
	
	ОбновитьГруппуВнешняяКомпонента(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСейчас(Команда)
	
	СохранитьНастройки();
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьСейчасЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения, Истина);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗакрытиеФормы

&НаКлиенте
Процедура ВопросПерезапуститьПрограммуПослеОбновленияМодуля() Экспорт
	
	// Если модуль обновлен тогда предлагаем перезапуститься
	ТекстВопроса = "Изменения вступят в силу только после повторного открытия программы!
		|Перезапустить программу сейчас?";
		
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВопросПерезапуститьПрограммуПослеОбновленияМодуляЗавершение", 
		ЭтотОбъект);
		
	ПоказатьВопрос(
		ОписаниеОповещения, 
		ТекстВопроса, 
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПерезапуститьПрограммуПослеОбновленияМодуляЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗавершитьРаботуСистемы(Истина, Истина);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтказеОтЗакрытияФормы(Результат, ВходящийКонтекст) Экспорт
	
	Модифицированность = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	УправлениеЭУ();
	
	ОбновитьГруппуВнешняяКомпонента();

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВерсиюВнешнегоМодуляИзФайла(Адрес, ВыбранноеИмяФайла)
	
	Файл = Новый Файл(ВыбранноеИмяФайла);
	// сохраняем обработку во временный файл
	Если Адрес <> Неопределено Тогда
		ИмяФайлаОбработки = КаталогВременныхФайлов() + Файл.Имя;
		ПолучитьИзВременногоХранилища(Адрес).Записать(ИмяФайлаОбработки);
	Иначе
		Возврат Неопределено
	КонецЕсли;
	
	// пытаемся извлечь версию внешнего модуля
	Попытка
		Результат = ВнешниеОбработки.Создать(ИмяФайлаОбработки).мВерсияМодуля;
	Исключение
		Результат = Неопределено;
	КонецПопытки;
	
	// удаляем временный файл обработки
	УдалитьФайлы(ИмяФайлаОбработки);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ДобавитьСтрокуВТаблицуCSP(ИмяКриптопровайдера, КодCSP, ТипCSP)
	
	НовСтр = ТаблицаCSP.Добавить();
	НовСтр.Имя = ИмяКриптопровайдера;
	НовСтр.Код = КодCSP;
	НовСтр.Тип = ТипCSP;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	// читаем общие настройки
	Если ПравоДоступа("Чтение", Метаданные.Константы.ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль) Тогда
		
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			ТекстЗапроса =
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	Константы.ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль,
				|	Константы.ДокументооборотСКонтролирующимиОрганами_ВерсияВнешнегоМодуля
				|ИЗ
				|	Константы КАК Константы";
				
			Запрос = Новый Запрос(ТекстЗапроса);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				
				ИспользоватьВнешнийМодуль 	= Выборка.ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль;
				ВерсияМодуля 				= Выборка.ДокументооборотСКонтролирующимиОрганами_ВерсияВнешнегоМодуля;
				
			КонецЕсли;
		КонецЕсли;
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ"
			+ ?(НЕ ОбщегоНазначения.РазделениеВключено(), "
			|	Константы.ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль,
			|	Константы.ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль,
			|	Константы.ДокументооборотСКонтролирующимиОрганами_ВерсияВнешнегоМодуля,",
			"") + "
			|	Константы.ДокументооборотСКонтролирующимиОрганами_ИмяКриптопровайдера,
			|	Константы.ДокументооборотСКонтролирующимиОрганами_ТипКриптопровайдера,
			|	Константы.ДокументооборотСКонтролирующимиОрганами_РежимТестирования
			|ИЗ
			|	Константы КАК Константы";
			
		Запрос = Новый Запрос(ТекстЗапроса);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			
			Если НЕ ОбщегоНазначения.РазделениеВключено() Тогда
				ИспользоватьВнешнийМодуль 	= Выборка.ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль;
				ДанныеМодуля 				= Выборка.ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль.Получить();
				ВерсияМодуля 				= Выборка.ДокументооборотСКонтролирующимиОрганами_ВерсияВнешнегоМодуля;
			КонецЕсли;
			
			ИмяКриптопровайдера = Выборка.ДокументооборотСКонтролирующимиОрганами_ИмяКриптопровайдера;
			ТипКриптопровайдера = Выборка.ДокументооборотСКонтролирующимиОрганами_ТипКриптопровайдера;
			
			ИспользоватьРежимТестирования = Выборка.ДокументооборотСКонтролирующимиОрганами_РежимТестирования; 
			
			СтрCSP = ТаблицаCSP.НайтиСтроки(Новый Структура("Имя, Тип", ИмяКриптопровайдера, ТипКриптопровайдера));
			Если СтрCSP.Количество() > 0 Тогда
				Криптопровайдер = СтрCSP[0].Код;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	сохрРазрешитьОбновлениеМодуля = ХранилищеОбщихНастроек.Загрузить("ДокументооборотСКонтролирующимиОрганами_РазрешитьОнлайнОбновление");
	Если сохрРазрешитьОбновлениеМодуля = Неопределено Тогда
		сохрРазрешитьОбновлениеМодуля = ХранилищеОбщихНастроек.Загрузить("ДокументооборотСНалоговымиОрганами_РазрешитьОнлайнОбновление"); // прежнее имя параметра
	КонецЕсли;
	РазрешитьОбновлениеМодуля = (сохрРазрешитьОбновлениеМодуля = Истина);
	
КонецПроцедуры

&НаСервере
Функция СохранитьНастройки()
	
	Если ИспользоватьВнешнийМодуль И НЕ ОбщегоНазначения.РазделениеВключено() И НЕ ЗначениеЗаполнено(ДанныеМодуля) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Выберите внешний модуль.'"));
		Возврат Ложь;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	ИзменениеВнешнегоМодуляРазрешено = КонтекстЭДОСервер.ИзменениеСвойствМодуляДокументооборотаВозможно()
		И НЕ ОбщегоНазначения.РазделениеВключено();
	
	// сохраняем общие настройки
	Если ИзменениеВнешнегоМодуляРазрешено Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	ИменаКонстантНабора =
		?(НЕ ОбщегоНазначения.РазделениеВключено(),
		"ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль,
		|ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль,
		|ДокументооборотСКонтролирующимиОрганами_ВерсияВнешнегоМодуля,
		|",
		"")
		+ "ДокументооборотСКонтролирующимиОрганами_ИмяКриптопровайдера,
		|ДокументооборотСКонтролирующимиОрганами_ТипКриптопровайдера,
		|ДокументооборотСКонтролирующимиОрганами_РежимТестирования";
	КонстантыНабор = Константы.СоздатьНабор(ИменаКонстантНабора);
	
	Если НЕ ОбщегоНазначения.РазделениеВключено() Тогда
		КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль = ИспользоватьВнешнийМодуль;
		
		Если ЗначениеЗаполнено(ДанныеМодуля) Тогда
			Если ТипЗнч(ДанныеМодуля) = Тип("ДвоичныеДанные") Тогда 
				КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль = Новый ХранилищеЗначения(ДанныеМодуля);
			ИначеЕсли ЭтоАдресВременногоХранилища(ДанныеМодуля) Тогда 
				ДанныеМодуля = ПолучитьИзВременногоХранилища(ДанныеМодуля);
				КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль = Новый ХранилищеЗначения(ДанныеМодуля);
			КонецЕсли;
			КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ВерсияВнешнегоМодуля = ВерсияМодуля;
		Иначе
			КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль = Неопределено;
			КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ВерсияВнешнегоМодуля = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаCSPЗначение = РеквизитФормыВЗначение("ТаблицаCSP");
	СтрКриптопровайдер = ТаблицаCSPЗначение.Найти(Криптопровайдер, "Код");
	Если ЗначениеЗаполнено(СтрКриптопровайдер) Тогда
		// определение типа (программы) криптопровайдера и получение параметров с алгоритмом по умолчанию для него
		СвойстваКриптопровайдера = КриптографияЭДКОКлиентСервер.СвойстваКриптопровайдера(СтрКриптопровайдер.Имя, СтрКриптопровайдер.Тип);
		Если СвойстваКриптопровайдера <> Неопределено Тогда
			СтрКриптопровайдер = СвойстваКриптопровайдера;
			ПараметрыКриптопровайдера = КриптографияЭДКОКлиентСервер.СвойстваКриптопровайдераПоУмолчанию(СвойстваКриптопровайдера.ТипКриптопровайдера);
			Если ЗначениеЗаполнено(ПараметрыКриптопровайдера.Имя) ИЛИ ЗначениеЗаполнено(ПараметрыКриптопровайдера.Тип) Тогда
				СтрКриптопровайдер = СвойстваКриптопровайдера;
			КонецЕсли;
		КонецЕсли;
		
		КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ИмяКриптопровайдера = СтрКриптопровайдер.Имя;
		КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ТипКриптопровайдера = СтрКриптопровайдер.Тип;
		
	Иначе
		КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ИмяКриптопровайдера = Неопределено;
		КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ТипКриптопровайдера = Неопределено;
	КонецЕсли;
	
	КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_РежимТестирования = ИспользоватьРежимТестирования;
	
	КонстантыНабор.Записать();
	Если ИзменениеВнешнегоМодуляРазрешено Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	// сохраняем индивидуальные настройки
	ХранилищеОбщихНастроек.Сохранить("ДокументооборотСКонтролирующимиОрганами_РазрешитьОнлайнОбновление", , РазрешитьОбновлениеМодуля);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Модифицированность 	= Ложь;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьВнешнийМодуль()
	
	ФайлыБылиВыбраны = Ложь;
	ДанныеМодуля = Неопределено;

	ВыбранноеИмяФайла = "";
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВнешнийМодульЗавершение", ЭтотОбъект);
	НачатьПомещениеФайла(ОписаниеОповещения, ДанныеМодуля, ВыбранноеИмяФайла, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВнешнийМодульЗавершение(ФайлыБылиВыбраны, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	ВыбранКорректныйФайл = КонтекстЭДОКлиент.ВыбранКорректныйФайл(ВыбранноеИмяФайла, ".epf");
	Если НЕ ВыбранКорректныйФайл Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Загружать можно только файлы с расширением *.epf'"));
	Иначе
		ДанныеМодуля = Адрес;
		ВыбратьВнешнийМодульИзменитьПеременные(ФайлыБылиВыбраны, ВыбранноеИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВнешнийМодульИзменитьПеременные(ФайлыБылиВыбраны, ВыбранноеИмяФайла)
	
	Если ФайлыБылиВыбраны И ЗначениеЗаполнено(ДанныеМодуля) Тогда
		стрВерсияМодуля = ПолучитьВерсиюВнешнегоМодуляИзФайла(ДанныеМодуля, ВыбранноеИмяФайла);
		Если стрВерсияМодуля = Неопределено Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Выбранный файл не является внешним модулем документооборота!'"));
			
		Иначе
			
			ВерсияМодуля           = стрВерсияМодуля;
			ИзмененыСвойстваМодуля = Истина;
			Модифицированность     = Истина;
			
			УправлениеЭУ();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УправлениеЭУВРежимеСервиса()
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда 
		Элементы.ГруппаВнешнийМодуль.Видимость = Ложь;
		Элементы.ГруппаПрокси.Видимость = Ложь;
		Элементы.ГруппаОбновлениеМодуля.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаВнешнийМодульВРежимеСервиса.Видимость = ОбщегоНазначения.РазделениеВключено() И ИспользоватьВнешнийМодуль;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеЭУ(ПослеЗаменыМодуля = Ложь)
	
	Если НЕ ПослеЗаменыМодуля Тогда
		// поле с представлением внешнего модуля делаем доступным только если установлен
		// признак использования внешнего модуля
		Элементы.ПолеМодульДокументооборотаПредставление.Доступность = ИспользоватьВнешнийМодуль;
	КонецЕсли;
	
	// формируем представление внешнего модуля
	Если НЕ ЗначениеЗаполнено(ДанныеМодуля) Тогда
		МодульДокументооборотаПредставление = "";
	Иначе
		МодульДокументооборотаПредставление = "";
		Если ЗначениеЗаполнено(ВерсияМодуля) Тогда
			МодульДокументооборотаПредставление = "Модуль версии " + ВерсияМодуля;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(МодульДокументооборотаПредставление) И ЗначениеЗаполнено(ДанныеМодуля) Тогда
			МодульДокументооборотаПредставление = "Модуль загружен";
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПослеЗаменыМодуля Тогда
		// формируем информацию о внешнем модуле для отображения в режиме сервиса
		Если ЗначениеЗаполнено(ВерсияМодуля) Тогда
			Элементы.ДекорацияЗагруженВнешнийМодульВРежимеСервиса.Заголовок = СтрШаблон(
				НСтр("ru = 'Загружен внешний модуль версии %1'"),
				ВерсияМодуля);
		Иначе
			Элементы.ДекорацияЗагруженВнешнийМодульВРежимеСервиса.Заголовок = НСтр("ru = 'Загружен внешний модуль'");
		КонецЕсли;
		
		//путь модуля криптографии задается лишь для линукса
		Если ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоЛинукс() Тогда
			Элементы.ГруппаКриптография.Видимость = Истина;
			Элементы.ГруппаВнешняяКомпонента.Отображение = ОтображениеОбычнойГруппы.Нет;
		Иначе
			Элементы.ГруппаКриптография.Видимость = Ложь;
			Элементы.ГруппаВнешняяКомпонента.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуВнешняяКомпонента(ПредлагатьУстановкуКомпоненты = Ложь)
	
	Оповещение = Новый ОписаниеОповещения(
		"ОбновитьГруппуВнешняяКомпонентаЗавершение", ЭтотОбъект);
	КриптографияЭДКОКлиент.СоздатьМенеджерКриптографии(Оповещение, Ложь,, ПредлагатьУстановкуКомпоненты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуВнешняяКомпонентаЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		//компонента установлена
		Элементы.ТекущийСтатус.Заголовок = НСтр("ru = 'Внешняя компонента: установлена.'");
		Элементы.УстановитьКомпоненту.Видимость = Ложь;
	Иначе
		//компонента не установлена
		Элементы.ТекущийСтатус.Заголовок = НСтр("ru = 'Внешняя компонента: не установлена.'");
		Элементы.УстановитьКомпоненту.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСейчасЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	ПараметрыВнешнегоМодуля =
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ПараметрыВнешнегоМодуляДокументооборота();
	ВнешнийМодульЗаменен = (ПараметрыВнешнегоМодуля.ИспользоватьВнешнийМодуль = Истина И ИспользоватьВнешнийМодуль
		И Строка(ПараметрыВнешнегоМодуля.ВерсияВнешнегоМодуля) <> ВерсияМодуля);
	Если ВнешнийМодульЗаменен Тогда
		// после замены одного модуля на другой серверные вызовы прежнего модуля приводят к ошибкам
		ИспользоватьВнешнийМодуль 	= (ПараметрыВнешнегоМодуля.ИспользоватьВнешнийМодуль = Истина);
		ДанныеМодуля 				= ПараметрыВнешнегоМодуля.ВнешнийМодуль;
		ВерсияМодуля 				= Строка(ПараметрыВнешнегоМодуля.ВерсияВнешнегоМодуля);
		
		УправлениеЭУ(Истина);
		Если ВнешнийМодульЗаменен Тогда
			ВопросПерезапуститьПрограммуПослеОбновленияМодуля();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ВосстановитьНастройки();
	УправлениеЭУ();
	
КонецПроцедуры

#КонецОбласти 

#КонецОбласти

