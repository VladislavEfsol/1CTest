
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Загружаем каталог.
	СтруктураКаталога = "";
	Если Параметры.Свойство("СтруктураКаталога", СтруктураКаталога) Тогда
		
		НастройкиОбмена = Новый Структура;
		НастройкиОбмена.Вставить("ПрофильНастроекЭДО",
			Новый Структура("СпособОбменаЭД", Перечисления.СпособыОбменаЭД.БыстрыйОбмен));
		НастройкиОбмена.Вставить("Организация", СтруктураКаталога.Организация);
		
		ИД = "";
		ОбменСКонтрагентамиПереопределяемый.ПолучитьИДКонтрагента(СтруктураКаталога.Организация, "Организация", ИД);
		НастройкиОбмена.Вставить("ИдентификаторОрганизации", ИД);
		
		ПараметрыФормирования = ОбменСКонтрагентамиСлужебный.НовыеПараметрыФормированияЭлектронногоДокумента();
		ПараметрыФормирования.НастройкиОбмена = НастройкиОбмена;
		
		СтруктураВозврата = ОбменСКонтрагентамиВнутренний.СформироватьКаталогНоменклатуры(ПараметрыФормирования, СтруктураКаталога);
		Если Не ЗначениеЗаполнено(СтруктураВозврата) Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПолноеИмяФайла = СтруктураВозврата.ПолноеИмяФайла;
		НоваяСтрока.НаименованиеФайла = СтруктураВозврата.Наименование;
		
		Если СтруктураВозврата.Свойство("МассивФайлов") И СтруктураВозврата.МассивФайлов.Количество() > 0 Тогда
			АрхивДополнительныхФайлов = ОбменСКонтрагентамиСлужебный.АрхивДополнительныхФайлов(СтруктураВозврата.МассивФайлов);
			СтруктураВозврата.Вставить("Картинки", АрхивДополнительныхФайлов);
		КонецЕсли;
		
		ДвоичныеДанныеПакета = Обработки.ОбменСКонтрагентами.СформироватьДвоичныеДанныеПакета(СтруктураВозврата);
		НоваяСтрока.АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанныеПакета, УникальныйИдентификатор);
		
		ИзменитьВидимостьДоступностьПриСозданииНаСервере();
		
	КонецЕсли;
	
	// Загружаем документы.
	МассивСсылокНаОбъект = Новый Массив;
	Если Параметры.Свойство("СтруктураЭД", МассивСсылокНаОбъект) Тогда
		Если МассивСсылокНаОбъект.Количество() = 0 Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("МассивСсылокНаОбъект", МассивСсылокНаОбъект);
		ПараметрыЗадания.Вставить("ОтправкаЧерезБС", Ложь);
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.ОбменСКонтрагентами.ПодготовитьДанныеДляЗаполненияДокументов(ПараметрыЗадания, АдресХранилища);
		
		Если АдресХранилища  = "" Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ЗагрузитьПодготовленныеДанныеЭД();
		
	КонецЕсли;
	
	СтруктураЭД= Неопределено;
	Если Параметры.Свойство("ВыгрузитьВФайл", СтруктураЭД) И ЗначениеЗаполнено(СтруктураЭД) Тогда
		
		СтруктураВозврата = ОбменСКонтрагентамиВнутренний.ФайлБыстрогоОбмена(СтруктураЭД);
		
		Если Не СтруктураВозврата = Неопределено Тогда
			НоваяСтрока = ТаблицаДанных.Добавить();
			НоваяСтрока.ПолноеИмяФайла = СтруктураВозврата.ПолноеИмяФайла;
			НоваяСтрока.НаименованиеФайла = СтруктураВозврата.Наименование;
			
			ДвоичныеДанныеПакета = Обработки.ОбменСКонтрагентами.СформироватьДвоичныеДанныеПакета(СтруктураВозврата);
			НоваяСтрока.АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанныеПакета, УникальныйИдентификатор);
			
			ИзменитьВидимостьДоступностьПриСозданииНаСервере();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(ТаблицаДанных) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособВыгрузкиПриИзменении(Элемент)
	
	ИзменитьСпособВыгрузки();
	ИзменитьВидимостьДоступность();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	Если ТаблицаДанных.Количество() > 1 Тогда
		МассивСтруктур = Новый Массив;
		Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("АдресХранилища", СтрокаДанных.АдресХранилища);
			СтруктураПараметров.Вставить("ФайлАрхива", Истина);
			СтруктураПараметров.Вставить("НаименованиеФайла", СтрокаДанных.НаименованиеФайла);
			СтруктураПараметров.Вставить("НаправлениеЭД", СтрокаДанных.НаправлениеЭД);
			СтруктураПараметров.Вставить("Контрагент", СтрокаДанных.Контрагент);
			СтруктураПараметров.Вставить("УникальныйИдентификатор", СтрокаДанных.УникальныйИдентификатор);
			СтруктураПараметров.Вставить("ВладелецЭД", СтрокаДанных.ВладелецЭД);
			
			МассивСтруктур.Добавить(СтруктураПараметров);
		КонецЦикла;
		ФормаПросмотраЭД = ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.СписокВыгружаемыхЭлектронныхДокументов",
			Новый Структура("СтруктураЭД", МассивСтруктур), ЭтотОбъект);
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ВывестиЭДНаПросмотр(ТаблицаДанных[0]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	ОчиститьСообщения();
	
	ТекстСообщения = "";
	Отказ = ВыгрузитьЭД(ТекстСообщения);
	
	Если Отказ Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьВидимостьДоступность()
	
	ВыгрузкаВЭП = (СпособВыгрузки = "ЧерезЭлектроннуюПочту");
	Элементы.СтраницыПолучателей.Доступность = ВыгрузкаВЭП ИЛИ (Элементы.СтраницыПолучателей.ТекущаяСтраница = Элементы.НетДоступа);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьПриСозданииНаСервере()
	
	Текст = НСтр("ru = 'Выгрузка документов в файл'");
	ТекстГиперссылки = НСтр("ru = 'Документы не найдены.'");
	Если ТаблицаДанных.Количество() > 1 Тогда
		ТекстГиперссылки = НСтр("ru = 'Открыть список электронных документов (%1)'");
		ТекстГиперссылки = СтрЗаменить(ТекстГиперссылки, "%1", ТаблицаДанных.Количество());
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ТекстГиперссылки = НСтр("ru = 'Электронный документ: %1'");
		ТекстГиперссылки = СтрЗаменить(ТекстГиперссылки, "%1", ТаблицаДанных[0].НаименованиеФайла);
	КонецЕсли;
	Элементы.ПредварительныйПросмотрДокумента.Заголовок = ТекстГиперссылки;
	Заголовок = Текст;
	СпособВыгрузки = "ЧерезЭлектроннуюПочту";
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		СпособВыгрузки = "ЧерезКаталог";
		Элементы.СтраницыПолучателей.ТекущаяСтраница = Элементы.НетДоступа;
		Элементы.СпособВыгрузки.Доступность = Ложь;
	Иначе
		ИзменитьСпособВыгрузки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиЭДНаПросмотр(СтрокаДанных)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("АдресХранилища");
	СтруктураПараметров.Вставить("ФайлАрхива", Истина);
	СтруктураПараметров.Вставить("НаименованиеФайла");
	СтруктураПараметров.Вставить("НаправлениеЭД");
	СтруктураПараметров.Вставить("Контрагент");
	СтруктураПараметров.Вставить("УникальныйИдентификатор");
	СтруктураПараметров.Вставить("ВладелецЭД");

	ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтрокаДанных);
	ФормаПросмотраЭД = ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.ЗагрузкаПросмотрЭлектронногоДокумента",
		Новый Структура("СтруктураЭД", СтруктураПараметров), ЭтотОбъект, СтруктураПараметров.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьУчетнуюЗапись()
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	НЕ УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления
	|	И УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки";
	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Количество() = 1 Тогда
		Результат.Следующий();
		Возврат Результат.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка();

КонецФункции

&НаКлиенте
Функция ВыгрузитьЭД(ТекстСообщения)
	
	Отказ = Ложь;
	Если НЕ ЗначениеЗаполнено(СпособВыгрузки) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо указать способ выгрузки.'");
		Отказ = Истина;
	КонецЕсли;
	Если СпособВыгрузки = "ЧерезЭлектроннуюПочту"
		И НЕ ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
			+ НСтр("ru = 'Необходимо указать учетную запись.'");
		Отказ = Истина;
	КонецЕсли;
	Если НЕ Отказ Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("СпособВыгрузки",  СпособВыгрузки);
		СтруктураПараметров.Вставить("ПутьККаталогу");
		СтруктураПараметров.Вставить("УчетнаяЗапись",   УчетнаяЗапись);
		СтруктураПараметров.Вставить("АдресПолучателя", АдресПолучателя);
		
		МассивСтруктур = Новый Массив;
		
		Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
			СтруктураОбмена = Новый Структура;

			СтруктураОбмена.Вставить("НаименованиеФайла", СтрокаДанных.НаименованиеФайла);
			СтруктураОбмена.Вставить("НаправлениеЭД",     СтрокаДанных.НаправлениеЭД);
			СтруктураОбмена.Вставить("Контрагент",        СтрокаДанных.Контрагент);
			СтруктураОбмена.Вставить("УникальныйИдентификатор", СтрокаДанных.УникальныйИдентификатор);
			СтруктураОбмена.Вставить("ВладелецЭД",        СтрокаДанных.ВладелецЭД);
			СтруктураОбмена.Вставить("АдресХранилища",    СтрокаДанных.АдресХранилища);
			
			МассивСтруктур.Добавить(СтруктураОбмена);
		КонецЦикла;
		
		БыстрыйОбменВыгрузитьЭД(МассивСтруктур, СтруктураПараметров);
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

&НаСервере
Процедура ИзменитьСпособВыгрузки()
	
	Если СпособВыгрузки = Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту Тогда
		Если ЗначениеЗаполнено(Контрагент) И Не ЗначениеЗаполнено(АдресПолучателя) Тогда
			АдресПолучателя = ""; 
			ОбменСКонтрагентамиПереопределяемый.АдресЭлектроннойПочтыКонтрагента(Контрагент, АдресПолучателя);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
			УчетнаяЗапись = ПолучитьУчетнуюЗапись();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйОбменВыгрузитьЭД(МассивСтруктурОбмена, СтруктураПараметров)
	
	Перем ПутьККаталогу;
	
	Если СтруктураПараметров.СпособВыгрузки = "ЧерезКаталог" Тогда
		ДополнительныеПараметры = Новый Структура("МассивСтруктурОбмена", МассивСтруктурОбмена);
		Оповещение = Новый ОписаниеОповещения("БыстрыйОбменВыгрузитьЭДЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстСообщения = НСтр("ru = 'Для сохранения документа необходимо установить расширение работы с файлами.'");
		ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстСообщения);
	Иначе
		ПараметрыФормы = Новый Структура;
		Если МассивСтруктурОбмена.Количество() > 1 Тогда
			ТемаПисьма = НСтр("ru = 'Пакеты электронных документов'");
		Иначе
			ТемаПисьма = НСтр("ru = 'Пакет электронного документа:'") + " " + МассивСтруктурОбмена[0].НаименованиеФайла;
		КонецЕсли;
		ПараметрыФормы.Вставить("Тема", ТемаПисьма);
		ПараметрыФормы.Вставить("УчетнаяЗапись", СтруктураПараметров.УчетнаяЗапись);
		ПараметрыФормы.Вставить("Получатель", СтруктураПараметров.АдресПолучателя);
		
		Вложения = Новый Массив;
		Для Каждого СтруктураОбмена Из МассивСтруктурОбмена Цикл
			ДанныеВложения = Новый Структура();
			ДанныеВложения.Вставить("Представление", СтруктураОбмена.НаименованиеФайла + ".zip");
			ДанныеВложения.Вставить("АдресВоВременномХранилище", СтруктураОбмена.АдресХранилища);
			Вложения.Добавить(ДанныеВложения);
		КонецЦикла;
		ПараметрыФормы.Вставить("Вложения", Вложения);
		Форма = ОткрытьФорму("ОбщаяФорма.ОтправкаСообщения", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйОбменВыгрузитьЭДЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеПодключено Тогда
		МассивФайлов = Новый Массив;
		Для Каждого СтруктураОбмена Из ДополнительныеПараметры.МассивСтруктурОбмена Цикл
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
				СтруктураОбмена.НаименованиеФайла + ".zip", СтруктураОбмена.АдресХранилища);
			МассивФайлов.Добавить(ОписаниеФайла);
		КонецЦикла;
		Если МассивФайлов.Количество() Тогда
			ПустойОбработчик = Новый ОписаниеОповещения;
			НачатьПолучениеФайлов(ПустойОбработчик, МассивФайлов);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеЭД()
	
	ТаблицаЭД = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если НЕ ЗначениеЗаполнено(ТаблицаЭД) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Строка Из ТаблицаЭД Цикл
		Строка.АдресХранилища = ПоместитьВоВременноеХранилище(Строка.ДвоичныеДанныеПакета, УникальныйИдентификатор);
	КонецЦикла;
	
	ТаблицаДанных.Загрузить(ТаблицаЭД);
	
	ИзменитьВидимостьДоступностьПриСозданииНаСервере();
	
КонецПроцедуры

#КонецОбласти
