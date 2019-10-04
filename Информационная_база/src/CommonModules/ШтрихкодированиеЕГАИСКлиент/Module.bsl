
#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗавершитьОбработкуВводаШтрихкода(ПараметрыЗавершенияВводаШтрихкода) Экспорт
	
	Форма                       = ПараметрыЗавершенияВводаШтрихкода.Форма;
	РезультатОбработкиШтрихкода = ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода;
	ПараметрыСканирования       = ПараметрыЗавершенияВводаШтрихкода.ПараметрыСканирования;
	ДанныеШтрихкода             = ПараметрыЗавершенияВводаШтрихкода.ДанныеШтрихкода;
	
	ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная");
	
	Если ЗначениеЗаполнено(РезультатОбработкиШтрихкода.ТекстОшибки) Тогда
		
		ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного(ВидПродукции);
		ПараметрыОткрытияФормы.АлкогольнаяПродукция = РезультатОбработкиШтрихкода.АлкогольнаяПродукция;
		ПараметрыОткрытияФормы.Штрихкод             = РезультатОбработкиШтрихкода.Штрихкод;
		ПараметрыОткрытияФормы.ТекстОшибки          = РезультатОбработкиШтрихкода.ТекстОшибки;
		ПараметрыОткрытияФормы.ТипШтрихкода         = РезультатОбработкиШтрихкода.ТипШтрихкода;
		
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы);
		
	ИначеЕсли РезультатОбработкиШтрихкода.ЕстьОшибкиВДеревеУпаковок Тогда
		
		ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного(ВидПродукции);
		ПараметрыОткрытияФормы.АдресДереваУпаковок = РезультатОбработкиШтрихкода.АдресДереваУпаковок;
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы);
		
	ИначеЕсли РезультатОбработкиШтрихкода.ТребуетсяВыборНоменклатуры Тогда
		
		ОткрытьФорму(
			"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМаркиПоискНоменклатуры",
			РезультатОбработкиШтрихкода.ПараметрыВыбораНоменклатуры,
			Форма,,,,
			Новый ОписаниеОповещения("ВыборНоменклатурыЗавершение", ЭтотОбъект, ПараметрыЗавершенияВводаШтрихкода),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли РезультатОбработкиШтрихкода.ТребуетсяВыборСправки2 Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("Ссылка", РезультатОбработкиШтрихкода.Справки2);
		
		ПараметрыВыбораСправки2 = Новый Структура;
		ПараметрыВыбораСправки2.Вставить("РежимВыбора",        Истина);
		ПараметрыВыбораСправки2.Вставить("ЗакрыватьПриВыборе", Истина);
		ПараметрыВыбораСправки2.Вставить("Отбор",              Отбор);
		
		ОткрытьФорму(
			"Справочник.Справки2ЕГАИС.ФормаВыбора",
			ПараметрыВыбораСправки2,
			Форма,,,,
			Новый ОписаниеОповещения("ВыборСправки2Завершение", ЭтотОбъект, ПараметрыЗавершенияВводаШтрихкода),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	Иначе
		
		ШтрихкодированиеЕГАИСКлиентСервер.ОбработатьСохраненныйВыборДанныхПоАлкогольнойПродукции(Форма, ДанныеШтрихкода);
		Если ПараметрыСканирования.ВозможнаЗагрузкаТСД
			И Форма.ЗагрузкаДанныхТСД <> Неопределено Тогда
		
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ПослеОбработкиШтрихкодаТСД", 0.1, Истина);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Функция ТребуетсяУточнениеДанныхУПользователя(РезультатОбработки) Экспорт

	Возврат РезультатОбработки.ТребуетсяВыборСправки2;

КонецФункции

Процедура ВыборНоменклатурыЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если РезультатВыбора = Неопределено Тогда
		
		ПараметрыСканирования = ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования(Форма);
		
		Если ПараметрыСканирования.ВозможнаЗагрузкаТСД
			И Форма.ЗагрузкаДанныхТСД <> Неопределено Тогда
		
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ПослеОбработкиШтрихкодаТСД", 0.1, Истина);
			
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатВыбора.Номенклатура) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указана номенклатура'"));
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено Тогда
		Действие = "ОбработатьВыборНоменклатуры";
		РезультатОбработкиШтрихкода = Форма.Подключаемый_ВыполнитьДействие(
			Действие,
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.КэшированныеЗначения);
		
		ДополнительныеПараметры.РезультатОбработкиШтрихкода = РезультатОбработкиШтрихкода;
		 
		ЗавершитьОбработкуВводаШтрихкода(ДополнительныеПараметры);
		
	Иначе
		
		ДанныеШтрихкода = АкцизныеМаркиВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораНоменклатуры(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода);
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеШтрихкода);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборСправки2Завершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Действие = "ОбработатьВыборСправки2";
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено Тогда
		РезультатОбработкиШтрихкода = Форма.Подключаемый_ВыполнитьДействие(
			Действие,
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.КэшированныеЗначения);
			
		ДополнительныеПараметры.РезультатОбработкиШтрихкода = РезультатОбработкиШтрихкода;
		
		ЗавершитьОбработкуВводаШтрихкода(ДополнительныеПараметры);
	Иначе
		
		ДанныеШтрихкода = АкцизныеМаркиВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораСправки2(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода);
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеШтрихкода);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму с описанием ошибки о невозможности обработать отсканированный штрихкод.
// 
// Параметры:
//  Форма - УправляемаяФорма - форма, для которой необходимо выполнить обработку штрихкода.
//  ПараметрыОткрытияФормы - (См. ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного).
Процедура ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы, ОповещениеОЗакрытии = Неопределено) Экспорт
	
	ОткрытьФорму(
		"Обработка.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.Форма.ИнформацияОНевозможностиДобавленияОтсканированного",
		ПараметрыОткрытияФормы, Форма,,,, ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти
