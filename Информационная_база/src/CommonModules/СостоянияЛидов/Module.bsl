
#Область ПрограммныйИнтерфейс

Функция УстановитьУсловноеОформлениеСостоянияЗавершен(УсловноеОформлениеКД,
		СостояниеЗавершен,
		ИмяПоляСостояния = "Ссылка",
		ОформляемоеПоле = Неопределено) Экспорт
	
	ЖирныйШрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста,,,Истина);
	ЭлементУсловногоОформления = УсловноеОформлениеКД.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ЖирныйШрифт);
	ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "СостояниеЗавершен";
	ЭлементУсловногоОформления.РежимОтображения	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	ЭлементУсловногоОформления.Представление	= НСтр("ru='Состояние ""Завершен"" жирным шрифтом'");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных(ИмяПоляСостояния);
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение	= СостояниеЗавершен;
	
	Если ОформляемоеПоле <> Неопределено Тогда
		ОформляемоеПолеКД = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ОформляемоеПолеКД.Поле = Новый ПолеКомпоновкиДанных(ОформляемоеПоле);
		ОформляемоеПолеКД.Использование = Истина;
	КонецЕсли;
	
	Возврат ЭлементУсловногоОформления;
	
КонецФункции

Процедура УстановитьУсловноеОформлениеПоЦветамСостояний(УсловноеОформлениеКД,
		ПолноеИмяСправочникаСостояний,
		ИмяПоляСостояния = "СостояниеЛида",
		ОформляемоеПоле = Неопределено) Экспорт
	
	УдаляемыеЭлементы = Новый Массив;
	
	Для Каждого ЭлементУсловногоОформления Из УсловноеОформлениеКД.Элементы Цикл
		Если ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "ЦветСостояния" Тогда
			УдаляемыеЭлементы.Добавить(ЭлементУсловногоОформления);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементУсловногоОформления Из УдаляемыеЭлементы Цикл
		УсловноеОформлениеКД.Элементы.Удалить(ЭлементУсловногоОформления);
	КонецЦикла;
	
	МенеджерСостояний = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяСправочникаСостояний);
	ВыборкаСостояний = МенеджерСостояний.Выбрать();
	
	Пока ВыборкаСостояний.Следующий() Цикл
		
		ЦветСостояния = ВыборкаСостояний.Цвет.Получить();
		Если ТипЗнч(ЦветСостояния) <> Тип("Цвет") Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементУсловногоОформления = УсловноеОформлениеКД.Элементы.Добавить();
		
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветСостояния);
		ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "ЦветСостояния";
		ЭлементУсловногоОформления.РежимОтображения	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		ЭлементУсловногоОформления.Представление	= НСтр("ru='Оформление в цвет состояния'");
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных(ИмяПоляСостояния);
		ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение	= ВыборкаСостояний.Ссылка;
		
		Если ОформляемоеПоле <> Неопределено Тогда
			ОформляемоеПолеКД = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
			ОформляемоеПолеКД.Поле = Новый ПолеКомпоновкиДанных(ОформляемоеПоле);
			ОформляемоеПолеКД.Использование = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписьюЛида(ЛидОбъект) Экспорт
	
	ПредыдущееСостояние = Неопределено;
	ОчиститьИсториюСостоянийПриИзмененииВида = Ложь;
	
	Если Не ЛидОбъект.ЭтоНовый() Тогда
		ПредыдущееСостояние = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЛидОбъект.Ссылка, "СостояниеЛида");
	КонецЕсли;
	
	ДанныеИсторииСостояния = Новый Структура;
	ДанныеИсторииСостояния.Вставить("ЗаписыватьСостояниеВИсторию", ЛидОбъект.ЭтоНовый() Или ЛидОбъект.СостояниеЛида <> ПредыдущееСостояние);
	ДанныеИсторииСостояния.Вставить("ПредыдущееСостояние", ПредыдущееСостояние);
	ДанныеИсторииСостояния.Вставить("ОчиститьИсториюСостоянийПриИзмененииВида", ОчиститьИсториюСостоянийПриИзмененииВида);
	
	ЛидОбъект.ДополнительныеСвойства.Вставить("ДанныеИсторииСостояния", ДанныеИсторииСостояния);
	
КонецПроцедуры

Процедура ПриЗаписиЛида(ЛидОбъект) Экспорт
	
	Если ЗначениеЗаполнено(ЛидОбъект.ДополнительныеСвойства.ДанныеИсторииСостояния.ПредыдущееСостояние) Тогда
		СостоянияЛидов.ПроверитьОчиститьИсториюСостояний(
			ЛидОбъект.Ссылка,
			ЛидОбъект.ДополнительныеСвойства.ДанныеИсторииСостояния.ПредыдущееСостояние,
			ЛидОбъект.СостояниеЛида);
	КонецЕсли;
	Если ЛидОбъект.ДополнительныеСвойства.ДанныеИсторииСостояния.ЗаписыватьСостояниеВИсторию Тогда
		СостоянияЛидов.СохранитьСостояниеЛидаВИстории(ЛидОбъект.Ссылка, ЛидОбъект.СостояниеЛида);
	КонецЕсли;
КонецПроцедуры

// Процедура очищает записи истории состояний лида, если у нового состояния порядок меньше чем у предыдущего
//
Процедура ПроверитьОчиститьИсториюСостояний(ЛидСсылка, ПредыдущееСостояние, ТекущееСостояние) Экспорт
	
	ПорядокТекущего = ПолучитьПорядокСостояния(ТекущееСостояние);
	ПорядокПредыдущего = ПолучитьПорядокСостояния(ПредыдущееСостояние);
	Если ПорядокПредыдущего = Неопределено Или ПорядокТекущего >= ПорядокПредыдущего Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияЛидов.Ссылка КАК Состояние
	|ПОМЕСТИТЬ втСостоянияКОчистке
	|ИЗ
	|	Справочник.СостоянияЛидов КАК СостоянияЛидов
	|ГДЕ
	|	СостоянияЛидов.РеквизитДопУпорядочивания >= &ПорядокТекущего
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсторияСостоянийЛидов.Период КАК Период,
	|	ИсторияСостоянийЛидов.Лид КАК Лид,
	|	ИсторияСостоянийЛидов.Состояние КАК Состояние
	|ИЗ
	|	РегистрСведений.ИсторияСостоянийЛидов КАК ИсторияСостоянийЛидов
	|ГДЕ
	|	ИсторияСостоянийЛидов.Лид = &Лид
	|	И ИсторияСостоянийЛидов.Состояние В
	|			(ВЫБРАТЬ
	|				втСостоянияКОчистке.Состояние
	|			ИЗ
	|				втСостоянияКОчистке)";
	
	Запрос.УстановитьПараметр("Лид", ЛидСсылка);
	Запрос.УстановитьПараметр("ПорядокТекущего", ПорядокТекущего);
	
	Выборка = Запрос.Выполнить().Выбрать();
	МенеджерЗаписи = РегистрыСведений.ИсторияСостоянийЛидов.СоздатьМенеджерЗаписи();
	
	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Прочитать();
		МенеджерЗаписи.Удалить();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьВсюИсториюСостоянийПоЛиду(ЛидСсылка) Экспорт
	
	НаборЗаписей = РегистрыСведений.ИсторияСостоянийЛидов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Лид.Установить(ЛидСсылка);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Процедура СохранитьСостояниеЛидаВИстории(ЛидСсылка, СостояниеЛида, Период = Неопределено) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.ИсторияСостоянийЛидов.СоздатьМенеджерЗаписи();
	Если ЗначениеЗаполнено(Период) Тогда
		МенеджерЗаписи.Период		= Период;
	Иначе
		МенеджерЗаписи.Период		= ТекущаяДатаСеанса();
	КонецЕсли;
	МенеджерЗаписи.Лид		= ЛидСсылка;
	МенеджерЗаписи.Состояние	= СостояниеЛида;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Функция возвращает порядок состояния
//
// Параметры:
//  Состояние	 - СправочникСсылка.СостоянияЛидов - состояние для которого получается порядок// 
// Возвращаемое значение:
//  число - порядок состояния
//
Функция ПолучитьПорядокСостояния(Состояние) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Состояние, "РеквизитДопУпорядочивания");
КонецФункции

Функция ПолучитьСостояниеЛидаПередЗавершением(ЛидСсылка, СостояниеЗавершен) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИсторияСостоянийЛидовСрезПоследних.Состояние КАК Состояние
		|ИЗ
		|	РегистрСведений.ИсторияСостоянийЛидов.СрезПоследних(
		|			,
		|			Лид = &Лид
		|				И Состояние <> &СостояниеЗавершен) КАК ИсторияСостоянийЛидовСрезПоследних";
	
	Запрос.УстановитьПараметр("Лид", ЛидСсылка);
	Запрос.УстановитьПараметр("СостояниеЗавершен", СостояниеЗавершен);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Состояние;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Процедура обработчик подписки "ОчиститьИсториюСостоянияЛидов". Очищает вспомогательные данные по удаляемому состоянию.
//
Процедура ОчиститьИсториюСостоянияЛидовПередУдалением(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ИсторияСостоянийЛидов.УдалитьИнформациюОСостоянииЛидов(Источник.Ссылка);
	
КонецПроцедуры

#КонецОбласти
