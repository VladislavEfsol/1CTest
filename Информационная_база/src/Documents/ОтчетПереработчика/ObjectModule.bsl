#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполняет табличную часть по спецификации.
//
Процедура ЗаполнитьТабличнуюЧастьПоСпецификации(СтекСпецификацийУзлов, ТаблицаУзлы = Неопределено) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаПродукция.НомерСтроки КАК НомерСтроки,
	|	ТаблицаПродукция.Количество КАК Количество,
	|	ТаблицаПродукция.Коэффициент КАК Коэффициент,
	|	ТаблицаПродукция.Спецификация КАК Спецификация
	|ПОМЕСТИТЬ ВременнаяТаблицаПродукция
	|ИЗ
	|	&ТаблицаПродукция КАК ТаблицаПродукция
	|ГДЕ
	|	ТаблицаПродукция.Спецификация <> ЗНАЧЕНИЕ(Справочник.Спецификации.ПустаяСсылка)";
	
	Если ТаблицаУзлы = Неопределено Тогда
		Запасы.Очистить();
		ТаблицаПродукция = Продукция.Выгрузить();
		Массив = Новый Массив();
		Массив.Добавить(Тип("Число"));
		ОписаниеТиповЧ = Новый ОписаниеТипов(Массив, , ,Новый КвалификаторыЧисла(10,3));
		ТаблицаПродукция.Колонки.Добавить("Коэффициент", ОписаниеТиповЧ);
		Для каждого СтрокаПродукция Из ТаблицаПродукция Цикл
			Если ЗначениеЗаполнено(СтрокаПродукция.ЕдиницаИзмерения)
				И ТипЗнч(СтрокаПродукция.ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
				СтрокаПродукция.Коэффициент = СтрокаПродукция.ЕдиницаИзмерения.Коэффициент;
			Иначе
				СтрокаПродукция.Коэффициент = 1;
			КонецЕсли;
		КонецЦикла;
		ТаблицаУзлы = ТаблицаПродукция.СкопироватьКолонки("НомерСтроки,Количество,Коэффициент,Спецификация");
		Запрос.УстановитьПараметр("ТаблицаПродукция", ТаблицаПродукция);
	Иначе
		Запрос.УстановитьПараметр("ТаблицаПродукция", ТаблицаУзлы);
	КонецЕсли;
	
	Запрос.Выполнить();
	
	Запрос.Текст = Справочники.СтавкиНДС.ПолучитьТекстЗапросаСозданияВТСтавкиНДС(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	Запрос.Выполнить();
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МИНИМУМ(ТаблицаПродукция.НомерСтроки) КАК НомерСтрокиПродукции,
	|	ТаблицаПродукция.Спецификация КАК СпецификацияПродукции,
	|	МИНИМУМ(ТаблицаМатериалы.НомерСтроки) КАК НомерСтрокиСостава,
	|	ТаблицаМатериалы.ТипСтрокиСостава КАК ТипСтрокиСостава,
	|	ТаблицаМатериалы.Номенклатура КАК Номенклатура,
	|	ЕСТЬNULL(ВТСтавкиНДС.СтавкаНДС, ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)) КАК СтавкаНДС,
	|	ТаблицаМатериалы.Номенклатура.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ВЫБОР
	|		КОГДА ИспользоватьХарактеристики.Значение
	|			ТОГДА ТаблицаМатериалы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	СУММА(ТаблицаМатериалы.Количество / ТаблицаМатериалы.КоличествоПродукции * ТаблицаПродукция.Коэффициент * ТаблицаПродукция.Количество) КАК Количество,
	|	ТаблицаМатериалы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА ТаблицаМатериалы.ТипСтрокиСостава = ЗНАЧЕНИЕ(Перечисление.ТипыСтрокСоставаСпецификации.Узел)
	|				И ТИПЗНАЧЕНИЯ(ТаблицаМатериалы.ЕдиницаИзмерения) = ТИП(Справочник.ЕдиницыИзмерения)
	|				И ТаблицаМатериалы.ЕдиницаИзмерения <> ЗНАЧЕНИЕ(Справочник.ЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА ТаблицаМатериалы.ЕдиницаИзмерения.Коэффициент
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Коэффициент,
	|	ТаблицаМатериалы.ДоляСтоимости КАК ДоляСтоимости,
	|	ТаблицаМатериалы.Спецификация КАК Спецификация,
	|	ВЫБОР
	|		КОГДА ВЫБОР
	|				КОГДА ЦеныНоменклатурыСрезПоследних.ЕдиницаИзмерения ССЫЛКА Справочник.ЕдиницыИзмерения
	|					ТОГДА ЦеныНоменклатурыСрезПоследних.ЕдиницаИзмерения.Коэффициент
	|				ИНАЧЕ 1
	|			КОНЕЦ = 0
	|			ТОГДА 0
	|		ИНАЧЕ ЦеныНоменклатурыСрезПоследних.Цена / ВЫБОР
	|				КОГДА ЦеныНоменклатурыСрезПоследних.ЕдиницаИзмерения ССЫЛКА Справочник.ЕдиницыИзмерения
	|					ТОГДА ЦеныНоменклатурыСрезПоследних.ЕдиницаИзмерения.Коэффициент
	|				ИНАЧЕ 1
	|			КОНЕЦ * ВЫБОР
	|				КОГДА ТаблицаМатериалы.ЕдиницаИзмерения ССЫЛКА Справочник.ЕдиницыИзмерения
	|					ТОГДА ТаблицаМатериалы.ЕдиницаИзмерения.Коэффициент
	|				ИНАЧЕ 1
	|			КОНЕЦ
	|	КОНЕЦ КАК Цена
	|ИЗ
	|	ВременнаяТаблицаПродукция КАК ТаблицаПродукция
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Спецификации.Состав КАК ТаблицаМатериалы
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|					&ДатаЦен,
	|					ВидЦен = &ВидЦен
	|						И Актуальность = ИСТИНА) КАК ЦеныНоменклатурыСрезПоследних
	|			ПО ТаблицаМатериалы.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|				И ТаблицаМатериалы.Характеристика = ЦеныНоменклатурыСрезПоследних.Характеристика
	|		ПО ТаблицаПродукция.Спецификация = ТаблицаМатериалы.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСтавкиНДС КАК ВТСтавкиНДС
	|		ПО (ТаблицаМатериалы.Номенклатура.ВидСтавкиНДС = ВТСтавкиНДС.ВидСтавкиНДС),
	|	Константа.ФункциональнаяОпцияИспользоватьХарактеристики КАК ИспользоватьХарактеристики
	|ГДЕ
	|	ТаблицаМатериалы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПродукция.Спецификация,
	|	ТаблицаМатериалы.ТипСтрокиСостава,
	|	ТаблицаМатериалы.Номенклатура,
	|	ТаблицаМатериалы.ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА ТаблицаМатериалы.ТипСтрокиСостава = ЗНАЧЕНИЕ(Перечисление.ТипыСтрокСоставаСпецификации.Узел)
	|				И ТИПЗНАЧЕНИЯ(ТаблицаМатериалы.ЕдиницаИзмерения) = ТИП(Справочник.ЕдиницыИзмерения)
	|				И ТаблицаМатериалы.ЕдиницаИзмерения <> ЗНАЧЕНИЕ(Справочник.ЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА ТаблицаМатериалы.ЕдиницаИзмерения.Коэффициент
	|		ИНАЧЕ 1
	|	КОНЕЦ,
	|	ТаблицаМатериалы.ДоляСтоимости,
	|	ТаблицаМатериалы.Спецификация,
	|	ВЫБОР
	|		КОГДА ИспользоватьХарактеристики.Значение
	|			ТОГДА ТаблицаМатериалы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ТаблицаМатериалы.Номенклатура.СтранаПроисхождения,
	|	ВЫБОР
	|		КОГДА ВЫБОР
	|				КОГДА ЦеныНоменклатурыСрезПоследних.ЕдиницаИзмерения ССЫЛКА Справочник.ЕдиницыИзмерения
	|					ТОГДА ЦеныНоменклатурыСрезПоследних.ЕдиницаИзмерения.Коэффициент
	|				ИНАЧЕ 1
	|			КОНЕЦ = 0
	|			ТОГДА 0
	|		ИНАЧЕ ЦеныНоменклатурыСрезПоследних.Цена / ВЫБОР
	|				КОГДА ЦеныНоменклатурыСрезПоследних.ЕдиницаИзмерения ССЫЛКА Справочник.ЕдиницыИзмерения
	|					ТОГДА ЦеныНоменклатурыСрезПоследних.ЕдиницаИзмерения.Коэффициент
	|				ИНАЧЕ 1
	|			КОНЕЦ * ВЫБОР
	|				КОГДА ТаблицаМатериалы.ЕдиницаИзмерения ССЫЛКА Справочник.ЕдиницыИзмерения
	|					ТОГДА ТаблицаМатериалы.ЕдиницаИзмерения.Коэффициент
	|				ИНАЧЕ 1
	|			КОНЕЦ
	|	КОНЕЦ,
	|	ВТСтавкиНДС.СтавкаНДС
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиПродукции,
	|	НомерСтрокиСостава";
	
	Если НЕ ЗначениеЗаполнено(ВидЦен) Тогда
		ВидЦен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗаказПокупателя,"ВидЦен");
	КонецЕсли;
	Запрос.УстановитьПараметр("ВидЦен", ВидЦен);
	Если ЗначениеЗаполнено(Дата) Тогда
	    Запрос.УстановитьПараметр("ДатаЦен", Дата);
	Иначе	
		Запрос.УстановитьПараметр("ДатаЦен", ТекущаяДата());
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ТипСтрокиСостава = Перечисления.ТипыСтрокСоставаСпецификации.Узел Тогда
			ТаблицаУзлы.Очистить();
			Если НЕ СтекСпецификацийУзлов.Найти(Выборка.Спецификация) = Неопределено Тогда
				ТекстСообщения = НСтр("ru = 'При попытке заполнить табличную часть Материалы по спецификации,
									|обнаружено рекурсивное вхождение элемента'")+" "+Выборка.Номенклатура+" "+НСтр("ru = 'в спецификации'")+" "+Выборка.СпецификацияПродукции+"
									|Операция не выполнена!";
				ВызватьИсключение ТекстСообщения;
			КонецЕсли;
			СтекСпецификацийУзлов.Добавить(Выборка.Спецификация);
			НоваяСтрока = ТаблицаУзлы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			ЗаполнитьТабличнуюЧастьПоСпецификации(СтекСпецификацийУзлов, ТаблицаУзлы);
		Иначе
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
		
		Если НЕ НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС Тогда
			Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС Тогда
				СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСБезНДС();
			Иначе
				СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСНоль();
			КонецЕсли;
			СтрокаТабличнойЧасти.СтавкаНДС = СтавкаНДСПоУмолчанию;
		ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС) Тогда
			СтрокаТабличнойЧасти.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(Организация.ВидСтавкиНДСПоУмолчанию);
		КонецЕсли;
		
		СтавкаНДСЧисло = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаТабличнойЧасти.СтавкаНДС);
		СтрокаТабличнойЧасти.СуммаНДС = ?(СуммаВключаетНДС, 
										  СтрокаТабличнойЧасти.Сумма - (СтрокаТабличнойЧасти.Сумма) / ((СтавкаНДСЧисло + 100) / 100),
										  СтрокаТабличнойЧасти.Сумма * СтавкаНДСЧисло / 100);
										  
		СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(СуммаВключаетНДС, 0, СтрокаТабличнойЧасти.СуммаНДС);
	КонецЦикла;
	
	СтекСпецификацийУзлов.Очистить();
	
	Запасы.Свернуть("Номенклатура, Характеристика, Партия, ЕдиницаИзмерения, Цена, Спецификация, СтавкаНДС, СтранаПроисхождения", "Количество, Сумма, СуммаНДС, Всего");
	
КонецПроцедуры // ЗаполнитьТабличнуюЧастьПоСпецификации()

#КонецОбласти

#Область ПроцедурыЗаполненияДокумента

// Процедура заполняет авансы.
//
Процедура ЗаполнитьПредоплату() Экспорт
	
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация);
	
	// Заполнение расшифровки предоплаты.
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов КАК ВалютаРасчетов,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) КАК СуммаВалОстаток
	|ПОМЕСТИТЬ ВременнаяТаблицаРасчетыСПоставщикамиОстатки
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.Договор КАК Договор,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.Документ.Дата КАК ДокументДата,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками.Остатки(
	|				,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					И Договор = &Договор
	|					И Заказ = &Заказ
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПоставщикамиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПоставщиками.Договор,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ.Дата,
	|		ДвиженияДокументаРасчетыСПоставщиками.Заказ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК ДвиженияДокументаРасчетыСПоставщиками
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПоставщиками.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПоставщиками.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПоставщиками.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПоставщиками.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПоставщиками.Договор = &Договор
	|		И ДвиженияДокументаРасчетыСПоставщиками.Заказ = &Заказ
	|		И ДвиженияДокументаРасчетыСПоставщиками.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПоставщикамиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата,
	|	РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов
	|
	|ИМЕЮЩИЕ
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПоставщикамиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаУчета) КАК СуммаУчета,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаРасчетов) КАК СуммаРасчетов,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаПлатежа) КАК СуммаПлатежа,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаУчета / ВЫБОР
	|			КОГДА ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаРасчетов, 0) <> 0
	|				ТОГДА РасчетыСПоставщикамиОстатки.СуммаРасчетов
	|			ИНАЧЕ 1
	|		КОНЕЦ) * (РасчетыСПоставщикамиОстатки.КурсыВалютыУчетаКурс / РасчетыСПоставщикамиОстатки.КурсыВалютыУчетаКратность) КАК Курс,
	|	1 КАК Кратность,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКурс КАК КурсыВалютыДокументаКурс,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКратность КАК КурсыВалютыДокументаКратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) КАК СуммаУчета,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаРасчетов,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) * КурсыВалютыУчета.Курс * &КратностьВалютыДокумента / (&КурсВалютыДокумента * КурсыВалютыУчета.Кратность) КАК СуммаПлатежа,
	|		КурсыВалютыУчета.Курс КАК КурсыВалютыУчетаКурс,
	|		КурсыВалютыУчета.Кратность КАК КурсыВалютыУчетаКратность,
	|		&КурсВалютыДокумента КАК КурсыВалютыДокументаКурс,
	|		&КратностьВалютыДокумента КАК КурсыВалютыДокументаКратность
	|	ИЗ
	|		ВременнаяТаблицаРасчетыСПоставщикамиОстатки КАК РасчетыСПоставщикамиОстатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаУчета) КАК КурсыВалютыУчета
	|			ПО (ИСТИНА)) КАК РасчетыСПоставщикамиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата,
	|	РасчетыСПоставщикамиОстатки.ВалютаРасчетов,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыУчетаКурс,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыУчетаКратность,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКурс,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКратность
	|
	|ИМЕЮЩИЕ
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаРасчетов) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата";
	
	Если Контрагент.ВестиРасчетыПоЗаказам Тогда
		Запрос.УстановитьПараметр("Заказ", ДокументОснование);
	Иначе
		Запрос.УстановитьПараметр("Заказ", Документы.ЗаказПоставщику.ПустаяСсылка());
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	Если Договор.ВалютаРасчетов = ВалютаДокумента Тогда
		Запрос.УстановитьПараметр("КурсВалютыДокумента", Курс);
		Запрос.УстановитьПараметр("КратностьВалютыДокумента", Кратность);
	Иначе
		Запрос.УстановитьПараметр("КурсВалютыДокумента", 1);
		Запрос.УстановитьПараметр("КратностьВалютыДокумента", 1);
	КонецЕсли;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = ТекстЗапроса;
	
	Предоплата.Очистить();
	СуммаОсталосьРаспределить = Всего;
	СуммаОсталосьРаспределить = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
		СуммаОсталосьРаспределить,
		?(Договор.ВалютаРасчетов = ВалютаДокумента, Курс, 1),
		Курс,
		?(Договор.ВалютаРасчетов = ВалютаДокумента, Кратность, 1),
		Кратность
	);
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока СуммаОсталосьРаспределить > 0 Цикл
		
		Если ВыборкаРезультатаЗапроса.Следующий() Тогда
			
			Если ВыборкаРезультатаЗапроса.СуммаРасчетов <= СуммаОсталосьРаспределить Тогда // сумма остатка меньше или равна чем осталось распределить
				
				НоваяСтрока = Предоплата.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				СуммаОсталосьРаспределить = СуммаОсталосьРаспределить - ВыборкаРезультатаЗапроса.СуммаРасчетов;
				
			Иначе // сумма остатка больше чем нужно распределить
				
				НоваяСтрока = Предоплата.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				НоваяСтрока.СуммаРасчетов = СуммаОсталосьРаспределить;
				НоваяСтрока.СуммаПлатежа = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
					НоваяСтрока.СуммаРасчетов,
					ВыборкаРезультатаЗапроса.Курс,
					ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКурс,
					ВыборкаРезультатаЗапроса.Кратность,
					ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКратность
				);
				СуммаОсталосьРаспределить = 0;
				
			КонецЕсли;
			
		Иначе
			
			СуммаОсталосьРаспределить = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПредоплату()

