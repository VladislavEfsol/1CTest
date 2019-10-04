#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция рассчитывает сумму документа.
//
Функция ПолучитьСуммуДокумента() Экспорт

	ТаблицаНачислений = Новый ТаблицаЗначений;
    Массив = Новый Массив;
	СтруктураВозврата = Новый Структура("СуммаНачислено, СуммаУдержано, СуммаДокумента, СуммаПогашено, СуммаВзносов", 0, 0, 0, 0, 0);
	
	СтруктураВозврата.СуммаВзносов = Взносы.Итог("Сумма");
	Массив.Добавить(Тип("СправочникСсылка.ВидыНачисленийИУдержаний"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаНачислений.Колонки.Добавить("ВидНачисленияУдержания", ОписаниеТипов);

	Массив.Добавить(Тип("Число"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаНачислений.Колонки.Добавить("Сумма", ОписаниеТипов);
	
	Для каждого СтрокаТЧ Из НачисленияУдержания Цикл
		НоваяСтрока = ТаблицаНачислений.Добавить();
        НоваяСтрока.ВидНачисленияУдержания = СтрокаТЧ.ВидНачисленияУдержания;
        НоваяСтрока.Сумма = СтрокаТЧ.Сумма;
	КонецЦикла;
	Для каждого СтрокаТЧ Из НалогиНаДоходы Цикл
		НоваяСтрока = ТаблицаНачислений.Добавить();
        НоваяСтрока.ВидНачисленияУдержания = СтрокаТЧ.ВидНачисленияУдержания;
        НоваяСтрока.Сумма = СтрокаТЧ.Сумма;
	КонецЦикла;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ТаблицаНачисленияУдержания.ВидНачисленияУдержания,
	                      |	ТаблицаНачисленияУдержания.Сумма
	                      |ПОМЕСТИТЬ ТаблицаНачисленияУдержания
	                      |ИЗ
	                      |	&ТаблицаНачисленияУдержания КАК ТаблицаНачисленияУдержания
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СУММА(ВЫБОР
	                      |			КОГДА НачислениеЗарплатыНачисленияУдержания.ВидНачисленияУдержания.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Начисление)
	                      |				ТОГДА НачислениеЗарплатыНачисленияУдержания.Сумма
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК СуммаНачислено,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА НачислениеЗарплатыНачисленияУдержания.ВидНачисленияУдержания.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Начисление)
	                      |				ТОГДА 0
	                      |			ИНАЧЕ НачислениеЗарплатыНачисленияУдержания.Сумма
	                      |		КОНЕЦ) КАК СуммаУдержано,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА НачислениеЗарплатыНачисленияУдержания.ВидНачисленияУдержания.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Начисление)
	                      |				ТОГДА НачислениеЗарплатыНачисленияУдержания.Сумма
	                      |			ИНАЧЕ -1 * НачислениеЗарплатыНачисленияУдержания.Сумма
	                      |		КОНЕЦ) КАК СуммаДокумента
	                      |ИЗ
	                      |	ТаблицаНачисленияУдержания КАК НачислениеЗарплатыНачисленияУдержания");
						  
	Запрос.УстановитьПараметр("ТаблицаНачисленияУдержания", ТаблицаНачислений);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	СтруктураВозврата.Вставить("СуммаПогашено", ПогашениеЗаймов.Итог("ПогашеноЗайма") + ПогашениеЗаймов.Итог("ПогашеноПроцентов"));
	
	Если РезультатЗапроса[1].Пустой() Тогда
		СтруктураВозврата.СуммаДокумента = СтруктураВозврата.СуммаДокумента - СтруктураВозврата.СуммаПогашено;
		Возврат СтруктураВозврата;	
	Иначе
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, РезультатЗапроса[1].Выгрузить()[0]);
		Если ЗначениеЗаполнено(СтруктураВозврата.СуммаДокумента) Тогда
			СтруктураВозврата.СуммаДокумента = СтруктураВозврата.СуммаДокумента - СтруктураВозврата.СуммаПогашено;
		Иначе
			СтруктураВозврата.СуммаДокумента = -СтруктураВозврата.СуммаПогашено;
		КонецЕсли;
		Возврат СтруктураВозврата;	
	КонецЕсли; 

КонецФункции // ПолучитьСуммуДокумента()

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	СуммаДокумента = ПолучитьСуммуДокумента().СуммаДокумента;
	
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимНаправлениямДеятельности.Получить() Тогда
		
		Для каждого СтрокаНачисленияУдержания из НачисленияУдержания Цикл
			
			Если СтрокаНачисленияУдержания.СчетЗатрат.ТипСчета = Перечисления.ТипыСчетов.Расходы Тогда
				
				СтрокаНачисленияУдержания.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ОсновноеНаправление;
				
			КонецЕсли;	
			
		КонецЦикла;	
		
		Для каждого СтрокаВзносы из Взносы Цикл
			
			Если СтрокаВзносы.СчетЗатрат.ТипСчета = Перечисления.ТипыСчетов.Расходы Тогда
				
				СтрокаВзносы.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ОсновноеНаправление;
				
			КонецЕсли;	
			
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Для начисления страховых взносов запишем изначально доходы по страховым взносам
	Сотрудники.ОтразитьСтраховыеВзносыДоходы(Ссылка, ДополнительныеСвойства, Движения, Отказ);
	
	// Инициализация данных документа.
	Документы.НачислениеЗарплаты.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	УправлениеНебольшойФирмойСервер.ОтразитьНачисленияИУдержания(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыСПерсоналом(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыПоНалогам(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	// Учет расчетов по займам сотрудникам.
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыПоКредитамИЗаймам(ДополнительныеСвойства, Движения, Отказ);
	Сотрудники.ОтразитьПримененныеВычетыПоНДФЛ(ДополнительныеСвойства, Движения, Отказ);
	Сотрудники.ОтразитьНДФЛДоходы(ДополнительныеСвойства, Движения, Отказ);
	Сотрудники.ОтразитьСтраховыеВзносыДоходы(Ссылка, ДополнительныеСвойства, Движения, Отказ);
	Сотрудники.ОтразитьРасчетыСФондамиПоСтраховымВзносам(ДополнительныеСвойства, Движения, Отказ);
	Сотрудники.ОтразитьНДФЛРасчетыНалоговыхАгентовСБюджетом(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.НачислениеЗарплаты.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	Документы.НачислениеЗарплаты.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#КонецЕсли