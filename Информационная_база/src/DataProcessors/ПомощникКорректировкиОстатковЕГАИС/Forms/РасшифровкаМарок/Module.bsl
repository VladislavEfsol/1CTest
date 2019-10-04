
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	ПроверитьОбработатьПереданныеПараметры(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ПринудительноЗакрытьФорму И НЕ ЗавершениеРаботы И Модифицированность Тогда
		
		Отказ = Истина;
		
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Сохранить'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не сохранять'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru = 'Введенные данные не сохранены, сохранить?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перепроверить(Команда)
	
	Для Каждого Марка Из Марки Цикл
		Если Марка.Факт Тогда
			Модифицированность = Истина;
			Марка.Факт = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	Для Каждого Марка Из Марки Цикл
		Если НЕ Марка.Факт Тогда
			Модифицированность = Истина;
			Марка.Факт = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура Готово(Команда)
	
	ВыполнитьСохранениеРезультата();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьОбработатьПереданныеПараметры(Отказ)
	
	Если Параметры.Марки.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.ПроверялосьУТМ Тогда
		Элементы.МаркиУТМ.Видимость = Ложь;
	КонецЕсли;
	
	Остаток = Параметры.Остаток;
	
	Для Каждого НоваяМарка Из Параметры.Марки Цикл
		ЗаполнитьЗначенияСвойств(Марки.Добавить(), НоваяМарка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		
		ВыполнитьСохранениеРезультата();
		
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСохранениеРезультата()
	
	ВыбраноМарок = ВыбраноВсего();
	Если ВыбраноМарок > Остаток Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(НСтр("ru = 'Выбрано слишком много марок (%1 из %2)'"), ВыбраноМарок, Остаток),,
			"Марки");
		Возврат;
	КонецЕсли;
	
	РезультатСопоставления = Новый Массив;
	Для Каждого НоваяМарка Из Марки Цикл
		ДанныеСтроки = Новый Структура;
		ДанныеСтроки.Вставить("АкцизнаяМарка", НоваяМарка.АкцизнаяМарка);
		ДанныеСтроки.Вставить("Факт", НоваяМарка.Факт);
		РезультатСопоставления.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(РезультатСопоставления);
	
КонецПроцедуры

&НаКлиенте
Функция ВыбраноВсего()
	
	Выбрано = 0;
	Для Каждого НоваяМарка Из Марки Цикл
		Если НоваяМарка.Факт Тогда
			Выбрано = Выбрано + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Выбрано;
	
КонецФункции

#КонецОбласти
