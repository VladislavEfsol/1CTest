
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("АдресСхемы", АдресСхемыКомпоновкиДанных);
	Параметры.Свойство("АдресНастроек", АдресНастроек);
	Параметры.Свойство("ТипЗначения", ТипЗначения);
	Если НЕ ПустаяСтрока(АдресСхемыКомпоновкиДанных) И НЕ ПустаяСтрока(АдресНастроек) Тогда
		Настройки = ПолучитьИзВременногоХранилища(АдресНастроек);
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
		КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	КонецЕсли;
	Параметры.Свойство("Поле", Поле);
	ЭтаФорма.ЗакрыватьПриВыборе = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Поле) Тогда
		ПолеКомпоновки = Новый ПолеКомпоновкиДанных(Поле);
		Найден = Ложь;
		Для каждого ЭлементУО Из КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
			Для каждого ПолеУО Из ЭлементУО.Поля.Элементы Цикл
				Если ПолеКомпоновки=ПолеУО.Поле Тогда
					Найден = Истина;
					Прервать;
				КонецЕсли; 
			КонецЦикла;
			Если Найден Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла;
		Если НЕ Найден Тогда
			ЭлементУО = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
			ПолеУО = ЭлементУО.Поля.Элементы.Добавить();
			ПолеУО.Поле = ПолеКомпоновки;
			ПолеУО.Использование = Истина;
		КонецЕсли;
		#Если НЕ ВебКлиент И НЕ МобильныйКлиент Тогда
		Элементы.КомпоновщикНастроекНастройкиУсловноеОформление.ТекущаяСтрока = ЭлементУО;
		#КонецЕсли 
	КонецЕсли; 
	
КонецПроцедуры
  
#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Закрыть(ПоместитьВоВременноеХранилище(КомпоновщикНастроек.Настройки, АдресНастроек));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВБыстрыхНастройках(Команда)
	
	ТекСтр = Элементы.КомпоновщикНастроекНастройкиУсловноеОформление.ТекущиеДанные;
	Если ТекСтр=Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ИмяНастройки = "";
	Оповещение = Новый ОписаниеОповещения("СохранитьВБыстрыхНастройкахЗавершение", ЭтотОбъект, Новый Структура("ИмяНастройки", ИмяНастройки));
	ПоказатьВводСтроки(Оповещение, ИмяНастройки, НСтр("ru = 'Имя настройки'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВБыстрыхНастройкахЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ИмяНастройки = ?(Результат = Неопределено, ДополнительныеПараметры.ИмяНастройки, Результат);
    
    Если НЕ (Результат <> Неопределено) Тогда
        Возврат;
    КонецЕсли;
    СохранитьВБыстрыхНастройкахНаСервере(ИмяНастройки, Элементы.КомпоновщикНастроекНастройкиУсловноеОформление.ТекущаяСтрока);

КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьВБыстрыхНастройкахНаСервере(ИмяНастройки, Идентификатор)
	
	ПредставлениеТипа = Строка(ТипЗначения.Типы().Получить(0));
	ТекСтр = КомпоновщикНастроек.Настройки.УсловноеОформление.ПолучитьОбъектПоИдентификатору(Идентификатор);
	ТекСписок = ХранилищеСистемныхНастроек.Загрузить("БыстрыеНастройкиОформленияОтчетов", ПредставлениеТипа);
	Если НЕ ТипЗнч(ТекСписок)=Тип("СписокЗначений") Тогда
		ТекСписок = Новый СписокЗначений;
	КонецЕсли; 
	ТекСписок.Добавить(ОформлениеВСтруктуру(ТекСтр.Оформление), ИмяНастройки);
	ТекСписок.СортироватьПоПредставлению();
	ХранилищеСистемныхНастроек.Сохранить("БыстрыеНастройкиОформленияОтчетов", ПредставлениеТипа, ТекСписок);
	
КонецПроцедуры

// Возвращает соответствие элементов условного оформления
//	Тип возвращаемого значения: Соответствие - содержит измененные элементы условного оформления 
//
// Параметры:
//  Оформление - НастройкаОформления - НАстройка оформления, которую нужно разложить в соответствие
//
&НаСервере
Функция ОформлениеВСтруктуру(Оформление)
	
	Результат = Новый Структура;
	Для каждого Элемент Из Оформление.Элементы Цикл
		Если НЕ Элемент.Использование Тогда
			Продолжить;
		КонецЕсли; 
		Результат.Вставить(Строка(Элемент.Параметр),Элемент.Значение);
	КонецЦикла; 
	Возврат Результат;
	
КонецФункции 

#КонецОбласти
 
