///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ПоставленВручную", Истина);
	ОтборПостановкаНаМониторинг = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбработкаВыбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура ОтборПостановкаНаМониторингПриИзменении(Элемент)
	
	УстановитьОтборПоСпособуПостановки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура СнятьСМониторинга(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПриОтветеНаВопросОСнятииСМониторинга", ЭтотОбъект),
		НСтр("ru = 'Снять выбранных контрагентов с мониторинга?'"),
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборКонтрагентовДляМониторинга(Команда)
	
	СправочникиКонтрагенты = СПАРКРискиКлиентПовтИсп.СправочникиКонтрагенты();
	Если СправочникиКонтрагенты.Количество() = 1 Тогда
		ОткрытьФормуПодбора(СправочникиКонтрагенты[0].Значение);
	Иначе
		СправочникиКонтрагенты.ПоказатьВыборЭлемента(
			Новый ОписаниеОповещения("ПриВыбореСправочникаКонтрагентаДляПодбора", ЭтотОбъект),
			НСтр("ru = 'Выбор справочника контрагентов'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуКонтрагента(Команда)
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.Контрагент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборПоСпособуПостановки()
	
	Если ОтборПостановкаНаМониторинг = 0 Тогда
		
		ОтборыСпособПостановки = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.Отбор, "ПоставленВручную");
		Для Каждого ТекущийОтбор Из ОтборыСпособПостановки Цикл
			ТекущийОтбор.Использование = Ложь;
		КонецЦикла;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор,
			"ПоставленВручную",
			(ОтборПостановкаНаМониторинг = 1),
			,
			,
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбора(ОписаниеСправочника)
	
	Если ЗначениеЗаполнено(ОписаниеСправочника.ИмяФормыПодбора) Тогда
		
		ОткрытьФорму(
			ОписаниеСправочника.ИмяФормыПодбора,
			Новый Структура("ВыборКонтрагентов1СПАРКРискиПостановкаНаМониторинг", Истина),
			ЭтотОбъект);
		
	Иначе
		
		ИмяФормыВыбора = "Справочник." + ОписаниеСправочника.Имя + ".ФормаВыбора";
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора"         , Истина);
		ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ПредопределенноеЗначение("ИспользованиеГруппИЭлементов.Элементы"));
		ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
		ПараметрыФормы.Вставить("ВыборКонтрагентов1СПАРКРискиПостановкаНаМониторинг", Истина);
		ОткрытьФорму(
			ИмяФормыВыбора,
			ПараметрыФормы,
			ЭтотОбъект,
			,
			,
			,
			,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореСправочникаКонтрагентаДляПодбора(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОткрытьФормуПодбора(ВыбранныйЭлемент.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораНаСервере(Знач ВыбранныеКонтрагенты)
	
	СПАРКРискиМониторингСобытий.ВключитьМониторингКонтрагентов(ВыбранныеКонтрагенты, Истина);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтветеНаВопросОСнятииСМониторинга(КодВозврата, ДополнительныеПараметры) Экспорт
	
	Если КодВозврата = КодВозвратаДиалога.Да Тогда
		УдаленоЗаписей = СнятьСМониторингаНаСервере();
		Если УдаленоЗаписей = 0 Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Среди выбранных контрагентов нет поставленных вручную.'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СнятьСМониторингаНаСервере()
	
	КонтрагентыДляСнятияСМониторинга = Новый Массив;
	Для каждого КлючЗаписи Из Элементы.Список.ВыделенныеСтроки Цикл
		КонтрагентыДляСнятияСМониторинга.Добавить(КлючЗаписи.Контрагент);
	КонецЦикла;
	
	КоличествоИзмененных = СПАРКРискиМониторингСобытий.ОтключитьМониторингКонтрагентов(КонтрагентыДляСнятияСМониторинга, Истина);
	
	Если КоличествоИзмененных > 0 Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	Возврат КоличествоИзмененных;
	
КонецФункции

#КонецОбласти