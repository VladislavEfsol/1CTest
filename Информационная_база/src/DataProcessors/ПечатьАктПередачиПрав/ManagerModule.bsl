
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ServiceAPI

Функция ИдентификаторПечатнойФормы() Экспорт
	
	Возврат "АктПередачиПрав";
	
КонецФункции

Функция КлючПараметровПечати() Экспорт
	
	Возврат "ПАРАМЕТРЫ_ПЕЧАТИ_Универсальные_АктПередачиПрав";
	
КонецФункции

Функция ПолныйПутьКМакету() Экспорт
	
	Возврат "Обработка.ПечатьАктПередачиПрав.ПФ_MXL_АктПередачиПрав";
	
КонецФункции

Функция ПредставлениеПФ() Экспорт
	
	Возврат НСтр("ru ='Акт передачи прав'");
	
КонецФункции

Функция СформироватьПФ(ОписаниеПечатнойФормы, ДанныеОбъектовПечати, ОбъектыПечати) Экспорт
	Перем Ошибки, ПервыйДокумент, НомерСтрокиНачало;
	
	Макет				= УправлениеПечатью.МакетПечатнойФормы(ОписаниеПечатнойФормы.ПолныйПутьКМакету);
	ТабличныйДокумент	= ОписаниеПечатнойФормы.ТабличныйДокумент;
	ДанныеПечати		= Новый Структура;
	ЕстьТЧЗапасы		= (ДанныеОбъектовПечати.Колонки.Найти("ТаблицаЗапасы") <> Неопределено);
	НациональнаяВалюта	= Константы.НациональнаяВалюта.Получить();
	
	РеквизитыИзСведений = "ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,Факс,НомерСчета,Банк,БИК,КоррСчет";
	
	ОбластиМакета = Новый Структура;
	ОбластиМакета.Вставить("ОбластьМакетаШапка",			ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Шапка", 			"", 							Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаЗаголовокТаблицы", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ЗаголовокТаб", 	НСтр("ru ='Заголовок таблицы'"),Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаСтрока",			ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Строка", 			"",								Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаИтогоПоСтранице",	ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ИтогоПоСтранице",	НСтр("ru ='Итоги по странице'"),Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаВсего",			ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Всего",			"",								Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаПодвал",			ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Подвал",			"",								Ошибки));
	
	Для каждого ДанныеОбъекта Из ДанныеОбъектовПечати Цикл
		
		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало, ДанныеПечати);
		
		Если ОбластиМакета.ОбластьМакетаШапка <> Неопределено Тогда
			
			НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ДанныеОбъекта.ДатаДокумента, ДанныеОбъекта.Номер, ДанныеОбъекта.Префикс);
			
			ДанныеПечати.Вставить("НомерДокумента", НомерДокумента);
			ДанныеПечати.Вставить("ДатаДокумента", ДанныеОбъекта.ДатаДокумента);
			
			СведенияОПоставщике			= УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ДанныеОбъекта.Организация,      ДанныеОбъекта.ДатаДокумента, ,);
			СведенияОПокупателе			= УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ДанныеОбъекта.Контрагент,       ДанныеОбъекта.ДатаДокумента, , ДанныеОбъекта.БанковскийСчетКонтрагента);
			
			ДанныеПечати.Вставить("ПредставлениеПоставщика",	УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОПоставщике,		РеквизитыИзСведений));
			ДанныеПечати.Вставить("ПредставлениеПлательщика",	УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОПокупателе,		РеквизитыИзСведений));
			
			ДанныеПечати.Вставить("ПоставщикНаименование", СведенияОПоставщике.ПолноеНаименование);
			ДанныеПечати.Вставить("ПлательщикНаименование", СведенияОПокупателе.ПолноеНаименование);
			ДанныеПечати.Вставить("ПредставлениеПодразделения", ДанныеОбъекта.ПредставлениеСкладаСписания);
			ДанныеПечати.Вставить("ВидДеятельностиПоОКДП", Неопределено);
			ДанныеПечати.Вставить("ПоставщикПоОКПО", СведенияОПоставщике.КодПоОКПО);
			ДанныеПечати.Вставить("ПлательщикПоОКПО", СведенияОПокупателе.КодПоОКПО);
			ДанныеПечати.Вставить("ПредставлениеОснования",ДанныеОбъекта.ПредставлениеОснования);
			ДанныеПечати.Вставить("ОснованиеНомер", ДанныеОбъекта.ОснованиеНомер);
			ДанныеПечати.Вставить("ОснованиеДата", ДанныеОбъекта.ОснованиеДата);
			ДанныеПечати.Вставить("ТранспортнаяНакладнаяНомер", ДанныеОбъекта.ТранспортнаяНакладнаяНомер);
			ДанныеПечати.Вставить("ТранспортнаяНакладнаяДата", ДанныеОбъекта.ТранспортнаяНакладнаяДата);
			
			ОбластиМакета.ОбластьМакетаШапка.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаШапка);
			
		КонецЕсли;
		
		НомерСтраницы = 1;
		Если ОбластиМакета.ОбластьМакетаЗаголовокТаблицы <> Неопределено Тогда 
			
			ДанныеПечати.Вставить("НомерСтраницы", "Страница " + НомерСтраницы);
			
			ОбластиМакета.ОбластьМакетаЗаголовокТаблицы.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаЗаголовокТаблицы);
			
		КонецЕсли;
		
		СтруктураИтогов = Новый Структура(
		"ИтогоМестНаСтранице,
		|ИтогоМассаБруттоПоСтранице,
		|ИтогоКоличествоНаСтранице,
		|ИтогоСуммаНаСтранице,
		|ИтогоНДСНаСтранице,
		|ИтогоСуммаСНДСНаСтранице,
		|НомерСтроки,
		|КоличествоСтрок,
		|ИтогоМест,
		|ИтогоМассаБрутто,
		|ИтогоКоличество,
		|ИтогоСумма,
		|ИтогоНДС,
		|ИтогоСуммаСНДС",
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
		
		Если ОбластиМакета.ОбластьМакетаСтрока <> Неопределено Тогда
			
			ПараметрыНоменклатуры = Новый Структура;
			
			Если ЕстьТЧЗапасы Тогда
				
				// Наборы
				ЕстьНаборы = (ДанныеОбъекта.ТаблицаЗапасы.Колонки.Найти("НоменклатураНабора")<>Неопределено);
				СтруктураИтогов.Вставить("ЕстьНаборы", ЕстьНаборы);
				// Конец Наборы
				
				Для Каждого СтрокаЗапаса Из ДанныеОбъекта.ТаблицаЗапасы Цикл
					
					ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаЗапаса, ДанныеПечати, ПараметрыНоменклатуры, СтруктураИтогов, ДанныеОбъекта.СуммаВключаетНДС);
					
					Если СтруктураИтогов.НомерСтроки > 1 
						И СтрокаКорректноРазмещаетсяНаСтранице(ТабличныйДокумент, ОбластиМакета, СтруктураИтогов) = Ложь Тогда
						
						ДобавитьНовуюСтраницуДокумента(ТабличныйДокумент, ОбластиМакета, СтруктураИтогов);
						
					КонецЕсли;
					
					ОбластиМакета.ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеПечати);
					ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаСтрока);
					
					// Наборы
					Если СтруктураИтогов.ЕстьНаборы Тогда
						НаборыСервер.УчестьОформлениеСтрокиНабора(ТабличныйДокумент, ОбластиМакета.ОбластьМакетаСтрока, СтрокаЗапаса);
					КонецЕсли; 
			
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ОбластиМакета.ОбластьМакетаИтогоПоСтранице <> Неопределено Тогда
			
			ОбластиМакета.ОбластьМакетаИтогоПоСтранице.Параметры.Заполнить(СтруктураИтогов);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаИтогоПоСтранице);
			
		КонецЕсли;
		
		Если ОбластиМакета.ОбластьМакетаВсего <> Неопределено Тогда
			
			ОбластиМакета.ОбластьМакетаВсего.Параметры.Заполнить(СтруктураИтогов);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаВсего);
			
		конецЕсли;
		
		Если ОбластиМакета.ОбластьМакетаПодвал <> Неопределено Тогда
			
			ПоследняяЦифра = Прав(Строка(НомерСтраницы), 1);
			Суффикс = ?(ПоследняяЦифра = "1", НСтр("ru =' листе'"), НСтр("ru =' листах'"));
			ДанныеПечати.Вставить("КоличествоЛистовВПриложении", Строка(НомерСтраницы) + Суффикс);
			
			ДанныеПечати.Вставить("ДолжностьРуководителя", ДанныеОбъекта.ДолжностьРуководителя);
			ДанныеПечати.Вставить("РасшифровкаПодписиРуководителя", ДанныеОбъекта.РасшифровкаПодписиРуководителя);
			ДанныеПечати.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", ЧислоПрописью(СтруктураИтогов.КоличествоСтрок, ,",,,,,,,,0"));
			ДанныеПечати.Вставить("ВсегоМестПрописью", ?(СтруктураИтогов.ИтогоМест = 0, "", ЧислоПрописью(СтруктураИтогов.ИтогоМест, ,",,,С,,,,,0")));
			ДанныеПечати.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(СтруктураИтогов.ИтогоСуммаСНДС, НациональнаяВалюта));
			ДанныеПечати.Вставить("ДоверенностьНомер", ДанныеОбъекта.ДоверенностьНомер);
			ДанныеПечати.Вставить("ДоверенностьДата", ДанныеОбъекта.ДоверенностьДата);
			ДанныеПечати.Вставить("ДоверенностьВыдана", ДанныеОбъекта.ДоверенностьВыдана);
			ДанныеПечати.Вставить("ДоверенностьЧерезКого", ДанныеОбъекта.ДоверенностьЛицо);
			ДанныеПечати.Вставить("ДоверенностьЧерезКого", ДанныеОбъекта.ДоверенностьЛицо);
			ДанныеПечати.Вставить("РасшифровкаПодписиКонтрагента", ДанныеОбъекта.РасшифровкаПодписиКонтрагента);
			
			ПолнаяДатаДокумента = Формат(ДанныеОбъекта.ДатаДокумента, "ДФ=""дд ММММ гггг """"года""""""");
			ДлинаСтроки         = СтрДлина(ПолнаяДатаДокумента);
			ПервыйРазделитель   = СтрНайти(ПолнаяДатаДокумента," ");
			ВторойРазделитель   = СтрНайти(Прав(ПолнаяДатаДокумента,ДлинаСтроки - ПервыйРазделитель), " ") + ПервыйРазделитель;
			
			ДанныеПечати.Вставить("ДатаДокументаДень", """" + Лев(ПолнаяДатаДокумента, ПервыйРазделитель - 1) + """");
			ДанныеПечати.Вставить("ДатаДокументаМесяц", Сред(ПолнаяДатаДокумента, ПервыйРазделитель + 1, ВторойРазделитель - ПервыйРазделитель - 1));
			ДанныеПечати.Вставить("ДатаДокументаГод", Прав(ПолнаяДатаДокумента, ДлинаСтроки - ВторойРазделитель));
			
			ОбластиМакета.ОбластьМакетаПодвал.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаПодвал);
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеОбъекта.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

Процедура ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеПечати, ПараметрыНоменклатуры, СтруктураИтогов, СуммаВключаетНДС)
	
	ДанныеПечати.Очистить();
	
	Если СтрокаТабличнойЧасти.ЭтоНабор Тогда
		НомерСтроки = 0;
	Иначе
		СтруктураИтогов.НомерСтроки = СтруктураИтогов.НомерСтроки+1;
		НомерСтроки = СтруктураИтогов.НомерСтроки;
	КонецЕсли;
	ДанныеПечати.Вставить("НомерСтроки", НомерСтроки);
	
	ПараметрыНоменклатуры.Очистить();
	ПараметрыНоменклатуры.Вставить("Содержание", СтрокаТабличнойЧасти.Содержание);
	ПараметрыНоменклатуры.Вставить("ПредставлениеНоменклатуры", СтрокаТабличнойЧасти.ПредставлениеНоменклатуры);
	ПараметрыНоменклатуры.Вставить("ПредставлениеХарактеристики", СтрокаТабличнойЧасти.Характеристика);
	// Наборы
	Если СтруктураИтогов.ЕстьНаборы Тогда
		ПараметрыНоменклатуры.Вставить("НеобходимоВыделитьКакСоставНабора", СтрокаТабличнойЧасти.НеобходимоВыделитьКакСоставНабора);
	КонецЕсли;
	// Конец Наборы
	ДанныеПечати.Вставить("ПредставлениеНоменклатуры", ПечатьДокументовУНФ.ПредставлениеНоменклатуры(ПараметрыНоменклатуры));
	ДанныеПечати.Вставить("ПредставлениеКодаНоменклатуры", ПечатьДокументовУНФ.ПредставлениеКодаНоменклатуры(СтрокаТабличнойЧасти));
	ДанныеПечати.Вставить("ЗапасКод", СтрокаТабличнойЧасти.ЗапасКод);
	ДанныеПечати.Вставить("ЕдиницаИзмеренияПоОКЕИ_Наименование", СтрокаТабличнойЧасти.ЕдиницаИзмеренияПоОКЕИ_Наименование);
	ДанныеПечати.Вставить("ЕдиницаИзмеренияПоОКЕИ_Код", СтрокаТабличнойЧасти.ЕдиницаИзмеренияПоОКЕИ_Код);
	
	ДанныеПечати.Вставить("ВидУпаковки", СтрокаТабличнойЧасти.ВидУпаковки);
	ДанныеПечати.Вставить("КоличествоВОдномМесте", СтрокаТабличнойЧасти.КоличествоВОдномМесте);
	ДанныеПечати.Вставить("КоличествоМест", СтрокаТабличнойЧасти.КоличествоМест);
	ДанныеПечати.Вставить("Количество", Окр(СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.КоэффициентЕдиницыИзмерения, 3));
	
	ДанныеПечати.Вставить("СтавкаНДС", СтрокаТабличнойЧасти.СтавкаНДС);
	ДанныеПечати.Вставить("СуммаСНДС", СтрокаТабличнойЧасти.Всего);
	ДанныеПечати.Вставить("СуммаНДС", СтрокаТабличнойЧасти.СуммаНДС);
	
	СуммаБезНДС = СтрокаТабличнойЧасти.Сумма - ?(СуммаВключаетНДС, СтрокаТабличнойЧасти.СуммаНДС, 0);
	ДанныеПечати.Вставить("СуммаБезНДС", СуммаБезНДС);
	ДанныеПечати.Вставить("Цена", СуммаБезНДС / ?(ДанныеПечати.Количество = 0, 1, ДанныеПечати.Количество));
	
	Если НЕ СтруктураИтогов.ЕстьНаборы ИЛИ НЕ СтрокаТабличнойЧасти.ЭтоНабор Тогда
		
		СтруктураИтогов.ИтогоМестНаСтранице = СтруктураИтогов.ИтогоМестНаСтранице + ?(ДанныеПечати.КоличествоМест = Неопределено, 0, ДанныеПечати.КоличествоМест);
		СтруктураИтогов.ИтогоКоличествоНаСтранице = СтруктураИтогов.ИтогоКоличествоНаСтранице + ДанныеПечати.Количество;
		СтруктураИтогов.ИтогоСуммаНаСтранице = СтруктураИтогов.ИтогоСуммаНаСтранице + ДанныеПечати.СуммаБезНДС;
		СтруктураИтогов.ИтогоНДСНаСтранице = СтруктураИтогов.ИтогоНДСНаСтранице + ДанныеПечати.СуммаНДС;
		СтруктураИтогов.ИтогоСуммаСНДСНаСтранице = СтруктураИтогов.ИтогоСуммаСНДСНаСтранице + ДанныеПечати.СуммаСНДС;
		
		СтруктураИтогов.ИтогоМест = СтруктураИтогов.ИтогоМест + ?(ДанныеПечати.КоличествоМест = Неопределено, 0, ДанныеПечати.КоличествоМест);
		СтруктураИтогов.ИтогоКоличество = СтруктураИтогов.ИтогоКоличество + ДанныеПечати.Количество;
		СтруктураИтогов.ИтогоСумма = СтруктураИтогов.ИтогоСумма + ДанныеПечати.СуммаБезНДС;
		СтруктураИтогов.ИтогоНДС = СтруктураИтогов.ИтогоНДС + ДанныеПечати.СуммаНДС;
		СтруктураИтогов.ИтогоСуммаСНДС = СтруктураИтогов.ИтогоСуммаСНДС + ДанныеПечати.СуммаСНДС;
		
		СтруктураИтогов.КоличествоСтрок = СтруктураИтогов.КоличествоСтрок + 1;
		
	КонецЕсли; 
	
КонецПроцедуры

Функция СтрокаКорректноРазмещаетсяНаСтранице(ТабличныйДокумент, СтруктураОбластейМакета, СтруктураИтогов)
	
	ЕстьВсеОбласти = Истина;
	Для каждого ЭлементСтруктуры Из СтруктураОбластейМакета Цикл
		
		Если ЭлементСтруктуры.Значение = Неопределено Тогда
			
			ЕстьВсеОбласти = Ложь;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьВсеОбласти Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	МассивОбластейМакета = Новый Массив;
	
	Если СтруктураИтогов.НомерСтроки = 1 Тогда
		
		МассивОбластейМакета.Добавить(СтруктураОбластейМакета.ОбластьМакетаЗаголовокТаблицы);
		
	КонецЕсли;
	
	МассивОбластейМакета.Добавить(СтруктураОбластейМакета.ОбластьМакетаСтрока);
	МассивОбластейМакета.Добавить(СтруктураОбластейМакета.ОбластьМакетаИтогоПоСтранице);
	
	Если СтруктураИтогов.НомерСтроки = СтруктураИтогов.КоличествоСтрок Тогда
		
		МассивОбластейМакета.Добавить(СтруктураОбластейМакета.ОбластьМакетаВсего);
		МассивОбластейМакета.Добавить(СтруктураОбластейМакета.ОбластьМакетаПодвал);
		
	КонецЕсли;
	
	Возврат НЕ ТабличныйДокумент.ПроверитьВывод(МассивОбластейМакета)
	
КонецФункции

Процедура ДобавитьНовуюСтраницуДокумента(ТабличныйДокумент, ОбластиМакета, СтруктураИтогов)
	
	ОбластиМакета.ОбластьМакетаИтогоПоСтранице.Параметры.Заполнить(СтруктураИтогов);
	ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаИтогоПоСтранице);
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	СтруктураИтогов.ИтогоМестНаСтранице = 0;
	СтруктураИтогов.ИтогоКоличествоНаСтранице = 0;
	СтруктураИтогов.ИтогоСуммаНаСтранице = 0;
	СтруктураИтогов.ИтогоНДСНаСтранице = 0;
	СтруктураИтогов.ИтогоСуммаСНДСНаСтранице = 0;
	
	// Выведем заголовок таблицы
	СтруктураИтогов.НомерСтраницы = СтруктураИтогов.НомерСтраницы + 1;
	ПредставлениеСтраницы = НСтр("ru ='Страница '") + СтруктураИтогов.НомерСтраницы;
	ОбластиМакета.ОбластьМакетаЗаголовокТаблицы.Параметры.Заполнить(Новый Структура("ПредставлениеСтраницы", ПредставлениеСтраницы));
	ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаЗаголовокТаблицы);
	
КонецПроцедуры

#КонецЕсли