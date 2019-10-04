
#Область ПрограммныйИнтерфейс

// Возвращает текущую дату, приведенную к часовому поясу сеанса.
// Предназначена для использования вместо функции ТекущаяДата().
//
// Возвращаемое значение:
//  Результат - текущая дата.
//
Функция ДатаСеанса() Экспорт
	
	Возврат ТекущаяДата();
	
КонецФункции

// Функция возвращает объект обработчика драйвера по его наименованию.
//
// Параметры:
//  ОбработчикДрайвера  - Перечисление, ссылка на обработчик драйвера подключаемого оборудования.
//  ЗагружаемыйДрайвер  - Булево, признак, что драйвер загружаемый
//  ТипОборудованияИмя  - Строка, представление типа оборудования
//
// Возвращаемое значение:
//  Результат - Используемый модуль обработчика драйвера.
//
Функция ПолучитьОбработчикДрайвера(ОбработчикДрайвера, ЗагружаемыйДрайвер, ТипОборудованияИмя) Экспорт

// Используем универсальный обработчик драйвера по стандарту "1С:Совместимо".
#Если ВебКлиент Тогда
	Результат = ПодключаемоеОборудованиеУниверсальныйДрайверАсинхронноКлиент; 
#Иначе
	Результат = ПодключаемоеОборудованиеУниверсальныйДрайверКлиент;
#КонецЕсли
	
	// Обработчики драйверов не удовлетворяющие стандарту "1С:Совместимо".
	Если Не ЗагружаемыйДрайвер И ОбработчикДрайвера <> Неопределено Тогда
		
		// Сканеры штрихкода
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССканерыШтрихкода") Тогда
			Возврат ПодключаемоеОборудование1ССканерыШтрихкодаКлиент;
		КонецЕсли;
		// Конец Сканеры штрихкода
		
		// Считыватели магнитных карт
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССчитывателиМагнитныхКарт") Тогда
			Возврат ПодключаемоеОборудование1ССчитывателиМагнитныхКартКлиент;
		КонецЕсли;
		// Конец Считыватели магнитных карт.
		
	        // Весы с печатью этикеток
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикACOMВесыСПечатьюЭтикеток") Тогда
			Возврат ПодключаемоеОборудованиеACOMВесыСПечатьюЭтикетокКлиент;
		КонецЕсли;
		// Конец Весы с печатью этикеток.
	
		// ККМ Офлайн
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолККМOffline") Тогда
			Возврат ОфлайнОборудованиеАтолККМКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМККМOffline") Тогда
			Возврат ОфлайнОборудованиеШтрихМККМКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СККМOffline") Тогда
			Возврат ОфлайнОборудование1СККМКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СЭвоторККМOffline") Тогда
			Возврат ОфлайнОборудование1СЭвоторКлиент;
		КонецЕсли;
		// Конец ККМ Офлайн
		
		// Web-сервис оборудование
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СWebСервисОборудование") Тогда
			Возврат Неопределено;
		КонецЕсли;
		// Конец Web-сервис оборудование
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Процедура отправляет электронное сообщение на электронную почта и абонентский номер.
//
Процедура НачатьОтправкуЭлектронногоЧека(ПараметрыЧека, ТекстСообщения, ПокупательEmail, ПокупательНомер) Экспорт
	
	РассылкаЭлектронныхЧековКлиент.НачатьОтправкуЭлектронногоЧека(ПараметрыЧека, ТекстСообщения, ПокупательEmail, ПокупательНомер);
	
КонецПроцедуры

// Начинает рассылку или ставит задачу на рассылку нефискальных документов.
// Которые заданы в шаблоне чека.
Процедура НачатьРассылкуНефискальныхДокументов(Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти
 
#Область РаботаСФормойЭкземпляраОборудования

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриОткрытии".
//
Процедура ЭкземплярОборудованияПриОткрытии(Объект, ЭтаФорма, Отказ) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗакрытием".
//
Процедура ЭкземплярОборудованияПередЗакрытием(Объект, ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписью".
//
Процедура ЭкземплярОборудованияПередЗаписью(Объект, ЭтаФорма, Отказ, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписи".
//
Процедура ЭкземплярОборудованияПослеЗаписи(Объект, ЭтаФорма, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ОбработкаНавигационнойСсылки".
//
Процедура ЭкземплярОборудованияОбработкаНавигационнойСсылки(Объект, ЭтаФорма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ТипОборудованияОбработкаВыбора".
//
Процедура ЭкземплярОборудованияТипОборудованияВыбор(Объект, ЭтаФорма, ЭтотОбъект, Элемент, ВыбранноеЗначение) Экспорт
	
	// Доступ к узлу есть только для соответствующего оборудования.
	ЭтаФорма.Элементы.ПравилоОбмена.Видимость = Объект.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККМОфлайн")
		ИЛИ Объект.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток")
		ИЛИ Объект.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.УдалитьWebСервисОборудование");
	
КонецПроцедуры

#КонецОбласти

Процедура ОбработатьСобытие() Экспорт
	
КонецПроцедуры

