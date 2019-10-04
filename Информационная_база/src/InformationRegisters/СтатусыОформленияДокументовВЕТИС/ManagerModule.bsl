#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает структуру значений по умолчанию для документа для движений.
//
// Возвращаемое значение:
//	Структура - значения по умолчанию
//
Функция ЗначенияПолейЗаписиРегистраПоУмолчанию(Основание, СсылкаНаОформляемыйДокумент) Экспорт
	
	СтруктураЗначенияПоУмолчанию = Новый Структура;
	
	СтруктураЗначенияПоУмолчанию.Вставить("Документ",         СсылкаНаОформляемыйДокумент);
	СтруктураЗначенияПоУмолчанию.Вставить("Основание",        Основание);
	СтруктураЗначенияПоУмолчанию.Вставить("СтатусОформления", Перечисления.СтатусыОформленияДокументовВЕТИС.НеОформлено);
	
	СтруктураЗначенияПоУмолчанию.Вставить("Дата",  '00010101');
	СтруктураЗначенияПоУмолчанию.Вставить("Номер", "");
	СтруктураЗначенияПоУмолчанию.Вставить("Контрагент");
	СтруктураЗначенияПоУмолчанию.Вставить("ТорговыйОбъект");
	СтруктураЗначенияПоУмолчанию.Вставить("ПроизводственныйОбъект");
	СтруктураЗначенияПоУмолчанию.Вставить("Ответственный");
	СтруктураЗначенияПоУмолчанию.Вставить("ДополнительнаяИнформация");
	
	Возврат СтруктураЗначенияПоУмолчанию;
	
КонецФункции

// Проверяет наличие записи в регистре с указанными значениями измерений.
//
Функция ЕстьЗаписьРегистра(Основание, СсылкаНаОформляемыйДокумент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтатусыОформления.СтатусОформления
	|ИЗ
	|	РегистрСведений.СтатусыОформленияДокументовВЕТИС КАК СтатусыОформления
	|ГДЕ
	|	СтатусыОформления.Основание = &Основание
	|	И СтатусыОформления.Документ = &СсылкаНаОформляемыйДокумент";
	
	Запрос.УстановитьПараметр("Основание", Основание);
	Запрос.УстановитьПараметр("СсылкаНаОформляемыйДокумент", СсылкаНаОформляемыйДокумент);
	
	ЕстьЗаписьРегистра = НЕ Запрос.Выполнить().Пустой();
	
	Возврат ЕстьЗаписьРегистра;
	
КонецФункции

// Проверяет наличие записей в регистре по указанным документам-основаниям и документу ВЕТИС.
//
Функция ДокументыОснованияСЗаписямиРегистра(МассивДокументов, ПустаяСсылкаВЕТИС) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтатусыОформления.Основание
	|ИЗ
	|	РегистрСведений.СтатусыОформленияДокументовВЕТИС КАК СтатусыОформления
	|ГДЕ
	|	СтатусыОформления.Основание В (&МассивДокументов)
	|	И СтатусыОформления.Документ = &ПустаяСсылкаВЕТИС";
	
	Запрос.УстановитьПараметр("МассивДокументов",  МассивДокументов);
	Запрос.УстановитьПараметр("ПустаяСсылкаВЕТИС", ПустаяСсылкаВЕТИС);
	
	ДокументыСЗаписьюРегистра = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Основание");
	
	Возврат ДокументыСЗаписьюРегистра;
	
КонецФункции

// Осуществляет запись в регистр по переданным данным.
//
// Параметры:
//  ДанныеЗаписи - данные для записи в регистр
//
Процедура ВыполнитьЗаписьВРегистр(ДанныеЗаписи) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.СтатусыОформленияДокументовВЕТИС.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписи);
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Удаляет запись из регистра по переданному документу.
//
// Параметры:
//  Документ  - ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления - измерение регистра для очистки
//  Основание - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС     - измерение регистра для очистки
//
Процедура УдалитьЗаписьРегистра(Основание, Документ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.СтатусыОформленияДокументовВЕТИС.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Основание.Установить(Основание);
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	
	НаборЗаписей.Записать();
	
КонецПроцедуры


// Возвращает статусы оформления документов ВЕТИС по указанному документу-основанию.
//
// Параметры:
//	ДокументОснование - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС - документ-основание для документа ВЕТИС
//
// Возвращаемое значение:
//	Структура
//		Ключ - имя документа ВЕТИС как оно указано в метаданных
//		Значение - ПеречислениеСсылка.СтатусыОформленияДокументовВЕТИС - статус оформления
//
Функция СтатусыДокументовВЕТИСПоДокументуОснованию(ДокументОснование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Статусы.Документ,
	|	Статусы.СтатусОформления КАК Статус
	|ИЗ
	|	РегистрСведений.СтатусыОформленияДокументовВЕТИС КАК Статусы
	|ГДЕ
	|	Статусы.Основание = &ДокументОснование";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	СтатусыОформления = Новый Структура;
	
	Пока Выборка.Следующий() Цикл
		СтатусыОформления.Вставить(Выборка.Документ.Метаданные().Имя, Выборка.Статус);
	КонецЦикла;
	
	Возврат СтатусыОформления;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли
