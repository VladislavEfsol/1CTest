
&НаКлиенте
Процедура Подключаемый_НастройкиСкрытияПДнПриИзменении(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗащитаПерсональныхДанных") Тогда
		МодульЗащитаПерсональныхДанныхКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗащитаПерсональныхДанныхКлиент");
		МодульЗащитаПерсональныхДанныхКлиент.НастройкиСкрытияПерсональныхДанныхПриИзменении(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры