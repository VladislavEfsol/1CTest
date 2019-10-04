#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		Элементы.ПараметрыДоступаВИнтернет.Видимость = Истина;
	Иначе
		Элементы.ПараметрыДоступаВИнтернет.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Объект.Ссылка, "password", Истина);
		Подпись = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Объект.Ссылка, "signature", Истина);
		ЕстьЗарегистрированныеКассы = ОбменСКассовымСерверомШтрихМ.ЕстьПодключенныеКассы();
	Иначе
		Объект.Код = "002";
		Объект.Наименование =
			НСтр("ru='Настройка обмена с кассовым сервером Штрих-М'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		Объект.СтрокаСоединенияИнформационнойБазы = СтрокаСоединенияИнформационнойБазы();
		Объект.МаксимальноеКоличествоДокументов = 10000;
		Объект.ВыполнятьОбменССерверомШтрихМ = Ложь;
	КонецЕсли;
	
	
	ПриИзмененииПодписи();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Объект.Ссылка, Пароль, "password");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Объект.Ссылка, Подпись, "signature");
	Модифицированность = Ложь;
	ОбменСКассовымСерверомШтрихМ.УстановитьИспользованиеРегламентногоЗадания();
	
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийШапкиФормы

&НаКлиенте
Процедура АдресСервераПриИзменении(Элемент)
	
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторНаСервереШтрихМПриИзменении(Элемент)
	
	УстановитьДоступность();
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьПодпись(Команда)
	
	ПараметрыФормы = Новый Структура("ИдентификаторСервиса", Объект.ИдентификаторНаСервереШтрихМ);
	ПараметрыФормы.Вставить("ТекущаяПодпись", Подпись);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВводаКлючевогоСлова", ЭтотОбъект);
	ОткрытьФорму("ПланОбмена.ОбменСКассовымСерверомШтрихМ.Форма.АутентификацияНаСервереШтрихМ",
		ПараметрыФормы,,,,, ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИдентификатор(Команда)
	
	ЗаголовокВопроса = НСтр("ru = 'Очистка идентификатора подсистемы'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	ТекстВопроса = НСтр("ru = 'Очистка идентификатора подсистемы приведет
		|к регистрации новой подсистемы на сервере Штрих-М.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Если ЕстьЗарегистрированныеКассы Тогда
		ТекстВопроса = ТекстВопроса + НСтр("ru = 'Также это приведет к перерегистрации кассовых аппаратов,
		|товаров и документов в новую подсистему из существующей.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	КонецЕсли;
	ТекстВопроса = ТекстВопроса + НСтр("ru = 'Выполнить очистку идентификатора подсистемы (agent_node_id)?'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(КодВозвратаДиалога.Да,
		НСтр("ru = 'Выполнить'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	СписокКнопок.Добавить(КодВозвратаДиалога.Отмена,
		НСтр("ru = 'Отменить'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОтветаНаВопросОчистить", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок,, КодВозвратаДиалога.Отмена, ЗаголовокВопроса);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыДоступаВИнтернет(Команда)
	
	ОбменДаннымиКлиент.ОткрытьФормуПараметровПроксиСервера();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПароль(Команда)
	
	Элементы.Пароль.РежимПароля = НЕ Элементы.Пароль.РежимПароля;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПодпись(Команда)
	
	Элементы.Подпись.РежимПароля = НЕ Элементы.Подпись.РежимПароля;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	
	Настройки = Новый Структура;
	Настройки.Вставить("АдресСервера", Объект.АдресСервера);
	Настройки.Вставить("ИмяПользователя", Объект.ИмяПользователя);
	Настройки.Вставить("Пароль", Пароль);
	
	Соединение = HTTPСоединениеНаСевере(Настройки);

	Если Соединение.HTTPСоединение = Неопределено Тогда
		СтрокаПредупреждения = Соединение.СообщениеОбОшибке;
	Иначе
		СтрокаПредупреждения = НСтр("ru = 'Соединенение успешно установлено.'",
			ОбщегоназначенияКлиентСервер.КодОсновногоЯзыка());
	КонецЕсли;
	ЗаголовокПредупреждения = НСтр("ru = 'Проверка подключения'",
			ОбщегоназначенияКлиентСервер.КодОсновногоЯзыка());
	ПоказатьПредупреждение(, СтрокаПредупреждения,, ЗаголовокПредупреждения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВводаКлючевогоСлова(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат = Неопределено И ЗначениеЗаполнено(Результат) И НЕ Подпись = Результат Тогда
		Подпись = Результат;
		Модифицированность = Истина;
		ПриИзмененииПодписи();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОчистить(Ответ, ДополнительныеПараметры) Экспорт
	
	Если НЕ Ответ = Неопределено И Ответ = КодВозвратаДиалога.Да Тогда
		Объект.ИдентификаторОбластиНаСервереШтрихМ = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПодписи()
	
	Если ЗначениеЗаполнено(Подпись) Тогда
		Элементы.ИзменитьПодпись.Заголовок = НСтр("ru='Изменить'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Иначе
		Элементы.ИзменитьПодпись.Заголовок = НСтр("ru='Заполнить'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	КонецЕсли;
	
	УстановитьДоступность();
КонецПроцедуры

&НаСервере
Функция HTTPСоединениеНаСевере(Настройки)
	Соединение = ОбменСКассовымСерверомШтрихМ.HTTPСоединение(Настройки);
	Если НЕ Соединение.HTTPСоединение = Неопределено Тогда
		Соединение.HTTPСоединение = Истина;
	КонецЕсли;
	
	Возврат Соединение;
КонецФункции

&НаСервере
Процедура УстановитьДоступность()
	
	ВозможноВыполнятьОбмен = ЗначениеЗаполнено(Объект.АдресСервера)
		И ЗначениеЗаполнено(Объект.ИдентификаторНаСервереШтрихМ)
		И ЗначениеЗаполнено(Подпись);
	
	Если НЕ ВозможноВыполнятьОбмен И Объект.ВыполнятьОбменССерверомШтрихМ Тогда
		Объект.ВыполнятьОбменССерверомШтрихМ = Ложь;
	КонецЕсли;
	
	Элементы.ВыполнятьОбменССерверомШтрихМ.Доступность = ВозможноВыполнятьОбмен;
	Элементы.ИзменитьПодпись.Доступность = ЗначениеЗаполнено(Объект.ИдентификаторНаСервереШтрихМ);
	
	Элементы.ПоказатьПароль.Доступность = ЗначениеЗаполнено(Пароль);
	Элементы.ПоказатьПодпись.Доступность = ЗначениеЗаполнено(Подпись);
	Элементы.ОчиститьИдентификатор.Доступность = ЗначениеЗаполнено(Объект.ИдентификаторОбластиНаСервереШтрихМ);
КонецПроцедуры

#КонецОбласти
