#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПоказыватьНастройкиДиаграммыНаФормеОтчета = Ложь;
	
	НастройкиВариантов["Остатки"].Вставить("ТолькоРесурсыОстатков", Истина);
	
	НастройкиВариантов["Ведомость"].Рекомендуемый = Истина;
	НастройкиВариантов["ЗапасыВПереработке"].Рекомендуемый = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	МассивПолейКоличеств = Новый Массив;
	МассивПолейСумм = Новый Массив;
	Для каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если НЕ ДоступноеПоле.Ресурс Тогда
			Продолжить;
		КонецЕсли;
		ИмяПоля = Строка(ДоступноеПоле.Поле);
		Если Найти(ИмяПоля, "Сумма")>0 Тогда
			МассивПолейСумм.Добавить(ИмяПоля);
		ИначеЕсли Найти(ИмяПоля, "Количество")>0 Тогда
			МассивПолейКоличеств.Добавить(ИмяПоля);
		КонецЕсли; 
	КонецЦикла;
	МассивПолейСумм.Добавить("СтоимостьЕд");
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияКоличества(ВариантыОформления, МассивПолейКоличеств);
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(ВариантыОформления, МассивПолейСумм);
			
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Ведомость"].Теги = НСтр("ru = 'Запасы,Закупки,Номенклатура,Передача,Комиссия,Продажи'");
	НастройкиВариантов["Остатки"].Теги = НСтр("ru = 'Запасы,Закупки,Номенклатура,Передача,Комиссия'");
	НастройкиВариантов["ЗапасыВПереработке"].Теги = НСтр("ru = 'Запасы,Закупки,Номенклатура,Передача,Переработка'");
	НастройкиВариантов["ЗапасыНаОтветхранении"].Теги = НСтр("ru = 'Запасы,Закупки,Номенклатура,Передача,Ответхранение'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Ведомость"].СвязанныеПоля, "Контрагент", "Справочник.Контрагенты");
	
КонецПроцедуры
 
#КонецОбласти 

ЭтоОтчетУНФ = Истина;

#КонецЕсли
