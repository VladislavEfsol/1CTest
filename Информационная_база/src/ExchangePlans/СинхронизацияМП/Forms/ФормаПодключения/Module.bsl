&НаСервере
Процедура СформироватьQR()
	
	АдресДляПодключенияКЦентральнойБазеСМобильногоУстройства = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
	QRСтрока = "sbmcs" + ";" + АдресДляПодключенияКЦентральнойБазеСМобильногоУстройства + ";" + Пользователь; 
	ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRСтрока, 0, 190);
	QRКод = ПоместитьВоВременноеХранилище(ДанныеQRКода, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресДляПодключенияКЦентральнойБазеСМобильногоУстройства = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
	
	Если Найти(АдресДляПодключенияКЦентральнойБазеСМобильногоУстройства, "e1c://") = Истина Тогда
		Элементы.ГруппаШаг2Заголовок.Видимость = Ложь;
		Элементы.ГруппаШаг2.Видимость = Ложь;
		Элементы.ДекорацияШаг1.Видимость = Ложь;
	Иначе
		Элементы.ГруппаШаг2Заголовок.Видимость = Истина;
		Элементы.ГруппаШаг2.Видимость = Истина;
		Элементы.ДекорацияШаг1.Видимость = Истина;
		Элементы.ДекорацияШаг2Заголовок.Заголовок = НСТр("ru='После загрузки мобильного приложения используйте этот QR-код для установки соединения'");
	Конецесли;
		
	Если Параметры.Свойство("Пользователь") Тогда
		Пользователь = Параметры.Пользователь;
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		ТекПользователь = Пользователи.ТекущийПользователь();
		Если ТекПользователь.Наименование= "<Не указан>" Тогда
			Пользователь = "";
		Иначе
			Пользователь = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	Сценарий = "Директор";
	СформироватьQR();
	
	//Элементы.ПереходВБольшойУНФ.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияQRAndroidНажатие(Элемент)
	
	АдресСтраницы = "https://play.google.com/store/apps/details?id=com.e1c.MobileSmallBusiness";
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКнопкаAndroidНажатие(Элемент)
	
	АдресСтраницы = "https://play.google.com/store/apps/details?id=com.e1c.SmallBusinessMobile";
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияQRiOSНажатие(Элемент)
	
	АдресСтраницы = "https://itunes.apple.com/us/app/id1459657913?l=ru&ls=1&mt=8";
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКнопкаiOSНажатие(Элемент)
	
	АдресСтраницы = "https://itunes.apple.com/ru/app/1s-unf/id590223043?mt=8";
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповестить("НастройкаМобильногоПриложенияГотово");
	
КонецПроцедуры

&НаКлиенте
Процедура Попробовать(Команда)
	
	Текст = НСтр("ru = 'В случае обратного перехода в мобильное приложение, данные, созданные в пробной версии, не сохранятся.
		|Продолжить?'");
	Результат = Неопределено;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПопробоватьПриСогласии", ЭтотОбъект), Текст, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПопробоватьПриСогласии(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		АктивацияВыполнена = АктивироватьПромоТарифСервер();
		
		Если АктивацияВыполнена Тогда
			ПопробоватьПриСогласииНаСервере();
			ОбновитьИнтерфейс();
			ОткрытьФорму("ОбщаяФорма.МобильныйКлиент", Новый Структура("ПереходИзМП20", Истина));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПопробоватьПриСогласииНаСервере()
	ПереходВБольшойУНФИзМобильногоПриложения20МПУНФ.ВыполнитьПереход();
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	
	Если Константы.ДатаОкончанияПробногоПериодаМПУНФ.Получить() <> '00010101000000' Тогда
		
		Элементы.Попробовать.Заголовок = НСтр("ru = 'Активировать'");
		Элементы.ДекорацияПереход.Заголовок = НСтр("ru = 'Мало возможностей мобильного приложения? Активируйте пробный период полной версии 1С:УНФ еще раз.'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Функция АктивироватьПромоТарифСервер()
	
	Возврат ПрограммныйИнтерфейсСервиса.ИспользоватьПромокод("sbm_to_sb");
	
КонецФункции

