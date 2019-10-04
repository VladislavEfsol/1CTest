
&НаКлиенте
Процедура ДекорацияQRAndroidНажатие(Элемент)
	
	ПерейтиВGooglePlay();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКнопкаAndroidНажатие(Элемент)
	
	ПерейтиВGooglePlay();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияQRiOSНажатие(Элемент)
	
	ПерейтиВAppStore();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКнопкаiOSНажатие(Элемент)
	
	ПерейтиВAppStore();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВGooglePlay()
	
	АдресСтраницы = "https://play.google.com/store/apps/details?id=com.e1c.SmallBusiness";
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВAppStore()
	
	АдресСтраницы = "https://itunes.apple.com/us/app/1%D1%81-%D1%83%D0%BD%D1%84-%D0%B2-%D0%BE%D0%B1%D0%BB%D0%B0%D0%BA%D0%B5/id1440287699?l=ru&ls=1&mt=8";
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПереходИзМП20") И Параметры.ПереходИзМП20 Тогда
		Элементы.Группа1.Видимость = Ложь;
		Элементы.ГруппаПереходИзМП.Видимость = Истина;
	Иначе
		Элементы.Группа1.Видимость = Истина;
		Элементы.ГруппаПереходИзМП.Видимость = Ложь;
	КонецЕсли;
	
	//Если МобильноеПриложение20ВызовСервераМПУНФ.ВключенПробныйПериод() Тогда
	//	Элементы.ВернутьсяВМобильноеПриложение20.Видимость = Истина;
	//Иначе
	Элементы.ВернутьсяВМобильноеПриложение20.Видимость = Ложь;
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяВМобильноеПриложение20(Команда)
	
	Текст = НСтр("ru = 'При обратном переходе, данные, созданные в пробной версии, не перенесутся в мобильное приложение.
	|Продолжить?'");
	Результат = Неопределено;
	ПоказатьВопрос(Новый ОписаниеОповещения("ВернутьсяВМобильноеПриложение20ПриСогласии", ЭтотОбъект), Текст, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяВМобильноеПриложение20ПриСогласии(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ВключитьМобильный20ПриСогласииНаСервере();
		МассивПользователей = МобильноеПриложениеВызовСервера.ПолучитьМассивПользователей();
		МобильноеПриложениеВызовСервера.УстановитьМинимальныйИнтерфейс(МассивПользователей);
		МобильноеПриложениеВызовСервера.УстановитьСоставФормДляПользователей(МассивПользователей, Истина);
		ОбновитьИнтерфейс();
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВключитьМобильный20ПриСогласииНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ЭтоМобильноеПриложение20.Установить(Истина);
	Константы.ЭтоОбычноеПриложение.Установить(Ложь);
	Константы.ЭтоМобильноеПриложение.Установить(Ложь);
	Константы.ВключенПробныйПериодМПУНФ.Установить(Ложь);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры


