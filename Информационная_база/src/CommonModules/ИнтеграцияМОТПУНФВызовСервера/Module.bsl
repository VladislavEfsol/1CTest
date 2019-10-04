#Область СлужебныйПрограммныйИнтерфейс

Функция АдресДанныхПроверкиТабачнойПродукцииЧекККМ(ПараметрыСканирования, Знач Объект, УникальныйИдентификатор) Экспорт
	
	СписокШтрихкодов = Объект.АкцизныеМарки.Выгрузить().ВыгрузитьКолонку("АкцизнаяМарка");
	ШтрихкодыТабачнойПродукции = ИнтеграцияИСУНФ.ШтрихкодыСодержащиеВидыПродукции(
		СписокШтрихкодов,
		Перечисления.ВидыПродукцииИС.Табачная);
	
	ДанныеПроверяемогоДокумента = ШтрихкодированиеИС.ВложенныеШтрихкодыУпаковок(
		ШтрихкодыТабачнойПродукции, ПараметрыСканирования);
	
	ТаблицаТабачнойПродукции = ПроверкаИПодборПродукцииМОТП.ТаблицаТабачнойПродукцииДокумента(Объект);

	ДанныеХранилища = Новый Структура("ДеревоУпаковок, МаркированныеТовары, ТаблицаТабачнойПродукции",
		ДанныеПроверяемогоДокумента.ДеревоУпаковок,
		ДанныеПроверяемогоДокумента.МаркированныеТовары,
		ТаблицаТабачнойПродукции);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеХранилища, УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти