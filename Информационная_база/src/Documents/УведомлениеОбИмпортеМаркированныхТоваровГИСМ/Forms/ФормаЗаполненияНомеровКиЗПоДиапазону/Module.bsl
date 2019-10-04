#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ПредставлениеНоменклатурыКиЗ.Заголовок = ИнтеграцияИС.ПредставлениеНоменклатуры(
		Параметры.НоменклатураКиЗ, Параметры.ХарактеристикаКиЗ);
	КоличествоНомеров = Параметры.КоличествоКиЗ;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() И НЕ ТолькоПросмотр Тогда
		Если ИмяСобытия = "ScanData" Тогда
			
			Данные = СобытияФормИСКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр);
			ОбработатьШтрихкоды(Данные);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	НомерКиЗНачало = РазложитьНомерКиЗ(НомерНачало);
	НомерКиЗОкончание = РазложитьНомерКиЗ(НомерОкончание);
	
	ПараметрыЗакрытия = Новый Структура();
	ПараметрыЗакрытия.Вставить("НомерНачалоСтроковаяЧасть",    НомерКиЗНачало.СтроковаяЧасть);
	ПараметрыЗакрытия.Вставить("НомерОкончаниеСтроковаяЧасть", НомерКиЗОкончание.СтроковаяЧасть);
	ПараметрыЗакрытия.Вставить("НомерНачалоЦифроваяЧасть",     НомерКиЗНачало.ЦифроваяЧасть);
	ПараметрыЗакрытия.Вставить("НомерОкончаниеЦифроваяЧасть",  НомерКиЗОкончание.ЦифроваяЧасть);
	ПараметрыЗакрытия.Вставить("КоличествоНомеров",            КоличествоНомеров);
	ПараметрыЗакрытия.Вставить("НоменклатураКиЗ",              Параметры.НоменклатураКиЗ);
	ПараметрыЗакрытия.Вставить("ХарактеристикаКиЗ",            Параметры.ХарактеристикаКиЗ);
	
	Оповестить(
		"ЗаполнениеНомеровКиЗПоДиапазону",
		ПараметрыЗакрытия,
		ЭтаФорма);
		
	Закрыть(Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура КоличествоНомеровПриИзменении(Элемент)
	
	ЗаполнитьНомерКиЗОкончание();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерНачалоПриИзменении(Элемент)
	
	ЗаполнитьНомерКиЗОкончание();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерОкончаниеПриИзменении(Элемент)
	
	ЗаполнитьКоличествоНомеров();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьНомерКиЗОкончание()
	
	Если ЗначениеЗаполнено(НомерНачало)
		И ЗначениеЗаполнено(КоличествоНомеров) Тогда
		
		НомерКиЗНачало = РазложитьНомерКиЗ(НомерНачало);
		
		Если Не ЗначениеЗаполнено(НомерОкончание) Тогда
			НомерОкончание = НомерКиЗНачало.СтроковаяЧасть;
		КонецЕсли;
		
		НомерКиЗОкончание = РазложитьНомерКиЗ(НомерОкончание);
		
		Если НомерКиЗНачало.СтроковаяЧасть = НомерКиЗОкончание.СтроковаяЧасть Тогда
			НомерКиЗОкончаниеЧислом = НомерКиЗНачало.ЦифроваяЧасть + КоличествоНомеров - 1;
			НомерОкончание = НомерКиЗОкончание.СтроковаяЧасть + Формат(НомерКиЗОкончаниеЧислом, "ЧН=0; ЧГ=0");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКоличествоНомеров()
	
	Если ЗначениеЗаполнено(НомерНачало)
		И ЗначениеЗаполнено(НомерОкончание) Тогда
		
		НомерКиЗНачало = РазложитьНомерКиЗ(НомерНачало);
		НомерКиЗОкончание = РазложитьНомерКиЗ(НомерОкончание);
		
		Если НомерКиЗНачало.СтроковаяЧасть = НомерКиЗОкончание.СтроковаяЧасть И 
			НомерКиЗОкончание.ЦифроваяЧасть >= НомерКиЗНачало.ЦифроваяЧасть+1 Тогда
			
			КоличествоНомеров = НомерКиЗОкончание.ЦифроваяЧасть - НомерКиЗНачало.ЦифроваяЧасть + 1;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция РазложитьНомерКиЗ(НомерКиЗ)
	
	ДлинаНомераКиЗ = СтрДлина(НомерКиЗ);
	ПараметрыВозврата = Новый Структура();
	ПараметрыВозврата.Вставить("ЦифроваяЧасть", Неопределено);
	ПараметрыВозврата.Вставить("СтроковаяЧасть", НомерКиЗ);
	
	ЦифроваяЧастьНомераКиЗ = "";
	
	Для а = 0 По ДлинаНомераКиЗ Цикл
		
		ТекСимвол = Сред(НомерКиЗ, ДлинаНомераКиЗ-а, 1);
		
		Если Не ЭтоЦифра(ТекСимвол) Или а = ДлинаНомераКиЗ Тогда
			
			ЦифроваяЧастьНомераКиЗ = Прав(НомерКиЗ, а);
			СтроковаяЧастьНомераКиЗ = Лев(НомерКиЗ, ДлинаНомераКиЗ-а);
			
			Попытка
				ЦифроваяЧастьНомераКиЗ = Число(ЦифроваяЧастьНомераКиЗ);
			Исключение
				ЦифроваяЧастьНомераКиЗ = 0;
				СтроковаяЧастьНомераКиЗ = НомерКиЗ;
			КонецПопытки;
			
			ПараметрыВозврата.Вставить("ЦифроваяЧасть", ЦифроваяЧастьНомераКиЗ);
			ПараметрыВозврата.Вставить("СтроковаяЧасть", СтроковаяЧастьНомераКиЗ);
			
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПараметрыВозврата;
	
КонецФункции

&НаКлиенте
Функция ЭтоЦифра(Символ)
	
	Возврат СтрНайти("0123456789", Символ) > 0;
	
КонецФункции

&НаСервере
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	ШтрихкодыПоТипам = ИнтеграцияГИСМКлиентСервер.РазложитьПоТипамШтрихкодов(ДанныеШтрихкодов);
	
	Если ШтрихкодыПоТипам.КиЗ.Количество() > 0 Тогда
		
		Для Каждого Штрихкод Из ШтрихкодыПоТипам.КиЗ Цикл
			
			Если Не ИнтеграцияГИСМВызовСервера.ЭтоНомерКиЗ(Штрихкод.ШтрихКод) Тогда
				ТекстСообщения = НСтр("ru = 'Введенные данные не являются номером КиЗ.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				Продолжить;
			КонецЕсли;
			
			НомерНачало = Штрихкод.ШтрихКод;
			
		КонецЦикла;
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Введенные данные не являются номером КиЗ.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти