#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И( ЗначениеРазрешено(Контрагент)
	|	ИЛИ Контрагент = Значение(Справочник.Контрагенты.ПустаяСсылка)
	|	)И( ЗначениеРазрешено(Касса)
	|	ИЛИ ТипДенежныхСредств <> Значение(Перечисление.ТипыДенежныхСредств.Наличные)
	|	) ";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// Процедура формирования таблицы платежного календаря.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//
Процедура СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК Статья,
	|	ТаблицаДокумента.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ТаблицаДокумента.СтатусУтвержденияПлатежа КАК СтатусУтвержденияПлатежа,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.Касса
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	&Ссылка КАК СчетНаОплату,
	|	ТаблицаДокумента.ВалютаДокумента КАК Валюта,
	|	-ТаблицаДокумента.СуммаДокумента КАК Сумма
	|ИЗ
	|	Документ.РасходДСПлан КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлатежныйКалендарь", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПлатежныйКалендарь()

// Процедура формирования таблицы денежных средств в резерве.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//
Процедура СформироватьТаблицаДенежныеСредстваВРезерве(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.Касса
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	&Ссылка КАК Документ,
	|	ТаблицаДокумента.ВалютаДокумента КАК Валюта,
	|	ТаблицаДокумента.СуммаДокумента КАК Сумма
	|ИЗ
	|	Документ.РасходДСПлан КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|	И ТаблицаДокумента.СтатусУтвержденияПлатежа = ЗНАЧЕНИЕ(Перечисление.СтатусыУтвержденияПлатежей.Утвержден)
	|	И ТаблицаДокумента.РезервироватьДенежныеСредства";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ДенежныеСредстваВРезерве", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПлатежныйКалендарь()

// Формирует таблицу данных документа.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	СтруктураДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//	
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДенежныеСредстваВРезерве(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаРасходДСПлан, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если НЕ Константы.КонтролироватьОстаткиПриПроведении.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРезервированиеДенежныхСредств") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДенежныеСредстваВРезервеОстатки.Организация КАК Организация,
		|	ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|	ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса КАК БанковскийСчетКассаПредставление,
		|	ДенежныеСредстваВРезервеОстатки.Валюта КАК Валюта,
		|	ДенежныеСредстваВРезервеОстатки.Документ КАК Документ,
		|	ДенежныеСредстваВРезервеОстатки.СуммаОстаток КАК ВРезерве
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(&МоментКонтроля, Документ = &СсылкаНаДокумент) КАК ДенежныеСредстваВРезервеОстатки
		|ГДЕ
		|	ДенежныеСредстваВРезервеОстатки.СуммаОстаток < 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияДенежныеСредстваВРезервеИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.Организация КАК ОрганизацияПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса КАК БанковскийСчетКассаПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.Валюта КАК ВалютаПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств КАК ТипДенежныхСредствПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) КАК ОстатокДенежныхСредств,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПриЗаписи КАК СуммаПриЗаписи,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаИзменение КАК СуммаИзменение,
		|	ЕСТЬNULL(РезервыПоДокументам.СуммаОстаток, 0) + ЕСТЬNULL(НеснижаемыеОстаткиДенежныхСредствСрезПоследних.СуммаНеснижаемогоОстатка, 0) - ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПриЗаписи КАК ВРезерве,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) КАК СвободныйОстаток
		|ИЗ
		|	ДвиженияДенежныеСредстваВРезервеИзменение КАК ДвиженияДенежныеСредстваВРезервеИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредства.Остатки(&МоментКонтроля, ) КАК ДенежныеСредстваОстатки
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.Организация = ДенежныеСредстваОстатки.Организация
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = ДенежныеСредстваОстатки.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = ДенежныеСредстваОстатки.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = ДенежныеСредстваОстатки.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НеснижаемыеОстаткиДенежныхСредств.СрезПоследних(&МоментКонтроля, ) КАК НеснижаемыеОстаткиДенежныхСредствСрезПоследних
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ДенежныеСредстваВРезервеОстатки.Организация КАК Организация,
		|			ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|			ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса КАК БанковскийСчетКасса,
		|			ДенежныеСредстваВРезервеОстатки.Валюта КАК Валюта,
		|			СУММА(ДенежныеСредстваВРезервеОстатки.СуммаОстаток) КАК СуммаОстаток
		|		ИЗ
		|			РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(&МоментКонтроля, ) КАК ДенежныеСредстваВРезервеОстатки
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ДенежныеСредстваВРезервеОстатки.Организация,
		|			ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств,
		|			ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса,
		|			ДенежныеСредстваВРезервеОстатки.Валюта) КАК РезервыПоДокументам
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.Организация = РезервыПоДокументам.Организация
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = РезервыПоДокументам.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = РезервыПоДокументам.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = РезервыПоДокументам.Валюта
		|ГДЕ
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) - (ЕСТЬNULL(НеснижаемыеОстаткиДенежныхСредствСрезПоследних.СуммаНеснижаемогоОстатка, 0) + ЕСТЬNULL(РезервыПоДокументам.СуммаОстаток, 0)) < 0");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		Запрос.УстановитьПараметр("СсылкаНаДокумент", ДокументСсылкаРасходДСПлан);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если 	НЕ МассивРезультатов[0].Пустой()
			ИЛИ НЕ МассивРезультатов[1].Пустой() Тогда
			ДокументОбъектРасходДСПлан = ДокументСсылкаРасходДСПлан.ПолучитьОбъект()
		КонецЕсли;
		
		// Отрицательный остаток по денежным средствам в резерве.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструДенежныеСредстваВРезерве(ДокументОбъектРасходДСПлан, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток по денежным средствам с учетом резервов.
		Если НЕ МассивРезультатов[1].Пустой() Тогда //Если остатка денежных средств не хватает, то выводить ошибку по резервам нет смысла
			Если ДокументОбъектРасходДСПлан.РезервироватьДенежныеСредства Тогда
				ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструДенежныеСредстваСУчетомРезервов(ДокументОбъектРасходДСПлан, ВыборкаИзРезультатаЗапроса, Отказ);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Процедура формирует и выводит печатную форму документа по указанному макету.
//
// Параметры:
//	ТабличныйДокумент - ТабличныйДокумент в который будет выводится печатная
//				   форма.
//  ИмяМакета    - Строка, имя макета печатной формы.
//
Процедура СформироватьПланированиеРасходаДС(ТабличныйДокумент, МассивОбъектов, ОбъектыПечати)
	
	ПервыйДокумент = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасходДСПлан_ПланированиеРасходовДС";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РасходДСПлан.ПФ_MXL_ПланированиеРасходовДС");
	
	СтруктураЗаполненияСекции = Новый Структура;
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если НЕ ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПланРасходаДС.Ссылка
		|	,ПланРасходаДС.Номер КАК Номер
		|	,ПланРасходаДС.Дата КАК ДатаДокумента
		|	,ПланРасходаДС.Организация КАК Организация
		|	,ПланРасходаДС.Организация.Префикс КАК Префикс
		|	,ПланРасходаДС.СуммаДокумента КАК Сумма
		|	,ПланРасходаДС.ВалютаДокумента КАК Валюта
		|	,Представление(ПланРасходаДС.СтатьяДвиженияДенежныхСредств) КАК СтатьяДДС
		|	,Выразить(ПланРасходаДС.Комментарий КАК Строка(1000)) КАК Комментарий
		|	,ПланРасходаДС.ТипДенежныхСредств КАК ТипДС
		|	,ПланРасходаДС.БанковскийСчет.Код КАК НомерРС
		|	,ПланРасходаДС.Касса КАК Касса
		|	,Представление(ПланРасходаДС.ДокументОснование) КАК ОписаниеОснования
		|	,Выбор 
		|		Когда ПланРасходаДС.Проведен И ПланРасходаДС.СтатусУтвержденияПлатежа = Значение(Перечисление.СтатусыУтвержденияПлатежей.Утвержден) Тогда Истина
		|		Иначе Ложь
		|		Конец КАК ЗаявкаУтверждена
		|	,ПланРасходаДС.НомерВходящегоДокумента
		|	,ПланРасходаДС.ДатаВходящегоДокумента
		|	,ПланРасходаДС.Контрагент КАК Контрагент
		|	,ПланРасходаДС.Договор КАК Договор
		|	,ПланРасходаДС.ПодписьРуководителя.Должность КАК ДолжностьРуководителя
		|	,ПланРасходаДС.ПодписьРуководителя.РасшифровкаПодписи КАК РасшифровкаПодписиРуководителя
		|	,ПланРасходаДС.ПодписьГлавногоБухгалтера.Должность КАК ДолжностьГлавногоБухгалтера
		|	,ПланРасходаДС.ПодписьГлавногоБухгалтера.РасшифровкаПодписи КАК РасшифровкаПодписиГлавногоБухгалтера
		|	,ПланРасходаДС.Автор
		|ИЗ
		|	Документ.РасходДСПлан КАК ПланРасходаДС
		|ГДЕ
		|	ПланРасходаДС.Ссылка = &ТекущийДокумент";
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
		ДанныеДокумента = Запрос.Выполнить().Выбрать();
		ДанныеДокумента.Следующий();
		
		//:::Утверждено, отступ
		ОбластьМакета = Макет.ПолучитьОбласть(?(ДанныеДокумента.ЗаявкаУтверждена, "Утверждено", "Отступ"));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//:::Шапка
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		СтруктураЗаполненияСекции.Очистить();
		
		НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ДанныеДокумента.ДатаДокумента, ДанныеДокумента.Номер, ДанныеДокумента.Префикс);
		ДатаДокумента = Формат(ДанныеДокумента.ДатаДокумента, "ДФ='дд ММММ гггг'");
		Заголовок = НСтр("ru ='Планирование расхода денежных средств № '") + НомерДокумента + НСтр("ru =' от '") + ДатаДокумента;
		СтруктураЗаполненияСекции.Вставить("Заголовок", Заголовок);
		ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//:::Строка
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		СтруктураЗаполненияСекции.Очистить();
		
		СтруктураЗаполненияСекции.Вставить("СтатьяДДС", ДанныеДокумента.СтатьяДДС);
		СтруктураЗаполненияСекции.Вставить("Комментарий", ДанныеДокумента.Комментарий);
		СтруктураЗаполненияСекции.Вставить("ОписаниеСуммы", Формат(ДанныеДокумента.Сумма, "ЧЦ=15; ЧДЦ=2; ЧРД=.") + ", " + ДанныеДокумента.Валюта);
		
		ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//:::Подвал
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		СтруктураЗаполненияСекции.Очистить();
		
		СтруктураЗаполненияСекции.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДанныеДокумента.Сумма, ДанныеДокумента.Валюта));
		СтруктураЗаполненияСекции.Вставить("ОписаниеОснования", ДанныеДокумента.ОписаниеОснования);
		СтруктураЗаполненияСекции.Вставить("ОписаниеКонтрагента", ДанныеДокумента.Контрагент);
		
		ОписаниеИсточникаФинансирования = "";
		Если ДанныеДокумента.ТипДС = Перечисления.ТипыДенежныхСредств.Безналичные Тогда
			
			ОписаниеИсточникаФинансирования = НСтр("ru ='расчетный счет организации № '") + ДанныеДокумента.НомерРС;
			
		ИначеЕсли ДанныеДокумента.ТипДС = Перечисления.ТипыДенежныхСредств.Безналичные Тогда
			
			ОписаниеИсточникаФинансирования = НСтр("ru ='касса организации '") + ДанныеДокумента.Касса;
			
		КонецЕсли;
		СтруктураЗаполненияСекции.Вставить("ОписаниеИсточникаФинансирования", ОписаниеИсточникаФинансирования);
		
		ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//:::Подпись
		ОбластьМакета = Макет.ПолучитьОбласть("Подпись");
		ОбластьМакета.Параметры.Заполнить(ДанныеДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
КонецПроцедуры // СформироватьПланированиеРасходаДС()

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПланированиеРасходовДС") Тогда
		
		СформироватьПланированиеРасходаДС(ТабличныйДокумент, МассивОбъектов, ОбъектыПечати);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПланированиеРасходовДС", "Планирование расходов ДС", ТабличныйДокумент);
		
	КонецЕсли;
	
	// параметры отправки печатных форм по электронной почте
	УправлениеНебольшойФирмойСервер.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПланированиеРасходовДС";
	КомандаПечати.Представление = НСтр("ru = 'Планирование расходов ДС'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли