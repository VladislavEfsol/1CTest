&НаКлиенте
Процедура ВыбратьСтрокуИЗакрытьФорму()
	
	ДанныеТекущейСтроки = Элементы.Источник.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено
		ИЛИ ПустаяСтрока(ДанныеТекущейСтроки.ПредставлениеПоля) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураВыбора = Новый Структура;
	СтруктураВыбора.Вставить("Источник",			ДанныеТекущейСтроки.Источник);
	СтруктураВыбора.Вставить("ОписаниеПоля",		ДанныеТекущейСтроки.ОписаниеПоля);
	СтруктураВыбора.Вставить("ИмяПоля",				ДанныеТекущейСтроки.ИмяПоля);
	СтруктураВыбора.Вставить("ПредставлениеПоля",	ДанныеТекущейСтроки.ПредставлениеПоля);
	
	Закрыть(СтруктураВыбора);
	
КонецПроцедуры

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДеревоЗначений = Новый ДеревоЗначений;
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Строка"));
	КС = Новый КвалификаторыСтроки(100);
	ОписаниеСтрока = Новый ОписаниеТипов(МассивТипов, КС);
	КолонкиСостава = ДеревоЗначений.Колонки;
	
	КолонкиСостава.Добавить("ОписаниеПоля", 		ОписаниеСтрока);
	КолонкиСостава.Добавить("ПредставлениеПоля", 	ОписаниеСтрока);
	КолонкиСостава.Добавить("Источник", 			ОписаниеСтрока);
	КолонкиСостава.Добавить("ИмяПоля", 				ОписаниеСтрока);

 	НовыйИсточник = ДеревоЗначений.Строки.Добавить();
	НовыйИсточник.ОписаниеПоля = "Учетная информация";

	Для Каждого МетаданныеРегистр Из Метаданные.РегистрыНакопления Цикл

		Если МетаданныеРегистр.Ресурсы.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Источники = НовыйИсточник.Строки.Добавить();
		Источники.Источник 		= "РегистрНакопления." + МетаданныеРегистр.Имя;
		Источники.ОписаниеПоля 	= МетаданныеРегистр.Представление();
		
		ИсточникТаблица = Источники.Строки.Добавить();
		ИсточникТаблица.Источник 			= "РегистрНакопления." + МетаданныеРегистр.Имя;
		ИсточникТаблица.ОписаниеПоля 		= "Движения";
		
		Если МетаданныеРегистр.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
			
			ИсточникТаблицаПриход = ИсточникТаблица.Строки.Добавить();
			ИсточникТаблицаПриход.Источник 			= "РегистрНакопления." + МетаданныеРегистр.Имя;
			ИсточникТаблицаПриход.ПредставлениеПоля = МетаданныеРегистр.Представление() + " движения: приход";
			ИсточникТаблицаПриход.ОписаниеПоля 		= "движения: приход";		
			ИсточникТаблицаПриход.ИмяПоля 			= МетаданныеРегистр.Имя + "ДвиженияПриход";
			
			ИсточникТаблицаРасход = ИсточникТаблица.Строки.Добавить();
			ИсточникТаблицаРасход.Источник 			= "РегистрНакопления." + МетаданныеРегистр.Имя;
			ИсточникТаблицаРасход.ПредставлениеПоля	= МетаданныеРегистр.Представление() + " движения: расход";
			ИсточникТаблицаРасход.ОписаниеПоля 		= "движения: расход";		
			ИсточникТаблицаРасход.ИмяПоля 			= МетаданныеРегистр.Имя + "ДвиженияРасход";
			
		Иначе
			
			ИсточникТаблицаДвижение = ИсточникТаблица.Строки.Добавить();
			ИсточникТаблицаДвижение.Источник 			= "РегистрНакопления." + МетаданныеРегистр.Имя;
			ИсточникТаблицаДвижение.ПредставлениеПоля 	= МетаданныеРегистр.Представление() + " движения: оборот";
			ИсточникТаблицаДвижение.ОписаниеПоля 		= "движения: оборот";		
			ИсточникТаблицаДвижение.ИмяПоля 			= МетаданныеРегистр.Имя + "ДвиженияОборот";

		КонецЕсли;
		
		Если МетаданныеРегистр.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда

			ИсточникТаблица = Источники.Строки.Добавить();
			ИсточникТаблица.Источник 			= "РегистрНакопления." + МетаданныеРегистр.Имя + ".Остатки(&МоментВремени,)";
			ИсточникТаблица.ПредставлениеПоля	= МетаданныеРегистр.Представление() + ": остатки";
			ИсточникТаблица.ОписаниеПоля		= "Остатки";
			ИсточникТаблица.ИмяПоля				= МетаданныеРегистр.Имя + "Остатки";

			ИсточникТаблица = Источники.Строки.Добавить();
			ИсточникТаблица.Источник 			= "РегистрНакопления." + МетаданныеРегистр.Имя + ".Обороты(&НачалоПериода,&КонецПериода,Авто,)";
			ИсточникТаблица.ПредставлениеПоля 	= МетаданныеРегистр.Представление() + ": обороты";
			ИсточникТаблица.ОписаниеПоля 		= "Обороты";
			ИсточникТаблица.ИмяПоля				= МетаданныеРегистр.Имя+"Обороты";

			ИсточникТаблица = Источники.Строки.Добавить();
			ИсточникТаблица.Источник 			= "РегистрНакопления." + МетаданныеРегистр.Имя + ".ОстаткиИОбороты(&НачалоПериода,&КонецПериода,Авто,,)";
			ИсточникТаблица.ПредставлениеПоля 	= МетаданныеРегистр.Представление() + ": остатки и обороты";
			ИсточникТаблица.ОписаниеПоля 		= "Остатки и обороты";
			ИсточникТаблица.ИмяПоля				= МетаданныеРегистр.Имя + "ОстаткиИОбороты";

		Иначе

			ИсточникТаблица = Источники.Строки.Добавить();
			ИсточникТаблица.Источник 			= "РегистрНакопления." + МетаданныеРегистр.Имя + ".Обороты(&НачалоПериода,&КонецПериода,Авто,)";
			ИсточникТаблица.ПредставлениеПоля 	= МетаданныеРегистр.Представление() + ": обороты";
			ИсточникТаблица.ОписаниеПоля 		= "Обороты";
			ИсточникТаблица.ИмяПоля 			= МетаданныеРегистр.Имя + "Обороты";

		КонецЕсли;

	КонецЦикла;

	НовыйИсточник = ДеревоЗначений.Строки.Добавить();
	НовыйИсточник.ОписаниеПоля = "Справочная информация";

	Для Каждого МетаданныеРегистр Из Метаданные.РегистрыСведений Цикл

		ЧисловыхРесурсов = 0;

		Для каждого Ресурс Из МетаданныеРегистр.Ресурсы Цикл	

			ТипыРесурса = Ресурс.Тип.Типы();

			Если ТипыРесурса.Количество() = 1 И ТипыРесурса[0] = Тип("Число") Тогда
				ЧисловыхРесурсов = ЧисловыхРесурсов + 1;
			КонецЕсли;
		
		КонецЦикла; 
		
		Если ЧисловыхРесурсов = 0 Тогда
			Продолжить;
		КонецЕсли;

		Источники = НовыйИсточник.Строки.Добавить();

		Если Строка(МетаданныеРегистр.ПериодичностьРегистраСведений) = "Непериодический" Тогда
			Источники.Источник = "РегистрСведений." + МетаданныеРегистр.Имя;
		Иначе
			Источники.Источник = "РегистрСведений." + МетаданныеРегистр.Имя + ".СрезПоследних(&МоментВремени,)";
		КонецЕсли;
		
		Источники.ПредставлениеПоля = МетаданныеРегистр.Представление();
		Источники.ОписаниеПоля 		= МетаданныеРегистр.Представление();
		Источники.ИмяПоля 			= МетаданныеРегистр.Имя;

	КонецЦикла;	
	
	НовыйИсточник = ДеревоЗначений.Строки.Добавить();
	НовыйИсточник.ОписаниеПоля = "Остатки и обороты по планам счетов";

	Для Каждого МетаданныеРегистр Из Метаданные.РегистрыБухгалтерии Цикл

		Если МетаданныеРегистр.Ресурсы.Количество()=0 Тогда
			
			Продолжить;
			
		КонецЕсли;

		РегистрИсточник	= НовыйИсточник.Строки.Добавить();
		РегистрИсточник.Источник = "РегистрБухгалтерии." + МетаданныеРегистр.Имя;
		РегистрИсточник.ОписаниеПоля = МетаданныеРегистр.Представление();

		РегистрИсточникТаблица = РегистрИсточник.Строки.Добавить();
		РегистрИсточникТаблица.Источник = "РегистрБухгалтерии." + МетаданныеРегистр.Имя + ".Обороты(&НачалоПериода,&КонецПериода,День,,)";
		РегистрИсточникТаблица.ПредставлениеПоля = МетаданныеРегистр.Представление() + ": обороты";
		РегистрИсточникТаблица.ОписаниеПоля = "Обороты";
		РегистрИсточникТаблица.ИмяПоля = МетаданныеРегистр.Имя + "Обороты";
		
		РегистрИсточникТаблица = РегистрИсточник.Строки.Добавить();
		РегистрИсточникТаблица.Источник = "РегистрБухгалтерии." + МетаданныеРегистр.Имя + ".Остатки(&МоментВремени,,) ";
		РегистрИсточникТаблица.ПредставлениеПоля = МетаданныеРегистр.Представление() + ": остатки";
		РегистрИсточникТаблица.ОписаниеПоля = "Остатки";
		РегистрИсточникТаблица.ИмяПоля = МетаданныеРегистр.Имя + "Остатки";

		РегистрИсточникТаблица = РегистрИсточник.Строки.Добавить();
		РегистрИсточникТаблица.Источник = "РегистрБухгалтерии." + МетаданныеРегистр.Имя + ".ОстаткиИОбороты(&НачалоПериода,&КонецПериода,День,,) ";
		РегистрИсточникТаблица.ПредставлениеПоля = МетаданныеРегистр.Представление() + ": остатки и обороты";
		РегистрИсточникТаблица.ОписаниеПоля = "Остатки и обороты";
		РегистрИсточникТаблица.ИмяПоля = МетаданныеРегистр.Имя + "ОстаткиИОбороты";

	КонецЦикла;
	
	ЭтаФорма.ЗначениеВРеквизитФормы(ДеревоЗначений, "Источник");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПодключитьОбработчикОжидания("ВыбратьСтрокуИЗакрытьФорму", 0.1, Истина)
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтроку(Команда)
	
	ВыбратьСтрокуИЗакрытьФорму();
	
КонецПроцедуры