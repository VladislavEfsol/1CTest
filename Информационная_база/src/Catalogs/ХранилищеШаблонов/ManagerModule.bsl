#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имя поля из доступных полей компоновки данных.
//
Функция ИмяПоляВШаблоне(Знач ИмяПоля) Экспорт
	
	ИмяПоля = СтрЗаменить(ИмяПоля, ".DeletionMark", ".ПометкаУдаления");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Owner", ".Владелец");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Code", ".Код");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Parent", ".Родитель");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Predefined", ".Предопределенный");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".IsFolder", ".ЭтоГруппа");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Description", ".Наименование");
	Возврат ИмяПоля;
	
КонецФункции

// Получает массивы реквизитов зависимых от реквизита типа шаблона.
// Параметры:
//           Объект - СправочникСсылка.ХранилищеШаблонов - Элемент справочника для которого устанавливаем доступные
//                                                         реквизиты.
//           МассивВсехРеквизитов - Неопределено - Выходной параметр с типом Массив в который будут помещены имена всех
//                                                 реквизитов справочника.
//           МассивРеквизитовОперации - Неопределено - Выходной параметр с типом Массив в который будут помещены имена
//                                                     реквизитов справочника.
//
Процедура ЗаполнитьИменаРеквизитовПоТипуШаблона(Объект, МассивВсехРеквизитов, МассивРеквизитов) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("Наименование");
	МассивВсехРеквизитов.Добавить("ТипШаблона");
	МассивВсехРеквизитов.Добавить("ОбъектМетаданных");
	
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить("Наименование");
	МассивРеквизитов.Добавить("ТипШаблона");
	
	Если Объект.ТипШаблона = Перечисления.ТипыШаблонов.ПустаяСсылка() Тогда
		МассивРеквизитов.Добавить("ОбъектМетаданных");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
