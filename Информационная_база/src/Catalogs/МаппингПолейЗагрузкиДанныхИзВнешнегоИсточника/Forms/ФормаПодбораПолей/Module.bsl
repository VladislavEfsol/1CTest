
#Область СлужебныеМетоды

&НаСервере
Процедура ДоступныеПоляЗагрузкиДанныхИзВнешнегоИсточника(ВыбранныеПоля)
	
	ДоступныеПоляЗагрузки = Справочники.МаппингПолейЗагрузкиДанныхИзВнешнегоИсточника.ДоступныеПоляЗагрузкиДанныхИзВнешнегоИсточника(ОбъектЗагрузки, ИмяТабличнойЧасти, Истина);
	Для каждого ЭлементСтруктуры Из ДоступныеПоляЗагрузки Цикл
		
		НоваяСтрока = МаппингПолей.Добавить();
		
		Если ТипЗнч(ЭлементСтруктуры.Значение) = Тип("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения") Тогда
			
			НоваяСтрока.ДополнительныйРеквизит = ЭлементСтруктуры.Значение;
			НоваяСтрока.Отметка = (ВыбранныеПоля.Найти(НоваяСтрока.ДополнительныйРеквизит) <> Неопределено);
			
		Иначе
			
			НоваяСтрока.ИмяПоля = ЭлементСтруктуры.Ключ;
			НоваяСтрока.Отметка = (ВыбранныеПоля.Найти(НоваяСтрока.ИмяПоля) <> Неопределено);
			
		КонецЕсли;
		
		НоваяСтрока.ПредставлениеПоля = Строка(ЭлементСтруктуры.Значение);
		НоваяСтрока.ЭтоПолеВыбрано = НоваяСтрока.Отметка;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеПолей()
	
	//::: ТолькоПросмотр
	ЭлементУО1 = УсловноеОформление.Элементы.Добавить();
	ЭлементУО1.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	ЭлементУО1.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("МаппингПолейОтметка");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО1.Отбор, "МаппингПолей.ЭтоПолеВыбрано", ВидСравненияКомпоновкиДанных.Равно, Истина, , Истина);
	
	
	//::: Цвет
	ЭлементУО2 = УсловноеОформление.Элементы.Добавить();
	ЭлементУО2.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(180, 180, 180));
	ЭлементУО2.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("МаппингПолейПредставлениеПоля");
	ЭлементУО2.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("МаппингПолейИмяПоля");
	ЭлементУО2.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("МаппингПолейЭтоПолеВыбрано");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО2.Отбор, "МаппингПолей.ЭтоПолеВыбрано", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	//::: Дополнительные реквизиты
	ЭлементУО3 = УсловноеОформление.Элементы.Добавить();
	ЭлементУО3.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(30, 100, 150));
	ЭлементУО3.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("МаппингПолейПредставлениеПоля");
	ЭлементУО3.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("МаппингПолейИмяПоля");
	ЭлементУО3.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("МаппингПолейЭтоПолеВыбрано");
	
	ГруппаУсловий = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ЭлементУО3.Отбор.Элементы, "ГруппаУсловий", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаУсловий, "МаппингПолей.ЭтоПолеВыбрано",ВидСравненияКомпоновкиДанных.НеРавно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаУсловий, "МаппингПолей.ИмяПоля",		ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ОбъектЗагрузки", ОбъектЗагрузки) Тогда
		
		Отказ = Истина;
		ВызватьИсключение НСтр("ru ='Для подбора полей необходимо указать объект, в который будут загружаться данные из внешнего источника.'");
		
	КонецЕсли;
	
	Параметры.Свойство("ИмяТабличнойЧасти", ИмяТабличнойЧасти);
	
	ДоступныеПоляЗагрузкиДанныхИзВнешнегоИсточника(Параметры.ВыбранныеПоля);
	УстановитьУсловноеОформлениеПолей();
	
КонецПроцедуры

#КонецОбласти

#Область ЭлементыФормы



#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбранныеПоля = Новый Соответствие;
	Для каждого СтрокаТаблицы Из МаппингПолей Цикл
		
		Если СтрокаТаблицы.ЭтоПолеВыбрано 
			ИЛИ СтрокаТаблицы.Отметка = Ложь Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ВыбранныеПоля.Вставить(?(ПустаяСтрока(СтрокаТаблицы.ИмяПоля), СтрокаТаблицы.ДополнительныйРеквизит, СтрокаТаблицы.ИмяПоля), СтрокаТаблицы.ПредставлениеПоля);
		
	КонецЦикла;
	
	Закрыть(ВыбранныеПоля);
	
КонецПроцедуры

#КонецОбласти
