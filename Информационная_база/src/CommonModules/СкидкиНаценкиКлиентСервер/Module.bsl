
//Рассчитывает сумму и процент ручной скидки (без учета автоматической скидки) для документа
//Процент скидки может быть разным для разных строк, тогда общий процент ручной скидки рассчитывается от суммы документа
//
// Параметры:
//  Форма             - УправляемаяФорма
//  ИмяТабличнойЧасти - Строка
//  ПараметрыОтбора   - Соответствие - Ключ соответствует имени колонки, а значение — допустимому значению обрабатываемой строки.
//
Процедура РассчитатьСуммуИПроцентСкидки(Форма, ИмяТабличнойЧасти = "Запасы", ПараметрыОтбора = Неопределено) Экспорт
	
	Если ПараметрыОтбора = Неопределено Тогда
		Форма.СкидкаСумма = Форма.Объект[ИмяТабличнойЧасти].Итог("СуммаСкидкиНаценки");
		ОбщаяСуммаБезСкидок = Форма.Объект[ИмяТабличнойЧасти].Итог("Сумма") + Форма.Объект[ИмяТабличнойЧасти].Итог("СуммаСкидкиНаценки");
		Если Форма.Объект[ИмяТабличнойЧасти].Количество()>0 Тогда
			Если Форма.Объект[ИмяТабличнойЧасти][0].Свойство("СуммаАвтоматическойСкидки") Тогда
				ОбщаяСуммаБезСкидок = ОбщаяСуммаБезСкидок + Форма.Объект[ИмяТабличнойЧасти].Итог("СуммаАвтоматическойСкидки");
			КонецЕсли;
		КонецЕсли;
		Форма.СкидкаПроцент = ?(ОбщаяСуммаБезСкидок=0, 0, Форма.СкидкаСумма / ОбщаяСуммаБезСкидок * 100);
	Иначе
		ОбщаяСуммаРучнойСкидки	= 0;
		ОбщаяСуммаБезСкидок		= 0;
		Для каждого стр Из Форма.Объект[ИмяТабличнойЧасти] Цикл
			
			Если ПараметрыОтбора <> Неопределено Тогда
				ЭтоПодходящаяСтрока = УправлениеНебольшойФирмойКлиентСервер.ОбъектСоответствуетПараметрамОтбора(стр, ПараметрыОтбора);
				Если НЕ ЭтоПодходящаяСтрока Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			ОбщаяСуммаБезСкидок = ОбщаяСуммаБезСкидок + стр.Цена * стр.Количество;
			Если стр.ПроцентСкидкиНаценки = 0 Тогда
				Продолжить;
			ИначеЕсли стр.Свойство("СуммаАвтоматическойСкидки") Тогда
				ОбщаяСуммаРучнойСкидки = ОбщаяСуммаРучнойСкидки + стр.Цена * стр.Количество - стр.Сумма - стр.СуммаАвтоматическойСкидки;
			Иначе
				ОбщаяСуммаРучнойСкидки = ОбщаяСуммаРучнойСкидки + стр.Цена * стр.Количество - стр.Сумма;
			КонецЕсли; 
			
		КонецЦикла;
		
		Форма.СкидкаСумма = ОбщаяСуммаРучнойСкидки;
		Форма.СкидкаПроцент = ?(ОбщаяСуммаБезСкидок=0, 0, Форма.СкидкаСумма / ОбщаяСуммаБезСкидок * 100);
	КонецЕсли; 
	
КонецПроцедуры
