
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Номенклатура", Номенклатура) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьУсловноеОформление();
	
	Элементы.ГруппаКопирование.Видимость = ЗначениеЗаполнено(Номенклатура);
	
	УстановитьУсловноеОформлениеФормы();
	
	УстановитьОтбор(Список.Отбор, "Владелец", Номенклатура);	
	УстановитьОтбор(Список.Отбор, "ЗаказПокупателя", Документы.ЗаказПокупателя.ПустаяСсылка());	
	
	ПроверкаИспользованияСпецификаций();
	
	ЗаполнитьХарактеристики();
	ОбновитьПараметрыОтображения();
	УправлениеФормой(ЭтотОбъект);
	УстановитьОтборНедействительная(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КопированиеСпецификаций" И ЗначениеЗаполнено(Номенклатура) И Параметр=Номенклатура Тогда
		
		Элементы.Список.Обновить();
		
	ИначеЕсли ИмяСобытия = "СпецификацияЗаписана" Тогда
		
		СтрокаСписка = Элементы.Список.ТекущиеДанные;
		Если СтрокаСписка<>Неопределено И Параметр.Ссылка=СтрокаСписка.Ссылка Тогда
			ОтразитьВозможностьУстановкиСпецификацииКакОсновной(Параметр.Недействителен);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОтразитьВозможностьУстановкиСпецификацииКакОсновной();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПриИзменении(Элемент)
	
	Если Режим=0 Тогда
		ТекущаяХарактеристика = Неопределено;
		УстановитьОтбор(Список.Отбор, "ХарактеристикаПродукции", ТекущаяХарактеристика);
	ИначеЕсли Режим=2 Тогда
		ТекущаяХарактеристика = ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
		УстановитьОтбор(Список.Отбор, "ХарактеристикаПродукции", ТекущаяХарактеристика);
	ИначеЕсли Режим=1 И Элементы.Характеристики.ТекущиеДанные<>Неопределено Тогда
		ТекущаяХарактеристика = Элементы.Характеристики.ТекущиеДанные.Характеристика;
		УстановитьОтбор(Список.Отбор, "ХарактеристикаПродукции", ТекущаяХарактеристика);
	Иначе
		ТекущаяХарактеристика = Неопределено;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПриАктивизацииСтроки(Элемент)

	Если Элемент.ТекущиеДанные=Неопределено ИЛИ Элемент.ТекущиеДанные.Характеристика=ТекущаяХарактеристика Тогда
		Возврат;
	КонецЕсли; 
	
	ТекущаяХарактеристика = Элемент.ТекущиеДанные.Характеристика;
	УстановитьОтбор(Список.Отбор, "ХарактеристикаПродукции", ТекущаяХарактеристика);	
	
КонецПроцедуры
 
&НаКлиенте
Процедура ОтображатьСпецификацииЗаказовПриИзменении(Элемент)
	
	УстановитьОтбор(Список.Отбор, "ЗаказПокупателя", ?(ОтображатьСпецификацииЗаказов, Неопределено, ПредопределенноеЗначение("Документ.ЗаказПокупателя.ПустаяСсылка")));
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтрокаТабличнойЧасти = Характеристики.НайтиПоИдентификатору(Строка);
	
	МассивСпецификаций = Новый Массив;
	Если ТипЗнч(ПараметрыПеретаскивания.Значение)=Тип("СправочникСсылка.Спецификации") Тогда
		МассивСпецификаций.Добавить(ПараметрыПеретаскивания.Значение);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение)=Тип("Массив") Тогда
		Для каждого Спецификация Из ПараметрыПеретаскивания.Значение Цикл
			Если ТипЗнч(Спецификация)=Тип("СправочникСсылка.Спецификации") Тогда
				МассивСпецификаций.Добавить(Спецификация);
			КонецЕсли; 
		КонецЦикла;
	Иначе
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если МассивСпецификаций.Количество()=0 Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	ИзменитьХарактеристикуСпецификаций(МассивСпецификаций, СтрокаТабличнойЧасти.Характеристика);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	
	СтруктураИменЭлементов = Новый Структура("ФильтрыНастройкиИДопИнфо, ДекорацияРазвернутьОтборы, ПраваяПанель",
	    "ФильтрыНастройкиИДопИнфо","ДекорацияРазвернутьОтборы","ПраваяПанель"
		);
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость, СтруктураИменЭлементов);
		
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользоватьКакОсновную(Команда)
	
	СтрокаТабличнойЧасти = Элементы.Список.ТекущиеДанные;
	Если СтрокаТабличнойЧасти=Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ИспользоватьКакОсновнуюСервер(Номенклатура, СтрокаТабличнойЧасти.ХарактеристикаПродукции, СтрокаТабличнойЧасти.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ИспользоватьКакОсновнуюСервер(Номенклатура, Характеристика, Спецификация)
	
	Справочники.Спецификации.ИзменитьПризнакОсновнаяСпецификация(Номенклатура, Характеристика, Спецификация); 
	
	Элементы.Список.Обновить();
	Элементы.Список.ТекущаяСтрока = Спецификация;
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьОт(Команда)
	
	СтруктураОткрытия = Новый Структура;
	СтруктураОткрытия.Вставить("Номенклатура", Номенклатура);
	СтруктураОткрытия.Вставить("КопироватьСпецификации", Истина);
	СтруктураОткрытия.Вставить("КопироватьИзВыбранных", Истина);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаКопированияСвязаннойИнформации", СтруктураОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьДругим(Команда)
	
	СтруктураОткрытия = Новый Структура;
	СтруктураОткрытия.Вставить("Номенклатура", Номенклатура);
	СтруктураОткрытия.Вставить("КопироватьСпецификации", Истина);
	СтруктураОткрытия.Вставить("КопироватьИзВыбранных", Ложь);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаКопированияСвязаннойИнформации", СтруктураОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительную(Команда)
	
	Элементы.ФормаПоказыватьНедействительную.Пометка = Не Элементы.ФормаПоказыватьНедействительную.Пометка;
	
	УстановитьОтборНедействительная(ЭтотОбъект)
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Характеристики.Устарела", Истина);
	РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "ХарактеристикиПредставление");
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекстаТабличнойЧасти);
	
	НовоеУсловноеОформление = Список.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Недействителен", Истина, ВидСравненияКомпоновкиДанных.Равно);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекстаТабличнойЧасти); 

КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыОтображения()
	
	ИспользуютсяХарактеристики = (Характеристики.Количество()>0);
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Спецификации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Спецификации КАК Спецификации
		|ГДЕ
		|	Спецификации.Владелец = &Номенклатура
		|	И Спецификации.ЗаказПокупателя <> ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)";
		ИспользуютсяЗаказы = НЕ Запрос.Выполнить().Пустой();
	Иначе
		ИспользуютсяЗаказы = Ложь;
	КонецЕсли; 	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Список.Недействителен", Истина, ВидСравненияКомпоновкиДанных.Равно);
	РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "Наименование");
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекстаТабличнойЧасти); 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗаказПокупателя", "Видимость", Форма.ОтображатьСпецификацииЗаказов);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ХарактеристикаПродукции", "Видимость", Форма.ИспользуютсяХарактеристики И Форма.Режим=0);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаХарактеристики", "Видимость", Форма.ИспользуютсяХарактеристики И Форма.Режим=1);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Режим", "Видимость", Форма.ИспользуютсяХарактеристики);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтображатьСпецификацииЗаказов", "Видимость", Форма.ИспользуютсяЗаказы);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПраваяПанель", "Видимость", Форма.ИспользуютсяХарактеристики ИЛИ Форма.ИспользуютсяЗаказы);
	
КонецПроцедуры

