Процедура СписокЗаказовОбработкаОповещенияФрагмент(Форма, ИмяСобытия, ИмяСписка = "Список") Экспорт

	Если ИмяСобытия = "Запись_РасходнаяНакладная"
	 ИЛИ ИмяСобытия = "Запись_АктВыполненныхРабот"
	 ИЛИ ИмяСобытия = "Запись_ЧекККМ_с_ЗаказомПокупателя"
	 ИЛИ ИмяСобытия = "ОповещениеОбОплатеЗаказа" 
	 ИЛИ ИмяСобытия = "ОбновитьФормуСпискаДокументовЧекККМ" 
	 ИЛИ ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		Форма.Элементы[ИмяСписка].Обновить();
	КонецЕсли;

КонецПроцедуры

Процедура СписокДокументовОтгрузкиОбработкаОповещенияФрагмент(Форма, ИмяСобытия, ИмяСписка = "Список") Экспорт

	Если ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		Форма.Элементы[ИмяСписка].Обновить();
	КонецЕсли;

КонецПроцедуры