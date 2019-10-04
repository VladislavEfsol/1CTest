
Процедура ПолныйЗарегистрироватьИзменениеДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если ОбменДаннымиРИБСобытияПовтИсп.ЕстьУзлыРИБ() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("Полный", Источник, Отказ, РежимЗаписи, РежимПроведения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолныйЗарегистрироватьИзменениеПередЗаписью(Источник, Отказ) Экспорт
	
	Если ОбменДаннымиРИБСобытияПовтИсп.ЕстьУзлыРИБ() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("Полный", Источник, Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПолныйЗарегистрироватьИзменениеНабораЗаписейПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	Если ОбменДаннымиРИБСобытияПовтИсп.ЕстьУзлыРИБ() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("Полный", Источник, Отказ, Замещение);
	КонецЕсли;

КонецПроцедуры

Процедура ПолныйЗарегистрироватьИзменениеКонстантыПередЗаписью(Источник, Отказ) Экспорт
	
	Если ОбменДаннымиРИБСобытияПовтИсп.ЕстьУзлыРИБ() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("Полный", Источник, Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПолныйЗарегистрироватьУдалениеПередУдалением(Источник, Отказ) Экспорт
	
	Если ОбменДаннымиРИБСобытияПовтИсп.ЕстьУзлыРИБ() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("Полный", Источник, Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПоОрганизацииЗарегистрироватьИзменениеКонстантыПередЗаписью(Источник, Отказ) Экспорт
	
	Если ОбменДаннымиРИБСобытияПовтИсп.ЕстьУзлыРИБ() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("ПоОрганизации", Источник, Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПоОрганизацииЗарегистрироватьИзменениеНабораЗаписейПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	Если ОбменДаннымиРИБСобытияПовтИсп.ЕстьУзлыРИБ() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ПоОрганизации", Источник, Отказ, Замещение);
	КонецЕсли;

КонецПроцедуры

Процедура ПоОрганизацииЗарегистрироватьИзменениеДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если ОбменДаннымиРИБСобытияПовтИсп.ЕстьУзлыРИБ() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ПоОрганизации", Источник, Отказ, РежимЗаписи, РежимПроведения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоОрганизацииЗарегистрироватьИзменениеПередЗаписью(Источник, Отказ) Экспорт
	
	Если ОбменДаннымиРИБСобытияПовтИсп.ЕстьУзлыРИБ() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ПоОрганизации", Источник, Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПоОрганизацииЗарегистрироватьУдалениеПередУдалением(Источник, Отказ) Экспорт
	
	Если ОбменДаннымиРИБСобытияПовтИсп.ЕстьУзлыРИБ() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ПоОрганизации", Источник, Отказ);
	КонецЕсли;
КонецПроцедуры

Процедура ОбновлениеПовторноИспользуемыхЗначенийРИБПриЗаписи(Источник, Отказ) Экспорт
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры
