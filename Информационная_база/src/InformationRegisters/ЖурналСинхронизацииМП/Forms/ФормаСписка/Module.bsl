
&НаКлиенте
Процедура АвтоматическоеОбновление(Команда)
	ПодключитьОбработчикОжидания("Подключаемый_АвтоматическоеОбновление", 1, Ложь);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АвтоматическоеОбновление()
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьАвтоматическоеОбновление(Команда)
	ОтключитьОбработчикОжидания("Подключаемый_АвтоматическоеОбновление");
КонецПроцедуры

