////////////////////////////////////////////////////////////////////////////////
// Модуль менеджера РегистрСведений.СостоянияОбменовЭДЧерезОператоровЭДО
//  
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Ложь;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.СостоянияОбменовЭДЧерезОператоровЭДО";
	ДополнительныеПараметры.ОтметитьВсеРегистраторы = Ложь;
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	
	// Переход на новую архитектуру настроек ЭДО.
	Данные = ДанныеКОбработке_НоваяАрхитектураНастроекЭДО();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИнициализироватьПараметрыОбработкиДляПереходаНаНовуюВерсию(Параметры);
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.СостоянияОбменовЭДЧерезОператоровЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	ОбработанныхОбъектов = 0;
	ПроблемныхОбъектов = 0;
	
	ПараметрыВыборки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	ПараметрыВыборки.ДополнительныеИсточникиДанных.Вставить("УдалитьПрофильНастроекЭДО");
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь, ПолноеИмяОбъекта, ПараметрыВыборки);
	
	ИдентификаторыПрофилей = ИдентификаторыПрофилейНастроекЭДО();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("УдалитьПрофильНастроекЭДО", Выборка.УдалитьПрофильНастроекЭДО);
			ЭлементБлокировки.УстановитьЗначение("УдалитьСоглашениеОбИспользованииЭД", Выборка.УдалитьСоглашениеОбИспользованииЭД);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Набор = РегистрыСведений.СостоянияОбменовЭДЧерезОператоровЭДО.СоздатьНаборЗаписей();
			Набор.Отбор.УдалитьПрофильНастроекЭДО.Установить(Выборка.УдалитьПрофильНастроекЭДО);
			Набор.Отбор.УдалитьСоглашениеОбИспользованииЭД.Установить(Выборка.УдалитьСоглашениеОбИспользованииЭД);
			Набор.Прочитать();
			
			Записать = Ложь;
			
			ОбработатьДанные_НоваяАрхитектураНастроекЭДО(Набор, ИдентификаторыПрофилей, Записать);
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор);
			КонецЕсли;
			
			ОбработанныхОбъектов = ОбработанныхОбъектов + 1;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			ТекстСообщения = НСтр("ru = 'Не удалось обработать состояния обменов электронных документов по причине:'") + Символы.ПС 
				+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта,, ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если ОбработанныхОбъектов = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые состояния обменов электронных документов (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция состояний обменов электронных документов: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбработанныхОбъектов);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов  = Параметры.ПрогрессВыполнения.ОбработаноОбъектов  + ОбработанныхОбъектов;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Обновление

Процедура ИнициализироватьПараметрыОбработкиДляПереходаНаНовуюВерсию(Параметры)
	
	// Определим общее количество объектов к обработке.
	Если Параметры.ПрогрессВыполнения.ВсегоОбъектов = 0 Тогда
		
		ПараметрыВыборки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
		ПараметрыВыборки.ВыбиратьПорциями = Ложь;
		Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
			Параметры.Очередь, "РегистрСведений.СостоянияОбменовЭДЧерезОператоровЭДО", ПараметрыВыборки);
		Параметры.ПрогрессВыполнения.ВсегоОбъектов = Выборка.Количество();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДанныеКОбработке_НоваяАрхитектураНастроекЭДО()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияОбменов.УдалитьПрофильНастроекЭДО КАК УдалитьПрофильНастроекЭДО,
	|	СостоянияОбменов.УдалитьСоглашениеОбИспользованииЭД КАК УдалитьСоглашениеОбИспользованииЭД
	|ИЗ
	|	РегистрСведений.СостоянияОбменовЭДЧерезОператоровЭДО КАК СостоянияОбменов
	|ГДЕ
	|	СостоянияОбменов.ИдентификаторОрганизации = """"
	|	И СостоянияОбменов.УдалитьПрофильНастроекЭДО <> ЗНАЧЕНИЕ(Справочник.УдалитьПрофилиНастроекЭДО.ПустаяСсылка)";
	
	Данные = Запрос.Выполнить().Выгрузить();
	
	Возврат Данные;
	
КонецФункции

Процедура ОбработатьДанные_НоваяАрхитектураНастроекЭДО(Набор, ИдентификаторыПрофилей, Записать)
	
	Для каждого Запись Из Набор Цикл
		
		Если Не ЗначениеЗаполнено(Запись.ИдентификаторОрганизации)
			И ЗначениеЗаполнено(Запись.УдалитьПрофильНастроекЭДО) Тогда
			
			СтрокаИдентификатора = ИдентификаторыПрофилей.Найти(Запись.УдалитьПрофильНастроекЭДО, "ПрофильНастроекЭДО");
			Если СтрокаИдентификатора = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если Запись.ИдентификаторОрганизации <> СтрокаИдентификатора.ИдентификаторОрганизации Тогда
				Записать = Истина;
				Запись.ИдентификаторОрганизации = СтрокаИдентификатора.ИдентификаторОрганизации;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИдентификаторыПрофилейНастроекЭДО()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УдалитьПрофилиНастроекЭДО.Ссылка КАК ПрофильНастроекЭДО,
	|	УдалитьПрофилиНастроекЭДО.ИдентификаторОрганизации КАК ИдентификаторОрганизации
	|ИЗ
	|	Справочник.УдалитьПрофилиНастроекЭДО КАК УдалитьПрофилиНастроекЭДО";
	
	Идентификаторы = Запрос.Выполнить().Выгрузить();
	Идентификаторы.Индексы.Добавить("ПрофильНастроекЭДО");
	
	Возврат Идентификаторы;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли