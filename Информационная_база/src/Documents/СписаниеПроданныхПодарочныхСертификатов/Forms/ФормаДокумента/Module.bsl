#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерезаполнитьОстатокПоСертификатам(Команда)
	
	ЗаполнитьОстатокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПросроченнымиСертификатами(Команда)
	
	Если Объект.ПодарочныеСертификаты.Количество() > 0 Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПросроченнымиСертификатамиЗавершение", ЭтотОбъект),
			НСтр("ru = 'Табличная часть будет очищена. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьПросроченнымиСертификатамиНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПросроченнымиСертификатамиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПросроченнымиСертификатамиНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПросроченнымиСертификатамиНаСервере()
		
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК ПодарочныйСертификат,
	|	Номенклатура.ТипСрокаДействия КАК ТипСрокаДействия
	|ПОМЕСТИТЬ Сертификаты
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат)
	|	И Номенклатура.ТипСрокаДействия <> ЗНАЧЕНИЕ(Перечисление.СрокДействияПодарочныхСертификатов.БезОграниченияСрока)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ЕСТЬNULL(СерийныеНомера.Ссылка, ЗНАЧЕНИЕ(Справочник.СерийныеНомера.ПустаяСсылка)) КАК НомерСертификата,
	|	Сертификаты.ТипСрокаДействия КАК ТипСрокаДействия
	|ПОМЕСТИТЬ СертификатыСНомерами
	|ИЗ
	|	Сертификаты КАК Сертификаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СерийныеНомера КАК СерийныеНомера
	|		ПО Сертификаты.ПодарочныйСертификат = СерийныеНомера.Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СерийныеНомераОбороты.СерийныйНомер КАК НомерСертификата,
	|	МАКСИМУМ(СерийныеНомераОбороты.Период) КАК ПериодПродажи
	|ПОМЕСТИТЬ ПродажиПоНомерам
	|ИЗ
	|	РегистрНакопления.СерийныеНомера.Обороты(
	|			,
	|			,
	|			Регистратор,
	|			СерийныйНомер В
	|				(ВЫБРАТЬ
	|					СертификатыСНомерами.НомерСертификата КАК НомерСертификата
	|				ИЗ
	|					СертификатыСНомерами КАК СертификатыСНомерами)) КАК СерийныеНомераОбороты
	|ГДЕ
	|	(СерийныеНомераОбороты.Регистратор ССЫЛКА Документ.РасходнаяНакладная
	|			ИЛИ СерийныеНомераОбороты.Регистратор ССЫЛКА Документ.ЧекККМ
	|			ИЛИ СерийныеНомераОбороты.Регистратор ССЫЛКА Документ.ЗаказПокупателя)
	|
	|СГРУППИРОВАТЬ ПО
	|	СерийныеНомераОбороты.СерийныйНомер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СертификатыСНомерами.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	СертификатыСНомерами.НомерСертификата КАК НомерСертификата,
	|	ВЫБОР
	|		КОГДА СертификатыСНомерами.ТипСрокаДействия = ЗНАЧЕНИЕ(Перечисление.СрокДействияПодарочныхСертификатов.СОграничениемНаДату)
	|			ТОГДА СертификатыСНомерами.ПодарочныйСертификат.ДатаОкончанияДействия
	|		КОГДА СертификатыСНомерами.ТипСрокаДействия = ЗНАЧЕНИЕ(Перечисление.СрокДействияПодарочныхСертификатов.ПериодПослеПродажи)
	|			ТОГДА ВЫБОР
	|					КОГДА СертификатыСНомерами.ПодарочныйСертификат.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиПоНомерам.ПериодПродажи, ДЕНЬ, СертификатыСНомерами.ПодарочныйСертификат.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА СертификатыСНомерами.ПодарочныйСертификат.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиПоНомерам.ПериодПродажи, НЕДЕЛЯ, СертификатыСНомерами.ПодарочныйСертификат.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА СертификатыСНомерами.ПодарочныйСертификат.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиПоНомерам.ПериодПродажи, ДЕКАДА, СертификатыСНомерами.ПодарочныйСертификат.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА СертификатыСНомерами.ПодарочныйСертификат.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиПоНомерам.ПериодПродажи, МЕСЯЦ, СертификатыСНомерами.ПодарочныйСертификат.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА СертификатыСНомерами.ПодарочныйСертификат.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиПоНомерам.ПериодПродажи, КВАРТАЛ, СертификатыСНомерами.ПодарочныйСертификат.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА СертификатыСНомерами.ПодарочныйСертификат.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиПоНомерам.ПериодПродажи, ПОЛУГОДИЕ, СертификатыСНомерами.ПодарочныйСертификат.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА СертификатыСНомерами.ПодарочныйСертификат.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиПоНомерам.ПериодПродажи, ГОД, СертификатыСНомерами.ПодарочныйСертификат.КоличествоПериодовДействия), ДЕНЬ)
	|					ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|				КОНЕЦ
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ КАК СрокОкончания
	|ПОМЕСТИТЬ СертификатыСоСроками
	|ИЗ
	|	СертификатыСНомерами КАК СертификатыСНомерами
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПродажиПоНомерам КАК ПродажиПоНомерам
	|		ПО СертификатыСНомерами.НомерСертификата = ПродажиПоНомерам.НомерСертификата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СертификатыСоСроками.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	СертификатыСоСроками.НомерСертификата КАК НомерСертификата,
	|	ПодарочныеСертификатыОстатки.СуммаОстаток КАК Остаток
	|ИЗ
	|	СертификатыСоСроками КАК СертификатыСоСроками
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПодарочныеСертификаты.Остатки(, ) КАК ПодарочныеСертификатыОстатки
	|		ПО СертификатыСоСроками.ПодарочныйСертификат = ПодарочныеСертификатыОстатки.ПодарочныйСертификат
	|			И СертификатыСоСроками.НомерСертификата = ПодарочныеСертификатыОстатки.НомерСертификата
	|			И (СертификатыСоСроками.СрокОкончания <= &СрокОкончания)");
	Запрос.УстановитьПараметр("СрокОкончания", Объект.Дата);
	
	Объект.ПодарочныеСертификаты.Загрузить(Запрос.Выполнить().Выгрузить());
		
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДополнительныйРеквизит(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийНаборСвойств", ПредопределенноеЗначение("Справочник.НаборыДополнительныхРеквизитовИСведений.Документ_СписаниеПроданныхПодарочныхСертификатов"));
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Ложь);
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Объект.Организация);
	
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	// Установка способа выбора структурной единицы в зависимости от ФО.
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимПодразделениям.Получить() Тогда
		
		Элементы.СтруктурнаяЕдиница.РежимВыбораИзСписка = Истина;
		Элементы.СтруктурнаяЕдиница.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
		
	КонецЕсли;
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = УправлениеСвойствамиПереопределяемый.ЗаполнитьДополнительныеПараметры(Объект, "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// Серийные номера
	ИспользоватьСерийныеНомераОстатки = РаботаССерийнымиНомерами.ИспользоватьСерийныеНомераОстатки();
	
	УправлениеНебольшойФирмойСервер.НастроитьФормуОбъектаМобильныйКлиент(Элементы);
	
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
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НеОткрыватьФорму Тогда
		Отказ = Истина;
	КонецЕсли;
	
	УправлениеФормой();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ПриЗакрытии()

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "Проведение"+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	КонецЕсли;
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обсуждения
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Модифицированность", Модифицированность);
	// Конец Обсуждения
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Обработчик механизма "Свойства"	
	
КонецПроцедуры // ПередЗаписьюНаСервере()

// Процедура - обработчик события ОбработкаОповещения формы.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
	   И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			//Преобразуем предварительно к ожидаемому формату
			Данные = Новый Массив();
			Если Параметр[1] = Неопределено Тогда
				Данные.Добавить(Новый Структура("Штрихкод, Количество", Параметр[0], 1)); // Достаем штрихкод из основных данных
			Иначе
				Данные.Добавить(Новый Структура("Штрихкод, Количество", Параметр[1][1], 1)); // Достаем штрихкод из дополнительных данных
			КонецЕсли;
			
			//ПолученыШтрихкоды(Данные);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// Обсуждения
	ОбсужденияКлиент.ОбработкаОповещения(ИмяСобытия, Параметр, Источник, ЭтотОбъект, Объект.Ссылка);
	// Конец Обсуждения
	
КонецПроцедуры // ОбработкаОповещения()

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
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
Процедура ОрганизацияПриИзменении(Элемент)
	
	// Обработка события изменения организации.
	Объект.Номер = "";
	
КонецПроцедуры // ОрганизацияПриИзменении()

// Процедура - обработчик события Открытие поля СтруктурнаяЕдиница.
//
&НаКлиенте
Процедура СтруктурнаяЕдиницаОткрытие(Элемент, СтандартнаяОбработка)
	
	Если Элементы.СтруктурнаяЕдиница.РежимВыбораИзСписка
		И НЕ ЗначениеЗаполнено(Объект.СтруктурнаяЕдиница) Тогда
		
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры // СтруктурнаяЕдиницаОткрытие()

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура ПодарочныеСертификатыНомерСертификатаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПодборДляОплаты", Истина);
	СтруктураПараметров.Вставить("Отбор", Новый Структура("Владелец", Элементы.ПодарочныеСертификаты.ТекущиеДанные.ПодарочныйСертификат));
	ОткрытьФорму("Справочник.СерийныеНомера.ФормаВыбора", СтруктураПараметров, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодарочныеСертификатыНомерСертификатаПриИзменении(Элемент)
	
	ЗаполнитьОстатокСертификатов(Элементы.ПодарочныеСертификаты.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодарочныеСертификатыПодарочныйСертификатПриИзменении(Элемент)
	
	ЗаполнитьОстатокСертификатов(Элементы.ПодарочныеСертификаты.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеОбъектов

&НаКлиенте
Процедура СохранитьДокументКакШаблон(Параметр) Экспорт
	
	ЗаполнениеОбъектовУНФКлиент.СохранитьДокументКакШаблон(Объект, ОтображаемыеРеквизиты(), Параметр);
	
КонецПроцедуры

&НаСервере
Функция ОтображаемыеРеквизиты()
	
	Возврат ЗаполнениеОбъектовУНФ.ОтображаемыеРеквизиты(ЭтотОбъект);
	
КонецФункции

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

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры // Подключаемый_РедактироватьСоставСвойств()

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры // ОбновитьЭлементыДополнительныхРеквизитов()

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область УправлениеВнешнимВидомФормы

&НаКлиенте
Процедура УправлениеФормой()
	
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОстатокСертификатов(НомерСтроки = Неопределено)
	
	Если НомерСтроки = Неопределено Тогда
		Результат = РаботаСПодарочнымиСертификатами.ПолучитьСтруктуруДанныхПоТаблицеСертификатов(
			Объект.ПодарочныеСертификаты.Выгрузить(, "ПодарочныйСертификат, НомерСертификата"));
		Объект.ПодарочныеСертификаты.Загрузить(Результат);
	Иначе
		Результат = РаботаСПодарочнымиСертификатами.ПолучитьСтруктуруДанныхСертификата(
			Объект.ПодарочныеСертификаты.НайтиПоИдентификатору(НомерСтроки).ПодарочныйСертификат,
			Объект.ПодарочныеСертификаты.НайтиПоИдентификатору(НомерСтроки).НомерСертификата);
		Объект.ПодарочныеСертификаты.НайтиПоИдентификатору(НомерСтроки).Остаток = Результат.Остаток;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	РазностьДат = УправлениеНебольшойФирмойСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить(
		"РазностьДат",
		РазностьДат
	);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

#КонецОбласти