

#Область ОписаниеПеременных

&НаСервере
Перем ОбъектЭтогоОтчета; // Объект метаданных отчета, из которого открыта форма записи.

&НаКлиенте
Перем УправляемаяФормаВладелец; // Форма отчета, из которого открыта форма записи.

&НаКлиенте
Перем УникальностьФормы; // Уникальный идентификатор формы отчета.

&НаКлиенте
Перем ПоказыватьПредупреждениеПослеПереходаПоСсылке; // Флаг необходимости показа предупреждения.

// Форма выбора из списка, ввода пары значений, форма длительной операции, 
// записи регистра, ввода данных по ОП и т.д.
// Любая открытая из данной формы форма в режиме блокировки владельца.
&НаКлиенте
Перем ОткрытаяФормаПотомокСБлокировкойВладельца Экспорт;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправлениеВидимостью(Ложь);
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	ФормированиеПредставленийНаСервере(Запись.П000010000301, Запись.П000010000302, Запись.П000010000305);
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	
	// Определим тексты запросов динамических списков.
	
	ВставитьКодПродукции = Ложь;
	
	
	ОсновнаяТаблица = "";
	ТекстЗапроса = РегламентированнаяОтчетностьАЛКО.ТекстЗапросаВыбораКонтрагентаАЛКО(
																	ОсновнаяТаблица, Ложь, Неопределено);
			
	ДинСписокПолучателя.ТекстЗапроса = ТекстЗапроса;
	ДинСписокПолучателя.ОсновнаяТаблица = ОсновнаяТаблица;
	ДинСписокПолучателя.ДинамическоеСчитываниеДанных = Истина;
	
	Элементы.ТаблицаПолучателей.Обновить();
		
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	ТекстПредупреждения = НСтр("ru='Данная форма предназначена для редактирования данных из форм регламентированных отчетов.
										|
										|Открытие данной формы не из формы регламентированного отчета не предусмотрено!'");
	
	// Ищем управляемую форму, откуда открыли.
	Если ВладелецФормы = Неопределено Тогда
		
	    Отказ = Истина;		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
				
	ТекущийРодитель = ВладелецФормы;
	 
	Пока ТипЗнч(ТекущийРодитель) <> Тип("УправляемаяФорма") Цикл
	    ТекущийРодитель = ТекущийРодитель.Родитель;		
	КонецЦикла;
	
	УправляемаяФормаВладелец = ТекущийРодитель;
		
	ИмяФормыВладельца 	= УправляемаяФормаВладелец.ИмяФормы;
		
	Если СтрНайти(ИмяФормыВладельца, "РегламентированныйОтчетАлко") = 0 Тогда
	
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	
	КонецЕсли;
	
	УникальностьФормы   = УправляемаяФормаВладелец.УникальностьФормы;
	Оповестить("ОткрытаФормаЗаписиРегистра", ЭтаФорма, УникальностьФормы);
	
	ТекущееСостояниеВладельца = УправляемаяФормаВладелец.ТекущееСостояние;
	
    ДокументЗаписи = 		УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мСохраненныйДок;
	ИндексСтраницыЗаписи = 	УправляемаяФормаВладелец.ИндексАктивнойСтраницыВРегистре;
	ИндексСтраницы = 		УправляемаяФормаВладелец.НомерАктивнойСтраницыМногострочногоРаздела;
	НомерПоследнейЗаписи = 	УправляемаяФормаВладелец.КоличествоСтрок;
	МаксИндексСтраницы = 	УправляемаяФормаВладелец.МаксИндексСтраницы;
	
	ДатаПодписи = 			УправляемаяФормаВладелец.ДатаПодписи;
	
	ПоказыватьПредупреждениеПослеПереходаПоссылке = УправляемаяФормаВладелец.ПоказыватьПредупреждениеПослеПереходаПоссылке;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
				
		// Заполним измерения, их нет на форме.
	    Запись.Активно = Истина;
		
		Запись.Документ = ДокументЗаписи;
				
		НомерПоследнейЗаписи = НомерПоследнейЗаписи + 1;
	    Запись.ИндексСтроки = НомерПоследнейЗаписи;
		
		Модифицированность = Истина;
			
	КонецЕсли;
		
	Заголовок = "Сведения об объеме поставки фармацевтической субстанции спирта этилового (этанола)";
	
	ФлажокОтклАвтоРасчет 	= УправляемаяФормаВладелец.СтруктураРеквизитовФормы.ФлажокОтклАвтоРасчет;
	ФлажокОтклАвтоВыборКодов	= УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мАвтоВыборКодов;
	ДатаПериодаОтчета = УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мДатаКонцапериодаОтчета;
	
	ПодготовкаНаСервере();

	Если НЕ ВладелецФормы.ТекущийЭлемент = Неопределено Тогда
		
		ИмяАктивногоПоля = ВладелецФормы.ТекущийЭлемент.Имя;
		
		// Если активное поле Наименование продукции - перекинем на код.
		Если ИмяАктивногоПоля = "П000010000301" Тогда
		    ИмяАктивногоПоля = "П000010000302";			
		КонецЕсли; 
		
	    АктивноеПоле = Элементы.Найти(ИмяАктивногоПоля);
		Если НЕ АктивноеПоле = Неопределено Тогда
		    ТекущийЭлемент = АктивноеПоле;		
		КонецЕсли;
	
	КонецЕсли;
			
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить("ЗакрытаФормаЗаписиРегистра", , УникальностьФормы);
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
				
	ВнесеныИзменения = Модифицированность;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		// Обработка ситуаций "битых" внутренних данных отчета.
		// В норме условие должно проверяться один раз, результат Ложь, 
		// но если из отчета пришло неверное значениепоследней строки - этот цикл позволит
		// записать корректно данные.
		// В дальнейшем при закрытии формы через оповещение отчет будет проинформирован о текущей строке,
		// и скорректирует свои внутренние данные.
		
		СписокСоставаРегистра = Новый СписокЗначений;
		СписокСоставаРегистра.Добавить("Измерения");
		СтруктураИзмерений = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруДанныхЗаписиРегистраСведений(
																		ИмяРегистра, СписокСоставаРегистра);
	
		Пока РегламентированнаяОтчетностьАЛКО.СуществуетЗапись(Запись, ИмяРегистра, СтруктураИзмерений) Цикл
			
			НомерПоследнейЗаписи = НомерПоследнейЗаписи + 1;
			Запись.ИндексСтроки = НомерПоследнейЗаписи;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЭтоПервоеРедактирование = Ложь;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки, "ДобавлениеСтроки");
									
	ИначеЕсли ВнесеныИзменения Тогда
			
		// Нужно записать первоначальные данные Записи регистра в журнал.
		// Но сделать это надо только для случая первого изменения Записи после последнего сохранения отчета,
		// чтобы была информация о данных до изменения в случае отката внесенных изменений, если
		// отказался пользователь от сохранения отчета.
		
		ЭтоПервоеРедактирование = РегламентированнаяОтчетностьАЛКО.ЭтоПервоеРедактированиеЗаписиРегистра(ТекущийОбъект.Документ, ИмяРегистра, 
															ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки);
				
	КонецЕсли;
	
	Если ЭтоПервоеРедактирование Тогда
		
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("НачальноеЗначение", НачальноеЗначение);
		Ресурсы.Вставить("КоличествоСтрок", НомерПоследнейЗаписи);
		Ресурсы.Вставить("МаксИндексСтраницы", МаксИндексСтраницы);
		
		// Нужно сохранить первоначальные данные.
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки, "Редактирование", Ресурсы);
	Иначе
									
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("КоличествоСтрок", НомерПоследнейЗаписи);		
		Ресурсы.Вставить("МаксИндексСтраницы", МаксИндексСтраницы);
		
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, 0, "Сервис", Ресурсы);							
	КонецЕсли;

	Если ВнесеныИзменения Тогда
		РегламентированнаяОтчетностьАЛКО.ПолучитьВнутреннееПредставлениеСтруктурыДанныхЗаписи(
											Запись, ИмяРегистра, КонечноеЗначениеСтруктураДанных);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповещаем о необходимости пересчета итогов форму-владелец для активных записей.
	Если ВнесеныИзменения и Запись.Активно Тогда
	 
		// Оповещаем форму-владелец о изменениях.
		ИнформацияДляПересчетаИтогов = Новый Структура;
		ИнформацияДляПересчетаИтогов.Вставить("ИмяРегистра", 		ИмяРегистра);
		ИнформацияДляПересчетаИтогов.Вставить("ИндексСтраницы", 	ИндексСтраницы);
		ИнформацияДляПересчетаИтогов.Вставить("ИндексСтроки", 		Запись.ИндексСтроки);
		ИнформацияДляПересчетаИтогов.Вставить("НачальноеЗначение", 	НачальноеЗначениеСтруктураДанных);
		ИнформацияДляПересчетаИтогов.Вставить("КонечноеЗначение", 	КонечноеЗначениеСтруктураДанных);
		
		Оповестить("ПересчетИтогов", ИнформацияДляПересчетаИтогов, УникальностьФормы);
	
	КонецЕсли;
	
	
	// Удаляем данные из Допданных страницы отчета, теперь они уже не нужны.
	АктивнаяСтраница = УправляемаяФормаВладелец.ТаблицаСтраницыДекларация[ИндексСтраницы];
	ДополнительныеДанныеСтраницы = АктивнаяСтраница.ДополнительныеДанные[0].Значение;
	ИмяОбласти = "П000010000305_" + Формат(Запись.ИндексСтроки, "ЧН=; ЧГ=0");
	ДополнительныеДанныеСтраницы.Удалить(ИмяОбласти);
		
	ВнесеныИзменения = Ложь;
		
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если (НЕ ЗавершениеРаботы = Неопределено) и ЗавершениеРаботы Тогда
		// Идет завершение работы системы.
	Иначе
		// Обычное закрытие.
	    Если Элементы.ГруппаВыборПолучателя.Видимость Тогда
		    // Щелкнули на крестик при выборе получателя.
			Отказ = Истина;
		    УправлениеВидимостью(Ложь);
			
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = УникальностьФормы Тогда
		
		Если НРег(ИмяСобытия) = НРег("ЗакрытьОткрытыеФормыЗаписи") Тогда			
		    Модифицированность = Ложь;
			Закрыть();			
		КонецЕсли;
					
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборВидаПродукции();
	
КонецПроцедуры


&НаКлиенте
Процедура ПолеПриИзменении(Элемент)
		
	ОбработкаПослеИзменения();
		
КонецПроцедуры


&НаКлиенте
Процедура ПолучательПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	НажатиеГиперссылки(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресНажатие(Элемент, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	ВводАдресаНаКлиенте();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПолучателей

&НаКлиенте
Процедура ТаблицаПолучателейВыбор(Элемент, ВыбраннаяСтрока = Неопределено, Поле = Неопределено, СтандартнаяОбработка = Истина)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
	    Возврат;	
	КонецЕсли; 
	
	НаименованиеПолное = Элемент.ТекущиеДанные.НаименованиеПолное;
	ИНН = Элемент.ТекущиеДанные.ИНН;
	КПП = Элемент.ТекущиеДанные.КПП;
	
	ТаблицаПолучателейВыборНаСервере(НаименованиеПолное, ИНН, КПП);
			
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаПолучателейПриАктивизацииСтроки(Элемент)
	
	Если НЕ ПроверялиНеобходимостьПоказаПредупреждения Тогда	
		
		Элементы.ГруппаИнфоВыбораПолучателя.Видимость = (Элемент.ТекущиеДанные = Неопределено);			
		
		ПроверялиНеобходимостьПоказаПредупреждения = Истина;
		
	КонецЕсли;	 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьИЗакрыть(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если НЕ Модифицированность Тогда
	    Закрыть();
	Иначе	
	    Записать();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьПолучателя(Команда)
	
	УправлениеВидимостью(Истина);
	
КонецПроцедуры


&НаКлиенте
Процедура ВыборПолучателя(Команда)
	
	ТаблицаПолучателейВыбор(Элементы.ТаблицаПолучателей);
	
КонецПроцедуры


&НаКлиенте
Процедура ВернутьсяНазад(Команда)
	
	УправлениеВидимостью(Ложь);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовкаНаСервере()
	
	УправлениеВидимостью(Ложь);
	
	ДоступностьПолейНаСервере();	
	СформироватьСпискиВыбораНаСервере();
	ФормированиеПредставленийНаСервере(Запись.П000010000301, Запись.П000010000302, Запись.П000010000305);
	
	// Заполним начальное значение всех полей записи во внутреннем формате.
	ИмяРегистра = РегламентированнаяОтчетностьАЛКО.ПолучитьИмяОбъектаМетаданныхПоИмениФормы(ИмяФормы);
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		
		Запись.ИДДокИндСтраницы = РегламентированнаяОтчетностьАЛКО.ПолучитьИдДокИндСтраницы(Запись.Документ, ИндексСтраницыЗаписи);
		Запись.Организация = Запись.Документ.Организация;
		
		// Начальные данные в этих случаях всегда пустые.
		НачальноеЗначениеСтруктураДанных = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруДанныхЗаписиРегистраСведений(ИмяРегистра);
		НачальноеЗначение = ЗначениеВСтрокуВнутр(НачальноеЗначениеСтруктураДанных);
		
	Иначе
		НачальноеЗначение = РегламентированнаяОтчетностьАЛКО.ПолучитьВнутреннееПредставлениеСтруктурыДанныхЗаписи(
															Запись, ИмяРегистра, НачальноеЗначениеСтруктураДанных);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ДоступностьПолейНаСервере()

	// Доступность полей формы в зависимости от флажка Авторасчет в отчете-владельце.
	// Для раздела 2 Алко приложения 11 нет авторасчета.
	
	Возврат;
	
КонецПроцедуры


&НаСервере
Функция ОбъектОтчета(ИмяФормыОбъекта)
	
	Возврат РегламентированнаяОтчетностьАЛКО.ОбъектОтчетаАЛКО(ИмяФормыОбъекта, ОбъектЭтогоОтчета);
	
КонецФункции


&НаСервере
Процедура ОбработкаМодифицированности(НачальноеЗначениеПолей, СтруктураМодифицированности)
	
	МодифицированностьКлючевыхПолей = Ложь;
	Для Каждого ЭлСтруктуры Из СтруктураМодифицированности Цикл
					
		Если ЭлСтруктуры.Значение Тогда
		    МодифицированностьКлючевыхПолей = Истина;
			Прервать;			
		КонецЕсли; 
	
	КонецЦикла;
			
	Если НЕ МодифицированностьКлючевыхПолей Тогда
		
		// Принудительно записываем начальные данные, включая всю
		// вспомогательную информацию.
		ЗаполнитьЗначенияСвойств(Запись, НачальноеЗначениеПолей);
		
	Иначе
		
		Запись.Получатель = Неопределено;
		
		ОбъектОтчета(ИмяФормыВладельца).ОбработкаЗаписи(ИмяРегистра, Запись);		
				
	КонецЕсли; 
	
	Модифицированность = МодифицированностьКлючевыхПолей;
	
КонецПроцедуры


&НаСервере
Процедура ОбработкаПослеИзменения()
	
	СтруктураМодифицированности = "";
	РегламентированнаяОтчетностьАЛКО.ЗаписьИзменилась(Запись, НачальноеЗначениеСтруктураДанных, 
														Ложь, СтруктураМодифицированности);
	ОбработкаМодифицированности(НачальноеЗначениеСтруктураДанных, СтруктураМодифицированности);
	
	ФормированиеЗаголовковСвернутогоОтображения();
	
КонецПроцедуры


&НаСервере
Процедура ФормированиеЗаголовковСвернутогоОтображения()

	// ГруппаПолучателя.
	Элементы.ПолучательПредставление.Видимость = ЗначениеЗаполнено(Запись.Получатель);
	
	Если ЗначениеЗаполнено(Запись.П000010000304)
		или ЗначениеЗаполнено(Запись.П000010000305)
		или ЗначениеЗаполнено(Запись.П000010000307)
		или ЗначениеЗаполнено(Запись.П000010000306)
		Тогда
		
	    Элементы.ГруппаПолучателя.ЗаголовокСвернутогоОтображения = "Получатель: " + 
			?(ЗначениеЗаполнено(Запись.П000010000304),Запись.П000010000304, "наименование не заполнено") 
			+ ?(ЗначениеЗаполнено(Запись.П000010000306),", ИНН " + Запись.П000010000306, ", ИНН не заполнено")
			+ ?(ЗначениеЗаполнено(Запись.П000010000307),", КПП " + Запись.П000010000307, 
											?(СтрДлина(Запись.П000010000306) = 10,", КПП не заполнено", "") )
			+ ?(ЗначениеЗаполнено(Запись.П000010000305),", Адрес: " + Запись.П000010000305, ", Адрес не заполнен")
			+ ?(ЗначениеЗаполнено(Запись.П000010000308),", Виды деятельности: " + Запись.П000010000308, ", Вид деятельности не заполнен");
											
		
			
	Иначе	
	    Элементы.ГруппаПолучателя.ЗаголовокСвернутогоОтображения = 
							Элементы.ГруппаПолучателя.Заголовок + " не заполнены!";							
	КонецЕсли;
						
	// Доступ к КПП только если введен 10 значный ИНН.
	Если СтрДлина(Запись.П000010000306) = 10 Тогда
		
	    Элементы.П000010000307.ТолькоПросмотр = Ложь;
		Элементы.П000010000307.ПропускатьПриВводе = Ложь;
		
	Иначе
		
	    Элементы.П000010000307.ТолькоПросмотр = Истина;
		Элементы.П000010000307.ПропускатьПриВводе = Истина;
		Если НЕ СокрЛП(Запись.П000010000307) = "" Тогда
		    Запись.П000010000307 = "";
			Модифицированность = Истина;		
		КонецЕсли; 
		
	КонецЕсли;
		
КонецПроцедуры


&НаСервере
Процедура ФормированиеПредставленийНаСервере(
				ВидПродукции = Неопределено, КодВида = Неопределено, АдресПолучателя = Неопределено)
	
	Если ВидПродукции = Неопределено Тогда
	    ВидПродукции = Запись.П000010000301;	
	КонецЕсли;
	
	Если КодВида = Неопределено Тогда
	    КодВида = Запись.П000010000302;	
	КонецЕсли;
	
	Если АдресПолучателя = Неопределено Тогда
	    АдресПолучателя = Запись.П000010000305;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодВида) Тогда
	    ПредставлениеПродукции = "Код " + КодВида + ", " + ВидПродукции;
	Иначе	
	    ПредставлениеПродукции = "Заполнить";
	КонецЕсли; 
	
	Если ПредставлениеПродукции = "Заполнить" Тогда		
		Элементы.Представление.ЦветТекста = ЦветСтиляНезаполненныйРеквизит;
	Иначе
		Элементы.Представление.ЦветТекста = ЦветСтиляЦветГиперссылкиБРО;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресПолучателя) Тогда
	    ПредставлениеАдресаПолучателя = АдресПолучателя;
	Иначе	
	    ПредставлениеАдресаПолучателя = "Заполнить";
	КонецЕсли;
	
	Если ПредставлениеАдресаПолучателя = "Заполнить" Тогда		
		Элементы.ПредставлениеАдресаПолучателя.ЦветТекста = ЦветСтиляНезаполненныйРеквизит;
	Иначе
		Элементы.ПредставлениеАдресаПолучателя.ЦветТекста = ЦветСтиляЦветГиперссылкиБРО;
	КонецЕсли;
		
	ФормированиеЗаголовковСвернутогоОтображения();
		
КонецПроцедуры


&НаКлиенте
Процедура ВводАдресаНаКлиенте()
	
	СтандартнаяОбработка = Ложь;
		
	АдресМестаДеятельности = РегламентированнаяОтчетностьАЛКОВызовСервера.ПолучитьПустуюСтруктуруАдреса();
		
	// Читаем сохраненную во внутреннем представлении структуру.
	АдресXML = Запись.П000010000305XML;
		
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(АдресXML) Тогда			
		АдресМестаДеятельности.АдресXML = АдресXML;								     
	КонецЕсли;	
	АдресМестаДеятельности.ПредставлениеАдреса = Запись.П000010000305;
	
	ЗаголовокФормыВвода = "Ввод адреса";
	
	ВидКонтактнойИнформации = УправляемаяФормаВладелец.СтруктураРеквизитовФормы.СправочникиВидыКонтактнойИнформации.ЛюбойАдрес;
		
	Оповещение = Новый ОписаниеОповещения("ВводАдресаЗавершениеНаКлиенте", ЭтаФорма);
	
	РегламентированнаяОтчетностьАЛКОКлиент.ВызватьФормуВводаАдресаАЛКО(
							АдресМестаДеятельности, ЗаголовокФормыВвода, Оповещение, ВидКонтактнойИнформации);
		
КонецПроцедуры

&НаКлиенте
Процедура ВводАдресаЗавершениеНаКлиенте(Результат, Параметры) Экспорт

	Если Результат = Неопределено Тогда
	    Возврат;	
	КонецЕсли; 
	
	СтароеПредставление = Запись.П000010000305;
	СтарыйАдресXML = Запись.П000010000305XML;
				
	СтруктураАдреса = Неопределено;
	
	Если НЕ (ТипЗнч(Результат) = Тип("Структура")) Тогда
		Возврат;	
	КонецЕсли;
	
	Запись.П000010000305XML = Результат.КонтактнаяИнформация; // формат XML
	Запись.П000010000305 = Результат.Представление;
		
	ФормированиеПредставленийНаСервере();
	
	Если СтароеПредставление <> Запись.П000010000305 
		или СтарыйАдресXML <> Запись.П000010000305XML Тогда
		
	    Модифицированность = Истина;
		
	КонецЕсли;
	
	ОбработкаПослеИзменения();
	
КонецПроцедуры 


&НаКлиенте
Процедура ВыборВидаПродукции()
	
	// Из списка.
	ИсходноеЗначениеКода = СокрЛП(Запись.П000010000302);
	ИсходноеЗначениеНазвания = СокрЛП(Запись.П000010000301);
	КолонкаПоиска = "Код";
	ИмяКолонкиКодПродукции = "П000010000302";
		
	// Не из списка.
	ЗаголовокФормы = "Ввод вида продукции";
	НадписьПоляЗначения = "Вид продукции";
	НадписьПоляКод = "Код";
	МногострочныйРежимЗначения = Истина;
	ДлинаПоляКода  = 4;
	ДлинаПоляЗначения = 40;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборЗавершение", ЭтотОбъект);
		
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ПараметрыПриВключенномВыбореИзСписка", Новый Структура);
	ПараметрыВыборИзСписка = СтруктураПараметров.ПараметрыПриВключенномВыбореИзСписка;
	// Из списка.
	ПараметрыВыборИзСписка.Вставить("СвойстваПоказателей", 	СвойстваПоказателей);
	ПараметрыВыборИзСписка.Вставить("ИмяКолонкиКод", 		ИмяКолонкиКодПродукции);	
	ПараметрыВыборИзСписка.Вставить("КолонкаПоиска", 		КолонкаПоиска);
	ПараметрыВыборИзСписка.Вставить("ИсходноеЗначение", 	ИсходноеЗначениеКода);
	
	СтруктураПараметров.Вставить("ПараметрыПриОтключенномВыбореИзСписка", Новый Структура);
	ПараметрыВыборНеИзСписка = СтруктураПараметров.ПараметрыПриОтключенномВыбореИзСписка;
	// Не из списка.
	ПараметрыВыборНеИзСписка.Вставить("ЗаголовокФормы", 			ЗаголовокФормы);
	ПараметрыВыборНеИзСписка.Вставить("ИсходноеЗначениеКода", 		ИсходноеЗначениеКода);	
	ПараметрыВыборНеИзСписка.Вставить("ИсходноеЗначениеПоКоду",		ИсходноеЗначениеНазвания);
	ПараметрыВыборНеИзСписка.Вставить("НадписьПоляЗначения", 		НадписьПоляЗначения);
	ПараметрыВыборНеИзСписка.Вставить("НадписьПоляКод", 			НадписьПоляКод);
	ПараметрыВыборНеИзСписка.Вставить("МногострочныйРежимЗначения", МногострочныйРежимЗначения);
	ПараметрыВыборНеИзСписка.Вставить("ДлинаПоляКода", 				ДлинаПоляКода);
	ПараметрыВыборНеИзСписка.Вставить("ДлинаПоляЗначения", 			ДлинаПоляЗначения);
	ПараметрыВыборНеИзСписка.Вставить("УникальностьФормы", 			УникальностьФормы);

	
	РегламентированнаяОтчетностьАЛКОКлиент.ВызватьФормуВыбораЗначенийАЛКО(
			ЭтаФорма, ФлажокОтклАвтоВыборКодов, СтруктураПараметров, ОписаниеОповещения);
		
КонецПроцедуры


&НаКлиенте
Процедура ВыборЗавершение(РезультатВыбора, Параметры) Экспорт
	
	ОткрытаяФормаПотомокСБлокировкойВладельца = Неопределено;
	
	Если РезультатВыбора = Неопределено Тогда
	    Возврат;	
	КонецЕсли; 
	
	// Поскольку всегда "выбираем" код.
	ИмяКолонкиКодПродукции 			= "П000010000302";
	ИмяКолонкиНаименованияПродукции = "П000010000301";
	
	ИсходноеЗначение 				= СокрЛП(Запись[ИмяКолонкиКодПродукции]);
	Запись[ИмяКолонкиКодПродукции] 	= СокрЛП(РезультатВыбора.Код);
	
	КодИзменился = (ИсходноеЗначение <> СокрЛП(Запись[ИмяКолонкиКодПродукции]));
		
	ИсходноеЗначениеНаименования 			= СокрЛП(Строка(Запись[ИмяКолонкиНаименованияПродукции]));
	Запись[ИмяКолонкиНаименованияПродукции] = ?(СокрЛП(РезультатВыбора.Код) = "",
													"", СокрЛП(РезультатВыбора.Название));
	
	НаименованиеИзменилось = (ИсходноеЗначениеНаименования <> СокрЛП(Запись[ИмяКолонкиНаименованияПродукции]));	
	
	Модифицированность = Модифицированность или КодИзменился или НаименованиеИзменилось;
	
	ФормированиеПредставленийНаСервере();	
	ОбработкаПослеИзменения(); 
	
КонецПроцедуры


&НаСервере
Процедура СформироватьСпискиВыбораНаСервере()
		
	КоллекцияСписковВыбора = РегламентированнаяОтчетностьАЛКО.СчитатьКоллекциюСписковВыбораАЛКО(
														ДатаПериодаОтчета, ИмяФормыВладельца, ОбъектЭтогоОтчета);
	
	СвойстваПоказателей.Очистить();
		
	РегламентированнаяОтчетность.ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000010000301", 3, , "Выбор вида продукции", КоллекцияСписковВыбора["ВидыПродукции"]);
	РегламентированнаяОтчетность.ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000010000302", 3, , "Выбор вида продукции", КоллекцияСписковВыбора["ВидыПродукции"]);

КонецПроцедуры


&НаСервере
Процедура УправлениеВидимостью(ПоказатьВыборПолучателей = Ложь)
	
	Если ПоказатьВыборПолучателей Тогда
		
		ПроверялиНеобходимостьПоказаПредупреждения = Ложь;
				
		Элементы.ОК.Видимость = Ложь;
		Элементы.Отмена.Видимость = Ложь;
		Элементы.ГруппаЗапись.Видимость = Ложь;
		
		Элементы.ГруппаВыборПолучателя.Видимость = Истина;
		
		Если ЗначениеЗаполнено(Запись.Получатель) Тогда
			
			Элементы.ТаблицаПолучателей.ТекущаяСтрока = Запись.Получатель;
						
		КонецЕсли;
		
	Иначе
				
		Элементы.ГруппаИнфоВыбораПолучателя.Видимость = Ложь;
		
		Элементы.ГруппаВыборПолучателя.Видимость = Ложь;
		
		Элементы.ГруппаЗапись.Видимость = Истина;	
		Элементы.Отмена.Видимость = Истина;
		Элементы.ОК.Видимость = Истина;
		
	КонецЕсли; 
	
КонецПроцедуры


&НаСервере
Функция ПолучитьИмяФормыОбъектаЭлементаСсылки(ИмяЭлементаСсылки, ЗначениеСсылка = Неопределено)
	
	ЗначениеСсылка = РегламентированнаяОтчетностьАЛКО.ПолучитьЗначениеЭлементаФормы(ЭтаФорма, ИмяЭлементаСсылки);	
	ИмяФормыОбъекта = РегламентированнаяОтчетностьАЛКО.ПолучитьИмяФормыОбъекта(ЗначениеСсылка);
	
	Возврат ИмяФормыОбъекта;
	
КонецФункции


&НаКлиенте
Процедура НажатиеГиперссылки(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ИмяЭлементаСсылки = Элемент.Имя;
	
	ЗначениеСсылка = Неопределено;
	ИмяФормыОбъекта = ПолучитьИмяФормыОбъектаЭлементаСсылки(ИмяЭлементаСсылки, ЗначениеСсылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НажатиеГиперссылкиЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ЗначениеСсылка);
	ОткрытаяФормаПотомокСБлокировкойВладельца = ОткрытьФорму(ИмяФормыОбъекта, ПараметрыФормы, 
			ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры


&НаКлиенте
Процедура НажатиеГиперссылкиЗавершение(Результат, ДопПараметры) Экспорт
	
	ОткрытаяФормаПотомокСБлокировкойВладельца = Неопределено;
	
	Если ПоказыватьПредупреждениеПослеПереходаПоссылке = Неопределено Тогда
	    ПоказыватьПредупреждениеПослеПереходаПоссылке = Истина;	
	КонецЕсли;
	
	Если ПоказыватьПредупреждениеПослеПереходаПоссылке Тогда
	    // Открываем форму предупреждения.
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru='Внимание!'"));
		ПараметрыФормы.Вставить("ТекстПредупреждения", НСтр("ru='"
				+ "Если Вы внесли изменения в элемент справочника или документ,"
				+ " следует учесть, что изменения автоматически обновятся только"
				+ " в текущей редактируемой строке таблицы отчета.'"));
		ПараметрыФормы.Вставить("ТекстЗаголовкаФлажка", НСтр("ru='Больше не показывать в этом сеансе редактирования'"));
		ПараметрыФормы.Вставить("УникальностьФормы",       		УникальностьФормы);
		
		ИмяФормыПредупреждения = "ОбщаяФорма.АЛКОФормаПредупрежденияСФлажком";
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьСостояниеФлажкаФормыПредупреждения", ЭтотОбъект);
		ОткрытьФорму(ИмяФормыПредупреждения, ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьСостояниеФлажкаФормыПредупреждения(Результат, ДопПараметры) Экспорт
	
	Если (НЕ Результат = Неопределено) и Результат Тогда
		// Оповещаем форму отчета владельца о том, что больше показывать
		// предупреждение не надо.
		ПоказыватьПредупреждениеПослеПереходаПоссылке = Ложь;
		Оповестить("ПоказыватьПредупреждениеПослеПереходаПоСсылке", , УникальностьФормы);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ТаблицаПолучателейВыборНаСервере(НаименованиеПолное, ИНН, КПП)
			
	ИНН = СокрЛП(ИНН);
	КПП = СокрЛП(КПП);
	НаименованиеПолное = СокрЛП(НаименованиеПолное);
	
	Запись.П000010000306 = ИНН;
	Запись.П000010000307 = КПП;	
	Запись.П000010000304 = НаименованиеПолное;
			
			
	// Анализ изменений Получателя.
		
	Получатель = ОбъектОтчета(ИмяФормыВладельца).ОпределитьПолучателя(ИНН, КПП, НаименованиеПолное);
	
	// Если Получатель изменился - поменяем адрес.
	Если (Получатель <> Запись.Получатель) 
		ИЛИ (НЕ ЗначениеЗаполнено(Запись.П000010000305)) Тогда
	
		Запись.Получатель = Получатель;
		
        // Нужно определить адрес.
		ПредставлениеАдреса = Неопределено;
		
		СписокВидовКонтактнойИнформации = Новый СписокЗначений;
		СписокВидовКонтактнойИнформации.Добавить("ЮрАдресКонтрагента");
		СписокВидовКонтактнойИнформации.Добавить("ФактАдресКонтрагента");
		СписокВидовКонтактнойИнформации.Добавить("ПочтовыйАдресКонтрагента");
		СписокВидовКонтактнойИнформации.Добавить("ЮрАдресОрганизации");
		СписокВидовКонтактнойИнформации.Добавить("АдресПоПропискеФизическиеЛица");
		СписокВидовКонтактнойИнформации.Добавить("АдресМестаПроживанияФизическиеЛица");
				
		АдресXML = РегламентированнаяОтчетностьАЛКО.ПолучитьАдресXMLОбъекта(Получатель, ПредставлениеАдреса, 
														СписокВидовКонтактнойИнформации, Истина, ДатаПодписи);
							
									
		Запись.П000010000305 = ПредставлениеАдреса;
		Запись.П000010000305XML = АдресXML;
		
		ФормированиеПредставленийНаСервере();
		
	КонецЕсли; 
				
	УправлениеВидимостью(Ложь);
	
	ОбработкаПослеИзменения();
	
КонецПроцедуры

#КонецОбласти
