
#Область ПрограммныйИнтерфейс

// Процедура добавляет вложения-картинки из форматированного документа для отправки по электронной почте
//
// Параметры:
//  ТекстHTML		 - Строка		 - исходный текст HTML электронного письма. Параметр изменяется в процедуре.
//  ВложенияПисьма	 - Соответствие	 - см.комментарий к РаботаСПочтовымиСообщениямиСлужебный.ОтправитьСообщение(). Параметр изменяется в процедуре.
//  ВложенияКартинки - Структура	 - см.синтакс-помощник ФорматированныйДокумент.ПолучитьHTML() параметр Вложения
Процедура ДобавитьВложенияКартинкиВПисьмо(ТекстHTML, ВложенияПисьма, знач ВложенияКартинки) Экспорт
	
	СоответствиеИмениКартинкиИдентификатору = Новый Соответствие;
	
	Для Каждого КлючИЗначение Из ВложенияКартинки Цикл
		
		ИДКартинки = Новый УникальныйИдентификатор;
		СоответствиеИмениКартинкиИдентификатору.Вставить(КлючИЗначение.Ключ, ИДКартинки);
		
		ОписаниеВложения = Новый Структура("ДвоичныеДанные, Идентификатор");
		ОписаниеВложения.ДвоичныеДанные = КлючИЗначение.Значение.ПолучитьДвоичныеДанные();
		ОписаниеВложения.Идентификатор = ИДКартинки;
		ВложенияПисьма.Вставить(КлючИЗначение.Ключ, ОписаниеВложения);
		
	КонецЦикла;
	
	ДокументHTML = ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекстHTML);
	
	Для Каждого Картинка Из ДокументHTML.Картинки Цикл
		
		АтрибутИсточникКартинки = Картинка.Атрибуты.ПолучитьИменованныйЭлемент("src");
		
		НовыйАтрибутКартинки = АтрибутИсточникКартинки.КлонироватьУзел(Ложь);
		НовыйАтрибутКартинки.ТекстовоеСодержимое = "cid:" + СоответствиеИмениКартинкиИдентификатору.Получить(АтрибутИсточникКартинки.ТекстовоеСодержимое);
		Картинка.Атрибуты.УстановитьИменованныйЭлемент(НовыйАтрибутКартинки);
		
	КонецЦикла;
	
	ТекстHTML = ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
	
КонецПроцедуры

// Функция получает объект - документ HTML из текста HTML
//
// Параметры:
//  ТекстHTML	 - Строка	 - текст HTML
//  Кодировка	 - Строка	 - Указывает кодировку, которая будет использована в механизме разбора HTML для преобразования.
// Возвращаемое значение:
//  ДокументHTML - объект
Функция ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекстHTML, Кодировка = Неопределено) Экспорт
	
	Построитель = Новый ПостроительDOM;
	ЧтениеHTML = Новый ЧтениеHTML;
	
	НовыйТекстHTML = ТекстHTML;
	ПозицияОткрытиеXML = СтрНайти(НовыйТекстHTML,"<?xml");
	
	Если ПозицияОткрытиеXML > 0 Тогда
		
		ПозицияЗакрытиеXML = СтрНайти(НовыйТекстHTML,"?>");
		Если ПозицияЗакрытиеXML > 0 Тогда
			НовыйТекстHTML = Лев(НовыйТекстHTML, ПозицияОткрытиеXML - 1) + Прав(НовыйТекстHTML, СтрДлина(НовыйТекстHTML) - ПозицияЗакрытиеXML -1);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Кодировка = Неопределено Тогда
		ЧтениеHTML.УстановитьСтроку(ТекстHTML);
	Иначе
		ЧтениеHTML.УстановитьСтроку(ТекстHTML, Кодировка);
	КонецЕсли;
	
	Возврат Построитель.Прочитать(ЧтениеHTML);
	
КонецФункции

// Функция получает текст HTML из объекта ДокументHTML
//
// Параметры:
//  ДокументHTML	 - ДокументHTML	 - документ, из которого будет извлекаться текст
// Возвращаемое значение:
//  Строка - текст HTML
Функция ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML) Экспорт
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьHTML = Новый ЗаписьHTML;
	ЗаписьHTML.УстановитьСтроку();
	ЗаписьDOM.Записать(ДокументHTML,ЗаписьHTML);
	
	Возврат ЗаписьHTML.Закрыть();
	
КонецФункции

// Функция получает текст HTML из объекта ДокументHTML
//
// Параметры:
//  ДокументHTML	 - ДокументHTML	 - документ, из которого будет извлекаться текст
// Возвращаемое значение:
//  Строка - текст HTML
Функция ПолучитьТекстИзHTML(ТекстHTML) Экспорт
	
	ФД = Новый ФорматированныйДокумент;
	ФД.УстановитьHTML(ТекстHTML, Новый Структура);
	
	Возврат ФД.ПолучитьТекст();
	
КонецФункции

// Функция сопоставляет статус доставки SMS, полученный от провайдера, с соответствующим перечислением
//
// Параметры:
//  СтатусДоставкиСтрокой	 - Строка	 - статус, полученный от провайдера
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияСообщенияSMS - результат сопоставления
Функция СопоставитьСтатусДоставкиSMS(СтатусДоставкиСтрокой) Экспорт
	
	СоответствиеСтатусов = Новый Соответствие;
	СоответствиеСтатусов.Вставить("",				Перечисления.СостоянияСообщенияSMS.Исходящее);
	СоответствиеСтатусов.Вставить("НеОтправлялось", Перечисления.СостоянияСообщенияSMS.Исходящее);
	СоответствиеСтатусов.Вставить("Отправляется",	Перечисления.СостоянияСообщенияSMS.ОтправляетсяПровайдером);
	СоответствиеСтатусов.Вставить("Отправлено",		Перечисления.СостоянияСообщенияSMS.ОтправленоПровайдером);
	СоответствиеСтатусов.Вставить("НеОтправлено",	Перечисления.СостоянияСообщенияSMS.НеОтправленоПровайдером);
	СоответствиеСтатусов.Вставить("Доставлено",		Перечисления.СостоянияСообщенияSMS.Доставлено);
	СоответствиеСтатусов.Вставить("НеДоставлено",	Перечисления.СостоянияСообщенияSMS.НеДоставлено);
	
	Результат = СоответствиеСтатусов[СтатусДоставкиСтрокой];
	Возврат ?(Результат = Неопределено, Перечисления.СостоянияСообщенияSMS.ОшибкаПолученияСтатусаУПровайдера, Результат);
	
КонецФункции

Функция ПолучитьАдресПолучателяСкрытойКопии(ИмяПользователя = Неопределено) Экспорт
	
	АдресПолучателяСкрытойКопии = "";
	
	ОтправлятьСлепыеКопииПисем = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ПараметрыОтправкиСкрытыхКопий",
		"ОтправлятьСлепыеКопииПисем",
		Ложь,
		,
		ИмяПользователя
	);
	
	Если ОтправлятьСлепыеКопииПисем Тогда
		АдресПолучателяСкрытойКопии = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ПараметрыОтправкиСкрытыхКопий",
			"АдресПолучателяСкрытойКопии",
			"",
			,
			ИмяПользователя
		);
	КонецЕсли;
	
	Возврат АдресПолучателяСкрытойКопии;
	
КонецФункции

#КонецОбласти