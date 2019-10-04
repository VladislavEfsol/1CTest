
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	// Для тех, у кого есть профиль "Рабочее место кассира" 
	Если ПараметрыРаботыКлиента.Свойство("ЕстьПрофильРМК") И ПараметрыРаботыКлиента.ЕстьПрофильРМК Тогда
		РабочееМестоКассираВызовСервера.УстановитьМинимальныйИнтерфейсРМК();
		ОбновитьИнтерфейс();
		ОткрытьФормуРМК();
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Запуск формы РМК

Процедура ОткрытьФормуРМК() Экспорт
	
	ЗначенияЗаполнения = РабочееМестоКассираВызовСервера.ПолучитьКассуККМИТерминалПоУмолчанию();
	
	МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
	
	Если ТребуетсяОткрытьОкноВыбораКассы(ЗначенияЗаполнения) Тогда
		ОткрытьФорму("Документ.ЧекККМ.Форма.ФормаДокумента_РМК_ОкноВыбораКассы", 
		Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения));
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(
	"Документ.ЧекККМ.Форма.ФормаДокумента_РМК",
	Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения));

КонецПроцедуры

Функция ТребуетсяОткрытьОкноВыбораКассы(ЗначенияЗаполнения) Экспорт
	
	Если Не ЗначениеЗаполнено(ЗначенияЗаполнения.КассаККМ) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗначенияЗаполнения.КоличествоЭквайринговыхТерминалов)
		И Не ЗначениеЗаполнено(ЗначенияЗаполнения.ЭквайринговыйТерминал) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции
