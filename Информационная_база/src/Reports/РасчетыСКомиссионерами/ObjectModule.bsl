#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиВариантов["РасчетыСКомиссионерами"].Рекомендуемый = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.Настройки;
	ПараметрыОтчета = ОтчетыУНФ.ПараметрыФормированияОтчета(НастройкиОтчета);
	
	ОтчетыУНФ.СтандартизироватьСхему(СхемаКомпоновкиДанных);
	ОтчетыУНФ.ДобавитьВычисляемыеПоля(СхемаКомпоновкиДанных);
	
	УправлениеНебольшойФирмойОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
	УправлениеНебольшойФирмойОтчеты.ВывестиЗаголовокОтчета(ПараметрыОтчета, ДокументРезультат);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	Если СтрНайти(МакетКомпоновки.НаборыДанных.НаборДанных1.Запрос, "ДанныеПоКомиссионерам.Регистратор") > 0 Тогда
		Для каждого ПолеНабораДанных Из МакетКомпоновки.НаборыДанных.НаборДанных1.Поля Цикл
			Если СтрНайти(ПолеНабораДанных.ПутьКДанным, "Номенклатура") > 0 Тогда
				ПолеНабораДанных.Роль.ИгнорироватьЗначенияNULL = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	//Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	//Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	//Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	//Основной цикл вывода отчета
	Пока Истина Цикл
		//Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			//Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе
			// Зафиксируем шапку
			Если  Не ТаблицаЗафиксирована 
				  И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
				  И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда

				ТаблицаЗафиксирована = Истина;
				ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;

			КонецЕсли;
			//Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		КонецЕсли;
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();
	
	ОтчетыУНФ.ОбоработатьДиаграммыТабличногоДокумента(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		
		ОтчетыУНФ.ДобавитьВариантыОформленияКоличества(
		ВариантыОформления,
		"КоличествоКонечныйОстаток,КоличествоНачальныйОстаток,КоличествоПриход,КоличествоРасход");
		
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(
		ВариантыОформления,
		"СуммаКонечныйДолг,СуммаКонечныйОстаток,СуммаНачальныйДолг,СуммаНачальныйОстаток"
		+ "СуммаОплата,СуммаПриход,СуммаРасход,СуммаВознаграждения");
		
	КонецЦикла
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		НастройкиТекВарианта.Значение.Теги = НСтр("ru = 'Деньги,Контрагенты,Номенклатура,Комиссия,Продажи'");
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "Контрагент", "Справочник.Контрагенты");
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "Номенклатура", "Справочник.Номенклатура");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли
