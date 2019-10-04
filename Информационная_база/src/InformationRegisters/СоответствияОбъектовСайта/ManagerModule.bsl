#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	ПроверяемыеРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Добавить("УзелИнформационнойБазы");
	ПроверяемыеРеквизиты.Добавить("УникальныйИдентификаторПриемника");
	
	Для Каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
		Если СтруктураЗаписи.Свойство(ПроверяемыйРеквизит)
			И Не ЗначениеЗаполнено(СтруктураЗаписи[ПроверяемыйРеквизит]) Тогда
			
			ОписаниеСобытия = НСтр("ru = 'Добавление записи регистра сведений ""Соответствия объектов информационных баз""'");
			Комментарий     = НСтр("ru = 'Не заполнен реквизит %1. Создание записи регистра невозможно.'");
			Комментарий     = СтрШаблон(Комментарий, ПроверяемыйРеквизит);
			ЗаписьЖурналаРегистрации(ОписаниеСобытия, 
			                         УровеньЖурналаРегистрации.Ошибка,
			                         Метаданные.РегистрыСведений.СоответствияОбъектовИнформационныхБаз,
			                         ,
			                         Комментарий);
			
			Возврат;
			
		КонецЕсли;
	КонецЦикла;
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СоответствияОбъектовИнформационныхБаз", Загрузка);
	
КонецПроцедуры

// Процедура удаляет набор записей в регистре по переданным значениям структуры.
Процедура УдалитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	ОбменДаннымиСервер.УдалитьНаборЗаписейВРегистреСведений(СтруктураЗаписи, "СоответствияОбъектовИнформационныхБаз", Загрузка);
	
КонецПроцедуры

Функция ОбъектЕстьВРегистре(Объект, УзелИнформационнойБазы) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ 1
	|ИЗ
	|	РегистрСведений.СоответствияОбъектовИнформационныхБаз КАК СоответствияОбъектовИнформационныхБаз
	|ГДЕ
	|	  СоответствияОбъектовИнформационныхБаз.УзелИнформационнойБазы           = &УзелИнформационнойБазы
	|	И СоответствияОбъектовИнформационныхБаз.УникальныйИдентификаторИсточника = &УникальныйИдентификаторИсточника
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы",           УзелИнформационнойБазы);
	Запрос.УстановитьПараметр("УникальныйИдентификаторИсточника", Объект);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

Процедура УдалитьНеактуальныеЗаписиРежимаВыгрузкиПоСсылке(УзелИнформационнойБазы) Экспорт
	
	ТекстЗапроса = "
	|////////////////////////////////////////////////////////// {СоответствияОбъектовИнформационныхБазПоСсылке}
	|ВЫБРАТЬ
	|	СоответствияОбъектовИнформационныхБаз.УзелИнформационнойБазы,
	|	СоответствияОбъектовИнформационныхБаз.УникальныйИдентификаторИсточника,
	|	СоответствияОбъектовИнформационныхБаз.УникальныйИдентификаторПриемника,
	|	СоответствияОбъектовИнформационныхБаз.ТипПриемника,
	|	СоответствияОбъектовИнформационныхБаз.ТипИсточника
	|ПОМЕСТИТЬ СоответствияОбъектовИнформационныхБазПоСсылке
	|ИЗ
	|	РегистрСведений.СоответствияОбъектовИнформационныхБаз КАК СоответствияОбъектовИнформационныхБаз
	|ГДЕ
	|	  СоответствияОбъектовИнформационныхБаз.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И СоответствияОбъектовИнформационныхБаз.ОбъектВыгруженПоСсылке
	|;
	|
	|//////////////////////////////////////////////////////////{}
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствияОбъектовИнформационныхБазПоСсылке.УзелИнформационнойБазы,
	|	СоответствияОбъектовИнформационныхБазПоСсылке.УникальныйИдентификаторИсточника,
	|	СоответствияОбъектовИнформационныхБазПоСсылке.УникальныйИдентификаторПриемника,
	|	СоответствияОбъектовИнформационныхБазПоСсылке.ТипПриемника,
	|	СоответствияОбъектовИнформационныхБазПоСсылке.ТипИсточника
	|ИЗ
	|	СоответствияОбъектовИнформационныхБазПоСсылке КАК СоответствияОбъектовИнформационныхБазПоСсылке
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствияОбъектовИнформационныхБаз КАК СоответствияОбъектовИнформационныхБаз
	|ПО   СоответствияОбъектовИнформационныхБаз.УникальныйИдентификаторИсточника = СоответствияОбъектовИнформационныхБазПоСсылке.УникальныйИдентификаторИсточника
	|	И СоответствияОбъектовИнформационныхБаз.ОбъектВыгруженПоСсылке = ЛОЖЬ
	|	И СоответствияОбъектовИнформационныхБаз.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|ГДЕ
	|	НЕ СоответствияОбъектовИнформационныхБаз.УзелИнформационнойБазы ЕСТЬ NULL
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СтруктураЗаписи = Новый Структура("УзелИнформационнойБазы, УникальныйИдентификаторИсточника, УникальныйИдентификаторПриемника, ТипПриемника, ТипИсточника");
			
			ЗаполнитьЗначенияСвойств(СтруктураЗаписи, Выборка);
			
			УдалитьЗапись(СтруктураЗаписи, Истина);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьОбъектВФильтрРазрешенныхОбъектов(Знач Объект, Знач Получатель) Экспорт
	
	Если Не ОбъектЕстьВРегистре(Объект, Получатель) Тогда
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", Получатель);
		СтруктураЗаписи.Вставить("УникальныйИдентификаторИсточника", Объект);
		СтруктураЗаписи.Вставить("ОбъектВыгруженПоСсылке", Истина);
		
		ДобавитьЗапись(СтруктураЗаписи, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли