
#Region СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаГруппыПолей(Поле, Отказ)
	
	Если НЕ ПустаяСтрока(Поле.ИмяГруппыПолей) Тогда
		
		Отказ = Истина;
		ПоказатьПредупреждение(, Нстр("ru='Выбор групп не предусмотрен...'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПоляДополнительныхРеквизитов(Поле, ДополнительныйРеквизит, Отказ)
	
	Если Параметры.НастройкиЗагрузкиДанных.Свойство("ОписаниеДополнительныхРеквизитов") Тогда
		
		Для каждого ОписаниеДопРеквизита Из Параметры.НастройкиЗагрузкиДанных.ОписаниеДополнительныхРеквизитов Цикл
			
			Если ОписаниеДопРеквизита.Значение = Поле.ИмяПоля Тогда
				
				ДополнительныйРеквизит = ОписаниеДопРеквизита.Ключ; // Если отменяем выбор доп. реквизита - определем его.
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Поле.ИмяПоля = КэшЗначений.ИмяПоляДополнительныхРеквизитов Тогда
		
		Отказ = Истина;
		
		МаксимумДополнительныхРеквизитов = ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.МаксимумДополнительныхРеквизитовТабличногоДокумента();
		Если Параметры.НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты.Количество() >= МаксимумДополнительныхРеквизитов Тогда
			
			ТекстПредупреждения = НСтр("ru ='Большое количество дополнительных реквизитов в загрузке существенно замедляет процесс. 
			|Рекомендуется разделить загрузку на несколько итераций.'");
			
			ТекстЗаголовка = СтрШаблон(НСтр("ru ='Выбрано %1 реквизита'"), МаксимумДополнительныхРеквизитов);
			ПоказатьПредупреждение( , ТекстПредупреждения, 0, ТекстЗаголовка);
			Возврат;
			
		КонецЕсли;
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаДополнительныеРеквизиты;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗапомнитьЗаголовокПоляИВыборПользователя(ИмяВыбранногоПоля, ДополнительныйРеквизит, ОтменитьВыборВКолонке)
	
	Если ПустаяСтрока(КэшЗначений.ЗаголовокКолонки) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОписаниеОбъектаЗагрузки = ЗагрузкаДанныхИзВнешнегоИсточника.ОбъектЗагрузкиПоПолномуИмени(Параметры.НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения);
	Если НЕ ЗначениеЗаполнено(ОписаниеОбъектаЗагрузки.ОбъектЗагрузки) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.СоответствиеНаименованияКолонокПолямЗагрузки.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ОбъектЗагрузки		= ОписаниеОбъектаЗагрузки.ОбъектЗагрузки;
	МенеджерЗаписи.ИмяТабличнойЧасти	= ОписаниеОбъектаЗагрузки.ИмяТабличнойЧасти;
	МенеджерЗаписи.ЗаголовокКолонки		= КэшЗначений.ЗаголовокКолонки;
	
	Если ЗначениеЗаполнено(ДополнительныйРеквизит) Тогда
		
		ЭтоОтменаВыбора = (Параметры.НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты.Получить(ДополнительныйРеквизит) <> Неопределено)
			И ОтменитьВыборВКолонке = КэшЗначений.НомерКолонки;
		
		Если НЕ ЭтоОтменаВыбора Тогда
			
			МенеджерЗаписи.ДополнительныйРеквизит = ДополнительныйРеквизит;
			
		КонецЕсли;
		
		МенеджерЗаписи.Записать(Истина);
		
	ИначеЕсли ОтменитьВыборВКолонке <> 0 Тогда
		
		// имя оставляем пустым, что бы более колонка не сопоставлялась по данному заголовку
		// Важно!!! Выполняется до проверки ПустаяСтрока(ИмяВыбранногоПоля)!
		МенеджерЗаписи.Записать(Истина);
		
	ИначеЕсли НЕ ПустаяСтрока(ИмяВыбранногоПоля) Тогда
		
		МенеджерЗаписи.Поле = ИмяВыбранногоПоля;
		МенеджерЗаписи.Записать(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбязательныеДействияНаСервере(ИмяВыбранногоПоля, ДополнительныйРеквизит, ОтменитьВыборВКолонке = 0)
	
	// План:
	//
	// Необходимо убедиться, что номер колонки уникален для выбранного поля (во всех др полях обнулить такой номер колонки)
	// Записать дерево значений для дальнейшей работы
	
	ДеревоПолей = ДанныеФормыВЗначение(ДеревоПолейЗагрузки, Тип("ДеревоЗначений"));
	
	ПараметрыОтбора = Новый Структура("НомерКолонки", КэшЗначений.НомерКолонки);
	
	НайденныеСтрокиДереваПолей = ДеревоПолей.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	Если НайденныеСтрокиДереваПолей.Количество() > 1 Тогда
		
		Для каждого СтрокаДереваПолей Из НайденныеСтрокиДереваПолей Цикл
			
			Если СтрокаДереваПолей.ИмяПоля <> ИмяВыбранногоПоля Тогда
				
				СтрокаДереваПолей.НомерКолонки = 0;
				СтрокаДереваПолей.НомерЦвета  = СтрокаДереваПолей.НомерЦветаОригинал;
				
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ОтменитьВыборВКолонке <> 0
		И НайденныеСтрокиДереваПолей.Количество() = 1
		И НайденныеСтрокиДереваПолей[0].НомерКолонки = ОтменитьВыборВКолонке
		Тогда
		
		НайденныеСтрокиДереваПолей[0].НомерКолонки = 0;
		НайденныеСтрокиДереваПолей[0].НомерЦвета  = НайденныеСтрокиДереваПолей[0].НомерЦветаОригинал;
		
	КонецЕсли;
	
	ЗапомнитьЗаголовокПоляИВыборПользователя(ИмяВыбранногоПоля, ДополнительныйРеквизит, ОтменитьВыборВКолонке);
	
	ПоместитьВоВременноеХранилище(ДеревоПолей, Параметры.НастройкиЗагрузкиДанных.АдресХраненияДереваПолей);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПолейЗагрузки(ДеревоПолей)
	
	ЗначениеВРеквизитФормы(ДеревоПолей, "ДеревоПолейЗагрузки");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоДополнительныхРеквизитов()
	
	Если НЕ Параметры.НастройкиЗагрузкиДанных.Свойство("ОписаниеДополнительныхРеквизитов") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДеревоДопРеквизитов = РеквизитФормыВЗначение("ДополнительныеРеквизиты");
	
	СтрокиВладельцев = ДеревоДопРеквизитов.Строки;
	Для каждого Описание Из Параметры.НастройкиЗагрузкиДанных.ОписаниеДополнительныхРеквизитов Цикл
		
		ДополнительныйРеквизит = Описание.Ключ;
		
		ВладелецДопРеквизита = СтрокиВладельцев.Найти(ДополнительныйРеквизит.НаборСвойств, "ВладелецДопРеквизита", Ложь);
		Если ВладелецДопРеквизита = Неопределено Тогда
			
			ВладелецДопРеквизита = СтрокиВладельцев.Добавить();
			ВладелецДопРеквизита.ВладелецДопРеквизита = ДополнительныйРеквизит.НаборСвойств;
			ВладелецДопРеквизита.Представление = ДополнительныйРеквизит.НаборСвойств.Наименование;
			ВладелецДопРеквизита.ЭлементДоступен = Истина; // для групп всегда Истина
			
		КонецЕсли;
		
		НоваяCтрока = ВладелецДопРеквизита.Строки.Добавить();
		НоваяCтрока.ДополнительныйРеквизит = Описание.Ключ;
		НоваяCтрока.Представление = Строка(Описание.Ключ.Наименование);
		НоваяCтрока.ЭлементДоступен = Истина;
		
	КонецЦикла;
	
	НоваяCтрока = СтрокиВладельцев.Добавить();
	НоваяCтрока.ДополнительныйРеквизит = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПустаяСсылка();
	НоваяCтрока.Представление = КэшЗначений.ПолеВозвратаСписок;
	НоваяCтрока.ЭлементДоступен = Истина;
	
	ЗначениеВРеквизитФормы(ДеревоДопРеквизитов, "ДополнительныеРеквизиты");
	
КонецПроцедуры

&НаКлиенте
Функция ДостигнутМаксимумПоКоличествуВыбранныхДополнительныхРеквизитов(КоллекцияЭлементовДополнительныхРеквизитов)
	
	МаксимумДополнительныхРеквизитов = ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.МаксимумДополнительныхРеквизитовТабличногоДокумента();
	
	Возврат КоллекцияЭлементовДополнительныхРеквизитов.Количество() >= МаксимумДополнительныхРеквизитов;
	
КонецФункции

&НаКлиенте
Функция ДобавитьПолеДополнительногоРеквизитаВДеревоПолей(КоллекцияЭлементовДополнительныхРеквизитов, СтрокаДопРеквизита)
	
	ПолеДополнительногоРеквизита = КоллекцияЭлементовДополнительныхРеквизитов.Добавить();
	
	ПолеДополнительногоРеквизита.ИмяГруппыПолей = "";
	ПолеДополнительногоРеквизита.ИмяПоля = Параметры.НастройкиЗагрузкиДанных.ОписаниеДополнительныхРеквизитов.Получить(СтрокаДопРеквизита.ДополнительныйРеквизит);
	ПолеДополнительногоРеквизита.ТипПолучаемогоЗначения = Неопределено;
	ПолеДополнительногоРеквизита.ПредставлениеПоля = СтрокаДопРеквизита.Представление;
	ПолеДополнительногоРеквизита.НомерЦвета = 3;
	ПолеДополнительногоРеквизита.НомерЦветаОригинал = 4;
	
	Возврат ПолеДополнительногоРеквизита;
	
КонецФункции

&НаКлиенте
Функция НайтиПолеДополнительногоРеквизитаВДеревоПолей(КоллекцияЭлементовДополнительныхРеквизитов, СтрокаДопРеквизита)
	
	Для каждого ПолеДополнительногоРеквизита Из КоллекцияЭлементовДополнительныхРеквизитов Цикл
		
		Если ПолеДополнительногоРеквизита.ИмяПоля = 
			Параметры.НастройкиЗагрузкиДанных.ОписаниеДополнительныхРеквизитов.Получить(СтрокаДопРеквизита.ДополнительныйРеквизит) Тогда
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПолеДополнительногоРеквизита;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборДополнительногоРеквизита(СтрокаДопРеквизита)
	
	Если СтрокаДопРеквизита.ПолучитьЭлементы().Количество() > 0 Тогда
		
		ПоказатьПредупреждение(, НСтр("ru ='Выбор групп не предусмотрен...'"));
		Возврат;
		
	КонецЕсли;
	
	ГруппаДопРеквизитов = Неопределено;
	
	ЭлементыПервогоУровня = ДеревоПолейЗагрузки.ПолучитьЭлементы();
	Для каждого СтрокаДерева Из ЭлементыПервогоУровня Цикл
		
		Если СтрокаДерева.ИмяПоля = КэшЗначений.ИмяГруппыДополнительныхРеквизитов Тогда
			
			ГруппаДопРеквизитов = СтрокаДерева;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	КоллекцияЭлементовДополнительныхРеквизитов = ГруппаДопРеквизитов.ПолучитьЭлементы();
	Если Параметры.НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты.Получить(СтрокаДопРеквизита.ДополнительныйРеквизит) = Неопределено Тогда
		
		ПолеДополнительногоРеквизита = ДобавитьПолеДополнительногоРеквизитаВДеревоПолей(КоллекцияЭлементовДополнительныхРеквизитов, СтрокаДопРеквизита);
		
		Если ДостигнутМаксимумПоКоличествуВыбранныхДополнительныхРеквизитов(КоллекцияЭлементовДополнительныхРеквизитов) Тогда
			
			ГруппаДопРеквизитов.НомерЦвета = 3;
			
		КонецЕсли;
		
	Иначе
		
		ПолеДополнительногоРеквизита = НайтиПолеДополнительногоРеквизитаВДеревоПолей(КоллекцияЭлементовДополнительныхРеквизитов, СтрокаДопРеквизита);
		
	КонецЕсли;
	
	ЗапомнитьВыборИЗакрытьФорму(ПолеДополнительногоРеквизита, СтрокаДопРеквизита.ДополнительныйРеквизит);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьВыборИЗакрытьФорму(Поле, ДополнительныйРеквизит = Неопределено)
	
	Результат = Новый Структура;
	Результат.Вставить("Представление",			Поле.ПредставлениеПоля);
	Результат.Вставить("Значение",				Поле.ИмяПоля);
	Результат.Вставить("ДопРеквизит",			ДополнительныйРеквизит);
	Результат.Вставить("ОтменитьВыборВКолонке", 0);
	
	Если Поле.НомерКолонки <> 0 Тогда
		
		Результат.Вставить("ОтменитьВыборВКолонке", Поле.НомерКолонки);
		
	ИначеЕсли (ПустаяСтрока(Поле.ИмяПоля) И ПустаяСтрока(Поле.ИмяГруппыПолей))
		И КэшЗначений.НомерКолонки <> 0 Тогда
		
		Результат.Вставить("ОтменитьВыборВКолонке", КэшЗначений.НомерКолонки);
		
	КонецЕсли;
	
	ВернутьЦветКолонки = Ложь;
	ВыбралиСамиСебя = (Поле.НомерКолонки = КэшЗначений.НомерКолонки);
	Если НЕ ПустаяСтрока(Поле.ИмяПоля) Тогда
		
		Поле.НомерКолонки = ?(ВыбралиСамиСебя, 0, КэшЗначений.НомерКолонки);
		Поле.НомерЦвета = ?(ВыбралиСамиСебя, Поле.НомерЦветаОригинал, 3);
		
	ИначеЕсли (ПустаяСтрока(Поле.ИмяПоля) И ПустаяСтрока(Поле.ИмяГруппыПолей))
		И КэшЗначений.НомерКолонки <> 0 Тогда
		
		// Мы не можем тут вернуть цвет без обращения к серверу, потому что выбрано поле "Не загружать",
		// в котором нет оригинального цвета поля.
		ВернутьЦветКолонки = Истина;
		
	КонецЕсли;
	
	ВыполнитьОбязательныеДействияНаСервере(Поле.ИмяПоля, ДополнительныйРеквизит, Результат.ОтменитьВыборВКолонке);
	
	Если Результат.ОтменитьВыборВКолонке = 0 Тогда
		
		Результат.Удалить("ОтменитьВыборВКолонке");
		
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

#EndRegion

#Region СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ЗаголовокКолонки;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокКолонки", ЗаголовокКолонки) Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru ='Выбор поля'") + ?(ПустаяСтрока(ЗаголовокКолонки), "", ": " + СокрЛП(ЗаголовокКолонки));
		
	Иначе
		
		ВызватьИсключение НСтр("ru ='Открытие обработки без контекста запрещено.'");
		
	КонецЕсли;
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("ИмяПоляДополнительныхРеквизитов", ЗагрузкаДанныхИзВнешнегоИсточника.ИмяПоляДобавленияДополнительныхРеквизитов());
	КэшЗначений.Вставить("НомерКолонки", Параметры.НомерКолонки);
	КэшЗначений.Вставить("ПолеВозвратаСписок", НСтр("ru ='Назад к списку реквизитов'"));
	КэшЗначений.Вставить("ИмяГруппыДополнительныхРеквизитов", ЗагрузкаДанныхИзВнешнегоИсточника.ИмяПоляДобавленияДополнительныхРеквизитов());
	КэшЗначений.Вставить("ЗаголовокКолонки", СокрЛП(ЗаголовокКолонки));
	
	ДеревоПолей = ПолучитьИзВременногоХранилища(Параметры.НастройкиЗагрузкиДанных.АдресХраненияДереваПолей);
	ЗаполнитьДеревоПолейЗагрузки(ДеревоПолей);
	
	ЗаполнитьДеревоДополнительныхРеквизитов();
	
	ЗапомнитьСопоставление = Истина;
	
КонецПроцедуры

#EndRegion

#Region СобытияРеквизитовФормы

&НаКлиенте
Процедура ТаблицаПолейЗагрузкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Отказ					= Ложь;
	СтандартнаяОбработка	= Ложь;
	ДополнительныйРеквизит	= Неопределено;
	
	Поле = ДеревоПолейЗагрузки.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОбработкаГруппыПолей(Поле, Отказ);
	ОбработкаПоляДополнительныхРеквизитов(Поле, ДополнительныйРеквизит, Отказ);
	
	Если НЕ Отказ Тогда
		
		ЗапомнитьВыборИЗакрытьФорму(Поле, ДополнительныйРеквизит);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаДопРеквизита = ДополнительныеРеквизиты.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если СтрокаДопРеквизита.Представление = КэшЗначений.ПолеВозвратаСписок Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоля;
		
	Иначе
		
		ОбработатьВыборДополнительногоРеквизита(СтрокаДопРеквизита);
		
	КонецЕсли;
	
КонецПроцедуры

#EndRegion