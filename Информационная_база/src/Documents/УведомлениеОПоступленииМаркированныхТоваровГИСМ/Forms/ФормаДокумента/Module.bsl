
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Элементы.Подразделение.Видимость = ИнтеграцияГИСМ.ИспользоватьПодразделения();
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = Неопределено;
	ИнтеграцияГИСМПереопределяемый.ВалютаРегламентированногоУчета(ВалютаРегламентированногоУчета);
	Элементы.НомераКиЗСтоимость.Заголовок = СтрЗаменить(НСтр("ru = 'Стоимость (%Валюта%)'"), "%Валюта%", ВалютаРегламентированногоУчета);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьСтатусГИСМ();
	
	ЗаполнитьПредставлениеТоваровУведомленияОПоступлении();
	
	РазблокироватьДанныеДляРедактирования(ТекущийОбъект.Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи = Новый Структура;
	Оповестить("Запись_УведомлениеОПоступленииМаркированныхТоваровГИСМ", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСостоянияГИСМ"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Если Параметр.ОбновленоСостояниеПодтверждения Тогда
			Прочитать();
		Иначе
			ОбновитьСтатусГИСМ();
		КонецЕсли
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусГИСМФормахВДокументах)) Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ИнтеграцияГИСМКлиентПереопределяемый.ОбработатьВыборНовогоКонтрагента(ВыбранноеЗначение, ИсточникВыбора, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНомераКиЗ

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Уведомление о поступлении маркированных товаров ГИСМ не проведено. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Уведомление о поступлении маркированных товаров ГИСМ было изменено. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать();
	КонецЕсли;
	
	Если Не Модифицированность И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНомераКиЗ

&НаКлиенте
Процедура НомераКиЗПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.НомераКиЗ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Элемент.ТекущийЭлемент.Имя = "НомераКиЗДокументПоступления" Тогда
		ЗаполнитьСписокВыбораПоляДокументПоступления(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомераКиЗДокументПоступленияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НомераКиЗ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ДокументПоступления) Тогда
		ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить");
	Иначе
		НайденныеСтроки = КандидатыВДокументыПоступления.НайтиСтроки(Новый Структура("НомерКиЗ", ТекущиеДанные.НомерКиЗ));
		Если НайденныеСтроки.Количество() > 0 Тогда
			ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ВыбратьПоступление");
		Иначе
			ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ОжидаетсяПоступление");
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьПредставлениеТоваровУведомленияОПоступлении();
	
КонецПроцедуры

&НаКлиенте
Процедура НомераКиЗВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.НомераКиЗ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "НомераКиЗДокументПоступления"
		И ЗначениеЗаполнено(ТекущиеДанные.ДокументПоступления)
		И (ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.КПередаче")
		   Или ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.Передано")
		   Или ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ПринятоГИСМ")) Тогда
		ПоказатьЗначение(, ТекущиеДанные.ДокументПоступления);
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.НомераКиЗНоменклатураПредставление Тогда
		
		ТекущиеДанные = Элементы.НомераКиЗ.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
			ПоказатьЗначение(Неопределено, ТекущиеДанные.Номенклатура);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомераКиЗДокументПоступленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Не КандидатыВДокументыПоступленияЗаполнены Тогда
		
		ЗаполнитьПоПоступлениямСервер(Ложь);
		ОтключитьОтметкуНезаполненного();
		
		ТекущиеДанные = Элементы.НомераКиЗ.ТекущиеДанные;
		ЗаполнитьСписокВыбораПоляДокументПоступления(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура СопоставитьПоИННКПП(Команда)
	
	ОчиститьСообщения();
	
	КонтрагентНайден = СопоставитьПоИННКППСервер();
	
	Если Не КонтрагентНайден Тогда
		Если ЕстьПравоСозданияКонтрагента Тогда
			ТекстВопроса = НСтр("ru='Контрагент с указанными ИНН и КПП не найден. Создать нового?'");
			ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьНовогоКонтрагента", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Контрагент с указанными ИНН и КПП не найден.'"),
			                                                  ,
			                                                  "GLNКонтрагента",
			                                                  "Объект");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ.Форма.ФормаДокумента.ЗаписатьИЗакрыть");
	
	ОчиститьСообщения();
	
	Если Записать() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоступления(Команда)
	
	ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("ЗаполнитьПоступлениеЗавершение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Документы поступления по неподтвержденным КиЗ будут перезаполнены. Продолжить?'");
	ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоступлениеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	ЗаполнитьПоПоступлениямСервер(Истина);
	ОтключитьОтметкуНезаполненного();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборВыбратьПоступление(Команда)
	
	ИнтеграцияГИСМКлиент.УстановитьОтборСтрокВТЧ(ЭтотОбъект, "НомераКиЗ", ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ВыбратьПоступление"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборКПередаче(Команда)
	
	ИнтеграцияГИСМКлиент.УстановитьОтборСтрокВТЧ(ЭтотОбъект, "НомераКиЗ", ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.КПередаче"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборОжидаетсяПоступление(Команда)
	
	ИнтеграцияГИСМКлиент.УстановитьОтборСтрокВТЧ(ЭтотОбъект, "НомераКиЗ", ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ОжидаетсяПоступление"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПередано(Команда)
	
	ИнтеграцияГИСМКлиент.УстановитьОтборСтрокВТЧ(ЭтотОбъект, "НомераКиЗ", ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.Передано"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПодтвердить(Команда)
	
	ИнтеграцияГИСМКлиент.УстановитьОтборСтрокВТЧ(ЭтотОбъект, "НомераКиЗ", ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборОтклоненоГИСМ(Команда)
	
	ИнтеграцияГИСМКлиент.УстановитьОтборСтрокВТЧ(ЭтотОбъект, "НомераКиЗ", ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ОтклоненоГИСМ"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПолучениеВыделенныхСтрок(Команда)
	
	ВыделенныеСтроки = Элементы.НомераКиЗ.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не выбрано ни одной строки для подтверждения.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	КоличествоУстановленныхСостоянийКПодтверждению = 0;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		ТекущиеДанные = Элементы.НомераКиЗ.ДанныеСтроки(ВыделеннаяСтрока);
		Если ТекущиеДанные = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если (ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить")
			Или ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ОтклоненоГИСМ"))
			И ЗначениеЗаполнено(ТекущиеДанные.ДокументПоступления) Тогда
			
			ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.КПередаче");
			КоличествоУстановленныхСостоянийКПодтверждению = КоличествоУстановленныхСостоянийКПодтверждению + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Если КоличествоУстановленныхСостоянийКПодтверждению > 0 Тогда
		ТекстОповещения = НСтр("ru = 'Состояние ""К передаче"" установлено для %1 из %2 строк'");
		ТекстОповещения = СтрШаблон(ТекстОповещения, КоличествоУстановленныхСостоянийКПодтверждению, КоличествоУстановленныхСостоянийКПодтверждению);
	Иначе
		ТекстОповещения = НСтр("ru = 'Отсутствуют строки с состоянием ""Подтвердить"" или ""Отклонено ГИСМ""'");
	КонецЕсли;
	ТекстЗаголовка  = НСтр("ru = 'Подтверждение получения'");
	ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстОповещения, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПолучение(Команда)
	
	КоличествоСтрок = Объект.НомераКиЗ.Количество();
	Если КоличествоСтрок = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Нет строк для подтверждения.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	КоличествоУстановленныхСостоянийКПодтверждению = ПодтвердитьПолучениеСервер();
	
	Если КоличествоУстановленныхСостоянийКПодтверждению > 0 Тогда
		ТекстОповещения = НСтр("ru = 'Состояние ""К передаче"" установлено для %1 из %2 строк'");
		ТекстОповещения = СтрШаблон(ТекстОповещения, КоличествоУстановленныхСостоянийКПодтверждению, КоличествоУстановленныхСостоянийКПодтверждению);
	Иначе
		ТекстОповещения = НСтр("ru = 'Отсутствуют строки с состоянием ""Подтвердить"" или ""Отклонено ГИСМ""'");
	КонецЕсли;
	ТекстЗаголовка  = НСтр("ru = 'Подтверждение получения'");
	ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстОповещения, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПринятоГИСМ(Команда)
	
	ИнтеграцияГИСМКлиент.УстановитьОтборСтрокВТЧ(ЭтотОбъект, "НомераКиЗ", ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ПринятоГИСМ"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьGLNПоИННКПП(Команда)
	
	ИнтеграцияГИСМКлиент.ПолучитьGLNПоИННКПП(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераКиЗНоменклатураПредставление.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НомераКиЗ.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Не поступало>'"));
	
#Область НомераКиЗ

	СписокСостоянийНедоступныИзменения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.СписокСостоянийНедоступныИзмененияПоступления();
	
	СписокСостоянийНеТребуетсяПоступление = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.СписокСостоянийНеТребуетсяПоступление();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераКиЗДокументПоступления.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.НомераКиЗ.СостояниеПодтверждения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСостоянийНедоступныИзменения;
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераКиЗДокументПоступления.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.НомераКиЗ.СостояниеПодтверждения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСостоянийНеТребуетсяПоступление;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераКиЗСостояниеПодтверждения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.НомераКиЗ.СостояниеПодтверждения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ОтклоненоГИСМ;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
	
#КонецОбласти
	
КонецПроцедуры

#Область СопоставлениеПартнеров

&НаСервере
Функция ДанныеДокументаИзСообщенияXML()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ГИСМПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	|	И ГИСМПрисоединенныеФайлы.Операция = &Операция
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = &ТипСообщения");
	
	Запрос.УстановитьПараметр("ТипСообщения",  Перечисления.ТипыСообщенийГИСМ.Входящее);
	Запрос.УстановитьПараметр("Операция",      Перечисления.ОперацииОбменаГИСМ.ПолучениеТоваров);
	Запрос.УстановитьПараметр("ВладелецФайла", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		КонвертSOAP = ИнтеграцияГИСМВызовСервера.КонвертSOAPИзПротокола(Выборка.Ссылка);
		
		Данные = ИнтеграцияГИСМВызовСервера.ОбработатьОтветНаЗапросПолученияДокумента(КонвертSOAP, Неопределено);
		
		ДанныеДокументаИзСообщенияXML = Данные;
		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

&НаСервере
Функция СопоставитьПоИННКППСервер()
	
	Если Не ЗначениеЗаполнено(ДанныеДокументаИзСообщенияXML) Тогда
		Данные = ДанныеДокументаИзСообщенияXML();
	Иначе
		Данные = ДанныеДокументаИзСообщенияXML;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные) Тогда
		Контрагент = ИнтеграцияГИСМ.КонтрагентПоДаннымXML(Данные.Результат.ДанныеДокумента, Данные.Результат.ДанныеОтправителя);
		Если ЗначениеЗаполнено(Контрагент) Тогда
			Объект.Контрагент = Контрагент;
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура СоздатьНовогоКонтрагента(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеДокументаИзСообщенияXML) Тогда
		Данные = ДанныеДокументаИзСообщенияXML();
	Иначе
		Данные = ДанныеДокументаИзСообщенияXML;
	КонецЕсли;
	
	Если Данные = Неопределено Тогда
		ДанныеКонтрагента = Неопределено;
	Иначе
		ДанныеКонтрагента = ИнтеграцияГИСМКлиентСервер.ДанныеКонтрагентаПоДаннымXML(Данные.Результат.ДанныеДокумента, Данные.Результат.ДанныеОтправителя);
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ИнтеграцияГИСМКлиентПереопределяемый.ОткрытьФормуСозданияНовогоКонтрагента(ДанныеКонтрагента, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПодтвердитьПолучение" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаПодтверждения"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЗакрытьЗаявку" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ОбновитьСтатусГИСМ();
	ИнтеграцияГИСМПереопределяемый.ЗаполнитьПредставлениеТоваровУведомленияОПоступлении(Объект.НомераКиЗ);
	ЕстьПравоСозданияКонтрагента = ИнтеграцияГИСМ.ЕстьПравоСозданияКонтрагента();
	
	НомерГИСМ = Формат(Объект.НомерГИСМ, "ЧГ=");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусГИСМ()

	СтатусГИСМ         = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Получено;
	ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПустаяСсылка();
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Статусы.Статус,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПустаяСсылка)
		|		ИНАЧЕ Статусы.ДальнейшееДействие
		|	КОНЕЦ КАК ДальнейшееДействие,
		|	Статусы.СтатусПоступления,
		|	1 В
		|		(ВЫБРАТЬ ПЕРВЫЕ 1
		|			1
		|		ИЗ
		|			Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ.НомераКиЗ КАК Т
		|		ГДЕ
		|			Т.Ссылка = &УведомлениеОПоступлении
		|			И Т.СостояниеПодтверждения = ЗНАЧЕНИЕ(Перечисление.СостоянияОтправкиПодтвержденияГИСМ.КПередаче)) КАК КПередачеПодтверждения
		|ИЗ
		|	РегистрСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ КАК Статусы
		|ГДЕ
		|	Статусы.Документ = &УведомлениеОПоступлении");
		
		Запрос.УстановитьПараметр("УведомлениеОПоступлении", Объект.Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияГИСМ.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СтатусГИСМ         = Выборка.Статус;
			ДальнейшееДействие = Выборка.ДальнейшееДействие;
			
			Если Не ЗначениеЗаполнено(ДальнейшееДействие)
				И Выборка.КПередачеПодтверждения > 0 Тогда
				
				ДальнейшееДействие = Новый Массив;
				ДальнейшееДействие.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПодтвердитеПолучение);
				
			КонецЕсли;
			
		Иначе
			
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПодтвердитеПолучение);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ЗакройтеЗаявку);
	СтатусГИСМПредставление = ИнтеграцияГИСМ.ПредставлениеСтатусаГИСМ(
		СтатусГИСМ,
		ДальнейшееДействие,
		ДопустимыеДействия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПоступлениямСервер(ЗаполнитьДокументПоступленияВТабличнойЧасти = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	КандидатыВДокументыПоступленияЗаполнены = Истина;
	
	КандидатыВДокументыПоступления.Очистить();
	
	Запрос = Неопределено;
	ИнтеграцияГИСМПереопределяемый.ЗапросПоПоступившимКиЗ(Объект, Запрос);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ВыборкаНомераКиЗ = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаНомераКиЗ.Следующий() Цикл
		
		НоваяСтрокаКандидаты = КандидатыВДокументыПоступления.Добавить();
		НоваяСтрокаКандидаты.НомерКиЗ = ВыборкаНомераКиЗ.НомерКиЗ;
		ТекущийДокументПоступленияПравильный = Ложь;
		
		ВыборкаДетали = ВыборкаНомераКиЗ.Выбрать();
		Пока ВыборкаДетали.Следующий() Цикл
			
			Если ЗначениеЗаполнено(ВыборкаДетали.ДокументПоступленияКандидат) Тогда
				НоваяСтрокаКандидаты.СписокДокументовПоступления.Добавить(ВыборкаДетали.ДокументПоступленияКандидат);
			КонецЕсли;
			Если ВыборкаДетали.ДокументПоступления = ВыборкаДетали.ДокументПоступленияКандидат
				И ЗначениеЗаполнено(ВыборкаДетали.ДокументПоступления) Тогда
				ТекущийДокументПоступленияПравильный = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЗаполнитьДокументПоступленияВТабличнойЧасти Тогда
			
			Если Не ТекущийДокументПоступленияПравильный Тогда
				
				ПараметрыОтбора = Новый Структура();
				ПараметрыОтбора.Вставить("НомерКиЗ", ВыборкаНомераКиЗ.НомерКиЗ);
				НайденныеСтроки = Объект.НомераКиЗ.НайтиСтроки(ПараметрыОтбора);
				
				Для Каждого НайденнаяСтроки Из НайденныеСтроки Цикл
					
					КоличествоКандитатовВПоступление =  НоваяСтрокаКандидаты.СписокДокументовПоступления.Количество();
					Если КоличествоКандитатовВПоступление = 1 Тогда
						НайденнаяСтроки.ДокументПоступления = НоваяСтрокаКандидаты.СписокДокументовПоступления.Получить(0).Значение;
						НайденнаяСтроки.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить;
					Иначе
						НайденнаяСтроки.ДокументПоступления = Неопределено;
						Если КоличествоКандитатовВПоступление = 0 Тогда
							НайденнаяСтроки.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ОжидаетсяПоступление;
						Иначе
							НайденнаяСтроки.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ВыбратьПоступление;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИнтеграцияГИСМПереопределяемый.ЗаполнитьПредставлениеТоваровУведомленияОПоступлении(Объект.НомераКиЗ);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставлениеТоваровУведомленияОПоступлении()
	
	ИнтеграцияГИСМПереопределяемый.ЗаполнитьПредставлениеТоваровУведомленияОПоступлении(Объект.НомераКиЗ);
	
КонецПроцедуры

&НаСервере
Функция ПодтвердитьПолучениеСервер()
	
	КоличествоУстановленныхСостоянийКПодтверждению = 0;
	
	Для Каждого ТекСтрока Из Объект.НомераКиЗ Цикл
		
		Если (ТекСтрока.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить
			Или ТекСтрока.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ОтклоненоГИСМ)
			И ЗначениеЗаполнено(ТекСтрока.ДокументПоступления) Тогда
			
			ТекСтрока.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.КПередаче;
			КоличествоУстановленныхСостоянийКПодтверждению = КоличествоУстановленныхСостоянийКПодтверждению + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КоличествоУстановленныхСостоянийКПодтверждению;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСписокВыбораПоляДокументПоступления(ТекущиеДанные)
	
	Элементы.НомераКиЗДокументПоступления.СписокВыбора.Очистить();
	
	НайденныеСтроки = КандидатыВДокументыПоступления.НайтиСтроки(Новый Структура("НомерКиЗ", ТекущиеДанные.НомерКиЗ));
	Если НайденныеСтроки.Количество() > 0 Тогда
		Элементы.НомераКиЗДокументПоступления.СписокВыбора.ЗагрузитьЗначения(
		           НайденныеСтроки[0].СписокДокументовПоступления.ВыгрузитьЗначения());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
