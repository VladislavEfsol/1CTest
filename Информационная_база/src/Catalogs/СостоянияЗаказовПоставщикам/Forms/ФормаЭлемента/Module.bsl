
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Цвет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЗначениеКопирования, "Цвет").Получить();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Цвет = ТекущийОбъект.Цвет.Получить();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗначениеЦвета = Цвет;
	
	Если ЗначениеЦвета = Новый Цвет(0, 0, 0) Тогда
		ЗначениеЦвета = Неопределено;
	КонецЕсли;
	
	ТекущийОбъект.Цвет = Новый ХранилищеЗначения(ЗначениеЦвета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СостоянияЗаказовПоставщикам", Объект.Ссылка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
