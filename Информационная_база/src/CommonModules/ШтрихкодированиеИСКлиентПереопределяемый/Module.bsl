#Область ПрограммныйИнтерфейс

// В процедуре нужно показать диалоговое окно для ввода штрихкода и передать полученные данные в описание оповещения.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - процедура, которую нужно вызвать после ввода штрихкода.
//
Процедура ПоказатьВводШтрихкода(Оповещение) Экспорт
	
	ИнтеграцияМОТПУНФКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

// В процедуре необходимо реализовать алгоритм обработки
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой были обработаны штрихкоды,
//  ОбработанныеДанные - Структура - подготовленные ранее данные штрихкодов,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
Процедура ПослеОбработкиШтрихкодов(Форма, ОбработанныеДанные, КэшированныеЗначения) Экспорт
	
	ИнтеграцияМОТПУНФКлиент.ПослеОбработкиШтрихкодов(Форма, ОбработанныеДанные, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ОткрытьФормуПодбораНоменклатурыПоШтрихкодам(НеизвестныеШтрихкоды,
		ФормаВладелец = Неопределено, ОповещениеОЗакрытии = Неопределено) Экспорт
	
	СтруктураПараметров  = Новый Структура;
	СтруктураПараметров.Вставить("НеизвестныеШтрихкоды", НеизвестныеШтрихкоды);
	
	ОткрытьФорму("Обработка.РаботаСНоменклатурой.Форма.ПоискНоменклатурыПоШтрихкоду", 
		СтруктураПараметров, ФормаВладелец, Новый УникальныйИдентификатор, , , ОповещениеОЗакрытии);
	
КонецПроцедуры

Процедура ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения) Экспорт
	
	ИнтеграцияМОТПУНФКлиент.ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения);
	
КонецПроцедуры

// Вызывается после загрузки данных из ТСД. В процедуре нужно проанализировать полученные штрихкоды на предмет сканирования акцизной марки, а также
// обработать штрихкоды, не привязанные к номенклатуре.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой были обработаны штрихкоды,
//  ОбработанныеДанные - Структура - подготовленные ранее данные штрихкодов,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
Процедура ПослеОбработкиТаблицыТоваровПолученнойИзТСД(Форма, ОбработанныеДанные, КэшированныеЗначения) Экспорт
	
	ИнтеграцияМОТПУНФКлиент.ПослеОбработкиТаблицыТоваровПолученнойИзТСД(Форма, ОбработанныеДанные, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
	Форма, ТаблицаТоваров, КэшированныеЗначения, ПараметрыЗаполнения, СтруктураДействий) Экспорт

	ИнтеграцияМОТПУНФКлиент.ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
		Форма, ТаблицаТоваров, КэшированныеЗначения, ПараметрыЗаполнения, СтруктураДействий);
	
КонецПроцедуры

Процедура ЗаполнитьПолноеИмяФормыУказанияСерии(ПолноеИмяФормыУказанияСерии) Экспорт
	
	ИнтеграцияМОТПУНФКлиент.ЗаполнитьПолноеИмяФормыУказанияСерии(ПолноеИмяФормыУказанияСерии);
	
КонецПроцедуры

// В данной процедуре нужно переопределить параметры записи журнала регистрации при отказе ввода кода маркировки.
// 
// Параметры:
//  Форма - УправляемаяФорма - форма, для которой происходит обработка штрихкода.
//  СтруктураСообщения - Структура:
//   * ИмяСобытия - Строка - Имя события журнала регистрации.
//   * Уровень - Строка - Уровень журнала регистрации. Возможные уровни: "Информация", "Ошибка", "Предупреждение",
//        "Примечание".
//   * Данные - Любая ссылка, Число, Строка, Дата, Булево, Неопределено; Null; Тип - Данные журнала регистрации.
//   * СсылкаНаОбъект - Любая ссылка - Ссылка на объект, на основании которого будут полученные метаданные для записи
//        в журнал регистрации.
//   * КодМаркировки - Строка - Введеный код маркировки. Если значение кода не заполнено - ввод кода маркировки отменен
//        по инициативе пользователя.
Процедура ПриОпределенииИнформацииОбОтказеВводаКодаМаркиДляЖурналаРегистрации(Форма, СтруктураСообщения) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти
