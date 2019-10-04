#Область ПрограммныйИнтерфейс

// Возвращает цену товара поставщика.
//
// Возвращаемое значение:
//  Число
//
Функция ПолучитьЦенуТовара(Период = '00010101', Товар) Экспорт
	
	ОтборПоНоменклатуре = Новый Структура("Товар", Товар);
	
	Таблица = СрезПоследних(Период, ОтборПоНоменклатуре);
	Таблица.Сортировать("Период Убыв");
	Если Таблица.Количество() > 0 тогда
		Возврат Таблица[0].Цена;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции // ПолучитьЦенуТовара()

// Возвращает цену товара поставщика.
//
// Возвращаемое значение:
//  Число
//
Функция ПолучитьЦенуТовараПоставщика(Товар, Поставщик) Экспорт
	
	Отбор = Новый Структура("Товар, Поставщик", Товар, Поставщик);
	
	Таблица = СрезПоследних(, Отбор);
	Если Таблица.Количество() > 0 тогда
		Возврат Таблица[0].Цена;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции // ПолучитьЦенуТовараПоставщика()

// Возвращает последнюю цену закупки товара.
//
// Возвращаемое значение:
//  Число
//
Функция ПолучитьПоследнююЦенуЗакупки(Товар) Экспорт
	
	Отбор = Новый Структура("Товар", Товар);
	
	Таблица = СрезПоследних(, Отбор);
	Таблица.Сортировать("Период Убыв");
	Если Таблица.Количество() > 0 тогда
		Возврат Таблица[0].Цена;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции // ПолучитьПоследнююЦенуЗакупки()


#КонецОбласти