
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СохраненноеЗначение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПланСчетовУправленческийФормаВыбораПростая", "ПланСчетовУправленческийФормаВыбораПростая_ПереключательСтраниц");
	
	Если Не ЗначениеЗаполнено(СохраненноеЗначение) Тогда
		ПереключательСтраниц = 1;
	Иначе
		ПереключательСтраниц = СохраненноеЗначение;
	КонецЕсли;
	
	ЭлементОтбора = Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	
	ВключатьВРасходыПрочие = Ложь;
	ВключатьВДоходыПрочие = Ложь;
	
	// Для отображения прочих расходов вместе с основными.
	Если Параметры.Свойство("ВключатьВРасходыПрочие") Тогда
		ВключатьВРасходыПрочие = Параметры.ВключатьВРасходыПрочие;
	Конецесли;
	
	// Для отображения прочих доходов вместе с основными.
	Если Параметры.Свойство("ВключатьВДоходыПрочие") Тогда
		ВключатьВДоходыПрочие = Параметры.ВключатьВДоходыПрочие;
	Конецесли;
	
	// Для изменения заголовка формы.
	Если Параметры.Свойство("ЗаголовокСчета") Тогда
		Заголовок = Параметры.ЗаголовокСчета;
	Конецесли;
	
	// Для изменения заголовка формы.
	Если Параметры.Свойство("ИсключатьПредопределенныеСчета") Тогда
		ИсключатьПредопределенныеСчета = Параметры.ИсключатьПредопределенныеСчета;
	Конецесли;
	
	Если Параметры.Свойство("ТекущаяСтрока")
	   И ЗначениеЗаполнено(Параметры.ТекущаяСтрока)
	   И ТипЗнч(Параметры.ТекущаяСтрока) = Тип("ПланСчетовСсылка.Управленческий")
	   И Параметры.Свойство("Отбор")
	   И Параметры.Отбор.Свойство("ТипСчета") Тогда // если уже выбран счет.
		ДобавитьИерархию(Параметры.Отбор.ТипСчета, Параметры.ТекущаяСтрока.ТипСчета);
		ЭлементОтбора.ПравоеЗначение = Параметры.ТекущаяСтрока; // для исключения моргания при установке отбора.
	ИначеЕсли Параметры.Свойство("Отбор")
			И Параметры.Отбор.Свойство("ТипСчета") Тогда // если не выбран счет.
		ДобавитьИерархию(Параметры.Отбор.ТипСчета);
		ЭлементОтбора.ПравоеЗначение = ПланыСчетов.Управленческий.ПустаяСсылка(); // для исключения моргания при установке отбора.
	Иначе
		ДобавитьИерархию();
		ЭлементОтбора.ПравоеЗначение = ПланыСчетов.Управленческий.ПустаяСсылка();
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор")
		И Параметры.Отбор.Свойство("ТипСчета") Тогда
		Если ТипЗнч(Параметры.Отбор.ТипСчета) = Тип("ФиксированныйМассив") Тогда
			Для Каждого ТипСчета Из Параметры.Отбор.ТипСчета Цикл
				ОтборПоТипуСчета.Добавить(ТипСчета);
			КонецЦикла;
		ИначеЕсли ТипЗнч(Параметры.Отбор.ТипСчета) = Тип("ПеречислениеСсылка.ТипыСчетов") Тогда
			ОтборПоТипуСчета.Добавить(Параметры.Отбор.ТипСчета);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СтраницыПоТипуИСписком.ТекущаяСтраница = ?(ПереключательСтраниц = 1, Элементы.СтраницаПоТипу, Элементы.СтраницаСписком);
	Если ПереключательСтраниц = 2 Тогда
		УстановитьОтборНаСервереДляОтображенияСписком();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКлючаОбъекта = СтрЗаменить(ИмяФормы,".","");
	СохранитьНастройки(ИмяКлючаОбъекта, ПереключательСтраниц);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИерархияПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Иерархия.ТекущиеДанные <> Неопределено
	   И ТекИерархия <> Элементы.Иерархия.ТекущиеДанные.Значение Тогда
		УстановитьОтборНаКлиенте(Элементы.Иерархия.ТекущиеДанные.Значение);
		ТекИерархия = Элементы.Иерархия.ТекущиеДанные.Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательСтраницПриИзменении(Элемент)
	
	Элементы.СтраницыПоТипуИСписком.ТекущаяСтраница = ?(ПереключательСтраниц = 1, Элементы.СтраницаПоТипу, Элементы.СтраницаСписком);
	Если ПереключательСтраниц = 1 Тогда
		Если Элементы.Иерархия.ТекущиеДанные = Неопределено Тогда
			Если Иерархия.Количество() > 0 Тогда
				Элементы.Иерархия.ТекущаяСтрока = Иерархия.Получить(0).ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
		Если Элементы.Иерархия.ТекущиеДанные = Неопределено Тогда
			УстановитьОтборНаКлиенте(Неопределено);
			ТекИерархия = Неопределено;
		Иначе
			УстановитьОтборНаКлиенте(Элементы.Иерархия.ТекущиеДанные.Значение);
			ТекИерархия = Элементы.Иерархия.ТекущиеДанные.Значение;
		КонецЕсли;
	Иначе
		УстановитьОтборНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСчетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОповеститьОВыборе(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройки(ИмяКлючаОбъекта, ПереключательСтраниц)

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПланСчетовУправленческийФормаВыбораПростая", "ПланСчетовУправленческийФормаВыбораПростая_ПереключательСтраниц", ПереключательСтраниц);

КонецПроцедуры

&НаСервере
Процедура ДобавитьИерархию(ТипыСчетов = Неопределено, ТипСчета = Неопределено)
	
	ИспользоватьПодсистемуПроизводство = Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводство.Получить();
	
	Сч = 0;
	ТекСтрокаИерархии = 0;
	
	Если ТипЗнч(ТипыСчетов) = Тип("ФиксированныйМассив") Тогда
		Для каждого ТекТипСчета Из ТипыСчетов Цикл
			ЗаголовокСчета = "";
			Если ТекТипСчета = Перечисления.ТипыСчетов.Расходы Тогда
				ЗаголовокСчета = НСтр("ru='Расходы, распределяемые на финансовый результат (Косвенные)'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.ПрочиеРасходы Тогда
				ЗаголовокСчета = НСтр("ru='Прочие расходы, распределяемые на финансовый результат'");
			ИначеЕсли  ТекТипСчета = Перечисления.ТипыСчетов.Доходы Тогда
				ЗаголовокСчета = НСтр("ru='Доходы, распределяемые на финансовый результат'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.ПрочиеДоходы Тогда
				ЗаголовокСчета = НСтр("ru='Прочие доходы, распределяемые на финансовый результат'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.Дебиторы Тогда
				ЗаголовокСчета = НСтр("ru='Прочие дебиторы (задолженность перед нами)'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.Кредиторы Тогда
				ЗаголовокСчета = НСтр("ru='Прочие кредиторы (наша задолженность)'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.ДенежныеСредства Тогда
				ЗаголовокСчета = НСтр("ru='Перемещения денег'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.ДолгосрочныеОбязательства Тогда
				ЗаголовокСчета = НСтр("ru='Долгосрочные обязательства'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.Капитал Тогда
				ЗаголовокСчета = НСтр("ru='Капитал'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.КредитыИЗаймы Тогда
				ЗаголовокСчета = НСтр("ru='Кредиты и займы'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.НезавершенноеПроизводство Тогда
				ЗаголовокСчета = НСтр("ru='Затраты, относящиеся к выпуску продукции (Прямые)'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.КосвенныеЗатраты Тогда
				ЗаголовокСчета = НСтр("ru='Затраты, распределяемые на себестоимость выпуска продукции (Косвенные)'");
			ИначеЕсли ТекТипСчета = Перечисления.ТипыСчетов.ПрочиеОборотныеАктивы Тогда
				ЗаголовокСчета = НСтр("ru='Прочие оборотные активы'");
			КонецЕсли;
			Если (ИспользоватьПодсистемуПроизводство
				  ИЛИ (ТекТипСчета <> Перечисления.ТипыСчетов.НезавершенноеПроизводство
					   И ТекТипСчета <> Перечисления.ТипыСчетов.КосвенныеЗатраты))
			   И (НЕ ВключатьВРасходыПрочие
				  ИЛИ (ВключатьВРасходыПрочие
					   И ТекТипСчета <> Перечисления.ТипыСчетов.ПрочиеРасходы))
			   И (НЕ ВключатьВДоходыПрочие
				  ИЛИ (ВключатьВДоходыПрочие
					   И ТекТипСчета <> Перечисления.ТипыСчетов.ПрочиеДоходы)) Тогда // добавление иерархии, если отбор соответствует условиям.
				Иерархия.Добавить(ТекТипСчета, ЗаголовокСчета);
				Если ТекТипСчета = ТипСчета
					ИЛИ (ВключатьВРасходыПрочие И ТипСчета = Перечисления.ТипыСчетов.ПрочиеРасходы И ТекТипСчета = Перечисления.ТипыСчетов.Расходы)
					ИЛИ (ВключатьВДоходыПрочие И ТипСчета = Перечисления.ТипыСчетов.ПрочиеДоходы И ТекТипСчета = Перечисления.ТипыСчетов.Доходы) Тогда
					ТекСтрокаИерархии = Сч;
				КонецЕсли;
				Сч = Сч + 1;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ЗначениеЗаполнено(ТипыСчетов) Тогда
		Иерархия.Добавить(ТипыСчетов);
		ТекСтрокаИерархии = 0;
	Иначе
		Для Сч = 0 По Перечисления.ТипыСчетов.Количество() - 1 Цикл
			Иерархия.Добавить(Перечисления.ТипыСчетов[Сч]);
		КонецЦикла;
		ТекСтрокаИерархии = 0;
	КонецЕсли;
	
	Для Сч = 0 По Иерархия.Количество() - 1 Цикл
		Иерархия[Сч].Картинка = БиблиотекаКартинок.Папка;
	КонецЦикла;
	
Конецпроцедуры

&НаКлиенте
Процедура УстановитьОтборНаКлиенте(ТипСчета = Неопределено)
	
	Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Очистить();
	
	Если ИсключатьПредопределенныеСчета Тогда
		
		СписокОтбора = Новый СписокЗначений(); // Счета, которым соответствуют регистры накопления нужно исключить из выбора для прочих операций.
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.Банк"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.Касса"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.Налоги"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.НалогиКВозмещению"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыПоАвансамВыданным"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыПоАвансамПолученным"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПокупателями"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПоставщиками"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПодотчетниками"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.ПерерасходПодотчетников"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПерсоналомПоОплатеТруда"));
		
		ЭлементОтбора = Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = СписокОтбора;
		
	КонецЕсли;
	
	Если ПереключательСтраниц = 1 И ЗначениеЗаполнено(ТипСчета) Тогда
		
		ЭлементОтбора = Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипСчета");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		
		Если ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.Расходы")
		   И ВключатьВРасходыПрочие = Истина Тогда
			СписокОтбора = Новый СписокЗначений();
			СписокОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСчетов.Расходы"));
			СписокОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСчетов.ПрочиеРасходы"));
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбора.ПравоеЗначение = СписокОтбора;
		ИначеЕсли ТипСчета = ПредопределенноеЗначение("Перечисление.ТипыСчетов.Доходы")
		   И ВключатьВДоходыПрочие = Истина Тогда
			СписокОтбора = Новый СписокЗначений();
			СписокОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСчетов.Доходы"));
			СписокОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСчетов.ПрочиеДоходы"));
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбора.ПравоеЗначение = СписокОтбора;
		Иначе
			ЭлементОтбора.ПравоеЗначение = ТипСчета;
		КонецЕсли;
		
	ИначеЕсли ПереключательСтраниц = 2 И ЗначениеЗаполнено(ОтборПоТипуСчета) Тогда
		
		ЭлементОтбора = Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипСчета");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.Использование = Истина;
		
		ЭлементОтбора.ПравоеЗначение = ОтборПоТипуСчета;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборНаСервереДляОтображенияСписком()
	
	Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Очистить();
	
	Если ИсключатьПредопределенныеСчета Тогда
		
		СписокОтбора = Новый СписокЗначений(); // Счета, которым соответствуют регистры накопления нужно исключить из выбора для прочих операций.
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.Банк"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.Касса"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.Налоги"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.НалогиКВозмещению"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыПоАвансамВыданным"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыПоАвансамПолученным"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПокупателями"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПоставщиками"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПодотчетниками"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.ПерерасходПодотчетников"));
		СписокОтбора.Добавить(ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПерсоналомПоОплатеТруда"));
		
		ЭлементОтбора = Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = СписокОтбора;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборПоТипуСчета) Тогда
		
		ЭлементОтбора = Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипСчета");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.Использование = Истина;
		
		ЭлементОтбора.ПравоеЗначение = ОтборПоТипуСчета;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
