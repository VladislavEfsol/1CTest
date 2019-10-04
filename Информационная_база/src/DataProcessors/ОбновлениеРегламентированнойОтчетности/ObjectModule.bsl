#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции
	
Функция ПоискЭлементаПоРеквизитам(Наименование, Источник = "", ЭтоГруппа = Ложь)	

	РегламОтчеты = Справочники.РегламентированныеОтчеты;

	Если ЭтоГруппа Тогда
		
		НайденнаяГруппа = РегламОтчеты.НайтиПоНаименованию(Наименование, Истина);

		Если НЕ НайденнаяГруппа = РегламОтчеты.ПустаяСсылка() Тогда

			Возврат НайденнаяГруппа;

		КонецЕсли;

	Иначе

		НайденныйЭлемент = РегламОтчеты.НайтиПоРеквизиту("ИсточникОтчета", СокрЛП(Источник));

		Если НЕ НайденныйЭлемент = РегламОтчеты.ПустаяСсылка() Тогда

			Возврат НайденныйЭлемент;

		КонецЕсли;

	КонецЕсли;

	Возврат Неопределено;

КонецФункции

Функция РазложитьСтрокуПериодов(Периоды)
	
	ПериодыПредставления = Новый Соответствие;
	
	Для НомСтр = 1 По СтрЧислоСтрок(Периоды) Цикл
	
		ТекСтр = СтрПолучитьСтроку(Периоды, НомСтр);
		Если ПустаяСтрока(ТекСтр) Тогда
			Продолжить;
		КонецЕсли;
		
		ВхождениеРазделителяНачалаДействия = СтрНайти(ТекСтр, "#");
		СтрПустаяДатаНачалаДействия = "00010101000000";
		Если ВхождениеРазделителяНачалаДействия = 0 Тогда
			СтрДатаНачалаДействия = СтрПустаяДатаНачалаДействия;
		Иначе
			СтрДатаНачалаДействия = СокрЛП(Лев(ТекСтр, ВхождениеРазделителяНачалаДействия - 1));
			ДлинаПредставленияДатыНачала = СтрДлина(СтрДатаНачалаДействия);
			Для Инд = ДлинаПредставленияДатыНачала + 1 По СтрДлина(СтрПустаяДатаНачалаДействия) Цикл
				СтрДатаНачалаДействия = СтрДатаНачалаДействия + Сред(СтрПустаяДатаНачалаДействия, Инд, 1);
			КонецЦикла;
		КонецЕсли;
		ДатаНачалаДействия = Дата(СтрДатаНачалаДействия);
		
		ТекСтр = СокрЛП(Сред(ТекСтр, ВхождениеРазделителяНачалаДействия + 1));
		
		МассивСлов = Новый Массив;
		ПредыдущийРазделитель = 0;
		
		Для Сч = 1 По СтрДлина(ТекСтр) Цикл
			
			Если Сред(ТекСтр, Сч, 1) = ";" Тогда
				Слово = СокрЛП(Сред(ТекСтр, ПредыдущийРазделитель + 1, Сч - ПредыдущийРазделитель - 1));
				Если ПустаяСтрока(Слово) Тогда
					Продолжить;
				КонецЕсли;
				МассивСлов.Добавить(Слово);
				ПредыдущийРазделитель = Сч;
			КонецЕсли;
			
		КонецЦикла;
		
		Слово = СокрЛП(Сред(ТекСтр, ПредыдущийРазделитель + 1));
		Если НЕ ПустаяСтрока(Слово) Тогда
			МассивСлов.Добавить(Слово);
		КонецЕсли;
		
		СтруктураТекущегоПериода = Новый Структура;
		Для Каждого Слово Из МассивСлов Цикл
			
			ВхождениеДвоеточия = СтрНайти(Слово, ":");
			Если ВхождениеДвоеточия = 0 Тогда
				Продолжить;
			КонецЕсли;
			Ключ = СокрЛП(Лев(Слово, ВхождениеДвоеточия - 1));
			Значение = СокрЛП(Сред(Слово, ВхождениеДвоеточия + 1));
			
			МассивИнтервалов = Новый Массив;
			ПредыдущийРазделитель = 0;
			Для Сч = 1 По СтрДлина(Значение) Цикл
				
				Если Сред(Значение, Сч, 1) = "," Тогда
					МассивИнтервалов.Добавить(Число(СокрЛП(Сред(Значение, ПредыдущийРазделитель + 1, Сч - ПредыдущийРазделитель - 1))));
					ПредыдущийРазделитель = Сч;
				КонецЕсли;
			
			КонецЦикла;
			
			Интервал = СокрЛП(Сред(Значение, ПредыдущийРазделитель + 1));
			Если НЕ ПустаяСтрока(Интервал) Тогда
				МассивИнтервалов.Добавить(Число(Интервал));
			КонецЕсли;
			
			СтруктураТекущегоПериода.Вставить(Ключ, МассивИнтервалов);
				
		КонецЦикла;
		
		ПериодыПредставления.Вставить(ДатаНачалаДействия, СтруктураТекущегоПериода);
		
	КонецЦикла;
	
	Возврат ПериодыПредставления;
	
КонецФункции

Функция ПолучитьСписокОтчетов() Экспорт

	Перем ДеревоОтчетов;

	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000));

	ОписаниеТиповЧисло  = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1));

	МассивБулево = Новый Массив;
	МассивБулево.Добавить(Тип("Булево"));
	ОписаниеТиповБулево = Новый ОписаниеТипов(МассивБулево);

	// Дерево значений содержит иерархию элементов справочника РегламентированныеОтчеты.
	// В колонках дерева значений отображается следующая информация:
	//   - наименование отчета;
	//   - описание отчета;
	//   - место нахождения отчета;
	//   - метка выбора отчета.
	ДеревоОтчетов = Новый ДеревоЗначений;
	ДеревоОтчетов.Колонки.Добавить( "Наименование", ОписаниеТиповСтрока );
	ДеревоОтчетов.Колонки.Добавить( "Описание",     ОписаниеТиповСтрока );
	ДеревоОтчетов.Колонки.Добавить( "Источник",     ОписаниеТиповСтрока );
	ДеревоОтчетов.Колонки.Добавить( "ЭтоГруппа",    ОписаниеТиповБулево );
	ДеревоОтчетов.Колонки.Добавить( "МеткаВыбора",  ОписаниеТиповЧисло  );
	ДеревоОтчетов.Колонки.Добавить( "Периоды",  	ОписаниеТиповСтрока );
	ДеревоОтчетов.Колонки.Добавить( "УИДОтчета",  	ОписаниеТиповСтрока );

	// Шаблон списка отчетов в макете имеет следующую структуру:
	//   Каждая именованная область макета содержит элементы одной группы.
	//   При отсутствии имени группы в первой колонке первой строки области
	//   элементы, содержащиеся в этой области, принимаются за элементы корневого
	//   уровня (0-уровня). Элементы создаются в том же порядке, в котором они
	//   перечислены в макете.
	
	СписокРеглОтчетовИспользуемыхВТекущейКонфигурации = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСписокРегламентированныхОтчетов();
	
	// Получим макет со списком отчетов.
	МакетСписокОтчетов = ЭтотОбъект.ПолучитьМакет("СписокОтчетов");

	Для Инд = 0 По МакетСписокОтчетов.Области.Количество() - 1 Цикл

		ТекОбласть = МакетСписокОтчетов.Области[Инд];
		ИмяОбласти = ТекОбласть.Имя;

		// наименование группы определяется по первой колонке макета
		ИмяГруппы = СокрЛП(МакетСписокОтчетов.Область(ТекОбласть.Верх, 1).Текст);
		ОписаниеГруппы = СокрЛП(МакетСписокОтчетов.Область(ТекОбласть.Верх, 3).Текст);
		ИсточникГруппы = СокрЛП(МакетСписокОтчетов.Область(ТекОбласть.Верх, 4).Текст);

		Если Не ПустаяСтрока(ИмяГруппы) Тогда

			СтрокаУровня1 = ДеревоОтчетов.Строки.Добавить();
			СтрокаУровня1.Наименование = ИмяГруппы;
			СтрокаУровня1.Источник     = ИсточникГруппы;
			СтрокаУровня1.ЭтоГруппа    = Истина;
			СтрокаУровня1.Описание     = ОписаниеГруппы;
			СтрокаУровня1.МеткаВыбора  = 1;

			Для Ном = ТекОбласть.Верх По ТекОбласть.Низ Цикл
				// перебираем элементы второго уровня

				// наименование отчета определяется по второй колонке макета
				Наименование = СокрЛП(МакетСписокОтчетов.Область(Ном, 2).Текст);

				Если ПустаяСтрока(Наименование) Тогда
					// пустые строки пропускаем
					Продолжить;
				КонецЕсли;

				// описание отчета  определяется по третьей колонке макета
				Описание     = СокрЛП(МакетСписокОтчетов.Область(Ном, 3).Текст);
				// место нахождения отчета  определяется по четвертой колонке макета
				Источник     = СокрЛП(МакетСписокОтчетов.Область(Ном, 4).Текст);
				
				Периоды		 = СокрЛП(МакетСписокОтчетов.Область(Ном, 5).Текст);
				
				УИДОтчета	 = СокрЛП(МакетСписокОтчетов.Область(Ном, 6).Текст);

				Если СписокРеглОтчетовИспользуемыхВТекущейКонфигурации.НайтиПоЗначению(Источник) = Неопределено Тогда
					Продолжить;
				КонецЕсли;
								
				СтрокаУровня2 = СтрокаУровня1.Строки.Добавить();
				СтрокаУровня2.Наименование = Наименование;
				СтрокаУровня2.Описание     = Описание;
				СтрокаУровня2.Источник     = Источник;
				СтрокаУровня2.ЭтоГруппа    = Ложь;
				СтрокаУровня2.МеткаВыбора  = 1;
				СтрокаУровня2.Периоды	   = Периоды;
				СтрокаУровня2.УИДОтчета	   = УИДОтчета;

			КонецЦикла;
			
			Если СтрокаУровня1.Строки.Количество() = 0 Тогда
				ДеревоОтчетов.Строки.Удалить(СтрокаУровня1);
			КонецЕсли;
			
		Иначе
			// для элемента корневого (0-уровня)
			Для Ном = ТекОбласть.Верх По ТекОбласть.Низ Цикл
				// перебираем элементы второго уровня

				// наименование отчета определяется по второй колонке макета
				Наименование = СокрЛП(МакетСписокОтчетов.Область(Ном, 2).Текст);

				Если ПустаяСтрока(Наименование) Тогда
					// пустые строки пропускаем
					Продолжить;
				КонецЕсли;

				// описание отчета  определяется по третьей колонке макета
				Описание      = СокрЛП(МакетСписокОтчетов.Область(Ном, 3).Текст);
				// место нахождения отчета  определяется по четвертой колонке макета
				Источник      = СокрЛП(МакетСписокОтчетов.Область(Ном, 4).Текст);

				Периоды		 = СокрЛП(МакетСписокОтчетов.Область(Ном, 5).Текст);
				
				УИДОтчета	 = СокрЛП(МакетСписокОтчетов.Область(Ном, 6).Текст);
				
				Если СписокРеглОтчетовИспользуемыхВТекущейКонфигурации.НайтиПоЗначению(Источник) = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаУровня1 = ДеревоОтчетов.Строки.Добавить();
				СтрокаУровня1.Наименование = Наименование;
				СтрокаУровня1.Описание     = Описание;
				СтрокаУровня1.Источник     = Источник;
				СтрокаУровня1.ЭтоГруппа    = Ложь;
				СтрокаУровня1.МеткаВыбора  = 1;
				СтрокаУровня1.Периоды	   = Периоды;
				СтрокаУровня1.УИДОтчета	   = УИДОтчета;

			КонецЦикла;
			
		КонецЕсли;

	КонецЦикла;
	
	Возврат ДеревоОтчетов;
	
КонецФункции

Процедура ЗаполнитьСписокОтчетов(ДеревоОтчетов) Экспорт

	Перем НайденнаяГруппа;
	Перем НайденныйЭлемент;
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		
		Возврат;
		
	КонецЕсли;
		
	РегламОтчеты = Справочники.РегламентированныеОтчеты;
	
	// Открываем транзакцию.
	НачатьТранзакцию();
	
	Для Каждого СтрокаУровня1 Из ДеревоОтчетов.Строки Цикл
		
		ИмяОтчета = СокрЛП(СтрокаУровня1.Наименование);
		Описание  = СокрЛП(СтрокаУровня1.Описание);
		Источник  = СокрЛП(СтрокаУровня1.Источник);
		ЭтоГруппа = СтрокаУровня1.ЭтоГруппа;
		Метка     = СтрокаУровня1.МеткаВыбора;
		Периоды   = СокрЛП(СтрокаУровня1.Периоды);
		УИДОтчета = СокрЛП(СтрокаУровня1.УИДОтчета);

		Если Метка = 0 Тогда
			// Пропускаем не помеченные отчеты.
			Продолжить;
		КонецЕсли;
		
		Если ЭтоГруппа Тогда
			
			НайденнаяГруппа = ПоискЭлементаПоРеквизитам(ИмяОтчета, "", Истина);
			Родитель        = НайденнаяГруппа;
			
			Если НайденнаяГруппа = Неопределено Тогда
				
				// Новая группа элементов справочника.
				НоваяГруппа = РегламОтчеты.СоздатьГруппу();
				НоваяГруппа.Наименование   = ИмяОтчета;
				НоваяГруппа.ИсточникОтчета = Источник;
				
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НоваяГруппа, , Истина);
				
				Родитель = НоваяГруппа.Ссылка;
				
			Иначе
				
				ГруппаОбъект = НайденнаяГруппа.ПолучитьОбъект();
				ГруппаОбъект.Описание       = Описание;
				ГруппаОбъект.ИсточникОтчета = Источник;
				
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ГруппаОбъект, , Истина);
				
			КонецЕсли;
			
			Если СтрокаУровня1.Строки.Количество() > 0 Тогда
				
				Для Каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл
					
					ИмяОтчета = СокрЛП(СтрокаУровня2.Наименование);
					Описание  = СокрЛП(СтрокаУровня2.Описание);
					Источник  = СокрЛП(СтрокаУровня2.Источник);
					ЭтоГруппа = СтрокаУровня2.ЭтоГруппа;
					Метка     = СтрокаУровня2.МеткаВыбора;
					Периоды   = СокрЛП(СтрокаУровня2.Периоды);
					УИДОтчета = СокрЛП(СтрокаУровня2.УИДОтчета);
					
					Если Метка = 0 Тогда
						// Пропускаем не помеченные отчеты.
						Продолжить;
					КонецЕсли;
					
					НайденныйЭлемент = ПоискЭлементаПоРеквизитам(ИмяОтчета, Источник);
					
					Если НайденныйЭлемент = Неопределено Тогда
						
						// Создаем новый элемент справочника.
						НовыйЭлемент                = РегламОтчеты.СоздатьЭлемент();
						НовыйЭлемент.Родитель       = Родитель;
						НовыйЭлемент.Наименование   = ИмяОтчета;
						НовыйЭлемент.Описание       = Описание;
						НовыйЭлемент.ИсточникОтчета = Источник;
						НовыйЭлемент.Периоды		= Новый ХранилищеЗначения(РазложитьСтрокуПериодов(Периоды));
						НовыйЭлемент.УИДОтчета		= УИДОтчета;
						
						ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НовыйЭлемент, , Истина);
						
					Иначе
						
						// Обновляем реквизиты найденного элемента.
						ТекЭлемент = НайденныйЭлемент.ПолучитьОбъект();
						ТекЭлемент.Родитель     = Родитель;
						ТекЭлемент.Наименование = ИмяОтчета;
						ТекЭлемент.Описание     = Описание;
						ТекЭлемент.Периоды		= Новый ХранилищеЗначения(РазложитьСтрокуПериодов(Периоды));
						ТекЭлемент.УИДОтчета	= УИДОтчета;
						
						ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ТекЭлемент, , Истина);
						
					КонецЕсли;
					
				КонецЦикла;
			КонецЕсли;
			
		Иначе
			
			НайденныйЭлемент = ПоискЭлементаПоРеквизитам(ИмяОтчета, Источник);
			
			Если НайденныйЭлемент = Неопределено Тогда
				
				// Создаем новый элемент справочника.
				НовыйЭлемент                = РегламОтчеты.СоздатьЭлемент();
				НовыйЭлемент.Наименование   = ИмяОтчета;
				НовыйЭлемент.Описание       = Описание;
				НовыйЭлемент.ИсточникОтчета = Источник;
				НовыйЭлемент.Периоды		= Новый ХранилищеЗначения(РазложитьСтрокуПериодов(Периоды));
				НовыйЭлемент.УИДОтчета		= УИДОтчета;
				
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НовыйЭлемент, , Истина);
				
			Иначе
				
				// Обновляем реквизиты найденного элемента.
				ТекЭлемент = НайденныйЭлемент.ПолучитьОбъект();
				ТекЭлемент.Наименование = ИмяОтчета;
				ТекЭлемент.Описание     = Описание;
				ТекЭлемент.Периоды		= Новый ХранилищеЗначения(РазложитьСтрокуПериодов(Периоды));
				ТекЭлемент.УИДОтчета	= УИДОтчета;
				
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ТекЭлемент, , Истина);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Завершаем транзакцию.
	ЗафиксироватьТранзакцию();
		
КонецПроцедуры

Процедура УстановитьСнятьПометкуНаУдаление(ДеревоОтчетов) Экспорт
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	РеглОтчеты = Справочники.РегламентированныеОтчеты.Выбрать();
		
	Пока РеглОтчеты.Следующий() Цикл
		
		Если РеглОтчеты.ЭтоГруппа Тогда
			
			РезультатПоиска = ДеревоОтчетов.Строки.Найти(РеглОтчеты.Наименование, "Наименование", Истина);
			
			Если РезультатПоиска = Неопределено	ИЛИ НЕ ЗначениеЗаполнено(РеглОтчеты.Наименование) Тогда
				
				Реквизиты = Новый Структура;
				Реквизиты.Вставить("ПометкаУдаления", Истина);
				
				ИзменитьРеквизитыОтчета(РеглОтчеты.ПолучитьОбъект(), Реквизиты);
				
			ИначеЕсли РеглОтчеты.ПометкаУдаления Тогда
				
				Реквизиты = Новый Структура;
				Реквизиты.Вставить("ПометкаУдаления", Ложь);
				
				ИзменитьРеквизитыОтчета(РеглОтчеты.ПолучитьОбъект(), Реквизиты);
				
			КонецЕсли;
			
		Иначе	
			
			РезультатПоиска = ДеревоОтчетов.Строки.Найти(РеглОтчеты.ИсточникОтчета, "Источник", Истина);
												
			Если РезультатПоиска = Неопределено	ИЛИ НЕ ЗначениеЗаполнено(РеглОтчеты.ИсточникОтчета) Тогда
				
				Реквизиты = Новый Структура;
				Реквизиты.Вставить("ПометкаУдаления", Истина);
				
				ИзменитьРеквизитыОтчета(РеглОтчеты.ПолучитьОбъект(), Реквизиты);
				
			ИначеЕсли РеглОтчеты.ПометкаУдаления Тогда
				
				Реквизиты = Новый Структура;
				Реквизиты.Вставить("ПометкаУдаления", Ложь);
				
				ИзменитьРеквизитыОтчета(РеглОтчеты.ПолучитьОбъект(), Реквизиты);
				
			КонецЕсли;
		
		КонецЕсли;
				
	КонецЦикла;
	
