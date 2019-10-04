
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НавигационнаяСсылка = "e1cib/app/" + ЭтотОбъект.ИмяФормы;
	
	УстановитьУсловноеОформление();
	
	Если Не ТорговыеПредложения.ПравоНастройкиТорговыхПредложений(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИспользоватьВидыНоменклатуры = Ложь;
	ТорговыеПредложенияПереопределяемый.ФункциональнаяОпцияИспользуется(ИмяФормы, ИспользоватьВидыНоменклатуры);
	Если Не ИспользоватьВидыНоменклатуры Тогда
		ТорговыеПредложенияПереопределяемый.СообщитьОНеобходимостиИспользованияФункциональнойОпции(
			ИмяФормы, ИспользоватьВидыНоменклатуры, Отказ);
		Возврат;
	КонецЕсли;
	
	ТаблицаТорговыхПредложений = Метаданные.НайтиПоТипу(Метаданные.ОпределяемыеТипы.ТорговоеПредложение.Тип.Типы()[0]);
	ЕстьПравоПросмотраТаблицыТорговыхПредложений = ПравоДоступа("Просмотр", ТаблицаТорговыхПредложений);
	Элементы.Добавить.Доступность = ЕстьПравоПросмотраТаблицыТорговыхПредложений;
	УстановитьЗапросДинамическогоСписка(ТаблицаТорговыхПредложений);
	
	ЗаполнитьСписокЗарегистрированныхОрганизаций();
	
	Элементы.СписокОрганизация.Видимость = ЭлектронноеВзаимодействиеСлужебный.ИспользуетсяНесколькоОрганизаций();
	
	АвтоматическиСинхронизировать = АвтоматическаяСинхронизацияВключена();
	Элементы.Расписание.Заголовок = ТекущееРасписание();
	Элементы.Расписание.Доступность = АвтоматическиСинхронизировать;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиСинхронизировать;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.НастроитьРасписание.Видимость = Ложь;
		Элементы.Расписание.Видимость = Ложь;
	КонецЕсли;
	
	ИмяОбъектаСоглашения = "Справочник." + Метаданные.НайтиПоТипу(Метаданные.РегистрыСведений.
		СостоянияСинхронизацииТорговыеПредложения.Измерения.ТорговоеПредложение.Тип.Типы()[0]).Имя;
		
	Элементы.СписокТорговоеПредложение.Заголовок = Метаданные.НайтиПоТипу(
		Метаданные.ОпределяемыеТипы.ТорговоеПредложение.Тип.Типы()[0]).ПредставлениеОбъекта;
		
	ВыполнитьДлительнуюОперацию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбработкаВыбораНаСервере(ВыбранноеЗначение);
	Элементы.Список.Обновить();
	
	Оповестить("ТорговыеПредложения_ИзменениеСинхронизации", ВыбранноеЗначение, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ТорговыеПредложения_ПослеЗаписи" Тогда
		
		Элементы.Список.Обновить();
		
	ИначеЕсли ИмяСобытия = "СинхронизацияТорговыхПредложений_ПриИзменении" Тогда
		
		АвтоматическиСинхронизировать = АвтоматическаяСинхронизацияВключена();
		Элементы.Расписание.Заголовок = ТекущееРасписание();
		Элементы.Расписание.Доступность = АвтоматическиСинхронизировать;
		Элементы.НастроитьРасписание.Доступность = АвтоматическиСинхронизировать;
		
	ИначеЕсли ИмяСобытия = "ТорговыеПредложения_ОбновлениеПубликаций" Тогда
		
		ВыполнитьДлительнуюОперацию();
		ОжидатьДлительнуюОперацию();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОжидатьДлительнуюОперацию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОчиститьСообщения();
	
	СтандартнаяОбработка = Ложь;
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		ПоляДополнительныхНастроек = "СписокАдресЭлектроннойПочты, СписокДополнительноеОписание,
			|СписокПубликоватьЦены, СписокПубликоватьСрокиПоставки, СписокПубликоватьОстатки";
		Если СтрНайти(ПоляДополнительныхНастроек, Поле.Имя) Тогда
			ОткрываемаяФорма = "РегистрСведений.СостоянияСинхронизацииТорговыеПредложения.Форма.НастройкиПубликации";
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("ТорговоеПредложение", Элементы.Список.ТекущиеДанные.ТорговоеПредложение);
			ОткрытьФорму(ОткрываемаяФорма, ПараметрыОткрытияФормы, ЭтотОбъект);
		Иначе
			ОчиститьСообщения();
			ОткрытьФорму(ИмяОбъектаСоглашения + ".ФормаОбъекта", Новый Структура("Ключ", Элементы.Список.ТекущиеДанные.ТорговоеПредложение));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	УдалитьВосстановитьПубликацию(Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Добавить(Команда)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Организация", ЗарегистрированныеОрганизации);
	ОчиститьСообщения();
	ОткрытьФорму(ИмяОбъектаСоглашения + ".ФормаВыбора", Новый Структура("Отбор", Отбор),ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВосстановитьПубликацию(Элемент, Отказ = Неопределено)

	Отказ = Истина;
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		ПараметрыМетода = НовыйПараметрыОбработкиСтрок();
		ПараметрыМетода.ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
		
		Если Элементы.Список.ТекущиеДанные.ДействиеСинхронизации = ПредопределенноеЗначение("Перечисление.ДействияСинхронизацииТорговыеПредложения.Удаление") Тогда
			Действие = НСтр("ru = 'Восстановить'");
			ПараметрыМетода.ЭтоОтменаУдаления = Истина;
		Иначе
			Действие = НСтр("ru = 'Удалить'");
			ПараметрыМетода.ЭтоУдаление = Истина;
		КонецЕсли;
		
		УдалитьВосстановитьПубликациюПродолжение = Новый ОписаниеОповещения("УдалитьВосстановитьПубликациюПродолжение",
			ЭтотОбъект, ПараметрыМетода);
			
		ТекстВопроса = СтрШаблон(НСтр("ru = '%1 публикацию торгового предложения?'"), Действие);
		
		ПоказатьВопрос(УдалитьВосстановитьПубликациюПродолжение,
			ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да,
			НСтр("ru = 'Удаление (восстановление) публикации.'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВключитьПубликацию(Элемент, Отказ = Неопределено)
	
	Отказ = Истина;
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		ПараметрыМетода = НовыйПараметрыОбработкиСтрок();
		ПараметрыМетода.ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
		
		Если Элементы.Список.ТекущиеДанные.Отключено = Истина Тогда
			Действие = НСтр("ru = 'Включить'");
			ПараметрыМетода.ЭтоВключениеПубликации = Истина;
		Иначе
			Действие = НСтр("ru = 'Отключить'");
			ПараметрыМетода.ЭтоОтключениеПубликации = Истина;
		КонецЕсли;
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтключитьВключитьПубликациюПродолжение",
			ЭтотОбъект, ПараметрыМетода);
			
		ТекстВопроса = СтрШаблон(НСтр("ru = '%1 публикацию торгового предложения?'"), Действие);
		
		ПоказатьВопрос(ОписаниеОповещения,
			ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да, НСтр("ru = 'Отключение (включение) публикации.'")); 
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьТорговыеПредложения(Команда)
	
	ОчиститьСообщения();
	
	ДлительнаяОперация = СинхронизацияТорговыхПредложенийВФоне();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,
		Новый ОписаниеОповещения("СинхронизироватьТорговыеПредложенияЗавершение", ЭтотОбъект), ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(ТекущееРасписание());
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиСинхронизироватьПриИзменении(Элемент)
	
	УстановитьПараметрРегламентногоЗадания("Использование", АвтоматическиСинхронизировать);
	Элементы.Расписание.Доступность = АвтоматическиСинхронизировать;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиСинхронизировать;
	
	Оповестить("СинхронизацияТорговыхПредложений_ПриИзменении");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПубликуемыеТорговыеПредложения(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("ПрайсЛист", ТекущиеДанные.ТорговоеПредложение);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	ОчиститьСообщения();
	ОткрытьФорму("Отчет.ПубликуемыеТорговыеПредложения.Форма", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПригласитьПокупателей(Команда)
	
	ОчиститьСообщения();
	
	// Приглашение покупателей в сервис.
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимПриглашения", "Покупатели");
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ОтправкаПриглашенийКонтрагентам", ПараметрыОткрытия);

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИдентификаторы(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОчиститьИдентификаторыПродолжение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'В программе будут очищены служебный идентификаторы публикуемых торговых предложений.
		|При синхронизации для публикуемых товаров в сервисе будут созданы новые идентификаторы.
		|Операция производится для текущей строки.
		|Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УдалитьВосстановитьПубликациюПродолжение(РезультатВопроса, ПараметрыМетода) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ИзменитьСостояниеПубликацииПрайсЛистов(ПараметрыМетода);
		Элементы.Список.Обновить();
		
		Оповестить("ТорговыеПредложения_ИзменениеСинхронизации",, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВключитьПубликациюПродолжение(РезультатВопроса, ПараметрыМетода) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ИзменитьСостояниеПубликацииПрайсЛистов(ПараметрыМетода);
		Элементы.Список.Обновить();
		
		Оповестить("ТорговыеПредложения_ИзменениеСинхронизации",, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработкаВыбораНаСервере(ТорговоеПредложение, ДополнительныеПараметры = Неопределено)
	
	Отбор = Новый Структура("ТорговоеПредложение", ТорговоеПредложение);
	Выборка = РегистрыСведений.СостоянияСинхронизацииТорговыеПредложения.Выбрать(Отбор);
	
	Если Не Выборка.Следующий() Тогда
		МенеджерЗаписи = РегистрыСведений.СостоянияСинхронизацииТорговыеПредложения.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ТорговоеПредложение = ТорговоеПредложение;
		
		// Заполнение организации.
		СвойстваПредложения = Новый Структура("Организация, Валюта");
		ТорговыеПредложенияПереопределяемый.ПолучитьСвойстваТорговогоПредложения(ТорговоеПредложение, СвойстваПредложения);
		МенеджерЗаписи.Организация = СвойстваПредложения.Организация;
		
		МенеджерЗаписи.Состояние = Перечисления.СостоянияСинхронизацииТорговыеПредложения.ТребуетсяСинхронизация;
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьТорговыеПредложенияЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = Неопределено Тогда // отменено пользователем.
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("Сообщения") Тогда
		Для каждого Сообщение Из Результат.Сообщения Цикл 
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ТекстСообщения = Результат.ПодробноеПредставлениеОшибки;
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 %2'"),
				ОбщегоНазначенияКлиент.ДатаСеанса(), ТекстСообщения));
	КонецЕсли;
		
	Элементы.Список.Обновить();
	
	Оповестить("ТорговыеПредложения_ИзменениеСинхронизации",, ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьСостояниеПубликацииПрайсЛистов(ПараметрыМетода)
	
	ТорговыеПредложенияСлужебный.ИзменитьСостояниеПубликацииПрайсЛистов(ПараметрыМетода);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Оформление.
	УсловноеОформление.Элементы.Очистить();
	
	// Отображение информации об ошибке.
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Отображение информации об ошибке'");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокОписаниеОшибки.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Состояние");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СостоянияСинхронизацииТорговыеПредложения.ОшибкаСинхронизации;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Представление состояния при статусе к удалению.
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Представление состояния при удалении'");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСостояние.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ДействиеСинхронизации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ДействияСинхронизацииТорговыеПредложения.Удаление;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Удаление публикации. Требуется синхронизация'"));
	
	// Представление состояния при отключении публикации (до синхронизации).
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Представление состояния при отключении публикации'");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСостояние.Имя);
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ОтборЭлементаСостояние = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлементаСостояние.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Состояние");
	ОтборЭлементаСостояние.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлементаСостояние.ПравоеЗначение = Перечисления.СостоянияСинхронизацииТорговыеПредложения.ТребуетсяСинхронизация;
	ОтборЭлементаОтключено = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлементаОтключено.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Отключено");
	ОтборЭлементаОтключено.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлементаОтключено.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Отключение публикации. Требуется синхронизация'"));
	
	// Представление состояния при отключении публикации (после синхронизации).
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Представление состояния при отключении публикации'");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСостояние.Имя);
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ОтборЭлементаСостояние = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлементаСостояние.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Состояние");
	ОтборЭлементаСостояние.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлементаСостояние.ПравоеЗначение = Перечисления.СостоянияСинхронизацииТорговыеПредложения.Синхронизировано;
	ОтборЭлементаОтключено = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлементаОтключено.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Отключено");
	ОтборЭлементаОтключено.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлементаОтключено.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Отключено'"));
	
	// Цвет текста при статусе к удалению.
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Цвет текста при статусе к удалению'");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ДействиеСинхронизации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ДействияСинхронизацииТорговыеПредложения.Удаление;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	
	// Представление пустого значения почты для уведомления.
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Представление пустого значения электронной почты для уведомления'");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокАдресЭлектроннойПочты.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.УведомлятьОЗаказах");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<отключено>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	
	// Представление пустого значения описания для описания.
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Представление пустого дополнительного описания'");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДополнительноеОписание.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ДополнительноеОписание");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Укажите описание>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЗарегистрированныхОрганизаций()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОрганизацииБизнесСеть.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ОрганизацииБизнесСеть КАК ОрганизацииБизнесСеть";
	УстановитьПривилегированныйРежим(Истина);
	ЗарегистрированныеОрганизации.ЗагрузитьЗначения(
		Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Организация"));
	
КонецПроцедуры

&НаСервере
Функция АвтоматическаяСинхронизацияВключена()
	
	Возврат ПолучитьПараметрРегламентногоЗадания("Использование", Ложь);
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрРегламентногоЗадания(ИмяПараметра, ЗначениеПараметра)
	
	БизнесСеть.ИзменитьРегламентноеЗадание(Метаданные.РегламентныеЗадания.СинхронизацияТорговыхПредложений.Имя,
		ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрРегламентногоЗадания(ИмяПараметра, ЗначениеПоУмолчанию)
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.СинхронизацияТорговыхПредложений);
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.СинхронизацияТорговыхПредложений.ИмяМетода);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Для каждого Задание Из СписокЗаданий Цикл
		Возврат Задание[ИмяПараметра];
	КонецЦикла;
	
	Возврат ЗначениеПоУмолчанию;
	
КонецФункции

&НаСервере
Функция ТекущееРасписание()
	
	Возврат ПолучитьПараметрРегламентногоЗадания("Расписание", Новый РасписаниеРегламентногоЗадания);
	
КонецФункции

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрРегламентногоЗадания("Расписание", Расписание);
	Элементы.Расписание.Заголовок = Расписание;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗапросДинамическогоСписка(ТаблицаТорговыхПредложений)
	
	ОсновнаяТаблица = ТаблицаТорговыхПредложений.ПолноеИмя();
	ТекстЗапросаСписка =
	"ВЫБРАТЬ
	|	СостояниеСинхронизации.ТорговоеПредложение КАК ТорговоеПредложение,
	|	СостояниеСинхронизации.ДатаСинхронизации КАК ДатаСинхронизации,
	|	СостояниеСинхронизации.Состояние КАК Состояние,
	|	СостояниеСинхронизации.ДействиеСинхронизации КАК ДействиеСинхронизации,
	|	СостояниеСинхронизации.ОписаниеОшибки КАК ОписаниеОшибки,
	|	СостояниеСинхронизации.УведомлятьОЗаказах КАК УведомлятьОЗаказах,
	|	СостояниеСинхронизации.АдресЭлектроннойПочты КАК АдресЭлектроннойПочты,
	|	СостояниеСинхронизации.ДополнительноеОписание КАК ДополнительноеОписание,
	|	СостояниеСинхронизации.Организация КАК Организация,
	|	ПРЕДСТАВЛЕНИЕ(СостояниеСинхронизации.ТорговоеПредложение) КАК Наименование,
	|	ВЫБОР
	|		КОГДА СостояниеСинхронизации.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСинхронизацииТорговыеПредложения.Синхронизировано)
	|				И НЕ СостояниеСинхронизации.Отключено
	|			ТОГДА 0
	|		КОГДА СостояниеСинхронизации.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСинхронизацииТорговыеПредложения.Синхронизировано)
	|				И СостояниеСинхронизации.Отключено
	|			ТОГДА 3
	|		КОГДА СостояниеСинхронизации.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСинхронизацииТорговыеПредложения.ТребуетсяСинхронизация)
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК НомерКартинкиСтроки,
	|	СостояниеСинхронизации.ПубликоватьЦены КАК ПубликоватьЦены,
	|	СостояниеСинхронизации.ПубликоватьСрокиПоставки КАК ПубликоватьСрокиПоставки,
	|	СостояниеСинхронизации.ПубликоватьОстатки КАК ПубликоватьОстатки,
	|	СостояниеСинхронизации.Отключено КАК Отключено
	|ИЗ
	|	РегистрСведений.СостоянияСинхронизацииТорговыеПредложения КАК СостояниеСинхронизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаТорговыхПредложений КАК ТорговыеПредложения
	|		ПО СостояниеСинхронизации.ТорговоеПредложение = ТорговыеПредложения.Ссылка";
	ТекстЗапросаСписка = СтрЗаменить(ТекстЗапросаСписка, "ТаблицаТорговыхПредложений", ОсновнаяТаблица);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица              = ОсновнаяТаблица;
	СвойстваСписка.ТекстЗапроса                 = ТекстЗапросаСписка;
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);

КонецПроцедуры

&НаСервере
Функция СинхронизацияТорговыхПредложенийВФоне()
		
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Синхронизация торговых предложений с сервисом 1С:Бизнес-сеть'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("ТорговыеПредложенияСлужебный.СинхронизацияТорговыхПредложений",
		Неопределено, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ОчиститьИдентификаторыПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Организация", Элементы.Список.ТекущиеДанные.Организация);
	ПараметрыПроцедуры.Вставить("ТорговоеПредложение", Элементы.Список.ТекущиеДанные.ТорговоеПредложение);
	
	ДлительнаяОперация = ОчиститьИдентификаторыВФоне(ПараметрыПроцедуры);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Неопределено);
	
КонецПроцедуры

&НаСервере
Функция ОчиститьИдентификаторыВФоне(ПараметрыПроцедуры)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Очистка идентификаторов прайс-листа'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("ТорговыеПредложенияСлужебный.ОчиститьИдентификаторыПрайсЛиста",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаСервереБезКонтекста
Функция НовыйПараметрыОбработкиСтрок()
	
	Результат = Новый Структура;
	Результат.Вставить("ВыделенныеСтроки",        Новый Массив);
	Результат.Вставить("ЭтоУдаление",             Ложь);
	Результат.Вставить("ЭтоОтменаУдаления",       Ложь);
	Результат.Вставить("ЭтоОтключениеПубликации", Ложь);
	Результат.Вставить("ЭтоВключениеПубликации",  Ложь);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ВыполнитьДлительнуюОперацию()
	
	Элементы.ГруппаВнешниеПубликации.Видимость = Ложь;
	
	Задание = Новый Структура("ИмяПроцедуры, Наименование, ПараметрыПроцедуры");
	Задание.Наименование = НСтр("ru = '1С:Торговая площадка. Получение внешних публикаций.'");
	Задание.ИмяПроцедуры = "ТорговыеПредложенияСлужебный.ПолучитьВнешниеПрайсЛисты";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Задание.Наименование;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0.2;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(Задание.ИмяПроцедуры,
		Задание.ПараметрыПроцедуры, ПараметрыВыполнения);
		
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьДлительнуюОперацию()
	
	Если ДлительнаяОперация <> Неопределено И ДлительнаяОперация.Статус = "Выполняется" Тогда
	
		// Инициализация обработчика ожидания завершения длительной операции.
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Получение внешних публикаций.'");
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
		ПараметрыОжидания.ВыводитьСообщения = Истина;
		ПараметрыОжидания.Вставить("ИдентификаторЗадания", ДлительнаяОперация.ИдентификаторЗадания);
		ПараметрыОжидания.Интервал = 1;
		ОбработкаЗавершенияПоиска = Новый ОписаниеОповещения("ПолучитьВнешниеПрайсЛистыЗавершение",
			ЭтотОбъект, ДлительнаяОперация);
			
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОбработкаЗавершенияПоиска, ПараметрыОжидания);
		
	Иначе
		
		ПолучитьВнешниеПрайсЛистыЗавершение(ДлительнаяОперация, ДлительнаяОперация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВнешниеПрайсЛистыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	// Вывод сообщений из фонового задания.
	Отказ = Ложь;
	ТорговыеПредложенияКлиент.ОбработатьОшибкиФоновогоЗадания(Результат, Отказ);
	
	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		ПолучитьВнешниеПрайсЛистыОбработка(Результат.АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьВнешниеПрайсЛистыОбработка(АдресРезультата)
	
	ДлительнаяОперация = Неопределено;
	Результат = Неопределено;
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		РезультатЗапроса = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если РезультатЗапроса <> Неопределено И РезультатЗапроса.Количество() > 0 Тогда
			Элементы.ВнешниеПубликации.Заголовок = НСтр("ru = 'Внешние публикации'")
				+ " (" + РезультатЗапроса.Количество() + ")";
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаВнешниеПубликации.Видимость = Результат <> Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПубликацииНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ВнешниеПубликации");
	
КонецПроцедуры

#КонецОбласти

