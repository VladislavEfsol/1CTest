
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики операций

// Соответствует операции GetExchangeFeatures
Функция ПолучитьПланыОбменаКонфигурации()
	
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ExchangeAdministration/Common/2.4.5.1", "ExchangeFeatures"));
	ТипExchangeFeature = ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ExchangeAdministration/Common/2.4.5.1", "ExchangeFeature");
	
	Для Каждого ИмяПланаОбмена Из ОбменДаннымиВМоделиСервисаПовтИсп.ПланыОбменаСинхронизацииДанных() Цикл
		
		ИмяКонфигурацииИсточника = "";
		ИмяКонфигурацииПриемника = Новый Структура;
		ФорматОбмена = "";
		
		ВерсияБСП243 = ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СтандартныеПодсистемыСервер.ВерсияБиблиотеки(), "2.4.3.1") >= 0;
		
		Если ВерсияБСП243 Тогда
			НастройкиОбмена = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена,
				"ИмяКонфигурацииИсточника, ФорматОбмена, ЭтоПланОбменаXDTO, ИмяКонфигурацииПриемника");
			
			ИмяКонфигурацииИсточника = НастройкиОбмена.ИмяКонфигурацииИсточника;
			
			Если НастройкиОбмена.ИмяКонфигурацииПриемника <> Неопределено Тогда
				Если НастройкиОбмена.ЭтоПланОбменаXDTO Тогда
					ФорматОбмена = НастройкиОбмена.ФорматОбмена;
				Иначе
					ФорматОбмена = ИмяПланаОбмена;
				КонецЕсли;
				
				ИмяКонфигурацииПриемника = НастройкиОбмена.ИмяКонфигурацииПриемника;
			КонецЕсли;
		Иначе
			ИмяКонфигурацииИсточника = ПланыОбмена[ИмяПланаОбмена].ИмяКонфигурацииИсточника();
		КонецЕсли;
		
		Если ПустаяСтрока(ИмяКонфигурацииИсточника) Тогда
			Если ВерсияБСП243 Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не задано возвращаемое значение функции ИмяКонфигурацииИсточника() в модуле менеджера плана обмена %1'"),
					ИмяПланаОбмена);
			Иначе
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не задано значение свойства ИмяКонфигурацииИсточника в процедуре ПриПолученииНастроек() модуля менеджера плана обмена %1'"),
					ИмяПланаОбмена);
			КонецЕсли;
		КонецЕсли;
		
		Если ИмяКонфигурацииПриемника.Количество() > 0 Тогда
			Для Каждого Приемник Из ИмяКонфигурацииПриемника Цикл
				ExchangeFeature = ФабрикаXDTO.Создать(ТипExchangeFeature);
				ExchangeFeature.ExchangePlan   = ИмяПланаОбмена;
				ExchangeFeature.ExchangeRole   = ИмяКонфигурацииИсточника;
				ExchangeFeature.ExchangeFormat = ФорматОбмена;
				ExchangeFeature.ExchangeCorrespondentRole = Приемник.Ключ;
				
				Результат.Feature.Добавить(ExchangeFeature);
			КонецЦикла;
		Иначе
			ExchangeFeature = ФабрикаXDTO.Создать(ТипExchangeFeature);
			ExchangeFeature.ExchangePlan   = ИмяПланаОбмена;
			ExchangeFeature.ExchangeRole   = ИмяКонфигурацииИсточника;
			ExchangeFeature.ExchangeFormat = ФорматОбмена;
			
			Результат.Feature.Добавить(ExchangeFeature);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Соответствует операции PrepareExchangeExecution
Функция ЗапланироватьВыполнениеОбменаДанными(ОбластиДляОбменаДаннымиXDTO)
	
	ОбластиДляОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(ОбластиДляОбменаДаннымиXDTO);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого Элемент Из ОбластиДляОбменаДанными Цикл
		
		ЗначениеРазделителя = Элемент.Ключ;
		СценарийОбменаДанными = Элемент.Значение;
		
		Параметры = Новый Массив;
		Параметры.Добавить(СценарийОбменаДанными);
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода"    , "ОбменДаннымиВМоделиСервиса.ВыполнитьОбменДанными");
		ПараметрыЗадания.Вставить("Параметры"    , Параметры);
		ПараметрыЗадания.Вставить("Ключ"         , "1");
		ПараметрыЗадания.Вставить("ОбластьДанных", ЗначениеРазделителя);
		
		Попытка
			ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		Исключение
			Если ИнформацияОбОшибке().Описание <> ОчередьЗаданий.ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат "";
КонецФункции

// Соответствует операции StartExchangeExecutionInFirstDataBase
Функция ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазе(ИндексСтрокиСценария, СценарийОбменаДаннымиXDTO)
	
	СценарийОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(СценарийОбменаДаннымиXDTO);
	
	СтрокаСценария = СценарийОбменаДанными[ИндексСтрокиСценария];
	
	Ключ = СтрокаСценария.ИмяПланаОбмена + СтрокаСценария.КодУзлаИнформационнойБазы + СтрокаСценария.КодЭтогоУзла;
	
	РежимОбмена = РежимОбменаДанными(СценарийОбменаДанными);
	
	Если РежимОбмена = "Ручной" Тогда
		
		Параметры = Новый Массив;
		Параметры.Добавить(ИндексСтрокиСценария);
		Параметры.Добавить(СценарийОбменаДанными);
		Параметры.Добавить(СтрокаСценария.ЗначениеРазделителяПервойИнформационнойБазы);
		
		ФоновыеЗадания.Выполнить("ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазеИзНеразделенногоСеанса",
			Параметры, Ключ);
	ИначеЕсли РежимОбмена = "Автоматический" Тогда
		
		Попытка
			Параметры = Новый Массив;
			Параметры.Добавить(ИндексСтрокиСценария);
			Параметры.Добавить(СценарийОбменаДанными);
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("ОбластьДанных", СтрокаСценария.ЗначениеРазделителяПервойИнформационнойБазы);
			ПараметрыЗадания.Вставить("ИмяМетода", "ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазе");
			ПараметрыЗадания.Вставить("Параметры", Параметры);
			ПараметрыЗадания.Вставить("Ключ", Ключ);
			ПараметрыЗадания.Вставить("Использование", Истина);
			
			УстановитьПривилегированныйРежим(Истина);
			ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		Исключение
			Если ИнформацияОбОшибке().Описание <> ОчередьЗаданий.ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неизвестный режим обмена данными %1'"), Строка(РежимОбмена));
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Соответствует операции StartExchangeExecutionInSecondDataBase
Функция ВыполнитьДействиеСценарияОбменаДаннымиВоВторойИнформационнойБазе(ИндексСтрокиСценария, СценарийОбменаДаннымиXDTO)
	
	СценарийОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(СценарийОбменаДаннымиXDTO);
	
	СтрокаСценария = СценарийОбменаДанными[ИндексСтрокиСценария];
	
	Ключ = СтрокаСценария.ИмяПланаОбмена + СтрокаСценария.КодУзлаИнформационнойБазы + СтрокаСценария.КодЭтогоУзла;
	
	РежимОбмена = РежимОбменаДанными(СценарийОбменаДанными);
	
	Если РежимОбмена = "Ручной" Тогда
		
		Параметры = Новый Массив;
		Параметры.Добавить(ИндексСтрокиСценария);
		Параметры.Добавить(СценарийОбменаДанными);
		Параметры.Добавить(СтрокаСценария.ЗначениеРазделителяВторойИнформационнойБазы);
		
		ФоновыеЗадания.Выполнить("ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВоВторойИнформационнойБазеИзНеразделенногоСеанса",
			Параметры, Ключ);
		
	ИначеЕсли РежимОбмена = "Автоматический" Тогда
		
		Попытка
			Параметры = Новый Массив;
			Параметры.Добавить(ИндексСтрокиСценария);
			Параметры.Добавить(СценарийОбменаДанными);
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("ОбластьДанных", СтрокаСценария.ЗначениеРазделителяВторойИнформационнойБазы);
			ПараметрыЗадания.Вставить("ИмяМетода", "ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВоВторойИнформационнойБазе");
			ПараметрыЗадания.Вставить("Параметры", Параметры);
			ПараметрыЗадания.Вставить("Ключ", Ключ);
			ПараметрыЗадания.Вставить("Использование", Истина);
			
			УстановитьПривилегированныйРежим(Истина);
			ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		Исключение
			Если ИнформацияОбОшибке().Описание <> ОчередьЗаданий.ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неизвестный режим обмена данными %1'"), Строка(РежимОбмена));
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Соответствует операции TestConnection
Функция ПроверитьПодключение(СтруктураНастроекXDTO, ВидТранспортаСтрокой, СообщениеОбОшибке)
	
	Отказ = Ложь;
	
	// Проверяем подключение обработки транспорта сообщений обмена.
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		МодульОбменДаннымиСервер.ПроверитьПодключениеОбработкиТранспортаСообщенийОбмена(Отказ,
			СериализаторXDTO.ПрочитатьXDTO(СтруктураНастроекXDTO),
			Перечисления.ВидыТранспортаСообщенийОбмена[ВидТранспортаСтрокой],
			СообщениеОбОшибке);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Соответствует операции Ping
Функция Ping()
	
	// Заглушка. Необходима, чтобы не выдавалась ошибка проверки конфигурации.
	Заглушка = Истина;
	
КонецФункции

//

Функция РежимОбменаДанными(СценарийОбменаДанными)
	
	Результат = "Ручной";
	
	Если СценарийОбменаДанными.Колонки.Найти("Режим") <> Неопределено Тогда
		Результат = СценарийОбменаДанными[0].Режим;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
