
&НаКлиенте
Процедура ПорядокУстановкиШрифтаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Попытка
		Если Найти(ДанныеСобытия.Href, "GnivcFontDownload") > 0 Тогда
			Попытка
				ПолучитьФайл(АдресФайлаШрифта, "EANG000.ttf", Истина);
			Исключение
				ПоказатьПредупреждение(,НСтр("ru='Не удалось получить файл'"));
			КонецПопытки;
		КонецЕсли;
	Исключение
		
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПорядокУстановкиШрифта = Обработки.ОбработкиНалоговИОтчетности.ПолучитьМакет("ПорядокУстановкиШрифта").ПолучитьТекст();
	
КонецПроцедуры
