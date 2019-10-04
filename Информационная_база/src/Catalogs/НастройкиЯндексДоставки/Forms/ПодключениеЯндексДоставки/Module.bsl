
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимВыбора = Истина;
	
	Если Параметры.Свойство("Организация") Тогда
		Объект.Организация = Параметры.Организация;
	КонецЕсли;
	Параметры.Свойство("Подразделение", Подразделение);
	Параметры.Свойство("Склад", Склад);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Перем Ошибки;
	
	ПроверитьСоответствиеМагазинов(Ошибки);
	ПроверитьСоответствиеСкладов(Ошибки);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Расписание = Новый ХранилищеЗначения(ЯндексДоставка.РасписаниеПоУмолчанию());
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_НастройкиЯндексДоставки");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыМагазины

&НаКлиенте
Процедура МагазиныСтруктурнаяЕдиницаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для Каждого ТекСтрокаМагазины Из Объект.Магазины Цикл
		Если ТекСтрокаМагазины.ПолучитьИдентификатор() = Элементы.Магазины.ТекущаяСтрока Тогда
			Продолжить;
		КонецЕсли;
		Если ТекСтрокаМагазины.СтруктурнаяЕдиница = ВыбранноеЗначение Тогда
			ТекСтрокаМагазины.СтруктурнаяЕдиница = ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ПустаяСсылка");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСклады

&НаКлиенте
Процедура СкладыСтруктурнаяЕдиницаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для Каждого ТекСтрокаСклады Из Объект.Склады Цикл
		Если ТекСтрокаСклады.ПолучитьИдентификатор() = Элементы.Склады.ТекущаяСтрока Тогда
			Продолжить;
		КонецЕсли;
		Если ТекСтрокаСклады.СтруктурнаяЕдиница = ВыбранноеЗначение Тогда
			ТекСтрокаСклады.СтруктурнаяЕдиница = ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ПустаяСсылка");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПродолжить(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.КлючиМетодов) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр("ru = 'Не указаны ключи методов.'"),,
		"КлючиМетодов",
		"Объект");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Идентификаторы) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр("ru = 'Не указаны идентификаторы.'"),,
		"Идентификаторы",
		"Объект");
		Возврат;
	КонецЕсли;
	
	Идентификаторы = ПрочитатьИдентификаторыИзJSON(Объект.Идентификаторы);
	ЗаполнитьТаблицуМагазины(Идентификаторы);
	ЗаполнитьТаблицуСклады(Идентификаторы);
	Элементы.Страницы.ТекущаяСтраница = Элементы.СоответствиеИдентификаторов;
	Элементы.ЗаписатьИЗакрыть.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.КлючиМетодовИдентификаторы;
	Элементы.ЗаписатьИЗакрыть.КнопкаПоУмолчанию = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПрочитатьИдентификаторыИзJSON(ИдентификаторыСтрока)
	
	ЧтениеJSON_IDs = Новый ЧтениеJSON;
	ЧтениеJSON_IDs.УстановитьСтроку(ИдентификаторыСтрока);
	
	Возврат ПрочитатьJSON(ЧтениеJSON_IDs, Истина);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуМагазины(Идентификаторы)
	
	Объект.Магазины.Очистить();
	
	Для Каждого ТекЗапись Из Идентификаторы["senders"] Цикл
		СтрокаМагазин = Объект.Магазины.Добавить();
		СтрокаМагазин.Идентификатор = ТекЗапись["id"];
		СтрокаМагазин.Наименование = ТекЗапись["name"];
		Если Объект.Магазины.Количество() = 1 Тогда
			СтрокаМагазин.СтруктурнаяЕдиница = Подразделение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуСклады(Идентификаторы)
	
	Объект.Склады.Очистить();
	
	Для Каждого ТекЗапись Из Идентификаторы["warehouses"] Цикл
		СтрокаСклад = Объект.Склады.Добавить();
		СтрокаСклад.Идентификатор = ТекЗапись["id"];
		СтрокаСклад.Наименование = ТекЗапись["name"];
		Если Объект.Склады.Количество() = 1 Тогда
			СтрокаСклад.СтруктурнаяЕдиница = Склад;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСоответствиеМагазинов(Ошибки)
	
	Для Каждого ТекСтрокаМагазины Из Объект.Магазины Цикл
		Если ЗначениеЗаполнено(ТекСтрокаМагазины.СтруктурнаяЕдиница) Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
	Ошибки,
	"Объект.Магазины",
	НСтр("ru = 'Установите соответствие магазинов и подразделений.'"),
	"Объект.Магазины");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСоответствиеСкладов(Ошибки)
	
	Для Каждого ТекСтрокаСклады Из Объект.Склады Цикл
		Если ЗначениеЗаполнено(ТекСтрокаСклады.СтруктурнаяЕдиница) Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
	Ошибки,
	"Объект.Склады",
	НСтр("ru = 'Установите соответствие складов.'"),
	"Объект.Склады");
	
КонецПроцедуры

#КонецОбласти