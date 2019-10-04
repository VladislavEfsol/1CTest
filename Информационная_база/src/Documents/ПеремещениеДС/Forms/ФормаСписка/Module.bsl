
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	
	//УНФ.ОтборыСписка
	ПрочитатьРасчетныеСчетаИКассы();
	
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	//Конец УНФ.ОтборыСписка
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"УНФ.Документ.ПеремещениеДС",
		"ФормаСписка",
		Неопределено,
		НСтр("ru='Новости: Перемещение денег'"),
		Ложь,
		Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Истина),
		"ПриОткрытии"
	);
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИспользуютсяПереводыВПути = РегистрыСведений.ПрименениеПереводовВПути.ИспользуютсяПереводыВПути();
	Если ИспользуютсяПереводыВПути Тогда
		Элементы.ПодменюПеремещение.Видимость = Истина;
		Элементы.ПодменюПеремещениеБез57Счета.Видимость = Ложь;
	Иначе
		Элементы.ПодменюПеремещение.Видимость = Ложь;
		Элементы.ПодменюПеремещениеБез57Счета.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПеремещениеДС" Тогда
		Если Параметр.Свойство("УдалениеПомеченных") И Параметр.УдалениеПомеченных Тогда
			Возврат;
		КонецЕсли;
		
		Элементы.Список.ТекущаяСтрока = Параметр.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(
	"Документ.ПеремещениеДС",
	Список.КомпоновщикНастроек.Настройки.Отбор.Элементы,
	Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ВедомостьПерейти(Команда)
	
	ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта, СформироватьПриОткрытии", "Ведомость", Истина));
	
КонецПроцедуры // ВедомостьПерейти()

#КонецОбласти

#Область ОбработчикиБиблиотек

// ИнтернетПоддержкаПользователей.Новости
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, "ПриОткрытии");
	
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.Новости


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборОперацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;

	УстановитьМеткуИОтборСписка("Автор", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВалютаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ВалютаДенежныхСредств", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетИКассаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СчетКассаДляОтбора", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетИКассаПолучательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СчетКассаПолучательДляОтбора", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ИмяДокумента = РаботаСФормойДокументаКлиент.ПолучитьИмяДокументаПоТипу(Параметр);
	ИмяКоманды = "ПеремещениеМеждуКассами";
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент(ИмяДокумента, "", ДанныеМеток,, ПолучитьПараметрыПеремещенияДС(ИмяКоманды));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьРасчетныеСчетаИКассы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Кассы.Ссылка,
		|	ПРЕДСТАВЛЕНИЕ(Кассы.Ссылка) КАК Представление
		|ИЗ
		|	Справочник.Кассы КАК Кассы
		|
		|УПОРЯДОЧИТЬ ПО
		|	Кассы.Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	БанковскиеСчета.Ссылка,
		|	ПРЕДСТАВЛЕНИЕ(БанковскиеСчета.Ссылка) КАК Представление
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО БанковскиеСчета.Владелец = Организации.Ссылка";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаКасс = МассивРезультатов[0].Выбрать();
	ВыборкаСчетов = МассивРезультатов[1].Выбрать();
	
	Элементы.ОтборСчетИКасса.СписокВыбора.Очистить();
	
	Пока ВыборкаСчетов.Следующий() Цикл
		Элементы.ОтборСчетИКасса.СписокВыбора.Добавить(ВыборкаСчетов.Ссылка,,, БиблиотекаКартинок.Банк);
		Элементы.ОтборСчетИКассаПолучатель.СписокВыбора.Добавить(ВыборкаСчетов.Ссылка,,, БиблиотекаКартинок.Банк);
	КонецЦикла;
	Пока ВыборкаКасс.Следующий() Цикл
		Элементы.ОтборСчетИКасса.СписокВыбора.Добавить(ВыборкаКасс.Ссылка,,, БиблиотекаКартинок.Касса);
		Элементы.ОтборСчетИКассаПолучатель.СписокВыбора.Добавить(ВыборкаКасс.Ссылка,,, БиблиотекаКартинок.Касса);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПеремещениеДС

&НаСервереБезКонтекста
Функция ПолучитьПараметрыПеремещенияДС(ИмяКоманды)
	
	ТипДенежныхСредств = Перечисления.ТипыДенежныхСредств.Наличные;
	ТипДенежныхСредствПолучатель = Перечисления.ТипыДенежныхСредств.Наличные;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", Новый Структура("ТипДенежныхСредств, ТипДенежныхСредствПолучатель", 
		ТипДенежныхСредств, ТипДенежныхСредствПолучатель));
		
	Возврат ПараметрыОткрытия;
	
КонецФункции

&НаКлиенте
Процедура ПеремещениеМеждуКассами(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПеремещениеДС", "ПеремещениеДС", ДанныеМеток,, ПолучитьПараметрыПеремещенияДС(Команда.Имя));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзКассыНаСчет(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ВзносНаличнымиВБанк", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура СоСчетаВКассу(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "ПолучениеНаличныхВБанке", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура СоСчетаНаСчет(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходСоСчета", "ПереводНаДругойСчет", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура НаСчетИзКассы(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеНаСчет", "ВзносНаличными", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура ВКассуСоСчета(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходСоСчета", "СнятиеНаличных", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура СоСчетаНаСчет1(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеНаСчет", "ПереводСДругогоСчета", ДанныеМеток);
	
КонецПроцедуры

#КонецОбласти
