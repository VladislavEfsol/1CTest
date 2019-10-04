#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция получает начало периода относительно окончания периода.
//
// Параметры:
//  Дата		 - Дата	 - дата окончания
//  ВидПериода	 - ПеречислениеСсылка.ВидыПериодовМонитораРуководителя	 - вид периода.
// 
// Возвращаемое значение:
//  Дата - дата начала.
//
Функция ПолучитьНачалоПериода(Дата, ВидПериода) Экспорт
	
	Результат = Дата;
	
	Если ВидПериода = ПоследняяНеделя Тогда
		Результат = НачалоДня(Дата - (7 * 24 * 3600));
	ИначеЕсли ВидПериода = ПоследнийМесяц Тогда
		Результат = НачалоДня(ДобавитьМесяц(Дата, -1));
	ИначеЕсли ВидПериода = ПоследнийКвартал Тогда
		Результат = НачалоДня(ДобавитьМесяц(Дата, -3));
	ИначеЕсли ВидПериода = ПоследниеПолгода Тогда
		Результат = НачалоДня(ДобавитьМесяц(Дата, -6));
	ИначеЕсли ВидПериода = ПоследнийГод Тогда
		Результат = НачалоДня(ДобавитьМесяц(Дата, -12));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли