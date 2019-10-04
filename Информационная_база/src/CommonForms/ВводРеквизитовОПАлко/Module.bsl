
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
	    Возврат;
	КонецЕсли;
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	
	ОбрабатываемыеДанные= Новый Структура;
	
	ОбрабатываемыеДанные.Вставить("Наименование", "");
	
	ОбрабатываемыеДанные.Вставить("КПП",          "");
	
	ОбрабатываемыеДанные.Вставить("Страна",          "РОССИЯ");
	ОбрабатываемыеДанные.Вставить("Индекс",          "");
	ОбрабатываемыеДанные.Вставить("Регион",          "");
	ОбрабатываемыеДанные.Вставить("КодРегиона",      "");
	ОбрабатываемыеДанные.Вставить("Район",           "");
	ОбрабатываемыеДанные.Вставить("Город",           "");
	ОбрабатываемыеДанные.Вставить("НаселенныйПункт", "");
	ОбрабатываемыеДанные.Вставить("Улица",           "");
	ОбрабатываемыеДанные.Вставить("Дом",             "");
	ОбрабатываемыеДанные.Вставить("Корпус",          "");
	ОбрабатываемыеДанные.Вставить("Литера",     	 "");
	ОбрабатываемыеДанные.Вставить("Квартира",        "");
	
	
	ОбрабатываемыеДанные.Вставить("ПредставлениеАдреса", "");
	ОбрабатываемыеДанные.Вставить("АдресXML", "");
	
	Если ТипЗнч(Параметры.СведенияОбОП) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ОбрабатываемыеДанные, Параметры.СведенияОбОП);
		ОбрабатываемыеДанные.Вставить("Регион", РегламентированнаяОтчетностьВызовСервера.ПолучитьНазваниеРегионаПоКоду(Параметры.СведенияОбОП.КодРегиона));
	КонецЕсли;

	Наименование = ОбрабатываемыеДанные.Наименование;
	
	Если Параметры.ЭтоПБОЮЛ Тогда
	    КПП = "";
		Элементы.КПП.Видимость = Ложь;
		Заголовок = "Реквизиты объекта торговли";
	Иначе
		КПП = ОбрабатываемыеДанные.КПП;
		Заголовок = "Реквизиты обособленного подразделения";
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Параметры.Заголовок) Тогда
	    Заголовок = Параметры.Заголовок;	
	КонецЕсли; 
	
	СправочникиВидыКонтактнойИнформацииФактАдресОрганизации = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации;
	
	АдресПредставление = ВывестиПредставлениеАдреса(ОбрабатываемыеДанные);
	
	ОбновитьЦветаСсылок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
	    Отказ = Истина;
		ТекстПредупреждения = НСтр("ru='Данная форма вспомогательная, предназначена для редактирования данных
										|из форм регламентированных отчетов!'");
		ПоказатьПредупреждение(, ТекстПредупреждения, , НСтр("ru='Форма ввода реквизитов ОП.'"));
		Возврат;	
	КонецЕсли;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВывестиПредставлениеАдреса(СтруктураАдреса)
		
	ПредставлениеБезЗапятых = СтрЗаменить(СтруктураАдреса.ПредставлениеАдреса, ",", "");
	Если ЗначениеЗаполнено(ПредставлениеБезЗапятых) Тогда
		Результат = СтруктураАдреса.ПредставлениеАдреса;
	ИначеЕсли ЗначениеЗаполнено(СтруктураАдреса.АдресXML) Тогда
		
		Результат = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(СтруктураАдреса.АдресXML);
		Если ЗначениеЗаполнено(Результат) Тогда
		    СтруктураАдреса.ПредставлениеАдреса = Результат;
		Иначе	
		    Результат = "Ввести адрес";
		КонецЕсли; 
		
	Иначе		
		Результат = "Ввести адрес";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьЦветаСсылок()
		
	Элементы.Адрес.ЦветТекста = ?(АдресПредставление = "Ввести адрес", 
																ЦветСтиляНезаполненныйРеквизит, 
																ЦветСтиляЦветГиперссылкиБРО);
КонецПроцедуры

&НаКлиенте
Процедура АдресНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗначенияПолей = Неопределено;
	// Читаем сохраненную во внутреннем представлении структуру
	АдресXML = ОбрабатываемыеДанные.АдресXML;
	Если ЗначениеЗаполнено(АдресXML) Тогда
		Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(АдресXML) Тогда
		    ЗначенияПолей = АдресXML;						
		КонецЕсли;	     
	КонецЕсли;
	
	Если ЗначенияПолей = Неопределено Тогда	
	
        // если был сохранен в предыдущем варианте хранения
		ЗначенияПолей = Новый СписокЗначений;

		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Страна,          "Страна");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Индекс,          "Индекс");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.КодРегиона,      "КодРегиона");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Регион,          "Регион");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Район,           "Район");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Город,           "Город");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.НаселенныйПункт, "НаселенныйПункт");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Улица,           "Улица");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Дом,             "Дом");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Корпус,          "Корпус");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Литера,          "Литера");
		ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Квартира,        "Квартира");
		
	КонецЕсли;
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",               "Ввод адреса");
	ПараметрыФормы.Вставить("ЗначенияПолей", 		   ЗначенияПолей);
	ПараметрыФормы.Вставить("Представление", 		   ОбрабатываемыеДанные.ПредставлениеАдреса);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации", СправочникиВидыКонтактнойИнформацииФактАдресОрганизации);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(2);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	
	Оповещение = Новый (ТипЗначения, ПараметрыКонструктора);
	
	ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);

КонецПроцедуры

// Адрес - 	строка стандартного представления адреса УправлениеКонтактнойИнформацией
//			строка XDTO XML 
&НаСервереБезКонтекста
Функция ПолучитьСтруктуруАдресаОтчетаИзСтандартногоПредставленияИлиXML(Адрес)

	АдресВФорматеОтчета = Новый Структура;
	АдресВФорматеОтчета.Вставить("КодСтраны",       "643");
	АдресВФорматеОтчета.Вставить("Страна",       	"РОССИЯ");
	АдресВФорматеОтчета.Вставить("Индекс",          "");
	АдресВФорматеОтчета.Вставить("КодРегиона",      "");
	АдресВФорматеОтчета.Вставить("Регион",		    "");
	АдресВФорматеОтчета.Вставить("Район",           "");
	АдресВФорматеОтчета.Вставить("Город",           "");
	АдресВФорматеОтчета.Вставить("НаселенныйПункт", "");
	АдресВФорматеОтчета.Вставить("Улица",           "");
	АдресВФорматеОтчета.Вставить("Дом",             "");
	АдресВФорматеОтчета.Вставить("Корпус",          "");
	АдресВФорматеОтчета.Вставить("Литера",          "");
	АдресВФорматеОтчета.Вставить("Квартира",        "");
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(Адрес) Тогда
	    АдресXML = Адрес;
	Иначе	
	    // если адрес пуст - возвращаем пустую структуру
		Если ПустаяСтрока(СтрЗаменить(Адрес, ",","")) Тогда
		    Возврат АдресВФорматеОтчета;		
		КонецЕсли;
		
		Если СтрНайти(Адрес, "Страна=") > 0 Тогда
		    // старый формат хранения полей адреса
			АдресXML = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Адрес,, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);			
		Иначе
			Адрес = СтрЗаменить(Адрес, ".", "");		
	    	АдресXML = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению(Адрес, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
		КонецЕсли;
	КонецЕсли; 	

	СтруктураАдресаСМассивами = РаботаСАдресами.СведенияОбАдресе(АдресXML);
		
	СтрокаДома = "";
	Если СтруктураАдресаСМассивами.Свойство("Здание") Тогда
	
		Если СтруктураАдресаСМассивами.Здание.Количество() > 0 Тогда
			СтрокаДома = СтрокаДома + СтруктураАдресаСМассивами.Здание.ТипЗдания 
									+ " " + СтруктураАдресаСМассивами.Здание.Номер;
		КонецЕсли;	
	
	КонецЕсли; 
	
	СтруктураАдресаСМассивами.Вставить("Дом", СтрокаДома);
		
	СтрокаКорпуса = "";
	СтрокаЛитера  = "";
	Если СтруктураАдресаСМассивами.Свойство("Корпуса") Тогда
		
		МассивКорпусов = СтруктураАдресаСМассивами.Корпуса;
		КолвоЭлементовКорпусов = 0;
		
		Для Каждого ЭлМассива Из МассивКорпусов Цикл
			
			Если СокрЛП(ЭлМассива.ТипКорпуса) <> "Литера"  Тогда
				
			    КолвоЭлементовКорпусов = КолвоЭлементовКорпусов + 1;
				ТекКорпус = ЭлМассива.ТипКорпуса + " " + ЭлМассива.Номер;				
				СтрокаКорпуса = СтрокаКорпуса + ?(СтрокаКорпуса = "", "", ", ") + ТекКорпус;	
				
			Иначе
				СтрокаЛитера  = "" + ЭлМассива.Номер;
			КонецЕсли;		 
		    	
		КонецЦикла;
		
		
		Если (КолвоЭлементовКорпусов = 1) и (СтрНайти(СтрокаКорпуса, "Корпус") > 0) Тогда
		    СтрокаКорпуса = СокрЛП(СтрЗаменить(СтрокаКорпуса, "Корпус", ""));		
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураАдресаСМассивами.Вставить("Корпус", СтрокаКорпуса);
	СтруктураАдресаСМассивами.Вставить("Литера", СтрокаЛитера);

	СтрокаКвартира = "";
	КолвоЭлементовПомещений = 0;
	
	Если СтруктураАдресаСМассивами.Свойство("Помещения") Тогда
		
		МассивПомещений = СтруктураАдресаСМассивами.Помещения;
		
		Для Каждого ЭлМассива Из МассивПомещений Цикл
			
			КолвоЭлементовПомещений = КолвоЭлементовПомещений + 1;
			ТекПомещение = ЭлМассива.ТипПомещения + " " + ЭлМассива.Номер;			
			СтрокаКвартира = СтрокаКвартира + ?(СтрокаКвартира = "", "", ", ") + ТекПомещение; 
		    	
		КонецЦикла;
		
		Если (КолвоЭлементовПомещений = 1) и (СтрНайти(СтрокаКвартира, "Квартира") > 0) Тогда
		    СтрокаКвартира = СокрЛП(СтрЗаменить(СтрокаКвартира, "Квартира", ""));		
		КонецЕсли;
		
	КонецЕсли;
		
	СтруктураАдресаСМассивами.Вставить("Квартира", СтрокаКвартира);
		
	ЗаполнитьЗначенияСвойств(АдресВФорматеОтчета, СтруктураАдресаСМассивами);
	
	Если НЕ ЗначениеЗаполнено(АдресВФорматеОтчета.КодРегиона) Тогда
	    АдресВФорматеОтчета.КодРегиона = "00";		
	КонецЕсли;
	Если СтрДлина(АдресВФорматеОтчета.КодРегиона) = 1 Тогда
	    АдресВФорматеОтчета.КодРегиона = "0" + АдресВФорматеОтчета.КодРегиона;
	КонецЕсли;
	
	// Добавим сокращения
	Если НЕ АдресВФорматеОтчета.Район = Неопределено Тогда
		
		Если СтруктураАдресаСМассивами.Свойство("РайонСокращение") Тогда
		
			АдресВФорматеОтчета.Район = ?(СтруктураАдресаСМассивами.РайонСокращение = Неопределено,
											АдресВФорматеОтчета.Район,
											АдресВФорматеОтчета.Район + " " +СтруктураАдресаСМассивами.РайонСокращение);	
		
		КонецЕсли; 
			
	КонецЕсли; 
	
	Если НЕ АдресВФорматеОтчета.Город = Неопределено Тогда
		
		Если СтруктураАдресаСМассивами.Свойство("ГородСокращение") Тогда
			
			АдресВФорматеОтчета.Город = ?(СтруктураАдресаСМассивами.ГородСокращение = Неопределено,
										"г " + АдресВФорматеОтчета.Город,
										СтруктураАдресаСМассивами.ГородСокращение + " " +АдресВФорматеОтчета.Город);
		КонецЕсли;
									
	КонецЕсли;
									
	Если НЕ АдресВФорматеОтчета.НаселенныйПункт = Неопределено Тогда
		
		Если СтруктураАдресаСМассивами.Свойство("НаселенныйПунктСокращение") Тогда
			
			АдресВФорматеОтчета.НаселенныйПункт = ?(СтруктураАдресаСМассивами.НаселенныйПунктСокращение = Неопределено,
										АдресВФорматеОтчета.НаселенныйПункт,
										АдресВФорматеОтчета.НаселенныйПункт + " " + СтруктураАдресаСМассивами.НаселенныйПунктСокращение);
		КонецЕсли;								
		
	КонецЕсли;
	
	Если НЕ АдресВФорматеОтчета.Улица = Неопределено Тогда
		
		Если СтруктураАдресаСМассивами.Свойство("УлицаСокращение") Тогда
			
			АдресВФорматеОтчета.Улица = ?(СтруктураАдресаСМассивами.УлицаСокращение = Неопределено,
										АдресВФорматеОтчета.Улица + " ул",
										АдресВФорматеОтчета.Улица + " " + СтруктураАдресаСМассивами.УлицаСокращение);
		КонецЕсли;
										
	КонецЕсли;								
	
	Возврат АдресВФорматеОтчета;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
	    Возврат;	
	КонецЕсли;
		
	СтруктураАдреса = Неопределено;
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		АдресXML 				=  Результат.КонтактнаяИнформация; // формат XML
		ПредставлениеАдреса    =  Результат.Представление;
								
		СтруктураАдреса = ПолучитьСтруктуруАдресаОтчетаИзСтандартногоПредставленияИлиXML(АдресXML);
		
		ЗаполнитьЗначенияСвойств(ОбрабатываемыеДанные, СтруктураАдреса);
		
		ОбрабатываемыеДанные.АдресXML = АдресXML;
		ОбрабатываемыеДанные.ПредставлениеАдреса = ПредставлениеАдреса;
		
		АдресПредставление = ВывестиПредставлениеАдреса(ОбрабатываемыеДанные);
	
		ОбновитьЦветаСсылок();
		
	Иначе
		// Отказ
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ЭтаФорма.Закрыть(РезультатВвода());

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЭтаФорма.Закрыть();

КонецПроцедуры

&НаКлиенте
Функция РезультатВвода()
	
	ОбрабатываемыеДанные.Наименование = Наименование;
		
	ОбрабатываемыеДанные.КПП = КПП;
	
	Возврат ОбрабатываемыеДанные;
	
КонецФункции

#КонецОбласти