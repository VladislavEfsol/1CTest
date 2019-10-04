#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ВерсияПеречняСодержитГруппу35()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДопустимыеЦелиПоГруппамПриказаВЕТИС.ГруппаПриказа КАК ГруппаПриказа
	|ИЗ
	|	РегистрСведений.ДопустимыеЦелиПоГруппамВЕТИС КАК ДопустимыеЦелиПоГруппамПриказаВЕТИС
	|ГДЕ
	|	ДопустимыеЦелиПоГруппамПриказаВЕТИС.ГруппаПриказа = ЗНАЧЕНИЕ(Перечисление.ГруппыПродукцииУполномоченныхЛиц.Группа35Строка1)";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ДанныеОбновленыНаНовуюВерсиюПрограммы(МетаданныеИОтбор) Экспорт

	Возврат ВерсияПеречняСодержитГруппу35();

КонецФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры = Неопределено) Экспорт
	
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра",             "РегистрСведений.ДопустимыеЦелиПоГруппамВЕТИС");
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ЭтоДвижения",                   Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДопустимыеЦелиПоГруппамПриказаВЕТИС.ГруппаПриказа КАК ГруппаПриказа,
	|	ДопустимыеЦелиПоГруппамПриказаВЕТИС.ЦельИдентификатор КАК ЦельИдентификатор
	|ИЗ
	|	РегистрСведений.ДопустимыеЦелиПоГруппамВЕТИС КАК ДопустимыеЦелиПоГруппамПриказаВЕТИС";
	
	Данные = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры = Неопределено) Экспорт
	
	Если Параметры <> Неопределено Тогда
		УзелРегистрации = ПланыОбмена.ОбновлениеИнформационнойБазы.УзелПоОчереди(Параметры.Очередь);
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ДопустимыеЦелиПоГруппамВЕТИС");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.ДопустимыеЦелиПоГруппамВЕТИС.СоздатьНаборЗаписей();
		НаборЗаписей.Записать();
		
		ДопустимыеЦелиВЕТИС.ЗаполнитьДанныеВРегистреДопустимыеЦелиПоГруппамПриказаВЕТИС();
		
		Если Параметры <> Неопределено Тогда
			ПланыОбмена.УдалитьРегистрациюИзменений(УзелРегистрации, Метаданные.РегистрыСведений.ДопустимыеЦелиПоГруппамВЕТИС);
			Параметры.ОбработкаЗавершена = Истина;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось обработать регистр ДопустимыеЦелиПоГруппамВЕТИС по причине: %1'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.РегистрыСведений.ДопустимыеЦелиПоГруппамВЕТИС,,
			ТекстСообщения);
		
		Если Параметры <> Неопределено Тогда
			Параметры.ОбработкаЗавершена = Ложь;
		КонецЕсли;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли