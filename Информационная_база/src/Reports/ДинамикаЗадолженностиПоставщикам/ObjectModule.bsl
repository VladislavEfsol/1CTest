#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПоказыватьГруппуСтрокиНаФормеОтчета = Ложь;
	НастройкиОтчета.ПоказыватьГруппуКолонкиНаФормеОтчета = Ложь;
	НастройкиОтчета.ПоказыватьНастройкиДиаграммыНаФормеОтчета = Ложь;
	НастройкиОтчета.ПрограммноеИзменениеФормыОтчета = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	
КонецПроцедуры

Процедура ОбновитьНастройкиНаФорме(НастройкиОтчета, НастройкиСКД, Форма) Экспорт
	
	ДобавитьПолеВыбораПериодичности(НастройкиСКД, Форма);
	
КонецПроцедуры

Процедура ПриИзмененииНестандартногоРеквизита(Тип, ИмяПоля, СтруктураЗначений, НастройкиСКД, Форма, ИмяЭлемента) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.Настройки;
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(НастройкиОтчета);
	
	ОтчетыУНФ.СтандартизироватьСхему(СхемаКомпоновкиДанных);
	
	УправлениеНебольшойФирмойОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
	УправлениеНебольшойФирмойОтчеты.ВывестиЗаголовокОтчета(ПараметрыОтчета, ДокументРезультат);
	УправлениеНебольшойФирмойОтчеты.НастроитьДинамическийПериод(СхемаКомпоновкиДанных, ПараметрыОтчета, Ложь);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ВнешниеНаборыДанных = ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки);
	
	//Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);

	//Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	//Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	
	//Основной цикл вывода отчета
	ОбластиКУдалению = Новый Массив;
	КоличествоДиаграмм = 0;
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
	
	Для каждого Область Из ОбластиКУдалению Цикл
		ДокументРезультат.УдалитьОбласть(Область, ТипСмещенияТабличногоДокумента.ПоВертикали);
	КонецЦикла;
	
	ОтчетыУНФ.ОбоработатьДиаграммыТабличногоДокумента(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодготовитьПараметрыОтчета(НастройкиОтчета)
	
	НачалоПериода = Дата(1,1,1);
	КонецПериода  = Дата(1,1,1);
	Периодичность = Перечисления.Периодичность.ПустаяСсылка();
	ТипДиаграммыОтчета = Неопределено;
	ВыводитьЗаголовок = Ложь;
	Заголовок = "Динамика задолженности покупателей";
	
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СтПериод"));
	Если ПараметрПериод <> Неопределено И ПараметрПериод.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ Тогда
		Если ПараметрПериод.Использование
			И ЗначениеЗаполнено(ПараметрПериод.Значение) Тогда
			
			НачалоПериода = ПараметрПериод.Значение.ДатаНачала;
			КонецПериода  = ПараметрПериод.Значение.ДатаОкончания;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрПериодичность = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Периодичность"));
	Если ПараметрПериодичность <> Неопределено
		И ПараметрПериодичность.Использование
		И ЗначениеЗаполнено(ПараметрПериодичность.Значение) Тогда
		
		Периодичность = ПараметрПериодичность.Значение;
	КонецЕсли;
	
	ПараметрВыводитьЗаголовок = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьЗаголовок"));
	Если ПараметрВыводитьЗаголовок <> Неопределено
		И ПараметрВыводитьЗаголовок.Использование Тогда
		
		ВыводитьЗаголовок = ПараметрВыводитьЗаголовок.Значение;
	КонецЕсли;
	
	ПараметрВывода = НастройкиОтчета.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок"));
	Если ПараметрВывода <> Неопределено
		И ПараметрВывода.Использование Тогда
		Заголовок = ПараметрВывода.Значение;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НачалоПериода"        , НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"         , КонецПериода);
	ПараметрыОтчета.Вставить("Периодичность"            , Периодичность);
	ПараметрыОтчета.Вставить("ТипДиаграммы"             , ТипДиаграммыОтчета);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"        , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("Заголовок"                , Заголовок);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"      , "ДинамикаЗадолженностиПокупателей");
	ПараметрыОтчета.Вставить("НастройкиОтчета", НастройкиОтчета);
		
	Возврат ПараметрыОтчета;
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ТаблицаЗадолженность = Новый ТаблицаЗначений;
	ТаблицаЗадолженность.Колонки.Добавить("Период");
	ТаблицаЗадолженность.Колонки.Добавить("Организация");
	ТаблицаЗадолженность.Колонки.Добавить("Контрагент");
	ТаблицаЗадолженность.Колонки.Добавить("Договор");
	ТаблицаЗадолженность.Колонки.Добавить("Задолженность");
	ТаблицаЗадолженность.Колонки.Добавить("ПросроченнаяЗадолженность");
	
	НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
	КонецПериода  = ?(ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода), КонецДня(ПараметрыОтчета.КонецПериода), ПараметрыОтчета.КонецПериода);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(МИНИМУМ(РасчетыСПоставщиками.Период), &НачалоПериода) КАК НачалоПериода,
	|	ЕСТЬNULL(МАКСИМУМ(РасчетыСПоставщиками.Период), &КонецПериода) КАК КонецПериода
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК РасчетыСПоставщиками");
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	НачалоПериода = Макс(НачалоПериода, Выборка.НачалоПериода);
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = Выборка.КонецПериода;
	Иначе
		КонецПериода = Мин(КонецПериода, Выборка.КонецПериода);
	КонецЕсли;
	
	ТаблицаПериоды = ОтчетыУНФ.ТаблицаПериодов(НачалоПериода, КонецПериода, ПараметрыОтчета);
	
	Для Каждого Период Из ТаблицаПериоды Цикл
			ВременнаяТаблица = ПолучитьЗадолженность(ПараметрыОтчета, Период.ПериодКонец);
			Для Каждого СтрокаТаблицы Из ВременнаяТаблица Цикл
				НоваяСтрока = ТаблицаЗадолженность.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
				НоваяСтрока.Период = Период.ПериодНачало;
			КонецЦикла;
	КонецЦикла;
	
	ВнешниеНаборыДанных = Новый Структура("ТаблицаЗадолженность", ТаблицаЗадолженность);
	Возврат ВнешниеНаборыДанных;
	
КонецФункции

Функция ПолучитьЗадолженность(ПараметрыОтчета, КонДата)
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", КонецДня(КонДата));
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Организация,
	|	РасчетыСПоставщикамиОстатки.Контрагент,
	|	РасчетыСПоставщикамиОстатки.Договор,
	|	РасчетыСПоставщикамиОстатки.Документ.Дата КАК ДатаРасчетногоДокумента,
	|	ВЫБОР
	|		КОГДА РасчетыСПоставщикамиОстатки.Договор.СрокОплатыПоставщику > 0
	|			ТОГДА РасчетыСПоставщикамиОстатки.Договор.СрокОплатыПоставщику
	|		КОГДА СрокОплатыПоставщику.Значение > 0
	|			ТОГДА СрокОплатыПоставщику.Значение
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СрокОплатыПоставщику,
	|	РасчетыСПоставщикамиОстатки.СуммаОстаток
	|ПОМЕСТИТЬ Вт_РасчетыСПоставщиками
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками.Остатки КАК РасчетыСПоставщикамиОстатки,
	|	Константа.СрокОплатыПоставщику КАК СрокОплатыПоставщику
	|ГДЕ
	|	РасчетыСПоставщикамиОстатки.Документ <> НЕОПРЕДЕЛЕНО
	|	И РасчетыСПоставщикамиОстатки.СуммаОстаток > 0
	|	И РасчетыСПоставщикамиОстатки.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)
	|	И РАЗНОСТЬДАТ(РасчетыСПоставщикамиОстатки.Документ.Дата, &Период, ДЕНЬ) >= 0
	|	И РасчетыСПоставщикамиОстатки.СуммаВалОстаток > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщиками.Организация,
	|	РасчетыСПоставщиками.Контрагент,
	|	РасчетыСПоставщиками.Договор,
	|	РасчетыСПоставщиками.СуммаОстаток КАК Задолженность,
	|	ВЫБОР
	|		КОГДА РасчетыСПоставщиками.СрокОплатыПоставщику > 0
	|				И РАЗНОСТЬДАТ(РасчетыСПоставщиками.ДатаРасчетногоДокумента, &Период, ДЕНЬ) > РасчетыСПоставщиками.СрокОплатыПоставщику
	|			ТОГДА РасчетыСПоставщиками.СуммаОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПросроченнаяЗадолженность
	|ИЗ
	|	Вт_РасчетыСПоставщиками КАК РасчетыСПоставщиками";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

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
	
	НастройкиВариантов["ДинамикаЗадолженности"].Теги = НСТР("ru = 'Деньги,Долги,Авансы,Поставщики'");
	
КонецПроцедуры

Процедура ДобавитьПолеВыбораПериодичности(НастройкиСКД, Форма)
	
	ЗначениеПараметраПериодичность = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Периодичность");
	
	Если Не ЗначениеЗаполнено(ЗначениеПараметраПериодичность.ИдентификаторПользовательскойНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрСтПериод = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СтПериод");
	
	Если ЗначениеЗаполнено(ЗначениеПараметраПериодичность.Значение) Тогда
		ЗначениеПоУмолчанию = ЗначениеПараметраПериодичность.Значение
	Иначе
		ЗначениеПоУмолчанию = УправлениеНебольшойФирмойОтчеты.ПолучитьЗначениеПериодичности(
		ПараметрСтПериод.Значение.ДатаНачала,
		ПараметрСтПериод.Значение.ДатаОкончания);
	КонецЕсли;
	
	Стр = Форма.ПоляНастроек.ПолучитьЭлементы().Добавить();
	Стр.Тип = "Параметр";
	Стр.Поле = "Периодичность";
	Стр.ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.Периодичность");
	Стр.Заголовок = НСтр("ru = 'Периодичность'");
	Стр.ВидЭлемента = "Поле";
	Стр.Реквизиты = Новый Структура;
	Стр.Элементы = Новый Структура;
	Стр.ДополнительныеПараметры = Новый Структура;
	ИмяРеквизита = "ПараметрПериодичность";
	Стр.Реквизиты.Вставить(ИмяРеквизита, ЗначениеПоУмолчанию);
	МассивРеквизитов = Новый Массив;
	Для каждого Элемент Из Стр.Реквизиты Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(Элемент.Ключ, Стр.ТипЗначения,, Стр.Заголовок));
	КонецЦикла;
	Стр.Создан = Истина;
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	Форма[ИмяРеквизита] = ЗначениеПоУмолчанию;
	НастройкиСКД.ПараметрыДанных.УстановитьЗначениеПараметра(Стр.Поле, ЗначениеПоУмолчанию);
	Элемент = Форма.Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), Форма.Элементы.ГруппаПараметрыЭлементы);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	Элемент.ПутьКДанным = ИмяРеквизита;
	Элемент.КнопкаОткрытия = Ложь;
	Элемент.КнопкаВыбора = Ложь;
	Элемент.КнопкаСоздания = Ложь;
	Элемент.БыстрыйВыбор = Истина;
	Элемент.ЦветРамки = ЦветаСтиля.НедоступныеДанныеЦвет;
	Элемент.ПодсказкаВвода = Стр.Заголовок;
	Элемент.Ширина = 23;
	Элемент.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВПолеВвода;
	Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ПараметрПриИзменении");
	Стр.Элементы.Вставить(Элемент.Имя, Элемент.ПутьКДанным);
	
	ПереместитьВнизЭлементВыводитьЗаголовок(Форма);
	
КонецПроцедуры

Процедура ПереместитьВнизЭлементВыводитьЗаголовок(Знач Форма)
	
	Для Каждого ТекСтрокаРеквизит Из Форма.ПоляНастроек.ПолучитьЭлементы() Цикл
		
		Если НЕ ТекСтрокаРеквизит.Тип = "Параметр" Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТекСтрокаЭлемент Из ТекСтрокаРеквизит.Элементы Цикл
			
			Если ТекСтрокаРеквизит.Поле = "ВыводитьЗаголовок" Тогда
				Форма.Элементы.Переместить(Форма.Элементы[ТекСтрокаЭлемент.Ключ], Форма.Элементы.ГруппаПараметрыЭлементы);
				Возврат;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли