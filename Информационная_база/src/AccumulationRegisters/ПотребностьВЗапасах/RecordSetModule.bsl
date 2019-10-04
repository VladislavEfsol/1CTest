#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПотребностьВЗапасах.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияПотребностьВЗапасахИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияПотребностьВЗапасахИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияПотребностьВЗапасахИзменение Тогда
		
		// Если временная таблица "ДвиженияПотребностьВЗапасахИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияПотребностьВЗапасахПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПотребностьВЗапасах.НомерСтроки КАК НомерСтроки,
		|	ПотребностьВЗапасах.Организация КАК Организация,
		|	ПотребностьВЗапасах.ТипДвижения КАК ТипДвижения,
		|	ПотребностьВЗапасах.ЗаказПокупателя КАК ЗаказПокупателя,
		|	ПотребностьВЗапасах.Номенклатура КАК Номенклатура,
		|	ПотребностьВЗапасах.Характеристика КАК Характеристика,
		|	ВЫБОР
		|		КОГДА ПотребностьВЗапасах.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ПотребностьВЗапасах.Количество
		|		ИНАЧЕ -ПотребностьВЗапасах.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияПотребностьВЗапасахПередЗаписью
		|ИЗ
		|	РегистрНакопления.ПотребностьВЗапасах КАК ПотребностьВЗапасах
		|ГДЕ
		|	ПотребностьВЗапасах.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияПотребностьВЗапасахИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблцу "ДвиженияПотребностьВЗапасахПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияПотребностьВЗапасахИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияПотребностьВЗапасахИзменение.Организация КАК Организация,
		|	ДвиженияПотребностьВЗапасахИзменение.ТипДвижения КАК ТипДвижения,
		|	ДвиженияПотребностьВЗапасахИзменение.ЗаказПокупателя КАК ЗаказПокупателя,
		|	ДвиженияПотребностьВЗапасахИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияПотребностьВЗапасахИзменение.Характеристика КАК Характеристика,
		|	ДвиженияПотребностьВЗапасахИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияПотребностьВЗапасахПередЗаписью
		|ИЗ
		|	ДвиженияПотребностьВЗапасахИзменение КАК ДвиженияПотребностьВЗапасахИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПотребностьВЗапасах.НомерСтроки,
		|	ПотребностьВЗапасах.Организация,
		|	ПотребностьВЗапасах.ТипДвижения,
		|	ПотребностьВЗапасах.ЗаказПокупателя,
		|	ПотребностьВЗапасах.Номенклатура,
		|	ПотребностьВЗапасах.Характеристика,
		|	ВЫБОР
		|		КОГДА ПотребностьВЗапасах.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ПотребностьВЗапасах.Количество
		|		ИНАЧЕ -ПотребностьВЗапасах.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ПотребностьВЗапасах КАК ПотребностьВЗапасах
		|ГДЕ
		|	ПотребностьВЗапасах.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияПотребностьВЗапасахИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияПотребностьВЗапасахИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияПотребностьВЗапасахИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияПотребностьВЗапасахИзменение");
	
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияПотребностьВЗапасахИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияПотребностьВЗапасахИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияПотребностьВЗапасахИзменение.Организация КАК Организация,
	|	ДвиженияПотребностьВЗапасахИзменение.ТипДвижения КАК ТипДвижения,
	|	ДвиженияПотребностьВЗапасахИзменение.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ДвиженияПотребностьВЗапасахИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияПотребностьВЗапасахИзменение.Характеристика КАК Характеристика,
	|	СУММА(ДвиженияПотребностьВЗапасахИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияПотребностьВЗапасахИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияПотребностьВЗапасахИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияПотребностьВЗапасахИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияПотребностьВЗапасахПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияПотребностьВЗапасахПередЗаписью.Организация КАК Организация,
	|		ДвиженияПотребностьВЗапасахПередЗаписью.ТипДвижения КАК ТипДвижения,
	|		ДвиженияПотребностьВЗапасахПередЗаписью.ЗаказПокупателя КАК ЗаказПокупателя,
	|		ДвиженияПотребностьВЗапасахПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияПотребностьВЗапасахПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияПотребностьВЗапасахПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияПотребностьВЗапасахПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияПотребностьВЗапасахПередЗаписью КАК ДвиженияПотребностьВЗапасахПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияПотребностьВЗапасахПриЗаписи.НомерСтроки,
	|		ДвиженияПотребностьВЗапасахПриЗаписи.Организация,
	|		ДвиженияПотребностьВЗапасахПриЗаписи.ТипДвижения,
	|		ДвиженияПотребностьВЗапасахПриЗаписи.ЗаказПокупателя,
	|		ДвиженияПотребностьВЗапасахПриЗаписи.Номенклатура,
	|		ДвиженияПотребностьВЗапасахПриЗаписи.Характеристика,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияПотребностьВЗапасахПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияПотребностьВЗапасахПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияПотребностьВЗапасахПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияПотребностьВЗапасахПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ПотребностьВЗапасах КАК ДвиженияПотребностьВЗапасахПриЗаписи
	|	ГДЕ
	|		ДвиженияПотребностьВЗапасахПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияПотребностьВЗапасахИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияПотребностьВЗапасахИзменение.Организация,
	|	ДвиженияПотребностьВЗапасахИзменение.ТипДвижения,
	|	ДвиженияПотребностьВЗапасахИзменение.ЗаказПокупателя,
	|	ДвиженияПотребностьВЗапасахИзменение.Номенклатура,
	|	ДвиженияПотребностьВЗапасахИзменение.Характеристика
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияПотребностьВЗапасахИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ТипДвижения,
	|	ЗаказПокупателя,
	|	Номенклатура,
	|	Характеристика");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияПотребностьВЗапасахИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияПотребностьВЗапасахИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияПотребностьВЗапасахПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияПотребностьВЗапасахПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#КонецЕсли