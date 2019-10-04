
#Область ПрограммныйИнтерфейс

#Область СобытияЭлементовФормы

Процедура ДанныеПанелиКонтактнойИнформацииВыбор(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаКИ = Форма.ДанныеПанелиКонтактнойИнформации.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если СтрокаКИ.ТипОтображаемыхДанных = "ЗначениеКИ" Тогда
		
		ДанныеКИ = Новый Структура;
		ДанныеКИ.Вставить("Тип", СтрокаКИ.ТипКИ);
		ДанныеКИ.Вставить("Представление", СтрокаКИ.ПредставлениеКИ);
		ДанныеКИ.Вставить("Владелец", СтрокаКИ.ВладелецКИ);
		
		ОснованиеЗаполненияСобытия = Новый Структура;
		ОснованиеЗаполненияСобытия.Вставить("Контакт", СтрокаКИ.ВладелецКИ);
		ОснованиеЗаполненияСобытия.Вставить("КонтактРодитель", СтрокаКИ.Родитель);
		ОснованиеЗаполненияСобытия.Вставить("ЗначениеКИ", СтрокаКИ.ПредставлениеКИ);
		
		КонтактнаяИнформацияУНФКлиент.ОбработатьНажатиеПиктограммы(Форма, Элемент, ДанныеКИ, ОснованиеЗаполненияСобытия);
		
	ИначеЕсли СтрокаКИ.ТипОтображаемыхДанных = "КонтактноеЛицо" Тогда
		
		ПоказатьЗначение(,СтрокаКИ.ВладелецКИ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(Форма, Элемент) Экспорт
	
	СтрокаКИ = Форма.Элементы.ДанныеПанелиКонтактнойИнформации.ТекущиеДанные;
	Если СтрокаКИ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КнопкаЯндекс = Форма.Элементы.Найти("КонтекстноеМенюПанелиКартаЯндекс");
	Если КнопкаЯндекс <> Неопределено Тогда
		КнопкаЯндекс.Доступность = СтрокаКИ.ТипОтображаемыхДанных = "ЗначениеКИ"
			И СтрокаКИ.ИндексПиктограммы = 12; // Адрес
	КонецЕсли;
	
	КнопкаGoogle = Форма.Элементы.Найти("КонтекстноеМенюПанелиКартаGoogle");
	Если КнопкаGoogle <> Неопределено Тогда
		КнопкаGoogle.Доступность = СтрокаКИ.ТипОтображаемыхДанных = "ЗначениеКИ"
			И СтрокаКИ.ИндексПиктограммы = 12; // Адрес
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКоманду(Форма, Команда, ВладелецКИ) Экспорт
	
	Если Команда.Имя = "КонтекстноеМенюПанелиКартаЯндекс" Тогда
		
		СтрокаКИ = Форма.Элементы.ДанныеПанелиКонтактнойИнформации.ТекущиеДанные;
		Если СтрокаКИ = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		УправлениеКонтактнойИнформациейКлиент.ПоказатьАдресНаКарте(СтрокаКИ.ПредставлениеКИ, "Яндекс.Карты");
		
	ИначеЕсли Команда.Имя = "КонтекстноеМенюПанелиКартаGoogle" Тогда
		
		СтрокаКИ = Форма.Элементы.ДанныеПанелиКонтактнойИнформации.ТекущиеДанные;
		Если СтрокаКИ = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		УправлениеКонтактнойИнформациейКлиент.ПоказатьАдресНаКарте(СтрокаКИ.ПредставлениеКИ, "GoogleMaps");
		
	ИначеЕсли Команда.Имя = "СписокПоказатьКонтактнуюИнформациюТекущегоОбъекта" Тогда
		
		ОткрытьФорму("ОбщаяФорма.КонтактнаяИнформацияВладельца_МК", Новый Структура("ВладелецКИ", ВладелецКИ));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Функция ОбрабатыватьОповещения(Форма, ИмяСобытия, Параметр) Экспорт
	
	Результат = ИмяСобытия = "Запись_Контрагент"
			Или ИмяСобытия = "Запись_КонтактноеЛицо";
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти
