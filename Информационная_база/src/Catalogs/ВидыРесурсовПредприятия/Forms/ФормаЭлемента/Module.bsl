
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокРесурсов.Параметры.УстановитьЗначениеПараметра("ВидРесурсаПредприятия", Объект.Ссылка);
	
	// Запрет удаления из состава вида Все ресурсы.
	Если Объект.Ссылка = Справочники.ВидыРесурсовПредприятия.ВсеРесурсы Тогда
		
		Элемент = Элементы.Найти("СписокРесурсовУдалить");
		Если Элемент <> Неопределено Тогда
			Элемент.Доступность = Ложь;
		КонецЕсли;
		
		Элемент = Элементы.Найти("СписокРесурсовКонтекстноеМенюУдалить");
		Если Элемент <> Неопределено Тогда
			Элемент.Доступность = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ВидыРесурсовПредприятия" Тогда
		
		СписокРесурсов.Параметры.УстановитьЗначениеПараметра("ВидРесурсаПредприятия", Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокРесурсовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Данные еще не записаны.'");
		Сообщение.Сообщить();
	Иначе
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ДоступностьВида", Ложь);
		ПараметрыОткрытия.Вставить("ЗначениеВидРесурсаПредприятия", Объект.Ссылка);
		ОткрытьФорму("РегистрСведений.ВидыРесурсовПредприятия.ФормаЗаписи", ПараметрыОткрытия, Элемент);
	КонецЕсли;
	
КонецПроцедуры // СписокРесурсовПередНачаломДобавления()

&НаКлиенте
Процедура СписокРесурсовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Элементы.СписокРесурсов.ТекущаяСтрока);
	ПараметрыОткрытия.Вставить("ДоступностьВида", Ложь);
	ОткрытьФорму("РегистрСведений.ВидыРесурсовПредприятия.ФормаЗаписи", ПараметрыОткрытия);
	
КонецПроцедуры // СписокРесурсовВыбор()

&НаКлиенте
Процедура СписокРесурсовПередУдалением(Элемент, Отказ)
	
	Если Объект.Ссылка = ПредопределенноеЗначение("Справочник.ВидыРесурсовПредприятия.ВсеРесурсы") Тогда
		ТекстСообщения = НСтр("ru = 'Объект не удален, т. к. ресурс предприятия должен входить в вид ""Все ресурсы"".'");
		УправлениеНебольшойФирмойКлиент.СообщитьОбОшибке(Объект, ТекстСообщения, , , , Отказ);
	КонецЕсли;
	
КонецПроцедуры // СписокРесурсовПередУдалением()

&НаКлиенте
Процедура СписокРесурсовПослеУдаления(Элемент)
	
	Оповестить("Запись_ВидыРесурсовПредприятия");
	
КонецПроцедуры // СписокРесурсовПослеУдаления()

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти
