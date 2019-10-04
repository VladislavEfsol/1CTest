
#Область ПрограммныйИнтерфейс

// Регистрирует тарифицируемые услуги конфигурации из Структуры.
//
// Параметры:
//  ПоставщикиУслуг - Массив - массив структур, описывающей поставщика услуги.
//
// Пример структуры
//  Обязательные ключи:
//    * "Идентификатор" - идентификатор поставщика услуги (тип Строка(50)),
//    * "Наименование" - наименование поставщика услуги (тип Строка(150)),
//    * "Услуги" - массив услуг, массив структур с обязательными ключами:
//         ** "Идентификатор" - идентификатор услуги  (тип Строка(50))
//         ** "Наименование" - наименование услуги  (тип Строка(150))
//         ** "ТипУслуги" - тип услуги  (тип ПеречислениеСсылка.ТипыУслуг)
//
Процедура ПриФормированииСпискаУслуг(ПоставщикиУслуг) Экспорт
	
	МассивУслуг = Новый Массив;
	
	
	// Услуга для того, чтобы определить - откуда у нас пришёл абонент
	// и нужно ли ему включать соответствующий интерфейс розничных продаж 
	Услуга = Новый Структура;
	Услуга.Вставить("Идентификатор", "РозничныйАбонент");
	Услуга.Вставить("Наименование", "Абонент с розничными услугами");
	Услуга.Вставить("ТипУслуги", Перечисления.ТипыУслуг.Безлимитная);
	Услуга.Вставить("РазрешеноДобавлятьВТарифы", Истина);
	МассивУслуг.Добавить(Услуга);
	
	НовыйПоставщикУНФ = Новый Структура;
	НовыйПоставщикУНФ.Вставить("Идентификатор", "1С_УНФ");
	НовыйПоставщикУНФ.Вставить("Наименование", "1С:УНФ");
	НовыйПоставщикУНФ.Вставить("Услуги", МассивУслуг);
	
	ПоставщикиУслуг.Добавить(НовыйПоставщикУНФ);
	
	МассивУслугКассы = Новый Массив;
	
	// Ограничение по количеству действующих касс ккм
	МассивУслугКассы.Добавить(ОграничениеКоличествоКассПоТарифу());
	
	НовыйПоставщикКассы = Новый Структура;
	НовыйПоставщикКассы.Вставить("Идентификатор", "1С_Касса");
	НовыйПоставщикКассы.Вставить("Наименование", "1С:Касса");
	НовыйПоставщикКассы.Вставить("Услуги", МассивУслугКассы);
	
	ПоставщикиУслуг.Добавить(НовыйПоставщикКассы);
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.ПриФормированииСпискаУслуг(ПоставщикиУслуг);
	// Конец ИнтернетПоддержкаПользователей
	
	// БиблиотекаЭлектронныхДокументов
	ЭлектронноеВзаимодействие.ПриФормированииСпискаУслуг(ПоставщикиУслуг);
	// Конец БиблиотекаЭлектронныхДокументов
	
	// МобильноеПриложение
	МобильноеПриложениеВызовСервера.ПриФормированииСпискаУслуг(ПоставщикиУслуг);
	// Конец МобильноеПриложение
	
КонецПроцедуры

// Событие, которое вызывается при изменении активации лицензии.
//
// Параметры:
//  ДанныеОЛицензии - Структура - данные о лицензии.
//    ** Услуга - СправочникСсылка.Услуги - услуга.
//    ** ИмяЛицензии - Строка - имя лицензии.
//    ** КонтекстЛицензии - Строка - контекст лицензии.
//  ЛицензияАктивирована - Булево - активирована лицензия или деактивирована.
//
Процедура ПриИзмененииСостоянияАктивацииЛицензии(ДанныеОЛицензии, ЛицензияАктивирована) Экспорт
	
	РеквизитыУслуги = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеОЛицензии.Услуга, "ПоставщикУслуги, Идентификатор");
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыУслуги.ПоставщикУслуги, "Идентификатор") = "1С_Касса"
			И РеквизитыУслуги.Идентификатор = "КоличествоКасс" Тогда
		ВыполнитьАктивациюЛицензииКоличествоКасс(ДанныеОЛицензии.ИмяЛицензии, ЛицензияАктивирована);
	КонецЕсли;
КонецПроцедуры

// Событие, которое вызывается при обновлении доступных лицензий.
//
// ПараметрыЛицензии - Структура - структура лицензии. Структура соответствует составу реквизитов, измерений и ресурсов РС "ДоступныеЛицензии".
//
Процедура ПриОбновленииДоступныхЛицензий(ПараметрыЛицензии) Экспорт
	
	
	
КонецПроцедуры

// Событие, которое вызывается при удалении доступных лицензий.
//
// ПараметрыЛицензии - Структура - структура лицензии. Структура соответствует составу реквизитов, измерений и ресурсов РС "ДоступныеЛицензии".
//
Процедура ПриУдаленииДоступныхЛицензий(ПараметрыЛицензии) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при определении представления валюты оплаты сервиса.
// 
// Параметры:
//  ПредставлениеВалютыОплаты - представление валюты оплаты. 
//
Процедура ПриУстановкеПредставленияВалютыОплаты(ПредставлениеВалютыОплаты) Экспорт
	ПредставлениеВалютыОплаты = НСтр("ru='руб.'");
КонецПроцедуры

// Вызывается при получении имени формы обработки ответа на запрос счета на оплату.
// 
// Параметры:
//  ИмяФормыОбработкиОтвета - имя формы обработки ответа.
//
Процедура ПриПолученииИмениФормыОбработкиОтвета(ИмяФормыОбработкиОтвета) Экспорт
	ИмяФормыОбработкиОтвета = "Обработка.ОплатаСервиса.Форма.ОбработкаОтвета";
КонецПроцедуры

#Область ПрограммныйИнтерфейсУНФ

Процедура ВыполнитьАктивациюЛицензииКоличествоКасс(ИмяЛицензии, ЛицензияАктивирована) Экспорт
	
	КодЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
	КассовыйАппарат = ИнтеграцияОбменШтрихМ.ПолучитьКассуПоИдентификаторуЛицензии(ИмяЛицензии);
	Если Не ЗначениеЗаполнено(КассовыйАппарат) Тогда
		// Это ошибочная регистрация. Надо освободить лицензию.
		Отмена = ТарификацияПереопределяемый.ОтменаРегистрацииКассыНаСервереТарификации(ИмяЛицензии, Ложь);
		Если Не Отмена Тогда
			Сообщение = СтрШаблон(НСтр("ru = 'Не освобождена лицензия для ККМ с регистрационным номером: %1'", КодЯзыка),
				ИмяЛицензии);
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Деактивация лицензии.'",КодЯзыка),
			УровеньЖурналаРегистрации.Предупреждение,,, Сообщение);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ОтключенаЛицензия = ИнтеграцияОбменШтрихМ.ПолучитьРеквизитыКассыШтрихМ(КассовыйАппарат).ОтключенаЛицензия;
	ИзменитьОтключение = Ложь;
	Если ОтключенаЛицензия И ЛицензияАктивирована Тогда
		ИзменитьОтключение = Истина;
	ИначеЕсли НЕ ОтключенаЛицензия И НЕ ЛицензияАктивирована Тогда
		ИзменитьОтключение = Истина;
	КонецЕсли;
	
	Если ИзменитьОтключение Тогда
		КассовыйАппаратОбъект = КассовыйАппарат.ПолучитьОбъект();
		Если КассовыйАппаратОбъект = Неопределено Тогда
			// Это ошибочная регистрация. Надо освободить лицензию.
			Отмена = ТарификацияПереопределяемый.ОтменаРегистрацииКассыНаСервереТарификации(ИмяЛицензии, Ложь);
			Если Не Отмена Тогда
				Сообщение = СтрШаблон(НСтр("ru = 'Не освобождена лицензия для ККМ с регистрационным номером: %1'", КодЯзыка),
					ИмяЛицензии);
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Деактивация лицензии.'",КодЯзыка),
				УровеньЖурналаРегистрации.Предупреждение,,, Сообщение);
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		//КассовыйАппаратОбъект.ОтключенаЛицензия = НЕ ЛицензияАктивирована;
		ЗаписьРегистра = РегистрыСведений.НастройкиКассыШтрихМ.СоздатьМенеджерЗаписи();
		ЗаписьРегистра.КассаККМ = КассовыйАппарат;
		ЗаписьРегистра.Прочитать();
		ЗаписьРегистра.ОтключенаЛицензия = НЕ ЛицензияАктивирована;
		ЗаписьРегистра.Записать();
		
	КонецЕсли;
КонецПроцедуры

// Описание ограничения "Количество зарегистрированных ККМ".
//
// Возвращаемое значение:
//  ТарифноеОграничение - Структура, описание тарифного ограничения.
//
Функция ОграничениеКоличествоКассПоТарифу() Экспорт
	
	ТарифноеОграничение = Новый Структура;
	ТарифноеОграничение.Вставить("Идентификатор", "КоличествоКасс");
	ТарифноеОграничение.Вставить("Наименование", НСтр("ru = 'Количество подключенных ККМ (по рег. номеру)'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	ТарифноеОграничение.Вставить("ТипУслуги", Перечисления.ТипыУслуг.Уникальная);
	ТарифноеОграничение.Вставить("Поставщик", "1С_Касса");
	
	Возврат ТарифноеОграничение;
КонецФункции

// Выполняет попытку отмены регистрации на сервере тарификации кассового аппарата.
//
// Параметры:
//  Ссылка - СправочникСсылка.КассовыеАппараты - ссылка на кассовый аппарат.
//  УдалениеОбъекта - Булево - флаг удаления кассового аппарата.
//
// Возвращаемое значение:
//  Булево - флаг успешной отмены регистрации.
//
Функция ОтменаРегистрацииКассыНаСервереТарификации(ИдентификаторЛицензии, УдалениеОбъекта = Истина, ОтменитьДляВсехОбластей = Ложь, КодОбластиДанных = 0) Экспорт
	
	
	// Тариф проверям только во Фреше.
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЛицензии) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИдентификаторОперации = Новый УникальныйИдентификатор;
	
	ТарифноеОграничение = ОграничениеКоличествоКассПоТарифу();
	
	ЛицензияИспользуется = ПроверкаИспользованияЛицензииКоличествоКасс(ИдентификаторЛицензии, ТарифноеОграничение);
	
	Если ЛицензияИспользуется = Неопределено Тогда
		Возврат Истина;
	Иначе
		Если Не ЛицензияИспользуется Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		Если РаботаВМоделиСервиса.СеансЗапущенБезРазделителей() Тогда
			Результат = Тарификация.ОсвободитьЛицензиюУникальнойУслуги(ТарифноеОграничение.Поставщик,
				ТарифноеОграничение.Идентификатор,
				ИдентификаторЛицензии,
				ИдентификаторОперации, КодОбластиДанных,, ОтменитьДляВсехОбластей);
		Иначе
			Результат = Тарификация.ОсвободитьЛицензиюУникальнойУслуги(ТарифноеОграничение.Поставщик,
				ТарифноеОграничение.Идентификатор,
				ИдентификаторЛицензии,
				ИдентификаторОперации,,, ОтменитьДляВсехОбластей);
		КонецЕсли;
		Если Результат Тогда
			Тарификация.ПодтвердитьОперацию(ИдентификаторОперации);
			Возврат Истина;
		Иначе
			Тарификация.ОтменитьОперацию(ИдентификаторОперации);
			Возврат Ложь;
		КонецЕсли;
	Исключение
		Возврат Ложь;
	КонецПопытки;
КонецФункции

// Возвращает ссылку на личный кабинет абонента
//
// Возвращаемое значение:
//  Строка.
//
Функция СсылкаНаЛичныйКабинетАбонента() Экспорт
	
	СсылкаНаЛичныйКабинет = ИнформационныйЦентрСервер.КонтекстнаяСсылкаПоИдентификатору(НСтр("ru ='ЛичныйКабинет'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		
	Возврат СсылкаНаЛичныйКабинет.Адрес;
КонецФункции

// Выполняет проверку и попытку регистрации на сервере тарификации кассового аппарата.
//
// Параметры:
//  Результат - Булево - флаг успешной проверки и регистрации кассы.
//
Функция ПодключениеКассыПоТарифу(ИдентификаторЛицензии) Экспорт
	
	// Тариф проверям только во Фреше.
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Результат = Истина;
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЛицензии) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТарифноеОграничение = ТарификацияПереопределяемый.ОграничениеКоличествоКассПоТарифу();
	
	ЛицензияИспользуется = ПроверкаИспользованияЛицензииКоличествоКасс(ИдентификаторЛицензии, ТарифноеОграничение);
	
	Если ЛицензияИспользуется = Неопределено Тогда
		Результат = Ложь;
	Иначе
		Если ЛицензияИспользуется Тогда
			Результат = ЛицензияИспользуется;
		Иначе
			Результат = ЗанятьЛицензииКоличествоКасс(ИдентификаторЛицензии, ТарифноеОграничение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет попытку регистрации на сервере тарификации кассового аппарата.
//
// Параметры:
//  Ссылка - СправочникСсылка.КассовыеАппараты - ссылка на кассовый аппарат.
//
// Возвращаемое значение:
//  Структура с ключами:
//    * Результат - Булево - результат выполнения (Истина = лицензия успешно получена).
//    * ДоступноЛицензий - Число - максимально доступное абоненту количество лицензий на указанную услугу.
//    * ЗанятоЛицензий - Число - количество уже полученных (использованных) лицензий на услугу.
//
Функция ЗанятьЛицензииКоличествоКасс(ИдентификаторЛицензии, ТарифноеОграничение = Неопределено)
	
	Ответ = ОтветЗанятияЛицензий();
	
	Если ТарифноеОграничение = Неопределено Тогда
		ТарифноеОграничение = ТарификацияПереопределяемый.ОграничениеКоличествоКассПоТарифу();
	КонецЕсли;
	
	ИдентификаторОперации = Новый УникальныйИдентификатор;
	
	Ответ = Тарификация.ЗанятьЛицензиюУникальнойУслуги(ТарифноеОграничение.Поставщик,
		ТарифноеОграничение.Идентификатор,
		ИдентификаторЛицензии,
		ИдентификаторОперации);
		
	Если Ответ.Результат Тогда
		Попытка
			Тарификация.ПодтвердитьОперацию(ИдентификаторОперации);
			Возврат Истина;
		Исключение
			Тарификация.ОтменитьОперацию(ИдентификаторОперации);
			Возврат Ложь;
		КонецПопытки;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

// Возвращает структуру ответа занятия услуги со значениями по умолчанию.
//
// Возвращаемое значение:
//  Структура - структура ответа.
//
Функция ОтветЗанятияЛицензий()
	
	Ответ = Новый Структура;
	Ответ.Вставить("Результат", Ложь);
	Ответ.Вставить("ДоступноЛицензий", 0);
	Ответ.Вставить("ЗанятоЛицензий", 0);
	
	Возврат Ответ;
КонецФункции

Функция ПроверкаИспользованияЛицензииКоличествоКасс(ИдентификаторЛицензии, ТарифноеОграничение = Неопределено)
	
	ЛицензияИспользуется = Неопределено;
	
	Если ТарифноеОграничение = Неопределено Тогда
		ТарифноеОграничение = ТарификацияПереопределяемый.ОграничениеКоличествоКассПоТарифу();
	КонецЕсли;
	
	ИмяСобытия = Тарификация.ИмяСобытияЖР() + НСтр("ru = 'Проверка наличия лицензии уникальной услуги из приложения'");
	ЗаголовокКомментария = ЗаголовокКомментария(ТарифноеОграничение.Поставщик,
		ТарифноеОграничение.Идентификатор,
		ИдентификаторЛицензии);
	Попытка
		ЛицензияИспользуется = Тарификация.ЗарегистрированаЛицензияУникальнойУслуги(ТарифноеОграничение.Поставщик,
		ТарифноеОграничение.Идентификатор,
		ИдентификаторЛицензии);
	Исключение;
		Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибку(ИмяСобытия, ЗаголовокКомментария, Комментарий);
	КонецПопытки;
	
	Возврат ЛицензияИспользуется;
КонецФункции

#Область РаботаСЖурналомРегистрации

// Записывает ошибку в ЖР при операциях с лицензиями.
//
// Параметры:
//  ИмяСобытия - Строка - имя события ЖР.
//  ЗаголовокКомментария - Строка - заголовок комментария ошибки.
//  Комментарий - Строка - комментарий ошибки.
//
Процедура ЗаписатьОшибку(ИмяСобытия, ЗаголовокКомментария, Комментарий)
	
	ЗаписьЖурналаРегистрации(ИмяСобытия,
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		ЗаголовокКомментария + Символы.ПС + Символы.ПС + Комментарий);
	
КонецПроцедуры

// Заголовок комментария для ЖР.
//
// Параметры:
//  ИдентификаторПоставщика - Строка - идентификатор поставщика.
//  ИдентификаторУслуги - Строка - идентификатор услуги.
//  ИдентификаторЛицензии - Строка - идентификатор лицензии.
//  КоличествоЛицензий - Число - количество занимаемых лицензий.
//  ИдентификаторОперации  - Строка - идентификатор операции.
//  КодОбластиДанных - Число - код области данных.
//
// Возвращаемое значение:
//  строка - заголовок комментария.
//
Функция ЗаголовокКомментария(ИдентификаторПоставщика, ИдентификаторУслуги, ИдентификаторЛицензии = Неопределено, 
	КоличествоЛицензий = 1, ИдентификаторОперации = Неопределено, КодОбластиДанных = Неопределено)
	
	Шаблон = НСтр("ru = 'Идентификатор поставщика: %1
                       |Идентификатор услуги: %2
                       |Идентификатор лицензии: %3
                       |Количество лицензий: %4
                       |Идентификатор операции: %5
                       |Код области данных: %6
                       |
                       |'");
	Возврат СтрШаблон(Шаблон, ИдентификаторПоставщика, ИдентификаторУслуги, ИдентификаторЛицензии, КоличествоЛицензий, ИдентификаторОперации, КодОбластиДанных);
	
КонецФункции

Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ТарификацияПриЗапуске();
	
#Если ВнешнееСоединение Тогда
	Параметры.Вставить(
		"ИспользоватьЛегкиеРозничныеПродажи",
		Ложь);
#Иначе
	Параметры.Вставить(
		"ИспользоватьЛегкиеРозничныеПродажи",
		ИспользоватьЛегкиеРозничныеПродажи());
#КонецЕсли
	
КонецПроцедуры

// Для случая, когда у пользователя используюется тарифная опция "РозничныйАбонент", которая
// может быть включена в любой момент, то необходимо при первом включении показать соответствующий
// рабочий стол и включить соответствующие функциональные опции. 
// 
Функция ТарификацияПриЗапуске() Экспорт
	
	Если ИспользоватьЛегкиеРозничныеПродажи()
		И НЕ Константы.ЛегкиеРозничныеПродажиБылиУстановлены.Получить() Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Константы.ФункциональнаяОпцияЛегкиеРозничныеПродажи.Установить(Истина);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецФункции


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Если база в режиме сервиса и у абонента есть услуга РозначиныйАбонент поставщика УНФ
// тогда разрешено использование режима легкиз розничных продаж. 
Функция ИспользоватьЛегкиеРозничныеПродажи()
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат Тарификация.ЗарегистрированаЛицензияБезлимитнойУслуги("1С_УНФ", "РозничныйАбонент");
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

