#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийОбъектов

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяСправочника - Строка - имя справочника, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, УправляемаяФорма - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ПриПолученииФормыСправочника(ИмяСправочника, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяДокумента - Строка - имя документа, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, УправляемаяФорма - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ПриПолученииФормыДокумента(ИмяДокумента, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ВидФормы = "ФормаСписка"
		И Параметры.Свойство("ТекущаяСтрока") Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаСпискаДокументов";
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра сведений, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, УправляемаяФорма - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ПриПолученииФормыРегистраСведений(ИмяРегистра, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Возникает на сервере при создании формы.
//
// Параметры:
//  Форма - УправляемаяФорма - создаваемая форма,
//  Отказ - Булево - признак отказа от создания формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ВозвратИзРегистра2ЕГАИС.Форма.ФормаСпискаДокументов" Тогда
		Форма.Элементы.СтраницаКОформлению.Видимость = Ложь;
		Форма.Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	ЭлементСерия = Форма.Элементы.Найти("Серия");
	Если ЭлементСерия <> Неопределено Тогда
		ЭлементСерия.Видимость = Ложь;
	КонецЕсли; 
	
	КнопкаПодбор = Форма.Элементы.Найти("ТоварыОткрытьПодбор");
	Если КнопкаПодбор = Неопределено Тогда
		КнопкаПодбор = Форма.Элементы.Найти("ТоварыОткрытьПодборНомеклатуры");
	КонецЕсли;
	
	Если КнопкаПодбор <> Неопределено Тогда
		КнопкаПодбор.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при чтении объекта на сервере.
//
// Параметры:
//  Форма - УправляемаяФорма - форма читаемого объекта,
//  ТекущийОбъект - ДокументОбъект, СправочникОбъект - читаемый объект.
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиДействийФорм

// Возникает на сервере при записи константы в формах настроек.
//   если запись одной константы может повлечь изменение других отображаемых в этой же форме
//
// Параметры:
//   Форма             - УправляемаяФорма - форма,
//   КонстантаИмя      - Строка           - записываемая константа,
//   КонстантаЗначение - Произвольный     - значение константы.
//
Процедура ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(Форма, КонстантаИмя, КонстантаЗначение) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Устанавливается свойство ОтображениеПредупрежденияПриРедактировании элемента формы.
//
Процедура ОтображениеПредупрежденияПриРедактировании(Элемент, Отображать) Экспорт

	Возврат
	
КонецПроцедуры

#КонецОбласти

#Область УсловноеОформление

// Устанавливает условное оформление для поля "Характеристика".
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой нужно установить условное оформление,
//  ИмяПоляВводаХарактеристики - Строка - имя элемента формы "Характеристика",
//  ПутьКПолюОтбора - Строка - полный путь к реквизиту "Характеристики используются".
//
Процедура УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
	Форма,
	ИмяПоляВводаХарактеристики = "ТоварыХарактеристика",
	ПутьКПолюОтбора = "Объект.Товары.ХарактеристикиИспользуются") Экспорт
	
	СобытияФормИСУНФ.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		Форма,
		ИмяПоляВводаХарактеристики,
		ПутьКПолюОтбора);
	
КонецПроцедуры

// Устанавливает условное оформление для поля "Единица измерения".
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой нужно установить условное оформление,
//  ИмяПоляВводаЕдиницИзмерения - Строка - имя элемента формы "Единица измерения",
//  ПутьКПолюОтбора - Строка - полный путь к реквизиту "Упаковка".
//
Процедура УстановитьУсловноеОформлениеЕдиницИзмерения(Форма,
	                                                  ИмяПоляВводаЕдиницИзмерения = "ТоварыНоменклатураЕдиницаИзмерения",
	                                                  ПутьКПолюОтбора = "Объект.Товары.Упаковка") Экспорт
	
	СобытияФормИСУНФ.УстановитьУсловноеОформлениеЕдиницИзмерения(Форма,
														ИмяПоляВводаЕдиницИзмерения,
														ПутьКПолюОтбора);
	
КонецПроцедуры

// Устанавливает условное оформление для поля "Серия".
//
// Параметры:
//	Форма - УправляемаяФорма - Форма, в которой нужно установить условное оформление,
//
Процедура УстановитьУсловноеОформлениеСерийНоменклатуры(Форма,
														ИмяПоляВводаСерии = "ТоварыСерия",
														ПутьКПолюОтбораСтатусУказанияСерий = "Объект.Товары.СтатусУказанияСерий",
														ПутьКПолюОтбораТипНоменклатуры = "Объект.Товары.ТипНоменклатуры") Экспорт
	
	СобытияФормИСУНФ.УстановитьУсловноеОформлениеСерийНоменклатуры(Форма,
														ИмяПоляВводаСерии,
														ПутьКПолюОтбораСтатусУказанияСерий,
														ПутьКПолюОтбораТипНоменклатуры);
	
КонецПроцедуры

#КонецОбласти

#Область СвязиПараметровВыбора

// Устанавливает связь элемента формы с полем ввода номенклатуры.
//
// Параметры:
//	Форма					- УправляемаяФорма	- Форма, в которой нужно установить связь.
//	ИмяПоляВвода			- Строка			- Имя поля, связываемого с номенклатурой.
//	ПутьКДаннымНоменклатуры	- Строка			- Путь к данным текущей номенклатуры в форме.
//
Процедура УстановитьСвязиПараметровВыбораСНоменклатурой(Форма, ИмяПоляВвода,
	ПутьКДаннымНоменклатуры = "Элементы.Товары.ТекущиеДанные.Номенклатура") Экспорт
	
	Возврат;
	
КонецПроцедуры

// Устанавливает связь элемента формы с полем ввода характеристики номенклатуры.
//
// Параметры:
//	Форма						- УправляемаяФорма	- Форма, в которой нужно установить связь.
//	ИмяПоляВвода				- Строка			- Имя поля, связываемого с номенклатурой.
//	ПутьКДаннымХарактеристики	- Строка			- Путь к данным текущей характеристики номенклатуры в форме.
//
Процедура УстановитьСвязиПараметровВыбораСХарактеристикой(Форма, ИмяПоляВвода,
	ПутьКДаннымХарактеристики = "Элементы.Товары.ТекущиеДанные.Характеристика") Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Устанавливает у элемента формы Упаковка подсказку ввода для соответствующей номенклатуры
//
// Параметры:
// 	Форма - УправляемаяФорма - Форма объекта.
//
Процедура УстановитьИнформациюОЕдиницеХранения(Форма) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
