#Область ОписаниеПеременных

&НаКлиенте
Перем СписокПредставленийДанных;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.ПредставлениеДанных;
	
	Для каждого Представление Из Параметры.СписокПредставленийДанных Цикл
		Список.Добавить().Представление = Представление;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьДанные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура УстановитьСписокПредставлений(СписокПредставлений, Контекст) Экспорт
	
	СписокПредставленийДанных = СписокПредставлений;
	
	Контекст = Новый ОписаниеОповещения("УстановитьСписокПредставлений", ЭтотОбъект, Контекст);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокОткрыть()
	
	ОткрытьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДанные()
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Строка = Список.НайтиПоИдентификатору(Элементы.Список.ТекущаяСтрока);
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Индекс = Список.Индекс(Строка);
	
	Значение = СписокПредставленийДанных[Индекс].Значение;
	
	Если ТипЗнч(Значение) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(Значение);
	Иначе
		ПоказатьЗначение(, Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
