////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Физлицо") Тогда
		Физлицо = Параметры.Отбор.Физлицо;
		
		УдостоверениеЛичности = РегистрыСведений.ДокументыФизическихЛиц.ДокументУдостоверяющийЛичностьФизлица(Физлицо);
		
		ЕстьУдостоверение = Не ПустаяСтрока(УдостоверениеЛичности);
		
		Элементы.УдостоверениеЛичности.Высота		= ?(ЕстьУдостоверение, 2, 0);
		УдостоверениеЛичности = ?(ЕстьУдостоверение, "Удостоверение личности: ", "") + УдостоверениеЛичности;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Физлицо",	Физлицо);
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДокументыФизическихЛиц.Представление
		|ИЗ
		|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
		|ГДЕ
		|	ДокументыФизическихЛиц.Физлицо = &Физлицо";
		ЕстьДокументы = Не Запрос.Выполнить().Пустой();
		
		Если Не ЕстьУдостоверение И ЕстьДокументы Тогда
			Элементы.НетУдостоверения.Видимость		= Истина;
			ТекстСообщения = НСтр("ru = 'Для физлица %1 не задан документ, удостоверяющий личность.'");
			УдостоверениеЛичности = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Физлицо);
		КонецЕсли;
		
		Элементы.УдостоверениеЛичности.Видимость	= Не ПустаяСтрока(УдостоверениеЛичности);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	Оповестить("ИзменилсяДокументФизЛиц");
КонецПроцедуры

