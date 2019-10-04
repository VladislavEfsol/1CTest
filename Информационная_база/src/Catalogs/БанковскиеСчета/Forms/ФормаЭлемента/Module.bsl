
#Область ОписаниеПеременных

&НаКлиенте
Перем УстановкаОсновногоСчетаВыполнена; // Признак успешной установки основного банковского счета из формы контрагента/организации/физлица

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НациональнаяВалюта = Константы.НациональнаяВалюта.Получить();
	
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) Тогда
		
		Объект.ВалютаДенежныхСредств = НациональнаяВалюта;
		
	КонецЕсли;
	
	// Заполним БИК и кор.счет банка.
	ЗаполнитьДанныеБанка(БИКБанка, КоррСчетБанка, ЯвляетсяБанкомРФ, Объект.Банк, Объект.Владелец);
	ИзменитьДлинуНомераСчета(ЯвляетсяБанкомРФ);

	// Заполним БИК и кор.счет банка для расчетов.
	ЗаполнитьДанныеБанка(БИКБанкаДляРасчетов, КоррСчетБанкаДляРасчетов, ЯвляетсяБанкомРФДляРасчетов, Объект.БанкРасчетов, Объект.Владелец);
	
	УправлениеЭлементамиФормы();
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидСчета) Тогда
		Объект.ВидСчета = "Расчетный";
	КонецЕсли;
	
	ЗаполнитьСписокВариантовПредставленийСчета();
	
	РазделениеВключено = ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// Эквайринг
	ВалютаДенежныхСредств = Объект.ВалютаДенежныхСредств;
	// Конец Эквайринг
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СправочникБанковскиеСчетаЗапись");
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
	// Если выключено использование банка для расчетов, очистим значение банка.
	Если НЕ ИспользуетсяБанкДляРасчетов
		И ЗначениеЗаполнено(Объект.БанкРасчетов) Тогда
		
		Объект.БанкРасчетов = Неопределено;
		
	КонецЕсли; 
	
	// Заполним текст корреспондента.
	Если РедактироватьТекстКорреспондента Тогда
		
		Объект.ТекстКорреспондента = ТекстКорреспондента;
		
	Иначе
		
		Объект.ТекстКорреспондента = "";
		
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ПроверитьВозможностьИзменений(Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Если открыта форма контрагента/организации, то изменение основного счета выполняем в ней
	Если ЭтоЕдинственныйСчетВладельца(Объект.Владелец) Тогда
		
		УстановкаОсновногоСчетаВыполнена = Ложь;
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Владелец", Объект.Владелец);
		СтруктураПараметров.Вставить("НовыйОсновнойСчет", Объект.Ссылка);
		СтруктураПараметров.Вставить("УстановленОсновнойСчет", Ложь);
		
		Оповестить("УстановкаОсновногоСчета", СтруктураПараметров, ЭтотОбъект);
		
		// Если форма контрагента/организации закрыта, то запишем основной счет контрагента/организации самостоятельно
		Если Не УстановкаОсновногоСчетаВыполнена Тогда
			ЗаписатьОсновнойСчет(СтруктураПараметров);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменилисьСчетаБанковскиеСчета" Тогда
		Объект.СчетУчета = Параметр.СчетУчета;
		Модифицированность = Истина;
	ИначеЕсли ИмяСобытия = "УстановкаОсновногоСчетаВыполнена" Тогда
		УстановкаОсновногоСчетаВыполнена = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекстОшибки = "";
	
	Если Не УправлениеНебольшойФирмойКлиентСервер.НомерСчетаКорректен(Объект.НомерСчета, БИКБанка, ЯвляетсяБанкомРФ, ТекстОшибки) Тогда
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,, "Объект.НомерСчета",, Отказ);
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Не удалось записать банковский счет'"),
			УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.БанковскиеСчета,
			,
			ТекстОшибки);
	КонецЕсли;
		
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Банк, "Страна") <> Справочники.СтраныМира.Россия Тогда
		НайденныйРеквизит = ПроверяемыеРеквизиты.Найти("БИКБанка");
		ПроверяемыеРеквизиты.Удалить(НайденныйРеквизит);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьМаскуНомераСчета();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура БанкПриИзменении(Элемент)
	
	ОбработатьИзменениеБанка();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеБанка()
	
	Если Не ЗначениеЗаполнено(Объект.Банк) Тогда
		БИКБанка = "";
		КоррСчетБанка = "";
		ЯвляетсяБанкомРФ = Ложь;
	КонецЕсли;
	
	ИзменитьДлинуНомераСчета(ЯвляетсяБанкомРФ);
	Объект.НомерСчета = Элементы.НомерСчета.ОграничениеТипа.ПривестиЗначение(Объект.НомерСчета);
	
	УстановитьНаименованиеБанка();
	
	УстановитьТекстНастройкиЭДО(ЭтотОбъект);
	ЗаполнитьСписокВариантовПредставленийСчета();
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура БанкОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбработатьВыборБанка(ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьВыборБанка(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КлассификаторБанков")
		И ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		ВыбранноеЗначение = БанкИзКлассификатора(ВыбранноеЗначение);
	КонецЕсли;
	
	ЗаполнитьДанныеБанка(БИКБанка, КоррСчетБанка, ЯвляетсяБанкомРФ, ВыбранноеЗначение, Объект.Владелец);
	
КонецПроцедуры

// Переопределяет обработчик АвтоПодбор поля банка для подбора банков одновременно из справочника и классификатора.
//
// Параметры:
//  Текст                - Строка - см. описание параметра обработчика АвтоПодбор.
//  ДанныеВыбора         - Произвольный - см. описание параметра обработчика АвтоПодбор.
//  СтандартнаяОбработка - Булево - см. описание параметра обработчика АвтоПодбор.
//  Параметры            - Структура - см. описание параметра ПараметрыПолученияДанных обработчика АвтоПодбор. 
//
&НаКлиенте
Процедура ОбработкаАвтоПодбораБанка(Текст, ДанныеВыбора, СтандартнаяОбработка, Параметры)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Текст) И СтрДлина(Текст)<=2 Тогда
		ДанныеВыбора = Новый СписокЗначений;
	Иначе
		ДанныеВыбора = ДанныеВыбораБанка(Параметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БанкАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ОбработкаАвтоПодбораБанка(Текст, ДанныеВыбора, СтандартнаяОбработка, ПараметрыПолученияДанных);
КонецПроцедуры

// Процедура - обработчик события ОкончаниеВводаТекста поля КоррСчетБанка.
//
&НаКлиенте
Процедура КоррСчетБанкаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокНайденныхБанков = НайтиБанки(СокрЛП(Текст), Элемент.Имя, Объект.ВалютаДенежныхСредств <> НациональнаяВалюта);
	Если ТипЗнч(СписокНайденныхБанков) = Тип("СписокЗначений") Тогда
		
		Если СписокНайденныхБанков.Количество() = 1 Тогда
			
			ОповеститьОбИзменении(Тип("СправочникСсылка.Банки"));
			
			Объект.Банк = СписокНайденныхБанков[0].Значение;
			ЗаполнитьДанныеБанка(БИКБанка, КоррСчетБанка, ЯвляетсяБанкомРФ, Объект.Банк, Объект.Владелец);
			
			ОбработатьИзменениеБанка();
			
		ИначеЕсли СписокНайденныхБанков.Количество() > 1 Тогда
			
			ОповеститьОбИзменении(Тип("СправочникСсылка.Банки"));
			
			ОткрытьФормуВыбораБанка(Истина, СписокНайденныхБанков);
			
		Иначе
			
			ОткрытьФормуВыбораБанка(Истина);
			
		КонецЕсли;
		
	Иначе
		
		ЭтаФорма.ТекущийЭлемент = Элемент;
		
	КонецЕсли;
	
КонецПроцедуры // КоррСчетБанкаОкончаниеВводаТекста()

// Процедура - обработчик события ОбработкаВыбора поля БИКБанкаРасчетов.
//
&НаКлиенте
Процедура КоррСчетБанкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Объект.Банк = ВыбранноеЗначение;
	ЗаполнитьДанныеБанка(БИКБанка, КоррСчетБанка, ЯвляетсяБанкомРФ, Объект.Банк, Объект.Владелец);
	
	ОбработатьИзменениеБанка();
	
КонецПроцедуры // БИКБанкаОбработкаВыбора()

&НаКлиенте
Процедура БанкРасчетовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КлассификаторБанков")
		И ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		ВыбранноеЗначение = БанкИзКлассификатора(ВыбранноеЗначение);
	КонецЕсли;
	
	ЗаполнитьДанныеБанка(БИКБанкаДляРасчетов, КоррСчетБанкаДляРасчетов, ЯвляетсяБанкомРФДляРасчетов, ВыбранноеЗначение, Объект.Владелец);
	
КонецПроцедуры

&НаКлиенте
Процедура БанкРасчетовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ОбработкаАвтоПодбораБанка(Текст, ДанныеВыбора, СтандартнаяОбработка, ПараметрыПолученияДанных);
КонецПроцедуры

// Процедура - обработчик события ОкончаниеВводаТекста поля КоррСчетБанкаДляРасчетов
//
&НаКлиенте
Процедура КоррСчетБанкаДляРасчетовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокНайденныхБанков = НайтиБанки(СокрЛП(Текст), Элемент.Имя, Объект.ВалютаДенежныхСредств <> НациональнаяВалюта);
	Если ТипЗнч(СписокНайденныхБанков) = Тип("СписокЗначений") Тогда
		
		Если СписокНайденныхБанков.Количество() = 1 Тогда
			
			ОповеститьОбИзменении(Тип("СправочникСсылка.Банки"));
			
			Объект.БанкРасчетов = СписокНайденныхБанков[0].Значение;
			ЗаполнитьБИКиКоррСчет(Объект.БанкРасчетов,  БИКБанкаДляРасчетов, КоррСчетБанкаДляРасчетов);
			
		ИначеЕсли СписокНайденныхБанков.Количество() > 1 Тогда
			
			ОповеститьОбИзменении(Тип("СправочникСсылка.Банки"));
			
			ОткрытьФормуВыбораБанка(Ложь, СписокНайденныхБанков);
			
		Иначе
			
			ОткрытьФормуВыбораБанка(Ложь);
			
		КонецЕсли;
		
	Иначе
		
		ЭтаФорма.ТекущийЭлемент = Элемент;
		
	КонецЕсли;
	
КонецПроцедуры // КоррСчетБанкаДляРасчетовОкончаниеВводаТекста()

// Процедура - обработчик события ОбработкаВыбора поля КоррСчетБанкаДляРасчетов.
//
&НаКлиенте
Процедура КоррСчетБанкаДляРасчетовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Объект.БанкРасчетов = ВыбранноеЗначение;
	ЗаполнитьДанныеБанка(БИКБанкаДляРасчетов, КоррСчетБанкаДляРасчетов, ЯвляетсяБанкомРФДляРасчетов, Объект.БанкРасчетов, Объект.Владелец);
	
КонецПроцедуры // КоррСчетБанкаДляРасчетовОбработкаВыбора()

// Процедура - обработчик события ПриИзменении флажка ИспользуетсяБанкДляРасчетов.
//
&НаКлиенте
Процедура ИспользуетсяБанкДляРасчетовПриИзменении(Элемент)
	
	Элементы.КоррСчетБанкаДляРасчетов.Видимость = ИспользуетсяБанкДляРасчетов;
	Элементы.БанкРасчетов.Видимость             = ИспользуетсяБанкДляРасчетов;
	Элементы.БанкРасчетовГород.Видимость       = ИспользуетсяБанкДляРасчетов;
	
КонецПроцедуры // ИспользуетсяБанкДляРасчетовПриИзменении()

// Процедура - обработчик события ПриИзменении флажка РедактироватьТекстПлательщика.
//
&НаКлиенте
Процедура РедактироватьТекстПлательщикаПриИзменении(Элемент)
	
	Элементы.ТекстПлательщика.Доступность = РедактироватьТекстКорреспондента;
	
	Если НЕ РедактироватьТекстКорреспондента Тогда
		ЗаполнитьТекстКорреспондента();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении флажка РедактироватьТекстПолучателя.
//
&НаКлиенте
Процедура РедактироватьТекстПолучателяПриИзменении(Элемент)
	
	Элементы.ТекстПолучателя.Доступность = РедактироватьТекстКорреспондента;
	
	Если НЕ РедактироватьТекстКорреспондента Тогда
		ЗаполнитьТекстКорреспондента();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля НомерСчета.
//
&НаКлиенте
Процедура НомерСчетаПриИзменении(Элемент)
	
	ОбработатьИзменениеНомераСчета();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеНомераСчета()
	
	УстановитьНаименованиеБанка();
	
	ЗаполнитьСписокВариантовПредставленийСчета();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ВалютаДенежныхСредств.
//
&НаКлиенте
Процедура ВалютаДенежныхСредствПриИзменении(Элемент)
	
	ЗаполнитьСписокВариантовПредставленийСчета();
	
КонецПроцедуры

// Процедура - обработчик события ОкончаниеВводаТекста поля НомерСчета.
//
&НаКлиенте
Процедура НомерСчетаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
		
		Если ЯвляетсяБанкомРФ И СтрДлина(Текст) > 20 Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Введенное значение превышает допустимую длину номера счета 20 символов!'");
			Сообщение.Сообщить();
			
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаЭДОНажатие(Элемент)
	
	Обработчик = Новый ОписаниеОповещения("ПослеСозданияНастройкиЭДО", ЭтотОбъект);
	ОбменСБанкамиКлиент.ОткрытьСоздатьНастройкуОбмена(
		Объект.Владелец, Объект.Банк, Объект.НомерСчета, Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСозданияНастройкиЭДО(НастройкаЭДО, Параметры) Экспорт
	
	Элементы.НастройкаЭДО.Заголовок = ОбменСБанкамиКлиентСервер.ЗаголовокНастройкиОбменаСБанком(
		Объект.Владелец, Объект.Банк);
	
КонецПроцедуры	

&НаКлиенте
Процедура НомерСчетаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
#Если НЕ ВебКлиент Тогда
	
	ТекущийТекстНомераСчета = СтрЗаменить(Текст, " ", "");
	
	Если ЯвляетсяБанкомРФ И ТекущийТекстНомераСчета <> Неопределено Тогда
		
		ДлинаСчетаРФ = 20;
		КоличествоЦифрВСчете = СтрДлина(ТекущийТекстНомераСчета);
		
		Если ДлинаСчетаРФ <> КоличествоЦифрВСчете Тогда
			ТекстСообщения = Нстр("ru = 'Осталось ввести %1'");
			СклоняемыйТекст = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
							Нстр("ru = ';%1 цифру;;%1 цифры;%1 цифр;%1 цифры'"), ДлинаСчетаРФ - КоличествоЦифрВСчете);
			
			Элементы.НомерСчета.Подсказка = СтрШаблон(ТекстСообщения,СклоняемыйТекст);
		Иначе
			Элементы.НомерСчета.Подсказка = "";
		КонецЕсли;
		
	Иначе
		Элементы.НомерСчета.Подсказка = "";
	КонецЕсли;
	
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет значения полей БИК и КоррСчет.
//
&НаСервереБезКонтекста
Процедура ЗаполнитьБИКиКоррСчет(Банк, Бик, КоррСчет)
	
	Если НЕ ЗначениеЗаполнено(Банк) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Бик = Банк.Код;
	КоррСчет = Банк.КоррСчет;
	
КонецПроцедуры // ЗаполнитьБИКиКоррСчет()

// Процедура заполняет значения поля ТекстКорреспондента.
//
&НаСервере
Процедура ЗаполнитьТекстКорреспондента()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.Владелец);
		
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Организации") Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Организации.НаименованиеПолное
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Ссылка";
		
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Контрагенты.НаименованиеПолное
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка = &Ссылка";
		
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстКорреспондента = СокрЛП(Выборка.НаименованиеПолное);
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьТекстКорреспондента()

// Процедура открывает форму списка банков для ручного выбора
//
&НаКлиенте
Процедура ОткрытьФормуВыбораБанка(ЭтоБанк, СписокНайденныхБанков = Неопределено)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", ?(ЭтоБанк, Объект.Банк, Объект.БанкРасчетов));
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормы.Вставить("МножественныхВыбор", Ложь);
	
	Если СписокНайденныхБанков <> Неопределено Тогда
		
		ПараметрыФормы.Вставить("СписокНайденныхБанков", СписокНайденныхБанков);
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Банки.ФормаВыбора", ПараметрыФормы, ?(ЭтоБанк, Элементы.Банк, Элементы.БанкРасчетов));
	
КонецПроцедуры // ОткрытьФормуВыбораБанка()

&НаСервереБезКонтекста
Функция ДеятельностьБанкаПрекращена(БИК)
	
	Результат = Ложь;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КлассификаторБанков.ДеятельностьПрекращена
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков
	|ГДЕ
	|	КлассификаторБанков.Код = &БИК";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("БИК", БИК);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.ДеятельностьПрекращена;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокБанковПоРеквизитам(Знач Поле, Знач Значение) Экспорт

	СписокБанков = Новый СписокЗначений;
	
	Если ПустаяСтрока(Значение) Тогда
	
		Возврат СписокБанков;
		
	КонецЕсли;
	
	ТаблицаБанков = Справочники.Банки.ПолучитьТаблицуБанковПоРеквизитам(Поле, Значение);
	
	СписокБанков.ЗагрузитьЗначения(ТаблицаБанков.ВыгрузитьКолонку("Ссылка"));
	
	Возврат СписокБанков;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПроверитьКорректностьНомераСчета(Номер, ВалютныйСчет = Ложь, ТекстОшибки = "")

	Результат = Истина;
	
	Если ПустаяСтрока(Номер) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ТекстОшибки = "";
	Если НЕ ВалютныйСчет И СтрДлина(Номер) <> 20 Тогда
		
		ТекстОшибки = НСтр("ru = 'Возможно номер счета указан не полностью'");
		Результат = Ложь;
		
	ИначеЕсли НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Номер) Тогда
		
		ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", " ") +
			НСтр("ru = 'В номере банковского счета присутствуют не только цифры.
				|Возможно, номер указан неверно'");
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПроверитьКорректностьБИК(БИК, ТекстОшибки = "")
	
	Если ПустаяСтрока(БИК) Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	ТекстОшибки = "";
	Если СтрДлина(БИК) <> 9 Тогда
		
		ТекстОшибки = НСтр("ru = 'По указанному БИК банк не найден. Возможно БИК указан не полностью.'");
		
	ИначеЕсли НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(БИК) Тогда
		
		ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", " ") +
			НСтр("ru = 'В составе БИК банка должны быть только цифры'");
		
	ИначеЕсли НЕ Лев(БИК, 2) = "04" Тогда
		
		ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", " ") +
			НСтр("ru = 'Первые 2 цифры БИК банка должны быть ""04""'");
		
	КонецЕсли;
	
	Возврат ПустаяСтрока(ТекстОшибки);
	
КонецФункции

// Функция возвращает список значений с банком/банками подходящих условию поиска
// 
// В случае неудачи возвращает Неопределено или пустой список значений.
//
&НаКлиенте
Функция НайтиБанки(ТекстДляПоиска, Поле, Валютный = Ложь)
	
	Перем ТекстОшибки;
	
	ЭтоБанк = (Поле = "БИКБанка") ИЛИ (Поле = "КоррСчетБанка");
	ОчититьЗначенияВСвязаныхПоляхФормы(ЭтоБанк);
	
	Если ПустаяСтрока(ТекстДляПоиска) Тогда
		
		ОчиститьСообщения();
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Поле ""%1"" заполнено не корректно.'"), 
			?(СтрНайти(Поле, "БИК") > 0, "БИК", "Корр. счет")
			);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, Поле);
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Если СтрНайти(Поле, "БИК") = 1 Тогда
		
		ОбластьПоиска = "Код";
		
	ИначеЕсли СтрНайти(Поле, "КоррСчет") = 1 Тогда
		
		ОбластьПоиска = "КоррСчет";
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	СписокНайденныхБанков = ПолучитьСписокБанковПоРеквизитам(ОбластьПоиска, ТекстДляПоиска);
	Если СписокНайденныхБанков.Количество() = 0 Тогда
		
		Если ОбластьПоиска = "Код" Тогда
			
			Если НЕ ПроверитьКорректностьБИК(ТекстДляПоиска, ТекстОшибки) Тогда
				
				ОчиститьСообщения();
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,, Поле);
				Возврат Неопределено;
				
			КонецЕсли;
			
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Банк с БИК ""%1"" не найден в справочнике банков'"), ТекстДляПоиска);
			
		ИначеЕсли ОбластьПоиска = "КоррСчет" Тогда
			
			Если НЕ ПроверитьКорректностьНомераСчета(ТекстДляПоиска, Валютный, ТекстОшибки) Тогда
				ОчиститьСообщения();
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,, Поле);
				Возврат Неопределено;
			КонецЕсли;
			
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Банк с корр. счетом ""%1"" не найден в справочнике банков'"), ТекстДляПоиска);
			
		КонецЕсли;
		
		// Сформируем варианты
		Кнопки	= Новый СписокЗначений;
		Кнопки.Добавить("Выбрать",     НСтр("ru = 'Выбрать из справочника'"));
		Кнопки.Добавить("Отменить",   НСтр("ru = 'Отменить ввод'"));
		
		// Обработка выбора
		ОписаниеОповещения = Новый ОписаниеОповещения("ОпределитьНеобходимостьВыбораБанкаИзСправочника", ЭтотОбъект, Новый Структура("ЭтоБанк", ЭтоБанк));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,, "Выбрать", НСтр("ru = 'Банк не найден'"));
		Возврат Неопределено;
		
	ИначеЕсли ОбластьПоиска = "Код" И СписокНайденныхБанков.Количество() = 1 Тогда
		
		Если Поле = "БИКБанкаДляРасчетов" Тогда
			
			ДеятельностьБанкаНепрямыхРасчетовПрекращена = ДеятельностьБанкаПрекращена(ТекстДляПоиска);
			
		Иначе
			
			ДеятельностьБанкаПрекращена = ДеятельностьБанкаПрекращена(ТекстДляПоиска);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СписокНайденныхБанков;
	
КонецФункции // НайтиБанки()

// Процедура управления элементами формы.
//
&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ВидимостьРеквизитовБанкаРасчетов = ЯвляетсяБанкомРФ Или Не ЗначениеЗаполнено(Объект.Банк);
	Элементы.ГруппаБанкРасчетов.Видимость = ВидимостьРеквизитовБанкаРасчетов;
	
	Если ВидимостьРеквизитовБанкаРасчетов Тогда
		// Установим использование банка для расчетов.
		ИспользуетсяБанкДляРасчетов = ЗначениеЗаполнено(Объект.БанкРасчетов);
		
		Элементы.КоррСчетБанкаДляРасчетов.Видимость = ИспользуетсяБанкДляРасчетов;
		Элементы.БанкРасчетов.Видимость             = ИспользуетсяБанкДляРасчетов;
		Элементы.БанкРасчетовГород .Видимость       = ИспользуетсяБанкДляРасчетов;
	КонецЕсли;
	
	// Установим редактирования текста наименования орагнизации.
	РедактироватьТекстКорреспондента = ЗначениеЗаполнено(Объект.ТекстКорреспондента);
	Элементы.ТекстПлательщика.Доступность = РедактироватьТекстКорреспондента;
	Элементы.ТекстПолучателя.Доступность = РедактироватьТекстКорреспондента;
	
	Если РедактироватьТекстКорреспондента Тогда
		ТекстКорреспондента = Объект.ТекстКорреспондента;
	Иначе
		ЗаполнитьТекстКорреспондента();
	КонецЕсли;
	
	// Настройка печати.
	Элементы.ГруппаРеквизитыСчетаОрганизации.Видимость = (ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Организации"));
	Элементы.ГруппаРеквизитыСчетаКонтрагента.Видимость = НЕ (ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Организации"));
	
	УстановитьТекстНастройкиЭДО(ЭтотОбъект);
	
КонецПроцедуры // УправлениеЭлементамиФормы()

// Функция формирует наименование банковского счета.
//
&НаСервере
Процедура ЗаполнитьСписокВариантовПредставленийСчета()
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	НаименованиеБанка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Банк, "Наименование");
	
	СтрокаНаименования = СокрЛп(Объект.НомерСчета) + ?(ЗначениеЗаполнено(НаименованиеБанка), ", в " + Строка(НаименованиеБанка), "");
	СтрокаНаименования = Лев(СтрокаНаименования, 100);
	
	Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	
	СтрокаНаименования = ?(ЗначениеЗаполнено(НаименованиеБанка), Строка(НаименованиеБанка), "") + " (" + Строка(Объект.ВалютаДенежныхСредств) + ")";
	СтрокаНаименования = Лев(СтрокаНаименования, 100);
	
	Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	
КонецПроцедуры // ЗаполнитьСписокВариантовПредставленийСчета()

// Процедура очищает значения полей в связанных полях формы
//
// Актуальна для случая, когда пользователь откроет форму выбора и откажеться от выбора значения.
//
&НаКлиенте
Процедура ОчититьЗначенияВСвязаныхПоляхФормы(ЭтоБанк)
	
	Если ЭтоБанк Тогда
		
		Объект.Банк = Неопределено;
		БИКБанка = "";
		КоррСчетБанка = "";
		
	Иначе
		
		Объект.БанкРасчетов = Неопределено;
		БИКБанкаДляРасчетов = "";
		КоррСчетБанкаДляРасчетов = "";
		
	КонецЕсли;
	
КонецПроцедуры // ОчититьЗначенияВСвязаныхПоляхФормы()

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекстНастройкиЭДО(Форма)

	Форма.Элементы.НастройкаЭДО.Видимость = ЗначениеЗаполнено(Форма.Объект.Владелец)
		И (ТипЗнч(Форма.Объект.Владелец) = Тип("СправочникСсылка.Организации"));
	Если Форма.Элементы.НастройкаЭДО.Видимость Тогда
		Форма.Элементы.НастройкаЭДО.Заголовок = ОбменСБанкамиКлиентСервер.ЗаголовокНастройкиОбменаСБанком(
			Форма.Объект.Владелец, Форма.Объект.Банк);
		Если НЕ ЗначениеЗаполнено(Форма.Элементы.НастройкаЭДО.Заголовок) Тогда
			Форма.Элементы.НастройкаЭДО.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // УстановитьТекстНастройкиЭДО()

// Заполняет данные банка и информацию о настройках прямого обмена.
//
&НаСервереБезКонтекста
Процедура ЗаполнитьДанныеБанка(БИКБанка, КоррСчетБанка, ЯвляетсяБанкомРФ, Знач Банк, Знач ВладелецСчета)

	РеквизитыБанка = Справочники.Банки.РеквизитыБанка(Банк);
	
	Если РеквизитыБанка.ЯвляетсяБанкомРФ Тогда 
		БИКБанка = РеквизитыБанка.Код;
	Иначе
		БИКБанка = РеквизитыБанка.СВИФТБИК;
	КонецЕсли;
	
	КоррСчетБанка = РеквизитыБанка.КоррСчет;
	ЯвляетсяБанкомРФ = РеквизитыБанка.ЯвляетсяБанкомРФ;

КонецПроцедуры // ЗаполнитьДанныеБанка()

// Процедура изменяет длину номера счета, в зависимости от того, 
// является ли счет иностранным или российским.
//
// Параметры:
//  ЯвляетсяБанкомРФ - Булево -  признак российского банка.
//
&НаСервере
Процедура ИзменитьДлинуНомераСчета(ЯвляетсяБанкомРФ)
	
	ПолеНомераСчета = Элементы.НомерСчета;
	
	Если ЯвляетсяБанкомРФ Тогда
		ПолеНомераСчета.ОграничениеТипа = УправлениеНебольшойФирмойКлиентСервер.ТипНомерСчета();
	Иначе
		ПолеНомераСчета.ОграничениеТипа = УправлениеНебольшойФирмойКлиентСервер.ТипМеждународныйНомерСчета();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает список выбора с банками по реквизитам поиска: код, SWIFT или наименование.
//
// Параметры:
//  Параметры - Структура - см. описание параметра обработчика Автоподбор
// 
// Возвращаемое значение:
//  СписокЗначений - список с выбранными банками.
//
&НаСервереБезКонтекста
Функция ДанныеВыбораБанка(Параметры)
	
	// Для числовой строки использует поиск по коду банка, в остальных случаях поиск идет по коду, SWIFT и наименованию банка.
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Параметры.СтрокаПоиска) Тогда
		
		СтрокаПоиска = Параметры.СтрокаПоиска + "%";
		
		ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка КАК Ссылка,
		|	Банки.Код КАК ПолеПоиска,
		|	Банки.Наименование КАК ПолеРасшифровки,
		|	0 КАК Сортировка,
		|	0 КАК Упорядочивание
		|ИЗ
		|	Справочник.Банки КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.Код ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка,
		|	Банки.Код,
		|	Банки.Наименование,
		|	0,
		|	1
		|ИЗ
		|	Справочник.КлассификаторБанков КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.Код ПОДОБНО &СтрокаПоиска
		|
		|УПОРЯДОЧИТЬ ПО
		|	Упорядочивание,
		|	ПолеПоиска";

	Иначе
		
		// Для повышения производительности в файловом режиме используем индексируемый поиск по началу строки.
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			СтрокаПоиска = Параметры.СтрокаПоиска + "%";
		Иначе
			СтрокаПоиска = "%" + Параметры.СтрокаПоиска + "%";
		КонецЕсли;
		
		ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка КАК Ссылка,
		|	Банки.Код КАК ПолеПоиска,
		|	Банки.Наименование КАК ПолеРасшифровки,
		|	0 КАК Сортировка
		|ИЗ
		|	Справочник.Банки КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.Код ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка,
		|	Банки.СВИФТБИК,
		|	Банки.Наименование,
		|	0
		|ИЗ
		|	Справочник.Банки КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.СВИФТБИК ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка,
		|	Банки.Наименование,
		|	ВЫБОР
		|		КОГДА Банки.Страна = &СтранаРФ
		|			ТОГДА Банки.Код
		|		ИНАЧЕ Банки.СВИФТБИК
		|	КОНЕЦ,
		|	1
		|ИЗ
		|	Справочник.Банки КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.Наименование ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка,
		|	Банки.Наименование,
		|	Банки.Код,
		|	2
		|ИЗ
		|	Справочник.КлассификаторБанков КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.Наименование ПОДОБНО &СтрокаПоиска
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сортировка,
		|	ПолеПоиска";
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("СтрокаПоиска",СтрокаПоиска);
	Запрос.УстановитьПараметр("СтранаРФ", Справочники.СтраныМира.Россия);
	
	Результат = Запрос.Выполнить();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Если Результат.Пустой() Тогда
		Возврат ДанныеВыбора;
	КонецЕсли;
	
	МаксКоличествоВыбранных = 20;
	
	РезультатыОтбора = Новый Соответствие;
	РезультатыОтбора.Вставить("ПолеПоиска");
	
	ШрифтВыделения = Новый Шрифт(,,Истина);
	ЦветВыделения  = ЦветаСтиля.ЦветУспешногоПоиска;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если РезультатыОтбора.Количество() >= МаксКоличествоВыбранных Тогда
			Прервать;
		КонецЕсли;
		
		Если ТипЗнч(Выборка.Ссылка) <> Тип("СправочникСсылка.Банки")
			И РезультатыОтбора.Получить(Выборка.ПолеПоиска) <> Неопределено Тогда
			
			Продолжить;
		КонецЕсли;
		
		РезультатыОтбора.Вставить(Выборка.ПолеПоиска, Выборка.ПолеПоиска);
		
		// Для каждой строки результата формируем представление, аналогично платформенному.
		ПредставлениеСтроки = Новый Массив;
		ИсходнаяСтрока = СокрЛП(Выборка.ПолеПоиска);
		ВыделяемаяЧасть = Параметры.СтрокаПоиска;
		ПолеРасшифровки = СокрЛП(Выборка.ПолеРасшифровки);
		
		// Находим и выделяем цветом часть строки, которая была введена пользователем.
		Поз = СтрНайти(ВРег(ИсходнаяСтрока), ВРег(Параметры.СтрокаПоиска),, 1);
		ВыделяемаяПодстрока = Сред(ИсходнаяСтрока, Поз, СтрДлина(ВыделяемаяЧасть));
		ФорматВыделяемаяСтрока = Новый ФорматированнаяСтрока(ВыделяемаяПодстрока, ШрифтВыделения, ЦветВыделения);
		
		// Находим оставшуюся часть строки и формируем массив из введенной пользователем строки и оставшейся части.
		Если Поз = 1 Тогда
			// Часть введенной пользователем строки находится в начале, значит оставшуюся строку нужно искать с конца.
			ПредставлениеСтроки.Добавить(ФорматВыделяемаяСтрока);
			ПредставлениеСтроки.Добавить(Новый ФорматированнаяСтрока(Прав(ИсходнаяСтрока, СтрДлина(ИсходнаяСтрока) - СтрДлина(ВыделяемаяЧасть))));
		ИначеЕсли Поз = СтрДлина(ИсходнаяСтрока) Тогда
			// Часть введенной пользователем строки находится в конце, значит оставшуюся строку  искать с начала.
			ПредставлениеСтроки.Добавить(Новый ФорматированнаяСтрока(Лев(ИсходнаяСтрока, Поз-1)));
			ПредставлениеСтроки.Добавить(ФорматВыделяемаяСтрока);
		Иначе
			// Часть введенной пользователем строки находится в середине, значит оставшуюся строку нужно искать в начале и в конце.
			ПредставлениеСтроки.Добавить(Новый ФорматированнаяСтрока(Лев(ИсходнаяСтрока, Поз-1)));
			ПредставлениеСтроки.Добавить(ФорматВыделяемаяСтрока);
			ПредставлениеСтроки.Добавить(Новый ФорматированнаяСтрока(Сред(ИсходнаяСтрока, Поз + СтрДлина(ВыделяемаяЧасть))));
		КонецЕсли;
		
		КодЯвляетсяРасшифровкой = ?(Выборка.Сортировка = 0, Истина, Ложь);
		
		Если КодЯвляетсяРасшифровкой Тогда
			ДанныеВыбора.Добавить(Выборка.Ссылка, Новый ФорматированнаяСтрока(ПредставлениеСтроки, " ", ПолеРасшифровки));
		Иначе
			ДанныеВыбора.Добавить(Выборка.Ссылка, Новый ФорматированнаяСтрока(ПолеРасшифровки, " ", ПредставлениеСтроки));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

&НаСервереБезКонтекста
Функция БанкИзКлассификатора(КлассификаторБанков)
	
	Результат = РаботаСБанкамиПереопределяемый.БанкИзКлассификатора(КлассификаторБанков);
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьНаименованиеБанка()
	
	НаименованиеБанка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Банк, "Наименование");
	Объект.Наименование = Лев(СокрЛп(Объект.НомерСчета) + ?(ЗначениеЗаполнено(НаименованиеБанка), ", в " + НаименованиеБанка, ""), 100);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьОсновнойСчет(СтруктураПараметров)
	
	ВладелецОбъект = СтруктураПараметров.Владелец.ПолучитьОбъект();
	ВладелецУспешноЗаблокирован = Истина;
	
	Попытка
		ВладелецОбъект.Заблокировать();
	Исключение
		
		ВладелецУспешноЗаблокирован = Ложь;
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось заблокировать %1: %2, для изменения основного банковского счета, по причине:
				|%3'", Метаданные.ОсновнойЯзык.КодЯзыка), 
				Строка(СтруктураПараметров.Владелец), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Предупреждение,, ВладелецОбъект, ОписаниеОшибки());
		
	КонецПопытки;
	
	// Если удалось заблокировать, изменим банковский счет по умолчанию у контрагента/организации
	Если ВладелецУспешноЗаблокирован Тогда
		ВладелецОбъект.БанковскийСчетПоУмолчанию = СтруктураПараметров.НовыйОсновнойСчет;
		ВладелецОбъект.Записать();
		СтруктураПараметров.УстановленОсновнойСчет = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоЕдинственныйСчетВладельца(Владелец)
	
	// Устанавливаем счет по-умолчанию только если он единственный у владельца
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	БанковскиеСчета.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|ГДЕ
		|	БанковскиеСчета.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	ВыборкаСчетов = Запрос.Выполнить().Выбрать();
	
	Возврат (ВыборкаСчетов.Количество() = 1);
	
КонецФункции

&НаКлиенте
Процедура УстановитьМаскуНомераСчета()
	
	Если ЯвляетсяБанкомРФ Тогда
		Элементы.НомерСчета.Маска = "99999999999999999999";
	Иначе
		Элементы.НомерСчета.Маска = "";
		Элементы.НомерСчета.Подсказка = "";
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
// Процедура-обработчик результата вопроса о подборе банка из классификатора
//
//
Процедура ОпределитьНеобходимостьВыбораБанкаИзСправочника(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = "Выбрать" Тогда
		
		ОткрытьФормуВыбораБанка(ДополнительныеПараметры.ЭтоБанк);
		
	КонецЕсли;
	
КонецПроцедуры // ОпределитьНеобходимостьПодбораБанкаИзКлассификатора()

#КонецОбласти

#Область Эквайринг

&НаСервере
Процедура ПроверитьВозможностьИзменений(Отказ)
	
	Если ВалютаДенежныхСредств = Объект.ВалютаДенежныхСредств Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЭквайринговыеТерминалы.Договор
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	ЭквайринговыеТерминалы.БанковскийСчетЭквайринг = &БанковскийСчетЭквайринг";
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("БанковскийСчетЭквайринг", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТекстСообщения = НСтр("ru = 'В базе присутствуют эквайринговые терминалы, в которых выбран текущий банковский счет. Изменение валюты расчетов запрещено.'");
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(ЭтаФорма, ТекстСообщения, , , "Объект.ВалютаДенежныхСредств", Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти
