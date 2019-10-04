#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Ссылка");
	Поля.Добавить("Наименование");
	Поля.Добавить("ТребуетсяЗагрузка");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если Данные.ТребуетсяЗагрузка = Истина Тогда
		СтандартнаяОбработка = Ложь;
		Представление = НСтр("ru = '<не загружено>'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ХозяйствующийСубъект") И ЗначениеЗаполнено(Параметры.ХозяйствующийСубъект) Тогда
		СтандартнаяОбработка = Ложь;
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ВведенноеНаименование", Истина);
		Запрос.УстановитьПараметр("Ссылка", Параметры.ХозяйствующийСубъект);
		
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 50
		|	ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие КАК Предприятие,
		|	ПРЕДСТАВЛЕНИЕ(ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие) КАК ПредприятиеСтрока,
		|	ХозяйствующиеСубъектыВЕТИСПредприятия.НеИспользовать ИЛИ ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие.ПометкаУдаления КАК Пометка
		|ИЗ
		|	Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК ХозяйствующиеСубъектыВЕТИСПредприятия
		|ГДЕ
		|	ХозяйствующиеСубъектыВЕТИСПредприятия.Ссылка = &Ссылка
		|	И &ВведенноеНаименование
		|УПОРЯДОЧИТЬ ПО Пометка";
		
		Если ЗначениеЗаполнено(Параметры.СтрокаПоиска) Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ВведенноеНаименование", "ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие.Наименование ПОДОБНО (&Наименование)");
			Запрос.УстановитьПараметр("Наименование", Параметры.СтрокаПоиска);
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();
		ДанныеВыбора = Новый СписокЗначений;
		Пока Выборка.Следующий() Цикл
			Элемент = ДанныеВыбора.Добавить();
			Элемент.Значение = Выборка.Предприятие;
			Элемент.Представление = Выборка.ПредприятиеСтрока;
			Элемент.Пометка = Выборка.Пометка;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка КАК Ссылка Из Справочник.ПредприятияВЕТИС КАК ПредприятияВЕТИС ГДЕ Не ТребуетсяЗагрузка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ПредприятияВетИС");
	
	ШаблонОшибкиОбработкиПредприятия =
		НСтр("ru = 'Не удалось обработать предприятие ВетИС ""%1"" по причине:
		           |%2'");
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДанныеПредприятия = ЦерберВЕТИСВызовСервера.ПредприятиеПоGUID(СправочникОбъект.Идентификатор, Истина);
			
			Если НЕ ЗначениеЗаполнено(ДанныеПредприятия.ТекстОшибки) Тогда
				
				ИнтеграцияВЕТИС.ЗагрузитьПредприятие(ДанныеПредприятия.Элемент, СправочникОбъект);
				
			Иначе
				
				СправочникОбъект.ИдентификаторВерсии   = Неопределено;
				СправочникОбъект.ТребуетсяЗагрузка     = Истина;
				СправочникОбъект.ОбменДанными.Загрузка = Истина;
				СправочникОбъект.Записать();
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			ТекстСообщения = СтрШаблон(ШаблонОшибкиОбработкиПредприятия,
				Строка(Выборка.Ссылка),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение, , , ТекстСообщения);
			Продолжить;
		КонецПопытки;
		
		ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
		
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ПредприятияВетИС") Тогда
		Параметры.ОбработкаЗавершена = Ложь;
	Иначе
		Параметры.ОбработкаЗавершена = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПредставлениеНомеровПроизводителей

// Заполняет колонку "Номера предприятий" табличной части объекта или таблицы формы "Производители" в формах
//   В табличной части должны присутствовать колонки "Производитель", "НомераПредприятия"
// 
// Параметры:
//   Производители - ДанныеФормыКоллекция - заполняемая коллекция
//   Производитель - Неопределено, Справочникссылка.ПроизводителиВЕТИС - изменившееся значение производителя
//
Процедура ЗаполнитьНомера(Производители, Знач Производитель = Неопределено) Экспорт
	
	МассивЗаписей = Новый Массив;
	
	Если Производитель = Неопределено Тогда
		
		МассивЗаписей = Новый Массив;
		Для каждого Строка Из Производители Цикл
			МассивЗаписей.Добавить(Строка.Производитель);
		КонецЦикла;
	
	Иначе
		
		МассивЗаписей.Добавить(Производитель);
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НомераПредприятий.Ссылка КАК Ссылка,
	|	НомераПредприятий.Номер КАК Номер
	|ИЗ
	|	Справочник.ПредприятияВЕТИС.НомераПредприятий КАК НомераПредприятий
	|ГДЕ
	|	НомераПредприятий.Ссылка В (&Ссылка)
	|ИТОГИ
	|	КОЛИЧЕСТВО(Номер)
	|ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", МассивЗаписей);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		НомераПредприятия = "";
		ДетальныеЗаписи = Выборка.Выбрать();
		Если Выборка.Номер = 1 Тогда
			ДетальныеЗаписи.Следующий();
			НомераПредприятия = СокрЛП(ДетальныеЗаписи.Номер);
		ИначеЕсли Выборка.Номер > 1 Тогда
			Номер = Новый Массив;
			Пока ДетальныеЗаписи.Следующий() Цикл
				Номер.Добавить(СокрЛП(ДетальныеЗаписи.Номер));
			КонецЦикла;
			Номер = СтрСоединить(Номер, "; ");
			Если СтрДлина(Номер) > 75 Тогда
				Номер = СтрШаблон(НСтр("ru = '(%1) '"), Выборка.Номер) + Номер;
				Номер = Лев(Номер, 72)+"...";
			КонецЕсли;
			НомераПредприятия = Номер;
		КонецЕсли;
		
		Для Каждого СтрокаТаблицы Из Производители.НайтиСтроки(Новый Структура("Производитель", Выборка.Ссылка)) Цикл
			СтрокаТаблицы.НомераПредприятий = НомераПредприятия;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли