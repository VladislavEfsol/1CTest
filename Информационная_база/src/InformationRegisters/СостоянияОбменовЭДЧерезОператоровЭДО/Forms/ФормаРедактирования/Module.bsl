
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("УчетнаяЗаписьЭДО") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СостоянияОбменовЭДЧерезОператоровЭДО.ДатаПолученияЭД КАК ДатаПолученияЭД,
		|	СостоянияОбменовЭДЧерезОператоровЭДО.ДатаПоследнегоПолученияПриглашений КАК ДатаПоследнегоПолученияПриглашений,
		|	СостоянияОбменовЭДЧерезОператоровЭДО.ДатаПоследнейАктивности КАК ДатаПоследнейАктивности,
		|	СостоянияОбменовЭДЧерезОператоровЭДО.ИдентификаторОрганизации КАК ИдентификаторОрганизации
		|ИЗ
		|	РегистрСведений.СостоянияОбменовЭДЧерезОператоровЭДО КАК СостоянияОбменовЭДЧерезОператоровЭДО
		|ГДЕ
		|	СостоянияОбменовЭДЧерезОператоровЭДО.ИдентификаторОрганизации = &УчетнаяЗаписьЭДО";
		Запрос.УстановитьПараметр("УчетнаяЗаписьЭДО", Параметры.УчетнаяЗаписьЭДО);
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		КонецЕсли;
		ИдентификаторОрганизации = Параметры.УчетнаяЗаписьЭДО;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И Не ЗавершениеРаботы Тогда
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОтветаНаВопрос", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаСервере();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеОтветаНаВопрос(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьИЗакрыть(Неопределено);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()

	НаборЗаписей = РегистрыСведений.СостоянияОбменовЭДЧерезОператоровЭДО.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторОрганизации.Установить(ИдентификаторОрганизации);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяЗапись, ЭтотОбъект);
	НаборЗаписей.Записать();
	
	Модифицированность = Ложь;

КонецПроцедуры

#КонецОбласти
