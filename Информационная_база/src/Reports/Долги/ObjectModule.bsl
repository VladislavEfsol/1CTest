#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПрограммноеИзменениеФормыОтчета = Истина;
	НастройкиОтчета.ИспользоватьСравнение = Истина;
	НастройкиОтчета.ИспользоватьПериодичность = Ложь;
	НастройкиОтчета.ПоказыватьНастройкиДиаграммыНаФормеОтчета = Ложь;
	
	НастройкиВариантов["Долги"].Рекомендуемый = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	
КонецПроцедуры

Процедура ОбновитьНастройкиНаФорме(НастройкиОтчета, НастройкиСКД, Форма) Экспорт
	
	ДобавитьНастройкуСвернутьДолг(НастройкиСКД, Форма);
	ДобавитьНастройку("Покупатели", "Контрагент.Покупатель", НастройкиСКД, Форма);
	ДобавитьНастройку("Поставщики", "Контрагент.Поставщик", НастройкиСКД, Форма);
	ДобавитьНастройку("Прочие", "Контрагент.ПрочиеОтношения", НастройкиСКД, Форма);
	
КонецПроцедуры

Процедура ПриИзмененииНестандартногоРеквизита(Тип, ИмяПоля, СтруктураЗначений, НастройкиСКД, Форма, ИмяЭлемента) Экспорт
	
	УстановитьОтборПоЗначению(ИмяЭлемента, ИмяПоля, НастройкиСКД, СтруктураЗначений[ИмяЭлемента]);
	Форма.ОбновитьОтображениеОтметокФильтровВызов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	НастроитьКолонкиОтчета();
	
	ОтчетыУНФ.ОбработатьСхемуМультивалютногоОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки);
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
	ОбработатьШапкуИПодвал(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	МассивПолейСумм = Новый Массив;
	Для каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если НЕ ДоступноеПоле.Ресурс Тогда
			Продолжить;
		КонецЕсли;
		ИмяПоля = Строка(ДоступноеПоле.Поле);
		МассивПолейСумм.Добавить(ИмяПоля);
	КонецЦикла; 
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(ВариантыОформления, МассивПолейСумм);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Долги"].Теги = НСТР("ru = 'Главное,Запасы,Закупки,Продажи,Взаиморасчеты,Долги,Авансы,Контрагенты,Покупатели,Поставщики'");
	
КонецПроцедуры

Процедура ДобавитьНастройкуСвернутьДолг(НастройкиСКД, Форма)
	
	ИмяНастройки = "СвернутьДолг";
	ЗначениеРеквизита = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ИмяНастройки).Значение;
	
	Стр = Форма.ПоляНастроек.ПолучитьЭлементы().Добавить();
	Стр.Тип = "Параметр";
	Стр.Поле = ИмяНастройки;
	Стр.ТипЗначения = Новый ОписаниеТипов("Булево");
	Стр.ВидЭлемента = "Поле";
	Стр.Реквизиты = Новый Структура;
	Стр.Элементы = Новый Структура;
	Стр.ДополнительныеПараметры = Новый Структура;
	Стр.Реквизиты.Вставить(ИмяНастройки, ЗначениеРеквизита);
	МассивРеквизитов = Новый Массив;
	Для Каждого ОписаниеРеквизита Из Стр.Реквизиты Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(ОписаниеРеквизита.Ключ, Стр.ТипЗначения,, Стр.Заголовок));
	КонецЦикла;
	Стр.Создан = Истина;
	
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	
	Форма[ИмяНастройки] = ЗначениеРеквизита;
	НастройкиСКД.ПараметрыДанных.УстановитьЗначениеПараметра(Стр.Поле, ЗначениеРеквизита);
	Элемент = Форма.Элементы.Добавить(ИмяНастройки, Тип("ПолеФормы"), Форма.Элементы.ГруппаПараметрыЭлементы);
	Элемент.Вид = ВидПоляФормы.ПолеФлажка;
	Элемент.ВидФлажка = ВидФлажка.Тумблер;
	Элемент.ПутьКДанным = ИмяНастройки;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	Элемент.ОдинаковаяШиринаЭлементов = Ложь;
	Элемент.ФорматРедактирования = "БИ=Свернуто; БЛ='Долг нам/Долг наш'";
	Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ПараметрПриИзменении");
	Стр.Элементы.Вставить(Элемент.Имя, Элемент.ПутьКДанным);

КонецПроцедуры

Процедура ДобавитьНастройку(ИмяНастройки, ИмяПоля, НастройкиСКД, Форма)
	
	ЗначениеРеквизита = ЗначениеОтбора(ИмяНастройки, ИмяПоля, НастройкиСКД);
	
	Стр = Форма.ПоляНастроек.ПолучитьЭлементы().Добавить();
	Стр.Тип = "Фильтр";
	Стр.Поле = ИмяПоля;
	Стр.ТипЗначения = Новый ОписаниеТипов("Булево");
	Стр.ВидЭлемента = "Булево";
	Стр.НестандартныйОбработчик = Истина;
	Стр.Заголовок = ИмяНастройки;
	Стр.Реквизиты = Новый Структура;
	Стр.Элементы = Новый Структура;
	Стр.ДополнительныеПараметры = Новый Структура;
	Стр.ДополнительныеПараметры.Вставить("СвязьПоПредставлению", Истина);
	Стр.Реквизиты.Вставить(ИмяНастройки, ЗначениеРеквизита);
	МассивРеквизитов = Новый Массив;
	Для Каждого ОписаниеРеквизита Из Стр.Реквизиты Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(ОписаниеРеквизита.Ключ, Стр.ТипЗначения,, Стр.Заголовок));
	КонецЦикла;
	Стр.Создан = Истина;
	
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	
	Форма[ИмяНастройки] = ЗначениеРеквизита;
	Элемент = Форма.Элементы.Добавить(ИмяНастройки, Тип("ПолеФормы"), Форма.Элементы.ГруппаПараметрыЭлементы);
	Элемент.Вид = ВидПоляФормы.ПолеФлажка;
	Элемент.ПутьКДанным = ИмяНастройки;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ФильтрПриИзменении");
	Стр.Элементы.Вставить(Элемент.Имя, Элемент.ПутьКДанным);
	
КонецПроцедуры

Функция ЗначениеОтбора(ИмяНастройки, ИмяПоля, НастройкиСКД)
	
	КонтрольноеПоле = Новый ПолеКомпоновкиДанных(ИмяПоля);
	
	Для Каждого ТекЭлементОтбора Из НастройкиСКД.Отбор.Элементы Цикл
		
		Если ТипЗнч(ТекЭлементОтбора) <> Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекЭлементОтбора.Представление <> ИмяНастройки Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ТекЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТекЭлементГруппы Из ТекЭлементОтбора.Элементы Цикл
			Если ТекЭлементГруппы.Использование 
				И ТекЭлементГруппы.ЛевоеЗначение = КонтрольноеПоле Тогда
				Возврат ТекЭлементГруппы.ПравоеЗначение;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Процедура НастроитьКолонкиОтчета()
	
	ПараметрСвернутьДолг = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СвернутьДолг");
	Если ПараметрСвернутьДолг = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПорядокРесурсаНеВСписке = Новый Массив;
	
	Если ПараметрСвернутьДолг.Значение Тогда
		ПорядокРесурсаНеВСписке.Добавить(1);
		ПорядокРесурсаНеВСписке.Добавить(2);
		ПорядокРесурсаНеВСписке.Добавить(6);
		ПорядокРесурсаНеВСписке.Добавить(7);
	Иначе
		ПорядокРесурсаНеВСписке.Добавить(3);
		ПорядокРесурсаНеВСписке.Добавить(8);
	КонецЕсли;
	
	ПолеПорядокРесурса = Новый ПолеКомпоновкиДанных("ПорядокРесурса");
	
	Для Каждого ТекЭлемент Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		
		Если ТипЗнч(ТекЭлемент) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекЭлемент.ЛевоеЗначение <> ПолеПорядокРесурса Тогда
			Продолжить;
		КонецЕсли;
		
		ТекЭлемент.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
		ТекЭлемент.ПравоеЗначение = Новый СписокЗначений;
		ТекЭлемент.ПравоеЗначение.ЗагрузитьЗначения(ПорядокРесурсаНеВСписке);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьОтборПоЗначению(ИмяЭлемента, ИмяПоляОтбора, НастройкиСКД, ЗначениеПараметра)
	
	ПолеКД = Новый ПолеКомпоновкиДанных(ИмяПоляОтбора);
	Отбор = ОтчетыУНФКлиентСервер.НайтиПолеРекурсивно(ПолеКД, НастройкиСКД.Отбор.Элементы);
	
	Если Отбор = Неопределено Тогда
		Группа = НастройкиСКД.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		Группа.Представление = ИмяЭлемента;
		Группа.ПредставлениеПользовательскойНастройки = СтрЗаменить(ИмяЭлемента + Новый УникальныйИдентификатор, "-", "");
		Отбор = Группа.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ЛевоеЗначение = ПолеКД;
		Отбор.ПравоеЗначение = Истина;
	КонецЕсли;
	
	Отбор.Родитель.Использование = ЗначениеПараметра;
	Отбор.Использование = ЗначениеПараметра;
	
КонецПроцедуры

Процедура ОбработатьШапкуИПодвал(ТабличныйДокумент)
	
	ПараметрПериодОтчета = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СтПериод"));
	
	Если ПараметрПериодОтчета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для ИндексСтроки = 1 По ТабличныйДокумент.ВысотаТаблицы Цикл
		
		ИмяОбластиНачОст = "";
		ИмяОбластиКонОст = "";
		
		Для ИндексКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			
			ТекстЗаголовка = ТабличныйДокумент.Область(ИндексСтроки, ИндексКолонки).Текст;
			
			ОбработатьЗаголовокКолонки(ИмяОбластиНачОст, ИндексКолонки, ИндексСтроки, ТабличныйДокумент, ТекстЗаголовка, НСтр("ru = '(нач. ост.)'"));
			
			ОбработатьЗаголовокКолонки(ИмяОбластиКонОст, ИндексКолонки, ИндексСтроки, ТабличныйДокумент, ТекстЗаголовка, НСтр("ru = '(кон. ост.)'"));
			
		КонецЦикла;
		
		УстановитьТекстОбласти(
		ТабличныйДокумент,
		ИмяОбластиНачОст,
		Формат(ПараметрПериодОтчета.Значение.ДатаНачала, "ДЛФ=D"),
		НСтр("ru = 'Начальный остаток'"));
		
		УстановитьТекстОбласти(
		ТабличныйДокумент,
		ИмяОбластиКонОст,
		Формат(ПараметрПериодОтчета.Значение.ДатаОкончания, "ДЛФ=D"),
		НСтр("ru = 'Конечный остаток'"));
		
		Если ЗначениеЗаполнено(ИмяОбластиНачОст)
			Или ЗначениеЗаполнено(ИмяОбластиКонОст) Тогда
			
			ОчиститьИтогиДвижений(ТабличныйДокумент, ИндексСтроки);
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьЗаголовокКолонки(ИмяОбласти, ИндексКолонки, ИндексСтроки, ТабличныйДокумент, ТекстЗаголовка, Суффикс)
	
	Если СтрНайти(ТекстЗаголовка, Суффикс) = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяОбласти)
		И СтрНайти(ИмяОбласти, ":") = 0 Тогда
		ИмяОбласти = СтрШаблон("%1:R%2C%3", ИмяОбласти, ИндексСтроки, ИндексКолонки);
	Иначе
		ИмяОбласти = СтрШаблон("R%1C%2", ИндексСтроки, ИндексКолонки);
	КонецЕсли;
	
	ТабличныйДокумент.Область(ИндексСтроки + 1, ИндексКолонки).Текст = СтрЗаменить(ТекстЗаголовка, Суффикс, "");
	
КонецПроцедуры

Процедура УстановитьТекстОбласти(ТабличныйДокумент, ИмяОбласти, Текст, ТекстПоУмолчанию)
	
	Если Не ЗначениеЗаполнено(ИмяОбласти) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрНайти(ИмяОбласти, ":") <> 0 Тогда
		ТабличныйДокумент.Область(ИмяОбласти).Объединить();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ТабличныйДокумент.Область(ИмяОбласти).Текст = Текст;
	Иначе
		ТабличныйДокумент.Область(ИмяОбласти).Текст = ТекстПоУмолчанию;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьИтогиДвижений(ТабличныйДокумент, ИндексСтрокиШапки)
	
	Для ИндексКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
		
		ТекстЗаголовка = ТабличныйДокумент.Область(ИндексСтрокиШапки, ИндексКолонки).Текст;
		
		Если СтрНачинаетсяС(ТекстЗаголовка, "Увеличение") Или СтрНачинаетсяС(ТекстЗаголовка, "Уменьшение") Тогда
			
			ТабличныйДокумент.Область(ТабличныйДокумент.ВысотаТаблицы, ИндексКолонки).Текст = "";
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли