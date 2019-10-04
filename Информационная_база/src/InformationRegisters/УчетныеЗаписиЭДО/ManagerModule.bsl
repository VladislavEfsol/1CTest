#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция НовыеДанныеЗаполнения() Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация"                                  , Неопределено);
	ДанныеЗаполнения.Вставить("НаименованиеУчетнойЗаписи"                    , Неопределено);
	ДанныеЗаполнения.Вставить("ВерсияКонфигурации"                           , Неопределено);
	ДанныеЗаполнения.Вставить("ОператорЭДО"                                  , Неопределено);
	ДанныеЗаполнения.Вставить("СпособОбменаЭД"                               , Неопределено);
	ДанныеЗаполнения.Вставить("ЭлектроннаяПочтаДляУведомлений"               , Неопределено);
	ДанныеЗаполнения.Вставить("ОжидатьИзвещениеОПолучении"                   , Ложь);
	ДанныеЗаполнения.Вставить("УведомлятьОНовыхПриглашениях"                 , Ложь);
	ДанныеЗаполнения.Вставить("УведомлятьОбОтветахНаПриглашения"             , Ложь);
	ДанныеЗаполнения.Вставить("УведомлятьОНовыхДокументах"                   , Ложь);
	ДанныеЗаполнения.Вставить("УведомлятьОНеОбработанныхДокументах"          , Ложь);
	ДанныеЗаполнения.Вставить("УведомлятьОбОкончанииСрокаДействияСертификата", Ложь);
	ДанныеЗаполнения.Вставить("КодНалоговогоОргана"                          , Неопределено);
	ДанныеЗаполнения.Вставить("ДатаПолученияЭД"                              , ТекущаяДатаСеанса());
	ДанныеЗаполнения.Вставить("ДатаПоследнегоПолученияПриглашений"           , Неопределено);
	ДанныеЗаполнения.Вставить("НазначениеУчетнойЗаписи"                      , Неопределено);
	ДанныеЗаполнения.Вставить("ПодробноеОписаниеУчетнойЗаписи"               , Неопределено);
	ДанныеЗаполнения.Вставить("ИдентификаторЭДО"                             , Неопределено);
	ДанныеЗаполнения.Вставить("АдресОрганизации"                             , Неопределено);
	ДанныеЗаполнения.Вставить("ПринятыУсловияИспользования"                  , Ложь);
	
	Возврат ДанныеЗаполнения;
КонецФункции

Процедура НоваяУчетнаяЗаписьЭДО(Знач ДанныеЗаполнения, Отказ) Экспорт
	
	ПустыеДанныеЗаполнения = НовыеДанныеЗаполнения();
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(ДанныеЗаполнения, ПустыеДанныеЗаполнения, Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО
		|ИЗ
		|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|ГДЕ
		|	УчетныеЗаписиЭДО.Организация = &Организация
		|	И УчетныеЗаписиЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ДанныеЗаполнения.ИдентификаторЭДО);
	Запрос.УстановитьПараметр("Организация"     , ДанныеЗаполнения.Организация);
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		Шаблон = НСтр("ru = 'Учетная запись организации %2 с идентификатором %1 уже существует'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ДанныеЗаполнения.ИдентификаторЭДО, ДанныеЗаполнения.Организация);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(ДанныеЗаполнения.ИдентификаторЭДО)
				Или Не ЗначениеЗаполнено(ДанныеЗаполнения.Организация) Тогда 
				
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не заполнены обязательные реквизиты учетной записи.'"),,,,Отказ);
				
				Возврат;
				
	КонецЕсли;
	
	Попытка
		Запись = РегистрыСведений.УчетныеЗаписиЭДО.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, ДанныеЗаполнения);
		Запись.Записать();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ВидОперации = НСтр("ru = 'Создание новой учетной записи ЭДО'");
		ПодробныйТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КраткийТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ЭлектронноеВзаимодействие.ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, КраткийТекстОшибки, "ОбменСКонтрагентами");
		
		Отказ = Истина;
		
	КонецПопытки;
	
КонецПроцедуры

Функция ДанныеУчетнойЗаписиЭДОПоИдентификатору(ИдентификаторЭДО) Экспорт 
	
	Данные = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	УчетныеЗаписиЭДО.Организация КАК Организация,
		|	УчетныеЗаписиЭДО.ОператорЭДО КАК ОператорЭДО,
		|	УчетныеЗаписиЭДО.СпособОбменаЭД КАК СпособОбменаЭД,
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторОрганизации
		|ИЗ
		|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|ГДЕ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторЭДО);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаРезультат = РезультатЗапроса.Выгрузить();
	
	Если ТаблицаРезультат.Количество() > 0 Тогда
		
		Данные = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРезультат[0]);
		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Процедура УдалитьУчетнуюЗаписьЭДО(Параметры, АдресРезультата) Экспорт
	
	Отказ                     = Ложь;
	ИдентификаторЭДО          = Неопределено;
	НаименованиеУчетнойЗаписи = Неопределено;
	
	Параметры.Свойство("ИдентификаторЭДО", ИдентификаторЭДО);
	Параметры.Свойство("НаименованиеУчетнойЗаписи", НаименованиеУчетнойЗаписи);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель КАК Отправитель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель КАК Получатель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор КАК Договор,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ВидДокумента КАК ВидДокумента
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам КАК НастройкиОтправкиЭлектронныхДокументовПоВидам
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторОтправителя = &ИдентификаторЭДО
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СостоянияОбменовЭДЧерезОператоровЭДО.ИдентификаторОрганизации КАК ИдентификаторОрганизации
		|ИЗ
		|	РегистрСведений.СостоянияОбменовЭДЧерезОператоровЭДО КАК СостоянияОбменовЭДЧерезОператоровЭДО
		|ГДЕ
		|	СостоянияОбменовЭДЧерезОператоровЭДО.ИдентификаторОрганизации = &ИдентификаторЭДО
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	АбонентыЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО
		|ИЗ
		|	РегистрСведений.АбонентыЭДО КАК АбонентыЭДО
		|ГДЕ
		|	АбонентыЭДО.ИдентификаторЭДО = &ИдентификаторЭДО
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя КАК ИдентификаторПолучателя
		|ИЗ
		|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
		|ГДЕ
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = &ИдентификаторЭДО
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации КАК ИдентификаторОрганизации
		|ИЗ
		|	РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами КАК ПриглашенияКОбменуЭлектроннымиДокументами
		|ГДЕ
		|	ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации = &ИдентификаторЭДО
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО
		|ИЗ
		|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|ГДЕ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторЭДО);
	
	Если ЗначениеЗаполнено(ИдентификаторЭДО) Тогда
		
		// Удаляем все под текущими правами пользователя.
		РезультатыЗапросов = Запрос.ВыполнитьПакет();
		
		НачатьТранзакцию();
		Попытка
			
			НастройкиОтправкиЭлектронныхДокументовПоВидам = РезультатыЗапросов[0].Выбрать();
			Пока НастройкиОтправкиЭлектронныхДокументовПоВидам.Следующий() Цикл
				НаборЗаписей = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Отправитель.Установить(НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель);
				НаборЗаписей.Отбор.Получатель.Установить(НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель);
				НаборЗаписей.Отбор.Договор.Установить(НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор);
				НаборЗаписей.Отбор.ВидДокумента.Установить(НастройкиОтправкиЭлектронныхДокументовПоВидам.ВидДокумента);
				НаборЗаписей.Записать();
			КонецЦикла;
			
			СостоянияОбменовЭДЧерезОператоровЭДО = РезультатыЗапросов[1].Выбрать();
			Пока СостоянияОбменовЭДЧерезОператоровЭДО.Следующий() Цикл
				НаборЗаписей = РегистрыСведений.СостоянияОбменовЭДЧерезОператоровЭДО.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ИдентификаторОрганизации.Установить(СостоянияОбменовЭДЧерезОператоровЭДО.ИдентификаторОрганизации);
				НаборЗаписей.Записать();
			КонецЦикла;
			
			АбонентыЭДО = РезультатыЗапросов[2].Выбрать();
			Пока АбонентыЭДО.Следующий() Цикл
				НаборЗаписей = РегистрыСведений.АбонентыЭДО.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(АбонентыЭДО.ИдентификаторЭДО);
				НаборЗаписей.Записать();
			КонецЦикла;
			
			НастройкиПолученияЭлектронныхДокументов = РезультатыЗапросов[3].Выбрать();
			Пока НастройкиПолученияЭлектронныхДокументов.Следующий() Цикл
				НаборЗаписей = РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ИдентификаторПолучателя.Установить(НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя);
				НаборЗаписей.Записать();
			КонецЦикла;
			
			ПриглашенияКОбменуЭлектроннымиДокументами = РезультатыЗапросов[4].Выбрать();
			Пока ПриглашенияКОбменуЭлектроннымиДокументами.Следующий() Цикл
				НаборЗаписей = РегистрыСведений.ПриглашенияКОбменуЭлектроннымиДокументами.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ИдентификаторОрганизации.Установить(ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации);
				НаборЗаписей.Записать();
			КонецЦикла;
			
			УчетныеЗаписиЭДО = РезультатыЗапросов[5].Выбрать();
			Пока УчетныеЗаписиЭДО.Следующий() Цикл
				НаборЗаписей = РегистрыСведений.УчетныеЗаписиЭДО.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(УчетныеЗаписиЭДО.ИдентификаторЭДО);
				НаборЗаписей.Записать();
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			Информация = ИнформацияОбОшибке();
			
			Отказ = Истина;
			
			ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Удаление настроек учетной записи ЭДО'"),
				ПодробноеПредставлениеОшибки(Информация));
				
		КонецПопытки;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Отказ, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
