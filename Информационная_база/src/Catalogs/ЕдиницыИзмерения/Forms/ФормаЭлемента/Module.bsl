
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ИсточникКопирования = Параметры.ЗначениеКопирования;
		НастроитьВесИОбъем(Истина);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	НастроитьВесИОбъем();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("УказатьВесИОбъемДляЕдиницыТовара", ЗначениеЗаполнено(Вес) ИЛИ ЗначениеЗаполнено(Объем));
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Вес", Вес);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Объем", Объем);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	НастроитьВесИОбъем();
	
КонецПроцедуры

&НаКлиенте
Процедура ВесПриИзменении(Элемент)
	
	Элементы.ГруппаВесИОбъем.ЗаголовокСвернутогоОтображения = ЗаголовокСвернутойГруппыВесИОбъем(Вес, Объем);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъемПриИзменении(Элемент)
	
	Элементы.ГруппаВесИОбъем.ЗаголовокСвернутогоОтображения = ЗаголовокСвернутойГруппыВесИОбъем(Вес, Объем);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьВесИОбъем(ПоИсточникуКопирования = Ложь)
	
	Если ПоИсточникуКопирования Тогда
		ВладелецИсточника = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсточникКопирования, "Владелец");
		Если ТипЗнч(ВладелецИсточника) <> Тип("СправочникСсылка.Номенклатура") Тогда
			Элементы.ГруппаВесИОбъем.Видимость = Ложь;
			Возврат;
		КонецЕсли;
		ОтборНоменклатура = ВладелецИсточника;
		ОтборЕдиница = ИсточникКопирования;
	Иначе
		Если ТипЗнч(Объект.Владелец) <> Тип("СправочникСсылка.Номенклатура") Тогда
			Элементы.ГруппаВесИОбъем.Видимость = Ложь;
			Возврат;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Возврат;
		КонецЕсли;
		ОтборНоменклатура = Объект.Владелец;
		ОтборЕдиница = Объект.Ссылка;
	КонецЕсли; 
	Элементы.ГруппаВесИОбъем.Видимость = Истина;
	
	МенеджерЗаписи = РегистрыСведений.ВесИОбъемЕдиницТоваров.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Номенклатура = ОтборНоменклатура;
	МенеджерЗаписи.ЕдиницаИзмерения = ОтборЕдиница;
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		Вес = МенеджерЗаписи.Вес;
		Объем = МенеджерЗаписи.Объем;
		Элементы.ГруппаВесИОбъем.ЗаголовокСвернутогоОтображения = ЗаголовокСвернутойГруппыВесИОбъем(Вес, Объем);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокСвернутойГруппыВесИОбъем(Знач Вес, Знач Объем)
	
	КомпонентыЗаголовка = Новый Массив;
	Если ЗначениеЗаполнено(Вес) Тогда
		КомпонентыЗаголовка.Добавить(СтрШаблон("Вес: %1 кг", Вес));
	КонецЕсли;
	Если ЗначениеЗаполнено(Объем) Тогда
		КомпонентыЗаголовка.Добавить(СтрШаблон("Объем: %1 м³", Объем));
	КонецЕсли;
	
	Возврат СтрСоединить(КомпонентыЗаголовка, ", ");
	
КонецФункции

#КонецОбласти