// Обработчик заполнения на основании документа ЗаказПоставщику
//
// Параметры:
//	ДокументСсылкаЗаказПоставщику - ДокументСсылка.ЗаказПоставщику.
//	
Процедура ЗаполнитьПоЗаказПоставщику(ДокументСсылкаЗаказПоставщику) Экспорт
	
	// Заполнение шапки.
	ЭтотОбъект.ДокументОснование = ДокументСсылкаЗаказПоставщику;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаЗаказПоставщику,
			Новый Структура("Организация, Контрагент, Договор, ЗаказПокупателя, ВалютаДокумента, СуммаВключаетНДС, НДСВключатьВСтоимость, Курс, Кратность, СостояниеЗаказа, Проведен"));
	
	Документы.ЗаказПоставщику.ПроверитьВозможностьВводаНаОснованииЗаказаПоставщику(ДокументСсылкаЗаказПоставщику, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов, "Организация, Контрагент, Договор, ВалютаДокумента, СуммаВключаетНДС, НДСВключатьВСтоимость, Курс, Кратность");
	
	Если Константы.ФункциональнаяОпцияРезервированиеЗапасов.Получить() Тогда
		ЗаказПокупателя = ЗначенияРеквизитов.ЗаказПокупателя;
	КонецЕсли;
	
	НалогообложениеНДС = УправлениеНебольшойФирмойСервер.НалогообложениеНДС(Организация,, ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДата()));
	
	Если НЕ ВалютаДокумента = Константы.НациональнаяВалюта.Получить() Тогда
		СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДата()), Новый Структура("Валюта", Договор.ВалютаРасчетов));
		Курс = СтруктураПоВалюте.Курс;
		Кратность = СтруктураПоВалюте.Кратность;
	КонецЕсли;
	
	// Заполнение документа.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказыОстатки.Характеристика КАК Характеристика,
	|	СУММА(ЗаказыОстатки.КоличествоОстаток) КАК КоличествоОстаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказыОстатки.Номенклатура КАК Номенклатура,
	|		ЗаказыОстатки.Характеристика КАК Характеристика,
	|		ЗаказыОстатки.КоличествоОстаток КАК КоличествоОстаток
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам.Остатки(
	|				,
	|				ЗаказПоставщику = &ДокументОснование
	|					И Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)) КАК ЗаказыОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаЗаказыПоставщикам.Номенклатура,
	|		ДвиженияДокументаЗаказыПоставщикам.Характеристика,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаЗаказыПоставщикам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|				ТОГДА ЕСТЬNULL(ДвиженияДокументаЗаказыПоставщикам.Количество, 0)
	|			ИНАЧЕ -ЕСТЬNULL(ДвиженияДокументаЗаказыПоставщикам.Количество, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам КАК ДвиженияДокументаЗаказыПоставщикам
	|	ГДЕ
	|		ДвиженияДокументаЗаказыПоставщикам.Регистратор = &Ссылка) КАК ЗаказыОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказыОстатки.Номенклатура,
	|	ЗаказыОстатки.Характеристика
	|
	|ИМЕЮЩИЕ
	|	СУММА(ЗаказыОстатки.КоличествоОстаток) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МИНИМУМ(ЗаказПоставщикуЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ЗаказПоставщикуЗапасы.Номенклатура КАК Номенклатура,
	|	ЗаказПоставщикуЗапасы.Характеристика КАК Характеристика,
	|	ЗаказПоставщикуЗапасы.Спецификация КАК Спецификация,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ЗаказПоставщикуЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА 1
	|		ИНАЧЕ ЗаказПоставщикуЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Коэффициент,
	|	ЗаказПоставщикуЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ЗаказПоставщикуЗапасы.Количество) КАК Количество
	|ИЗ
	|	Документ.ЗаказПоставщику.Запасы КАК ЗаказПоставщикуЗапасы
	|ГДЕ
	|	ЗаказПоставщикуЗапасы.Ссылка = &ДокументОснование
	|	И ЗаказПоставщикуЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказПоставщикуЗапасы.Номенклатура,
	|	ЗаказПоставщикуЗапасы.Характеристика,
	|	ЗаказПоставщикуЗапасы.Спецификация,
	|	ЗаказПоставщикуЗапасы.ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ЗаказПоставщикуЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА 1
	|		ИНАЧЕ ЗаказПоставщикуЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаЗаказПоставщику);
	Запрос.УстановитьПараметр("ДатаДокумента", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДата()));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ТаблицаОстатков = МассивРезультатов[0].Выгрузить();
	ТаблицаОстатков.Индексы.Добавить("Номенклатура,Характеристика");
	
	Продукция.Очистить();
	Запасы.Очистить();
	Если ТаблицаОстатков.Количество() > 0 Тогда
		
		Выборка = МассивРезультатов[1].Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтруктураДляПоиска = Новый Структура;
			СтруктураДляПоиска.Вставить("Номенклатура", Выборка.Номенклатура);
			СтруктураДляПоиска.Вставить("Характеристика", Выборка.Характеристика);
			
			МассивСтрокОстатков = ТаблицаОстатков.НайтиСтроки(СтруктураДляПоиска);
			Если МассивСтрокОстатков.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрокаПродукция = Продукция.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаПродукция, Выборка);
			НоваяСтрокаПродукция.Спецификация = УправлениеНебольшойФирмойСервер.ПолучитьПоУмолчаниюСпецификацию(НоваяСтрокаПродукция.Номенклатура, НоваяСтрокаПродукция.Характеристика);
			
			КоличествоКСписанию = Выборка.Количество * Выборка.Коэффициент;
			МассивСтрокОстатков[0].КоличествоОстаток = МассивСтрокОстатков[0].КоличествоОстаток - КоличествоКСписанию;
			Если МассивСтрокОстатков[0].КоличествоОстаток < 0 Тогда
				НоваяСтрокаПродукция.Количество = (КоличествоКСписанию + МассивСтрокОстатков[0].КоличествоОстаток) / Выборка.Коэффициент;
			Иначе
				НоваяСтрокаПродукция.Количество = Выборка.Количество;
			КонецЕсли;
			
			Если НЕ НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС Тогда
			
				Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС Тогда
					СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСБезНДС();
				Иначе
					СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСНоль();
				КонецЕсли;
				
				Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
					СтрокаТабличнойЧасти.СтавкаНДС = СтавкаНДСПоУмолчанию;
				КонецЦикла;
			
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ДокументСсылкаЗаказПоставщику.Материалы.Количество()>0 Тогда
	    Запасы.Загрузить(ДокументСсылкаЗаказПоставщику.Материалы.Выгрузить());
	Иначе
		// Заполним по спецификации продукции
		СтекСпецификацийУзлов = Новый Массив;
		ЗаполнитьТабличнуюЧастьПоСпецификации(СтекСпецификацийУзлов);
	КонецЕсли;
	
	НалогообложениеНДС = УправлениеНебольшойФирмойСервер.НалогообложениеНДС(Организация,, ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДата()));
	Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
		
		Если НЕ НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС Тогда
			Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС Тогда
				СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСБезНДС();
			Иначе
				СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСНоль();
			КонецЕсли;
			СтрокаТабличнойЧасти.СтавкаНДС = СтавкаНДСПоУмолчанию;
		ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС) Тогда
			СтрокаТабличнойЧасти.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(Организация.ВидСтавкиНДСПоУмолчанию);
		КонецЕсли;
		
		СтавкаНДСЧисло = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаТабличнойЧасти.СтавкаНДС);
		СтрокаТабличнойЧасти.СуммаНДС = ?(СуммаВключаетНДС, 
		СтрокаТабличнойЧасти.Сумма - (СтрокаТабличнойЧасти.Сумма) / ((СтавкаНДСЧисло + 100) / 100),
		СтрокаТабличнойЧасти.Сумма * СтавкаНДСЧисло / 100);
		
		СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(СуммаВключаетНДС, 0, СтрокаТабличнойЧасти.СуммаНДС);
	КонецЦикла;
	
	Запасы.Свернуть("Номенклатура, Характеристика, Партия, ЕдиницаИзмерения, Цена, Спецификация, СтавкаНДС, СтранаПроисхождения", "Количество, Сумма, СуммаНДС, Всего");
	
КонецПроцедуры // ЗаполнитьПоЗаказПоставщику()

// Обработчик заполнения на основании документа ПриходныйОрдер
//
// Параметры:
//	ДокументСсылкаПриходныйОрдер - ДокументСсылка.ПриходныйОрдер.
//	
Процедура ЗаполнитьПоПриходныйОрдер(ДокументСсылкаПриходныйОрдер) Экспорт
	
	// Заполнение шапки документа.
	Организация = ДокументСсылкаПриходныйОрдер.Организация;
	СтруктурнаяЕдиница = ДокументСсылкаПриходныйОрдер.СтруктурнаяЕдиница;
	Ячейка = ДокументСсылкаПриходныйОрдер.Ячейка;
	НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС;
	
	// Заполнение табличной части документа.
	ЭтотОбъект.Продукция.Очистить();
	Для каждого строкаЗапасы Из ДокументСсылкаПриходныйОрдер.Запасы Цикл
		
		НовСтр = ЭтотОбъект.Продукция.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, строкаЗапасы);
		
		НовСтр.Спецификация = УправлениеНебольшойФирмойСервер.ПолучитьПоУмолчаниюСпецификацию(строкаЗапасы.Номенклатура, строкаЗапасы.Характеристика);
	
	КонецЦикла;
	
	ЭтотОбъект.СерийныеНомера.Очистить();
	ЭтотОбъект.СерийныеНомера.Загрузить(ДокументСсылкаПриходныйОрдер.СерийныеНомера.Выгрузить());
	
КонецПроцедуры // ЗаполнитьПоПриходныйОрдер()

// Обработчик заполнения на основании документа РасходнаяНакладная
//
// Параметры:
//	ДокументСсылкаРасходнаяНакладная - ДокументСсылка.РасходнаяНакладная.
//	
Процедура ЗаполнитьПоРасходнаяНакладная(ДокументСсылкаРасходнаяНакладная) Экспорт
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылкаРасходнаяНакладная, "ВидОперации")
		<> Перечисления.ВидыОперацийРасходнаяНакладная.ПередачаВПереработку Тогда
		ВызватьИсключение НСтр("ru = 'Отчет о переработке вводится только на основании передачи в переработку!'");;
	КонецЕсли;
	
	// Заполнение шапки.
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаРасходнаяНакладная,
			Новый Структура("Организация, Контрагент, Договор, Заказ, ВидЦен, ВалютаДокумента, НалогообложениеНДС, СуммаВключаетНДС, НДСВключатьВСтоимость, Курс, Кратность"));
	
	Документы.ЗаказПоставщику.ПроверитьВозможностьВводаНаОснованииЗаказаПоставщику(ДокументСсылкаРасходнаяНакладная, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов, "Организация, Контрагент, Договор, ВидЦен, ВалютаДокумента, НалогообложениеНДС, СуммаВключаетНДС, НДСВключатьВСтоимость, Курс, Кратность");
	ЭтотОбъект.ДокументОснование = ЗначенияРеквизитов.Заказ;
	
	Если Константы.ФункциональнаяОпцияРезервированиеЗапасов.Получить()
		И ТИПЗНЧ(ЗначенияРеквизитов.Заказ) = ТИП("ДокументСсылка.ЗаказПоставщику") Тогда
		ЗаказПокупателя = ЗначенияРеквизитов.Заказ.ЗаказПокупателя;
	КонецЕсли;
	
	Если НЕ ВалютаДокумента = Константы.НациональнаяВалюта.Получить() Тогда
		СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДата()), Новый Структура("Валюта", Договор.ВалютаРасчетов));
		Курс = СтруктураПоВалюте.Курс;
		Кратность = СтруктураПоВалюте.Кратность;
	КонецЕсли;
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасходнаяНакладнаяЗапасы.НомерСтроки КАК НомерСтроки,
	|	РасходнаяНакладнаяЗапасы.Номенклатура КАК Номенклатура,
	|	РасходнаяНакладнаяЗапасы.Характеристика КАК Характеристика,
	|	РасходнаяНакладнаяЗапасы.Партия КАК Партия,
	|	РасходнаяНакладнаяЗапасы.Количество КАК Количество,
	|	РасходнаяНакладнаяЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	РасходнаяНакладнаяЗапасы.Цена КАК Цена,
	|	РасходнаяНакладнаяЗапасы.Сумма КАК Сумма,
	|	РасходнаяНакладнаяЗапасы.СтавкаНДС КАК СтавкаНДС,
	|	РасходнаяНакладнаяЗапасы.СуммаНДС КАК СуммаНДС,
	|	РасходнаяНакладнаяЗапасы.Всего КАК Всего,
	|	РасходнаяНакладнаяЗапасы.СерийныеНомера КАК СерийныеНомера,
	|	РасходнаяНакладнаяЗапасы.КлючСвязи КАК КлючСвязи
	|ИЗ
	|	Документ.РасходнаяНакладная.Запасы КАК РасходнаяНакладнаяЗапасы
	|ГДЕ
	|	РасходнаяНакладнаяЗапасы.Ссылка = &ДокументОснование
	|	И РасходнаяНакладнаяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказПоставщикуЗапасы.Номенклатура КАК Номенклатура,
	|	ЗаказПоставщикуЗапасы.Характеристика КАК Характеристика,
	|	ЗаказПоставщикуЗапасы.Количество КАК Количество,
	|	ЗаказПоставщикуЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЗаказПоставщикуЗапасы.Спецификация КАК Спецификация
	|ИЗ
	|	Документ.ЗаказПоставщику.Запасы КАК ЗаказПоставщикуЗапасы
	|ГДЕ
	|	ЗаказПоставщикуЗапасы.Ссылка = &ОснованиеЗаказПоставщику";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаРасходнаяНакладная);
	Запрос.УстановитьПараметр("ОснованиеЗаказПоставщику", ЗначенияРеквизитов.Заказ);
	
	Запасы.Очистить();
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатЗапасы = МассивРезультатов[0];
	Если НЕ РезультатЗапасы.Пустой() Тогда
		Выборка = РезультатЗапасы.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.Спецификация = УправлениеНебольшойФирмойСервер.ПолучитьПоУмолчаниюСпецификацию(НоваяСтрока.Номенклатура, НоваяСтрока.Характеристика);
		КонецЦикла;
	КонецЕсли;
	
	РезультатПродукция = МассивРезультатов[1];
	Продукция.Загрузить(РезультатПродукция.Выгрузить());
	
КонецПроцедуры // ЗаполнитьПоРасходнаяНакладная()

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент)
	И НЕ Контрагент.ВестиРасчетыПоДоговорам
	И НЕ ЗначениеЗаполнено(Договор) Тогда
		Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказПоставщику")] = "ЗаполнитьПоЗаказПоставщику";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПриходныйОрдер")] = "ЗаполнитьПоПриходныйОрдер";
	СтратегияЗаполнения[Тип("ДокументСсылка.РасходнаяНакладная")] = "ЗаполнитьПоРасходнаяНакладная";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Расход)
	 ИЛИ ЗначениеЗаполнено(Всего) Тогда
		
		ПроверяемыеРеквизиты.Добавить("Расход");
		ПроверяемыеРеквизиты.Добавить("Сумма");
		
	КонецЕсли;
	
	ВсегоПредоплата = Предоплата.Итог("СуммаПлатежа");
	
	РасчетыРаботаСФормамиВызовСервера.ПроверитьЗаполнениеДокументаПредоплаты(Контрагент, ПроверяемыеРеквизиты);
	
	Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
	КонецЕсли;
	
	// Серийные номера
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурнаяЕдиница,"ОрдерныйСклад") = Истина Тогда
		РаботаССерийнымиНомерами.ПроверкаЗаполненияСерийныхНомеров(Отказ, Продукция, СерийныеНомера, СтруктурнаяЕдиница, ЭтотОбъект);
	КонецЕсли;
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
	
	ГрузовыеТаможенныеДекларацииСервер.ПриОбработкеПроверкиЗаполнения(Отказ, ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ОтчетПереработчика.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыВРазрезеГТД(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьВыпускПродукции(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыКПоступлениюНаСклады(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыПереданные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗаказыПоставщикам(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРазмещениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыКассовыйМетод(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыНераспределенные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыОтложенные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);

	// СерийныеНомера
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераГарантии(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераОстатки(ДополнительныеСвойства, Движения, Отказ);
	
	УправлениеНебольшойФирмойСервер.ОтразитьЗакупкиДляКУДиР(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.ОтчетПереработчика.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.ОтчетПереработчика.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
	// Подчиненная счет-фактура (полученная)
	Если НЕ Отказ Тогда
		
		КонтрольПодчиненнойСчетФактуры();
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

// Процедура - обработчик события ПриКопировании объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	Предоплата.Очистить();
	
КонецПроцедуры // ПриКопировании()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	УправлениеНебольшойФирмойСервер.ПриЗаписиДокументаОснованияСчетаФактуры(Ссылка, ДополнительныеСвойства, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура отмены проведения у подченненой счет фактуры (полученной)
//
Процедура КонтрольПодчиненнойСчетФактуры()
	
	СтруктураСчетаФактуры = УправлениеНебольшойФирмойСервер.ПолучитьПодчиненныйСчетФактуру(Ссылка, Истина);
	Если СтруктураСчетаФактуры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СчетФактура	 = СтруктураСчетаФактуры.Ссылка;
	Если Не СчетФактура.Проведен Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'В связи с отсутствием движений у документа %ПредставлениеТекущегоДокумента% распроводится %ПредставлениеСчетФактуры%.'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеТекущегоДокумента%", """Отчет переработчика № " + Номер + " от " + Формат(Дата, "ДФ=dd.MM.yyyy") + """");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеСчетФактуры%", """Счет фактура (полученная) № " + СтруктураСчетаФактуры.Номер + " от " + СтруктураСчетаФактуры.Дата + """");
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	СчетФактураОбъект = СчетФактура.ПолучитьОбъект();
	СчетФактураОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	
КонецПроцедуры //КонтрольПодчиненнойСчетФактуры()

#КонецОбласти

#КонецЕсли