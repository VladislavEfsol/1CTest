
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СписокШиринаСлипЧека = Элементы.ШиринаСлипЧека.СписокВыбора;
	СписокШиринаСлипЧека.Добавить(24,  НСтр("ru='24 сим.'"));
	СписокШиринаСлипЧека.Добавить(32,  НСтр("ru='32 сим.'"));
	СписокШиринаСлипЧека.Добавить(36,  НСтр("ru='36 сим.'"));
	СписокШиринаСлипЧека.Добавить(40,  НСтр("ru='40 сим.'"));
	СписокШиринаСлипЧека.Добавить(48,  НСтр("ru='48 сим.'"));

	времШиринаСлипЧека             = Неопределено;
	времКодСимволаЧастичногоОтреза = Неопределено;
	времВерсияБиблиотеки           = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("ШиринаСлипЧека"            , времШиринаСлипЧека);
	Параметры.ПараметрыОборудования.Свойство("КодСимволаЧастичногоОтреза", времКодСимволаЧастичногоОтреза);
	Параметры.ПараметрыОборудования.Свойство("ВерсияБиблиотеки"          , времВерсияБиблиотеки);
	
	ШиринаСлипЧека = ?(времШиринаСлипЧека = Неопределено, 32, времШиринаСлипЧека);
	КодСимволаЧастичногоОтреза = ?(времКодСимволаЧастичногоОтреза = Неопределено, 22, времКодСимволаЧастичногоОтреза);
	ВерсияБиблиотеки = ?(времВерсияБиблиотеки = Неопределено, Ложь, времВерсияБиблиотеки);
	
	Элементы.ТестУстройства.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("ШиринаСлипЧека"             , ШиринаСлипЧека);
	НовыеЗначениеПараметров.Вставить("КодСимволаЧастичногоОтреза" , КодСимволаЧастичногоОтреза);
	НовыеЗначениеПараметров.Вставить("ВерсияБиблиотеки"           , ВерсияБиблиотеки);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	
	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("ШиринаСлипЧека"            , ШиринаСлипЧека);
	времПараметрыУстройства.Вставить("КодСимволаЧастичногоОтреза", КодСимволаЧастичногоОтреза);
	времПараметрыУстройства.Вставить("ВерсияБиблиотеки"          , ВерсияБиблиотеки);
	
	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
	Иначе
		Драйвер = ВыходныеПараметры[2];
	КонецЕсли;
	
	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	         
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	РезультатТеста = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	времПараметрыУстройства = Новый Структура();
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth", ВходныеПараметры, ВыходныеПараметры, Идентификатор, времПараметрыУстройства);

	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тестовое чтение карты успешно выполнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		                           И ВыходныеПараметры.Количество() >= 2, НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1], "");
		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание), "", Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти