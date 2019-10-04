
#Область ПрограммныйИнтерфейс

// Событие журнала регистрации для подсистемы Телефония.
// 
// Возвращаемое значение:
//  Строка - Имя события.
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru='Телефония'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

// Добавляет запись в журнал регистрации с вложенным событием.
//
// Параметры:
//  ВложенноеИмяСобытия	 - Строка - Вложенное имя события.
//  Текст				 - Строка - Комментарий журнала регистрации.
//  УровеньЖР			 - УровеньЖурналаРегистрации - Уровень важности событий журнала регистрации.
//
Процедура ЗаписатьЗапросВЖурналРегистрации(ВложенноеИмяСобытия, Текст, УровеньЖР = Неопределено) Экспорт
	
	Если УровеньЖР = Неопределено Тогда
		УровеньЖР = УровеньЖурналаРегистрации.Примечание;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		СобытиеЖурналаРегистрации() + "." + ВложенноеИмяСобытия,
		УровеньЖР,,,
		Текст);
	
КонецПроцедуры

// Переопределяемые настройки для формы настроек одного пользователя АТС.
// 
// Возвращаемое значение:
//  Структура
//   * ПоказыватьИсходящийНомер - Булево - Опрелеет видимость колонки "Исходящий номер АТС".
//
Функция НастройкиФормыПользователей() Экспорт
	
	НастройкиФормы = Новый Структура;
	НастройкиФормы.Вставить("ПоказыватьИсходящийНомер", Константы.ИспользуемаяАТС.Получить() = Перечисления.ДоступныеАТС.Яндекс);
	
	Возврат НастройкиФормы;
	
КонецФункции

// См. ТелефонияСервер.ИспользоватьНастройкуМаршрутизацииЗвонковНаОтветственного
//
Процедура НастройкаМаршрутизацииАТСИспользуетсяВ(СписокАТС) Экспорт
	
	СписокАТС.Добавить(Перечисления.ДоступныеАТС.MangoOffice);
	СписокАТС.Добавить(Перечисления.ДоступныеАТС.Ростелеком);
	
КонецПроцедуры

// См. ТелефонияСервер.ПоказыватьУведомлениеОНовомЗвонке
//
Процедура ПоказУведомленияОНовомЗвонкеНеИспользуетсяВ(СписокАТС) Экспорт
	
	СписокАТС.Добавить(Перечисления.ДоступныеАТС.Ростелеком);
	
КонецПроцедуры

#Область ПереопределяемыеМетодыАТС

// См. ТелефонияСервер.ПриСозданииИсходящегоВызова
//
Процедура ПриСозданииИсходящегоВызова(ДанныеЗвонка, ДанныеПользователяАТС, URL, ТелоЗапроса, Заголовки, ЗащищенноеСоединение, Ошибка) Экспорт
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	
	АТС = Константы.ИспользуемаяАТС.Получить();
	
	Если НЕ НастройкиИнтеграцииЗаполнены(АТС, НастройкиТелефонии) Тогда
		Ошибка = "НеЗаполненыНастройкиИнтеграции";
		Возврат;
	КонецЕсли;
	
	НомерКонтакта = ДанныеЗвонка.НомерКонтакта;
	НомерКонтакта = КонтактнаяИнформацияУНФ.ПреобразоватьНомерДляКонтактнойИнформации(НомерКонтакта);
	
	Если АТС = Перечисления.ДоступныеАТС.MangoOffice Тогда
		ПриСозданииИсходящегоВызоваMangoOffice(НомерКонтакта, ДанныеПользователяАТС, НастройкиТелефонии, URL, ТелоЗапроса, Заголовки, Ошибка);
	ИначеЕсли ЭтоПлатформаItoolabs(АТС) Тогда
		ПриСозданииИсходящегоВызоваItoolabs(НомерКонтакта, ДанныеПользователяАТС, НастройкиТелефонии, URL, ТелоЗапроса, Заголовки, Ошибка);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Яндекс Тогда
		ПриСозданииИсходящегоВызоваЯндекс(НомерКонтакта, ДанныеПользователяАТС, НастройкиТелефонии, URL, ТелоЗапроса, Заголовки, Ошибка);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Ростелеком Тогда
		ПриСозданииИсходящегоВызоваРостелеком(НомерКонтакта, ДанныеПользователяАТС, НастройкиТелефонии, URL, ТелоЗапроса, Заголовки, Ошибка);
	Иначе
		ВызватьИсключение ТекстОшибкиРеализацияНеОпределена(АТС, "ПриСозданииИсходящегоВызова");
	КонецЕсли;
	
	Если АТС = Перечисления.ДоступныеАТС.ТТК Тогда
		ЗащищенноеСоединение = Неопределено;
	Иначе
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	КонецЕсли;
	
КонецПроцедуры

// См. ТелефонияСервер.ПриОбработкеПолученияИнформацииОВызывающемАбоненте
//
Процедура ПриОбработкеПолученияИнформацииОВызывающемАбоненте(АТС, ДанныеАбонента, Ответ) Экспорт
	
	Если АТС = Перечисления.ДоступныеАТС.MangoOffice Тогда
		ПриОбработкеПолученияИнформацииОВызывающемАбонентеMangoOffice(ДанныеАбонента, Ответ);
	ИначеЕсли ЭтоПлатформаItoolabs(АТС) Тогда
		ПриОбработкеПолученияИнформацииОВызывающемАбонентеItoolabs(ДанныеАбонента, Ответ);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Яндекс Тогда
		ПриОбработкеПолученияИнформацииОВызывающемАбонентеЯндекс(ДанныеАбонента, Ответ);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Ростелеком Тогда
		ПриОбработкеПолученияИнформацииОВызывающемАбонентеРостелеком(ДанныеАбонента, Ответ);
	Иначе
		ВызватьИсключение ТекстОшибкиРеализацияНеОпределена(АТС, "ПриОбработкеПолученияИнформацииОВызывающемАбоненте");
	КонецЕсли;
	
КонецПроцедуры

// См. ТелефонияСервер.ПриОбработкеОтветаНаСозданиеИсходящегоВызова
//
Процедура ПриОбработкеОтветаНаСозданиеИсходящегоВызова(HTTPОтвет, ИмяСобытияДляЖурналаРегистрации) Экспорт
	
	ЗаголовокОшибки = Неопределено;
	ТекстОшибки = Неопределено;
	
	АТС = Константы.ИспользуемаяАТС.Получить();
	
	Если АТС = Перечисления.ДоступныеАТС.MangoOffice Тогда
		ПриОбработкеОтветаНаСозданиеИсходящегоВызоваMangoOffice(HTTPОтвет, ЗаголовокОшибки, ТекстОшибки);
	ИначеЕсли ЭтоПлатформаItoolabs(АТС) Тогда
		ПриОбработкеОтветаНаСозданиеИсходящегоВызоваItoolabs(HTTPОтвет, ЗаголовокОшибки, ТекстОшибки);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Яндекс Тогда
		ПриОбработкеОтветаНаСозданиеИсходящегоВызоваЯндекс(HTTPОтвет, ЗаголовокОшибки, ТекстОшибки);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Ростелеком Тогда
		ПриОбработкеОтветаНаСозданиеИсходящегоВызоваРостелеком(HTTPОтвет, ЗаголовокОшибки, ТекстОшибки);
	Иначе
		ВызватьИсключение ТекстОшибкиРеализацияНеОпределена(АТС, "ПриОбработкеОтветаНаСозданиеИсходящегоВызова");
	КонецЕсли;
	
	ТекстОшибки = СтрШаблон("%1%2%3",
		ЗаголовокОшибки,
		Символы.ПС,
		ТекстОшибки);
	
КонецПроцедуры

// См. ТелефонияСервер.ПриПолученииАдресаОбратногоВызова
//
Процедура ПриПолученииАдресаОбратногоВызова(АТС, ШаблонСтрокиПодключения, ПараметрыПодключения, АдресОбратногоВызова) Экспорт
	
	Если АТС = Перечисления.ДоступныеАТС.MangoOffice Тогда
		ПриПолученииАдресаОбратногоВызоваMangoOffice(ШаблонСтрокиПодключения, ПараметрыПодключения, АдресОбратногоВызова);
	ИначеЕсли ЭтоПлатформаItoolabs(АТС) Тогда
		ПриПолученииАдресаОбратногоВызоваItoolabs(ШаблонСтрокиПодключения, ПараметрыПодключения, АдресОбратногоВызова);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Яндекс Тогда
		ПриПолученииАдресаОбратногоВызоваЯндекс(ШаблонСтрокиПодключения, ПараметрыПодключения, АдресОбратногоВызова);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Ростелеком Тогда
		ПриПолученииАдресаОбратногоВызоваРостелеком(ШаблонСтрокиПодключения, ПараметрыПодключения, АдресОбратногоВызова);
	Иначе
		ВызватьИсключение ТекстОшибкиРеализацияНеОпределена(АТС, "ПриПолученииАдресаОбратногоВызова");
	КонецЕсли;
	
КонецПроцедуры

// См. ТелефонияСервер.КорневойАдресАТС
//
Функция КорневойАдресАТС() Экспорт
	
	АТС = Константы.ИспользуемаяАТС.Получить();
	
	Если АТС = Перечисления.ДоступныеАТС.MangoOffice Тогда
		Возврат КорневойАдресMangoOffice();
	ИначеЕсли ЭтоПлатформаItoolabs(АТС) Тогда
		Возврат КорневойАдресItoolabs();
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Яндекс Тогда
		Возврат КорневойАдресЯндекс();
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Ростелеком Тогда
		Возврат КорневойАдресРостелеком();
	Иначе
		ВызватьИсключение ТекстОшибкиРеализацияНеОпределена(АТС, "КорневойАдресАТС");
	КонецЕсли;
	
КонецФункции

// См. ТелефонияСервер.КорневойURLСервисаОсновнойПубликации
//
Функция КорневойURLСервисаОсновнойПубликации(АТС) Экспорт
	
	ШаблонURL = "";
	
	Если АТС = Перечисления.ДоступныеАТС.MangoOffice Тогда
		ШаблонURL = ШаблонURLHTTPСервисаMangoOffice();
	ИначеЕсли ЭтоПлатформаItoolabs(АТС) Тогда
		ШаблонURL = ШаблонURLHTTPСервисаItoolabs();
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Яндекс Тогда
		ШаблонURL = ШаблонURLHTTPСервисаЯндекс();
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Ростелеком Тогда
		ШаблонURL = ШаблонURLHTTPСервисаРостелеком();
	Иначе
		ВызватьИсключение ТекстОшибкиРеализацияНеОпределена(АТС, "КорневойURLСервисаОсновнойПубликации");
	КонецЕсли;
	
	Возврат СтрШаблон("telephony/%1", ШаблонURL);
	
КонецФункции

// См. ТелефонияСервер.КорректнаяПодписьЗапроса
//
Функция КорректнаяПодписьЗапроса(АТС, ПодписьЗапроса, ПараметрыЗапроса = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если АТС = Перечисления.ДоступныеАТС.MangoOffice Тогда
		Возврат КорректнаяПодписьЗапросаMangoOffice(АТС, ПодписьЗапроса, ПараметрыЗапроса);
	ИначеЕсли ЭтоПлатформаItoolabs(АТС) Тогда
		Возврат КорректнаяПодписьЗапросаItoolabs(АТС, ПодписьЗапроса, ПараметрыЗапроса);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Яндекс Тогда
		Возврат КорректнаяПодписьЗапросаЯндекс(АТС, ПодписьЗапроса, ПараметрыЗапроса);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Ростелеком Тогда
		Возврат КорректнаяПодписьЗапросаРостелеком(АТС, ПодписьЗапроса, ПараметрыЗапроса);
	Иначе
		ВызватьИсключение ТекстОшибкиРеализацияНеОпределена(АТС, "КорректнаяПодписьЗапроса");
	КонецЕсли;
	
КонецФункции

// См. ТелефонияСервер.СсылкаНаЗаписьРазговора
//
Функция СсылкаНаЗаписьРазговора(ДанныеЗвонка, Ошибка) Экспорт
	
	АТС = Константы.ИспользуемаяАТС.Получить();
	
	Если АТС = Перечисления.ДоступныеАТС.MangoOffice Тогда
		Возврат СсылкаНаЗаписьРазговораMangoOffice(ДанныеЗвонка, Ошибка);
	ИначеЕсли ЭтоПлатформаItoolabs(АТС) Тогда
		Возврат СсылкаНаЗаписьРазговораItoolabs(ДанныеЗвонка, Ошибка);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Яндекс Тогда
		Возврат СсылкаНаЗаписьРазговораЯндекс(ДанныеЗвонка, Ошибка);
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Ростелеком Тогда
		Возврат СсылкаНаЗаписьРазговораРостелеком(ДанныеЗвонка, Ошибка);
	Иначе
		ВызватьИсключение ТекстОшибкиРеализацияНеОпределена(АТС, "СсылкаНаЗаписьРазговора");
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область MangoOffice

Процедура ПриСозданииИсходящегоВызоваMangoOffice(НомерАбонента, ДанныеПользователяАТС, НастройкиТелефонии, URL, ТелоЗапроса, Заголовки, Ошибка)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	
	ЗаписьJSON.ЗаписатьИмяСвойства("command_id");
	ЗаписьJSON.ЗаписатьЗначение(Строка(Новый УникальныйИдентификатор));
	
	ЗаписьJSON.ЗаписатьИмяСвойства("from");
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("extension");
	ЗаписьJSON.ЗаписатьЗначение(ДанныеПользователяАТС.ВнутреннийНомер);
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	
	ЗаписьJSON.ЗаписатьИмяСвойства("to_number");
	ЗаписьJSON.ЗаписатьЗначение(НомерАбонента);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	json = ЗаписьJSON.Закрыть();
	
	sign = ПолучитьSign(НастройкиТелефонии.vpbx_api_key, json, НастройкиТелефонии.vpbx_api_salt);
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить("vpbx_api_key=" + КодировкаURL(НастройкиТелефонии.vpbx_api_key));
	ПараметрыЗапроса.Добавить("sign=" + КодировкаURL(sign));
	ПараметрыЗапроса.Добавить("json=" + КодировкаURL(json));
	
	ТелоЗапроса = СтрСоединить(ПараметрыЗапроса, "&");
	
	URL = URL + "commands/callback";
	
КонецПроцедуры

Процедура ПриОбработкеПолученияИнформацииОВызывающемАбонентеMangoOffice(ДанныеАбонента, Ответ)
	
КонецПроцедуры

Процедура ПриОбработкеОтветаНаСозданиеИсходящегоВызоваMangoOffice(HTTPОтвет, ЗаголовокОшибки, ТекстОшибки)
	
	ТелоОтвета = РаскодироватьСтроку(HTTPОтвет.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	
	Если HTTPОтвет.КодСостояния = 200 Тогда
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТелоОтвета);
		ПараметрыОтвета = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		
		КодОтвета = Неопределено;
		ПараметрыОтвета.Свойство("result", КодОтвета);
		
		// 1ххх: Действие успешно выполнено
		Если СтрНачинаетсяС(КодОтвета, "1") Тогда
			Возврат;
		КонецЕсли;
		
		ЗаголовокОшибки = РасшифровкаОшибкиMango(КодОтвета);
		ТекстОшибки = ТелоОтвета;
		
	Иначе
		
		ЗаголовокОшибки = НСтр("ru='Ошибка при инициализации вызова.'");
		ТекстОшибки = ТелоОтвета;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриПолученииАдресаОбратногоВызоваMangoOffice(ШаблонСтрокиПодключения, ПараметрыПодключения, АдресОбратногоВызова)
	
	
	
КонецПроцедуры

Функция КорневойАдресMangoOffice()
	
	Возврат "https://app.mango-office.ru/vpbx/";
	
КонецФункции

Функция ШаблонURLHTTPСервисаMangoOffice()
	
	Возврат "mango";
	
КонецФункции

Функция КорректнаяПодписьЗапросаMangoOffice(АТС, ПодписьЗапроса, ПараметрыЗапроса = Неопределено)
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	РассчитанныйSign = ТелефонияСервер.ПолучитьSign(
		НастройкиТелефонии.vpbx_api_key,
		ПараметрыЗапроса.json,
		НастройкиТелефонии.vpbx_api_salt);
	
	Возврат РассчитанныйSign = ПодписьЗапроса;
	
КонецФункции

Функция НастройкиИнтеграцииЗаполненыMangoOffice(АТС, НастройкиТелефонии)
	
	Возврат ЗначениеЗаполнено(НастройкиТелефонии.vpbx_api_key)
		И ЗначениеЗаполнено(НастройкиТелефонии.vpbx_api_salt);
	
КонецФункции

Функция СсылкаНаЗаписьРазговораMangoOffice(ДанныеЗвонка, Ошибка)
	
	ШаблонURL = ТелефонияСервер.КорневойАдресАТС() + "queries/recording/issa/[recording_id]/[action]";
	ПараметрыURL = Новый Структура;
	ПараметрыURL.Вставить("recording_id", ДанныеЗвонка.ИдентификаторЗвонкаВАТС);
	ПараметрыURL.Вставить("action", "play");
	URL = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонURL, ПараметрыURL);
	
	Возврат URL;
	
КонецФункции

#Область СлужебныеПроцедурыИФункцииMangoOffice

Функция ПолучитьSign(vpbx_api_key, json, vpbx_api_salt)
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA256);
	//ХешированиеДанных.Добавить(vpbx_api_key + json + vpbx_api_salt);
	ХешированиеДанных.Добавить(vpbx_api_key);
	ХешированиеДанных.Добавить(json);
	ХешированиеДанных.Добавить(vpbx_api_salt);
	
	Возврат НРег(СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", ""));
	
КонецФункции

Функция РасшифровкаОшибкиMango(Знач Код)
	
	Код = Формат(Код, "ЧГ=0");
	
	Если СтрНачинаетсяС(Код, "21") Тогда // 2100
		Возврат НСтр("ru='Доступ к счету невозможен'");
	ИначеЕсли Код = "2210" Тогда
		Возврат НСтр("ru='Доступ ограничен периодом использования'");
	ИначеЕсли Код = "2211" Тогда
		Возврат НСтр("ru='Достигнут дневной лимит использования услуги'");
	ИначеЕсли Код = "2212" Тогда
		Возврат НСтр("ru='Достигнут месячный лимит использования услуги'");
	ИначеЕсли Код = "2220" Тогда
		Возврат НСтр("ru='Количество одновременных вызовов/действий ограничено'");
	ИначеЕсли Код = "2230" Тогда
		Возврат НСтр("ru='Услуга недоступна'");
	ИначеЕсли Код = "2240" Тогда
		Возврат НСтр("ru='Недостаточно средств на счете'");
	ИначеЕсли Код = "2250" Тогда
		Возврат НСтр("ru='Ограничение на количество использований услуги в биллинге'");
	ИначеЕсли СтрНачинаетсяС(Код, "22") Тогда // 2200
		Возврат НСтр("ru='Доступ к счету ограничен'");
	ИначеЕсли СтрНачинаетсяС(Код, "23") Тогда // 2300
		Возврат НСтр("ru='Направление заблокировано'");
	ИначеЕсли СтрНачинаетсяС(Код, "24") Тогда // 2400
		Возврат НСтр("ru='Ошибка биллинга'");
	ИначеЕсли СтрНачинаетсяС(Код, "2") Тогда // 2000
		Возврат НСтр("ru='Ограничение биллинговой системы'");
	ИначеЕсли Код = "3100" Тогда
		Возврат НСтр("ru='Переданы неверные параметры команды'");
	ИначеЕсли Код = "3101" Тогда
		Возврат НСтр("ru='Запрос выполнен по методу, отличному от POST'");
	ИначеЕсли Код = "3102" Тогда
		Возврат НСтр("ru='Значение ключа не соответствуют рассчитанному'");
	ИначеЕсли Код = "3103" Тогда
		Возврат НСтр("ru='В запросе отсутствует обязательный параметр'");
	ИначеЕсли Код = "3104" Тогда
		Возврат НСтр("ru='Параметр передан в неправильном формате'");
	ИначеЕсли Код = "3105" Тогда
		Возврат НСтр("ru='Неверный ключ доступа'");
	ИначеЕсли СтрНачинаетсяС(Код, "32") Тогда // 3200
		Возврат НСтр("ru='Неверно указан номер абонента'");
	ИначеЕсли Код = "3310" Тогда
		Возврат НСтр("ru='Вызов не найден'");
	ИначеЕсли Код = "3320" Тогда
		Возврат НСтр("ru='Запись разговора не найдена'");
	ИначеЕсли Код = "3330" Тогда
		Возврат НСтр("ru='Номер не найден у ВАТС или сотрудника'");
	ИначеЕсли СтрНачинаетсяС(Код, "33") Тогда // 3300
		Возврат НСтр("ru='Объект не существует'");
	ИначеЕсли СтрНачинаетсяС(Код, "3") Тогда // 3000
		Возврат НСтр("ru='Неверный запрос'");
	ИначеЕсли СтрНачинаетсяС(Код, "4") Тогда // 4000
		Возврат НСтр("ru='Действие не может быть выполнено'");
	ИначеЕсли СтрНачинаетсяС(Код, "5") Тогда // 5000
		Возврат НСтр("ru='Ошибка сервера'");
	Иначе
		Возврат НСтр("ru='Неизвестная ошибка'");
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Itoolabs

Процедура ПриСозданииИсходящегоВызоваItoolabs(НомерАбонента, ДанныеПользователяАТС, НастройкиТелефонии, URL, ТелоЗапроса, Заголовки, Ошибка)
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить("cmd=makeCall");
	ПараметрыЗапроса.Добавить("phone=" + НомерАбонента);
	ПараметрыЗапроса.Добавить("user=" + ДанныеПользователяАТС.ВнутреннийНомер);
	ПараметрыЗапроса.Добавить("token=" + НастройкиТелефонии.КлючДляАвторизацииВОблачнойАТС);
	
	ТелоЗапроса = СтрСоединить(ПараметрыЗапроса, "&");
	
КонецПроцедуры

Процедура ПриОбработкеПолученияИнформацииОВызывающемАбонентеItoolabs(ДанныеАбонента, Ответ)
	
КонецПроцедуры

Процедура ПриОбработкеОтветаНаСозданиеИсходящегоВызоваItoolabs(HTTPОтвет, ЗаголовокОшибки, ТекстОшибки)
	
	// 200 ОК
	Если HTTPОтвет.КодСостояния = 200 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокОшибки = РасшифровкаОшибкиItoolabs(HTTPОтвет.КодСостояния);
	ТекстОшибки = РаскодироватьСтроку(HTTPОтвет.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	
КонецПроцедуры

Процедура ПриПолученииАдресаОбратногоВызоваItoolabs(ШаблонСтрокиПодключения, ПараметрыПодключения, АдресОбратногоВызова)
	
	
	
КонецПроцедуры

Функция КорневойАдресItoolabs()
	
	Возврат ТелефонияСервер.ПолучитьНастройкиТелефонии().АдресОблачнойАТС;
	
КонецФункции

Функция ШаблонURLHTTPСервисаItoolabs()
	
	Возврат "itoolabs";
	
КонецФункции

Функция КорректнаяПодписьЗапросаItoolabs(АТС, ПодписьЗапроса, ПараметрыЗапроса = Неопределено)
	
	КлючДляАвторизации = ТелефонияСервер.ПолучитьНастройкиТелефонии().КлючДляАвторизацииВУНФ;
	Возврат ПодписьЗапроса = КлючДляАвторизации;
	
КонецФункции

Функция НастройкиИнтеграцииЗаполненыItoolabs(АТС, НастройкиТелефонии)
	
	Возврат ЗначениеЗаполнено(НастройкиТелефонии.АдресОблачнойАТС)
		И ЗначениеЗаполнено(НастройкиТелефонии.КлючДляАвторизацииВОблачнойАТС)
		И ЗначениеЗаполнено(НастройкиТелефонии.КлючДляАвторизацииВУНФ);
	
КонецФункции

Функция СсылкаНаЗаписьРазговораItoolabs(ДанныеЗвонка, Ошибка)
	
	Возврат ДанныеЗвонка.ЗаписьРазговора.Ссылка;
	
КонецФункции

#Область СлужебныеПроцедурыИФункцииItoolabs

Функция РасшифровкаОшибкиItoolabs(Код)
	
	Если Код = 400 Тогда
		Возврат НСтр("ru='Переданы некорректные параметры'");
	ИначеЕсли Код = 401 Тогда
		Возврат НСтр("ru='Передан неверный ключ (token)'");
	Иначе
		Возврат НСтр("ru='Неизвестная ошибка'");
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Яндекс

Процедура ПриСозданииИсходящегоВызоваЯндекс(НомерАбонента, ДанныеПользователяАТС, НастройкиТелефонии, URL, ТелоЗапроса, Заголовки, Ошибка)
	
	Если НЕ ЗначениеЗаполнено(ДанныеПользователяАТС.ИсходящийНомер) Тогда
		Ошибка = "НеЗаполненНомерИсходящегоЗвонкаПользователя";
		Возврат;
	КонецЕсли;
	
	Токен = ТокенДоступаAPI(ДанныеПользователяАТС.ВнутреннийНомер, Ошибка);
	
	Если Ошибка <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Токен = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не удалось авторизоваться.'");
	КонецЕсли;
	
	URL = URL + "api/v2/calls/makecall";
	
	Заголовки.Вставить("Authorization", "bearer " + Токен);
	Заголовки.Вставить("x-api-key", ТелефонияСервер.ПолучитьНастройкиТелефонии().КлючДляАвторизацииАТСЯндекс);
	
	Если НЕ СтрНачинаетсяС(НомерАбонента, "+") Тогда
		НомерАбонента = "+" + НомерАбонента;
	КонецЕсли;
	НомерАбонента = КодироватьСтроку(НомерАбонента, СпособКодированияСтроки.КодировкаURL);
	
	БизнесНомер = КонтактнаяИнформацияУНФ.ПреобразоватьНомерДляКонтактнойИнформации(ДанныеПользователяАТС.ИсходящийНомер);
	Если НЕ СтрНачинаетсяС(БизнесНомер, "+") Тогда
		БизнесНомер = "+" + БизнесНомер;
	КонецЕсли;
	БизнесНомер = КодироватьСтроку(БизнесНомер, СпособКодированияСтроки.КодировкаURL);
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить("from=" + БизнесНомер);
	ПараметрыЗапроса.Добавить("to=" + НомерАбонента);
	
	ТелоЗапроса = СтрСоединить(ПараметрыЗапроса, "&");
	
КонецПроцедуры

Процедура ПриОбработкеПолученияИнформацииОВызывающемАбонентеЯндекс(ДанныеАбонента, Ответ)
	
КонецПроцедуры

Процедура ПриОбработкеОтветаНаСозданиеИсходящегоВызоваЯндекс(HTTPОтвет, ЗаголовокОшибки, ТекстОшибки)
	
	
	
КонецПроцедуры

Процедура ПриПолученииАдресаОбратногоВызоваЯндекс(ШаблонСтрокиПодключения, ПараметрыПодключения, АдресОбратногоВызова)
	
	
	
КонецПроцедуры

Функция КорневойАдресЯндекс()
	
	Возврат "https://api.yandex.mightycall.ru/";
	
КонецФункции

Функция ШаблонURLHTTPСервисаЯндекс()
	
	Возврат "yandex";
	
КонецФункции

Функция КорректнаяПодписьЗапросаЯндекс(АТС, ПодписьЗапроса, ПараметрыЗапроса = Неопределено)
	
	КлючДляАвторизации = ТелефонияСервер.ПолучитьНастройкиТелефонии().КлючДляАвторизацииАТСЯндекс;
	Возврат ПодписьЗапроса = КлючДляАвторизации;
	
КонецФункции

Функция НастройкиИнтеграцииЗаполненыЯндекс(АТС, НастройкиТелефонии)
	
	Возврат ЗначениеЗаполнено(НастройкиТелефонии.КлючДляАвторизацииАТСЯндекс);
	
КонецФункции

Функция СсылкаНаЗаписьРазговораЯндекс(ДанныеЗвонка, Ошибка)
	
	Токен = ТокенДоступаAPI(ТелефонияСервер.ВнутреннийНомерПользователя(), Ошибка);
	
	Если Ошибка <> Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Токен = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не удалось авторизоваться.'");
	КонецЕсли;
	
	URL = ТелефонияСервер.КорневойАдресАТС() + "api/v2/calls/" + ДанныеЗвонка.ИдентификаторЗвонкаВАТС;
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	
	HTTPЗапрос = Новый HTTPЗапрос();
	HTTPЗапрос.АдресРесурса = СтруктураURI.ПутьНаСервере;
	HTTPЗапрос.Заголовки.Вставить("Content-Type", "application/json");
	HTTPЗапрос.Заголовки.Вставить("Authorization", "bearer " + Токен);
	HTTPЗапрос.Заголовки.Вставить("x-api-key", ТелефонияСервер.ПолучитьНастройкиТелефонии().КлючДляАвторизацииАТСЯндекс);
	
	Прокси = ПолучениеФайловИзИнтернета.ПолучитьПрокси(СтруктураURI.Схема);
	HTTPСоединение = Новый HTTPСоединение(СтруктураURI.Хост, СтруктураURI.Порт,,, Прокси, 20, Новый ЗащищенноеСоединениеOpenSSL);
	
	HTTPОтвет = HTTPСоединение.ВызватьHTTPМетод("GET", HTTPЗапрос);
	
	// todo если запрос неуспешно то отвал
	
	Если HTTPОтвет.КодСостояния <> 200 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТелоЗапроса = РаскодироватьСтроку(HTTPОтвет.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТелоЗапроса);
	МассивИмен = Новый Массив;
	ПараметрыЗапроса = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	ДанныеЗаписи = ПараметрыЗапроса.data.callRecord;
	
	СсылкаНаЗапись = ?(ДанныеЗаписи = Неопределено, Неопределено, ДанныеЗаписи.Uri);
	
	ДанныеЗвонка.ЗаписьРазговора.Ссылка = СсылкаНаЗапись;
	ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
	
	Возврат СсылкаНаЗапись;
	
КонецФункции

#Область СлужебныеПроцедурыИФункцииЯндекс

Функция ТокенДоступаAPI(ВнутреннийНомер, Ошибка)
	
	Токен = АктуальныйТокенДоступаAPI(ВнутреннийНомер);
	
	Если Токен = Неопределено Тогда
		Токен = НовыйТокенДоступаAPI(ВнутреннийНомер, Ошибка);
	КонецЕсли;
	
	Возврат Токен;
	
КонецФункции

Функция АктуальныйТокенДоступаAPI(ВнутреннийНомер)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ТокеныДоступаAPIТелефонии.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ВнутреннийНомерСотрудника = ВнутреннийНомер;
	МенеджерЗаписи.Прочитать();
	
	Если НЕ ЗначениеЗаполнено(МенеджерЗаписи.Токен) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если МенеджерЗаписи.СрокДействия < ТекущаяДатаСеанса() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат МенеджерЗаписи.Токен;
	
КонецФункции

Функция НовыйТокенДоступаAPI(ВнутреннийНомер, Ошибка)
	
	ДанныеАвторизации = ЗапроситьТокенДоступа(ВнутреннийНомер, Ошибка);
	
	Если ЗначениеЗаполнено(Ошибка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ДанныеАвторизации = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЗаписатьТокенДоступа(
		ВнутреннийНомер,
		ДанныеАвторизации.access_token,
		ТекущаяДатаСеанса() + ДанныеАвторизации.expires_in);
	
	Возврат ДанныеАвторизации.access_token;
	
КонецФункции

Функция ЗапроситьТокенДоступа(ВнутреннийНомер, Ошибка)
	
	api_key = ТелефонияСервер.ПолучитьНастройкиТелефонии().КлючДляАвторизацииАТСЯндекс;
	
	URL = ТелефонияСервер.КорневойАдресАТС() + "api/v2/auth/token";
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить("grant_type=client_credentials");
	ПараметрыЗапроса.Добавить("client_id=" + api_key);
	ПараметрыЗапроса.Добавить("client_secret=" + ВнутреннийНомер);
	
	HTTPЗапрос = Новый HTTPЗапрос();
	HTTPЗапрос.АдресРесурса = СтруктураURI.ПутьНаСервере;
	HTTPЗапрос.Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	HTTPЗапрос.Заголовки.Вставить("x-api-key", api_key);
	HTTPЗапрос.УстановитьТелоИзСтроки(СтрСоединить(ПараметрыЗапроса, "&"),
		КодировкаТекста.UTF8,
		ИспользованиеByteOrderMark.НеИспользовать);
	
	Прокси = ПолучениеФайловИзИнтернета.ПолучитьПрокси(СтруктураURI.Схема);
	HTTPСоединение = Новый HTTPСоединение(СтруктураURI.Хост, СтруктураURI.Порт,,, Прокси, 20, Новый ЗащищенноеСоединениеOpenSSL);
	HTTPОтвет = HTTPСоединение.ВызватьHTTPМетод("POST", HTTPЗапрос);
	
	Если HTTPОтвет.КодСостояния <> 200 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТелоЗапроса = РаскодироватьСтроку(HTTPОтвет.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТелоЗапроса);
	ПараметрыЗапроса = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	Если ПараметрыЗапроса.Свойство("error") И ПараметрыЗапроса.error = "invalid_client" Тогда
		Ошибка = "НекорректныйВнутреннийНомерПользователя";
	КонецЕсли;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗаписатьТокенДоступа(ВнутреннийНомер, Токен, СрокДействия)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ТокеныДоступаAPIТелефонии.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ВнутреннийНомерСотрудника = ВнутреннийНомер;
	МенеджерЗаписи.Токен = Токен;
	МенеджерЗаписи.СрокДействия = СрокДействия;
	МенеджерЗаписи.Записать();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Ростелеком

Процедура ПриСозданииИсходящегоВызоваРостелеком(НомерАбонента, ДанныеПользователяАТС, НастройкиТелефонии, URL, ТелоЗапроса, Заголовки, Ошибка)
	
	URL = URL + "call_back";
	
	ИсходящиеПараметры = Новый Структура;
	ИсходящиеПараметры.Вставить("request_number", НомерАбонента);
	ИсходящиеПараметры.Вставить("from_pin", ДанныеПользователяАТС.ВнутреннийНомер);
	
	ТелоЗапроса = ТелефонияСервер.СоздатьJSONИзСтруктуры(ИсходящиеПараметры, ПереносСтрокJSON.Нет);
	
	Подпись = НастройкиТелефонии.УникальныйКодИдентификации + ТелоЗапроса + НастройкиТелефонии.УникальныйКлючДляПодписи;
	Подпись = НовыйХешСумма(Подпись);
	
	Заголовки.Вставить("X-Client-ID",   НастройкиТелефонии.УникальныйКодИдентификации);
	Заголовки.Вставить("X-Client-Sign", Подпись);
	
КонецПроцедуры

Процедура ПриОбработкеПолученияИнформацииОВызывающемАбонентеРостелеком(ДанныеАбонента, Ответ)
	
#Если НЕ ВнешнееСоединение Тогда
	ПараметрыОтвета = Новый Структура;
	ПараметрыОтвета.Вставить("result", 0);
	ПараметрыОтвета.Вставить("resultMessage", НСтр("ru='Операция выполнена успешно'", ОбщегоНазначения.КодОсновногоЯзыка()));
	ПараметрыОтвета.Вставить("displayName", "");
	ПараметрыОтвета.Вставить("PIN", "");
	
	Если ДанныеАбонента = Неопределено Тогда
		ПараметрыОтвета.result = 1;
		ПараметрыОтвета.resultMessage = НСтр("ru='Не найдены данные абонента'", ОбщегоНазначения.КодОсновногоЯзыка());
	Иначе
		ПараметрыОтвета.displayName = ДанныеАбонента.Представление;
		Если ДанныеАбонента.МаршрутизироватьВызовНаОтветственного Тогда
			ПараметрыОтвета.PIN = Строка(ДанныеАбонента.ВнутреннийНомерОтветственного);
		КонецЕсли;
	КонецЕсли;
	
	ТелоОтвета = ТелефонияСервер.СоздатьJSONИзСтруктуры(ПараметрыОтвета, ПереносСтрокJSON.Нет);
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type",   "application/json; charset=utf-8");
	Ответ.УстановитьТелоИзСтроки(ТелоОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	ПодписатьЗапросРостелеком(Ответ);
	
	ЗаписатьЗапросВЖурналРегистрации(
		"/get_number_info.Ответ",
		ПредставлениеСоответствияСтрокой(Ответ.Заголовки) + Символы.ПС + ТелоОтвета);
#КонецЕсли
	
КонецПроцедуры

Процедура ПриОбработкеОтветаНаСозданиеИсходящегоВызоваРостелеком(HTTPОтвет, ЗаголовокОшибки, ТекстОшибки)
	
	
	
КонецПроцедуры

Процедура ПриПолученииАдресаОбратногоВызоваРостелеком(ШаблонСтрокиПодключения, ПараметрыПодключения, АдресОбратногоВызова)
	
	АдресОбратногоВызова = URLБезПротокола(АдресОбратногоВызова);
	
КонецПроцедуры

Функция КорневойАдресРостелеком()
	
	Возврат "https://api.cloudpbx.rt.ru/";
	
КонецФункции

Функция ШаблонURLHTTPСервисаРостелеком()
	
	Возврат "rt";
	
КонецФункции

Функция КорректнаяПодписьЗапросаРостелеком(АТС, ПодписьЗапроса, ПараметрыЗапроса = Неопределено)
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	ПараметрыПодписи = НастройкиТелефонии.УникальныйКодИдентификации + ПараметрыЗапроса + НастройкиТелефонии.УникальныйКлючДляПодписи;
	Возврат ПодписьЗапроса = НовыйХешСумма(ПараметрыПодписи);
	
КонецФункции

Функция НастройкиИнтеграцииЗаполненыРостелеком(АТС, НастройкиТелефонии)
	
	Возврат ЗначениеЗаполнено(НастройкиТелефонии.УникальныйКодИдентификации)
		И ЗначениеЗаполнено(НастройкиТелефонии.УникальныйКлючДляПодписи);
	
КонецФункции

Функция СсылкаНаЗаписьРазговораРостелеком(ДанныеЗвонка, Ошибка)
	
	URL = ТелефонияСервер.КорневойАдресАТС() + "get_record";
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("session_id", ДанныеЗвонка.ИдентификаторЗвонкаВАТС);
	ПараметрыЗапроса.Вставить("ip_adress", "");
	
	ТелоЗапроса = ТелефонияСервер.СоздатьJSONИзСтруктуры(ПараметрыЗапроса, ПереносСтрокJSON.Нет);
	
	HTTPЗапрос = Новый HTTPЗапрос();
	HTTPЗапрос.АдресРесурса = СтруктураURI.ПутьНаСервере;
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	ПодписатьЗапросРостелеком(HTTPЗапрос);
	
	Прокси = ПолучениеФайловИзИнтернета.ПолучитьПрокси(СтруктураURI.Схема);
	HTTPСоединение = Новый HTTPСоединение(СтруктураURI.Хост, СтруктураURI.Порт,,, Прокси, 20, Новый ЗащищенноеСоединениеOpenSSL);
	
	HTTPОтвет = HTTPСоединение.ВызватьHTTPМетод("POST", HTTPЗапрос);
	
	// todo если запрос неуспешно то отвал
	
	Если HTTPОтвет.КодСостояния <> 200 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТелоОтвета = РаскодироватьСтроку(HTTPОтвет.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	ПараметрыОтвета = ТелефонияСервер.ПрочитатьJSONВСтруктуру(ТелоОтвета);
	
	Результат = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(ПараметрыОтвета.URL,, Истина);
	
	Расширение = "mp3";
	ИмяФайла = СтрШаблон(
		НСтр("ru='Звонок %1 от %2.%3'"),
		?(ЗначениеЗаполнено(ДанныеЗвонка.Контакт.Ссылка), ДанныеЗвонка.Контакт.Ссылка, ДанныеЗвонка.НомерКонтакта),
		ДанныеЗвонка.ДатаНачалаЗвонка,
		Расширение);
	
	ДанныеФайла = Новый Структура;
	ДанныеФайла.Вставить("ИмяФайла", ИмяФайла);
	ДанныеФайла.Вставить("СсылкаНаДвоичныеДанныеФайла", Результат.Путь);
	ДанныеФайла.Вставить("Расширение", Расширение);
	
	Возврат ДанныеФайла;
	
КонецФункции

#Область СлужебныеПроцедурыИФункцииРостелеком

Процедура ПодписатьЗапросРостелеком(Запрос, НастройкиТелефонии = Неопределено)
	
	Если НастройкиТелефонии = Неопределено Тогда
		НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	КонецЕсли;
	
	ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку();
	
	Если ТелоЗапроса = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не установлено тело запроса.'");
	КонецЕсли;
	
	Подпись = НастройкиТелефонии.УникальныйКодИдентификации + ТелоЗапроса + НастройкиТелефонии.УникальныйКлючДляПодписи;
	Подпись = НовыйХешСумма(Подпись);
	
	Запрос.Заголовки.Вставить("X-Client-ID",   НастройкиТелефонии.УникальныйКодИдентификации);
	Запрос.Заголовки.Вставить("X-Client-Sign", Подпись);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстОшибкиРеализацияНеОпределена(АТС, ИмяМетода)
	
	Возврат СтрШаблон(НСтр("ru='Не заполнена реализация метода ""%1"" для АТС ""%2""'"), ИмяМетода, АТС);
	
КонецФункции

Функция КодировкаURL(Строка)
	
	Возврат КодироватьСтроку(Строка, СпособКодированияСтроки.КодировкаURL);
	
КонецФункции

Функция НастройкиИнтеграцииЗаполнены(АТС, НастройкиТелефонии)
	
	Если АТС = Перечисления.ДоступныеАТС.MangoOffice Тогда
		
		Возврат НастройкиИнтеграцииЗаполненыMangoOffice(АТС, НастройкиТелефонии);
		
	ИначеЕсли ЭтоПлатформаItoolabs(АТС) Тогда
		
		Возврат НастройкиИнтеграцииЗаполненыItoolabs(АТС, НастройкиТелефонии);
		
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Яндекс Тогда
		
		Возврат НастройкиИнтеграцииЗаполненыЯндекс(АТС, НастройкиТелефонии);
		
	ИначеЕсли АТС = Перечисления.ДоступныеАТС.Ростелеком Тогда
		
		Возврат НастройкиИнтеграцииЗаполненыРостелеком(АТС, НастройкиТелефонии);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru='Не заполнена реализация метода ""НастройкиИнтеграцииЗаполнены"" для АТС ""%1""'"),
			АТС);
		
	КонецЕсли;
	
КонецФункции

Функция НовыйХешСумма(ПараметрыПодписи)
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA256);
	ХешированиеДанных.Добавить(ПараметрыПодписи);
	
	Возврат НРег(СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", ""));
	
КонецФункции

Функция ЭтоПлатформаItoolabs(АТС)
	
	АТСНаПлатформеItoolabs = Новый Массив;
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.УниверсальныйItoolabs);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.ДомRu);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.ВестКоллСПб);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.ДеловаяСетьИркутск);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.Энфорта);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.Мегафон);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.ТТК);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.ВестКоллМосква);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.VirginConnect);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.ГарсТелеком);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.НаукаСвязь);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.RiNet);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.СибирскиеСети);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.Авантел);
	АТСНаПлатформеItoolabs.Добавить(Перечисления.ДоступныеАТС.Гравител);
	
	Возврат АТСНаПлатформеItoolabs.Найти(АТС) <> Неопределено;
	
КонецФункции

Функция URLБезПротокола(URL)
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	Протокол = СтруктураURI.Схема + "://";
	Возврат Прав(URL, СтрДлина(URL) - СтрДлина(Протокол));
	
КонецФункции

Функция ПредставлениеСоответствияСтрокой(Соответствие)
	
	Строка = "";
	Для Каждого КлючИЗначение Из Соответствие Цикл
		Если ЗначениеЗаполнено(Строка) Тогда
			Строка = Строка + Символы.ПС;
		КонецЕсли;
		Строка = Строка + КлючИЗначение.Ключ + ":" + КлючИЗначение.Значение;
	КонецЦикла;
	
	Возврат Строка;
	
КонецФункции

#КонецОбласти
