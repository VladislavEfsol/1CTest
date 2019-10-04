
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область Служебные

&НаКлиенте
Процедура ИзменитьВидПоляНаименованиеДелегированияПодписи()
	
	ПереключениеВидов = Новый Соответствие;
	ПереключениеВидов.Вставить(ВидПоляФормы.ПолеВвода, ВидПоляФормы.ПолеНадписи);
	ПереключениеВидов.Вставить(ВидПоляФормы.ПолеНадписи, ВидПоляФормы.ПолеВвода);
	
	ШиринаПоля = ?(ПереключениеВидов[Элементы.Наименование.Вид] = ВидПоляФормы.ПолеВвода, 36, 37);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Наименование", "Вид", ПереключениеВидов[Элементы.Наименование.Вид]);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Наименование", "АвтоМаксимальнаяШирина", Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Наименование", "МаксимальнаяШирина", ШиринаПоля);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Наименование", "ЦветТекста", КэшЗначений.ЦветаСтиляВыделенногоЦвета);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеНаКлиенте()
	
	ШаблонНаименования = НСтр("ru ='%1 №%2 от %3'");
	Объект.Наименование = СтрШаблон(ШаблонНаименования, Объект.ВидДелегирования, Объект.Код, Формат(Объект.ДатаНачала, "ДФ=dd.MM.yyyy"));
	
КонецПроцедуры

#КонецОбласти

#Область форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("ЦветаСтиляВыделенногоЦвета", ЦветаСтиля.ВидДняПроизводственногоКалендаряСубботаЦвет);
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура РедактироватьПредставление(Команда)
	
	ИзменитьВидПоляНаименованиеДелегированияПодписи();
	
КонецПроцедуры

#КонецОбласти

#Область Элементы

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	СформироватьПредставлениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	СформироватьПредставлениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДелегированияПриИзменении(Элемент)
	
	СформироватьПредставлениеНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

