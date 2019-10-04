#Область ВызовыМодулейГИСМ

// Открывает форму создания нового контрагента
//
// Параметры:
//   ДанныеКонтрагента - Структура - Содержит поля для заполнения данных нового контрагента.
//   Форма             - УправляемаяФорма - форма-владелец.
//
Процедура ОткрытьФормуСозданияНовогоКонтрагента(ДанныеКонтрагента, Форма) Экспорт
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта");
	
КонецПроцедуры

// Обработчик выбора нового контрагента
//
// Параметры:
//   ВыбранноеЗначение - Стандартный параметр обработчика формы ОбработкаВыбора
//   ИсточникВыбора    - Стандартный параметр обработчика формы ОбработкаВыбора
//   Объект            - ДокументОбъект - Документ, в форме которого обрабатывается выбор.
//
Процедура ОбработатьВыборНовогоКонтрагента(ВыбранноеЗначение, ИсточникВыбора, Объект) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Возвращает через параметр структуру параметров, необходимых для передачи в форму списка документов
// Отчеты о розничных продажах.
//
// Параметры:
//   Параметры - Структура - поля структуры
//		ИмяФормы - Полный путь к форме списка отчетов о розничных продажах
//		ОткрытьРаспоряжения - Булево, нужно ли открывать закладку Распоряжения на форме, если есть
//		ИмяПоляОтветственный - Имя реквизита формы, соответствующего фильтру по ответственному
//		ИмяПоляОрганизация - Имя реквизита формы, соответствующего фильтру по организации.
//
Процедура ПараметрыОткрытияСпискаОтчетыОРозничныхПродажах(Параметры) Экспорт
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("ИмяФормы", "Документ.ОтчетОРозничныхПродажах.Форма.ФормаСпискаГИСМ");
	Параметры.Вставить("ОткрытьРаспоряжения", Ложь);
	Параметры.Вставить("ИмяПоляОтветственный", "Ответственный");
	Параметры.Вставить("ИмяПоляОрганизация", "Организация");
	
КонецПроцедуры

// Возвращает через параметр структуру параметров, необходимых для передачи в форму списка документов
// Возвраты товаров от розничных клиентов.
//
// Параметры:
//   Параметры - Структура - поля структуры
//		ИмяФормы - Полный путь к форме списка отчетов о розничных продажах
//		ДальнейшееДействиеГИСМ - ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные")
//		ОткрытьРаспоряжения - Булево, нужно ли открывать закладку Распоряжения на форме, если есть
//		ИмяПоляОтветственный - Имя реквизита формы, соответствующего фильтру по ответственному
//		ИмяПоляОрганизация - Имя реквизита формы, соответствующего фильтру по организации.
//
Процедура ПараметрыОткрытияСпискаВозвратыТоваровОтРозничныхКлиентов(Параметры) Экспорт
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("ИмяФормы", "Документ.ПриходнаяНакладная.Форма.ФормаСпискаДокументовГИСМ");
	Параметры.Вставить("ДальнейшееДействиеГИСМ", ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные"));
	Параметры.Вставить("ОткрытьРаспоряжения", Ложь);
	Параметры.Вставить("ИмяПоляОтветственный", "Ответственный");
	Параметры.Вставить("ИмяПоляОрганизация", "Организация");
	
КонецПроцедуры

// Обработчик ПриИзменении таблицы ЗаказанныеКиЗ документа ЗаявкаНаВыпускКиЗ
//
// Параметры:
//   Форма                 - УправляемаяФорма - Форма документа ЗаявкаНаВыпускКиЗ
//   КэшированныеЗначения  - Структура -  используется механизмом обработки изменения реквизитов ТЧ
//   Элемент               - Стандартный параметр обработчика таблицы формы ПриИзменении.
//
Процедура ЗаявкаНаВыпускКиЗЗаказанныеКиЗПриИзменении(Форма, КэшированныеЗначения, Элемент) Экспорт
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Номенклатура) Тогда
			Элемент.ТекущиеДанные.ХарактеристикиИспользуются = ИнтеграцияГИСМУНФВызовСервера.ЗначениеРеквизитаОбъекта(
															   Элемент.ТекущиеДанные.Номенклатура,
															   "ИспользоватьХарактеристики");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Предоставляет возможность открыть произвольную форму, в которой выведен список документов.
//
// Параметры:
//   СписокДокументов - СписокЗначений - Список документов, которые необходимо показать в форме
//   Заголовок        - Строка - Заголовок формы.
//
Процедура ОткрытьФормуСпискаДокументов(СписокДокументов, Заголовок) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Обработчик ПриИзменении поля НоменклатураКиЗ таблицы Товары 
// 
// Параметры:
//   ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Текущие данные таблицы, в которой изменяется поле
//   КэшированныеЗначения - Структура -  используется механизмом обработки изменения реквизитов ТЧ.
//
Процедура ТоварыУведомлениеОбИмпортеНоменклатураКиЗПриИзменении(ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Открывает форму подбора номенклатуры КиЗ
// 
// Параметры:
//   Форма - УправляемаяФорма - Владелец открываемой формы.
//
Процедура ОткрытьПодборЗаказываемыхКиЗ(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Проверяет, что форма является формой подбора товаров в документ
// Используется в обработчике формы ОбработкаВыбора.
// 
// Параметры:
//   ИсточникВыбора - Строка - имя формы источника выбора.
//   Результат      - Булево - Истина, если форма является формой подбора.
//
Процедура ИсточникВыбораЭтоФормаПодбора(ИсточникВыбора, Результат) Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область Панель1СМаркировка

// Открывает форму списка видов номенклатуры.
//
Процедура ОткрытьФормуСпискаВидыНоменклатуры(ВладелецФормы) Экспорт
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаСписка");
	
КонецПроцедуры

// Открывает форму списка номенклатуры.
//
Процедура ОткрытьФормуСпискаНоменклатуры(ВладелецФормы) Экспорт
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаСписка");
	
КонецПроцедуры

// Открывает форму списка классификатора ТНВЭД.
//
Процедура ОткрытьФормуСпискаКлассификатораТНВЭД(ВладелецФормы) Экспорт
	
	ОткрытьФорму("Справочник.КлассификаторТНВЭД.ФормаСписка");
	
КонецПроцедуры

#Конецобласти

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура ТекстЗаявкаНаВыпускКиЗОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПротоколОбмена" Тогда
		
		ИнтеграцияГИСМКлиент.ОткрытьПротоколОбмена(Форма.Объект.Ссылка, Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СоздатьЗаявкуНаВыпускКиЗ" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Форма.Объект.Ссылка);
		ОткрытьФорму("Документ.ЗаявкаНаВыпускКиЗГИСМ.Форма.ФормаДокумента", ПараметрыФормы, Форма);
		
	КонецЕсли;
	
КонецПроцедуры

// См. описание процедуры ИнтеграцияГИСМКлиентПереопределяемый.ТекстУведомленияОбИмпортеВвозеИзЕАЭСОбработкаНавигационнойСсылки
//
Процедура ТекстУведомленияОбИмпортеВвозеИзЕАЭСОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПротоколОбмена" Тогда
		
		ИнтеграцияГИСМКлиент.ОткрытьПротоколОбмена(Форма.Объект.Ссылка, Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СоздатьУведомлениеГИСМ" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Форма.Объект.Ссылка);
		
		ОткрытьФорму("Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Форма.ФормаДокумента", ПараметрыФормы, Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СоздатьУведомлениеГИСМЕАЭС" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Форма.Объект.Ссылка);
		
		ОткрытьФорму("Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Форма.ФормаДокумента", ПараметрыФормы, Форма);
		
	КонецЕсли;

КонецПроцедуры

// См. описание процедуры ИнтеграцияГИСМКлиентПереопределяемый.ТекстУведомленияОСписанииКиЗГИСМОбработкаНавигационнойСсылки
//
Процедура ТекстУведомленияОСписанииКиЗГИСМОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПротоколОбмена" Тогда
		
		ИнтеграцияГИСМКлиент.ОткрытьПротоколОбмена(Форма.Объект.Ссылка, Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СоздатьУведомлениеГИСМ" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Форма.Объект.Ссылка);
		ОткрытьФорму("Документ.УведомлениеОСписанииКиЗГИСМ.Форма.ФормаДокумента", ПараметрыФормы, Форма);
		
	КонецЕсли;

КонецПроцедуры

// См. описание процедуры ИнтеграцияГИСМКлиентПереопределяемый.ТекстУведомленияОбОтгрузкеГИСМОбработкаНавигационнойСсылки
//
Процедура ТекстУведомленияОбОтгрузкеГИСМОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПротоколОбмена" Тогда
		
		ИнтеграцияГИСМКлиент.ОткрытьПротоколОбмена(Форма.Объект.Ссылка, Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СоздатьУведомлениеГИСМ" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Форма.Объект.Ссылка);
		ОткрытьФорму("Документ.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ.Форма.ФормаДокумента", ПараметрыФормы, Форма);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область РаботаСоСканеромШтрихкодов

Функция ПреобразоватьДанныеСоСканераВМассив(Параметр) Экспорт
	
	
	Данные = Новый Массив;
	Данные.Добавить(ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
	
	Возврат Данные;
	
КонецФункции

Функция ПреобразоватьДанныеСоСканераВСтруктуру(Параметр) Экспорт
	
	
	Если Параметр[1] = Неопределено Тогда
		Данные = Новый Структура("Штрихкод, Количество", Параметр[0], 1); 	 // Достаем штрихкод из основных данных
	Иначе
		Данные = Новый Структура("Штрихкод, Количество", Параметр[1][1], 1); // Достаем штрихкод из дополнительных данных
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

#КонецОбласти