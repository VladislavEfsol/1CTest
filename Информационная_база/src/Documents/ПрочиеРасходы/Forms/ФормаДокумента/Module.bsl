
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Объект.Организация);
	ОбновитьРеквизитыВидимостиФормы();

	Для Каждого ТекущаяСтрока Из Объект.Расходы Цикл
		ТекущаяСтрока.ТипСчета = ТекущаяСтрока.СчетЗатрат.ТипСчета;
	КонецЦикла;
	
	УправлениеФормой(ЭтаФорма);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Прочие расчеты
	Если ИмяСобытия = "Запись_ПланСчетовУправленческий" Тогда
		Если ЗначениеЗаполнено(Параметр)
			И Объект.Корреспонденция = Параметр Тогда
			
			ОбновитьРеквизитыВидимостиФормы();
			УправлениеФормой(ЭтотОбъект);
			
		КонецЕсли;
	КонецЕсли;
	// Конец Прочие расчеты
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
Процедура ДатаПриИзменении(Элемент)
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Организация.
// В процедуре осуществляется очистка номера документа,
// а также производится установка параметров функциональных опций формы.
// Переопределяет соответствующий параметр формы.
//
Процедура ОрганизацияПриИзменении(Элемент)
	
	// Обработка события изменения организации.
	Объект.Номер = "";
	СтруктураДанные = ПолучитьДанныеОрганизацияПриИзменении(Объект.Организация);
	Компания = СтруктураДанные.Компания;
	
КонецПроцедуры // ОрганизацияПриИзменении()

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФнукции

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("РазностьДат", УправлениеНебольшойФирмойСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервереБезКонтекста
// Получает набор данных с сервера.
//
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Компания", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеОрганизацияПриИзменении()

#КонецОбласти

#Область ЗаполнениеОбъектов

&НаКлиенте
Процедура СохранитьДокументКакШаблон(Параметр) Экспорт
	
	ЗаполнениеОбъектовУНФКлиент.СохранитьДокументКакШаблон(Объект, ОтображаемыеРеквизиты(), Параметр);
	
КонецПроцедуры

&НаСервере
Функция ОтображаемыеРеквизиты()
	
	Возврат ЗаполнениеОбъектовУНФ.ОтображаемыеРеквизиты(ЭтаФорма);
	
КонецФункции

#КонецОбласти

#Область ПрочиеРасчеты

&НаКлиенте
Процедура РасходыСчетЗатратПриИзменении(Элемент)
	
	ПараметрыСчета = ПолучитьПараметрыСчетаЗатратПриИзменении(Элементы.Расходы.ТекущиеДанные.СчетЗатрат);
	ТекущиеДанные = Элементы.Расходы.ТекущиеДанные;
	ТекущиеДанные.АналитикаПрочихДоходовИРасходов = ПараметрыСчета.АналитикаПрочихДоходовИРасходов;
	ТекущиеДанные.ТипСчета = ПараметрыСчета.ТипСчета;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПараметрыСчетаЗатратПриИзменении(Счет)
	
	Параметры = Новый Структура("АналитикаПрочихДоходовИРасходов, ТипСчета");
	
	Если ЗначениеЗаполнено(Счет.АналитикаДоходовИРасходов) И (Счет.ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.ПрочиеДоходы")
		ИЛИ Счет.ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.ПрочиеРасходы") ИЛИ Счет.ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.ПрочиеОборотныеАктивы")
		ИЛИ Счет.ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.Расходы")) Тогда
		Параметры.Вставить("АналитикаПрочихДоходовИРасходов", Новый(Счет.АналитикаДоходовИРасходов));
	Иначе
		Параметры.Вставить("АналитикаПрочихДоходовИРасходов", Неопределено);
	КонецЕсли;
	Параметры.Вставить("ТипСчета", Счет.ТипСчета);
	
	Возврат Параметры;
	
КонецФункции

&НаКлиенте
Процедура РасходыАналитикаПрочихДоходовИРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Элементы.Расходы.ТекущиеДанные.АналитикаПрочихДоходовИРасходов = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Для данного типа счета не требуется указывать аналитику доходов и расходов";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КорреспонденцияПриИзменении(Элемент)
	
	ОбновитьРеквизитыВидимостиФормы();
	
	УправлениеФормой(ЭтотОбъект);
	Объект.АналитикаПрочихДоходовИРасходов = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРеквизитыВидимостиФормы()
	
	СтрокаРеквизитов = "ВестиРасчетыПоДоговорам";
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Контрагент, СтрокаРеквизитов);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ЗначенияРеквизитов, СтрокаРеквизитов);
	
	СтрокаРеквизитов = "ТипСчета";
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Корреспонденция, СтрокаРеквизитов);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ЗначенияРеквизитов, СтрокаРеквизитов);
	
	Если ЗначениеЗаполнено(Объект.Корреспонденция) Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Корреспонденция, "АналитикаДоходовИРасходов");
		АналитикаПрочихДоходовИРасходов = ЗначенияРеквизитов.АналитикаДоходовИРасходов;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.Договор.Видимость = Форма.ВестиРасчетыПоДоговорам;
	
	Элементы.АналитикаПрочихДоходовИРасходов.Видимость = Ложь;
	Элементы.Контрагент.Видимость = Ложь;
	Элементы.Договор.Видимость = Ложь;
	
	Элементы.РасходыДоговор.Видимость = Объект.УчетПрочихРасчетов;
	Элементы.РасходыКонтрагент.Видимость = Объект.УчетПрочихРасчетов;
	
	// Прочие расчеты
	Если (Форма.ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.ПрочиеДоходы")
		ИЛИ Форма.ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.ПрочиеРасходы") ИЛИ Форма.ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.ПрочиеОборотныеАктивы")) Тогда
		Если ЗначениеЗаполнено(Форма.АналитикаПрочихДоходовИРасходов) Тогда
			Элементы.АналитикаПрочихДоходовИРасходов.Видимость = Истина;
			Элементы.АналитикаПрочихДоходовИРасходов.ОграничениеТипа = Новый ОписаниеТипов(Форма.АналитикаПрочихДоходовИРасходов);
			Элементы.АналитикаПрочихДоходовИРасходов.Заголовок = Строка(Элементы.АналитикаПрочихДоходовИРасходов.ОграничениеТипа);
			Элементы.АналитикаПрочихДоходовИРасходов.Доступность = Истина;
			Элементы.АналитикаПрочихДоходовИРасходов.ПодсказкаВвода = "";
		Иначе
			Элементы.АналитикаПрочихДоходовИРасходов.Видимость = Истина;
			Объект.АналитикаПрочихДоходовИРасходов = Неопределено;
			Элементы.АналитикаПрочихДоходовИРасходов.Заголовок = "Аналитика прочих доходов и расходов";
			Элементы.АналитикаПрочихДоходовИРасходов.ПодсказкаВвода = "<Не настроена у этого счета>";
			Элементы.АналитикаПрочихДоходовИРасходов.Доступность = Ложь;
			Элементы.АналитикаПрочихДоходовИРасходов.Видимость = Истина;
		КонецЕсли;
	Иначе
		Элементы.АналитикаПрочихДоходовИРасходов.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.УчетПрочихРасчетов И (Форма.ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.Дебиторы")
		ИЛИ Форма.ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.Кредиторы")) Тогда
		Элементы.Контрагент.Видимость = Истина;
		Элементы.Договор.Видимость = Форма.ВестиРасчетыПоДоговорам;
	КонецЕсли;
	
	УстановитьПараметрыВыбораПоУчетуПрочихРасчетовНаСервере(Форма);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Контрагент.
//
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(Объект.Контрагент, Объект.Организация, Объект.Дата);
	
	Объект.Договор = СтруктураДанные.Договор;
	
КонецПроцедуры // КонтрагентПриИзменении()

// Получает набор данных с сервера для процедуры КонтрагентПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеКонтрагентПриИзменении(Контрагент, Организация, Дата)
	
	ДоговорПоУмолчанию = ПолучитьДоговорПоУмолчанию(Объект.Ссылка, Контрагент, Организация);
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"КонтрагентНаименованиеПолное",
		Контрагент.НаименованиеПолное
	);
	
	СтруктураДанные.Вставить(
		"Договор",
		ДоговорПоУмолчанию
	);
	
	СтруктураДанные.Вставить(
		"ДоговорВалютаКурсКратность",
		РегистрыСведений.КурсыВалют.ПолучитьПоследнее(
			Дата,
			Новый Структура("Валюта", ДоговорПоУмолчанию.ВалютаРасчетов)
		)
	);
	
	ВестиРасчетыПоДоговорам = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ВестиРасчетыПоДоговорам");
	УстановитьВидимостьРеквизитовРасчетов(ЭтаФорма);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()

// Процедура устанавливает видимость реквизитов расчетов.
//
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьРеквизитовРасчетов(Форма)
	
	УправлениеФормой(Форма);
	
КонецПроцедуры // УстановитьВидимостьРеквизитовРасчетов()

// Получает договор по умолчанить в зависимости от способа ведения расчетов.
//
&НаСервереБезКонтекста
Функция ПолучитьДоговорПоУмолчанию(Документ, Контрагент, Организация)
	
	Если Не Контрагент.ВестиРасчетыПоДоговорам Тогда
		Возврат Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
	КонецЕсли;
	
	МенеджерСправочника = Справочники.ДоговорыКонтрагентов;
	
	СписокВидовДоговоров = МенеджерСправочника.ПолучитьСписокВидовДоговораДляДокумента(Документ);
	ДоговорПоУмолчанию = МенеджерСправочника.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
	
	Возврат ДоговорПоУмолчанию;
	
КонецФункции

&НаКлиенте
Процедура РасходыКонтрагентПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Расходы.ТекущиеДанные;
	ТекущиеДанные.Договор = ПолучитьДоговорПоУмолчанию(Объект.Ссылка, ТекущиеДанные.Контрагент, Объект.Организация)
	
КонецПроцедуры

&НаКлиенте
Процедура УчетПрочихРасчетовПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораПоУчетуПрочихРасчетовНаСервере(Форма)

	УстановитьПараметрыВыбораПоУчетуПрочихРасчетовНаСервереДляЭлемента(Форма, Форма.Элементы.Корреспонденция);
	УстановитьПараметрыВыбораПоУчетуПрочихРасчетовНаСервереДляЭлемента(Форма, Форма.Элементы.РасходыСчетЗатрат);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораПоУчетуПрочихРасчетовНаСервереДляЭлемента(Форма, Элемент)

	Элементы = Форма.Элементы;
	
	ПараметрыВыбораЭлемента = Новый Массив;
	ОтборПоТипуСчета = Новый Массив;
	
	Для Каждого Параметр Из Элемент.ПараметрыВыбора Цикл
		Если Параметр.Имя = "Отбор.ТипСчета" Тогда
			
			Для Каждого ТипСчета Из Параметр.Значение Цикл
				Если ТипСчета <> ПредопределенноеЗначение("Перечисление.ТипыСчетов.Кредиторы")
					И ТипСчета <> ПредопределенноеЗначение("Перечисление.ТипыСчетов.Дебиторы")
					И ТипСчета <> ПредопределенноеЗначение("Перечисление.ТипыСчетов.Капитал") Тогда
					ОтборПоТипуСчета.Добавить(ТипСчета);
				КонецЕсли;
			КонецЦикла;
			
			Если Форма.Объект.УчетПрочихРасчетов Тогда
				Если ОтборПоТипуСчета.Найти(ПредопределенноеЗначение("Перечисление.ТипыСчетов.Дебиторы")) = Неопределено Тогда
					ОтборПоТипуСчета.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСчетов.Дебиторы"));
				КонецЕсли;
				Если ОтборПоТипуСчета.Найти(ПредопределенноеЗначение("Перечисление.ТипыСчетов.Кредиторы")) = Неопределено Тогда
					ОтборПоТипуСчета.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСчетов.Кредиторы"));
				КонецЕсли;
				Если Элемент = Элементы.Корреспонденция Тогда
					Если ОтборПоТипуСчета.Найти(ПредопределенноеЗначение("Перечисление.ТипыСчетов.Капитал")) = Неопределено Тогда
						ОтборПоТипуСчета.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСчетов.Капитал"));
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			ПараметрыВыбораЭлемента.Добавить(Новый ПараметрВыбора("Отбор.ТипСчета", Новый ФиксированныйМассив(ОтборПоТипуСчета)));
		Иначе
			ПараметрыВыбораЭлемента.Добавить(Параметр);
		КонецЕсли;
	КонецЦикла;
	
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыКонтрагентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Расходы.ТекущиеДанные;
	Если ТекущиеДанные.ТипСчета <> ПредопределенноеЗначение("Перечисление.ТипыСчетов.Кредиторы") И ТекущиеДанные.ТипСчета <> ПредопределенноеЗначение("Перечисление.ТипыСчетов.Дебиторы") Тогда
		СтандартнаяОбработка = Ложь;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Для данного типа счета не требуется указывать контрагента";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

// Получает структуру параметров формы выбора договора контрагента.
//
&НаСервереБезКонтекста
Функция ПолучитьПараметрыФормыВыбора(Документ, Организация, Контрагент, Договор)
	
	СписокВидовДоговоров = Справочники.ДоговорыКонтрагентов.ПолучитьСписокВидовДоговораДляДокумента(Документ);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КонтролироватьВыборДоговора", Контрагент.ВестиРасчетыПоДоговорам);
	ПараметрыФормы.Вставить("Контрагент", Контрагент);
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("ВидыДоговоров", СписокВидовДоговоров);
	ПараметрыФормы.Вставить("ТекущаяСтрока", Договор);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Процедура РасходыДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтрокаТабличнойЧасти = Элементы.Расходы.ТекущиеДанные;
	Если СтрокаТабличнойЧасти.ТипСчета <> ПредопределенноеЗначение("Перечисление.ТипыСчетов.Кредиторы") И СтрокаТабличнойЧасти.ТипСчета <> ПредопределенноеЗначение("Перечисление.ТипыСчетов.Дебиторы") Тогда
		
		СтандартнаяОбработка = Ложь;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Для данного типа счета не требуется указывать договор";
		Сообщение.Сообщить();
		
	ИначеЕсли СтрокаТабличнойЧасти <> Неопределено Тогда
		
		ПараметрыФормы = ПолучитьПараметрыФормыВыбора(Объект.Ссылка, Объект.Организация, СтрокаТабличнойЧасти.Контрагент, СтрокаТабличнойЧасти.Договор);
		Если ПараметрыФормы.КонтролироватьВыборДоговора Тогда
			
			СтандартнаяОбработка = Ложь;
			ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", ПараметрыФормы, Элемент);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = ПолучитьПараметрыФормыВыбора(Объект.Ссылка, Объект.Организация, Объект.Контрагент, Объект.Договор);
	Если ПараметрыФормы.КонтролироватьВыборДоговора Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", ПараметрыФормы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
