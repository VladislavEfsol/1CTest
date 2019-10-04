#Область ПрограммныйИнтерфейс

// Загружает в таблицу данные из терминала сбора данных.
//
Процедура ПолучитьДанныеИзТСД(Форма) Экспорт
	
	ОчиститьСообщения();
	
	Форма.Доступность = Ложь;
	
	Параметры = Новый Структура;
	Параметры.Вставить("Форма", Форма);
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПолучитьДанныеИзТСДЗавершение", ЭтотОбъект, Параметры);
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(
		ОповещениеПриЗавершении,
		Форма.УникальныйИдентификатор
	);
	
КонецПроцедуры

Процедура ПолучитьДанныеИзТСДЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Параметры.Форма.Доступность = Истина; // Разблокировка интерфейса пользователя.
	
	Если РезультатВыполнения.Результат Тогда
		Параметры.Форма.ПолученыШтрихкоды(РезультатВыполнения.ТаблицаТоваров);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатВыполнения.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

// Получает вес с электронных весов для табличной части.
//    
Процедура ПолучениеВесаСЭлектронныхВесовДляТабличнойЧасти(Форма, ИмяТабличнойЧасти = "Товары", ВыполнитьПолучитьВесЗавершение = Истина) Экспорт
	
	// Проверим текущую строку табличной части.
	Если ЗначениеЗаполнено(ИмяТабличнойЧасти) Тогда
		
		ТекущаяСтрока = Форма.Элементы[ИмяТабличнойЧасти].ТекущиеДанные;
		Если ТекущаяСтрока = Неопределено Тогда
			ТекстСообщения = НСтр("ru='Необходимо выбрать строку, для которой необходимо получить вес.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Иначе
			Форма.Доступность = Ложь;
			
			Параметры = Новый Структура;
			Параметры.Вставить("ВыполнитьПолучитьВесЗавершение", ВыполнитьПолучитьВесЗавершение);
			Параметры.Вставить("ТекущаяСтрока" , ТекущаяСтрока);
			Параметры.Вставить("Форма"         , Форма);
			ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеВесаСЭлектронныхВесовДляТабличнойЧастиЗавершение", ЭтотОбъект, Параметры);
			МенеджерОборудованияКлиент.НачатьПолученияВесаСЭлектронныхВесов(ОписаниеОповещения, Форма.УникальныйИдентификатор, , Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Получает вес с электронных весов для табличной части - завершение.
//    
Процедура ПолучениеВесаСЭлектронныхВесовДляТабличнойЧастиЗавершение(РезультатОперации, Параметры) Экспорт
	
	Параметры.Форма.Доступность = Истина;
	
	Если РезультатОперации.Результат Тогда
		
		Параметры.ТекущаяСтрока.Количество = РезультатОперации.Вес;
		
		Если Параметры.ВыполнитьПолучитьВесЗавершение Тогда
			Параметры.Форма.ПолучитьВесЗавершение(Параметры.ТекущаяСтрока);
		КонецЕсли;
		
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатОперации.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


