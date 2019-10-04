
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбработатьПараметрыПоиска();
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ИнициализироватьПоляКонтактнойИнформации();
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура GUIDПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерПредприятияПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура GLNПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПоискаПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоСредиПредприятийПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

#Область РедактированиеАдреса

&НаСервере
Процедура СтранаМираПриИзмененииНаСервере(СтранаМира)
	
	ДанныеСтраныМира = ПрочиеКлассификаторыВЕТИСВызовСервера.ДанныеСтраныМира(СтранаМира);
	
	ДанныеАдреса = ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныхАдреса();
	ДанныеАдреса.СтранаGUID          = ДанныеСтраныМира.Идентификатор;
	ДанныеАдреса.СтранаПредставление = ДанныеСтраныМира.Наименование;
	
	Адрес              = "";
	АдресПредставление = "";
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаМираПриИзменении(Элемент)
	
	СтранаМираПриИзмененииНаСервере(СтранаМира);
	
	Элементы.ПредставлениеАдреса.Видимость      = (СтранаМира  = ПредопределенноеЗначение("Справочник.СтраныМира.Россия"));
	Элементы.ПредставлениеАдресаВЕТИС.Видимость = (СтранаМира <> ПредопределенноеЗначение("Справочник.СтраныМира.Россия"));
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаМираОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаПриИзменении(Элемент)
	
	Текст = Элемент.ТекстРедактирования;
	Если ПустаяСтрока(Текст) Тогда
		// Очистка данных, сбрасываем как представления, так и внутренние значения полей.
		Адрес = "";
		ДанныеАдреса = Неопределено;
		Возврат;
	КонецЕсли;
	
	// Формируем внутренние значения полей по тексту и параметрам формирования из
	// реквизита ВидКонтактнойИнформации.
	АдресПредставление = Текст;
	
	ДанныеРазбораАдреса = ДанныеДляРазбораАдреса();
	ПредставлениеАдресаПриИзмененииСервер(ДанныеРазбораАдреса);
	
	Адрес        = ДанныеРазбораАдреса.Адрес;
	ДанныеАдреса = ДанныеРазбораАдреса.ДанныеАдреса;
	
	Если ЗначениеЗаполнено(ДанныеРазбораАдреса.ТекстОшибки) Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ДанныеРазбораАдреса.ТекстОшибки,, ДанныеРазбораАдреса.Поле);
	КонецЕсли;
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если представление было изменено в поле и сразу нажата кнопка выбора, то необходимо 
	// привести данные в соответствие и сбросить внутренние поля для повторного разбора.
	Если Элемент.ТекстРедактирования <> АдресПредставление Тогда
		АдресПредставление = Элемент.ТекстРедактирования;
		Адрес              = "";
	КонецЕсли;
	
	// Данные для редактирования
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформацииАдреса);
	ПараметрыОткрытия.Вставить("ЗначенияПолей",           Адрес);
	ПараметрыОткрытия.Вставить("Представление",           АдресПредставление);
	
	// Переопределямый заголовок формы, по умолчанию отобразятся данные по ВидКонтактнойИнформации.
	ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru='Адрес хозяйствующего субъекта'"));
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОчистка(Элемент, СтандартнаяОбработка)
	
	// Сбрасываем как представления, так и внутренние значения полей.
	АдресПредставление = "";
	Адрес              = "";
	ДанныеАдреса = ДанныеАдресаКлиент();
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение)<>Тип("Структура") Тогда
		// Отказ от выбора, данные неизменны.
		Возврат;
	КонецЕсли;
	
	АдресПредставление = ВыбранноеЗначение.Представление;
	Адрес              = ВыбранноеЗначение.КонтактнаяИнформация;
	ДанныеАдреса       = ДанныеАдресаКлиент();
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ДанныеАдреса", ДанныеАдреса);
	
	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.РедактированиеАдреса",
		ПараметрыОткрытияФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбработатьРезультатРедактированияАдресаВЕТИС", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	ПроверитьКорректностьЗаполненияРеквизитовПоиска(Отказ);
	
	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыПоиска = Новый Структура;
	
	ПараметрыПоиска.Вставить("ИдентификаторХС", ИдентификаторХС);
	ПараметрыПоиска.Вставить("ПредставлениеХС", ПредставлениеХС);
	ПараметрыПоиска.Вставить("ТолькоСредиПредприятий", ТолькоСредиПредприятий);
	
	Если ТолькоСредиПредприятий Тогда
		Закрыть(ПараметрыПоиска);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		ПараметрыПоиска.Вставить("Идентификатор", Идентификатор);
		Закрыть(ПараметрыПоиска);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(GLN) Тогда
		ПараметрыПоиска.Вставить("GLN", GLN);
		Закрыть(ПараметрыПоиска);
		Возврат;
	КонецЕсли;
	
	ПараметрыПоиска.Вставить("РежимПоиска", РежимПоиска);
	
	Если ЗначениеЗаполнено(СтранаМира) И СтранаМира <> ПредопределенноеЗначение("Справочник.СтраныМира.Россия") Тогда
		ПараметрыПоиска.Вставить("Страна", ДанныеАдреса.СтранаGUID);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерПредприятия) Тогда
		ПараметрыПоиска.Вставить("НомерПредприятия", НомерПредприятия);
		Закрыть(ПараметрыПоиска);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		ПараметрыПоиска.Вставить("Наименование", Наименование);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресПредставление) Тогда
		ПараметрыПоиска.Вставить("Адрес",              Адрес);
		ПараметрыПоиска.Вставить("АдресПредставление", АдресПредставление);
		ПараметрыПоиска.Вставить("ДанныеАдреса",       ДанныеАдреса);
	КонецЕсли;
	
	Закрыть(ПараметрыПоиска);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

&НаКлиенте
Процедура УправлениеДоступностьюЭлементовФормы()
	
	УказанИдентификатор = Не ПустаяСтрока(Идентификатор);
	
	УказанGLN           = Не ПустаяСтрока(GLN);
	УказанНомер         = Не ПустаяСтрока(НомерПредприятия);
	
	УказанРеквизитНеТочногоСоответствия = Не ПустаяСтрока(Наименование)
	                                      Или Не ПустаяСтрока(АдресПредставление);
	
	УказанРеквизитТочногоСоответствия = УказанИдентификатор Или УказанGLN;
	
	Элементы.Идентификатор.Доступность    = Не (УказанGLN Или УказанНомер Или УказанРеквизитНеТочногоСоответствия Или ТолькоСредиПредприятий);
	Элементы.GLN.Доступность              = Не (УказанИдентификатор Или УказанНомер Или УказанРеквизитНеТочногоСоответствия Или ТолькоСредиПредприятий);
	Элементы.НомерПредприятия.Доступность = Не (УказанИдентификатор Или УказанGLN Или УказанРеквизитНеТочногоСоответствия Или ТолькоСредиПредприятий);
	
	Элементы.Наименование.Доступность        = Не (УказанРеквизитТочногоСоответствия Или ТолькоСредиПредприятий);
	Элементы.ГруппаПоискПоАдресу.Доступность = Не (УказанРеквизитТочногоСоответствия Или ТолькоСредиПредприятий);
	Элементы.РежимПоиска.Доступность         = Не (УказанРеквизитТочногоСоответствия Или ТолькоСредиПредприятий);
	
	Элементы.ТолькоСредиПредприятий.Доступность = Не (УказанРеквизитТочногоСоответствия Или УказанРеквизитНеТочногоСоответствия);
	
	Элементы.СтранаМира.ТолькоПросмотр = Не РежимПоиска;
	Если Не РежимПоиска Тогда
		СтранаМира = ПредопределенноеЗначение("Справочник.СтраныМира.Россия");
	КонецЕсли;
	
	Элементы.Идентификатор.ОтметкаНезаполненного = УказанИдентификатор И НЕ СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(Идентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметрыПоиска()

	Если ТипЗнч(Параметры.ПараметрыПоиска)= Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыПоиска);
		
		Если ДанныеАдреса <> Неопределено
			И ЗначениеЗаполнено(ДанныеАдреса.СтранаGUID) Тогда
			СтранаМира = ИнтеграцияВЕТИСПовтИсп.СтранаМира(ДанныеАдреса.СтранаGUID);
		ИначеЕсли Параметры.ПараметрыПоиска.Свойство("Страна") Тогда
			СтранаМира = ИнтеграцияВЕТИСПовтИсп.СтранаМира(Параметры.ПараметрыПоиска.Страна);
			ДанныеАдреса = Новый Структура("СтранаGUID", Параметры.ПараметрыПоиска.Страна);
		Иначе
			СтранаМира = Справочники.СтраныМира.Россия;
		КонецЕсли;
		
	Иначе
		
		СтранаМира = Справочники.СтраныМира.Россия;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторХС) Тогда
		
		Строки = Новый Массив;
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Только предприятия ХС'"), Новый Шрифт("Аrial", 9, Истина), Новый Цвет(0, 150, 70)));
		Строки.Добавить(СтрШаблон(" %1", ПредставлениеХС));
		Элементы.ДекорацияТолькоСредиПредприятий.Заголовок = Новый ФорматированнаяСтрока(Строки);
		
	Иначе
		
		Элементы.ГруппаТолькоСредиПредприятий.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКорректностьЗаполненияРеквизитовПоиска(Отказ)
	
	Если ТолькоСредиПредприятий Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Идентификатор)
		И Не СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(Идентификатор) Тогда
		
		ТекстОшибки = НСтр("ru = 'Неправильно указан идентификатор'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ,"Идентификатор",, Отказ);
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(GLN)
		И СтрДлина(GLN) <> 13 Тогда
		
		ТекстОшибки = НСтр("ru = 'Необходимо указать 13 символов'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ,"GLN",, Отказ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресПредставление)
		И ДанныеАдреса = Неопределено Тогда
		ДанныеАдреса = ДанныеАдресаКлиент(Ложь, Отказ);
	КонецЕсли;

КонецПроцедуры

#Область РедактированиеАдреса

// Функция - Данные для разбора адреса
// 
// Возвращаемое значение:
//  Структура - структура с полями:
//   * Текст        - введенное представление адреса (входящий),
//   * Вид          - вид контактной информации адреса (входящий),
//   * Страна       - страна адреса (входящий),
//   * Адрес        - см соответствующую процедуру ЗначенияПолейКонтактнойИнформацииСервер (исходящий)
//   * ДанныеАдреса - Неопределено или структура с полями адреса (исходящий),
//   * ТекстОшибки  - описание ошибки получения адреса (исходящий),
//   * Поле         - поле в котором будет выведено сообщение об ошибке (исходящий).
//
&НаКлиенте
Функция ДанныеДляРазбораАдреса()
	
	Результат = Новый Структура;
	Результат.Вставить("Текст",  АдресПредставление);
	Результат.Вставить("Вид",    ВидКонтактнойИнформацииАдреса);
	Результат.Вставить("Страна", СтранаМира);
	Результат.Вставить("Адрес");
	Результат.Вставить("ДанныеАдреса");
	Результат.Вставить("ТекстОшибки", "");
	Результат.Вставить("Поле");
	Возврат Результат;
	
КонецФункции

// Процедура - Представление адреса при изменении сервер
//
// Параметры:
//  ДанныеАдреса - 	 - Структура - состав полей см процедуру ДанныеДляРазбораАдреса()
//
&НаСервереБезКонтекста
Процедура ПредставлениеАдресаПриИзмененииСервер(ДанныеАдреса)
	
	ДанныеАдреса.Адрес = ЗначенияПолейКонтактнойИнформацииСервер(
		ДанныеАдреса.Текст,
		ДанныеАдреса.ВидКонтактнойИнформацииАдреса);
		
	Попытка
		ДанныеАдреса.ДанныеАдреса = ИнтеграцияВЕТИСВызовСервера.ДанныеАдресаПоАдресуXML(
			ДанныеАдреса.Адрес,
			ДанныеАдреса.Текст);
	Исключение
		ДанныеАдреса.ДанныеАдреса = Неопределено;
		Если ДанныеАдреса.СтранаМира = Справочники.СтраныМира.Россия Тогда
			ДанныеАдреса.Поле        = "ПредставлениеАдреса";
			ДанныеАдреса.ТекстОшибки = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введен регион. Повторите ввод.'");
		Иначе
			ДанныеАдреса.Поле        = "ПредставлениеАдресаВЕТИС";
			ДанныеАдреса.ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введены данные. Повторите ввод. Причина ошибки: %1'"),
				ОписаниеОшибки());
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеАдресаКлиент(ОчищатьСообщения = Истина, Отказ = Ложь)
	Попытка
		ДанныеАдресаСтруктурой = ИнтеграцияВЕТИСВызовСервера.ДанныеАдресаПоАдресуXML(Адрес, АдресПредставление);
	Исключение
		Если СтранаМира = ПредопределенноеЗначение("Справочник.СтраныМира.Россия") Тогда
			ИмяПоля = "ПредставлениеАдреса";
			ТекстСообщения = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введен регион. Повторите ввод.'");
		Иначе
			ИмяПоля = "ПредставлениеАдресаВЕТИС";
			ТекстСообщения = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введены данные. Повторите ввод. Причина ошибки: %1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ОписаниеОшибки());
		КонецЕсли;
		Если ОчищатьСообщения Тогда
			ОчиститьСообщения();
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ИмяПоля);
		ДанныеАдресаСтруктурой = Неопределено;
		
		Отказ = Истина;
	КонецПопытки;
	
	Возврат ДанныеАдресаСтруктурой;
	
КонецФункции

&НаСервере
Процедура ИнициализироватьПоляКонтактнойИнформации()
	
	// Реквизит формы, контролирующий работу с адресом доставки.
	// Используемые поля аналогичны полям справочника ВидыКонтактнойИнформации.
	ВидКонтактнойИнформацииАдреса = Новый Структура;
	ВидКонтактнойИнформацииАдреса.Вставить("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
	ВидКонтактнойИнформацииАдреса.Вставить("АдресТолькоРоссийский",        Истина);
	ВидКонтактнойИнформацииАдреса.Вставить("ВключатьСтрануВПредставление", Ложь);
	ВидКонтактнойИнформацииАдреса.Вставить("СкрыватьНеактуальныеАдреса",   Ложь);
	
	Если СтранаМира  = Справочники.СтраныМира.Россия Тогда
		// Считываем данные из полей адреса в реквизиты для редактирования.
		АдресПредставление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Адрес);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначенияПолейКонтактнойИнформацииСервер(Знач Представление, Знач ВидКонтактнойИнформации, Знач Комментарий = Неопределено)
	
	// Создаем новый экземпляр по представлению.
	Результат = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению(Представление, ВидКонтактнойИнформации);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатРедактированияАдресаВЕТИС(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Адрес              = "";
	АдресПредставление = Результат.ПредставлениеАдреса;
	ДанныеАдреса       = Результат;
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
