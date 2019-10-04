
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Представление = Данные.НомерЗаписи;
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("НомерЗаписи");
	
КонецПроцедуры

#КонецОбласти


#Область ТекстыЗапросов

Функция ТекстЗапросаДанныеЗаписейСкладскогоЖурнала() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ОстаткиПродукцииВЕТИС.ХозяйствующийСубъект            КАК ХозяйствующийСубъект,
	|	ОстаткиПродукцииВЕТИС.Предприятие                     КАК Предприятие,
	|	ОстаткиПродукцииВЕТИС.Продукция                       КАК Продукция,
	|	ОстаткиПродукцииВЕТИС.ЗаписьСкладскогоЖурнала         КАК ЗаписьСкладскогоЖурнала,
	|	СУММА(ОстаткиПродукцииВЕТИС.КоличествоВЕТИС)          КАК КоличествоВЕТИС,
	|	МАКСИМУМ(ОстаткиПродукцииВЕТИС.ЕдиницаИзмеренияВЕТИС) КАК ЕдиницаИзмеренияВЕТИС
	|ПОМЕСТИТЬ ВТОстаткиПродукцииВЕТИС
	|ИЗ
	|	РегистрСведений.ОстаткиПродукцииВЕТИС КАК ОстаткиПродукцииВЕТИС
	|ГДЕ
	|	ОстаткиПродукцииВЕТИС.ЗаписьСкладскогоЖурнала В(&Ссылки)
	|
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиПродукцииВЕТИС.ХозяйствующийСубъект,
	|	ОстаткиПродукцииВЕТИС.Предприятие,
	|	ОстаткиПродукцииВЕТИС.Продукция,
	|	ОстаткиПродукцииВЕТИС.ЗаписьСкладскогоЖурнала
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ХозяйствующийСубъект,
	|	Предприятие,
	|	Продукция,
	|	ЗаписьСкладскогоЖурнала
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиСкладскогоЖурналаВЕТИСВетеринарноСопроводительныеДокументы.Ссылка                              КАК ЗаписьСкладскогоЖурнала,
	|	ЗаписиСкладскогоЖурналаВЕТИСВетеринарноСопроводительныеДокументы.ВетеринарноСопроводительныйДокумент КАК ВСД
	|ПОМЕСТИТЬ ВТВетеринарноСопроводительныеДокументыЗаписей
	|ИЗ
	|	Справочник.ЗаписиСкладскогоЖурналаВЕТИС.ВетеринарноСопроводительныеДокументы КАК ЗаписиСкладскогоЖурналаВЕТИСВетеринарноСопроводительныеДокументы
	|ГДЕ
	|	ЗаписиСкладскогоЖурналаВЕТИСВетеринарноСопроводительныеДокументы.Ссылка В(&Ссылки)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаписиСкладскогоЖурналаВЕТИСВетеринарноСопроводительныеДокументы.Ссылка,
	|	ЗаписиСкладскогоЖурналаВЕТИСВетеринарноСопроводительныеДокументы.ВетеринарноСопроводительныйДокумент
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаписиСкладскогоЖурналаВЕТИСВетеринарноСопроводительныеДокументы.Ссылка,
	|	ЗаписиСкладскогоЖурналаВЕТИСВетеринарноСопроводительныеДокументы.ВетеринарноСопроводительныйДокумент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗначенияИзВСД.ЗаписьСкладскогоЖурнала                                                       КАК ЗаписьСкладскогоЖурнала,
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ ЗначенияИзВСД.ВСД.Цель)                                               КАК ЦелиПоЗаписи,
	|	МАКСИМУМ   (ЗначенияИзВСД.ВСД.Цель)                                                         КАК Цель,
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ ЗначенияИзВСД.ВСД.ПериодНахожденияЖивотныхНаТерриторииТС)             КАК ПериодыПоЗаписи,
	|	МАКСИМУМ   (ЗначенияИзВСД.ВСД.ПериодНахожденияЖивотныхНаТерриторииТС)                       КАК ПериодНахожденияЖивотныхНаТерриторииТС,
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ ЗначенияИзВСД.ВСД.КоличествоПериодовНахожденияЖивотныхНаТерриторииТС) КАК КоличествоПериодовПоЗаписи,
	|	МАКСИМУМ   (ЗначенияИзВСД.ВСД.КоличествоПериодовНахожденияЖивотныхНаТерриторииТС)           КАК КоличествоПериодовНахожденияЖивотныхНаТерриторииТС,
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ ЗначенияИзВСД.ВСД.ТипПроисхождения)                                   КАК ТипыПроисхожденияПоЗаписи,
	|	МАКСИМУМ   (ЗначенияИзВСД.ВСД.ТипПроисхождения)                                             КАК ТипПроисхождения
	|ПОМЕСТИТЬ ВТРеквизитыДокументовИзВСД
	|ИЗ ВТВетеринарноСопроводительныеДокументыЗаписей КАК ЗначенияИзВСД
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗначенияИзВСД.ЗаписьСкладскогоЖурнала
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗначенияИзВСД.ЗаписьСкладскогоЖурнала
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиСкладскогоЖурналаВЕТИС.Ссылка                             КАК Ссылка,
	|	ЗаписиСкладскогоЖурналаВЕТИС.Продукция                          КАК Продукция,
	|	ЗаписиСкладскогоЖурналаВЕТИС.СкоропортящаясяПродукция           КАК СкоропортящаясяПродукция,
	|	ЗаписиСкладскогоЖурналаВЕТИС.НизкокачественнаяПродукция         КАК НизкокачественнаяПродукция,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(ВТРеквизитыДокументовИзВСД.ЦелиПоЗаписи,0) = 1
	|		ТОГДА ВТРеквизитыДокументовИзВСД.Цель
	|	ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ                                        КАК Цель,
	|	ВЫБОР КОГДА ЕСТЬNULL(ВТРеквизитыДокументовИзВСД.ПериодыПоЗаписи,0) = 1
	|		ТОГДА ВТРеквизитыДокументовИзВСД.ПериодНахожденияЖивотныхНаТерриторииТС
	|	ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ                                        КАК ПериодНахожденияЖивотныхНаТерриторииТС,
	|	ВЫБОР КОГДА ЕСТЬNULL(ВТРеквизитыДокументовИзВСД.КоличествоПериодовПоЗаписи,0) = 1
	|		ТОГДА ВТРеквизитыДокументовИзВСД.КоличествоПериодовНахожденияЖивотныхНаТерриторииТС
	|	ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ                                        КАК КоличествоПериодовНахожденияЖивотныхНаТерриторииТС,
	|	ВЫБОР КОГДА ЕСТЬNULL(ВТРеквизитыДокументовИзВСД.ТипыПроисхожденияПоЗаписи,0) = 1
	|		ТОГДА ВТРеквизитыДокументовИзВСД.ТипПроисхождения
	|	ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ                                        КАК ТипПроисхождения,
	|
	|	ЗаписиСкладскогоЖурналаВЕТИС.ДатаПроизводстваСтрока             КАК ДатаПроизводстваСтрока,
	|	ЗаписиСкладскогоЖурналаВЕТИС.ДатаПроизводстваТочностьЗаполнения КАК ДатаПроизводстваТочностьЗаполнения,
	|	ЗаписиСкладскогоЖурналаВЕТИС.ДатаПроизводстваНачалоПериода      КАК ДатаПроизводстваНачалоПериода,
	|	ЗаписиСкладскогоЖурналаВЕТИС.ДатаПроизводстваКонецПериода       КАК ДатаПроизводстваКонецПериода,
	|	ЗаписиСкладскогоЖурналаВЕТИС.СрокГодностиСтрока                 КАК СрокГодностиСтрока,
	|	ЗаписиСкладскогоЖурналаВЕТИС.СрокГодностиТочностьЗаполнения     КАК СрокГодностиТочностьЗаполнения,
	|	ЗаписиСкладскогоЖурналаВЕТИС.СрокГодностиНачалоПериода          КАК СрокГодностиНачалоПериода,
	|	ЗаписиСкладскогоЖурналаВЕТИС.СрокГодностиКонецПериода           КАК СрокГодностиКонецПериода,
	|
	|	ЗаписиСкладскогоЖурналаВЕТИС.СтранаПроизводства                 КАК СтранаПроизводства,
	|
	|	ВЫБОР
	|		КОГДА НЕ ЗаписиСкладскогоЖурналаВЕТИС.АктуальнаяЗаписьСкладскогоЖурнала = ЗНАЧЕНИЕ(Справочник.ЗаписиСкладскогоЖурналаВЕТИС.ПустаяСсылка)
	|			ТОГДА ЗаписиСкладскогоЖурналаВЕТИС.КоличествоВЕТИС
	|		ИНАЧЕ ЕСТЬNULL(ВТОстаткиПродукцииВЕТИС.КоличествоВЕТИС, 0)
	|	КОНЕЦ КАК КоличествоВЕТИС,
	|
	|	ВЫБОР
	|		КОГДА НЕ ЗаписиСкладскогоЖурналаВЕТИС.АктуальнаяЗаписьСкладскогоЖурнала = ЗНАЧЕНИЕ(Справочник.ЗаписиСкладскогоЖурналаВЕТИС.ПустаяСсылка)
	|			ТОГДА ЗаписиСкладскогоЖурналаВЕТИС.ЕдиницаИзмеренияВЕТИС
	|		ИНАЧЕ ЕСТЬNULL(ВТОстаткиПродукцииВЕТИС.ЕдиницаИзмеренияВЕТИС, ЗНАЧЕНИЕ(Справочник.ЕдиницыИзмеренияВЕТИС.ПустаяСсылка))
	|	КОНЕЦ КАК ЕдиницаИзмеренияВЕТИС,
	|
	|	ЗаписиСкладскогоЖурналаВЕТИС.УпаковкиВЕТИС.(
	|		ИдентификаторСтроки     КАК ИдентификаторСтроки,
	|		УровеньУпаковки         КАК УровеньУпаковки,
	|		УпаковкаВЕТИС           КАК УпаковкаВЕТИС,
	|		КоличествоУпаковокВЕТИС КАК КоличествоУпаковокВЕТИС
	|	) КАК УпаковкиВЕТИС,
	|
	|	ЗаписиСкладскогоЖурналаВЕТИС.ШтрихкодыУпаковок.(
	|		ИдентификаторСтроки     КАК ИдентификаторСтроки,
	|		Штрихкод                КАК Штрихкод,
	|		ТипМаркировки           КАК ТипМаркировки
	|	) КАК ШтрихкодыУпаковок,
	|
	|	ЗаписиСкладскогоЖурналаВЕТИС.Производители.(
	|		Производитель           КАК Производитель,
	|		РольПредприятия         КАК РольПредприятия
	|	) КАК Производители,
	|
	|	ЗаписиСкладскогоЖурналаВЕТИС.ПроизводственныеПартии.(
	|		ИдентификаторПартии     КАК ИдентификаторПартии
	|	) КАК ПроизводственныеПартии
	|
	|ИЗ
	|	Справочник.ЗаписиСкладскогоЖурналаВЕТИС КАК ЗаписиСкладскогоЖурналаВЕТИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОстаткиПродукцииВЕТИС КАК ВТОстаткиПродукцииВЕТИС
	|		ПО ЗаписиСкладскогоЖурналаВЕТИС.ХозяйствующийСубъект = ВТОстаткиПродукцииВЕТИС.ХозяйствующийСубъект
	|			И ЗаписиСкладскогоЖурналаВЕТИС.Предприятие = ВТОстаткиПродукцииВЕТИС.Предприятие
	|			И ЗаписиСкладскогоЖурналаВЕТИС.Продукция = ВТОстаткиПродукцииВЕТИС.Продукция
	|			И ЗаписиСкладскогоЖурналаВЕТИС.Ссылка = ВТОстаткиПродукцииВЕТИС.ЗаписьСкладскогоЖурнала
	|			И (ЗаписиСкладскогоЖурналаВЕТИС.АктуальнаяЗаписьСкладскогоЖурнала = ЗНАЧЕНИЕ(Справочник.ЗаписиСкладскогоЖурналаВЕТИС.ПустаяСсылка))
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРеквизитыДокументовИзВСД КАК ВТРеквизитыДокументовИзВСД
	|			ПО ВТРеквизитыДокументовИзВСД.ЗаписьСкладскогоЖурнала = ЗаписиСкладскогоЖурналаВЕТИС.Ссылка
	|ГДЕ
	|	ЗаписиСкладскогоЖурналаВЕТИС.Ссылка В(&Ссылки)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти