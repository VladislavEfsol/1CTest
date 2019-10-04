
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураПараметров = ПолучитьСтруктуруДляПередачиВФормуПросмотра(Параметры.ДанныеСтроки);
	ПечатнаяФорма.Вывести(ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресХранилища));
	ЭтотОбъект.Заголовок = СтруктураПараметров.Заголовок;
	ТекстФайла = СтруктураПараметров.ТекстДокумента;
	
	РасскрашенныйТекст = КлиентБанкФорматированиеФайла.ОтформатироватьИсходныйФайл(ТекстФайла);
	
	ЗагрузитьНастройку();
	Элементы.ФорматированныйВид.Пометка = НачальноеПредставлениеФорматировано;
	
	УстановитьПредставление();
	
	Если СтруктураПараметров.Свойство("ИмяСтраницы") Тогда
		Попытка
			Элементы.Страницы.ТекущаяСтраница = Элементы[СтруктураПараметров.ИмяСтраницы];
		Исключение
			//
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматированныйВид(Команда)
	Элементы.ФорматированныйВид.Пометка = НЕ Элементы.ФорматированныйВид.Пометка;
	УстановитьПредставление();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		СохранитьНастройкуНаСервере(Элементы.ФорматированныйВид.Пометка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставление()
	
	Элементы.РасскрашенныйТекст.Видимость = Элементы.ФорматированныйВид.Пометка;
	Элементы.НеРасскрашенныйТекст.Видимость = НЕ Элементы.ФорматированныйВид.Пометка;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкуНаСервере(ЗначениеНастройки)
	
	ХранилищеОбщихНастроек.Сохранить("ОбменСКлиентомБанка", "ПоказыватьФорматированно", ЗначениеНастройки);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройку()
	
	ПредНачальноеПредставлениеФорматировано = ХранилищеОбщихНастроек.Загрузить("ОбменСКлиентомБанка", "ПоказыватьФорматированно");
	Если НЕ ПредНачальноеПредставлениеФорматировано = Неопределено Тогда
		НачальноеПредставлениеФорматировано = ПредНачальноеПредставлениеФорматировано;
	Иначе
		НачальноеПредставлениеФорматировано = Истина;
	КонецЕсли;
	
КонецПроцедуры // ЗагрузитьНастройкиФормы()

&НаСервере
Функция ПолучитьСтруктуруДляПередачиВФормуПросмотра(ТекущаяСтрока)
	
	ИмяСтраницы = "ПечатнаяФормаПлатежа";
	ЗаголовокОкнаПросмотра = ""+ТекущаяСтрока.Операция+" №"+ТекущаяСтрока.НомерДок+" от "+Формат(ТекущаяСтрока.ДатаДок, "ДФ=dd.MM.yyyy");
	
	ПрямыеРасчеты = ПустаяСтрока(ТекущаяСтрока.ПОЛУЧАТЕЛЬ2) И ПустаяСтрока(ТекущаяСтрока.ПЛАТЕЛЬЩИК2);
	
	Если ВРег(СокрЛП(ТекущаяСтрока.Операция)) = ВРег("Платежное поручение") И ПрямыеРасчеты Тогда
		
		ПечФорма = ПосмотретьВОтдельномОкнеПлатежноеПоручениеНаСервере(ТекущаяСтрока);
		
	ИначеЕсли ВРег(СокрЛП(ТекущаяСтрока.Операция)) = ВРег("Платежное поручение") И НЕ ПрямыеРасчеты Тогда
		
		ПечФорма = ПосмотретьВОтдельномОкнеПлатежноеПоручениеНеПрямыеРасчетыНаСервере(ТекущаяСтрока);
		
	ИначеЕсли ВРег(СокрЛП(ТекущаяСтрока.Операция)) = ВРег("Банковский ордер") Тогда
		
		ПечФорма = ПосмотретьВОтдельномОкнеБанковскийОрдерНаСервере(ТекущаяСтрока);
		
	ИначеЕсли ВРег(СокрЛП(ТекущаяСтрока.Операция)) = ВРег("Платежное требование") Тогда
		
		ПечФорма = ПосмотретьВОтдельномОкнеПлатежноеТребованиеНаСервере(ТекущаяСтрока);
		
	ИначеЕсли ВРег(СокрЛП(ТекущаяСтрока.Операция)) = ВРег("Инкассовое поручение") Тогда
		
		ПечФорма = ПосмотретьВОтдельномОкнеИнкассовоеПоручениеНаСервере(ТекущаяСтрока);
		
	ИначеЕсли ВРег(СокрЛП(ТекущаяСтрока.Операция)) = ВРег("Аккредитив") ИЛИ
		ВРег(СокрЛП(ТекущаяСтрока.Операция)) = ВРег("Заявление на аккредитив") Тогда
		
		ПечФорма = ПосмотретьВОтдельномОкнеАккредитивНаСервере(ТекущаяСтрока);
		
	Иначе
		
		ПечФорма = ПосмотретьВОтдельномОкнеОперациюНаСервере(ТекущаяСтрока);
		ИмяСтраницы = "ТекстИзФайлаВыписки";
		
	КонецЕсли;
	
	АдресХранилища = ПоместитьВоВременноеХранилище(ПечФорма, УникальныйИдентификатор);
	ТекстДокумента = ТекущаяСтрока.ТекстДокумента;
	
	Возврат Новый Структура("Заголовок, АдресХранилища, ТекстДокумента, ИмяСтраницы", 
		ЗаголовокОкнаПросмотра,
		АдресХранилища,
		ТекстДокумента,
		ИмяСтраницы);
	
КонецФункции

&НаСервере
Функция ПосмотретьВОтдельномОкнеПлатежноеПоручениеНаСервере(ТекущаяСтрока)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПлатежноеПоручение";
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПлатежноеПоручение_ПлатежноеПоручение";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.КлиентБанк.ПФ_MXL_ПлатежноеПоручение");
	
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
	ОбластьМакета.Параметры.СуммаПрописью = УправлениеНебольшойФирмойСервер.ФорматироватьСуммуПрописьюПлатежногоДокумента(
			ТекущаяСтрока.СуммаДокумента,
			ТекущаяСтрока.БанковскийСчетВалюта,
		);
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Плательщик) Тогда
		ОбластьМакета.Параметры.Плательщик = ТекущаяСтрока.Плательщик1;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Получатель) Тогда
		ОбластьМакета.Параметры.Получатель = ТекущаяСтрока.Получатель1;
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ИмяОбласти = "ЗаголовокТаблицы";
	
	НомерСтрокиОкончание = ТабличныйДокумент.ВысотаТаблицы;
	ТабличныйДокумент.Область(НомерСтрокиНачало, , НомерСтрокиОкончание, ).Имя = ИмяОбласти;

	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаСервере
Функция ПосмотретьВОтдельномОкнеПлатежноеПоручениеНеПрямыеРасчетыНаСервере(ТекущаяСтрока)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПлатежноеПоручение";
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПлатежноеПоручение_ПлатежноеПоручение";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.КлиентБанк.ПФ_MXL_ПлатежноеПоручениеНеПрямыеРасчеты");
	
	// Шапка.
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
	ОбластьМакета.Параметры.СуммаПрописью = УправлениеНебольшойФирмойСервер.ФорматироватьСуммуПрописьюПлатежногоДокумента(
			ТекущаяСтрока.СуммаДокумента,
			ТекущаяСтрока.БанковскийСчетВалюта,
		);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	// Плательщик.
	Если ПустаяСтрока(ТекущаяСтрока.ПЛАТЕЛЬЩИК2) Тогда
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПлательщикПрямые");
		ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
		
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.Плательщик) Тогда
			ОбластьМакета.Параметры.Плательщик = ТекущаяСтрока.Плательщик1;
		КонецЕсли;
		
	Иначе
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПлательщикНеПрямые");
		ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
		
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	// Получатель.
	Если ПустаяСтрока(ТекущаяСтрока.ПОЛУЧАТЕЛЬ2) Тогда
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПолучательПрямые");
		ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
		
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.Получатель) Тогда
			ОбластьМакета.Параметры.Получатель = ТекущаяСтрока.Получатель1;
		КонецЕсли;
		
	Иначе
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПолучательНеПрямые");
		ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
		
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	// Подвал.
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
	ТабличныйДокумент.Вывести(ОбластьМакета);

	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаСервере
Функция ПосмотретьВОтдельномОкнеБанковскийОрдерНаСервере(ТекущаяСтрока)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПлатежноеПоручение";
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПлатежноеПоручение_БанковскийОрдер";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.КлиентБанк.ПФ_MXL_БанковскийОрдер");
	
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
	ОбластьМакета.Параметры.СуммаПрописью = УправлениеНебольшойФирмойСервер.ФорматироватьСуммуПрописьюПлатежногоДокумента(
			ТекущаяСтрока.СуммаДокумента,
			ТекущаяСтрока.БанковскийСчетВалюта,
		);
		
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Плательщик) Тогда
		ОбластьМакета.Параметры.Плательщик = ТекущаяСтрока.Плательщик1;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Получатель) Тогда
		ОбластьМакета.Параметры.Получатель = ТекущаяСтрока.Получатель1;
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ИмяОбласти = "ЗаголовокТаблицы";
	
	НомерСтрокиОкончание = ТабличныйДокумент.ВысотаТаблицы;
	ТабличныйДокумент.Область(НомерСтрокиНачало, , НомерСтрокиОкончание, ).Имя = ИмяОбласти;

	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаСервере
Функция ПосмотретьВОтдельномОкнеПлатежноеТребованиеНаСервере(ТекущаяСтрока)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПлатежноеПоручение";
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПлатежноеПоручение_ПлатежноеТребование";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.КлиентБанк.ПФ_MXL_ПлатежноеТребование");
	
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
	ОбластьМакета.Параметры.СуммаПрописью = УправлениеНебольшойФирмойСервер.ФорматироватьСуммуПрописьюПлатежногоДокумента(
			ТекущаяСтрока.СуммаДокумента,
			ТекущаяСтрока.БанковскийСчетВалюта,
		);
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Плательщик) Тогда
		ОбластьМакета.Параметры.Плательщик = ТекущаяСтрока.Плательщик1;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Получатель) Тогда
		ОбластьМакета.Параметры.Получатель = ТекущаяСтрока.Получатель1;
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ИмяОбласти = "ЗаголовокТаблицы";
	
	НомерСтрокиОкончание = ТабличныйДокумент.ВысотаТаблицы;
	ТабличныйДокумент.Область(НомерСтрокиНачало, , НомерСтрокиОкончание, ).Имя = ИмяОбласти;

	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаСервере
Функция ПосмотретьВОтдельномОкнеИнкассовоеПоручениеНаСервере(ТекущаяСтрока)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПлатежноеПоручение";
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПлатежноеПоручение_ИнкассовоеПоручение";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.КлиентБанк.ПФ_MXL_ИнкассовоеПоручение");
	
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
	ОбластьМакета.Параметры.СуммаПрописью = УправлениеНебольшойФирмойСервер.ФорматироватьСуммуПрописьюПлатежногоДокумента(
			ТекущаяСтрока.СуммаДокумента,
			ТекущаяСтрока.БанковскийСчетВалюта,
		);
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Плательщик) Тогда
		ОбластьМакета.Параметры.Плательщик = ТекущаяСтрока.Плательщик1;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Получатель) Тогда
		ОбластьМакета.Параметры.Получатель = ТекущаяСтрока.Получатель1;
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ИмяОбласти = "ЗаголовокТаблицы";
	
	НомерСтрокиОкончание = ТабличныйДокумент.ВысотаТаблицы;
	ТабличныйДокумент.Область(НомерСтрокиНачало, , НомерСтрокиОкончание, ).Имя = ИмяОбласти;

	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаСервере
Функция ПосмотретьВОтдельномОкнеАккредитивНаСервере(ТекущаяСтрока)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПлатежноеПоручение";
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПлатежноеПоручение_Аккредитив";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.КлиентБанк.ПФ_MXL_Аккредитив");
	
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
	ОбластьМакета.Параметры.СуммаПрописью = УправлениеНебольшойФирмойСервер.ФорматироватьСуммуПрописьюПлатежногоДокумента(
			ТекущаяСтрока.СуммаДокумента,
			ТекущаяСтрока.БанковскийСчетВалюта,
		);
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Плательщик) Тогда
		ОбластьМакета.Параметры.Плательщик = ТекущаяСтрока.Плательщик1;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Получатель) Тогда
		ОбластьМакета.Параметры.Получатель = ТекущаяСтрока.Получатель1;
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ИмяОбласти = "ЗаголовокТаблицы";
	
	НомерСтрокиОкончание = ТабличныйДокумент.ВысотаТаблицы;
	ТабличныйДокумент.Область(НомерСтрокиНачало, , НомерСтрокиОкончание, ).Имя = ИмяОбласти;

	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаСервере
Функция ПосмотретьВОтдельномОкнеОперациюНаСервере(ТекущаяСтрока)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПлатежноеПоручение";
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПлатежноеПоручение_НеНайденаОперация";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.КлиентБанк.ПФ_MXL_НеНайденаОперация");
	
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьМакета.Параметры.Заполнить(ТекущаяСтрока);
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ИмяОбласти = "ЗаголовокТаблицы";
	
	НомерСтрокиОкончание = ТабличныйДокумент.ВысотаТаблицы;
	ТабличныйДокумент.Область(НомерСтрокиНачало, , НомерСтрокиОкончание, ).Имя = ИмяОбласти;

	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции
