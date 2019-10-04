////////////////////////////////////////////////////////////////////////////////
// Модуль набора записей регистра сведений НастройкиОтправкиЭлектронныхДокументовПоВидам
//  
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель КАК Отправитель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель КАК Получатель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор КАК Договор,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.Интеркампани) КАК ЭтоИнтеркампани
		|ПОМЕСТИТЬ КлючевыеРеквизиты
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам КАК НастройкиОтправкиЭлектронныхДокументовПоВидам
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КлючевыеРеквизиты.Отправитель КАК Отправитель,
		|	КлючевыеРеквизиты.Получатель КАК Получатель,
		|	КлючевыеРеквизиты.Договор КАК Договор,
		|	ИСТИНА КАК Добавить,
		|	КлючевыеРеквизиты.ЭтоИнтеркампани КАК ЭтоИнтеркампани
		|ИЗ
		|	КлючевыеРеквизиты КАК КлючевыеРеквизиты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОтправкиЭлектронныхДокументов КАК НастройкиОтправкиЭлектронныхДокументов
		|		ПО КлючевыеРеквизиты.Отправитель = НастройкиОтправкиЭлектронныхДокументов.Отправитель
		|			И КлючевыеРеквизиты.Получатель = НастройкиОтправкиЭлектронныхДокументов.Получатель
		|			И КлючевыеРеквизиты.Договор = НастройкиОтправкиЭлектронныхДокументов.Договор
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументов.Отправитель ЕСТЬ NULL
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НастройкиОтправкиЭлектронныхДокументов.Отправитель,
		|	НастройкиОтправкиЭлектронныхДокументов.Получатель,
		|	НастройкиОтправкиЭлектронныхДокументов.Договор,
		|	ЛОЖЬ,
		|	КлючевыеРеквизиты.ЭтоИнтеркампани
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументов КАК НастройкиОтправкиЭлектронныхДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ КлючевыеРеквизиты КАК КлючевыеРеквизиты
		|		ПО (КлючевыеРеквизиты.Отправитель = НастройкиОтправкиЭлектронныхДокументов.Отправитель)
		|			И (КлючевыеРеквизиты.Получатель = НастройкиОтправкиЭлектронныхДокументов.Получатель)
		|			И (КлючевыеРеквизиты.Договор = НастройкиОтправкиЭлектронныхДокументов.Договор)
		|ГДЕ
		|	КлючевыеРеквизиты.Отправитель ЕСТЬ NULL";
	
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Начало = ОценкаПроизводительности.НачатьЗамерДлительнойОперации("РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.МодульНабораЗаписей.ПриЗаписи");
		
		ЗаписьЗапроса = РезультатЗапроса.Выбрать();
		МенеджерЗаписи = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументов.СоздатьМенеджерЗаписи();
		Счетчик = 0;
		
		НачатьТранзакцию();
		Попытка
			
			Пока ЗаписьЗапроса.Следующий() Цикл
				
				Счетчик = Счетчик + 1;
				ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ЗаписьЗапроса);
				
				Если ЗаписьЗапроса.Добавить Тогда
					МенеджерЗаписи.ДатаНачалаДействия = ТекущаяДатаСеанса();
					МенеджерЗаписи.Записать();
				Иначе
					МенеджерЗаписи.Удалить();
				КонецЕсли;
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			Информация = ИнформацияОбОшибке();
			
			ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Обновление настроек отправки'"), ПодробноеПредставлениеОшибки(Информация),
				НСтр("ru = 'Не удалось обновить настройки отправки электронных документов'"));
			
		КонецПопытки;
		
		УстановитьПривилегированныйРежим(Ложь);
		
		ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(Начало, Счетчик);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли