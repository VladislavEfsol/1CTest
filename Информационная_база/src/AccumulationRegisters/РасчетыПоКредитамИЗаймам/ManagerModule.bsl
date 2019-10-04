#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ЕстьРасчетыПоКредитамИЗаймам() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	РасчетыПоКредитамИЗаймам.Организация
		|ИЗ
		|	РегистрНакопления.РасчетыПоКредитамИЗаймам КАК РасчетыПоКредитамИЗаймам";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ВЫБОР КОГДА ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКредитаИЗайма.КредитПолученный) ТОГДА ЗначениеРазрешено(Контрагент)
	|	ИНАЧЕ ИСТИНА КОНЕЦ И ЗначениеРазрешено(ВидДоговора)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли