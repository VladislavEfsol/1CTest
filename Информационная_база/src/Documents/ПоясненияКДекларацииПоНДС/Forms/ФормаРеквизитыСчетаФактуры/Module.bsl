
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НомерСчетаФактуры = Параметры.НомерСчетаФактуры;
	ДатаСчетаФактуры  = Параметры.ДатаСчетаФактуры;
	НомерИсправленияСчетаФактуры = Параметры.НомерИсправленияСчетаФактуры;
	ДатаИсправленияСчетаФактуры  = Параметры.ДатаИсправленияСчетаФактуры;
	НомерКорректировочногоСчетаФактуры = Параметры.НомерКорректировочногоСчетаФактуры;
	ДатаКорректировочногоСчетаФактуры  = Параметры.ДатаКорректировочногоСчетаФактуры;
	НомерИсправленияКорректировочногоСчетаФактуры = Параметры.НомерИсправленияКорректировочногоСчетаФактуры;
	ДатаИсправленияКорректировочногоСчетаФактуры  = Параметры.ДатаИсправленияКорректировочногоСчетаФактуры;
	
	СтандартныйСчетФактура = НЕ ЗначениеЗаполнено(НомерКорректировочногоСчетаФактуры);
	Исправление                              = НомерИсправленияСчетаФактуры <> 0;
	ИсправлениеКорректировочногоСчетаФактуры = НомерИсправленияКорректировочногоСчетаФактуры <> 0;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Реквизиты счета-фактуры (строка декларации %1)'"),
		Параметры.НомерСтрокиДекларации);
	
	Если ТолькоПросмотр Тогда
		Элементы.ФормаЗаписатьИЗакрыть.Видимость = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда 
		
		Если НЕ ПеренестиВДокумент Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Отменить изменения?'");
	
			ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
				ЭтотОбъект, 
				Отказ, 
				ЗавершениеРаботы,
				ТекстПредупреждения, 
				"ПеренестиВДокумент");
			
		ИначеЕсли Не Отказ Тогда
			Отказ = НЕ ПроверитьЗаполнениеНаКлиенте();
			Если Отказ Тогда
				ПеренестиВДокумент = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтандартныйСчетФактураПриИзменении(Элемент)
	
	Если СтандартныйСчетФактура Тогда
		ДатаИсправленияКорректировочногоСчетаФактуры = Дата(1,1,1);
		ДатаКорректировочногоСчетаФактуры = Дата(1,1,1);
		НомерИсправленияКорректировочногоСчетаФактуры = "";
		НомерКорректировочногоСчетаФактуры = "";
		ИсправлениеКорректировочногоСчетаФактуры = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправлениеПриИзменении(Элемент)
	
	ПриИзмененииПризнакаИсправления();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправлениеКорректировочногоПриИзменении(Элемент)
	
	Если НЕ ИсправлениеКорректировочногоСчетаФактуры Тогда
		НомерИсправленияКорректировочногоСчетаФактуры = 0;
		ДатаИсправленияКорректировочногоСчетаФактуры  = '00010101';
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьИсправлениеИсходногоПриИзменении(Элемент)
	
	ПриИзмененииПризнакаИсправления();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Если ПроверитьЗаполнениеНаКлиенте() Тогда 
		РезультатЗакрытия = ВернутьСтруктуруЗакрытия();
		ОповеститьОВыборе(РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть(Неопределено)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.СтандартныйСчетФактура Тогда 
		Элементы.СтраницыВидыСчетовФактур.ТекущаяСтраница = Элементы.СтраницаСчетФактура;
	Иначе
		Элементы.СтраницыВидыСчетовФактур.ТекущаяСтраница = Элементы.СтраницаКорректировочныйСчетФактура;
	КонецЕсли;
		
	Элементы.НомерИсправления.Доступность = Форма.Исправление;
	Элементы.ДатаИсправления.Доступность  = Форма.Исправление;
	
	Элементы.НомерИсправленияКорректировочного.Доступность = Форма.ИсправлениеКорректировочногоСчетаФактуры;
	Элементы.ДатаИсправленияКорректировочного.Доступность  = Форма.ИсправлениеКорректировочногоСчетаФактуры;
	
	Элементы.НомерИсправленияИсходного.Доступность =  Форма.Исправление;
	Элементы.ДатаИсправленияИсходного.Доступность  =  Форма.Исправление;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеНаКлиенте()

	Отказ = Ложь;
	
	Если СтандартныйСчетФактура Тогда 
		Если Не ЗначениеЗаполнено(НомерСчетаФактуры) Тогда 
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Номер счета-фактуры'"));
			Поле = "НомерСчетаФактуры";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
			
		Если Не ЗначениеЗаполнено(ДатаСчетаФактуры) Тогда 
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Дата счета-фактуры'"));
			Поле = "ДатаСчетаФактуры";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
			
		Если Исправление Тогда 
			Если Не ЗначениеЗаполнено(НомерИсправленияСчетаФактуры) Тогда 
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Номер исправления счета-фактуры'"));
				Поле = "НомерИсправленияСчетаФактуры";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);		
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ДатаИсправленияСчетаФактуры) Тогда 
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Дата исправления счета-фактуры'"));
				Поле = "ДатаИсправленияСчетаФактуры";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);		
			КонецЕсли;
		КонецЕсли;
			
	Иначе
		Если Не ЗначениеЗаполнено(НомерКорректировочногоСчетаФактуры) Тогда 
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Номер корректировочного счета-фактуры'"));
			Поле = "НомерКорректировочногоСчетаФактуры";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);		
		КонецЕсли;
			
		Если Не ЗначениеЗаполнено(ДатаКорректировочногоСчетаФактуры) Тогда 
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Дата корректировочного счета-фактуры'"));
			Поле = "ДатаКорректировочногоСчетаФактуры";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);		
		КонецЕсли;
			
		Если ИсправлениеКорректировочногоСчетаФактуры Тогда 
			Если Не ЗначениеЗаполнено(НомерИсправленияКорректировочногоСчетаФактуры) Тогда 
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Номер исправления корректировочного счета-фактуры'"));
				Поле = "НомерИсправленияКорректировочного";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);		
			КонецЕсли;
				
			Если Не ЗначениеЗаполнено(ДатаИсправленияКорректировочногоСчетаФактуры) Тогда 
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Дата исправления корректировочного счета-фактуры'"));
				Поле = "ДатаИсправленияКорректировочного";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);		
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(НомерСчетаФактуры) Тогда 
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Номер корректируемого счета-фактуры'"));
			Поле = "НомерИсходногоДокумента";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);				
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДатаСчетаФактуры) Тогда 
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Дата корректируемого счета-фактуры'"));
			Поле = "ДатаИсходногоДокумента";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);				
		КонецЕсли;
		
		Если Исправление Тогда 
			Если Не ЗначениеЗаполнено(НомерИсправленияСчетаФактуры) Тогда 
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Номер исправления счета-фактуры'"));
				Поле = "НомерИсправленияИсходного";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);		
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ДатаИсправленияСчетаФактуры) Тогда 
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Дата исправления счета-фактуры'"));
				Поле = "ДатаИсправленияИсходного";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);		
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииПризнакаИсправления()
	
	Если НЕ Исправление Тогда
		НомерИсправленияСчетаФактуры = 0;
		ДатаИсправленияСчетаФактуры  = '00010101';
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ВернутьСтруктуруЗакрытия()
	
	Структура = Новый Структура();
	
	Структура.Вставить("НомерСтрокиДокумента",		НомерСтрокиДокумента);
	
	Структура.Вставить("ДатаСчетаФактуры",			ДатаСчетаФактуры);
	Структура.Вставить("НомерСчетаФактуры",			НомерСчетаФактуры);
	Структура.Вставить("НомерИсправленияСчетаФактуры",	НомерИсправленияСчетаФактуры);
	Структура.Вставить("ДатаИсправленияСчетаФактуры",	ДатаИсправленияСчетаФактуры);
	Структура.Вставить("НомерКорректировочногоСчетаФактуры",	НомерКорректировочногоСчетаФактуры);
	Структура.Вставить("ДатаКорректировочногоСчетаФактуры",		ДатаКорректировочногоСчетаФактуры);
	Структура.Вставить("НомерИсправленияКорректировочногоСчетаФактуры",	НомерИсправленияКорректировочногоСчетаФактуры);
	Структура.Вставить("ДатаИсправленияКорректировочногоСчетаФактуры",	ДатаИсправленияКорректировочногоСчетаФактуры);
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти