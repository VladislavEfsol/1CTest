///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоЭтотУзел = (Объект.Ссылка = ОбменСообщениямиВнутренний.ЭтотУзел());
	
	Элементы.ГруппаИнформационныхСообщений.Видимость = Не ЭтоЭтотУзел;
	
	Если Не ЭтоЭтотУзел Тогда
		
		Если Объект.Заблокирована Тогда
			Элементы.ИнформационноеСообщение.Заголовок
				= НСтр("ru = 'Эта конечная точка заблокирована.'");
		ИначеЕсли Объект.Ведущая Тогда
			Элементы.ИнформационноеСообщение.Заголовок
				= НСтр("ru = 'Эта конечная точка является ведущей, т.е. инициирует отправку и получение сообщений обмена для текущей информационной системы.'");
		Иначе
			Элементы.ИнформационноеСообщение.Заголовок
				= НСтр("ru = 'Эта конечная точка является ведомой, т.е. выполняет отправку и получение сообщений обмена только по требованию текущей информационной системы.'");
		КонецЕсли;
		
		Элементы.СделатьЭтуКонечнуюТочкуВедомой.Видимость = Объект.Ведущая И Не Объект.Заблокирована;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	Оповестить(ОбменСообщениямиКлиент.ИмяСобытияЗакрытаФормаКонечнойТочки());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ОбменСообщениямиКлиент.ИмяСобытияУстановленаВедущаяКонечнаяТочка() Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СделатьЭтуКонечнуюТочкуВедомой(Команда)
	
	ПараметрыФормы = Новый Структура("КонечнаяТочка", Объект.Ссылка);
	
	ОткрытьФорму("ОбщаяФорма.УстановкаВедущейКонечнойТочки", ПараметрыФормы, ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти
