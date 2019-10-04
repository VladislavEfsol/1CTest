///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Проверка

// Отображение формы с предложением включить проверку контрагентов.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма объекта, в котором выполняется проверка контрагентов.
Процедура ПредложитьВключитьПроверкуКонтрагентов(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.НужноПоказатьПредложениеВключитьПроверкуКонтрагентов Тогда
		
		СтандартнаяОбработка = Истина;
		РаботаСКонтрагентамиКлиентПереопределяемый.ПредложитьВключитьПроверкуКонтрагентов(СтандартнаяОбработка);
		
		Если СтандартнаяОбработка Тогда 
			ОткрытьФорму("ОбщаяФорма.ВключениеПроверкиКонтрагентов", , Форма);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверка доступа к сервису.
Процедура ПроверитьДоступКСервису() Экспорт
	
	ТекстПредупреждения = ПроверкаКонтрагентовВызовСервера.РезультатПроверкиПараметровДоступа();
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
КонецПроцедуры

// Настройка параметров прокси сервера.
Процедура НастроитьПараметрыПроксиСервера() Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернетаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеФайловИзИнтернетаКлиент");
		МодульПолучениеФайловИзИнтернетаКлиент.ОткрытьФормуПараметровПроксиСервера();
	КонецЕсли;
	
КонецПроцедуры

// Вспомогательный API. Получает состояние контрагента из регистра сведений или из временного хранилища, если
//           передан адрес.
//
// Параметры:
//  КонтрагентСсылка - ОпределяемыйТип.КонтрагентБИП - Проверяемый контрагент.
//  ИНН				 - Строка - ИНН контрагента.
//  КПП				 - Строка - КПП контрагента.
//  АдресХранилища	 - Строка - Адрес временного хранилища, в котором может содержаться 
//		результат проверки контрагента.
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияСуществованияКонтрагента - Состояние контрагента.
//
Функция ТекущееСостояниеКонтрагента(КонтрагентСсылка, ИНН, КПП, АдресХранилища = Неопределено) Экспорт
	
	Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустаяСсылка");
	
	// 1. Пытаемся получить состояние контрагента из хранилища.
	Если ЗначениеЗаполнено(АдресХранилища) И ЭтоАдресВременногоХранилища(АдресХранилища) Тогда		
		Состояние = ПолучитьИзВременногоХранилища(АдресХранилища);			
	КонецЕсли;
	
	// 2. Если в хранилище нет результата, то пытаемся получить состояние из регистра.
	Если ЗначениеЗаполнено(КонтрагентСсылка) И НЕ ЗначениеЗаполнено(Состояние) Тогда
		Состояние = ПроверкаКонтрагентовВызовСервера.ТекущееСохраненноеСостояниеКонтрагента(КонтрагентСсылка, ИНН, КПП);
	КонецЕсли;
	
	Возврат Состояние;
		
КонецФункции

// Открыть настройки сервиса.
Процедура ОткрытьНастройкиСервиса() Экспорт
	
	ОткрытьФорму("ОбщаяФорма.НастройкиПроверкиКонтрагентов");

КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВДокументах

// Подключение обработчиков результата проверки контрагентов из формы документа.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
Процедура ПриОткрытииДокумент(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		// Состояния контрагентов для документа могут быть получены из кэша,
		// поэтому для таких документов повторно выполнять проверку не имеет
		// смысла.
		Если Форма.РеквизитыПроверкиКонтрагентов.ТребуетсяПроверкаСервисом Тогда
			// Не сразу запускаем проверку, а через обработчик, чтобы
			// ускорить открытие формы документа.
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
		КонецЕсли;
		
	Иначе
		
		Если Форма.РеквизитыПроверкиКонтрагентов.НужноПоказатьПредложениеВключитьПроверкуКонтрагентов Тогда
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Отображение предупреждения о причине выделения контрагента в строке таблице как некорректного.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  Элемент	 - ТаблицаФормы - Таблица, в которой выполнили двойное нажатие на значке с информацией о наличии
//                            некорректного контрагента.
//  Поле	 - ПолеФормы - Колонка, в которой выполнили двойное нажатие на значке с информацией о наличии некорректного
//                      контрагента.
Процедура ТаблицаФормыВыбор(Форма, Элемент, Поле) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ИнициализацияВыполненаПолностью Тогда
	
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Если Поле.Имя = ПроверкаКонтрагентовКлиентСервер.ИмяПоляКартинки(Элемент) Тогда
				Если ПроверкаКонтрагентовКлиентСервер.ЭтоНекорректноеСостояниеКонтрагента(ТекущиеДанные.Состояние) Тогда
				
					Описание = Новый Структура;
					Описание.Вставить("ДокументПустой", 		Ложь);
					Описание.Вставить("КонтрагентЗаполнен", 	Истина);
					Описание.Вставить("СостояниеКонтрагента", 	ТекущиеДанные.Состояние);
					Описание.Вставить("КонтрагентовНесколько", 	Ложь);
					
					СостояниеПроверки = ПредопределенноеЗначение("Перечисление.СостоянияПроверкиКонтрагентов.ПроверкаВыполнена");
					
					ПодсказкаВДокументе = ПроверкаКонтрагентовКлиентСервер.ПодсказкаВДокументе(Описание, СостояниеПроверки);
					ПоказатьПредупреждение(,ПодсказкаВДокументе.Текст, , НСтр("ru = 'Проверка контрагентов'"));
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
			
КонецПроцедуры

// Определяет, требует ли событие, вызванное оповещением, запуска проверки контрагентов.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  ИмяСобытия					 - Строка - Имя события обработки оповещения.
//  Параметр					 - Произвольный - Параметр обработки оповещения.
//  Источник					 - Произвольный - Источник обработки оповещения.
// Возвращаемое значение:
//  Булево - требует ли событие, вызванное оповещением, запуска проверки контрагентов.
Функция СобытиеТребуетПроверкиКонтрагента(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	ТребуетсяПроверкаКонтрагентов = Ложь;
	
	РаботаСКонтрагентамиКлиентПереопределяемый.ОпределитьНеобходимостьПроверкиКонтрагентовВОбработкеОповещения(
		Форма, ИмяСобытия, Параметр, Источник, ТребуетсяПроверкаКонтрагентов);
		
	Возврат ТребуетсяПроверкаКонтрагентов;
	
КонецФункции

// Запуск проверки контрагентов в документе после возникновения определенного события.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  ДополнительныеПараметры		 - Дата - Дата документа, в случае если произошло изменение даты.
//								 - ТаблицаФормы - Если изменения произошли в табличной части.
//								 - ПолеФормы - Если изменился контрагент в определенном поле произошли в табличной части.
Процедура ЗапуститьПроверкуКонтрагентовВДокументе(Форма, ДополнительныеПараметры = Неопределено) Экспорт
	
	Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаПоКнопке =
		ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ЭтоПроверкаПоКнопке") 
		И ДополнительныеПараметры.ЭтоПроверкаПоКнопке;
	
	Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаКонтрагентовПриОткрытии =
		(Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаКонтрагентовПриОткрытии
		И НЕ Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаПоКнопке);
	
	// Для предотвращения проверки при отключенной автоматической проверке,
	// когда меняется контрагент в документе.
	Если Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаПоКнопке
		ИЛИ Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		ПараметрыФоновогоЗадания = ПроверкаКонтрагентовКлиентСервер.ПараметрыФоновогоЗадания(ДополнительныеПараметры);
		Форма.ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания);
		
		Если Форма.РеквизитыПроверкиКонтрагентов.ИнициализацияВыполненаПолностью Тогда
				
			Форма.РеквизитыПроверкиКонтрагентов.СохранятьРезультатСразуПослеПроверки = 
				ПараметрыФоновогоЗадания.Свойство("СохранятьРезультатСразуПослеПроверки") 
				И ПараметрыФоновогоЗадания.СохранятьРезультатСразуПослеПроверки;
				
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания);
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработка результата работы фонового задания по проверке контрагентов.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
Процедура ОбработатьРезультатПроверкиКонтрагентовВДокументе(Форма) Экспорт

	Если Форма.РеквизитыПроверкиКонтрагентов.ИнициализацияВыполненаПолностью Тогда
		
		ОтложитьПрорисовкуРезультатаПроверкиКонтрагентов = Форма.РеквизитыПроверкиКонтрагентов.ОтложитьПрорисовкуРезультатаПроверкиКонтрагентов;
		
		Если Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаКонтрагентовПриОткрытии Тогда
			
			ПроверкаКонтрагентовКлиентСервер.ПредотвратитьСбросРедактируемогоЗначения(Форма);
			
			// Вход в данную ветку возможен только сразу после открытия документа.
			// Дополнительный параметр предназначен для того, чтобы сразу после проверки сохранить 
			// результат проверки в регистр.
			ДополнительныеПараметры = Истина;
			ЗапуститьПроверкуКонтрагентовВДокументе(Форма, ДополнительныеПараметры);
			Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаКонтрагентовПриОткрытии = Ложь;
			
		ИначеЕсли НЕ ОтложитьПрорисовкуРезультатаПроверкиКонтрагентов Тогда
			
			Результат = ПроверкаКонтрагентовВызовСервера.РезультатРаботыФоновогоЗаданияПроверкиКонтрагентовВДокументе(
				Форма.РеквизитыПроверкиКонтрагентов);
			
			Если Результат.ЗаданиеВыполнено Тогда
				
				// Закрытие формы длительной операции.
				Если Форма.ФормаДлительнойОперации <> Неопределено
					И Форма.ФормаДлительнойОперации.Открыта() Тогда
					ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(Форма.ФормаДлительнойОперации);
				КонецЕсли;
				
				// Уведомление должно идти после закрытия формы длительной операции,
				// иначе обе формы закроются одновременно.
				Если НЕ Результат.ЕстьДоступКВебСервисуФНС Тогда
					Если Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаПоКнопке Тогда
						УведомитьОбОтсутствииДоступа(); // в документе
						Возврат;
					КонецЕсли;
				КонецЕсли;

				// Отображение результата проверки на форме.
				// Результат проверки перерисовывается на форме:
				// - при проверке по кнопке - всегда.
				// - при автоматической проверке - только если данные в кэше отличаются от данных,
				//		полученных от ФНС.
				Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания = Неопределено;
				Если НЕ Результат.ДанныеВКэшСовпадаютСФНС
					ИЛИ Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаПоКнопке Тогда
					
					// Контекстный серверный вызов, который из-за особенности платформы
					// приводит к сбрасыванию редактируемого значения.
					Форма.ОтобразитьРезультатПроверкиКонтрагента();
					
				КонецЕсли;
				
				// Перерисовка списка документов.
				ОповеститьОбИзмененииСостоянияДокумента(Форма);
				
			Иначе
				
				// Если есть незавершившиеся фоновые задания, то продолжаем ждать результат.
				Если Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания <> Неопределено Тогда
					
					ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания);
					
					Форма.ПодключитьОбработчикОжидания(
						"Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", 
						Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания.ТекущийИнтервал, 
						Истина);
						
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

// Запускает проверку контрагента из документа, если было определено, что возникло событие,
//	требующее обновления результата проверки контрагентов.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  ИмяСобытия					 - Строка - Имя события обработки оповещения.
//  Параметр					 - Произвольный - Параметр обработки оповещения.
//  Источник					 - Произвольный - Источник обработки оповещения.
Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		Если СобытиеТребуетПроверкиКонтрагента(Форма, ИмяСобытия, Параметр, Источник) Тогда
			
			// Добавляем в параметры источник события.
			ДополнительныеПараметры = ПроверкаКонтрагентовКлиентСервер.ПараметрыФоновогоЗадания(Источник);
			// Добавляем в параметры признак, что после проверки нужно записать результат в регистр.
			ДополнительныеПараметры = ПроверкаКонтрагентовКлиентСервер.ПараметрыФоновогоЗадания(Истина, ДополнительныеПараметры);
			
			ЗапуститьПроверкуКонтрагентовВДокументе(Форма, ДополнительныеПараметры);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Взводит флаг, что редактируется табличная часть.
//		Если взведен флаг, то результат проверки контрагента не будет отображен до тех пор, 
//		пока не завершится редактирование табличной части.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//
Процедура ПриНачалеРедактированияТабличнойЧасти(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		Форма.РеквизитыПроверкиКонтрагентов.ОтложитьПрорисовкуРезультатаПроверкиКонтрагентов = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Сбрасывает флаг, что редактируется табличная часть.
//		Если взведен флаг, то результат проверки контрагента не будет отображен до тех пор, 
//		пока не завершится редактирование табличной части.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//
Процедура ПриОкончанииРедактированияТабличнойЧасти(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		Форма.РеквизитыПроверкиКонтрагентов.ОтложитьПрорисовкуРезультатаПроверкиКонтрагентов = Ложь;
		
		Если Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания <> Неопределено Тогда
			ОбработатьРезультатПроверкиКонтрагентовВДокументе(Форма);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверка контрагентов по кнопке в открытом документе.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//
Процедура ПроверитьКонтрагентовВДокументеПоКнопке(Форма) Экспорт

	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("СохранятьРезультатСразуПослеПроверки", НЕ Форма.Модифицированность);
	ДополнительныеПараметры.Вставить("ЭтоПроверкаПоКнопке", Истина);
	
	ЗапуститьПроверкуКонтрагентовВДокументе(Форма, ДополнительныеПараметры);
	
	Форма.ФормаДлительнойОперации = 
		ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(
			Форма, 
			Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания);
			
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВОтчетах

// Подключение обработчика ожидания для отображения предложения на использование проверки.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма отчета, в котором выполняется проверка контрагентов.
Процедура ОтчетПриОткрытии(Форма) Экспорт
	
	Если НЕ Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется
		И Форма.РеквизитыПроверкиКонтрагентов.НужноПоказатьПредложениеВключитьПроверкуКонтрагентов Тогда
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
	КонецЕсли;
	
КонецПроцедуры

// Запуск проверки контрагентов в отчете после первичного формирования отчета.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма отчета, в котором выполняется проверка контрагентов.
Процедура ЗапуститьПроверкуКонтрагентовВОтчете(Форма) Экспорт
	
	Форма.РеквизитыПроверкиКонтрагентов.ПроверкаВыполнялась = Ложь;
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется 
		И Форма.РеквизитыПроверкиКонтрагентов.НедействующиеКонтрагентыКоличество > 0 Тогда
		
		Если Форма.РеквизитыПроверкиКонтрагентов.ЕстьДоступКВебСервисуФНС Тогда
			
			Форма.ПроверитьКонтрагентов();
			ПроверкаКонтрагентовКлиентСервер.УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, "ПроверкаВПроцессеВыполнения");
			
			ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
			ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
			
			ДополнительныеПараметры = Новый Структура();
			ДополнительныеПараметры.Вставить("Форма", Форма);

			ОповещениеОЗавершении = Новый ОписаниеОповещения(
				"ПроверкаКонтрагентовВОтчетеЗавершение", 
				ЭтотОбъект,
				ДополнительныеПараметры);
				
			ДлительныеОперацииКлиент.ОжидатьЗавершение(
				Форма.РеквизитыПроверкиКонтрагентов.ДлительнаяОперация, 
				ОповещениеОЗавершении, 
				ПараметрыОжидания);
			
		Иначе
			ПроверкаКонтрагентовКлиентСервер.ВывестиНужнуюПанельПроверкиКонтрагентовВОтчете(Форма);
		КонецЕсли;
	Иначе
		ПроверкаКонтрагентовКлиентСервер.ВывестиНужнуюПанельПроверкиКонтрагентовВОтчете(Форма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВСправочнике

// Подключение обработчиков результата проверки контрагента из карточки контрагента.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Карточка контрагента.
Процедура ПриОткрытииКонтрагент(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.НужноПоказатьПредложениеВключитьПроверкуКонтрагентов Тогда
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
	КонецЕсли;
		
	// Если состояние контрагента не известно, то пытаемся его определить.
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		Если Форма.РеквизитыПроверкиКонтрагентов.ФоновоеЗаданиеЗапущено Тогда
			Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата = 1;
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата, Истина);
		КонецЕсли;
	КонецЕсли
	
КонецПроцедуры

// Запуск проверки из карточки контрагента.
//
// Параметры:
//  Форма - УправляемаяФорма - Карточка контрагента.
//
Процедура ЗапуститьПроверкуКонтрагентаВСправочнике(Форма) Экспорт
	
	// Если ИНН или КПП некорректные, или проверка не включена, то не запускаем проверку.
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаПоКнопке = Ложь;
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ЭтоПроверкаСправочника", Истина);
		
		ЕстьОшибкиПредварительнойПроверки =
			ПроверкаКонтрагентовКлиентСервер.ПрерватьПроверкуКонтрагентовИзЗаОшибокПредварительнойПроверки(
				Форма,
				ДополнительныеПараметры,
				ОбщегоНазначенияКлиент.ДатаСеанса());
		
		Если ЕстьОшибкиПредварительнойПроверки Тогда
			
			ОбработатьСостояниеКонтрагентаВСправочнике(Форма);
			
		Иначе
			
			ПроверкаКонтрагентовКлиентСервер.ПроверитьКонтрагентаИзКарточки(Форма, Ложь);
			
			// Прерываем предыдущую проверку.
			Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата = 1;
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата, Истина);
			
		КонецЕсли;
		
	Иначе
		
		// При возникновении любого события, приводящего к необходимости перепроверить контрагента
		// в режиме проверки по кнопке сбрасываем предыдущий результат проверки, но не перепроверяем.
		// Если нужно, перепроверку пользователь сможет сделать по кнопке.
		ОчиститьРезультатПроверкиКонтрагента(Форма);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработка результата фонового задания по проверке контрагента из карточки контрагента.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Карточка контрагента.
Процедура ОбработатьРезультатПроверкиКонтрагентовВСправочнике(Форма) Экспорт
	
	ПроверкаКонтрагентовКлиентСервер.ПредотвратитьСбросРедактируемогоЗначения(Форма);
	
	// Определение объекта и ссылки.
	ОбъектИСсылкаПоФорме = ПроверкаКонтрагентовКлиентСервер.ОбъектИСсылкаПоФорме(Форма);
	КонтрагентОбъект     = ОбъектИСсылкаПоФорме.Объект;
	КонтрагентСсылка     = ОбъектИСсылкаПоФорме.Ссылка;
	
	СвойстваСправочника = ПроверкаКонтрагентовКлиентСервер.СвойстваСправочникаКонтрагенты(КонтрагентСсылка);
	
	ИНН = КонтрагентОбъект[СвойстваСправочника.РеквизитИНН];
	КПП = КонтрагентОбъект[СвойстваСправочника.РеквизитКПП];
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаПоКнопке
		И НЕ ЗначениеЗаполнено(Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента)
		И Форма.РеквизитыПроверкиКонтрагентов.ФоновоеЗаданиеЗапущено Тогда 
		
		// Если это проверка по кнопке то результат получаем только из адреса временного хранилища.
		Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента = 
			ТекущееСостояниеКонтрагента(Неопределено, Неопределено, Неопределено, Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища);
		
	Иначе
		
		Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента = 
			ТекущееСостояниеКонтрагента(КонтрагентСсылка, ИНН, КПП, Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища);
		
	КонецЕсли;
	
	ОбработатьСостояниеКонтрагентаВСправочнике(Форма);
	
КонецПроцедуры

// Проверка контрагента по кнопке в карточке контрагента.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Карточка контрагента.
//
Процедура ПроверитьКонтрагентаПоКнопке(Форма) Экспорт

	Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаПоКнопке = Истина;
	
	ОчиститьРезультатПроверкиКонтрагента(Форма);
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ЭтоПроверкаСправочника", 					Истина);
	ДополнительныеПараметры.Вставить("СохранятьРезультатСразуПослеПроверки", 	НЕ Форма.Модифицированность);
	
	ЕстьОшибкиПредварительнойПроверки = 
		ПроверкаКонтрагентовКлиентСервер.ПрерватьПроверкуКонтрагентовИзЗаОшибокПредварительнойПроверки(
			Форма,
			ДополнительныеПараметры,
			ОбщегоНазначенияКлиент.ДатаСеанса());
	
	Если ЕстьОшибкиПредварительнойПроверки Тогда
		
		ОбработатьСостояниеКонтрагентаВСправочнике(Форма);
		
	Иначе
		
		// Если форма модифицирована, то результат запишется при записи карточки.
		// Сразу результат не записываем для модифицированного контрагента на тот случай,
		// если в карточке сделают изменение, а потом закроют форму без сохранения.
		СохранятьРезультатСразуПослеПроверки = НЕ Форма.Модифицированность;
		ПроверкаКонтрагентовКлиентСервер.ПроверитьКонтрагентаИзКарточки(Форма, СохранятьРезультатСразуПослеПроверки);
		
		// Прерываем предыдущую проверку.
		Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата = 1;
		
		Форма.ПодключитьОбработчикОжидания(
			"Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", 
			Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата, 
			Истина);
		
		// Открываем форму длительной операции.
		Форма.ФормаДлительнойОперации = 
			ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(
				Форма, 
				Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания); 
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверкаКонтрагентовВОтчетеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если Форма.Открыта() И Результат <> Неопределено Тогда
		Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища = Результат.АдресРезультата;
		Форма.ОтобразитьРезультатПроверкиКонтрагента();
		Форма.РеквизитыПроверкиКонтрагентов.ДлительнаяОперация = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповеститьОбИзмененииСостоянияДокумента(Форма)
	
	// Перерисовка списка выполняется всегда, не только когда данные в регистре не совпадают с 
	// данными веб-сервиса, так как при следующих условиях перерисовка требуется,
	// но в ветку для кэша не заходит: документ еще ни разу не проверялся, но данные контрагента
	// совпадают с кэшем.
	Если Форма.РеквизитыПроверкиКонтрагентов.СохранятьРезультатСразуПослеПроверки
		И Форма.РеквизитыПроверкиКонтрагентов.ЭтотДокументБылСОшибкой <> Форма.РеквизитыПроверкиКонтрагентов.ЭтоДокументСОшибкой Тогда
		
		// Определение объекта и ссылки.
		ОбъектИСсылкаПоФорме 	= ПроверкаКонтрагентовКлиентСервер.ОбъектИСсылкаПоФорме(Форма);
		ДокументСсылка 			= ОбъектИСсылкаПоФорме.Ссылка;

		ОповеститьОбИзменении(ДокументСсылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УведомитьОбОтсутствииДоступа()

	ПоказатьПредупреждение(, НСтр("ru = 'Проверка контрагентов сервисом ФНС не выполнена из-за ошибки подключения к сервису'"));

КонецПроцедуры

Функция ИнтервалОбработкиРезультата()
	
	// Более короткий интервал приводит к замедлению при открытии форм.
	Возврат 1;
	
КонецФункции

Процедура ОбработатьСостояниеКонтрагентаВСправочнике(Форма)
	
	ПроверкаКонтрагентовКлиентСервер.ПредотвратитьСбросРедактируемогоЗначения(Форма);
	
	// Проверяем готовность результата фонового задания.
	Если ЗначениеЗаполнено(Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента) Тогда
		
		// Результат получен
		Форма.РеквизитыПроверкиКонтрагентов.ФоновоеЗаданиеЗапущено = Ложь;
		ПроверкаКонтрагентовКлиентСервер.ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма);
		
		ЗакрытьФормуДлительнойОперацииВСправочнике(Форма);
		
	Иначе
		
		ПроверкаКонтрагентовКлиентСервер.ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма);
		// Проверяем результат через каждые 2 сек до 25 сек
		Если Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата <= 25 Тогда
			Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата = Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата + 2;
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата, Истина);
			Возврат;
		Иначе
			
			ЗакрытьФормуДлительнойОперацииВСправочнике(Форма);
			
			// Была выполнена проверка по кнопке.
			// Пользователь ждет результата.
			// Если результат через 25 секунд не получен - предупреждаем пользователя.
			Если Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаПоКнопке Тогда
				УведомитьОбОтсутствииДоступа(); // в справочнике
			КонецЕсли;

			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ЗакрытьФормуДлительнойОперацииВСправочнике(Форма)

	Если Форма.РеквизитыПроверкиКонтрагентов.ЭтоПроверкаПоКнопке Тогда
		
		Если Форма.ФормаДлительнойОперации <> Неопределено
			И Форма.ФормаДлительнойОперации.Открыта() Тогда
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(Форма.ФормаДлительнойОперации);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОчиститьРезультатПроверкиКонтрагента(Форма)
	
	Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента = 
		ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустаяСсылка");
			
	ПроверкаКонтрагентовКлиентСервер.ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма);
	
КонецПроцедуры

#КонецОбласти