&НаСервере
Процедура ПроверкаИспользованияСпецификаций()
	
	ИспользоватьПодсистемуПроизводство = Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводство.Получить();
	ИспользоватьПодсистемуРаботы = Константы.ФункциональнаяОпцияИспользоватьПодсистемуРаботы.Получить();
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, "ТипНоменклатуры, ЭтоНабор");
	
	Если НЕ ЗначениеЗаполнено(Номенклатура)
		ИЛИ ЗначенияРеквизитов.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ВидРабот
		ИЛИ ЗначенияРеквизитов.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга
		ИЛИ ЗначенияРеквизитов.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Операция
		ИЛИ ЗначенияРеквизитов.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда
		
		АвтоЗаголовок = Ложь;
		Если ИспользоватьПодсистемуПроизводство И ИспользоватьПодсистемуРаботы Тогда
			Заголовок = НСтр("ru = 'Спецификации хранятся только для запасов и работ'");
		ИначеЕсли ИспользоватьПодсистемуПроизводство Тогда
			Заголовок = НСтр("ru = 'Спецификации хранятся только для запасов'");
		Иначе
			Заголовок = НСтр("ru = 'Спецификации хранятся только для работ'");
		КонецЕсли;
		Элементы.Список.ТолькоПросмотр = Истина;
		Элементы.ФильтрыНастройкиИДопИнфо.Доступность = Ложь;
		Элементы.ФормаИспользоватьКакОсновную.Видимость = Ложь;
		Элементы.ГруппаКопирование.Доступность = Ложь;
		
	// Наборы
	ИначеЕсли ЗначенияРеквизитов.ЭтоНабор Тогда
		
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Спецификации недоступны для наборов'");
		Элементы.Список.ТолькоПросмотр = Истина;
		Элементы.ФильтрыНастройкиИДопИнфо.Доступность = Ложь;
		Элементы.ФормаИспользоватьКакОсновную.Видимость = Ложь;
		Элементы.ГруппаКопирование.Доступность = Ложь;
	
	// Конец Наборы
	ИначеЕсли ЗначенияРеквизитов.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас И НЕ ИспользоватьПодсистемуПроизводство Тогда
		
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Спецификации хранятся только для работ'");
		Элементы.Список.ТолькоПросмотр = Истина;
		Элементы.ФильтрыНастройкиИДопИнфо.Доступность = Ложь;
		Элементы.ФормаИспользоватьКакОсновную.Видимость = Ложь;
		Элементы.ГруппаКопирование.Доступность = Ложь;
		
	ИначеЕсли ЗначенияРеквизитов.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа И НЕ ИспользоватьПодсистемуРаботы Тогда
		
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Спецификации хранятся только для запасов'");
		Элементы.Список.ТолькоПросмотр = Истина;
		Элементы.ФильтрыНастройкиИДопИнфо.Доступность = Ложь;
		Элементы.ФормаИспользоватьКакОсновную.Видимость = Ложь;
		Элементы.ГруппаКопирование.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьХарактеристики()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика,
	|	ХарактеристикиНоменклатуры.Наименование КАК Наименование
	|ПОМЕСТИТЬ ТабХарактеристики
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	(ХарактеристикиНоменклатуры.Владелец = &Номенклатура
	|			ИЛИ ХарактеристикиНоменклатуры.Владелец = ВЫРАЗИТЬ(&Номенклатура КАК Справочник.Номенклатура).КатегорияНоменклатуры)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Характеристики.Характеристика КАК Характеристика,
	|	ЛОЖЬ КАК Устарела,
	|	Характеристики.Наименование КАК Представление,
	|	0 КАК Порядок
	|ИЗ
	|	ТабХарактеристики КАК Характеристики
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Спецификации.ХарактеристикаПродукции,
	|	ИСТИНА,
	|	Спецификации.ХарактеристикаПродукции.Наименование + "" (устарела)"",
	|	1
	|ИЗ
	|	Справочник.Спецификации КАК Спецификации
	|ГДЕ
	|	Спецификации.ХарактеристикаПродукции <> ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	И Спецификации.Владелец = &Номенклатура
	|	И НЕ Спецификации.ХарактеристикаПродукции В
	|				(ВЫБРАТЬ
	|					ТабХарактеристики.Характеристика
	|				ИЗ
	|					ТабХарактеристики)
	|
	|СГРУППИРОВАТЬ ПО
	|	Спецификации.ХарактеристикаПродукции,
	|	Спецификации.ХарактеристикаПродукции.Наименование + "" (устарела)""
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	Представление";
	Характеристики.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ТекущаяХарактеристика = Неопределено;
	УстановитьОтбор(Список.Отбор, "ХарактеристикаПродукции", Неопределено);
	Если Характеристики.Количество()>0 Тогда
		Элементы.Характеристики.ТекущаяСтрока = Характеристики[0].ПолучитьИдентификатор();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтбор(ГруппаЭлементовОтбора, ПутьКДаннымПоля, Значение) Экспорт
	
	НайденныйЭлемент = Неопределено;
	Поле = Новый ПолеКомпоновкиДанных(ПутьКДаннымПоля);
	Для каждого ЭлементОтбора Из ГруппаЭлементовОтбора.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение=Поле Тогда
			НайденныйЭлемент = ЭлементОтбора;
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	
	Если НайденныйЭлемент=Неопределено И Значение=Неопределено Тогда
		Возврат;
	ИначеЕсли НайденныйЭлемент=Неопределено Тогда
		Отбор = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ЛевоеЗначение  = Поле;
	Иначе
		Отбор = НайденныйЭлемент;
	КонецЕсли; 
	Отбор.Использование  = Значение<>Неопределено;
	Отбор.ПравоеЗначение = Значение;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьХарактеристикуСпецификаций(МассивСпецификаций, Характеристика)

	Для каждого Спецификация Из МассивСпецификаций Цикл
		СпецификацияОбъект = Спецификация.ПолучитьОбъект();
		СпецификацияОбъект.ХарактеристикаПродукции = Характеристика;
		СпецификацияОбъект.Записать();
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры 

&НаКлиенте
Процедура ОтразитьВозможностьУстановкиСпецификацииКакОсновной(Недействителен = Неопределено)
	
	Если Недействителен=Неопределено Тогда
		СтрокаСписка = Элементы.Список.ТекущиеДанные;
		Если СтрокаСписка=Неопределено Тогда
			Недействителен = Ложь;
		Иначе
			Недействителен = СтрокаСписка.Недействителен;
		КонецЕсли; 
	КонецЕсли; 
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаИспользоватьКакОсновную", "Доступность", НЕ Недействителен);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборНедействительная(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Форма.Элементы.ФормаПоказыватьНедействительную.Пометка);
	
КонецПроцедуры

#КонецОбласти

