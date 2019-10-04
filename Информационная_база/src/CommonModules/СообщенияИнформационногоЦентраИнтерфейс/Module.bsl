////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ИНТЕРФЕЙСА СООБЩЕНИЙ ИНФОРМАЦИОННОГО ЦЕНТРА
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter/Messages/" + Версия();
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
//
Функция Версия() Экспорт
	
	Возврат "1.0.1.1";
	
КонецФункции

// Возвращает название программного интерфейса сообщений.
//
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "MessageInfoCenter";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияИнформационногоЦентраОбработчикСообщения_1_0_1_1);
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter/Messages/a.b.c.d}notificateSuggestion
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОповещенияПожелания(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения("notificateSuggestion", ИспользуемыйПакет);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач Тип, Знач ИспользуемыйПакет = Неопределено)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти