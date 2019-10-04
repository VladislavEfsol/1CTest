#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	РасчетыСПоставщиками.НомерСтроки КАК НомерСтроки,
	|	РасчетыСПоставщиками.Организация КАК Организация,
	|	РасчетыСПоставщиками.Контрагент КАК Контрагент,
	|	РасчетыСПоставщиками.Договор КАК Договор,
	|	РасчетыСПоставщиками.Документ КАК Документ,
	|	РасчетыСПоставщиками.Заказ КАК Заказ,
	|	РасчетыСПоставщиками.ТипРасчетов КАК ТипРасчетов,
	|	РасчетыСПоставщиками.Сумма КАК СуммаПередЗаписью,
	|	РасчетыСПоставщиками.Сумма КАК СуммаИзменение,
	|	РасчетыСПоставщиками.Сумма КАК СуммаПриЗаписи,
	|	РасчетыСПоставщиками.СуммаВал КАК СуммаВалПередЗаписью,
	|	РасчетыСПоставщиками.СуммаВал КАК СуммаВалИзменение,
	|	РасчетыСПоставщиками.СуммаВал КАК СуммаВалПриЗаписи
	|ПОМЕСТИТЬ ДвиженияРасчетыСПоставщикамиИзменение
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК РасчетыСПоставщиками");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыСПоставщикамиИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Контрагент)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли