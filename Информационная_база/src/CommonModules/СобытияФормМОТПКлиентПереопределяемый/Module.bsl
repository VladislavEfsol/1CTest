#Область СлужебныйПрограмныйИнтерфейс

#Область Номенклатурa

// Выполняется при начале выбора номенклатуры. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец     - УправляемаяФорма            - Форма владелец.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится выбор.
Процедура ПриНачалеВыбораНоменклатуры(Владелец, ДанныеСтроки) Экспорт
	
	
КонецПроцедуры

// Выполняется при создании номенклатуры из формы МОТП. Требуется определить и открыть форму (диалога) создания номенклатуры.
//
// Параметры:
//  Владелец     - УправляемаяФорма            - Форма владелец.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится создание.
Процедура ПриСозданииНоменклатуры(Владелец, ДанныеСтроки) Экспорт
	
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора номенклатуры.
//
// Параметры:
//  Форма                  - УправляемаяФорма              - Форма для которой требуется обработать событие выбора.
//  ВыбранноеЗначение      - ОпределяемыйТип..Номенклатура - Результат выбора.
//  ИсточникВыбора         - УправляемаяФорма              - Форма, в которой произведен выбор.
//  ПараметрыУказанияСерий - (См. ПроверкаИПодборПродукцииМОТП.ПараметрыУказанияСерий).
//  КэшированныеЗначения   - Структура - Сохраненные значения параметров, используемых при обработке.
Процедура ОбработкаВыбораНоменклатуры(Форма, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий, КэшированныеЗначения) Экспорт
	
	
КонецПроцедуры

// Выполняет действия при изменении номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма                  - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ХарактеристикиНоменклатуры

// Выполняется при начале выбора характеристики. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец     - УправляемаяФорма            - форма, в которой вызывается команда выбора характеристики.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится выбор.
Процедура ПриНачалеВыбораХарактеристики(Владелец, ДанныеСтроки) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Выполняется при создании характеристики из формы МОТП. Требуется пепеопределить и открыть форму (диалога)
// создания характеристики при необходимости.
//
// Параметры:
//  Владелец             - УправляемаяФорма            - Форма владелец.
//  ДанныеСтроки         - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится создание.
//  Элемент              - ПолеВвода                   - элемент в котором создается характеристика.
//  СтандартнаяОбработка - Булево                      - Признак стандартной обработки.
Процедура ПриСозданииХарактеристики(Владелец, ДанныеСтроки, Элемент, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора характеристики.
//
// Параметры:
//  Форма                  - УправляемаяФорма - Форма для которой требуется обработать событие выбора.
//  ВыбранноеЗначение      - ОпределяемыйТип.ХарактеристикаНоменклатуры - результат выбора.
//  ИсточникВыбора         - УправляемаяФорма - Форма, в которой произведен выбор.
//  КэшированныеЗначения   - Структура - Сохраненные значения параметров, используемых при обработке.
Процедура ОбработкаВыбораХарактеристики(Форма, ВыбранноеЗначение, ИсточникВыбора, КэшированныеЗначения) Экспорт
	
	
КонецПроцедуры

// Выполняет действия при изменении характеристики номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма                - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
Процедура ПриИзмененииХарактеристики(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СерииНоменклатуры

// Выполняет действия при изменении серии номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииСерии(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий) Экспорт
	
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора серии.
// 
// Параметры:
//  Форма                  - УправляемаяФорма - Форма для которой требуется обработать событие выбора.
//  ВыбранноеЗначение      - ОпределяемыйТип.СерияНоменклатуры - результат выбора.
//  ИсточникВыбора         - УправляемаяФорма - Форма, в которой произведен выбор.
//  ПараметрыУказанияСерий - (См. ПроверкаИПодборПродукцииМОТП.ПараметрыУказанияСерий).
Процедура ОбработкаВыбораСерии(Форма, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область Количество

// Выполняет действия при изменении подобранного количества в строке таблицы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