КонецПроцедуры

Процедура СкрытьВосстановитьОтчеты(ДеревоОтчетов) Экспорт
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	РеглОтчеты = Справочники.РегламентированныеОтчеты.Выбрать();
		
	Пока РеглОтчеты.Следующий() Цикл
		
		Если НЕ РеглОтчеты.ЭтоГруппа Тогда
			
			РезультатПоиска = ДеревоОтчетов.Строки.Найти(РеглОтчеты.ИсточникОтчета, "Источник", Истина);
			
			СкрытыеРегламентированныеОтчеты = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
			СкрытыеРегламентированныеОтчеты.РегламентированныйОтчет = РеглОтчеты.Ссылка;
			СкрытыеРегламентированныеОтчеты.Прочитать();
			
			Если РезультатПоиска = Неопределено	ИЛИ НЕ ЗначениеЗаполнено(РеглОтчеты.ИсточникОтчета) Тогда
				
				Реквизиты = Новый Структура;
				Реквизиты.Вставить("СкрытьРеглОтчет", Истина);
				
				ИзменитьСкрытыеРегламентированныеОтчеты(РеглОтчеты.ПолучитьОбъект(), Реквизиты);
				
			ИначеЕсли РеглОтчеты.ПометкаУдаления И СкрытыеРегламентированныеОтчеты.Выбран() Тогда
				
				Реквизиты = Новый Структура;
				Реквизиты.Вставить("СкрытьРеглОтчет", Ложь);
				
				ИзменитьСкрытыеРегламентированныеОтчеты(РеглОтчеты.ПолучитьОбъект(), Реквизиты);
				
			КонецЕсли;
			
		КонецЕсли;
				
	КонецЦикла;
	
КонецПроцедуры

Процедура ИзменитьРеквизитыОтчета(Отчет, Реквизиты)
	
	// Открываем транзакцию.
	НачатьТранзакцию();
	
	Попытка 
		
		Отчет.ПометкаУдаления = Реквизиты.ПометкаУдаления;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Отчет, , Истина);
		
		// Завершаем транзакцию.
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
	КонецПопытки
	
КонецПроцедуры

Процедура ИзменитьСкрытыеРегламентированныеОтчеты(Отчет, Реквизиты)
	
	// Открываем транзакцию.
	НачатьТранзакцию();
	
	СкрытыеРегламентированныеОтчеты = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
	СкрытыеРегламентированныеОтчеты.РегламентированныйОтчет = Отчет.Ссылка;
	
	Если Реквизиты.СкрытьРеглОтчет Тогда
		СкрытыеРегламентированныеОтчеты.Записать();
	Иначе
		СкрытыеРегламентированныеОтчеты.Удалить();
	КонецЕсли;
	
	// Завершаем транзакцию.
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли